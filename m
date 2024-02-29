Return-Path: <kvm+bounces-10366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C7086C0DF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8A72287274
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3134F615;
	Thu, 29 Feb 2024 06:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YVngwO36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC694F1FE
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188722; cv=none; b=sqPn+QpTmplz16ZtHPQv1BJE6NFJp8sklHh20JByNJGe3DUsXDejmp1jTM6dXCTHRRNdzRTmXsgJGY2M0e4KfwIYQjAs7VU58f1l4ZLdqGyy2l51IwOHwf7WveA9ZXwV/jCPKoX67kBky+KfLKvOZIssYofPCKG954LZWcvt01M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188722; c=relaxed/simple;
	bh=R6P1mkE+VzbCklXI+XUrVzqW75xnxMrG1Ytrh3IX+7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mvHnpFcbcpSKqFCRdpAH/9FOm/YLSYJg6I8nEVd2to85m4dASbZCLfWNGTwRpwu68qRuNf056KmSdiUliVnFny4fZH03az3clqe7VOmZHgC7b4lZTMJGn5nEQDDe0j397K6RGjJAhSpoi5t2tSB0GEc+GIG1btfUz6Uriy8GqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YVngwO36; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188720; x=1740724720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R6P1mkE+VzbCklXI+XUrVzqW75xnxMrG1Ytrh3IX+7U=;
  b=YVngwO36YsNljVdECMShQDPp/CEcdLAzoJa/ytMBTN/Cdou5Zjvc0/TV
   gA96lHTIfkbG1bqx18dVjGazUho+Q8XkoP2KPpOcRTMxmfz+tgfpbvf0E
   qTr9XQzOyeDYBZmGdJi06uDRFrVVmX2sSIynhcZt3NxDu/5wDDDMAKBcf
   6Ci0iK4zlcBhZQaccnCIEKE88fcJMjqf0+y58clz8AQchkCH7lwpq25OP
   YwsG5cnjXdt7VhE0BJsVeFM1BAuMlkfSZJwDyoFhMWk2Y41ZQP86mpVfo
   fF6UxAqJ/jPxcVHrR8Lrr6fKEO3LwbyrDNg4gCvjnEGUzxc2q0VYxfpQJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802555"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802555"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:38:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075011"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:38:34 -0800
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
Subject: [PATCH v5 10/65] kvm/memory: Make memory type private by default if it has guest memfd backend
Date: Thu, 29 Feb 2024 01:36:31 -0500
Message-Id: <20240229063726.610065-11-xiaoyao.li@intel.com>
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

KVM side leaves the memory to shared by default, while may incur the
overhead of paging conversion on the first visit of each page. Because
the expectation is that page is likely to private for the VMs that
require private memory (has guest memfd).

Explicitly set the memory to private when memory region has valid
guest memfd backend.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index fe2eb3f06902..0c0719a0303c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1451,6 +1451,16 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
                     strerror(-err));
             abort();
         }
+
+        if (memory_region_has_guest_memfd(mr)) {
+            err = kvm_set_memory_attributes_private(start_addr, slot_size);
+            if (err) {
+                error_report("%s: failed to set memory attribute private: %s\n",
+                             __func__, strerror(-err));
+                exit(1);
+            }
+        }
+
         start_addr += slot_size;
         ram_start_offset += slot_size;
         ram += slot_size;
-- 
2.34.1


