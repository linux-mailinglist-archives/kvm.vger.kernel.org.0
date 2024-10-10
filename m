Return-Path: <kvm+bounces-28468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39399998E61
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 19:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCE371F24719
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDABB19CD01;
	Thu, 10 Oct 2024 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TLZnBGHQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3962519ABCE
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728581615; cv=none; b=tbpgJrACv9A4aqaS28Ds1mMurrKNQh4R+oE/ChocLaKxk+bP37PMqBoFbYlQ8LR0YIcBuV+ByfusuWyNpltZukkm2cCH+QeN6D1PPgDsdRajytehIl8hF6+FvQpowmpVMQBt+rQEKanUpBQ8xHzLRSgwcDUMrLbaIIl/sWzKLa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728581615; c=relaxed/simple;
	bh=TpudZfWqkCcmd/bpH0tW3WTYx5/dRivAp7hmpZfeAjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SA5gHvzAh003ymus6G7qc/2CGvd0JMMR6V/V+P7llVLYqTUrJZqTk+OxT8n3TMUiDecf5gIWnjoODb8rS+OlO2ku34icthW92naYxYZLA72tsMjR1BHFntUPUAj0b6TEJzhoH4bhITdFYPRrDmjcggw1mE+8TwSQjx05UhM8Xiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TLZnBGHQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3231725c9so22381737b3.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 10:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728581612; x=1729186412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dR3nCa958EpxO2i96Lodv2h6igMH8RyyiSlJ4Ns8KDM=;
        b=TLZnBGHQFarJrcYN9uZQAqc91Sg0rJe3Lsxbi9FG7R+XNYgFV5GzOQWhYc0eitzuuh
         uj4/OdplqdyDCxz8Yzb3WIi774A49ilNrHf9qI40WCU9uO5QTcvHkeKRMW/Ozxx0dEg7
         vSqjESTqQ3T1NfsRD26yjEXjtnhe9cM88Zs/BecpDEix4nw1OjmpXzbFamHMol7U2yhI
         E/QONCpeqIiQ67NhvGA5MdrSM+GyzaqjtncoIE930kr8fnJtKivKFdTS09S5gWsVx6+P
         eOHMR5uSmTqsWxso6NyNbePk70cooyLoh3ZXSuWB2r0JJmfA7yhTiwlCf8PDF/OV3BVn
         /rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728581612; x=1729186412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dR3nCa958EpxO2i96Lodv2h6igMH8RyyiSlJ4Ns8KDM=;
        b=GivZVo0hgH673EfsCxWkV77TyIPBYHWu31OVO3TjvDleqb1vLlx4hJuYIA5txxl2Uw
         wvd5xgTudAKhAq2GgQaOvKORUXPF9TA9uDPITmAzyF8Hp8lgZCaKvXqNzHI4teJCxlFQ
         oLG5SZkfok3tnrGkNZv+A/hv7KyZsa0WNyILocC+Me/zjORauNb9n3rDYmJ5656T0z9x
         +fr1oj/J+gwodXSfdO5hH7cgyHr12hqE8ejJtpDJOrqYVYqFpIdn5GrmiE5UERhLXqOi
         GRb2+OvJxukO3B5M2sY0Tab9ne6FP7pvxmhax29dLjROsUTb3cHFwW1Iy7XFCbBFYZ5h
         Ryug==
X-Forwarded-Encrypted: i=1; AJvYcCXFntT/q6lSVo1eGcCXJ2m1b2elvkiGXY109m+V0OzLkeROdf6fTHgQcXaRnaXR+i8j1sg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/nxQmH76Fc7k6FRH/ZCwvgSINc9w4KiUNcrNMAMtwbmA0/n/C
	y1UBF9wr5FM3K/xhG/zHwDGFrA6yvv3XLuXSZcvqvraBP13ZB1q5MVxXRuE8CBB8mWizf//OIze
	4wg==
