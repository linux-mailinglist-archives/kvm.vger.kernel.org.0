Return-Path: <kvm+bounces-46721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C55BAB8FD6
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 21:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01641505535
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 19:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C76528A3ED;
	Thu, 15 May 2025 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NgbQYr1o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4EDDDC1;
	Thu, 15 May 2025 19:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747336893; cv=fail; b=IAlFrNc074iCiKwu418uyhBIwcLebjJjBAz7ghVDzC07aBEHE6EkX9AlPmntk1zIUaIl1w6GV2ON3njLPA5XWl7U3ywpnY2MQxs21bjAIkSNjpZ4XoXxeFa15Uhjbyym4++jtoHQBekXSQtPUPPF9Vuin8dTJ9VhlE5mIIAQlWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747336893; c=relaxed/simple;
	bh=uAz7O1SWKvd38g0ayUqu2TgIlhugsr4qWBLpJepVVi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qEWWk4ztPNGvCLiPqPSKMTv3hhMb3CmTKb4D+OJvIVnhno4GzcWmwZXHyMBg7WMtnD0uAC6Vq13gP9QxdXKOh1ewGBOhgU72WYjLeYPGpRZcj0/WhFxVT+G7R/ux6d+unMQpOqxLzB/AkkLAMZH1h0ez2kkr/vJTVHOkHEG8arM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NgbQYr1o; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7AZJzBxOreX3Te4DHOhpdjxdFKuWaXGhMtQBIx/GGIpLGVYfkpquPr0TKUOdY9lJdMkGdNQiC7KYbisNaRklgz0agV8tnylVgStNO+suOQizn3orQOYBvjFNi+lApV0J7bbsCFHRv7vrLjtuPKGXOKe4qZsIlt9LvXB1mIh9l6rFofnYUgeF5Lyy6ccadVyJb/q8gpeLYkvsolwEQSxes0cHPOuQoKdliswi/ADklR2wnayRQ1lcRJZnCtQ0u3kSVp4VC7FC7eJoiSASGBn9ecKwvN2b150lbi2PFJMNN1s6choCY2pHsBCXJJtzXzhiWZlpokFNarUF1OV/iGm5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K33z5+xi4198KnymUusYgyJb+35rjaT/UbgCF6jKnxk=;
 b=OvEl8nDJQMUE4Cc9aZom9h3VPXaR4VMfWEFE0ocLL+nw3sQShtQXcnVJ6pHM/CqBtx9QQ7Z995RAoakJT0gfpt7IoJ3o+UJhDJYDdzvLsWrhIi9mdh5NgppUQD2vbIR1brAPcBq8LIOp1FwYrk7AIDxyV/lFDoo0VMHX1jWA98Yzr8hPxaOFkRvJZACEUlm5ankd7CNRdVxQHYE6dtQXgE57CJEa7Pu1cpyRPUnzSckLU/oZXXAF7+vMPW5RrD9TXynGamvWEuOdEwCFvid674jXYMx0BwngC1fo6KbEuhzd86etqxh7v9OKV9EVuJDiP9KXzPRIE1WmiGwzkYgiLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K33z5+xi4198KnymUusYgyJb+35rjaT/UbgCF6jKnxk=;
 b=NgbQYr1o0gAvxoLowTFe0mjIbyOqnRwxUeQEFzsIhbLM+JsgPQc23/qTd1gqqdzkZEmWoVtLfVQF+WfvyefVgD4pq9LavjL5I+IyYRZ/anaHa8LU0zsFigC7MSGcgI1xi0Qs9kb+esm1/TJ9T0rw0NkguUBqfOAXHalbPK5b3W5kZ5VOJjv47kfDqxlk1SaCxzghfwGyHZsq7mChFfgrkBKq6/fz3bmv+gouDd10m9J69kyQksnFTT6kyN1gCXBBIHCXq9GKZAcgUef8FdtEfts0S04mfEzt9PLSra9L5P6NsGxOQbqvixmSV3YpSql/sdFIPnGDXWMebrr6SvW+8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7489.namprd12.prod.outlook.com (2603:10b6:930:90::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 19:21:29 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8722.031; Thu, 15 May 2025
 19:21:29 +0000
Date: Thu, 15 May 2025 16:21:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Zhi Wang <zhiw@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>,
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <20250515192127.GA580805@nvidia.com>
References: <aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
 <aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
 <20250509184318.GD5657@nvidia.com>
 <aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
 <2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
 <20250512140617.GA285583@nvidia.com>
 <20250513130315.0158a626.zhiw@nvidia.com>
 <aCRmoDupzK9zTqFL@yilunxu-OptiPlex-7050>
 <20250514230502.6b64da7f.zhiw@nvidia.com>
 <aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCYsNSFQJZzHVOFI@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: BN9PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:408:f9::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7489:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e61b64e-f264-4728-1479-08dd93e5b15a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h+LQIdYaTZBsVhC6jGPXhvgsiTkkE//NBY83PaC6jk6/kue+QvIz5tcyFQqp?=
 =?us-ascii?Q?wQshwWAPpDDG/Tq1v7jc6bcMTgHAurKO5jqxHlR0ciS2o6/IVyHtWj8HhvJu?=
 =?us-ascii?Q?AH6V04N+WJtzYElLidy1l2xno6Uz2dOD56T1na1CP+1xut3YS8/rTxWnB+z8?=
 =?us-ascii?Q?VnO6tRUtWiElz+fvrFKOMMdD+XL4D25d7mY0IQJB/MTA3wdpLpx+zJiN7rOp?=
 =?us-ascii?Q?N23rf+JD4gATqU7leWkO7d2062Rf8LIlKnXnecKTPr4D3balstINcmXITGII?=
 =?us-ascii?Q?NsasRnAYvPKOTDdksY5zfQq8A0DOpLDQnzHSq1MDyo6vfC0TY03eCp4qcvpe?=
 =?us-ascii?Q?PCoSCWoG1wMDt0qNTaIQC4xGE7R+jbFz/5C2inoWOItUJFX+y/HlC3Shqhco?=
 =?us-ascii?Q?VQXndyLLjouSL5Ak4oPtQAovYNwFcaoMM/+ix6OwpNhzJ9VVa/S+J/bBrjOO?=
 =?us-ascii?Q?cVXM3brNXxwd00i8cjQBZM//osDCPLFTkbe0fxNJE55+usOBZf6Q2uSQXbOJ?=
 =?us-ascii?Q?IFwf0LJ9PhZ+PYzzHgWYnpbjzpf8O0FyqSQ0cWPX1Rtq16PuU9ATYo/SnfP0?=
 =?us-ascii?Q?nX7k91rhOZ5DLu/a4Bjjy7ssCNxwkD8V35tlQBWbk6+Cyja+cPP5F1iTz482?=
 =?us-ascii?Q?wm1zthPkJaYbXjdVq1J9+g1KREhmCv0xqFzPZLRxj4IfcWDp/s1qmS5tCrw1?=
 =?us-ascii?Q?/oiqaIp1c18jXVl7Fgn93NJQFAGqlYMOgCliLlKGeVNeiivcFG0AkcQQf+Po?=
 =?us-ascii?Q?/KfhMIGZMeqOTK8DEBrZVOC6MnZ3q7iEFCbUgnSKNGuxNemimNXYIWn1/Nl0?=
 =?us-ascii?Q?LJi1rVLt/5jilLfMJIM9OTKyXNt2T7rhKKhknEUceYmE2BgzmsTGgy0iqHQK?=
 =?us-ascii?Q?5xieWBOyAngJ+aRk6RIgVI6WmM/Do8VukW2h88NuF5Bx3LQJKusuWohbFvVE?=
 =?us-ascii?Q?L1b7bwnv4LLqVfBS5hCBM5y20fygeZ+cA3TGrQOPHUhlJsYnEMy0zqPGYvUd?=
 =?us-ascii?Q?w6AopVFga/eBc88pReeXtHE57fVuJLY2N9oSQTHl4T8u++P7ezrJQU0Sj2gX?=
 =?us-ascii?Q?RIOc9qqEkzlBnb6v/ihwMc+GQKcrRppMUuUSaJ6X1sj0DHE3ZU3kgzhKBK4r?=
 =?us-ascii?Q?a6+S1E+IeTPrrP0qxUlz1zjQRfq0uQ0oy+0PK6FhjmfE3LgkMz+5kFOWoyxd?=
 =?us-ascii?Q?IeqSLd/vPB6s1sG7AOTguoIXFyuy9rN2dJs2wLJmyKXI0U6XaKIHrKNnL3QP?=
 =?us-ascii?Q?eQ7IPc1f26OZCxJe8lJrPsTRlJ2trUIEoiB9qENxnLwe3Z+ELIKNloPL5/ys?=
 =?us-ascii?Q?zbtlhTmdrxoMWkDr/8CP9moTfzSf2OpPNueOHf/SA3erjBb/14gZqqjvmJUg?=
 =?us-ascii?Q?an8jD3CjycFcYdgZuPYgCH4EoPFjHt227qFamWaIc+zMSiPMkg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z2FPrpEMXo9zg+DLuZGm7ZJatUkXKJUjlCxUbcxjB/08hcx1NNUHRpwdbXbQ?=
 =?us-ascii?Q?Ig/fxJQHB6B0//KGWYMo6WCPqgWUv1BzNuu5MBwj8cx2sBEzYBl2iLSEmCLS?=
 =?us-ascii?Q?ElHsLr2lJ3vCRJVI3grcOSV15QGNAQsqMRqtbMdFiKWwE70m8G6TVc9rJUEn?=
 =?us-ascii?Q?9pw1AAOpfVYIa49pKNO8hCwK5VMeks8j7PGuvPSMk7IrKqdgH7w3tv6Q6cKu?=
 =?us-ascii?Q?ZWsKhagv9tdVfCwW2ahVPXd1BWIgvJV+5mmV7pQ0qKm8t1QVSxHfBhgqyy5w?=
 =?us-ascii?Q?xBkj/WUiMvxIIVDk93iEjkI0YOwW6u+nWTJe7ILjyvMR268LYnND2PrezQFg?=
 =?us-ascii?Q?V57RhFjwilFzw7hl0lJDY2QZe9JJ5iXWRK/BIQakRxNCTVBfqlP0lYGgFGOJ?=
 =?us-ascii?Q?H0uBu3u2yHgfCBIB7fjKxp7igafcMfzeQBDDOI/M3EsaTqiKPmxS01rPKtnA?=
 =?us-ascii?Q?DplSbXSBFcEGkKN1DhAN1jZN8elCmZoD85ep/PvPWSbPvhNk/yjTkwC+nI7d?=
 =?us-ascii?Q?ocKKDS+2APUGwOc5lHp3kB7EJ3bFeeFlj660GAHUPB3Ard5pWd5kk1MaWPe4?=
 =?us-ascii?Q?y0iB6z+K5JK7NY940gmLbT8VoJOgMU7+Gxx29t3Yh5/3+HtbeFwGk13yLwqC?=
 =?us-ascii?Q?BDW/qx5uSQpAlpfZXAbtVBn+ZxbDTJIMINP8qMC0Af8wz8tDX0Xkhv7zcJFB?=
 =?us-ascii?Q?O0BwzAL/IC12OwzucGktu8oOnup3Rmgn0MV09x3wkLNMDoQpwYqbZ1hDs17b?=
 =?us-ascii?Q?r0pAtqNzyJdRxPkJQBXF9xaaqYj0hVk2+Bnzs9P2Dpq79zZCw98slpy8NdU7?=
 =?us-ascii?Q?bnz9+hXFqTjirdvvSoqadbawqe7wr4aLXlLrjgFFypW8+zJV3B4jupIFQtHA?=
 =?us-ascii?Q?IUuS9ezVLx8vJar3Ty9cttVBUkHr/H8fxAfQFnnxYSGSVbIFe7h8hP6WjCiy?=
 =?us-ascii?Q?Djd5erZAgigVSckHYlOq4FuTtuS1WPdl4Q9fFmHHdl/VdDesOcjjqNBy1+Gy?=
 =?us-ascii?Q?0XDD1YQ3B48mm1x5ksv1LzfPc6NMVnC40Q/OM+QIKuBHhvho7X+WR0+1tj09?=
 =?us-ascii?Q?ADtQtcNd5dg2Iz8x0YEuxrv3vsndJTrWq0bfot7RmwhFL9c4Dh+lfpgpv6AY?=
 =?us-ascii?Q?1/zTWYvxOKmcmRfqc0GqFuZ/3+oukcGhCVTTwbqdTl1lbSZoek/kmeowaFqQ?=
 =?us-ascii?Q?aSNfgpOA/F6KM/v9d30v6L/SMx/j1DEV0LxgMYa6oLOFNiGo5z5YWLnm5nrE?=
 =?us-ascii?Q?Zg28kpWokukUlsUeucgMIQu3eby4KmJcwUdIuyWJ1NUrR9feeYU7KBLjzad7?=
 =?us-ascii?Q?whhqNCA6J2Ccw8jOSjj26oiRQk+W+aM7ENjvI4z4dLWWZEeKTnqKcIdygXG2?=
 =?us-ascii?Q?OxnSZp1H9k1xCj+v3WIGLOlJ3T/Pq5TSOHtsAoFWoYsoSCLCW9vW1ojTCNPa?=
 =?us-ascii?Q?tMBX65sLRwqVNNqYcV4XhilUfgmLReB0CKdVyMdTKZjaABBtEPJ4//DjpkDR?=
 =?us-ascii?Q?hwLQGwwhWQPgqTSwxxw/tKuQw+jxj5ujieSySCXSGRkg2vzwt/I4eHgyHiD6?=
 =?us-ascii?Q?eo2n78PajRWkfqQ8K4/3I/1+vdJmn2OjAl4wJpTD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e61b64e-f264-4728-1479-08dd93e5b15a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 19:21:29.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB2PnzlZ1MeaoByM2L5VMYsDoQbI8acPINc+QIkMwrRKrQoeF1QG/0KS0lWXWYdC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7489

On Fri, May 16, 2025 at 02:02:29AM +0800, Xu Yilun wrote:
> > IMHO, I think it might be helpful that you can picture out what are the
> > minimum requirements (function/life cycle) to the current IOMMUFD TSM
> > bind architecture:
> > 
> > 1.host tsm_bind (preparation) is in IOMMUFD, triggered by QEMU handling
> > the TVM-HOST call.
> > 2. TDI acceptance is handled in guest_request() to accept the TDI after
> > the validation in the TVM)
> 
> I'll try my best to brainstorm and make a flow in ASCII. 
> 
> (*) means new feature
> 
> 
>       Guest          Guest TSM       QEMU           VFIO            IOMMUFD       host TSM          KVM 
>       -----          ---------       ----           ----            -------       --------          ---
> 1.                                                                               *Connect(IDE)
> 2.                                 Init vdev            

