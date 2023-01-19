Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B3C67475C
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjASXqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjASXqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:46:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0BE9F394
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674171914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DP8p6YjB5n3mkUbVX2jmwqTvj2K5FpHC88UY/qgrSK8=;
        b=T/rqLtgd7wlhXP3LYzRkuA4mDnm1NJbsVbkg7AQIrV8NhUsDONb+IiL3LkOmCdUGLBRvDx
        08jnVp73hT6eN6AxPc1YPqHiq+e4zk7+YSuSpvLWDDlZQF3y8xEA0H8wrAlhTeo7r4+F0P
        8TS1hWMp3zwz2JU7Bppc/JcfYnl3RlU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-8qlFck-1Puq6zLbjF-jjIg-1; Thu, 19 Jan 2023 18:45:11 -0500
X-MC-Unique: 8qlFck-1Puq6zLbjF-jjIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48C37801779;
        Thu, 19 Jan 2023 23:45:10 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 405282166B2A;
        Thu, 19 Jan 2023 23:45:02 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        oliver.upton@linux.dev, will@kernel.org, gshan@redhat.com,
        ricarkol@google.com, eric.auger@redhat.com, yuzhe@nfschina.com,
        renzhengeek@gmail.com, reijiw@google.com, ardb@kernel.org,
        Julia.Lawall@inria.fr, yuzenghui@huawei.com, seanjc@google.com,
        shan.gavin@gmail.com
Subject: [PATCH v2 2/3] KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending status
Date:   Fri, 20 Jan 2023 07:44:04 +0800
Message-Id: <20230119234405.349644-3-gshan@redhat.com>
In-Reply-To: <20230119234405.349644-1-gshan@redhat.com>
References: <20230119234405.349644-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't have a running VCPU context to restore vgic3 LPI pending status
due to command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM
device "kvm-arm-vgic-its".

Use vgic_write_guest_lock() to restore vgic3 LPI pending status.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst | 8 +++++---
 arch/arm64/kvm/vgic/vgic-v3.c  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b57..40ada313faa3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8070,9 +8070,11 @@ considering the state as complete. VMM needs to ensure that the dirty
 state is final and avoid missing dirty pages from another ioctl ordered
 after the bitmap collection.
 
-NOTE: One example of using the backup bitmap is saving arm64 vgic/its
-tables through KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on
-KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
+NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
+tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
+KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
+command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
+"kvm-arm-vgic-its". vgic3 LPI pending status is restored.
 
 8.30 KVM_CAP_XEN_HVM
 --------------------
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 2074521d4a8c..2e680d8a0a15 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -339,7 +339,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	if (status) {
 		/* clear consumed data */
 		val &= ~(1 << bit_nr);
-		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
+		ret = vgic_write_guest_lock(kvm, ptr, &val, 1);
 		if (ret)
 			return ret;
 	}
-- 
2.23.0

