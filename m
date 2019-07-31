Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9486D7C598
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388627AbfGaPIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:55 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33648 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388657AbfGaPIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:34 -0400
Received: by mail-ed1-f66.google.com with SMTP id i11so2525097edq.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AKmba4vf/ZPJ1ANSLVq0BszaZ5EHEw0+rluolW4cNw8=;
        b=bo4uajak/nrY2caCviEQ5+13QOOruKSVot/3mpFhnPUptXe8wQiI2pcggx1UFzkc+6
         p2enaIZE1WQ0nur+4ojLwMmfA3mnX2TiIzq/vOH4fPX7tFzT7bwdjkaqQeNcebCtaRK2
         YncpJbM19Mg+hJ0PgQoeGEunjUw6+YNXDPaFZKrtGi1suwJGSQ25iciPmh/QlVLzh68/
         dFKIA5VbuTbQiB1EFWVSIRHLZOqQe4aOiF5cdzltkeIKMO93kV8/XGQs8282Dvs4jNAK
         r4taKwQzR2Fb1WQzuTvnWB10NdFL0EW3LOi1Sx3I7icX3Xv1+3uBneHoWO18TZnuPiw4
         Xl9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AKmba4vf/ZPJ1ANSLVq0BszaZ5EHEw0+rluolW4cNw8=;
        b=NLM2jAHeIbKXmAEbbxHtGIFgmSkaxLvrsZBkGJrLoK2VZuW4aFhMexXbNysf+XsNEq
         GMtMPPdikJSmuTcb0ecKyEi44IYOCrRC++TdRNDYecak6VKpCDSiH6XguJ0Vohe1Kq+f
         kBBt1u8JiEG1oHE7wMspahJpjkDAKfEVK1AOi0PrCpHyxhWVMThJmF5AWGmCrWtsieSH
         FpM6H7Vmnn5iv8PzDm+L8OM0Jbn1MRqTq4p+He2iNUORdp4hZ5v+OKj7LUXeXnWgZ26V
         slWYkQJdaydTB+i0gVibJYYOgMT+pnAZSkfhUuO6yefAjr1EXJtxfT1WvtkVFuNoRcBe
         LK7g==
X-Gm-Message-State: APjAAAViODjq/wb0iM5mNKItPj3fuixIKPlYXYcvuceQVRPcacBV1fW9
        w1jwP3l7MNbt+M/hFLeMlS4=
X-Google-Smtp-Source: APXvYqwScU6xXfOXVBF3/9vB3jUnf5274LJ9+ShKG2lqwNOlRRUFmLwjUMddJUmbcRJe29HUOaEEYg==
X-Received: by 2002:a17:906:b6c6:: with SMTP id ec6mr96502459ejb.183.1564585711755;
        Wed, 31 Jul 2019 08:08:31 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id w24sm17512065edb.90.2019.07.31.08.08.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:30 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 5E4AA1048A3; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 51/59] x86/mm: Disable MKTME on incompatible platform configurations
Date:   Wed, 31 Jul 2019 18:08:05 +0300
Message-Id: <20190731150813.26289-52-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Icelake Server requires additional check to make sure that MKTME usage
is safe on Linux.

Kernel needs a way to access encrypted memory. There can be different
approaches to this: create a temporary mapping to access the page (using
kmap() interface), modify kernel's direct mapping on allocation of
encrypted page.

In order to minimize runtime overhead, the Linux MKTME implementation
uses multiple direct mappings, one per-KeyID. Kernel uses the direct
mapping that is relevant for the page at the moment.

Icelake Server in some configurations doesn't allow a page to be mapped
with multiple KeyIDs at the same time. Even if only one of KeyIDs is
actively used. It conflicts with the Linux MKTME implementation.

OS can check if it's safe to map the same with multiple KeyIDs by
examining bit 8 of MSR 0x6F. If the bit is set we cannot safely use
MKTME on Linux.

The user can disable the Directory Mode in BIOS setup to get the
platform into Linux-compatible mode.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9852580340b9..3583bea0a5b9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -19,6 +19,7 @@
 #include <asm/microcode_intel.h>
 #include <asm/hwcap2.h>
 #include <asm/elf.h>
+#include <asm/cpu_device_id.h>
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
@@ -560,6 +561,16 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 
 #define TME_ACTIVATE_CRYPTO_KNOWN_ALGS	TME_ACTIVATE_CRYPTO_AES_XTS_128
 
+#define MSR_ICX_MKTME_STATUS		0x6F
+#define MKTME_ALIASES_FORBIDDEN(x)	(x & BIT(8))
+
+/* Need to check MSR_ICX_MKTME_STATUS for these CPUs */
+static const struct x86_cpu_id mktme_status_msr_ids[] = {
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ICELAKE_X		},
+	{ X86_VENDOR_INTEL,	6,	INTEL_FAM6_ICELAKE_XEON_D	},
+	{}
+};
+
 /* Values for mktme_status (SW only construct) */
 #define MKTME_ENABLED			0
 #define MKTME_DISABLED			1
@@ -593,6 +604,17 @@ static void detect_tme(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	/* Icelake Server quirk: do not enable MKTME if aliases are forbidden */
+	if (x86_match_cpu(mktme_status_msr_ids)) {
+		u64 status;
+		rdmsrl(MSR_ICX_MKTME_STATUS, status);
+
+		if (MKTME_ALIASES_FORBIDDEN(status)) {
+			pr_err_once("x86/tme: Directory Mode is enabled in BIOS\n");
+			mktme_status = MKTME_DISABLED;
+		}
+	}
+
 	if (mktme_status != MKTME_UNINITIALIZED)
 		goto detect_keyid_bits;
 
-- 
2.21.0

