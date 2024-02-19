Return-Path: <kvm+bounces-9015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E03859D75
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D70B61C215A7
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2560E24A18;
	Mon, 19 Feb 2024 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jkWCW/Ug"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879B8210EC;
	Mon, 19 Feb 2024 07:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328868; cv=none; b=AyGnZOgb5TFBmBXe23mHoK5ZUmXg7h3yoVMxrjQ0KB2wTABh7Mj4FW5V8gPbvXUS+71Lb6+R4OL1/Ysvqoj1IoiGlBFsgouTAAZUK5uC4IsuLBP2VNBWnz4rOrwnUf8CW1Oi8Wx5M8GsbxUVx9NDGdZCr70118HF2M/AyY4tjs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328868; c=relaxed/simple;
	bh=j7/oTF9PaZHXhsGXMLIHaKH3qGq42otZGD7EVuO6kH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUw0CbkiCPx8kF8IJSjVjqjM0Zq/r9gpX22qMHR35MI6s9AjnQssbK+vy8sXgkvhgOyhBAtIbff3BxcE3DJKaNawjZgHBynaKPe+s3dD/MP6Q7meHmUK3jNMlO13+7ePr+pm+BQuLy/exaHq3GMvTCqyNqTTOAlZJazAZJ0bozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jkWCW/Ug; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328866; x=1739864866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j7/oTF9PaZHXhsGXMLIHaKH3qGq42otZGD7EVuO6kH4=;
  b=jkWCW/Ug9PmBRejg2WSwly//SWw32nH7p8AlMUEyq+hCFadHejwb6et+
   RO1RbCIoFJiNtiFArzbe30bR46u6tjR5/G325ZpLgTUlkaVtRmOONYoM9
   LGFHJ6ArQl70s3oCXbeBIafQyr4HdghCrG0ehAR/kaIcMhajp5Vmth+w9
   OoXbRJGEEn4V7eNRUURqi7LlN1smuaGO5iKhHK7vGvA0j8abY2DSKr701
   DNp+lqer+/GF9/iNeCL7aEG143TBikJByLantsl+cuVTXuQutgTzl6hzF
   XGHxyrWcAG/mgCacpNJJs0e1TVci3j+Zm6JBUx8IuK7Xv5d2KvxjeKyyf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535017"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535017"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966060"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966060"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 01/27] x86/fpu/xstate: Always preserve non-user xfeatures/flags in __state_perm
Date: Sun, 18 Feb 2024 23:47:07 -0800
Message-ID: <20240219074733.122080-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/fpu/xstate.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 117e74c44e75..07911532b108 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1601,16 +1601,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
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
2.43.0


