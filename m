Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A54487585
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 11:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346754AbiAGK3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 05:29:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346743AbiAGK3R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 05:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641551357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQcAEWzNT9KF5xI5r0wHhg6G3Y0EE7hYu8lY7B237hU=;
        b=eXUoziP35opaAJ85JDi7QlXNxHrSc44k9xgXHCieBKmAMfB5IqEpJLcOgZB3yJhzNNlE2L
        qd9y+6zbWFlqQWo+1f9fXz+Ll+7IfK68oBmMxRvkCLSkvmAdH7jrcAZz8UhWloF5OocYkj
        IAeoiwhxJHfo9KmiS5F65pOBrkgiKDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-sqxzYbslPRy-sA2qef0H2w-1; Fri, 07 Jan 2022 05:29:14 -0500
X-MC-Unique: sqxzYbslPRy-sA2qef0H2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B722314754;
        Fri,  7 Jan 2022 10:29:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6BEB72FA2;
        Fri,  7 Jan 2022 10:29:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: nVMX: Rename vmcs_to_field_offset{,_table}
Date:   Fri,  7 Jan 2022 11:28:57 +0100
Message-Id: <20220107102859.1471362-4-vkuznets@redhat.com>
In-Reply-To: <20220107102859.1471362-1-vkuznets@redhat.com>
References: <20220107102859.1471362-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmcs_to_field_offset{,_table} may sound misleading as VMCS is an opaque
blob which is not supposed to be accessed directly. In fact,
vmcs_to_field_offset{,_table} are related to KVM defined VMCS12 structure.

Rename vmcs_field_to_offset() to get_vmcs12_field_offset() for clarity.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 arch/x86/kvm/vmx/vmcs12.c | 4 ++--
 arch/x86/kvm/vmx/vmcs12.h | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f235f77cbc03..5941ba05b509 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5111,7 +5111,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	offset = vmcs_field_to_offset(field);
+	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
 		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
@@ -5214,7 +5214,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
-	offset = vmcs_field_to_offset(field);
+	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
 		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
@@ -6462,7 +6462,7 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
 	max_idx = 0;
 	for (i = 0; i < nr_vmcs12_fields; i++) {
 		/* The vmcs12 table is very, very sparsely populated. */
-		if (!vmcs_field_to_offset_table[i])
+		if (!vmcs12_field_offsets[i])
 			continue;
 
 		idx = vmcs_field_index(VMCS12_IDX_TO_ENC(i));
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index cab6ba7a5005..2251b60920f8 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -8,7 +8,7 @@
 	FIELD(number, name),						\
 	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
 
-const unsigned short vmcs_field_to_offset_table[] = {
+const unsigned short vmcs12_field_offsets[] = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
 	FIELD(POSTED_INTR_NV, posted_intr_nv),
 	FIELD(GUEST_ES_SELECTOR, guest_es_selector),
@@ -151,4 +151,4 @@ const unsigned short vmcs_field_to_offset_table[] = {
 	FIELD(HOST_RSP, host_rsp),
 	FIELD(HOST_RIP, host_rip),
 };
-const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs_field_to_offset_table);
+const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 2a45f026ee11..746129ddd5ae 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -361,10 +361,10 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(guest_pml_index, 996);
 }
 
-extern const unsigned short vmcs_field_to_offset_table[];
+extern const unsigned short vmcs12_field_offsets[];
 extern const unsigned int nr_vmcs12_fields;
 
-static inline short vmcs_field_to_offset(unsigned long field)
+static inline short get_vmcs12_field_offset(unsigned long field)
 {
 	unsigned short offset;
 	unsigned int index;
@@ -377,7 +377,7 @@ static inline short vmcs_field_to_offset(unsigned long field)
 		return -ENOENT;
 
 	index = array_index_nospec(index, nr_vmcs12_fields);
-	offset = vmcs_field_to_offset_table[index];
+	offset = vmcs12_field_offsets[index];
 	if (offset == 0)
 		return -ENOENT;
 	return offset;
-- 
2.33.1

