Return-Path: <kvm+bounces-6607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7524E83794E
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:36:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF861B25482
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4A65EE84;
	Mon, 22 Jan 2024 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eY8mJY2z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D9E5D90F;
	Mon, 22 Jan 2024 23:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967724; cv=none; b=dPGWTQzLDsNgUqubau25zUzGCYwXfmjAbzTByJBpDvfceUaqRV8R3m3no5EwPoCsH6r2avj2ZSV2ITCnq+oPT6feIvx3pBRWkDZJAMGliDRLdq2GRYw5vsI8f6noSMCTgMwfylEYacafq+n+xfm7Dk95ba4OEb2Xfp9MN4fm/ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967724; c=relaxed/simple;
	bh=zdJ2GT4ARrSNbJp3F6eaxutpQ4DdrmPtIT6M7sepMRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rm20eqVYhZJeX7P1ZRHTSP05QKfQn5zfnUmMXbkFHVd3oKKvIil7k61JBq6+JGg0zBtPPXBBRNm2Jcoji/tL0eDq8ZmdoHgy05LAH3cgjUkitHkIrvilPkyquscIF9FzQDaPLXR59Lt9LuRyRrGRGDmsFwBo52eLh5ofQVDEiNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eY8mJY2z; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967723; x=1737503723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdJ2GT4ARrSNbJp3F6eaxutpQ4DdrmPtIT6M7sepMRw=;
  b=eY8mJY2zOCPLikNmbPCkwyquo7u/d1vOOUi717MV3RZ49IqCm+VCKeih
   fTuEdKdWlxT91N1rx9b4P4WPC1u3aNGoo1oi+0ZDia+Vfaw34RxhotQeI
   n/LQnUtFvyTS7ZZ5BQT6KSn+3oWJ09zJsCQOB9SKECUWKekY/Gu1s8JAo
   lfVK/C+JYSKMkrkZwQ76J3taaZiFcv4Cue6xes7DD2e95bo3zhjN2Udl9
   0Kr790xE1+rSzuPq+gNaO6DRnSR6LHI2Ekrj7EkciriCx3EiD2luAYYdJ
   +lVNj4vkPxwVFyhd/IqI+l7zCi56/FhBVKDLvTh2/roS0S3kdfoLKmXF2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243863"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243863"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888629"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888629"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:22 -0800
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
Subject: [PATCH v18 034/121] [MARKER] The start of TDX KVM patch series: KVM TDP refactoring for TDX
Date: Mon, 22 Jan 2024 15:53:10 -0800
Message-Id: <c897a0fb9a3b4dc2138d7dc99531f057b9623d5c.1705965635.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of KVM TDP
refactoring for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 8b8186e7bfeb..e893a3d714c7 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -25,6 +25,6 @@ Patch Layer status
 * TD vcpu enter/exit:                   Not yet
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
-* KVM MMU GPA shared bits:              Applying
-* KVM TDP refactoring for TDX:          Not yet
+* KVM MMU GPA shared bits:              Applied
+* KVM TDP refactoring for TDX:          Applying
 * KVM TDP MMU hooks:                    Not yet
-- 
2.25.1


