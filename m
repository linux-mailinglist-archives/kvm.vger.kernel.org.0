Return-Path: <kvm+bounces-10413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 719AF86C123
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D29B8B272CF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D34482F4;
	Thu, 29 Feb 2024 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LrPGXL3F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1F482D7
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189029; cv=none; b=laKM+faZw6Mi2Tj4FbFmmsCGdrjzkNf3nbi0XWBplEoyvY3Zr9zpPOvmU44NlHZbIPn7sJgk/XFeulNj2ztvoSLVokN5n8MlRsJDFVX4Akums0c5v8aO4S7HWBAyGyMiPMculsm6XxIygbCp6IykLtyphqZNuoaeo9MKUoFXrYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189029; c=relaxed/simple;
	bh=2HpHUtoGlBgCRa/lw+ulygVEE6b54rA+j9YRCGAK7E0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YB2W0f3aBKVfxSdaeyWHQcMJjwfKaNtGqI5Rq67C4zi9cY04j5d80FIt+wWhbgnT5P4zp/eswoO+LA8GIc29fCRMhAllN5rzl7FHwi+X38QR/Sy7M83jRkk+SfudWd1qZVZjRlqrXtK2htUOZjZeuaYdGKtTrba7S6z6fc62yvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LrPGXL3F; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709189028; x=1740725028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2HpHUtoGlBgCRa/lw+ulygVEE6b54rA+j9YRCGAK7E0=;
  b=LrPGXL3FyZrCHP4lTgEUWe+/a0XLxUMYx5++B7LYTrMfBTeUdljrHT8y
   1Z2zB++hmWtSQUL0ARkKc1KqK250Plg4KaknGFcFlWzpUVITzRoF0fVqR
   Kyzn6hj3T2YGO+PEub78DOmxivhaGs52fy/DMpKVKLAj7W28JOD30ua72
   vY9ISFgG3JExT49lilBO6lQzY8OJ1i+/UgAUj2hqnKtwA4NdNsDyL8jNe
   5fyhBUXms/XfQyEriRhAf/JD3OkAchXoVmhLgXo5qMVhISz8ZWSkpthGV
   T1bCkV5RozaTxin1iu02EMQPreSf/N2CoCFnEElUHFy58KwwFqwLI+pkH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803208"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803208"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:43:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076378"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:43:42 -0800
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
Subject: [PATCH v5 57/65] i386/tdx: Don't allow system reset for TDX VMs
Date: Thu, 29 Feb 2024 01:37:18 -0500
Message-Id: <20240229063726.610065-58-xiaoyao.li@intel.com>
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

TDX CPU state is protected and thus vcpu state cann't be reset by VMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2748086231d5..b1b0384b0c5c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5673,7 +5673,7 @@ bool kvm_has_waitpkg(void)
 
 bool kvm_arch_cpu_check_are_resettable(void)
 {
-    return !sev_es_enabled();
+    return !sev_es_enabled() && !is_tdx_vm();
 }
 
 #define ARCH_REQ_XCOMP_GUEST_PERM       0x1025
-- 
2.34.1


