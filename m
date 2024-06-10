Return-Path: <kvm+bounces-19185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF70690222D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 14:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19AF3B21CE5
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0331781ABB;
	Mon, 10 Jun 2024 12:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="oOjI+l6J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E33A80C1D;
	Mon, 10 Jun 2024 12:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718024277; cv=none; b=f946q/jqJOpUG9XkAMAjMwc05mfl13S+bJ2COjmf/LzzX77kx8i2fvv3k8MW8OZj6iZA10FqBwaw4PZFJch5gBBBWWzA+i9K2Q7o8H5BG+Iq5ALbWvUqO5P4jKwnextgTqzpF5rYEw7EK6GEskW2gqVNuEgM4qjadCv5ue4YDeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718024277; c=relaxed/simple;
	bh=d71z35+QWzMp5JV4v5Cq6bXAf8H95u1CvuP601c3fmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwLn2Wrtzbk8TpUYbLWPGfk5x6y7fcvtGwVLzLd3+zn/ySEtIEhV+NzErB1YTxRayoXZEnRtlFQGZ6QvUXq1Iz/B+I2WVjdhwD5yaOQs2DG5gt1J646gtjcGGcGOHijuXjIGiN9VZak3QnYqjukBvQDNPT1sAfV7i0oxx8fR0HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=oOjI+l6J; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1718024276; x=1749560276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R+t5kuH61I6DmDTD2guJKH5i6i3EwO5ldYL3sCW0Zow=;
  b=oOjI+l6Jj/Q2iauad+oerkdrcQlVKko1L7R9CiCVnuB6FZ1zI8UeLIpp
   DSzhb/Mw2ZpRuR7ygo2i4rwy3lCQGQbbm00rhVxXhE7nP6Z2mIHBUq8Wa
   7QhKAeK9uttjg+ryChMHxwS4/dTOf+bVPfmmkoIo7TYE4MogN0ZLj0krA
   I=;
X-IronPort-AV: E=Sophos;i="6.08,227,1712620800"; 
   d="scan'208";a="3967899"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 12:57:52 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:61759]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.119:2525] with esmtp (Farcaster)
 id ccd1910a-3428-451d-be34-03c6fb9f1573; Mon, 10 Jun 2024 12:57:51 +0000 (UTC)
X-Farcaster-Flow-ID: ccd1910a-3428-451d-be34-03c6fb9f1573
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 10 Jun 2024 12:57:40 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 10 Jun 2024 12:57:40 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Mon, 10 Jun 2024 12:57:36 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <griffoul@gmail.com>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, kernel test robot <lkp@intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>, Waiman Long
	<longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo
	<tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Mark Rutland
	<mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>, Ard Biesheuvel
	<ardb@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian
	<kevin.tian@intel.com>, Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, Christian Brauner <brauner@kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Reinette Chatre <reinette.chatre@intel.com>, Ye Bin
	<yebin10@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<cgroups@vger.kernel.org>
Subject: [PATCH v5 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
Date: Mon, 10 Jun 2024 12:57:07 +0000
Message-ID: <20240610125713.86750-2-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240610125713.86750-1-fgriffo@amazon.co.uk>
References: <20240610125713.86750-1-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

A subsequent patch calls cpuset_cpus_allowed() in the vfio driver pci
code. Export the symbol to be able to build the vfio driver as a kernel
module.

This is not enough, however: when CONFIG_CPUSETS is _not_ defined
cpuset_cpus_allowed() is an inline function returning
task_cpu_possible_mask(). For the arm64 architecture this function is
also inline: it checks the arm64_mismatched_32bit_el0 static key and
calls system_32bit_el0_cpumask(). We need to export those symbols as
well.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406060731.L3NSR1Hy-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202406070659.pYu6zNrx-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202406101154.iaDyTRwZ-lkp@intel.com/

---
 arch/arm64/kernel/cpufeature.c | 2 ++
 kernel/cgroup/cpuset.c         | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 56583677c1f2..2f1de6343bee 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -127,6 +127,7 @@ static bool __read_mostly allow_mismatched_32bit_el0;
  * seen at least one CPU capable of 32-bit EL0.
  */
 DEFINE_STATIC_KEY_FALSE(arm64_mismatched_32bit_el0);
+EXPORT_SYMBOL_GPL(arm64_mismatched_32bit_el0);

 /*
  * Mask of CPUs supporting 32-bit EL0.
@@ -1614,6 +1615,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)

 	return cpu_possible_mask;
 }
+EXPORT_SYMBOL_GPL(system_32bit_el0_cpumask);

 static int __init parse_32bit_el0_param(char *str)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4237c8748715..9fd56222aa4b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4764,6 +4764,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	rcu_read_unlock();
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
+EXPORT_SYMBOL_GPL(cpuset_cpus_allowed);

 /**
  * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
--
2.40.1


