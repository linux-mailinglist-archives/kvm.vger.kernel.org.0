Return-Path: <kvm+bounces-27590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9EB9987B61
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 00:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F245F1C232AC
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 22:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF661B07A5;
	Thu, 26 Sep 2024 22:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="doZfg1Bz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8391B07A0
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 22:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391229; cv=fail; b=YQ+y9XWaZrkAC1zn+u0POh+p2iwXOBJrN8/JZDRO60K4MeCU4vpBaIRTdOSl7vAEQCZXbufgpCD8C/E8g8k0bHbgCbxJKJGcl2ULqzGEZZT3Bwr9z08CremBkfwsmfMZZYM2ydjqM751TNqByMnSr2/iZMzDmxM1grCYuQK30f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391229; c=relaxed/simple;
	bh=tsPr0FJAAa6Ev4Wm5K2IWRfiuDRZOqIACBLKTQbbC10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=udbL2r3sBTn6/MjyPc1Lb7tG9qNQZc+Qwcvfro4nl0VMFNA0RwFkoqf2ltdfwm05zfOq2FImRyGZd5EoZTad5kjfWn2CnxpYe4tFZdfsELRSwvFXq/iEB6Y5PYLoDcxT3IbB+SibVCVTsdKXlSD/AB51WS4TAZpE7G34FghN5Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=doZfg1Bz; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uv+pIpfjmAkYmy66xbJwAqwMEUMJ08Vh/zGrB8GTYWYxsDEEn+js882MkeVT6UMF+QKlCog4yfsJF0k6Jn9o+QZoj6wkH7oLwmyC32T2R1koad5i4iZfbgjHp82cv8Oqe9BjTYiXOq1rLSdecANydLbUqfxbG/sf6G1TlT73y5uoUM+loafV+GkxvHvCZ+4wL3XFD6sZ9vjzhgnQOSTotYgOqWxsad/Zyttdqm5f4eyJRI9ugbVvTrahrC7MONJkX8JvIKETZyk/p12AFQ5OlQSesgG2fP9lLTmOxeBvRFVmDiR9oqP94hYjgtl9tQw992Yxoi2xnuEJfbA26g+OsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMbq9NDLT+VOWqG+L/b8+opWNZVWE9Q89KeipNLtih4=;
 b=IzIXnAAPTVlx/oKnd5aLd0sWkL+6DKmz3ZwvsLjhQYN/GCQOhnzBrqDzHh02Pw6/v9uJ/4uW28iTuv+K3EGsvlXQlAO32n+KE0LC9MFFq8LsaF28IzVasZDYGg6fjRlmq6Zbi0M5fb1+Yz5qBibJmajZShRL56aUtVpRxtYE5JRxM9foXmKZiV2t1O8oy+JTd72g6YeVgscfdRkmlm5GW9lvNZWFN9Ymngg0t1Tg7Ur9KMGul2c9+xVLf0ZhTnC0FC2V0klechmfl1Q+BkgfnxDU82lG5IkYD/EtHhB0xBF0cQtMcqg2kM1bM7JZz/XdKrPcs5QT0JpZauBax3tILg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMbq9NDLT+VOWqG+L/b8+opWNZVWE9Q89KeipNLtih4=;
 b=doZfg1BzEdnH83exaoDChNzqNMGDG7NPSP78m3WnuZDf29CMT779TSkjJpLISJ+AnFBER7uWQbCTm0qsiSaqgLLN/AIwyEt8PYUnKYY5tOkju7YJeGzpg/fm0tXnd+/PX+uOeu2TlJHe5bSCQ/3hCxozqCtYpiLVZ/ts1rf61el+/33xfSY5pgDZiK6Rus8M905N4OKtlpaJMa7MWyVSzDLqHqcVupiMKaZXGvFMcv4hUz6dszFw1N6a6pr/p3VrxfR4zmNXyGh8qCl9OVQzbQpGMFivn4AIUj3hbO3E7Z7aGNfy75QckXv7fDZ+HQCvE8E4CPrDXCQEJj1IE7Vtfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Thu, 26 Sep
 2024 22:53:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 22:53:45 +0000
Date: Thu, 26 Sep 2024 19:53:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 06/29] nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is
 enabled
