Return-Path: <kvm+bounces-10365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F00C86C0DD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 453701F238F7
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51FA4EB3A;
	Thu, 29 Feb 2024 06:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iIMwUs+h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972154DA0C
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188715; cv=none; b=RhBM0XC0GOcHW8PySRP6ePUkqKO3EZRYbYPOZEatFg2hwogqKBxziZ6CpS6GSM2cXBSRKF6364bdoqxn7wJqTeXPlZl0o1n5IBnP1zdlu9eKEORwBZOZ8YQYqgIjhlnISMNAO6HCIvqAYqsD1WJQKkDBtifj2qWIqp8siM6/x8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188715; c=relaxed/simple;
	bh=JyVMX810DXl+dX+w8+WDx/YFXlVut7d6olHsgcNQ9es=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NyGUPut6DwqlfwzNbxNXWtqhQP/IItBG+Zd6N/gNfZRoO3qviBuiuQZqWDXNCUdXlaSbYMlsRYa0MHBnfUauumpJhnsOHKdIz+1nMjLieoW5Qy6yMZLqUq+nqSdVAu0C93aM/GTR+UDjQHoc3uYJnPT3Q4EbvtRYgmMC0sBwsXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iIMwUs+h; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188713; x=1740724713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JyVMX810DXl+dX+w8+WDx/YFXlVut7d6olHsgcNQ9es=;
  b=iIMwUs+hOnPJvxqd8ekc6a/U0Q2N9W2OuerT2a4PMbCyYFPjQYi8EWNV
   TPtGiVWnOxcCuTJ8YvDZWXXpq+HCZHFfXsELJPuceAaz4s32nPwG4VEPb
   WwBGYmeg+wLhHi1YIGt4UCTHKeQ7fd0DXl7ofD7CKdjavId9RyR8Cz/zP
   IGiRzvxfwnMKKik0qSoWaqv/r/zucDjCUrjY0+Dqud1/nr/g0gx5uZLtb
   1CZqBUkjlvkmknrlIP9fIeeWwmRJ57ZwLm7GW98SacbzXByvIuTXR3nmF
   CITg+SaOt+dlmXSOMK59qMQcKhp3rFkxYtQTdBhCdcIyZQHVMvQA1ilRD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802537"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802537"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:38:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8074993"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:38:27 -0800
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
Subject: [PATCH v5 09/65] trace/kvm: Add trace for page convertion between shared and private
Date: Thu, 29 Feb 2024 01:36:30 -0500
Message-Id: <20240229063726.610065-10-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c    | 2 ++
 accel/kvm/trace-events | 1 +
 2 files changed, 3 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 87e4275932a7..fe2eb3f06902 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2912,6 +2912,8 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     void *addr;
     int ret = -1;
 
+    trace_kvm_convert_memory(start, size, to_private ? "shared_to_private" : "private_to_shared");
+
     if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
         !QEMU_PTR_IS_ALIGNED(size, qemu_host_page_size)) {
         return -1;
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index e8c52cb9e7a1..31175fed97ce 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -31,3 +31,4 @@ kvm_cpu_exec(void) ""
 kvm_interrupt_exit_request(void) ""
 kvm_io_window_exit(void) ""
 kvm_run_exit_system_event(int cpu_index, uint32_t event_type) "cpu_index %d, system_even_type %"PRIu32
+kvm_convert_memory(uint64_t start, uint64_t size, const char *msg) "start 0x%" PRIx64 " size 0x%" PRIx64 " %s"
-- 
2.34.1


