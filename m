Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E507C640
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfGaPVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:21:10 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44450 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfGaPVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:21:08 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so66016253edr.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sg6bxLoMlRes885QhQrq9mVE221k6YoeytqqLikFglU=;
        b=IXEicb9BiLYExfvQdFk4yaWrUYrtPs2P+FQ3xbHGAjJqFjc/Tjuex7il/QhhrAU3gJ
         1B0zMUjyCzuoPb2CGvJQ7dAtThjRe7D5+pWm017eXRhJ5OYV8RCaNICnYmJ009+sfvzW
         5NUoC3YokyUZoQB7sHYWULxV/2/f9TOcZ1/gPkf55duPH15/Vc4B/k9Omnv9/9Yv3CZU
         SeCOWTrZNYeWEwYFisHEi4GPFxy3g1PXFpyNHAYa2qaeY0jn6aM8/D2yPWi1YGyBcl0J
         4Kakk20YFCj7A+Ev81808+OjXvvP+eFNT1KH0KoZhORiukznX+DHLEGwFZnttRXtl3Xg
         KF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sg6bxLoMlRes885QhQrq9mVE221k6YoeytqqLikFglU=;
        b=FrFOil/AiwbUfThggtdiJH3dfuKDsSxRS/7Ll2p7vpm9hbQYzbDV3lG8r8lFxdvzdy
         0SUKXFBWcdd9TKXy04jkHzaNligPt6LmONF2EijF2KTdPS9S+G41oqGR/x19P88nclhZ
         mUd7z1IT9FnWUEvW/4kZmYyrMzb1NzheBOzIFBCebHw4TW9AewFouUYlXFQQsWhPgrXy
         tilvJ2Y7N/lEqEesuPMVcYPVOKk4/HcmvM7pE3ZVjYyr1hY+PzGlfH5r6aG/H84Gtlkt
         YigokvbP0RcAoIvwHaCYsXHnw2Fp3YeZqDk+UnyLOP8mtVoC1Hj6eSgrbNQjcda/keOq
         hqhA==
X-Gm-Message-State: APjAAAVCoFjuxfG3WeO42/J2WEw+qD1FCexXeE/I1g1cRmmBWRJQJrTQ
        YNudUnj8GVzD/uwAkRiAhP4=
X-Google-Smtp-Source: APXvYqzUHszTMCf0FqL0C12el1+4vYG6LYW8ml5drC1eMYBiTn4AhQh509XXdc2m4fyznpBj9tVZ/g==
X-Received: by 2002:a17:906:d052:: with SMTP id bo18mr88285067ejb.311.1564586030665;
        Wed, 31 Jul 2019 08:13:50 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id u9sm17451892edm.71.2019.07.31.08.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:47 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id B852D103C08; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 29/59] keys/mktme: Set up PCONFIG programming targets for MKTME keys
Date:   Wed, 31 Jul 2019 18:07:43 +0300
Message-Id: <20190731150813.26289-30-kirill.shutemov@linux.intel.com>
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

MKTME Key service maintains the hardware key tables. These key tables
are package scoped per the MKTME hardware definition. This means that
each physical package on the system needs its key table programmed.

These physical packages are the targets of the new PCONFIG programming
command. So, introduce a PCONFIG targets bitmap as well as a CPU mask
that includes the lead CPUs capable of programming the targets.

The lead CPU mask will be used every time a new key is programmed into
the hardware.

Keep the PCONFIG targets bit map around for future use during CPU
hotplug events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 42 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 8ac75b1e6188..272bff8591b7 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -2,6 +2,7 @@
 
 /* Documentation/x86/mktme/ */
 
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/key.h>
 #include <linux/key-type.h>
@@ -17,6 +18,8 @@
 static DEFINE_SPINLOCK(mktme_lock);
 static unsigned int mktme_available_keyids;  /* Free Hardware KeyIDs */
 static struct kmem_cache *mktme_prog_cache;  /* Hardware programming cache */
+static unsigned long *mktme_target_map;	     /* PCONFIG programming target */
+static cpumask_var_t mktme_leadcpus;	     /* One CPU per PCONFIG target */
 
 enum mktme_keyid_state {
 	KEYID_AVAILABLE,	/* Available to be assigned */
@@ -257,6 +260,33 @@ struct key_type key_type_mktme = {
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
@@ -278,9 +308,21 @@ static int __init init_mktme(void)
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
2.21.0

