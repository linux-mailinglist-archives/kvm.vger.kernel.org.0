Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04FA5577AB
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 12:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiFWKRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 06:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiFWKRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 06:17:33 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB93C49F9F;
        Thu, 23 Jun 2022 03:17:29 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id E114E20C63C9;
        Thu, 23 Jun 2022 03:17:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E114E20C63C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655979449;
        bh=ReoHMI5JhpilguE9X6PU0nYis/u6+UJ/Af/HK8AAjZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sHf/2Tlb4InhVSYT03UGIfr/kqdGxn++tPTa0f4Sc4REdV0O8T77inimwEka9HLEA
         W7aQ1A52rdYUEn9UeDxxQL4XKMzI+IyFcFyyBxJfDLF1+pD+n+JJUIkZ8gvxPBKKBY
         t6m6IF2Uj4t1fIF3vLOGGKLvSWINXVEUlnDCDCC4=
Date:   Thu, 23 Jun 2022 15:47:18 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <YrQ9rt61a8tPWWGO@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com>
 <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com>
 <87zgi5xh42.fsf@redhat.com>
 <YrMenI1mTbqA9MaR@anrayabh-desk>
 <87r13gyde8.fsf@redhat.com>
 <YrNBHFLzAgcsw19O@anrayabh-desk>
 <87k098y77x.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k098y77x.fsf@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 06:48:50PM +0200, Vitaly Kuznetsov wrote:
> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
> 
> > On Wed, Jun 22, 2022 at 04:35:27PM +0200, Vitaly Kuznetsov wrote:
> 
> ...
> 
> >> 
> >> I've tried to pick it up but it's actually much harder than I think. The
> >> patch has some minor issues ('&vmcs_config.nested' needs to be switched
> >> to '&vmcs_conf->nested' in nested_vmx_setup_ctls_msrs()), but the main
> >> problem is that the set of controls nested_vmx_setup_ctls_msrs() needs
> >> is NOT a subset of vmcs_config (setup_vmcs_config()). I was able to
> >> identify at least:
> 
> ...
> 
> I've jsut sent "[PATCH RFC v1 00/10] KVM: nVMX: Use vmcs_config for
> setting up nested VMX MSRs" which implements Sean's suggestion. Hope
> this is the way to go for mainline.
> 
> >
> > How about we do something simple like the patch below to start with?
> > This will easily apply to stable and we can continue improving upon
> > it with follow up patches on mainline.
> >
> 
> Personally, I'm not against this for @stable. Alternatively, in case the

I think it's a good intermediate fix for mainline too. It is easier to land
it in stable if it already exists in mainline. It can stay in mainline
until your series lands and replaces it with the vmcs_config approach.

What do you think?

> only observed issue is with TSC scaling, we can add support for it for
> KVM-on-Hyper-V but not for Hyper-V-on-KVM (a small subset of "[PATCH
> 00/11] KVM: VMX: Support TscScaling and EnclsExitingBitmap whith
> eVMCS"). I can prepare patches if needed.

Will it fit in stable's 100 line rule?

Thanks!

	- Anirudh.
