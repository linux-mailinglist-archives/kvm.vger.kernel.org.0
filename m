Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01261CF27E
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgELKcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729429AbgELKcs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:32:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A473DC061A0C;
        Tue, 12 May 2020 03:32:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f15so5200550plr.3;
        Tue, 12 May 2020 03:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=b6G4ttoVTX7wxC7sy8no6J4tkFCpa/GVR5VVnIRfabpKWTvCb/Vv/iaJvPNmpqiLYp
         HGS2GjNFzxmU2Vr9+gBIpRj2/DQLq7VbOSnKazQ8iK1Ax8YK7hj8+VF2MJH3GY0G4W0R
         +SnJIOtTxridBJeY6eoPt7DSAsGcRIszP3XvOIXsuK26++Ob5/e2Ncmv1RN1TsMJeLun
         jOoaePEIiUotMQoBNU4UDH4PTsNtGTQPAFzr9VNP3mu+2trwOM4uE23Ov6sP0OnQoUcr
         1Oh3mwtwhilNMgahnnNNyAKS+Vls2oBxQValF/PYH6tXHq+Eq6q0N35Zp6WAL7tI7Ygq
         Wj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=f7usDonl/A5hTv3suUOh3tWmU05gvgnEmUa40fjrCvs=;
        b=HpdMfnQwb6TkUfta3dYeAG/YcT7qYwwczzWjOcImN9jDMhTZdvjtPhclY8q06rpnlk
         7goS2YR4lA2MJCFJABTuuF47G3g3wtZX1NtYWCgfCgZnAM5uY6ar/bUqfQ5pIIl3UBN0
         WbwhXSl42nyetYs/fH4viUXOv4pDzXE7LZr7pBUaKEpS/ZnhaCQofs2nwI9tlztUJZqs
         5ip+//ByUnZ+2aqEjIodu0frsPMDCCqIht+YeL2fzGpiS8P/ypsDwrnXYbqALYF3Or+A
         V6emJJh1zUdhTgOSdrFCUaF3Mj9GTno+071VuH2ZzBZPCPXV9dk9YqspKmfE3VHazepo
         k10w==
X-Gm-Message-State: AGi0PuYSxYABCZbrGlrW0XDIv0I8/WV3goIn1VX+ukX9hwNj9oDPpBvc
        CrqkMqJDjNJAgzO3evaX+7Y=
X-Google-Smtp-Source: APiQypKA2dTVfj6QMF53Boqu3uYtyOZFFqtCqqv8IPUPJEJhKPr1Jirj90DcZQAemkkB84nFD02kRQ==
X-Received: by 2002:a17:902:6b05:: with SMTP id o5mr18418392plk.274.1589279566242;
        Tue, 12 May 2020 03:32:46 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.32.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:32:45 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 04/14] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Tue, 12 May 2020 18:31:10 +0800
Message-Id: <1589279480-27722-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
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

