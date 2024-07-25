Return-Path: <kvm+bounces-22218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D92E93BD07
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E98081F2237A
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0491171E5A;
	Thu, 25 Jul 2024 07:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9EbnNlm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB2916F830
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892179; cv=none; b=Md5YQgU8Q5TOWk4sr2ARIQQo7ZBVluJ9H4M9O4PrhegjPk08IOcmNxYbLW3IHKpIa4fO4Onici8NNqeNC2ffzmTcZlXUGfYUma05BIQh0ad0owDD9aM1PlYJl21hhjzIGxqSVf8qm38aU27GCHeSJCcAbOGTn2s0pWwZMTg/0/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892179; c=relaxed/simple;
	bh=l2lUqV9g3yKHM7XwJAQ7khV4fRpn4ow3j+tpeoa6IUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnjAcWsz83pjWSHi6zzCWfxNEBTrkfW3JuGdZHocRR/dVpBhrHyFt1M0Zg9prFZ9QInJhcLuN2qeN+ynvM5FVey7jfyD3RMf/QgGV7D5SOg7MRPTzPmnhNFsQKaHQUUjnsWRVlNXhyIm3WwWL0/m4P6rjQ+ULRB5TDJ7PZ17Cw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9EbnNlm; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892177; x=1753428177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l2lUqV9g3yKHM7XwJAQ7khV4fRpn4ow3j+tpeoa6IUU=;
  b=O9EbnNlmHeoKiT6pC+hMbdaffjKNRDf140XQf+6Dib/8siDlwZX9T+Rb
   xD5d4JhJHmXjDficGHKFxRt3iUoMTuBbxDC1JL56PPXsxI0RtKNYM/KPp
   VxQT9OcFWkS6/Mn5g04UmrzOjyQEZqwKvMBxz+NquOso3wFu6Mp8e9K5o
   mqv313eDh6Q6JtPQkWBnSzFcT+LvdKwzFEdZUeQeFgzy7g4DFgqDDucdq
   bt7jCIPTC3Is4n0RHyIjqPz5hbKoX+vMvGzAwSupzg/THTOTVOWNW5eGA
   gO5e3qKInwJ04s20R59ToeNsgdWpSU4mp8adWY46le1IvaFmo9vf0anUK
   A==;
X-CSE-ConnectionGUID: 37MLHl1vS9iVhMaTMtdJuA==
X-CSE-MsgGUID: xFm5Y2tUQouBB14CAa7fmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30754006"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30754006"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:57 -0700
X-CSE-ConnectionGUID: 3L+kWF1eQP2UnHrtemDUQA==
X-CSE-MsgGUID: aE4D7ZLoSU6JV3CkwMoB0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858196"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:54 -0700
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
Subject: [RFC PATCH 5/6] guest-memfd: Default to discarded (private) in guest_memfd_manager
Date: Thu, 25 Jul 2024 03:21:14 -0400
Message-ID: <20240725072118.358923-6-chenyi.qiang@intel.com>
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

guest_memfd was initially set to shared until the commit bd3bcf6962
("kvm/memory: Make memory type private by default if it has guest memfd
backend"). To align with this change, the default state in
guest_memfd_manager is set to discarded.

One concern raised by this commit is the handling of the virtual BIOS.
The virtual BIOS loads its image into the shared memory of guest_memfd.
However, during the region_commit() stage, the memory attribute is
set to private while its shared memory remains valid. This mismatch
persists until the shared content is copied to the private region.
Fortunately, this interval only exits during setup stage and currently,
only the guest_memfd_manager is concerned with the state of the
guest_memfd at that stage. For simplicity, the default bitmap in
guest_memfd_manager is set to discarded (private). This is feasible
because the shared content of the virtual BIOS will eventually be
discarded and there are no requests to DMA access to this shared part
during this period.

Additionally, setting the default to private can also reduce the
overhead of mapping shared pages into IOMMU by VFIO at the bootup stage.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 system/guest-memfd-manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index deb43db90b..ad1a46bac4 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -393,6 +393,7 @@ static void guest_memfd_manager_realize(Object *obj, MemoryRegion *mr,
     gmm->mr = mr;
     gmm->discard_bitmap_size = bitmap_size;
     gmm->discard_bitmap = bitmap_new(bitmap_size);
+    bitmap_fill(gmm->discard_bitmap, bitmap_size);
 }
 
 static void guest_memfd_manager_init(Object *obj)
-- 
2.43.5


