Return-Path: <kvm+bounces-6681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9CD1837870
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7250B294179
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4713F7FBBF;
	Mon, 22 Jan 2024 23:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bdeUTAO9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43EB7E780;
	Mon, 22 Jan 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967772; cv=none; b=Cmp1DbIvpPOREQcK1Xt9L3ACZ3HCg8AQVncrQdkvhPK43e49PkH2lt6YleJ+xcdwXeJME1QRCCjyImRB6wj8lhNqMsbb4EBpCYV9OQ4QZkQY4zy9Iv9byotIYAdTRRwX0Gqwsa4BfggCW9NY2rjww3PYObQdR5L37fyqcZZru6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967772; c=relaxed/simple;
	bh=oAY2vBodBoJjRLKa8EO0C+EcU6IOAxDgw153dv5CsIU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tgLTK6iDe3KGnbAow12TXP5GhyiLHIi9pUslMfGvmieznBJm/2xa3tljzvOShQaGxkarp/Z4n2FiJFKe8fa8T7EedBcINU0YuKioYjI9Q0p6Gv9YTa2wP/7lK5yVFtTEw4tWWStzOJed5dDVth1+jLjIA4QFXqShQiey3f/38Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bdeUTAO9; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967770; x=1737503770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oAY2vBodBoJjRLKa8EO0C+EcU6IOAxDgw153dv5CsIU=;
  b=bdeUTAO9J4XrOlUsGg00cDa7NkneGqhleqY9pJedbr++3ZEv+b2U6pym
   z6TUDG6VGRL1248RjMOHBA4CYN5D0FzMFqqR+KQot6ybAeVVLbgtPJAsf
   1ml6EHVL65VYHs+ciIcMCtKsihraeGEp1KJDP02sVYzpCaQ0DLgr2kGTm
   0Ns2W1hcs9S0OQBcR38LKE9eCcQPjfcE/Sz85WxH1LDw/6x79bSU/wjVY
   wxtT28Q5r0Z92bn+RM9UipLGy93S7dYFz/qjJWwF7La9Z9wWHJPXgE22F
   /ksZVuRMLf358Cxf4DPbsOiiQW3UibRuWilj/ULaiKLM8DlwJ07rvYIf+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217929"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217929"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818021"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:57 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 111/121] KVM: TDX: Add methods to ignore accesses to TSC
Date: Mon, 22 Jan 2024 15:54:27 -0800
Message-Id: <a00f28f4c6f9b87a397e656b692f4baf257292c3.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX protects TDX guest TSC state from VMM.  Implement access methods to
ignore guest TSC.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 74e5197733ef..adaf61bb754c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -847,6 +847,42 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_get_l2_tsc_offset(vcpu);
+}
+
+static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_get_l2_tsc_multiplier(vcpu);
+}
+
+static void vt_write_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* In TDX, tsc offset can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_offset(vcpu);
+}
+
+static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* In TDX, tsc multiplier can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_multiplier(vcpu);
+}
+
 static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
@@ -1004,10 +1040,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_tsc_offset = vmx_write_tsc_offset,
-	.write_tsc_multiplier = vmx_write_tsc_multiplier,
+	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
+	.write_tsc_offset = vt_write_tsc_offset,
+	.write_tsc_multiplier = vt_write_tsc_multiplier,
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-- 
2.25.1


