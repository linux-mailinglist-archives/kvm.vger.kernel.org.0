Return-Path: <kvm+bounces-19016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0938E8FF06B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 17:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EB001C26275
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 15:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164011990B5;
	Thu,  6 Jun 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="wDKEeDBf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B39196D86;
	Thu,  6 Jun 2024 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717686676; cv=none; b=bbvncjvTd8gh4usQ2ioppkVPFebJCYfEh4p0irfKuT1DitId7PHauW3K4C/KvO7hR+S27zxcjcBw3s27Orn7V47LsJhBArMziVczRIzU+F5hEcnKMjpZ9YPAIEoQw0bwoVxKBOnOowutiyrvuoC/2CFpdAUB7+P6ousJOvi9zvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717686676; c=relaxed/simple;
	bh=v817bIMc8LCngm5aUfnkq+5jwelHGj9o1rf31AuUP60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=stbuSZeJ/V57mhPsNpmyjXXU+iyx2u+1rmU396nrvIYOkm3bJ4kwrF/R/gr1vE2P1mwl42IA41Y4nlRAwHjouEmjWtUf2+7vVFDlUSsLjjhStw5Nss+oI1ZiIM/9xJCC/59Et1wBOKPMO8iLaIlT3sLkXuZg+ORj9wloYDQq2ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=wDKEeDBf; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1717686676; x=1749222676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3G9qxMT86kDpYdUxpd7pF8ELFUehp62qjuTlc4JGLIg=;
  b=wDKEeDBf+ryyHi8AHnTZNjO4KWO3hqZGtkdhv3lNiYJSCdL29WEkdiAf
   6uJh+sqYc8jXvwOkMf1v3yu56Z/Zke+oyaPUvqwGNGzLqSzT5pnKzmXaw
   tiRm/7g5GFHcN4vj6lPwCvw3CrnByUdWE/Yn4OaGWi8rf2sjsiRVvbdcq
   o=;
X-IronPort-AV: E=Sophos;i="6.08,219,1712620800"; 
   d="scan'208";a="637767875"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 15:11:13 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:62920]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.31.105:2525] with esmtp (Farcaster)
 id 990c7da9-484b-4967-885f-b3d91f08d027; Thu, 6 Jun 2024 15:11:11 +0000 (UTC)
X-Farcaster-Flow-ID: 990c7da9-484b-4967-885f-b3d91f08d027
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Jun 2024 15:11:11 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 6 Jun 2024 15:11:11 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com
 (10.13.244.152) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34 via Frontend Transport; Thu, 6 Jun 2024 15:11:08 +0000
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <griffoul@gmail.com>
CC: Fred Griffoul <fgriffo@amazon.co.uk>, kernel test robot <lkp@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, Waiman Long
	<longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo
	<tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian
	<kevin.tian@intel.com>, Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, Christian Brauner <brauner@kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Reinette Chatre <reinette.chatre@intel.com>, Ye Bin
	<yebin10@huawei.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cgroups@vger.kernel.org>
Subject: [PATCH v3 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
Date: Thu, 6 Jun 2024 15:10:12 +0000
Message-ID: <20240606151017.41623-2-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240606151017.41623-1-fgriffo@amazon.co.uk>
References: <20240606151017.41623-1-fgriffo@amazon.co.uk>
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

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406060731.L3NSR1Hy-lkp@intel.com/
---
 kernel/cgroup/cpuset.c | 1 +
 1 file changed, 1 insertion(+)

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


