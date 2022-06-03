Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370FF53C1CE
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbiFCA6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240492AbiFCAsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:48:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0E911C31
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:55 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n8-20020a170903110800b001636d9ff4f8so3482820plh.11
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bRAEwwd8ey3z9X0VEPjYYsn1VMfgDNaL8F4OeDoloP0=;
        b=Arg0yMzCSRhXWx5g47HlADiMEEAhXGQy2wM6eA+W7ss2alARZOfckQvP8kSb/+bqXP
         YPkpWo2LI8aDK2trmSi3k/yY7y99HAG3VCuxPPcty7MH6r3FISy+JF26saPblgwI7lSc
         7wG+gNr1FsOY3pWI4Hn1nyIQY7HIzbZLXyLOhq3HBB4/fPkVw6SCGLlPfbnMv3i3sfLT
         6qFWiTHxJq9WEdYdV3PaXjJVfuHa2JsTtyAWY5ZXZQoeGtxeS580If7ypRYhRDAm9L9I
         Oa9WHbbghr72+H/Dancwa9rgouJKrYMF2g6D0vc3iTkqPoMaK3HZTdoDXlVwCuCxrR0l
         tSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bRAEwwd8ey3z9X0VEPjYYsn1VMfgDNaL8F4OeDoloP0=;
        b=yYfQPLaB11gdr4iqtBiMK/hwBiLZT2OsweU30kYRFRjcUy6ixaz6Dy19BIuc7RUKSj
         CI+05HKNfH9hFYdAaQVS9YYa9h5YSuKUNWPMYRaiZGzZr0MSR4RBS4r81NIEXPwfmHMk
         tt+rAs/avAIy71Q1r5IT8bw1R2aGzzMjgY4XzuqoMHQ+45I6DtIh/p/zeqOiXjNSAnGv
         4d+OfqC4eWdi02mMj4HegHSEz/AoI/UhU3Fghgp09m4Gb6hVZSshiNaSuoicD3ABJVWr
         Kouzn3yuLGq7AoR+Dv1XGjtbUrWiOb0/JJXm6sM79K0f8URuWLFwO+jDCHrWcx9XBs3v
         xhQg==
X-Gm-Message-State: AOAM5335xoltowYzbWqlmPR4+um+ILa5h/tby6ruWoF9SnrDw8/nqH0/
        mld/LjZq1iBcTmj1/KAIwvTJJ8XvzcA=
X-Google-Smtp-Source: ABdhPJyPeWXaOSdzs/Zkbt6Y4IE87D1ZIMazf/pmmoIdw8biRGyfNLIJWPcdF4k9KgOrDAUZYUydDomfzbg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1952:b0:518:9fbd:ff7a with SMTP id
 s18-20020a056a00195200b005189fbdff7amr7576373pfk.77.1654217214929; Thu, 02
 Jun 2022 17:46:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:57 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-111-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 110/144] KVM: selftests: Convert triple_fault_event_test
 away from VCPU_ID
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

Convert triple_fault_event_test to use vm_create_with_one_vcpu() and pull
the vCPU's ID from 'struct kvm_vcpu'.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/triple_fault_event_test.c      | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 68e0f1c5ec5a..2b0f19ddbc8b 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -9,7 +9,6 @@
 
 #include "kselftest.h"
 
-#define VCPU_ID			0
 #define ARBITRARY_IO_PORT	0x2000
 
 /* The virtual machine object. */
@@ -41,6 +40,7 @@ void l1_guest_code(struct vmx_pages *vmx)
 
 int main(void)
 {
+	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vcpu_events events;
 	vm_vaddr_t vmx_pages_gva;
@@ -56,13 +56,13 @@ int main(void)
 		exit(KSFT_SKIP);
 	}
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	vm_enable_cap(vm, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 1);
 
-	run = vcpu_state(vm, VCPU_ID);
+	run = vcpu->run;
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
-	vcpu_run(vm, VCPU_ID);
+	vcpu_args_set(vm, vcpu->id, 1, vmx_pages_gva);
+	vcpu_run(vm, vcpu->id);
 
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 		    "Expected KVM_EXIT_IO, got: %u (%s)\n",
@@ -70,21 +70,21 @@ int main(void)
 	TEST_ASSERT(run->io.port == ARBITRARY_IO_PORT,
 		    "Expected IN from port %d from L2, got port %d",
 		    ARBITRARY_IO_PORT, run->io.port);
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vm, vcpu->id, &events);
 	events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
 	events.triple_fault.pending = true;
-	vcpu_events_set(vm, VCPU_ID, &events);
+	vcpu_events_set(vm, vcpu->id, &events);
 	run->immediate_exit = true;
-	vcpu_run_complete_io(vm, VCPU_ID);
+	vcpu_run_complete_io(vm, vcpu->id);
 
-	vcpu_events_get(vm, VCPU_ID, &events);
+	vcpu_events_get(vm, vcpu->id, &events);
 	TEST_ASSERT(events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT,
 		    "Triple fault event invalid");
 	TEST_ASSERT(events.triple_fault.pending,
 		    "No triple fault pending");
-	vcpu_run(vm, VCPU_ID);
+	vcpu_run(vm, vcpu->id);
 
-	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	switch (get_ucall(vm, vcpu->id, &uc)) {
 	case UCALL_DONE:
 		break;
 	case UCALL_ABORT:
-- 
2.36.1.255.ge46751e96f-goog

