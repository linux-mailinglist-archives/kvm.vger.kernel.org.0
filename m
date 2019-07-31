Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16D47C60D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfGaPUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:20:12 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36492 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfGaPUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:20:10 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so66068449edq.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vwkKEN+NO/42LLW7V4MVtQKdg9NG9HC4dwr+b7oU7/A=;
        b=Uf1FCuDX52sEvKUCsJficveOp2kKNYX4EUGxdRJNZykLCtDIIDHpegDxYsp6cPe5pW
         EAoTzT/6HRwwAnq5QnSYpAtuKu32nvYS2kUdpN1mP4PQQ10UlxLyuA/tskPf2FIwxPud
         pUuxivdUf/yz+Tp+pjhIEiW+/6YgFS3K9zGL+Qh3OQ4/mioDDDPpCShm0v2J1MgLE8ff
         LAdvm4H5jX3b3WNwtdu5V9RM3W2HZGEtg1DkZ1XkWQ5ltdRlOKm5W2OJllK1ZO7oeFpf
         AvmUIe2HLJhkTNVz6b9FQaFDlX7qZyFGnnid7IyU8Nt0XiTLAB+dX1L/C7HwTI3yhcZW
         +xaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vwkKEN+NO/42LLW7V4MVtQKdg9NG9HC4dwr+b7oU7/A=;
        b=NGnBEI8WEV1mcHP8ClIvAeYtIHzfWDPxoNhbJInyCvEDcUW/dDQNsADywJeTHHhrnk
         tOdrl2YpgbQ4EtI+Woc90N0I3MhBzvzfcMwEzkbx/tCXNgrJab5IUFEdEQX5TU/FbjSM
         0tv06qjQheGbq683BYo3kGQjXbs5E2bUmq0ruwgfGWaa7BCUWYgfXLNcsVt47IqFkOFr
         5TfiDj5LxkCF6C6pbDrAaB60c6SUNxsEZkDa+Bd7CVwFKJMtyj5W7M/Hk487pGumbnWk
         v2ByXjHHIjYxDr/znuFkUb/3ohqdwahMy0JnmsKTaAXCn4dadWbJttTaY7HudG/rgFc9
         qSrg==
X-Gm-Message-State: APjAAAWYcm4lVoEjZhESDfc6unqF6Ev7dfzkB7NHoi/Itl2SKG8MXhge
        RCbzGqZz5DXz84lel4BhAhk=
X-Google-Smtp-Source: APXvYqzBhlGdHrkZxNCta+YbwIpYcpSQldx/aTh7wiP6WOvFi0hxTn7lmyACen/6coFCsBG0rQq5SQ==
X-Received: by 2002:a17:906:43c9:: with SMTP id j9mr92667128ejn.248.1564586034633;
        Wed, 31 Jul 2019 08:13:54 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k10sm17260344eda.9.2019.07.31.08.13.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:53 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 103E71045FE; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 40/59] keys/mktme: Block memory hotplug additions when MKTME is enabled
Date:   Wed, 31 Jul 2019 18:07:54 +0300
Message-Id: <20190731150813.26289-41-kirill.shutemov@linux.intel.com>
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

Intel platforms supporting MKTME need the ability to evaluate
the memory topology before allowing new memory to go online.
That evaluation would determine if the kernel can program the
memory controller. Every memory controller needs to have a
CPU online, capable of programming its MKTME keys.

The kernel uses the ACPI HMAT at boot time to determine a safe
MKTME topology, but at run time, there is no update to the HMAT.
That run time support will come in the future with platform and
kernel support for the _HMA method.

Meanwhile, be safe, and do not allow any MEM_GOING_ONLINE events
when MKTME is enabled.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index b042df73899d..f804d780fc91 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/key.h>
 #include <linux/key-type.h>
+#include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/parser.h>
 #include <linux/percpu-refcount.h>
@@ -497,6 +498,26 @@ static int mktme_cpu_teardown(unsigned int cpu)
 	return ret;
 }
 
+static int mktme_memory_callback(struct notifier_block *nb,
+				 unsigned long action, void *arg)
+{
+	/*
+	 * Do not allow the hot add of memory until run time
+	 * support of the ACPI HMAT is available via an _HMA
+	 * method. Without it, the new memory cannot be
+	 * evaluated to determine an MTKME safe topology.
+	 */
+	if (action == MEM_GOING_ONLINE)
+		return NOTIFY_BAD;
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mktme_memory_nb = {
+	.notifier_call = mktme_memory_callback,
+	.priority = 99,				/* priority ? */
+};
+
 static int __init init_mktme(void)
 {
 	int ret, cpuhp;
@@ -543,10 +564,15 @@ static int __init init_mktme(void)
 	if (cpuhp < 0)
 		goto free_encrypt;
 
+	if (register_memory_notifier(&mktme_memory_nb))
+		goto remove_cpuhp;
+
 	ret = register_key_type(&key_type_mktme);
 	if (!ret)
 		return ret;			/* SUCCESS */
 
+	unregister_memory_notifier(&mktme_memory_nb);
+remove_cpuhp:
 	cpuhp_remove_state_nocalls(cpuhp);
 free_encrypt:
 	kvfree(encrypt_count);
-- 
2.21.0

