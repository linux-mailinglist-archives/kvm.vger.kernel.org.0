Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1931DFE84
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgEXLQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgEXLQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:16:52 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A52C061A0E;
        Sun, 24 May 2020 04:16:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id v2so2469158pfv.7;
        Sun, 24 May 2020 04:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=Tjb4CxjojiaZLNdFFhrO8kGHDDdZ4dZyHshqItHq7qudrpBlrv1AEi6uAxzjzIZzJz
         d3TaVu1Gt65xDUgcq/nD3o1NMeIzdIF1b2MBbcVmQsyUe51oUqAwFoHVDLTXuCeIitkU
         FHB7uPg+rLVMYh2Z7viO0o192blPJFnhzFB/jeaBY76SO+mUTKnAIYZIJFCePhtdVTCY
         jidsQ23YtJnVhHWyRCI/c//AEcpU8o2awP9/lxezIgrTG/l3nu1NgjRNJ28m+3Ea6Re3
         f5OuxbtSPM3wKXX2FlkXSvPi1G/LqSKBm/PG76DiwXdz5IgL/jSiB6CI/maM8233KwHW
         Gjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=tLaci9RJqflxmR2jQRFtvJAhwSsN67YV/JkJ5qdjAK/DLZgicGmsrnADUoCK1Vv6wj
         Ph/wF5bkpTay3iAvI2YSUaRenbP2Rljs3/XzOiciZsu6aHtxU9XG1pf8Qt+e+52IPAq9
         lLBXSKlrDTS2S707MIPfXlbBt1R2Zxiqu6L2zq2kZzMaXhtk6Z268iF37icNvoMbh2DV
         rzdbQcCC5JzetOwXJYsy6NC02We4ytxaAm3ErHcWGhVC0FD5FTCDmHN2NqSqdSVU6UTZ
         M8pm7z0QztoMFz6YTtBjjtgd9k4kFYVLaDRiLpiZijUipXp+L8zkOnP+NA5BAGummlEv
         369w==
X-Gm-Message-State: AOAM531Xc7ptPxFWA4fwbKj0MRzS1MZgFYEQ+IndPZ0EEex/V1ArsHSd
        cmB/Zjt1SuuD906BHphnZwM=
X-Google-Smtp-Source: ABdhPJzcSaAbfkPXZHBY4XpeMlKa+5LfY8hxpdKzRDY6LEUzS6zuFFUXV+qMtcjE5BuvdIgHQehe3A==
X-Received: by 2002:a62:8c42:: with SMTP id m63mr12175764pfd.106.1590319010743;
        Sun, 24 May 2020 04:16:50 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.16.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:16:50 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 04/15] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Sun, 24 May 2020 19:13:28 +0800
Message-Id: <1590318819-24520-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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

