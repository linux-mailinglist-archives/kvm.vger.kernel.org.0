Return-Path: <kvm+bounces-26012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD2596F5EB
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2E5A281808
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A361CF2A4;
	Fri,  6 Sep 2024 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NjPMKBga"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B39C14BF8D;
	Fri,  6 Sep 2024 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630859; cv=fail; b=QvY72ARRxaG8m4VC7aq7pUsEoAWyxbg+qD3kGXIZoIfXq519kIBLKaQoo+hAB01D6EPy00ARGb6Ji1WDmJSnJ8oxMVF0zV8bQbZdcjT0F0MFABh3TOeDYJL/kVNsBBvNWSJCaSIEjXQ1IH9xopbkZ2Qo9+lDmA2jXN3VL8IGI8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630859; c=relaxed/simple;
	bh=jk7zB9BuxJTO0yNORKQEtOEoXGH3i8GhN3fB1BMiCIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=og2Xtw0pyJgNocZx+q4UdlRZB0MotwEkYwykfyo9ePfm+dxEUrVGhoe/1hyiwWhDxpaa09dsF8elI+KK5zWO94VPu2cDnR/x8+fjCRAqYaG+IePNSQgJQ3hUz4cK65/RRZB20YuXzZ9tkk7AOW/MGYgkWJsKCqSdo3f24NM/+uI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NjPMKBga; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQdjKwZjIObhYRzWV3jhxvAHbQ9u63jXP/4XYBG6dyjgvTgFOba2yHn2gYXi6YZQ0NSmc7oLzNGfXfoINNeHXujjhR/KO7aEW8WyB/ue4TqMiIKu/1sTOmZOhlY9Fm9eZIenX/NYrO6gA9nkSnQfz0JBdhS9+406v3UyfUfrPKykCZKd3u90fA9Z6KIOMuCArTAAwCl3ke+K4XPHEwzcr0K/MemZEHBxzmS+OkqdIgIxx93Ar+D1zZkWwsa82cSa4XlQ2e3Zw1GY/j110XAfJMF/Z8ASHVcPOXSiciL25AF1wig58Xa0wsn5U9Ui8DOP8AygSv3PaeTGlo9gxyT/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucpDz4kVtGZeOLgZjUPPHY7e/aIGr91PrWzo6Ny7fkQ=;
 b=ayhxO6jAwcNvBXENCjqw9TStWtlOwGTOPuI94Q1iirkfR19oCWVBACR4/TOiB/JbWz4LGs/sxHH/pUafozn9STJlWnsVDLj1HPxAKBVG3BA471G12B398d23UX+AicZ++/hGXFni5+2aN9Ljl1RG8Dx9XVN2YHfG1X09/GeZKcCUDV9o1uq6m05yg0KBdhalbPv9grTUfRe/u70gI2fkc58QlO3mv9QUocQwKI541S4a6/44xkfmHFZSYdCqp+PSWDIqvY1ugMEeLOY9WnbUDunn5qCWsL/cQN4Zw5d68JpjhcyzqG5bxUz/HMehUCTCtGGQv5w88tyc/VP4lI4X0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucpDz4kVtGZeOLgZjUPPHY7e/aIGr91PrWzo6Ny7fkQ=;
 b=NjPMKBgayWQ0F59VzUcV8Q2zmjinu8RTD1VrcA0zP6P0JHoTnTjjzCesQMktA7gJtpVD0jSGq4bloZY5xOyUtCaCadSK+/rOY+gc1kkNgfJeQDH+s+lgKEn3L7B7VM3ABxg/n0XWiP1MKBGusB5SY20E6yyYRKiADQNb43I6zwlKB4vcZNhnQqnPK7wj3WPlVeafMqwsXrirlogoBL4GEPGpUNCT6ehDzO20D+DSyOe0ndN5ntkUrGNUZFv4umJ5Psvi/D94kI454RDZh62O8xROZX2IqF0bHQeExQTAyZKGYNfKUvrKk9I7r34D4CFAoV8XnXj5Oulsdtsv2eNwag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by LV2PR12MB5918.namprd12.prod.outlook.com (2603:10b6:408:174::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 13:54:14 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 13:54:14 +0000
Date: Fri, 6 Sep 2024 10:54:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
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
Message-ID: <20240906135413.GG1358970@nvidia.com>
References: <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
 <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240905122336.GG1358970@nvidia.com>
 <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905230657.GB1358970@nvidia.com>
 <BN9PR11MB52769C4CDF39D76D320FB3938C9E2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52769C4CDF39D76D320FB3938C9E2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0289.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::24) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|LV2PR12MB5918:EE_
