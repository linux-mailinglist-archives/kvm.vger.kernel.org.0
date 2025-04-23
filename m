Return-Path: <kvm+bounces-43919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A88A9887E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E50184440B8
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CAF26FA59;
	Wed, 23 Apr 2025 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7HOEVB5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DE9262FFB
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407573; cv=none; b=qT82Ifl1A/7bxW1fkpUxLrkMPdLjm2IWkAqUF3f4NttUVhhRKLh7doXRw3bFeyY8vMfZWpyA8/qvBoG3JaJuJF8DYsC4JM2Hu/hQy89aZHbFd6h6ZHAQmbWw3ZFJnnRJbDc/83JhtTfxSpYx3hW1mqB9+HEapmspe+9X8c1bi6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407573; c=relaxed/simple;
	bh=sWI3DOLRDTWF/zbnA7amIpyitgpG1InAQItEsYRGi6E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=kLSiRf/hG7eazxSC/+oUXryZvXYwKujzPkps13Z2RRvZStliTjIlAG6wGBXex2tlvSmKfMKlUl/Q9HZ83G++Llt4/2+BssNAPXO7bARw5VKnKU8m6ouTG6mceOhcYegjsHDnruY/JooFQtshP8zuPxvaY1gHungCArnvekO7CdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7HOEVB5; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407572; x=1776943572;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sWI3DOLRDTWF/zbnA7amIpyitgpG1InAQItEsYRGi6E=;
  b=k7HOEVB5kHRHU96cVLS3dUg4hHSGo98C90VIot1sUCx0H/BN6Pt6wCkL
   c53BClfB3IK7CF8usaCyJS30EXTetR6QOvsAMCSDwaYODnEb6/YW8k0Z+
   ujpUdp2d3mgm0mYG7YzN+zhEHCpsGPm/JHaM0ggUw2oaOrftNRoifUZ9f
   /NCPn/fwMI5EVvqoZgQIQzN3qp1k4qCo0B0PZmDFjDYG/MgqAJqZORZHk
   4F3TKyLFC8qjqYqpZShTpf8qrGiXmcsaMB3llHvdiVDC41EKLpYrcxwDr
   VR/5hzyjyoD0VNwSID7rb+Mb/QpOs0tr2hyCYKFyzFEz9/ESoW7akDQ8B
   A==;
X-CSE-ConnectionGUID: +/hFHR7MSbKgS234b3sUgg==
X-CSE-MsgGUID: +vkdHDfqQhSh3kNFZn9bag==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825247"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825247"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:11 -0700
X-CSE-ConnectionGUID: 7kic6yL5Ry26K8wLOk1jIg==
X-CSE-MsgGUID: FK6712zITSS+5mtmot+13g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150718"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:07 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model & topo CPUID enhencement
Date: Wed, 23 Apr 2025 19:46:52 +0800
Message-Id: <20250423114702.1529340-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

(Since patches 1 and 2 involve changes to x86 vendors other than Intel,
I have also cc'd friends from AMD and Zhaoxin.)

These are the ones I was going to clean up a long time ago:
 * Fixup CPUID 0x80000005 & 0x80000006 for Intel (and Zhaoxin now).
 * Add cache model for Intel CPUs.
 * Enable 0x1f CPUID leaf for specific Intel CPUs, which already have
   this leaf on host by default.

Overall, the enhancements to the Intel CPU models are still based on
feedback received over time, for a long time...

I'll introduce my changes one by one in the order of importance as I
see it. (The doc update is missing in this version.)


Intel Cache Model
=================

AMD has supports cache model for a long time. And this feature strats
from the Eduardo's idea [1].

Unfortunately, Intel does not support this, and I have received some
feedback (from Tejus on mail list [2] and kvm forum, and from Jason).

Additionally, after clearly defining the cache topology for QEMU's
cache model, outdated cache models can easily raise more questions. For
example, the default legacy cache model's L3 is per die, but SPR's
real L3 is per socket. Users may question how the L3 topology changes
when multiple dies are created (discussed with Daniel on [3]).

So, in this series, I have added cache models for SRF, GNR, and SPR
(because these are the only machines I can find at the moment :-) ).

