Return-Path: <kvm+bounces-34120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EBD09F76FC
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 976941893AE7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8710E217650;
	Thu, 19 Dec 2024 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bWaNKqID"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C2C1FAC26
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596057; cv=none; b=ZWbZymoR5syZACuJU2GjwTVFk/at38H23B+G3ajdwz+scblY1nsJawq+8wR8b2ZDDG6n+gGbrNd/4jZSCgKqj7u1Pj8tlT3aB3rTXfRSeirQGD0I2FdY1ROxducBq695uS8JxvE9PHz4KicunXwbJwzlP3XU85bnVyjKIwoStNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596057; c=relaxed/simple;
	bh=sJD1HzK00lYZY9+cHhZD1q8bcprwUdJTGT1EY0BZmJw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ANPiViuj76k8lQhcUHP6TPELiCx9ad9f1ujpNE/cJV/aoh6kZIq7UVjNbKAZbaJLv9JQtijxokd8EqYIFBIzfzUGcJkVbEv3oX0vV8bQnmqzaAYbGwAdShAtBXzceFDNIEhl/DnwqYaABmWnIPQkkCsgVrTLcqCPyz4uA5k2QLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bWaNKqID; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734596056; x=1766132056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sJD1HzK00lYZY9+cHhZD1q8bcprwUdJTGT1EY0BZmJw=;
  b=bWaNKqIDH2xOitGuW3inef5k7BLUieyen2ZSAzUCxxGJb2UJ7Vxmq3W0
   9zLXjnaUk7yfyTdtCBTo21yxtueZmXs+ke14CWmkQCzMID4/+VqLq0TJ8
   0zNZRYuqmi+Dzhw86xlPQyra18TMrOGUrQJaskepzt9fZUsQLN3UTom9O
   O1ejw1HI6uPNCEhVpzos34Z/LDg9jNp18oJi786f3IQn/SLst1D3nAvfv
   Qe6y0j+BcqoGp5wD/RYbkBamekWjO5OI8o0EUSGnTShhCX50Txy60ps8S
   l9ujzQQ1jnU01VQCehK+CsVxc+879KltQ8VGsKXO22u7Hw+t6pO9covE7
   g==;
X-CSE-ConnectionGUID: H1zwdVaxRbe5zgtzyz5Mag==
X-CSE-MsgGUID: 7yT6xDIWSl65Fs/hUB5g0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="34378600"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="34378600"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 00:14:15 -0800
X-CSE-ConnectionGUID: EOAUv0rrQ8ifIgUQ8s7VTg==
X-CSE-MsgGUID: 6ckPH2LHT8mTQwa3lrXScw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129097513"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 19 Dec 2024 00:14:11 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 0/4] i386: Support SMP Cache Topology
Date: Thu, 19 Dec 2024 16:32:33 +0800
Message-Id: <20241219083237.265419-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is my v6. since Phili has already merged the general smp cache
part, v6 just includes the remaining i386-specific changes to support
SMP cache topology for PC machine (currently all patches have got
Reviewed-by from previous review).

Compared with v5 [1], there's no change and just series just picks
the unmerged patches and rebases on the master branch (based on the
commit 8032c78e556c "Merge tag 'firmware-20241216-pull-request' of
https://gitlab.com/kraxel/qemu into staging").

The patch 4 ("i386/cpu: add has_caches flag to check smp_cache"), which
introduced a has_caches flag, is also ARM side wanted.

Though now this series targets to i386, to help review, I still include
the previous introduction about smp cache topology feature.


Background
==========

The x86 and ARM (RISCV) need to allow user to configure cache properties
(current only topology):
 * For x86, the default cache topology model (of max/host CPU) does not
   always match the Host's real physical cache topology. Performance can
   increase when the configured virtual topology is closer to the
   physical topology than a default topology would be.
 * For ARM, QEMU can't get the cache topology information from the CPU
   registers, then user configuration is necessary. Additionally, the
   cache information is also needed for MPAM emulation (for TCG) to
   build the right PPTT. (Originally from Jonathan)


About smp-cache
===============

The API design has been discussed heavily in [3].

Now, smp-cache is implemented as a array integrated in -machine. Though
-machine currently can't support JSON format, this is the one of the
directions of future.

An example is as follows:

smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die

"cache" specifies the cache that the properties will be applied on. This
field is the combination of cache level and cache type. Now it supports
"l1d" (L1 data cache), "l1i" (L1 instruction cache), "l2" (L2 unified
cache) and "l3" (L3 unified cache).

"topology" field accepts CPU topology levels including "thread", "core",
"module", "cluster", "die", "socket", "book", "drawer" and a special
value "default".

The "default" is introduced to make it easier for libvirt to set a
default parameter value without having to care about the specific
machine (because currently there is no proper way for machine to
expose supported topology levels and caches).

If "default" is set, then the cache topology will follow the
architecture's default cache topology model. If other CPU topology level
is set, the cache will be shared at corresponding CPU topology level.


[1]: Patch v5: https://lore.kernel.org/qemu-devel/20241101083331.340178-1-zhao1.liu@intel.com/
[2]: ARM smp-cache: https://lore.kernel.org/qemu-devel/20241010111822.345-1-alireza.sanaee@huawei.com/
[3]: API disscussion: https://lore.kernel.org/qemu-devel/8734ndj33j.fsf@pond.sub.org/

Thanks and Best Regards,
Zhao
---
Alireza Sanaee (1):
  i386/cpu: add has_caches flag to check smp_cache configuration

Zhao Liu (3):
  i386/cpu: Support thread and module level cache topology
  i386/cpu: Update cache topology with machine's configuration
  i386/pc: Support cache topology in -machine for PC machine

 hw/core/machine-smp.c |  2 ++
 hw/i386/pc.c          |  4 +++
 include/hw/boards.h   |  3 ++
 qemu-options.hx       | 31 +++++++++++++++++-
 target/i386/cpu.c     | 76 ++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 111 insertions(+), 5 deletions(-)

-- 
2.34.1


