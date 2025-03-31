Return-Path: <kvm+bounces-42256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97164A76BAC
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 18:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0E3166C3A
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 16:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7048E214810;
	Mon, 31 Mar 2025 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GfJjQs9E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77639213E83;
	Mon, 31 Mar 2025 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437556; cv=fail; b=G1GBHBNUKDodnJZ37UBsgEqwQYfBFZaLoPt2PobkxcW+92f1KRMS/MWx3YhHlPz2aVyUT+QU/6+WItKiUPpPt6bGlKrTMKeU+9Mmhs+ZnBUJ1SrG7LpNueXsd7JBER4SDPi9IHmueW5+rvOXqd69ZV/qfjpr1uo6oertYA7tfDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437556; c=relaxed/simple;
	bh=U22lxNvT38rY+PMZSpbgaY/cWrPpqvrC4GKUza7MxXI=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=LFlI0/j/16GMaaOTTgw4P+GS+fh/ngCcSlqHL7Y9Tnag2Du0MCa11ucmjxafJjlHqV/xyEwRrI6p2kn8ThH6LJYVpeagZL/VHOqxAxBz7VAF5TnYSSx10JtD1nwxq056hNws31v88qXnujle7AbLbAYSl0mhzWq71LGDE/nXn08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GfJjQs9E; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlhahgDfrK4L/W5ne7UxgCgZFqrNgpo/IqMsf3w4Unc8SpiIcWL+087jztZv40pLuHV74E4ez/fhqKA+jPXAzkru80WQfz98xAQopkfBEeKRl0CaEK/gU7sFQHMhvx6EAE4Gq0tAqaOC0rMGRrtUa9Qpj+VcWPIgRjmNObaCdDs9ieVLezfCdx377pQk0BnDOcvvUXj7muCdRhQ11Pl1HSYD2gA65wvd6aILEUzm1AujH48zI2pIoFAvagqAQ3VP2DCR5DF80qbAotuzo56p78iNHs/ly39emDPmE4wMANzTAjl9IZj9SYN2wV3vWzFjJrI64O8KUMfP6KcwTG4cVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VrpHv+ttEnSzvCTxgG9MlNHXKcZ11ydebA+nm3Xi6k=;
 b=VWhKhVGgwxii87ySnl3rr4Gy3RQNlOUnE9OZd7y6ptJp/ojxay7QJNCnGcherAgw1bGZjJRS3yG5jmZIyHzyW9wwPgLVt28V5YMuu5Gslk1Lgw4dx37OUWU+/GcWap5XvonSFjOO8hRFAchNE+KFein7X4DkqWv+wlSMnuwLVj1rNj3QVZo4rgB47b067PZOdAoq+O2g9ziRX6bR0XCz/bADafW5tYe8TwPjs1YIXRZfwt36PZI3h7FpygZwTV6E6ZZmG4Udmq2+Y9+qgB79LigYiEYX2O0Svv/DNDAj+D74znjNPefGp0sFPTwVWUDNUpTP/lrTfNMsN2EGzmVsJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VrpHv+ttEnSzvCTxgG9MlNHXKcZ11ydebA+nm3Xi6k=;
 b=GfJjQs9E8XE8mHqLRtkCtzAliBdSoWNKQVRQfIG6hz4+gVIGgd8fCN2YOXsYLNEujjXFlPhCgtNxa5mlyiBzZmqvItSYdfPmSwqb/qw/4BPNEUiJDfFxoYGj7Ldc4+zwLKysfPJBIcY5LxrnOuqcaIi/vCHcZctrxc7OBlRYOWXRTzj6bqa+JQDwxx5bSkvWvad7dOohOAQPsao0q+Y7LPYFvNwYbX1IVoJ9AxIV+vKyASztGS3ySkSo/KfVFtQEDUDPYuPhSdK1c8FpXr6pqDXJVoip798W8Gow5g/mTYc6UR3KnCvofhhTL0DEB0byYJamCy7OQyrPjyXg/Jnt9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7515.namprd12.prod.outlook.com (2603:10b6:930:93::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Mon, 31 Mar
 2025 16:12:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:12:28 +0000
Date: Mon, 31 Mar 2025 13:12:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20250331161227.GA287780@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+IkPkk61Vpmrs914"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0285.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f45e58-b627-4df1-f7bc-08dd706ed507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yokvL3x2kWugM48HjxAs6U84mGMoboehtdKHARzNk3oMZIKAJBdXDvxVXM/o?=
 =?us-ascii?Q?50+sfk66Ema7NeGVE/BDeOGZSTV4nCF0Ofk6Rb9pC+E0st1LTZa4i6bzEjh3?=
 =?us-ascii?Q?+Z6Opxc1W/PljZEKtETiOAxSTPvJqoKbL9BRx/tP3hN/V3y6VN54q7VDBTuJ?=
 =?us-ascii?Q?GuDpeZD4gBEDttBti76u3oG+M/e3G6CS4/GlioyZUUW1EPurMIeRrNH+fkSL?=
 =?us-ascii?Q?dhydmukahQiev74p+jwZkIUR2NMwKTjSch8GlT0TNYSu0PJqg+cPeAQMNhYY?=
 =?us-ascii?Q?LObmiHSMBXPGQ4Ugl3bD4iC2VUn+oObWU+korIFvgp4IqQ929D5Nxsa0ZVVC?=
 =?us-ascii?Q?8BNtXw4uXEXc+FK9tpTSO8woUKx29w0tvO43GU32kNQnfDNHDgDv3R8PTq1Z?=
 =?us-ascii?Q?oVU1/PhtS5ccDFTF6BP8zQnE4DZ1Qa1pAL/54UM4MjWwI/7qTOD0qEbNMOZ5?=
 =?us-ascii?Q?Hy7TAQigqBzrk9slOz1qS0ehyrZG/b4ptLOT7u/5kXeWfQF2FQlIMvZEAlHe?=
 =?us-ascii?Q?1ZR7AkjwkB4Ngt8PEfDWTS3Bw1FUdKsn3vQQCJufP4UhpLn9ZdCHKtGDRlB0?=
 =?us-ascii?Q?1D8yLv03ABmaVPuDvnldYBQ75sAJ/na2+25t86PMEerjgofeHRdvCaGxNHZn?=
 =?us-ascii?Q?bTCJSjMVD/mgzfPFaHyrDIPb6L+X4fU2RLQQdrhRoexNVmJPYxfoSR1z4WiH?=
 =?us-ascii?Q?7jIDi3w7pu57rZ5K5bjBtptW/XmeATJdqrrWeHyKQmIWWR0tnu04WTBhZU5i?=
 =?us-ascii?Q?u2CLPiXjKioqhSAn5mlnTJvLHAZ/QISdX/AWeGhVyn7tyJkyX6D40K+ah8DV?=
 =?us-ascii?Q?oULh6t6nfZSVJL3XbSA71Op+xH5Mwwmbr0gl4OYsGVqebVcgAfo6HYh5rm6S?=
 =?us-ascii?Q?otyuK8NoXN6wH9m+bVkL5ovRwkXLTppQ2x45MX7/9Ye6kF4+KU8jZo8QIns3?=
 =?us-ascii?Q?6DSbQYN87aLIat5MqFQBzBQ9cla7LgV8LHPp9P7ssQKxPC5ChgzbKC3iOxIB?=
 =?us-ascii?Q?iQzPspP4jylqYO4+wS+2gEdyVtPdmV7a/5KluU7m/yTV19ovKpIFXa8AHBrU?=
 =?us-ascii?Q?9kjGZqRQ1umB9dPtqjrht95Otzqr0GFVivtf0iho2oksXZuDVsqgCvs9bKD7?=
 =?us-ascii?Q?SoG05ZKuRH1bP1F166tA2U570xHNer+g12m9q0el/pNPNPmsXYBR+nAqTHMy?=
 =?us-ascii?Q?aHmRgQGzz6rSbSkEwIoof1cPhm+OHRuxJ7ifuguaacINzAGmZym2iVrH8OF1?=
 =?us-ascii?Q?1OB3dXN0k3+uOrCfrGhEFAxkGiGp2XFtMiQvwCxVGM9RuZB/QHu3rg+t8xAT?=
 =?us-ascii?Q?Yt7bA8VXDQOvr2NZODN171D5OHTBVL2wK9z8EM48Q8T8l8UBB1f9hMKeEvnV?=
 =?us-ascii?Q?XIiuWCgWQNr64t0NBGsY3pYn1SjX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IkBrlI3Q3OtYekw18t3ovCH8NxBVRPC9jviT8TivapieG+gYGGzklyIspPeX?=
 =?us-ascii?Q?IXDFF1AHLn8A6hUUNdYJDanX0PMBAc5jFaFTu4PaOQeHM/tXUodrOdotW2Rj?=
 =?us-ascii?Q?4Iy6V0y4Uxsd4olLRyutcFxssoR1ZaFwUzNgAOGZY1oECxR/9MSLcIumdbkP?=
 =?us-ascii?Q?lSHubznOM5+2kROgtptzoW1F7Jnba0cDOS6M4FH9kVmy0ea3GWVkGOTTjMGk?=
 =?us-ascii?Q?PVuf6NN7FlX0yyg5zDH1t36uyZkOlNcO5smzbEfAnihx7kywM+PPzAl5ooYg?=
 =?us-ascii?Q?JwqOV7Xr8DOVp3+rH0EdTmo+eMSpvd0l+Gl2KwvDE/TYUkHZPw+937Kolwfq?=
 =?us-ascii?Q?wE5X1JFLrg5a8wnTH1XpVYUYyl+ovq+ziEa/o/hqumvBGD+MI+2r8mPu4jTP?=
 =?us-ascii?Q?iq9blomRa8tBYdfhAr6+p8OpuXHHbvSEnAQNpYyaFO/R/CRRXCgXPITUxvAX?=
 =?us-ascii?Q?8atwZLTXhQwfLE/zX5eSYGEL1lQ4KGRVIpQEozYzheEnkuTVOXVCGL1xZPdm?=
 =?us-ascii?Q?McfNrBs0hchewKtnpp7QuSLauNuKvB1wPOL1o71T/QBWBsFj2GapcyIDCpzV?=
 =?us-ascii?Q?D3sHdXYL72krVMinWGPdu/EuPXsqw0xS/TBawkX494glhneOSjkoBE00fY8u?=
 =?us-ascii?Q?mRXndq8FTlLlv+TEsBVKzziJaZ3N6UDOa8X/bbQV0mCGyTUond34wSWZ3tmb?=
 =?us-ascii?Q?WfGtyD9Xde/qBM/PaZAuEDHZINkedK0sglkdZMvCbv0C1asyi0pRWOdccxFI?=
 =?us-ascii?Q?XYGpsyy47NzPt3IfeMQcZ/M5h+t5GEms3FoH4k0f85gdv97OcnuhnVndMj39?=
 =?us-ascii?Q?qSjXHWSjoCR3BLeOUnYUm7Plqojx9YkO1MLPpX5+X2HlOGh9zf7VWX4WJoJN?=
 =?us-ascii?Q?Di8C5FPMYsK03j/aora2NlStKoeokM87caEtdnRbL54ig/1NrGXCcGm4w2gc?=
 =?us-ascii?Q?9Z2r7ltx7Ht8xn6Peijy9toobRmKVex7c//pnZy2aXGq9lBTwrrpVvdrwF7l?=
 =?us-ascii?Q?Rfx0SItQ0LCi3ZzkQyr4lq/AiJkwnyFYmTVDqpcu29TUC26mSbM7p6AC51JU?=
 =?us-ascii?Q?yiBUi8XkxtuFjbwxboxs8m7Z4VCdyZeHNIm+FDS5VmBTFX0PgeaBcEwXGyBC?=
 =?us-ascii?Q?b4BEujOpWC4M1WfU3fAmq9SeT/da8CVu+jmgtZTHI7LZcegmlu5WQhRLD0mo?=
 =?us-ascii?Q?vZjkrJgNQ9h3xU5zXIRuiTjWHSV+5IbiX+AWEngSnxRerElWx2ax4gydnuPY?=
 =?us-ascii?Q?vBXZ1Vk4bA2me2N7+qsGykARJd/k+k7CqSJjkEDzN7cBmOWENxtg3Qm8jjAA?=
 =?us-ascii?Q?JBf+cacs0hu7aaw7GcwlAkz7MLLR5V4Mn/cvHVPNDTC/0S1qMM8hZ0jD2Tl5?=
 =?us-ascii?Q?qFDr1pAzl1/CknDXgQiE63MyTKZ40P9u7C2SNk+v1jhHKv+3XUZzq4nGGvlK?=
 =?us-ascii?Q?xaz/oOzhncEeEPc77roBv84c6FRUkMG0mm7wLgvpoig3S8QC5AzPoabsy7SP?=
 =?us-ascii?Q?MqJRl7KtjCDmrNkBRPpaRJ1oib9c6P6fZ1wXMYv3y0UdaxsZqT5Rcn+BVAK3?=
 =?us-ascii?Q?3cAHmKpWeewSkD0gHgisBwTtX+j0bVRTWwYWjgLR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f45e58-b627-4df1-f7bc-08dd706ed507
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:12:28.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6SskJAZ0KC81rVaYOoyChQM6ADV6Bz55nzSV09UFNBlJy1+0h8ZT7TQJH4pWqZm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7515

--+IkPkk61Vpmrs914
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Late this time due to some travel and a bunch of linux-next issues
last week. I think it is quiet now.

There is a shared branch with Joerg's tree that has already been
merged by you. That branch contained a fix for a long standing issue
with how interrupts on ARM interwork with iommufd, and it should bring
full functionality to ARM systems now too.

Despite the shared branch there was still a merge conflict=20
(take both but drop mutex and sw_msi):

diff --cc drivers/iommu/dma-iommu.c
index 8cc5397d7dfc1a,0832998eca389a..6054d0ab802321
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@@ -54,31 -59,34 +54,30 @@@ struct iommu_dma_options=20
  };
 =20
  struct iommu_dma_cookie {
 -	enum iommu_dma_cookie_type	type;
 +	struct iova_domain iovad;
 +	struct list_head msi_page_list;
 +	/* Flush queue */
  	union {
 -		/* Full allocator for IOMMU_DMA_IOVA_COOKIE */
 -		struct {
 -			struct iova_domain	iovad;
 -			/* Flush queue */
 -			union {
 -				struct iova_fq	*single_fq;
 -				struct iova_fq	__percpu *percpu_fq;
 -			};
 -			/* Number of TLB flushes that have been started */
 -			atomic64_t		fq_flush_start_cnt;
 -			/* Number of TLB flushes that have been finished */
 -			atomic64_t		fq_flush_finish_cnt;
 -			/* Timer to regularily empty the flush queues */
 -			struct timer_list	fq_timer;
 -			/* 1 when timer is active, 0 when not */
 -			atomic_t		fq_timer_on;
 -		};
 -		/* Trivial linear page allocator for IOMMU_DMA_MSI_COOKIE */
 -		dma_addr_t		msi_iova;
 +		struct iova_fq *single_fq;
 +		struct iova_fq __percpu *percpu_fq;
  	};
 -	struct list_head		msi_page_list;
 -
 +	/* Number of TLB flushes that have been started */
 +	atomic64_t fq_flush_start_cnt;
 +	/* Number of TLB flushes that have been finished */
 +	atomic64_t fq_flush_finish_cnt;
 +	/* Timer to regularily empty the flush queues */
 +	struct timer_list fq_timer;
 +	/* 1 when timer is active, 0 when not */
 +	atomic_t fq_timer_on;
  	/* Domain for flush queue callback; NULL if flush queue not in use */
 -	struct iommu_domain		*fq_domain;
 +	struct iommu_domain *fq_domain;
  	/* Options for dma-iommu use */
 -	struct iommu_dma_options	options;
 +	struct iommu_dma_options options;
- 	struct mutex mutex;
 +};
 +
 +struct iommu_dma_msi_cookie {
 +	dma_addr_t msi_iova;
 +	struct list_head msi_page_list;
  };
 =20
  static DEFINE_STATIC_KEY_FALSE(iommu_deferred_attach_enabled);
