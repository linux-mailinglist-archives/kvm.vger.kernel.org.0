Return-Path: <kvm+bounces-27592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F00987B6F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 695511F25800
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5F31AFB3C;
	Thu, 26 Sep 2024 22:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b3T9NviQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D179882488
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391433; cv=fail; b=o22TOMo1dq1mjdp/gwBvZSzqVa/CVYzzJt4NU9ezrLc04Bu/GgiaYhynpUCLb738pH1pZGvxti86RiYWGDjKnhu3wM7MR/d3BQb1ZVw1SbeXVagum+8x8TmAJFZvxOFxRdosOgo8Psev49L8tlGXOt5EFS6nEljnXEvIAp59uqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391433; c=relaxed/simple;
	bh=ItCyKKoCvNy8KloY5zKl+4O1V/w7nHLY4SqiXRbjNNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jByPoWUCLEuLsmcwDrG5BuVn2J9up7aejYQ4LU9rB4UQKMupMiTgfdhyt6sxojISHC7M1E64pX86YHCVhpbpMYJxUbvxHwC8rWk+AuwJklUWDBu0KlHXyml5FDqIx9aJLn7mnQX/Qb9l7Xld99aKz0LCYdVYhPJscpdBsbyobCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b3T9NviQ; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRbQqtziUYIM8yHeXs55qhu6QLo+weI6cHRv4AkJKjbeYWPCLU+j4wfErHP3DF6aKoRvejSagp3V5/GATywNK6+yaE4MVgDpZgb78UXqDldmjXsyG79R/V0Ev1+AUPQYnqHfah7uj8AtVQV59S+4DfKhJ1DDdBP77Cb6Op6T4mSs5cKee/RDK1INLazERS291BMeLBMmta+WcAfI4V908rp2xqk+4rHYAr3eHFOPuRTa3NkEWizTA2vKY/mEOHWLNn0eTMADz0jd4vHLGaYfUI/OX6bsr/u1U/RMaF1bm2T/KdhCFYhcPQL/ev2Vz2uB1f3qbsawkzHbuziJct+zWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItCyKKoCvNy8KloY5zKl+4O1V/w7nHLY4SqiXRbjNNs=;
 b=X4A210vH8H1+hsTZkGn/WTn8LeIVCU5Vv1+mSdpJzT0mBRJYAE5YkP4ngpW5pA9qyYluAfpcvYcD83pctaGqz64VjDbnRWuEZVfhmKJVuJq4xZB4iNYsIegmks0IlbDJhA6m/hwqoF4eash/0bRACs2e1aP2kx7l7hYGA52pXmaKEreTg7z/em8VdAMM0EnGeunrM3GfS25ZIekhLPG5Uh2vKufYK7N+83y4e48j6HI1OgzIPjeIv6ByJx6a6l5V5hnpcf/faHQ5/JJgxeqzUdQ0D0DMs00T6g+XD5C63AypV3eICilq9Kf/PCC7L2sz5G9Q4imyy5n/EM9EkB/ukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItCyKKoCvNy8KloY5zKl+4O1V/w7nHLY4SqiXRbjNNs=;
 b=b3T9NviQyBaoa36gPpVYkM2ysG6Z+10VmK6eigW7Bov/25wkrQD88gFQD/WuQEn7SYDF2Sbn3PN/q5kJBGt88lqYogDUpJ4IsNdgUYBcW/DruaqX/+xDAqHAvVAVd2pWD4FcSO0hwS2fcw+Kro4iBoo1nqFr+tDJwYmYkS6MieEQ3cyvLw9B8w7KtWfG4dW2zeTDOFavZ1/tZv8YccZjPffUtnRHRG+x2VOJzKUOQGikwnNG+2Ylb1xce1w7aK2dRQKrj1o1hsJJpa9vVrMYxQlMGgiAgGq18T3QZvs3QErrSVOny5wd2SSODEdY7pj+MquqbJhOz32yCx2RG6bPQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB7889.namprd12.prod.outlook.com (2603:10b6:510:27f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.29; Thu, 26 Sep
 2024 22:57:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 22:57:08 +0000
Date: Thu, 26 Sep 2024 19:57:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	"Currid, Andy" <acurrid@nvidia.com>,
	"cjia@nvidia.com" <cjia@nvidia.com>,
	"smitra@nvidia.com" <smitra@nvidia.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>,
	"aniketa@nvidia.com" <aniketa@nvidia.com>,
	"kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240926225706.GA285230@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <BN9PR11MB5276CAEC8170719F5BF4EE228C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240923150225.GC9417@nvidia.com>
 <BN9PR11MB52768D78EE4017A90E7CAE408C6A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240926125528.GY9417@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926125528.GY9417@nvidia.com>
X-ClientProxiedBy: BN9PR03CA0611.namprd03.prod.outlook.com
 (2603:10b6:408:106::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: d4de5590-ba6f-459b-4bb2-08dcde7e8c22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FHGP0K86MiOdFb8xGEhAp2CSU2gbizwsR8K1WyCR5oaZ9sWF3eCjVWOZb2TL?=
 =?us-ascii?Q?KUOzKEEIcsuGpV3jE7VHBwySGZ+FLG0WybEcCJfkPCgfEQTnt+MHt25uBxrw?=
 =?us-ascii?Q?+FBxXjtu6VCEV88jTyTJks18XOe0ekMgmK6MB16JaUhAPZqC4c9SnIhz+GZ+?=
 =?us-ascii?Q?eDrP0qVo01Rq+yZoRPxnFvPLjeQTe9bj7nerzZNxP1Btl8NOWoynO7hEkiDy?=
 =?us-ascii?Q?Vc8EWaQwT1VaYQHgzlmLIh+F5WBnO3hSxjrijtrHRLsv38mAH1RUmXv2OnFP?=
 =?us-ascii?Q?bFfHLQgyIwf4rAalQnyfbsK+awOWeUpcT/L5VY4Xzyq2tNrJHlyCJc8ocYPz?=
 =?us-ascii?Q?NyBiHqZyudYe3e/OPg6XQHWj29cNqUNZdmHRowqiD4O6+/aT62WQnp9J1zBU?=
 =?us-ascii?Q?N5lj/yPTpqnqTJ7ZjyyZLZruyXncJp/7RI0Az+TrcG3gGdKmY3r56CxRV8Wq?=
 =?us-ascii?Q?WpzUpqZ4HrS2U1gqOLduSbfp9n9ldTwebH45FRyX5ILLbgDC7qaF3YTB0hfn?=
 =?us-ascii?Q?F7at69zxkTUMrCm+9FLAq0Nr8JAawjbkaEWD/zlHmj7DqREQlFU4uyMdSTXC?=
 =?us-ascii?Q?dLvZSa5Fj1Sed5ghUNlJIQQdF2KCOCaiCqw8x6tVgG3M6xbn/UQ4ASfwgJof?=
 =?us-ascii?Q?Difnwlh5HjUBtX0pCLJvJD4En9uncqi2gsLaML9wjLnuR4LJ7Kw2YatSOFdE?=
 =?us-ascii?Q?pW2P/isoYvICx+Lun9yG3uuQpWPCPs8+NCf+780EpG+2DHR5U77458n9WSU4?=
 =?us-ascii?Q?iDdYuz+tFjjzeogUZwcFSdgPX188qz8KyifzNxJZq+ulO+Ss/3I2MErNEPNY?=
 =?us-ascii?Q?BM5/o9ub27YehSwoyZcAidl+kZw303icdANvEP+LBGzPmdTIPybOwZmZQX5r?=
 =?us-ascii?Q?7lxQA1ct8ka3EG2NfA4QnikmDbf7jCYcmy4olVjiPsOrAXaxythpWCCVvQzG?=
 =?us-ascii?Q?liwcOJOfaGEGQBixwnwUnmk8UfcY15rbFYKLco34tiyGDsVb8CnlQrCBrI2y?=
 =?us-ascii?Q?HmRUXfzv+Z4HNG/knUECsA1Fr3f5jXiMmmUuxaxO4q71/ETB5LeI/i43jsqe?=
 =?us-ascii?Q?hbm+XyL9pCeAEQaRRv9lSRY4Rf3kyOdQeQA3VbHxvbjldyn4A/Dg8QwnEGMw?=
 =?us-ascii?Q?MQxdmobUqah0qjQT/K6nha8sJE/yENPyWC8i0dfDHZyO8LD8Rw+RHuG8RGvn?=
 =?us-ascii?Q?g+bhkDFshhSfF0evknwW7qeDQhCOeNfMJQ/iI1oA5/nBSA3DtkZbLaVslxkL?=
 =?us-ascii?Q?zqWH8JfC896JYX8uiMK1To6FPqog7XOnT47UHLwf9iD0VMtryOQjyxsfZbAV?=
 =?us-ascii?Q?Z/SGcb7EPzp0ecokXqdrDHWrdOXB/Uk5UKe+5oglJ0+9sw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NbEuGKGrrcBE2c6bTgoGv6mhxZT2CLNsJ0VZGDlFYGeVEIoRzze1O7RGkHA1?=
 =?us-ascii?Q?Iv3gpq2rRdVNyAmIWum1mXwhbxmlRDZogDPUhMWcB8TM6dSjtNc0Ishjoucv?=
 =?us-ascii?Q?OMPU5m1+NDmqK8zaOMqr8WGFkakHU5eN6SfqfiTugWullkfJK/7hv8QOH0/U?=
 =?us-ascii?Q?8KiGXfqReVUWDK9kvoBP74O35zqrVcIdo6tAINpQGwuFZvmklnf+2zEs5Oju?=
 =?us-ascii?Q?iqjg44IpKV0g2S7TMzK2IWVoRB728VO+tGB0BOLQT1pVUzsWYQkAmbsf8PJD?=
 =?us-ascii?Q?UzogPaOFjtmvKJxtQfpEwlk85A0Syb6SvfutFf1m5G/CrrEP00nrD63wnRhK?=
 =?us-ascii?Q?Wwe++xX9WYzrxx16V/8BZgZxdHXoKQLjgkpUcJqYTueQ5uPpGmeUGbkQqTsE?=
 =?us-ascii?Q?f7dkhld8tIpV5+bYYwruvLO5wFVpyy3p/znxmtjTYkWfwPunmwTfj3JIsQ/u?=
 =?us-ascii?Q?G/qoK/5rwnRScF+R3QppHgM9fuUQG+8rYG7zJYqqzDYeweF5GxspMtd3Iaf7?=
 =?us-ascii?Q?p9BgdP8Y4CMkxHjl1SggUSQSL7Ame/q0cIUOiVF1sMVGq2WQelfIcZo4UQsc?=
 =?us-ascii?Q?k5H3rsMiOTfFBlLSouQCjNdv/acD1YguFkJ5bKmJJPhiQPmwCsft59KZ0bhd?=
 =?us-ascii?Q?mZ7Ytp9O6J1owoWVXFso6jAhxo3lzPLmIyvN6S8vKpVhZhJJ54CKsAUVJ2CV?=
 =?us-ascii?Q?3LexRke1tIEsPeHLmOH06gtpLulik5hTEi/oLYPt/mLvdvxlKxtJxJIbBmt1?=
 =?us-ascii?Q?2cQ+jbL9303xq/cHpAyPm7G0jB4zTAVP0WI+AmBjPIBmTngAcQUuqG3C88tA?=
 =?us-ascii?Q?KJIKX7M9wPfA/flfq1DyQA4noIDrgqdRHkrnficP45D7CKR5oKLpdi1Q43jM?=
 =?us-ascii?Q?rDRRmQbq8BugdLFF3LWoeZ0/P1A2rlIe3odFuRzqWWP8PR707xQv4B0b3uOZ?=
 =?us-ascii?Q?Onm/Hr3ZHyZ0NjFHoxHiSouRZOKSYGMOni5XaI4/uN4w58d2Ub/yMRfj6SvM?=
 =?us-ascii?Q?i7lStr+SqaDPXI2rR7ILoAg7zDpTkMyY1ewvXfFhe3JA3MzjJZ86Jx7/YjZO?=
 =?us-ascii?Q?zGouQ8YFzhSHV9wsu+xelUigNhqj01Xp1phu12R5/e77S2ZKMKqtB1eDoHVH?=
 =?us-ascii?Q?kgiRw7CqG4STy3phsJQwhdJUMnTCLvDEEDt+d6gMbbCT7Ux/fyIK0shYNyiQ?=
 =?us-ascii?Q?gqtfCcW/PECZBwu+MPFNOm7/WBY9CEjmvvEUgJS8n5/Zg9yfTOkKU6wVIeZR?=
 =?us-ascii?Q?kwFV31/avjnL5VE2tud+SMCamdmHmzSW5CrtwrLdzWdZW39ad5ZsuN9wvUDf?=
 =?us-ascii?Q?bRiw9Jiciyjvg8W3eKL50nud+ZmakmMPgNkS/LMuLJY8cPkxorRcLE0xijeD?=
 =?us-ascii?Q?hwYa8eSadY2fN1ThiDQOLOiw2pM1jmV1md4ktxI9vjEUguPUyLtmXs1C5Rx7?=
 =?us-ascii?Q?ez/s/Wt2OPdSuxjHaC+EKHuU4WQ2MPSVCTuBSkfEj/3fkGS516Ir6yTVbjk4?=
 =?us-ascii?Q?e+cYhOEh9BF+tLnMvoGDa2V07GYjFcFML/Bog6sAVnGdwbtrjS6ZyGjWqvM/?=
 =?us-ascii?Q?tQK4r2mF9EPXzDD3wO8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4de5590-ba6f-459b-4bb2-08dcde7e8c22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 22:57:07.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLUJJCm2rldCYYEDkwK9DsPxW8RycH0nzL6qgWhQpfFLhlgEhDWENcskj+Edzag7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7889

On Thu, Sep 26, 2024 at 09:55:28AM -0300, Jason Gunthorpe wrote:

> I'm not entirely sure yet what this whole 'mgr' component is actually
> doing though.

Looking more closely I think some of it is certainly appropriate to be
in vfio. Like when something opens the VFIO device it should allocate
the PF device resources from FW, setup kernel structures and so on to
allow the about to be opened VF to work. That is good VFIO topics. IOW
if you don't open any VFIO devices there would be a minimal overhead

But that stuff shouldn't be shunted into some weird "mgr", it should
just be inside the struct vfio_device subclass inside the variant
driver.

How to get the provisioning into the kernel prior to VFIO open, and
what kind of control object should exist for the hypervisor side of
the VF, I'm not sure. In mlx5 we used devlink and a netdev/rdma
"respresentor" for alot of this complex control stuff.

Jason

