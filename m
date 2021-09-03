Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DC740075B
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 23:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbhICVRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 17:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234472AbhICVRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 17:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630703765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6t3h2Mlp3rk1TasU2ZEG8OzaCEsOtdQv3ykEEHWrfc=;
        b=ARnAk0IKYBBpsnX5CZPQ4OkZhvdJWX7OOTRh//+1S4pUQ5L/Ey3SvE+RqHSucHwNfiPnWu
        FdYnLqT6f3at7aTvvXWy8xO7CXMZ3xJTK66/bifPL4QGIbUGy2z9Rfd4H71FUDnOhRbBbP
        7wp8bWGD5c9lw5d3etBkZlPAPpUOl1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-aa8o_a-gNPCbzyoETfJJuA-1; Fri, 03 Sep 2021 17:16:03 -0400
X-MC-Unique: aa8o_a-gNPCbzyoETfJJuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5EE010054F6;
        Fri,  3 Sep 2021 21:16:02 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E47260861;
        Fri,  3 Sep 2021 21:16:02 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 1/3] kvm: x86: Set KVM_MAX_VCPU_ID to 4*KVM_MAX_VCPUS
Date:   Fri,  3 Sep 2021 17:15:58 -0400
Message-Id: <20210903211600.2002377-2-ehabkost@redhat.com>
In-Reply-To: <20210903211600.2002377-1-ehabkost@redhat.com>
References: <20210903211600.2002377-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of requiring KVM_MAX_VCPU_ID to be manually increased
every time we increase KVM_MAX_VCPUS, set it to 4*KVM_MAX_VCPUS.
This should be enough for CPU topologies where Cores-per-Package
and Packages-per-Socket are not powers of 2.

In practice, this increases KVM_MAX_VCPU_ID from 1023 to 1152.
The only side effect of this change is making some fields in
struct kvm_ioapic larger, increasing the struct size from 1628 to
1780 bytes (in x86_64).

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
Note: this conflicts with:
  https://lore.kernel.org/lkml/20210903130808.30142-3-jgross@suse.com
  Date: Fri,  3 Sep 2021 15:08:03 +0200
  From: Juergen Gross <jgross@suse.com>
  Subject: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id bits
  Message-Id: <20210903130808.30142-3-jgross@suse.com>

I would be happy to drop this patch and resubmit the series if
Juergen's series gets merged first.  This is part of this series
only because I'm not sure how the final version of Juergen's
changes will look like and how long they will take to be merged.
---
 arch/x86/include/asm/kvm_host.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index af6ce8d4c86a..f4cbc08b8d4d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,7 +39,19 @@
 
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
-#define KVM_MAX_VCPU_ID 1023
+
+/*
+ * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
+ * might be larger than the actual number of VCPUs because the
+ * APIC ID encodes CPU topology information.
+ *
+ * In the worst case, we'll need less than one extra bit for the
+ * Core ID, and less than one extra bit for the Package (Die) ID,
+ * so ratio of 4 should be enough.
+ */
+#define KVM_VCPU_ID_RATIO 4
+#define KVM_MAX_VCPU_ID (KVM_MAX_VCPUS * KVM_VCPU_ID_RATIO)
+
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
 
-- 
2.31.1

