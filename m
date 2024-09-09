Return-Path: <kvm+bounces-26119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A8B971B47
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 775F41C229D3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206961B9B55;
	Mon,  9 Sep 2024 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DfN8hxiF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C91B6549
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725889255; cv=fail; b=Xpmf+dqEmE0TIT9iNMF/6lCHEtVdBipKIF7/kMKpLcAIcfKVf0NSimMUOFXPFTvxY8P7vcsxuwqAZV8aq4WlqVto7oQX5vEQTPB04E1xLFn+Ai4Rui1r58fAvioWltQC9SXjPXlVPEWUfUoxbNotO/SeiOhYzwhe6gi/MrXxu3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725889255; c=relaxed/simple;
	bh=cfkd6sHmDtSjOsCF+q0KfVtGqHR1kGvxXJzDUCL/Cf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RFyXQYs23kamSh2BgGhJ5T+goqHbUl5iUuv068pQIwp+mwLRFNiM0+pbC2XPKHuNRvW8uRnaW2U+PmoIWNOu9KhiC/cgKcPy9jMBaPgxUVJieu9thPcf+B7CVp/Cd/OBr4EZzSBE8IATL/atwaJuY7wypqYqSqoq2/UYtLKQ47E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DfN8hxiF; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wy/Fe9kqnBI7Z8rGWcfIL0/6VyD0PmHksis5Ee6hPj9nipctwHxtpOT+TxzNTUia61zeWaRUDR1NXTYrUOxzbqRYw0EvFA/DhlIc5ixw93wFqnOoy127nfhWxXAdcJ0CxEyAvcXV4jgnqMK4ftGhKidXhe+gFan9HeqV7/yGjZe5xevtCLXfV+23b/CfR7RGQziNgsnf8NqJKMnBhw3yr3LA0PS/XdPQu5jIw63fsgXQfDb+eliOpzjICeUiCHutx2TmIhH3fac0NzbKXgCCtHzeBlsTAOQ2Uvd1ErHH7i5QrcCn0UXOj5E4CQyrBF+BvnZY+U2fpsdSjKCAdSHulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnU2HV+Vr2MPcVPvJaVjJQLHaEkR3ydS9Kkn6FwWpmY=;
 b=Pi21XXlYmrsJjNFz78gYSckvtAIsvii1ZXX92UVwHt1LRe6l6RJtU0v3ijpu4d7kmnPUmB47C+HGEg+PiKN4XXNUoqMXsUmnuezWrzvpSWrV2P9Z7eWhwRjnBzJZJ9oiNT5IneuG/vmdasMUVzeFHWv6Figgv4+Hzh8JgptLMVjDb7TL5Sq0Cjuc6TA7wBXGxvAgBvjR1Es0SAGJt1+W+jCJfg2C23XzyMFpVvv11ookGwpoK2+wP4lgAy8J8N7IMhwuidXH5VfBwO+pbQwohYozZNzmS493nWiNXfxImCVSs1xq9bZdBc7bbcm8FPYHfb8YTHMf+cZ/JPEPJGgweQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnU2HV+Vr2MPcVPvJaVjJQLHaEkR3ydS9Kkn6FwWpmY=;
 b=DfN8hxiF9nTWjJbcbCSsCnjEHQI5r99Vr489hW8q+gGgN7wMHuID2M8/lD6LPBVISyBZvo7mmT5w5ZVXTaIGfieCQsqjsAhvQIGACGcx6jQrIpDRdpEYP37cTd4jFaLbKbhPJkP9FxtC6ACvYynUG2TMCr3xxBvIWzdWPpwUB4h6ZVAdGq1EpXwApc6xyy1pVNpuhEBenCXzKNVkl1PaEjdl/KuPN2szOxKWk2M5CWOlMB+3yA73DBP9QkrIkg9bKklbSamjcKTPXm8j1P/E4hiya1iEnax+dEvOyZYEk8G89UO3x6cwbD88yzMdXu7espu1jxOw1G7io2bJ3wIRJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB6433.namprd12.prod.outlook.com (2603:10b6:208:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.21; Mon, 9 Sep
 2024 13:40:49 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 13:40:49 +0000
Date: Mon, 9 Sep 2024 10:40:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240909134048.GC58321@nvidia.com>
References: <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
 <20240909130437.GB58321@nvidia.com>
 <bf023188-ba72-457c-b1df-7209be423567@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf023188-ba72-457c-b1df-7209be423567@intel.com>
X-ClientProxiedBy: BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20)
 To CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: b585cac9-a3ed-4680-0e28-08dcd0d503d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T06XnF4eUiytL+e5utzoWtWXkid4cCdllJ5GwU/nv+jWFHeRLQ3ja27yYPgF?=
 =?us-ascii?Q?drSwP9kgwX38GeHyKytUMrGupjP6OzlGpo+Jf+oY9fOvPLj3ZwjKIUBK5muN?=
 =?us-ascii?Q?bknOP09Zwg0Hgc5yITJMkak1nAbSo+RCCXnXPpRQn3ZkISJLSZh4n/JswS1U?=
 =?us-ascii?Q?AtZqkpZAB9p3MKEE76n8Y6+xT1oPwo6VhcqnUQK2Mr1ikykgYs7G/fitxjMq?=
 =?us-ascii?Q?Wwrkojdh7yaUDAKhgJRtbHdLSd8AVCUb+/q+hWZmoLUNzAoTqRBiAkNECsd4?=
 =?us-ascii?Q?ElP8xjkYC9zpiOOIdkKCxD5RMoZe0i3eL2023mIrnmP5vZ6KUeFK6oU+MBBm?=
 =?us-ascii?Q?2QISNqNNl3jh5cAKLeGHxYbQGPyXdYisDg9FSm/YtgeSzAojz2/AI0BRerxa?=
 =?us-ascii?Q?Thcfc/rzcSkan8ibiHSgsXQmfNsIisvVeYUspGz0c34ITtziYYV48WF8+WCz?=
 =?us-ascii?Q?BxVU8nZUZ9L2oekEK74VNjl2xFdWH4vcY+RSqpEfGbvjQ9BDiA0xwG8E9NtX?=
 =?us-ascii?Q?JYoyC1pLYFFtSQ4u0AHNUmXw/e3CioyrG2V+/XwDsB6LbEuW8xM/P8qmT556?=
 =?us-ascii?Q?FYkkngw+rb5SxSzkxDdiT+Cobc5/0dpz9lEay/Av2bcs6C/vwrTmdi8rObCd?=
 =?us-ascii?Q?xZajtXei08EbrR+mFbVv9sJWpnyds+S7kthiJr/BjUWBchB3tHJ6SKHTvO9e?=
 =?us-ascii?Q?Nqe5cN0S4L/rVcPF0nrMNuk2ifkQjaBfvJ4Gn7iFRws4BAVLIT+Xk35avigY?=
 =?us-ascii?Q?Dv64HGeVllgHU+KEluTWmGu0FD8bXHWu9lPXZSOsXudlr3FE7hxZAIKrmC62?=
 =?us-ascii?Q?aAlu0ehsMAuY5fHPWS6vbN1FJ5vKtzyCcuPOd9NSBFZldD8TIxLPrACMCQ+c?=
 =?us-ascii?Q?fIpxClxSD/xNWNRbGOzY/BDQAcO9w5vzOg7B5R5IIurwhRb/kEzBAt9iM+L0?=
 =?us-ascii?Q?85Jeuh5T5IQLCyz3KII1n/Zrn0FWzwh6Dj7CrO1dWBKhuHnnkvEcDS09ocvZ?=
 =?us-ascii?Q?m9pEGZidqViTjyR0RBT9g//J3bqfiEAj2+JpCHMFTQqqxk8WuFPUF7XcOEGC?=
 =?us-ascii?Q?MlN7ZA8zu+5sPslxVGEpHuJHm20h6pJW18FevAT0cLVm8uouaNsk5iYdK93+?=
 =?us-ascii?Q?xAyIO3U8rrL6ErsKMMv98E5bSzcTFlcjmucbuZ7upSktHrsDy2YaZsuZAPhP?=
 =?us-ascii?Q?KiGsIS+CAezIRgGU8VGM0Pe+oa+uzYSOcqY4wMGIiK96jddpPRnRMfquTJTN?=
 =?us-ascii?Q?K3DCkmy5ihcKInWJ/hJSLluDkChh+tH4NtbCuys9YuyFfJmbM6ijnt2PaAJo?=
 =?us-ascii?Q?QayIF3ugtXwDjwv5omIaV+4wfLE0nUahyMp8qlDTWCTDSQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2DJqhsrVvJY09Gj1Izf2f/KWyEUGLRNxFTxSqpDOW+yruCmc/c363cNPwj/m?=
 =?us-ascii?Q?sGcz9z+V3+Z+Iax+kNYf/UZwGQU+3CSSxznCyn4QHfuxOFdt0hTWA0GJG1Pz?=
 =?us-ascii?Q?cdkr63mDo33eFlc6GntobUydgagEllSmf8xSlqcr3pWDiMrMwhbvs2oNCFVE?=
 =?us-ascii?Q?S3XI7dT25aCkuJDbVnfEFtvWOwmwowAB0S0CxkYawoNADs+RO0bSwkDavULd?=
 =?us-ascii?Q?NK9/ZYf6Ps3aFLYhnTe2+ZX0WEjFAkGgcTuIfwcqjzh3nL7DYC7CgukX8CVi?=
 =?us-ascii?Q?CGDrXB31B6M83lmSvvkEx5wxptze7feS5PzBGMMAkao3LNYTknlqmbI3UlVR?=
 =?us-ascii?Q?mSPzA+Uo5gIt4GtLrvApcSSiQQWbIrpnwOLi0vr7GIMtRHRvAI2X9w58zsPe?=
 =?us-ascii?Q?rJhxpjsDPl6AsTFKK9q8a93btv9g2PucmqEZNJOHThIgdFrJrw2ITCT2cKBn?=
 =?us-ascii?Q?e6wE/BckCxJLuIzdQTf5Ed0gdL7nzRQZ7X+lCexdxtNd6dUOIWvog3FUFLie?=
 =?us-ascii?Q?PLbsxor0ohmlCFCwxiQluScO+K3L9bFnWh3LPRgo2Q3Lbqb72cCr3zvo3daP?=
 =?us-ascii?Q?EM87zxM8BbrysYg2x15cSh+C4IC1MJE8BdyPdf8/oYcnueUp5xM/CQHzEu4R?=
 =?us-ascii?Q?U45SDt7d+Gzqt2PhR9WSwO/GNHsZg7Ap4vLrNiqJyRQq3MMAkNR+zWJ9IgpV?=
 =?us-ascii?Q?MYPO5HNtncfUTSZR+m898mok37Y3WdtfvxLXz44sJKYFQk/llAC8D5YmlIMI?=
 =?us-ascii?Q?OJkr3GomCoEMHhjHOV4rs5CMBLv1Fsw39X25LgjHCHrn1Y7zxNZhVkhYYPtt?=
 =?us-ascii?Q?OjR5SyGVHsNSTcYZCgkiJRTgXn9EjEieRiBfhegd8uiCLQZG8+aoBPg7BIc7?=
 =?us-ascii?Q?krP4X/gG8ja0PQD4jUTJJFpGsNSsUEwe9WWZFwrLaXrMTQvZ2zAGTNU6pj9b?=
 =?us-ascii?Q?RLn+FZR+3c1013Tp1WWGct32BDA9HFUmiu2ma13Og0+yUzFU34BWvgrEeblY?=
 =?us-ascii?Q?5IEkpAKujTqWodURB49BK61li/KedP4iNDVtF2FHvki59SJ3vo6gQfs48H/3?=
 =?us-ascii?Q?8CU1uHm3n/E0PDzq+1M66qe6wQBQfYdFPrE8cAwrrKCy1SBN4Q6CWDscgk61?=
 =?us-ascii?Q?6fnGm9+LtUr6smFki//C82iCBCtwrcywN94vIrFU8xeMjEee/WmejxPwAZ5P?=
 =?us-ascii?Q?sioPGCEQQj9ujuOKfeHtE6RljCOJaekHGo/rYd1B66qhkncCTqKyBx2sOwr8?=
 =?us-ascii?Q?pBQGmI93JOq0BdYlls0qndptPDJ/xGLL41ro9/HeGUGwxrNSYBuT66B1DemE?=
 =?us-ascii?Q?6Pdl0ayD9u2stKh4soiCMYwKih/7ppd3A2n5RbEr2BYtOyqHllVboBGtymRp?=
 =?us-ascii?Q?bFySAEstTPK4Wlpv0zaQIkMrE8qf4veaqa/h9oi1SBqMGhAAxJaT3q9Ilm1E?=
 =?us-ascii?Q?Z1URv6UEXCMJsPQ71JK7ixal14JJYklCe2V4C60kknEL6TWwf99nZbQ+0/eA?=
 =?us-ascii?Q?uQy31lB83uHvNpEaPJ8FS3Zya7xNeIfnEuRGhRikS4UVS0K8lm+Ta+vmrkiD?=
 =?us-ascii?Q?DXWgMxOvaYan+ezz8PezMKGWO5DGNF1nFGizu4jU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b585cac9-a3ed-4680-0e28-08dcd0d503d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 13:40:49.1967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjg7DqS/muBiTJ845ef0CmaOlnBi62ddZl2KitJm4KVfnod/ZTPwjJkboDWj8haG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6433

