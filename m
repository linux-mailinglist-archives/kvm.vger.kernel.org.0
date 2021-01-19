Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5192FC467
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 00:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbhASXGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 18:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbhASXG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 18:06:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA7EC061757
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 15:05:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e9so7259973plh.3
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 15:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bfrivxDJ5IXNieKCyR76rcGnHFi5zLCwb69Y836UObY=;
        b=Qq6rURNfQIDvJQfrDgDCoP6ZSXzf8oJZSovIkWQnNZct9pbmQWO1CjiUK+Wb9qzLK5
         Pezs/oF+1EDLzriJauP73LvWAmaIUPEUXV+ay4CcvpLZZ14tI8wbMKPaDS8JmLiRrQqp
         5qrUo65vHO7Uo+vA0aZPqaqLxf7P5vDmLMXvE7963Jg5udOupoKxBFQ/WhwfOaxEs11T
         iczY02gnfAc9Vud89U10br8OBJ3rA6VQNY0+jh99pTKqC/2tjstUa8SZDaImdDAoQCML
         /JXfi/1h9Qhm8G359/9V/NrJd5S8AeyE9v8w+pl8n5n6yY2fyjEx16i/hnrOYLMubRRQ
         ogig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bfrivxDJ5IXNieKCyR76rcGnHFi5zLCwb69Y836UObY=;
        b=SwgQAoEswd4OD+nQguXJNcfIh7VAItA0IBKsAs5ovqnxPSv+t5JTTH6QawW/vPLdUN
         /gugYIfupiNe7IQl3bJ733T9c5jysuxK82A++/aTSxNIaeL/yydc94KSowuf1gWd67Ct
         nX/MEFjrvhaOHPp7OPZLp8EkVNIX3JrBbKXzpT8gxRHuAsbycurmRGBkWGOQaG9ZuEA6
         RwO8EJ26viZrJstwMMF/tn7IpeVtPQq8kYrUw190+45SOANp4znXi+aqqEHJf83FT37J
         89Ne6yJeCarNUkKEmbg6oNy1FJ1hJbVshR6Q3FN5lviCnI7PUv5qnaIwPG18tWQwHPOt
         Bz1w==
X-Gm-Message-State: AOAM531SYOWbmLCPiXU+Fj0kN7oPTlcWF2Mfx/faqwK/eknJyTrx/DQ5
        JJH0LUepERU6/h0LOFvmfflgDbViPCHDKw==
X-Google-Smtp-Source: ABdhPJwn73cTwNfGaeh8KMsUHsgWN+wlEAJOdRBbFJ8ui1FdNrzjIy7EB3pDlr88gs19wy8aJ7G1tg==
X-Received: by 2002:a17:90a:8597:: with SMTP id m23mr2084095pjn.85.1611097547491;
        Tue, 19 Jan 2021 15:05:47 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 21sm159106pfx.84.2021.01.19.15.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:05:46 -0800 (PST)
Date:   Tue, 19 Jan 2021 15:05:40 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/7] KVM: x86: hyper-v: Always use vcpu_to_hv_vcpu()
 accessor to get to 'struct kvm_vcpu_hv'
Message-ID: <YAdlxE1LYz9NSdq8@google.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
 <20210113143721.328594-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113143721.328594-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Vitaly Kuznetsov wrote:
> As a preparation to allocating Hyper-V context dynamically, make it clear
> who's the user of the said context.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c  | 14 ++++++++------
>  arch/x86/kvm/hyperv.h  |  4 +++-
>  arch/x86/kvm/lapic.h   |  6 +++++-
>  arch/x86/kvm/vmx/vmx.c |  9 ++++++---
>  arch/x86/kvm/x86.c     |  4 +++-
>  5 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 922c69dcca4d..82f51346118f 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -190,7 +190,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
>  static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
>  {
>  	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);

Tangentially related...

