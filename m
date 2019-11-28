Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5614110C63A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfK1Jy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:54:29 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39203 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfK1Jy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 04:54:28 -0500
Received: by mail-pf1-f202.google.com with SMTP id z2so15871321pfg.6
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 01:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=73thCkBPX2FDaxemBtAwlsmt1YdFFahmNunbm6OlhXA=;
        b=qS997IoyaKyuX8vAeEwryNr0YQfCT2kQsW6fDAbJSRDys/1RJ4FSh7/GuPkbWh2r5+
         CH9giMeuYCNfTHVFsA0shUhiNtlLoIb87rX6CEJrU++U5jKFFQnIR8u+8QAVXHeeCYtH
         ulxQB7BXNJsUfEsnA1xOriRJNMaroM5sXsUQPi4n8OMWD+AVLHbG9/rm0gAg0V5PD+7M
         DztF0T+YOhiYwiEdAwDky9hBYxIezR/t6mq7REndeljx7WnomwEAdORBhog/yVmPErgD
         oQLhpfIafi7ix+UNmjJcUWfZDRe3pAYxfINv8JCmnVLaIIcQROfM/CPctR2v8myf1E8Y
         Ho1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=73thCkBPX2FDaxemBtAwlsmt1YdFFahmNunbm6OlhXA=;
        b=QHVfnjtFO4Amxnyli+tiaTquT2DwQCFLdNM0oZY7lSfVEgAslGwcvJ7VlvU0whUAWP
         ym9ABwy+uMI9vckEJ8W103aeEZPiR5oRSAJ17qQgb2PDo1VKhYHJkqCCULMkuHhUeYnV
         tYIB6d7rLXMHyPbJCoQsLR7EJKUKhXHFCsJb3bjqXetgRZcpa+Pq2tZwBmfX5ULq3qYm
         cQsETwr9wHGtUYCQmoSR3Oe9jj+WwM5lhrH/c0XMsee2e0fDa5kzlTLOx10uSs3Kj4Wu
         ClcbVywJy62eQzYYycsVqlLxF3AW3BVgGDZe7V1HQLo3EgtV/rD5PsIpPsLJ6ClppiRQ
         ZbMQ==
X-Gm-Message-State: APjAAAW907Zzr61/ztBcyNdF8yHkEB/+sZrTz5NUF9ObHmCr62JplK1b
        tg+WiUeANe9QWhHiCRyhy4TuIRw/1JbfvJ9QY3r6AJusPphhT/+9eIPhby9JK9kvrVBabvM2fWu
        ZXB6nDWn0L0ejP/zc/wv0u7I7MMKLV+ekBN9PcHpZ3YlAqtKT8S6N58PXpQ==
X-Google-Smtp-Source: APXvYqwxYbkRGasT2EvGWOZ4/ON7b3DquXQZsXKljp3ze2dB3SXF3hn3mg272YlBsCB4oa67PN9s29cpOOM=
X-Received: by 2002:a63:1a22:: with SMTP id a34mr9728712pga.403.1574934866510;
 Thu, 28 Nov 2019 01:54:26 -0800 (PST)
Date:   Thu, 28 Nov 2019 01:54:22 -0800
Message-Id: <20191128095422.26757-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: Check EPT AD bits when enabled in ept_access_paddr()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify the test helper, ept_access_paddr(), to test the correctness
of the L1's EPT AD bits when enabled. After a successful guest access,
assert that the accessed bit (bit 8) has been set on all EPT entries
which were used in the translation of the guest-physical address.

Since ept_access_paddr() tests an EPT mapping that backs a guest paging
structure, processor accesses are treated as writes and the dirty bit
(bit 9) is set accordingly. Assert that the dirty bit is set on the leaf
EPT entry.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a456bd1..325dde7 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1135,6 +1135,11 @@ static void ept_disable_ad_bits(void)
 	vmcs_write(EPTP, eptp);
 }
 
+static int ept_ad_enabled(void)
+{
+	return eptp & EPTP_AD_FLAG;
+}
+
 static void ept_enable_ad_bits_or_skip_test(void)
 {
 	if (!ept_ad_bits_supported())
@@ -2500,6 +2505,8 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 	unsigned long *ptep;
 	unsigned long gpa;
 	unsigned long orig_epte;
+	unsigned long epte;
+	int i;
 
 	/* Modify the guest PTE mapping data->gva according to @pte_ad.  */
 	ptep = get_pte_level(current_page_table(), data->gva, /*level=*/1);
@@ -2536,6 +2543,17 @@ static void ept_access_paddr(unsigned long ept_access, unsigned long pte_ad,
 		do_ept_access_op(op);
 	} else {
 		do_ept_access_op(op);
+		if (ept_ad_enabled()) {
+			for (i = EPT_PAGE_LEVEL; i > 0; i--) {
+				TEST_ASSERT(get_ept_pte(pml4, gpa, i, &epte));
+				TEST_ASSERT(epte & EPT_ACCESS_FLAG);
+				if (i == 1)
+					TEST_ASSERT(epte & EPT_DIRTY_FLAG);
+				else
+					TEST_ASSERT_EQ(epte & EPT_DIRTY_FLAG, 0);
+			}
+		}
+
 		ept_untwiddle(gpa, /*level=*/1, orig_epte);
 	}
 
-- 
2.24.0.432.g9d3f5f5b63-goog

