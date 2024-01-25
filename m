Return-Path: <kvm+bounces-6911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2E283B7D5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D0B289151
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327E610A3A;
	Thu, 25 Jan 2024 03:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IR5P9oNd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC3C10A1E
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153293; cv=none; b=a6FNf+amFUoBQPN5p8NRGSK5+WVBoi94Y9IdTlFklkx6wFeHtAYjraF12hgrcYET3NZ8pbjFS5wI87WmKCTc+aDhmyzP+FKDD7svz/FZfk9hPtI+sZaP1k9yHYHS6oEJT7qj9yXVA7xRxd0IlEXXc+0YEh65lbnbKqe2eABS9M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153293; c=relaxed/simple;
	bh=StSREf5QkCSEOqmZOMZd9ps9P2w48xkgIY2iwYIvkos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XII1yu6ze15hre6vHUgElystfrVVInKzPy+QIQBaLMlm2zuC9H4l/ksLov+GKVT5ldpbUA0h43vni8jMiPFcBcJTqFKmwYyR5cudaxrzi5+i5mol37pjXsJlDra/ytd700psNXOKbLeDTeyWdk4/6cH80CfGMxdgJM1mHB0s1rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IR5P9oNd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153292; x=1737689292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=StSREf5QkCSEOqmZOMZd9ps9P2w48xkgIY2iwYIvkos=;
  b=IR5P9oNdu9ie+8MjARnMcg3Rc+jhL13mlJN1wdUsSuyrB25QMzK5GBP1
   1PjBNZliVs5RTl/xoer+4KQ62kvxrp6xe+mtGDo2un9rkySx8w0pITcE2
   ZTIYf87w0mKACSi564eFGk095+IhPtEy6L2TLF8jUqPDO3L+UU+TUFC6o
   B12ykNLFcfT1fcGTPRSpDc6ND/uGH6Lh44OxsE/rDDuJ4GEStNbVFaqcI
   sbTgGOF5hmHF7I+h7oXkpcEgLFsCs6Ee5x8aSvIN60tadwC9k2O2yhrrq
   giCmxoSSK9mjcFpTMIaZ2OOqr4x0ulyn9zWD3K6LZ6Qt2HbV+RaiKpk5L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428044"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428044"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084711"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:21 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 09/66] trace/kvm: Add trace for page convertion between shared and private
Date: Wed, 24 Jan 2024 22:22:31 -0500
Message-Id: <20240125032328.2522472-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
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
index 2421b8a5b314..def2b46b9de2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2902,6 +2902,8 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
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


