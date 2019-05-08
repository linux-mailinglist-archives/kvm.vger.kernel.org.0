Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD46B17C2A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEHOor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:59520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbfEHOop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:44 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 07:44:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 11A32AF7; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 28/62] keys/mktme: Set up PCONFIG programming targets for MKTME keys
Date:   Wed,  8 May 2019 17:43:48 +0300
Message-Id: <20190508144422.13171-29-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

MKTME Key service maintains the hardware key tables. These key tables
are package scoped per the MKTME hardware definition. This means that
each physical package on the system needs its key table programmed.

These physical packages are the targets of the new PCONFIG programming
command. So, introduce a PCONFIG targets bitmap as well as a CPU mask
that includes the lead CPUs capable of programming the targets.

The lead CPU mask will be used every time a new key is programmed into
the hardware.

Keep the PCONFIG targets bit map around for future use during hotplug
events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 42 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 9fdf482ea3e6..b5b44decfd3e 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -2,6 +2,7 @@
 
 /* Documentation/x86/mktme_keys.rst */
 
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/key.h>
 #include <linux/key-type.h>
@@ -17,6 +18,8 @@
 
 static DEFINE_SPINLOCK(mktme_lock);
 struct kmem_cache *mktme_prog_cache;	/* Hardware programming cache */
+unsigned long *mktme_target_map;	/* Pconfig programming targets */
+cpumask_var_t mktme_leadcpus;		/* One lead CPU per pconfig target */
 
 /* 1:1 Mapping between Userspace Keys (struct key) and Hardware KeyIDs */
 struct mktme_mapping {
@@ -303,6 +306,33 @@ struct key_type key_type_mktme = {
 	.destroy	= mktme_destroy_key,
 };
 
+static void mktme_update_pconfig_targets(void)
+{
+	int cpu, target_id;
+
+	cpumask_clear(mktme_leadcpus);
+	bitmap_clear(mktme_target_map, 0, sizeof(mktme_target_map));
+
+	for_each_online_cpu(cpu) {
+		target_id = topology_physical_package_id(cpu);
+		if (!__test_and_set_bit(target_id, mktme_target_map))
+			__cpumask_set_cpu(cpu, mktme_leadcpus);
+	}
+}
+
+static int mktme_alloc_pconfig_targets(void)
+{
+	if (!alloc_cpumask_var(&mktme_leadcpus, GFP_KERNEL))
+		return -ENOMEM;
+
+	mktme_target_map = bitmap_alloc(topology_max_packages(), GFP_KERNEL);
+	if (!mktme_target_map) {
+		free_cpumask_var(mktme_leadcpus);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static int __init init_mktme(void)
 {
 	int ret;
@@ -320,9 +350,21 @@ static int __init init_mktme(void)
 	if (!mktme_prog_cache)
 		goto free_map;
 
+	/* Hardware programming targets */
+	if (mktme_alloc_pconfig_targets())
+		goto free_cache;
+
+	/* Initialize first programming targets */
+	mktme_update_pconfig_targets();
+
 	ret = register_key_type(&key_type_mktme);
 	if (!ret)
 		return ret;			/* SUCCESS */
+
+	free_cpumask_var(mktme_leadcpus);
+	bitmap_free(mktme_target_map);
+free_cache:
+	kmem_cache_destroy(mktme_prog_cache);
 free_map:
 	kvfree(mktme_map);
 
-- 
2.20.1