Message-ID: <20240926225343.GV9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-7-zhiw@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922124951.1946072-7-zhiw@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:207:3c::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 426dab81-3a37-4a91-7bab-08dcde7e132b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xc+1Ax+BoWxb19piHUej2pl7fEmJ9DUn+giWEgx+7ySbrxcdgUfcpvgZArsQ?=
 =?us-ascii?Q?8SGR2jIFKVLjAphhP7pJ25cd3K2EAcFdxxxbuJv1vqe80eaSC+T985iXHpFU?=
 =?us-ascii?Q?4/EEXwx9Ruo6whaxNhyWRmFZggySyrmeEIn4v6WdkX2q7OShHsSJuOZ06ilm?=
 =?us-ascii?Q?r1EUtUjGdU6zB4p5G/Us21nqRntasBxBPPg847tZl8k6DJuxYSbpFxAHOnqS?=
 =?us-ascii?Q?2shZii5TjeInRkQWIgEPVNKpJNmLJ9J+AAgjCTGK0boq71dQPBoDetm4atQ1?=
 =?us-ascii?Q?zuZgwiA/bmN99phr0Df2NoJJD2ldtsWKzWj54Osz9s6SWTmYTH31vtyGS7RE?=
 =?us-ascii?Q?MK5nu4AFdm+9k9s6ZqTPlg6OcWxHksrdQ3G2SanSO2QFr5y9qBuNwuLs4SbZ?=
 =?us-ascii?Q?jSu/vu6V6gLz646EdFOYROmDOaKhBDYULKODM+T6ctW/yB50i6OSMbIYhRTj?=
 =?us-ascii?Q?haQixd4pqMVZ7dpNQtd0MKLWC8bljBXxkxo1Tu33FcSPzyqFVSd+YVRSHTcO?=
 =?us-ascii?Q?Z02007R7Wt98GbXj6zo9e6duFMyuqJZPIltHI70VEb6ELssxbZMxPLoS/vVv?=
 =?us-ascii?Q?GYlODUENV/WOx4+YrNVpPUQCHZSNT7GMAi34aarljy5SGJOl9rhLSES2bcpq?=
 =?us-ascii?Q?2CztEAHjivrmC+1IOrzvc/YOfpAL75orMaJTpAGsJmMfLbNCAdoUHwqoWcA2?=
 =?us-ascii?Q?2/Q58rkoeU8rVogDUh0McNEgq0PSeoOjI/gi9Kh89oTU1j9xDD3qs2/vXuyN?=
 =?us-ascii?Q?rZQxxCLa02TOtwTMTXs5WzsC26HnlLzTblrAn2neID2uPqzkncVZzbAx0o2V?=
 =?us-ascii?Q?JShUkuybTjZF07lJaNdq5E4iEASKpjTU+o1zoJHAooJ/c5kOivX/qNYvpB2T?=
 =?us-ascii?Q?f5++8f0N/zct/E27m0DRoziThB5q7EAojU3JP3cTO5T6PRc7cdemEA1K94Un?=
 =?us-ascii?Q?j4MGbqsR7YmoxJT9N4zKoeH8kZSub2ZG07wiZfAaafCwQK5b1er4WfGuDRZq?=
 =?us-ascii?Q?OlDQzpISzgy3SsT1YMQFQbYY3G2Dx44IbCZcvXpCxPZCKT64pjVveLXK8HTM?=
 =?us-ascii?Q?mDCh0SK2gyjIHBFxBz0TzB6fnVVhhyVLDzQzI8YUKyWmi/RtCqDEJxSuMeI/?=
 =?us-ascii?Q?lXhiBnHlCITu99vJHzzWam8PhqgrN9yE6xucct/2RAtheB0zXVQnVMjH8l6X?=
 =?us-ascii?Q?IUKI9jAC1CyS+apnmDmUFWivKB1kDeo3yJK4ecPq2I48NVF/85NzNq1/jIIJ?=
 =?us-ascii?Q?YZ7zgTPJHxCbTOBcyTXjI2a07CHrf392ULBNqlfqxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0tFNBeFa+L5lshDDUWfkXBxF3b2za3KRqivUvF8hicLv4g8pnzTjVqA8Ji7v?=
 =?us-ascii?Q?bGoHYPvXWEgPIx9kXsmYL9xpKZwKdgk9gQ73paQ6Ipu1+/7qk02egUO2fk71?=
 =?us-ascii?Q?7BzDKac1QPeizofx5jOiJI6iwgU8o3plMfhttT3V5UKgK2Yd9mhAEVCvgTBG?=
 =?us-ascii?Q?ctuhxf4O41nkeFF6WM/EF51iCH5ozDcKvGa0mfGm2BoYDc7Yn8WiBH/66FNu?=
 =?us-ascii?Q?7+JmQobTFCP3D9/hN2hjCDay2AhWV3YyWfVpaX70pFHoypveUkxbERPyhlDd?=
 =?us-ascii?Q?SR5vJegq0gpDKT7F5F3RtbOVYq9d6OqSdg11/1oFpd+ocP7JT1EjgCSCd4+z?=
 =?us-ascii?Q?k58ZLS+tN+bdFcdmh0+FbqYbJMD4p8KyRHYBKNacKnlcmCBUGcKj4veMt++X?=
 =?us-ascii?Q?sD5LJ5OD7SJECd+vb4KjUCz+ZuyoqXf/SuP70a215Yk41GdaWzPlBVqazlGg?=
 =?us-ascii?Q?uBKs1Ld0M3O/ZlYOuFyiyxZYKU2YjLwZfcOT1XSYV0EuUXBULUZ/EERr8lhE?=
 =?us-ascii?Q?PifOekqpg4+zyRC+9+8pCXTEV+tR6jdrLu0YjxheBpyhvhkEzONb7c+nGWw2?=
 =?us-ascii?Q?cWn2ledLoZYSicznhWgFwwSgx97TRwIf24JVozyrYkIQLLyXMvZFFzpqsFGm?=
 =?us-ascii?Q?cZeAswQ0x8usrmXpNzpKVmm574LkZhRIefyyGP4axvhV0UlOeCQlDFH6iO6C?=
 =?us-ascii?Q?oaWqpnRUJ23HMtFDXvzy3S1epbrEncyRJ1KTbfBsjFvJUqCutPt2+H8EZC5s?=
 =?us-ascii?Q?hfd4In/qy45fP+22/18vj7p0Ph4RFwoiYXvVdriMVFHOuISbvk2yVcHbC8M8?=
 =?us-ascii?Q?aoEBagL4fGzjX8xTNgM4mvPX759YGC5ji/q/3bRroULevFvDvuM7AIh9sOAT?=
 =?us-ascii?Q?cTqhOYSyfeVXdWHdSDNNn2duNMhOqRsPuktR3jvj/OCThbNJg3RHN6GPDCVH?=
 =?us-ascii?Q?o1I66MJk+2Mi20Bf8nBFGGqBJWVmFx38A4KE28u/vtZYedfnyGnDGqJC6xwn?=
 =?us-ascii?Q?lhoU9XNuXPhcHvUrxVW0pqup6UcJpsfjWLdQoWI9h1vw4LjPFqEG1SXfgZ0x?=
 =?us-ascii?Q?hM18WlLg3NiIAJYvQHeXvSDKXbiRcsRp6hBbHdvdLBnxW4ULUDoMzMPPAH2a?=
 =?us-ascii?Q?DBRR+nY+txc9VjGmRdQE6zZ3h6/g3L7hPeAGvbZv59ve6LcXoYK2N1EvVFiV?=
 =?us-ascii?Q?/OYmUE+K75RhljG/KaN5/XyqxAktYLjAHBh6yQVlQ/lI/J08PcbBBIUEGTLz?=
 =?us-ascii?Q?YRFQLsfA4UmG9fevwQPxD3cTzbQQUVGCrHkLvJPsfyOIOGqoX+0e7Vmg8cJA?=
 =?us-ascii?Q?ivVuPlmAPOQdbP9qGGfx9IIt4vnJ6mZWN2ZWmgPqnPFowWt2fEjGwCDM9Acn?=
 =?us-ascii?Q?oOMyFmKhcfaDmqsrHquurI0e49ayqlkKoAWXxbcOsovJcZw21diKPVdYQisJ?=
 =?us-ascii?Q?j2iszkGwR2rynWqpXhTJQE9evrXyJPWLm1y+xEoN7KVV6R5Tzu9cG4ypGI5M?=
 =?us-ascii?Q?uEhyZ3uF1Acvlb1Aq9d1PUbSzWACtlQB1qfD9uvwiC7JylcYXNwjBfJZccYD?=
 =?us-ascii?Q?TwNB5uI/elaYg9pAwso=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426dab81-3a37-4a91-7bab-08dcde7e132b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 22:53:44.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FUDcjUUGIeMAKr2pcnV02HwJ4/iLtkP/uGdR6WVIGhWUghEqkP+Emsd5jS9Go9k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Sun, Sep 22, 2024 at 05:49:28AM -0700, Zhi Wang wrote:
> The registry object "RMSetSriovMode" is required to be set when vGPU is
> enabled.
> 
> Set "RMSetSriovMode" to 1 when nvkm is loading the GSP firmware and
> initialize the GSP registry objects, if vGPU is enabled.

Also really weird, this sounds like what the PCI sriov enable is for.

Jason

