Return-Path: <kvm+bounces-60635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 518D7BF53CA
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:32:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AF7C1897361
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C676303A15;
	Tue, 21 Oct 2025 08:32:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0006630217D
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761035521; cv=none; b=kRV6krNCdTrA7aWWnbmjvtBgYhzmTf9Ar0zieODb4ZhQhUugPgpVx6EkbyYUcvnmsFa559P2+1oJnARVPN9WzOH9e9m5XUcIEDoiaYIySxMAUDIQtznXO8EqYeHbP5QmhO78t4YiS9SYvfolSbkQB327HEa3xkpPX9eD3bg2pHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761035521; c=relaxed/simple;
	bh=FlosaNiHGpEDQzKGrkVj0yU5+dHfFwwNLg7K+/7VJlU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Qx7dMG+0Kiq26Kf3wUpNEJTMMkpwAlB7rB39aXwTCWeiwqX+LhALRDA9jQof1mj7HBBwyrc5gsD1CDf0tzWope+vWTpBHgIu3ttaaqTGx0VjRG2jJWcuw/kPAOL8bNVEeHTItp0y9nQQS8Ty1TW0TDlWcwAk1Y0fwacS00RtYhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS34.andestech.com [10.0.1.134])
	by Atcsqr.andestech.com with ESMTPS id 59L8VrpO071964
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
	Tue, 21 Oct 2025 16:31:53 +0800 (+08)
	(envelope-from minachou@andestech.com)
Received: from swlinux02.andestech.com (10.0.15.183) by ATCPCS34.andestech.com
 (10.0.1.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Oct
 2025 16:31:53 +0800
From: Hui Min Mina Chou <minachou@andestech.com>
To: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
CC: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tim609@andestech.com>, <minachou@andestech.com>,
        <ben717@andestech.com>, <az70021@gmail.com>
Subject: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration to prevent stale entries
Date: Tue, 21 Oct 2025 16:31:05 +0800
Message-ID: <20251021083105.4029305-1-minachou@andestech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ATCPCS33.andestech.com (10.0.1.100) To
 ATCPCS34.andestech.com (10.0.1.134)
X-DKIM-Results: atcpcs34.andestech.com; dkim=none;
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:Atcsqr.andestech.com 59L8VrpO071964

From: Hui Min Mina Chou <minachou@andestech.com>

If multiple VCPUs of the same Guest/VM run on the same Host CPU,
hfence.vvma only flushes that Host CPU’s VS-stage TLB. Other Host CPUs
may retain stale VS-stage entries. When a VCPU later migrates to a
different Host CPU, it can hit these stale GVA to GPA mappings, causing
unexpected faults in the Guest.

To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CPU.
This ensures that no stale VS-stage mappings remain after VCPU migration.

Fixes: 92e450507d56 ("RISC-V: KVM: Cleanup stale TLB entries when host CPU changes")
Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
---
Changes in v2:
- Updated Fixes commit to 92e450507d56
- Renamed function to kvm_riscv_local_tlb_sanitize

 arch/riscv/kvm/vmid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 3b426c800480..6323f5383d36 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
 }
 
-void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
+void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
 {
 	unsigned long vmid;
 
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


