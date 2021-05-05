Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F01373E53
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhEEPTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233476AbhEEPT1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 11:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620227910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdEvneCWyil2ISxR35j5JgadXQtJ5dFEDKqIji5H1SA=;
        b=SFsBXIE62cY6U89EsrjzmHTPP7iLD/00rM9epQ/XOsP5tURQhsN6SwJJEjn0QSzbAzBJyV
        Nn52D6Q04v/3E63C6+EZ0aApGAqu+1VJofOJq/cAKtvCVKzEzIm3G7TTYhcpv2VxJUpo7j
        PYSiEbg70VVK8ctDSrVxkZGd82q0pSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-cDpTHzW_O46ZnPlXdcX3wg-1; Wed, 05 May 2021 11:18:29 -0400
X-MC-Unique: cDpTHzW_O46ZnPlXdcX3wg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 221628189C3;
        Wed,  5 May 2021 15:18:28 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C7265C1A3;
        Wed,  5 May 2021 15:18:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: selftests: evmcs_test: Check that VMLAUNCH with bogus EVMPTR is causing #UD
Date:   Wed,  5 May 2021 17:18:21 +0200
Message-Id: <20210505151823.1341678-2-vkuznets@redhat.com>
In-Reply-To: <20210505151823.1341678-1-vkuznets@redhat.com>
References: <20210505151823.1341678-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'run->exit_reason == KVM_EXIT_SHUTDOWN' check is not ideal as we may be
getting some unexpected exception. Directly check for #UD instead.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index ca22ee6d19cb..b01f64ac6ce3 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -19,6 +19,14 @@
 
 #define VCPU_ID		5
 
+static int ud_count;
+
+static void guest_ud_handler(struct ex_regs *regs)
+{
+	ud_count++;
+	regs->rip += 3; /* VMLAUNCH */
+}
+
 void l2_guest_code(void)
 {
 	GUEST_SYNC(7);
@@ -71,11 +79,11 @@ void guest_code(struct vmx_pages *vmx_pages)
 	if (vmx_pages)
 		l1_guest_code(vmx_pages);
 
-	GUEST_DONE();
-
 	/* Try enlightened vmptrld with an incorrect GPA */
 	evmcs_vmptrld(0xdeadbeef, vmx_pages->enlightened_vmcs);
 	GUEST_ASSERT(vmlaunch());
+	GUEST_ASSERT(ud_count == 1);
+	GUEST_DONE();
 }
 
 int main(int argc, char *argv[])
@@ -109,6 +117,10 @@ int main(int argc, char *argv[])
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
 
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+
 	for (stage = 1;; stage++) {
 		_vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
@@ -124,7 +136,7 @@ int main(int argc, char *argv[])
 		case UCALL_SYNC:
 			break;
 		case UCALL_DONE:
-			goto part1_done;
+			goto done;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
@@ -156,10 +168,6 @@ int main(int argc, char *argv[])
 			    (ulong) regs2.rdi, (ulong) regs2.rsi);
 	}
 
-part1_done:
-	_vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
-		    "Unexpected successful VMEnter with invalid eVMCS pointer!");
-
+done:
 	kvm_vm_free(vm);
 }
-- 
2.30.2

