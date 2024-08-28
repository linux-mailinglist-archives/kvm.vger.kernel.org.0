Return-Path: <kvm+bounces-25292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 146789630C7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53E4BB228FD
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059E51ABEA3;
	Wed, 28 Aug 2024 19:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N1oPB0iP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE431AAE0F;
	Wed, 28 Aug 2024 19:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724872362; cv=fail; b=RdVBM8S9pRkoZfQsJI1Mw2bMXh0Uyl4Hf20uNdtZEf9szOGLD6yDIcY3Q6phVbnY2KKBji6fRgoMqbkglg0iUyKATtmuTBFBQ3aZsqB/6gSjAhyGuLpX24gMSwmvsG2riNeIcdcF/nB6tJ0NY1nHIUygkX0j9Vv4g8TK6lodZAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724872362; c=relaxed/simple;
	bh=A4Bkcemz6PzJDi9E/BCFHioMe1sMmf+3ei/LbHwANeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kJ6Ms622zP/3ApE73OscUEw1S94Hy21mF3BxmlUE457+sQJA4MOXRb7Va9/wx69+ZwRzzATsmech2AxkIsYiXXnrbV+SVrQKaupkbCwMYu91SpYO0AMxcpk7i+5Y/CcSkz3Xkk1LJJr9bJdPR6CAo3ZDlQsj7HHRD5BUnP6h/cE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N1oPB0iP; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ukcCzIXcNZYcht4evTq7klkmYWUwDgCedIBy1IDk2idKoV3qJxhHHLoHdyTzEpkYkQhdcliDD6kSBpLXwTCVNmepec5vOZMIlipb9WHgkNyiWBpCoFLk4R5tOoIoTDtnWr22MKpdauXPlmzvInA8KGxbHjIcnidICNKkH5BcI+BjnWjywXvdveessY/JaYc4JwiTk6UlkGErhMwo2hGkg3c63YfOxjCTo9MDQ3fiOZ+ARFIWE6+tcCBOBzVtL1XHQcMkACbGYznqfQ68XyZXR7v8gQXV0DxO/FNV6Z2vaE+dxydrgd1UNp88QPMNBSMc/9Wy1krrWxFNtFU8+CprDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjcG9khP1mMZ0VaNNry0VVpPyfxNUrsztYlg1Tw+/08=;
 b=vqdYDcUbk3MqOa2N+ut2CfsKbDG4B2amSfgoB4Khr1HMTTaKEbBY4yGZBCO8O0zCCvS8GOWn38OEZHw+dbf9R00c9WFV5DR2xpV34mj6bCUA/y9EyPzT+7hbAe1pp+1BZXrN8EMO2VjlDkx1khLKSPlNHJdyUIGK3rnQdpQXmofBMAhEfEiXOEZxngZL1X0zqne0xm7zWUCGfnvF8vHETFOiYOTh3NhfVL7nFmYQgCFqtbXqV0VeB39nOK195Cd+po89w5YmEbUeTKkVwto3yIc1e85yQBGE8brLjYLKJ90874zql44wfbrBFqY6QE54yHqYKWxNf01qWsHwddDbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjcG9khP1mMZ0VaNNry0VVpPyfxNUrsztYlg1Tw+/08=;
 b=N1oPB0iPasbafAHJix7g0kFJKCWnOyxbXGJEWgul3OtO4wANAwBYeZvKLgtpY3mp4b6GEK43fHL1XMGDXyUzXLKpISL38BVQcIXfCHAO4ORJff+JX492/GPlCtKz0W7sG27CYdvh01eXL65Q7PxLjxHcETEZKR2JGAV6lUAkdWu2n9Ln80/Y75xiUYZJkdc/jFGgI4a7yIaDCtGAUpn7pg7wL9B5ehZZuRyJpf2Z51tyJSZSc05k5Pvy8l6x1x2Jwo1DF2nQFLRXnSPaRjYPYdk6nEHqHLy5ZaIXfEJyAX1OBjo1Z4i6JFBwsIc1pY0LOa86blmns7eUKJP2t5Gzsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7241.namprd12.prod.outlook.com (2603:10b6:930:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 19:12:37 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 19:12:37 +0000
Date: Wed, 28 Aug 2024 16:12:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Report
 IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Message-ID: <20240828191235.GB1373017@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <5-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs4zK/5TPHs555Vt@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs4zK/5TPHs555Vt@Asurada-Nvidia>
X-ClientProxiedBy: BLAPR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:208:32d::30) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: 3151fbfa-e179-4136-5987-08dcc79560c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R2oWII1IsmBBsCOEEjDRjCI6UPfvJ9uhbNwolLses6X+MjWCUEQ/llrHPx05?=
 =?us-ascii?Q?wapTlHUKfr52GjDfkvYCeZ8zZQP537+ZlKDyICWqgP1v1aC1bf7paFczZn8X?=
 =?us-ascii?Q?DEuFDhIw7d2T5RbGnKhE/qturFetQoB8+/J2a88S6sJh4i91yblgTF50ES36?=
 =?us-ascii?Q?e/jwDnN9NWbkNdNzVHydVJDO+l5/nlc370sxpIg176jay4viVS01rCxUsO63?=
 =?us-ascii?Q?uy0jZVRtuZ1KorGmjWaKxattAKXGQLQIxw3xljcFj9O49zqVrRVJAA/3foHZ?=
 =?us-ascii?Q?jyUk8rKRzmT8W39jsTgxdJXAfOrwwqB2BZAVc2dbfSodmCCQ0zqplB4g+Qqm?=
 =?us-ascii?Q?I5TvXerC1/Fz4E98F80L2aTC5TRD3Qj3iwBwV9RwyHprB4UTuzO0GCkWXR3o?=
 =?us-ascii?Q?IRJSBY599N/ec0lNBomK9kpXXJ3L761DRy+XkOVMPb7IysWvcJK2cZnYFf5s?=
 =?us-ascii?Q?jbMwGfquB6p3PEhyyJWs10ymKLG+BCK0fdmEjseKXercFZoEczpWAhFfcdX4?=
 =?us-ascii?Q?rRxvpOB4RjPH4Sjm9gs2SzWku/5BNeq5Vvczooa3PxXv0OeGxTZbBpBn8Gfg?=
 =?us-ascii?Q?kTcGC4Vc/MG9kTB+f4tgUrWQbjFPi4i2zH6g00+EZCqYkd0Q11YS+u3OUGYI?=
 =?us-ascii?Q?lSJ7xsLhd7PflZsudPPDu7w3siQ3eoVGt/Fk1+m+Hz6k0R2/OEaa1WOTiU6U?=
 =?us-ascii?Q?m0+nt5W8GnQDmogyqSIfPHGSs0QSxUYR/o9uuakJJKWi3Vn8oGrmON37udKd?=
 =?us-ascii?Q?+h28+B1cqLMEt7eCLAWEzxHJ5hRB2+AZLFEz2n8u7fHdO6BAFhrUifTihO0C?=
 =?us-ascii?Q?m5Lh16B5ZUvFLb3xMWhrnKx1lDetf6J0sPR8PqReZCXIvx24LCA70sftbEAC?=
 =?us-ascii?Q?twG9Q/xQtRZ2K/D5Rzo0qvpIyEBq+muQUcgJ+NnvsdF+5RxlbKtpndcueYgZ?=
 =?us-ascii?Q?C7fI229xoJsUpCEkSohJm65NvZisvT4vsRCfp+vmzmHMVtvi31JKMbEiv8KR?=
 =?us-ascii?Q?K8XHZxI0vO4T+AHmXaGffLm1ktxTx5JGGaj1vGBNhj7S9TreQOT+ySi0+f8Q?=
 =?us-ascii?Q?DPs+i4fZC82jPovjArqOrpUYs3VpsG+9pF+ObZICcNpipzkUh4d/qWHerN3x?=
 =?us-ascii?Q?2c1ylARN+QBOHK6pGwezTGfVa73Oo9KP1P8b1qQPqVPZab3hg+aGjctyAJSe?=
 =?us-ascii?Q?xL94DuDJqkq5B9TEBECuKK2cBiebWDmIQu7mQBxQmN2TiFWT0G4ouUnMW3Sv?=
 =?us-ascii?Q?2jQl9LHgCkb5UgiCMqq69/JLMvRkJnBX6qJ/9RiHkg/j1t0fjIQBRjurvKLy?=
 =?us-ascii?Q?BUhXgDucHEj7A4Y89avg97Pn4noXzpJy+HCohTmK5Xy3LA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EiSZszJ0FO6rR2lrH2Dt4jH0QkYUMvjGdIbHrCglDdNtEl/OdtKHFEL/r9Eu?=
 =?us-ascii?Q?SyWUD1GR9mtUE/eIREqBJhvgR9lkh7NfyzrSKWrHp1nabS0VYMtM2oxUpm31?=
 =?us-ascii?Q?BM10SGH2S0XhRAu4kaPglj5DJBJ03w4Bi/HgYXuDwoUzFubDnip5N51nvrve?=
 =?us-ascii?Q?x2vUIUFVz1w4HuZw8qttz17Z5j9R0CG8uDIlB3w3Tylo59fkxoLOaL4i5Xeg?=
 =?us-ascii?Q?D+Cm3Ps4QDrFZuPEveyR4F+UtfQz8FtYEGQQxsdf5FYqVbP/QoqRXvxYYi++?=
 =?us-ascii?Q?gYAi8/GsoXC95kbznbALmURZUyEGmpHe/Vmrp2LW3I+R4297dFgBFDNePJ0u?=
 =?us-ascii?Q?HfMim3m410Emlibr6ZqY3liUGmP2bR7RqNg2uuODxNSyVl00ayMj0TBq/+pc?=
 =?us-ascii?Q?buuYfTeESWkGpnCUUhVUHl/Er0HweJZeFpvOy3KQIP2Uc/VL6Vbz6tyy9+mT?=
 =?us-ascii?Q?Xa3NUHpXvhb0D2PtcyMPL8j6IG3W6S1pNEhQXOuzF1dkcfcC3gjITIqxQSUa?=
 =?us-ascii?Q?lREM1cUl7Sin857IFI+FAXKROIk12tuJRGzPKOys+5+bjByag0CXis8IdNXV?=
 =?us-ascii?Q?884mdiR6NYlnVZn5vLzhaI83UPKIL2PgoNdz5xbz/Ji8V9gPfsz00wInD6Um?=
 =?us-ascii?Q?ZPXRFljNdClOxtlEvL4RE8I4wIxyFiGFfy2c/3+yAr1jXV4daK4NsJ2v7RtR?=
 =?us-ascii?Q?a0nkb1qyge/geMxnwfUR2iREzstyEID/IzqP5LYR6c65+HaQxEDi2A81tU/0?=
 =?us-ascii?Q?O5bxtqY4e1Mw4sUHXnaNC8F1nae6TscUytWmBKnCO/EuO8JdObWz6xUZu5s6?=
 =?us-ascii?Q?iRMsr0tywhxvEuxDZ5Jd8uUD83BYC+WMGZeg7L24am0Z4828gQUFtAgmiNdJ?=
 =?us-ascii?Q?FFFiqymIlJwdAitsOfoGKgtVRBgUXGTbR6Gef/LvkkrA+osErHaL22ndLZQN?=
 =?us-ascii?Q?HLkBJ2XB8FzKIqojb0RDnt0RaMqJIwTqvmCNUznWaVCs3tpePu5TBqQze28c?=
 =?us-ascii?Q?YcGO2h4AnQWK+K8q2997ngnH42UruxpeKbV0uHWqGIKLwRbXHxUCAfpK9GI9?=
 =?us-ascii?Q?hXZfutrtlTDYmnmIWWoKwQqnvAQc38lFYfMhS8Lzf+4vcRYFBVvXlXtw+7MR?=
 =?us-ascii?Q?vtVp9hL0DzMDBQQvV9OEjqHtPn3KellizNvwlXaPi8rKL+hZlKiLyoiI9Oi0?=
 =?us-ascii?Q?374Ja7cIGCPsT3ZnKX43ptheKn6MBFANygVQqofbBxLvVlp4LV+mo/qw/Ctp?=
 =?us-ascii?Q?RAKs/uxczjI2i/+e6IBn5PKkW1Aq8L/wx7BxgqAVAkyLgHn8k59TXRidWkdr?=
 =?us-ascii?Q?qw3uQKjapA3sN11ztHwDStm1CJPEuWR+LW6GlfE7f3KidT+DKTzWVY7hnFtZ?=
 =?us-ascii?Q?Xko+VyWHuzmWVK6LHdoF3CqE86hN9BLjJeJ+wCkWeRnn1cNYdy50dIi6rY73?=
 =?us-ascii?Q?G5upZqYtanA3r/vjW7XNXdE8HVh4xnA8sEwI8U5FYPlAJ9zc1hkeWJ3L0bqo?=
 =?us-ascii?Q?YUZcMGXjmADA/SjkwXXoh4bFGTevN0+ws/lnUquoziP43rJJiF6fQLlhaFgZ?=
 =?us-ascii?Q?8CIlXLHZ+0WqOoVWt2LQv0bvCJYTTGoNQdcjiU1k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3151fbfa-e179-4136-5987-08dcc79560c7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 19:12:37.0894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /OIFcVCbV0YjB+cpapJY0aETWs90AAirQFovJJiVl/rtBepffa6i8L/WBGEoOZLw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7241

On Tue, Aug 27, 2024 at 01:12:27PM -0700, Nicolin Chen wrote:
> > @@ -2693,6 +2718,15 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
> >  		 * one of them.
> >  		 */
> >  		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> > +		if (smmu_domain->enforce_cache_coherency &&
> > +		    !(dev_iommu_fwspec_get(master->dev)->flags &
> > +		      IOMMU_FWSPEC_PCI_RC_CANWBS)) {
> 
> How about a small dev_enforce_cache_coherency() helper?

I added a

+static bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
+{
+       return dev_iommu_fwspec_get(master->dev)->flags &
+              IOMMU_FWSPEC_PCI_RC_CANWBS;
+}
+

> > +			kfree(master_domain);
> > +			spin_unlock_irqrestore(&smmu_domain->devices_lock,
> > +					       flags);
> > +			return -EINVAL;
> 
> kfree() doesn't need to be locked.

Yep

Thanks,
Jason

