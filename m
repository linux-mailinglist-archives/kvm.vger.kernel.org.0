Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9506466B67E
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 05:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjAPEFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 23:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjAPEFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 23:05:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7A583DC
        for <kvm@vger.kernel.org>; Sun, 15 Jan 2023 20:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673841898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bA+wbP792KXwkm3/fGkTmvYSd+miHBdshWBI6pE7H5E=;
        b=bD0ez8qvAjjDAoE3ZQJtffTTrJu2zJm+q37v56usfR8Cqa8oJufpMWkg1gR4LEy2sPYl5D
        t8NPuk5sI3ky3sK9mTMVMGRE/bD3PBES4dDSCAiQKyAWsaB8PQ8QA41yRlsz+cPGdZ+gZt
        vsgQ1yIrYep9ZcYyw+uaEZXbT+wF/aw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-8MvBQx6yPoCdaaYFkjo74w-1; Sun, 15 Jan 2023 23:04:52 -0500
X-MC-Unique: 8MvBQx6yPoCdaaYFkjo74w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBA301C08DA5;
        Mon, 16 Jan 2023 04:04:51 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0EAD492B05;
        Mon, 16 Jan 2023 04:04:44 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        corbet@lwn.net, james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, seanjc@google.com,
        shan.gavin@gmail.com
Subject: [PATCH 2/4] KVM: arm64: Allow saving vgic3 pending tables in no running vcpu context
Date:   Mon, 16 Jan 2023 12:04:03 +0800
Message-Id: <20230116040405.260935-3-gshan@redhat.com>
In-Reply-To: <20230116040405.260935-1-gshan@redhat.com>
References: <20230116040405.260935-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's possible to save vgic3 pending tables in no running VCPU
context. This is another unknown case detected by 'kvm-unit-tests'.

   # ./kvm-unit-tests/tests/its-pending-migration
   WARNING: CPU: 120 PID: 7973 at arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3325 \
   mark_page_dirty_in_slot+0x60/0xe0
    :
   mark_page_dirty_in_slot+0x60/0xe0
   __kvm_write_guest_page+0xcc/0x100
   kvm_write_guest+0x7c/0xb0
   vgic_v3_save_pending_tables+0x148/0x2a0
   vgic_set_common_attr+0x158/0x240
   vgic_v3_set_attr+0x4c/0x5c
   kvm_device_ioctl+0x100/0x160
   __arm64_sys_ioctl+0xa8/0xf0
   invoke_syscall.constprop.0+0x7c/0xd0
   el0_svc_common.constprop.0+0x144/0x160
   do_el0_svc+0x34/0x60
   el0_svc+0x3c/0x1a0
   el0t_64_sync_handler+0xb4/0x130
   el0t_64_sync+0x178/0x17c

Fix it by allowing to save VGIC3 pending tables in no running VCPU
context.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst | 3 +++
 arch/arm64/kvm/vgic/vgic-v3.c  | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 18b245a0ba02..7cf3d4b77703 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8074,6 +8074,9 @@ NOTE: One example of using the backup bitmap is saving arm64 vgic/its
 tables and vgic3 LPI pending status through KVM_DEV_ARM_{VGIC_GRP_CTRL,
 ITS_SAVE_TABLES} and KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES}
 command on KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
+The backup bitmap is also used when vgic3 pending table is saved
+through KVM_DEV_ARM_{VGIC_GRP_CTRL, VGIC_SAVE_PENDING_TABLES} command
+on KVM device "kvm-arm-vgic-v3".
 
 8.30 KVM_CAP_XEN_HVM
 --------------------
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 32998c8587a8..1e6b5f19d524 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -440,7 +440,9 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		else
 			val &= ~(1 << bit_nr);
 
+		dist->save_vgic_v3_tables_in_progress = true;
 		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
+		dist->save_vgic_v3_tables_in_progress = false;
 		if (ret)
 			goto out;
 	}
-- 
2.23.0

