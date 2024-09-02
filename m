Return-Path: <kvm+bounces-25691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 13528969087
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 01:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73FF4B218B7
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 23:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7648E188005;
	Mon,  2 Sep 2024 23:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YRY21A+t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2D13C684;
	Mon,  2 Sep 2024 23:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725321133; cv=fail; b=uz0AEZw8UPhf5EV4WiWbS20mVTFtZ6MHbVntxTN0ZHsVQ4ydqmhD+nLFI3AiEXaG/qNQoNb2+r7uoh420ZVPRwQvr4iDVAJDhYPryyiN9Xav2BmF/T3MdO4hTGxYgIzZFp5TjOVATSoWM94iIShIff1EiPfMTk6Amh5RqDyoZjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725321133; c=relaxed/simple;
	bh=GucctfuQOvHw3OU/qYry3y6O6eEXldR7pOqKu9YQ5WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IO2IAMGWnbJBxTTwIL7uiq9c5hmHms+0HwoN+4WyZYQqdR2D8T06dDM4+ELf+VdAkOQzHhFxcIaDxUvllJigUpSp/qH9CCEerOPy/kOKks5JNVRLxhF20nDjuYDyJxJeqI/goYi9jUB6PjCx9V3DtV5HtjeeVcZ+tOsKtcxfqwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YRY21A+t; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k09ehnmxZzawT9mzuyOhVPPbMgU7uBaeVJz9vkc8ce8LowfDr9lsE4fMdZ6NtlxzFJ2yS9zUEyIgA06abpDMxDkzXnYZFjZndgt6YSqc8pnYRP5hiH4UYm78+5QxIC7mDZG92dhS9JR1EOsiUl5XlJpFdQrng7kRiafo6cDtY3wBpMmlmtOtW00BsCRIktnWbfv1PV0KR6+kZVFdiE6pFskxyK6JEbK6efobTpPRx90jxQRWy/sRSJfQHb0xVGNj6kuKPXxRLePSRFUSl3pdipoQFzqWLt1SrhGk4X5iXwfKS99p67wLJD0NxlyDTavIDROsU2zs/lpFYTLZkFIHwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okVpd+WES9qKplvpVtwIE6n6ndPxFF4Gx3MhrlHIpdI=;
 b=whc0LhUH9MDInQmlzh+URXascYgh7vgBKm4JoqXmalaBGBoKlXfIYwz7OFMwWym5p78BYgky9OsU7T5VJz/aBGjDXS6w7UK6fAL3agHiCCnuubB0RkJUo5upkfCax+CkrBCCVVm4bCpw2HjZZPJqPqbc2qYgDOzmmJtk51nmXS3RJqc5abdbXKjWqcKgy3+QXaNrke7TmjPdshrLIjIvl/mPblowvOK4OuF6mXk8YcbdYNRQNcv006ccUwDlIPSoY3JOvYow5ScUtv8KLNskRW7GRGdLoUyoWK2oMqS16AxFFnLO0QJAZct0cWyXgBq3p7Kbr7xF5F9FR0zRiXR0Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okVpd+WES9qKplvpVtwIE6n6ndPxFF4Gx3MhrlHIpdI=;
 b=YRY21A+tkbatfcCTfonT26Q5AS9O7DmFmd2CSZwj0YKSmsL6er+3LXwyYC79MINWkPQyFSPaU2zqeqd+H4U5AbU0LMaC7KV23S+jY2MbLjW74iLZU8rSEMoZ2qbyUhBGo1iN4+4IvO8iqoNmruO9+LmdL9QQY+Txpl51d/vGmzmVvGKCB8ZRoo0h6Z6nXL32MyHa956dgZpAOYGTqHL0juimkhxHe+4QSGlQSnX4Ch2wJAHx8qzWWrf0lExVz7BpohhsUWuBtGf9aox7ts/tAxpnfo4+SlkXORg2lRDV0trWmWU65uVE5O+fxpb7EoA2tpclqkzNwnuYapPtqXVrAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 2 Sep
 2024 23:52:08 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 23:52:08 +0000
