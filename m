Return-Path: <kvm+bounces-16690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 255808BC9A9
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D58D9282A51
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46301422A5;
	Mon,  6 May 2024 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CeYjE1mM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217041419A0
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984668; cv=none; b=gGLNJZt3hHPE+4P2xyJ1bGH0kEK8/8XYBctZC6A5aMqZz49Lb9Qz0sAqeF9VLh0svfb8YBhnAZquxybpH84xE3ZKV/usQN2Ox9daGz743dBji4Z83V4Nqa2VufVQ1YphiCV8e6w9p5w3mhAcwhyj3xwnh7STwfzksHgBAYN8Us8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984668; c=relaxed/simple;
	bh=t16zbWmXufIghAtbC59BZnfuKimAEZlNbjdKAMlDDag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RSlpFzEHpVjFXUedl0ec16iWhq601gu96piqoPgnPhgD+r6F7eIiu3k91P6YYz8MWhIdgyugyBX1Wnn62DaOTvf7jpQxDLk5+GgJmhl1Gz2xGmmPHVZimJytVa0AkKMmWCYT/fa81iUT5fvnrP/dkXl3+kvNXTSf71QYPA3eYA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CeYjE1mM; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984666; x=1746520666;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t16zbWmXufIghAtbC59BZnfuKimAEZlNbjdKAMlDDag=;
  b=CeYjE1mMBXtEf9Z3OGlH2vQRGj250Isd7nAcBG/14FDDtnKmyY2ek+YN
   1NXYoHPTSr2bX/XgH0CFKJCC/kLavRDSF1G74WNAjHbNoI1bHSlnuqU7z
   /eGHZ4QQcmsRUB1ESHZ3AJA7J0G2KOvhmzvpnJ0yKRLMIk3AxTeV9hjRi
   oFEtJef9dhB4ssrldKzyEf07S+4WLmQ2tqw+OmQThvema5yOuEFdbMRGQ
   2DTud+VKV0UkUceNd4Gx4PkgoAayXInv6JQXrNkGMo8l+X1i179QhIU9o
   hISK2lCVRtj8K5faIjMOl8186OWe1AXJp4q1e0n2BLmsdjurBsD0PSuq+
   g==;
X-CSE-ConnectionGUID: g+VOO8s9TvyVwlKo5aoenA==
X-CSE-MsgGUID: XlxEDa7VQka95w3VAJbPfA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14533313"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14533313"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:37:46 -0700
X-CSE-ConnectionGUID: yv9lfA5xRjetFiZhiWpslw==
X-CSE-MsgGUID: mcQArTPlQFCiDrXfvOBQiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28186713"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 06 May 2024 01:37:43 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and outdated comments
Date: Mon,  6 May 2024 16:51:47 +0800
Message-Id: <20240506085153.2834841-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is my v2 cleanup series. Compared with v1 [1], only tags (R/b, S/b)
updates, and a typo fix, no code change.

This series picks cleanup from my previous kvmclock [2] (as other
renaming attempts were temporarily put on hold).

In addition, this series also include the cleanup on a historically
workaround and recent comment of coco interface [3].

Avoiding the fragmentation of these misc cleanups, I consolidated them
all in one series and was able to tackle them in one go!

[1]: https://lore.kernel.org/qemu-devel/20240426100716.2111688-1-zhao1.liu@intel.com/
[2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
[3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/

Thanks and Best Regards,
Zhao
---
Zhao Liu (6):
  target/i386/kvm: Add feature bit definitions for KVM CPUID
  target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
    MSR_KVM_SYSTEM_TIME definitions
  target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
  target/i386/kvm: Save/load MSRs of kvmclock2
    (KVM_FEATURE_CLOCKSOURCE2)
  target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
  target/i386/confidential-guest: Fix comment of
    x86_confidential_guest_kvm_type()

 hw/i386/kvm/clock.c              |  5 +--
 target/i386/confidential-guest.h |  2 +-
 target/i386/cpu.h                | 25 +++++++++++++
 target/i386/kvm/kvm.c            | 63 +++++++++++++++++++-------------
 4 files changed, 66 insertions(+), 29 deletions(-)

-- 
2.34.1


