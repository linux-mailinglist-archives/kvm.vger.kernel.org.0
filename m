Return-Path: <kvm+bounces-21797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C6A93444B
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DA6E1F2249F
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED1E1188CA4;
	Wed, 17 Jul 2024 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r4omNZO3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E845036AEC;
	Wed, 17 Jul 2024 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253309; cv=fail; b=uiSq0wM7TmYpCtYYL8zru1/2RkuX44A6frAKYGTowIckp3BoD3ebDceUZ9byLHD80bP6YVIJ5JXLhyW48EIgtw+9BPnUvchI09YAmr8L2+jjK5elJN30cNBBU6TxjPN8mhiu/r76OE3AIt18ok02opUJdx2uVRPxxqyoAyNVU8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253309; c=relaxed/simple;
	bh=FfFna8eG/XeXhqmI2mgn5RZC6lzfNsPRBc/brxe6Pxc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVqiRp/yKQrPzp/Iccs06YblOVewZjMb0pYxaRb1pS61tFUyu6mTpI+tZmVhBumHEFyEoTbRxGiO6FSAk1YNLFJcAr98lNJIS2JOTZki9SZm79H0PGQNqQP7OiUaTLyG1EGUnKJszREcmqTUdEGFdrOkUITW53BduCcV8qQR9+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r4omNZO3; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q+81BkH+aYk0dMQ4Kx1kfFkM3+4DDfU4mx9HeL2YVRHiMw8RSBVeWzRv9RZKjrFHMe+iFVohtJyfc52322B4euU2yFgcGTXD/HU7NRNm500ICRXYzJ3plwJClsLWzCs1kxlEPBd7xVTZL6Jeq+XaviaVDvPqMkINuBgUwQo/ROsGL0t0iuPdvnkdpOZGKQXKhdOBz10E6rPEfa9VqJbtEV6msoDmW06l2WNYIv6+hPTruIZHqjt7YSPESOPo4eoohxoE392cMdH/LqfIf4Na7nTjK1T7Zc8THbRVk01PAzxLHCIUEylpx0kHbINRnGT0Pgd0cJ4OtOD/KvohQL2cmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqlP/wPHX1Ghyq2YzAuN+azqt5xOifb0Dp2Atz17NV0=;
 b=l+SO6hlPKYRD8Z2aeqYGgCLW72eDXkithK5QMHRaU7eiPCQshb2mC2teV9p6jz7U8Xj5dgpiKKdCyHVpG8rPWha9+pSbDEmHn8b4Q8zkb+UNfjEenMIYmgy8hrs2sC3wEBI0Z7lepwNvjlYERFqV/gfRVRXWJz6rj1M1npHENl1vRbyKONWqeBA8OzfRNjuhRNM60Gf0az31q2eWspJRW0ELOFloIMFQOzIr2h1TrNsXTQA0Lcf9rIezXFMtwGvafELOVP/OR+FLEdo8dvWP1xKXmBA6Ko+t5WyexekvSUA4dQVRJ01RrB6MlTrzJg+yEfoI+dWQch66j26vIy0giQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqlP/wPHX1Ghyq2YzAuN+azqt5xOifb0Dp2Atz17NV0=;
 b=r4omNZO31qlNcPOOZX63YL5n6AI+TEYR+tJM6s0KS9K/Ea08lk+5HyMg6Qcj100aYs33K97Vqy6Hh5JDfX4FTaur6PI/d6FivBM1PCEaEXlobwuoR2LLP6xDyktmqwJ5Jjedi61wgGeMbTOq3eGrbo4MWPqTEsxHdmyy6yU/TLs=
