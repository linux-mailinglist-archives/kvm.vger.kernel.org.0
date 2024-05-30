Return-Path: <kvm+bounces-18439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D768D5430
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A095FB24FFB
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA5F18308A;
	Thu, 30 May 2024 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P24KvUDo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB86C84D13;
	Thu, 30 May 2024 21:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103254; cv=none; b=u9tJeS6PXnpUOnEMepPSiabCg9cjllS2P03jQL0z8UDZo8CCpiuQBcZXb3dDX921+2BfhpJ8J6XOPRQuz4OpLiViq2RblC+/mWr2/di8jcyKyaNXLeDJru2zn2HZ7N1CijTJlIzB0KHKbSp345Uf3RCpVgQYlLqL0QYnoq72FXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103254; c=relaxed/simple;
	bh=VX7MgdwvWo75LHOu/OQNQG0ISrnE2BQomr6o4j/J3Gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E2KvRCNoggwjKz1eQrYtjQfDhjXCEBprC9V8khv3FpZ5v8yWvwNTtoRughKZ+0kUagPI3wxKFAkQe8AnhaDm8qLkHx0Ip1OTP3f0oeUUO28/2jPSGZztAVCcrwyB0qxxz5DdrhPaY8/vgrClwm0z9G1N6oPilKaPXyV02E56DPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P24KvUDo; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103253; x=1748639253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VX7MgdwvWo75LHOu/OQNQG0ISrnE2BQomr6o4j/J3Gs=;
  b=P24KvUDoWs/bTytODeuGL9A/b+fB2MBE8G0t4zAuTX4FwqejR605uDIf
   Suz9Jlzfc0DAXM7wT22NckuPvx/j0RuplkxurA8Mpv7qhkL7pVWW6vO4U
   t1QDpXD4BcbQaA5Wov/7LBlravFuygfRq47yhpKtYHpiGg77ku9QWAeFh
   g7woTe+iOGhz5kwJcKF19nmQrVVGb95oUSZho9nWtv5xr3KOx0tMdvzof
   S6O5YAI8a6P5B0lM68Ap6nDuWNzMk9+Q782cTKkCJBeiK81NYe0eBfH+5
   FOIxY8YWHhPLwn96gBTOhlRtn7VKgkXLAIKXVqcpfSEeWw90iD/PY5FMT
   A==;
X-CSE-ConnectionGUID: h2h5g72vSuq8DrZIOrLfag==
X-CSE-MsgGUID: y6CBRameQSqhJn1uFodG2Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117086"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117086"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:31 -0700
X-CSE-ConnectionGUID: +fZ4+CpcRh+d5Nz5n/teng==
X-CSE-MsgGUID: GKMWHHJ0ReWDzqLkkox3sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874404"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:31 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v2 02/15] KVM: x86: Add a VM type define for TDX
Date: Thu, 30 May 2024 14:07:01 -0700
Message-Id: <20240530210714.364118-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a VM type define for TDX.

Future changes will need to lay the ground work for TDX support by
making some behavior conditional on the VM being a TDX guest.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep:
 - New patch, split from main series
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 988b5204d636..4dea0cfeee51 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -922,5 +922,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
 #define KVM_X86_SNP_VM		4
+#define KVM_X86_TDX_VM		5
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.34.1


