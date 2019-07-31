Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A37C63C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfGaPV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:21:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44563 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbfGaPV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:21:58 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so66018712edr.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0SvRw1bdF/wj1/uPaALpB1mJItIzSwaE2+8pgarmj/0=;
        b=K8GSlHVyaCoX6eoUymMD8WNd8fo5NWDf75jpRiOk+1zSA+MpR6EfH2u4sq/cei0nEX
         o80zJP8en7QDpE5vzs8O5n4LrgF22geCbTMxZs9xW/Bw6G07hLfzIVGyGKyQoxIOnZBD
         YFtORfTsEPttMMQotUKNiwrIP4HCJfUjTSf2by1YSPzvrtnfC1aL0Dv/WEnFMeyqvoSY
         1yZ+xCdOLBGgiLW+bKu/YcS0pacqJtrPn8i6k/jyqe3Rz1jF3T9VOENF63nv+EydMMBy
         h8eN884I5s73CM7fbg8Lu/9/FG0L4WKxt0gSlNtUkWxzIvuA+TNSCpjkFO+PNMv3SZs9
         BR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0SvRw1bdF/wj1/uPaALpB1mJItIzSwaE2+8pgarmj/0=;
        b=sDKgkhNjIZuVDVxLgiOgKVJauVV3FsXvuxaXeneLlloaf3izQR2I78qjrbGNGgv+sG
         HP6rFU8N87kmMWEBHeIcgeN7LboF6lo+hNEx3GnrL6SiG55WVmwDogH1p5NVwrTF+qZ+
         tqA26sEOiYLNNlilf4q/EOZ2uoVhy6G5QIfpNWuCew4aah6Oe1dqzs5D2pzz07Ruhp5J
         QjBVy7IvyweMBBEjsxX5AJ4Og+P9pRs4cCokrYTeFjmZP5MKGium4EomTLzDNzv1PQpn
         ldAvmoC837WquV+N9p0jIv7u4M3UsNeBuA/jX8NWSm2fOW2G4OiIhcqTIHIbZ5JVFNB6
         elzA==
X-Gm-Message-State: APjAAAUIBjVpxavWbA4Oo7EEIA6X1ukDXJEh+DFqs3e37BRojFohhoAl
        Fs+714ebkAjfPbg7X7mpoHw=
X-Google-Smtp-Source: APXvYqwDDDPlNwfBHKIOlIbyqYdy0UrYvh8zFar3DZnhvZm8R0JCleo52KdoWAHk4ZEHWuudYw10ag==
X-Received: by 2002:a17:906:e11a:: with SMTP id gj26mr95741299ejb.95.1564586040068;
        Wed, 31 Jul 2019 08:14:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id qq13sm12564390ejb.27.2019.07.31.08.13.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id EF8F91045FB; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 37/59] acpi/hmat: Evaluate topology presented in ACPI HMAT for MKTME
Date:   Wed, 31 Jul 2019 18:07:51 +0300
Message-Id: <20190731150813.26289-38-kirill.shutemov@linux.intel.com>
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

MKTME, Multi-Key Total Memory Encryption, is a feature on Intel
platforms. The ACPI HMAT table can be used to verify that the
platform topology is safe for the usage of MKTME.

The kernel must be capable of programming every memory controller
on the platform. This means that there must be a CPU online, in
the same proximity domain of each memory controller.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/acpi/hmat/hmat.c | 54 ++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h     |  1 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 38e3341f569f..936a403c0694 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -677,3 +677,57 @@ bool acpi_hmat_present(void)
 	acpi_put_table(tbl);
 	return true;
 }
+
+static int mktme_parse_proximity_domains(union acpi_subtable_headers *header,
+					 const unsigned long end)
+{
+	struct acpi_hmat_proximity_domain *mar = (void *)header;
+	struct acpi_hmat_structure *hdr = (void *)header;
+
+	const struct cpumask *tmp_mask;
+
+	if (!hdr || hdr->type != ACPI_HMAT_TYPE_PROXIMITY)
+		return -EINVAL;
+
+	if (mar->header.length != sizeof(*mar)) {
+		pr_warn("MKTME: invalid header length in HMAT\n");
+		return -1;
+	}
+	/*
+	 * Require a valid processor proximity domain.
+	 * This will catch memory only physical packages with
+	 * no processor capable of programming the key table.
+	 */
+	if (!(mar->flags & ACPI_HMAT_PROCESSOR_PD_VALID)) {
+		pr_warn("MKTME: no valid processor proximity domain\n");
+		return -1;
+	}
+	/* Require an online CPU in the processor proximity domain. */
+	tmp_mask = cpumask_of_node(pxm_to_node(mar->processor_PD));
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask)) {
+		pr_warn("MKTME: no online CPU in proximity domain\n");
+		return -1;
+	}
+	return 0;
+}
+
+/* Returns true if topology is safe for MKTME key creation */
+bool mktme_hmat_evaluate(void)
+{
+	struct acpi_table_header *tbl;
+	bool ret = true;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_HMAT, 0, &tbl);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	if (acpi_table_parse_entries(ACPI_SIG_HMAT,
+				     sizeof(struct acpi_table_hmat),
+				     ACPI_HMAT_TYPE_PROXIMITY,
+				     mktme_parse_proximity_domains, 0) < 0) {
+		ret = false;
+	}
+	acpi_put_table(tbl);
+	return ret;
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d27f4d17dfb3..8854ae942e37 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1337,6 +1337,7 @@ acpi_platform_notify(struct device *dev, enum kobject_action action)
 
 #ifdef CONFIG_X86_INTEL_MKTME
 extern bool acpi_hmat_present(void);
+extern bool mktme_hmat_evaluate(void);
 #endif /* CONFIG_X86_INTEL_MKTME */
 
 #endif	/*_LINUX_ACPI_H*/
-- 
2.21.0

