Return-Path: <kvm+bounces-952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9947E4298
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:02:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ABAB1C20E8D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B378E31A82;
	Tue,  7 Nov 2023 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/hZKf3C"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83C731A64
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:01:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CC0132;
	Tue,  7 Nov 2023 06:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369139; x=1730905139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SCW6Dkj/Vj+qX6sWycKS9/fk9MJ8AKVtZUkBL10lrs=;
  b=J/hZKf3Ct4O8Fu9vQb0uOoMYf/cq32CJsCvXOTGIcvP2+xHpsBFJvpZq
   +bCB4B7xj+2g2LoM5f/GsS+VvByeECKByeXmY4nYkM1RM3cdNQCoE9RIg
   ZTGzIFJKWwvuK+Ncyo8cFIjpzmnrkuj0r7X9evewQvHEtJ3Juu8BjQlfe
   GQ3ThM7Mx3w1h1aZRT10wq9EdxdHIIOuS680RPquWJ7Vqtd0EYstDq9qz
   7x62uYe8pGIq92SGjxly9T1SQWX/kAClxGFtyfxYjw8h7h9Gb2e4yav3y
   J2Jrmua7iogIwiIXj6dusD2HJvWawamNdlJEnO6P2myveCdLw/MG4CdoE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462318"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462318"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851391"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:12 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH v17 048/116] KVM: x86/mmu: TDX: Do not enable page track for TD guest
Date: Tue,  7 Nov 2023 06:56:14 -0800
Message-Id: <b1c31659542f7ac08c06fb823f5405e287cd42fd.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

TDX does not support write protection and hence page track.
Though !tdp_enabled and kvm_shadow_root_allocated(kvm) are always false
for TD guest, should also return false when external write tracking is
enabled.

Cc: Yuan Yao <yuan.yao@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11f3a04..ce698ab213c1 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -22,6 +22,9 @@
 
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return false;
+
 	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
 	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
 }
-- 
2.25.1


