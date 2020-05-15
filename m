Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE81D582D
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgEORl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:41:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726615AbgEORl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 13:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=3QVWKpoXf+LG4l+3jzo+2GrQilylKP/gdKsYh3UzKn4=;
        b=Fwsouug+enjOMuX+cUyPjOXmrDGkwBwkXn0HSgv4yrz0iojG8mx6ycoBsc7xOKhC1nWJX2
        T4D3vtOeKmJrQ6sbTL73AYTph8+tdkKL0dS/i1l2bpg/mf5eBhfe+RvLDtJCwx5t0xJKSu
        CihsgDDHIOoWEQlVQEm5dCv63yiTLD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-ZxHHY3L7Pla_4kbrpbIOhQ-1; Fri, 15 May 2020 13:41:53 -0400
X-MC-Unique: ZxHHY3L7Pla_4kbrpbIOhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09F61107ACCD;
        Fri, 15 May 2020 17:41:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 634D910002CD;
        Fri, 15 May 2020 17:41:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 7/7] KVM: SVM: introduce data structures for nested virt state
Date:   Fri, 15 May 2020 13:41:44 -0400
Message-Id: <20200515174144.1727-8-pbonzini@redhat.com>
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c65..cdca0fd1b107 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -385,7 +385,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+#define KVM_STATE_NESTED_FORMAT_SVM	1
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
@@ -395,8 +395,14 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
+#define KVM_STATE_NESTED_SVM_VMENTRY_IF	0x00000001
+#define KVM_STATE_NESTED_SVM_GIF	0x00000002
+
 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
 
+#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
+
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -411,6 +417,17 @@ struct kvm_vmx_nested_state_hdr {
 	} smm;
 };
 
+struct kvm_svm_nested_state_data {
+	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
+	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
+};
+
+struct kvm_svm_nested_state_hdr {
+	__u64 vmcb_pa;
+
+	__u16 interrupt_flags;
+};
+
 /* for KVM_CAP_NESTED_STATE */
 struct kvm_nested_state {
 	__u16 flags;
@@ -419,6 +441,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -431,6 +454,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
-- 
2.18.2

