Return-Path: <kvm+bounces-48982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4AE6AD5137
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E92117A5498
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0060A2686AF;
	Wed, 11 Jun 2025 10:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NkO+L4no"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8958F2620CA;
	Wed, 11 Jun 2025 10:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749636313; cv=none; b=dh+JwU7veS93i8Km6A3E/SBlkJwUnnnlNPwuMNPlLkPQwo09lSudM9OGbV3v7X511Juhf0HXijuaKfC1r0P3e72AhxzYOk/1TQeo4oMECQUlH87YTQ7II5MHnu4To2UVV9uftji0eYrtrtlLMz1N03EJWDAyK1w1zu6DWcxDs/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749636313; c=relaxed/simple;
	bh=TeLI3Lddts0BIYHmBS0TtowM9nVihM9glw/C2T0j7XM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uytTF1zh73FuMbWatoRXIwZBrZqZWIhAx4pPrlUWUDI47HVzh5eLk/V50GZevv8UOQnwZ0d9nGDM0Fwf4c9ClvI0xnQY8uh/+Cu1/BVhIvsTRoltmjs+PFy7ncLwPlWILyU6SSo/hw0ptZ50QWUl7Ecln/DtgEf2gdZ62iBmNh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NkO+L4no; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-RSFL4TU.corp.microsoft.com (unknown [167.220.238.139])
	by linux.microsoft.com (Postfix) with ESMTPSA id E878B2115188;
	Wed, 11 Jun 2025 03:05:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E878B2115188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1749636311;
	bh=iFH/A224Q7Iky4IKjuP9TxBCXGPTpQ+mWawcgol9EaM=;
	h=From:To:Cc:Subject:Date:From;
	b=NkO+L4noU0fsiOO/C7biOMxA6iMyK/EamuP/4x0qx+xMoA4wcnRKwpXYB6GBSXnyS
	 8XpgrGCgIkGGbl0cadlbp0unuMHuYlREdNsRhXOp27/vWCp2T6ZcnSUCcMJ3IbzZAM
	 Zk5vBoLeQmK9m+OUqW1a7AnaUtSJT/mdUrSy875g=
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
Subject: [PATCH 0/6] Fix warning for missing export.h in Hyper-V drivers
Date: Wed, 11 Jun 2025 15:34:53 +0530
Message-Id: <20250611100459.92900-1-namjain@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the kernel is compiled with W=1 option, a warning is reported
if a .c file exports a symbol but does not include export.h header
file. This warning was added in below patch, which merged recently:
commit a934a57a42f6 ("scripts/misc-check: check missing #include <linux/export.h> when W=1")

Fix this issue in Hyper-V drivers. This does not bring any
functional changes.

The one in drivers/hv/vmbus_drv.c is going to be fixed with 
https://lore.kernel.org/all/20250611072704.83199-2-namjain@linux.microsoft.com/
so it is not included in this series.

Naman Jain (6):
  Drivers: hv: Fix warnings for missing export.h header inclusion
  x86/hyperv: Fix warnings for missing export.h header inclusion
  KVM: x86: hyper-v: Fix warnings for missing export.h header inclusion
  clocksource: hyper-v: Fix warnings for missing export.h header
    inclusion
  PCI: hv: Fix warnings for missing export.h header inclusion
  net: mana: Fix warnings for missing export.h header inclusion

 arch/x86/hyperv/hv_init.c                       | 1 +
 arch/x86/hyperv/irqdomain.c                     | 1 +
 arch/x86/hyperv/ivm.c                           | 1 +
 arch/x86/hyperv/nested.c                        | 1 +
 arch/x86/kvm/hyperv.c                           | 1 +
 arch/x86/kvm/kvm_onhyperv.c                     | 1 +
 drivers/clocksource/hyperv_timer.c              | 1 +
 drivers/hv/channel.c                            | 1 +
 drivers/hv/channel_mgmt.c                       | 1 +
 drivers/hv/hv_proc.c                            | 1 +
 drivers/hv/mshv_common.c                        | 1 +
 drivers/hv/mshv_root_hv_call.c                  | 1 +
 drivers/hv/ring_buffer.c                        | 1 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 1 +
 drivers/pci/controller/pci-hyperv-intf.c        | 1 +
 16 files changed, 16 insertions(+)


base-commit: 475c850a7fdd0915b856173186d5922899d65686
-- 
2.34.1


