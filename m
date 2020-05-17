Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063241D658A
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgEQEID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgEQEIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:08:02 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80D8C061A0C;
        Sat, 16 May 2020 21:08:02 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y18so3101002pfl.9;
        Sat, 16 May 2020 21:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=BFVxc2ZI78KGf/zhRS1Cy4doNnfNpNMWbMfEf9Ie1/UOC8DP2nNzN6KSWIdONJ5bLy
         XAVbOClF+D5dAx7gN2FTk1gCm4MFf0gMBIaYapxnkTnSuKTdRtS6E6waaeLV73vvZKjO
         /EdotCX9ti4edbJnjOLzvYmaEcvH8u6cu6KF5R64sKd8h1HDXmOn7WnSu6zziPsos7FR
         r0wxNpHYPXKf7m496mawemlOkh+6aubudC8UFj+6DvuvOjmDhwtDXYbjHs0p+ZEsvKqr
         12O71b5cvouqNEiHZlhOOOBn7gkJ5VQnvS+dn09fHJY19+rvdo5OoKhnophDPjeNKM3J
         LIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=coa4fGzcWRprAcB8wcTQfR+OLpbKvB10OA0Zt+pvabwCkUrFrx620I2fuW6daUw4+s
         iQoO884DjloOWunU/osC53uhnHJB4+4BJR9dmfBRr2HRpVQT8vWwjuymoxycj2KTGxs9
         kp1qVgGF8Wywm8q0EuIyFiYpynHfgnLDGtQZTDxITb9/8bPSNK9+saFAxFWCq/R9ApVY
         Hqvoy5u7LxNJpEjxbfeUoznSyubpQWGakKSMSkJ4sD4g5mO6Ik/AAgoN0ktpQVAaydIj
         ZbdasYCa8eWb+NWVmEIBGfvV9NM0HKPk73ekc5d74QXAy/N2K4gMRlAMgnEl9Hen0QxO
         b9WA==
X-Gm-Message-State: AOAM531qgGs8PFr15XKCPX0sSCqTVi7H04wPHq6fphGGLJWCOy4B8jms
        5P3l5PLZuvPsRs/dGTny2AA=
X-Google-Smtp-Source: ABdhPJxNj6OKq3mfEnUPiXV9eF5DMn3S/jFGWgixLOgRQBVIheaJ98ZYL1V7JZjOClrGD0aWYJQcnA==
X-Received: by 2002:a63:3c8:: with SMTP id 191mr9688368pgd.320.1589688482502;
        Sat, 16 May 2020 21:08:02 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.07.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:08:02 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 04/15] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Sun, 17 May 2020 12:06:01 +0800
Message-Id: <1589688372-3098-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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

