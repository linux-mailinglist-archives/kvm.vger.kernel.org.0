Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DC722EDA5
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgG0Njt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 09:39:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729112AbgG0Njr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 09:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595857185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j7vAEtPkblIb/FUeLn/+GN2wLSCH8Au5AcbyR00wCiM=;
        b=G8gfpvLCvtg6vsfQFBNVU1cUi64uyy0cAiBLi59HHJEya7imHnEGoUbl8e00Ml4T9wfqcX
        B0DbWXFAbw3hl4EWiGrbQvDjdZnEtd/fLPTNEnoeN+aw6C6iXYvOXYruUYgZ8noWtIJtpp
        wmdXd/VaDhNYc4pU0kPPmyQCs1M7nPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-BQFNoj0ZMhmuUwC_RoTqxQ-1; Mon, 27 Jul 2020 09:39:40 -0400
X-MC-Unique: BQFNoj0ZMhmuUwC_RoTqxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBA401005510;
        Mon, 27 Jul 2020 13:39:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E3205D9F3;
        Mon, 27 Jul 2020 13:39:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, aaronlewis@google.com
Subject: [PATCH 1/3] selftests: kvm: do not set guest mode flag
Date:   Mon, 27 Jul 2020 09:39:32 -0400
Message-Id: <20200727133934.25482-2-pbonzini@redhat.com>
In-Reply-To: <20200727133934.25482-1-pbonzini@redhat.com>
References: <20200727133934.25482-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Setting KVM_STATE_NESTED_GUEST_MODE enables various consistency checks
on VMCS12 and therefore causes KVM_SET_NESTED_STATE to fail spuriously
with -EINVAL.  Do not set the flag so that we're sure to cover the
conditions included by the test, and cover the case where VMCS12 is
set and KVM_SET_NESTED_STATE is called with invalid VMCS12 contents.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../kvm/x86_64/vmx_set_nested_state_test.c      | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 54cdefdfb49d..d14a34f1b018 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -76,10 +76,8 @@ void set_default_state(struct kvm_nested_state *state)
 void set_default_vmx_state(struct kvm_nested_state *state, int size)
 {
 	memset(state, 0, size);
-	state->flags = KVM_STATE_NESTED_GUEST_MODE  |
-			KVM_STATE_NESTED_RUN_PENDING;
 	if (have_evmcs)
-		state->flags |= KVM_STATE_NESTED_EVMCS;
+		state->flags = KVM_STATE_NESTED_EVMCS;
 	state->format = 0;
 	state->size = size;
 	state->hdr.vmx.vmxon_pa = 0x1000;
@@ -190,17 +188,20 @@ void test_vmx_nested_state(struct kvm_vm *vm)
 	state->size = sizeof(*state);
 	test_nested_state(vm, state);
 
+	/*
+	 * KVM_SET_NESTED_STATE succeeds with invalid VMCS
+	 * contents but L2 not running.
+	 */
+	set_default_vmx_state(state, state_sz);
+	state->flags = 0;
+	test_nested_state(vm, state);
+
 	/* vmxon_pa cannot be the same address as vmcs_pa. */
 	set_default_vmx_state(state, state_sz);
 	state->hdr.vmx.vmxon_pa = 0;
 	state->hdr.vmx.vmcs12_pa = 0;
 	test_nested_state_expect_einval(vm, state);
 
-	/* The revision id for vmcs12 must be VMCS12_REVISION. */
-	set_default_vmx_state(state, state_sz);
-	set_revision_id_for_vmcs12(state, 0);
-	test_nested_state_expect_einval(vm, state);
-
 	/*
 	 * Test that if we leave nesting the state reflects that when we get
 	 * it again.
-- 
2.26.2


