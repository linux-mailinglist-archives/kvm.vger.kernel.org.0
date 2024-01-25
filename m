Return-Path: <kvm+bounces-6949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F4083B825
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:33:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7AE01C21158
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9187E1171C;
	Thu, 25 Jan 2024 03:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jhydKGOi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ADB111A2
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153427; cv=none; b=sC9tMjKGb43ZjqbjCwScHbLU3mQ2eISoU4uLO8NcSQTW3TxJMbGJskBBqXvWMctcGRTRZayNix7HhGxPa+oYCiEzD5uDyCJ33yfOcHAYwHOGdS5PISWRPFsXNWNKlWh6B+sz/jcOXR87lgjCy+21dELJV9ZZUMEkiwIEBNwDmEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153427; c=relaxed/simple;
	bh=AdKQF2BW1bf4ZYSY+8ORr/ArRwOGx//exmON+mQRoYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Drpdl3UJPulOkhOSxyuvOlAk+qGj/63o/VUZ8pB/enrMiyVzWc9QNimLoLyzCokYz1DJ6hH1PoLKfjoF9ZHQak4kV8e6P+wPxJFj88US9u7FXsQyJSJ0c8QldsfwVaTEvfwXBWJOh8pYdBv2ruehVUOcbTuqs/4POxnDf8AxIMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jhydKGOi; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153426; x=1737689426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AdKQF2BW1bf4ZYSY+8ORr/ArRwOGx//exmON+mQRoYo=;
  b=jhydKGOia4fJ4i1facq62Fs6R3eyVbztiVJj+hd0eamLv5SyFltc7afB
   CC3Csdl/aw6aWytDVMylLUQx5QCdHU6PuUbGjLPn4smtKuSXkMmi04Ke9
   kXko6sDZa6JXszQjlB0D21owFJmqFIRTGLYR0KDB9dV3Zl3cCZs0v+yQn
   cA+W0IIH33nwBGr+FRNC2tmA88S8/s/SdGd5J+a+X+f9w0hc3YEowH90o
   suSZyAIYLmAQKF3lARlZgMvMBtMnr1HnNNMM8SUamvZy5OwBazhw0sG02
   seUod3ICeyQS04gkctLSPS+CBeElnu9+KbgSwf8Hek8qiiuza/LQ+95yw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429920"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429920"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:28:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086101"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:27:55 -0800
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
Subject: [PATCH v4 48/66] i386/tdx: Finalize TDX VM
Date: Wed, 24 Jan 2024 22:23:10 -0500
Message-Id: <20240125032328.2522472-49-xiaoyao.li@intel.com>
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

Invoke KVM_TDX_FINALIZE_VM to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 341b4e76bf7d..69a697608219 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -674,6 +674,13 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
     /* Tdvf image was copied into private region above. It becomes unnecessary. */
     ram_block = tdx_guest->tdvf_region->ram_block;
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


