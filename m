Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C3DE2C0E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 10:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438163AbfJXIZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 04:25:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41308 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfJXIZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 04:25:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id q7so14654619pfh.8
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 01:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hU4CSfYQ63kVLgy0WVaQhgAkxDVhbStNM/XZwCb+pGQ=;
        b=U9u8BEdrLTYHLxCVdyQ0V3Y9WN+h7BAw+8VyGXYlT9ZP3asAjaEXBACXCqMN4KXHYe
         uLywqbK455jhL6IPGKnE6y0j70ntK1RebrLODaHdhATZ2DD0pa0VwmRM5BodqYFaS5vI
         eSrq1ykqx9GRBRlJNYTQdiJy4dnbKU8jI8ZlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hU4CSfYQ63kVLgy0WVaQhgAkxDVhbStNM/XZwCb+pGQ=;
        b=YazfgeUmpx/5GTAlJDYzH/L1tA3AkeofcZx/DY0rIE/aGvoEKSNHoEVoB3viXkEnU8
         62JN744hBoIneCxiLgYrTDo75rsSWY2nQnOPC4pbj5Fn09aqG0hf4dFQahxBld8d33Je
         wIw4+hGJ3MXpECn1bte6FZ+hgeDfBOnXe8dJ6jZlBa3XMUwpzTNdkvKalTQ81Z5ofxrD
         FOKH4gUEqNMo2zSWhZtXbWshFm0/FZMX1ropytbM/KyhkvHzMjb8lJfjjy2p8S3bjazS
         pM4Ki1tJJDaaA1WWCmAxJq0mEkEawWEuQRBwHnwX8OjwpZudB5qLUqrzqUpaNJ1KqM2r
         YK8Q==
X-Gm-Message-State: APjAAAW29V+75kqFILLm9p46J+dURmt0Q4T1W22ui6tpJ+XXdywK7RGy
        3wIcd1ghV9ZgEfEbAo7I5nHFXKm4Sdo=
X-Google-Smtp-Source: APXvYqxYgKGNKdKEdxny+mlNOsqHTeUjdWWBTF7j0sC5yb+u8cuCSfcI6+ysPtBlh7uvWJTi2z+Anw==
X-Received: by 2002:a62:2643:: with SMTP id m64mr15526339pfm.232.1571905509576;
        Thu, 24 Oct 2019 01:25:09 -0700 (PDT)
Received: from localhost ([2620:0:1002:19:d6d5:8aa1:4314:d1e6])
        by smtp.gmail.com with ESMTPSA id b18sm25951736pfi.157.2019.10.24.01.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 01:25:08 -0700 (PDT)
From:   Matt Delco <delco@chromium.org>
To:     kvm@vger.kernel.org
Cc:     Matt Delco <delco@chromium.org>
Subject: [PATCH v2] KVM: x86: return length in KVM_GET_CPUID2.
Date:   Thu, 24 Oct 2019 01:24:52 -0700
Message-Id: <20191024082452.165627-1-delco@chromium.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191024052918.140750-1-delco@chromium.org>
References: <20191024052918.140750-1-delco@chromium.org>
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
 arch/x86/kvm/x86.c   | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

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
index 5863c38108d9..701bf4f4f6f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4161,12 +4161,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
-		r = 0;
+		}
 		break;
 	}
 	case KVM_GET_MSRS: {
-- 
2.23.0.866.gb869b98d4c-goog

