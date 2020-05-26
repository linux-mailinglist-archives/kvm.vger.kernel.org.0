Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116891A8DFB
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 23:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733042AbgDNVre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 17:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728094AbgDNVre (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 17:47:34 -0400
Received: from mail-vk1-xa4a.google.com (mail-vk1-xa4a.google.com [IPv6:2607:f8b0:4864:20::a4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35F3C061A0E
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 14:47:33 -0700 (PDT)
Received: by mail-vk1-xa4a.google.com with SMTP id r141so832388vke.10
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 14:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q9VWneTARaSpEeqpvNS9sbRvLulbvH9sc0Nr1tReClA=;
        b=JdAueOO+3ZCjbFNV5v4z0SXow0yHMkMQ9rZP23u0W3w2VJnR/blzoMSvyhX0fVxj49
         HwFGtyUNnYn+lId93VNEb+IYi4NrUR07MD/aVl2i5TQMtQyoDVEfFupznKN8u7ayzfhq
         s40u0775XDOk9u7o3sf97qfWqrePu4+lWvI6lBwq9CAV7pSZ88P+FXgnimHJEIjMmpxy
         JpzKJmHXJwSmtvWUYWw+seK7xNWFojJlvElWZE2tN/hIZL3ESKrbaC9JfXm1bW04dJx6
         MxgvAcfsO1Vozzr6fyf4ZNC5TFyLwC/C1PmBAKMTxWexkHF5CJUrxweYcfUXtjqO0VYg
         Barg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q9VWneTARaSpEeqpvNS9sbRvLulbvH9sc0Nr1tReClA=;
        b=qYoZJ3eZQMzX3cRhMHncASoEbg+yba1urNgrbKrtsJEv3pUo8WPfdJpj91TOOwdFOc
         AE1JRVy92CX8UKh8jOCcOVxpD4LOFu6hGXV8hlR6/Gn5FAb7k2r6hU+VSBRUqlPvZb2n
         pH/7Kz6nUsonuz5tZjR/qA14rUm/08i4c0zsjOi+HSiIK6H8zQmnajtmc1D/8ejOCbHx
         uPUDNJ/saDYH0DZaAA09ze++TlAyEJPr7TN/rsyJhZz4TTIHH6OOqnV0FzxsU7binDza
         jDdmaWybHhjXVveAiglg9cuZC1c7qCspDsCrkJkBAMD2kfVr+wGZ5o+9iczgGeMATZgT
         cq5A==
X-Gm-Message-State: AGi0PuZByAVVxXJ2yT+owVdKA67xndDYV0Ksu5tBAsktm9NPQj1/eyYQ
        HuZpq8T5b9OH/1X6HMD59w/Beyw94NFYRpAyosb5+bXjyjfzN+PVXZKdPslhmy9Xrmd64d0FTAj
        ELs16yv0fixaF/a5f89Hh+40LE2OaL0I85eMUkWAGIIzI0b7uNF/7L+h3Cw==
X-Google-Smtp-Source: APiQypL1GZh5+2OZI5rfeBPrqiyXR586irZyd8E2Ni/4ecOto9JhHaJNrKVkPqtmpf5FtM0UxrjLd53U/+s=
X-Received: by 2002:a67:1107:: with SMTP id 7mr2103723vsr.144.1586900852895;
 Tue, 14 Apr 2020 14:47:32 -0700 (PDT)
Date:   Tue, 14 Apr 2020 21:46:36 +0000
In-Reply-To: <20200414214634.126508-1-oupton@google.com>
Message-Id: <20200414214634.126508-2-oupton@google.com>
Mime-Version: 1.0
References: <20200414214634.126508-1-oupton@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: test MTF VM-exit event injection
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SDM 26.6.2 describes how the VM-entry interruption-information field
may be configured to inject an MTF VM-exit upon VM-entry. Ensure that an
MTF VM-exit occurs when the VM-entry interruption-information field is
configured appropriately by the host.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 Parent commit: b16df9e ("arch-run: Add reserved variables to the default environ")
 x86/vmx_tests.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1f97fe3..a91715f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4964,6 +4964,7 @@ static void test_vmx_preemption_timer(void)
 extern unsigned char test_mtf1;
 extern unsigned char test_mtf2;
 extern unsigned char test_mtf3;
+extern unsigned char test_mtf4;
 
 static void test_mtf_guest(void)
 {
@@ -4992,7 +4993,10 @@ static void test_mtf_guest(void)
 	      * documented, don't rely on assemblers enumerating the
 	      * instruction. Resort to hand assembly.
 	      */
-	     ".byte 0xf1;\n\t");
+	     ".byte 0xf1;\n\t"
+	     "vmcall;\n\t"
+	     "test_mtf4:\n\t"
+	     "mov $0, %eax;\n\t");
 }
 
 static void test_mtf_gp_handler(struct ex_regs *regs)
@@ -5037,7 +5041,7 @@ static void report_mtf(const char *insn_name, unsigned long exp_rip)
 	unsigned long rip = vmcs_read(GUEST_RIP);
 
 	assert_exit_reason(VMX_MTF);
-	report(rip == exp_rip, "MTF VM-exit after %s instruction. RIP: 0x%lx (expected 0x%lx)",
+	report(rip == exp_rip, "MTF VM-exit after %s. RIP: 0x%lx (expected 0x%lx)",
 	       insn_name, rip, exp_rip);
 }
 
@@ -5114,7 +5118,12 @@ static void vmx_mtf_test(void)
 	disable_mtf();
 
 	enter_guest();
+	skip_exit_vmcall();
 	handle_exception(DB_VECTOR, old_db);
+	vmcs_write(ENT_INTR_INFO, INTR_INFO_VALID_MASK | INTR_TYPE_OTHER_EVENT);
+	enter_guest();
+	report_mtf("injected MTF", (unsigned long) &test_mtf4);
+	enter_guest();
 }
 
 /*
-- 
2.26.0.110.g2183baf09c-goog

