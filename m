Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E59D0156
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfJHTno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 15:43:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfJHTno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 15:43:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4955C10C0946;
        Tue,  8 Oct 2019 19:43:44 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-92.brq.redhat.com [10.40.204.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77E595D6A7;
        Tue,  8 Oct 2019 19:43:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 1/3] selftests: kvm: vmx_set_nested_state_test: don't check for VMX support twice
Date:   Tue,  8 Oct 2019 21:43:36 +0200
Message-Id: <20191008194338.24159-2-vkuznets@redhat.com>
In-Reply-To: <20191008194338.24159-1-vkuznets@redhat.com>
References: <20191008194338.24159-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 08 Oct 2019 19:43:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_set_nested_state_test() checks if VMX is supported twice: in the very
beginning (and skips the whole test if it's not) and before doing
test_vmx_nested_state(). One should be enough.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/vmx_set_nested_state_test.c       | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 853e370e8a39..a6d85614ae4d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -271,12 +271,7 @@ int main(int argc, char *argv[])
 	state.flags = KVM_STATE_NESTED_RUN_PENDING;
 	test_nested_state_expect_einval(vm, &state);
 
-	/*
-	 * TODO: When SVM support is added for KVM_SET_NESTED_STATE
-	 *       add tests here to support it like VMX.
-	 */
-	if (entry->ecx & CPUID_VMX)
-		test_vmx_nested_state(vm);
+	test_vmx_nested_state(vm);
 
 	kvm_vm_free(vm);
 	return 0;
-- 
2.20.1

