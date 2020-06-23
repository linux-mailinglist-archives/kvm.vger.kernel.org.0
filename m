Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D48204DC2
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbgFWJUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:20:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731938AbgFWJUu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592904048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s16NwfI3JixQk4P13nqbgQj1Gxhu5uAf3M2pBFtoqOo=;
        b=IO+i6TN6uOM8fn+dG7k5JBvSTtw/vACm31sBK3SJuwW5DWaY6gpPoWLrN0B04wYjqsw8tF
        FLvlqJiD1tKCRcJL3cBMHM4wCYhL+MoEOqUYB6yVzhJOjH3i67dUY5IiLF9RNwt0IePLEK
        tjxBjK4a8v8SR1ml8ItrvmxgWig/8ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-yRmnP8n9OHmejooAZeBd9A-1; Tue, 23 Jun 2020 05:20:47 -0400
X-MC-Unique: yRmnP8n9OHmejooAZeBd9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37EF0464;
        Tue, 23 Jun 2020 09:20:46 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF6CA5C541;
        Tue, 23 Jun 2020 09:20:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH kvm-unit-tests] vmx: remove unnecessary #ifdef __x86_64__
Date:   Tue, 23 Jun 2020 05:20:45 -0400
Message-Id: <20200623092045.271835-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMX tests are 64-bit only, so checking the architecture is
unnecessary.  Also, if the tests supported 32-bits environments
the #ifdef would probably go in test_canonical.

Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 48c5d48..4aae954 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -793,10 +793,8 @@ asm(
 	"insn_rdtsc: rdtsc;ret\n\t"
 	"insn_cr3_load: mov cr3,%rax; mov %rax,%cr3;ret\n\t"
 	"insn_cr3_store: mov %cr3,%rax;ret\n\t"
-#ifdef __x86_64__
 	"insn_cr8_load: xor %eax, %eax; mov %rax,%cr8;ret\n\t"
 	"insn_cr8_store: mov %cr8,%rax;ret\n\t"
-#endif
 	"insn_monitor: xor %eax, %eax; xor %ecx, %ecx; xor %edx, %edx; monitor;ret\n\t"
 	"insn_pause: pause;ret\n\t"
 	"insn_wbinvd: wbinvd;ret\n\t"
@@ -819,10 +817,8 @@ extern void insn_rdpmc(void);
 extern void insn_rdtsc(void);
 extern void insn_cr3_load(void);
 extern void insn_cr3_store(void);
-#ifdef __x86_64__
 extern void insn_cr8_load(void);
 extern void insn_cr8_store(void);
-#endif
 extern void insn_monitor(void);
 extern void insn_pause(void);
 extern void insn_wbinvd(void);
@@ -885,12 +881,10 @@ static struct insn_table insn_table[] = {
 		FIELD_EXIT_QUAL},
 	{"CR3 store", CPU_CR3_STORE, insn_cr3_store, INSN_CPU0, 28, 0x13, 0,
 		FIELD_EXIT_QUAL},
-#ifdef __x86_64__
 	{"CR8 load", CPU_CR8_LOAD, insn_cr8_load, INSN_CPU0, 28, 0x8, 0,
 		FIELD_EXIT_QUAL},
 	{"CR8 store", CPU_CR8_STORE, insn_cr8_store, INSN_CPU0, 28, 0x18, 0,
 		FIELD_EXIT_QUAL},
-#endif
 	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0, &monitor_supported},
 	{"PAUSE", CPU_PAUSE, insn_pause, INSN_CPU0, 40, 0, 0, 0},
 	// Flags for Secondary Processor-Based VM-Execution Controls
@@ -7603,14 +7597,12 @@ static void test_host_segment_regs(void)
 
 	vmcs_write(HOST_SEL_SS, selector_saved);
 
-#ifdef __x86_64__
 	/*
 	 * Base address for FS, GS and TR must be canonical
 	 */
 	test_canonical(HOST_BASE_FS, "HOST_BASE_FS", true);
 	test_canonical(HOST_BASE_GS, "HOST_BASE_GS", true);
 	test_canonical(HOST_BASE_TR, "HOST_BASE_TR", true);
-#endif
 }
 
 /*
@@ -7619,10 +7611,8 @@ static void test_host_segment_regs(void)
  */
 static void test_host_desc_tables(void)
 {
-#ifdef __x86_64__
 	test_canonical(HOST_BASE_GDTR, "HOST_BASE_GDTR", true);
 	test_canonical(HOST_BASE_IDTR, "HOST_BASE_IDTR", true);
-#endif
 }
 
 /*
@@ -7839,10 +7829,8 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_perf_global_ctrl();
 	test_load_guest_bndcfgs();
 
-#ifdef __x86_64__
 	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
 	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
-#endif
 
 	u32 guest_desc_limit_saved = vmcs_read(GUEST_LIMIT_GDTR);
 	TEST_GUEST_VMCS_FIELD_RESERVED_BITS(16, 31, 4, GUEST_LIMIT_GDTR,
-- 
2.26.2

