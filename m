Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF50F3EC67D
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhHOBCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235776AbhHOBCq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:02:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=88N+p1H52aFWa1qAO1bnhEhJK9rOvXpt4szntFewDdM=;
        b=aGfjgJ6WHTccPJ4Dy4Ct7EdmPSLpolqb7sHVque0uHYo15uJmS6hfEigGYvEWGeohNJK1B
        bdzinIbJ9NW93SHXK7CEdFCccrnU5GCXnE+M0TEACTv0yVUu0nMejus+DkT3JmqsmUXw00
        n4z4FcEGQO0/TDkOxoMcu658semKc/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-CUo5fvpvMxuh573TVCXGSA-1; Sat, 14 Aug 2021 21:02:14 -0400
X-MC-Unique: CUo5fvpvMxuh573TVCXGSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF58B1008061;
        Sun, 15 Aug 2021 01:02:12 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1C046091B;
        Sun, 15 Aug 2021 01:02:08 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 06/15] KVM: arm64: Add paravirtualization header files
Date:   Sun, 15 Aug 2021 08:59:38 +0800
Message-Id: <20210815005947.83699-7-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need put more stuff in the paravirtualization header files when
the asynchronous page fault is supported. The generic header files
can't meet the goal. This duplicate the generic header files to be
our platform specific header files. It's the preparatory work to
support the asynchronous page fault in the subsequent patches:

   include/uapi/asm-generic/kvm_para.h
   include/asm-generic/kvm_para.h

   arch/arm64/include/uapi/asm/kvm_para.h
   arch/arm64/include/asm/kvm_para.h

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_para.h      | 27 ++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/Kbuild     |  2 --
 arch/arm64/include/uapi/asm/kvm_para.h |  5 +++++
 3 files changed, 32 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_para.h
 create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h

diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
new file mode 100644
index 000000000000..0ea481dd1c7a
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_para.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM_KVM_PARA_H
+#define _ASM_ARM_KVM_PARA_H
+
+#include <uapi/asm/kvm_para.h>
+
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_hints(void)
+{
+	return 0;
+}
+
+static inline bool kvm_para_available(void)
+{
+	return false;
+}
+
+#endif /* _ASM_ARM_KVM_PARA_H */
diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
index 602d137932dc..f66554cd5c45 100644
--- a/arch/arm64/include/uapi/asm/Kbuild
+++ b/arch/arm64/include/uapi/asm/Kbuild
@@ -1,3 +1 @@
 # SPDX-License-Identifier: GPL-2.0
-
-generic-y += kvm_para.h
diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
new file mode 100644
index 000000000000..cd212282b90c
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/kvm_para.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_ARM_KVM_PARA_H
+#define _UAPI_ASM_ARM_KVM_PARA_H
+
+#endif /* _UAPI_ASM_ARM_KVM_PARA_H */
-- 
2.23.0

