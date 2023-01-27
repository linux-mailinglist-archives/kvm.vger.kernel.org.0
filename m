Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A147167F274
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjA0Xxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjA0Xxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:53:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B8D24CA3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674863577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2wJW8358fg+BxDaJzgkd3OND14b2zFqKAQeciq7tLo=;
        b=epzPdeZJBD8B7tzXeKPUBTUXMKR+QpIw97U0yc3xz+pjh75BlWa7eDeqDoxUkk0KHHoDyX
        3j1YFGBq13Jb/YJlf7guvlpaVoA1ZmCXNBlTjlvjRQ+wYkj1br2R2Q3TXjYDAa+enqlszw
        uszuzVzUXrMYPU1tKIigTM60TaqtYWA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490--DjD9ThIOLGmJsNr4myWAw-1; Fri, 27 Jan 2023 18:52:52 -0500
X-MC-Unique: -DjD9ThIOLGmJsNr4myWAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5B672801E4F;
        Fri, 27 Jan 2023 23:52:51 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F02B40C141B;
        Fri, 27 Jan 2023 23:52:44 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, yuzhe@nfschina.com,
        gshan@redhat.com, seanjc@google.com, isaku.yamahata@intel.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
Subject: [PATCH v4 3/4] KVM: arm64: Allow no running vcpu on restoring VGICv3 LPI pending status
Date:   Sat, 28 Jan 2023 07:51:49 +0800
Message-Id: <20230127235150.17025-4-gshan@redhat.com>
In-Reply-To: <20230127235150.17025-1-gshan@redhat.com>
References: <20230127235150.17025-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't have a running VCPU context to restore VGICv3 LPI pending status
due to command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM
device "kvm-arm-vgic-its".

Use vgic_write_guest_lock() to restore VGICv3 LPI pending status.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst | 8 +++++---
 arch/arm64/kvm/vgic/vgic-v3.c  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b57..5dc3598afbe2 100644
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
+"kvm-arm-vgic-its". VGICv3 LPI pending status is restored.
 
 8.30 KVM_CAP_XEN_HVM
 --------------------
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 5dfbd03e5e1a..c94e4d7520fc 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -338,7 +338,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
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

