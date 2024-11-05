Return-Path: <kvm+bounces-30744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 890979BD0DA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACA871C2277D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29BB13A244;
	Tue,  5 Nov 2024 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e+Sclm8Q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66511126C03
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821365; cv=fail; b=ng+jwthQNwCCElK2qYQZmoAi9QBUHflStoBVbK2pfeTfX2cO4DMljLoYwVvXfml/Axbb5RREjW5IgWdPRqRRi3uVMsO6gwSul6tzVSL0O4MO2DQCNkB8X0Rwb7xK4ttCGY/hEZV2BAIx63Sasnxm7RByywemWcrXObrHtRBhliU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821365; c=relaxed/simple;
	bh=a5iTq4oYp2SOsy8B76EGiACl7wEvSps6gLOtMOd8VTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F7/4/d38e1rEg57jvBPVt8e5IYUBRP4mWThDinBq9D5p8CZtikc//36r18yo/MuWXO3l0Kg+DU08R+YM2kJ7y3o2Pq271Hbq+vZq6YbVfk5RO0oVQSxyvvlbEDGMKL6xIWGDxuG9aucvTf+HoBvcpBaXA2AJ+idwgXDN5RpkcnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e+Sclm8Q; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BbNxF3vDy4J39oYGHCpjOWQd9IF5I5B523egx4cbvTtHXI5enk4whRpJqz4xVoYRSdTiMwt9y4ynBF9IeNkFS32FySQIVqhv9iZdILnqdHDr4w3ox2zJJqz/NWdfjlJFeokU+AHZveAo1bfyMpZzPY4y8tFgj3tLGCtf2fxbGzus7pI6eZVbF+03xkAITtIhSpTwt/oMKipv7RFEaqXk2y1n1k4jeDFYTKSMUpD5jCnC11B6Ta7DmVH9DAVwZKC5MbyU7OnbSBjKPrS52ryuQ4UbINBxXsw2EO5kD56J26G2Uhjx4sG1o5KgUEEQvmt4vesSswbBSJHkygVEWKeJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnjaHpoOADZzQcwK3J50ejH/quqYsfOrNyACrkAjO2w=;
 b=K9bjWO9X5X927zr+pQ1hYX0U6tKbiMO2EIj7kIwIbc5Isj4YFBDOYQhQki4Q/qcLm1mlKM4Yd8XU7V2mTW5qWU9cfF+ktURjmViYFWDiS1rp3/FtwWMPkWLB/E7SRw+o1Xaoxz0jI4XKazlxHuWM0aDrQ7PFYUn2VocVHKRTR4+JvVgjdBnLkXFGXmZYCuzZrt72WDl6VNh0UAYEokZvmIl398LyFrUlON2FL6VSB9KOOtJnwo3WOVuJkD1geM5BM6euNoZFklh7ulhDYEWWQ73UfDbXvGtb4vCOjTn2JMMtSceb4SWjsTilqYoBXFiykhOR+BT1ZQ2Nqb7zW8YLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnjaHpoOADZzQcwK3J50ejH/quqYsfOrNyACrkAjO2w=;
 b=e+Sclm8QshKZAM3m/CgpTEU9FFI2GwAXUBu7DTA2087aFOEwKN0wqcaF3akzdTALrSwiSlG8HXrn516YlDZEMipCBtqIM6uCnjamTpSac9aJdDO4uxkwuUhxn4F8wAeUKPeCT1TBOsWUyCcHqcKlv+f8GuLtZZq+NfLzJubp15U3aR+5MASanvcZPCNWq8jpOZsgPEiuwUQgzVmwJZLl8uAqCYeQnP0GJ/IygIemiqOLH8gg0cGtWgefMtXR6Bklc7tjxhUtQg8MtiBUVJknpEfdNS5f9LpCbp6xaCoMQZ/KN949rOI6bpz5aIGcfu3IDPbb7mPnug0v3CTmBKEXng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Tue, 5 Nov
 2024 15:42:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:42:40 +0000
Date: Tue, 5 Nov 2024 11:42:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v3 2/7] iommu: Consolidate the ops->remove_dev_pasid
 usage into a helper
Message-ID: <20241105154239.GG458827@nvidia.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132033.14027-3-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:208:23c::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: bc69b692-ef47-4f99-cbf2-08dcfdb07b62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?25ziJbGb6Kj2v7H8zTOlL+vvwyd9V/zWOaBW3o6pupO2JntJFYrVmvJFHwbR?=
 =?us-ascii?Q?rpuy9qwBAMluAPK9lEEFAKBUXdtrDbYuV7v1lq3y3ZqRPGQ79qpdEC5zSiSk?=
 =?us-ascii?Q?apQ80zKQp3ocjCdr3WDROI74PGeK/ATORMM8GeOO5vtswiIteksGMMSBfgqK?=
 =?us-ascii?Q?4fWNWDvypKAZDuRFOilM7cia0IBRHPrxq3ACnIM48K6yLBQkRsw/Z9wO1gCf?=
 =?us-ascii?Q?Q5INHxETu9YySw/b72DMYhm/qE4Mw4bDDziyoYDYWG99XKJ2FXRMild2tlNo?=
 =?us-ascii?Q?K3DFg3lDyEb+0oHGWyK8Hz7yWMhSkVUdutuX1hfyfIiFYVDzCCmNxy2nLlrj?=
 =?us-ascii?Q?zvoeIZZkAkSctZEkccYhDpDh356yN0QmTf+j/7nG2mA9fxWM5KKVDNghdJla?=
 =?us-ascii?Q?zxDEfPhG5ddSh6PIsltITG1KrXSCwqCizRIK9UHbN+jaRqlokrwyMolFcnLo?=
 =?us-ascii?Q?4IPrCGYGzFnWPkvfev2EEJ29XG4a7hkme87wNoibhhId+M1Qrn36pFD1rcYA?=
 =?us-ascii?Q?lPIjWQvtRG+T8IpwM7DMZOPGmyj8VwTWSmjtzXliZY9cZU81ZAqI4fcF9x2M?=
 =?us-ascii?Q?2yxv9lIudlwnSh6KPzz4mQWssexi4lklr7rnkLHHUvG1yQSd17w8vu4/8zIX?=
 =?us-ascii?Q?+lTXT2k93iZ7yez4FV1wbBLzDeCwYfT2FVl2nFvngJlNaYcdiObfmHpqjplb?=
 =?us-ascii?Q?NL8qo7YeDBYgPGo4ab4TjhN2aKWDotYsB36w2F+12yKnwYse82+ob+e0Q9eM?=
 =?us-ascii?Q?clgsAF23KXc9EGAE7lOtlPHaOwpUzLAQ7ccDmnEmTbALHiiuFwWtHNyc+G17?=
 =?us-ascii?Q?XLefNtMiW+mSqTXii9ghvYUZ2jejJSGYhMij8qC1VErF/UWQkYh4HtHQQdz5?=
 =?us-ascii?Q?qe4OsDbqCI14oKFjJx556HLlvGq9EaKIxAxRs+lVD/g4JAWnrYjdW8sbiKxd?=
 =?us-ascii?Q?hopdLqVOOYQJDPgjsFgtMYCA6A4cGsKMH23SLzVBe4tHU6xtD0lMyd7yblod?=
 =?us-ascii?Q?mzL6n6W+Sr5eZWTLWC2fOkZzYbVLg5zjDrFcZUfR80M0mZl+Rfm8xRoNYhQl?=
 =?us-ascii?Q?0fDLUBmsmTYbuF1/sSY+r7B/Umnl98yBI0fPTAIO42VHhaY37VF7S0db1moj?=
 =?us-ascii?Q?YAwxo9T/MyFopAosgOgxe35eLNanqygOTzAkMPxou0AL/RC3F8XCBF+tPQQ0?=
 =?us-ascii?Q?VOIMmlJWnDTWlYEWcJOPgKFDKqctnZ+NCzzTF4ByBDuzJmbqi+d8nQJiDa+h?=
 =?us-ascii?Q?DHAGANPY792JMiAURjPcxvYQwHqYVgeOaJ2w0tC8U+m2HfLK/m75/vLh5kPa?=
 =?us-ascii?Q?qdILSzrQ4T4+estYRFNutIF+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ssUf9Iwn/buRkzNf+UeFH0/lo4xSaOuzxRb322Fdq2YvRPrlLZPnNk53yPux?=
 =?us-ascii?Q?ysyKlSU8EaqIuj1HrNEY0OFwewgmnSnVMfrzkojVOf4nwXjQqHZpLuD4KlLE?=
 =?us-ascii?Q?n54LbkNn56w5vOU7eil2h3Azq+IgsvvPfHd1f2PmJp4Vg9XedDbRHzQjn4pz?=
 =?us-ascii?Q?elj0Y6TRse5lXYs8xwN3YQn9m2Uk6PHRVYDiqvySN7jgaKJL6QJk0wizFiAX?=
 =?us-ascii?Q?1sF6EDhOKdixTlfxVu7o7MSISpngkRhnB9/Y65CnTtV0XbUEWLmEoSTDWREP?=
 =?us-ascii?Q?NQ9U0lLa8hezMw4U9ZEFJpMR1DQ/UACmw0lQ/gLvx5d+8VvHUl+0sWF7KfZ0?=
 =?us-ascii?Q?leW9L/YZW0UBw7OyDe1NFQ9pUa/knZN/vX/K1fCAa03SQ1ohWz5wr72WZ2iZ?=
 =?us-ascii?Q?9y1Xw4XTlr9vhOX9liYlWA28F5wOGivuhPZ8nSs3yKE1N6R1R/lyTniVV+jq?=
 =?us-ascii?Q?faOr+OQTiLT+qGocPwGZAtPziRgPDlON2w85+nAK/B4+TXPxpSWJLL8uCiFV?=
 =?us-ascii?Q?UtoNK3B51dr74xu+TgDX91gY9Uaj2uQ4USG6c4hi2XKHgBIGZiTxZtFsDwjS?=
 =?us-ascii?Q?vDJcrWJ+dCFvy6zfOADuqWBAnBw+TnsugC0Hw0V/bTGFJha/viezRTDy16Y3?=
 =?us-ascii?Q?hwXEuCuOtCitfEF/Og7Jx+ca+9JCk2IJT7mUxu0dOvOLRDM84OQTltpYLmdG?=
 =?us-ascii?Q?t0/dDtvblMl1hvvLLdPWpy9Gu2/DT3BJZJl9aShWxfnrZs5qDm/OJ9LObCx7?=
 =?us-ascii?Q?IoxKF7uAmPuP0iGxSJeK/ekvPMY7KapAJ1VgoHBGfM77rxKM8gTD+BK3z31r?=
 =?us-ascii?Q?8omyDZkodqu3XPtSHhVbucxq22LfzEmPZmFd24O4udSILdj0PKHMpTa5WXSz?=
 =?us-ascii?Q?BDHq8h5zPonLCayGAocsdYYkqpcXr9mjW52TVgqJi9t6waPbVZosmF3vSkPo?=
 =?us-ascii?Q?40cgFa+EXUakKe/n+AXWK5X1dlujZYrtFLuYP9TBF34R5POb+G8YBE0NoS0X?=
 =?us-ascii?Q?8wMMwKJrfKAR84YcsvHf7XBtfq4CZn0tXbfSSsRGCSP4RWfgZwdCr+1/PTJf?=
 =?us-ascii?Q?q+jlW867xoHnvVnZjsQY5haKaE1Jmzu8g8t3aX3Tm3gYDkjngpuNa/5X/Zbn?=
 =?us-ascii?Q?X4+v4I+mrdqpBTGnEUTWHvbqOgTOMQYTIlyik8R01Bf6a/HeEfGV3rQ69wRo?=
 =?us-ascii?Q?8rmAmkBzy1tBy2Vg5blYzOCqZGrXv5T8WUdNdVYc8Jq44VZeSf0GuSTi5+Nn?=
 =?us-ascii?Q?joMJtqivR6TX7zroJe7eN96L2DbxiBzu/ceC4ayby260zMviJGZZdbKjVOFQ?=
 =?us-ascii?Q?M4YWPgXoTz6F4x7QVkn6hw9Ux7KrKkkOgThzzYJG+iXa3swgwl7/HywJX24X?=
 =?us-ascii?Q?bTwIjZYpZXLTyrzejYrjuSn6XplPuSD8JVqWSbIcaWJYyOyqRDX6+2pySvTr?=
 =?us-ascii?Q?KxeOoiEx6a8Bv+5wJ234sZ130WHsSfCQMuTYJLV9IknV36VoXpCpEsmg4x0F?=
 =?us-ascii?Q?lSAsDKy4dnB7ZS6mk6wXFzw0Wu1ayAhorJXWeys8/GX3U7m5RNkBM4B8fpvN?=
 =?us-ascii?Q?agbv/4VZAgMdZE1KebdbCryDu6yLHW4A/a12JPPk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc69b692-ef47-4f99-cbf2-08dcfdb07b62
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:42:40.7513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1274KEjgblwWeccPNdF5CNRwZC3wMZ3nF2f6BOyXe9B+2e+Cs21/y0ODMA/mjJI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

On Mon, Nov 04, 2024 at 05:20:28AM -0800, Yi Liu wrote:
> Add a wrapper for the ops->remove_dev_pasid, this consolidates the iommu_ops
> fetching and callback invoking. It is also a preparation for starting the
> transition from using remove_dev_pasid op to detach pasid to the way using
> blocked_domain to detach pasid.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommu.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

