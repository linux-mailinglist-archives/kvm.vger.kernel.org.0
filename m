Return-Path: <kvm+bounces-9690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0068866CEC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 172771C2171A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C2662A1D;
	Mon, 26 Feb 2024 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HiBKXFRO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89B161677;
	Mon, 26 Feb 2024 08:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936108; cv=none; b=CCQFa7pr+PdW5NyjdNtOAKzwbi0F8/ojCwrPsCFrbxliPoDtJfnr6he6WxNrbvTSPvL+xRwyUaDap4C6fBRMLB1oigJwArXm8Fj1ioKM3xqOBJ686l/b0QmA7cfOncn5gyPZ6sHR7cI5cGq44xPw23z4hv3jMTpg4+4dMNJeUrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936108; c=relaxed/simple;
	bh=BKyLEUsx8ByDpiKr07UAt4uH6XYvHHe1y8EuoJK+8NM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GW0R9FfeSbe2BodRw0gl9SI+bBJV5H052zXy+x1I5W7gE1sgBKZ4kS6ydYnr3mr5dw8SvRnYV2lpWy/rxLAyEhNUuF6drcdknRi71uenkDSTx8G5pf5JbfQTiIS8zBAQW1QqAKMj98wtuOaa6Bxxgb48rhPdUPHt033mmXfZYyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HiBKXFRO; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936106; x=1740472106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BKyLEUsx8ByDpiKr07UAt4uH6XYvHHe1y8EuoJK+8NM=;
  b=HiBKXFRO/hqTtSXK3xYmu8jqaGlmz3Mah5Yx28xC7TOekyLjLGwQPCCX
   +qMkvDijsYCZjLGNjwjSDU1HPkOUDttwb2u3yHR0WtGkrLLG7INWnFO0m
   +hcyRlVBOd7phYs/9PqqzVEVGo8htb53JAay/Yf8lnB8hFC4sG2VB1xmS
   1ZuoSVz5ZQy6mPop/ttM5gFSQ9uxXJyaf6Jsbo+yX1uVIQSGNiTDTay72
   lHkIehQLn9J3ic5iqGC9jLa4ReGsBSvK1JMzXFeouarX2HmgXDecFERvD
   YSVI27pbLLJSGNHMaKpwtV5E0C6SVCRIsAsldToqSlTw9Qng3NXBUFDkh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155476"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155476"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615946"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:21 -0800
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
	tina.zhang@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Yuan Yao <yuan.yao@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v19 064/130] KVM: x86/mmu: Do not enable page track for TD guest
Date: Mon, 26 Feb 2024 00:26:06 -0800
Message-Id: <066ce30f61d65f3a5e701f0cf1c2f71fa3df2a0d.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v19:
- drop TDX: from the short log
- Added reviewed-by: BinBin
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
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


