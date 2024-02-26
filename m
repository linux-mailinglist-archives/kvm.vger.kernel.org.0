Return-Path: <kvm+bounces-9701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F4E1866D29
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FF2CB26B44
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BBD626DD;
	Mon, 26 Feb 2024 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eeM+zcRy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC98269D19;
	Mon, 26 Feb 2024 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936116; cv=none; b=hiN0APu9MG0tfPE/q9OAwN2cKnZKFOWLxPmjR1ZfNo7IqkSsBodLDBuGEHqAV7bpDLX7En5YOg8HoixQBlyfB5bedwVhNdF9sQecL23CKk4z20G7TG/jUFWYd/5j2WZ5xG3pmqYqV54ddz5wnVdt+oDqq+LGge1d+2/+StvEBf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936116; c=relaxed/simple;
	bh=R5wOuoM4Onpjff9OlffMGMEw35e7AU+j3x/NDTZE/oY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=swzmfGverUUzAX7kiOw/ii6OwKNrY2gfHsUQcC12SQeGSPi3HE2Ze21sjTuHFFenFBrYe8e/UZH8WfSPw/k7zJ7ImLPH7iqX1Au7nNoV33GMJxkFxBdwgtU9IkUCiEHO/LipyE6CAX9QPp9KBGnLrsYEY4pXcFcu5l0UiZ8GdlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eeM+zcRy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936115; x=1740472115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R5wOuoM4Onpjff9OlffMGMEw35e7AU+j3x/NDTZE/oY=;
  b=eeM+zcRyOmknzq8W90XX8fcpNu8R3FvtucKZqTyn2yqltOwmYhi2IoRC
   JqCjybDESXdeDKp/a/ZqCxCfPB/DqpFcPJjBgF7oSQRZUsktdnhZXGuUd
   pgEQ7Y17dEUInwZnzxBT5ZVWQalynW+IOHUSaY89ptud2UBSmFxgwa0Lt
   i6BdPLIOI3zxWLML94wVYLowA0QdiBURpcNyjxXpzekSd9FZ4DcKP5fzH
   JzB8NcreJaWn8g5GZsVkKbWizD9fBlH/DTxNWUpsD8MiGcjw5KbroLvdJ
   rMqGxUKpq44z2+JpBZqxxzUauEUhgpVWCitd+qWhJCEe7hy6i8QCNfG1b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069496"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069496"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272497"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:34 -0800
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
Subject: [PATCH v19 077/130] [MARKER] The start of TDX KVM patch series: TD vcpu enter/exit
Date: Mon, 26 Feb 2024 00:26:19 -0800
Message-Id: <dbf887b65295cdead74b2c45bade70f1535975b8.1708933498.git.isaku.yamahata@intel.com>
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

This empty commit is to mark the start of patch series of TD vcpu
enter/exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 46ae049b6b85..33e107bcb5cf 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -12,6 +12,7 @@ What qemu can do
 - Qemu can create/destroy guest of TDX vm type.
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
+- Qemu can finalize guest TD.
 
 Patch Layer status
 ------------------
@@ -22,8 +23,8 @@ Patch Layer status
 * TD VM creation/destruction:           Applied
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
-* TD finalization:                      Applying
-* TD vcpu enter/exit:                   Not yet
+* TD finalization:                      Applied
+* TD vcpu enter/exit:                   Applying
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1


