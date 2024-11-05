Return-Path: <kvm+bounces-30741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74EC99BD03A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97AEE1C2195E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13331D9340;
	Tue,  5 Nov 2024 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B/nn7GOT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD223BB21
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730819922; cv=fail; b=gvYI7A9SofBexy6UN05Kw2R2Jb6GdwakMRFLxENCZIPgLmnlBYAHTjUiJs5h0+7JjXudo3pQ1S4yEtQtmWzcYzGxpMMbQWZkRVuEQEnGw1uX95602CJbgWbfRlMOGdaNqj3r/X4fDSOieB7YJzirse4FrDiVNsADU4TtogPDfDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730819922; c=relaxed/simple;
	bh=yyTAYO07s6Unw3C3SlMmwEP8t0ls8Tw3n5Pj2qGI9Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=goAbjjIAKVcwoEcNBN5O8LvPMmrE8TzUJDiPqJzlEyDcT2uQfxQUSVig5Hr5nVkaXAbtzDmw0wDPY9jDGbcD/E0WQfxyYhUilxGD0CwprwV3Z/9G9mbXBc0PLfXzylAgZRrUHudTeCdXqtRI9hDC9ndBcZjT9MesO+TB38A8Qlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B/nn7GOT; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vg+R9cvzPo35BnnwqxCkFvpMaEr4US13tfusSIduzoWXY619vyDNfTfFaqGFH9B3zhWsPmccW1Zw4zKSMuI7mSnn1/kU32Xr1RUtVPcs8eV5+olkkt4WkMgEIT14k5jluay+o0uw0kUSWGPAeVbVfMpIEX6KCfOrrZ3fgPfIHFEl5TsUSIAGFx5iWrqp9rFO/fVxsSvlTaQ9sXSN52FRKO9DjUeCByOo+osbPl+TZEkTH/SgmjIrZZvMKvpN+O3qYaAcTQyy1yL69GohRJOqC2QUpCuV9RvMQNgyr7SbyrdIKmylA1dhT0xxHgRqApclvUPGjXMVarXlgjqEH4h5Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqwuaMWH9b32/U8WV9csa4j1l1bj6lwu1Geh84acI0o=;
 b=PGRepRaBUJ42yzsPrS0VFLQ4dju0H3yfc+VGI/4lh3lbadqXvjMja1FkAN812R72McyxCHiKdBQO1t9L0lJNSgvKzr0YViifPVnWCd5RaAHhK//XzEZa260uKs+9SBmt0KTAKdUmmvtGPf/6KH5ab3luddwJMlo7ogO79UC8q7y7eZMLRK5RHN0At7/ZBKf6Pp/otPNW8VlwkDKGWADpVO+bJXirNqZHe/Cxyrvzj+OQ+nSdJvCRvBLcZzwDVxZGG2+KiK1SXRwwzid6T10XyuBtBnxFZiXiEZ07ose0krI6tGlqV9CreazEKHOVxNEDlGrzwgOrxMVWaNQ9d21q2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqwuaMWH9b32/U8WV9csa4j1l1bj6lwu1Geh84acI0o=;
 b=B/nn7GOTyJed0V+sAw2eEY6kBOmfk6SjtlZ2J7l/WJiI1Vb+GRGEhl5FbkAb7/pYDwqZOeb1dm4FetMsO7xb6w0SOv1a8mt4/CYPNARjtZ+ti1EEfNYw4FMaENX3tc76XSL1vJGfwcH0HCPZWAx2b1XkY72fVQe4WskZYurPXfqy01UgxRaWUTuApMsj652KZ2Ijkh42TopQu3CsrfcBGQbgdL9NkBni/kF73bA82c/G787CWwZr9UvAavQ7hvA2Sldg1V8UMNQ7yznjd18kVnDrIhQHGSBg98Q3BtocfAEVqQmfz4HKqDqoIORw5iSRVKnZ1S+u/KoliQlJYLM+Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 15:18:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:18:34 +0000
Date: Tue, 5 Nov 2024 11:18:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, joro@8bytes.org,
	kevin.tian@intel.com, alex.williamson@redhat.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 03/12] iommufd: Move the iommufd_handle helpers to
 device.c
Message-ID: <20241105151832.GD458827@nvidia.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-4-yi.l.liu@intel.com>
 <41de13f5-c1c3-49a3-a19e-1e1d28ff1b2f@linux.intel.com>
 <2d1b8ce9-e0b7-41de-b404-d90ee77d44b1@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d1b8ce9-e0b7-41de-b404-d90ee77d44b1@intel.com>
