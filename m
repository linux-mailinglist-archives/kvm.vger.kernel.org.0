Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F0D3EF691
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhHRAKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbhHRAKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D937C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so958531yba.9
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GhtfSafVU8V5kwY4FhO2K/ZXeN7bIJFS/tv4zfm1rPI=;
        b=S1iyigO8cTIdPI6l7T7TKa+GPkTHu4k+sRjbh9Wmul9aM35klnrINdmxtQNDEfjO9r
         2G+UaibBWeuGW16LiReFiwC8IMDoMfW9shONaFlq6JeWiR7ESY23E+WvJJmPCi3MR6H0
         VxGb6dE2S6Q3VMHkd28W7ZOJ+/9m90Dc1TfLM6H1zcng5hYaVEMzMZgeib2risRxEm51
         vIpU5+Y0SKbP0Gdem56Djq/N09rLpgC95YS9MrDblc5EcMhPi1jP+DsfNUxjTwMAibc8
         KLMkopru6LY3lq07UxHsLi/qconkamihfyGi9wD8bQMjOvoHa8luBHRsdxaGVVb38Gg3
         oYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GhtfSafVU8V5kwY4FhO2K/ZXeN7bIJFS/tv4zfm1rPI=;
        b=nDk1soE5FhEPLePd3i6oe8mUGchwAQ1sjpeHeDbuhYcFpEiQwif6IrAjbrSp6Wg0yk
         49rx4nZiXlLFTBJrXC23Fni0dSsXKkuEb5bcHQBZgHi/b1rz7/RM4BzhGq2+llEKQp3d
         4vaqHhMWRqOavSOngo5VNnBsWkRUGhAndfY532D9+gaBFrdR3PFQOznxvixW04TRjViR
         zif6xTmnT9MHdQ7uj0gAMr3u4v4lPchR1vUcEGwlAU7EAgQy8ywPMBi5H9NKgFaxbfh4
         pJPDqD9X6N2ltJPIMsXxq6DRHC1S6Rne4FKiST56Y5KD5sDQxu6aAR4NszLk+KDX0Nxe
         SL6g==
X-Gm-Message-State: AOAM533TvyifCzi4kIAMRFRFp6rth8QgOf2OSwhcmDBkGEKhX5VAoeDA
        m2jU9tEVSVvP6R59Jkhd3zFp3Xz84+vBpMOhvAygOM0DiTzQiQOLDh1mUti1nn1wRMM7VZsXTvu
        JNJqm/pBdPND7za3FSDaLRsYydl4lv5ynI60o1/6+Jz2gVmnkQ22TfTqr0oWIlEJw6jDe
X-Google-Smtp-Source: ABdhPJzze/vIxP0yvJz/QYNTo5KLNrKpJV4hWotNmOm8a776Kfu0Hea+3vTjrrRZcc7M+U/la2GigJSYe+7Yfwyz
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:d68a:: with SMTP id
 n132mr7237034ybg.483.1629245377483; Tue, 17 Aug 2021 17:09:37 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:09:02 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-14-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 13/16] x86 AMD SEV-ES: Load GDT with UEFI segments
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before this commit, KVM-Unit-Tests set up process crashes when executing
'lgdt' instruction under SEV-ES. This is because lgdt triggers UEFI
procedures (e.g. UEFI #VC handler) that require UEFI's code and data
segments. But these segments are are not compatible with KVM-Unit-Tests
GDT:

UEFI uses 0x30 as code segment and 0x38 as data segment, but in
KVM-Unit-Tests' GDT, 0x30 is a data segment, and 0x38 is a code segment.
This discrepancy crashes the UEFI procedures and thus crashes the 'lgdt'
execution.

This commit fixes this issue by copying UEFI GDT's code and data
segments into KVM-Unit-Tests GDT, so that UEFI procedures (e.g. UEFI #VC
handler) can work.

In this commit, the guest VM passes setup_gdt_tss() but crashes in
load_idt(), which will be fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 36 ++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h |  1 +
 lib/x86/setup.c   |  4 ++++
 3 files changed, 41 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index a31d352..c2aebdf 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -53,6 +53,42 @@ EFI_STATUS setup_amd_sev_es(void){
 
 	return EFI_SUCCESS;
 }
+
+static void copy_gdt_entry(gdt_entry_t *dst, gdt_entry_t *src, unsigned segment)
+{
+	unsigned index;
+
+	index = segment / sizeof(gdt_entry_t);
+	dst[index] = src[index];
+}
+
+/* Defined in x86/efi/efistart64.S */
+extern gdt_entry_t gdt64[];
+
+/* Copy UEFI's code and data segments to KVM-Unit-Tests GDT.
+ *
+ * This is because KVM-Unit-Tests reuses UEFI #VC handler that requires UEFI
+ * code and data segments to run. The UEFI #VC handler crashes the guest VM if
+ * these segments are not available. So we need to copy these two UEFI segments
+ * into KVM-Unit-Tests GDT.
+ *
+ * UEFI uses 0x30 as code segment and 0x38 as data segment. Fortunately, these
+ * segments can be safely overridden in KVM-Unit-Tests as they are used as
+ * protected mode and real mode segments (see x86/efi/efistart64.S for more
+ * details), which are not used in EFI set up process.
+ */
+void copy_uefi_segments(void)
+{
+	/* GDT and GDTR in current UEFI */
+	gdt_entry_t *gdt_curr;
+	struct descriptor_table_ptr gdtr_curr;
+
+	/* Copy code and data segments from UEFI */
+	sgdt(&gdtr_curr);
+	gdt_curr = (gdt_entry_t *)gdtr_curr.base;
+	copy_gdt_entry(gdt64, gdt_curr, read_cs());
+	copy_gdt_entry(gdt64, gdt_curr, read_ds());
+}
 #endif /* CONFIG_AMD_SEV_ES */
 
 unsigned long long get_amd_sev_c_bit_mask(void)
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index a2eccfc..4d81cae 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -39,6 +39,7 @@
 EFI_STATUS setup_amd_sev(void);
 #ifdef CONFIG_AMD_SEV_ES
 EFI_STATUS setup_amd_sev_es(void);
+void copy_uefi_segments(void);
 #endif /* CONFIG_AMD_SEV_ES */
 
 unsigned long long get_amd_sev_c_bit_mask(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d29f415..d828638 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -348,6 +348,10 @@ static void setup_gdt_tss(void)
 	tss_hi->limit_low = (u16)((curr_tss_addr >> 32) & 0xffff);
 	tss_hi->base_low = (u16)((curr_tss_addr >> 48) & 0xffff);
 
+#ifdef CONFIG_AMD_SEV_ES
+	copy_uefi_segments();
+#endif /* CONFIG_AMD_SEV_ES */
+
 	load_gdt_tss(tss_offset);
 }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

