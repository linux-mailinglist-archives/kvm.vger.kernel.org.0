Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6193EC687
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhHOBDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:03:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236311AbhHOBDQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JcWtDu7p2Qu/JKSPI/zS4AqjmMnxUQpnL7tRXt4otTk=;
        b=UKpV5DkVnIOgA2l9gjOgVC70ZFsmgbT+uUoeYKhzGfgYBFtyPjEb5fCS2N9X+w2N71hvBM
        IqT3ejTV7UNDSbr4lo11nWb8z386KPiCk1zOUQYqR+m6iproK5O696ksMsevtVwNAVD206
        gWrr36rz9fhnqWHnSJNdKJRoK1t3phs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-M4xytfevM7-OQVPAceXSWw-1; Sat, 14 Aug 2021 21:02:46 -0400
X-MC-Unique: M4xytfevM7-OQVPAceXSWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F252D8799E0;
        Sun, 15 Aug 2021 01:02:44 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEB4E6091B;
        Sun, 15 Aug 2021 01:02:40 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 11/15] KVM: arm64: Export async PF capability
Date:   Sun, 15 Aug 2021 08:59:43 +0800
Message-Id: <20210815005947.83699-12-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This exports the asynchronous page fault capability:

    * Identify capability KVM_CAP_ASYNC_{PF, PF_INT}.

    * Standardize SDEI event for asynchronous page fault.

    * Enable kernel config CONFIG_KVM_ASYNC_{PF, PF_SLOT}.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/uapi/asm/kvm_sdei.h | 1 +
 arch/arm64/kvm/Kconfig                 | 2 ++
 arch/arm64/kvm/arm.c                   | 4 ++++
 arch/arm64/kvm/sdei.c                  | 5 +++++
 4 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm_sdei.h b/arch/arm64/include/uapi/asm/kvm_sdei.h
index f7a6b2b22b50..cbe8be3d0a25 100644
--- a/arch/arm64/include/uapi/asm/kvm_sdei.h
+++ b/arch/arm64/include/uapi/asm/kvm_sdei.h
@@ -16,6 +16,7 @@
 #define KVM_SDEI_MAX_VCPUS	512
 #define KVM_SDEI_INVALID_NUM	0
 #define KVM_SDEI_DEFAULT_NUM	0x40400000
+#define KVM_SDEI_ASYNC_PF_NUM	0x40400001
 
 struct kvm_sdei_event_state {
 	__u64	num;
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a4eba0908bfa..3c6f89b4c9a0 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -29,6 +29,8 @@ menuconfig KVM
 	select SRCU
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
+	select KVM_ASYNC_PF
+	select KVM_ASYNC_PF_SLOT
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 74ca5ec51e53..2692bd24df86 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -281,6 +281,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SDEI:
 		r = 1;
 		break;
+	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_ASYNC_PF_INT:
+		r = IS_ENABLED(CONFIG_KVM_ASYNC_PF) ? 1 : 0;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
index 4f5a582daa97..437303bfafba 100644
--- a/arch/arm64/kvm/sdei.c
+++ b/arch/arm64/kvm/sdei.c
@@ -19,6 +19,11 @@ static struct kvm_sdei_event_state defined_kse[] = {
 	  1,
 	  SDEI_EVENT_PRIORITY_CRITICAL
 	},
+	{ KVM_SDEI_ASYNC_PF_NUM,
+	  SDEI_EVENT_TYPE_PRIVATE,
+	  1,
+	  SDEI_EVENT_PRIORITY_CRITICAL
+	},
 };
 
 static struct kvm_sdei_event *kvm_sdei_find_event(struct kvm *kvm,
-- 
2.23.0

