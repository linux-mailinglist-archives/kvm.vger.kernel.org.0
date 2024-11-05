Return-Path: <kvm+bounces-30661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB8A9BC59F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 719EB2830E4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D731FEFB2;
	Tue,  5 Nov 2024 06:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K3jYleZz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A8C1FCF71
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788701; cv=none; b=gb2bakMNBxCxVn94xhMyJP/RJuFii7pdRWXETt+LqGzA8VtN2V1qRrCIBH9jD7B3sZJsmftpHo/OdnRbfXHiFFA9lOriBZq40nlQOMnZacdFz0ahZJuSxo8M13a2U6z/7TxLA9+QTGdKQkWOpJNtrPNtxd3UAfeDPbcOpvrmBgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788701; c=relaxed/simple;
	bh=CqV8pOHF0zado4AcM+LoYPzs2/IDXl5pQDk/iq626Nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OvGcFmLNN/10GxIsL9y7XS3qsICNWXCGvbclS98HhYVXsu83TsVcoES5GUbQitRwLw1Jlserog+n9xwbWLsvYk1ho6j+jS157Fe0i5uKa6gqwHxhCEchbuWMSWQEtRvIV9o7RFZHfMbPmLmCZygG/TZVI9Lpn9+sIrc4PxAupgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K3jYleZz; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788699; x=1762324699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CqV8pOHF0zado4AcM+LoYPzs2/IDXl5pQDk/iq626Nc=;
  b=K3jYleZzqSmRSHg3O02l38jJEZP0NdRPJJM9Rrhflk1qOxQX3mqWENLe
   O14TwPkO5bwU3zv5nx3cdFXO12zQzkLE31Ncm+QXaMAGe+xOzPJe0fdVW
   HbHRPKXzdeUGqPyot9mCmvMpahcKssYU33saVRddf0BA1U+qpdKourKyJ
   gzYluotQXnZQydw6UJLXqjEqc4eR+cnCGZZQfwPepdPro1wcgWgCNCazY
   DfToTV4HQLHEt9F4JPDvk7Cg+qXB0RQFL+OAydvlO7KVRJg5SkEviW+XH
   uFBk6MlutZCbLzSfxgu8ugUP+tWUO1NNm1r6xKNSsUjFyeAP63i63kOSB
   Q==;
X-CSE-ConnectionGUID: j1eTEZC/Q16t4D83RtYxpg==
X-CSE-MsgGUID: YKld6ZtdQpmrbWgLyFCqqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689604"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689604"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:19 -0800
X-CSE-ConnectionGUID: Kz4s4N8uRXmCfX4vxeZZNw==
X-CSE-MsgGUID: gzLPe+K2QjucAkeJFr6zoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989076"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:15 -0800
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
Subject: [PATCH v6 27/60] i386/tdx: Finalize TDX VM
Date: Tue,  5 Nov 2024 01:23:35 -0500
Message-Id: <20241105062408.3533704-28-xiaoyao.li@intel.com>
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

Invoke KVM_TDX_FINALIZE_VM to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1abca7a5be6d..33d7ed039051 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -335,6 +335,13 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
      */
     ram_block = tdx_guest->tdvf_mr->ram_block;
     ram_block_discard_range(ram_block, 0, ram_block->max_length);
+
+    r = tdx_vm_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
+    if (r < 0) {
+        error_report("KVM_TDX_FINALIZE_VM failed %s", strerror(-r));
+        exit(0);
+    }
+    CONFIDENTIAL_GUEST_SUPPORT(tdx_guest)->ready = true;
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


