Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC318E29E9
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406766AbfJXF3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:29:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37266 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404071AbfJXF3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:29:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id p13so37006pll.4
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 22:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MePgjdi/Ed9y573bxV4jUy7lIcKKe70AG165bjiiX1k=;
        b=ahC/OJwgE1PgJ1qiAk9afmQHhtoAHR7R2WcyYbYckM9pt/LuRx8EYKvyTQhdj/snUd
         e06jNlIcf3AqkY2U3oGo0cNTxgDAx3yN+lkOHOJBMHUN5vU5x6JodQPq1bCC2JYaEJRt
         8pTfmW0wr0YTXTBii9CYct252hl0oS78EwqBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MePgjdi/Ed9y573bxV4jUy7lIcKKe70AG165bjiiX1k=;
        b=GC5unEfHPCTEZ0e16S1dOiTfJ+8qYC1ktXhGinavbD93qTie6YYW5RsNw6j8iIcRQV
         Dl3u/Yif1rOT+NGVzIAqiEmBO+Na4N5XKCu/PwaR4ECtgkv538vmThpA9qtCllkzh8MN
         91aKnavDctJEVD4UBr/cdC0HvdhQJK3vdH8nnKEhTNHqesV6RtYIAqUcv09cMtdKDQFF
         /9YHMYKm4JjHvykgEGxOnXuchGr4J9Co9vlgpV0/tG8t7YxQgGUEjYCvbLlbCwUcmkX2
         f/8GsPyosz1dVh1hfKaRgqZ1jLjrMeKB5gKh3PfHRzEaCjcgkrCO3+F1aPiXUzR2mJx8
         wbqw==
X-Gm-Message-State: APjAAAU/TpAj8iLko2PPK4tIq6PlGPRM39vhkNPnHFsfHtzBdi68iHFt
        /sjajJ4IgnuTPM/nPJAdypglSN9Z798=
X-Google-Smtp-Source: APXvYqxL10Pw/zaVUwgC6Nbc/IXk/HSCieVNPHD0W/L0t7bMoGTzhj2/TB9vNI5bkE7vGJ9C//4R2A==
X-Received: by 2002:a17:902:be0f:: with SMTP id r15mr354746pls.72.1571894972396;
        Wed, 23 Oct 2019 22:29:32 -0700 (PDT)
Received: from localhost ([2620:0:1002:19:d6d5:8aa1:4314:d1e6])
        by smtp.gmail.com with ESMTPSA id o123sm14765923pfg.161.2019.10.23.22.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 22:29:31 -0700 (PDT)
From:   Matt Delco <delco@chromium.org>
To:     kvm@vger.kernel.org
Cc:     Matt Delco <delco@chromium.org>
Subject: [PATCH] KVM: x86: return length in KVM_GET_CPUID2.
Date:   Wed, 23 Oct 2019 22:29:18 -0700
Message-Id: <20191024052918.140750-1-delco@chromium.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_CPUID2 never indicates the array length it populates. If an app
passes in an array that's too short then kvm_vcpu_ioctl_get_cpuid2() populates
the required array length and returns -E2BIG.  However, its caller then just
bails to "goto out", thus bypassing the copy_to_user(). If an app
passes in an array that's not too short, then
kvm_vcpu_ioctl_get_cpuid2() doesn't populate the array length. Its
caller will then call copy_to_user(), which is pointless since no data
values have been changed.

This change attempts to have KVM_GET_CPUID2 populate the array length on
both success and failure, and still indicate -E2BIG when a provided
array is too short.  I'm not sure if this type of change is considered
an API breakage and thus we need a KVM_GET_CPUID3.

Fixes: 0771671749b59 ("KVM: Enhance guest cpuid management", 2007-11-21)
Signed-off-by: Matt Delco <delco@chromium.org>
---
 arch/x86/kvm/cpuid.c | 1 +
 arch/x86/kvm/x86.c   | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f68c0c753c38..ec013b68b266 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -274,6 +274,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
 			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
+	cpuid->nent = vcpu->arch.cpuid_nent;
 	return 0;
 
 out:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5863c38108d9..4998d3bafbfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4161,11 +4161,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			goto out;
 		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
 					      cpuid_arg->entries);
-		if (r)
+		if (r && r != -E2BIG)
 			goto out;
-		r = -EFAULT;
-		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
+		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid))) {
+			r = -EFAULT;
 			goto out;
+		}
 		r = 0;
 		break;
 	}
-- 
2.23.0.866.gb869b98d4c-goog

