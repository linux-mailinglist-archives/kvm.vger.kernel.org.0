Return-Path: <kvm+bounces-31696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9114A9C66CF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 02:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D487B2BB29
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386CC4CB5B;
	Wed, 13 Nov 2024 01:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PFv45fDW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D707B3A8D2
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 01:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461874; cv=fail; b=QUmqz35/QYNjhanZh5Eh1BP2gBTifgUcanMLTuBPLkixX/EX4bT4ZgFLY5KHMLldthrP01gLBoGQhlGfRWp4fsFCKkk4B5+R/ob1Lc92FG0PmlZo8MpPdfpkOA1rKxuHL5nPQxM3uSSbXrSMBkX2T5ytFki7w5iWMx51AEzqEow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461874; c=relaxed/simple;
	bh=YYaNbDQYQDCf8M2RO7GxmD66UuyELnzcq2PEVS6tiYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VpvAqyJP0erHZB5Ka4qclh44+RgDQ6x44qjuWHKdiBhHu7d4IFW1qAO7FK+/gqxe/bZQgs3vU2u4KnmrDwyMsTXT/fY3NTZ24I0nNolBcbjXbKNYgd2qrugpRc0cwV8eNpul3v+s4CxccOQfBXt47DWaPNNwLzavIV0Dkj+T5Os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PFv45fDW; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uO+4A5Pwm80zlhedNhNNBbDC0IxoacMFWZ4DF3T4KMXh4tJA64NL1FIcAwTM1jxWv8wyWYhA5iS5ROj4qxrLY9ce+VaJHgoRDsvWCif7ekN9vkW9yJSewMhaljUfFUHPyZW32sTHkuAyX3NwdG4rGqUhaDsP2X7QSO3RBq4MrR2nBCdIim3Y//qwl+t+CoDEIx3f14oj/DLxq1VzmVJk1AOzeZChEuKmJqC8+8wf0hwOFT2q0B4dn3LR6TPAS3q5cjUDrtS1ynKjeE2ivgXy6GIj9hdd+g6Rh8C/bFtltj8FHDkzoY5nTY7EIrpSHoFacHUpdZb9LX90C1QFUvlCDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYaNbDQYQDCf8M2RO7GxmD66UuyELnzcq2PEVS6tiYc=;
 b=Fa75AxoyBWHaKbYzP76VqryfBq+xbFBK2gRRDFkWRZ7d1bFjL6m82EdCDEjEYcbrjIxtpQcZXDZNcfu8lYHWW2/g9A+WIeXqMsoiBb/Sfki5gpnLGRUL/O7TCAAehAHdHUPKOLomRagzDOvLjTRePWfXFLetMaMMyLdBwc3w4IHmOByC6rr+bp0fF5hBIGrhz2B2KMDbTfxBruEjJz/F1rB2BxRc3wN9GYf+ON1uRC56GUimRwVvUZA2/uIt68oQPW4LCeB+Eza2MbOCB+uwqfNNAwZpV+XyRhfmHx8vHmVLly9jJcgjajxV8uHqU8aQQWcdArpVmOgfoConMOruow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYaNbDQYQDCf8M2RO7GxmD66UuyELnzcq2PEVS6tiYc=;
 b=PFv45fDWI26k+oZUcu7ogQZ8RgSt7RvExTW0j9xzPQU1ivO8oOxhcm91YJE+neTWqd8MgEzR/ZzNNTiKF9TV7mi1cgCClpjQHsjYMweQ6IUsAw93fJBcS9YWGLwN0pcdi8hljPGpS8ke9mjBKXoltD0/dXrywifOl+S1/dE+JCCvVHLqaiZe4FRflgN+7Uyk+Gewdsidq1Fo/IlUA7hKN+NI2gIe9f7vVBjmyK4Fks0tdA1rSLaKX/5M0jiSbRKjAZEtz/+JXUawEl38ONZfSCZzyBoRXd0GsbCcLVc2zaG6YsqFbBeZSCvA3TFpRzIus8pWB+UBn6i4W+V2CuA0Pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6630.namprd12.prod.outlook.com (2603:10b6:8:d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 01:37:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 01:37:49 +0000
Date: Tue, 12 Nov 2024 21:37:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 00/12] iommufd support pasid attach/replace
Message-ID: <20241113013748.GD35230@nvidia.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132513.15890-1-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:208:120::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6630:EE_
X-MS-Office365-Filtering-Correlation-Id: 008b512a-f833-4025-a6ed-08dd0383c893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NrYZBhiAo4NszjB3xMkeWYuI4Gcavo//tSr2uaF15Heb2hLbNhvXCNs6ht5L?=
 =?us-ascii?Q?H+NBf3M8bJn3SHIjYIza1CkxIONGKrj/5wgNcy42UfelqTUjdIoK6Ge/9xo/?=
 =?us-ascii?Q?UGcDF0CtvtAT8E8NhmxVpNsO0SWbcX1fsuRwfQN5SWdmvlcMq0sYh/JkUxVQ?=
 =?us-ascii?Q?LCb3aVoJDU8GE3fblK1+Y2t/wWeB5iomef9jJVv8eO7KyWfH05GEoD17JlRU?=
 =?us-ascii?Q?jRBXl1q3Mw8TyObl2P8NFvNlAwTe8ASDZGfOphjK0lfr5fK3+DrV/2lyr2Jr?=
 =?us-ascii?Q?IbmiqxxmwsUIaTwCsv8jfY3Y7DirgyV9K2dA29ibaRaSUGJU/21va89PFEOJ?=
 =?us-ascii?Q?iKzv3/oxKJkKosC+NDbWJbh225MgutlFdXRkJlKEGV4UWSUtE2APbh2+Gdom?=
 =?us-ascii?Q?RuQebdRX8bEQhujREU7W2BvWZTqqza550/07w9zkcpJwV+EiN9xSNFRVeZpa?=
 =?us-ascii?Q?qrFMPnwmbFn+Z68i0v2SRGZLybHPvzWhAXQt3Yz+I/ZXRr+OQwCMrmbQ1+vU?=
 =?us-ascii?Q?bABMqX0j/yeE1UmZZsny+SJL9C/tm3VMQMalPGaDgJlYC2AeuCaJE3uZoeII?=
 =?us-ascii?Q?I7EAqraxkqDov/SgU7KDs5a8K7sxmpNq44zacrIMVzx/hPJD5xIiSbOZvpOC?=
 =?us-ascii?Q?OcNmz7ybCn2/r2icgFTOHtDdiEgjbVvhK+L4FPIF+0i6EcDC35N14tsb8TKD?=
 =?us-ascii?Q?dlgKFzP2v5ouuyOJgC2mta9D/wYf/IyYKmHQG/3NNnCVLAgylv1JVUqHAW51?=
 =?us-ascii?Q?MvY2fkIdlprdRPF0D93tXk9qSbmuY6R1FOrAVNX4aTWOOgujvJJBwosSrRIM?=
 =?us-ascii?Q?YnLO6NG/5GQe1irdNHhhHPE44fPnfBFyU1kFAtFJePDKShaPMkZwtsnJForw?=
 =?us-ascii?Q?OuOblYm9khN4sg8jGXiw/v2G3LxATqeMWDHJE/Unf02xIt8AgawD2cRzIul2?=
 =?us-ascii?Q?IaoJnsb8nuuKaPT6OyTweb4FNUdxi5/Pyr8QN4kNgVaAQWVSVPPTEJMQSEgk?=
 =?us-ascii?Q?VB/Cew5tUIf6tS9dp1gjqLrojqrW9JJwy0wQ8S9Vd6AtrDxyBXEle4OsPVc1?=
 =?us-ascii?Q?C3BCpGq6lLxsqezJagz6aiXP4Id4YL3+3WBASM+Y0U2PlEpbrw7rbR6xW6G5?=
 =?us-ascii?Q?XL1aIbicRIDv9ZQTos3XXFx9z4po0GBqQR+uegaJ9uxLsYiiQbyQCZtZZ81r?=
 =?us-ascii?Q?awjoROTLi0RAE07JhC3PdGsxQhKhrVHWHexB0F3jjJiEgM/QsvK+4QLYZA1O?=
 =?us-ascii?Q?Z1U07SslFkj/2O9xWjsTW8vYMYsLisLtpNq4C2tl0i0k4WcI5aZMaIc53rH2?=
 =?us-ascii?Q?bwhsARpQChqKAhaVc/S8/lsR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8ppPwd53Gyr2p10n/6n8YSZ4PG93urJhqKeNBL5EouV/DE3iaH9ugA1Bera7?=
 =?us-ascii?Q?WLoRb4qaJ1K9YYyfHS2V6j3friHW3Tvf3hI/O6vuAZTyBAa1o/qoSmP5w1Ox?=
 =?us-ascii?Q?j1aQidJ+w2QeOg6YS5PLRjXLlW8xaN6vRnA57hESPpZQx95AnaHEVs/Qf911?=
 =?us-ascii?Q?HtC/b9kehADXJlbFz2FMTdjo+KSsLgaepmy35W2arn1APH54O1UCi6rBMCiO?=
 =?us-ascii?Q?ks3GPUr19MB7fuXAgjnSgxeCKNzd2qUeAPIbQ3H4GzC6hKgsfBTgGnSXN4qm?=
 =?us-ascii?Q?DBaLImB1Q8qfKdFfEu4lgRDYoYkk6Ib6QH8FwjlUlfPzox4G7wi67+DNW2Aj?=
 =?us-ascii?Q?JVsnwKHokg6rZhTHmbQl+M5vd489RnUg3jAqk6V7eFqLRADhd5YKELHFzirg?=
 =?us-ascii?Q?FJuYDeaRGNCgNBqEkfvk/yRhUiN6A8ZAhjthYiFusSw5bBfio202l62JlhJP?=
 =?us-ascii?Q?Ctz2hWh7/j6o2f4YzDZ4yoMxXI73CUL3MClfCn4jQWbgJxJBU7UD8trt+ghT?=
 =?us-ascii?Q?YTWQs8WJOoDOh9GMG6CIvBjnyCwFqOA+Xz/kU6SgEEvm++So8VaUafWsySeQ?=
 =?us-ascii?Q?b6rBDMP0ZldNjko1WlUEg1bceelSpB4/+DV0cSF3jQ/4JmIKVdBk+M14+wK0?=
 =?us-ascii?Q?iofDkMZmcQE0FAalc63YEFlqCBjEOx9xoJwsPQPTH1jxq6Kwhk/MNAIn4iVC?=
 =?us-ascii?Q?RoLt1WYi6XrLn73q/X2Hm/6j7nbrq5meGxek6MwYXVCHgTeRKZedPczA0EVV?=
 =?us-ascii?Q?+iGKNpZvnWUTbQ3Y+Alb+w7KfTCPFKKRXuhSulSZSh+r3UDF+0kQ1iI6B//V?=
 =?us-ascii?Q?rVvjpaENwFQuwysHfJ82Srub2U/yg1yfjhC06BQlAp3Y4GRyN5xR0fEBH5Ph?=
 =?us-ascii?Q?ELho6loGO9iDG5JEjxY3K1DAtrDdN0A1QtU8g9S6rXYbG5Rluui2ayvMZxQG?=
 =?us-ascii?Q?6axVSDyle0yYKs5BI3NjQmIjNTmyL1K/vofUbJUhvQqiB10Oj8/yBn6PvTMt?=
 =?us-ascii?Q?1Z5s0eoo/RGkusADsO1qF5MxPEwBmD4fYch2BEvBuFUS0V3a7mn/qHqPAvHv?=
 =?us-ascii?Q?kzXlYf1XyiXIEQfiYTjkks/Tzp8AsWfTpmbUgTGz1g2EUhlW8i2QYNQdczXU?=
 =?us-ascii?Q?AJbGPXJ4B+xj5haLn/RpTExVghgb6lfodTZKjbvIPhBe3VrYh/6IFgUnwK0V?=
 =?us-ascii?Q?y1iREtlvAQp1kmGaBVFwe1QDwdo4Pfr9Bz098vhI+lXoXicwveOqDCRyPX9c?=
 =?us-ascii?Q?IMpcME441JwqMzwSpjRqwURGRilcCbRJQ7O0915TAt6avcyUOTyxvhYGMyfV?=
 =?us-ascii?Q?P4SS7cNDo5cM/bnBFmfoCgEGkd16gYyABIVbft5ISYQ5fvGaWWB4NeYCiNIB?=
 =?us-ascii?Q?snLF5qH2df3ojDxTHslm9jE4WtcsEE674cdndIjwANH4csgOx6cOqDZvnl5A?=
 =?us-ascii?Q?0iwFPP6v/OUG6ZgBIv0zZrupVPWMCdzDsRoT58VaGdjjlkcqyddoLaid3kLy?=
 =?us-ascii?Q?u6SyX2Ay5gRUMcwKPO5YYNmU96pF8/tPUDmDgr+ORHsxh6lljWVhmfzg8kUE?=
 =?us-ascii?Q?esO5kawGWPWPirOWQzw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008b512a-f833-4025-a6ed-08dd0383c893
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 01:37:49.8804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gj2EZ9Ej73ehIMZlPPm/hGTmjwN9isKjz+SpsTMkB67INPa1ihWgBc5vBON5QWZI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6630

On Mon, Nov 04, 2024 at 05:25:01AM -0800, Yi Liu wrote:

> This series is based on the preparation series [1] [2], it first adds a
> missing iommu API to replace the domain for a pasid.

Let's try hard to get some of these dependencies merged this cycle..

Thanks,
Jason

