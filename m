Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26723F92B9
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244153AbhH0DNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:36 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F003EC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:47 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 41-20020a17090a0fac00b00195a5a61ab8so1107731pjz.3
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4TornJd3esEN0slc3+Yshw+33yLpq3lBCewRutYBCuQ=;
        b=uZhZtJzLMpePq5SIQP/2eHXp+t3a65SEkGSHmr1yUgyXxvrCA7b6ZANN6mRXCp2SzF
         1QvUC3xkWckXvNP1DxiBEheTLlcP4zKTY7070bRvwb/D7tNycE7GZzUgvAdWSHl5xK2/
         QMZSqnF10d6NpNyQiHBBsjG/htXBz7cmGWwT5OYCzgb4o9vHlATMocDiHZVpfvW3/Yjs
         6Q3iqRtat3s3VZpzcb3cFw8eihTdF5OrlPFdFo7chG+hO5S5AiY0HOUws78/cHamAO8t
         KPLbhKOr7/dSfmXreGtOt9P0eejh64UjZDLgP0xwA+bc89JeDuiXKxVBqHjdhCeOVXr9
         IYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4TornJd3esEN0slc3+Yshw+33yLpq3lBCewRutYBCuQ=;
        b=BkcZRL37ytuODecaIxEpYRxz882RgKE1uBnod5AL4dp6MG9c2j93qLeTGbpr6Ztb2s
         Re3CNvMdWkctCf8x4jFQRo1kbWCWiRuxIZhywIQKD6QnbMXO7VGzMLmwrStAYCSemxqW
         TYTEKHIxljcU4AzhsQDdpY+tAeUfVrhNE/lQq21phLRgArB3O7savckAGV4hNgu3k+5Z
         sSRFfhEhzpczpvphBvnWOCUS+eK6HPA0FzGgJa/hhxXqtZxbwdJjl6xStrk7Ig3C9E88
         tPYFAc2OEIZykJJzX+th1nTKYS8rwY4KCcQIk2M8MfpcBKyzrBDnvNNetcRaNFTLiTbK
         qX3A==
X-Gm-Message-State: AOAM533C4mDbkiGuNkGtAFQCJt+vJfxppYe+2a4C3osAZeh/mePcL1oq
        AfnHKgV37vcH9qysJPfZo26vjTvRjeKYMtRfsLUVVTz4qdvhboGM+J8mDv6dE2bNXlz4EGONuAz
        FnuelXtWb7wzLhXNGM6m1PpTfb7Xq4F/f9cDBGtmS9e5ZPZ2E7RzbZtRHgFUIQ6C3KCu0
X-Google-Smtp-Source: ABdhPJyKeM7nnyPzzvC8oQB4xeB24hy00w/dR7CfNUK5uiPWUgjz5QrbtGVd4pRu1s0rPDH6ACDF2UOXsrKnZdlc
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a65:6a09:: with SMTP id
 m9mr5992565pgu.269.1630033967383; Thu, 26 Aug 2021 20:12:47 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:18 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-14-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 13/17] x86 AMD SEV-ES: Check SEV-ES status
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit provides initial start up code for KVM-Unit-Tests to run in
an SEV-ES guest VM. This start up code checks if SEV-ES feature is
supported and enabled for the guest.

In this commit, KVM-Unit-Tests can pass the SEV-ES check and enter
setup_efi() function, but crashes in setup_gdt_tss(), which will be
fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 24 ++++++++++++++++++++++++
 lib/x86/amd_sev.h |  7 +++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index f5e3585..8d4df8c 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -67,6 +67,30 @@ efi_status_t setup_amd_sev(void)
 	return EFI_SUCCESS;
 }
 
+bool amd_sev_es_enabled(void)
+{
+	static bool sev_es_enabled;
+	static bool initialized = false;
+
+	if (!initialized) {
+		sev_es_enabled = false;
+		initialized = true;
+
+		if (!amd_sev_enabled()) {
+			return sev_es_enabled;
+		}
+
+		/* Test if SEV-ES is enabled */
+		if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
+			return sev_es_enabled;
+		}
+
+		sev_es_enabled = true;
+	}
+
+	return sev_es_enabled;
+}
+
 unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	if (amd_sev_enabled()) {
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 2780560..b73a872 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -32,12 +32,15 @@
  * AMD Programmer's Manual Volume 2
  *   - Section "SEV_STATUS MSR"
  */
-#define MSR_SEV_STATUS   0xc0010131
-#define SEV_ENABLED_MASK 0b1
+#define MSR_SEV_STATUS      0xc0010131
+#define SEV_ENABLED_MASK    0b1
+#define SEV_ES_ENABLED_MASK 0b10
 
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
+bool amd_sev_es_enabled(void);
+
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
 
-- 
2.33.0.259.gc128427fd7-goog