@@@ -363,19 -393,14 +362,18 @@@ int iommu_dma_init_fq(struct iommu_doma
   */
  int iommu_get_dma_cookie(struct iommu_domain *domain)
  {
 -	if (domain->iova_cookie)
 +	struct iommu_dma_cookie *cookie;
 +
 +	if (domain->cookie_type !=3D IOMMU_COOKIE_NONE)
  		return -EEXIST;
 =20
 -	domain->iova_cookie =3D cookie_alloc(IOMMU_DMA_IOVA_COOKIE);
 -	if (!domain->iova_cookie)
 +	cookie =3D kzalloc(sizeof(*cookie), GFP_KERNEL);
 +	if (!cookie)
  		return -ENOMEM;
 =20
- 	mutex_init(&cookie->mutex);
 -	iommu_domain_set_sw_msi(domain, iommu_dma_sw_msi);
 +	INIT_LIST_HEAD(&cookie->msi_page_list);
 +	domain->cookie_type =3D IOMMU_COOKIE_DMA_IOVA;
 +	domain->iova_cookie =3D cookie;
  	return 0;
  }
 =20

The tag for-linus-iommufd-merged with my merge resolution to your tree is a=
lso available to pull.

The following changes since commit 5e9f822c9c683ae884fa5e71df41d1647b2876c6:

  iommu: Swap the order of setting group->pasid_array and calling attach op=
 of iommu drivers (2025-02-28 10:07:14 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-li=
nus-iommufd

for you to fetch changes up to 7be11d34f660bfa6583f3d6e2032d5dcbff56081:

  iommufd: Test attach before detaching pasid (2025-03-28 11:40:41 -0300)

----------------------------------------------------------------
iommufd 6.15 merge window pull

Two significant new items:

- Allow reporting IOMMU HW events to userspace when the events are clearly
  linked to a device. This is linked to the VIOMMU object and is intended to
  be used by a VMM to forward HW events to the virtual machine as part of
  emulating a vIOMMU. ARM SMMUv3 is the first driver to use this
  mechanism. Like the existing fault events the data is delivered through
  a simple FD returning event records on read().

- PASID support in VFIO. "Process Address Space ID" is a PCI feature that
  allows the device to tag all PCI DMA operations with an ID. The IOMMU
  will then use the ID to select a unique translation for those DMAs. This
  is part of Intel's vIOMMU support as VT-D HW requires the hypervisor to
  manage each PASID entry. The support is generic so any VFIO user could
  attach any translation to a PASID, and the support should work on ARM
  SMMUv3 as well. AMD requires additional driver work.

Some minor updates, along with fixes:

- Prevent using nested parents with fault's, no driver support today

- Put a single "cookie_type" value in the iommu_domain to indicate what
  owns the various opaque owner fields

----------------------------------------------------------------
Bagas Sanjaya (1):
      iommufd: Fix iommu_vevent_header tables markup

Josh Poimboeuf (1):
      iommu: Convert unreachable() to BUG()

Nicolin Chen (18):
      iommufd: Fix uninitialized rc in iommufd_access_rw()
      iommufd: Set domain->iommufd_hwpt in all hwpt->domain allocators
      iommufd/fault: Move two fault functions out of the header
      iommufd/fault: Add an iommufd_fault_init() helper
      iommufd: Abstract an iommufd_eventq from iommufd_fault
      iommufd: Rename fault.c to eventq.c
      iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC
      iommufd/viommu: Add iommufd_viommu_get_vdev_id helper
      iommufd/viommu: Add iommufd_viommu_report_event helper
      iommufd/selftest: Require vdev_id when attaching to a nested domain
      iommufd/selftest: Add IOMMU_TEST_OP_TRIGGER_VEVENT for vEVENTQ covera=
ge
      iommufd/selftest: Add IOMMU_VEVENTQ_ALLOC test coverage
      Documentation: userspace-api: iommufd: Update FAULT and VEVENTQ
      iommu/arm-smmu-v3: Introduce struct arm_smmu_vmaster
      iommu/arm-smmu-v3: Report events that belong to devices attached to v=
IOMMU
      iommu/arm-smmu-v3: Set MEV bit in nested STE for DoS mitigations
      iommufd: Move iommufd_sw_msi and related functions to driver.c
      iommu: Drop sw_msi from iommu_domain

Robin Murphy (1):
      iommu: Sort out domain user data

Yi Liu (28):
      iommufd: Disallow allocating nested parent domain with fault ID
      iommufd: Fail replace if device has not been attached
      iommu: Require passing new handles to APIs supporting handle
      iommu: Introduce a replace API for device pasid
      iommufd: Pass @pasid through the device attach/replace path
      iommufd/device: Only add reserved_iova in non-pasid path
      iommufd/device: Replace idev->igroup with local variable
      iommufd/device: Add helper to detect the first attach of a group
      iommufd/device: Wrap igroup->hwpt and igroup->device_list into attach=
 struct
      iommufd/device: Replace device_list with device_array
      iommufd/device: Add pasid_attach array to track per-PASID attach
      iommufd: Enforce PASID-compatible domain in PASID path
      iommufd: Support pasid attach/replace
      iommufd: Enforce PASID-compatible domain for RID
      iommu/vt-d: Add IOMMU_HWPT_ALLOC_PASID support
      iommufd: Allow allocating PASID-compatible domain
      iommufd/selftest: Add set_dev_pasid in mock iommu
      iommufd/selftest: Add a helper to get test device
      iommufd/selftest: Add test ops to test pasid attach/detach
      iommufd/selftest: Add coverage for iommufd pasid attach/detach
      ida: Add ida_find_first_range()
      vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
      vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
      iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
      iommufd/selftest: Add coverage for reporting max_pasid_log2 via IOMMU=
_HW_INFO
      iommufd: Initialize the flags of vevent in iommufd_viommu_report_even=
t()
      iommufd: Balance veventq->num_events inc/dec
      iommufd: Test attach before detaching pasid

 Documentation/userspace-api/iommufd.rst            |  17 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c    |  60 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  80 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |  36 ++
 drivers/iommu/dma-iommu.c                          | 204 +++----
 drivers/iommu/dma-iommu.h                          |  14 +
 drivers/iommu/intel/iommu.c                        |   3 +-
 drivers/iommu/intel/nested.c                       |   2 +-
 drivers/iommu/iommu-priv.h                         |  16 +
 drivers/iommu/iommu-sva.c                          |   1 +
 drivers/iommu/iommu.c                              | 160 +++++-
 drivers/iommu/iommufd/Kconfig                      |   2 +-
 drivers/iommu/iommufd/Makefile                     |   2 +-
 drivers/iommu/iommufd/device.c                     | 499 ++++++++++-------
 drivers/iommu/iommufd/driver.c                     | 198 +++++++
 drivers/iommu/iommufd/eventq.c                     | 598 +++++++++++++++++=
++++
 drivers/iommu/iommufd/fault.c                      | 342 ------------
 drivers/iommu/iommufd/hw_pagetable.c               |  42 +-
 drivers/iommu/iommufd/iommufd_private.h            | 156 ++++--
 drivers/iommu/iommufd/iommufd_test.h               |  40 ++
 drivers/iommu/iommufd/main.c                       |   7 +
 drivers/iommu/iommufd/selftest.c                   | 297 +++++++++-
 drivers/iommu/iommufd/viommu.c                     |   2 +
 drivers/pci/ats.c                                  |  33 ++
 drivers/vfio/device_cdev.c                         |  60 ++-
 drivers/vfio/iommufd.c                             |  60 ++-
 drivers/vfio/pci/vfio_pci.c                        |   2 +
 include/linux/idr.h                                |  11 +
 include/linux/iommu.h                              |  35 +-
 include/linux/iommufd.h                            |  32 +-
 include/linux/pci-ats.h                            |   3 +
 include/linux/vfio.h                               |  14 +
 include/uapi/linux/iommufd.h                       | 129 ++++-
 include/uapi/linux/vfio.h                          |  29 +-
 lib/idr.c                                          |  67 +++
 lib/test_ida.c                                     |  70 +++
 tools/testing/selftests/iommu/iommufd.c            | 365 +++++++++++++
 tools/testing/selftests/iommu/iommufd_fail_nth.c   |  59 +-
 tools/testing/selftests/iommu/iommufd_utils.h      | 229 +++++++-
 39 files changed, 3147 insertions(+), 829 deletions(-)
(diffstat from tag for-linus-iommufd-merged)

--+IkPkk61Vpmrs914
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZ+q+6QAKCRCFwuHvBreF
YfWJAP4zU5M5y+W/mQAurfIjOGASUMybiCxBBi+dmvJQeKELxgD7BJUzvsJo8iR0
rZv45eAORKf8tIPL8F5WPyNMgS1Oag8=
=D8/J
-----END PGP SIGNATURE-----

--+IkPkk61Vpmrs914--

