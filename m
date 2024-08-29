Return-Path: <kvm+bounces-25346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F7296442E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D827F1C2293A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85FA197A99;
	Thu, 29 Aug 2024 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bY/i1VDu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4592F194C86;
	Thu, 29 Aug 2024 12:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933766; cv=fail; b=tZDSW+egC3+87uAqSNlf3HKKR20sSExQC5W6dSP8t49zH6FZdG3Cro6X8QCsc5frW0U6fBp6teHy/5yIylpgnkXQ8lrfl9Jz4RqQCD4R8DAH25xU5AI4rYeLPI+tBdp3Kc2ePE0asbe+hLdSH6MGj1KPbbv4jsZ+/WcykvFHAgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933766; c=relaxed/simple;
	bh=aWEQN24TeDkqjuTGdTv2SrBANXO7ODC++7n1ReG9HLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m9SP4xbKMSEYe4uIpuCnCEzLrrcdnbu/qgjcSqiuYM3f2E2yO7tYKTHXPb+NqOvBb08qaFAKe5VbMmObxiCmRSIEW0Xx4JgbBln+ODQ6/pIEnbpdGhcIlcweU/Sw9OL1FUNjWHKADPIS3cHcPXoQc5Q8NlRBO/JWtNxIBpmVZKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bY/i1VDu; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjssNvLyeer63z24otwazssA9fsJJ95zi/ndyVbZ4be+F8g1l3U1V4APLjbLg0V13PtQnVMTl6P68EEaAMMY3jE5A91/RUd39FVVkgY2e8kmZuR8LX2PwFwAdoWCWMt47lz+Y+50XZRvOHWUFDLrUB2AADgOBKKICFcQHZw+6G47D5JhTepHYsQQamauXDdOtMb27Wo4bD6T2ej/tKFjai5x9c7tYrhQrYruC8MdjNc45uT0IiHo1ahUdQ15LnxBCiHqB3et+2VURH7/TPZymWrw1xetLt/k32Mhct8YEphJMLjCLQ8FU89IbRUTMJ7jDsUC87t35U0NS2w1UMBfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lsa4FBNQVe3s95oCrtrrpASSp+IB43Ep+SntCCsJPAY=;
 b=RZZQxevhGvGk1EN62op1avBt1Ujsu5VpXC3I+RmrJcFMauuvxp5Et7XFSX3f6hvtORAE5c0M9aIbY9Kd1F3sq9GBy7DfmZL3MInc6xavafJRyIcsh498rCBbdvSlNXXaNQMkgHDMjae8N38jlbLXYDvpn8wJY4vi0BORUxxAThhVO2ZKJCQGGQILt5ykgNtUZzCuKNmgVbpIZ5BgGy8xrRtlmURQ0ZaHBJnkK4+D+yjoXrZgK3scXDOmsT0mDjzZNHDS+KYRCqfaIWFP5xyAewiAp3gQVeHfvMbovm1y/+R1XhU0pSTixciQV2lmB+1Rbva/DoQqJMZMZ8tkdXw1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsa4FBNQVe3s95oCrtrrpASSp+IB43Ep+SntCCsJPAY=;
 b=bY/i1VDuRWTFAmk0COxXf27KiiQiglMifCmwPvnYVlfp1doO2XPUwQR6mvEl11/hTelB20wkM59ndZqLSC6Z0GUyBZTdYmdS4oS5trG0DvzT2ts6gCxizt6EdPAvfM3LGmqvH1GPurRAyR8skASJSxbTfinwSLob6Vm4ZY6G4Z4PoXOKGbmB3OXj84i98uhWzgziAHM0gKxeAO+i0ksy1oM0739z6fKrKGHajZn1P8rz5FZcduH6Hm84QfQt+xwNHLnzFKEEd2IdDtq1qZGvl7dTUE3lZUjOk0PgBq6NfM6TU61NFTRigG/NcLkzOhIqquGFE6UsMJ1Upmc5sr/WpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN6PR12MB8542.namprd12.prod.outlook.com (2603:10b6:208:477::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Thu, 29 Aug
 2024 12:15:51 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 12:15:50 +0000
Date: Thu, 29 Aug 2024 09:15:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
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
Message-ID: <20240829121549.GF3773488@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: BN9PR03CA0800.namprd03.prod.outlook.com
 (2603:10b6:408:13f::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN6PR12MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e19f6a0-e130-4b40-9f7f-08dcc8245248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h0QEkAlgRqITR+vR9c3Q/2vKR7CqFuROrNXr/JkNqVIDKCtS+pc041SoWn8K?=
 =?us-ascii?Q?ykX4vwtHxRJrEq7RBIN+Yh6nvxwBDl3NYnPKDaTO6lTJ/cl/pgza8Z9KwLcj?=
 =?us-ascii?Q?9gMQVrZLhFBKDQh+KwMHt11ydB38mTHFn6kgk96deBaQMy+I9ligjJIdihei?=
 =?us-ascii?Q?RUJw6xc8kwqzdjmIkz72du80eQBfjjoadRpMWaAG7mEeL/chlKFvNKRLgboR?=
 =?us-ascii?Q?raRKu9wKvrC6Izorv6sAY7C0DjKrUvyGA99oK0S17WFWVt7X9zF4+w/EQSC4?=
 =?us-ascii?Q?cObjSFz4n6aw+1sa1ENRdmGYORf3YS3rG2gjk82ULPK4MfG5cICf6oLKvmdl?=
 =?us-ascii?Q?JOjGiq7dxaugndJMXg9tXWptSxK3MH8+bifMdGLn0e/0n9zp1cE0AsIwUMi2?=
 =?us-ascii?Q?jbtVNd9PcODfkHkOnf1Vt7pxAlwwfezesqoX1LHhM2BRai57Hl2hNhqx93x7?=
 =?us-ascii?Q?F1JQfPtPMQnGcTY3BijbM0vH7jZK4ObHzau7LIcj/R1UDlW4gCeS3nwEqiWH?=
 =?us-ascii?Q?bNIrYy7b9TFNCRYppGtqHTuvnv3q7I4CcsUP+tLiuovKGLps5hETGjuOpo/t?=
 =?us-ascii?Q?XepBeFxJyzxGFEyoKL537BKhTP/OtaqmykyM1g6lVzmrd+W28/jJdsGmIMsh?=
 =?us-ascii?Q?whhXFkKGfQrglDCiII9Nksl3rVy2ZfPmOvfA/CzO14HG+ckdIykfHHPaCa93?=
 =?us-ascii?Q?SAq5eItbLENGL8b1AQdD95VuEsD/kMoShWZbXfgB+o9X5/oZd6M/apVgUSp7?=
 =?us-ascii?Q?/dCjSnwnK4c3c0QkzK7yecg6ZTg3R6fIDFIBWGC+6oXIzUPAxrF2wLtb7shr?=
 =?us-ascii?Q?Yq/HB6fnN05qVv4JJtBQHsIKsx1pJbHcvT7lfZsbuKAfay8dm46SjtJSFmlF?=
 =?us-ascii?Q?fypTgbhv40+m9X+N/cVMXpm4fMU/mMvqFRmteefvna5Rka1oAPkDtOggAogr?=
 =?us-ascii?Q?hErJO/tUM8QIdFDfAbZmaSptP9phhujGs0dCwTWgv6L0JH7+I6y1iGeErqYj?=
 =?us-ascii?Q?RWT2A/d6VubGqT66SdKLMV6X4eodMeTMYC6GrH5rMGYOII5PLEjJSatnF4Z9?=
 =?us-ascii?Q?XsTKTaDX77Cym9ry0YT0M3i0xCOrGLl/A6+7ieO9lIsf5YrZl0rBh6bkXmL/?=
 =?us-ascii?Q?FgpyFreccA6NZdvN3vq5qIX5a0AVpW/QNzUXDcndEjxrPohAj8X5DoviJzWk?=
 =?us-ascii?Q?9gglLfHA+0NfcSvx2tzXGoEV/raOLSUzTBXrDvGPVVYQNtdmylz1VmuhB9K0?=
 =?us-ascii?Q?N3jyEHKYHiVFRM9kEgOSnfUw+STmMu2UP9ClgtdiBxJhHfn8zytiXjxDL75g?=
 =?us-ascii?Q?JDaWBJY9hnrnfMpp0jLMja58VmJxgePPap2JwoU9NU2/Ef6W5XQBnaXBjJYz?=
 =?us-ascii?Q?Hbu6prI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qky9ZxSLrYUos/GKd+gjrV0qawSlZzGo5CgbSxcz+jQiVPqr7ZF/UeMg/E/f?=
 =?us-ascii?Q?j/283NwHFYacQhBF039YJQb4TaNUIZNwc1ssYlY5bSK89nuHPpm5c6HzH7+C?=
 =?us-ascii?Q?eHn3TjaACBYPSVDc8XUSbAxsSrT2BBt0JrD3kt3Woo2jCMah79WjHJ67rAfv?=
 =?us-ascii?Q?Uw6z4dHn+trpwp32/M3CgzqTogXwEW2A6hMf/8GmYfXJcyLMGLqhE3V6UqDx?=
 =?us-ascii?Q?zqJhXmavjPrtcn1fn9elXM1z4Q/iif+MY03l3xs7lL7ZYE9QsNPh2eQ8sXgK?=
 =?us-ascii?Q?pcvZRmXpn45inZlB1JLJ6ANpQwaqm53CtgAeRiY1+lr5sHXs7DCGehPBDPW8?=
 =?us-ascii?Q?pQGB+KorJCXi1nxfArRr4VaLKeBqppwGv8D6OsrZjOKsolFSM9luBFOHsjZY?=
 =?us-ascii?Q?LhsxANLmF3PIY8FJZky9mZHLZ9GjQQ0NG3VszcM+4HdXWNJndfAqwatOIpyt?=
 =?us-ascii?Q?bDIsX4IaF7W3P1/ISn51hIy+mIMQSbNRixdJ/7mbujtZv03iMbjhUsDxRz3P?=
 =?us-ascii?Q?6jaWH6LGsh9RocE6IEXFYYuxF6jDyvbZXrKgzXynSNFpZGmMinRTbd19UjrO?=
 =?us-ascii?Q?mPiBFzgk5CDLNAHp4lHAiaQ5MC5raGAYLC6U1CXdlinzlbXIITIvLbTYASiO?=
 =?us-ascii?Q?B903lP05ZR8fLhbWwLcpmvmgek54QNSpmNH3umHPh+ZMSm9KG1208v9SoFFA?=
 =?us-ascii?Q?9m+XrhjEoMia5+mNiaLBvTtqFcHyTaTXUjqdrSYBWU8gdnCPB59PsRhwhZdC?=
 =?us-ascii?Q?/g9/Q9e8e0CRcYPrTWB/8zMgolsgBtnPHHLTwX8MM7RWOWxhqH7dkyac4s9p?=
 =?us-ascii?Q?tElG5re6oGqmi9cNwd98ooNlxEycaw12xYG/lsOtKZQa9Rmfuar2Com2O50U?=
 =?us-ascii?Q?jyaCiit8EApwyF4KDXcO5W6jz9kq+u4BdU75ZyUybJdT12xM/xFV3zBJz0St?=
 =?us-ascii?Q?Cz0QgrYLS/dZk6jO6JyLeBrOGrjif+Q08j9/x3ZqFqmgEWqJVvJL3fcfE/Lx?=
 =?us-ascii?Q?3NkfHj2QGoLhk9qsk5lT/XYrBt3whFk02uFgoQUF7eFojV4YHEcwEVbBf7Go?=
 =?us-ascii?Q?tOcPhTd3gQthaZXhmNqvmtckRhFJ/LDTungkLeS5RjFUdstqEF+ZO3HdTZYu?=
 =?us-ascii?Q?AEmGVUIoxAZyc1qN4TSKfRyjsoMRC6sE+AeWj94odUN3mznxfpDZrN6fzxL4?=
 =?us-ascii?Q?TwSzlub9/91ocAOLAgsmgx5Etw6TUZq+A0Ej5qnRJymxT284pJTsE5Klzemp?=
 =?us-ascii?Q?lBAiBi7AaatWMClxMRt4F7E3I3HNxMFkNj2PrlkQZNFRkWWPtH+wVhwVzAGV?=
 =?us-ascii?Q?gV6FZmSFnMfF1mlRHkHkzBsqM0QrQ5GppjBdinXnXhMPGJXNw7THgAM5GTpy?=
 =?us-ascii?Q?2GHVXh3bXO7bkr8cR7UZlZb8fS+td7Ylq0LxbtS6bKImyvWinwQKiK+r2Tv9?=
 =?us-ascii?Q?GpybB8jkQzcC6vC4a1as/Lb+5bCNcrQZma6AGUQE6DOgdlzkV0x/C4xXYDB6?=
 =?us-ascii?Q?qEMXCrcsoYnpmQn1f80MROWLII6YySfK2+vXmDQPLtaM74TnfXQ0yAQB3iK1?=
 =?us-ascii?Q?XlCa0ZF0YoQopAcCZOn9LsWHbB2HdF7GIvCKC3U6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e19f6a0-e130-4b40-9f7f-08dcc8245248
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 12:15:50.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AYrdVeXatxSkx5I8PR2BE/5qRY7BAd/s6uT45i4K1uGg72HVcKfK163+BBUUt2r+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8542

On Thu, Aug 29, 2024 at 05:34:52PM +0800, Xu Yilun wrote:
> On Mon, Aug 26, 2024 at 09:30:24AM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 26, 2024 at 08:39:25AM +0000, Tian, Kevin wrote:
> > > > IOMMUFD calls get_user_pages() for every mapping which will allocate
> > > > shared memory instead of using private memory managed by the KVM and
> > > > MEMFD.
> > > > 
> > > > Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
> > > > API
> > > > similar to already existing VFIO device and VFIO group fds.
> > > > This addition registers the KVM in IOMMUFD with a callback to get a pfn
> > > > for guest private memory for mapping it later in the IOMMU.
> > > > No callback for free as it is generic folio_put() for now.
> > > > 
> > > > The aforementioned callback uses uptr to calculate the offset into
> > > > the KVM memory slot and find private backing pfn, copies
> > > > kvm_gmem_get_pfn() pretty much.
> > > > 
> > > > This relies on private pages to be pinned beforehand.
> > > > 
> > > 
> > > There was a related discussion [1] which leans toward the conclusion
> > > that the IOMMU page table for private memory will be managed by
> > > the secure world i.e. the KVM path.
> > 
> > It is still effectively true, AMD's design has duplication, the RMP
> > table has the mappings to validate GPA and that is all managed in the
> > secure world.
> > 
> > They just want another copy of that information in the unsecure world
> > in the form of page tables :\
> > 
> > > btw going down this path it's clearer to extend the MAP_DMA
> > > uAPI to accept {gmemfd, offset} than adding a callback to KVM.
> > 
> > Yes, we want a DMA MAP from memfd sort of API in general. So it should
> > go directly to guest memfd with no kvm entanglement.
> 
> A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
> takes control of the IOMMU mapping in the unsecure world. 

Yes, such is how it seems to work.

It doesn't actually have much control, it has to build a mapping that
matches the RMP table exactly but still has to build it..

> But as mentioned, the unsecure world mapping is just a "copy" and
> has no generic meaning without the CoCo-VM context. Seems no need
> for userspace to repeat the "copy" for IOMMU.

Well, here I say copy from the information already in the PSP secure
world in the form fo their RMP, but in a different format.

There is another copy in KVM in it's stage 2 translation but..

> Maybe userspace could just find a way to link the KVM context to IOMMU
> at the first place, then let KVM & IOMMU directly negotiate the mapping
> at runtime.

I think the KVM folks have said no to sharing the KVM stage 2 directly
with the iommu. They do too many operations that are incompatible with
the iommu requirements for the stage 2.

If that is true for the confidential compute, I don't know.

Still, continuing to duplicate the two mappings as we have always done
seems like a reasonable place to start and we want a memfd map anyhow
for other reasons:

https://lore.kernel.org/linux-iommu/20240806125602.GJ478300@nvidia.com/

Jason

