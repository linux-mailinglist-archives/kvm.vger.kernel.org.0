Return-Path: <kvm+bounces-56884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F69B4594A
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC5F348248E
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 13:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FE9285CB2;
	Fri,  5 Sep 2025 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XpZXuCBe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284FE352FF2;
	Fri,  5 Sep 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757079559; cv=fail; b=YsZwYjDbPcFlOMV5FyqYzwl3TrmfoQefxBdpHKDn4xL+cabsh0X5ye6HFU3Dtu89hYwnsiiDrcUhGVwNJZnIxlmEHfUUuHTVn+LWubbFpp734oIg7HBBp6y46jgFFl9HbcD9dBY6qWPoUB4ummfXS7Pf1OZNjGcKDeSUYD+kGSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757079559; c=relaxed/simple;
	bh=xqrP4CGWF13CeJrJmRZ2L10ynqMklMRRyGNfcTWisDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j76P8mwM7vXKAOlQQapOrNqiQQXJSZ8hSNZeHwenIzfl4mFeRd4kR/4V1bUUmky8b+himgrEFE71vL30SHZcfKuJRHuHbcCbtwW8o6foTMZPALGeV3GkiiG2QLkzsLMyZ8JQArt+ZrerOf5/iIwGtLFwPcz/vEAyyXbAkg75JGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XpZXuCBe; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OWaSjurZ2COZ3vur5VPAwwGgMDb80pEN4OZGPHvJ+up4Na0ZKWD+tYg6c0nL4RKiHUrzK0o7VBNOlvi303zxdC5M5Cy0Nd2SMW7lTeIFcUcma2RSzahyXrW9uwai42Rd1dMTdfMrcoLS4zlJrAizRxitYaMtiM4VGTV7Qp6rFqYbbmzd1eWjzAXXyOkBiWmxiE1CV+ruhbJA790Tp6p11qYMR+Jb1n4PD4ZdEkfa9kbXEN9jnVpgKueKppKZwUJs91K/UzJg2b69ru9ZSduSTShtzZqCg5UD4xwu2fsjVRBoCAPfOimQqAzFt0s7XBwgYEZjkMnZjmBe6vIQG2ymlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlTs3VsAb8TJJ6THZ11ab6DcqdhXokYQauaIdM1LhyE=;
 b=vtzzjYjkcrjTmcHRHmPOE53IHy86EWmbSdtCx7ad0z+BjFCpV/ua2zsHfECGRJ8IWFk32d2lC5VAwj2X9wc5CgnMGEKkJtn3QbDw0Gq137RzhZa2K3NrSeErfy0ch1atn2hiVwBxUCUG41MIVw9PlE9BgzCCAPCSEQlJG/VNmBJxHbtauvSMGyRUfPNiKEh05KBPk79sttNI30KkO+rpdj5pIj0PQoRSiXrnU1ReOzHjcw5br33VDdnRAjgH10qF/zfnJYIoxn05S/+Q/fLuXqRX0DhmFo+itLeaFGNWnjpyl69R7MMRcR0vaJ7r7j3w5hj4OLZ8PNpaoS5EkiLmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlTs3VsAb8TJJ6THZ11ab6DcqdhXokYQauaIdM1LhyE=;
 b=XpZXuCBep48+K30lsBtGnaJo6rznfUzBG5tZM1yaK01hzky1TrBVvEx6ZCV2WZ+v5LDSzE2DWAWLw8XIDZRO7vY4NPfOq8LgUIzQEGh9wXDtWeYrFvD/A1D2VegTFFyYbRKmXOxCJ9NyiUggK1RpsFSGlXhoo0QnoSPbA0nHwKTwl6mGTkxsUmt/ZqA4B/Xq/9oIojpcHx+vPt/UKMmuRITF+Sz1pWhtu5pl2bAO6l7/2H1yzIgFc6k4o9BYb6sG4gi3XHjHydjV6kfofy8Z7crMXqPl5rf0yDz+gkL2L7hPc2n3zSqqfe+IeUqbVL/JlnrNiUnhT1js0IawcmZoTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SN7PR12MB8789.namprd12.prod.outlook.com (2603:10b6:806:34b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 13:39:13 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 13:39:13 +0000
Date: Fri, 5 Sep 2025 10:39:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: ankita@nvidia.com
Cc: alex.williamson@redhat.com, yishaih@nvidia.com, skolothumtho@nvidia.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, zhiw@nvidia.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	anuaggarwal@nvidia.com, mochs@nvidia.com, kjaju@nvidia.com,
	dnigam@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 10/14] vfio/nvgrace-egm: Clear Memory before handing out to
 VM
