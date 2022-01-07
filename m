Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CAF487C91
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiAGSzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbiAGSz0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pLm3+v3CV9NsmlMw38Vs6LLjaRcIRw8vGpiUQp4f1Ec=;
        b=GP2lnw+YvTWpE+f3zpxwpOJDbpPDQHlsWN2Sg9ucTDUx9NWY+VGNC7Ub1CSMwWAxl70E0v
        P7bT8MFshR54rJkhE4jTapRdUvmhcZMcEWB1P3Q2j2CvW8a9+wxq4T8LHkuVpsvpHKxvj+
        yCevcIJ25ukL0KKtMVXDtsLSrjp+YF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-ZScsXPlePrW3BLC_5o65dg-1; Fri, 07 Jan 2022 13:55:21 -0500
X-MC-Unique: ZScsXPlePrW3BLC_5o65dg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2478764A7C;
        Fri,  7 Jan 2022 18:55:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E99C838FB;
        Fri,  7 Jan 2022 18:55:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 07/21] x86/fpu: Provide fpu_enable_guest_xfd_features() for KVM
Date:   Fri,  7 Jan 2022 13:54:58 -0500
Message-Id: <20220107185512.25321-8-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Provide a wrapper for expanding the guest fpstate buffer according
to requested xfeatures. KVM wants to call this wrapper to manage
any dynamic xstate used by the guest.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20220105123532.12586-8-yang.zhong@intel.com>
[Remove unnecessary 32-bit check. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h |  1 +
 arch/x86/kernel/fpu/core.c     | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index d8c222290e68..1ed2a247a84e 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -138,6 +138,7 @@ extern inline u64 xstate_get_guest_group_perm(void);
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
+extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a78bc547fc03..64b2ee39bece 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -261,6 +261,28 @@ void fpu_free_guest_fpstate(struct fpu_guest *gfpu)
 }
 EXPORT_SYMBOL_GPL(fpu_free_guest_fpstate);
 
+/*
+  * fpu_enable_guest_xfd_features - Check xfeatures against guest perm and enable
+  * @guest_fpu:         Pointer to the guest FPU container
+  * @xfeatures:         Features requested by guest CPUID
+  *
+  * Enable all dynamic xfeatures according to guest perm and requested CPUID.
+  *
+  * Return: 0 on success, error code otherwise
+  */
+int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures)
+{
+	lockdep_assert_preemption_enabled();
+
+	/* Nothing to do if all requested features are already enabled. */
+	xfeatures &= ~guest_fpu->xfeatures;
+	if (!xfeatures)
+		return 0;
+
+	return __xfd_enable_feature(xfeatures, guest_fpu);
+}
+EXPORT_SYMBOL_GPL(fpu_enable_guest_xfd_features);
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
 	struct fpstate *guest_fps = guest_fpu->fpstate;
-- 
2.31.1


