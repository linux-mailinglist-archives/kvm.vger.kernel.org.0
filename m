Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4519E53C322
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbiFCAsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240286AbiFCApr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2FA344DD
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:46 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z16-20020a17090a015000b001dbc8da29a1so3397954pje.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8VTDN8kUgX/CTxSlXR8a6F78HmGtCBAZAqm9YtQdysQ=;
        b=Z4JQYNSPiXKMkTcHWJi6X9AQRjgwTHpuiKPXCO8XIqgSdq3RT2aVAPdwcqqFF5+EZ7
         jS6qjgXPdTYOFAAQS8nWgmT2r374GGHQj+T3t9SqJCgQ6FnfIKDNQNBh1AgSs8l1822N
         ADnH7aysGVXufWsSStgt4wFr518covfbBD0svb84PPnoBYnOsXZxsrQloB5YSMUk6fAp
         jTnNxY4tTeeKrDpD4BNZJCW0FA6KI7C6hdTiPL2G3/bz2DSluRgBYeB6i3gLEXQX4Dsj
         35/UxB3tMrAZR1ydGOWp5CDWrC+PVaD02Drs2HAjlPQxWsduGkVjVQinPJv1sKh3XvhH
         C8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8VTDN8kUgX/CTxSlXR8a6F78HmGtCBAZAqm9YtQdysQ=;
        b=50pJNDb9E4vlEJQLzVqwdYqupEqQFHeEBC1uWo6xod9jzQtGWdMPz0w0yXCEa0WfxO
         G6vATZjL34kfq38xM+6d1nkFz4NgXevI48BXhhj16Qd7lUcflOu6DBVT81JGlsZvMh/K
         P9EQGD/B0zVV3TnqQxtAj/q5cnxYyWUSJ4WZKIQHMHTO++wlqCEpaKlVdioLgM7x4vXe
         345eniCZtRA+PhKLjgx32rw3S27D1JW8d9PticAeyTbc25EX5MhQncIrJVtDBBmqZOjX
         HlMfOX8wSRLaH7W2UhMzzs/2+wfjFGwObiHtvSGMxhLLpsLs+i9KmlFHCNW1WfkNHnUB
         oAvQ==
X-Gm-Message-State: AOAM533po+kkdrVDUmhpqWIkHA4Gn5017GrsqlAwSgqHdNfipDyfLQdo
        VI71J/dcDdUccfzI/mDI0n+1uWcUVU0=
X-Google-Smtp-Source: ABdhPJxbwhAP6T1NPRgJBVvqIfDOWJj7K2wdc4rhn4Fq1FWQ9QdDsNO6pLlI/Wz3u1ENyqfhW9Tx0DvLJ5U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:88d2:0:b0:50a:cf7d:6ff1 with SMTP id
 k18-20020aa788d2000000b0050acf7d6ff1mr7869004pff.67.1654217146237; Thu, 02
 Jun 2022 17:45:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:18 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-72-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 071/144] KVM: selftests: Convert vmx_apic_access_test away
 from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert vmx_apic_access_test to use vm_create_with_one_vcpu() and pass
around a 'struct kvm_vcpu' object instead of using a global VCPU_ID.

Opportunistically make the "vm" variable local, it is unused outside of
main().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/vmx_apic_access_test.c          | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index d438c4d3228a..10f9c86029e6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -28,11 +28,6 @@
 
 #include "kselftest.h"
 
-#define VCPU_ID		0
-
-/* The virtual machine object. */
-static struct kvm_vm *vm;
-
 static void l2_guest_code(void)
 {
 	/* Exit to L1 */
@@ -84,9 +79,12 @@ int main(int argc, char *argv[])
 	struct vmx_pages *vmx;
 	bool done = false;
 
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
 	nested_vmx_check_supported();
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
 	kvm_get_cpu_address_width(&paddr_width, &vaddr_width);
 	high_gpa = (1ul << paddr_width) - getpagesize();
@@ -97,13 +95,13 @@ int main(int argc, char *argv[])
 
 	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	prepare_virtualize_apic_accesses(vmx, vm);
-	vcpu_args_set(vm, VCPU_ID, 2, vmx_pages_gva, high_gpa);
+	vcpu_args_set(vm, vcpu->id, 2, vmx_pages_gva, high_gpa);
 
 	while (!done) {
-		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 		if (apic_access_addr == high_gpa) {
 			TEST_ASSERT(run->exit_reason ==
 				    KVM_EXIT_INTERNAL_ERROR,
@@ -121,7 +119,7 @@ int main(int argc, char *argv[])
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
 				  __FILE__, uc.args[1]);
-- 
2.36.1.255.ge46751e96f-goog

