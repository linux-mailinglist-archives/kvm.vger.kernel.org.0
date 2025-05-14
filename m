Return-Path: <kvm+bounces-46514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BFCAB7184
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D15F1B67351
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2EF280A5B;
	Wed, 14 May 2025 16:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dzA6cYz8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413C528030F;
	Wed, 14 May 2025 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240430; cv=fail; b=CKiheG12DLKsbVQ45s+G8Pgl+K7zOr2wuEro/Kz7qvxKC8drdNMLHAHH7RN4sggqLP/SjhLeXb4D46q7F6nEx6AcQqy3xbUiPUnT7qbKZuWGqS2qQzrRZgPj5FNajuxK7BRTsrYniHYJ0NaieV1u8aeM5V7ey1i+T7kPMwtaLfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240430; c=relaxed/simple;
	bh=gfTCp+dlfML4sl6Grc3teruPZFulpxGAysOER1gavyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nRwTOdN4Jp0pMdH4EetcP7WwQ1lAKIwLSmHV40peRPq5xjEq3eVLeCz1uHtf4oN0bn91gjPZCK5ZBx34DPhva00ZeKD7hZA5NKm3uQ2aja94Up+uWvYXz3PAL+qbal1pINPod0OqxCtFKw4bv1kDgjtIspmbn5tVndU08g/AfOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dzA6cYz8; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hE6Q++lvwJxdM/TznDNM9qO/9NKRUpvT4viZwzEEQETOZcyLnuEJuHx8XTTM+WYCZlO9oMd1V3pvHB6rrKCZSqUP2Ye38T1KN+IP7vaqpKp+F1EkVPufo7FH3H3sbcPH/BBpw3OUt7fcA4n7SPQ7y9IwkVUc9oq3Ua+KWk0ATIrlp2+WmzrEsiGMMGmwlKHkHLe2YbK4dfL1Ix2xCZuBgOSxHdcx2PyvcVRuiTuH+p+whYUzeYLFSQwCx9cfxrGVLPnxnN9a2BmpxtO+hxfA/lcaF6ZDlOGQEUEtWnKgbgatZ3oywWwXeisfa8JCXOt1Ffa6yQGovnVbICXnlbfiRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxQirxrhTI8EOU1qJy412hQmprVmytWNGW+UPnIeZWA=;
 b=NCJzpFoZr2Zsau3drXCiAtTCjIxaEMZh+yXep/M3HqOvUDCZ0knlXjgKigIsK54jzUziqbMVRaX2znkvOmzjaMzuvbz9IG/6WA0FkcuBmFHUIKlqLR8e9WBxnyNDdCMAcuKFJHjuv7ClnKqDRB78i7tGns5e2Jc0TlR21jYDqi02iWcJAnqoiCivkXK9GpwyW9OzZwJn3jh79PvRPPdMt5dNHyn616N9ipcFeSU4f4poVs3M/xUbuHlexjEMlF6ZgXE91DxsErNGN5YjpFN0/ofVEm8Szjjuj3oTJJ4hgBoWRy+KbE7vSW7+4iR1ixX+OCl1h6wHgLUx9ctdl2miQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxQirxrhTI8EOU1qJy412hQmprVmytWNGW+UPnIeZWA=;
 b=dzA6cYz8ACdNRcSt78lLQv67PxqBDcgCafRbBdi/yZWnCzn88bpVLLXNostHLjAuoaRuSFpY7wO+dJqyuQS7b9GbzPkQPsowHomu6Era+epAfrea7riqVlHd8mu4/6nMxH+Y2lanMXBm5D2M8KCww8HGe4mNRie63hEQTgYzlxz4rIrAtlHELdKX6suMv9PRMwIQQ2ZkdVrG3vGwIEOmVlCz4KWtf4slkRCJVM28Xyg3GtE5JPgMhu+BMkktA0+7w9vL5CMcEk+6Myhyh4rTtU0R9oWq3medt3502eLuc83xp4vzmYzhWkktUN+YOetbPlgFkRtdWLo2vlbOS/f2bA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Wed, 14 May
 2025 16:33:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 16:33:41 +0000
