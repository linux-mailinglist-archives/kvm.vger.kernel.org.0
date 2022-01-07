Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653A7487C85
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiAGSzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232531AbiAGSze (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yg2VC5bEi5Y76PKYf5HzHLhPd+iAU8hKsJFvh3NCGdU=;
        b=LA1eDUEhWjdNq5AlcKe6Un2hk70KtE81Htal5Kx8/mGJ4EOuHcIDOj9RGFGEFCXtp6UEoq
        aOTwC5S399FubmgM7BLAgzSQVukFR8Ra2ixXjbv8K/taxE5xGWFaDKpfWZ9p+DM/yLTEyr
        88B9eK65vgFTbOXcXfycrg6g0LK5nRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-xy9eZSU7OsiyZOikP4jizg-1; Fri, 07 Jan 2022 13:55:30 -0500
X-MC-Unique: xy9eZSU7OsiyZOikP4jizg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D94FF81EE62;
        Fri,  7 Jan 2022 18:55:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EAAF8CB2B;
        Fri,  7 Jan 2022 18:55:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 17/21] x86/fpu: Add uabi_size to guest_fpu
Date:   Fri,  7 Jan 2022 13:55:08 -0500
Message-Id: <20220107185512.25321-18-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Userspace needs to inquire KVM about the buffer size to work
with the new KVM_SET_XSAVE and KVM_GET_XSAVE2. Add the size info
to guest_fpu for KVM to access.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-18-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/types.h | 5 +++++
 arch/x86/kernel/fpu/core.c       | 1 +
 arch/x86/kernel/fpu/xstate.c     | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 3795d0573773..eb7cd1139d97 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -522,6 +522,11 @@ struct fpu_guest {
 	 */
 	u64				xfd_err;
 
+	/*
+	 * @uabi_size:			Size required for save/restore
+	 */
+	unsigned int			uabi_size;
+
 	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 271fd5bc043b..de8e8c21f355 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -240,6 +240,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
 	gfpu->perm		= fpu_user_cfg.default_features;
+	gfpu->uabi_size		= fpu_user_cfg.default_size;
 	fpu_init_guest_permissions(gfpu);
 
 	return true;
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 0c0b2323cdec..10fe072f1c92 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1545,6 +1545,7 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
 		newfps->is_confidential = curfps->is_confidential;
 		newfps->in_use = curfps->in_use;
 		guest_fpu->xfeatures |= xfeatures;
+		guest_fpu->uabi_size = usize;
 	}
 
 	fpregs_lock();
-- 
2.31.1


