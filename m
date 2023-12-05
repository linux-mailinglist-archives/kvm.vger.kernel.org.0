Return-Path: <kvm+bounces-3490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C3B805092
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB9851F214EE
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC88A5B5AE;
	Tue,  5 Dec 2023 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnlkBA/Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00B31BFC
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZ3VaXwg7fGmimjT6+b6UM9vdexiUSoEh191iJ+c8CY=;
	b=CnlkBA/ZeCNuJ+A+nKRfkEZRFFamKsLvehHU0jHusMXL2ZC9uUqsACzVZq41Zs9W1gmn/c
	i2H1FjGkKz+TnjQ3j5a3lqJqa8BLfBvzTXFrNEEUsGWSN7vxRuLXTEBEuMJteRXjQpQh72
	BVUytqb0DWrbL8IZ5/lToq/gNNEXPUg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-QUvzl19RNsOn3j7JfQgUGQ-1; Tue, 05 Dec 2023 05:36:43 -0500
X-MC-Unique: QUvzl19RNsOn3j7JfQgUGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF72E85A58E;
	Tue,  5 Dec 2023 10:36:42 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C9512026D66;
	Tue,  5 Dec 2023 10:36:42 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 10/16] KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull vmx_set_nested_state_test for !eVMCS case
Date: Tue,  5 Dec 2023 11:36:24 +0100
Message-ID: <20231205103630.1391318-11-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

The "vmxon_pa == vmcs12_pa == -1ull" test happens to work by accident: as
Enlightened VMCS is always supported, set_default_vmx_state() adds
'KVM_STATE_NESTED_EVMCS' to 'flags' and the following branch of
vmx_set_nested_state() is executed:

        if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
            (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
             !vmx->nested.enlightened_vmcs_enabled))
                        return -EINVAL;

as 'enlightened_vmcs_enabled' is false. In fact, "vmxon_pa == vmcs12_pa ==
-1ull" is a valid state when not tainted by wrong flags so the test should
aim for this branch:

        if (kvm_state->hdr.vmx.vmxon_pa == INVALID_GPA)
                return 0;

Test all this properly:
- Without KVM_STATE_NESTED_EVMCS in the flags, the expected return value is
'0'.
- With KVM_STATE_NESTED_EVMCS flag (when supported) set, the expected
return value is '-EINVAL' prior to enabling eVMCS and '0' after.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../kvm/x86_64/vmx_set_nested_state_test.c       | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 41ea7028a1f8..67a62a5a8895 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -125,21 +125,25 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
-	 * setting the nested state but flags other than eVMCS must be clear.
-	 * The eVMCS flag can be set if the enlightened VMCS capability has
-	 * been enabled.
+	 * setting the nested state. When the eVMCS flag is not set, the
+	 * expected return value is '0'.
 	 */
 	set_default_vmx_state(state, state_sz);
+	state->flags = 0;
 	state->hdr.vmx.vmxon_pa = -1ull;
 	state->hdr.vmx.vmcs12_pa = -1ull;
-	test_nested_state_expect_einval(vcpu, state);
+	test_nested_state(vcpu, state);
 
-	state->flags &= KVM_STATE_NESTED_EVMCS;
+	/*
+	 * When eVMCS is supported, the eVMCS flag can only be set if the
+	 * enlightened VMCS capability has been enabled.
+	 */
 	if (have_evmcs) {
+		state->flags = KVM_STATE_NESTED_EVMCS;
 		test_nested_state_expect_einval(vcpu, state);
 		vcpu_enable_evmcs(vcpu);
+		test_nested_state(vcpu, state);
 	}
-	test_nested_state(vcpu, state);
 
 	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
 	state->hdr.vmx.smm.flags = 1;
-- 
2.43.0


