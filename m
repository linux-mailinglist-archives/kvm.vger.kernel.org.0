Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6C1DF5D0
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 09:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgEWH67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 03:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWH66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 03:58:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5766CC061A0E;
        Sat, 23 May 2020 00:58:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f6so6100906pgm.1;
        Sat, 23 May 2020 00:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=Uph2LgoHB1cXB/WhCHVwFu8A7WUEzzlelXQTXXM0hUTIA0SPMgboZ43xKE0dRMR/yl
         PZT8eZrChZxp8yrag9eta1RsR25P9IpNw/gPXKH73HvI+mwFlajrLuqJZ493jHuapog4
         kmafZ48sSlnGb+Q3yWoDeO+4VSHU8+mR36Y3t6+1g7+1+hVISSSpv8yPI0IVPhOg7zGg
         vniMaGsMfRQPldlMsq6muQP+RN0sWlIcBITPHaqtNJHQwneDwNTdL4/kJ9M4LGy6bWwQ
         WnxXuRabArkV1hbw95Gu+H0j6cOUvZG9NaLQavdZYHQeKU4JqZey/acVRXOmemA4cY8S
         za0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=Rf/AWp/FczBKo0+zmsRyDa/3hVlokTdMuxoHgEG7ye/rlqp6GYZilH/a19uzaXzs/H
         aVp2PwwHTvipkzGb5yLVUSgt6YgE60KtS07BzzskA8/HitMdkrFv0RMMGv/3pqZaIK2D
         nxUWSbfPKDx0FYdGVABVz6J4Sx67dTiIidkRbVB5Fk26ZNjyIZ8L73HwGokC33tsHF46
         T/ti1qYkEvNgL1wD+sJrhkuEfsIqHN/JbcMVpBJdG4GJYCEGxxcgG4xHJfIgERC7gq2G
         DX9oTLr1YeyzjkGbrTXvubwX9VIpJioZKJIKlRTCi1zIcOBEF1bi/1x/mkJkQl+Oy9nq
         6FLg==
X-Gm-Message-State: AOAM532nCcatxYhsbQ0kAV5aR0VyikH2IQyAcJugNBvF7tALn6Q3Lgxy
        RKOkjD0fbYITGjrZ0okcfBE=
X-Google-Smtp-Source: ABdhPJylAvBCwBzjO61OAlyLaKhgpUctSmazm0GF9zxWlwr6mwBApGf+CQOCoWzq6oRvftpnsewdgA==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr17440612pgq.382.1590220737933;
        Sat, 23 May 2020 00:58:57 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.00.58.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 00:58:57 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 04/15] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Sat, 23 May 2020 15:56:31 +0800
Message-Id: <1590220602-3547-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
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

