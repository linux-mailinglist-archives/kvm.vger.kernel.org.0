Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7567D70E7
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjJYPZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjJYPZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87635186
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ogZQrurRkWocGHPi25OqCYHrWbleHCNHLEdRKHHa8c=;
        b=Qo0c0jhPgXz7XZ03LSEiAOdmomJBLH6WWbhjcpGtAsdqn+8e0S50wUeWuL3asf2YB90jHf
        DzBhPwvxPLZ8n8Vwi6NNuf7qNKmw3ImMO4pGPmPiz9etqeJcqcuqh8De/54sbYtIsfdQEY
        /cG2tdhpVLuOM6KbbWic5wXG8bB+3cw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-nMYyCbkrOMW6cihJ1gFdZw-1; Wed,
 25 Oct 2023 11:24:19 -0400
X-MC-Unique: nMYyCbkrOMW6cihJ1gFdZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9236D3C0FC8C;
        Wed, 25 Oct 2023 15:24:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A50572166B26;
        Wed, 25 Oct 2023 15:24:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull vmx_set_nested_state_test for !eVMCS case
Date:   Wed, 25 Oct 2023 17:24:01 +0200
Message-ID: <20231025152406.1879274-10-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.41.0

