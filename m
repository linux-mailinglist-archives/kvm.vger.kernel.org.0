Return-Path: <kvm+bounces-36008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 025C3A16D2E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FD661883589
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03ED91E1C37;
	Mon, 20 Jan 2025 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="baQq/CxG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0CB1DF96B;
	Mon, 20 Jan 2025 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737378748; cv=fail; b=S9Ce7SHdMjB8nWnkgbstmYahWx1wUiQWU+VBkcUlyqd0foJI+wUtSV4y8C3LTyava1zwAZKrc5NREUKFEWZrxEW8KJsgt7C/MW1wV4tRQWfz3uQV8oHD0m5TM/haU8BHnPIhYyKUxfmzc/k39dKRIr3hTlBYLjGCcHi5/j0sY50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737378748; c=relaxed/simple;
	bh=mud9iwW3+jMw7c4kglAFPeUtNNZepazemn4LubUn3cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tfXyhlSOWuG+Gr448O67RXTaeIdnjN5vUC00Rif6MATAwe+70Ud7l14HXVaeRn0J+YIJdI8tUQxVc0OoYFmR2rnJRpuVc+NvGPtye0YbMlc6zG5L8sLTqUn5Lus8kwD7EQlDraDafUYqh7g3ndeyYSrhK1s4zUZt1uv8wQURZw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=baQq/CxG; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNw+Jt8nX2YgA85RjvwU5m9cV4tkrrBU0PsNYdkaewQ4/Qjr/v2+Rqenh4F9mgYP4/M+V9KSvdrQna7oiQvjXpYpJvu4Qp4T9z0drGMRfsQWUhrLm389xZlQxswYnTzo6L5mdreAzuvAbYm7nXf8pxBaLCDlRMuUr2OigXxk2XtbuLp5SwPPgj6uIsjeJbGheCt+6WCFNO+uDceu0RWJMYrcFTExxGSmVkyslvH/1t/XyP+Wk3jD//WHXOsL+yhtFOhmw36uk6ZOGfokGlTVX2H8/FrW7qvTV+VMv5Ri0UhsWme3cdDU4Kon8meAU1zqAstU5VzSHUWQG1bdc9jw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AI+pW3nkFMl0qntdChPg4v08tnbkuHEMIJJTrALVjtc=;
 b=fx4MhO7W4sswBOMRyIN8FZUgz0ke+OM6U6C092+ZQiq/5jfosgKqlxOlxXHNti1lwLiQw1u2FK09MjnNJiwxzaJQSjIohqvtxVVXVyd7p+GuypJp9myloWXnxM+Wpp1hRD05UUfZlGhm6YZYB4zrjNnhu8uSnW8leQ91jTjhPsMc+T1joHclKesnb3XJNgUJYiFcFt99G1SHzY6H4nvjr/ERcz31aTl5AlShiDLxKOiR/jBFBGCPvL9qBp/bZ00U9X29O58pSzXP4W5uFP0v51NfEhfKtHC2Ud/aZ82b8HTRzDzPCjjfGGKrWCwMU9G7VBTX4CnwUnhAdFOLL93bgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AI+pW3nkFMl0qntdChPg4v08tnbkuHEMIJJTrALVjtc=;
 b=baQq/CxGuNbVMN6ed97W9y99VvHbCzE9L45J5STmIlp6Y5A7RXVL9FnIR3adrkkkfRYKlfq+h2xrvNxuIo/IQ/jw1oNI0qncJr+T7+d7dCJqQ1YL9XnqUBWT7jY32favl5gBLQCcyEutiF+UAetDTY28PFnpQ2H62HFJcb3ybQZbDhvPPYer55LMAdwSCBZXfbXhdb5X1RyyiqIJLrMKWif8TNTVvN57nGkJYd3vzGi5N2VN3E1siCvCOr6DSOf/IKcmcFn5vhDLEY39sLKlIsCbL4RzZOO+3IKgUhnBGztB82x9zKPW/8h+JAfITK8sdNJSwLb4kbAhrB/6d1qEkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW6PR12MB8705.namprd12.prod.outlook.com (2603:10b6:303:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 13:12:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Mon, 20 Jan 2025
 13:12:23 +0000
Date: Mon, 20 Jan 2025 09:12:22 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	Zhi Wang <zhiw@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250120131222.GG5556@nvidia.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
 <20250117233704.3374-4-ankita@nvidia.com>
 <20250117205232.37dbabe3.alex.williamson@redhat.com>
 <SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250119201232.04af85b2.alex.williamson@redhat.com>
 <20250119202252.4fcd2c49.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250119202252.4fcd2c49.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW6PR12MB8705:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f8db1b-d0aa-444d-49b9-08dd39541411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oz3sVsLiCJCGBYyX2a/njoeHSbMzftdFoF7SGi7Jp9ZguGr+GEY0QwO4cfka?=
 =?us-ascii?Q?LONO4NVEaHDAgKYYE8XQecjn3h1OwtEmV98fadpTndRQ/iTcEX7Hqyj9LhtF?=
 =?us-ascii?Q?sRTNxLjS3T70aFv8pS6k+WwqhNHIRzEDI0DMar6sL4+vAwVM4ZUo7/Aq05gY?=
 =?us-ascii?Q?O8HFbUoAnNVGxbt0ojYV0LPpKHJeY9xMDr+UD8WESn4k5j/QGyPu8JSVqY4l?=
 =?us-ascii?Q?qxTbFlFusMPse93Reznm4ofsxb6+CukjP6OxA5mCQZ3wSjqkUrEBkvc5pvK8?=
 =?us-ascii?Q?l1I9356VhpfpVeUTrxNpRvmv46gWHcdJAcw4nWbQHYI1SSc9/OuPWa18F6Br?=
 =?us-ascii?Q?fcd01p4QRzMGCdk81M0jQfYMHWC11HFmZ/qQQJuoPmwvqako0sCjp5veJgul?=
 =?us-ascii?Q?/sNZK+Sf5dzpzHROOAeGOR6gFKaalrgVhmURSBM8pwEcCxWlPVemLAK5jeOJ?=
 =?us-ascii?Q?p1gJMqAN2kmQSeZZ5+YZUGXfGqdWKJpiuyMWQm82j5QmLXNZbOiOdFpFSAZl?=
 =?us-ascii?Q?AdfyQpMFadkzhYe3uBJYLVOsqAEZJvyC/zoh/FOvaRmgQyYlMY45qHAcFQit?=
 =?us-ascii?Q?BJpsP6hoDyCsNZqDme8qMpqqA+cMpG5dJ9Lmhs6peAjCMuCwxWAiUT4T8VgG?=
 =?us-ascii?Q?BrqsAPG8aLCpgI4P4V6wUP2x87HQ0fUKGZh2OxPmbu5lpp60koNdhBNDtOCC?=
 =?us-ascii?Q?ElQCkqe4natTVQ+oCmuxQHBV/7AB5rb0qPiogzADI7BSwWaRuaUyYsIVbmSN?=
 =?us-ascii?Q?pGDY+UpnjdCB2UxJ4UBDTjql940pkhkV48JcXCVUZ9hVqayyP+208Qv6VXBS?=
 =?us-ascii?Q?/DbXB+fHcNEEpAhijGRdciG+ZKcC4RWthIrO8aQhf9GbLbiJprT2aK17FIOe?=
 =?us-ascii?Q?qUl2VLEgZWCPRwD6MdV80wXB2gRvKDSlpYOVqvCdql4uCbYMRX+K8jHluz8g?=
 =?us-ascii?Q?YfFyfGyxelTAMHaahApRVy0ewlYutlpT4LwNTsORUj+paCKk/rhKFUnPOx/M?=
 =?us-ascii?Q?x4RIEVAt7Z2wksXW9J7rm70hND5n89swy2Vz2OdAqqUXXvHpXPnTfYe2gJW7?=
 =?us-ascii?Q?r2uqQGYOnRNvLQDWaV8Tr1rKoWW47ArpYtaTeAFk2m/Q3IG9fOK3RgHctui5?=
 =?us-ascii?Q?V78UQ8j3sB6EoaXnwDMr/P+DsHlgI/yReLzLXNA/es/wFODUYhmWPHp0DG1b?=
 =?us-ascii?Q?7m+iGheAHaLo7TyaGzWfcW8yAtuSWtiLNsIlJkq32mcP7jwbNjhwI2/8x4Po?=
 =?us-ascii?Q?eCBMuV0n/qxF+8rT5k5WKkL6lHUrkdvO7LTjnuiJ2B0M96AoyTesW4u+Gvk3?=
 =?us-ascii?Q?oS0meGLZV+WuMJHs/REIEyOZNqvJCuPIAxyc3MuOav2+aNxr0xvSA68V7g4e?=
 =?us-ascii?Q?DXT5TftekUOflYnR05Plbr6g72Fo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YI+LdQybIw4AfSsY7ilPwGgJZCkCjhkedycHJDsIGZTmZ9gAuGJeLMf0zzn1?=
 =?us-ascii?Q?5njfHyW+6KRvdohrA54mk5CgUJUX08HpceVXu2bOMUF3eHwA79bjgRVAElsI?=
 =?us-ascii?Q?v5QjFMe37b2zlgCaQh89WkyAMzpHwKDO29ML7k1z9c+0l5gyubeawQMPSfNq?=
 =?us-ascii?Q?d5oWlFrj+OkqXJH9HjnJjpW4Axz9XvcmqFOhp70zH7pbU9A/ShSTukY9wAwz?=
 =?us-ascii?Q?CfJU0g461i4j2Tm9gpHdCjSxwEvA33OoT/Vq9vqM0XaawEcn9WiZTH53vq00?=
 =?us-ascii?Q?yyS44qnyGLm+9z3bzmBhGGwNXmS+XTxuHwG6E8x3Ym0ivUvA69UDRrHN9NQb?=
 =?us-ascii?Q?QXI7RiG4FEdWOyzAhLkgBAIsTllUmnvVQIG1jdV6htQnPfov1rQxN8XBQu9Q?=
 =?us-ascii?Q?tje3bR/8KxL9g1CTkl1VJP0IKf1LL3pzikongQkxOpDbHWtQ9fck4rSmVyCv?=
 =?us-ascii?Q?WrtW8nmGKPmAoAzg6vluPBBxPjl1koMzYN+usoBXA4O7uGc5ESNui6f7W27l?=
 =?us-ascii?Q?MeodCUtSuMjRn6pDKbCnI8sSwho4Alziigggl3jkZkKSnVgsU9juNLaEd07C?=
 =?us-ascii?Q?0XHAXOy4Uqb3DshvXQ/AONEvWRz7SBmqDZLrBWHuKa44EefyrlpPw4MuuYDq?=
 =?us-ascii?Q?Y/o+F2r9igjqEXMUnp561F++aubkkx03JX5VD/nQniP/3tWcRrNWysgq3FPc?=
 =?us-ascii?Q?dKfQBH6qlX5IwE02g3xTmGiWWkKnyPTksF2VRtj3HxEtzDppQ7tqEO1gTPOf?=
 =?us-ascii?Q?sgZscg4QgIQfX3wMFEBr1kJqoxBa6j8quliRFi6dV+r/J8X9dO/hwJ6fPkPe?=
 =?us-ascii?Q?hM2wXkm8nW4ZXbkfHPd5BUtYGnVxt7SmonRlKQ0VdWFvRGLOWszfau5Ae7bt?=
 =?us-ascii?Q?vfhZAgQCaKmtVUftLxHbVyNwxM6GjV1/MHBcp10R0aJ4JQgAvy7/Zop12XX4?=
 =?us-ascii?Q?suX7+5eDmNurIu3jsZ2ysvZxhvbTrg7X+FLauWlvInZb3zuMcAyqT2cZ1mfZ?=
 =?us-ascii?Q?CICBHUgAnNrpcqArqiOq6gLPAaoTqaCCKNB5Qq6M5rG8s0N56XykeFtuCBhe?=
 =?us-ascii?Q?88fmZKS88q6uCdWZX3WUw8RwHb8wrGeGyWD2j0ZOn5tmZvy1qZIfwIJzKpNl?=
 =?us-ascii?Q?rOTBix1IuWAbRWIknDBBhkz+O57U1UH3uuE8c62tmAqXPE03S4KYXK25Hmbr?=
 =?us-ascii?Q?qSpeAHlvqKa6Qu6SfoCjx/cbZUwzKfiPFMRE7Jkke7mYHFf6qaIdBvFueHG/?=
 =?us-ascii?Q?JuvlWgfVg7/6vRqi5utHIzZ5QSj4/RX+WqWfJviHok51erCbfKCvKe61oFIP?=
 =?us-ascii?Q?Yh/vOehMgx5aqgd0k0mRGoEHgNbWGzydkZAwKllfuY9+98q237QjNRaBWj+7?=
 =?us-ascii?Q?RD09rFStc8ZvyPxtZQ2IcaWCIh+3QxP67isAD5B8fvfe7FS/q9hsr+OYYM0W?=
 =?us-ascii?Q?3YDuQyPTQVRFAsA/1qf/I2GcluIzjcpFkD3HkoJ+LmwWZdCgeBlmt54b+xR3?=
 =?us-ascii?Q?Arb3R4SWru2uyAFKILMh9pXMGErURBdHDkDL0XsUooeC9Nc291FE3oXZ2tuE?=
 =?us-ascii?Q?tQEC1AAz7d5uhakJTH0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f8db1b-d0aa-444d-49b9-08dd39541411
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 13:12:23.5233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wU35YPbKSur1BircNehoPl0q8aT7FPtLHChtR/xFq4RXaxx6dl19WNvu88KJ2ulH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8705

On Sun, Jan 19, 2025 at 08:22:52PM -0700, Alex Williamson wrote:
> On second thought, I guess a vfio-pci variant driver can't
> automatically bind to a device, whether statically built or not, so
> maybe this isn't a concern.  I'm not sure if there are other concerns
> with busy waiting for up to 30s at driver probe.  Thanks,

It is not entirely abnormal. mlx5 has a timeout while it pushes
its first command and on the failure path it is long > 30s IIRC..

Drivers that take a couple of seconds to complete probe are not
unusual.

Jason

