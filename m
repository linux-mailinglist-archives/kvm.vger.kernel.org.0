Return-Path: <kvm+bounces-25111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C56395FDB8
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 01:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8645FB21C67
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 23:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF4F13DB90;
	Mon, 26 Aug 2024 23:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hsBruKWs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C99A80027;
	Mon, 26 Aug 2024 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724714274; cv=fail; b=s1IXquJUBdCHRS3gi4yputL8PjvSVNWzJqbtdnZmOkMSI6DqyrtM0gL61r0OUAVDJG9kZyylC67RuwqFfUVoNl/qm7CZNPI2RDGrS1Dy5TPqaw95dZfbBbz3YbPMKUZru9s2gpsMO4ZfqgPQnbGZwTinlLC7i1TTaeeIz2oSclY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724714274; c=relaxed/simple;
	bh=bBVgY5pfQnkpo3iuNiHqJVJcjfpQXAEkzmrMPRHV0ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mt8Ga20FPjgvK4bt3hiBXgbbhZRbZQm1caQKNZbda8Iwx2wI5hMZsBimtHz4L1H0/AQN06qooiu424f28xXVMAf37rlVEtIPRYUfucu0L0J+zOfHuUo3BplkWVn0HL89f5RQKkLP382dRXYxWvZNwGG2GGx/1HoQK+dOZjl435c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hsBruKWs; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iX8sjnz0690TDfKaeVgos9hqloUABKwpo7/6x8scK6cRMaUvKvni1gSjPFDVM04zOEGZI/A8Ei9DXi5MAl4pWCIHdSlqUqnDsAflkZu0k7WcyAeULIf9q0f4KD7NRyJZDVPjHBLmvu4ozK4PDsRooJk0Tns/C6KxHZ3s4XtbrrZqtemkiqmdd3JMmFkuI193eYpdA8A2p4bKoWTq7jRvJmXR6bP8fHvXBx9OmTAoExXp1AlEeVldQNKvYSCw4KuVy/Udgwep8IKsel1ShFFR4Au6C7OhfiuUsIVpi0iYtBMKWtF9RoUdHet0ghzOJ84YCWXapOxtUe3XlkKrNiL0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=douNZRDCLEkZo8/9dId+ebA1zX3ZsXZ4dJGG8V50YxU=;
 b=u+CvrL6vN9qgENgXL9rfqVqYS/t8WNn+EacqhNdkGZolQwojwmGrIjBUnfwHK1WOitQWalyMj6Yef0Uj/HOmL1wZKTUt6z6uqyPLyd0sjc5NP5113fXXv1INqN4kfK80MNQSrHNlbZOOWxfsxg3v8pDsfZid6sid0+zO/uoyyWNqldn65AWtXNFAi0fXK28kraSpEJdfjqU0o8VTNCl3/d8doMIRO6A6nxeaYl+dq9oUgwwr8PMt/X92mHfDIqcw0uQm18sKrVQmErFl1HqCTTWlLZn10DdejdChrF8ZqvtrMlvGjYJCZh7pc1qehHeq6WrdIgtVk/6HOMLDWcJ54g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=douNZRDCLEkZo8/9dId+ebA1zX3ZsXZ4dJGG8V50YxU=;
 b=hsBruKWsIFr3SGN5TxgAMsxwqIeay6SnuKO2OiTUI7knUqbj+RNmPvWOEhFuHPpert/qQhGfeTKvwUuvI+tqYubqZgslTHlwwkik9Iy2Guxzse0q6V8ciQ1BE5AkJfgZRBoLk5v1JgJZRbgN/DhA9XwPSV8F4fgB3PD8DVa0tMxgTXhBEPt88iQvUaaF6GtOAZKEjKv2/Xn47IA3oTjq4vs6Ok4im9xcFixI1jV2eYHLgDU6VexgMKE1QlwwV29fz2rpglvUqFMPe/aiuCli45DXTyYFXSs6GGNxgE9Qgilnd8uknzHJj3kH8FdUt+k5ZrhyiQtmpNApCHehzzjM6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Mon, 26 Aug
 2024 23:17:50 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 23:17:50 +0000
Date: Mon, 26 Aug 2024 20:17:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Manoj Vishwanathan <manojvishy@google.com>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	David Dillow <dillow@google.com>
Subject: Re: [PATCH v1 0/4] vfio/iommu: Flag to allow userspace to set DMA
 buffers system cacheable
