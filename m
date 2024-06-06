Return-Path: <kvm+bounces-19010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FFE8FE5DC
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 13:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBBDD288B76
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45073195B0B;
	Thu,  6 Jun 2024 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ekkw8VGE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C923F13D28C;
	Thu,  6 Jun 2024 11:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717674911; cv=fail; b=QVD7G8TO1wU22abAR588gR5OGQYxY9zJKZxFBrUP26pIKGFRWE2VMcotqyrOoH/l8+9U+YtSwTcNeV/08FccEvRtDwYyd/+r+Ea78lbqvsqqHnNJnp4XtOCQVow0drIleCM42sQmrMeGP3of0KM+oc2LYKZX09/VgUraBOTmc/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717674911; c=relaxed/simple;
	bh=LAHFNNYPLXX8stQX8md53HD9RhBmZac0U5mAc8hs3rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ibeJ82ioTikSfkRUeXhy/X9xvYgAy0gEas55UBV0RimePHe1esnDZzji4NmX5u9ll+pY+UkvpVfsJr6f9AMhePEWPFZmcZiNwe6KGUaJ0hV8sIwiwUOYTmdHt0rJrlksotNA3k+G5/6O7oYtaYIVrlodf/MupoQjdZtMRT8zIAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ekkw8VGE; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1df2fbdrQE8xGDD3CtmKA7kgQH7uVfUHFKyBnWuV0DpBViTSMO8UZX8GckIo9G47B8XoWXEERKHcWNKH0v5ruD0iBxQQ8iTUutOnN1UsYA/zW3ESD1J+7eTIYAqwhlnFMl217qJvP2O2H2Ak/rC/h7m4osHTqy9FTCPqylNX/VIMveGMu+kwVpA8ZcUWifZSlylWZsPaZwRgCuNgtV48Da6dUlk3B7JAUjf0do6fFZEsAOKhtR6DxdyxGPNHsKrhl9RY8/ylFARmj/kDD1Kqt9WpTzulFYvGD+WnAYRNQoQrIGXE8K8VTk/nZOWy3p0UW02GBPHOatef7lClcYmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EASVH1VmbtdqnGevT6o0++PgCNjRcfgLEmPp059tB+A=;
 b=VfpZx+D9IJFUI3W6JzW/CmBEGEtFyI1marAJabE/2LYuvhUc16uiw/PC0IJYPZA+vpfGpOr/tEEDaOiKWZ30cUwDgvkouOdqGPUuEwYDPQnjZ3b/ty2zJ/9xxW6ixlmJ5BGKMX18ldbeIWYZlTnD/mpaFkZSxqqXKVAtwbJ1Z6hdQPf8TRf3IbM5CASpbHTCJZnO5qMLJZspz5Ye0jhCpuldrfJ/3fyzzGEQwRrXm1ZN3tkSG1Jg9JjBcFE3BmUmU3wCSlPpjqq+lvpD8qtDx+nAIaHTyohEZKxjx5ZSLuGecN8hhDQ26p4zJWOc1SrIay1pulYYDI9fEkcCMtpEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EASVH1VmbtdqnGevT6o0++PgCNjRcfgLEmPp059tB+A=;
 b=ekkw8VGEmDiXrPuz8SIB+vtmoq4PODwmXHlR2PunXusnSCpXSLUJMFLOrY2ahdfYllelVhtwnWdv818uqp+BGDrTpvQfW5kPigcL+BmMtyHGfwHcKMBOAarV6vhpduy/XAwv6bP7cgD/uod6ne/f4jNTUvDQRDfyp98RM8aLNnXXWohriJ1yZHLTFew/CDTZjXqbgSsi3FnqUCFLRfcr22n6Qxucq+Y6NlMuOIdeC/lqXTRSIA6msq/B/qfa8gnOjk+GGh4AIsCVYhcfuHnDWXteISPq3GP4rmIWj3jIzc2e44Wd3FSIxssYj0x0gCn6+GN9NVyED+lait7DDJ8c2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4371.namprd12.prod.outlook.com (2603:10b6:5:2a3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Thu, 6 Jun
 2024 11:55:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 11:55:05 +0000
Date: Thu, 6 Jun 2024 08:55:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <20240606115503.GZ19897@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
 <20240521160016.GA2513156@nvidia.com>
 <ZlV7rlmWdU7dJZKo@infradead.org>
 <Zlt6huNJeW8ekJlE@nvidia.com>
 <ZmEjavnYePBLDbrS@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmEjavnYePBLDbrS@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MN2PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:23a::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: b8dbd145-c0e1-4eba-cd13-08dc861f8116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZlSkBZ5XRQfqF3HV6n8UiGBnN4ogwOzPAt73CYmBP7wk82WLb8HQItpDWaS1?=
 =?us-ascii?Q?oB/usI+n6S/pAhR51APULR4dFGjnNG7r+vHJzim9WktGoP15KjGsdcbIgd+/?=
 =?us-ascii?Q?ZKszih9UvUKjkcXWezesPyw6lbEANkmGtJyiQECiKnNJGRLM3hylo7IjN8Du?=
 =?us-ascii?Q?xjLp+9ykjgdowHZCWiSe3RyFzb8+SryaMG2//gUXH/NM8iibNZ9ZmDlCTijR?=
 =?us-ascii?Q?UWL2cvdegw6nAFqS3oJkwFBv8mTgi989rpnM0dnQ2sx3OzzFpGaFMlau7LG2?=
 =?us-ascii?Q?/F0MdSx3QvebvK1ezXZAJ1rgJPPqFo8b4CDuDOcsoHhulwtmTCVQyiw2Zm1x?=
 =?us-ascii?Q?tpM0z3Y6gv+daoyHUlr/YJl9HLOqHqJM2dgjfj8SdxOVIWzCGWXo831SNmUD?=
 =?us-ascii?Q?2fYiH7Y+hB7RP2ECDsSLqKdEBw4OO7fquJWrXkH0fEKvOJI+h2m6QzrZ3Rft?=
 =?us-ascii?Q?/d9AfunRcuLI4lX97e2SoZ3nwCifW1EgeRI3tR458ypNSEpmE9yAKblMxGFX?=
 =?us-ascii?Q?XRps2IqraX7UnBcU8Zmsk/CncPAPlIuGfCJyPdM4JGan0X6eegaZ7aW0SpcR?=
 =?us-ascii?Q?zYktHpXvpmiWr1zGGSjUAfUMK4OXFgCAFaiQnXcNqeZG7ee9//8jWMvi4jbB?=
 =?us-ascii?Q?asWDHX0haDE2bxI4KT1/09puLK9euNijgLnzC0cfkHdXViPytXvMeJoBJUfy?=
 =?us-ascii?Q?d2hc8Vn41C5hLNX2WbXTA/NxYVPJ6eNTTXjtv2W/qNJIl4VNYYzS82ZpV3K4?=
 =?us-ascii?Q?1Cy9QVB+ccYXjrxPC+huizG46Hh2VSHBfdFerG4b1xwSAFfIaLznMUdBSbM3?=
 =?us-ascii?Q?9r1A3/6GBIpoDS+0x0TgeGjPLUIIx0a7Pfvlu6Ncy/0fOWxPyZ8H1n/xMNq8?=
 =?us-ascii?Q?gyQ47w+s4d1miHggwkr6ZvbmxT4voCFaHK/P5GVWR2DD8AeicKltpi5K6YEI?=
 =?us-ascii?Q?NvDrGEo9eO/eNth2HRVAzaT9E3ByByzMNPiITyNQjcq7FJ8JQ4ig0PHSgSQh?=
 =?us-ascii?Q?CwqyYEE6JqjAJob9P1S4Qy5aX6TXw0Qhy1tvwb0sds9UDBevGS5idEXo0o2p?=
 =?us-ascii?Q?1B0wzQZ9BHSd/ic3wTuA8fCM15XKo9z8iTk7sTiKDkJrzLYAP4ibOShkNk5w?=
 =?us-ascii?Q?5sI66Rbsp6DYBb07jb6OiM2xBViC95Eorw2Gr8GfMcMUrC06vl80nlrBAzvT?=
 =?us-ascii?Q?SMa+Qj8jUaFDum1fRquJi+GkzpihkxC500KwBKuDHgGqpVUFB56x1XCFMp9g?=
 =?us-ascii?Q?zpGs6JnvLocSjimkRAlfDF6nPHd9iWbPQKvbZDk6dRqr8CgfizjbX+Cg6v5g?=
 =?us-ascii?Q?UzmFNO4yn8l0sB9+EpXYzG9+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7IG1awX2rOpgLEOvkba20ylMW851rxc+DmVaBEj1x2fNQc1V6S/ZwEKvnqm2?=
 =?us-ascii?Q?QaKjjuPDOAFHelZqsvFRp4nwhA/qKSJiXvhjkPeJ7WNYjHXUJKpNu3ljO9Ur?=
 =?us-ascii?Q?WcG6fPTLVo/QRixEfh6/1z/9xTVBrVoI2yYKgBV1gbDDxkAou3Jnt7i/yeO4?=
 =?us-ascii?Q?6OkDNs/K5f9tH22/2TlIwBvjKVqnxAcHQc0OPZwIlV1SKBqnZHHGL3CEIdbh?=
 =?us-ascii?Q?SQmcVJRjA1fh7CDaJeYe0u4LjpNSac2l4c2iHNujnz4XGRNA1Ztdw/ZMQ8Il?=
 =?us-ascii?Q?+6zATncyHHvFgr+1r2CW6OfPBzw+8iOJS3aJU4rCwVY/3FGR0rdfgNyKSazu?=
 =?us-ascii?Q?JQgLWZWNWoRNT/x6tMMrPf3YZ1SoCX/zCLec/onXACiGJZMvSGJybFcHNuUd?=
 =?us-ascii?Q?pcdNcyfqL0+fswUmrYmXPkeF5JDo3x8cmra6+CZYqYVID1dYrmiSIoGNhwH7?=
 =?us-ascii?Q?pAZp0m686CPk3MUshX74WxZNfqgxeQXKVYdwcElwDaAaM87akenAOHJ6+Eh6?=
 =?us-ascii?Q?4uPkofpdrv3EmpiV8RpiQtkGKQTmtSP+rslGJTZ1qsItOayqGZVyTyJ5Kssz?=
 =?us-ascii?Q?QPgX2U6POdgje/kwUEBi1rxx8uw1uV6QJ4Lqj6seHHTRBPG1HeTjJgCV4hCO?=
 =?us-ascii?Q?BA/S2YjoP34v7eBfW5LBFOX2rcwdQH2jqLE3eOzD6jwlpaLtW2wznu6Tj3sZ?=
 =?us-ascii?Q?KHCfnRPNq1Wzvr46HMlf06YX9FZm3DQ9An9pkzPcpmHdKTMkwaomcNbt7q/K?=
 =?us-ascii?Q?Hcvl3feWXO5mC7qSH3WEHlQSXCNtEN0FJWj4dDEuNMytDjRK7VEjajQ7YN6g?=
 =?us-ascii?Q?+CguNkr1ZEz3DOSExcc42r2so/6DD2yojRAHFjRK1ZJs2qlvwHvDgq5XOnyy?=
 =?us-ascii?Q?qc+SJuWEIGOq4rFKXOa/dSKMpdSzikahkS51DW47FMfTMJvI6Qg6dfJyuY3D?=
 =?us-ascii?Q?4tFZOQ/gb1pyVkzqKwj2nchT5E8YUb5HHnym7SL5sd+FM+jfal/4bmTd7cr6?=
 =?us-ascii?Q?TAX6riMByxoKTIYlwpIqoupBv89ADSR+wiLSk2LBgG3+3TuSY+IEeWJ/v0KK?=
 =?us-ascii?Q?F/eK5vRS6N6JCm5gyJv2Ifp8s+f3Ir3LPI1337kw+yT/47cC6ayT9nny3c12?=
 =?us-ascii?Q?8jwLXitR25K4x4dcEdQj4qf/4sC2Ste44mkdIyOe9WLrBRtv3Is0hKxmmjDI?=
 =?us-ascii?Q?dr5I3A00BB9l4bhG/2X9dVt0m/klpDy3xD8jVI0kMWHLGcgtCxeQjVan8pYJ?=
 =?us-ascii?Q?LP++gZk3KttgY8O70GcEl5cQ/SqHb8ExugUSE+VBCUmmFxN1qG2CBxXAW4Yo?=
 =?us-ascii?Q?qlcSHLssBvG2F/bJfNRExw1fWi4ISyA424k0ze5rDrgMPTcdoJjgXok5BRaH?=
 =?us-ascii?Q?q7oD6dDZ+uIrOZ1T85D6ersP1P22xKvWR59DCFNum4MmmdVAyRNaCEHDv1L1?=
 =?us-ascii?Q?79BW0f+O/0FNGzaYjpIb1MkjKmI0UImo/vbWKq2Y1X076qx7dt3l3m3lThyF?=
 =?us-ascii?Q?DLct25uCgFMWog71YJ0WpmGBxP2uTR0r3Zvj11FpPAgJEJls6eUw0pcuUgP+?=
 =?us-ascii?Q?Y8QfsY7dOIFJkwn7RBw/KiArZoOYi7fN7QxMm/ps?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dbd145-c0e1-4eba-cd13-08dc861f8116
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 11:55:04.9681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbM8tDNfm0TocNK8sDMbKl7/wnpE4eV9Rrpt5CCEEZTC0VCB1zkI4gxEOqzh/vdK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4371

On Thu, Jun 06, 2024 at 10:48:10AM +0800, Yan Zhao wrote:
> On Sat, Jun 01, 2024 at 04:46:14PM -0300, Jason Gunthorpe wrote:
> > On Mon, May 27, 2024 at 11:37:34PM -0700, Christoph Hellwig wrote:
> > > On Tue, May 21, 2024 at 01:00:16PM -0300, Jason Gunthorpe wrote:
> > > > > > Err, no.  There should really be no exported cache manipulation macros,
> > > > > > as drivers are almost guaranteed to get this wrong.  I've added
> > > > > > Russell to the Cc list who has been extremtly vocal about this at least
> > > > > > for arm.
> > > > > 
> > > > > We could possibly move this under some IOMMU core API (ie flush and
> > > > > map, unmap and flush), the iommu APIs are non-modular so this could
> > > > > avoid the exported symbol.
> > > > 
> > > > Though this would be pretty difficult for unmap as we don't have the
> > > > pfns in the core code to flush. I don't think we have alot of good
> > > > options but to make iommufd & VFIO handle this directly as they have
> > > > the list of pages to flush on the unmap side. Use a namespace?
> > > 
> > > Just have a unmap version that also takes a list of PFNs that you'd
> > > need for non-coherent mappings?
> > 
> > VFIO has never supported that so nothing like that exists yet.. This
> > is sort of the first steps to some very basic support for a
> > non-coherent cache flush in a limited case of a VM that can do its own
> > cache flushing through kvm.
> > 
> > The pfn list is needed for unpin_user_pages() and it has an ugly
> > design where vfio/iommufd read back the pfns seperately from unmap,
> > and they both do it differently without a common range list
> > datastructure here.
> > 
> > So, we'd need to build some new unmap function that returns a pfn list
> > that it internally fetches via the read ops. Then it can do the read,
> > unmap, flush iotlb, flush cache in core code.
> Would the core code flush CPU caches by providing page physical address?

Physical address is all we will have in the core code..

> If yes, do you think it's still necessary to export arch_flush_cache_phys()
> (as what's implemented in this patch)?

Christoph is asking not to export it, that would mean relying on the
iommu core to be non-modulare and putting the arch calls there with a
more restricted exported API - ie based on unmap.

> > I've been working towards this very slowly as I want to push this
> > stuff down into the io page table walk and remove the significant
> > inefficiency, so it is not throw away work, but it is certainly some
> > notable amount of work to do.
> Will VFIO also be switched to this new unmap interface? Do we need to care
> about backporting?

I don't know :)
 
> And is it possible for VFIO alone to implement in the current proposed way
> in this series as the first step for easier backport?

I think this series is the best option we have right now, but make the
EXPORT a NS export to try to discourage abuse of it while we continue
working

Jason

