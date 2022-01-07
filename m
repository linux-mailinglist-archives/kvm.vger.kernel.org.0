Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6069487C99
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiAGS4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:56:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232106AbiAGSzb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/QuMP3yA23C6Iy1BoIHPFMqDtOIGaqLBVqqmF67NIU=;
        b=gES2gu1F/RB6Ki/+Rc60vt6fFp+JekK5ap7yE5RPdWYuR9bMxvPp8aUBFJQ1re8NCjcJLB
        TuuPnYBLrOPLUp89gdcbvn8VDhEWUoTF7Bg1PjDA4R5uzV+28+KaKpS/tFEVvK2mKFdj59
        y9uU3kLX3ynunMhrw9FAucV3APb6p5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-FXKseLOHNrC8wlPL6G_PsQ-1; Fri, 07 Jan 2022 13:55:27 -0500
X-MC-Unique: FXKseLOHNrC8wlPL6G_PsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7F6B18C9F41;
        Fri,  7 Jan 2022 18:55:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D432838FF;
        Fri,  7 Jan 2022 18:55:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 09/21] x86/fpu: Provide fpu_update_guest_xfd() for IA32_XFD emulation
Date:   Fri,  7 Jan 2022 13:55:00 -0500
Message-Id: <20220107185512.25321-10-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Guest XFD can be updated either in the emulation path or in the
restore path.

Provide a wrapper to update guest_fpu::fpstate::xfd. If the guest
fpstate is currently in-use, also update the per-cpu xfd cache and
the actual MSR.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-10-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h |  6 ++++++
 arch/x86/kernel/fpu/core.c     | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 1ed2a247a84e..e4d10155290b 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -140,6 +140,12 @@ extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
 extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
 
+#ifdef CONFIG_X86_64
+extern void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd);
+#else
+static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) { }
+#endif
+
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 64b2ee39bece..271fd5bc043b 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -283,6 +283,18 @@ int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures)
 }
 EXPORT_SYMBOL_GPL(fpu_enable_guest_xfd_features);
 
+#ifdef CONFIG_X86_64
+void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
+{
+	fpregs_lock();
+	guest_fpu->fpstate->xfd = xfd;
+	if (guest_fpu->fpstate->in_use)
+		xfd_update_state(guest_fpu->fpstate);
+	fpregs_unlock();
+}
+EXPORT_SYMBOL_GPL(fpu_update_guest_xfd);
+#endif /* CONFIG_X86_64 */
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
 	struct fpstate *guest_fps = guest_fpu->fpstate;
-- 
2.31.1


