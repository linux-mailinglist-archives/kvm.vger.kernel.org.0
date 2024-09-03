Return-Path: <kvm+bounces-25697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F04D9690B5
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F2DBB20FB3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 00:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A498E63CB;
	Tue,  3 Sep 2024 00:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ibV4Vfwl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FB1A32;
	Tue,  3 Sep 2024 00:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725323841; cv=fail; b=Q9/ki0oPRKt+3ZFTAkLfpIqGkQINYTBkcOnG22njwE8cFqptCrbBkkxrmPr/T4bPq4Tw8cECjZ1lAC07sh4SAe4NZeAMKO32qJCBG0nJ1u9kuAhDHFFKqedvLaCruh0LywYMt+tzcAcQjU+LBBHMf1RZa+XHIcqri8/oL8vtLww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725323841; c=relaxed/simple;
	bh=LQuAajeG2cA4AhMRdWnup05EkqIcVurslmpcYPXAIzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fUvG5xRN08dINTQhaFeZz6TAH8gEkr5khHQH91PJ9SgY99HZHNK80Dm1U+vRkkEBPxqTWcNyXlGJp1V68WpNzBvCQkv8/L4TL7af6TXzj7ZXGRj8R3i9kvBZYF6lfHNuJN4lqmcFyReGOtizgPulXVmeMJPFQYx0+vtHp42t14c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ibV4Vfwl; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcVPjKq4QJINLlVdFjoDYxm/VI4we/Ow6KbYvbkECWvxcHn/6kbZnkXPUDKjHWKMPpf5du8KjBrmSRxs+S4+WPi1BYqafd2whp2wcA1IA837KTaUIF7sKKXIt6TebcptdodZpXSmTd4CAC2sIw1BAwMfrhOpmV8ypKCtfH25a7F8/PeDPq5tuGjgstbwqoEsXr+dgtkIikGbMWEnzDWohivW2YMDZz1aqkaGJaackvm8ebYTcY5s+N27A+5JeNGuz1nMYOAVQ8Oc67endc8sYn9i1DQTK0UkIEhICxC4yuNYj4lG2dN6OJWOrRfZhZ1IY8i7kT/8hL8VZOGAB/7bSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHo3P8Q47GMsTWIBI5Fk3fJYq5hUhfytAUEIjWVxiC8=;
 b=Ar71mchzD63q2RsjjdRb7Qtf48lFwL6Lw2MT42TFcoM7K1fEsIJcTBkfaHZCFiqrZMNPshqdLor4GVgY2Iez2SfUrjNrGMlgingafsLL1aodF6lI2sRvLC58IoWlX7FqY11Bm6g5Ut3rCpf3YgiJCa8cd51lBX8ev50YMeL3aOuxwTsEDDaFauRPiNvGoTY6kIneEliAx437KJa14yzzH5sEb3OqgzGSgyve4BZ9MMKujjSHPdc3DSX/v5wDVZCINTa8z3A5lTPqvWu17vmT7xAxColmCJElbKavLInjRKQzUjJ85zehoWIV24v67VFkaRsk1zJw56MOHeR5PVbpGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHo3P8Q47GMsTWIBI5Fk3fJYq5hUhfytAUEIjWVxiC8=;
 b=ibV4VfwlDlNQGiGoAD2cGkJRCPDnALMi2QIC98iTJh1QpCwPdA5lcFYthW+v0R+KdxaeyniYrKoe64t/+ss7v/LjD+BIWmZoMPCM5oIZhdYjtrGOilSpqOHF/FlvEsFfjQtoo7LhfZ+X3/x14fXdbSsqQuiNdHolFt/0IyDPHN063msuEMT0ThGQhfP3zxHeNEKImne4iRBjgWBgQiutTGHpjELHd4odX2M08DtWcz64f1aXbh0GyiEXOHATvuSs6cB3Xvz+1O3M/+x97lgKzpvKVIpyzeI3+DFp2eg00z/iGpm9wTpArrzdz6dUXdaiCNDMr7mHVuhYQWsssZBVQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 00:37:14 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 00:37:13 +0000
Date: Mon, 2 Sep 2024 21:37:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>,
	"dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
	"david@redhat.com" <david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <20240903003712.GG3773488@nvidia.com>
