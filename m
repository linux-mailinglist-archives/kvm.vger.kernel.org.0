Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A762868F049
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjBHODL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjBHODF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D63740BE5
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675864901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LLoh5TBX9JIZXNzcUIXGAY+PkQJYUmsvSDRrT4/hutQ=;
        b=XyGJ/LzQx8EyodQU2rn0gQvWVuBlKU3DqvHU58M5ksbk2/uBtSoiGl9+Qo4i6o9cxJayVK
        iFYoZ+uUhrY/FfTgetTXlupoP5yycAMnrTTHoxa0Jqr46iWmtIxB7Dzeecnc9sKnSCtgvC
        9U2EJHJpmv97dQebWq+I4GwAfWBsFNQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-MhELPkxDNaajK6CI6PJt4A-1; Wed, 08 Feb 2023 09:01:34 -0500
X-MC-Unique: MhELPkxDNaajK6CI6PJt4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B55318057A6;
        Wed,  8 Feb 2023 14:01:30 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F86C1415113;
        Wed,  8 Feb 2023 14:01:27 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 3/6] KVM: x86: Remove the KVM_GET_NR_MMU_PAGES ioctl
Date:   Wed,  8 Feb 2023 15:01:02 +0100
Message-Id: <20230208140105.655814-4-thuth@redhat.com>
In-Reply-To: <20230208140105.655814-1-thuth@redhat.com>
References: <20230208140105.655814-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_GET_NR_MMU_PAGES ioctl is quite questionable on 64-bit hosts
since it fails to return the full 64 bits of the value that can be
set with the corresponding KVM_SET_NR_MMU_PAGES call. Its "long" return
value is truncated into an "int" in the kvm_arch_vm_ioctl() function.

Since this ioctl also never has been used by userspace applications
(QEMU, Google's internal VMM, kvmtool and CrosVM have been checked),
it's likely the best if we remove this badly designed ioctl before
anybody really tries to use it.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/x86/kvm/x86.c             | 8 --------
 include/uapi/linux/kvm.h       | 2 +-
 tools/include/uapi/linux/kvm.h | 2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..2d210ab47e21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6007,11 +6007,6 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	return 0;
 }
 
-static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
-{
-	return kvm->arch.n_max_mmu_pages;
-}
-
 static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
@@ -6689,9 +6684,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_NR_MMU_PAGES:
 		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
 		break;
-	case KVM_GET_NR_MMU_PAGES:
-		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
-		break;
 	case KVM_CREATE_IRQCHIP: {
 		mutex_lock(&kvm->lock);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 55155e262646..59dc7e5d4974 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1442,7 +1442,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
-#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)  /* deprecated */
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 55155e262646..59dc7e5d4974 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1442,7 +1442,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
-#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)  /* deprecated */
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
-- 
2.31.1

