Return-Path: <kvm+bounces-58526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8231BB95D93
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:32:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 366F73A2557
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 12:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFC3322DCC;
	Tue, 23 Sep 2025 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ngOG0ovO"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5EA946A;
	Tue, 23 Sep 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758630747; cv=fail; b=JM/5dppLnMVbKTZS66CNAGlUMMIYGq/Z9f2JvkCV27XKZxYXys6vo/b7XAkb9vAByJ3dy+WBtZ6QeKVxnf5QY7/GOuPJiRGOJWBzMfLjGt6fZc0+iSC5k/mpJLn/mzWWwVRvBIGySVSBu17MUMK8mNEpNVfCDyiZfRdaNkbCUrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758630747; c=relaxed/simple;
	bh=sCUUdOtzUM/Ut7efoyzUxLiiWE5uMBJ6Emio+1k0GXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lVSQQU3fbfytA+iVEbjEYjX5SgRPf8hvuOKA3hurpMHrMsSPbV1O8xhGZLTQJ3jXnIMQ1d6gY3Kvu4vc344i9KaiC16s6Jqlv5OiX2XypJEKuJiWMh2ksv7aM7lBir9McoFjC0zGOoPft8ElF8Ek7i/kRoF2Tj/4LflyeI4a7Kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ngOG0ovO; arc=fail smtp.client-ip=40.93.196.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IjDYKW5EL3t8i0Dp+ZcSutlW2vAtt59IZq2fAV8AqAu9wn3OjMLteZ3XfdI7nvIrOT8T1RF9N1Lh1/sEpZYntD9DEOIW8Ze7oIxZNsHXcqztyP2wll3nTUu6wvnW50SIKKslamyF34owloO44aQtesQZG1zcw3FkoKqr/FxMUA/ze4zxf/4cz4roAMHzJb4k5JeuIZuI824GJQ0fFVUHzuZC0pDyXyHTe7SqR+4fGWCIOxBtq0bMHUNha+7vO0B/iBYiCPQ2wzcUpdd0+O7YqehGLHKN8DWWs5jCO7cIDZQFdJmcM+RSNz74nFsTWgfACs+SzMycjkkiHryVmSmzQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaMefZ2gRqUl+kWDE4hmhF0z1Afpoj0piJejBdPvsC4=;
 b=MHatVO9++D79T7HW6aapBylSu7KBiL+6NaQkNo9GtVY6+1JgR/TwlK0nrXFJgiwnK4WFqGhhtXaFsh+1uX0JKpjHyNCiTvdJ/f2+hza9WVnjc22r8w6CEgjP3SdA4UJl7Pz5K03vFLX0oNG84P9nOJQjSLT+f/+nFjpnryjvGHBZQaGgsdBdrItEJ9cEosBe+u0wKsr/rNPokloouUmUt/uxSrHRm2Q1tfATeXaTvLquXwy/Ff1cfxa5iKmIQWI9v6RppSy7X6kh7UijknHhavnGBJtyLvHBEnbjyxrkSbdtFHE7DNDTS48zrsQgx+zG+ukXOhzkBwKHh7/lEFMBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaMefZ2gRqUl+kWDE4hmhF0z1Afpoj0piJejBdPvsC4=;
 b=ngOG0ovOcq2cvEp4SToNL35q4iA+kfhzBbUpTdDfnKcqkHNSvJrxHsQVS5wEFmYgHHAXqoIKue8dxee3CF8dzAgT45zBFUxB34ePB7NxjlpElNEPQeT6ZEyfAnW5/nZ/L7pcj/IQ0JL3/p9BwzVoOjOl0UXFFI26H2UpyR0/6TEtBadOnDipzWMYUHap8hxV/vtfTqhv9JGI+4NZBezMWzrH99FhY/2ClZcrrTYIQiKX3t5sa/I4C/yU8zohZoJk8ntNwPKGltEu3h3DhpyO9kZZrPlQQBuLefsPGa3y6qlapC04mSL7K+qOZPxfBofY7fqkBpgwpEbpyGqBR6KZWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 12:32:20 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 12:32:20 +0000
