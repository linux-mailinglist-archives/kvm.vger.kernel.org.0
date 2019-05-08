Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB717C81
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfEHOvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:51:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:19899 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbfEHOom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:39 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 07:44:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 243E9709; Wed,  8 May 2019 17:44:29 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
Subject: [PATCH, RFC 10/62] x86/mm: Detect MKTME early
Date:   Wed,  8 May 2019 17:43:30 +0300
Message-Id: <20190508144422.13171-11-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need to know the number of KeyIDs before page_ext is initialized.
We are going to use page_ext to store KeyID and it would be handly to
avoid page_ext allocation if there's no MKMTE in the system.

page_ext initialization happens before full CPU initizliation is complete.
Move detect_tme() call to early_init_intel().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index e271264e238a..4c9fadb57a13 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -161,6 +161,8 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+static void detect_tme(struct cpuinfo_x86 *c);
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
@@ -311,6 +313,9 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (detect_extended_topology_early(c) < 0)
 		detect_ht_early(c);
+
+	if (cpu_has(c, X86_FEATURE_TME))
+		detect_tme(c);
 }
 
 #ifdef CONFIG_X86_32
@@ -791,9 +796,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
 
-	if (cpu_has(c, X86_FEATURE_TME))
-		detect_tme(c);
-
 	init_intel_energy_perf(c);
 
 	init_intel_misc_features(c);
-- 
2.20.1

