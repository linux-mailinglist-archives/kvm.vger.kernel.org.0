Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401C51B13C5
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgDTR7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 13:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgDTR7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 13:59:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A97C061A0C
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 10:59:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y73so4717784ybe.22
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 10:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FNiVif2OGs+DEb/0JGe/lmn9AvD2UyqpmhDBJ0M7DiI=;
        b=BdBtj6dAXNTjrn5LHd5QUsXYKI5HfnUqrgXaaL6L1AzEhlw/0PANMnlRu1dQC7kCVb
         wQxAYz3VcbwD4ehXOwkfzOBfqEMwNtE/1uSS06Mb4DfJ8K7PcmGcuWMDp2ClBKwm+62C
         irTHKpGA7iUUtcgaarriZx4uHctZoY+8dsENgR0m536/NJZfHFN+5r2x4YC4JyI8MNzb
         ldcxVZKpOuKsOZp2CVkFTxhhYv+r1b2qsPao4EDIZJ7DnOdNluAww1K8GILXNo3xXtWD
         GQ3jjOWDoDGoPuGQUTgcdmUTxGp493zsxkkDbDimIjye0CaMm9C8NeAVL5GRyFHaR+nG
         6/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FNiVif2OGs+DEb/0JGe/lmn9AvD2UyqpmhDBJ0M7DiI=;
        b=VMNwLk3S4f6CSUnByhfaHs9eh3cFjWuuDWoI5X0hYbXaX9p5T1/gJERYZfMNJuiSA9
         Hw/BqPbA6E3/UU5CiL5p0NdblTLHnzRDWO6gosIpPytsxY4ZWMwhcARuab7p3Hi35jja
         kZuvnnK7p74AHQFeskpy2FPVk/gqOiMw0El1j72HSD4P2ARqIyFxkCOMBUyDu8kxj5am
         34ROBBJ9iRznEPGqSjJFbe9jS0EYOwEZ06pmqRRkArUvbKONI0Yz5aL0EpRQKzxkmPY4
         nAQ54Mfi9zhD2UspqTx/A2vMFG6gnyhjvSB+tsSUlzKsGU0Kl14RlOWOao8OEdFZoVeN
         TkMg==
X-Gm-Message-State: AGi0Puaz10O4JVWlxoji8Ac6MW5SfLJybdbXGqIiaYNhFitEdRtUVNxk
        8pgnh4U5a7ElMAoUu1wgySt1/NQggs8gUURFAM7MqtrC7RPl5fJGuZnFuVPaLNch+hOult4rPNg
        Ut4jyTyxZL2gHOrWVUKfskqAY2Fr2qcEGGhdL8G8E5kcBsu2zO6SOKOTF7tmHYZ9w0bVW2p0=
X-Google-Smtp-Source: APiQypJTSwql/zEgDxhAIO0C/xVMA0IBQfDwR9/++glCbi3BtIbmXdnSBP6nkiPrh1FdWrod08wMdfR5p1stG2PZ4Q==
X-Received: by 2002:a25:5057:: with SMTP id e84mr19773139ybb.198.1587405560005;
 Mon, 20 Apr 2020 10:59:20 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:58:34 -0700
Message-Id: <20200420175834.258122-1-brigidsmith@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [kvm-unit-tests PATCH v3] x86: nVMX: add new test for vmread/vmwrite
 flags preservation
From:   Simon Smith <brigidsmith@google.com>
To:     kvm@vger.kernel.org
Cc:     Simon Smith <brigidsmith@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
vmread should not set rflags to specify success in case of #PF")

The two new tests force a vmread and a vmwrite on an unmapped
address to cause a #PF and verify that the low byte of %rflags is
preserved and that %rip is not advanced.  The commit fixed a
bug in vmread, but we include a test for vmwrite as well for
completeness.

Before the aforementioned commit, the ALU flags would be incorrectly
cleared and %rip would be advanced (for vmread).

Signed-off-by: Simon Smith <brigidsmith@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 x86/vmx.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index 4c47eec1a1597..cbe68761894d4 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -32,6 +32,7 @@
 #include "processor.h"
 #include "alloc_page.h"
 #include "vm.h"
