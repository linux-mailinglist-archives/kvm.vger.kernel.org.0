Return-Path: <kvm+bounces-1761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC9F7EBDB0
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 087BA281312
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D7CC8ED;
	Wed, 15 Nov 2023 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bcE1+wrs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5813C12B
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:19:33 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D38E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032772; x=1731568772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bDn2RjuRFfQIgZQkWskSJy22Talnsr6AiwlkVu/nnqo=;
  b=bcE1+wrsbcyq8BbW4VevHbE0ybp61qkPuOAKAXrlEhXszZiH71NpeS1b
   +t+yTQVSRbeu+ft0YsAaN7XdlPQ9W+N7ZQBNbFprO3XaRyDXxr1Iy1ios
   xxUyw2TcVDTGft/2GfKoqJKCbjT1J0DU7DbElXyCC97qVz/zeVvE50NEI
   RzljTKJDG6EfHT0s2YTD/dfw511Y1tlHB41MhMvKLuANhSFpU/eJLExJx
   XJ4WZ9nTNhgpNplirZ8zOz4SNgPJwbQbRobIOkxE1aqLBxaZDZSS6BPOQ
   O4+0FrrgqhkHhDWmW3tbwmTRvxC6QKzLIlYpGK/dIIbyoxM1uyv/NJQAv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622952"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622952"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:19:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714799140"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714799140"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:19:22 -0800
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
Subject: [PATCH v3 33/70] i386/tdx: Set kvm_readonly_mem_enabled to false for TDX VM
Date: Wed, 15 Nov 2023 02:14:42 -0500
Message-Id: <20231115071519.2864957-34-xiaoyao.li@intel.com>
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

TDX only supports readonly for shared memory but not for private memory.

In the view of QEMU, it has no idea whether a memslot is used as shared
memory of private. Thus just mark kvm_readonly_mem_enabled to false to
TDX VM for simplicity.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 05ca841d0b66..50e68f9c1a41 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -472,6 +472,15 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
 
     update_tdx_cpuid_lookup_by_tdx_caps();
 
+    /*
+     * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
+     * memory for shared memory but not for private memory. Besides, whether a
+     * memslot is private or shared is not determined by QEMU.
+     *
+     * Thus, just mark readonly memory not supported for simplicity.
+     */
+    kvm_readonly_mem_allowed = false;
+
     tdx_guest = tdx;
     return 0;
 }
-- 
2.34.1