What say you about aligning Hyper-V to VMX and SVM terminology?  E.g. I like
that VMX and VXM omit the "vcpu_" part and just call it "to_vmx/svm()", and the
VM-scoped variables have a "kvm_" prefix but the vCPU-scoped variables do not.
I'd probably even vote to do s/vcpu_to_pi_desc/to_pi_desc, but for whatever
reason that one doesn't annoy as much, probably because it's less pervasive than
the Hyper-V code.

It would also help if the code were more consistent with itself.  It's all a bit
haphazard when it comes to variable names, using helpers (or not), etc...

Long term, it might also be worthwhile to refactor the various flows to always
pass @vcpu instead of constantly converting to/from various objects.  Some of
the conversions appear to be necessary, e.g. for timer callbacks, but AFAICT a
lot of the shenanigans are entirely self-inflicted.

E.g. stimer_set_count() has one caller, which already has @vcpu, but
stimer_set_count() takes @stimer instead of @vcpu and then does several
conversions in as many lines.  None of the conversions are super expensive, but
it seems like every little helper in Hyper-V is doing multiple conversions to
and from kvm_vcpu, and half the generated code is getting the right pointer. :-)

>  	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNIC;
>  	hv_vcpu->exit.u.synic.msr = msr;
> @@ -294,7 +294,7 @@ static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
>  static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
>  {
>  	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>  
>  	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
>  	hv_vcpu->exit.u.syndbg.msr = msr;
> @@ -840,7 +840,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
>  
>  bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
>  {
> -	if (!(vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
> +
> +	if (!(hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
>  		return false;
>  	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
>  }
> @@ -1216,7 +1218,7 @@ static u64 current_task_runtime_100ns(void)
>  
>  static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>  {
> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>  
>  	switch (msr) {
>  	case HV_X64_MSR_VP_INDEX: {
> @@ -1379,7 +1381,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  			  bool host)
>  {
>  	u64 data = 0;
> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>  
>  	switch (msr) {
>  	case HV_X64_MSR_VP_INDEX:
> @@ -1494,7 +1496,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
>  			    u16 rep_cnt, bool ex)
>  {
>  	struct kvm *kvm = current_vcpu->kvm;

Ugh, "current_vcpu".  That's really, really nasty, as it's silently shadowing a
global per-cpu variable.  E.g. this compiles without so much as a warning:

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 922c69dcca4d..142fe9c12957 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1490,7 +1490,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
        return vcpu_bitmap;
 }

-static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
+static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa,
                            u16 rep_cnt, bool ex)
 {
        struct kvm *kvm = current_vcpu->kvm;
@@ -1592,7 +1592,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
        }
 }

-static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
+static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
                           bool ex, bool fast)
 {
        struct kvm *kvm = current_vcpu->kvm;

> -	struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(current_vcpu);
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 6d7def2b0aad..6300038e7a52 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -114,7 +114,9 @@ static inline struct kvm_vcpu *stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stimer)
>  
>  static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>  {
> -	return !bitmap_empty(vcpu->arch.hyperv.stimer_pending_bitmap,
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
> +
> +	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
>  			     HV_SYNIC_STIMER_COUNT);
>  }
>  
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 4fb86e3a9dd3..dec7356f2fcd 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -6,6 +6,8 @@
>  
>  #include <linux/kvm_host.h>
>  
> +#include "hyperv.h"
> +
>  #define KVM_APIC_INIT		0
>  #define KVM_APIC_SIPI		1
>  #define KVM_APIC_LVT_NUM	6
> @@ -127,7 +129,9 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
>  
>  static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
> +
> +	return hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;

A short to_hyperv() would be nice here, e.g.

	return to_hyperv(vcpu)->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;


LOL, actually, kvm_hv_vapic_assist_page_enabled() doesn't have any callers and
can be dropped.  Looks likes it's supplanted by kvm_hv_assist_page_enabled().

>  }
>  
>  int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
