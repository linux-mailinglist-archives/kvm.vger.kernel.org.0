Return-Path: <kvm+bounces-62411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A912BC435C4
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 23:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E310E4E2135
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 22:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581C324E4B4;
	Sat,  8 Nov 2025 22:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gDuV+wuL"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011033.outbound.protection.outlook.com [40.93.194.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA77F18E1F
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 22:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762642731; cv=fail; b=Jq6t57Nahk1w0EqFByVzWKyOdjB2BW4enzy/Qaor3aFw76DBYZFxodI21YZPp/3Y5SIVc0X/b36gZo/BiNZoe/vquWOJmLrJvWJgxFiISuWEMv3ei25Ut2+qoDLNNLab3R1xfVCICXBGhp6/tBRUHb96VZ3i43il6whZ11G/3AE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762642731; c=relaxed/simple;
	bh=mqWLwZlCDF/h5Anq7XbzC7y+8C+3bPkYERfRUaltU4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ifSNiPhZLhzCU/+9gTb1pTdAsbw5QwXBGNQ02938qLfhqGJRaWFA5pl5EfieKS3Y01t8f4JSdmFawFEvgiu+36mYlc2Dk5OwoIek8020tAK3RoW8sgT4N+YAoaqORpJrbo/+UySB1APWJ7wKKdJqlq4eHt8QsLylDyeksB+6N6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gDuV+wuL; arc=fail smtp.client-ip=40.93.194.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYyq8Zle6xKPJsU+YTD3NXfOhCgcHx3ZSUVfoC179nzFsiJoImxOT5gZxdy+a2clExGwmnoEmqSJRNURbNWO1uzJLEbwuI/kjFgTvuCzjIqtQ5qLrKfx3+JQmO1W4OogHIlvtgd0UXci+LNEw+h/Dlqvq0dkCjRcIDduK6rl1EaQnyM1H2hBPoROATjgFqLFTvQJI0PKCOMvvittz8FBBJi4qEepQcuM617CeafpcZKLP8mQaK2GzzI8lBeqoOrSNLzFA6dpG7nUlcqUy6ojRSyApA/pJSz9FPPQEnsbS/6/S+7aXJClOJ2wTo3TyTmwD9uD2KjoLT7NBLqcT+TAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DvpOcMUz05SNJOvi3EOdRQdV8opsKsTMZZQS/i2wvI=;
 b=F679N5nonbkZ5xBRGhmeShQvS4OwpNWwlyc4FPSax9aQ4bsdGtCbhBFVh/hd9zzM6w+YGKZNYt8DK1ec5F16x/kQShL3rgQlAxbwfrIZQwrV5OQ+dKiWoTjPVadPta3IBtMASQtVmOQ6YWU6hQuysN967o6Z6zZLWk6M6dypvB0iB12owRXqGQ2bue99WUc9Q0bTuQqtBMWZuya1PcQ5y+1xSWq416BEYehr5YNo3npoKzO9HJQ6Xe5+hbZmgkq5hqrREHSBzIhZDxzB1CgnPr3QtualtOJZZspA5huxR+9KeARGQ6H16wDloL+Qkq8gAnexieqXJwNhwqd/z6Fxmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DvpOcMUz05SNJOvi3EOdRQdV8opsKsTMZZQS/i2wvI=;
 b=gDuV+wuLa8+pK2/Y0yLSh862qimJM6fsUwpqzIyo8THVZmwdIJr1srWUsh+NDurd4zl9RAqaukRBFoPAjAHIVmHaChrFk4kDt5/VNNAb19/ZGmgPw1pChP4R8O7LM247a8uhxiBapSkrjKl0MGDnwLbuzt52XeWNI5mXS0SJrWUda5WIaN5yUMGJHu/0Yx5xid8mfdaJM0lQ1o3ULUbq9P+ADv9PhoNndcdXNpzs7oXpS+HhClkoIAyZ9Scm8IryHT4QGSDRDrGLS3aVlRkMVAmD3HozYgjI3Nut8fYE9KU0Im6hBIsUnGRZDkh4xwQMAaSanVwpw+GPbZfXrVY7HQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by DS0PR12MB7899.namprd12.prod.outlook.com (2603:10b6:8:149::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 22:58:44 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.015; Sat, 8 Nov 2025
 22:58:44 +0000
Date: Sat, 8 Nov 2025 18:58:42 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
Cc: dmatlack@google.com, Alex Williamson <alex.williamson@nvidia.com>,
	amastro@fb.com, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Incorporate IOVA range info
Message-ID: <20251108225842.GI1932966@nvidia.com>
References: <20251108212954.26477-1-alex@shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108212954.26477-1-alex@shazbot.org>
X-ClientProxiedBy: BL1PR13CA0448.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::33) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|DS0PR12MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: dfc6ff8d-7920-44b3-771a-08de1f1a5de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?to+zJWNwb0dImMH83sdirEud981VLltwZNwSLs2fpN1FWsAlK/wGQns00DvM?=
 =?us-ascii?Q?B86XBo/71opSbcko2RhUzOWe/1MWqrzGiAkisxOeO8tobV15Wzvh9Oe0GWQ8?=
 =?us-ascii?Q?I4OI/F1O7YYov9uj9fO75z8yTsuGQJNwWeE376gi4cr4HIJ61xtJFw+NBU5p?=
 =?us-ascii?Q?9O136oS1c8vQNGzTha6CLD65P4628Jq5qkXlSYISrGgVr3JuxWLll9l592EE?=
 =?us-ascii?Q?P4OgKbx3DZr044w1xmx/Ilh4/znjDIFIElZIB8XCltBaMTvLBNu4Y48y6hEb?=
 =?us-ascii?Q?OnpOBDroAeg7X4EXHUvzOR8YFDBsjW79qQ1LN/vTAGXgcFd8MnvQL4fsWcch?=
 =?us-ascii?Q?SbLysbf/bVSOqrhhcnbMYrzwqh0X+UdSYeVjzGXjPd3Tes1OJiivFlxxl44n?=
 =?us-ascii?Q?kY1HdViuoMABrODwfepk43FPljiVRZIP55LbgaGc5Beur0dLOKN+UbN4RrgG?=
 =?us-ascii?Q?u0SHU+9m328kkK/BriGRlilnQn/CDbZc9Ewh1wJViQaem1exiS1QmNI4N0nV?=
 =?us-ascii?Q?Njuwsu0i5kbbW+NAYfHPh6wRexauaZEwkTwaJEFrIKuBLnmra67Y7tzQHcXR?=
 =?us-ascii?Q?lokW/i4wqhtuLzWC5F3Pfr3CoXFKoS0Mxrujx/SDoZjtcMZRpMRFWQANQDJO?=
 =?us-ascii?Q?tmpUzMBVGqi/XGPOjVGbT3ymXhrlZV9QaqsE7kyEtEkhCvq2pMLquR1F3HzG?=
 =?us-ascii?Q?TPs1w/u879W2Q8dbfN2dyKZkthaGAVVVeB5OFQfnpdy+8bOPPqykl+Tht2m3?=
 =?us-ascii?Q?TdHQIiGaYBS0kFxCFV0GKIrk8HRNvz2ASzHfHw1cJTkYpJsahxgAzsChF8Dm?=
 =?us-ascii?Q?o17LPwRfadhFjhHXDWWkUs9ReUVi20kEWE3waWJ4ansqpgBEviebhHa3ruFp?=
 =?us-ascii?Q?ZyOl/1CdB1shfj+AeGpbud7eE5TxPGfxEpnyG8RZ5dtZROZwFXI8cyLj0bl0?=
 =?us-ascii?Q?8SoJW6jtEKPsuMN7ZYbdWLnprY6VePgEnrHvQDX6v8o1sqR5uZutvnzz2CdA?=
 =?us-ascii?Q?68mZrxo60hjpkltlEFzsU4P26dk8gTND3tacPFP5TpOBBH1K0hUSHTUv3gUI?=
 =?us-ascii?Q?p2eDXOfBbDFxGDQQzsJMO5cuAtbzULKwZVmm0fQidnC69wbV2g1rvbgAkorh?=
 =?us-ascii?Q?AuQ3DwM3Rd0Hl+gJmxOHd2jHxDBoaXwHGxDPkIeR84usnET92YKg5IcodcJJ?=
 =?us-ascii?Q?9rzrC8DSL/CoKQWIZJCZB4NVM5t8cwnGLoKbXW+qYz5s2Wq5UQtrHHIgFW2I?=
 =?us-ascii?Q?z26IZykazqNpIDUPncEi0Fjrm/auPKtlqWNyzMV/u3Oe6qY5Kyo97BLtZiIn?=
 =?us-ascii?Q?zsig/H5FWYtsOnEbY4gNAIOrk379WUfSZ+o/GcpIzWX5/W3XdM4JCsiwjlb+?=
 =?us-ascii?Q?xWG+4sBwuZn3rsPCCjPf195z6ObOfoAAk1qUnv3FraVRMp4/YPVSpIbZI1Ui?=
 =?us-ascii?Q?iAskof3ealMdJ8xp1zav0yz7O+fSXsjZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fATo/E7ECp92cnGiIzhc5LgyXgSbBOn1hSW+Bd4TDx/FtmBNkQwbKmpiO8l7?=
 =?us-ascii?Q?mRLXGPMo4bjJDLRFR+Wb7fRphUXHZ8883jV9LiiFEALuFgGQLevLu7KXQcXr?=
 =?us-ascii?Q?Fh/Y4yIAx/4IQC9b5yOs+HxhPMwvQotrTHVk/+00/1c2o9JRzrCXfRMP929/?=
 =?us-ascii?Q?X46dRJlt5/rtVjNaGDNWU0CQHWvFlP9KlMqszFDyJvrJAjSpRt1cX4F04oyX?=
 =?us-ascii?Q?L0AisWzkV3iDOHMuZ0iOmD9YVKUMLoDaDPFsaxKaqfVdoYoUu9KYApkGSUmC?=
 =?us-ascii?Q?2qsZ4XTA5IQed+1Yx+4ewZdr9HMa3TdHl+w++lO7M85BuXj/KbmiKm5eiEKu?=
 =?us-ascii?Q?Ww4Sw8hPbuWF7CjjTmxV0mMuGPIEO3RG0JfBMp4jLRTvLk5kMEk74wz35Inn?=
 =?us-ascii?Q?m9oQmGf99Jor521kCNR++eOa0fvqujPJuY9iJ3z6MGZCHNuVGuKAecUEkap5?=
 =?us-ascii?Q?a2kymsGbF9acvY9YdJd432d/K73WGEwHNr6CHo/SQFx5CjuHunbUgTrDPj2H?=
 =?us-ascii?Q?nA1EjYbpPpMYp80C3+FUBevwmoPSKhqU0SwAYnJzpd8Y2KPD/AWK4Vyb4kHs?=
 =?us-ascii?Q?IWnOHyqmR5k7xisX+UY09HC8O0B4XNSSMmNNMnLGCNOvF6G0HRlvQ+FZtRCK?=
 =?us-ascii?Q?1C8VeFyyhroRxTfGJ2hhJpt6xdggTRCB958QcH4ksCbpa2lnNhbdJ+qZ9nFH?=
 =?us-ascii?Q?HLDRuQZ7mPJpM2xA9LU0DlkT2feA8x2YCaOm61qx3y/tGQ8au0m9t93sLnj/?=
 =?us-ascii?Q?VlNR8M+TAD+mUqVEwisilcXOvmFoCSpW5w8s6wjod8fhlYsQQEXgERGxB2Gk?=
 =?us-ascii?Q?Pa4Jn7CEDQKyBA9hbKYWRcMIYOQmMPNwcbQB04hUqmFe6p/JLBZNTORNk5Bj?=
 =?us-ascii?Q?7zww2VGtpS/SVuvJsN7hXHJkqmiltZShJsTPRQaw/QFY1wxsvwt9IG2mpKAs?=
 =?us-ascii?Q?nvy99nI12NCYAxH86JYtSLmNHaU9TA/pgHRHWJo/EGeeoFE5GC7AxRWeStzy?=
 =?us-ascii?Q?YVqEsvyfEQ5o6wc5FIVdJD75fKcprk6BNExxyUEQcg/N+yDUN9Ikh5xDFNn5?=
 =?us-ascii?Q?zPC8B9DjqAUUNbuJQujsDAhgNdSOWGmHvzhviCfMkkmoPmWn7LH+Hlqb912H?=
 =?us-ascii?Q?0SMRUAZWeTDDh3pZJAQuAfSfpxIEbInDjRSvweecrZlfLzJ8PWAmnF13MVAK?=
 =?us-ascii?Q?ZZx7VFnCuZZSlzevGg473TJ/sH6YEKyBxhQcyh3IKCEItfplVVG/XzpGQOcl?=
 =?us-ascii?Q?w7qC8F88tVBwaGvOMALE0mZ3GuAMU2d0Hnhg54KxBc1em6uhE6t5E+3rZyRq?=
 =?us-ascii?Q?hx1Ga4PoduMrBXAl/XDs+Re8vlWfBhK+Ecwh4wMI0eXacHRps/m3h5/SWnlP?=
 =?us-ascii?Q?4RxAdj4EeARSJ4Sp6QiY7b1NWulxxrwpyFe7itRhHK9nuxu5mH+QCTGUYAWH?=
 =?us-ascii?Q?/hYCvcrW08b12pfeDOUOEXSFQmLCgW34oy4MhWAmeersmUu1Twrqaev0owlm?=
 =?us-ascii?Q?txVKKetOKqSH8npBiMMrWz7aGNfCnUDOB4D400vK8uL3Xp9XN3qrEe9uyikN?=
 =?us-ascii?Q?WzjRW6ha9O76U6YiR+8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc6ff8d-7920-44b3-771a-08de1f1a5de9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 22:58:44.0085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amDjbFuXYPq9AlMNtBFqN3FO/yeFo1IOSrr8wphVB0f+yMUksrVaYcOHRD0xQyJ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7899

