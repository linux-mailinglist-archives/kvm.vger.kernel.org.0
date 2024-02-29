Return-Path: <kvm+bounces-10403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1DB86C114
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E26C9B2703C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64E95026D;
	Thu, 29 Feb 2024 06:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RcbDjmOA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2A950263
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188965; cv=none; b=QiagbvCMIKh9lsRcQ9KpmoI3zH44u1wI6bIs35wi9jnMR9MhdJWYlI3CoqcVd/nR2rbQJ0J7Z1Ln5Xjdmp1hBpdWNQTRqAeD65l92r0pACMQwkipiheeYlsCWFC3RM2j3PIzLYSuSn/THSl4URK3L8aEFSHSWPPMzN/8pgAWSSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188965; c=relaxed/simple;
	bh=i4WnuF8PzcZlduKwCFj52sHXBfB/tx0hlzlToxAPyw8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d7FyWuwLlSu2DxKL5dZ5EiIrSFZtU+Z1QrMHgX0RqCAJwq5mMKkvxrIra/U/Nc5WstjOCbmJlfwwfM5N+WnlFzyEaL//IYTJcP9vcQryzHE0MhfcDcfbvtHWgLyK3R3ZNZx9xZxtXKn+z9jMO+O1EOBkaZtIxzV0z9GsQNdmhJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RcbDjmOA; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188963; x=1740724963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i4WnuF8PzcZlduKwCFj52sHXBfB/tx0hlzlToxAPyw8=;
  b=RcbDjmOAYIpcJ84AjQ6pb0/OWfw0au/0A1E257upRV9oy0jvQrf6aYKU
   N+2eAPiQBv3TWVKEn8IUkSBmxWB9LKA3+HRMB4Gxne+rJ3kPmoeODdQBK
   IavSUyejTuOx3hEDaJtn0Bcil6FhA/T5z73/G7CXgk3KLmJm3OCkMiYMN
   DRPcaCKI9P/+PTpbtFnkd5xxONIQZ8klnMMqjlWXwZsa0Zkeg7rZtkJpt
   /bu9uBrH+Fv//OJCeam+efaCAVXt5a6jLVYWsP92yEx1urnOwo+bsvxUa
   +pkqr4e7L9tJwIQFOuQshNOfGh9hvzPdXeEAdZKnFLArAmmHaxUIebNNL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803077"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803077"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:42:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076076"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:42:37 -0800
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
Subject: [PATCH v5 47/65] i386/tdx: Finalize TDX VM
Date: Thu, 29 Feb 2024 01:37:08 -0500
Message-Id: <20240229063726.610065-48-xiaoyao.li@intel.com>
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

Invoke KVM_TDX_FINALIZE_VM to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 4625f806920e..d445d4b70f77 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -685,6 +685,13 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
      */
     ram_block = tdx_guest->tdvf_mr->ram_block;
     ram_block_discard_range(ram_block, 0, ram_block->max_length);
+
+    r = tdx_vm_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
+    if (r < 0) {
+        error_report("KVM_TDX_FINALIZE_VM failed %s", strerror(-r));
+        exit(0);
+    }
+    tdx_guest->parent_obj.ready = true;
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