X-MS-Office365-Filtering-Correlation-Id: 94eb45de-6fe4-4633-fab8-08dcce7b64cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VjG5VS2DNhLwki0tKkavdomds03NNW1L5crWosI6ZiF3d6dKbA08bjeZu4Iu?=
 =?us-ascii?Q?4F1UFXGWruyTncwwi0zQulvoD6vHYj0IV64lGkEYe43CUTWb+zfLjNIqw0Tl?=
 =?us-ascii?Q?jlaNRoXTxYhr0LRfjogCymhyh1axrATBfpky47qDl1fW9U9M63TUeXuLWjgN?=
 =?us-ascii?Q?ZGrEPi0PEu0FHmt4w8bs/4Lo/L/pjau46XRz/8B7dA8/JV5oIpoaeCZBsZD9?=
 =?us-ascii?Q?Ssb/yCYAeQFJjjAIL3uBBFlCdyFBIukwCYqWSJViCx/KvqPOINco8w1sjLnR?=
 =?us-ascii?Q?g+luBBJeKFaM3yrFwARzwM/9jQf9kJ0l5n+mhJwiOz2s2R5W4P/XMG533qO8?=
 =?us-ascii?Q?EBhjQEemAIECk7DFPX9tEeBC3UMUx4qgWIHKjLuwq101ZIFFmJ/V7d//iWTp?=
 =?us-ascii?Q?UcsT4sCNGDiA3DuH1gqFtzcrdNPrVFO0Uhbe48s4sSZC4b0Dl1yk7lfiQRVB?=
 =?us-ascii?Q?Vqyn0H3cjJXRbdf23a3yQz5/8SAjK5qW8w/5/4MJVM5z7J1KggNSuE6LJAJX?=
 =?us-ascii?Q?QjleG66RvtiQoQ2TvCzVPPe43OJyrwiBVIprG2Gk5tw8bsA+pFqbBC1dNbtt?=
 =?us-ascii?Q?At7I/cCJF0VHkpUjDbH6yH6uTCKLSkkqQjHQ+Ii8oQl5OTsJCaysOusTJ36J?=
 =?us-ascii?Q?pfPeifXs23ykU7hXAmV519AWFsOhg1H8i0YXLn3cUPiiV2OQiOoVMjaicn1v?=
 =?us-ascii?Q?LTchZ6DYClbvQ0cDcRBA3m/W/SEDBU2vc/N95cRZL90a9kQ4iStO27m8gk/x?=
 =?us-ascii?Q?pgwM5g0cSfMTs3w8mXqLNTM0qUPh06mUkgyiWlPNOq4Ncbp36llZrqU87KLI?=
 =?us-ascii?Q?0YKiVnV2NtHzo8edOC8+AXxIWzU5T8q+oZ2V//NAcJM8C8yzWg48WqBJQO6M?=
 =?us-ascii?Q?hMGwKxUZyqCMXKmekwJH0Ozq7s7bJk6NQdmidLyz8FBDK7+n2xiagHVs8+Sz?=
 =?us-ascii?Q?cylwDsTwjfoz50MZpLITAndVsqihv2iBXo9grE3GIT7rEuUqao/b8wAINxGW?=
 =?us-ascii?Q?1mb8v4U5a3chnrfcE2jZQGF/wEibdTmpqwDi5wWtgzjMn8kFwcyR2SW53n/X?=
 =?us-ascii?Q?ZPKf3k5yz6v6Ftxiej61n2lVs6qZK0Y1mXaupnq0B7nWhzL88fhWX8dASF/O?=
 =?us-ascii?Q?5ssusZvrPFisaywSsKF4hBOusgYAZzQaAFpkbeTPLYGELdlkYO80FDw8TID1?=
 =?us-ascii?Q?yedjxWFwGNkv2bR4f4zwxWvTZlbL8O685ACwwnQaWrvXS8eSgqHe0YgXyzQ4?=
 =?us-ascii?Q?loQLRy6Ki8e6yptVbuk0PdJybe7ktkwlsXjSTa7EaoKY07Okthse3AzedgVB?=
 =?us-ascii?Q?vitqd/1K8jBO95d/DGR8oYp086tebDEh8GSB7pCp4aItBg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z0L0iMvBT9m9d6duA7B/IJdnf3FznxzzOyqzJZiGSGIXN+0nISC5dMLR1RpV?=
 =?us-ascii?Q?J7tSgMm+VCg3Ii/q4iyLC4PKyUiJz7FQwyFBWVB/SXcD7PfVkFfYiRgkOpLg?=
 =?us-ascii?Q?k0bO1s2bFopMQYLJ3Nk5Le0gVkMzXaq4ygU7QgTYVgKRjD7jZHcy5A//yGsT?=
 =?us-ascii?Q?fc+PcuD/+JnGVH/TcqYDh3p4MvWNZdmFnOdwnnl5b7K/B8a9khi4YctfQeWF?=
 =?us-ascii?Q?B20dfVq6mHIMnaeNQ1mkaGkmjgKwQjV41oHX/w65OmvfqdFr9CKQKK1MR7Lm?=
 =?us-ascii?Q?SrPby0owkMIwcjUtLSeiXZw6E8IdY77h0amjUQRMRAV15vZnCx2iuwRD+Tm0?=
 =?us-ascii?Q?891ekV9MQUNhsxUHghrSYW3zwFBh/u1JLFszjYuflZshB9DMk7a42peUO8VH?=
 =?us-ascii?Q?CfN/eWFpe92RumZ6KzZv43Ph5et2ode4ed92hGQhoWvoz90V00aKvE1VXa7q?=
 =?us-ascii?Q?rZyOqN26ATibllbd0AO/yrjcvhScWYKT0qFCaSScym1e1uCInQ65VjWm9vBJ?=
 =?us-ascii?Q?5bXP8iP5K1HmRWxRWBnOZNRtMQgNypGfX2cf1TF8/6prVETxPcMu7oKbo7Jn?=
 =?us-ascii?Q?G9N1RX2bYIVAoXv6jO2xV0TDGO7qZgzREFpiV/UmKG21FsaBT1JXXYD82FtT?=
 =?us-ascii?Q?/v5DCWRgycvlN6mGhy/Dawjc/ii7FjjkOlszYq1UnRNg8pwf3td/jENaLT0W?=
 =?us-ascii?Q?q1gsRaNSwT2Pv1wgqHEiQDW0jbYdbhuA/qZ4cGXU89DAkIWd8LXPh+YAYvNO?=
 =?us-ascii?Q?X0TmbdGBiOK7Nd2YzuVS7inOiNVNO1w5enPiPtiGxZlUHLmP4M4PkPta+xHr?=
 =?us-ascii?Q?aKNqEfNvqTs1N1SauuH/gKPNzQoAWDHs2dshXvB5N12TP1aFY7pwC65lbeHc?=
 =?us-ascii?Q?6febMKQHGMYp3uOIrN+T4+DRujTWSDGGyycntpcPZigIU7/LmIUugCnbgzU4?=
 =?us-ascii?Q?ikeTqVce+PGmVSEOdOVNl+ZYYzH/hyIt8XMw+34213gNW0yZuPyETFrjSWX2?=
 =?us-ascii?Q?SGsbBw16WJJpFpl5o0ljqZKkxCHMngXfk9YQe3LWBtceljzTD7HbYcPua7mD?=
 =?us-ascii?Q?zF9GHR4hZchKIDTFWvgwLKLuz+oIcjkiF3tZPeJgcfWoxP3mibooAMYVf2JX?=
 =?us-ascii?Q?YXh3CrTSlxhn923aCesI8Loiv10abPqX7kUtqHmg7PHmpbU8OqosQxTTNMMb?=
 =?us-ascii?Q?9AKjkzhAokI/cIa5h9RvWJLPSrk1LdCSXo06ZsOeC1b/+lMPWxja5q5/LphH?=
 =?us-ascii?Q?jtA89Cg+72YX2pAJsGsDV0fApyKlvqTpwS/vbfRaJuk5FpFc9NyJWYYcYwZQ?=
 =?us-ascii?Q?wIW6VGJosepVfJzAKRe7gLQ75bgUjY9GoUe5vJn6xAL83hyaOec0i1d6i0QL?=
 =?us-ascii?Q?vC3bZ/RFM7SV9O1RZhfEZcR730xga44NTHEzBdTsHZCOabYQ/1mc5sX2PIBW?=
 =?us-ascii?Q?HY4DjAilIbQ0exbrj4XLznzVtq+JMn323MWYYaiO6EiYMgVchSiTqYmbvGkU?=
 =?us-ascii?Q?PgY8tVOQNNFNvt8l68mdS+IxP0b3F/GD0OGf3Nb2zcb3unMdtAE4+S992tSP?=
 =?us-ascii?Q?6Y5EbK36LGok3kxayptvPIuH1ism4gEQdWwQlYEE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94eb45de-6fe4-4633-fab8-08dcce7b64cd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 13:54:14.8525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GcO2kgJ/VU2ACAUMMS/me4w8+RSWt2mrTaCcau4pNZIVCiLzOn1dSNxxv7IqfDT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5918

On Fri, Sep 06, 2024 at 02:46:24AM +0000, Tian, Kevin wrote:
> > Further, the vIOMMU, and it's parameters, in the VM must also be
> > validated and trusted before the VM can lock the device. The VM and
> > the trusted world must verify they have the exclusive control over the
> > translation.
> 
> Looking at the TDISP spec it's the host to lock the device (as Dan
> described the entry into the LOCKED state) while the VM is allowed
> to put the device into the RUN state after validation.
> 
> I guess you actually meant the entry into RUN here? otherwise 
> there might be some disconnect here.

Yeah

Jason

