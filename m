Return-Path: <kvm+bounces-24538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3E5956F46
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41061C21D27
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35297131BAF;
	Mon, 19 Aug 2024 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ca3iYC0+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC11A3BBF2
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724082797; cv=fail; b=fVatwkRR//Tv8lDjNuQZsRRsO9VdhbyrqvKZVWaQTiVK0RiDcNg9rIt5cwX/eLa/yzTLPYNKARoTpiZ04jiZyiWTMWRzF9pNlQ10w5OJvUAqc7zKpMKFGa9nedLsE9pDdxpLkNIStLHh36+mA+MwcUUuCCF/gPfhFQA92njQAZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724082797; c=relaxed/simple;
	bh=c8JhS/IRCm9uk9riaft7twIBApY5EDw1YCUZ7U+rqFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dMTwe+IKnDZ9j2KQq57Rnr0GmL5qAoJ/8IsK9W421bG8HC5UID63NDKxSCtmaoqePAjkqGfNbqeRXRWrxkeGG3slzrlt8uxx0NOgQtHlvQlJJdtpd6IiJBg/9TD4jpmz5wCn5PV+0PUN5EAFTR5X0MDLi8v37AqGUZFrR56yFO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ca3iYC0+; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEXyRtEE4pQiHUO9fSJJsRH9yJ2uc5GO+Rp75tOrZhKxCjvHL85z1Eo+L2K0zm7LPiWSKkX1XqkEqlRMum4f+gJovq4CIrfMxYi9Fej10fH/9RgSuX3sojhYoHN2uDNRfV0I6bEZuUVS806j7eEJdi6mp+OWuYSXbT4yZB20M68jEnz0UGveCsZAyKkQUv/1aE5ZtKTsL6uy8tODPqG3DVnqosTcEM+Fjfz8S4iY58YbLywCo3raF/dmh6cuJasBcNivt2vo+Gf0QO8h+QG2RgR+MQpZSDoyZv8bfDul8t/mqt1pnvojrDinJek1CbTN1kfKOTR/7uv1int+WyftXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuLFPxgfJUmswZZHRrmJR2na5MN3mDCPd98lsO/E0E0=;
 b=TC+zBHhw2EvyLeeDlUsDDtBsyPT/Th8j0nvMr4vvspZWntLXO4CKIBGLZxDK2pKL723pGTM9uqHjYGML8bhrhGaYmkm4ZlJa+s9714wQKkl2TvxZ891STss0dzwyn433SDOtg/a93F3r14pgBsIm7KCd2Xuj4QeKrC2eMqFa1CUbeTeVGzZWfTFFBems8YMqvJ2c7PivG8UhJjIZEh8XKChnXy2s36SNGhnqTZjXyGymEAqeICwEyaFCbN4WOW3MalAGuW0w4s1QGumgYic1YmIBT6oN8GJBUCzg6krPNrMqc/sutZlufho2lXRzhXABRntNdB1ik+MlJZNTF80Q8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuLFPxgfJUmswZZHRrmJR2na5MN3mDCPd98lsO/E0E0=;
 b=ca3iYC0+JOl7i8hdMTh/ZKvr5U5S1cc+5ULpUut00RLJ1wwNSMVQGTYw78/J+m1j4WI68VPdast1lq0gUlVKS3aa4ggq4pJjlXEuEj7yVOM0zD1T2R3MGzvtY+4ZZ1NREUVGMUaPWY1bbr1ihy/oIJ97n4Al7M+rcWVI1bcF6kJo3QidVADQMwErHNDPyTCCJHpZENklqyEd1dMtTx06Vf4mzxFcZC1K31+ikIdiJepSyHnXOugjXJ4P4aXE1o8JBlTtrhI62S+voWu7YSp3QwS+0DxKIOWBe2usr0aTgSRyMibDzoaFalA6zeRKgauVy2o3b0RrI6l42sN2z7c7Iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6151.namprd12.prod.outlook.com (2603:10b6:208:3c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Mon, 19 Aug
 2024 15:53:12 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 15:53:11 +0000
Date: Mon, 19 Aug 2024 12:53:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Zhang, Tina" <tina.zhang@intel.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 16/16] iommupt: Add the Intel VT-D second stage page
 table format
Message-ID: <20240819155310.GB3094258@nvidia.com>
References: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <16-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <MW5PR11MB588168AE58B215896793E83C898C2@MW5PR11MB5881.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB588168AE58B215896793E83C898C2@MW5PR11MB5881.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN6PR17CA0040.namprd17.prod.outlook.com
 (2603:10b6:405:75::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 511ee770-83b7-41ff-ab45-08dcc0670741
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uGW9VUUBSc51STX2h5ES7w5jGMh2fwAsf12HBpGdmd7K9gRrZl4jP4pPq06U?=
 =?us-ascii?Q?qUCOqpEgS2gOGwtyjyweILmwCSWCw8tewRcgDr1wFCtdIg7k9OyYwioMitCn?=
 =?us-ascii?Q?nxE39FOnfO2BXvDkyS4cI9a0OuOtOz4teOwNN0BYvHe8j++xkVqFWdEw0dlk?=
 =?us-ascii?Q?9TRvn5m7Y2a9KrqNmuCYTf80hx6CpK+ZWbnwiuNXiHAFhhRNwANapAIkQi3b?=
 =?us-ascii?Q?6FfOVk9kocXjKb188zmeQN6pg0X61/Ye/4DhtM88YMc5+A37/k0uOr0AitRZ?=
 =?us-ascii?Q?UPjLPB1shdIWaNag0SYzwp2b3KtYURw/UMg4fS7leLZJ93Sb2o9p0irGuqNX?=
 =?us-ascii?Q?jw4gDA1TSX1pon0fMENdwM6WSwRnzi3HONp6DmRNoEigtChVm8CL0MZwTI4h?=
 =?us-ascii?Q?VzGXjDZFmxl/KhT6U8nFcwkiveBnZQU6HB4Xa3NpviZKOHKbakfUK0LEMGQ8?=
 =?us-ascii?Q?dsJ3R1GfbPuX1Sl5xV9I7l9g+/1TOnfaRHde6Ei5VYqQlCW+jaODuPcxncGJ?=
 =?us-ascii?Q?KNZjftSo/XXf86hn/+Vr006bcfNqk9MA1M3Nb1jtZUDnKtsAbqrLNyhFuQvj?=
 =?us-ascii?Q?1nADD/TPYjLZ5FgYJmXyqlKHW7Sh9/Vf/cVqA3QqDlquhIjrSrbQ7d8imTyl?=
 =?us-ascii?Q?czFYrriKVmiHmgbEms2c8UuOuRQTo5lz7AGs+CrBVLTu8h4/0HJGZ5DZXK7N?=
 =?us-ascii?Q?6pCmgCh+PxJGK1Xq9fmPUcUxjatkfOmSoRL1Mwwar0c/gLhT6znPpSTKvOC+?=
 =?us-ascii?Q?HqK2VBYCqCwTwaVVNrU27M75WZ0LyJMaiq+SidDDNdcsrI6qD7VUj8yOAS7+?=
 =?us-ascii?Q?3sj00Y4fKNccJ+rZ1GPX9FjiJ2wMGXR6zl8Cn6bK9m18uz8cR/vuwn4O/0AM?=
 =?us-ascii?Q?mo7yTJUO3YN5sPPLVzgrp7M6XjYLl8BayqXnoxUiT3tRSUJjSzLl3CINzCmp?=
 =?us-ascii?Q?hjFlG7INOn8MfUMH2oi6b2wqJPztLWH6PSZvBInJ/05IP7pfFRMzlPAnrUEb?=
 =?us-ascii?Q?MDp9o4jt9iU5npjjWVuT2mQ7VIPHGuyxd36oCPBYE8uNGAN9n08Fv/6B00p3?=
 =?us-ascii?Q?/fAaZJNmdIVOrcVpRCF+wChU+O+NePBtefNR3kwc1hduvO2zoM7oBYHw1XWm?=
 =?us-ascii?Q?GVVbtxOtqkyER3zvEC5NrRFICYOTFUIiWbzxk7NES6YF3jDySROHAP5DZuZS?=
 =?us-ascii?Q?rioFzhJm70SkzvlpwNHlzcNECMO4JylIu0iDD3jO/YdoMPmFAyu2NSjXSPgN?=
 =?us-ascii?Q?y4TpZcF0jYNqlhPKYW3L9jbe2kAFrnZFc8xYwuwDj2g/l2s7K5Pzgagvy87e?=
 =?us-ascii?Q?HE8S+a5tZyN8SO36RlKjrlUwjIClHjOYDo7xizaNbNsFBg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+75UqftvWxk5yxMqLgZP+uCe/Hw7eEV+nGUewMH71vKfZbbWvBT7VEeE8Vyv?=
 =?us-ascii?Q?V1Cjn+xzAeDrvFSy9GqCPkXj0GVMFE2wSCQkK1SlklWSKkeMm5m45Ppst3ux?=
 =?us-ascii?Q?UU3wIB/GfMseMDVcIHuwap1xYn/nP+5n5WK/Uf6S6fNrpCd7NW8TGfmKPWoU?=
 =?us-ascii?Q?d+LAwj1v9G4Q3rmSmJ+qm/lY2IkmzBy0xsU8ZB73KCUMVoQLht7ugQd1WJhu?=
 =?us-ascii?Q?A6THxj8x+eUWXocKUka1tekcHNduoV8zG1pZ/8kYOa31xsJ6TMcDgsIZoZPw?=
 =?us-ascii?Q?2d6Sf2iLxTxlSwZ7eKe7GSnOIDZUAyTK4KD0z01dDKjuB8UdIqUXVim7KpTr?=
 =?us-ascii?Q?te5em+9fXIz/MiWJJNXUUDQMtzeOVkr41Tu8BixxPD7auMrgqdRO8EIKzU9m?=
 =?us-ascii?Q?/Cyuzw6pQw3FK68OH9+5K89ff4WaK7DdaWVmTTqlpA3Re34fiMGogKNg8+p5?=
 =?us-ascii?Q?6Ugyn73lq0yHfAtgc4Jts+zaXYLFWfkLSwNG5xUXKRSCpWp8I5dudMsMlHda?=
 =?us-ascii?Q?cL2NVMbttmfWqCjAo937tkvIrL0ubnoYiUuIuiVlZTukb3AeVOulNBXBCJGs?=
 =?us-ascii?Q?oe9SfyMm1MCHMYmFTi5//bjyXziVnqhj0ca5BGBd1u06rI9w188Fgqx4cMDZ?=
 =?us-ascii?Q?74EV2QM9ucCv1af1jw12/O5YNB4o8KPyK+Pnt6hQljJew8Lz5A2IQRQ4T1+u?=
 =?us-ascii?Q?lG0CMcjW/MR0ebcbhoTOuWVLQC7Oz/FhswvcFLNF5hJHj3Aw5Q2JUGnkMM7X?=
 =?us-ascii?Q?vBsC0fM91sUcNj0/wliXmK/Lafy+KFxN/lA+gbjsKl6qTmwpzL6lb8bA6pWH?=
 =?us-ascii?Q?K47rzHRB2mLjavp3FKGQQyNGvQh6rMnbYcYUFhouj2XGAUJjh3BWOtuycNrE?=
 =?us-ascii?Q?cP7Mz6ytgOtqsrSvids3mmHd+15RqpdTB60rFEwGYnob7j0RNozoP/oF2Qpd?=
 =?us-ascii?Q?2J0HpH7bNxqIBW9kVEMUPwYLaQhULX9Dq9yltYdZmuAtFTI5Ce/tWoIiuQHQ?=
 =?us-ascii?Q?t49rz8FY+G9b7Sy9s3yN2Pwdm7DZFyAXNjsf2aC6RBQjGg32YpSd+G4sQFZW?=
 =?us-ascii?Q?zyA0WMmlb/8dLQQj66bWptbytLF0jhey6LEXdkVUwJTBaQT5cb/ugBbvir3L?=
 =?us-ascii?Q?zm+g1hWmPhjSRdX2JCNwh1oUt2AZexZIoal8r9v1fVhDI3IfSwfS8WgEH/dh?=
 =?us-ascii?Q?qX71jEE5iZp2U40Mh3b6JU5PA+ZnU274+ts1RqH5dOeLOlzUi5xGagzV+nD1?=
 =?us-ascii?Q?FetRG8f4gbMH7NpAnkJG7IivZ1TPx+yJcoHfwECTFUrM9OBt0qZ/rzm42bT9?=
 =?us-ascii?Q?U+ZS/hEQ5PJ0I/h3XrrsaQJynx8A6/yb1ea25ZktmAE4WmPbeBSsthaVzAn7?=
 =?us-ascii?Q?S6nxSyGeonZ7uPco+w3u4nGP7AwuqfN4e1Eb0xTrrMsTbUoj3vjzQAeyM9dC?=
 =?us-ascii?Q?IRBU22vCjd/Ij1ogalM4PLNKBas7YJp1070R3oRwKQtTphYXKu6zD2/LRHzk?=
 =?us-ascii?Q?S2k9WHDQYZVBgiPY2RlWr7/DRa9PEfvGE/yHBY0iwfCzstv28oZeToFBU3NW?=
 =?us-ascii?Q?b1MCHaAp1phvk4TO6mSKuFbeEBXh+Uc3u7x45x1+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511ee770-83b7-41ff-ab45-08dcc0670741
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 15:53:11.6976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gedn1y/4PQDtDRzXqhwM5YoTQ/FqzDY6II+6kNKMIaJcSdL5LD1b9kazJw+H/yz5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6151

On Mon, Aug 19, 2024 at 02:51:11AM +0000, Zhang, Tina wrote:

> > +/* Shared descriptor bits */
> > +enum {
> > +	VTDSS_FMT_R = BIT(0),
> > +	VTDSS_FMT_W = BIT(1),
> > +	VTDSS_FMT_X = BIT(2),
> 
> VT-d Spec doesn't have this BIT(2) defined.

It does:

 Figure 9-8. Format for Second-Stage Paging Entries

 Bit 2 = X^1

 1. X field is ignored by hardware if Execute Request Support (ERS) is
 reported as Clear in the Extended Capability Register or if SSEE=0 in
 the scalable-mode PASID-table entry referencing the second-stage
 paging entries.

> > +static struct io_pgtable_ops *
> > +vtdss_pt_iommu_alloc_io_pgtable(struct pt_iommu_vtdss_cfg *cfg,
> > +				struct device *iommu_dev,
> > +				struct io_pgtable_cfg **unused_pgtbl_cfg) {
> > +	struct io_pgtable_cfg pgtbl_cfg = {};
> > +
> > +	pgtbl_cfg.ias = 48;
> > +	pgtbl_cfg.oas = 52;
> 
> Since the alloca_io_pgtable_ops() is used for PT allocation, the
> pgtbl_cfg.ias and pgtbl_cfg.oas can be provided with the theoretical
> max address sizes or simply leave them unassigned here.

It doesn't work if they are unassigned. The map op returns EFAULT.

Thanks,
Jason

