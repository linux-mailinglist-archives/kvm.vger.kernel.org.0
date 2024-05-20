Return-Path: <kvm+bounces-17756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D9A8C9D02
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B554B28254A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A89854F86;
	Mon, 20 May 2024 12:14:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738125337F;
	Mon, 20 May 2024 12:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716207282; cv=none; b=JYS06gJzjAmbdYO+NovEmIf3V2CJaIAK7r18/ZHlLf7hEaiZnkuWC6jaSqfNR1UFx4VL0fe7HxMmoB+RWrMjXL4CXSST/m9+l8CuFWZu/H5Amkq6ktEicHaPay4R3D36E0r0UpHGBBbpd0JDsc40CMQrQj7IhZyzQv7wgNgzw14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716207282; c=relaxed/simple;
	bh=mvD6sd9vndZ7Sf1mQsWKHKUTPiFurzaR4/bRViw4zaM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L05/KGs2hCckn+tPQe+1ijkD6baJbOiBTZFYGwW9JL4ZLDqht7sl5QhZjAr+WAvubhodC8zZiwPk0GvC/zdGFqFHJWT5nASJsDAiFQBaAgb9tWRe6n0WSWGSle8E0APm/ogbTbxX+raDXM8HvkIG6R9W/PFuoY4Akd5xrJ5SVNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VjbcJ3M3dz2Cj98;
	Mon, 20 May 2024 19:55:44 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (unknown [7.185.36.236])
	by mail.maildlp.com (Postfix) with ESMTPS id B43F414037E;
	Mon, 20 May 2024 19:59:11 +0800 (CST)
Received: from huawei.com (10.173.134.152) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 20 May
 2024 19:59:11 +0800
From: <zhoushuling@huawei.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <weiqi4@huawei.com>, <zhoushuling@huawei.com>, <wanpengli@tencent.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: LAPIC: Fix an inversion error when a negative value assigned to lapic_timer.timer_advance_ns
Date: Mon, 20 May 2024 19:53:34 +0800
Message-ID: <20240520115334.852510-1-zhoushuling@huawei.com>
X-Mailer: git-send-email 2.23.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)

From: Shuling Zhou <zhoushuling@huawei.com>

After 'commit 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns
parameter overflow")',a negative value can be assigned to
lapic_timer_advance_ns, when it is '-1', the kvm_create_lapic()
will judge it and turns on adaptive tuning of timer advancement.
However, when lapic_timer_advance_ns=-2, it will be assigned to
an uint variable apic->lapic_timer.timer_advance_ns, the
apic->lapic_timer.timer_advance_ns of each vCPU will become a huge
value. When a VM is started, the VM is stuck in the
"
[    2.669717] ACPI: Core revision 20130517
[    2.672378] ACPI: All ACPI Tables successfully acquired
[    2.673309] ftrace: allocating 29651 entries in 116 pages
[    2.698797] Enabling x2apic
[    2.699431] Enabled x2apic
[    2.700160] Switched APIC routing to physical x2apic.
[    2.701644] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    2.702575] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8378A CPU @ 3.00GHz (fam: 06, model: 6a, stepping: 06)
..........
"

'Fixes: 0e6edceb8f18 ("KVM: LAPIC: Fix lapic_timer_advance_ns
parameter overflow")'

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Shuling Zhou<zhoushuling@huawei.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebf41023be38..5feeb889ddb6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2848,7 +2848,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
 		lapic_timer_advance_dynamic = true;
-	} else {
+	} else if (timer_advance_ns >= 0) {
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 		lapic_timer_advance_dynamic = false;
 	}
-- 
2.27.0


