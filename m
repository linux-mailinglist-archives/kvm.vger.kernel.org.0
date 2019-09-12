Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72271B1317
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 18:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbfILQzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 12:55:09 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:40277 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729855AbfILQzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 12:55:08 -0400
Received: by mail-ua1-f74.google.com with SMTP id i15so5030909uak.7
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 09:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WGsN+0gnskfgmbT2Sq3qhm+zIRmQlrdOfG0pAfSyggA=;
        b=qy/eiIN8wnwN7m9OlWHDf1YGIOAWBPmtMkYywYLLYnKjc70RfNx4GGmlzWX4sfvoHk
         3jwcf88ZHCvu/6BEt3nSgzyX+D68Ig5vslzDYINTyJbHprpYIteGNlSLFErZvyma4GnW
         gz9+MgukeLA2OgvCHxvXluQHBAs6tSdie3QrFbTtlzX1I2qgWhOqtfhS5xVRRY3A+phe
         xbgAKv4JUMFdJojX3m2dnuXfZMPcPnwUUN2V1FgBM9jDHJ2MW1q15izmkZCjw7d9sgM2
         CF3W8jKQSP32TtKY3ii84mgdZdR4nflqY8J6ZzwFf/Ech8wMTFNP10IBZJiD/wW5A5ni
         0qZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WGsN+0gnskfgmbT2Sq3qhm+zIRmQlrdOfG0pAfSyggA=;
        b=lnWg5AlON47e+5RNCPo0peyMLhGVQ9hMHs5gGCp/sNFCwzJLsuyVY+vpvCje/3W3fN
         R68cjPXKbH5cPH9Tenlah+t5UapaviyK7v29iusGFVjSxpfp+4IwmDV5WoqD+uXGzpJ0
         xgZbVQ43qbtb8gOae1y6O877EgWCXZ1dyR5el9ULK2DqhV5KaUeA+i3Zr3J5TYF7T1CB
         rgSa+RuOjmkwkh0Fi1+iXIHyhCnxn/K6bKbqyZpZ3HL1OJRfToWMhRMY+HT+/CsZ7ivk
         Ur65KnXdBKls0nIs0LEfss7yprURQC11gd4cetBIGaYKk6FPG+RNKxPIUWFVH5uzGKqX
         +usQ==
X-Gm-Message-State: APjAAAULhA6VqnlZpFq5puhiKGiTUuk4kZBCNjPhPJZv2iTEFI1tx06J
        JCKp7Zv6L6ciRwSCt99aoqZ4Rom0mzyrwlvp8pw8fOZFt3CKRUslN/+jWo3m8Ifn5mXd53sVUXg
        UR1ELCSXijHYFz3qJzZBvncBJVczyrqS3QJ7y7+TJVmWjCVPhg3Uwaj8MJCjsUCE=
X-Google-Smtp-Source: APXvYqxQ22ZGZXSY39xHw5bdGaja4waKjNK6QSqGVzMaeTb+CdAPVn+XgVJlHf6EIMIicgFomsa9GdaVIMjIxw==
X-Received: by 2002:a67:1a41:: with SMTP id a62mr24910467vsa.54.1568307307516;
 Thu, 12 Sep 2019 09:55:07 -0700 (PDT)
Date:   Thu, 12 Sep 2019 09:55:03 -0700
Message-Id: <20190912165503.190905-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH] kvm: x86: Add "significant index" flag to a few CPUID leaves
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the Intel SDM, volume 2, "CPUID," the index is
significant (or partially significant) for CPUID leaves 0FH, 10H, 12H,
17H, 18H, and 1FH.

Add the corresponding flag to these CPUID leaves in do_host_cpuid().

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
---
 arch/x86/kvm/cpuid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948e..e7d25f4364664 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -304,7 +304,13 @@ static void do_host_cpuid(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 7:
 	case 0xb:
 	case 0xd:
+	case 0xf:
+	case 0x10:
+	case 0x12:
 	case 0x14:
+	case 0x17:
+	case 0x18:
+	case 0x1f:
 	case 0x8000001d:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		break;
-- 
2.23.0.237.gc6a4ce50a0-goog