Message-ID: <20240826231749.GM3773488@nvidia.com>
References: <20240826071641.2691374-1-manojvishy@google.com>
 <20240826110447.6522e0a7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826110447.6522e0a7.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:208:23e::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|BY5PR12MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: 932f4776-9ce1-4923-6b6f-08dcc6254ddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Uv6YYgs74JuKEHfdM5IOdhvNc2MaRvZlHbZWKEimyifUjF1GFBVjrcU7QZ0U?=
 =?us-ascii?Q?m1i/nrU7WtEkleLu924uZjbeMku3h0ay6MOGa36PaBBwA7yB3WnbWAe61Byd?=
 =?us-ascii?Q?Rk9J5/YgXC2h03LgJ02oCembBwmGXuK8+WK7BmBu/koi1z/4pXU8wOmc7w/8?=
 =?us-ascii?Q?Dv9wrHV011N1raimc1SydcRT6zAwzIP1mENc6dU1SY/vXai3M7LKkvbwPqZL?=
 =?us-ascii?Q?5lAekmLkCSNiheFe1zeFnnuxXnhFx8JMUH9AooGA7Juw/jV4LRRbEy24fa2J?=
 =?us-ascii?Q?ZhsJPxTiTIYYXs7XeAEISz8sCeuAnjFU2Vgt8yNLBuLe7axRi/QzfFWIlbKl?=
 =?us-ascii?Q?aGLeqv/Ojjl8t3GTqntnDzY/5IvDm3v6IOtrr2lab01CEs9oeSZk44cyc0UW?=
 =?us-ascii?Q?CyDw3oVF0rIbW5x/APVAIttbjt7MrK2ySzmo0ho2sQHu0HWx4NG5FcgFM6v0?=
 =?us-ascii?Q?kkbdyiU6EyQEt4E6Yk1igKcneYwqtglbNvthH4VuTmvt2KrKKyjIJUj92qiV?=
 =?us-ascii?Q?BV/RUfF2Y8vX6+cAPC2u90eCGzcHVTTnTNjiTZkn9zukRmxAJixNuWjwlGCR?=
 =?us-ascii?Q?ZcIEcQKVuM53j0DwZUsZVXUfeH04eNCsqxPtRWEnVUeV497oywNSsDBNe/SU?=
 =?us-ascii?Q?iUi48FSXIj1BZlogdtsRJ+0wDszb9vKsE9/jaG/699M5cWkFK9x7+FwcJOMf?=
 =?us-ascii?Q?qKB1ygap6E2viJu6zm/sxSOF03+8Q0A04DY5gHmZSiMlMdHd9Ykit3tZ4nz0?=
 =?us-ascii?Q?NfK+ByWdM4rksVNUNq/ExbBBTFxmD6U8p/t/JjFDMQCZ1Kjr/o1vtQ/J/JtG?=
 =?us-ascii?Q?prCt0/C7HiHc0tYlgdGQ+CmRRv5WbgSy4NkAv/0nOeRuvSBmEEId/0CK2wBf?=
 =?us-ascii?Q?W1mPYIQ9LMmcqLhKncDYpsWkuwn0UWflcEvJaody+dUUbwozNDTBQhBZyEeO?=
 =?us-ascii?Q?wtiBtWRvCItRejeDJKJtrXTv2As8yXcg0K2iws/6vWncLHz8VnpiKXvVL8tf?=
 =?us-ascii?Q?uq+1Mt5VEp20BZ+/vKNePiDM8P8O6mRfBSsqvSt6CNi+gLuzt3zqUbwEppE1?=
 =?us-ascii?Q?fOGiJZPHk5yb1FPhMW9s8VLjN5Z7UM6sJciF5rxIWgmPIi48RXDGo/vXfyzq?=
 =?us-ascii?Q?y5nxrzpN6EkkTVtLBPhC+JPnloZw2ki6LoJ/4t1iSblRSXj0kdC1poVu844O?=
 =?us-ascii?Q?Dm9TjclL3YV2c+8fMJuQZ8gYPoEVHnYFiGhs1fFjvaK3nQihQ176FgBT/eqO?=
 =?us-ascii?Q?QatHSozFW5Hw+7ag8jqdbKRUaP0Qh9BLl3Sdq1bM3H8l+f+p/Yh1dlsm+K4M?=
 =?us-ascii?Q?OQzms4JzA4w0Nrq8+NgE59BljnF/BIJitErfspeK5/Pn3Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qlSgRiPLHB0U9v4GhrhFbPHZ6Pgjico1f6DLhvplu/Eptva1MWXUEr+XXTCQ?=
 =?us-ascii?Q?FTwhrrzTLm2OxVVythf7vfzgYGpduqt/nXBz0y6/OCaPCqNzmmLVs/0l+3dR?=
 =?us-ascii?Q?lkoQTddfkMadtrRQmOBcd0SLqT0nB0tmCAmHtD/4r0NlrhP5sz/XtGjlizrG?=
 =?us-ascii?Q?3hlnqfCS212gj/MKa2q/S4Riw4auML+SKTvY6nUhlwod3csG8mTh37GMIHtG?=
 =?us-ascii?Q?LEZXApU1FFAcsR9kiH24duqP5uiqkPxfFmQcKJYDjCeDsnDtPWNag5/b3gGj?=
 =?us-ascii?Q?pBKLd0lRZYJx8HSu6wSOKCaDto7FfPU7uUw3z9lGNf67hIEn5Hbu2MBazUpV?=
 =?us-ascii?Q?582IeUYay8y1zmPRWKmTqZfqprX4cyQpS59pV4ah6i3RE5myLTAR0Zi6xjNC?=
 =?us-ascii?Q?MGfJcG4r2wI8xutCpCXfapZNI109YrrdTwe6FaBYb9UwMUlWPEIt88xE8/k1?=
 =?us-ascii?Q?VLCCVehE8PhCDSpUqB6MVQmponniSVRL+oc00Pmwbeg4HqRKpZaPFG2424Cy?=
 =?us-ascii?Q?skGtLTQPJ/oCe6nc9Yo/jwAjc5Ptb9gaERzYJAPOLSGKTDMbDOiIAl6g4gKn?=
 =?us-ascii?Q?PTEUrNQMu91bjIVcAs9mNztDwMw2vLhCKC4qE58Fi+PsbWVwjYNez+M5F6NM?=
 =?us-ascii?Q?5Q//KZlStYeBhjFSoU/kJSeIPCahAqrm2XrA3ir0EKVbntUjMYEY8k8PWBTR?=
 =?us-ascii?Q?3skybeamcLOm+aLO52/3MxqvOSl8BiJTjp4+FECc+L5Ss4oqJEtzI50sq58L?=
 =?us-ascii?Q?QE2vxNtPJddw0PGtd2jm3XYIt4n7cXvX1jGGwEzSfT6DN13p6ZGxga2bNPT1?=
 =?us-ascii?Q?sva0TQ9U87KX6xGP8OeEv+87emFCmp8oKaVKXptjblwh8jHasovWm9hcCiDw?=
 =?us-ascii?Q?ETjx3OhmYhpaUxeN2ZdP2f+4q7Iw3ft9fPUfgbdhwb9flj5qkduht5FZVhDh?=
 =?us-ascii?Q?DUvPlDjVf1K5v9Y2PJmlZ0YqDhChuAPQJFxUaEE5OYman7v1he0u7i7eQfK6?=
 =?us-ascii?Q?jShdc09AiFkcJVqgJlhBoLnedEO05zkl4CQ98Wx5LS4qrRYLoPjLjM0HZB7Z?=
 =?us-ascii?Q?i/NDnCUc1wlReJZ78y50XTeovoosC52CVrr/+wLsvUdMwbXrzm/iMYbbogPG?=
 =?us-ascii?Q?JNMOjPdn/tIGk5SIB7ZRKFGFnpC6xTuyY2lLNZFtJOE+RjjWb+XAt2raouNO?=
 =?us-ascii?Q?65wED6G411rBUIHjBlZc8iR6Y5SxrN9yTGmNQppaTB6FgVMPjJWFYyFZuAAM?=
 =?us-ascii?Q?k88uu4O5VeE88a9+b0kAWr4YFNE/oJP07c4K6a0CCGwZGKOrsz+7bI5bAEf6?=
 =?us-ascii?Q?VzXDPPeKFUwM7GWgniUH2AEXngaq9SNjHSMVcjxMSk418KVUO/LY62LNp2Bt?=
 =?us-ascii?Q?XVsqhvjw4uegPA6EZLE+r65gQBoeSt9YlGfGY6gX4WL0m3r3KkgCausSQsM5?=
 =?us-ascii?Q?PJ5Rtc4JFaaSiqOT+ZB3KYzsqKqn2FRPZ4/eeH7qEaI1uR7SBI2Fqm4t2hG+?=
 =?us-ascii?Q?DacVOMEULHxpKM+91Erv9trxCVbzNFhicpGpyVXu3rdWhAJEvH9cU7uLIWxK?=
 =?us-ascii?Q?Ocsnqmhednp4OnF4fsTti3xOWFZVOIAcNs8CcR64?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932f4776-9ce1-4923-6b6f-08dcc6254ddd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2024 23:17:50.3579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqJ1ipcHpIgyNEty3mODQiqR3HjYePQDPIdRa6d8DTTxslupVk5JB3gh7DMza+aV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163

On Mon, Aug 26, 2024 at 11:04:47AM -0600, Alex Williamson wrote:
> On Mon, 26 Aug 2024 07:16:37 +0000
> Manoj Vishwanathan <manojvishy@google.com> wrote:
> 
> > Hi maintainers,
> > 
> > This RFC patch introduces the ability for userspace to control whether
> > device (DMA) buffers are marked as cacheable, enabling them to utilize
> > the system-level cache.
> > 
> > The specific changes made in this patch are:
> > 
> > * Introduce a new flag in `include/linux/iommu.h`: 
> >     * `IOMMU_SYS_CACHE` -  Indicates if the associated page should be cached in the system's cache hierarchy.
> > * Add `VFIO_DMA_MAP_FLAG_SYS_CACHE` to `include/uapi/linux/vfio.h`:

You'll need a much better description of what this is supposed to do
when you resend it.

IOMMU_CACHE already largely means that pages should be cached.

So I don't know what ARM's "INC_OCACHE" actually is doing. Causing
writes to land in a cache somewhere in hierarchy? Something platform
specific? I have no idea. By your description it sounds similar to the
x86 data placement stuff, whatever that was called, and the more
modern TPH approach.

Jason

