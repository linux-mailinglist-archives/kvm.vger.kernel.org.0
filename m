Return-Path: <kvm+bounces-10384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FE486C0FD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DE33282953
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5EF44F205;
	Thu, 29 Feb 2024 06:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPiLptnX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8528D4EB3A
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188839; cv=none; b=TaCj15QNBTxFtNasW+wxA/9dU+4bJyHgfVKyHfbqP8oPWU+Cu/qh9XJirdy5sXmB6CetYevWZvcCRf2Vtk9A7gc2FDQua2g7ZJg4c2dAQA7ZQrndvWaWPvAK+3FIWmBezVrcNfq2jGNoFdLxjHpLV6KJes0/2Y6gMKhdB/Q0Cq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188839; c=relaxed/simple;
	bh=RcN1i+VyxCmuAxfc7aZKC9U7QFVpxrbixJ8jY8jiEdY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QTu5ykvijBjUZYMPLbr8Vau0mjsvi64n8ndL3ICmlUoIzXrHnkkGUDRxkH3Di6Q2DIqptCzXIErtcPFmBxQswH9OQj/gC5dk6+rzcIWxAxSvF8RLKf/Qpq5h9VDMwSYHAtQTAElelCAS+SZT06/IrFAsrqhvV2MzVCiOqbHMxjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPiLptnX; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188838; x=1740724838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RcN1i+VyxCmuAxfc7aZKC9U7QFVpxrbixJ8jY8jiEdY=;
  b=SPiLptnXpm4Gs8J2sNQCeGtzBIsFwYBdyWJRKQRUOHhHXaC8ngrGyeUT
   R3ZGYM4MViznLKLU5HH8dhXlcWaH5oP7bV7wX/7Zjs6trNw4oe5WhpGIq
   C+XA+bKWSMTaR4PT5yvblvzeZhmIB29PhwxL1XwXIezXZHZS5b5TbXSl9
   Nsns3jzL1HfKpQvPZRgjnTUXkEYrrktTxbqt8v2AuLULwBb3/eLh5fd5V
   22nnsEVOy14PaCf5oci8p5mO1yyGVju96L3kAiIfQDjajDQYMc8sCdGF6
   SJxTHaQuRA+xx3H3hmt+sDP3VMz1xM/R7GAQ0gtBr0MwxWtEyBdFA75vF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802788"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802788"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:40:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075543"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:40:32 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 28/65] i386/tdx: Disable pmu for TD guest
Date: Thu, 29 Feb 2024 01:36:49 -0500
Message-Id: <20240229063726.610065-29-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current KVM doesn't support PMU for TD guest. It returns error if TD is
created with PMU bit being set in attributes.

Disable PMU for TD guest on QEMU side.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 262e86fd2c67..1c12cda002b8 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -496,6 +496,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
     int r = 0;
 
+    object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+
     QEMU_LOCK_GUARD(&tdx_guest->lock);
     if (tdx_guest->initialized) {
         return r;
-- 
2.34.1


