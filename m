Return-Path: <kvm+bounces-52164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0A6B01DC9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD5EE3BFD3E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEADB2E7F3E;
	Fri, 11 Jul 2025 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQBCYmXf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE532E7BDD;
	Fri, 11 Jul 2025 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240876; cv=none; b=TVioNaOFok5qYmta9d2Xy2kmc2D4MUJ+PpFhcD5ANpv2krz6BYYZS7i9vUT4z8fCMwv7Oo3Unm7MuSPh3/M1AXxWUdyz/9w+JjQhhCq7yntdUnQotgjj/H1jsqS4USglVQb1M0JOS4O+XUG/k1lQmtnGQmEVwe1TTbSo2HrHONc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240876; c=relaxed/simple;
	bh=HDcMtsioNj2DN5BBI17IRgOgyQAk23BUXHWEVTiKBdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5gW/2kuytnPpOYeiVt4ifSIVcyBIlp7LzKB62f6GR/XUpms2RGMNgqdwL9pYf1VMr0v99PjjNqrdScsSrggOBtZBfPrrXp4jnng3q0xgFS4ilbLuznAkmQkN/1hW4I728R3OvA+UVoFVNMq+WgEsvGivI9urISs3yUk9kNircA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQBCYmXf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752240875; x=1783776875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HDcMtsioNj2DN5BBI17IRgOgyQAk23BUXHWEVTiKBdg=;
  b=FQBCYmXfetID03qBmeGq1mw/8pDePcT/hwbsXOMLw/xj8EQPJzbubwVE
   EZAINe4yxRBkzGbIiDXg8ouhGHzTVY0IpzGVLCPzY5PPVDYTeMJ7IKini
   EhKIhhkaiULbVmsO6ZCD/b3WHszrIAmVKUCCI3PmmlexAw9BFvE+HnB+6
   n9ws/muwlyhw1pz5xjObWNR22MzBzKaeYp/obGCYPwLZCFv6aiYM/wt2s
   hEy4RN2goOv9Nn34+xtgAotUKuQnivNxeIL23X2fusl6xNWdYzrTd3Y3Z
   aeCQIggMf3XMM1x6/Uw3psb1h3i9NwXl1E1EJnICxD5gWezvHpMi0BVFr
   g==;
X-CSE-ConnectionGUID: 3m4fDKbwThmR/m82IZxKSg==
X-CSE-MsgGUID: SFtxa8AeTVqKO49ZKJsTsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="65603423"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="65603423"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 06:34:35 -0700
X-CSE-ConnectionGUID: bA05kdQlRteTitz8uDNnLg==
X-CSE-MsgGUID: AU+qYP0dTtaExVjqZTvQeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="187349239"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 11 Jul 2025 06:34:31 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v2 3/3] KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS
Date: Fri, 11 Jul 2025 21:26:20 +0800
Message-ID: <20250711132620.262334-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250711132620.262334-1-xiaoyao.li@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS to include
"TDX" in the name, making it clear that it pertains to TDX.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index efb7d589b672..90fb6ba245dd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
 }
 
-#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
+#define KVM_SUPPORTED_TDX_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
 {
@@ -76,7 +76,7 @@ static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 
 static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
 {
-	u64 val = KVM_SUPPORTED_TD_ATTRS;
+	u64 val = KVM_SUPPORTED_TDX_TD_ATTRS;
 
 	if ((val & td_conf->attributes_fixed1) != td_conf->attributes_fixed1)
 		return 0;
-- 
2.43.0


