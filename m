Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409085E575A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 02:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiIVAcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 20:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIVAct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 20:32:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0128FA98D5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 17:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663806766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvScjfkKuSDrLb00oYmoSVUq1hJaUCKKGbiWFg0bV0E=;
        b=PCg9luCCAsYNm5m+U6dgNKF7xWffCgmliu0m3ghLvBjIWECZYV6E3HZ/MQBPnRWwIAD3XE
        VkQ2/e1o0TEv0orZ7KZdv8qfrzgWPDvXUPpqiGJ56zAKndyW4D0QYnuqKuwVkF7khFUXV8
        4kBy4NUi3bp2tAYepdnbCmm3In3WjmI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-P5m3G0UpMhWxIGxgITatpA-1; Wed, 21 Sep 2022 20:32:43 -0400
X-MC-Unique: P5m3G0UpMhWxIGxgITatpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F88F1C14B68;
        Thu, 22 Sep 2022 00:32:42 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F3162166B26;
        Thu, 22 Sep 2022 00:32:37 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, maz@kernel.org, andrew.jones@linux.dev,
        will@kernel.org, dmatlack@google.com, oliver.upton@linux.dev,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v3 3/6] KVM: arm64: Enable ring-based dirty memory tracking
Date:   Thu, 22 Sep 2022 08:32:11 +0800
Message-Id: <20220922003214.276736-4-gshan@redhat.com>
In-Reply-To: <20220922003214.276736-1-gshan@redhat.com>
References: <20220922003214.276736-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables the ring-based dirty memory tracking on ARM64. The
feature is configured by CONFIG_HAVE_KVM_DIRTY_RING, detected and
enabled by KVM_CAP_DIRTY_LOG_RING. A ring buffer is created on every
VCPU when the feature is enabled. Each entry in the ring buffer is
described by 'struct kvm_dirty_gfn'.

A ring buffer entry is pushed when a page becomes dirty on host,
and pulled by userspace after the ring buffer is mapped at physical
page offset KVM_DIRTY_LOG_PAGE_OFFSET. The specific VCPU is enforced
to exit if its ring buffer becomes softly full. Besides, the ring
buffer can be reset by ioctl command KVM_RESET_DIRTY_RINGS to release
those pulled ring buffer entries.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst    | 2 +-
 arch/arm64/include/uapi/asm/kvm.h | 1 +
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/arm.c              | 8 ++++++++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..19fa1ac017ed 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8022,7 +8022,7 @@ regardless of what has actually been exposed through the CPUID leaf.
 8.29 KVM_CAP_DIRTY_LOG_RING
 ---------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Parameters: args[0] - size of the dirty log ring
 
 KVM is capable of tracking dirty memory using ring buffers that are
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 316917b98707..a7a857f1784d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -43,6 +43,7 @@
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 815cc118c675..0309b2d0f2da 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,7 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_DIRTY_RING
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2ff0ef62abad..76816f8e082b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -747,6 +747,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
+
+		if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
+		    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
+			kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
+			trace_kvm_dirty_ring_exit(vcpu);
+			return 0;
+		}
 	}
 
 	return 1;
-- 
2.23.0

