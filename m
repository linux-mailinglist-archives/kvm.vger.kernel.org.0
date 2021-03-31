Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A72C3478C5
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 13:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhCXMov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 08:44:51 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:42073 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhCXMoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 08:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1616589877; x=1648125877;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=QzTU51+vaXrdoMGEPdFqskhuNqgMoN2SMvPmnKALCTY=;
  b=j16HJQxas8ieqh8JvkIs7spHcYsjUSi7NPR/SkemHRQD88vQdyvKC8TT
   iN3yKHNvulZufxC2PXU+GaqP/KhKp/DqZnKTf2HD09YRiIZkSvtxXMCjn
   jM7MQHHmMxlTlr2dpWDSdw5KhA2l7AMjS8ECKASlludv3ZgG+7U5BBPth
   8=;
X-IronPort-AV: E=Sophos;i="5.81,274,1610409600"; 
   d="scan'208";a="101696263"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 24 Mar 2021 12:44:28 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 94C02A2268;
        Wed, 24 Mar 2021 12:44:27 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.104) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Mar 2021 12:44:21 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: make: Fix out-of-source module builds
Date:   Wed, 24 Mar 2021 13:43:47 +0100
Message-ID: <20210324124347.18336-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.104]
X-ClientProxiedBy: EX13D21UWA002.ant.amazon.com (10.43.160.246) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building kvm module out-of-source with,

    make -C $SRC O=$BIN M=arch/x86/kvm

fails to find "irq.h" as the include dir passed to cflags-y does not
prefix the source dir. Fix this by prefixing $(srctree) to the include
dir path.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 1b4766fe1de2..eafc4d601f25 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ccflags-y += -Iarch/x86/kvm
+ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 ifeq ($(CONFIG_FRAME_POINTER),y)
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