Note that the cache models are based on the Scalable Performance (SP)
version, and the Xeon Advanced Performance (AP) version may have
different cache sizes. However, SP is sufficient as the default cache
model baseline. In the future, I will consider adding additional
parameters in "smp-cache" to adjust cache sizes to meet different needs.

[1]: https://lore.kernel.org/qemu-devel/20180320175427.GU3417@localhost.localdomain/
[2]: https://lore.kernel.org/qemu-devel/6766AC1F-96D1-41F0-AAEB-CE4158662A51@nutanix.com/
[3]: https://lore.kernel.org/qemu-devel/ZkTrsDdyGRFzVULG@redhat.com/

0x1f CPUID by default (for some CPUs)
=====================================

Once the cache model can be clearly defined, another issue is the
topology.

Currently, the cache topology is actually tied to the CPU topology.
However, in recent Intel CPUs (from cascadelake-AP - 2nd xeon [4]),
CPU topology information is primarily expressed using the 0x1f leaf.

Due to compatibility issues and historical reasons, the Guest's 0x1f
is not unconditionally exposed.

The discrepancy between having 0x1f on the Host but not on the Guest
does indeed cause problems (Manish mentioned in [5]).

Manish and Xiaoyao (for TDX) both attempted to enable 0x1f by default
for Intel CPUs [6] [7], but following Igor's suggestion, it is more
appropriate to enable it by default only for certain CPU models [8]. 

So, as I update the CPU model at this time, I think it's time to revisit
the community's idea (referencing patch 7, where I "took the liberty" to
merge the property-related work pieces from Manish and Xiaoyao, based on
a TDX patch from Xiaoyao [9]).

I enable the 0x1f leaf for SRF, GNR and SPR by default for better
emulation of real silicons.

[4]: https://lore.kernel.org/qemu-devel/ZpoWskY4XE%2F98jss@intel.com/
[5]: https://lore.kernel.org/qemu-devel/PH0PR02MB738410511BF51B12DB09BE6CF6AC2@PH0PR02MB7384.namprd02.prod.outlook.com/
[6]: https://lore.kernel.org/qemu-devel/20240722101859.47408-1-manish.mishra@nutanix.com/
[7]: https://lore.kernel.org/qemu-devel/20240813033145.279307-1-xiaoyao.li@intel.com/
[8]: https://lore.kernel.org/qemu-devel/20240723170321.0ef780c5@imammedo.users.ipa.redhat.com/
[9]: https://lore.kernel.org/qemu-devel/20250401130205.2198253-34-xiaoyao.li@intel.com/


CPUID 0x80000005 & 0x80000006 Fix
=================================

CPUID[0x80000005] is reserved for Intel, and Intel only supports
CPUID[0x80000006].ECX. And becuase AMD requires lines_per_tag to be not
0, which blocks Intel's new cache model.

Therefore, fix these 2 leaves for Intel (and Zhaoxin - which follows
Intel's SDM).

Thanks and Best Regards,
Zhao
---
Manish Mishra (1):
  i386/cpu: Add a "cpuid-0x1f" property

Xiaoyao Li (1):
  i386/cpu: Introduce enable_cpuid_0x1f to force exposing CPUID 0x1f

Zhao Liu (8):
  i386/cpu: Mark CPUID[0x80000005] as reserved for Intel
  i386/cpu: Fix CPUID[0x80000006] for Intel CPU
  i386/cpu: Introduce cache model for SierraForest
  i386/cpu: Introduce cache model for GraniteRapids
  i386/cpu: Introduce cache model for SapphireRapids
  i386/cpu: Enable 0x1f leaf for SierraForest by default
  i386/cpu: Enable 0x1f leaf for GraniteRapids by default
  i386/cpu: Enable 0x1f leaf for SapphireRapids by default

 target/i386/cpu.c     | 346 ++++++++++++++++++++++++++++++++++++++++--
 target/i386/cpu.h     |   9 ++
 target/i386/kvm/kvm.c |   2 +-
 3 files changed, 343 insertions(+), 14 deletions(-)

-- 
2.34.1


