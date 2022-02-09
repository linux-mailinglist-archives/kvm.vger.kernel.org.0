Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6554AF7F0
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiBIRSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiBIRSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B440C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644427095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZHqCWeznLA/b2BCdTxSEDLYeb340DyvFnRih4TbEbVY=;
        b=Q4ftzA7wkwg0nFRguJch4i4HAZ0ogCgns1JQIcnFSBQ+9V07qWAB3qidxEamqKNZESOXhN
        OsdCyiYpqbVUP0Y40pIhcX8G6U6jcFpjXmop9JfQ9coi1EeRerNQOa0Qwb9589Th3ET0iK
        E53QoT3HNvkxpToFnPM9mNfC7PdsQVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-DAbkv6OBMeKGxFwilnpFow-1; Wed, 09 Feb 2022 12:18:14 -0500
X-MC-Unique: DAbkv6OBMeKGxFwilnpFow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 495A08143E5
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:18:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18A937CD66
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:18:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] vmexit: add test toggling CR0.WP and CR4.PGE
Date:   Wed,  9 Feb 2022 12:18:12 -0500
Message-Id: <20220209171812.1785257-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CR0.WP changes the MMU permissions but does not cause a TLB flush;
CR4.PGE is the opposite (at least as far as KVM as concerned).

This makes both of them interesting from a performance perspective,
so add new vmexit tests.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c      |  3 +++
 x86/unittests.cfg | 12 ++++++++++++
 x86/vmexit.c      | 16 ++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/x86/access.c b/x86/access.c
index 83c8221..21b4d74 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -251,6 +251,9 @@ static void set_cr0_wp(int wp)
 static void clear_user_mask(pt_element_t *ptep, int level, unsigned long virt)
 {
 	*ptep &= ~PT_USER_MASK;
+
+	/* Flush to avoid spurious #PF */
+	invlpg((void*)virt);
 }
 
 static void set_user_mask(pt_element_t *ptep, int level, unsigned long virt)
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 62a6692..cef09d2 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -118,6 +118,18 @@ file = vmexit.flat
 groups = vmexit
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 
+[vmexit_cr0_wp]
+file = vmexit.flat
+smp = 2
+extra_params = -append 'toggle_cr0_wp'
+groups = vmexit
+
+[vmexit_cr4_pge]
+file = vmexit.flat
+smp = 2
+extra_params = -append 'toggle_cr4_pge'
+groups = vmexit
+
 [access]
 file = access_test.flat
 arch = x86_64
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 8cfb36b..4adec78 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -20,6 +20,7 @@ struct test {
 #define GOAL (1ull << 30)
 
 static int nr_cpus;
+static u64 cr4_shadow;
 
 static void cpuid_test(void)
 {
@@ -459,6 +460,18 @@ static void wr_ibpb_msr(void)
 	wrmsr(MSR_IA32_PRED_CMD, 1);
 }
 
+static void toggle_cr0_wp(void)
+{
+	write_cr0(X86_CR0_PE|X86_CR0_PG);
+	write_cr0(X86_CR0_PE|X86_CR0_WP|X86_CR0_PG);
+}
+
+static void toggle_cr4_pge(void)
+{
+	write_cr4(cr4_shadow ^ X86_CR4_PGE);
+	write_cr4(cr4_shadow);
+}
+
 static struct test tests[] = {
 	{ cpuid_test, "cpuid", .parallel = 1,  },
 	{ vmcall, "vmcall", .parallel = 1, },
@@ -492,6 +505,8 @@ static struct test tests[] = {
 	{ wr_ibpb_msr, "wr_ibpb_msr", has_ibpb, .parallel = 1 },
 	{ wr_tsc_adjust_msr, "wr_tsc_adjust_msr", .parallel = 1 },
 	{ rd_tsc_adjust_msr, "rd_tsc_adjust_msr", .parallel = 1 },
+	{ toggle_cr0_wp, "toggle_cr0_wp" , .parallel = 1, },
+	{ toggle_cr4_pge, "toggle_cr4_pge" , .parallel = 1, },
 	{ NULL, "pci-mem", .parallel = 0, .next = pci_mem_next },
 	{ NULL, "pci-io", .parallel = 0, .next = pci_io_next },
 };
@@ -580,6 +595,7 @@ int main(int ac, char **av)
 	int ret;
 
 	setup_vm();
+	cr4_shadow = read_cr4();
 	handle_irq(IPI_TEST_VECTOR, self_ipi_isr);
 	nr_cpus = cpu_count();
 
-- 
2.31.1

