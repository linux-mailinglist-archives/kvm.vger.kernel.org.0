Return-Path: <kvm+bounces-13072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A79891678
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A37441C21CA4
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0FB524D3;
	Fri, 29 Mar 2024 10:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tp1ioRzP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17E4524A6
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711706771; cv=none; b=gmvWiqnwVS/00HeuJQV6yMG7KMMpeyPlcipSkob5xDXqP6hLCVbYA/Ngv88OhK0k3aEe75hxPtZnLAL7Vxq1gdcSnMFobheTM+sPa4zI86OF3hrNCreO84Uy1nrtdYdQMf0OfPBJghSpLviKoLydJ1P0nsJlP2yiwjuv3CTTvcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711706771; c=relaxed/simple;
	bh=USSSIVCjPSbOtnv4n93fr+Nx0gEISVP5OpWqSlGRleE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FLDKy+q1btW9200S4m5uTdPBwMnOtP2esPEVSSvbjZzMCv/ymGODU+Mq37ncROF83Q+I7kF6fM5Akn8Dwu+bnwpnjaiI6lTBHKoCGWvzjYraXfHleipxqW60Or30pANlNsyMweN1jLjkWALy/ip1jCkF2YNHqnFCE+dVJTuRX78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tp1ioRzP; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711706768; x=1743242768;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=USSSIVCjPSbOtnv4n93fr+Nx0gEISVP5OpWqSlGRleE=;
  b=Tp1ioRzP2v9n8TE9+2+95LiUyIqpRpEpnGn3o2a96IzTsmQON6hJ7JdV
   Pnuce8s3joMEuAbRVyfaXp8ySH7YaCQFDdtIK1k60h9H739v5hnbeTq5b
   skK31maE6fEAIfuJYeS+NRVLeYfZUOdeXdFjDhUeJ7W/PDPNc5y5T9pz0
   8N63Y9IPv2QyVs9Cxb6Hxf2ktWVu9MBQHE+KzP0AJKkV/NJKvwKHQIUoT
   7WfZPmAWbDGhyOG7Zb1M+jgNfLIzSpnxzmDewKa5gRyPKmx5HpJX8kgRi
   EMDOA2HgF9wHLB+SW9IHIEvQQpfEhIGwyn7k8xTxH69/Q5qyZzRvxYItE
   g==;
X-CSE-ConnectionGUID: nEYF5xBvRACgZgnuhozO2A==
X-CSE-MsgGUID: 4FbqTx79SwyOinYcNVb/vQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17519171"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17519171"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 03:06:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="21441940"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 29 Mar 2024 03:06:04 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock feature name
Date: Fri, 29 Mar 2024 18:19:47 +0800
Message-Id: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Hi list,

This series is based on Paolo's guest_phys_bits patchset [1].

Currently, the old and new kvmclocks have the same feature name
"kvmclock" in FeatureWordInfo[FEAT_KVM].

When I tried to dig into the history of this unusual naming and fix it,
I realized that Tim was already trying to rename it, so I picked up his
renaming patch [2] (with a new commit message and other minor changes).

13 years age, the same name was introduced in [3], and its main purpose
is to make it easy for users to enable/disable 2 kvmclocks. Then, in
2012, Don tried to rename the new kvmclock, but the follow-up did not
address Igor and Eduardo's comments about compatibility.

Tim [2], not long ago, and I just now, were both puzzled by the naming
one after the other.

So, this series is to push for renaming the new kvmclock feature to
"kvmclock2" and adding compatibility support for older machines (PC 9.0
and older).

Finally, let's put an end to decades of doubt about this name.


Next Step
=========

This series just separates the two kvmclocks from the naming, and in
subsequent patches I plan to stop setting kvmclock(old kcmclock) by
default as long as KVM supports kvmclock2 (new kvmclock).

Also, try to deprecate the old kvmclock in KVM side.

[1]: https://lore.kernel.org/qemu-devel/20240325141422.1380087-1-pbonzini@redhat.com/
[2]: https://lore.kernel.org/qemu-devel/20230908124534.25027-4-twiederh@redhat.com/
[3]: https://lore.kernel.org/qemu-devel/1300401727-5235-3-git-send-email-glommer@redhat.com/
[4]: https://lore.kernel.org/qemu-devel/1348171412-23669-3-git-send-email-Don@CloudSwitch.com/

Thanks and Best Regards,
Zhao

---
Tim Wiederhake (1):
  target/i386: Fix duplicated kvmclock name in FEAT_KVM

Zhao Liu (6):
  target/i386/kvm: Add feature bit definitions for KVM CPUID
  target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
    MSR_KVM_SYSTEM_TIME definitions
  target/i386/kvm: Only Save/load kvmclock MSRs when kvmclock enabled
  target/i386/kvm: Save/load MSRs of new kvmclock
    (KVM_FEATURE_CLOCKSOURCE2)
  target/i386/kvm: Add legacy_kvmclock cpu property
  target/i386/kvm: Update comment in kvm_cpu_realizefn()

 hw/i386/kvm/clock.c       |  5 ++--
 hw/i386/pc.c              |  1 +
 target/i386/cpu.c         |  3 +-
 target/i386/cpu.h         | 32 +++++++++++++++++++++
 target/i386/kvm/kvm-cpu.c | 25 ++++++++++++++++-
 target/i386/kvm/kvm.c     | 59 +++++++++++++++++++++++++--------------
 6 files changed, 99 insertions(+), 26 deletions(-)

-- 
2.34.1