Date: Mon, 2 Sep 2024 20:52:07 -0300
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
Message-ID: <20240902235207.GC3773488@nvidia.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <c4156489-f26b-498c-941d-e077ce777ff4@amd.com>
 <20240830123541.GN3773488@nvidia.com>
 <7abbe790-7d8e-4ef6-a828-51d8b9c84f33@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7abbe790-7d8e-4ef6-a828-51d8b9c84f33@amd.com>
X-ClientProxiedBy: BL1PR13CA0445.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::30) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 48f8c845-7f2c-46f7-741a-08dccbaa4167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QPl/S1DCTUgZ43ZadRc/4ip2alg3l5mzZI00SUExCkWUwzDNxEu3ZHEqp/7d?=
 =?us-ascii?Q?xkhDS7sB+9G1PfqrLWHPAkBBn+a1rpYBwHzfgOmwHk3imGBeEsS/oFxAnDPy?=
 =?us-ascii?Q?/jZLPQlDM/S2uA0yznV4GV6QAXFlxK7+17Q+IQKnItensq2YALIvSK4gcBrk?=
 =?us-ascii?Q?I7ILaW1/eBwvNNnxb85A74b+pmCNBZIckuHZsNOpPbYmZAaa6Xf73Q3TQHhi?=
 =?us-ascii?Q?oP23wT1cFh5Q+WWumCioTmHhHnFphTTWSk+xzAHr5EaYES98vrsqdGjQuBiU?=
 =?us-ascii?Q?iQ4XCM/1fDV0hd/YSEL6dQLQOkOQ8hMhpOYekL01Mgnr5Sg9XHqIpPw8MAo9?=
 =?us-ascii?Q?JNR4BT9dFbht2G9defdxRVgVacWhBEIzFiOHhMngKZl2jJzSPZSdR8hiOcOJ?=
 =?us-ascii?Q?OD3iWygpmblNQwqZdMjDDQ9zinTLqfqrepKxEANiUON1w3xd1iZxtPb+4ybI?=
 =?us-ascii?Q?4C1dm3a9eLMKrK5ME7P7mkR3sXUPezvkvW15VLjMKLg0zHT7DrEI6iNsUlSM?=
 =?us-ascii?Q?IsoB1COVET462Y2oqpEQ+32AfApzlRV6VX1jQLCQNOVsnDttB3whI8MkfkOm?=
 =?us-ascii?Q?XuBvkiAENlWLbZZvfXRoqWyGIijDVeIluz0xG6iVg96Sn0xBvRaDQDEs8zoX?=
 =?us-ascii?Q?ATFW8/fDXZi9ybNTF4sWn2fD5FOxesYZXPzEwY3kBo16/YypsD5eChEkPBQO?=
 =?us-ascii?Q?7RNdYcY92pt2jmnkhIMGo028Hs4S2JAvf/V8sJHUelNUmRIcvSljBJVAPrW2?=
 =?us-ascii?Q?pR0xhXcQzAMX03kOzein/+yJbY0j/NYc80MV7mLJqxyXJMNYHyNbJqfmTy8P?=
 =?us-ascii?Q?azBQUzYN/wARZ5qvJJ8i76LRcqYwRU8KKUgYw3iYuFnAZE7rFJQp79HBJCHi?=
 =?us-ascii?Q?kNGh46VtWQyqQjwvBWrAug4/uC54FZ+itgzcOUWSs76vheMBg7Gs1o+M87tc?=
 =?us-ascii?Q?Pkff0Qp8fTuTuUN18RkYkh7/HFZ4R4S5vt9ze9RpU8O3wICklqvzbMzoJWwd?=
 =?us-ascii?Q?SRXNAMWa6pKpC1R/Rwdrgm36KdIrcAUbgNjM/KNZ317aI0m/qf/EQIbf1uvU?=
 =?us-ascii?Q?0hv6BrIYTZgiFmW9D0GRVmpPYgfJTd+LYsCyPHwPYpqtZh3xvVO/wBBl716k?=
 =?us-ascii?Q?9T4fkcURxQrsj/RF4wfciveqqzIkJWoUt5Gzh9D6oGe38IEGkY0hf4n1IoQ1?=
 =?us-ascii?Q?hAFHRl4DhoJeUOsCWloUC2J4dJg3Hnlzz/eiFQSLvvC6sQRUva3TLkrJ2R9j?=
 =?us-ascii?Q?XpkcZlZvPMXHMmROic/Ol4H4eMWMLX1xkOoRSRhCoXniooOmlTVC7qtC+fzY?=
 =?us-ascii?Q?DujmpKejApxvHEnUpabFbmkDYjnPSxHL59/pou/Sn4H0Og=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XW9bZ9ZRGxNQ972vwd9VhdH9RsSGSjqhGUqhzGO4OM2yf8P4BnYhXjamHXXy?=
 =?us-ascii?Q?krwwiTiYIjvHQ2Qc6IYm37h/RT0odTHX6sweFAhQJenN1DFCEjDXBlb/CW8X?=
 =?us-ascii?Q?55DM3Rg7QzrTiLlq7CT2wRZGF8xGhxkYUtWFZt6T8VIqlUpYm07DwC9tqLlU?=
 =?us-ascii?Q?L4i/CnqAC781hLYEh270ZOoI91ORJuTT5zvrUgATXxlpP32zhYzl9C4k6tYO?=
 =?us-ascii?Q?f4STifjW2Cvrs24ePZ2K8JaebdLz6I2VzMYh0UFsqOJyNPWPvetxVhsFr+Ln?=
 =?us-ascii?Q?WfuvDLR7niWzg89vfQT7kTCmeLMGJYXl+PqBx0LJULegi4cuAsrbHxxMxqqz?=
 =?us-ascii?Q?nIx4VdEmRIlgx3x2mPCkPKoPJ/CyRE6FqlB91v929nEQq9tYEk+vsDr3ip6Y?=
 =?us-ascii?Q?rRx1Euzh5zFgnMYOFeh1uQlGRE/0vVt19BNU0tYk6/6EJSatHHa7X4LW5lt+?=
 =?us-ascii?Q?U1cYjFkAtr7wmBZmMmFrbfajvAlSWibjINy5VdBU+kEy2hYgqi2s3ont5eEa?=
 =?us-ascii?Q?kzNaWjZaanIWwIVJ4HEhw1Kxyc56CgptUWBamvkYCzJXhHELqCdWh/kcgCBO?=
 =?us-ascii?Q?UC7DrKfr2j5P7gjTwBjht0XIZXOOKdfCWpQmUtLyDdOUP6AgRGlF5IzMpqab?=
 =?us-ascii?Q?Ypn5cfUmpFWBE3DLUoJF1Jy40U5s5bgUHF7KoG9GwMCq6Ni4nd1XKoLVUW8O?=
 =?us-ascii?Q?jJl8XZaf5RpGwOpbgAGDi9rB8Yh16G5i2UNEfKQzD4FlnGSiEbyjKtHezkbP?=
 =?us-ascii?Q?Yk/mK5qcq/9B740QpeqXWhfsHj+gljkt9b4eWIKVRWKXevKwM/zAQC/tIuY1?=
 =?us-ascii?Q?SkxyXISCWKjZ7+s9JOBco1xc9X9SCIPdKXuu4GFq08P1TuG7tVcT/O+m65ZK?=
 =?us-ascii?Q?57qHbywit2KbK9po7yIRiZx0pzhWAUkFPEqCbnA9nTqeM2K+FwET7SRvwDk+?=
 =?us-ascii?Q?IrOpy6BACR/z3ZU9FkAAAcOdPfR9qi2CzSahPoLMokhRaEdgNmuOg4KSPaE9?=
 =?us-ascii?Q?J8Klpy7Y6G79A4zNigEUMJGk45vDEtJRdRGn0jnriSxhfbN6xpCfMvLPYZHp?=
 =?us-ascii?Q?7acmaVDDBXi2ht92n3CauhZTPgK4ngDroNt3I/g6NOsMSfvPFsHS4XoXrzDA?=
 =?us-ascii?Q?LJMLp41Gb7Mc0p6Fikc/6J2lmtl214Nw2RC4gOD2petAJnzF/Yr7X6mF+lwt?=
 =?us-ascii?Q?2bqnFJl9m5/l6IoCNxxrVYbI2TjpcD6u10XRG59b9oUqs/8zrn9+V1QzcZ9i?=
 =?us-ascii?Q?7Y3vYLTYbtQ+xhbJoNh/c5JwklCwf07EA8NDjGyfKsJJKZZAEHwIFUT6qXuG?=
 =?us-ascii?Q?N6N2pySd/3l+UdG1jFa+vdIHNfTyzcxQN8B+JlZj2EYZqSHvZs6SbcDdQ4k6?=
 =?us-ascii?Q?B7Nc+3ap+uMMdjK10RYGcQ+S6eKZUgXmtMieoBi7mNeNxAj0xE635DOIKgUT?=
 =?us-ascii?Q?wyWzrIqrkuplRf1RgX8FZ4J+x0Ioa04A/lWmiIudHAUIRsF57YEem1YGzbHy?=
 =?us-ascii?Q?PqB8XAaIJ+U3Oe0goUmU7QXudopg6J+AmSyyUOS3RLTizxuiHm/Oqd0YWTzc?=
 =?us-ascii?Q?9iluf96PwJ+8w0/4Qew=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f8c845-7f2c-46f7-741a-08dccbaa4167
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 23:52:08.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLYaEe6keMeshSXfiX/pFH3jE143/FVKrfxK8CSFrAY2ZEWd27Ys5rmCAT79cA56
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564

