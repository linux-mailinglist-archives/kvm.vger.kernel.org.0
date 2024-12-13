Return-Path: <kvm+bounces-33696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 310CD9F0535
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5A1728134C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037FB18FC9D;
	Fri, 13 Dec 2024 07:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0aZH8u9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8FF19006B
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073776; cv=none; b=b2I7viAiGqRov5/7R2JW8fkRdpDEwi3OAX+litBHu0yrKfqT2vErWexLnvhTey4pCzkZExdCPHrwy0UXtGa19VtbLd/v7jrsXjuOORG8u1zoMx9cwsNTYDYN1qaEgztgI078oPbZIw+X6I7FhZ8KB6sZKjeOiQbdZwCK6CpgSJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073776; c=relaxed/simple;
	bh=be+9xTTlW9Q1UDuF2/Stfqw8KCfr7EfJ8tCu6lwkuG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIFJ8Vv6whQZYOrJZOJmOvWMG7SsPEEPPqbk2dzmgdVQ8AMNnyoXETqif60dld13MdiOp+4VPkziLEnvfyut0cCKGl4g6WuL2QgG46CnVKwhEWMj+FduyFk9oeqmy6B56nJA4OVnlPCRM4QpAyKPHYWk/RjWDxCwi1nPvMFtUbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0aZH8u9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073775; x=1765609775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=be+9xTTlW9Q1UDuF2/Stfqw8KCfr7EfJ8tCu6lwkuG8=;
  b=O0aZH8u9NQMSpBSpGR2WaBnsmnKZ9hSJyyCGNQPXu8O3osbyK/tA0wvE
   fAlIWrPVSKHIsLSfQ7crPOuK6I1dnKpT7QftyiMJn/MM8uN2OgSld9rU9
   0srYL0Vx7YUsGRK0u+pxkmoxFzHmvyrPV1IMN30KekwayEvZN5Vv6o2/A
   D7Y5M9wEAEFm5ai/831Cs8XaUJsxji64KfjvZdrBKNgpd9ZuaWUQfirSH
   pDyv4oBbITYsnaLKBdw2UXtbpFZn1soyjkAVZrgfLK/gROb8f+8+CWLTY
   Fkv82tUKgnc/fUhk22UCynpiGIgTr9E13TPKOsFzvHdITrhEDClqO0xVC
   A==;
X-CSE-ConnectionGUID: 5LkizjiSQCi1W9wmSY7O5g==
X-CSE-MsgGUID: Tghwb7ECRxKpxhYn44hSPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937099"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937099"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:35 -0800
X-CSE-ConnectionGUID: EN3ia8tuQ6Cs2wMQRzzq2g==
X-CSE-MsgGUID: RVV3xVuERumDJExGsQeMfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365582"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:32 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6/7] RAMBlock: make guest_memfd require coordinate discard
Date: Fri, 13 Dec 2024 15:08:48 +0800
Message-ID: <20241213070852.106092-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241213070852.106092-1-chenyi.qiang@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As guest_memfd is now managed by guest_memfd_manager with
RamDiscardManager, only block uncoordinated discard.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 system/physmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/physmem.c b/system/physmem.c
index 532182a6dd..585090b063 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1872,7 +1872,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         assert(kvm_enabled());
         assert(new_block->guest_memfd < 0);
 
-        ret = ram_block_discard_require(true);
+        ret = ram_block_coordinated_discard_require(true);
         if (ret < 0) {
             error_setg_errno(errp, -ret,
                              "cannot set up private guest memory: discard currently blocked");
-- 
2.43.5