References: <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
 <20240830123541.GN3773488@nvidia.com>
 <7abbe790-7d8e-4ef6-a828-51d8b9c84f33@amd.com>
 <20240902235207.GC3773488@nvidia.com>
 <619bbd08-b423-4547-9748-6e5b5c0543e5@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <619bbd08-b423-4547-9748-6e5b5c0543e5@amd.com>
X-ClientProxiedBy: MN2PR01CA0063.prod.exchangelabs.com (2603:10b6:208:23f::32)
 To CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: 943e7c38-2966-48ac-9924-08dccbb08dfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DNa5/jnxYfK/uyowidHra48E/AmF7NvzQexO5LzmQB77okXpNAOrObrh0dnd?=
 =?us-ascii?Q?wbIViG4Cc0PRraLgn60pVUmGJ1fPhV1bkvQQ+LMFVKvl0ptrvMzyCFPFg4m+?=
 =?us-ascii?Q?33N5CQ3nYlealrgOGvmdT66pcCfVdig3F4r60CaJ713v9RB6syUmGoVVVFtQ?=
 =?us-ascii?Q?3g5Dpu7Vlbv3qUlVVoMLYRaWQly/WvmP4knO2PrvIfapOXuDziV7FA7SuWgs?=
 =?us-ascii?Q?dn2wj2EYGltPJa8SLeoyQ28sWqGtmoVTNb7c7qnvTwlcWKJ3rKDJfnm2UXcC?=
 =?us-ascii?Q?kSGzV3GhOToCCR6kLapBD/Lmx1CIw6O7DMmmt18OMBhKOhYsIAiuICtBfPD7?=
 =?us-ascii?Q?UWzF1IS+4e6/TYXafal12TU3U6INsDa7KSVTx2dTdG0axMBOU/+QU3O0/6MM?=
 =?us-ascii?Q?OQ/cg4jqhKLSc7hgC5ZyGhkITHx3K9vTM5MiZU/twaPcKrt5myJMDMLM73tU?=
 =?us-ascii?Q?uwbCcwaU834oRlAVbQZEbHkqjSMjWpXb2bYGWMwAA02bpYShtJRJKVPfibnA?=
 =?us-ascii?Q?AAhTsy66c9n0Akk7cbsYdba0ocp8Q215paGn4y61LMSmQprUyRT4mCVMK4MA?=
 =?us-ascii?Q?b9gOFu9xXvFu+gN8kpWd2smNBe4xLDreZqZcjIebN4ev3PmetM3NYUOFAmis?=
 =?us-ascii?Q?p6PJx/JFPcNAUsWlcOcoMO/p0ayaNkrdY8sLuYEoRdRYh+yhUOkzq9g3jUKC?=
 =?us-ascii?Q?EqQrvKXhnYLyfwr/RkGNdtCSMX+Tng9p17lUV2cq+4eYAyK0uxhIuhRQR52k?=
 =?us-ascii?Q?shqPYREGdk6Cym30pEwNFvlL2IlIAKoZnvM19i/vGiu1vvrWW3oF0OsoOKot?=
 =?us-ascii?Q?nzq1LaSvVOXI0zNrVI4YEhPCX7JbK3kc/Us7sDuVg6Vyly0pmCLD9gUFZOtP?=
 =?us-ascii?Q?hTuD9PLYYiuI4yDiuqEvDMKKPzaeN1JOH+AkT/w2+nhTytV6D3RAjF6+7Jz6?=
 =?us-ascii?Q?2kYiMLvKk02M/P0w1P08XTQHIIFti7MuCPk3wyVLgFY3h548qe2AHBI/xtrY?=
 =?us-ascii?Q?jLr0oaQfW/GzHwobbKEnFM7N3bbu+GC/sHARwpQzoyUn4jnKAxK4k89oGodu?=
 =?us-ascii?Q?YWCjrpLH1rq+R5iNm2KY8zwt5aQnpqF/nnW+29Uo+DFSSeaK08jt4S5nWVYr?=
 =?us-ascii?Q?sUfcyFRxQP4PrtficXv4+wR68WoN/3cLHqqsFDde8vasbC/poxUnER6ghiP9?=
 =?us-ascii?Q?PxIOzRc4kxVA41BZ4M2m1IiB/DCn4dLYcuIN7oP9oXrdqUq7pGW1Go1eEjiL?=
 =?us-ascii?Q?CW5jaTcaIMJoFiw4mdVWVtzvkrjONJXIkKO3pTFXWbYlifGKD+CTsGUS+Ybm?=
 =?us-ascii?Q?SRsLBpCFhsttfZ/shubkccVob2Jg3LyHyauGVPteKGGxOg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lz+PEVXh6d54bAf+lIVUzZu2vANfFryFn1/Ty1tkK+U364g1q1pZ1iBrpAvE?=
 =?us-ascii?Q?AJxpwDDRi+dvRriC/hmMRPw0EfY0oK+HdgrmoYoEh2oa2tO/m6DIKN2dZFqh?=
 =?us-ascii?Q?ViIOmJ/58g6xbNqyedBiALD2sPOOmA6SXy1kuybbJoEB7VCZTv8/ODr01OPc?=
 =?us-ascii?Q?3rR0PSjv7c6rMrP80P7U5qH+bqccWtcZ2bdGF/Gn4zzlYGrf2O7Y9OEws3pP?=
 =?us-ascii?Q?hrNAwhn4mT9OZuKXZl42VJkdjW7AOPcek9qj8LMprmI7IOTgs1+Nzp3RHame?=
 =?us-ascii?Q?vD7vwb9YfDas8TDoj9gaTyC2Q+Ab7X1VSK84yCSyyNzw6r/Gx45E+KnWto0Y?=
 =?us-ascii?Q?U/PKH2EWeawsKUOSDeFKl7aYTarOk1x/tJ1B+3S5GoZTyAmOoHHWcbh8JOyp?=
 =?us-ascii?Q?oFxx0SHAExhyAyY6gJqEYnlNolUjbaw3ZvZjS1WqQ0fMlX8fqXj1tRmNdkS1?=
 =?us-ascii?Q?EsJFrldzZQbY2nPseJb7H5rc4AoT3sAdw+MrvQTUJ4g0+CHJaLk2gqh/fo0O?=
 =?us-ascii?Q?4r0XcL4ZS+sDBO/sT8eCGA9A41249tOOGcfWE495fBEk/VmnxigkFf2we+ln?=
 =?us-ascii?Q?oEw5loYNKnFtJZ7F53HAEPueSvsPZHwZK1wB0xbO2B+baw6ptVQ5MX2Ir6tL?=
 =?us-ascii?Q?BGMpKaZ+1VaavnRLI9C700K0sNacDn4b8a8gxiGvuqrEZAKm6oV5IBajrPTc?=
 =?us-ascii?Q?WkzpidWEj4PxfKjNbl8eA+lWbQiXbxaqvysDuHitkL2mPTvX8EWMoJbjsVz8?=
 =?us-ascii?Q?ERngffe0dXeYn6ktJdwkViqbJeQLv4QTcf07g8Th/MnVAXjB4rJDcR9YzzYU?=
 =?us-ascii?Q?tbtpWzqUwnn7gDJPK1Dm6lvv/5Cb16bIW2VlK+eiZrw4mpFet5z7Ktj40Axu?=
 =?us-ascii?Q?QUplS9DiOlJ6dJBPv0Kzvjl3NQknIDnWAZvC6LFiZQMQ9GLvqMbJ298x907w?=
 =?us-ascii?Q?HS3daAtAYA5z+3yEOZdqS77Mjw6sboW6G/LvfR1M7oylmLrEBvPcwnJwzDC9?=
 =?us-ascii?Q?fxM5pvO1NoKiuEkxt58JPYLQGgeNgyZ19uzZUNuF2AzGBdME/cykrcxvZJaV?=
 =?us-ascii?Q?jH8SSaKkUVJ9kzKN7MH7O5vx8pxNbTo1Clc1cLHuG+ylm5jBxd8gwG8MyCga?=
 =?us-ascii?Q?MCHKa30lJ4EywfvgBPGzgExPKS57LibuMA+8b3W32i1gTVrZYcIKSJeggdDu?=
 =?us-ascii?Q?UGDDmEc3JlQaBCxHq79rYqZIv9pKoTsFBN1gUT2JziwzvAByjwjgUzyv8sZR?=
 =?us-ascii?Q?xoT2DRFuV+bcnsSnX+JZH4+rfDsl61zgrdJyiUSSH0/hhDpAXKp3Shzospnd?=
 =?us-ascii?Q?YTSrelUL5ePCaHSTC8V77JMmVn//buYYGSDbjNOepWatJtXBzB54oJbp3m4j?=
 =?us-ascii?Q?UhPxwfzY6Vk1v7zQXvANjfh7rhD9X8HknkeMVv2rmoa084n5CTNGnImZtPee?=
 =?us-ascii?Q?usMT36/RFuOF8UkYuwIThvPE0AsXBBsQ6Chd6O1Xt1u5Um1P7luEGZ5XUqSq?=
 =?us-ascii?Q?8Jd1tbxNdMunSLErTUClJ/FysxMS//ooRvlEn1n0aB9zFf/KsvjUgJIgxv9z?=
 =?us-ascii?Q?s5dh/ZDkdUjxVgLV1Hg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943e7c38-2966-48ac-9924-08dccbb08dfc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 00:37:13.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7cuwuBbwdZVWcYDpv7iFkgGs6lBVu8EIav7yd7HsA0tMdKVDI8wjfv6Ev8dSaXT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217