Date: Tue, 23 Sep 2025 09:32:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250923123218.GI1391379@nvidia.com>
References: <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
 <20250922231541.GF1391379@nvidia.com>
 <20250922191029.7a000d64.alex.williamson@redhat.com>
 <066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
 <20250922205027.229614fa.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922205027.229614fa.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0117.namprd05.prod.outlook.com
 (2603:10b6:a03:334::32) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: 95e5e665-d9cc-48b3-a20a-08ddfa9d3d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MBpUClbxiIOZLO8eqBssZyKNwBvDDVtQwXuGSER3VkmXVSVV8xLOhql0PUdW?=
 =?us-ascii?Q?CUqno66OMwsbj8CDMEJ5nL1QJGQvUta/MwYTHzsGNaEcLC9dp+QVGrvZBfFF?=
 =?us-ascii?Q?cuXycHDkuBXHJCdq94I/J+MZWnduEFcds8s0DEPDmrv4HJ/cRCUpKI5jbK5Y?=
 =?us-ascii?Q?yX+wZwTQ/mb+t3LLWLszWVhFbfephO9dNSf8s4Roae2wO5GrVcJnAA2Y+6+K?=
 =?us-ascii?Q?jCCuZ1YuJ5+E58PFKW2VdniTFDX/sf56WDQMoDgPQdZWGrd+3Q1SrG5o1lef?=
 =?us-ascii?Q?IOoisOL8kx7NqEV6UgCocL3/hJ2zEurP2JX5RKQEE7Za4/2+lLJ6Jo13qDk5?=
 =?us-ascii?Q?OEdd2JD8HRnMbxLLiGFoiiAyLOBiGni8JSLIR9MDjijm7bOjaU57Djg2F8Q2?=
 =?us-ascii?Q?A09Qf/+BHrxuhAvFAtU/8f4uqQNlk3KY5twsUpy436Qj7fo8KI+Tmo6WUzTG?=
 =?us-ascii?Q?rh1YqMk9O1SqmYdyUiFW5dX0I+kquVYSlluKZF85Mmgd5MIU4C7BqqRPIYjo?=
 =?us-ascii?Q?puH9UFr7XAvbUwnbBY0UO38oNVBkzH3zswAXaMiEzVfwVjkbWgkhVySX89y/?=
 =?us-ascii?Q?yi+1nTCY0+ueEneaA33YoNSo3Roo6V9pFQ+U6gmiUPE6zqqSCEwJibaA3+XY?=
 =?us-ascii?Q?YDPJmEecsfuTQAcxKedoNER6vsFfXzXzjz0i8ePopnmxz/daAIayHxR1edTh?=
 =?us-ascii?Q?ThFqCGLhYach0oBh/n10rq9ergl0vhvhKpCIWRujPX/77FiYH0yccshKmFln?=
 =?us-ascii?Q?FJiHo7RKex5CyUeZJzah06sJ/lgZO0RTW0nHe07e9scEI4WDmkvHVMBaPmLB?=
 =?us-ascii?Q?h3cYgwK5PIvkGr9Rp+i2N/CaAGCO1VfUx+SEId6fxeyQoZXhI6WLsWflljHg?=
 =?us-ascii?Q?ZgXSH1ZEUQ/E4+SaYip+bQE0euvc7xNMKJE2dLoKr4GkOC3PfItPRdAE2zRW?=
 =?us-ascii?Q?Lp8WiAhxUysECK8p0SZWXNXvwGocQU3KUkjys1fFiqmPtTkOh4nt8TiEuCpt?=
 =?us-ascii?Q?EKzE9k5x2TPM3E6KlmRa/EtIMxa3aR5VlYJIm2NXHURmmAQzKyJuxRtkeROF?=
 =?us-ascii?Q?VdGMGr7iY47VLamcKq9kr2ZGnhvM/u6YI98nRfpYmHKTKgAq+EM84ViLuF6S?=
 =?us-ascii?Q?yhEJ5xRgeikfvtgaAZIcwMtoJ6L2J5GaQr//K+8yg2SUckN1ZhglUdxhaohN?=
 =?us-ascii?Q?Yxqp/wg9u8D2kb1XtC1Uk2wMGfwG543r0E/O0dfoDF9EumI5Wq8EujT6r0LW?=
 =?us-ascii?Q?gfRBOleTngrTyO/nrIgBgxM/s0DIc9VvHsTWVXnhHYDbASU1wCULNIFz6CAQ?=
 =?us-ascii?Q?7nT2CMdJeBDKlvgseKh9GDoJ7II9mtmHYhMcPbvqv2uuit3HRIdhglD7/fbJ?=
 =?us-ascii?Q?IyfxaIvMlecsp28dvfls5TsTJCWhjkcbfiSFqKbgwiKIUWakQX/EMAUi2DG6?=
 =?us-ascii?Q?uiGwnD/DVa8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?233LCqJ+mNsLp7cXtZvD0ww/ZQQek3CQS+bMBPQKawIqzMsw6jVt7s3xhf3K?=
 =?us-ascii?Q?ROAx9AsO95NNlZ6eCe4H/TcRR1kzC1Qrg/OAcA1FsGbz8A9q81On764nODDW?=
 =?us-ascii?Q?k0cFrbIkHcq9hbTqDVOioPbji5DjYvLyDH+WM0B4P7pRhTASkr68ilymRu03?=
 =?us-ascii?Q?T2BUmlFaYAfRZGpShp0dDbhw1orbzx6wsKt5vCcFi7KJzszHt2QbXSiyx5I/?=
 =?us-ascii?Q?N0ig/pjc+4ExmXSQ/i7U5mOJc6lmZytQaJyS/m/JFybcapGLA2sbtNzhiK6Q?=
 =?us-ascii?Q?pY3MR0kEuf//rA9zj96GncDk4B7blehnRzE3lvG+ugdgsDs5RFS54ir0An4J?=
 =?us-ascii?Q?saEoCwWIR+lJKHtkKKAGknOy7zj0ajNLRdNWelKJMgPqSTExulUt4eUl/8zd?=
 =?us-ascii?Q?fb9z30T7nouC0ehM8ae45RNh0UP+KA9arx9Veo06iM+5EW3m0Xa1Lyf6VKbB?=
 =?us-ascii?Q?ZCPMt3Re5l6AFMSpwisXyP+fD0dzYuqkgakGnRFwcyMdCbtVJ4ajPfFEWQGX?=
 =?us-ascii?Q?BzwYT8PotP9NQdzK+OazsvDF4P/fYyt4KmRqMO65J2TzFV+yFnajz9jaCBEU?=
 =?us-ascii?Q?IpviNaU8BxI5Zx2+8XU2OOKi4/AogWf3DZkeCjfPNeZtK2meiOjV+3U61aK3?=
 =?us-ascii?Q?eiXQ3/6Ipp1C9fF+I6/QaO9yLw+0iZyifEhPh6KjShwzWZwBt13HioWx6/b8?=
 =?us-ascii?Q?Km6Mg6eMhVrSz97bjZmoreNpdZ1aib+UBOyOuHuK9aJlZrGTF1qsJeDNtMYv?=
 =?us-ascii?Q?L/ljw5rJuDg/jC0FvTa45gPO7iRSWNxcyHVRyjHYLyWEaSWyQJQfzynrSQXa?=
 =?us-ascii?Q?pbIoJFVt7hElpzUauWOBOLg8l1C7hzC41A2VeO+fX2a3kFoThoS76h5udkUY?=
 =?us-ascii?Q?pf56uU2Ga5MjC3cwjSTmcPjo/wt7bMQ4GUBnuvKgYdO3DPk3xz4QumbhCP9L?=
 =?us-ascii?Q?XFctkayqp5LmuySdU2oW7Vtwjdq+JUkWEjueytFTKeW+sFB+bkjgIOvS8wF6?=
 =?us-ascii?Q?OBG79bi2H4CKF2CKEtN4C4sU0+YI9esPFm/52w6OZvRe4rQSRa1r288kQ6u8?=
 =?us-ascii?Q?RcR/9y6oLbg6QE4lOgTyMs5CnGBUOHXq/k5O6KYA7Teiy3EITQqLuzm7k9YC?=
 =?us-ascii?Q?weizmO6q0s38rMrDv+psCmefYp84Fre2dMV759CbHpFb0QDEPIorEKEBFmk+?=
 =?us-ascii?Q?bfane/tlP6T2p1wVFeztveWpQzZe5E5LnxaRZ+av9dReoF8lzPul/CtARJbl?=
 =?us-ascii?Q?m0jfhecrjHIRzBznRIQcbbWPc3FXDVGAWbO+0txBDuN0jsZRsgOYczCSmGvp?=
 =?us-ascii?Q?c+JtaCfWtvmtgZbClMidNhfErwxYBOjzKujp1JdUC7/t9knt4R4EcqrDIdQy?=
 =?us-ascii?Q?rnchFayjf8af0QI4ipUx1LTBsx0pmG8RUY2u75uXhiFDWe9hbN5ookQWE+Wy?=
 =?us-ascii?Q?UIuSmp4R5nCTxAWF7Ru81kmR6I6RuBcZ1foZafEUPd13SVU8qYWzbJI8t5BU?=
 =?us-ascii?Q?QODPifU/6RhzpojD6rKWOBO01jtpxfi/TQ1TMtI4jtBuVwc7k/auYg4IyhQf?=
 =?us-ascii?Q?znt9ErOG/k1zPsFy08xhwxZDfk+UpePjBnJ+RMk/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e5e665-d9cc-48b3-a20a-08ddfa9d3d0e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 12:32:19.9442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHTzUxpWM0y/UTskCb2QjO0efZlOZ7z/OcnsHfnowLriZsxQhcmVu6ff8KdywFT8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595

