Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12CB6065D5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 18:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJTQcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 12:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJTQcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 12:32:12 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52801BE40F
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:32:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fw14so20209685pjb.3
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=slOFSNaEr+U6Cr7V1Uoh1wGdXN6LiPEgjEv5S4y1jeQ=;
        b=c8j+GfrsviCsX9XL9TDsr5YAwohb1MLFXTkNdO0kP9Wi9GEYDkA4mzJ15S4jMlMhm7
         tYZC9FxHTpSseyIqarGsPCnPquz8Xezn6FQUpZgxu8cQ3i03f0/5CvgUsRiksE4b7r8a
         /fcYssPpZ7ahsPsINbgx0qZVqHEI+kcAG+GcUbcDwMqR73KpV74lpxJOzz2HEppgX/8C
         kPRAyVDsSB7T+zjE1G1Lc7ubWu6lR00OZGkxC85WqEfcK/uBjROZCOBtw9fnyXRr9M8b
         rA11M84/cI7X9IiIjEAGCMz72/aEbkfFYbJt8CJ6t0Feq5Kz1UYK6os1uvnjmk+FVJo1
         WzdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slOFSNaEr+U6Cr7V1Uoh1wGdXN6LiPEgjEv5S4y1jeQ=;
        b=WUp3RXjpfUE4wezKlsDQ1XKGKFXjuLPcjDJJOMG6Zeo/2XZsPe4mlFJYYXOTY7A6Zq
         U1297s1rLmT3mDsS5n/YVDU8idXRy51geBgYop4eU1nwcFQ72kCKkQMJLAyIROPmnI+W
         Axeqvy4eTBMbJZgbbkdr8HmOYzM3BiSb7lk47VLaMJsgS2Q5FwFyNCt7FhTxXpnRcXTB
         UmRlyonvB7v4WYoqM5Yl8R6W4ylWQL9SliG1tC0G2c3SBerYAIspcVZzM8RdSY5w6Ucy
         DCi6yFRuCoRsJeUYFMoubUjToOhepwXx4goKRJb3PyzIAeFdHKT1LBXv/A3xq8sEuYGj
         JkVw==
X-Gm-Message-State: ACrzQf1w8/+8HH6QqPharlW8kmNztv87lPm2BEk/O16SLF/iifkhAZkf
        PXKN9gZ+mqHUdD/TeRGt3pdpVA==
X-Google-Smtp-Source: AMsMyM5Zbu7iD5ZwCknsWhp+gKBYvNCTRUogjlWP74YeLvZH/osnrE3rnK426TXNkxucnolDL/PYIg==
X-Received: by 2002:a17:902:ab89:b0:17a:67c:b9e9 with SMTP id f9-20020a170902ab8900b0017a067cb9e9mr14640321plr.55.1666283527085;
        Thu, 20 Oct 2022 09:32:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090abc8600b0020669c8bd87sm21265pjr.36.2022.10.20.09.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 09:32:06 -0700 (PDT)
Date:   Thu, 20 Oct 2022 16:32:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Message-ID: <Y1F4AoeOhNFQnHnJ@google.com>
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
 <Y1FatU6Yf9n5pWB+@google.com>
 <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Xiaoyao Li wrote:
> On 10/20/2022 10:27 PM, Sean Christopherson wrote:
> > On Thu, Oct 20, 2022, Xiaoyao Li wrote:
> > > vcpu->arch.mcg_cap represents the value of MSR_IA32_MCG_CAP. It's
> > > set via ioctl(KVM_X86_SETUP_MCE) from userspace when exposing and
> > > configuring MCE to guest.
> > > 
> > > It's wrong to leave the default value as KVM_MAX_MCE_BANKS.
> > 
> > Why?  I agree it's an odd default, but the whole MCE API is odd.  Functionally,
> > I don't see anything that's broken by allowing the guest to access the MCx_CTL MSRs
> > by default.
> 
> Yes. Allowing the access doesn't cause any issue for a VM.
> 
> However, for the perspective of virtualization. It virtualizes a magic
> hardware that even CPUID.MCA/MCE is not advertised and MCE is not set up by
> userspace, guest is told there are 32 banks and all the banks can be
> accessed.

'0' isn't necessarily better though, e.g. if userspace parrots back KVM's "supported"
CPUID without invoking KVM_X86_SETUP_MCE, then it's equally odd that the guest will
see no supported MCE MSRS.  

Older versions of the SDM also state (or at least very strongly imply) that banks
0-3 are always available on P6.

Bank 0 is an especially weird case, as several of the MSRs are aliased to other
MSRs that predate the machine check architecture.

Anyways, if this were newly introduced code I'd be all for defaulting to '0', but
KVM has defaulted to KVM_MAX_MCE_BANKS since KVM_X86_SETUP_MCE was added way back
in 2009.  Unless there's a bug that's fixed by this, I'm inclined to keep the
current behavior even though it's weird, as hiding all MCE MSRs by default could
theoretically cause a regression, e.g. by triggering #GP on MSRs that an older
guest expects to always exist.

If we really want to clean up this code, I think the correct approach would be to
inject #GP on all relevant MSRs if CPUID.MCA==0, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..97fafd851d8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3260,6 +3260,9 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        u64 data = msr_info->data;
        u32 offset, last_msr;
 
+       if (!msr_info->host_initiated && !guest_cpuid_has(X86_FEATURE_MCA))
+               return 1;
+
        switch (msr) {
        case MSR_IA32_MCG_STATUS:
                vcpu->arch.mcg_status = data;
@@ -3891,6 +3894,14 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
        unsigned bank_num = mcg_cap & 0xff;
        u32 offset, last_msr;
 
+       if (msr == MSR_IA32_P5_MC_ADDR || msr == MSR_IA32_P5_MC_TYPE) {
+               *pdata = 0;
+               return 0;
+       }
+
+       if (!host && !guest_cpuid_has(X86_FEATURE_MCA))
+               return 1;
+
        switch (msr) {
        case MSR_IA32_P5_MC_ADDR:
        case MSR_IA32_P5_MC_TYPE:

Or alternatively, this should work too:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..e4a44d7af0a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3774,6 +3774,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        case MSR_IA32_MCG_STATUS:
        case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
        case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+               if (!msr_info->host_initiated &&
+                   !guest_cpuid_has(X86_FEATURE_MCA))
+                       return 1;
                return set_msr_mce(vcpu, msr_info);
 
        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
@@ -4142,13 +4145,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
                msr_info->data = vcpu->arch.msr_kvm_poll_control;
                break;
-       case MSR_IA32_P5_MC_ADDR:
-       case MSR_IA32_P5_MC_TYPE:
        case MSR_IA32_MCG_CAP:
        case MSR_IA32_MCG_CTL:
        case MSR_IA32_MCG_STATUS:
        case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
        case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+               if (!msr_info->host_initiated &&
+                   !guest_cpuid_has(X86_FEATURE_MCA))
+                       return 1;
+               fallthrough;
+       case MSR_IA32_P5_MC_ADDR:
+       case MSR_IA32_P5_MC_TYPE:
                return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
                                   msr_info->host_initiated);
        case MSR_IA32_XSS:

