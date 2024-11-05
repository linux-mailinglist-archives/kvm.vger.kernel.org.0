Return-Path: <kvm+bounces-30666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 386369BC5A4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3CEBB221F5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7961FE110;
	Tue,  5 Nov 2024 06:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1xE4RW3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E161FDFAD
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788721; cv=none; b=oQe50v2u5ZAv3ec8rLz4aZ4q3VPaKvQgj5M8Nk1Jos1naxDC0jlBOW6GGJVmjHB6n5l3kNAr5Fj6X0e1wt8tPzNVsTZc4Yrr4aeuffJRXb5XoQEW03U6tLpkf90yw5KVrUPcwumhVgcucA0UU0O50iW3X72zjBm6vnfAMviNVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788721; c=relaxed/simple;
	bh=IFyldM/wkLLjkzgvXirqmq3JCBeSDG+HIbY0Aejj2GY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oXG9cL1iTXxTR3ax48HpADRqGO0n52OmqRI0lsrj7hBkaQRZF23oOl0uZXBe7+33M7Pb4Y0XZ14FVPjZ9K3B5696eslKUcw703+wQrl9VmlQ3KDLpHtDGjvRAa5IRMBxk0ntofm2GsdAvHOPA+GVgW7eWYqXgr/Apro+7K0JnZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1xE4RW3; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788720; x=1762324720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFyldM/wkLLjkzgvXirqmq3JCBeSDG+HIbY0Aejj2GY=;
  b=X1xE4RW3BYRmw9ONODniHEFnPcXaokxnV2pKBZk4eziWkbB9I7JRAJi6
   ICjVoKr94sa2K6ovacFfqpJCIoErp8En7+A1q2AYGAdRl3z/q3/f6ZV7F
   psVT5JNzp+GKRZlgobwuMCEe8QSyS3VwyJx5pJDg0eTjsNcfnw71h4CBm
   hXyoI8gTOGOx9uwKOgpEbFFqUYMD526aodkb5/9gjTe+nVnYKbXPibX9D
   vbFOF4RxGwO7UuPgEY5bq9j4QoL24JWS9tcvPczlcbitufRiMJyhCu+9J
   uJ0d0+Rlh4mLCsVWvmBlhRcb4Dble3I/lw/wQ5dBigWjA1eHaM/bHWtpj
   g==;
X-CSE-ConnectionGUID: x7B367ezT0efSLnn51GDnw==
X-CSE-MsgGUID: 59eTzcWrS6GFw4E23DPbvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689682"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689682"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:40 -0800
X-CSE-ConnectionGUID: iuT24egDTnOHJU8nk9k9hQ==
X-CSE-MsgGUID: 35Pm2IzXRcuowvndLGKt2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989208"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:36 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 32/60] i386/tdx: implement tdx_cpu_instance_init()
Date: Tue,  5 Nov 2024 01:23:40 -0500
Message-Id: <20241105062408.3533704-33-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, pmu is not supported for TDX by KVM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
chanegs in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 394f1d75dc0d..61fb1f184149 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -384,6 +384,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
+static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
+{
+    object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -727,4 +732,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
+    x86_klass->cpu_instance_init = tdx_cpu_instance_init;
 }
-- 
2.34.1