Received: from CH2PR12CA0023.namprd12.prod.outlook.com (2603:10b6:610:57::33)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Wed, 17 Jul
 2024 21:55:00 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:57:cafe::3f) by CH2PR12CA0023.outlook.office365.com
 (2603:10b6:610:57::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Wed, 17 Jul 2024 21:55:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 21:55:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 16:54:59 -0500
Date: Wed, 17 Jul 2024 16:53:35 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Message-ID: <20240717215335.spgo572mhpfqcq64@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-10-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: ae83944e-57f7-43f6-301f-08dca6ab1b03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZuOpXdUIlNZUaGt+9um8rJg1/iO+lG2RkHVhxvG5+Ktvtbhlk98zyOf/zXFZ?=
 =?us-ascii?Q?LkkXbQ8VywVcZ9p32PRymDCuzIYADvExVWEe9Dc5A/Fv4vl0pFsjg1QbKBPI?=
 =?us-ascii?Q?76oL5qqWk67mKk9oywTwxnVRw2cM1h6DvXXvJeWNvL6tLxFx2QFSzW9Oj2ud?=
 =?us-ascii?Q?56Br3oTLZHIcnxIbCcmFrM9HYk1U7rMSz141zchlpfFXn+nK0k4OoCXXnUMd?=
 =?us-ascii?Q?GdTthtA+lcvFihi6HlnsPWPfaVwjtvAoJa2PHNo8IxGjhtUV+oGcXH1PirdG?=
 =?us-ascii?Q?9ty8Ow8FvBwaD1891Bu0VXQhk/3Pa3KEj8GC822Ml98H+uiIlZmoBCmUuOPb?=
 =?us-ascii?Q?glSfLpRd4cdsVJnAf8P8hAkE9HcwNjB36TeOPXyBCTugdVsa370pv7o/GCPp?=
 =?us-ascii?Q?PR4G12+YDvQQXcdF67VKBIdJK0rrlOYJ60BBqS6eDkvWuEOrrh6B46a7UwaZ?=
 =?us-ascii?Q?CrqIVGU6hXoTgFajL7x9haqoAZqr75fn46RpKQFAva4MsN5o/e+sMTFdWpWG?=
 =?us-ascii?Q?1o3sto+GzuUIA29UcLJ/uQWlgEd1f0DLyZKg3mHOON5j1jwp8tmk8J+H+19V?=
 =?us-ascii?Q?fAnfsou/Qaa/AAJ3S+eGQAsOkAMcjcvPYptxEKYtZTp0qWF87ScMrOxIVCVG?=
 =?us-ascii?Q?IGe7kYKK55Ytn8B1/QhUifLQnk8SVj2FFefS0G4RLgw3BG7KwXqeQ3A09ppo?=
 =?us-ascii?Q?Ms6r5DUkVLkA7jlLhkJUPgTNDmVwLyQUBwmYCTPShcdS439p/6C40S61FWQi?=
 =?us-ascii?Q?hSFypI27zl3ed/Ys8U7tqtV3k+6YGfr5RZmF4vQ0g7wzRjsnoCHBgo/aOVvv?=
 =?us-ascii?Q?bFwtmUOV0fLFVkI4JLFa6InSpfPH8fJmLxUvfWTTUKKCmMt0hP1iqZ/8zmah?=
 =?us-ascii?Q?wwFR9BlQN6eqKSzTlbrUFTxrz6UAsMhVel16XjGqLgcFL66Gqhd8xut/Hp91?=
 =?us-ascii?Q?lsBs83ZVOU6ATsE+HkSAOmLu0nzR3GA15mh+//MCBhVoIS2rq0E15AB2ATYi?=
 =?us-ascii?Q?9f4G+oK1S4cwfxVUdkU8Su+9PA/yFFkl5qyfogUb4LkfPJ7pyrYjO0r39se1?=
 =?us-ascii?Q?bzPbn+KW+3pKUFNXfV+/G7HUl2fvc7HWBOXj+VSLKah3QOFzQZSYKmse9imd?=
 =?us-ascii?Q?O81ug+7/TkgvJ9wFuRMXeztEwU995OTFjPhONawY4qoRoe4waC2mrngVhQ36?=
 =?us-ascii?Q?zctlP1vnw9ykYVnwtD3nxl6Dj4+bK98soZaLv8cpIGMonsVgX3eYQMv4oJvv?=
 =?us-ascii?Q?nBigILpShS5PJMSvc30yPsyszz6Q8E5myBgD5G2iJkG9gdFQKJUSIj3+0nUJ?=
 =?us-ascii?Q?2naPk7G0TkDMCt/0H/NQrNPr+bvQkjipASJiYaV4swhRYxBY2fs2rmzYFCC2?=
 =?us-ascii?Q?XZIGRl80xyI2xlTtgb6TLE6rCILE3zVxmpXiEr0HP9IlxKby++s/jN2ukWM5?=
 =?us-ascii?Q?16SheDwq4rfZSJMws4gEbHK0BWay1W4F?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 21:55:00.1642
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae83944e-57f7-43f6-301f-08dca6ab1b03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323

On Thu, Jul 11, 2024 at 06:27:52PM -0400, Paolo Bonzini wrote:
> Do not allow populating the same page twice with startup data.  In the
> case of SEV-SNP, for example, the firmware does not allow it anyway,
> since the launch-update operation is only possible on pages that are
> still shared in the RMP.
> 
> Even if it worked, kvm_gmem_populate()'s callback is meant to have side
> effects such as updating launch measurements, and updating the same
> page twice is unlikely to have the desired results.
> 
> Races between calls to the ioctl are not possible because kvm_gmem_populate()
> holds slots_lock and the VM should not be running.  But again, even if
> this worked on other confidential computing technology, it doesn't matter
> to guest_memfd.c whether this is an intentional attempt to do something
> fishy, or missing synchronization in userspace, or even something
> intentional.  One of the racers wins, and the page is initialized by

I think one of those "intentional"s was meant to be an "unintentional".

> either kvm_gmem_prepare_folio() or kvm_gmem_populate().
> 
> Anyway, out of paranoia, adjust sev_gmem_post_populate() anyway to use
> the same errno that kvm_gmem_populate() is using.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Assuming based on the discussion here that there will be some logic added
to enforce that KVM_PRE_FAULT_MEMORY can only happen after finalization, I
think the new checks make sense.

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  virt/kvm/guest_memfd.c | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index df8818759698..397ef9e70182 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2213,7 +2213,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  		if (ret || assigned) {
>  			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
>  				 __func__, gfn, ret, assigned);
> -			ret = -EINVAL;
> +			ret = ret ? -EINVAL : -EEXIST;
>  			goto err;
>  		}
>  
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 509360eefea5..266810bb91c9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -650,6 +650,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> +		if (folio_test_uptodate(folio)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			ret = -EEXIST;
> +			break;
> +		}
> +
>  		folio_unlock(folio);
>  		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
>  		    (npages - i) < (1 << max_order))
> -- 
> 2.43.0
> 
> 
> 

