Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD621AF7E
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 08:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGJGd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 02:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgGJGd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 02:33:28 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jul 2020 23:33:28 PDT
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88554C08C5CE;
        Thu,  9 Jul 2020 23:33:28 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id B49E41FF17;
        Fri, 10 Jul 2020 06:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1594362808; bh=CCzGY+EXCa8vttsd31JrkpEa2N54sPjPX3YfSo2cRN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB9O6R2Rj9qUc3bq6wHtwUgVS1AlTYXJMmthLtiF+nXKVX6DUJTy+PdxJGRnUkLAk
         uLObB46PzTRRSvhZ3lvOclpxsoEc48HWHTxed8spSZyIlBUt93fsKCdZxk9lcRnJZF
         sP+E8eUuuLFuGwmYqIw20OI06r0jIKQH6itB50t9parqhlAnC5mK5JFjaUQUfeZJ4/
         zcmso5h3lQgN+53WTFoMBVX1mapYszcm0COAB2ZqE5S8mkT+FRuZ0EDxCnOfnF8hVg
         ux5X8W2Xp2OoxYALqmevJiOYlxUs26VzR+Mj1hDjNLZF6gkmNzNn/k8vOu9M3dDoXM
         FtnEe7vsJ0Y8Q==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Burton <paulburton@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH 2/3] MIPS: KVM: Limit Trap-and-Emulate to MIPS32R2 only
Date:   Fri, 10 Jul 2020 14:30:17 +0800
Message-Id: <20200710063047.154611-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710063047.154611-1-jiaxun.yang@flygoat.com>
References: <20200710063047.154611-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After tons of fixes to get Trap-and-Emulate build on Loongson64,
I've got panic on host machine when trying to run a VM.

I found that it can never work on 64bit systems. Revewing the
code, it looks like R6 can't supportrd by TE as well.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/Kconfig     | 1 +
 arch/mips/kvm/Kconfig | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 6bc577f34da1..1bf115a08dad 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2183,6 +2183,7 @@ endchoice
 
 config KVM_GUEST
 	bool "KVM Guest Kernel"
+	depends on CPU_MIPS32_R2
 	depends on BROKEN_ON_SMP
 	help
 	  Select this option if building a guest kernel for KVM (Trap & Emulate)
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 2bf02d849a3a..032b3fca6cbb 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -37,10 +37,11 @@ choice
 
 config KVM_MIPS_TE
 	bool "Trap & Emulate"
+	depends on CPU_MIPS32_R2
 	help
 	  Use trap and emulate to virtualize 32-bit guests in user mode. This
 	  does not require any special hardware Virtualization support beyond
-	  standard MIPS32/64 r2 or later, but it does require the guest kernel
+	  standard MIPS32 r2 or later, but it does require the guest kernel
 	  to be configured with CONFIG_KVM_GUEST=y so that it resides in the
 	  user address segment.
 
-- 
2.27.0

