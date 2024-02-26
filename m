Return-Path: <kvm+bounces-9707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DBD4866D3A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CB421F2259C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9658C78685;
	Mon, 26 Feb 2024 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HuTfOZXj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0463962A09;
	Mon, 26 Feb 2024 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936123; cv=none; b=X7lohWvRehkKhGURYUcxs72QemZ9GneVFNTy6+THHFzml5OQ7Ab/azZK2qcyj1RAnjd8Amy7IkmkVxXCQ/KB2tVf8dJEu2nOXLbQe6n71ZHCmDYJUWshNXau6wW+jn/ysIXr+nxUEZP5l84nO+2teiNjRYmxUYvQHpzTSUytX9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936123; c=relaxed/simple;
	bh=J0qMXx4Z1bmL0Bo7ShUuSxkVx6XY1Y4HAlOmBvk4LIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vi4+s8zXfw+u79epR4L+vmqIICqu8pHrvFZu2jrrHi/uJCU8Jl6rKxuPOq3Fn4+KvJuHSBu6CV3RQQ++8BehXD2ei4JwCOJStqJ5A+CWGa+uwtsE4a/yGCXZLvJpioBhFkmHlAaD+GnEBjsLhQdQRwnLf7VJ79FAvK5DEQKvMp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HuTfOZXj; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936122; x=1740472122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0qMXx4Z1bmL0Bo7ShUuSxkVx6XY1Y4HAlOmBvk4LIo=;
  b=HuTfOZXjCpF/+oHRJaIz5kHiAMFTc8/1v8Lfxi0Hn/gYk0yQuBtAewq/
   9Z97pH/cEN/cIIVWPJTCzXmJ2PFyd3lnQv5MDkJjv5GhDTq6r8hnRMtkx
   yt/0Dn3JwfdVCwc6mYdYXQIFoFScYV4biNncuI3DO3jlUwVxnLdfddDqm
   YulJ6F7dYefHsmHxmKI6BlIvGRDcksC9Fp5QaBhDPD/gGk6qLinsWF+DT
   2DbgRwOAzxbSgaHQ3Jb2Abd8/NsSWvsBxuKiPfHcyrMhEwI/BetwX2TO1
   pqh0Fn+e4fSPiOeZzDqs/naua7XZoBhR4n/yGfP7bsdpulJYHzRpVeRJP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069525"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069525"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272570"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:41 -0800
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
Subject: [PATCH v19 084/130] [MARKER] The start of TDX KVM patch series: TD vcpu exits/interrupts/hypercalls
Date: Mon, 26 Feb 2024 00:26:26 -0800
Message-Id: <c9440b060d23d70e9ca1ce9b80632577362cb816.1708933498.git.isaku.yamahata@intel.com>
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
exits, interrupts, and hypercalls.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/intel-tdx-layer-status.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx-layer-status.rst b/Documentation/virt/kvm/intel-tdx-layer-status.rst
index 33e107bcb5cf..7a16fa284b6f 100644
--- a/Documentation/virt/kvm/intel-tdx-layer-status.rst
+++ b/Documentation/virt/kvm/intel-tdx-layer-status.rst
@@ -13,6 +13,7 @@ What qemu can do
 - Qemu can create/destroy vcpu of TDX vm type.
 - Qemu can populate initial guest memory image.
 - Qemu can finalize guest TD.
+- Qemu can start to run vcpu. But vcpu can not make progress yet.
 
 Patch Layer status
 ------------------
@@ -24,7 +25,7 @@ Patch Layer status
 * TD vcpu creation/destruction:         Applied
 * TDX EPT violation:                    Applied
 * TD finalization:                      Applied
-* TD vcpu enter/exit:                   Applying
+* TD vcpu enter/exit:                   Applied
 * TD vcpu interrupts/exit/hypercall:    Not yet
 
 * KVM MMU GPA shared bits:              Applied
-- 
2.25.1


