Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE6D7C65F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfGaPXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:23:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33683 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfGaPXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:23:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id i11so2570925edq.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pyaxzbpsx58odlzi9CMlCU1WWA9qqTOgEqw5C9FEBVg=;
        b=TdeP43VIsvZBSvidBd63JYHMxnbdwhhCTLKUiBkNxJ1dN5ZesnIcrufzgwhWgQyHPq
         i7R3oVQxFEJynf2mhmWeT0e02bFtLfYtRn6p0VgZ/9Cfk6L2HmVLTwyWiesqSFHcOuWI
         C7Kd8pQSESCHFSvOb3B4KDGD0ws8qGv6qEQ5VxcXS9cAH00eVayINE6xKGf1l8i8BukU
         egoKu79G/bPpu3bRP9GqYkSE1/6ni+LU5rtZqvn7BKSJqvWNGHFJFeVK/BRE5mk85JT0
         SAUKBlIR/5r0VZdnIOVvK9sEH41/fY04cVEyxQuZT0wYs85IiJA+jJz7ToKIsDLSVFEp
         FYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pyaxzbpsx58odlzi9CMlCU1WWA9qqTOgEqw5C9FEBVg=;
        b=t6C95crUbaTZ045OKjaNE/IzJpPd/QIpkJRnPt6KXxNFktRbiJRHrukiTpa6X5zZ0j
         4CGsFxpCFGe4k2Dt2xDHlsRIBGcRnmWFUvptnTO22iHJYGJCZ+uvlAhAsKEX7+iVsDqk
         cUpQwFPJjigTTXJUR1YOcKCzvfiF5nuaEyza0T4IFVo+WHN+SyJUqCQP+DGhIdE7W4Jm
         vjMNn6SFPm28uNHMEbh6q0l3XlsEEsEPlwqwmXjNRXu5FOLq3KYpqS8/4wQ1OPGfD2c4
         FB3wXYrdvpSZuFTQs1K+pVnSPjb5QVcwk4TSKSBtwES0KHJ1TeFexNjno16zwHYqHFAH
         igjw==
X-Gm-Message-State: APjAAAXxT0JQHn7o7dDldG1a0w7vxtyQsFSos2FG+6aMTW/FxD/zbruh
        PMTsP+0bq88rzjy1U6AebrU=
X-Google-Smtp-Source: APXvYqwvQzZ9XL8yngupcDep2q/KvYsUDRxmOX5VsyvFeZ5aPPfxl5er8kzo/CVzwYry0AvSpyXG9Q==
X-Received: by 2002:a17:906:5409:: with SMTP id q9mr97412776ejo.209.1564586631213;
        Wed, 31 Jul 2019 08:23:51 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id u7sm12527377ejm.48.2019.07.31.08.23.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:23:49 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id D3EBD1045F6; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 33/59] keys/mktme: Require CAP_SYS_RESOURCE capability for MKTME keys
Date:   Wed, 31 Jul 2019 18:07:47 +0300
Message-Id: <20190731150813.26289-34-kirill.shutemov@linux.intel.com>
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

The MKTME key type uses capabilities to restrict the allocation
of keys to privileged users. CAP_SYS_RESOURCE is required, but
the broader capability of CAP_SYS_ADMIN is accepted.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 1e2afcce7d85..2d90cc83e5ce 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -2,6 +2,7 @@
 
 /* Documentation/x86/mktme/ */
 
+#include <linux/cred.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/key.h>
@@ -371,6 +372,9 @@ int mktme_preparse_payload(struct key_preparsed_payload *prep)
 	char *options;
 	int ret;
 
+	if (!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
 	if (datalen <= 0 || datalen > 1024 || !prep->data)
 		return -EINVAL;
 
-- 
2.21.0

