Return-Path: <kvm+bounces-48985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C05DAAD5147
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 001573A9328
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F9D2798ED;
	Wed, 11 Jun 2025 10:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="G19scGWg"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF50125F967;
	Wed, 11 Jun 2025 10:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749636341; cv=none; b=cRrrp4mcHWpnyb6e/HaIeydDV5nKUlxhR9cImBqh4aazxDaskuiw5vue1FsQ6lus7LizQ/zvgp9r71OIjSs1Du0tpCSFPt7UAXaIBu+jMjCaV98PQ7ZU2Kz6uzJ2FOeVhV5tECxaDo3ngSkFQC8YbAagH9JA9Rfq2FJzp/Ide4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749636341; c=relaxed/simple;
	bh=hjQSmeDTtGCOtlosXlMY9DOp2O+BmgFXXi/BBqDRsMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wio1wmcz6Sy/ZOpV3N0ooLqv7cabQ+hrcwqMKiW/b4UZSz8aCfpX48RFpR3Wv41cliyyqHmSehQ8JEtZb7V0zqzeI/aW29+M5XyCk3rdeq5UZTHNPZhKQ95Og7adxM9IvE0YlB13kLb1duzozWEsX01NKPSMrHGdRqRspi6ZjOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=G19scGWg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-RSFL4TU.corp.microsoft.com (unknown [167.220.238.139])
	by linux.microsoft.com (Postfix) with ESMTPSA id 94E23211518F;
	Wed, 11 Jun 2025 03:05:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 94E23211518F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749636339;
	bh=aGhf9pZAXcsrFOA10Cx3scwNyv6xzn/R2BH5ft4tdVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G19scGWg2rfuTT5vNAvhDc741LXQtKlwfX5y4hWp4k8ikMO9/rD8PAdN4pAvxV/Uh
	 z/lfiwhdyaPm+d1BjdFzyGZqDLlvsWky+YZs38azhBTIVMgi0MK5AyCrqHYBMG3Sz7
	 RRBZA6kuULDT+N6gWyulwrlhPW0kmbrTtT4xgQp4=
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
Subject: [PATCH 3/6] KVM: x86: hyper-v: Fix warnings for missing export.h header inclusion
Date: Wed, 11 Jun 2025 15:34:56 +0530
Message-Id: <20250611100459.92900-4-namjain@linux.microsoft.com>
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
 arch/x86/kvm/hyperv.c       | 1 +
 arch/x86/kvm/kvm_onhyperv.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 24f0318c50d7..09f9de4555dd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -33,6 +33,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/spinlock.h>
 #include <linux/eventfd.h>
+#include <linux/export.h>
 
 #include <asm/apicdef.h>
 #include <asm/mshyperv.h>
diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index ded0bd688c65..ba45f8364187 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -5,6 +5,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
+#include <linux/export.h>
 #include <asm/mshyperv.h>
 
 #include "hyperv.h"
-- 
2.34.1


