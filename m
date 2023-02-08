Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9271868F04A
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjBHODM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjBHODF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683A3E62E
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675864901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xhdyz5Hmwdmj1kqpk54W2jx2hLYYhCxWxV7IaOPuFFU=;
        b=PUT4FKp7hQ2VhHcEjLhxbfnmqIvQkfHXjEu+G2vhzsoeq4nBON9shQdjwX27xLVYNirRc+
        z6PynMZr5nSVxCPM2QqoMsufuJLXMDo+MaPe5F4bTvOnnXa1okEg77To8QvY/JI1ms9Ex+
        dpfNfc0dUkK3vxaoFxN8858wDTXkvko=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-HxcK6KbQMha2osLbIj2ioA-1; Wed, 08 Feb 2023 09:01:36 -0500
X-MC-Unique: HxcK6KbQMha2osLbIj2ioA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48E253C10687;
        Wed,  8 Feb 2023 14:01:34 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0863B1415113;
        Wed,  8 Feb 2023 14:01:30 +0000 (UTC)
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
Subject: [PATCH v2 4/6] KVM: arm64: Limit length in kvm_vm_ioctl_mte_copy_tags() to INT_MAX
Date:   Wed,  8 Feb 2023 15:01:03 +0100
Message-Id: <20230208140105.655814-5-thuth@redhat.com>
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

In case of success, this function returns the amount of handled bytes.
However, this does not work for large values: The function is called
from kvm_arch_vm_ioctl() (which still returns a long), which in turn
is called from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that function
stores the return value in an "int r" variable. So the upper 32-bits
of the "long" return value are lost there.

KVM ioctl functions should only return "int" values, so let's limit
the amount of bytes that can be requested here to INT_MAX to avoid
the problem with the truncated return value. We can then also change
the return type of the function to "int" to make it clearer that it
is not possible to return a "long" here.

Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Documentation/virt/kvm/api.rst    | 3 ++-
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/guest.c            | 8 ++++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0a67cb738013..f184427931fa 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5553,7 +5553,8 @@ with the KVM_XEN_VCPU_GET_ATTR ioctl.
   };
 
 Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
-``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
+``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned.
+``length`` must not be bigger than 2^31 - PAGE_SIZE bytes. The ``addr``
 field must point to a buffer which the tags will be copied to or from.
 
 ``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..b1a16343767f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -963,8 +963,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
-long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
-				struct kvm_arm_copy_mte_tags *copy_tags);
+int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
+			       struct kvm_arm_copy_mte_tags *copy_tags);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index cf4c495a4321..cadef953046f 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1013,8 +1013,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
-				struct kvm_arm_copy_mte_tags *copy_tags)
+int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
+			       struct kvm_arm_copy_mte_tags *copy_tags)
 {
 	gpa_t guest_ipa = copy_tags->guest_ipa;
 	size_t length = copy_tags->length;
@@ -1035,6 +1035,10 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
 		return -EINVAL;
 
+	/* Lengths above INT_MAX cannot be represented in the return value */
+	if (length > INT_MAX)
+		return -EINVAL;
+
 	gfn = gpa_to_gfn(guest_ipa);
 
 	mutex_lock(&kvm->slots_lock);
-- 
2.31.1

