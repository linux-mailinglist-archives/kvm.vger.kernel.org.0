Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33675487C79
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiAGSzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229763AbiAGSzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/rfn+RuolTeMpS9Bczr/u6Wc8qLb2nR5Cu6H35D8xo=;
        b=R6yNzLhftXYNhgnrWGB51uXIdR2kfEYA93q5gMx/9S5mU1SR+THQTio07Ic/JrvjNhK+qP
        dnlYio3mmO0tQkU7R4FTaFZrBDEBY3wr56qQcxsDW9TolGNrFCtzPmlhnG6dio2SQ3Avjy
        KytTzMzrdl+LiNyR+kFqILhj2mfXbew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-frbE_pRkOQGLwSt9Nbk1pw-1; Fri, 07 Jan 2022 13:55:20 -0500
X-MC-Unique: frbE_pRkOQGLwSt9Nbk1pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8281581EE60;
        Fri,  7 Jan 2022 18:55:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB421838F0;
        Fri,  7 Jan 2022 18:55:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 05/21] x86/fpu: Make XFD initialization in __fpstate_reset() a function argument
Date:   Fri,  7 Jan 2022 13:54:56 -0500
Message-Id: <20220107185512.25321-6-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

vCPU threads are different from native tasks regarding to the initial XFD
value. While all native tasks follow a fixed value (init_fpstate::xfd)
established by the FPU core at boot, vCPU threads need to obey the reset
value (i.e. ZERO) defined by the specification, to meet the expectation of
the guest.

Let the caller supply an argument and adjust the host and guest related
invocations accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-6-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index eddeeb4ed2f5..a78bc547fc03 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -199,7 +199,7 @@ void fpu_reset_from_exception_fixup(void)
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate);
+static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
 static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 {
@@ -231,7 +231,8 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	if (!fpstate)
 		return false;
 
-	__fpstate_reset(fpstate);
+	/* Leave xfd to 0 (the reset value defined by spec) */
+	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
@@ -454,21 +455,21 @@ void fpstate_init_user(struct fpstate *fpstate)
 		fpstate_init_fstate(fpstate);
 }
 
-static void __fpstate_reset(struct fpstate *fpstate)
+static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
 	/* Initialize sizes and feature masks */
 	fpstate->size		= fpu_kernel_cfg.default_size;
 	fpstate->user_size	= fpu_user_cfg.default_size;
 	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
-	fpstate->xfd		= init_fpstate.xfd;
+	fpstate->xfd		= xfd;
 }
 
 void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
 	fpu->fpstate = &fpu->__fpstate;
-	__fpstate_reset(fpu->fpstate);
+	__fpstate_reset(fpu->fpstate, init_fpstate.xfd);
 
 	/* Initialize the permission related info in fpu */
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
-- 
2.31.1


