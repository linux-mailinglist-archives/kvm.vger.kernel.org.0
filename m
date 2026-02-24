Return-Path: <kvm+bounces-71629-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EF7gKeLgnWnpSQQAu9opvQ
	(envelope-from <kvm+bounces-71629-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:33:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 06CD818A933
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32C5130CB13F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D453A9DA6;
	Tue, 24 Feb 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cP2SG1rY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8A3A961E
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771954311; cv=none; b=mQlwdY4F8E6LceQDmFZrq8kQW5fLoO5/RCrT53aM/54riAJBSQbeFzLVg5o9DKfDWuX9TmHwKsNyI6iVarXqUTn6i2+kbeqf2oWprIoRtDSS4SQv/7BUtIZGXfOsO8S7TV7Md0TpBrjKHwbDrm3bRM1Ij1d1ZxcOOjhq/6lcJyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771954311; c=relaxed/simple;
	bh=EwpXaeWzxU9JXsOZ/kU5orA5NKUcth5xtqHL2bq2ne4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qGgjfTFeTWyNwzyPSYWRhnrtZyiImHz8RgWXYgIkS/egOAD8zjovc/GrBKvj6h2YedfMevTtDri9QWnBcK999Yk976+X34AKC3BGiXzT2UjYpmp0r6cr3SdVAdyCpVL4Hg4+/lVy+YktCQJ90Km53oP05d4+dcmt/At/zubFph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cP2SG1rY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso3681885a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771954309; x=1772559109; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VuPOB7rG9LKyBkb7Y8YEmUtdQmZnS0ImLK7NP0qREno=;
        b=cP2SG1rYnlIJ9FwPxPr41Cli0MhPXtZu8lIAaqhdBc50mvj78bYK4IRJ4Qk/GcasRR
         7XzYJFBLWUKurXVHfz0frJvkBvuxKs/xdeq9EY0CLVLoGIsYF4Rr0Bq3UcUiVrinSGuQ
         l9Vc5S7dcrTevvUa0i8/Xgkc82nctnrJ6gBY+stp48l2q2cUzW3roeGnBXg0xMpk2WoF
         dI8O0mNT28ZrXEKe+lwvoyaFSmKuV0RkDCvQc7MgntKM/IK3/KZ6JQ/jMzIKV7jylhyH
         AtJ/uXR88jCtmBxiBDfXwPsCHdch/1wzMpzWHJTfjJxn5F32e+FDdPQIZpUGE3wK5iVo
         KozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954309; x=1772559109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VuPOB7rG9LKyBkb7Y8YEmUtdQmZnS0ImLK7NP0qREno=;
        b=sBUbKJwR5A6hKwJmCauGmPyL128ykjBl+1EKFk7s5f2inoYcN9jjfC6SfFY8HGYZVa
         Ph+68XGaXPzgPyiDfq8cpz3QLjP2U9IgJPZNXg7ep9CxjAjYB9s2kNhDWyln1YvbljIA
         9x4bSfXQXpBUFp5IcAHhHhq6k9/tjlyflhEG0wnfsuSuij5l6dY3O2S9kM5revLay6o5
         +an9jr0IW2Yt+E6Y57IdZnYwhpxcMSyyH+mQuBvCtVj8+26wn2xR3yZPg1qrZhKb++52
         DlzTuqi2jkx4MDRKInE3txlaWMHvPCdjT5QLMYTAX0nP+dxOfNKv9AFW6n35Vydswfak
         76jw==
X-Forwarded-Encrypted: i=1; AJvYcCXxnXzZzjANxLKCkuBoIQLz3i71TqlTbFVK+v06dhwTB+auAod5p4wjRRrG12rC19Sv1k4=@vger.kernel.org
X-Gm-Message-State: AOJu0YziQdcOVVN10OlrunVJTpB3QPyqN1XajBDxgLQDnmqJwipA6x+U
	bKKKNhaQjsbqBXT8jNsw72ZMhLjtwjh8e8XUGrg5Jx2Rt0eNKztiTCWTFxoI9IjRfsARynYFL0n
	zYqL2aw==
X-Received: from pjxx5.prod.google.com ([2002:a17:90b:58c5:b0:354:c506:5ac1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4e:b0:356:4c1f:98d4
 with SMTP id 98e67ed59e1d1-358ae8194ffmr10415719a91.13.1771954309148; Tue, 24
 Feb 2026 09:31:49 -0800 (PST)
Date: Tue, 24 Feb 2026 09:31:47 -0800
In-Reply-To: <20260224071822.369326-4-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-4-chengkev@google.com>
Message-ID: <aZ3gg2VsrWGKrX4l@google.com>
Subject: Re: [PATCH V2 3/4] KVM: VMX: Don't consult original exit
 qualification for nested EPT violation injection
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71629-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 06CD818A933
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Kevin Cheng wrote:
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 16 +++++++++++++++-
>  arch/x86/kvm/vmx/nested.c      |  3 ---
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f148c92b606ba..a084b5e50effc 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -386,8 +386,19 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  					     nested_access, &walker->fault);
>  
>  		if (unlikely(real_gpa == INVALID_GPA)) {
> +			/*
> +			 * Unconditionally set the NPF error_code bits and
> +			 * EPT exit_qualification bits for nested page
> +			 * faults.  The walker doesn't know whether L1 uses
> +			 * NPT or EPT, and each injection handler consumes
> +			 * only the field it cares about (error_code for
> +			 * NPF, exit_qualification for EPT violations), so
> +			 * setting both is harmless.
> +			 */
>  #if PTTYPE != PTTYPE_EPT
>  			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
> +			walker->fault.exit_qualification |=
> +				EPT_VIOLATION_GVA_IS_VALID;

This looks all kinds of wrong.  Shouldn't it be?

#if PTTYPE == PTTYPE_EPT
			walker->fault.exit_qualification |= EPT_VIOLATION_GVA_IS_VALID;
#else
			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
#endif

Ooooh, right, never mind, this is the case where KVM detects a fault on the
L2 GPA => L1 GPA translation when walking L2 GVA=>GPA.

This is very counter-intuitive, and unconditionally setting both is rather ugly.
To address both, what if we peek at the guest_mmu to determine whether the fault
is EPT vs. NPT?  E.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3911ac9bddfd..db43560ba6f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5263,6 +5263,9 @@ static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
        return false;
 }
 
+static bool kvm_nested_fault_is_ept(struct kvm_vcpu *vcpu,
+                                   struct x86_exception *exception);
+
 #define PTTYPE_EPT 18 /* arbitrary */
 #define PTTYPE PTTYPE_EPT
 #include "paging_tmpl.h"
@@ -5276,6 +5279,13 @@ static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 #include "paging_tmpl.h"
 #undef PTTYPE
 
+static bool kvm_nested_fault_is_ept(struct kvm_vcpu *vcpu,
+                                   struct x86_exception *exception)
+{
+       WARN_ON_ONCE(!exception->nested_page_fault);
+       return vcpu->arch.guest_mmu.page_fault == ept_page_fault;
+}
+
 static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
                                    u64 pa_bits_rsvd, int level, bool nx,
                                    bool gbpages, bool pse, bool amd)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a084b5e50eff..0c9ce7a4815b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -387,19 +387,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
                if (unlikely(real_gpa == INVALID_GPA)) {
                        /*
-                        * Unconditionally set the NPF error_code bits and
-                        * EPT exit_qualification bits for nested page
-                        * faults.  The walker doesn't know whether L1 uses
-                        * NPT or EPT, and each injection handler consumes
-                        * only the field it cares about (error_code for
-                        * NPF, exit_qualification for EPT violations), so
-                        * setting both is harmless.
+                        * Set EPT Violation flags even if the fault is an
+                        * EPT Misconfig, fault.exit_qualification is ignored
+                        * for EPT Misconfigs.
                         */
-#if PTTYPE != PTTYPE_EPT
-                       walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
-                       walker->fault.exit_qualification |=
-                               EPT_VIOLATION_GVA_IS_VALID;
-#endif
+                       if (kvm_nested_fault_is_ept(vcpu, &walker->fault))
+                               walker->fault.exit_qualification |= EPT_VIOLATION_GVA_IS_VALID;
+                       else
+                               walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
                        return 0;
                }
 
@@ -458,12 +453,11 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
        real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
        if (real_gpa == INVALID_GPA) {
-#if PTTYPE != PTTYPE_EPT
-               walker->fault.error_code |= PFERR_GUEST_FINAL_MASK;
-               walker->fault.exit_qualification |=
-                       EPT_VIOLATION_GVA_IS_VALID |
-                       EPT_VIOLATION_GVA_TRANSLATED;
-#endif
+               if (kvm_nested_fault_is_ept(vcpu, &walker->fault))
+                       walker->fault.exit_qualification |= EPT_VIOLATION_GVA_IS_VALID |
+                                                           EPT_VIOLATION_GVA_TRANSLATED;
+               else
+                       walker->fault.error_code |= PFERR_GUEST_FINAL_MASK;
                return 0;
        }
 
>  #endif
>  			return 0;
>  		}
> @@ -449,6 +460,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	if (real_gpa == INVALID_GPA) {
>  #if PTTYPE != PTTYPE_EPT
>  		walker->fault.error_code |= PFERR_GUEST_FINAL_MASK;
> +		walker->fault.exit_qualification |=
> +			EPT_VIOLATION_GVA_IS_VALID |
> +			EPT_VIOLATION_GVA_TRANSLATED;
>  #endif
>  		return 0;
>  	}
> @@ -496,7 +510,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	 * [2:0] - Derive from the access bits. The exit_qualification might be
>  	 *         out of date if it is serving an EPT misconfiguration.
>  	 * [5:3] - Calculated by the page walk of the guest EPT page tables
> -	 * [7:8] - Derived from [7:8] of real exit_qualification
> +	 * [7:8] - Set at the kvm_translate_gpa() call sites above
>  	 *
>  	 * The other bits are set to 0.
>  	 */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 248635da67661..6a167b1d51595 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -444,9 +444,6 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
>  			exit_qualification = 0;
>  		} else {
>  			exit_qualification = fault->exit_qualification;
> -			exit_qualification |= vmx_get_exit_qual(vcpu) &
> -					      (EPT_VIOLATION_GVA_IS_VALID |
> -					       EPT_VIOLATION_GVA_TRANSLATED);

Hmm, this isn't quite correct.  If KVM injects an EPT Violation (or a #NPF) when
handling an EPT Violation (or #NPF) from L2, then KVM _should_ follow hardware.

Aha!  I think the easiest way to deal with that is to flag nested page faults
that were the result of walking L1's TDP when handling an L2 TDP page fault, and
then let vendor code extract the fault information out of hardaware.

Alternatively, we could plumb in VMX's EPT_VIOLATION_GVA_IS_VALID as a synthetic
error code, but I think that be harder to follow overall, especially for VMX.

@@ -799,8 +793,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
         * The page is not mapped by the guest.  Let the guest handle it.
         */
        if (!r) {
-               if (!fault->prefetch)
+               if (!fault->prefetch) {
+                       walker.fault.hardware_nested_page_fault = walker.fault.nested_page_fault;
                        kvm_inject_emulated_page_fault(vcpu, &walker.fault);
+               }
 
                return RET_PF_RETRY;
        }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6a167b1d5159..9e7d541d256b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -443,8 +443,13 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
                        vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
                        exit_qualification = 0;
                } else {
-                       exit_qualification = fault->exit_qualification;
                        vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
+
+                       exit_qualification = fault->exit_qualification;
+                       if (fault->hardware_nested_page_fault)
+                               exit_qualification |= vmx_get_exit_qual(vcpu) &
+                                                     (EPT_VIOLATION_GVA_IS_VALID |
+                                                      EPT_VIOLATION_GVA_TRANSLATED);
                }
 
                /*




>  			vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
>  		}
>  
> -- 
> 2.53.0.414.gf7e9f6c205-goog
> 