On Tue, Sep 03, 2024 at 10:03:53AM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 3/9/24 09:52, Jason Gunthorpe wrote:
> > On Mon, Sep 02, 2024 at 11:09:49AM +1000, Alexey Kardashevskiy wrote:
> > > On 30/8/24 22:35, Jason Gunthorpe wrote:
> > > > On Fri, Aug 30, 2024 at 01:47:40PM +1000, Alexey Kardashevskiy wrote:
> > > > > > > > Yes, we want a DMA MAP from memfd sort of API in general. So it should
> > > > > > > > go directly to guest memfd with no kvm entanglement.
> > > > > > > 
> > > > > > > A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
> > > > > > > takes control of the IOMMU mapping in the unsecure world.
> > > > > > 
> > > > > > Yes, such is how it seems to work.
> > > > > > 
> > > > > > It doesn't actually have much control, it has to build a mapping that
> > > > > > matches the RMP table exactly but still has to build it..
> > > > > 
> > > > > Sorry, I am missing the point here. IOMMU maps bus addresses (IOVAs) to host
> > > > > physical, if we skip IOMMU, then how RMP (maps host pfns to guest pfns) will
> > > > > help to map IOVA (in fact, guest pfn) to host pfn? Thanks,
> > > > 
> > > > It is the explanation for why this is safe.
> > > > 
> > > > For CC the translation of IOVA to physical must not be controlled by
> > > > the hypervisor, for security. This can result in translation based
> > > > attacks.
> > > > 
> > > > AMD is weird because it puts the IOMMU page table in untrusted
> > > > hypervisor memory, everyone else seems to put it in the trusted
> > > > world's memory.
> > > > 
> > > > This works for AMD because they have two copies of this translation,
> > > > in two different formats, one in the RMP which is in trusted memory
> > > > and one in the IO page table which is not trusted. Yes you can't use
> > > > the RMP to do an IOVA lookup, but it does encode exactly the same
> > > > information.
> > > 
> > > It is exactly the same because today VFIO does 1:1 IOVA->guest mapping on
> > > x86 (and some/most other architectures) but it is not for when guests get
> > > hardware-assisted vIOMMU support.
> > 
> > Yes, you are forced into a nesting IOMMU architecture with CC guests.
> 
> Up to two I/O page tables and the RMP table allow both 1:1 and vIOMMU, what
> am I forced into, and by what?

A key point of CC security is that the hypervisor cannot control the
IOVA translation.

AMD is securing non-viommu by using the RMP to limit the IOVA
translation to 1:1

But, viommu models require a secured non 1:1 mapping.

How do you intend to secure this other than using actual iommu
nesting? Presumably relying on the PSP to program the secure DTE's
GCR3 pointer.

Jason

