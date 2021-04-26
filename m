Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E7D36B2A2
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhDZL7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:59:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233225AbhDZL7q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619438344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2xfjkPnQFPRjK9jBH/26YtD7u3pk0Xa3TCgZG3qQIhc=;
        b=Fe+2+Gl/NMo0Fc5BiRnKp1frHtA61IrztRLRdOuhDAyM1ne98NI4vM5Owj7U2pKbs0/MbR
        99VHULW2S8Z651dIV4DS71FYL1TjUj7i0IrQ4bPdxkMu2QbupQSa5nIce9IrhQuLJgttt7
        TKXEkdsoYRZaPV5yOZ4CwTNs/zltIBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-ozEL8TJpNJ6EPfoL1Ru9mQ-1; Mon, 26 Apr 2021 07:59:02 -0400
X-MC-Unique: ozEL8TJpNJ6EPfoL1Ru9mQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 695596409F;
        Mon, 26 Apr 2021 11:59:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FF9560855;
        Mon, 26 Apr 2021 11:58:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/2] kvm: update kernel headers for KVM_{GET|SET}_SREGS2
Date:   Mon, 26 Apr 2021 14:58:49 +0300
Message-Id: <20210426115850.1003501-2-mlevitsk@redhat.com>
In-Reply-To: <20210426115850.1003501-1-mlevitsk@redhat.com>
References: <20210426115850.1003501-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 linux-headers/asm-x86/kvm.h | 13 +++++++++++++
 linux-headers/linux/kvm.h   |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 8e76d3701d..d61dc76e24 100644
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
+	__u64 flags;
+	__u64 pdptrs[4];
+};
+#define KVM_SREGS2_FLAGS_PDPTRS_VALID 1
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 	__u8  fpr[8][16];
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..22ea29a243 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_SREGS2 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1563,6 +1564,10 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+
+#define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
+#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.26.2

