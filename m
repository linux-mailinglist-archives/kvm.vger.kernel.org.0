Return-Path: <kvm+bounces-45928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE64AAFE89
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D42074612C1
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12EC8284677;
	Thu,  8 May 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WR/gTgz4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B45284667
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716774; cv=none; b=EGwPXy32qH9mhvpFWqmHfmI6uphsOiaPqe7ZN3+jrc1g5cqdtmKwIsn1pRNawofeBZNLMONniyPzpHW8odOhAr3UUwF51QV15ocRbyEzeG/dq0FEwxW1DQR7SgXpR8UeQfsoO9deKDpC5Q6esgBcgc7OrjZ1M021LoCLZUl4nx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716774; c=relaxed/simple;
	bh=c8GpjWQyLWaCunCGWCh8PjoNmGOLzRawaoRcM4niFd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq9CSrpfb16T64GdUpq8gT9wpSSroqy+1zZC4IL56sab0KxBkk0nQ0VNggSB2pSkVg7QfAZM5vuHuNgHI2Sw8Kc8Edhz3CMDne6KTfaBmPqag8RqJ5Nym9duaidP3KTqj3lTjXCJJe4pCOsuvE37QBl091XSMf+5/CiZEOsAq2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WR/gTgz4; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716773; x=1778252773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c8GpjWQyLWaCunCGWCh8PjoNmGOLzRawaoRcM4niFd0=;
  b=WR/gTgz4cxFjJD0WLsHczYrXewSAGsRHn037kdSsOtvKcZOr/OghBnAu
   ly19tVK608zRS/OL76ELOBkPfzB9qH3FCUPsu/n6rwfmnu3dfJmJRE+3s
   r+EKvJv/hBdjQZdw9/95CUlvgH9k8l/Re9u44ABGu8dXHjpvku+rJzA6D
   zVvjETL2SdyXPmTp7KxTTT106iMhIgt0TG1jhaqjDMwvpc1bshB57LT8Z
   vvFOYrPrWX4jLx6u6lDolx07F+9WO4t5+0qwXv34mUvPBIzgQ5cx37lM2
   YTV2QJ27YUWQSyCJDtRXf80TeGEv9U+EDP1IOzAhK5UFOPuTNBI3WdadZ
   g==;
X-CSE-ConnectionGUID: t1QNw3HeSjmV27zVNJPXkg==
X-CSE-MsgGUID: WiCxVLHjTLqPJRhIWJZA3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888203"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888203"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:12 -0700
X-CSE-ConnectionGUID: KORdYUxWR+yRwZ+HzQ29sQ==
X-CSE-MsgGUID: 9MyC18anSWGGfP6LUxeO8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440046"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:10 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 25/55] i386/tdx: Call KVM_TDX_INIT_VCPU to initialize TDX vcpu
Date: Thu,  8 May 2025 10:59:31 -0400
Message-ID: <20250508150002.689633-26-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX vcpu needs to be initialized by SEAMCALL(TDH.VP.INIT) and KVM
provides vcpu level IOCTL KVM_TDX_INIT_VCPU for it.

KVM_TDX_INIT_VCPU needs the address of the HOB as input. Invoke it for
each vcpu after HOB list is created.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6a9215d9f0d7..31b288382fc8 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -266,6 +266,18 @@ static void tdx_init_ram_entries(void)
     tdx_guest->nr_ram_entries = j;
 }
 
+static void tdx_post_init_vcpus(void)
+{
+    TdxFirmwareEntry *hob;
+    CPUState *cpu;
+
+    hob = tdx_get_hob_entry(tdx_guest);
+    CPU_FOREACH(cpu) {
+        tdx_vcpu_ioctl(cpu, KVM_TDX_INIT_VCPU, 0, (void *)hob->address,
+                       &error_fatal);
+    }
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
@@ -309,6 +321,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 
+    tdx_post_init_vcpus();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         struct kvm_tdx_init_mem_region region;
         uint32_t flags;
-- 
2.43.0


