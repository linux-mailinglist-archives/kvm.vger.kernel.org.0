Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82086D83F0
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjDEQnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDEQnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:43:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C4AE26B3;
        Wed,  5 Apr 2023 09:43:50 -0700 (PDT)
Received: from [192.168.2.41] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5CA6D210DEDB;
        Wed,  5 Apr 2023 09:43:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5CA6D210DEDB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680713029;
        bh=6UIH2vmF08rmY+8MR3XIm6gXvAVwqi0BtmTVVd5Yo2w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DHYRJ5HZpDoWTCjVjlbXHcBGwh7nVVESx+eihe+xoRrFwigR+UbQGwM3PDIflhNG6
         iLU1SkwB9Oq0vH6jY6PiEutdbdU2HMt9eS8wnnmv6vzecYVfx3LkXfqOrsGIDgEFAJ
         xW8LKtSdWGbq1WY3e6DmFzERtRG9RWi9LVpgDI/4=
Message-ID: <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
Date:   Wed, 5 Apr 2023 18:43:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com>
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZAd2MRNLw1JAXmOf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/2023 6:36 PM, Sean Christopherson wrote:
> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
> happens to get lucky and not run afoul of the underlying bugs.  The revert appears
> to be reasonably straightforward (see bottom).

Hi Sean,

I'm back, and I don't have good news. The fix for the missing hyperv TLB flushes has
landed in Linus' tree and I now had the chance to test things outside Azure, in WSL on my
AMD laptop.

There is some seriously weird interaction going on between TDP MMU and Hyper-V, with
or without enlightened TLB. My laptop has 16 vCPUs, so the WSL VM also has 16 vCPUs.
I have hardcoded the kernel to disable enlightened TLB (so we know that is not interfering).
I'm running a Flatcar Linux VM inside the WSL VM using legacy BIOS, a single CPU
and 4GB of RAM.

If I run with `kvm.tdp_mmu=0`, I can boot and shutdown my VM consistently in 20 seconds.

If I run with TDP MMU, the VM boot stalls for seconds at a time in various spots
(loading grub, decompressing kernel, during kernel boot), the boot output feels like
it's happening in slow motion. The fastest I see it finish the same cycle is 2 minutes,
I have also seen it take 4 minutes, sometimes even not finish at all. Same everything,
the only difference is the value of `kvm.tdp_mmu`.

So I would like to revisit disabling tdp_mmu on hyperv altogether for the time being but it
should probably be with the following condition:

  tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && !hypervisor_is_type(X86_HYPER_MS_HYPERV)

Do you have an environment where you would be able to reproduce this? A Windows server perhaps
or an AMD laptop?

Jeremi

> 
> And _if_ we want to hack-a-fix it, then I would strongly prefer a very isolated,
> obviously hacky fix, e.g.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 36e4561554ca..a9ba4ae14fda 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5779,8 +5779,13 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>         tdp_root_level = tdp_forced_root_level;
>         max_tdp_level = tdp_max_root_level;
>  
> +       /*
> +        * FIXME: Remove the enlightened TLB restriction when KVM properly
> +        * handles TLB flushes for said enlightenment.
> +        */.
>  #ifdef CONFIG_X86_64
> -       tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
> +       tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled &&
> +                         !(ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB);
>  #endif
>         /*
>          * max_huge_page_level reflects KVM's MMU capabilities irrespective
> 
> 