X-ClientProxiedBy: BL1PR13CA0257.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: a80320f6-dbf0-4997-a45b-08dcfdad1d3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t9VZJZGAqws28EmVycv4njakcvW/C0WdNaHUKxKmOELUJ6l9IlKAY+U4szSJ?=
 =?us-ascii?Q?jq45HS55j8vvSX33ARaQJRKJFaNZRUQ02oeBROgWvUxYDk2qHvF14hqI0KZB?=
 =?us-ascii?Q?1Vb1o+h9SqVbq02WD1/fflB8XOu9luY3LjnADLl8yBcH2dhtAGHB9XT3gF3g?=
 =?us-ascii?Q?PMnuZhAd65p7jZYzZ3I8dPisv46jfXdb0dUepdktvUXg1zq+CO1EM4rEyXGk?=
 =?us-ascii?Q?Bgmb04G823ovHX0TqA6kgUI/TeJhu3t7Op5gO9GJvtDebXtdmB/3PB35+l+n?=
 =?us-ascii?Q?nBjiUT6wDJfEdRR5OgW7LvBRwN4YYoTEPhbCDMpC3T3BGUs1yU87MMdV/wBS?=
 =?us-ascii?Q?GjEj4mHazuxUN6fn7Qh5waBgGifPuylOJrHpMucgvjEB0iHxdFtqs05+wQax?=
 =?us-ascii?Q?Q46+PijOv+fbtya+1h6NsmypQJYrECoJd/qSFAgl6rB4y0ErhUVKJynPbFnR?=
 =?us-ascii?Q?2mGh65sUbzC+UKsY+bTI4xHDITGSC57oVNp+PxduP4KlDnySJ3MRG2f2FDr2?=
 =?us-ascii?Q?M2ZS5jt8Nem4Pa8Mll6WE30Hpad/gmQpCGQSNLfQFysAfbDBP+bHbgpkVoEs?=
 =?us-ascii?Q?2+a0YLpQLCp0uqG+fZmztSY4QcdPeF4n56lfrHJRTpdnPBnOtRmiptdLha1J?=
 =?us-ascii?Q?30JtBIQbaubEZS6OF0Ynl98FfrtPOEH8Sc8EwtXQRjCBwvTiCXNDdzzSP97q?=
 =?us-ascii?Q?FNmIDVQwyETq08ZXn1e23ddQyhoyBqravlWXIvJgIMOsog/Vd2AmLcPNusQc?=
 =?us-ascii?Q?OhJ87aFLYb9fqQhpHE5R6nLhekUwqgicyxFy9XipuOQ5Ad0uYMS7jUY8D+pT?=
 =?us-ascii?Q?HW256ba1TygBlPZMhW2DfjT3W+DaxpmR6lJVBaGihxcoI4O5afaKEEPX6Uzl?=
 =?us-ascii?Q?bBOw0T4CW1f8hHVP7QDzeBNzJ0loNHMmgGIkAynw0QlJ0fuR2qtFxoPC2c3m?=
 =?us-ascii?Q?b6qXrsSNYDlB96eulXzsT9pyNVf49zZmahgZ6iKqxW1VaQkzYwkUhs6ySHaF?=
 =?us-ascii?Q?cG3BVxBTpck68WCuc9fchInZ8/2hg9xs9DjhPe6dFyqg0H1Vp0j8ToG6X85x?=
 =?us-ascii?Q?bqqFq6jXRUJT/hXMa/7pkDODEUHm3FzpaPaLH4FWbE/iy77WYKic+OAiSGPg?=
 =?us-ascii?Q?ujIiz41Fe+RCLf1ksa1FAiZnRogpB59m1jnpm/+p0U/8JWInCKy2G1giDbSV?=
 =?us-ascii?Q?Un/2FQEL9nP73qgMtmFM2hw6w87WI8ojXDNVbcqx3BxKVbQg7Tb24inWbIAo?=
 =?us-ascii?Q?DVygzbjBEmBKrsZI2A1jI7aWXABRANniDuDDjlGJ6AaB/l1CvQndP0AvbrQ7?=
 =?us-ascii?Q?CBV6TMWxnMTi/lF/xn95XJco?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QyyMT1DP7d6TpdVAvcdjLoTF79vpeLupw+g7DtFCUnC5tb+/L7ZZ/2lP9NGI?=
 =?us-ascii?Q?nd2xEdxF230XwhL4gr/nfqI0jXF2RDp2+9JqvkIssakyKLbm90gILmy6gF5n?=
 =?us-ascii?Q?fC3MnksseF1Wyy8EAvf6eYON+6zbLx6Q1ZSBArEKeJWyg0MUphNUX6Y0trES?=
 =?us-ascii?Q?a8x6MkoipbxElBdkogfWyNsjp7lzStWIyOZNeaB3dGvs/h/xh3t/Q5lHLTL+?=
 =?us-ascii?Q?UL+e2CZbA3fAS1Ha26v+90SUsS+iR8J8vVMmOB3cTkQ1yRpmMrrgP2LxeADl?=
 =?us-ascii?Q?Zpk96N5RmPye+1qSWSRKyrMBoYvs/+YR8R0SVV7LDWbrKMt0p3hpuA2urLuP?=
 =?us-ascii?Q?rMSCxE19z3nS4JKtH3Z2Gi51XLLmI2mbDyQdcbY1e8QB1O/K0vctsVmSni4H?=
 =?us-ascii?Q?n/DxP/m5XNti0lVESr+KG73pL36ogZgpBUwATavOzCgP9fsUC/gyRyQD5w3G?=
 =?us-ascii?Q?z7+LXOEJOjTD43GWMvDRnyu33WSWyXuMbyGSShsJgIlr47leUgQgkWrgv7sc?=
 =?us-ascii?Q?hI13D1gtyHqB/FAvkdT8Lvu3YebMDIVLclqLFx4herTDvZsi40R4kRk4QKIS?=
 =?us-ascii?Q?Umb/8KNryNcg2iDhqmAC0vh3dggzO4GtQZa9WGjqsLSTgUZHI6aOgD94MjMy?=
 =?us-ascii?Q?zQokqFbo8IcBBpJPxli9yQGZSDHUDG5Tbw+QHb2ME9hEgfp4THgAs/Q/WZFA?=
 =?us-ascii?Q?5KWMGwKNLz2jjN31ntvaEwvjS29TNToknU6m6wwT2EqcULc1ZnDGsfcIhyUg?=
 =?us-ascii?Q?K3WphgsM+MbmpltOl3K9NYqGsXwjMz+qNmI16X6NeVlCbYvHGjnLRJZtadDm?=
 =?us-ascii?Q?unMgZJvmLSLFe7iKWFm8FosN+kLTgPYm9gxsrxVQZRSdCZUsytFVwxvkVj70?=
 =?us-ascii?Q?jGUdxKplNBIk4UOSElcUkAhVGyz1i+SzbXkvRPioxGpFRN7o7Lw9UQSbOyq1?=
 =?us-ascii?Q?deS7SK8BM0B0jS3tMpvhIl0AjhrqWFzidh8DeMnx9q0yFp+Y2vyGVDqe4XPA?=
 =?us-ascii?Q?me2MHCGchViqBZ3qr+qA7EXoO1Nr2snXBA86orzueh9F7MYERAMaTMlOSpD4?=
 =?us-ascii?Q?EMyKLkIfgefznRl270IBfG+rC/FWWVW+fWMXUQOypVH4mQ++kiVzlFMNeWjt?=
 =?us-ascii?Q?EPuIE/FbmRs5onzkgDaiE+nZfNNJ4UvKXIwAxB0nQ0yfIWQa9L671U14g8lu?=
 =?us-ascii?Q?s2ucmkls2yFumq+6QPwMZ8/GgCyN01KRRMy3ay5UQ7wwt65CkDBV9yEFKv/A?=
 =?us-ascii?Q?ywzg50ZZuE97j0gZIVQc/byWnFLynrX8959pBx1I6yYI4iMZsa6Xq7HntxUB?=
 =?us-ascii?Q?OVrx+wb6hyP7Ryye0fIjwX4xvdLsO7rvMjpxUCYZ1+aX0Vyw8k8NgNvc4dfs?=
 =?us-ascii?Q?t+Bz1cXqsjJU/CMUYpL030O8v8IsDkQswSFIL6NhORKw0Yk/hu0ev5EF7+ro?=
 =?us-ascii?Q?fo/id3xyhAsQ9NmBrmC6jvH978UOnq4PK/GCgVRj/Ss9wZQMN29lI6NghSNp?=
 =?us-ascii?Q?BHFIeVXy0zyFD6be1CE/GXkr178mV/xjNqYRJrSvROo/IhwNgfjYIG7lgJyw?=
 =?us-ascii?Q?0PmABeVsnfi67rkyNhpxqNxdcDmxVCHYJjitdl8U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80320f6-dbf0-4997-a45b-08dcfdad1d3b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:18:34.2821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8sLY9akWoaPBxC3IJztr+A8lSdirg/9x8c8yj2T/SjADCYNwyTxae0XH8XzNPJg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789

On Tue, Nov 05, 2024 at 04:01:24PM +0800, Yi Liu wrote:

> > By placing the helper near its callers and perhaps adding comments
> > explaining this limitation, we can improve maintainability and prevent
> > misuse in the future.
> 
> with this comment, it seems better to put it in the header file. There are
> two files that has referred this helper. the fault.c and iommufd_private.h.

Put kdoc comments at the function body in the .c file please

Jason


