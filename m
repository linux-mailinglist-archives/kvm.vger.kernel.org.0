Return-Path: <kvm+bounces-32506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C29F69D9552
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BCDD166C7B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BFE1CCB20;
	Tue, 26 Nov 2024 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQn2By8I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA312170A13;
	Tue, 26 Nov 2024 10:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616303; cv=none; b=RALlrE7l+MV9nkSo8OxQRzIoUcW+qY899ZL30X2+sywNa8kPUOMkIcq4j4LUQaHLtxIQ4lkxLrLtpSUp3tj8gOnAcrfiF+fTmwKRfw3WOjY5kvz/UZgcG2quA8kd2xAqEEnuBHAkQq69mS3Pl2Wdmr75TqhIOQz75c2aJDYZ7ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616303; c=relaxed/simple;
	bh=LqaYPy6K3NvYQVGafI0hODrTVtMrbpYcsb2dwanviVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1kk4X8fJ0Ekv4h5onrkA7g6OhzZ/wyG19+S25saeehSFZyUfjmX9h2yuV0y9YYLUpZU6FcpZQH0XmPll7nRBxYjQpK0LTsUHtbOuFUuUTDh/9jBC9P+ZGvX6C0yx2uxBTiVd5ManOAPWU8JH2W5jj22/qPYkYZtMGivqQXf3YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQn2By8I; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616302; x=1764152302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LqaYPy6K3NvYQVGafI0hODrTVtMrbpYcsb2dwanviVM=;
  b=dQn2By8IdvyYUsRm3W8RfDM/tsVZozFaJ1tW98phwD8HY9s9wdzz75NO
   Xz+rt/FsKVlzM5rL5A3bZnREghe0jquS7q2UvG7DfHuafKhLjGiOoWlM2
   mXmrjujmbXlbWgy+MtnPUPf8yiLJ6eTYETwgM/Y0S9nFHe0floHWVZbhq
   lXsjLXzLQSAKuxnEHrXdBviVEBQ3VgbVp9z3KDuYh7bGTRmp9NjVA+Mbt
   LgZVwleVGQarLZMK2ABIju4VXzsg5CmTPpxC4Uhbe/vvc8nd0R2pgdbbl
   LrwmK3JlyB0ffBnLFd30FcUUvbF38aI5PaTdOP367F6670cZhKK3ydefk
   g==;
