Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB71617972B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgCDRvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:51:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49902 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388374AbgCDRuY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 12:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Thxl5wIjIKH5B5NXRPkB8aLAOUeG1jEuoKaVSkWq1z8=;
        b=XsKXAVLhISj+RiObLcLeKcLTjfbYbz+d7CYjtuGb1bntfmxSZQwkCMjPqOvq0xvDF2F/xo
        DlNTuoqA+GyheesFWpcK+Xfy1DMPMljnN8V4qkvXi2xZ28YyKA0NkxlxIeSuqw4Chl/Asc
        mg09M2UpbjzH/Xi66d8f/bf1viAcCNA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-kK_nM2OdNyWqv3bCKVUvqQ-1; Wed, 04 Mar 2020 12:50:21 -0500
X-MC-Unique: kK_nM2OdNyWqv3bCKVUvqQ-1
Received: by mail-qk1-f200.google.com with SMTP id e13so1826624qkm.23
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Thxl5wIjIKH5B5NXRPkB8aLAOUeG1jEuoKaVSkWq1z8=;
        b=Gc9MHpg2EzZUIRiOgfmPLijExJnFXX/CEhBYEynudwuDRp6MsYVE8Of5FCMtgr7gmX
         4fVDeUr29yqz4j0WRP3ZSljh0uWUYMvHl3mPBFaS86xg2w1Q6UrEvRLrg2at5HgN+crm
         SYrWPI3W4NzTFwSva1dcA95DRfX3X/6uUS2Y5aeHIUL2xoVNSp+cwrknOzvkNUH1883s
         6daaAzAIYQl5sCoeG+UG9opXx3uOJ7Rkz1OpucfffblwslUQ7uEvSMuQ1SJFSLqVaeT+
         AhziNNMGUbD2Uf6T2UwIxSH+1DCzzBPIMtOf4UnvWWpAlKrvU+LOwnYpxILVSDNqqyBS
         ekkw==
X-Gm-Message-State: ANhLgQ0+lTJSf/EhAPO45oybv48cH1H9+ACk2sZaRrv9kY2vS9B4/aJn
        gQ/t+8GNxzVdylz9ie7v0GNflDld9e1S10UzOxfXxQMjGzn/ojJh0gZvT5/4i8p3J0zBEi8Hx7H
        dZPJOzEc+3QSN
X-Received: by 2002:a37:a38b:: with SMTP id m133mr4006213qke.418.1583344221057;
        Wed, 04 Mar 2020 09:50:21 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuIqOLXAjTIseX/1wpACTFkqf8S628dua+pQStSDFhdsTp5TywiNGVu9CXRRDz1KWYlmxRKpg==
X-Received: by 2002:a37:a38b:: with SMTP id m133mr4006190qke.418.1583344220813;
        Wed, 04 Mar 2020 09:50:20 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id z8sm1805606qtq.11.2020.03.04.09.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:50:20 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 09/14] KVM: selftests: Sync uapi/linux/kvm.h to tools/
Date:   Wed,  4 Mar 2020 12:49:42 -0500
Message-Id: <20200304174947.69595-10-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be needed to extend the kvm selftest program.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 44 ++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 4b95f9a31a2f..50bf39d24f17 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_DIRTY_RING_FULL  29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1010,6 +1011,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_DIRTY_LOG_RING 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1478,6 +1480,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc5)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1628,4 +1633,43 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         collected        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion (to collect dirty bits).  Also, it must not skip any
+ * dirty bits so that dirty bits are always collected in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
+
+/*
+ * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
+ * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
+ * size of the gfn buffer is decided by the first argument when
+ * enabling KVM_CAP_DIRTY_LOG_RING.
+ */
+struct kvm_dirty_gfn {
+	__u32 flags;
+	__u32 slot;
+	__u64 offset;
+};
+
 #endif /* __LINUX_KVM_H */
-- 
2.24.1

