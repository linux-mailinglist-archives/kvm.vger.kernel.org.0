Return-Path: <kvm+bounces-48987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D867AD5165
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16FC01BC0455
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0539127AC57;
	Wed, 11 Jun 2025 10:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="pOxDx+hj"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D744D7081D;
	Wed, 11 Jun 2025 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749636360; cv=none; b=IvmlLFLnHV7RA73IHL5AyeQQydDmNwvulfKa3somjCM5ySLPDOIW5nmAmOxvGDpOvkH2Z8Ajm1IRaNXkQ+Bcu5ueKmy+xXl5t+F44/3fTeli6LDpIUWlghacrtD1GGqFP3xpKaLGYabzleSGsm5lOGnWbcS4kEuswV7/tDls9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749636360; c=relaxed/simple;
	bh=qjBcuPulRI2eyx47QShOtDhoswZ6VKlfodV0k4Fw79k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tJ52J0EH0s10gKyMnJVDDBuXoayzH6Brn+DE/jBwcYbUSktjNtN2AHylIIs4M8QCAVHF89sUNaqwDrbhA2W/R3Oe+7+EtO71rfPneSC1uTvoCnBWwWx5iCg6xNTnSIuofXTNN99DyklOChVZgFj9k3QYeFlo/h6fL7X44pKgsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=pOxDx+hj; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-RSFL4TU.corp.microsoft.com (unknown [167.220.238.139])
	by linux.microsoft.com (Postfix) with ESMTPSA id AB33C2115194;
	Wed, 11 Jun 2025 03:05:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AB33C2115194
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749636358;
	bh=gCVgGnsid8uO5iTmv2/yObucT4a844YKHQ1W6Pi0rcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOxDx+hjxAdbFLGyijxmC1yUnP9MdDxyHeYXmjh2VC8wM9V3URHQAr2WMDMCv3OZq
	 FIQzRbq53tuHKbrxPXUFFSLDxVsZhFRa7nR/4Vk4UzFAcmUMLbZUZriNCDJBiOREyw
	 O6SSIEmFq9Qc7QusWbu+3/KXzCsEa1znUJuA+ros=
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
Subject: [PATCH 5/6] PCI: hv: Fix warnings for missing export.h header inclusion
Date: Wed, 11 Jun 2025 15:34:58 +0530
Message-Id: <20250611100459.92900-6-namjain@linux.microsoft.com>
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

Fix below warning in Hyper-V PCI driver that comes when kernel is
compiled with W=1 option. Include export.h in driver files to fix it.
* warning: EXPORT_SYMBOL() is used, but #include <linux/export.h>
is missing

Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
---
 drivers/pci/controller/pci-hyperv-intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pci-hyperv-intf.c b/drivers/pci/controller/pci-hyperv-intf.c
index cc96be450360..28b3e93d31c0 100644
--- a/drivers/pci/controller/pci-hyperv-intf.c
+++ b/drivers/pci/controller/pci-hyperv-intf.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/hyperv.h>
+#include <linux/export.h>
 
 struct hyperv_pci_block_ops hvpci_block_ops;
 EXPORT_SYMBOL_GPL(hvpci_block_ops);
-- 
2.34.1


