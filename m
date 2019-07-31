Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2127C5B6
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfGaPJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:09:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35939 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388615AbfGaPIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:31 -0400
Received: by mail-ed1-f68.google.com with SMTP id k21so66033321edq.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zVlcJDBaDTqmSz97nQxl4DvHh1B1aL9m42IztWqYpgk=;
        b=MLb+AaScf0hGsrpPSDd87+yWF18Ne5YphyrJDosl5qgEGBpjx5dqprcz8D6TDurakx
         v7dksS8vdyH98KwRfDrtg/ZbAe6E5vhUhxog7UiBo5/z7ZxDluJryzZrq7ii40mFem3i
         jMx9cmbPY8ZVw9geHuaHGUyOzRRTLmVrMwDlEzypgFsoq1OKR/Xmb+uMJ6IghodwNO1n
         RZiP1ftmR0Lj/uf8ewWim1E6GUd1B5u7cpUbveVRjMCNi8uIaEVIr/L9O6TQUka6NeYB
         zDwBJBoONjQlX/jht6jQVRNO6og/Cy7j8akyt5hXZpmDzorFoOnlfMMXa/CagiuWGoH+
         adxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zVlcJDBaDTqmSz97nQxl4DvHh1B1aL9m42IztWqYpgk=;
        b=M3dw0wwKdQt0USU5mNDY36kUA4HEG0HnOu8r9ThWD1LTZnc7X8IBU/xQFKSFqFxVbd
         6BkRfuKaEHXycjZaWR97+cgwXvexc01gaz106vFaF0XUZdFe6oxr1fU3z1o1i2G/P1Cj
         n+C8jR7Aut1DhwtIx1KbllEb51iTw7cx8KhXauIXU3gNMJC2OUNx0b5BILNJJu0ClZtN
         BmOmK7x8mUCsOl1oFa2iD5+RxRb0IugkbJBm9glN5giucTwttBECSpqQy7lSCeNZ4SrS
         VpppKpQzNoo2B2QArlEOCShDsRe0GWmbZb6NVsUz2P1vXx5zJfN54jQUiGbkJyKqrxNF
         klWw==
X-Gm-Message-State: APjAAAVcfaz+C7zW+gau0mQStSklyupl2Fb0L76WYHeXMszHw8G/ANFD
        O1ShEBEHDFmQ8vvJ6Roe0EE=
X-Google-Smtp-Source: APXvYqyr56BhZiXrSd8f2fq+Z375JbAoHMRws8MKCqxmheMr9Uoh5vHG5eCnsq/pE6efizao1axriw==
X-Received: by 2002:a05:6402:3d5:: with SMTP id t21mr107048118edw.13.1564585710210;
        Wed, 31 Jul 2019 08:08:30 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id s2sm5403001ejf.11.2019.07.31.08.08.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:28 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id E8A5B1045FA; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 36/59] keys/mktme: Require ACPI HMAT to register the MKTME Key Service
Date:   Wed, 31 Jul 2019 18:07:50 +0300
Message-Id: <20190731150813.26289-37-kirill.shutemov@linux.intel.com>
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

The ACPI HMAT will be used by the MKTME key service to identify
topologies that support the safe programming of encryption keys.
Those decisions will happen at key creation time and during
hotplug events.

To enable this, we at least need to have the ACPI HMAT present
at init time. If it's not present, do not register the type.

If the HMAT is not present, failure looks like this:
[ ] MKTME: Registration failed. ACPI HMAT not present.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 2d90cc83e5ce..6265b62801e9 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -2,6 +2,7 @@
 
 /* Documentation/x86/mktme/ */
 
+#include <linux/acpi.h>
 #include <linux/cred.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
@@ -445,6 +446,12 @@ static int __init init_mktme(void)
 
 	mktme_available_keyids = mktme_nr_keyids();
 
+	/* Require an ACPI HMAT to identify MKTME safe topologies */
+	if (!acpi_hmat_present()) {
+		pr_warn("MKTME: Registration failed. ACPI HMAT not present.\n");
+		return -EINVAL;
+	}
+
 	/* Mapping of Userspace Keys to Hardware KeyIDs */
 	mktme_map = kvzalloc((sizeof(*mktme_map) * (mktme_nr_keyids() + 1)),
 			     GFP_KERNEL);
-- 
2.21.0