X-CSE-ConnectionGUID: XU4GMfi1T4K+cGwR1VSpoQ==
X-CSE-MsgGUID: d4QUEzzwQTSLjIeFVlSBug==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32139857"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="32139857"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:21 -0800
X-CSE-ConnectionGUID: CIdb1ibPRJqnWOnPlaJWNg==
X-CSE-MsgGUID: nbP4SM/fRLemq/4ccyQEXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96631790"
Received: from spr.sh.intel.com ([10.239.53.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:17 -0800
From: Chao Gao <chao.gao@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v2 1/6] x86/fpu/xstate: Always preserve non-user xfeatures/flags in __state_perm
Date: Tue, 26 Nov 2024 18:17:05 +0800
Message-ID: <20241126101710.62492-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241126101710.62492-1-chao.gao@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

When granting userspace or a KVM guest access to an xfeature, preserve the
entity's existing supervisor and software-defined permissions as tracked
by __state_perm, i.e. use __state_perm to track *all* permissions even
though all supported supervisor xfeatures are granted to all FPUs and
FPU_GUEST_PERM_LOCKED disallows changing permissions.

Effectively clobbering supervisor permissions results in inconsistent
behavior, as xstate_get_group_perm() will report supervisor features for
process that do NOT request access to dynamic user xfeatures, whereas any
and all supervisor features will be absent from the set of permissions for
any process that is granted access to one or more dynamic xfeatures (which
right now means AMX).

The inconsistency isn't problematic because fpu_xstate_prctl() already
strips out everything except user xfeatures:

        case ARCH_GET_XCOMP_PERM:
                /*
                 * Lockless snapshot as it can also change right after the
                 * dropping the lock.
                 */
                permitted = xstate_get_host_group_perm();
                permitted &= XFEATURE_MASK_USER_SUPPORTED;
                return put_user(permitted, uptr);

        case ARCH_GET_XCOMP_GUEST_PERM:
                permitted = xstate_get_guest_group_perm();
                permitted &= XFEATURE_MASK_USER_SUPPORTED;
                return put_user(permitted, uptr);

and similarly KVM doesn't apply the __state_perm to supervisor states
(kvm_get_filtered_xcr0() incorporates xstate_get_guest_group_perm()):

        case 0xd: {
                u64 permitted_xcr0 = kvm_get_filtered_xcr0();
                u64 permitted_xss = kvm_caps.supported_xss;

But if KVM in particular were to ever change, dropping supervisor
permissions would result in subtle bugs in KVM's reporting of supported
CPUID settings.  And the above behavior also means that having supervisor
xfeatures in __state_perm is correctly handled by all users.

Dropping supervisor permissions also creates another landmine for KVM.  If
more dynamic user xfeatures are ever added, requesting access to multiple
xfeatures in separate ARCH_REQ_XCOMP_GUEST_PERM calls will result in the
second invocation of __xstate_request_perm() computing the wrong ksize, as
as the mask passed to xstate_calculate_size() would not contain *any*
supervisor features.

Commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE
permissions") fudged around the size issue for userspace FPUs, but for
reasons unknown skipped guest FPUs.  Lack of a fix for KVM "works" only
because KVM doesn't yet support virtualizing features that have supervisor
xfeatures, i.e. as of today, KVM guest FPUs will never need the relevant
xfeatures.

Simply extending the hack-a-fix for guests would temporarily solve the
ksize issue, but wouldn't address the inconsistency issue and would leave
another lurking pitfall for KVM.  KVM support for virtualizing CET will
likely add CET_KERNEL as a guest-only xfeature, i.e. CET_KERNEL will not
be set in xfeatures_mask_supervisor() and would again be dropped when
granting access to dynamic xfeatures.

Note, the existing clobbering behavior is rather subtle.  The @permitted
parameter to __xstate_request_perm() comes from:

	permitted = xstate_get_group_perm(guest);

which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm,
where __state_perm is initialized to:

        fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;

and copied to the guest side of things:

	/* Same defaults for guests */
	fpu->guest_perm = fpu->perm;

fpu_kernel_cfg.default_features contains everything except the dynamic
xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:

        fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
        fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;

When __xstate_request_perm() restricts the local "mask" variable to
compute the user state size:

	mask &= XFEATURE_MASK_USER_SUPPORTED;
	usize = xstate_calculate_size(mask, false);

it subtly overwrites the target __state_perm with "mask" containing only
user xfeatures:

	perm = guest ? &fpu->guest_perm : &fpu->perm;
	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
	WRITE_ONCE(perm->__state_perm, mask);

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org
Link: https://lore.kernel.org/all/ZTqgzZl-reO1m01I@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 22abb5ee0cf2..414fed7eb278 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1622,16 +1622,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 	if ((permitted & requested) == requested)
 		return 0;
 
-	/* Calculate the resulting kernel state size */
+	/*
+	 * Calculate the resulting kernel state size.  Note, @permitted also
+	 * contains supervisor xfeatures even though supervisor are always
+	 * permitted for kernel and guest FPUs, and never permitted for user
+	 * FPUs.
+	 */
 	mask = permitted | requested;
-	/* Take supervisor states into account on the host */
-	if (!guest)
-		mask |= xfeatures_mask_supervisor();
 	ksize = xstate_calculate_size(mask, compacted);
 
-	/* Calculate the resulting user state size */
-	mask &= XFEATURE_MASK_USER_SUPPORTED;
-	usize = xstate_calculate_size(mask, false);
+	/*
+	 * Calculate the resulting user state size.  Take care not to clobber
+	 * the supervisor xfeatures in the new mask!
+	 */
+	usize = xstate_calculate_size(mask & XFEATURE_MASK_USER_SUPPORTED, false);
 
 	if (!guest) {
 		ret = validate_sigaltstack(usize);
-- 
2.46.1