X-Google-Smtp-Source: AGHT+IFjm+4PQVWc3SaznJakoVPNQfQyTL82pMbEY3Z349o8Kxiop3E72eepwU47wk498j192blGL7Uj2p0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:a51:0:b0:e1a:6bf9:aa83 with SMTP id
 3f1490d57ef6-e28fe35009emr158291276.3.1728581612275; Thu, 10 Oct 2024
 10:33:32 -0700 (PDT)
Date: Thu, 10 Oct 2024 10:33:30 -0700
In-Reply-To: <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com> <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com> <ZwVG4bQ4g5Tm2jrt@google.com> <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com>
Message-ID: <ZwgP6nJ-MdDjKEiZ@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yuan Yao <yuan.yao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 10, 2024, Yan Zhao wrote:
> On Tue, Oct 08, 2024 at 07:51:13AM -0700, Sean Christopherson wrote:
> > On Wed, Sep 25, 2024, Yan Zhao wrote:
> > > On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
> > > > On Fri, Sep 13, 2024 at 10:23:00AM -0700, Sean Christopherson wrote:
> > > > > On Fri, Sep 13, 2024, Yan Zhao wrote:
> > > > > > This is a lock status report of TDX module for current SEAMCALL retry issue
> > > > > > based on code in TDX module public repo https://github.com/intel/tdx-module.git
> > > > > > branch TDX_1.5.05.
> > > > > > 
> > > > > > TL;DR:
> > > > > > - tdh_mem_track() can contend with tdh_vp_enter().
> > > > > > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> > > > > 
> > > > > The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> > > > > install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> > > > > a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> > > > > trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> > > > > whatever reason.
> > > > > 
> > > > > Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> > > > > what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> > > > > the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> > > > > hits the fault?
> > > > > 
> > > > > For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> > > > > desirable because in many cases, the winning task will install a valid mapping
> > > > > before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> > > > > instruction is re-executed.  In the happy case, that provides optimal performance
> > > > > as KVM doesn't introduce any extra delay/latency.
> > > > > 
> > > > > But for TDX, the math is different as the cost of a re-hitting a fault is much,
> > > > > much higher, especially in light of the zero-step issues.
> > > > > 
> > > > > E.g. if the TDP MMU returns a unique error code for the frozen case, and
> > > > > kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> > > > > then the TDX EPT violation path can safely retry locally, similar to the do-while
> > > > > loop in kvm_tdp_map_page().
> > > > > 
> > > > > The only part I don't like about this idea is having two "retry" return values,
> > > > > which creates the potential for bugs due to checking one but not the other.
> > > > > 
> > > > > Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> > > > > to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> > > > > option better even though the out-param is a bit gross, because it makes it more
> > > > > obvious that the "frozen_spte" is a special case that doesn't need attention for
> > > > > most paths.
> > > > Good idea.
> > > > But could we extend it a bit more to allow TDX's EPT violation handler to also
> > > > retry directly when tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY?
> > > I'm asking this because merely avoiding invoking tdh_vp_enter() in vCPUs seeing
> > > FROZEN_SPTE might not be enough to prevent zero step mitigation.
> > 
> > The goal isn't to make it completely impossible for zero-step to fire, it's to
> > make it so that _if_ zero-step fires, KVM can report the error to userspace without
> > having to retry, because KVM _knows_ that advancing past the zero-step isn't
> > something KVM can solve.
> > 
> >  : I'm not worried about any performance hit with zero-step, I'm worried about KVM
> >  : not being able to differentiate between a KVM bug and guest interference.  The
> >  : goal with a local retry is to make it so that KVM _never_ triggers zero-step,
> >  : unless there is a bug somewhere.  At that point, if zero-step fires, KVM can
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  : report the error to userspace instead of trying to suppress guest activity, and
> >  : potentially from other KVM tasks too.
> > 
> > In other words, for the selftest you crafted, KVM reporting an error to userspace
> > due to zero-step would be working as intended.  
> Hmm, but the selftest is an example to show that 6 continuous EPT violations on
> the same GPA could trigger zero-step.
> 
> For an extremely unlucky vCPU, is it still possible to fire zero step when
> nothing is wrong both in KVM and QEMU?
> e.g.
> 
> 1st: "fault->is_private != kvm_mem_is_private(kvm, fault->gfn)" is found.
> 2nd-6th: try_cmpxchg64() fails on each level SPTEs (5 levels in total)

Very technically, this shouldn't be possible.  The only way for there to be
contention on the leaf SPTE is if some other KVM task installed a SPTE, i.e. the
6th attempt should succeed, even if the faulting vCPU wasn't the one to create
the SPTE.

That said, a few thoughts:

1. Where did we end up on the idea of requiring userspace to pre-fault memory?

2. The zero-step logic really should have a slightly more conservative threshold.
   I have a hard time believing that e.g. 10 attempts would create a side channel,
   but 6 attempts is "fine".

3. This would be a good reason to implement a local retry in kvm_tdp_mmu_map().
   Yes, I'm being somewhat hypocritical since I'm so against retrying for the
   S-EPT case, but my objection to retrying for S-EPT is that it _should_ be easy
   for KVM to guarantee success.

E.g. for #3, the below (compile tested only) patch should make it impossible for
the S-EPT case to fail, as dirty logging isn't (yet) supported and mirror SPTEs
should never trigger A/D assists, i.e. retry should always succeed.

---
 arch/x86/kvm/mmu/tdp_mmu.c | 47 ++++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3b996c1fdaab..e47573a652a9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1097,6 +1097,18 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 				   struct kvm_mmu_page *sp, bool shared);
 
+static struct kvm_mmu_page *tdp_mmu_realloc_sp(struct kvm_vcpu *vcpu,
+					       struct kvm_mmu_page *sp)
+{
+	if (!sp)
+		return tdp_mmu_alloc_sp(vcpu);
+
+	memset(sp, 0, sizeof(*sp));
+	memset64(sp->spt, vcpu->arch.mmu_shadow_page_cache.init_value,
+		 PAGE_SIZE / sizeof(u64));
+	return sp;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1104,9 +1116,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm_mmu_page *sp = NULL;
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1116,8 +1128,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	rcu_read_lock();
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
-		int r;
-
+		/*
+		 * Somewhat arbitrarily allow two local retries, e.g. to play
+		 * nice with the extremely unlikely case that KVM encounters a
+		 * huge SPTE an Access-assist _and_ a subsequent Dirty-assist.
+		 * Retrying is inexpensive, but if KVM fails to install a SPTE
+		 * three times, then a fourth attempt is likely futile and it's
+		 * time to back off.
+		 */
+		int r, retry_locally = 2;
+again:
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
@@ -1140,7 +1160,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * The SPTE is either non-present or points to a huge page that
 		 * needs to be split.
 		 */
-		sp = tdp_mmu_alloc_sp(vcpu);
+		sp = tdp_mmu_realloc_sp(vcpu, sp);
 		tdp_mmu_init_child_sp(sp, &iter);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
@@ -1151,11 +1171,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
-		 * Force the guest to retry if installing an upper level SPTE
-		 * failed, e.g. because a different task modified the SPTE.
+		 * If installing an upper level SPTE failed, retry the walk
+		 * locally before forcing the guest to retry.  If the SPTE was
+		 * modified by a different task, odds are very good the new
+		 * SPTE is usable as-is.  And if the SPTE was modified by the
+		 * CPU, e.g. to set A/D bits, then unless KVM gets *extremely*
+		 * unlucky, the CMPXCHG should succeed the second time around.
 		 */
 		if (r) {
-			tdp_mmu_free_sp(sp);
+			if (retry_locally--)
+				goto again;
 			goto retry;
 		}
 
@@ -1166,6 +1191,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 				track_possible_nx_huge_page(kvm, sp);
 			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 		}
+		sp = NULL;
 	}
 
 	/*
@@ -1180,6 +1206,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 retry:
 	rcu_read_unlock();
+
+	/*
+	 * Free the previously allocated MMU page if KVM retried locally and
+	 * ended up not using said page.
+	 */
+	if (sp)
+		tdp_mmu_free_sp(sp);
 	return ret;
 }
 

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 

