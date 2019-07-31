Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB4C7C659
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfGaPXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:23:51 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44818 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfGaPXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:23:50 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so66024298edr.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fyWNol/pClGETI/+3Fy8S0o8APly1L7wYaUOInJ7cro=;
        b=0D+e9OKImyb4sTdS3DaGli2ESSvrhwMepoaeber6sOi6xNQeOXqjqOnb/1KIv5eA0x
         eNNtaJSwMUTdya3x65wpEduqQWVFqNJxowmsYurkJg6idVmOJAgynHTMtURvl6pRH+lp
         /AXQs/PGw3QMUYeGMcitYEalW7K8jjmrvIDBQFxHoyvKOlQjQp1wt8RvB40She7x5nMN
         Km17y2HW/2HnGsAkyXDWsXdzi+suKv/3bNL7rEATTZ6hOD/1GmoI3RxM+fG1oxMgjoTb
         i0NcERRrgjS3qiNo560qZowGrKNWVHk2bwOr/TVDT1ncGB5cnkrBEBAJUPDEPQtBhvsJ
         S6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fyWNol/pClGETI/+3Fy8S0o8APly1L7wYaUOInJ7cro=;
        b=ZwvjW/T0gTTS5g93/H6yC53fQXvAtPgwyBbghpzYPyNbMzMWYhKN1ddh7UVTSfBzGa
         piYPpE65uTkLBbkd0Kx9U2sxGu5uOQQMaO+sJg5V7JS83A85YuFW8uGz3Tp55pr7lsGO
         wNTYoRdm/PQ3eIDO4AxODwSj6+IPisPZQxl4v9YMIQ9TbUj1gBJkgev7TDyDw1n0U5cu
         ZN0GGGT8Ywhnf2dRkyf1gnVEvMkHiCcxhh/FRBhZZSU0WWSNCoFhJ5sF2B4ZLwZHQBZs
         LeV2dIEPvdVsUBHMkKZKWaBxcEJtcbO09iAnzUt4MeymT6WK7f12z9RrU33K2LZhGSbF
         6pRA==
X-Gm-Message-State: APjAAAXYxYv+HauTAbYO3FH8zu7MoVKpePzplHUkMAiMwUJe6hzcDEjj
        L2JmvbB0Yj87AggLAVTzFDg=
X-Google-Smtp-Source: APXvYqwsOKPemvbbrapjzGTexE0e+E42HWLS7Zg61PJSi6P6DFE4jdPIWGYYycTh80vcUaFlClexVw==
X-Received: by 2002:a50:b388:: with SMTP id s8mr106143247edd.15.1564586629069;
        Wed, 31 Jul 2019 08:23:49 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id f24sm16699742edt.82.2019.07.31.08.23.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:23:47 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id E1BE61045F9; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 35/59] acpi/hmat: Determine existence of an ACPI HMAT
Date:   Wed, 31 Jul 2019 18:07:49 +0300
Message-Id: <20190731150813.26289-36-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

Platforms that need to confirm the presence of an HMAT table
can use this function that simply reports the HMATs existence.

This is added in support of the Multi-Key Total Memory Encryption
(MKTME), a feature on future Intel platforms. These platforms will
need to confirm an HMAT is present at init time.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/acpi/hmat/hmat.c | 13 +++++++++++++
 include/linux/acpi.h     |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 96b7d39a97c6..38e3341f569f 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -664,3 +664,16 @@ static __init int hmat_init(void)
 	return 0;
 }
 subsys_initcall(hmat_init);
+
+bool acpi_hmat_present(void)
+{
+	struct acpi_table_header *tbl;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_HMAT, 0, &tbl);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	acpi_put_table(tbl);
+	return true;
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index fc1e7d4648bf..d27f4d17dfb3 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1335,4 +1335,8 @@ acpi_platform_notify(struct device *dev, enum kobject_action action)
 }
 #endif
 
+#ifdef CONFIG_X86_INTEL_MKTME
+extern bool acpi_hmat_present(void);
+#endif /* CONFIG_X86_INTEL_MKTME */
+
 #endif	/*_LINUX_ACPI_H*/
-- 
2.21.0

