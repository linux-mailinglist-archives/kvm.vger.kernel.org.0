Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DC556483A
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiGCPAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGCPAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 11:00:08 -0400
X-Greylist: delayed 911 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Jul 2022 08:00:06 PDT
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1069B635D
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 08:00:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1656859448; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=JsgKEhVJt7J2/9hSIaZwMOKftZZnsqUY+93KNqLXjhfzypZVNlDbXqnCT3VhsvBvpd1e4UdY2Dnak+7XLNzYeQjsYgeiw6BJ5mq5Ws22S1xXe+elsazBoPUC5nBKFIGC+1cazZPnjbopw593wt5jpjhyptFgC/ET7H7m6Ws3z3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1656859448; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Edog80gYaGd/Lw8yk6Ccfabu2w+M4QAbtCIhsIad0kY=; 
        b=HXGjvayjMoBfa3W1tXjkupNAghKoZm32vpmAUVjCiIBXzdnAbQbac/IC+goKuehXOf0I04vNoS94jvfPBFPfPp3ENTYysIDmzcCOIw21QDVddlXzfyNfBJl+52deanRb5mx5pcQ9XqXuvrSTU4Teee2Rd87UMVzqGkU/TFuv6lo=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1656859448;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Edog80gYaGd/Lw8yk6Ccfabu2w+M4QAbtCIhsIad0kY=;
        b=ZZe8E8CDeVBX4MSJmFO+SevdvjZywKwzqIFMsDIUdPTqkF1CcXJ7cILYxEOlznZh
        aMAmM6TsN8rE+QMx7C5ZhdSFgPOiNvs4Cl3mxeRma+6CZCIkfBfdJ8S7ZW5yWzbXCVE
        1iCBZfgFIPwWUbFws3x6hq/IBlkTc80l+p8DJn5s=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1656859437645771.6899342493789; Sun, 3 Jul 2022 20:13:57 +0530 (IST)
Date:   Sun, 03 Jul 2022 20:13:57 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Jue Wang" <juew@google.com>
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Xiaoyao Li" <xiaoyao.li@intel.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "David Matlack" <dmatlack@google.com>,
        "Tony Luck" <tony.luck@intel.com>, "kvm" <kvm@vger.kernel.org>,
        "Jiaqi Yan" <jiaqiyan@google.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <181c484aa33.6db8a9c7835812.4939150843849434525@siddh.me>
In-Reply-To: <20220701165045.4074471-2-juew@google.com>
References: <20220701165045.4074471-1-juew@google.com> <20220701165045.4074471-2-juew@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix access to vcpu->arch.apic when the
 irqchip is not in kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 01 Jul 2022 22:20:45 +0530  Jue Wang <juew@google.com> wrote
> Fix an access to vcpu->arch.apic when KVM_X86_SETUP_MCE is called
> without KVM_CREATE_IRQCHIP called or KVM_CAP_SPLIT_IRQCHIP is
> enabled.
> 
> Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4322a1365f74..d81020dd0fea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4820,8 +4820,9 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>          if (mcg_cap & MCG_CMCI_P)
>              vcpu->arch.mci_ctl2_banks[bank] = 0;
>      }
> -    vcpu->arch.apic->nr_lvt_entries =
> -        KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
> +    if (vcpu->arch.apic)
> +        vcpu->arch.apic->nr_lvt_entries =
> +            KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
>  
>      static_call(kvm_x86_setup_mce)(vcpu);
>  out:
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
>

Hello Jue,

There is a syzkaller bug regarding null ptr dereference which is caused by
vcpu->arch.apic being NULL, first reported on 27th June. You might want to
add it's reported-by line so that it can be marked as fixed.

Link: https://syzkaller.appspot.com/bug?id=10b9b238e087a6c9bef2cc48bee2375f58fabbfc

I was looking at this bug too and fixed it (i.e. reproducer won't crash)
using lapic_in_kernel(vcpu) as a condition instead of null ptr check on
vcpu->arch.apic, as it makes more sense to the code reader (the lapic is
not there since during kvm_arch_vcpu_create(), it isn't created due to
irqchip_in_kernel() check being false).

May I suggest that lapic_in_kernel(vcpu) be used instead of the null ptr
check?

Thanks,
Siddh
