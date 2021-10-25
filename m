Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB43438ECC
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 07:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhJYFbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 01:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJYFbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 01:31:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77849C061745
        for <kvm@vger.kernel.org>; Sun, 24 Oct 2021 22:28:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c140-20020a624e92000000b0044d3de98438so5816766pfb.14
        for <kvm@vger.kernel.org>; Sun, 24 Oct 2021 22:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CTt27ibvZrCOrH5nDDNMkGDaa9yJWzJBxmtC5ngpNVI=;
        b=rIF2Mkllp/lzbDfJItjQpWGe51YLIJTeNGeCWkCQ2z+OQUrU5bkwJ+EvgfmFK3vN1f
         YjAWEL7CnWseYStBEda/XlDZzCgNFRyl4e6Hf4LO4cJULJ6Jlp1DQkJX2Di8sSc6XrDq
         UOrIo2epZ4f9ePSIU7TgiA9wSAuprC5fjcnsV8i/wnzzKWHjQBrpO5wUlasY5RUHOc6t
         1m/d1DjuKji8niu/wqfkJzj/0c1TOFg8bgUssy9ewRBnP5PI81OpcaT3wQMQvX3cqJPg
         +IKT5PMQov3nWSXrc0Lu9gYo0+RlucbGhZ0yrHwjvc+UHuHnsvYIL8GwFKDxLav/4BQg
         KwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CTt27ibvZrCOrH5nDDNMkGDaa9yJWzJBxmtC5ngpNVI=;
        b=g0bHv7wOIPAKN+izTAg8BJwozDdNjmXREQZMBAjGAu7/Gxh0TRIFuKYsaAXKtWhv0G
         u5/Az21g70/6I5hZUalC/iLEPLpZKF0+IY7+TJOoTvyrZTAARIuEijyo/BmdCdkLPt3+
         ZzGr7UFz/EkOf9k2yfJyddwCNUt4ic+PQu9oXBnaTa4juDQ54548Odzo5w0KFP5GYqva
         sLEW9nGmQOaQc4GqPioJ7+3Ef4luDt5xGdi8sh8cU25J2zRCOW+gk2KrIKmrHGvFslz0
         P/WDTJLHoD/Uh7XREIJ5AeWEgevFaQ1K2U46xVW5M5gCIZknK7ZXCYz6P5A7gq8LkAC6
         j73Q==
X-Gm-Message-State: AOAM5310dO3vQghYRnht66irelDy6CBZ5X6BtTiuwXPGQHvGYlzqRHsM
        uO6uu0miaNlV8rr3IAnxeLECrKnoZs8t
X-Google-Smtp-Source: ABdhPJzVOlb7myyniCYNrg52jYHLPd8SDPVNauBIpnSi4Y22dUcaPGXCPeKcVmxT8LDltKxk1pHVs+qukzAk
X-Received: from marcorr-linuxworkstation.sea.corp.google.com
 ([2620:15c:29:204:8bda:38c0:4ce3:e285]) (user=marcorr job=sendgmr) by
 2002:a05:6a00:22d4:b0:44d:1c39:a8d3 with SMTP id f20-20020a056a0022d400b0044d1c39a8d3mr16507565pfj.56.1635139722352;
 Sun, 24 Oct 2021 22:28:42 -0700 (PDT)
Date:   Sun, 24 Oct 2021 22:28:29 -0700
Message-Id: <20211025052829.2062623-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH] x86: SEV-ES: add port string IO test case
From:   Marc Orr <marcorr@google.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org, Thomas.Lendacky@amd.com,
        zxwang42@gmail.com, fwilhelm@google.com, seanjc@google.com,
        oupton@google.com, mlevitsk@redhat.com, pgonda@google.com,
        drjones@redhat.com
Cc:     Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test case to verify that string IO works as expected under SEV-ES.
This test case is based on the `test_stringio()` test case in emulator.c.
However, emulator.c does not currently run under UEFI.

Only the first half of the test case, which processes a string from
beginning to end, was taken for now. The second test case did not work
and is thus left out of the amd_sev.c setup for now.

Also, the first test case was modified to do port IO at word granularity
rather than byte granularity. The reason is to ensure that using the
port IO size in a calculation within the kernel does not multiply or
divide by 1. In particular, this tweak is useful to demonstrate that a
recent KVM patch [1] does not behave correctly.

* This patch is based on the `uefi` branch.

[1] https://patchwork.kernel.org/project/kvm/patch/20211013165616.19846-2-pbonzini@redhat.com/

Signed-off-by: Marc Orr <marcorr@google.com>
---
 x86/amd_sev.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 061c50514545..7757d4f85b7a 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -18,6 +18,10 @@
 #define EXIT_SUCCESS 0
 #define EXIT_FAILURE 1
 
+#define TESTDEV_IO_PORT 0xe0
+
+static char st1[] = "abcdefghijklmnop";
+
 static int test_sev_activation(void)
 {
 	struct cpuid cpuid_out;
@@ -65,11 +69,29 @@ static void test_sev_es_activation(void)
 	}
 }
 
+static void test_stringio(void)
+{
+	int st1_len = sizeof(st1) - 1;
+	u16 got;
+
+	asm volatile("cld \n\t"
+		     "movw %0, %%dx \n\t"
+		     "rep outsw \n\t"
+		     : : "i"((short)TESTDEV_IO_PORT),
+		         "S"(st1), "c"(st1_len / 2));
+
+	asm volatile("inw %1, %0\n\t" : "=a"(got) : "i"((short)TESTDEV_IO_PORT));
+
+	report((got & 0xff) == st1[sizeof(st1) - 3], "outsb nearly up");
+	report((got & 0xff00) >> 8 == st1[sizeof(st1) - 2], "outsb up");
+}
+
 int main(void)
 {
 	int rtn;
 	rtn = test_sev_activation();
 	report(rtn == EXIT_SUCCESS, "SEV activation test.");
 	test_sev_es_activation();
+	test_stringio();
 	return report_summary();
 }
-- 
2.33.0.1079.g6e70778dc9-goog