+#include "vmalloc.h"
 #include "desc.h"
 #include "vmx.h"
 #include "msr.h"
@@ -387,6 +388,141 @@ static void test_vmwrite_vmread(void)
 	free_page(vmcs);
 }
 
+ulong finish_fault;
+u8 sentinel;
+bool handler_called;
+
+static void pf_handler(struct ex_regs *regs)
+{
+	/*
+	 * check that RIP was not improperly advanced and that the
+	 * flags value was preserved.
+	 */
+	report(regs->rip < finish_fault, "RIP has not been advanced!");
+	report(((u8)regs->rflags == ((sentinel | 2) & 0xd7)),
+	       "The low byte of RFLAGS was preserved!");
+	regs->rip = finish_fault;
+	handler_called = true;
+
+}
+
+static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
+{
+	/*
+	 * get an unbacked address that will cause a #PF
+	 */
+	*vpage = alloc_vpage();
+
+	/*
+	 * set up VMCS so we have something to read from
+	 */
+	*vmcs = alloc_page();
+
+	memset(*vmcs, 0, PAGE_SIZE);
+	(*vmcs)->hdr.revision_id = basic.revision;
+	assert(!vmcs_clear(*vmcs));
+	assert(!make_vmcs_current(*vmcs));
+
+	*old = handle_exception(PF_VECTOR, &pf_handler);
+}
+
+static void test_read_sentinel(void)
+{
+	void *vpage;
+	struct vmcs *vmcs;
+	handler old;
+
+	prep_flags_test_env(&vpage, &vmcs, &old);
+
+	/*
+	 * set the proper label
+	 */
+	extern char finish_read_fault;
+
+	finish_fault = (ulong)&finish_read_fault;
+
+	/*
+	 * execute the vmread instruction that will cause a #PF
+	 */
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmread %[enc], %[val]; finish_read_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah");
+	report(handler_called, "The #PF handler was invoked");
+
+	/*
+	 * restore the old #PF handler
+	 */
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmread_flags_touch(void)
+{
+	/*
+	 * set up the sentinel value in the flags register. we
+	 * choose these two values because they candy-stripe
+	 * the 5 flags that sahf sets.
+	 */
+	sentinel = 0x91;
+	test_read_sentinel();
+
+	sentinel = 0x45;
+	test_read_sentinel();
+}
+
+static void test_write_sentinel(void)
+{
+	void *vpage;
+	struct vmcs *vmcs;
+	handler old;
+
+	prep_flags_test_env(&vpage, &vmcs, &old);
+
+	/*
+	 * set the proper label
+	 */
+	extern char finish_write_fault;
+
+	finish_fault = (ulong)&finish_write_fault;
+
+	/*
+	 * execute the vmwrite instruction that will cause a #PF
+	 */
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmwrite %[val], %[enc]; finish_write_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah");
+	report(handler_called, "The #PF handler was invoked");
+
+	/*
+	 * restore the old #PF handler
+	 */
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmwrite_flags_touch(void)
+{
+	/*
+	 * set up the sentinel value in the flags register. we
+	 * choose these two values because they candy-stripe
+	 * the 5 flags that sahf sets.
+	 */
+	sentinel = 0x91;
+	test_write_sentinel();
+
+	sentinel = 0x45;
+	test_write_sentinel();
+}
+
+
 static void test_vmcs_high(void)
 {
 	struct vmcs *vmcs = alloc_page();
@@ -1988,6 +2124,10 @@ int main(int argc, const char *argv[])
 		test_vmcs_lifecycle();
 	if (test_wanted("test_vmx_caps", argv, argc))
 		test_vmx_caps();
+	if (test_wanted("test_vmread_flags_touch", argv, argc))
+		test_vmread_flags_touch();
+	if (test_wanted("test_vmwrite_flags_touch", argv, argc))
+		test_vmwrite_flags_touch();
 
 	/* Balance vmxon from test_vmxon. */
 	vmx_off();
-- 
2.26.1.301.g55bc3eb7cb9-goog

