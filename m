Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACF41A6397
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgDMHX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMHX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:23:27 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93167C008651;
        Mon, 13 Apr 2020 00:23:27 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t40so3484289pjb.3;
        Mon, 13 Apr 2020 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UVCxTnXHR3JksW4kNoRPYShJz0VQm0+u2ggksb/zVto=;
        b=YHKwQhQ8uYspWZKAckCJrtm72ODPhNdButAAJ27i9ZCefOlJDY//J9k6k+KGCG9+LI
         cljDdKd298diKZYs+1YwB3L5xRmmtSEe/0R0Tp1qGy9M6exVw2H/pM0AR7NFXsnsCwsL
         KwMoI/aRYOokKR/ub5d6FFHj2R0A/J+Kb8Fb1ozpAvLvzUq2zcJbQSC+WGsJ3InM64ER
         udEBtFP2AoLf2+YyzXXveF9V88yw5U5iNUEcF6jxoDOH+cd0NIROOZWwjuT7nwJ1L7MN
         zRJY4HD+dc2adbLRErSmlzHa3Rw6gJgc1PreAdODMduMyTn2NCpp66X0scK2Q54ikpur
         Ljug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=UVCxTnXHR3JksW4kNoRPYShJz0VQm0+u2ggksb/zVto=;
        b=tyOl1YgnwM1W/RNrRPSjVbTI2ypD42HarQfXFfo3ErUemWQ+OT0VRhyJAcQybSGNav
         Y9l8MIijAusjuZvSE+/u1wknqei4xxXSbSOyPUehAyCAxBgqEfqajXTFXhWmoX79l8Ws
         pbYHjLvEDnE6bwwHtOOPoFdLdQflBDaPwEQhb3qJcCqG+GnHlkD7gPFn8HCkA2sR/NnA
         b3hDD7n2HttJgrZmV9anzXQn7bqIV0KJr7H4QVupmMLjIZty7VeaegvA0N6gK5bcj5Ad
         nVegnA30WrasKUQCHObICqymxrjBOurMpW21Oq+itLcDUGw9WvqfGnXJl4uo6/MA//PM
         vbBA==
X-Gm-Message-State: AGi0PuZ/m8P/gHmvWNWPuc9M1w1OTGIWDd0zRP7L6wMlhRMfbczTg+fi
        qUCLZbMKZ0qmA5PZcNxg5u+I38d4irc=
X-Google-Smtp-Source: APiQypI1h6KmTeIWmHIup4Gdrnsdh7SfYOYPE5/YrcJrz5mweL0LD6nQ/PM51Xkrsv2zk27QQYZkow==
X-Received: by 2002:a17:90a:fe18:: with SMTP id ck24mr21510792pjb.57.1586762607056;
        Mon, 13 Apr 2020 00:23:27 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.23.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:23:26 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 05/15] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Mon, 13 Apr 2020 15:30:14 +0800
Message-Id: <1586763024-12197-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add EVENTFD support for KVM/MIPS, which is needed by VHOST. Tested on
Loongson-3 platform.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/Kconfig     | 1 +
 arch/mips/kvm/Makefile    | 2 +-
 arch/mips/kvm/trap_emul.c | 3 +++
 arch/mips/kvm/vz.c        | 3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index eac25ae..80b0464 100644
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

