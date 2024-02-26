Return-Path: <kvm+bounces-9679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBCC866CBF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEB991F256EA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E916D605B1;
	Mon, 26 Feb 2024 08:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTQ0wlRq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4F25FEFD;
	Mon, 26 Feb 2024 08:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936101; cv=none; b=XIYkraWvsOum4snIRa/fjy7kAZ21/XiG2k3H06dS+sLgi9JD9DCcPn6ADl0aN87cAiBznmXKdkyDYpkqNFcG9K1kaBIajj8S0MI1wxcWrOSFzTJ7DEGFmp/tPq0973gtUkyMmxOTNJWKXvI+OTt426sZej0oqeM31+K2jx97Xkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936101; c=relaxed/simple;
	bh=WkpnJmQUuLJFyL2brOxfTQdsOI1DqG1Lui1rEGPKdd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tZNXtDZQ76fWVUZD9uExPkBHD96tZlTOBMQAVxi8s5qt5paS+DHRsK4lkDGWgYHpxD6PCcGPGpEqXQW65RlUpibIjTxYli7gV9JAsnpVZ9NR+9bTXzXu4zbW4OHSEfE1Pqi9yRk+aFRSicjm+s8erSnIpCXJWAdPFOl3C43lr/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mTQ0wlRq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936099; x=1740472099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WkpnJmQUuLJFyL2brOxfTQdsOI1DqG1Lui1rEGPKdd4=;
  b=mTQ0wlRqccGzQf6PIa2T0glQv+Q0fTuTNNwSL7bNcZ4JHZMjB+y6lYLU
   yw4yIEaBO3ikTle7Ymwu5MtoCv95LQpxyPMJ4V/2+N5TrwDl+KKU1fQyH
   9Eh7hyEaIZH2BViOMX0buxol+LUl0t1lyh/NLOR2EMSeYHv7W1KPruXtG
   QVyjdu3nHtHBAsapZi9MyHhosqHCQdxTojM5mOWsSfLVaBQNqrthl+zzP
   yyd6wFR7UVH0BKQo8FdP+C5mNSv3Syr2uz7BLmeh4C6CoxcprHB1bbPwG
   XUKtky30cGV2MGaJWItqt1YCIQj0Jz0f2nhEgwfRp3R63gNNX3Mp0h/GH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155409"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155409"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615858"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:15 -0800
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
Subject: [PATCH v19 055/130] [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
Date: Mon, 26 Feb 2024 00:25:57 -0800
Message-Id: <973a712b27d94dcead1ea6ef31404a751f1c2a0b.1708933498.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

This empty commit is to mark the start of patch series of KVM TDP MMU
hooks.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index e893a3d714c7..7903473abad1 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -26,5 +26,5 @@ Patch Layer status
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-* KVM TDP refactoring for TDX:          Applying
-* KVM TDP MMU hooks:                    Not yet
+* KVM TDP refactoring for TDX:          Applied
+* KVM TDP MMU hooks:                    Applying
-- 
2.25.1


