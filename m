Return-Path: <kvm+bounces-30054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D0BA9B67F6
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D027282022
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857582139A7;
	Wed, 30 Oct 2024 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k4e6JYQ8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2064.outbound.protection.outlook.com [40.107.212.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93442213141
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730302589; cv=fail; b=C8gmO3FLBsOWP+SKnyef+WvV4rVAZ8EAnld60fwnG7yVGQiW8eBg90TpXG9TMzOCWem7Z+WFGeqQK++RRmhF6r5G4YPUgrGwIQWbokrKEXTVecKdzFIWC9A134l9UStscSZsiNallCNBXImjuhFNrWmjQZL+LUhcJKCl092SSW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730302589; c=relaxed/simple;
	bh=C8jCeAJJMqAGNJWQ681EsG4Ci4cDnqQU0hjjAwasUFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EpGtw4DFrv/4zyvPtaURLmI+O+F6+18Sr1Hq4NaODOJBLk/ygNvZVJfNCfJlTyutinZKv5nfwiX+IsdoCnh1Hca2ib3J3FJJrJDE5wbZW6MdUROYLR2G0PTYwibH5ztFCZZ9cZgO7cxC4M1yPE/mpiAUYXYE/dxcH0GOIh8KC4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k4e6JYQ8; arc=fail smtp.client-ip=40.107.212.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2kIOmGAUbl95c1Dr6K+5gv7L+8nGF1/iabVQ+f/j7I/ErnzpEKmQlSxDm9OIJ712P5cxlRXMCysg2lppDIQ8UXYqdFFqsuK6G3NOxIjUzwsdZYklBgLluNmg933xCcKLc5dPxHfm/Vm/l1XRpQVFqhi7Jy+740AV5ciBdnUSnPTcia0H0+ufpQLtwfkZJ9bUrvDWxGVj2Cy6y248PIma2GEt7XmjqUyIszCe0kbVMYy08Srf8phzA0UDX0FLp/uUUpvx1ca9VRe8iBsbYIUloHdYhAkEwEck6zEenQqPFVj2wc3mch9VK4tQNQMzGxd8BUG4w404QMHpNjvmap1LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+pPHK00m4VvLiflrEaJpUeH1PCE6cVefzqCcK/HsKo=;
 b=fU4POiJfLpn9MGz1cXQiuJl+1cUP8MZIe3kRxJXvoOxl/ogRw67/2BWBX6tn7/zm20OxLs/4NZTgvksIS6oIBa+866AcZzcNZ4y+2fkF7oIHgE+csUAzRofN/d9aHjv6TCoTc/LPtv0DQ9LqT0H4izbiMqmKsIeD/RCyOzlXtWne5w0cAjbMI3oaY9ux/oAPXjPClThbWmneylZvv45+WZPVw+JnY5rdwyxQT94mdfLW0/YlR2h4oO05GcXdWu6POFNssLZTwlMOo5LdK21kZOD0BJPpqAv2uPAxzY9njcrgGxQ4IrjeUKcuRpVQGDNSaDWrGtYEwvhlQOdOwbT+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+pPHK00m4VvLiflrEaJpUeH1PCE6cVefzqCcK/HsKo=;
 b=k4e6JYQ8WK7hgmLu8PUePUs/hsDSJMDUmGabY0GJCyhJZ+tSs0BJH8Ke7npNd1V4SpRXxSNHMSyiuXR419Qh7C1P/JthpakYodysXgkjojejRqSnJON2+b7f7FZmeU9BlJqWIsGPFDwP/tgnzDzZWRvvl03vshQAxw0RZu6FkzhG3rgRncLL1XA0/KtKsk2LOpsMujbgTi4rd8yR47JjEn7gCKwNeLTZUNJJNhyOKIl8zyVbTRTgaFOif4ASQD0CwZ+qfYR8yjnWld2hasXVdySNH3MqAeTvN1qOaEW7A27x43/dPFRa3nnvQZzHtOBAd7cnGCk133Vt6HFmdrWvMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Wed, 30 Oct
 2024 15:36:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Wed, 30 Oct 2024
 15:36:20 +0000
Date: Wed, 30 Oct 2024 12:36:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, Yi Liu <yi.l.liu@intel.com>,
	Yi Y Sun <yi.y.sun@intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	Shameer Kolothum <shamiali2008@gmail.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
Message-ID: <20241030153619.GG6956@nvidia.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
X-ClientProxiedBy: BN8PR15CA0051.namprd15.prod.outlook.com
 (2603:10b6:408:80::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: 5026bfc7-e9fb-424e-bcd4-08dcf8f89a39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xTYsClcEnf4sGxW1NXVSQoDBLAgeGgh3tbaGVHs7QGdAcSgV7+uNhXCgkq51?=
 =?us-ascii?Q?zoyil9N/GoK3TwTS7k1oRmi0U+CNEk9H033Y+gsakctODWGtpks52SyiJ0++?=
 =?us-ascii?Q?wMvA1O9UqkcYn+J6xOTM8itei/PMTUq8UpKyE/tulzCMEjw8X5uy++/QB/bd?=
 =?us-ascii?Q?sPcfaBVJoHCOLqn0Lv8vYv8Leebr+7QybmSh3nry3LJdMIRwjYaNdesUXj2c?=
 =?us-ascii?Q?jkB5ORAjsELMyrX8KpcYpu3Wba9Yb2cy1DBYBZH3FJXDKJuQMpJDsIbChk7K?=
 =?us-ascii?Q?RcntYOdszIWjJ3BrmuCZqvfd65A2kk+h+0DHLA9Dr6WrjSrjsB0caqBsfVQ0?=
 =?us-ascii?Q?U6Zk2IoXteF2O+0WrfVYHNB1RH53w86nRMZ+P/3qNLcRQMCQ7owAGLhYdmNC?=
 =?us-ascii?Q?Cjyb8m54tANG0myclm6wFGs08G/dTd3XFyclO3ATwtCD1MHYJKTxwQ2yxLs+?=
 =?us-ascii?Q?Z6yTmtA/1iDMtl2lDsz1/9IywvBA30NM72Mz9Mh6koLrY5p1SLhcPGyd+TCk?=
 =?us-ascii?Q?mImVJrqlAMAABjHIPzhF04jfHkXSmb30aqM3ig3vFYKehR5tFK84JjIGXMtN?=
 =?us-ascii?Q?O8kUBRNzDdx+h+EPM6d/aA4FllrDYoPwuwgJ3uioC3G8kpxe8qyMnPycje5q?=
 =?us-ascii?Q?seVIZU9E1x50mlDDWd4S/RgzaKtL3Sm7dPHOtjjHDcjq+QSCRClpf1Mkne8L?=
 =?us-ascii?Q?zJ5cb4vjt1mneklVD2mB+jbwGanhRS/vQPKo5QItf+UxMhCnuA/XfplWrJb+?=
 =?us-ascii?Q?d4YIykpcVhmN2f6afyiIOph2z/t/ys+/eJtM8gvNPPkI2WlsJDgicKmsOagg?=
 =?us-ascii?Q?fHeuPuQ1EW1TR64DnMs+J3sDpfmvY3TRMjBSIozdQfvPxk6U1q7q7YoPOtuc?=
 =?us-ascii?Q?bAxns2DeH6Xq2hrS07ceUkpm5ATC+MXPf7cc2Dqv2Dokkm2UhuvMfXLvKiWx?=
 =?us-ascii?Q?x9dtrc8clqjC7g8OAJ1e9cZrqkgaDD7pXgdm3IjE0ukiSkB5GPpcILV0AKvE?=
 =?us-ascii?Q?G8li+pMKWACQeev1Wj9fdOMw88cwMZf031BCdbYLrK79VkbW2zGMwPPNY4KZ?=
 =?us-ascii?Q?sP/H//CoQgXTNUTCK5aG1vBrkuXp00W/qEL+9xKbInxmN0EwnmLl3/Ke0GNf?=
 =?us-ascii?Q?MPa6WQkGg9y8Mu2VnWbnVr8v6Hvmm9zFSviE043drsCJoj6+Qt8uo3O9pZP4?=
 =?us-ascii?Q?R4fG2ov6bLwzfEFmXj1+OwIRqIp2QWeQoDkaEZV3PLVWKZlMY+aFaXW52vVX?=
 =?us-ascii?Q?WsxHfQxvVzyQvH+MJWEyoLP4Jondz9lFg7SOZqSiI8sySGSGK1sDs0cXIE8o?=
 =?us-ascii?Q?yoSLfPFEbkGtZ8RaCgn1rHCy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kzF1p1N2QyOz6NTl92F5/6wtmf1Z01wdTgj/mX96s3Ox1DAD4bRRqEOUgKS0?=
 =?us-ascii?Q?ccj+jPl/i87Oh427D2i5Gh0/7eYkBoKlLW6dhQzO+IfYT8B9JAewFflRWRFq?=
 =?us-ascii?Q?r1M4itfOz7Q3cqCy4MjCHcopkB/FY3BLR3RAdopBMge3BJVnXYoggPFARKuf?=
 =?us-ascii?Q?ZIpH/yIpmEKX3at06W/mB61qe8pn4Xskc9NjTnWRzHkF6S0bHenChnpluei/?=
 =?us-ascii?Q?JBMoqBe+AU3uB8HuphypDkMpXh52elqpEGAWK+YZ6l7MjjD7/kk2Ee0HRCOI?=
 =?us-ascii?Q?PFX1Qo+0eyV12jaBe1586SSiOUfgZUVlemGTpD80R7d+NjvYC3OBl8gUQTM/?=
 =?us-ascii?Q?pL/qlTBSPAOw7gkrlGqqHOi+CSkeBFZB35+i7+6koMKMkYZiLI/dzk6v0qCv?=
 =?us-ascii?Q?cqJh26GozQyr8f7LraEdC0rR5Tp/eK9ARubMwLzl1ZzKhO9TDigyD/qY8Za5?=
 =?us-ascii?Q?YUUJuvZambna4WtAA/+WyglepoPu1dFyqrRjkJgzzAvkjJYBQc5rfi4wFBY5?=
 =?us-ascii?Q?GdYug1sMHikAViGLNMVWxD4wzwg+fi1mbdbncN99plFk4UE79VYiekUING/z?=
 =?us-ascii?Q?ns21mC1PPBnETlwfKjM5pa6y/V25yFJ9/126MMP0davKREBPO3EdKUZs2pYV?=
 =?us-ascii?Q?JTFGmGc4sVxlpRb/Btk1hTKXtfd7yxg2uVJFR+wTof+Wz7ccZwN3cQHu+L/O?=
 =?us-ascii?Q?ohKL9TznrjUCusYegJvss/i9OWhWjfA+hS2OZVotOiFnjNfTbL8KUGuxceVf?=
 =?us-ascii?Q?awNfIAhfJ9I7QY/FypBmP0N7fNOXqAxLCeuv2tX6TtDNjSeICK53mhrM1iQJ?=
 =?us-ascii?Q?NJIrjBMECguc9rpfnDjN8u/wQQUJh8gqEuHhgOg4hVMmlhxatcl/QBer9dUL?=
 =?us-ascii?Q?BAglcTmJJiX+I4HCs3pJUXZVf2/Nb63A6YjwQ3JhbQT49JOWPedu1PIMXOLZ?=
 =?us-ascii?Q?RHdf3/RAZ+P42GHCoxYNGf1QQjoDeGkQZaFotaUiq4NUkNNhfsfMtZS+8kF8?=
 =?us-ascii?Q?QNMHupFqKOfogadT3B+7+G+wzI5schC5dAC2+ZLh7Jd+6eNPaj65VkxxmCYI?=
 =?us-ascii?Q?Qns2vnNgzGk7E2wsEci/xKiJ6BbtShCtE8IWM9z02OkTiK7VRtiO+DJIO+hw?=
 =?us-ascii?Q?9VNVNX3zpS6qR0ldtlukmiSeQpC3mxmWAHNPWlgvwVC3o3L74GMyCWmIjkux?=
 =?us-ascii?Q?NDCZ9A+GxKEJPnyGWNWwUwjfWH7taEPYNAJ9kIlFrXJZ6bfkuc12I15ebQGQ?=
 =?us-ascii?Q?IjiwD5zVkh/cM7BFPm/j6vksgW/dfz4PMdxWiLGiIuwVBb4wWvN0+oMuVN3y?=
 =?us-ascii?Q?U7qkKZVowU4an5jq9cMT3naOf1wo5EiBH9JBh69/LmJ8wHna9YvrgPQQVkYR?=
 =?us-ascii?Q?W7q9m8AL5olGvioUtliCLoFMtVXPV0mZJUbZsIBPZO0rXIivxwbFCIIPUhd4?=
 =?us-ascii?Q?9O/CvOL2ii5XCSho96S9WYoEH5RqzVC6IKifAmN+VwQVL6P+A8c5iPYdM7Fb?=
 =?us-ascii?Q?72en8hllqMyKfgmYyoQ1XDr5YvPdlm/bB+SeQ6urYjlV1vrVqeTVSenRWjgc?=
 =?us-ascii?Q?4Mf14pnlYi/IcayZUl0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5026bfc7-e9fb-424e-bcd4-08dcf8f89a39
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 15:36:20.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c58GNAm5yKoBIxg6/4W6Flnyc36/6nXt6qex9vjn93wt4Hl6ca6+98JKjHloUqau
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6218

On Wed, Oct 30, 2024 at 11:15:02PM +0800, Zhangfei Gao wrote:
> hw/vfio/migration.c
>     if (vfio_viommu_preset(vbasedev)) {
>         error_setg(&err, "%s: Migration is currently not supported "
>                    "with vIOMMU enabled", vbasedev->name);
>         goto add_blocker;
>     }

The viommu driver itself does not support live migration, it would
need to preserve all the guest configuration and bring it all back. It
doesn't know how to do that yet.

Jason

