Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C90E474555
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhLNOj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:39:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234950AbhLNOjY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 09:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639492764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9YeLr/AWKAX3341CQ/7V+98rvHnrsaSJrK/Ig2HVNV0=;
        b=HlDq7jGKpECqaUFuwfUecPPOEhJEIGm3boooKZfXyL3a/v2Ih/5yc+dDLk3aR6uClDvl1m
        MvpfQlu0+0aREFaleNwu6UK8zhseQTQ88jqoYkEFVwizimdATBWXiZABdca/+YrUM7ZEGb
        haxIXE5010O8Ep/s9KdbWIB/SlY921k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-GFSgmNdHPJCST7ufXnAnZA-1; Tue, 14 Dec 2021 09:39:20 -0500
X-MC-Unique: GFSgmNdHPJCST7ufXnAnZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42D3B100CFB0;
        Tue, 14 Dec 2021 14:39:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F99878D87;
        Tue, 14 Dec 2021 14:39:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: nVMX: Implement evmcs_field_offset() suitable for handle_vmread()
Date:   Tue, 14 Dec 2021 15:38:58 +0100
Message-Id: <20211214143859.111602-5-vkuznets@redhat.com>
In-Reply-To: <20211214143859.111602-1-vkuznets@redhat.com>
References: <20211214143859.111602-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to allowing reads from Enlightened VMCS from
handle_vmread(), implement evmcs_field_offset() to get the correct
read offset. get_evmcs_offset(), which is being used by KVM-on-Hyper-V,
is almost what's needed but a few things need to be adjusted. First,
WARN_ON() is unacceptable for handle_vmread() as any field can (in
theory) be supplied by the guest and not all fields are defined in
eVMCS v1. Second, we need to handle 'holes' in eVMCS (missing fields).
It also sounds like a good idea to WARN_ON() if such fields are ever
accessed by KVM-on-Hyper-V.

Implement dedicated evmcs_field_offset() helper.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c |  3 +--
 arch/x86/kvm/vmx/evmcs.h | 32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index a7ed30d5647a..87e3dc10edf4 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -12,8 +12,6 @@
 
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
-#if IS_ENABLED(CONFIG_HYPERV)
-
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
 #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
 		{EVMCS1_OFFSET(name), clean_field}
@@ -296,6 +294,7 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
+#if IS_ENABLED(CONFIG_HYPERV)
 __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 3a461a32128b..9bc2521b159e 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -65,8 +65,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
-#if IS_ENABLED(CONFIG_HYPERV)
-
 struct evmcs_field {
 	u16 offset;
 	u16 clean_field;
@@ -75,26 +73,44 @@ struct evmcs_field {
 extern const struct evmcs_field vmcs_field_to_evmcs_1[];
 extern const unsigned int nr_evmcs_1_fields;
 
-static __always_inline int get_evmcs_offset(unsigned long field,
-					    u16 *clean_field)
+static __always_inline int evmcs_field_offset(unsigned long field,
+					      u16 *clean_field)
 {
 	unsigned int index = ROL16(field, 6);
 	const struct evmcs_field *evmcs_field;
 
-	if (unlikely(index >= nr_evmcs_1_fields)) {
-		WARN_ONCE(1, "KVM: accessing unsupported EVMCS field %lx\n",
-			  field);
+	if (unlikely(index >= nr_evmcs_1_fields))
 		return -ENOENT;
-	}
 
 	evmcs_field = &vmcs_field_to_evmcs_1[index];
 
+	/*
+	 * Use offset=0 to detect holes in eVMCS. This offset belongs to
+	 * 'revision_id' but this field has no encoding and is supposed to
+	 * be accessed directly.
+	 */
+	if (unlikely(!evmcs_field->offset))
+		return -ENOENT;
+
 	if (clean_field)
 		*clean_field = evmcs_field->clean_field;
 
 	return evmcs_field->offset;
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+
+static __always_inline int get_evmcs_offset(unsigned long field,
+					    u16 *clean_field)
+{
+	int offset = evmcs_field_offset(field, clean_field);
+
+	WARN_ONCE(offset < 0, "KVM: accessing unsupported EVMCS field %lx\n",
+		  field);
+
+	return offset;
+}
+
 static __always_inline void evmcs_write64(unsigned long field, u64 value)
 {
 	u16 clean_field;
-- 
2.33.1

