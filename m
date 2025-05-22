Return-Path: <kvm+bounces-47387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 078F6AC0F97
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50B2CA23BE0
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87964291151;
	Thu, 22 May 2025 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YipQcUm5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979B4290BD8;
	Thu, 22 May 2025 15:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926647; cv=none; b=S/Crv3xYLocfsk4l9CbTxBIW8Z97utlW4ZFRFNqSJI9o21+ZWcKWQnF/y9uk0XEfd9wbGGXYkzKACmN2R6o5tXQe4lJ5nEPX4JP7PIMZWQbPVx0K8juSIP5CP6fjXczqXAwx1Ie+cJ6RsJJGHDSMRvqsnRkhSKSvQGbUQ8hmps8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926647; c=relaxed/simple;
	bh=DsZIwVY6w9Iitp4Kq16ev6TnmK6/KC1aRYaoCSeutV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ds7DpCD7e3CRPoCkvwmu1kJlQqz6grScbX+n1c7wukY5BqjLJMUprdAsHxqDYlskkzzAvg3UqXIiPhhtbO5brSozNe1Fri+Y1kbt+OP/31h5R4T2f5SrkM/XLMZfH7u+JdPRYdQc79szZRwr/SNyXEsdWnJgNEVKqmdncNbF0qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YipQcUm5; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747926646; x=1779462646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DsZIwVY6w9Iitp4Kq16ev6TnmK6/KC1aRYaoCSeutV8=;
  b=YipQcUm5ZGhfKuM9K0zUgW4Eao6zuw+cwyBkfuDxQLjSnCBmzrzOAe6I
   3V8KYKcuef93aQh3AwYsTWaSObRoKfIJ2vPbGbCN/OmWHyiY41kfRBl23
   Pfc5eOPl6jzZuhpMUYQgAWN/FHL2CriPKagRe8XODL/ZafzX2/aQsTTxy
   51KpwwR/0/oa0UXzb84yHSoG6eQYhpqtfu8an2YJDr56C4kr+/wI7+9m3
   NIw0Nk7jU41Xp31FcDzw5tvylKaNEC2ennPYe3BnDuMQhIYojIC/Du+aD
   wHoxbpKw/OoNI1uhBn937WdYQVewsRJTCQRZIweDDU2Bvcsr08Inq1A4f
   Q==;
X-CSE-ConnectionGUID: 6KGJvhHhR32K725cTEs2wQ==
X-CSE-MsgGUID: txH+YLhTTCySgYa+tuWnKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61006708"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61006708"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:46 -0700
X-CSE-ConnectionGUID: TwK2XDVES4CIzdTGYYRcXQ==
X-CSE-MsgGUID: NgmlidEHThewoZ2eNpG+4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171627630"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:45 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: [PATCH v8 5/6] x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
Date: Thu, 22 May 2025 08:10:08 -0700
Message-ID: <20250522151031.426788-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250522151031.426788-1-chao.gao@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

In preparation for upcoming CET virtualization support, the CET supervisor
state will be added as a "guest-only" feature, since it is required only by
KVM (i.e., guest FPUs). Establish the infrastructure for "guest-only"
features.

Define a new XFEATURE_MASK_GUEST_SUPERVISOR mask to specify features that
are enabled by default in guest FPUs but not in host FPUs. Specifically,
for any bit in this set, permission is granted and XSAVE space is allocated
during vCPU creation. Non-guest FPUs cannot enable guest-only features,
even dynamically, and no XSAVE space will be allocated for them.

The mask is currently empty, but this will be changed by a subsequent
patch.

Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v8: rebased

v6: Collect reviews

v5: Explain in detail the reasoning behind the mask name choice below the
"---" separator line.

In previous versions, the mask was named "XFEATURE_MASK_SUPERVISOR_DYNAMIC"
Dave suggested this name [1], but he also noted, "I don't feel strongly about
it and I've said my piece. I won't NAK it one way or the other."

The term "dynamic" was initially preferred because it reflects the impact
on XSAVE buffers—some buffers accommodate dynamic features while others do
not. This naming allows for the introduction of dynamic features that are
not strictly "guest-only", offering flexibility beyond KVM.

However, using "dynamic" has led to confusion [2]. Chang pointed out that
permission granting and buffer allocation are actually static at VCPU
allocation, diverging from the model for user dynamic features. He also
questioned the rationale for introducing a kernel dynamic feature mask
while using it as a guest-only feature mask [3]. Moreover, Thomas remarked
that "the dynamic naming is really bad" [4]. Although his specific concerns
are unclear, we should be cautious about reinstating the "kernel dynamic
feature" naming.

Therefore, in v4, I renamed the mask to "XFEATURE_MASK_SUPERVISOR_GUEST"
and further refined it to "XFEATURE_MASK_GUEST_SUPERVISOR" in this v5.

[1]: https://lore.kernel.org/all/893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com/#t
[2]: https://lore.kernel.org/kvm/e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com/
[3]: https://lore.kernel.org/kvm/7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com/
[4]: https://lore.kernel.org/all/87sg1owmth.ffs@nanos.tec.linutronix.de/
---
 arch/x86/include/asm/fpu/types.h  | 9 +++++----
 arch/x86/include/asm/fpu/xstate.h | 6 +++++-
 arch/x86/kernel/fpu/xstate.c      | 7 +++++--
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index abd193a1a52e..54ba567258d6 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -592,8 +592,9 @@ struct fpu_state_config {
 	 * @default_size:
 	 *
 	 * The default size of the register state buffer. Includes all
-	 * supported features except independent managed features and
-	 * features which have to be requested by user space before usage.
+	 * supported features except independent managed features,
+	 * guest-only features and features which have to be requested by
+	 * user space before usage.
 	 */
 	unsigned int		default_size;
 
@@ -609,8 +610,8 @@ struct fpu_state_config {
 	 * @default_features:
 	 *
 	 * The default supported features bitmap. Does not include
-	 * independent managed features and features which have to
-	 * be requested by user space before usage.
+	 * independent managed features, guest-only features and features
+	 * which have to be requested by user space before usage.
 	 */
 	u64 default_features;
 	/*
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index b308a76afbb7..a3cd25453f94 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -46,9 +46,13 @@
 /* Features which are dynamically enabled for a process on request */
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
+/* Supervisor features which are enabled only in guest FPUs */
+#define XFEATURE_MASK_GUEST_SUPERVISOR	0
+
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
-					    XFEATURE_MASK_CET_USER)
+					    XFEATURE_MASK_CET_USER | \
+					    XFEATURE_MASK_GUEST_SUPERVISOR)
 
 /*
  * A supervisor state component may not always contain valuable information,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index f15be5c3f0cc..f5eb3e84c3dc 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -778,8 +778,11 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 
 static u64 __init host_default_mask(void)
 {
-	/* Exclude dynamic features, which require userspace opt-in. */
-	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
+	/*
+	 * Exclude dynamic features (require userspace opt-in) and features
+	 * that are supported only for KVM guests.
+	 */
+	return ~((u64)XFEATURE_MASK_USER_DYNAMIC | XFEATURE_MASK_GUEST_SUPERVISOR);
 }
 
 static u64 __init guest_default_mask(void)
-- 
2.47.1