open /dev/vfio/XX as a VFIO action

Then VFIO attaches to IOMMUFD as an iommufd action creating the idev

> 3.                                *create dmabuf   
> 4.                                               *export dmabuf                              
> 5.                                create memslot
> 6.                                                                                              *import dmabuf
> 7.                                setup shared DMA
> 8.                                                                 create hwpt
> 9.                                               attach hwpt
> 10.                                  kvm run
> 11.enum shared dev
> 12.*Connect(Bind)
> 13.                  *GHCI Bind
> 14.                                  *Bind
> 15                                                                 CC viommu alloc
> 16.                                                                vdevice allloc

viommu and vdevice creation happen before KVM run. The vPCI function
is visible to the guest from the very start, even though it is in T=0
mode. If a platform does not require any special CC steps prior to KVM
run then it just has a NOP for these functions.

What you have here is some new BIND operation against the already
existing vdevice as we discussed earlier.

> 16.                                              *attach vdev
> 17.                                                               *setup CC viommu
> 18                                                                 *tsm_bind
> 19.                                                                                  *bind
> 20.*Attest
> 21.               *GHCI get CC info
> 22.                                 *get CC info
> 23.                                                                *vdev guest req
> 24.                                                                                 *guest req
> 25.*Accept
> 26.             *GHCI accept MMIO/DMA
> 27.                                *accept MMIO/DMA
> 28.                                                               *vdev guest req
> 29.                                                                                 *guest req
> 30.                                                                                              *map private MMIO
> 31.             *GHCI start tdi
> 32.                                *start tdi
> 33.                                                               *vdev guest req
> 34.                                                                                 *guest req

This seems reasonable you want to have some generic RPC scheme to
carry messages fro mthe VM to the TSM tunneled through the iommufd
vdevice (because the vdevice has the vPCI ID, the KVM ID, the VIOMMU
id and so on)

> 35.Workload...
> 36.*disconnect(Unbind)
> 37.              *GHCI unbind
> 38.                                *Unbind
> 39.                                            *detach vdev

unbind vdev. vdev remains until kvm is stopped.

> 40.                                                               *tsm_unbind
> 41.                                                                                 *TDX stop tdi
> 42.                                                                                 *TDX disable mmio cb
> 43.                                            *cb dmabuf revoke
> 44.                                                                                               *unmap private MMIO
> 45.                                                                                 *TDX disable dma cb
> 46.                                                              *cb disable CC viommu

I don't know why you'd disable a viommu while the VM is running,
doesn't make sense.

> 47.                                                                                 *TDX tdi free
> 48.                                                                                 *enable mmio
> 49.                                            *cb dmabuf recover
> 50.workable shared dev

This is a nice chart, it would be good to see a comparable chart for
AMD and ARM

Jason