Message-ID: <20250905133911.GG616306@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-11-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904040828.319452-11-ankita@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0328.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::18) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SN7PR12MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a852bb6-0240-4517-a7cf-08ddec8199cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FalkOisa/fzlMkMq+32tVh6M/k6fhsjscIWe6fLHWHGIovCMZ0q33N1ir7a9?=
 =?us-ascii?Q?tzbdt73C+cBs11XzcRApXO+EFCnKAmQCpBh6yd/mZJCl39xbHXgT9VByKmMx?=
 =?us-ascii?Q?mW38xch/a5P17YO46+Y2AVNGzuEhuH/rvcaqBWVc/yglLSOFY3s2OVg5CEOQ?=
 =?us-ascii?Q?LgJ5RVgZXtTpUV+PCj+M5y6nFuULphfD4GafsuJEHEXb29u623pFE8O5t+Ur?=
 =?us-ascii?Q?Ox4aR4uW6fFlMVYcf8LNQ26oIVTNXNcZHwSBWFJq5NL6RGQdzqSNcM2PU2kc?=
 =?us-ascii?Q?mqPqost5Qa6YiCVdNIi29adyImz8Szbh8LytUu2XIe3JLu9NESZyere2nKvN?=
 =?us-ascii?Q?8SRErAi46TKYLQf9KGittG2GHjfaBiec5Er7uNqRHqOGdln0ozYRBztsvLbd?=
 =?us-ascii?Q?a3egcsR9EBag+q7sI7kJBzxndgFRegxeCg1bZcUTD2FkIJHaOpVcQaRNRr3E?=
 =?us-ascii?Q?N+qwEzXaoZanfCpvn+DV2vtPT0eWUkyp1Idg2OiQvjExG6EHS2RM+yBy3x6D?=
 =?us-ascii?Q?vkBNXF/7SzVa7B1Q+0hW7t1wkevDm3a4VKGMRZqE/s9L0ERMH/n48GxXj1BP?=
 =?us-ascii?Q?TPTw1gjkk725qFHLZG289lI9Ya4zwP9t/rU6daML9coprvJusHqU6geRWrO2?=
 =?us-ascii?Q?cEKwFR5Z+LQxKiD5lwiB7dq+2U2Q6oH71NpfGkGiCSS5hiWy76GThR806Z1F?=
 =?us-ascii?Q?DEVWg64ihPNqaZ8OIoKXDCroq1yRN1OjOJeApt2Nade+qkxRBgXuAemsTDhm?=
 =?us-ascii?Q?fC5Mf8Tytzkz2k444p51WcnFHyZui5hsu5uN1VKkR2blI3Nj+A0xBcp0sob3?=
 =?us-ascii?Q?ceP9hi2ReIfqew6R/mAMaM8cIXL0KxMHTxYf588abKTj9odkCBYjNrO+zA17?=
 =?us-ascii?Q?aPBXFQl0evk8enMCCj9b3nt+y0lxxKDzqJou2AIg/8Z2klAzSQ9y1y+GP04/?=
 =?us-ascii?Q?XJrNduGUGQYWXkJs+PgOHZMaZmkb4q90el4ETwCE9rGMDIsS3ubPJwRJRdhZ?=
 =?us-ascii?Q?3TGYhUzai1bf8U4MGzzvITcFHqLOJ7Haez55Cf9PZY3UeT8Ns5NYLGLDVDg/?=
 =?us-ascii?Q?Vas0QzhKaTqSc39C28gnGIC4CSYPPAtgsJfG0eUkeQdjub+jcPdD1aqol3Zm?=
 =?us-ascii?Q?6YmuMqQRA3EYpnAyXWamgEaT2PpWgxC79Ve9Y1ZvNDaqZcZ62WJjSDDHlb9u?=
 =?us-ascii?Q?nkCv42ERXF1d2O9IYMnjyJI+OsEUv2EBGvYzB6n5Jl9sRabX8JX0bOxVn9C6?=
 =?us-ascii?Q?KXWvRNBfyxNO7UErbodDp5OCnPUy9f+FcuWsnTUah1nfxKAwavics6dJ/ESk?=
 =?us-ascii?Q?6cgQFd1erppzXbSCX+R+K1aARUAIciFvBp3YH8dyuqVI39m1LYHzggIQsemo?=
 =?us-ascii?Q?TWEAI41w5t0KiOMlWP/D9Bqw+0FRRf71cu/TaKo2kOzoesB1Uym6WcJ9U567?=
 =?us-ascii?Q?95WgyXCwRTk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?43k3dDUvUNZIeQ1TpzjN6xwDGgYgzm2iDdW1i1LKyCmrdXRMDVCB4e7cDfvK?=
 =?us-ascii?Q?bWUORJ9mjDGpFXdJxFcNtqkr1rPmCn3o6wUpU2TUAddFxOD4enRlm8PtcstE?=
 =?us-ascii?Q?LDHzpwddPzt7H4TmfWhgeery5pddVU+8QMfED93bbLn411vvfY+ntgIp1ZDJ?=
 =?us-ascii?Q?nu6QSnh0IPIWdRGCCcRtlWuAaL2qJrInEBjPSEhnI6rZM4HkTl80eWyNORSd?=
 =?us-ascii?Q?LliPWiptqVOI0sfudsb0loS0mAMfeJ2H6s02UwcEOAIKfX2NNgwLk9ME1hZV?=
 =?us-ascii?Q?ZFULLNTt5MQMHJ8vg2MHZvagm5s6TFfqJNRV4AwSDgTwYgJfO46spyeLgq0v?=
 =?us-ascii?Q?nqMAdRb9TrXiiE/S7yAdGNlhIETiQfaFw0cQoqmPOck4zq9Q+wVuDDA3lRYC?=
 =?us-ascii?Q?N+clKQuZiAzhFWuwbw9zUlvTApCjFx+090ZeoilK8JbRHf8bz46CZVg/tx0x?=
 =?us-ascii?Q?Y883yobI0w1c5zeoufh3GpJ8HIBk8ObWjQbhiympntjvVl8jwKuCnhV1zgZV?=
 =?us-ascii?Q?EQ5/mFdfDlJZl0ktWFT5+OQCu2cweifWqToOhtDbNhthNT61mrz8JpMsccJo?=
 =?us-ascii?Q?asNdIb3BDWzIbxn6zYXsACRm4mUFFphoq6aleCsy5EvuE3fiwSkneclgfgiN?=
 =?us-ascii?Q?KoybYy1vWxsk/PTSXD/6vhuhBudMZqDL9WmP3mqe9bQVvjDsgz0n/zsMY+3d?=
 =?us-ascii?Q?5u8t3+UoQdP5BqxAg1qTMYEg83PJPdXrM/s9qKoDMm7SIWLyDZl7VHwqx2fL?=
 =?us-ascii?Q?g3RLcvb1mlFycrG+0N3vAYthCTLt/sIB62j5wRVS/lxhPSJxlwFUsjct0r0w?=
 =?us-ascii?Q?51oBWleRzstIT2qZwU065Tm2J88aC4JlKeFhvGL5qSVMZ3hn7X+HHUeyVpL5?=
 =?us-ascii?Q?3TMq9EoVjklB/2tF9elAL8xZqg2tgGw+IoKsx12AgkMivFiqIMRM5CW+9gTV?=
 =?us-ascii?Q?qPn/W0+BZfro5GcTSz5KnMSiJb2R0ghN6EHk62J51WhO0Qq3Pf92lElt4FsZ?=
 =?us-ascii?Q?Xlwc9Qo76wzNbRVWIZQ/IoiFMHJuWOenMNEwe7u713DRjIGZekRJj2qbcqZO?=
 =?us-ascii?Q?D4Mg4rY2UD+aPRHdqPKMHrOElFg55FYn2Vkn7FM1i2iOVg5JgNPxsSI+SU7N?=
 =?us-ascii?Q?ppxwJmQ0AtRZWpE1XM9VWi72HT3UlWA/XlakRydDqwF18ylUbmknnowwNIrF?=
 =?us-ascii?Q?XGbEuMOI/1y0pNqSsmi9d1cXTVnflcLi7iM1brh7HD7cUW6bDPyzeywffvbJ?=
 =?us-ascii?Q?m9ocoOvs+TPg4GyLrVHwN7R9/cDTOt5sSLKdDo+V5Jlm+yxE0mnjECAiFmAt?=
 =?us-ascii?Q?3p6EgXLCt5rf3yHldhn4g7tat4PltK4OmbkS7Guf0usw6tKBwTueqa3Uvyu+?=
 =?us-ascii?Q?RVArcMGpwQVRxHmmQnV6oyR2d1/P4h1vuEKstaL08w2HLajkZ+ftQmVZ+ChC?=
 =?us-ascii?Q?7WNvzf9pqvZ7ZsR00BK1Vj07lvohz+EFDuNezfbZbBZqzibqivn1BcK6ix3Z?=
 =?us-ascii?Q?27FCsVPEKD7J1v1eHGbrYPWVfmbCcgWBtLIPgcKTNIEIGiBarRw/L4JqgRS9?=
 =?us-ascii?Q?fjpk86OWTiZfXxikkbM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a852bb6-0240-4517-a7cf-08ddec8199cf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 13:39:13.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KzYZuoyOPCF5pTtuoguHbTlENAlwRZ00bVAkbI7W2PeRKfY847UnVmka++TZEEt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8789

On Thu, Sep 04, 2025 at 04:08:24AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The EGM region is invisible to the host Linux kernel and it does not
> manage the region. The EGM module manages the EGM memory and thus is
> responsible to clear out the region before handing out to the VM.
> 
> Clear EGM region on EGM chardev open. It is possible to trigger open
> multiple times by tools such as kvmtool. Thus ensure the region is
> cleared only on the first open.

It would be cleaner not to support multi-open, why is kvmtool doing
this?

Jason

