Return-Path: <kvm+bounces-48984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D4BAD5152
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3B4F1891F0A
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AF627935C;
	Wed, 11 Jun 2025 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MUDrcCi6"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7308726981F;
	Wed, 11 Jun 2025 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749636331; cv=none; b=sCpwJL45qySQQ9JyDwjBp/5BJudatGgJBh2+rF/ZYEmPp1Ry5sZK+79REQAwleG8bN+twGDW+isOBqDSHoIjMsnjdAXN94mJo4ZVE2ei1gUOOyzzxfGzvZFP2uJhl8qPq+jtjb8v2ybynzx9ZIju5Dj4EvPOmSSF1IzKtuK0uig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749636331; c=relaxed/simple;
	bh=c3MGgcLuHBuTy5Q5AZf2oL6RPIsAHX6On6VI129UPU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s03nNfEf+Ss1G68wtTgaJZlNbG5ZkbS9Olb9QwXuE0xE+4XofxW7nahlEChXWAASE7Pg186Q2ipr5TPL74EvlT6GaUbjV5BqokPVIszRxqKapWHZC4xCb4t9zw2uDd0TidcahBPMVosHMSQFIP5h7pwkeCC/RR8ON0BzeLMcPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MUDrcCi6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-RSFL4TU.corp.microsoft.com (unknown [167.220.238.139])
	by linux.microsoft.com (Postfix) with ESMTPSA id 101962115191;
	Wed, 11 Jun 2025 03:05:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 101962115191
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749636330;
	bh=hhmJV4jbmsjCIZBbXFBUFq8i/eFYROTAil7BVAImEWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUDrcCi6ooE6MB1oBNeBYNvilQ7A1HtQve3poCeOqHpzhl9Hy8dsp+dL403S4lzpo
	 mFjSiQ9y2GQ3aG59vvCqo+ShJDDg3G945P3ZQgK77D47vv5gzX162y0GWmZYQx59kC
	 deXXCWds5JhOAVS8LTPiRpPEd1j2+lNZZMAUNzgo=
From: Naman Jain <namjain@linux.microsoft.com>
To: "K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Long Li <longli@microsoft.com>,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 2/6] x86/hyperv: Fix warnings for missing export.h header inclusion
Date: Wed, 11 Jun 2025 15:34:55 +0530
Message-Id: <20250611100459.92900-3-namjain@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250611100459.92900-1-namjain@linux.microsoft.com>
References: <20250611100459.92900-1-namjain@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix below warning in Hyper-V drivers that comes when kernel is compiled
with W=1 option. Include export.h in driver files to fix it.
* warning: EXPORT_SYMBOL() is used, but #include <linux/export.h>
is missing

Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
---
 arch/x86/hyperv/hv_init.c   | 1 +
 arch/x86/hyperv/irqdomain.c | 1 +
 arch/x86/hyperv/ivm.c       | 1 +
 arch/x86/hyperv/nested.c    | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 3d1d3547095a..afdbda2dd7b7 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -34,6 +34,7 @@
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 #include <linux/highmem.h>
+#include <linux/export.h>
 
 void *hv_hypercall_pg;
 EXPORT_SYMBOL_GPL(hv_hypercall_pg);
diff --git a/arch/x86/hyperv/irqdomain.c b/arch/x86/hyperv/irqdomain.c
index 31f0d29cbc5e..f7627bc8fe49 100644
--- a/arch/x86/hyperv/irqdomain.c
+++ b/arch/x86/hyperv/irqdomain.c
@@ -10,6 +10,7 @@
 
 #include <linux/pci.h>
 #include <linux/irq.h>
+#include <linux/export.h>
 #include <asm/mshyperv.h>
 
 static int hv_map_interrupt(union hv_device_id device_id, bool level,
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index e93a2f488ff7..ade6c665c97e 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/export.h>
 #include <asm/svm.h>
 #include <asm/sev.h>
 #include <asm/io.h>
diff --git a/arch/x86/hyperv/nested.c b/arch/x86/hyperv/nested.c
index 1083dc8646f9..8ccbb7c4fc27 100644
--- a/arch/x86/hyperv/nested.c
+++ b/arch/x86/hyperv/nested.c
@@ -11,6 +11,7 @@
 
 
 #include <linux/types.h>
+#include <linux/export.h>
 #include <hyperv/hvhdk.h>
 #include <asm/mshyperv.h>
 #include <asm/tlbflush.h>
-- 
2.34.1


