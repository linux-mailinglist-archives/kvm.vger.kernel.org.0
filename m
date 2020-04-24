Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913BC1B72AD
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgDXLIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgDXLIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:08:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E06AC09B045;
        Fri, 24 Apr 2020 04:08:45 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n16so4471334pgb.7;
        Fri, 24 Apr 2020 04:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oXmStsagWliYLkyg0XA1gqk4mbLGloO7btJZBgB6zp0=;
        b=meWGYT9RVbPO04cPKGRwK+OKw6tv57EMyssUrfLTRO4sc2CCNxV5rRlt7yMtp/WqvA
         4ntbb+9niZTXt05qNRnNQrD9U+FtaHGEkGkror68oZxgok57+DuXVN63l+o1X8xPFwsw
         dvinIJHumsGiJasZ9lELWIfdrOlNXwjVMoGFUBmoG6e/vHla/9sQIlsivwNp5PN0FzQy
         O0gmfhvDoBuloaBt6KbPN1BYBPH0ZvYe25Rg2wZ30B0L9Pxr3ta3RDJUc7dMrnrIT64o
         IhoUXcxe2myF1+GFwOJi551WBZQHjghzG+PZ3l1W14sbZw2EsRRAZtbQPyt6zqsqUTDU
         +UVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=oXmStsagWliYLkyg0XA1gqk4mbLGloO7btJZBgB6zp0=;
        b=L0D6qA2Qg2MCPgoJhNTvj8tV3WhnEeiHXypdSKgl3K+8zB8cUHXN3L1H/fTPeFXwR7
         WQUfV7MV8k+FSB4ShC4G4gpLa4Cqto1Ds9VcxQ2BLRhQKC4YFUInfox54WRB+iTxompk
         +0A7ODaP/CPNwFJWqzflS1/40z9cqjiHX+FHpSOxP0Es7NSL1dviFgOfzf0lqEf9pbv9
         4MnabdFZm1pSWAigmPjitZls83ocAmUyyyOu9yEEmURFWHxUMu9eYQZJqg7QDO3poCyk
         MDzNWgsm5w8O8oZ6eW+eVPHh7YFF+EZFZ86HxvkcNG28qmh/WZ5mbvkaa9StzfyFswow
         Xizg==
X-Gm-Message-State: AGi0PuYS2UExmAQaeEnMHy1sXTfSUvVSPtOvVZR+ZSN+oy0jFUe/Lx3a
        VX09cBnoQuHojofUazFx1+M=
X-Google-Smtp-Source: APiQypJE8ZRY8ztFaZyZIEy/MUzMmCxWsX3tlCjHm6mtObukFH3nGinGeqh0CxoUdfP9VjkceRdsYw==
X-Received: by 2002:a63:111a:: with SMTP id g26mr8322645pgl.245.1587726524906;
        Fri, 24 Apr 2020 04:08:44 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.08.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:08:44 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 04/14] KVM: MIPS: Add EVENTFD support which is needed by VHOST
Date:   Fri, 24 Apr 2020 19:15:23 +0800
Message-Id: <1587726933-31757-5-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
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

