Return-Path: <kvm+bounces-52417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72BC0B04F33
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C316E4A49F9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7292A2D0C9C;
	Tue, 15 Jul 2025 03:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jcWxei49"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A9B218827
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 03:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550794; cv=none; b=ELhsMyEdFIMqD3s0rSO0GAcajfTBgM34c8d8AISkvnIZkzv9gP+vY//AMmyFhN1tmRAte8hGC0HoqECnZN3Az2i4h9/VucR1+N68hOByMgZZzg9Mkfm8s3mXsK+4hJ/rYirfZBHqxllgSTiM4rLkyMPCOrcRqmcoQOYRR+7OAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550794; c=relaxed/simple;
	bh=zhKngkI310nx9PU9b2zv40h2kHDRfhghd844MS9S4mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL72yTVxaEZ6fyixKCwo2aiKIs8IFhpiM5myypcex+jrVKJEN39wLp7miQY1fN9SG3yxhp45Aac7HPF+bA0WJgmIPsa9Yk1f0o3pbkjItVnOMt71vdXpG6bWcw16ak8VeLDVvCvjbaP73MZLmSv+0+QLXecb151+svCNObtUTuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jcWxei49; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752550793; x=1784086793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zhKngkI310nx9PU9b2zv40h2kHDRfhghd844MS9S4mY=;
  b=jcWxei49bQES8OrkmJLDU1GdkFQ04vnKe2zpf/PsD2M/b+RFRLJTh1LY
   qChAa1+ZhKRl1Pt1IYMjYafSNgUF0ZT/9m/DH2AOD3CpmoXZPLR1d0SoV
   ePs2Srs08fSvBV09EYMRo1n26Z9peVRX8Yeu34gMftfN8gZ4iiUuQLf4V
   JhwhyWZE+ySsn8BqSrRnNrkqPWFWWTnLjCI5xUbgzO9E+2DD4oBQuZA9k
   82QcJ5Flzld2UGctq86Mfg1Sv+BzY7DzDx/Mtsug4sC6wsrro9SYfYK9Y
   pLxLkLZNbs7p+voNnOM/t3jipbZBUIf1rbiQCgBg5hu3VZmAFIBUWbJyn
   A==;
X-CSE-ConnectionGUID: Gk4OjLeyRVWaOZhFh1gXMQ==
X-CSE-MsgGUID: E0LupAEQTWST+2Vp4iSQwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72334909"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72334909"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:39:52 -0700
X-CSE-ConnectionGUID: 7lV0nEFjREiili/VteL1eQ==
X-CSE-MsgGUID: BpnnbOhaSRKnTfEwSDjg4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="180808082"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2025 20:39:49 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	ackerleytng@google.com,
	seanjc@google.com
Cc: Fuad Tabba <tabba@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	ira.weiny@intel.com,
	michael.roth@amd.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [POC PATCH 0/5] QEMU: Enable in-place conversion and hugetlb gmem
Date: Tue, 15 Jul 2025 11:31:36 +0800
Message-ID: <20250715033141.517457-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
References: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is the POC to enable in-place conversion and hugetlb support of
gmem (guest memfd) in QEMU. It can work with 1G gmem support series[1] and
TDX hugepage support series[2] to run TDX guest with hugepage. I don't
have SNP environment and don't know how it goes with SNP.

It is just the POC and we share it to show how QEMU work with gmem ABI.

The POC uses the simple implementation that switches to use in-place
conversion and hugetlb when it is supported and it doesn't introduce new
interface in QEMU so that existing command line to boot TDX can work without
any change.

Please go to each patch (specifically patch 3/4/5) to discuss the ABI
usage, potential issue, and maybe the upstreamable design.

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/
[2] https://lore.kernel.org/all/20250424030033.32635-1-yan.y.zhao@intel.com/

Xiaoyao Li (4):
  update-linux-headers: Add guestmem.h
  headers: Fetch gmem updates
  memory/guest_memfd: Enable hugetlb support
  [HACK] memory: Don't enable in-place conversion for internal
    MemoryRegion with gmem

Yan Zhao (1):
  memory/guest_memfd: Enable in-place conversion when available

 accel/kvm/kvm-all.c             | 82 ++++++++++++++++++++++++---------
 accel/stubs/kvm-stub.c          |  2 +
 include/system/kvm.h            |  2 +
 include/system/memory.h         |  5 ++
 include/system/ramblock.h       |  1 +
 linux-headers/linux/guestmem.h  | 29 ++++++++++++
 linux-headers/linux/kvm.h       | 18 ++++++++
 scripts/update-linux-headers.sh |  2 +-
 system/memory.c                 |  9 +++-
 system/physmem.c                | 40 ++++++++++++++--
 10 files changed, 163 insertions(+), 27 deletions(-)
 create mode 100644 linux-headers/linux/guestmem.h

-- 
2.43.0


