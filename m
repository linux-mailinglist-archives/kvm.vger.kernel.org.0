Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1F8136D4
	for <lists+kvm@lfdr.de>; Sat,  4 May 2019 03:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfEDBLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 21:11:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32951 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfEDBLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 21:11:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id e28so9938169wra.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 18:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X1twO1Q1L2oynVMIl2wzQZk14bzPOH9N24HDJtgP+uw=;
        b=plCMoa5/Hv0/W1Cqzs++iefq/F3xjEIe9SzDFlZnnHw7SlyqTArpA1QVF117YK3B2f
         YgS+mtM6YV5syACyYUN0nfWZYPmkRu8F3g/Hhv+ndMw1wcFrwMhvAfIfeC9JXmOHbx0w
         CcmOQowvjs+84MFSyawFs12gNqyGiiBXKI22J3BHhzf0QirqW/jqKI7SfMeN0ovC0uYd
         7UEaKKiEytkvaua3e4Tj3Ixiq+7sMuBcjnDPUzCb3vaX7mK06SYFhd50kR7lFmJicJXf
         sJd19HvyTvINWpdR9E51hBI0CS5XS3npyEPnI1TLOOoskAVn4/8VEbQFM0XrNPfiBNAv
         W0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X1twO1Q1L2oynVMIl2wzQZk14bzPOH9N24HDJtgP+uw=;
        b=l/LwHuMdYrcQTqx28Z1Ib0WAPzO9+PZYtlS0ZsPBEsj/jUqD3tHDGKPw8U1Z51ANii
         1egJXTNRorcr6dEezlCcBLsPXFLhkJvLmMXFRlHlWTyP/ECBfZ8HFrTPY8TFc8WAz5SK
         OquDysohFvHQR+MNHcqglLWTTgH+J7KJp8jWf/YQpys3jISb5RSCHCc1ffxAO/oXZc+H
         KgrHWKhk3/emIPbpD9O3iYymChUX2mct9hKxISsixp0ezattMbgZBNX5PjB4qNIwIe9F
         DmDTtmZ11UsdI2zKVSW6Oh+0I9nrbJVdeESkcuIUzdD6g94x1lxFQFPc365iv0PnFFVS
         caCw==
X-Gm-Message-State: APjAAAVshPsZpgSJz0MSamtaJozf7FFNmmLMRVPmvi9Nj3u5aCwjzOJQ
        HP/VxLAtGnlPTenfE5zCvek=
X-Google-Smtp-Source: APXvYqyKEwse0u0Mdo0/q08DQ5iaPxXM81uSbvg3lcaIo3U3H69ztUOb7D4I5kZV5+zhlIpJq8pgng==
X-Received: by 2002:a5d:624d:: with SMTP id m13mr9009415wrv.305.1556932276934;
        Fri, 03 May 2019 18:11:16 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id e5sm2409098wrh.79.2019.05.03.18.11.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:11:15 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: vmx: Mask undefined bits in exit qualifications
Date:   Fri,  3 May 2019 10:49:19 -0700
Message-Id: <20190503174919.13846-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

On EPT violation, the exit qualifications may have some undefined bits.

Bit 6 is undefined if "mode-based execute control" is 0.

Bits 9-11 are undefined unless the processor supports advanced VM-exit
information for EPT violations.

Right now on KVM these bits are always undefined inside the VM (i.e., in
an emulated VM-exit). Mask these bits to avoid potential false
indication of failures.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx.h       | 20 ++++++++++++--------
 x86/vmx_tests.c |  4 ++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index cc377ef..5053d6f 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -603,16 +603,20 @@ enum vm_instruction_error_number {
 #define EPT_ADDR_MASK		GENMASK_ULL(51, 12)
 #define PAGE_MASK_2M		(~(PAGE_SIZE_2M-1))
 
-#define EPT_VLT_RD		1
-#define EPT_VLT_WR		(1 << 1)
-#define EPT_VLT_FETCH		(1 << 2)
-#define EPT_VLT_PERM_RD		(1 << 3)
-#define EPT_VLT_PERM_WR		(1 << 4)
-#define EPT_VLT_PERM_EX		(1 << 5)
+#define EPT_VLT_RD		(1ull << 0)
+#define EPT_VLT_WR		(1ull << 1)
+#define EPT_VLT_FETCH		(1ull << 2)
+#define EPT_VLT_PERM_RD		(1ull << 3)
+#define EPT_VLT_PERM_WR		(1ull << 4)
+#define EPT_VLT_PERM_EX		(1ull << 5)
+#define EPT_VLT_PERM_USER_EX	(1ull << 6)
 #define EPT_VLT_PERMS		(EPT_VLT_PERM_RD | EPT_VLT_PERM_WR | \
 				 EPT_VLT_PERM_EX)
-#define EPT_VLT_LADDR_VLD	(1 << 7)
-#define EPT_VLT_PADDR		(1 << 8)
+#define EPT_VLT_LADDR_VLD	(1ull << 7)
+#define EPT_VLT_PADDR		(1ull << 8)
+#define EPT_VLT_GUEST_USER	(1ull << 9)
+#define EPT_VLT_GUEST_WR	(1ull << 10)
+#define EPT_VLT_GUEST_EX	(1ull << 11)
 
 #define MAGIC_VAL_1		0x12345678ul
 #define MAGIC_VAL_2		0x87654321ul
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c52ebc6..b4129e1 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2365,6 +2365,10 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
 
 	qual = vmcs_read(EXI_QUALIFICATION);
 
+	/* Mask undefined bits (which may later be defined in certain cases). */
+	qual &= ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_WR | EPT_VLT_GUEST_EX |
+		 EPT_VLT_PERM_USER_EX);
+
 	diagnose_ept_violation_qual(expected_qual, qual);
 	TEST_EXPECT_EQ(expected_qual, qual);
 
-- 
2.17.1