On Mon, Sep 22, 2025 at 08:50:27PM -0600, Alex Williamson wrote:
> That's not what the spec is doing.  We're misinterpreting it.  The
> sections of the spec you're quoting are saying that if a MFD function
> supports ACS it must support this specific p2p set of capability and
> control bits unless the device does not support internal p2p.

Bjorn raised that too, but it doesn't actually say that. The wording
is meaningfully different from the preceeding section that does
explicitly say the language only applies if the ACS cap is present.

IMHO, from a spec perspective, prior to this language, internal MFD
loopback was *undefined*.

You are advocating for a very pessimistic position that undefined must
mean the worst interpretation for everyone. It doesn't, undefined
means we don't know.

A big part of the argument here is that in the modern world the HW
community has aligned that MFDs should not have internal loopback
because it harms virtualization.

We are here a decade later and we can choose to require quirks on
devices that choose to implement internal loopback, because they are
certainly now the minority of HW.

> We've had NIC vendors implement an empty ACS capability to convey the
> fact that the device does not support internal p2p.  There is precedent
> for the interpretation I'm describing.

IMHO it just shows Linux has the power to convince device vendors to
do things.

> Are we going to expect users to opt-in to securing their system?

Since the grouping isn't working right today we are already
effectively doing this.

All this is arguing that the burden shifts from people with modern
systems to people with ancient systems.

Jason

