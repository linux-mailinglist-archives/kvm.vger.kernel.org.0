Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DE1125E97
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 11:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLSKL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 05:11:29 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33728 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLSKL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 05:11:29 -0500
Received: by mail-pl1-f195.google.com with SMTP id c13so2342588pls.0
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2019 02:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bfL9G0/z//jDm9lThiYy6HzVD6N1lKQVtSeDfgyyw7o=;
        b=NPKMxTN9dh+sITZ2jenEIcCMDBB2hMc3cBN6ASaBcEuRVzzG2sDgKEEXJJ0ckQcFwI
         mqGtQ2nSXE4lSgIDCRIKHF7laoRrsivOMj4e6yC0jqWsu31UfgYgXmi1/oTc+gYiyq0O
         vgUh7S4n5+HbEwB0YogXkNVWqEBWcHCwvLtzQbG8MKXWiDsrpDHzhXoa70XOt+w+ZVA6
         1hlc9q9iLCupu7S+t27qPmakBvy8zerLfDk0B50NnFEGxOGOvfIJE2HAtWitgaDpMvyh
         bHKyjN9EpqzFJJiTObMPhcWTacwIt/NP/Jtn5EyBOqs/QsfuMrpUe0ydTXYQjTa3y/7J
         clkA==
X-Gm-Message-State: APjAAAXzuplrXbqbKDzjSNAIX0Zwx8urYXOZSM5ErtmX2EJySZkdBoJk
        nf1/YHLV2W5rA/PrHssrLBE=
X-Google-Smtp-Source: APXvYqwHMFQoXCxXjp+W86S5b39pMbKC47DWXhLLUIHS+OsB/WUF4RS8TIiVkkCZKjI7RcQ7Wmpuiw==
X-Received: by 2002:a17:902:ac97:: with SMTP id h23mr8309400plr.237.1576750288088;
        Thu, 19 Dec 2019 02:11:28 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id c184sm7565530pfa.39.2019.12.19.02.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 02:11:26 -0800 (PST)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: vmx: Comprehensive max VMCS field search
Date:   Thu, 19 Dec 2019 02:10:05 -0800
Message-Id: <20191219101006.49103-2-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219101006.49103-1-namit@vmware.com>
References: <20191219101006.49103-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Search all VMCS fields when looking for the max VMCS field index.
Perform the search backwards to save some time. Change the existing test
to compare the maximum expected index (based on MSRs) is equal to the
actual one.  This improves the test that currently performs
greater-equal comparison.

Suggested-by: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 5803dc7..a1af59c 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -348,6 +348,34 @@ static bool check_all_vmcs_fields(u8 cookie)
 	return __check_all_vmcs_fields(cookie, NULL);
 }
 
+static u32 find_vmcs_max_index(void)
+{
+	u32 idx, width, type, enc;
+	u64 actual;
+	int ret;
+
+	/* scan backwards and stop when found */
+	for (idx = (1 << 9) - 1; idx >= 0; idx--) {
+
+		/* try all combinations of width and type */
+		for (type = 0; type < (1 << 2); type++) {
+			for (width = 0; width < (1 << 2) ; width++) {
+				enc = (idx << VMCS_FIELD_INDEX_SHIFT) |
+				      (type << VMCS_FIELD_TYPE_SHIFT) |
+				      (width << VMCS_FIELD_WIDTH_SHIFT);
+
+				ret = vmcs_read_checking(enc, &actual);
+				assert(!(ret & X86_EFLAGS_CF));
+				if (!(ret & X86_EFLAGS_ZF))
+					return idx;
+			}
+		}
+	}
+	/* some VMCS fields should exist */
+	assert(0);
+	return 0;
+}
+
 static void test_vmwrite_vmread(void)
 {
 	struct vmcs *vmcs = alloc_page();
@@ -358,11 +386,13 @@ static void test_vmwrite_vmread(void)
 	assert(!make_vmcs_current(vmcs));
 
 	set_all_vmcs_fields(0x42);
-	report(__check_all_vmcs_fields(0x42, &max_index), "VMWRITE/VMREAD");
+	report(check_all_vmcs_fields(0x42), "VMWRITE/VMREAD");
 
-	vmcs_enum_max = rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK;
-	report(vmcs_enum_max >= max_index,
-	       "VMX_VMCS_ENUM.MAX_INDEX expected at least: %x, actual: %x",
+	vmcs_enum_max = (rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK)
+			>> VMCS_FIELD_INDEX_SHIFT;
+	max_index = find_vmcs_max_index();
+	report(vmcs_enum_max == max_index,
+	       "VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
 	       max_index, vmcs_enum_max);
 
 	assert(!vmcs_clear(vmcs));
-- 
2.17.1

