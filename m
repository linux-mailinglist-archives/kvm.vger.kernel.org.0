Return-Path: <kvm+bounces-59386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C8CBB2716
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A84CF32504E
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D1224469B;
	Thu,  2 Oct 2025 03:35:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491903FFD
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759376106; cv=none; b=UgOlrVPOGNRQ03FYg/jxzTWI8NK0Uz87n45rYmVuW0YSsvwwOQwLojACPIlHqmXrQiC0BsV0DrnIYM0KUsR4RfQcfB3QUkZtDwCFoxES7DujBw/hqscfdbpUj++PJo/uUl9KvBUNcr1tt+kUIGc9t5l62FvRrXhNzJvrvkrLA00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759376106; c=relaxed/simple;
	bh=lq2ExnNqIsCf2nA3TdJVLqxRe4VyShlFupZuLdV9cvI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qFclAxbEhyUrL9gbGzEIwhH0bk2gnc5JgofNiSjKmlAAtfDrqZ4KuxM7IlQMVpDjBux0iw3iXIHMLKU24KDHj76ISaqbCN8Ujos92Y4ldLaaZlOHf07RaKt18Wm2eaRS+WwIMaqllyKawVOvdyO71QlUPmYGSTVw/qggAYLeYSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS31.andestech.com [10.0.1.89])
	by Atcsqr.andestech.com with ESMTPS id 5923YIBN012646
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 11:34:18 +0800 (+08)
	(envelope-from ben717@andestech.com)
Received: from swlinux02.andestech.com (10.0.15.183) by ATCPCS31.andestech.com
 (10.0.1.89) with Microsoft SMTP Server id 14.3.498.0; Thu, 2 Oct 2025
 11:34:18 +0800
From: Ben Zong-You Xie <ben717@andestech.com>
To:
CC: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
        <liujingqi@lanxincomputing.com>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tim609@andestech.com>,
        Hui Min Mina Chou
	<minachou@andestech.com>,
        Ben Zong-You Xie <ben717@andestech.com>
Subject: [PATCH] RISC-V: KVM: flush VS-stage TLB after VCPU migration to prevent stale entries
Date: Thu, 2 Oct 2025 11:34:02 +0800
Message-ID: <20251002033402.610651-1-ben717@andestech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DKIM-Results: atcpcs31.andestech.com; dkim=none;
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:Atcsqr.andestech.com 5923YIBN012646

From: Hui Min Mina Chou <minachou@andestech.com>

If multiple VCPUs of the same Guest/VM run on the same Host CPU,
hfence.vvma only flushes that Host CPU’s VS-stage TLB. Other Host CPUs
may retain stale VS-stage entries. When a VCPU later migrates to a
different Host CPU, it can hit these stale GVA to GPA mappings, causing
unexpected faults in the Guest.

To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CPU.
This ensures that no stale VS-stage mappings remain after VCPU migration.

Fixes: b79bf2025dbc ("RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()")
Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
---
 arch/riscv/kvm/vmid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 3b426c800480..38c6f532a6f8 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -146,4 +146,10 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
 
 	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
 	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
+
+	/*
+	 * Flush VS-stage TLBs entry after VCPU migration to avoid using
+	 * stale entries.
+	 */
+	kvm_riscv_local_hfence_vvma_all(vmid);
 }
-- 
2.34.1


