Return-Path: <kvm+bounces-25804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD8B96AD29
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 02:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F54B285F73
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 00:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2EC3D66;
	Wed,  4 Sep 2024 00:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZvfR5PBv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8CC645;
	Wed,  4 Sep 2024 00:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725408151; cv=fail; b=Ul+uSq4zct4dSsmDonzDi9StXVozDY9K/OV9Ud2XlMdc4sZZ95RglcVRyIPkQaNE9djj8ba2+Aws/mDVKKcON7qG8YG58moLYWAcJbtYb/F7RU71M7CXVvfjt1ym0u88vphex0jIF1pguOnfKw39iLB34bduPmAkCCqeNp07cFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725408151; c=relaxed/simple;
	bh=huwyzsP4UMJ8wtueiQnXiJF41JoR3X+BKHmWA50rqAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jUUY3yd7DBgrUhW4W59T9YORpSQvCMOUiybsBXrT+a1d6sMH02CaLu9XENp/xBxo8GBo33iLCWVcSHR5v0zHTJAxohvwwtFgkp0FLQ6YugMmygofoWoRhmVxepmgkNhaS8agke7Txi3aPkUJcx7gl0SK1E4hPkRAx8Fe/cmT1kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZvfR5PBv; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5YVVuwh6PT9279XNqX2HUf75CoqjA/0Shbpq3F6A+BSFFTthsCk9/B4l2t/6DD5ozX65Bt9VQur8RU3PtuahA3qCnRH6/ANLd3+hI5RQHujuh1BbsFudSMB9dsSYuV58q/YGKSwNKElPwfPjC7DaESGsFCZgMLGX61eULcx+Z9KLgLLjFPJOOkiSmX+gjWlmDTjll9yZdg5PQR0oMz5LGIqUBO6h6CLGWWRGbGjf0eQvVRd3OYbXSQARknRg7fOO0prUCtRc72d0L6Op2Zk+2tNP2IAtaTYQfQHOTzNHChhrR/Y7wGKQ96tuyA3fKQtRdlAymAnz44eCoIzM7XTyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBEozuwg39HpCif2K7uEc/tW2GxoCIAeleHvzLF92fQ=;
 b=hG4kI4iIol6oeVDGr2e3qEYDB3rHgCskN+dMPFa3gG/ffq0ulYNPZmieD13WDnV01r9eTMAh/rG3mtruZAnCGNj0GosvmGp30URxT1lPv9HtpeyirSSF2L728na5G5CvkvKljtJllnueCPXrqH+xzN42zepQk/TfctxD4YuD5Nu5XCc92yvGwA5VYzY5yI5wjz/vY2uPrQ4bqZTMhjuaeM8/JirnSmrlB8x+TGDrkocN4lZNwiSVXrWf4hR4ZZEawM8otXbQnRCuflfimdkT6H7EOWGYfHSekGvxv8H8ZR6kb63Ixcw/hFJz3kzlMXAh+fsuJxmS9d3X7ZhNiBfeag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBEozuwg39HpCif2K7uEc/tW2GxoCIAeleHvzLF92fQ=;
 b=ZvfR5PBvBA0iZUjwu0ZoXyNa5ROJ/k2BlPPGElo0JLtnNpKNjLdScnmi46PWH2EVapNFTdyJ7cKtH+0KP/oTF/qX7Ts1HvKeNvQVxjJxobF/AdEa0zupjhPU1GhL0Qmc0PqxFSZRxvc3cH1BOYqHWv6dcU4W2X1vQBw2CCWpbpoHQAIwezXuUmg2cvxizuapqFgD7xTcrmr99tY+avwioSQd7KSSilGkdaiKKJ1hEaus64XNFuwrigmWJm3tHh5pXBZrnuHJPmU/0u2WO3JSZJImDd7zgev1VzUvT17nJRWdVSZ57mj/pIHOdJzRQ21QDEj+TcBcW9pYS42PTw6qsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB7873.namprd12.prod.outlook.com (2603:10b6:8:142::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 00:02:26 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 00:02:26 +0000
Date: Tue, 3 Sep 2024 21:02:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20240904000225.GA3915968@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: BN9PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:408:fe::21) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: 294924c4-ff1f-489e-b024-08dccc74dc74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WAhJoICi1bjZsLGpz1EG9NwvHGLWYP3skMey8QDMLwOrNd7WJ6Mg9vQKk48U?=
 =?us-ascii?Q?HazB/x9nBqtuGfWxaTwnaWK94mOr9ywfQWMFMimBCpi6nZxkv+wbbFZ/A+WO?=
 =?us-ascii?Q?Jh7RwtA2B/Q+r9ILSvNO6j3TOVCo3Fw87iGcwuhvMPsUvzcjdBymCNp6csQA?=
 =?us-ascii?Q?5aQTWtcJyehm5Ensp8n8IIuOYA65KJPIvjnau87BlE5ODWjfP2E6xuZIZtaZ?=
 =?us-ascii?Q?dH71HaJKpLF9khe4PK6rHioFvaZNqlCeOHwDfU2kDEC8oRd/QANkMXIG8LWg?=
 =?us-ascii?Q?ikcaq8W8YsImeCQGgQCUusq9B7LJrCGcZMZaL4J9piqcnu/BhAy4BJYGoMZI?=
 =?us-ascii?Q?UdYGN9cUt0IA54//jjD74ChvdveCYmBm+qZRPa8bVKE2gjNu7GSHH8N2lO4Y?=
 =?us-ascii?Q?SicDEqbNHOLKclv1MbBji7URLQM+0nqbc3SCPBN7eTemEiYVgRqQLdw9L3Zx?=
 =?us-ascii?Q?d3GrDh0fo81aJci23tigDj6nCdPA9/lTz0+atN2E4B24kRlCTqAbWy78ueuX?=
 =?us-ascii?Q?FFfwgCIT0jC7J1dRMxTsxMVVSZjyR3D+0wbZ0Ni6wOqEmBCOxL1SftFXysgd?=
 =?us-ascii?Q?lTpj763IDMiwCVXgf+x5gCSKSsTkcE3ZuzWtxR7CGoZdKQUBrh0y7Nxs71kO?=
 =?us-ascii?Q?Lq0rukwVVbpBjwjVbgT1hnvJRPHM2Jg+1L7sbK54/eQm/7y1YCjnWyHcYLHf?=
 =?us-ascii?Q?maj08BIDl6MHr+SfR0GA/PdrxOFHVO3grdGoS8IcnMsdnCEdZ14es5M42fQi?=
 =?us-ascii?Q?4WqryHvQkH/7jFMQJi+zgs/GvlibUKoQVyCG9IMNjQve0zEAntZoAd4w0P1b?=
 =?us-ascii?Q?Gq0Vv6JHbOljixudyc+ewfIm5K2sXs/BgWbtwcWtEibvb6jHs61kso85N31F?=
 =?us-ascii?Q?JpNPWJQDyZchOptHGZHMhlhqI2G1j/f/ck+khb+6+aj0xuBHpsr6GLGfP4pX?=
 =?us-ascii?Q?c38Tld7Cq1YrWjxnKaxfAhiS14nxRjLy44rg2BgGQWt5Ce73c/mrtWgNR1RI?=
 =?us-ascii?Q?P+cm+mpniE8kIDPHU9+8/HYrPw3IP5o7wBeAciPVtYm2CJ0dr2Mhaeey3GJd?=
 =?us-ascii?Q?KPaLumpwd/Jfci0hcZuoLzGYDxk6+KTxuhtoDhGdnK1Eh+Uc2G/f0q6HuhI3?=
 =?us-ascii?Q?4BNvhMwrriAKrPzegHFCGhBAx/aAbCC/BXncdnOokZTgy3yQ7IkWSJq2B0+6?=
 =?us-ascii?Q?LBkZg9MEmTwRPcsKevuisBz3A5bX6TeYQwptIdK67if9v5tLUhhDyUqJDKnr?=
 =?us-ascii?Q?dlpdzbbJqy1RwVJ887tgKrxP2HrEe+3y7SzR2O2g9lv0Veo/bwJGfHl4DBlW?=
 =?us-ascii?Q?KBIAC0VhZr5MdDw+bw7lebjoez0eV6KJFlR6bYicz3OmoA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NJ0eyA6m4GdNss67m/gDMTNPOuJTbAHHiIACM7N3c+/BecANiDcVCtyFArku?=
 =?us-ascii?Q?H5bYDcPnkosAzf5yEftLZxAYRIrgIiURx9C1Nwht1n98pXVLavz34tGcDI76?=
 =?us-ascii?Q?u+WwKVwA7l3FwUOIPA3eKbtDiWTHzgLtt6/7hBUAkvEE2ayy1nz+FWATiovm?=
 =?us-ascii?Q?GEgWsf0LbS4T0yaupGgfLzHngbMzDcqKsDjMFb/Vhddb3hBz6CAoZlLLB+Eu?=
 =?us-ascii?Q?WvS6OR82M6AHe/7R8IcoWK+elCA/gtvMzU3ihu7eVUmjLjJgxH3zntAvRc+y?=
 =?us-ascii?Q?IGSYVbdr+XYPzC1ftzzBhM6VRcbsnygvWICBYjddhe4NYfrwc6clBIHV8NUn?=
 =?us-ascii?Q?w/PJf4+qJ1BZ51WZ2TNUzW3icpQC/XBA3E5ZJNcmugHGfQ91tpB56f85J4pb?=
 =?us-ascii?Q?Ow6vhsgL9Q9IM+AdW0SjZnOahwvSVDP6s7o03yZIMyo3r8pYSJE7NLy6f2sq?=
 =?us-ascii?Q?QbaJ7uBlpbdClJ8QLRwQXDKsREBa26sLD+FfzYQSr9gs+tlyJodfsY3RmUF3?=
 =?us-ascii?Q?4RmKZWAGKGtErbm0nZpm0IOhY2K6kSgNDgMBzvs58yR+wbfJV9qAvKE044pH?=
 =?us-ascii?Q?uwpGpyBeC8DHdKad+zj8CxrVJvfdNtF42hbpzwf0sVHHHSSyWFfMg5TPMxoN?=
 =?us-ascii?Q?Qt05ZKZvkximvoSvaCS56YE+mkK+rOGkpB1FYtqjho/DfuT/lnDpDLT/k+Ao?=
 =?us-ascii?Q?hdqrColEyZkCHs3Pc3VZ701494vChcwgSAv2LYEHa1sxqAcwErYHaMRDnPhr?=
 =?us-ascii?Q?VF9V20tEe71/QKOo/54/zjG1F+Ut7KXjqjySVT3k5R1aA6g1lP/zH7wI3TGy?=
 =?us-ascii?Q?s+eGdxqgrxKz5/3021o8ayBQlYW4TSeXYl24AM6W+bHPJnzpELObCaW7VOZK?=
 =?us-ascii?Q?piecEYFftFMtWOcP45YtXhpwD/gReayefV5CFVTrwJggtsFdyBs+JOY1H53e?=
 =?us-ascii?Q?W6/zuUXaslhhh6fE0xXYh62ZidywV1gbSUFwwsYKhby81MODjVCQGxy8CTgt?=
 =?us-ascii?Q?CK2+zbeDOWd6PD0LbNVaJs3e7WdotlzIfpcHqLp0SL8qQgnACNqbGJLRjL9f?=
 =?us-ascii?Q?rjK+8GdBXFK6Wnlt8QkkzHoUlRvzHygKQdyjelMgwEdGuqeKKN/pD+VuAIep?=
 =?us-ascii?Q?eiFxiiuxsMuA2vEmoqQHMRPhFhRB94xNGe0ha9+tRETmszGHmoFIl7mlYnRS?=
 =?us-ascii?Q?D47UIfwqZshRY+1v2ojt+Y9k9pEFUtH8uSaXWBZY1zp/txRejapWEmWXgvJU?=
 =?us-ascii?Q?IdbeOzfpJsXbPy9AVFDX9XXaPQX+5IoZaoPVrTbUMJWtsLnlFvIAf54KwJWx?=
 =?us-ascii?Q?K/VURR24HGs+nk1iPwhADhtgt7Dzlm+eetiNhcenMXCUFE1ddxrVo7PXT5Rr?=
 =?us-ascii?Q?IGpCY7AyJ+FXB0EULwTCKZOXpcPc1QEVf/AWZZom9mtBG23cfHQY33UIxsLU?=
 =?us-ascii?Q?IDo1GalJ8SmnZhN/MqynP7vD1YcFvrP4JI8k3U+prIdPoRSR5E9X1O1pg4RI?=
 =?us-ascii?Q?Ch9aQrllU/8hMJsZ+CJz4exocPSngC+dNLXWsGxla9KuMSbhp+vONHcOt3jY?=
 =?us-ascii?Q?8X1VpuiP7Ic1ZPLWGRk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294924c4-ff1f-489e-b024-08dccc74dc74
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 00:02:26.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugEetvxx+O92nh/6UZZFvUAwcSzQmrpNnlj6JpHbif4xZ0tIRuy/33vcRraryHF9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7873