On Sat, Nov 08, 2025 at 02:29:49PM -0700, Alex Williamson wrote:
> From: Alex Williamson <alex.williamson@nvidia.com>
> 
> Not all IOMMUs support the same virtual address width as the processor,
> for instance older Intel consumer platforms only support 39-bits of
> IOMMU address space.  On such platforms, using the virtual address as
> the IOVA and mappings at the top of the address space both fail.
> 
> VFIO and IOMMUFD have facilities for retrieving valid IOVA ranges,
> VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE and IOMMU_IOAS_IOVA_RANGES,
> respectively.  These provide compatible arrays of ranges from which
> we can construct a simple allocator and record the maximum supported
> IOVA address.
> 
> Use this new allocator in place of reusing the virtual address, and
> incorporate the maximum supported IOVA into the limit testing.  This
> latter change doesn't test quite the same absolute end-of-address space
> behavior but still seems to have some value.  Testing for overflow is
> skipped when a reduced address space is supported as the desired errno
> is not generated.
> 
> Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
> ---
> 
> This happened upon another interesting vfio-compat difference for
> IOMMUFD, native type1 returns the correct set of IOVA ranges after
> VFIO_SET_IOMMU, vfio-compat requires the next step of calling
> VFIO_GROUP_GET_DEVICE_FD to attach the device to the IOAS.  If
> checked prior to this, the IOVA range is reported as the full
> 64-bit address space.  ISTR this is known, but it's sufficiently
> subtle to make note of again.

Maybe we should fail in this in between state rather than give wrong
information?

Jason

