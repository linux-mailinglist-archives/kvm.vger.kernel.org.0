Return-Path: <kvm+bounces-59054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4A4BAADE5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 03:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FCDA17BB27
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 01:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F99A1DE8BF;
	Tue, 30 Sep 2025 01:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FlquDi/7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A241D198E91;
	Tue, 30 Sep 2025 01:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759195339; cv=none; b=k/ZnxIUqRkLJ8sRCbV8wwMWb040aup/nXMxa9nsdJIQwjPQKesaYN8Ww1572t27Jsv1gh1JobBl7eCkyk5qrs3oSg/JVTQypivnrDavyBwy5q3sXxKmT8doYY5N4m/RhSjUas4k01O4xXpEvp47MsAUb7SF6IGyDUAAKiKnLaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759195339; c=relaxed/simple;
	bh=jSNCKRd4vCmEaI/9dY/Zk/juHL5IoJEHFIhsjwnA9aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rf25GNIiQ2ox1dt3uszTrvZBTonfnIsfYJOfDEHKGuRiWX7yBJSB8M38TSsElm9h37Y5swLAufV0GoUGSyvCYvnXvtKfUaqhe7NCK/8Ktr9ONLt5QgNmiYUJUd3XFgjUrI46EVqpkNbeFohn6cbej96Rh2tk2axUokrPZsFTyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FlquDi/7; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759195337; x=1790731337;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jSNCKRd4vCmEaI/9dY/Zk/juHL5IoJEHFIhsjwnA9aw=;
  b=FlquDi/7fZECdl+SfQaTYcsErod3JKb6v4L8Y+RJ2hxWHFM7cjHu1v7A
   AGKlAFIUWz3Ekr5yjAnbPskuXreLD+ly68mIj9ZepKjC3jo38Sio1gsSp
   vsyhliZ0jqPonbisCnFHivqzmaTI7wBLx+ClcOv5WcPLrwx+lrYmxDPsq
   gnHGbwKesTegE21V8q/puxELiWyFIKow9i2E4ERkfwyTT/OyTlQgvdy4B
   xsHm06INJ3MKrm+thKk63QzwxvDfvecSMge+szcT3qqHSjq9HB5DSPlGn
   DKD1uN4Ef+qnGKapZYnhC60CVps8xsu/u+S11z4+07T7WWp1loTMBrX+V
   g==;
X-CSE-ConnectionGUID: uP44+/rvQsuEkp3gJg/sOg==
X-CSE-MsgGUID: LHFIXr1HSAmoXP5DlBFc2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65263492"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65263492"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:22:17 -0700
X-CSE-ConnectionGUID: jayVdhaESH6OsVT17G6ocQ==
X-CSE-MsgGUID: BVcRoYNESEy5Bky5/wcXPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="177508119"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO desk) ([10.124.221.201])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:22:16 -0700
Date: Mon, 29 Sep 2025 18:22:10 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jack Wang <jinpu.wang@ionos.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, asit.k.mallick@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	tao1.zhang@intel.com
Subject: Re: [PATCH 0/2] VMSCAPE optimization for BHI variant
Message-ID: <20250930012102.iayl5otar3lim23i@desk>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>

On Mon, Sep 29, 2025 at 07:12:03AM +0200, Jack Wang wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> Hi Pawan,
> 
> Thx for the patches, I tested them on our Intel SierraForest machine with
> fio 4k randread/randwrite from guest, qemu virtio-blk, noticed nice
> performance improvement comparing to the default IBPB before exit to
> userspace mitigation. eg with default IBPB mitigation fio gets 204k IOPS,
> with this new Clear BHB before exit to userspace gets 323k IOPS.

Thanks for sharing the results.

I realized the LFENCE in the clear_bhb_long_loop() is not required. The
ring3 transition after the loop should be serializing anyways. Below patch
gets rid of that LFENCE. It should give some performance boost as well.

--- 8< ---
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH] x86/vmscape: Remove LFENCE from BHB clearing long loop

Long loop is used to clear the branch history when switching from a guest
to host userspace. The LFENCE barrier is not required as ring transition
itself acts as a barrier.

Move the prologue, LFENCE and epilogue out of __CLEAR_BHB_LOOP macro to
allow skipping the LFENCE in the long loop variant. Rename the long loop
function to clear_bhb_long_loop_no_barrier() to reflect the change.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S            | 32 +++++++++++++++++-----------
 arch/x86/include/asm/entry-common.h  |  2 +-
 arch/x86/include/asm/nospec-branch.h |  4 ++--
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index f5f62af080d8..bb456a3c652e 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1525,10 +1525,6 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * Target Selection, rather than taking the slowpath via its_return_thunk.
  */
 .macro	__CLEAR_BHB_LOOP outer_loop_count:req, inner_loop_count:req
-	ANNOTATE_NOENDBR
-	push	%rbp
-	mov	%rsp, %rbp
-
 	movl	$\outer_loop_count, %ecx
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
@@ -1560,10 +1556,7 @@ SYM_CODE_END(rewind_stack_and_make_dead)
 	jnz	1b
 .Lret2_\@:
 	RET
-5:	lfence
-
-	pop	%rbp
-	RET
+5:
 .endm
 
 /*
@@ -1573,7 +1566,15 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * setting BHI_DIS_S for the guests.
  */
 SYM_FUNC_START(clear_bhb_loop)
+	ANNOTATE_NOENDBR
+	push	%rbp
+	mov	%rsp, %rbp
+
 	__CLEAR_BHB_LOOP 5, 5
+
+	lfence
+	pop	%rbp
+	RET
 SYM_FUNC_END(clear_bhb_loop)
 EXPORT_SYMBOL_GPL(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
@@ -1584,8 +1585,15 @@ STACK_FRAME_NON_STANDARD(clear_bhb_loop)
  * protects the kernel, but to mitigate the guest influence on the host
  * userspace either IBPB or this sequence should be used. See VMSCAPE bug.
  */
-SYM_FUNC_START(clear_bhb_long_loop)
+SYM_FUNC_START(clear_bhb_long_loop_no_barrier)
+	ANNOTATE_NOENDBR
+	push	%rbp
+	mov	%rsp, %rbp
+
 	__CLEAR_BHB_LOOP 12, 7
-SYM_FUNC_END(clear_bhb_long_loop)
-EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
-STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)
+
+	pop	%rbp
+	RET
+SYM_FUNC_END(clear_bhb_long_loop_no_barrier)
+EXPORT_SYMBOL_GPL(clear_bhb_long_loop_no_barrier)
+STACK_FRAME_NON_STANDARD(clear_bhb_long_loop_no_barrier)
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index b7b9af1b6413..c70454bdd0e3 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -98,7 +98,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
 			indirect_branch_prediction_barrier();
 		else if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
-			clear_bhb_long_loop();
+			clear_bhb_long_loop_no_barrier();
 
 		this_cpu_write(x86_pred_flush_pending, false);
 	}
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 32d52f32a5e7..151f5de1a430 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -388,9 +388,9 @@ extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
-extern void clear_bhb_long_loop(void);
+extern void clear_bhb_long_loop_no_barrier(void);
 #else
-static inline void clear_bhb_long_loop(void) {}
+static inline void clear_bhb_long_loop_no_barrier(void) {}
 #endif
 
 extern void (*x86_return_thunk)(void);