On Mon, Sep 02, 2024 at 11:09:49AM +1000, Alexey Kardashevskiy wrote:
> On 30/8/24 22:35, Jason Gunthorpe wrote:
> > On Fri, Aug 30, 2024 at 01:47:40PM +1000, Alexey Kardashevskiy wrote:
> > > > > > Yes, we want a DMA MAP from memfd sort of API in general. So it should
> > > > > > go directly to guest memfd with no kvm entanglement.
> > > > > 
> > > > > A uAPI like ioctl(MAP_DMA, gmemfd, offset, iova) still means userspace
> > > > > takes control of the IOMMU mapping in the unsecure world.
> > > > 
> > > > Yes, such is how it seems to work.
> > > > 
> > > > It doesn't actually have much control, it has to build a mapping that
> > > > matches the RMP table exactly but still has to build it..
> > > 
> > > Sorry, I am missing the point here. IOMMU maps bus addresses (IOVAs) to host
> > > physical, if we skip IOMMU, then how RMP (maps host pfns to guest pfns) will
> > > help to map IOVA (in fact, guest pfn) to host pfn? Thanks,
> > 
> > It is the explanation for why this is safe.
> > 
> > For CC the translation of IOVA to physical must not be controlled by
> > the hypervisor, for security. This can result in translation based
> > attacks.
> > 
> > AMD is weird because it puts the IOMMU page table in untrusted
> > hypervisor memory, everyone else seems to put it in the trusted
> > world's memory.
> > 
> > This works for AMD because they have two copies of this translation,
> > in two different formats, one in the RMP which is in trusted memory
> > and one in the IO page table which is not trusted. Yes you can't use
> > the RMP to do an IOVA lookup, but it does encode exactly the same
> > information.
> 
> It is exactly the same because today VFIO does 1:1 IOVA->guest mapping on
> x86 (and some/most other architectures) but it is not for when guests get
> hardware-assisted vIOMMU support. 

Yes, you are forced into a nesting IOMMU architecture with CC guests.

Jason

