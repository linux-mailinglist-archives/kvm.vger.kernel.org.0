Return-Path: <kvm+bounces-6693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1879837888
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6305F1F24704
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B752C86AC2;
	Mon, 22 Jan 2024 23:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IWLK9EXj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2C85C73;
	Mon, 22 Jan 2024 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967787; cv=none; b=jqGxkhyoLlz0c7P0N3dDaA037LcWyhb6LQQuCC+Ik0qpzaWkvLnhIemrZ6lQO4clSf/UTIYnCs7jkArpuejZkM4niBv0DuvPdGuiUL/4OE5PZ8dj2Dwmp/BvsO8ov8c9xrfVtMmf4juS6jIDp9J71wJF6/KM9Vi8PcMliaR7W/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967787; c=relaxed/simple;
	bh=kTm2N9RfSmKUFkaBFlwPDYytjDkSW5CSsRnqKsK/nWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gcil2/lRpY2cY4GwX922NdBwhoPhC4Dj/2FbMUO0zJmZcUkebTD4SjfE6nzuqmqrRcS3z03HV6E5TBe1VQJeGedLFL4CwnWhW1dk2ajcOWSkEqExUGzyb7D4qTyBkgkdGvixJQsa9ChzYwmalg8/14QRfyLAQPdHHb000vwN3M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IWLK9EXj; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967786; x=1737503786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kTm2N9RfSmKUFkaBFlwPDYytjDkSW5CSsRnqKsK/nWI=;
  b=IWLK9EXjVZo8W+yslSQdijxo0I/qtWHqPD1e2Xuh8mDAbtsYgh/LkEA6
   aLsBEyLyfuZh+bAf+fnVFQAzsBaQh7K8wwMd+M0OaenJDTloNi1VeLCEY
   BrMrjJMJPzM/wcdzZYQ7Cpu+Rh4IQldZrZ+pZmzHKgVbifzpe9qY40sud
   dNSnPn78DtFknFjcvezbGe3hD3yZfM2ic5g1cy9liiopVWCkiliAKcOCz
   FkjP5f1a8wQvVwXwOQDmaJgknFHfP/+N/M5JD+ROcek1pCmVs4R0G2HBC
   Y2sCHjohzoOlTE9eiOPBOI71W8+m3MFiU1IwPnCBVPCaKDXNxijvFE8/q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217976"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217976"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:56:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818063"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:56:00 -0800
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
Subject: [PATCH v18 121/121] [MARKER] the end of (the first phase of) TDX KVM patch series
Date: Mon, 22 Jan 2024 15:54:37 -0800
Message-Id: <c84dd2574f06133cac983d16154ebf8f65ab0bbb.1705965635.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the end of (the first phase of) patch series
of TDX KVM support.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/index.rst              |  1 -
 .../virt/kvm/intel-tdx-layer-status.rst       | 33 -------------------
 2 files changed, 34 deletions(-)
 delete mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ccff56dca2b1..5e78a8fc2fbd 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -20,4 +20,3 @@ KVM
    halt-polling
    review-checklist
 
-   intel-tdx-layer-status
diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
deleted file mode 100644
index 7a16fa284b6f..000000000000
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ /dev/null
@@ -1,33 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0
-
-===================================
-Intel Trust Dodmain Extensions(TDX)
-===================================
-
-Layer status
-============
-What qemu can do
-----------------
-- TDX VM TYPE is exposed to Qemu.
-- Qemu can create/destroy guest of TDX vm type.
-- Qemu can create/destroy vcpu of TDX vm type.
-- Qemu can populate initial guest memory image.
-- Qemu can finalize guest TD.
-- Qemu can start to run vcpu. But vcpu can not make progress yet.
-
-Patch Layer status
-------------------
-  Patch layer                          Status
-
-* TDX, VMX coexistence:                 Applied
-* TDX architectural definitions:        Applied
-* TD VM creation/destruction:           Applied
-* TD vcpu creation/destruction:         Applied
-* TDX EPT violation:                    Applied
-* TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applied
-* TD vcpu interrupts/exit/hypercall:    Not yet
-
-* KVM MMU GPA shared bits:              Applied
-* KVM TDP refactoring for TDX:          Applied
-* KVM TDP MMU hooks:                    Applied
-- 
2.25.1


