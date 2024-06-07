Return-Path: <kvm+bounces-19090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F394900C4A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 21:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 867D01F2373C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CCC149C77;
	Fri,  7 Jun 2024 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="NJQjNmWN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3445145341;
	Fri,  7 Jun 2024 19:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717787437; cv=none; b=FYKI+c3+++EFXpt1nntZuM/5L672MP+kmLWp9FD213uvsVlni4uAj63Xb8+wdWwzlNXKTei5vqzMyT20Zz/4z5zEwY7eLWhNoOLFG4vQVPU9U5rMeepWuk9b1iasOlRjt89HKJZI1EW0UwJrYIdftnwPMRnWdq/CZuhir8P50xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717787437; c=relaxed/simple;
	bh=4gRlKUjq8k6c1Z0/5HTOi/bl9NbiMEPawfQngjxA2nk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dw1AG2k5bbMG+f/jA2E8z4oC2vZareVW9OdEYdksNB8UCdzT0AvFKFlHiV/U8XM4lmm4OzWSXUSUbmnTKTa0OnTkMVYT6USrnQgtfzj/ySUXQXKvDh9bIohIOMNScIeRrVagDd77DzvxdqhivmzS5TC7fDDMMq27H2Aw/jbN4V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=NJQjNmWN; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717787436; x=1749323436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ZBxe52q1PnRY4oylN1pOYY5Do7Ms0IbtGTwXgGpYqI=;
  b=NJQjNmWNPraNXcV4B1SqH06Nnd1NRtbTDvJEsodu5zDSzbPTKayLIKSh
   sayzcdDnk73i0dFmUoipZ33Atxgi9jAqe4svVNEP844qvzawpg0XYQ+SH
   3OHGmiMRhdOU7s88tDPvIigGVI2crYckK7OTq/1EP5kkI5qJi+ugalYYY
   k=;
X-IronPort-AV: E=Sophos;i="6.08,221,1712620800"; 
   d="scan'208";a="300741761"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 19:10:32 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:7355]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.34.168:2525] with esmtp (Farcaster)
 id 35028c6b-1325-40e2-8b96-4afae449ecd2; Fri, 7 Jun 2024 19:10:30 +0000 (UTC)
X-Farcaster-Flow-ID: 35028c6b-1325-40e2-8b96-4afae449ecd2
Received: from EX19D007EUB003.ant.amazon.com (10.252.51.43) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 7 Jun 2024 19:10:30 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D007EUB003.ant.amazon.com (10.252.51.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 7 Jun 2024 19:10:29 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Fri, 7 Jun 2024 19:10:25 +0000
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
Subject: [PATCH v4 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
Date: Fri, 7 Jun 2024 19:09:48 +0000
Message-ID: <20240607190955.15376-2-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240607190955.15376-1-fgriffo@amazon.co.uk>
References: <20240607190955.15376-1-fgriffo@amazon.co.uk>
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
also inline and checks the arm64_mismatched_32bit_el0 static key. We
thus need to export this symbol as well.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406060731.L3NSR1Hy-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202406070659.pYu6zNrx-lkp@intel.com/

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 kernel/cgroup/cpuset.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 56583677c1f2..007fddb07039 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -127,6 +127,7 @@ static bool __read_mostly allow_mismatched_32bit_el0;
  * seen at least one CPU capable of 32-bit EL0.
  */
 DEFINE_STATIC_KEY_FALSE(arm64_mismatched_32bit_el0);
+EXPORT_SYMBOL_GPL(arm64_mismatched_32bit_el0);
 
 /*
  * Mask of CPUs supporting 32-bit EL0.
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


