Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28771D0B15
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbgEMIoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732346AbgEMIoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:44:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAD6C061A0C;
        Wed, 13 May 2020 01:44:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f4so485414pgi.10;
        Wed, 13 May 2020 01:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=D8D4LgCoZ43qHLN2bzSTPOySRlsqI0r/jwx5W2pLh+xzBxUd/aDNm1Z2XqMm7mqeji
         BLgiY4PGt4maVBZd8tLLmX5MhbYQuLb/g4TQyKNjDhcfuTi1naJAQ5YysS/Q7Gh4aZIn
         LoEZBwLJg5795aGRWc5oBOWwn5cmBDOYw0PLu4liXLv5qRVSz0gamsQYCnaTQpKQDOh3
         /e1fW9KJz5SwS0QaNM6zTCosZjjzZY6NHpJSeky00Ojq37KNXAEsxdIWnHkvOhJsCT3G
         GtKoNORCO/R8IRtMFnZDS7LJvXZHdHYwpq0bQFw29vEa/rrL0H7Ec3AJ+fXYltE4p9Ax
         e6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=mfG+gvG7YE5Afp8m1dcmDxBlyW6vEMtvHsuw2VEQwkgU1LOAUqDmVFpzNIl9JdKlsb
         53/jRf4dALwoC8OaerGpakWe+M56gXWQZx1lZ1KtEYW1PDSj+XPlLJO6xqSzOA6IaB42
         ecir5aUl5+p8MmsQ0Dug0rrmAKE4OWVVM++lV8Z56VDnSgadm+gPpcu+qK8FPl6LlkWG
         6cXcKDRf5wReB+yYO4uvhymnGhe/TkHRwubZIAKbqzwzXLy8Biy0s4XrgX2n2KTj0LdD
         SvlyuQB2NvJv90HlCQva/adGhq3C9ZrMiep68ySzPafET/b18Fx1Yc2niFnSZ0xBnbgo
         5Ldg==
X-Gm-Message-State: AGi0PuasbmRsuFf34/+gYFWnCPpN1zXWXdYNrQk88bUlBCMAitWtEZOg
        NfrddXCl9J0E10Qjyt+F0WTJOlklf/aVhw==
X-Google-Smtp-Source: APiQypKgMWHVQ31yci1nZO0Vbp2Io4ESvSfWQ9eebkvZ7U4MClNXrtIRb+QzDf02UAngL4QwaibsBg==
X-Received: by 2002:a63:d252:: with SMTP id t18mr19566149pgi.318.1589359458979;
        Wed, 13 May 2020 01:44:18 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.44.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:44:18 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 04/15] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Wed, 13 May 2020 16:42:35 +0800
Message-Id: <1589359366-1669-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add EVENTFD support for KVM/MIPS, which is needed by VHOST. Tested on
Loongson-3 platform.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/Kconfig     | 1 +
 arch/mips/kvm/Makefile    | 2 +-
 arch/mips/kvm/trap_emul.c | 3 +++
 arch/mips/kvm/vz.c        | 3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index b91d145..d697752 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -22,6 +22,7 @@ config KVM
 	select EXPORT_UASM
 	select PREEMPT_NOTIFIERS
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
 	select MMU_NOTIFIER
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 01affc1..0a3cef6 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for KVM support for MIPS
 #
 
-common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/mips/kvm
 
diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
index 5a11e83..f464506b 100644
--- a/arch/mips/kvm/trap_emul.c
+++ b/arch/mips/kvm/trap_emul.c
@@ -529,6 +529,9 @@ static int kvm_trap_emul_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MIPS_TE:
 		r = 1;
 		break;
+	case KVM_CAP_IOEVENTFD:
+		r = 1;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index dde2088..17932ab 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2927,6 +2927,9 @@ static int kvm_vz_check_extension(struct kvm *kvm, long ext)
 		r = 2;
 		break;
 #endif
+	case KVM_CAP_IOEVENTFD:
+		r = 1;
+		break;
 	default:
 		r = 0;
 		break;
-- 
2.7.0