On Mon, Sep 09, 2024 at 09:29:09PM +0800, Yi Liu wrote:
> On 2024/9/9 21:04, Jason Gunthorpe wrote:
> > On Mon, Sep 09, 2024 at 08:59:32PM +0800, Yi Liu wrote:
> > 
> > > In order to synthesize the vPASID cap, the VMM should get to know the
> > > capabilities like Privilege mode, Execute permission from the physical
> > > device's config space. We have two choices as well. vfio or iommufd.
> > > 
> > > It appears to be better reporting the capabilities via vfio uapi (e.g.
> > > VFIO_DEVICE_FEATURE). If we want to go through iommufd, then we need to
> > > add a pair of data_uptr/data_size fields in the GET_HW_INFO to report the
> > > PASID capabilities to userspace. Please let me know your preference. :)
> > 
> > I don't think you'd need a new data_uptr, that doesn't quite make
> > sense
> > 
> > What struct data do you imagine needing?
> 
> something like below.
> 
> struct iommufd_hw_info_pasid {
>        __u16 capabilities;
> #define IOMMUFD_PASID_CAP_EXEC     (1 << 0)
> #define IOMMUFD_PASID_CAP_PRIV     (1 << 1)
>        __u8 width;
>        __u8 __reserved;
> };

I think you could just stick that in the top level GET_HW_INFO struct
if you want.

It does make a sense that an iommufd user would need to know that
information, especially width (but call it something better,
max_pasid_log2 or something) to successefully use the iommfd PASID
APIs anyhow.

Jason

