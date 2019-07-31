Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD517C661
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfGaPXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:23:53 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44820 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbfGaPXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:23:52 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so66024369edr.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V4Vs01tlfRxj/hdhWvsn+MzzX7wMrP0xYcTZ6W3t7PA=;
        b=DnqAXhTZp01yN6WSw/evIc0boNe52PO2BoJktJtMh2RgostVls+YOyjDU6sjdeAXpu
         pYNcxAcwMJyK9ACo0Uze5/331zleuRgZ8tdMXcyXHPouR7MjjLnzEm4vrrvRLtE8OL+z
         76Cfo0xHGEhi44+MBvlBGlpc/EOvonqmzkGktFkI44+xmuDaiqapmC1Xp/Y9zTg7OInG
         a9YhCGJldybaRAWWZ5RBIZd3ymSs+wsjDNu5AUmyHnhmm+vat7AO8LplmVvMjX0krWt7
         jQavX89FPCTjy4eg6GZ4rPAOp0XfZXIvJviPw7ZSaRn3QUgHcgBLfJ3RAn+sdl9p07vK
         IUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V4Vs01tlfRxj/hdhWvsn+MzzX7wMrP0xYcTZ6W3t7PA=;
        b=OVEzLmll4tLR3wVpB339bZT0rrEjJg1/IXAqw0NCBJJz+fG0hjqQ7ZP6AIqCAM4Gey
         WaShcNZSEH2MeO1XH/PWtq8UFsrCSkYkQhLCEkRJOPrb1AjBhvWo4Mid+Xy4dy2Kq7yb
         XtFtc+uaqTqyJQgFraMtBayscaui6TfJktmTq1YSX4mTxeBCW4m5yIAySl6TaucYXNKD
         NmZR7MqLL173UIYuniI0AcsnzsEg8jXFZWD1P6zsqRt9x7j+4rXWvOXQciTIMrRa5NhX
         BYPU3xkXQqD6a6eL0TUT8IR+JsHqLBBpVfh0dyE8Zb0RkZB76wFnUl3JvhmiYq6loRST
         SbqA==
X-Gm-Message-State: APjAAAVwxbV9Hr06zu00nwooTLabVDdPNqGRiHtBAhTmuDpqmgXh0m0N
        n9CQdkr4pED3vH5E1DLnmDI=
X-Google-Smtp-Source: APXvYqzpD06BRkFUgNWq9pUNA5hd6n+ixu+p9XWwB3ULdCfnwz/4f2lQt2Iw5Gwg1+XUTttxmbAlwg==
X-Received: by 2002:a50:9116:: with SMTP id e22mr108657772eda.161.1564586630746;
        Wed, 31 Jul 2019 08:23:50 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id 9sm8073176ejw.63.2019.07.31.08.23.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:23:49 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 6C43A1048A5; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 53/59] x86: Introduce CONFIG_X86_INTEL_MKTME
Date:   Wed, 31 Jul 2019 18:08:07 +0300
Message-Id: <20190731150813.26289-54-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add new config option to enabled/disable Multi-Key Total Memory
Encryption support.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f2cc88fe8ada..d8551b612f3b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1550,6 +1550,25 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	  If set to N, then the encryption of system memory can be
 	  activated with the mem_encrypt=on command line option.
 
+config X86_INTEL_MKTME
+	bool "Intel Multi-Key Total Memory Encryption"
+	depends on X86_64 && CPU_SUP_INTEL && !KASAN
+	select X86_MEM_ENCRYPT_COMMON
+	select PAGE_EXTENSION
+	select KEYS
+	select ACPI_HMAT
+	---help---
+	  Say yes to enable support for Multi-Key Total Memory Encryption.
+	  This requires an Intel processor that has support of the feature.
+
+	  Multikey Total Memory Encryption (MKTME) is a technology that allows
+	  transparent memory encryption in upcoming Intel platforms.
+
+	  MKTME is built on top of TME. TME allows encryption of the entirety
+	  of system memory using a single key. MKTME allows having multiple
+	  encryption domains, each having own key -- different memory pages can
+	  be encrypted with different keys.
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
@@ -2220,7 +2239,7 @@ config RANDOMIZE_MEMORY
 
 config MEMORY_PHYSICAL_PADDING
 	hex "Physical memory mapping padding" if EXPERT
-	depends on RANDOMIZE_MEMORY
+	depends on RANDOMIZE_MEMORY || X86_INTEL_MKTME
 	default "0xa" if MEMORY_HOTPLUG
 	default "0x0"
 	range 0x1 0x40 if MEMORY_HOTPLUG
-- 
2.21.0

