Return-Path: <kvm+bounces-48988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A712AD5154
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76FC41E0246
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB2D27CB28;
	Wed, 11 Jun 2025 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PHHyZWPV"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE42269B07;
	Wed, 11 Jun 2025 10:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749636369; cv=none; b=WlVL0U1xS1gBlI/IR1FnECCBZYenXG+7YmUk8oB4TA1NK4XPZHjb50YYFBy5FsuBxGeSBluoOXOtiR+psDsWEtYv1dPIqj5VNIZ314SJLBM3G+cMKV8lBpaKRjRXUWbLwk6OO4FMuRV7NbyvttOrFh6pgnlhJ6oEfJ+COUtOpK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749636369; c=relaxed/simple;
	bh=VPToYgHTheKgSk91dnwnpEWxu/iIsLz1NQjpp/HoK9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T51hUPL3JQRGSiAq1WSG2PQssSJYdNg0VO9cwVR5N/dEinW6iIG603bA6Das66aq3Z1wJiadJGJxPCk9a+il/33gVGQrfyorK1emZM+Ue5+cDnCQtmHATdxQ6lMxJ0ZSAIh6nG6eglEZgeNmorWEtjMzOt1Cq0VUDsE5a6w/wUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=PHHyZWPV; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-RSFL4TU.corp.microsoft.com (unknown [167.220.238.139])
	by linux.microsoft.com (Postfix) with ESMTPSA id 39C1C2115195;
	Wed, 11 Jun 2025 03:05:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 39C1C2115195
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749636368;
	bh=l9DJH+HH91jPT4Tylpz4H2GjnE02AKAT2ubUE2pzEro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHHyZWPVtEmfXi5vOF5F/eDDCnYGlmDYvN+YWlxT44TjhYZYGjibB/xPd/AxQy/gZ
	 7ued2Ffk4pZ7jRhTeZ3Cx1mY3bNmcTNh04KOwmlKSbYDve8rHliQ1INHILM79AaJDZ
	 mwaExEMIafpFxHeCbw1w2uxSdPURtYOmR5S6JimA=
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
Subject: [PATCH 6/6] net: mana: Fix warnings for missing export.h header inclusion
Date: Wed, 11 Jun 2025 15:34:59 +0530
Message-Id: <20250611100459.92900-7-namjain@linux.microsoft.com>
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

Fix below warning in Hyper-V's MANA drivers that comes when kernel is
compiled with W=1 option. Include export.h in driver files to fix it.
* warning: EXPORT_SYMBOL() is used, but #include <linux/export.h>
is missing

Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 3504507477c6..019e32b60043 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/utsname.h>
 #include <linux/version.h>
+#include <linux/export.h>
 
 #include <net/mana/mana.h>
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index ccd2885c939e..faad1cb880f8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -10,6 +10,7 @@
 #include <linux/filter.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
+#include <linux/export.h>
 
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
-- 
2.34.1


