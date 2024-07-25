Return-Path: <kvm+bounces-22219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC5793BD08
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9BD0283131
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50637171E4B;
	Thu, 25 Jul 2024 07:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mxb/rfnX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2586816D9B9
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892182; cv=none; b=XbMvW6nk0REltx42W4hzAmDPjSheBkgYDykvR4Fos4hRo/pCxYdQvYe5KhBYnozuLMU9E/2lhf1ZY3w572p8a7EPyks6XNx18o6aoRHo6xeWymn2d6TFZZNNi9irJegPr1wnEepRTJcC3W2h7SgwK/xw/47FdD2hsm8EwYedCzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892182; c=relaxed/simple;
	bh=hEJIsWDYfFTtEa1W706+mMe0OCLnShBTQaakw4gSz8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhim7ngqwWkhhR8RrEL3Hr4ctUyKBMJ+YmWX9VDvPR9FKBqeE011Prvfpa+TPkW+fUXUD3kPNfFoeE44dVv13xVPhA0mBx0UXZL/RSMjI6Q+rJTwES0oxipTJrWzSpgseXJdCstOv+itVKj7ASo//GoD5vW5FEX8tTYJwXoEMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mxb/rfnX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892181; x=1753428181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hEJIsWDYfFTtEa1W706+mMe0OCLnShBTQaakw4gSz8Q=;
  b=mxb/rfnXK92igiff3uCh3mcJTnaMkONmcVdjfhAl5lWy1TmCqRD5vNJq
   VUf3O5KeWfpgw8y9pvw9KYSoVUcBIjnOGsz9iOdogQ2WqgrVisoMKcT4D
   WR1nbh8CGbN0qDG/awjhzji1p3SN/Uu1E5o7JI2BAI/RawKMtpw+c7/1N
   NghMShnGh76xRud2LfOKboQfwaPYLcNrfX2Iwy9pt2KK/h8A/xfIKYWH5
   IgqD1He+e5U5L7M97EXhS+w7vsSbJh7ZimOeFT/nA91/rIQdKxKYnCBRj
   jk7jq5QRYvGYPwqM/B0EOcaJjX55GV0Uf15fCv+Ro76X0yN+OLdU3HJgA
   g==;
X-CSE-ConnectionGUID: mXL/g9CdTkmX873Vz+4vZg==
X-CSE-MsgGUID: Hb+zOu8OTFWCETMeHzH0QA==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30754017"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30754017"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:23:01 -0700
X-CSE-ConnectionGUID: /vvKROvzSbqAL9fMxU/uyw==
X-CSE-MsgGUID: hWGUxWa3R/yK5BGhLtSg/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858206"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:58 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [RFC PATCH 6/6] RAMBlock: make guest_memfd require coordinate discard
Date: Thu, 25 Jul 2024 03:21:15 -0400
Message-ID: <20240725072118.358923-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240725072118.358923-1-chenyi.qiang@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
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
index 98072ae246..ffd68debf0 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1849,7 +1849,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         assert(kvm_enabled());
         assert(new_block->guest_memfd < 0);
 
-        if (ram_block_discard_require(true) < 0) {
+        if (ram_block_coordinated_discard_require(true) < 0) {
             error_setg_errno(errp, errno,
                              "cannot set up private guest memory: discard currently blocked");
             error_append_hint(errp, "Are you using assigned devices?\n");
-- 
2.43.5


