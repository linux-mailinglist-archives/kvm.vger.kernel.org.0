Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9486417BE8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfEHOqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:46:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:61895 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbfEHOpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:45:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP; 08 May 2019 07:45:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 08 May 2019 07:45:05 -0700
Date:   Wed, 8 May 2019 07:45:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jintack Lim <jintack@cs.columbia.edu>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2] KVM: nVMX: Disable intercept for *_BASE MSR in vmcs02
 when possible
Message-ID: <20190508144505.GB13834@linux.intel.com>
References: <1557158359-6865-1-git-send-email-jintack@cs.columbia.edu>
 <f6e474db-e40a-20cc-951e-2386a11a6ef8@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <f6e474db-e40a-20cc-951e-2386a11a6ef8@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2019 at 02:31:02PM +0200, Paolo Bonzini wrote:
> On 06/05/19 10:59, Jintack Lim wrote:
> > Even when neither L0 nor L1 configured to trap *_BASE MSR accesses from
> > its own VMs, the current KVM L0 always traps *_BASE MSR accesses from
> > L2.  Let's check if both L0 and L1 disabled trap for *_BASE MSR for its
> > VMs respectively, and let L2 access to*_BASE MSR without trap if that's
> > the case.
> > 
> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> > 
> > ---
> > 
> > Changes since v1:
> > - Added GS_BASE and KENREL_GS_BASE (Jim, Sean)
> > - Changed to allow reads as well as writes (Sean)
> > ---
> >  arch/x86/kvm/vmx/nested.c | 24 +++++++++++++++++++++++-
> >  1 file changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 0c601d0..d167bb6 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -537,6 +537,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >  	 */
> >  	bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
> >  	bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
> > +	bool fs_base = !msr_write_intercepted_l01(vcpu, MSR_FS_BASE);
> > +	bool gs_base = !msr_write_intercepted_l01(vcpu, MSR_GS_BASE);
> > +	bool kernel_gs_base = !msr_write_intercepted_l01(vcpu,
> > +							 MSR_KERNEL_GS_BASE);
> >  
> >  	/* Nothing to do if the MSR bitmap is not in use.  */
> >  	if (!cpu_has_vmx_msr_bitmap() ||
> > @@ -544,7 +548,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >  		return false;
> >  
> >  	if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
> > -	    !pred_cmd && !spec_ctrl)
> > +	    !pred_cmd && !spec_ctrl && !fs_base && !gs_base && !kernel_gs_base)
> >  		return false;
> >  
> >  	page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->msr_bitmap);
> > @@ -592,6 +596,24 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >  		}
> >  	}
> >  
> > +	if (fs_base)
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_FS_BASE,
> > +					MSR_TYPE_RW);
> > +
> > +	if (gs_base)
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_GS_BASE,
> > +					MSR_TYPE_RW);
> > +
> > +	if (kernel_gs_base)
> > +		nested_vmx_disable_intercept_for_msr(
> > +					msr_bitmap_l1, msr_bitmap_l0,
> > +					MSR_KERNEL_GS_BASE,
> > +					MSR_TYPE_RW);
> > +
> >  	if (spec_ctrl)
> >  		nested_vmx_disable_intercept_for_msr(
> >  					msr_bitmap_l1, msr_bitmap_l0,
> > 
> 
> Queued, thanks.  (It may take a couple days until I finish testing
> everything for the merge window, but it will be in 5.2).

Hold up, this patch is misleading and unoptimized.  KVM unconditionally
exposes the MSRs to L1, i.e. checking msr_write_intercepted_l01() is
unnecessary.  I missed this the first time through, I read it as checking
vmcs12.  I think the attached patch is what we want.

--liOOAslEiF7prFVr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-nVMX-Disable-intercept-for-FS-GS-base-MSRs-in-vm.patch"

From ef3d95da738eadaad71a7fb650a6846c3a35b884 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 8 May 2019 07:32:15 -0700
Subject: [PATCH] KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02
 when possible

If L1 is using an MSR bitmap, unconditionally merge the MSR bitmaps from
L0 and L1 for MSR_{KERNEL,}_{FS,GS}_BASE.  KVM unconditionally exposes
MSRs L1.  If KVM is also running in L1 then it's highly likely L1 is
also exposing the MSRs to L2, i.e. KVM doesn't need to intercept L2
accesses.

Based on code from Jintack Lim.

Cc: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 04b40a98f60b..f423c5593964 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -514,31 +514,11 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	unsigned long *msr_bitmap_l0 = to_vmx(vcpu)->nested.vmcs02.msr_bitmap;
 	struct kvm_host_map *map = &to_vmx(vcpu)->nested.msr_bitmap_map;
 
-	/*
-	 * pred_cmd & spec_ctrl are trying to verify two things:
-	 *
-	 * 1. L0 gave a permission to L1 to actually passthrough the MSR. This
-	 *    ensures that we do not accidentally generate an L02 MSR bitmap
-	 *    from the L12 MSR bitmap that is too permissive.
-	 * 2. That L1 or L2s have actually used the MSR. This avoids
-	 *    unnecessarily merging of the bitmap if the MSR is unused. This
-	 *    works properly because we only update the L01 MSR bitmap lazily.
-	 *    So even if L0 should pass L1 these MSRs, the L01 bitmap is only
-	 *    updated to reflect this when L1 (or its L2s) actually write to
-	 *    the MSR.
-	 */
-	bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
-	bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
-
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
 	    !nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
 		return false;
 
-	if (!nested_cpu_has_virt_x2apic_mode(vmcs12) &&
-	    !pred_cmd && !spec_ctrl)
-		return false;
-
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
 		return false;
 
@@ -583,13 +563,36 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (spec_ctrl)
+	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
+	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
+					     MSR_FS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
+					     MSR_GS_BASE, MSR_TYPE_RW);
+
+	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
+					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+
+	/*
+	 * Checking the L0->L1 bitmap is trying to verify two things:
+	 *
+	 * 1. L0 gave a permission to L1 to actually passthrough the MSR. This
+	 *    ensures that we do not accidentally generate an L02 MSR bitmap
+	 *    from the L12 MSR bitmap that is too permissive.
+	 * 2. That L1 or L2s have actually used the MSR. This avoids
+	 *    unnecessarily merging of the bitmap if the MSR is unused. This
+	 *    works properly because we only update the L01 MSR bitmap lazily.
+	 *    So even if L0 should pass L1 these MSRs, the L01 bitmap is only
+	 *    updated to reflect this when L1 (or its L2s) actually write to
+	 *    the MSR.
+	 */
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL))
 		nested_vmx_disable_intercept_for_msr(
 					msr_bitmap_l1, msr_bitmap_l0,
 					MSR_IA32_SPEC_CTRL,
 					MSR_TYPE_R | MSR_TYPE_W);
 
-	if (pred_cmd)
+	if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD))
 		nested_vmx_disable_intercept_for_msr(
 					msr_bitmap_l1, msr_bitmap_l0,
 					MSR_IA32_PRED_CMD,
-- 
2.21.0


--liOOAslEiF7prFVr--
