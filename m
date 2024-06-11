Return-Path: <kvm+bounces-19346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8DE9042A8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 19:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54157283B7A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B0559162;
	Tue, 11 Jun 2024 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="NORoAM53"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E5A502A9;
	Tue, 11 Jun 2024 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718127935; cv=none; b=VgO4be7ceo+2094YU/oVtDsc0rZVSYMymKnLCrsS/5aqEcZ34eBP5mwt/YjipBeKVAi8daTaX7DyVRCSnELYuN92Pm+Bjfl6g7Wcqf0IecUqWaq8LL0wEbyiwb+fzI0xrwhK068g0FJULiX+V+65vcskrQdfyJst/+fNbDaAK44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718127935; c=relaxed/simple;
	bh=zTaBAcIgu8FzEpJSI1r+QourCEvxKKmgr6F8JlwIUR0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYVspONKak8GJbEdGS5ALDu2FBZrnqwU+TalHuOoCq0HZUj/dXZGohBW5cfDkeTOthsU8b3VQvdAv0/BPJp4oKjmjYos4DduO0BoXT8/enn/94ACPcISRF2Y7xAob7WG67Nw6UfBN8OrVqYsP37AoAUQDw6GYEFL9nt6Ym7dIZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=NORoAM53; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1718127930; x=1749663930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GKre/lXeLq2FkbVhYcoGJbiGx0tXQ6v9fNnBOIMJeLw=;
  b=NORoAM53ue9g4Hl1e4uAFcXinqGhm6NEyN8BQdmDfJqu7hv0Ih0IfSEU
   nPmNAVO/k5qrsMAnBiUM4up3bGJoTCZdJYD23OTFokUbfBWbnh/bejIoZ
   7JS1lasJoFWs6KmoksxzF+SSbcDyaARIu3CTnGLcxJf2od3IV/DsBfIpK
   8=;
X-IronPort-AV: E=Sophos;i="6.08,230,1712620800"; 
   d="scan'208";a="425558126"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:45:22 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:42655]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.31.105:2525] with esmtp (Farcaster)
 id bb066631-9c9a-4482-b062-2f22bedf3b3d; Tue, 11 Jun 2024 17:45:21 +0000 (UTC)
X-Farcaster-Flow-ID: bb066631-9c9a-4482-b062-2f22bedf3b3d
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 11 Jun 2024 17:45:21 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 11 Jun 2024 17:45:21 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Tue, 11 Jun 2024 17:45:16 +0000
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
Subject: [PATCH v6 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
Date: Tue, 11 Jun 2024 17:44:24 +0000
Message-ID: <20240611174430.90787-2-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240611174430.90787-1-fgriffo@amazon.co.uk>
References: <20240611174430.90787-1-fgriffo@amazon.co.uk>
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