Date: Wed, 14 May 2025 13:33:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	christian.koenig@amd.com, pbonzini@redhat.com, seanjc@google.com,
	alex.williamson@redhat.com, vivek.kasireddy@intel.com,
	dan.j.williams@intel.com, yilun.xu@intel.com,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	lukas@wunner.de, yan.y.zhao@intel.com, daniel.vetter@ffwll.ch,
	leon@kernel.org, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <20250514163339.GD382960@nvidia.com>
References: <371ab632-d167-4720-8f0d-57be1e3fee84@amd.com>
 <4b6dc759-86fd-47a7-a206-66b25a0ccc6d@amd.com>
 <c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
 <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCRAHRCKP1s0Oi0c@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: BN0PR04CA0209.namprd04.prod.outlook.com
 (2603:10b6:408:e9::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: e111c9f8-b292-4876-f72b-08dd930515db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l9lMwEa0e3O4iqd5fDUqfWT125cdynwHqUimk8bH5XtNl11Xl97oqxgXFStL?=
 =?us-ascii?Q?Ax+9R/bNiDUOZegiIMVgtRVJI00hdW/qwSFJ+hyYku0fzaPQ8q641KFcRuBv?=
 =?us-ascii?Q?H2RLAgvzXJdCnYLy8Ta5QA7mtLXLiZ2IsMnGp8cih5SFZArxqGURtZltL9+b?=
 =?us-ascii?Q?y5FkOyckcdwzxMpudE/4ltN6oUhe/+rH6XfwVcKEXg8RFERKoJ2zJBDxxqyW?=
 =?us-ascii?Q?+Kd945CRjPhiPT4WVvoLpVbgJWHDSlQbwHN6rNq1H2ZDTdHUVYfqg9DF2I8C?=
 =?us-ascii?Q?+EduP8ufuYaZvJ7Qmqmf7yqRf5+0w9UlKaRPzho3AFX/PmdUM6GN3wHrSVUC?=
 =?us-ascii?Q?DwCmszuk4B3sb3hKNaYw8lY05hfTWs8SaWzth9UAL2WVegChkEt2TaoWJvkD?=
 =?us-ascii?Q?O3BrvoD7ujtsNZ7ubdqUBA2toDKf4HHS5zuWwTabhl8gaMMTE0vZLmQ2oIZK?=
 =?us-ascii?Q?INQy34ay6PTu2m9jNRRYW0v+X47HFfWENMXgNGE3cB9/fsaZzspiWnWwK38O?=
 =?us-ascii?Q?yXAUTuD/DTp/13GuDoYqWsI4teRVXrXWoqWRcG/kobhRYXfyhBvlFB1kfB+2?=
 =?us-ascii?Q?TTLJ14nYLG8XZrYmLZutSq0z1HCoWk29BpR2LgYink1GJ8K6ute7H8GKFhRm?=
 =?us-ascii?Q?qRPJdbrCS3OMkbV/KnIDHwnUSCyIB5lK2cjmcpZoACJQe1EaxTVshSMECaKC?=
 =?us-ascii?Q?JSia9C2nrMfgzai38I7cso+T+j/BIum9sVq0J/5giTpGn4tp969N+OjMfYiB?=
 =?us-ascii?Q?I68QiWKI8yDRQqm/9rh+Os9tkP3B2Lyou+/9iUuDy4Xtzu9gf0iLJwxdnehB?=
 =?us-ascii?Q?2DBDlaAEccYX7UofH2P+NwbJBjatgRlwo7Ow1cFFAGE6u2gLIGmikv0i3lQ4?=
 =?us-ascii?Q?sxqT9AM3TXW3OhHhRHZblr5pB+Xh4lOCtV22OxEu4GFQGOKr1SygO3hc+Kh+?=
 =?us-ascii?Q?2uf5Gts9yQT6zVlqlQWFQKX3ng3yQ3RINKiAMHczoAkbAqx4xKrH3at88xP3?=
 =?us-ascii?Q?84W1DNeDBmc6qpnBnUJSU7HFTNrGT2SaiF0woqOQgBpD+Q5ugoYUjbHjwVKj?=
 =?us-ascii?Q?teOiOWyn15qOSHLCRzXJ4rRGdZwKI1/Mgj96BSOQknrzUEjhoj9zXIh54k+f?=
 =?us-ascii?Q?0aJxRMF+Zc9eebiuTn+c4+h1LXc3P1bwCSOsO8nCONVdtSCQA8Qih/NB00lf?=
 =?us-ascii?Q?gqhSiyKJxy/PXJLGTlmzh9ev4ppCDHFwZwcBQuO8cT/3vBjmoaMgf2t3T/I8?=
 =?us-ascii?Q?7G1TzLXtBj+FbSpdHDS/loxiOH352YOOiIXATkAI9STqQeKGcl/i7DAmvyjB?=
 =?us-ascii?Q?f+EZBgwKlUi9Y0cveMI5BZ7iXNSR4MmXou5wDeXtjXt7eFckhrPRb6IgxgRv?=
 =?us-ascii?Q?s5riQW3NO7+LfN47meHPW3izDWZ59SZjULxsXDtx94LfupljO6UalA9WEcSc?=
 =?us-ascii?Q?Gi4o+RK9QGQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?goWbTGc1+I5z9UbzhhS9RF/UfA2Cnq2wVqyzA71wz39PVPvGzTd+B9HTr1Pn?=
 =?us-ascii?Q?1j6lqeeQv1f/NGVN71h/5fuRvLrsbkF9idfxkHnOGbCYJ9f8LkblHb7zuIZC?=
 =?us-ascii?Q?Y8HzPkpWQnpz1w4x8iV1ZOVDJ7fg/ONoR37lwLHxoQLwZEugw+sMXwlBsArU?=
 =?us-ascii?Q?GeiFJC+Xaur1UhUptwiDReP6btEdwsbLfnQQY6uJVVd7JycONMrThZQbn/OZ?=
 =?us-ascii?Q?xxV1oLvvKanEclCMr0hxes5eyAJLIoZZl+y7RQANtTp+o7A/AWXNA6Q4BMtP?=
 =?us-ascii?Q?xGFHTkHuTBaPaGzK7GCncmG/r4Aw0dwif4ZaCk9JsDMQaJnc2/vpctBrBkmb?=
 =?us-ascii?Q?99etyyKkRhh9OoA18EdMvoOjnsdXPk1AdVXdpfgA94ZVvnqiJY06Uxfp7KQA?=
 =?us-ascii?Q?bLSrS1LqmfPHo8+82qtoNDkOc07PZiCmn6z4E1bKcRQuxYWIotwKg8lDaf2B?=
 =?us-ascii?Q?h9Uuvvfnh0V1FEDdfKglUT2pB9btD+uynmNp7NFV6xH5pWco3G9CMaYMuJ3/?=
 =?us-ascii?Q?+hcd/c4/+0Y8CE/CkXGLDJ4XSJ3dlosMwt3js2OffQzzSuYeoQqhfo1mLJyl?=
 =?us-ascii?Q?8PuQdXlP5k3y9HRTrC7dungj/NqACm0wrHkSqTTjtVItL5HxcssAYSFfG9nx?=
 =?us-ascii?Q?K6csBYHXOWDNPgDvvewacS7nTJlEaTq8d9fhlpQ+SVUr6Hy0dtZX+zPpL6wv?=
 =?us-ascii?Q?THDRFndhBQPg6o8uhUapChCnm/zelLH8F23NMAKvRXmyUvzZwXN91OMqyuxq?=
 =?us-ascii?Q?vWSFY19/P/Z2bgVvIL05reCvY8id9FD4hGBi+bkpnhKUIGs7L5bLi5SH+sLC?=
 =?us-ascii?Q?r+7Cn0Y0338zIZtz0txJ2rB8LyFK3n1pE9FnteP8XVseU5KZo120vYyA7V+7?=
 =?us-ascii?Q?iSuGOGk9EAKRpCwrNBq/ht4U7z0sssPzDEdlH7ulCSL58mR+/m9H7e4hjgas?=
 =?us-ascii?Q?DBrITSt26CKjCAbqLagRK7gnYsYYRarM1BERN8R9ClZ66iyf45LHnAelCZwP?=
 =?us-ascii?Q?DIRg9yA0rw1+iAQxJ5P7pjrboD60MZ1turyUhogzQO1uijDKWsCO/hUHusZa?=
 =?us-ascii?Q?zuYmXGYbTa5JPWAwk4imzCMdZuMKDyehKJ6UaLTIdtBRaNyk0F0rQesp6XuI?=
 =?us-ascii?Q?gRi6Xou+/b8UbUBHDEJt6bxOrVC47x3U7RTqNHSWw6ha0fdaL+nRj2C5dQMO?=
 =?us-ascii?Q?bz736WPsnMXTwDP2bg/sXGkN4SqxTQHZb2auOKLILp6sulqXEHzPoD7ixnG8?=
 =?us-ascii?Q?1W3RWXxSMi4LBMpyIiBbNaoDuFPKDRudQ/hBk3zyPyWYz9T0u2jKxU8MixUH?=
 =?us-ascii?Q?JgKEEhYvtR0/iu8sJ5lXl6/B5ctt59RPrQlTpB9q67fVaUSR8zSLTmDVe3eF?=
 =?us-ascii?Q?MuiUta52qgR1O7oERWJ9may7koN1d3wl0s8PDZNZofRykvqdrBb6XUpsfBv3?=
 =?us-ascii?Q?lRG/8K9Bm4SS/5We32NWV1QTQrXEvObhZXltJWhmfoNBWX8OwRb6505p7J8t?=
 =?us-ascii?Q?t8nknsxm5nT9bU+G462frr6OU4sW0Vpn1Ap2R7cdwkELlzqxNOfAw+kr0t05?=
 =?us-ascii?Q?enx29PjtDeofR/uC3r3Cm/IcBrBOWOMdCqT6Si/x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e111c9f8-b292-4876-f72b-08dd930515db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 16:33:40.9503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFZk7HjtLkzpDHZ4eC/jwQKvpPOU17wJnwCxa3/uILoSjW+qGWtBhhjWdAWPxukg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7548

On Wed, May 14, 2025 at 03:02:53PM +0800, Xu Yilun wrote:
> > We have an awkward fit for what CCA people are doing to the various
> > Linux APIs. Looking somewhat maximally across all the arches a "bind"
> > for a CC vPCI device creation operation does:
> > 
> >  - Setup the CPU page tables for the VM to have access to the MMIO
> 
> This is guest side thing, is it? Anything host need to opt-in?

CPU hypervisor page tables.

> >  - Revoke hypervisor access to the MMIO
> 
> VFIO could choose never to mmap MMIO, so in this case nothing to do?

Yes, if you do it that way.
 
> >  - Setup the vIOMMU to understand the vPCI device
> >  - Take over control of some of the IOVA translation, at least for T=1,
> >    and route to the the vIOMMU
> >  - Register the vPCI with any attestation functions the VM might use
> >  - Do some DOE stuff to manage/validate TDSIP/etc
> 
> Intel TDX Connect has a extra requirement for "unbind":
> 
> - Revoke KVM page table (S-EPT) for the MMIO only after TDISP
>   CONFIG_UNLOCK

Maybe you could express this as the S-EPT always has the MMIO mapped
into it as long as the vPCI function is installed to the VM? Is KVM
responsible for the S-EPT?

> Another thing is, seems your term "bind" includes all steps for
> shared -> private conversion. 

Well, I was talking about vPCI creation. I understand that during the
vPCI lifecycle the VM will do "bind" "unbind" which are more or less
switching the device into a T=1 mode. Though I understood on some
arches this was mostly invisible to the hypervisor?

> But in my mind, "bind" only includes
> putting device in TDISP LOCK state & corresponding host setups required
> by firmware. I.e "bind" means host lockes down the CC setup, waiting for
> guest attestation.

So we will need to have some other API for this that modifies the vPCI
object.

It might be reasonable to have VFIO reach into iommufd to do that on
an already existing iommufd VDEVICE object. A little weird, but we
could probably make that work.

But you have some weird ordering issues here if the S-EPT has to have
the VFIO MMIO then you have to have a close() destruction order that
sees VFIO remove the S-EPT and release the KVM, then have iommufd
destroy the VDEVICE object.

> > It doesn't mean that iommufd is suddenly doing PCI stuff, no, that
> > stays in VFIO.
> 
> I'm not sure if Alexey's patch [1] illustates your idea. It calls
> tsm_tdi_bind() which directly does device stuff, and impacts MMIO.
> VFIO doesn't know about this.
> 
> I have to interpret this as VFIO firstly hand over device CC features
> and MMIO resources to IOMMUFD, so VFIO never cares about them.
> 
> [1] https://lore.kernel.org/all/20250218111017.491719-15-aik@amd.com/

There is also the PCI layer involved here and maybe PCI should be
participating in managing some of this. Like it makes a bit of sense
that PCI would block the FLR on platforms that require this?

Jason

