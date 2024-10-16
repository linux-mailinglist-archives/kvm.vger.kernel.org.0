Return-Path: <kvm+bounces-28991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C879A08C8
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 13:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1502F284CA4
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 11:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C992420821A;
	Wed, 16 Oct 2024 11:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GMLo68QE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8178F207A15;
	Wed, 16 Oct 2024 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729079617; cv=fail; b=Z5+xADlmV/yc3OjXNEl20cymI/6ERGduHNymO7C4B2m+2XxoflJm1yAvlBD8XY0C2CgvKG0B7lfQkmQR6TPGz1fYSrZnsWUuWzpwSNO8bokjYIAdnmN1iNSnVQhNVZ3fbcbd/CiADLocW2fXol7BHTrXkcdkilP5qjzcWkppjKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729079617; c=relaxed/simple;
	bh=EFFQcrQUm9KZ47wHP37UOHnr0O0pQk5HaxSwigpdMkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R46aWZdLdN2Byuibi/45HW9Il6Elu1h0C4yIxu164h310912ONxKGhAPHpvFFyvg1Du/OYiHIXLmxKFiWj6j9+MRNm0RbXYtWHMNg2XbZU+qY7NO4+T0Qb/kJiMhclfQ4gqYzSx8cuxAO7LEEHBye7InPfyxUQ7U9aDuCiAvLG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GMLo68QE; arc=fail smtp.client-ip=40.107.101.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjrrQ1u9aBTMGwQ/nXkqA271evXycJ7i60YAdUvquzQiJ95IixodU0hQDbCWYCarLiYmtT2PJgHmAkDoDUrBE5yV9kAbomUMxkr1djhZn7FKWYzPvUegPRSfD6UH1IEE/oAOKZT+jKA6T4CYkrLoSwHcFx00+BaVEtodjUZEUWSm5kXHN8qmOoUb33i21haZGgYSv03+ylAWMZdzh79e7k9BPWdnwSxIvWkMU3qPiHJAZIafIYior59W77lJu/rxFjc/ImXRofuT+jNEFd3nylTJEPVugjNbdKJOW68u/nrk1qSZSwMnGNzJRZJhJuWfaSGXf92xs6ixH0iRnCnxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUERNgOGx6DlQhxJipDwZcUjRx2H/Psi4KWpeUlHJ5c=;
 b=kapGp7F2enmeDY6IFhNXlBU1i704W+Jl2YWQnpj9FrV9UBFyJtKEEETlL56+OKRMSjmStesTp0kmd8Bv1OttOH/B8AW8AegJZiIip3pei+hgtKstyITCCy1DXWVCMUZFp0VC1HcU6OETnVrJgB/3n5v6+dEAfCjtnAiul+40JWGuFnGSWdCQANxAlrRFZ9oJhFouhkwNImW9lVr8xLyPALPBYeOBmoqa4FnGADr0Nk3PU9jjHvSV8ZGuYh0un40KunE220LgQa6CQPnwahz7dYTiOt0XlY1pSpZ7PUYl1+WUMmPXorN6mdMMdwmAVY2HAT+WFxYokNMSHWvVDtMeuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUERNgOGx6DlQhxJipDwZcUjRx2H/Psi4KWpeUlHJ5c=;
 b=GMLo68QEWeLKWDXeOfPBvs6cKRafJ+zksEvTSr7I4ZzksMJJQK54fa+oa0TQt0ylCr09UX46vRofSJeKe7X9KS7Nty91W5eCC6q3gnL0moFIhFBy8udWuzwqhdnMVPPw6KwP7FKfHxiJ0TD8hM1Gcf2AGQ45OKd7lbehWB3dJqGDaNnbdwa7t/6ANTfMVee5/LlKVDokSuvIwPT1AKn3aDAuhnqv+EPn6L1xqSnEkQYqyB0ZkqSiOESRpOhNuc8uWFN29oqGXo2tVKbLYaNcZyppy+QZN6WbFMLpN9LRkurufRrjs2OZqj1PdFLlAkOw/hiBqH39LHzhIWMJ0aOe2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7549.namprd12.prod.outlook.com (2603:10b6:8:10f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 11:53:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 11:53:33 +0000
Date: Wed, 16 Oct 2024 08:53:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
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
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <20241016115331.GB3559746@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <CABQgh9E32c5inrn=Q5HWThuJQ4xV=EFWLGwbyxVLHQVUZ_uYCA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9E32c5inrn=Q5HWThuJQ4xV=EFWLGwbyxVLHQVUZ_uYCA@mail.gmail.com>
X-ClientProxiedBy: BN7PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:408:20::37) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: c48c5a94-9785-4be3-6f28-08dcedd928d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7OuUE2ZBHxlINdQ5GG7Jy79zzYflTT3gN7/OhkM5bwaTvEkuSBkloz/vi8pJ?=
 =?us-ascii?Q?IzhzwdH86QJa2RSLMWnWTgOn7fWKRjUDsfDaZtslbZzlZM2Fxlr5Gsnszrln?=
 =?us-ascii?Q?xkCdy5klqd0ly9w1B7OEOyEcctd40Uh1HYn4WM9PoO3OesHJG2Jnev0N+c0m?=
 =?us-ascii?Q?SEBhHmdEHAiYgTq/cna+cWNZX0TIBTpbuyfJa0dUtLNO7CzrQ1+ctNDZ9aXt?=
 =?us-ascii?Q?cZOpQBMgXkx+oyFk3KY7ddNmtYXyofnHTaW/kF86wm1ffRT8G0idR82yKD29?=
 =?us-ascii?Q?Wb6ODmenMSLYBCEen/Ndoq3IJaGpjffLcUG9o230DF0o0H2vxJWrXdx4fUrj?=
 =?us-ascii?Q?OuFY4becfGiHQMhwL+1RN6NFCqMXjkKgrjNqcOy6GB2OsDhaud0Q0z1g9qPO?=
 =?us-ascii?Q?CuFQmaqKBCabELV/CCjAoMnvKV2kFm9DUaEPRAz3R9F4sJmvJjRK/bWsxLmu?=
 =?us-ascii?Q?3FtOxsbkTkXfBMDBN5lRxzqWvJwtBb3I7lku1by+kWIjJEpl+yIhtSS0in/b?=
 =?us-ascii?Q?UxlTCMX+SgoUe78W3n/UcT7o99G8CNrDCzJJACqFcVb32+Hfm8PSCCy+zJ4n?=
 =?us-ascii?Q?2AEWfPhXdr77Lsz+MoxLQp9UALhS21IFnnvXaBxezASlCqQWLdDQhRRJjA/s?=
 =?us-ascii?Q?ps9qUNnX75FIiy6ITecZL93nT0kBaJJ7AdBPHaORLhwcP+QE4uT082R760al?=
 =?us-ascii?Q?ogOyXPi9u94SvdnpP+RBd/R00lgf6N4w61yJXUQyPHw1UmCtvGtg79n2m2of?=
 =?us-ascii?Q?c0DwykP0dPbBuwg4QYPAE/7gP8Q3vcqjAxCP/1gxoRf/R1wN6Ks5UY4fWYJe?=
 =?us-ascii?Q?4LgUZ3dWhxzyF4bRYAvrbdXSI02ZISknFwvRijFrYKbIFZ+pvk7ZxYS+xWYn?=
 =?us-ascii?Q?uAMT4TH2x/IC9mkjK7WLg76eRAKIuQDVf02PioTwDBXhdlpsw4jNdgEZbYRK?=
 =?us-ascii?Q?zT9O1ca/J2KLyIJBcAW/rdZRMpwX4LMRc2v3mz3ocdQhkySgVFt+MxWc8zS/?=
 =?us-ascii?Q?Uxx1dJnmBuvFOWCcQ7NeTF+aPkUksqLNbB7UKC3DwX0GoSLONkawz7VHmSR7?=
 =?us-ascii?Q?HADPglju05H/IZi9fLqAtx1CQJFzimAv36N5dnnro837IzFgAbc34mH4vCaA?=
 =?us-ascii?Q?9DWiuQfSN42M2acwRBxXfkTcD14ZcgTdtddEH9xsxZ3fbwU7N2PAluzzh7jJ?=
 =?us-ascii?Q?Xov1vCKaT64kcfA2HlYaFQGINoBxeMdbAIiAi7Of3z2eKBdEHgQ2aOIbriRK?=
 =?us-ascii?Q?MrOCMpvDmaiKM8R6FQU8TIqy8HOs8JXnVGiWfB1XmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AGBI6d+T79jsHhOJdBKyPzULq2+HdhBy3SrUkwu403iuky8oQRcIEstmRyKI?=
 =?us-ascii?Q?PrdDOybOd4q2qgvt1DO9oGWWcvC4ER+93ndQr7SXY93bcvRYvRzwNmXcD9Ph?=
 =?us-ascii?Q?EBiCSZWiQozBoui9C52IdM5MpwYwP7jHmqysrLH2KkseHHv/V6KLmAzT2dln?=
 =?us-ascii?Q?YR1qPGVT8bKMBT5ydgg8gdZTAYjHb5CSai9Z4h4OXzKN6x/TTMqu4GhC3XHJ?=
 =?us-ascii?Q?zXRe9EVJp5wd3/2Ez+cVM2iPDm2/lyVu0nbrZ0cl+efDOLHkaSeJatiEBMg+?=
 =?us-ascii?Q?7aT80rAeF/xBlCtRwAW5xr7ELktkENtpHwkjVqCCZDMu6SqQEl3YRHvj/dcZ?=
 =?us-ascii?Q?eP22VSU/b/o4zp6OiESrAOhftiFebXxeYSWg3VmEsB1LGo6AoisrpL1nxPxL?=
 =?us-ascii?Q?mLmXEiPOUYzs4zOJl2qTc1sWPWY4dJS9aCmSOQU5DcDsbTho9eRZ3REeJJCT?=
 =?us-ascii?Q?fkv+ktxP7G9MELNlUJkjPY8vwB6pERvcMSNntO6fsMYdnHai+6fUFf2bbOrF?=
 =?us-ascii?Q?WHFQUYvVePLoaDvctImHJkE/zHd8ApWvUgbaUWsOAq7UgQJyaGxY1Bt+402q?=
 =?us-ascii?Q?0dBfP3bjAbt6OGPULeyaGgltQ3SJWZyUatJlYQPoNQuSPlKM8NOo4D3rTUOS?=
 =?us-ascii?Q?WtixJvVUEpvSDuy1q6ntNPswR0bh5TQjUH6DZuNYlxvgNFg3neoysLhh2Hqd?=
 =?us-ascii?Q?5DobFtnwpMrg1MGw7hH5p8K99QXgAtSC3UFclopMjcdGaMtaJhLouRBNN3xP?=
 =?us-ascii?Q?ZvrYexRokRztVJ3q1Qot9j2gjO1QecjX4bVxBJURaqXrkU5/NwOknCBMQqLl?=
 =?us-ascii?Q?w1OVPQ5IWaPP9SpIaK8yGrTLMYU/rE4LBiBk9Jx3K7UjAJgB7giaIA0Ioms0?=
 =?us-ascii?Q?4OUN9fzL1IkyvTh4Ye9DOzh9pSH/6aPPB8rcswAqfybHVlJApiY4TPwQusPC?=
 =?us-ascii?Q?Ids8hzrHbKqqJslzbfcbzNQ7kL77PU48o88VrxQ5eB0TsG/glcafaLQJRwnQ?=
 =?us-ascii?Q?mO/yhBoWx0sYTokt/gP9K7qIrzN8l0nrG1Ir/4BxTJV14+Cqf9kDE4+XYLWT?=
 =?us-ascii?Q?Jr7PFKgBKUL2HXjMK23GnrkpQhUihYiLc9PNzWdYvfxjdumikSaQObmLzDvd?=
 =?us-ascii?Q?izKGFYsuyiS7tu/mYanLHVQ5/yXaFbHVeCsvXknIPTWlmCUpk6XEgtaJ9396?=
 =?us-ascii?Q?V1KJ7e8xKxg/CsnYDfXMiuyHJzeoAzfvNNowgJIzYj8TkmlSJj6tbvcyrVWN?=
 =?us-ascii?Q?X5Am+2xDDv+TAWcyGUezbEs6cozmMRU0VNKYAj27s0uMSXX9i53JGJPFa0SU?=
 =?us-ascii?Q?aFS4ILkbMFhb8d/yC20QOCQehLRgBfyzdE/GR5kmvHFxp/1TfNbseOcJumfh?=
 =?us-ascii?Q?CwieBf11F/rJ/HT11oU/s6nYy5pJJb4acUfIcRxsAoztMTjzgsGlkj8MM9F9?=
 =?us-ascii?Q?CiqVDLtvpvPXvN7oSc49BxLRANjhaJSFbOr92JDxtL1J2E7Fb7YOfhsy9tZg?=
 =?us-ascii?Q?OMNUeU5hlPlagT2MJ1dClrVwEDPRifvPiD35sl6g2f5TnfJgj33fLrWHCKzW?=
 =?us-ascii?Q?PoGjuUSQsSvWwkwYlNA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48c5a94-9785-4be3-6f28-08dcedd928d5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 11:53:33.0540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8v/MFRqDzMb2mGxpm/GUSP+09UrMxRTVRYUFY0l0bgQvQCcZgalpLcGzpyzreg8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7549

On Wed, Oct 16, 2024 at 10:23:49AM +0800, Zhangfei Gao wrote:

> > Nesting support requires the system to either support S2FWB or the
> > stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> > cache and view incoherent data, currently VFIO lacks any cache flushing
> > that would make this safe.
> 
> What if the system does not support S2FWB or CANWBS, any workaround to
> passthrough?

Eventually we can add the required cache flushing to VFIO, but that
would have to be a followup.

> Currently I am testing nesting by ignoring this check.

This is probably OK, but I wouldn't run it as a production environment
with a hostile VM.

Jason

