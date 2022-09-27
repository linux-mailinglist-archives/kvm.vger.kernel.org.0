Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF02D5EB688
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 02:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiI0AzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 20:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiI0AzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 20:55:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170536AA2A
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 17:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664240115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t5oJm3SLbB/Kp1JDsmT1i9tK4j2Zs2VsSTp4T+ss7j8=;
        b=Obtjw0WKbH/MbZOXWMfKfIhbTnKl4Z/qZ63+K1fKRBtFTJHCkdxHgnEOPfOPYC9YbOhPxw
        t9Lf5CoOTkPaUC0MUkPcA9fTdshEET0elix6YCdU+5goB/QhuWROA9VB0qk9yeIpon03PQ
        CBkOhkzUKc95S9A5l0lvkZXCNBWW6tg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-fOTjcXngOWek9XE72AAz3g-1; Mon, 26 Sep 2022 20:55:11 -0400
X-MC-Unique: fOTjcXngOWek9XE72AAz3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E43D53810D20;
        Tue, 27 Sep 2022 00:55:10 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-143.bne.redhat.com [10.64.54.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B08540C2064;
        Tue, 27 Sep 2022 00:55:04 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, maz@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory tracking
Date:   Tue, 27 Sep 2022 08:54:36 +0800
Message-Id: <20220927005439.21130-4-gshan@redhat.com>
In-Reply-To: <20220927005439.21130-1-gshan@redhat.com>
References: <20220927005439.21130-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable ring-based dirty memory tracking on arm64 by selecting
CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL and providing the ring buffer's
physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst    | 2 +-
 arch/arm64/include/uapi/asm/kvm.h | 1 +
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/arm.c              | 3 +++
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 32427ea160df..bad78a974ccf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8022,7 +8022,7 @@ regardless of what has actually been exposed through the CPUID leaf.
 8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 ----------------------------------------------------------
 
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
index 815cc118c675..095c714b559e 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,7 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 917086be5c6b..53c963a159bc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -747,6 +747,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
+
+		if (kvm_dirty_ring_check_request(vcpu))
+			return 0;
 	}
 
 	return 1;
-- 
2.23.0

