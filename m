Return-Path: <kvm+bounces-1734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A80DC7EBD79
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D75E11C2083B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3665660;
	Wed, 15 Nov 2023 07:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCFwZV1b"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1912E4419
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:16:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF15C8E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032587; x=1731568587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+Zt4PPlUf4SBKG5BHDSP7VkS1LcDTzb79bbPWPOk4I=;
  b=eCFwZV1b115ZrbvOKse6sGsqsx7ukliOepntjmZHKUsXqMC2KaXkenK0
   iPLpmCfUqlpyE5Ej9Yzki6V9TPOkixTyc0S7+pUS/85/BfatYHR/GEVD8
   5A5MCEeKk2gze+Jyf6oZUBLIgY+16CTHVoQq8XtPuHYIi2ODdwFTMA4sA
   VqxEuEU4v4KhMQCp3lYATNFAeRf7BnHeqjN6URozyfqb7xjVRNh1fGOHN
   SespzWOMsLQAZRrZ0jgVz/I5UFEkHFPyjYM8etJ68X24LctBDxJLtuDIy
   xHiwnslvxBDy1A4SeD1Qubx2l2tcLOZzSly4AFn2+TFizKauCwY8d381a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622188"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622188"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:16:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714797046"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714797046"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:16:16 -0800
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
Subject: [PATCH v3 07/70] physmem: Relax the alignment check of host_startaddr in ram_block_discard_range()
Date: Wed, 15 Nov 2023 02:14:16 -0500
Message-Id: <20231115071519.2864957-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit d3a5038c461 ("exec: ram_block_discard_range") introduced
ram_block_discard_range() which grabs some code from
ram_discard_range(). However, during code movement, it changed alignment
check of host_startaddr from qemu_host_page_size to rb->page_size.

When ramblock is back'ed by hugepage, it requires the startaddr to be
huge page size aligned, which is a overkill. e.g., TDX's private-shared
page conversion is done at 4KB granularity. Shared page is discarded
when it gets converts to private and when shared page back'ed by
hugepage it is going to fail on this check.

So change to alignment check back to qemu_host_page_size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v3:
 - Newly added in v3;
---
 system/physmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/physmem.c b/system/physmem.c
index c56b17e44df6..8a4e42c7cf60 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3532,7 +3532,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
 
     uint8_t *host_startaddr = rb->host + start;
 
-    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
+    if (!QEMU_PTR_IS_ALIGNED(host_startaddr, qemu_host_page_size)) {
         error_report("ram_block_discard_range: Unaligned start address: %p",
                      host_startaddr);
         goto err;
-- 
2.34.1


