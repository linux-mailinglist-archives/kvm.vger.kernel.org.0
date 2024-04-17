Return-Path: <kvm+bounces-14977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B3C8A8649
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 026EA1C2114D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4391442F6;
	Wed, 17 Apr 2024 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jHhDO2eb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BC1420D3;
	Wed, 17 Apr 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364875; cv=none; b=QL0D/g5Np1sGgMGM6c+ia+s0Bieefn9ivrMKpbYW24f8pcKsei/h+JwG6Q/bGVCXVX3SkCYB/WrK2Aw8E+zp4xoetG6dd7R98WvbRzXs7lSJkUYo7tcwQI5hbkakzohMNTlOIWaYl4z7TXH0yJ7v30hMekG/kphzEaFJdFhB9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364875; c=relaxed/simple;
	bh=MkgtIhHVieQ7WcBMlGREAvGkJY99UfJXwbpRb44RjMg=;
	h=From:To:Cc:Subject:Date:Message-Id; b=BJa3NUd4c0ospwufbCsYLnjKs6zDmVV022mnDFudzuBSnkkqj4ccgbLVMho0wcqTQF5XkWzlDQUWhduknhVHzVpYB5bLjwFaq4HNWPuTNkgUpqE5h56fVblb3RfJ7vxGXwEiyxdgh7e55u7htuWlsQMCzWKibvpfxsZ3xCKEGQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jHhDO2eb; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713364873; x=1744900873;
  h=from:to:cc:subject:date:message-id;
  bh=MkgtIhHVieQ7WcBMlGREAvGkJY99UfJXwbpRb44RjMg=;
  b=jHhDO2ebWjfaPp9AoTvjEzQQ2irS/9QQnszFgocExNw67kxif9CJUSDA
   MUlrAdGMN+Scasr6p6VBsb5Its9Pq+Pr4j9b3b9NetjCqZYyHO48z49IY
   QFiuXSXbkEPAUJsUjVybsowXp877QxiZ/FR8uOh7k74A5Tvy6zt6FIbxH
   +7Hn3Uqk14/ULVdRK1gusryvABED7IhwJU5fSCjQA2qyrzD3M+N5qxiyD
   GHsAOVm1KWtPgoMelhWsPdEHRi1hyEfGX7yVCLxmvHJGDvWKTu/e8edmx
   wM3sxsCEYxvBU6FWhxr8Yf0VjfkxrCz+7P+DCNbfhDp0wrlGRs88QzOGz
   A==;
X-CSE-ConnectionGUID: 6bUpG95ASxykiHV/KzMVHw==
X-CSE-MsgGUID: RyqlVIfqQ0SvPaVXUv4Qmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8720125"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="8720125"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 07:41:13 -0700
X-CSE-ConnectionGUID: 00l+2GDMQWKZ3Vz8pvv4/w==
X-CSE-MsgGUID: C3h4XHyXTdWHG6ETW08QfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22651788"
Received: from qat-server-archercity1.sh.intel.com ([10.67.111.115])
  by orviesa009.jf.intel.com with ESMTP; 17 Apr 2024 07:41:10 -0700
From: Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	qat-linux@intel.com,
	Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH v6 0/1] vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF device
Date: Wed, 17 Apr 2024 22:31:40 +0800
Message-Id: <20240417143141.1909824-1-xin.zeng@intel.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This patch is the last one of set "crypto: qat - enable QAT GEN4 SR-IOV
VF live migration" [1].

The first 1~9 patches of this set introduce the helpers in QAT PF driver
to support the live migration of Intel QAT SR-IOV VF device and have
been merged into Herbert's tree [2].

This one adds a vfio pci extension specific for QAT which intercepts the
vfio device operations for a QAT VF to allow live migration.

Changes in v6 since v5 [1]:
- Introduce more QAT device specific information around migration in the
  commit message and comments in driver (Alex)

[1]: https://lore.kernel.org/kvm/20240306135855.4123535-1-xin.zeng@intel.com/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=f0bbfc391aa7eaa796f09ee40dd1cd78c6c81960

Xin Zeng (1):
  vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices

 MAINTAINERS                   |   8 +
 drivers/vfio/pci/Kconfig      |   2 +
 drivers/vfio/pci/Makefile     |   2 +
 drivers/vfio/pci/qat/Kconfig  |  12 +
 drivers/vfio/pci/qat/Makefile |   3 +
 drivers/vfio/pci/qat/main.c   | 679 ++++++++++++++++++++++++++++++++++
 6 files changed, 706 insertions(+)
 create mode 100644 drivers/vfio/pci/qat/Kconfig
 create mode 100644 drivers/vfio/pci/qat/Makefile
 create mode 100644 drivers/vfio/pci/qat/main.c


base-commit: f0bbfc391aa7eaa796f09ee40dd1cd78c6c81960
-- 
2.18.2


