Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997A71A0150
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 00:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgDFWz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 18:55:57 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45434 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFWz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 18:55:57 -0400
Received: by mail-pg1-f202.google.com with SMTP id v29so848919pgo.12
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 15:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HchK6g06mh8s+da573UNFqQlTVJHJhRQ30qDIQLe3NY=;
        b=JPpPHVKt1DFMxGmMCV0mDxSNU898AhK4KlDkAKc1nm+EwhmjCpOV/AFvD6PARezFZJ
         dfX37IbAdLorbILAD38uU0X7yk47n5aSzxrwTsEpZGSHevtSfQ00qGyY6DvFDYNIpzED
         dG0hWbvaQWoVmv9t2X/o/fLB3YJbC+jn3DAaFEhPDY4ts0oS8a9Qt4uYK4oq64RjUiTi
         p/DnvewQHbUwflpJZx4NGP+pFOHPQQBNIRXOZ+tRWf1KBTTqS6k+IeHESVcEWQH00857
         sWLJpZb7DPFVdKzzwyTOlD9h8KnFRKzlHJ3b4fiKycNfFrbZVRpKoVaYFTPWpG685tVI
         8hmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HchK6g06mh8s+da573UNFqQlTVJHJhRQ30qDIQLe3NY=;
        b=S9D5mGxItTd0hylbsNgvbDQl9qlCZ3pG/8jvg1k/uPFVfGwNO9D1cz1bTwxJe4EftX
         l/sXrPNFT6RMVPfag4GWJ6eDILkk0U8rwLjfs3mVQJLzQLkP/X2FqKGRla9d9mHtxQg0
         jt5c9DPvO3Utuf22xx9Aje0Nr9z24pA+6OOUxm7JXBA+A10rKkZrj2hIfFjlOcFhz61w
         3vzJDnUhm93/I7VkM8LIx81F71ka4lN2HxW3XH2xiFDzU2GHsM2lQjZBeXAWb+4d0w3U
         bHhPPRpPvJt9VlHht21nYFnsu2NwpbvDgN+F+NO3iT/vlMaYvd+CYlPeaLKmnuQk/6Hf
         3RWA==
X-Gm-Message-State: AGi0PuYIfrGC2DTq6Nos+P3iiEVzxn69TcHhmsB0xJ/nDpFghPKPCCkJ
        L1DLm7obZuccOlnWqJEKHDQuSLoAWcyQBgDUjH1ks7/PnLpvDc/+YT8RBBr1yFW91hgwC1DqODj
        ndfI6BWzQdTBG8ZtQ9cp9/WwFsb0k4x6a1hXdV5hKmiGGRSnDl9n6owfhncZ15UHZ14xA4yo=
X-Google-Smtp-Source: APiQypLjhDonwTcguvQhyOxamfNR3JEmdQEgUJRrbdsrSzknHC9S1ze1is2UrwHUkkD+SjFsf9RvTjQzApeLXm5hPQ==
X-Received: by 2002:a17:90a:f00b:: with SMTP id bt11mr1710191pjb.71.1586213753919;
 Mon, 06 Apr 2020 15:55:53 -0700 (PDT)
Date:   Mon,  6 Apr 2020 15:55:37 -0700
Message-Id: <20200406225537.48082-1-brigidsmith@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [kvm-unit-tests PATCH] x86: gtests: add new test for vmread/vmwrite
 flags preservation
From:   Simon Smith <brigidsmith@google.com>
To:     kvm@vger.kernel.org
Cc:     Simon Smith <brigidsmith@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
vmread should not set rflags to specify success in case of #PF")

The two new tests force a vmread and a vmwrite on an unmapped
address to cause a #PF and verify that the low byte of %rflags is
preserved and that %rip is not advanced.  The cherry-pick fixed a
bug in vmread, but we include a test for vmwrite as well for
completeness.

Before the aforementioned commit, the ALU flags would be incorrectly
cleared and %rip would be advanced (for vmread).

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Simon Smith <brigidsmith@google.com>
---
 x86/vmx.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index 647ab49408876..e9235ec4fcad9 100644
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
@@ -368,6 +369,122 @@ static void test_vmwrite_vmread(void)
 	free_page(vmcs);
 }
 
+ulong finish_fault;
+u8 sentinel;
+bool handler_called;
+static void pf_handler(struct ex_regs *regs)
+{
+	// check that RIP was not improperly advanced and that the
+	// flags value was preserved.
+	report("RIP has not been advanced!",
+		regs->rip < finish_fault);
+	report("The low byte of RFLAGS was preserved!",
+		((u8)regs->rflags == ((sentinel | 2) & 0xd7)));
+
+	regs->rip = finish_fault;
+	handler_called = true;
+
+}
+
+static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
+{
+	// get an unbacked address that will cause a #PF
+	*vpage = alloc_vpage();
+
+	// set up VMCS so we have something to read from
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
+	// set the proper label
+	extern char finish_read_fault;
+
+	finish_fault = (ulong)&finish_read_fault;
+
+	// execute the vmread instruction that will cause a #PF
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmread %[enc], %[val]; finish_read_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah"
+		      );
+	report("The #PF handler was invoked", handler_called);
+
+	// restore old #PF handler
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmread_flags_touch(void)
+{
+	// set up the sentinel value in the flags register. we
+	// choose these two values because they candy-stripe
+	// the 5 flags that sahf sets.
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
+	// set the proper label
+	extern char finish_write_fault;
+
+	finish_fault = (ulong)&finish_write_fault;
+
+	// execute the vmwrite instruction that will cause a #PF
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmwrite %[val], %[enc]; finish_write_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah"
+		      );
+	report("The #PF handler was invoked", handler_called);
+
+	// restore old #PF handler
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmwrite_flags_touch(void)
+{
+	// set up the sentinel value in the flags register. we
+	// choose these two values because they candy-stripe
+	// the 5 flags that sahf sets.
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
@@ -1994,6 +2111,10 @@ int main(int argc, const char *argv[])
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
2.26.0.292.g33ef6b2f38-goog