On Tue, Sep 03, 2024 at 01:34:29PM -0700, Dan Williams wrote:
> Jason Gunthorpe wrote:
> > On Fri, Aug 30, 2024 at 01:20:12PM +0800, Xu Yilun wrote:
> > 
> > > > If that is true for the confidential compute, I don't know.
> > > 
> > > For Intel TDX TEE-IO, there may be a different story.
> > > 
> > > Architechturely the secure IOMMU page table has to share with KVM secure
> > > stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX Module
> > > ensures the SEPT operations good for secure IOMMU, so there is no much
> > > trick to play for SEPT.
> > 
> > Yes, I think ARM will do the same as well.
> > 
> > From a uAPI perspective we need some way to create a secure vPCI
> > function linked to a KVM and some IOMMUs will implicitly get a
> > translation from the secure world and some IOMMUs will need to manage
> > it in untrusted hypervisor memory.
> 
> Yes. This matches the line of though I had for the PCI TSM core
> interface. 

Okay, but I don't think you should ever be binding any PCI stuff to
KVM without involving VFIO in some way.

VFIO is the security proof that userspace is even permitted to touch
that PCI Device at all.

> It allows establishing the connection to the device's
> security manager and facilitates linking that to a KVM context. So part
> of the uAPI is charged with managing device-security independent of a
> VM

Yes, the PCI core should have stuff for managing device-secuirty for
any bound driver, especially assuming an operational standard kernel
driver only.

> and binding a vPCI device involves a rendezvous of the secure-world
> IOMMU setup with secure-world PCI via IOMMU and PCI-TSM
> coordination.

And this stuff needs to start with VFIO and we can figure out of it is
in the iommufd subcomponent or not.

I'd really like to see a clearly written proposal for what the uAPI
would look like for vPCI function lifecycle and binding that at least
one of the platforms is happy with :)

It would be a good starting point for other platforms to pick at. Try
iommufd first (I'm guessing this is correct) and if it doesn't work
explain why.

Jason

