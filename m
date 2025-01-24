Return-Path: <kvm+bounces-36510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC8FA1B704
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45CDE7A4061
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2AB524B0;
	Fri, 24 Jan 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ejs2qI4T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE9478F4E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725917; cv=none; b=ptnF/apuSuawy6ymcPLySmgAewggBI8jk2JYEIRoAwxEHJvOX5U60+W314//5zUI9CntAvs1HCqHBTujlziDM3wdfbOzG0KiBylO8c/i2wRh6om8fGlTpbh6jJZBK4+wt7OReZ9Is/IiXB6xWi8ScBqRf3fznOojlw6ys/gj9xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725917; c=relaxed/simple;
	bh=9LeRcYgDvW5lMsehq+j8bbe6PQs/g/hSfE4cA/e4doU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uLLEqh2yedFCmUK0mG0IAYJqDeWkv8nUsGMXTX/0oKQdZGIRJqRzbAE8ACsQaUPGZhVBliC4Dcjem77ptfq2sN8YZPHD/i9ttwWALl0HPPG2EvY7svc1X7UXcGt+vR+ggGFhhpH0zvxLCSU7hmVYUzVBIrDGR4YaSkNQxx5I7fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ejs2qI4T; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725917; x=1769261917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9LeRcYgDvW5lMsehq+j8bbe6PQs/g/hSfE4cA/e4doU=;
  b=Ejs2qI4TTtitu2uO5MXbSnoJs5jqt7eaOvV17m9XXWXI/hTKUHx2gb/R
   VE53BdVWUTNnAVj/w1lFQtfcXNarJ14AXx/Rwth5uNuusWk3SCjLcjRuo
   opSCEfa4Xgvde6URSnY5XYs5AKOdKCx0L6YJFi8plsDprwHS7Eity30Gl
   6Jbb0QVDvOxsmzHQUwTvxVb+23NhmP7YYPUWjCrs5dIHTkE9QzRP9+URi
   eelQDY8ZqwR+p+L2bTyaI0RIwLqQlfGhXYQGtNGGgchfiEofHbmt0uFf/
   LivpQoOUOCMglg4SqjUrr58Shf+qzclZpNEoYeOplFqcLcHsCHkq1op1m
   g==;
X-CSE-ConnectionGUID: MXRCT/m8Qm2LsYhzvMIryg==
X-CSE-MsgGUID: YYHmBLg4R0uldeEHrtgoxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246428"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246428"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:36 -0800
X-CSE-ConnectionGUID: A65DTX7TRl2FBFd2ClD4QQ==
X-CSE-MsgGUID: 4nMhs+4ZReudkhpfCqarDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804321"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:32 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 25/52] i386/tdx: Finalize TDX VM
Date: Fri, 24 Jan 2025 08:20:21 -0500
Message-Id: <20250124132048.3229049-26-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
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
 target/i386/kvm/tdx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 99c1664d836b..d7f7f8301ca2 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -351,6 +351,9 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
      */
     ram_block = tdx_guest->tdvf_mr->ram_block;
     ram_block_discard_range(ram_block, 0, ram_block->max_length);
+
+    tdx_vm_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL, &error_fatal);
+    CONFIDENTIAL_GUEST_SUPPORT(tdx_guest)->ready = true;
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


