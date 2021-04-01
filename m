Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66935196C
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhDARxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235248AbhDARrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UuqX1vaXGK/rRIbLo5826fQo7T0UET7bCEj3dtAWeOc=;
        b=IBXTIT0Mc7+FiXvO06mIaQbK1Q0sjJOQQFsXA223UamnbbwjDiC5SAU92E3BggalHkjYjq
        6DVEK6qAHl9uF/i5i7pLqnWXPwwujlW1xQW+ZmW0Sazzuidx+5jZPgKjjAFXF78J7zEMz5
        Orb8PLDWBYfRs9t1KOOFDb/rILZE9m0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-xZzA3Ac2M0ewcgkKFRjlbQ-1; Thu, 01 Apr 2021 10:46:11 -0400
X-MC-Unique: xZzA3Ac2M0ewcgkKFRjlbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E30A88015B6;
        Thu,  1 Apr 2021 14:45:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F96A5C8AA;
        Thu,  1 Apr 2021 14:45:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] kvm: update kernel headers for KVM_{GET|SET}_SREGS2
Date:   Thu,  1 Apr 2021 17:45:44 +0300
Message-Id: <20210401144545.1031704-2-mlevitsk@redhat.com>
In-Reply-To: <20210401144545.1031704-1-mlevitsk@redhat.com>
References: <20210401144545.1031704-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 linux-headers/asm-x86/kvm.h | 13 +++++++++++++
 linux-headers/linux/kvm.h   |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 8e76d3701d..8c604e6bb1 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -158,6 +158,19 @@ struct kvm_sregs {
 	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
 };
 
+struct kvm_sregs2 {
+	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
+	struct kvm_segment cs, ds, es, fs, gs, ss;
+	struct kvm_segment tr, ldt;
+	struct kvm_dtable gdt, idt;
+	__u64 cr0, cr2, cr3, cr4, cr8;
+	__u64 efer;
+	__u64 apic_base;
+	__u64 flags; /* must be zero*/
+	__u64 pdptrs[4];
+	__u64 padding;
+};
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 	__u8  fpr[8][16];
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..a97f0f2d03 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_SREGS2 196
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1563,6 +1564,10 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+
+#define KVM_GET_SREGS2             _IOR(KVMIO,  0xca, struct kvm_sregs2)
+#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcb, struct kvm_sregs2)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.26.2

