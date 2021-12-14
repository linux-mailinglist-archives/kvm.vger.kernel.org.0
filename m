Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A6B473AE9
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 03:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbhLNCu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 21:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244700AbhLNCuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 21:50:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07696C061748;
        Mon, 13 Dec 2021 18:50:24 -0800 (PST)
Message-ID: <20211214024947.878061856@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639450223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=/QiR8LFIIghIdHuWPiT2Ph3EWm0DI3KfVwkZ9edwUik=;
        b=z4U6/hKo5Cx2hyMl0XZm6FByhOr0rSn5jEzghHwA+lIYB4hzXl7rb+5se6kG0xQza0hLvu
        Sn1taBF/DlpbhbOVCTjzDc7+rgHl4QUJHykLz8h/OcRBYkE88PFVsZI7MdoV17odhJe3r7
        kwHMvyw5PpFMD3sx4OJvmz6WeYH/OEvO0knZenWhJhxjkpkmFVrzv3uOn6GrVVbmBXROCo
        iIlv6fm22hpTg1NFz/CE0/tKcvg1i5VqXLq1W8Kvr2jBA3eywOY/toTfmG2pZLmG68dyEz
        Bk22BA+sH8WwA8QO+l5oVn+6G1k3UfKfxELbyvqHO8VAWT5hEr4vzi+LckiJ0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639450223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=/QiR8LFIIghIdHuWPiT2Ph3EWm0DI3KfVwkZ9edwUik=;
        b=mRUSRdZa2KYJ+7klW4efK6ryMNt4aIbxV/KR4Kd4Bjun1TxyD6EO/7Fr9fkDNQm0igD6j8
        Dyja/mqRGO+wVmCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [patch 2/6] x86/fpu: Prepare guest FPU for dynamically enabled FPU features
References: <20211214022825.563892248@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Dec 2021 03:50:22 +0100 (CET)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To support dynamically enabled FPU features for guests prepare the guest
pseudo FPU container to keep track of the currently enabled xfeatures and
the guest permissions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/types.h |   13 +++++++++++++
 arch/x86/kernel/fpu/core.c       |   26 +++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -505,6 +505,19 @@ struct fpu {
  */
 struct fpu_guest {
 	/*
+	 * @xfeatures:			xfeature bitmap of features which are
+	 *				currently enabled for the guest vCPU.
+	 */
+	u64				xfeatures;
+
+	/*
+	 * @perm:			xfeature bitmap of features which are
+	 *				permitted to be enabled for the guest
+	 *				vCPU.
+	 */
+	u64				perm;
+
+	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
 	struct fpstate			*fpstate;
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -201,6 +201,26 @@ void fpu_reset_from_exception_fixup(void
 #if IS_ENABLED(CONFIG_KVM)
 static void __fpstate_reset(struct fpstate *fpstate);
 
+static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
+{
+	struct fpu_state_perm *fpuperm;
+	u64 perm;
+
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return;
+
+	spin_lock_irq(&current->sighand->siglock);
+	fpuperm = &current->group_leader->thread.fpu.guest_perm;
+	perm = fpuperm->__state_perm;
+
+	/* First fpstate allocation locks down permissions. */
+	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
+
+	spin_unlock_irq(&current->sighand->siglock);
+
+	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
+}
+
 bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 {
 	struct fpstate *fpstate;
@@ -216,7 +236,11 @@ bool fpu_alloc_guest_fpstate(struct fpu_
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
 
-	gfpu->fpstate = fpstate;
+	gfpu->fpstate		= fpstate;
+	gfpu->xfeatures		= fpu_user_cfg.default_features;
+	gfpu->perm		= fpu_user_cfg.default_features;
+	fpu_init_guest_permissions(gfpu);
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(fpu_alloc_guest_fpstate);

