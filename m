Return-Path: <kvm+bounces-25254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 148DC962A14
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF4ED28602D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023EE189F52;
	Wed, 28 Aug 2024 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R0t3812U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DCD381C2;
	Wed, 28 Aug 2024 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855069; cv=fail; b=SizRY7lG/sBPdeqPGYONGqgXoQChLRSpOSb+rybcnAvXpr6zOPyKsuB4yDLFKpSLoaSPztc9gPGd4ScpJUffI+vykYx7VnXpi9f6MQNcRb1Aq7Wk6hRMQf0FaADcosbFKneI8nAUUh1v/bCLQsau4kYJ+66sUd3YIzZ3l5V+A6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855069; c=relaxed/simple;
	bh=e1MX7kwVjYOF/RM1nSdTggaiNW2JVSFmDfkDWbcFWDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oRSqfrAw3JO9WgPSDYlh70yxRjBnZOGKjWAbDJBancFlQto/2oFF6JLpuZwKlCyeCwsQwvIPDRcEyUAlvTvONoGKTvXs7R+bF6tF7XYRRt2zGVLG51zny5tZ5CT6FQsIo3jiVso2sQxZLiLPczq6W8cFI/HIRI/Wj/feXkxJ2S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R0t3812U; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8s7rB716YJPTyfYSThhf2WVhWUuxHpMeqC5dEfcvPTCJs6nsWx6WHD1LosuLM5bu55irSALtY7ylJ2w1D/gjgfJLeVkI08LHesz56o1R6mQ94gO84C2rQXDvhKQsdye8d98El9HmbmsErM78E8n7+dxvTSSvUbVx2go/SecV4h23V9ayC2kK25/8IyaAiM9aLOo0EITq2KxPTZXjpLC3O2WwrIOYhnDgjLG+nwx/sYgDf2eLlt1gxayvsGTMFhxpOhuAGM3C2FodLP4th8CvLtsBs/RDicwjhc5sT9C33FKi3KM/GuYM1ILL/B+2COnHTf0F0S+F8p1extaVTqSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1MX7kwVjYOF/RM1nSdTggaiNW2JVSFmDfkDWbcFWDQ=;
 b=Fp5Ntm09K1vKk88NnIvQa+plOUSgQQuigBTA6cjDo7QRItkUvypLNyQHDEBKvXrblaR6aTrJTQ9CcQ8kLusenqVfnNlQJ3RqEGWeXwsN1ncZMkFXNs2gSiRf3kktiUDvlqvbGKM/lS+VeOI32JhIgXUiFPDFEnEJL59/YthMjGOjz1rS+g7Tu1iAuAhtSrTfa5ZFavoVrNnsZdOKLwWV01wxV0J5muVjCUQxNuVGUi9wLdIQwx84H2bxbVKt3UAVKjf2WDxQiEgtcmank0MscJUI8vZMaI/ls0/1OIQDbvwg67DI66IZmTm+XjaMqw9NUxkdLg6RmL0H/xSLX8xanw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1MX7kwVjYOF/RM1nSdTggaiNW2JVSFmDfkDWbcFWDQ=;
 b=R0t3812UoMrN0MelU7C8LVickgJ3umVBG5uVeAvv21qPRGKpdV7AE6qYhLIdAMiuNLn64r5SkrxLWnfe/UF3ehe5JanU/RjidGbd7cydGiM3fbXTn8BUyXKotl9udRN4bdupu1cHYn/kF4mYDXLLpyrI5efOHSnu/wJk2gLrpEEmnDXcq2sV2E9XeweSa6UfM0JROnZDyFBvRk0jxsbuteNKWTMf9egOy2C5IpRDyqVkBXNbrf1+d2S50+tHbdIyAm3/rs1GbxD33L7yTeN5nOVzAcyppgU/qhm2DFpfKUgVrUM88OHcA8zpBytrYfSmCh5kfkVgM8q8rWOT/07vEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN2PR12MB4439.namprd12.prod.outlook.com (2603:10b6:208:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 14:24:23 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 14:24:23 +0000
Date: Wed, 28 Aug 2024 11:24:22 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <20240828142422.GU3773488@nvidia.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::19) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN2PR12MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f9a8b8-1a27-4f30-ec32-08dcc76d1cfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?okqMIcX5L0ZF72BefZSZw2/bTvH+Xgy7MdoGnnJClblaZNnWA+MRt/KcIUWN?=
 =?us-ascii?Q?MyzLHPkT54P48KDCUZDSdA/YBAjRSlPsVc6ulKQRJ/x+IijxPSLbNcBr7R2O?=
 =?us-ascii?Q?lfEis42R0vBegjWlSIC/QqB0KCMYe0Pcf7OAGcl2j4ErKyBpj1kBNQE/B9HQ?=
 =?us-ascii?Q?2ubQHQLF3aduqto5j4J9GVci2VDVn0JJR62UT5ZlJnJT6JdgjOdCfLwC54Ud?=
 =?us-ascii?Q?LnPpabz9E1z3eSDSLxFgIrCAyRpmkoF2lYnRGt6LIZ+bw9VFmZel1KAMNhL3?=
 =?us-ascii?Q?iFEAJp4172NPWROUGNjMZHmeIkUT4T6TEpF37ltQly3c5EjPY2kYEjsQm6aO?=
 =?us-ascii?Q?IRAcHElHJQJnOaCcGYApGEZbE06AaMekID46UMYV5ca8s2kx+San7ccxCVYd?=
 =?us-ascii?Q?27viPHhKTPEj2haR/1s5fsC/Pc9B7H0vbopuaVY0DZG44w/Kp4Ceu8mFph6G?=
 =?us-ascii?Q?d/b/d+zR0q33XKfGHlMC5He6JprqVCIMnFuhMpmi26GQRzqrXNqis2/QrK8q?=
 =?us-ascii?Q?S6bcrZDcHDDsSdxhQWfhkI/vqPcrk3Na1AcBvoHPixFEBgM1YNMZi61urO/k?=
 =?us-ascii?Q?gFvwFYiDpw75trEexguQ8ULoQBHe3qXHxcxTURd2qRGl5MR5OUGplCxmse2y?=
 =?us-ascii?Q?0AKAk+PnsMHtDTWv9RkRCSRD86YAJ4CDzR6kjglOwacZ/Jm3goCCydcbgzTD?=
 =?us-ascii?Q?wW3sNocd7ebDZ1DD7FWZpjmmNQMlcKtE3v4vYY1j5MX8Sdt7lTk2bI7OwGoI?=
 =?us-ascii?Q?Jg5hv47Mf4M5Q2rESvb2+sC8O9iSgmcL/5LRQxOm94FUzslwpM1HxMfxbFTk?=
 =?us-ascii?Q?DtoqRRGQZjxZtpUjKhZcVLb/eSA7Tpv4VzFWbIm0f2NTUdPigpaMLrWGakw6?=
 =?us-ascii?Q?9//gD2f3bc6qwlo7qcXPRzFsrUQNLf9wjoUXDSbJ1Jmtf6QE80FBUlOLkIEb?=
 =?us-ascii?Q?2xROtnzm1EMZLNkRaPKxrP0/z5sbnvfe7uXDzRWm3+Puvfn2t34PZTjA9IFv?=
 =?us-ascii?Q?c0IfzvH35KFNFrarQOjNKKxLf0S7SdDm3dfvfyZmbmctoGd0B0CNWrh2PSC7?=
 =?us-ascii?Q?RGk3KENiqAZboeh4KCYodEFxFu3TaikW3ZeMQvaASBHwNOUBCCCGgaOmRtCL?=
 =?us-ascii?Q?n18prB5NEF6m+gFd/dPUUZ61CUZIZlvBWnYeynq9T5TyZbEkK9SZHlLja70a?=
 =?us-ascii?Q?K76PSiRXWZQAItB17W2h3A1av6IMCxLX6KF0bJquiNUA9uNXvroT/3Oe3sJJ?=
 =?us-ascii?Q?4oHiDjAKKvM3ympFW1B1FJFE+5jKZ2vEVV5eSVS6jV+zEy+/sqcR8N/SwnmP?=
 =?us-ascii?Q?k+RIDHisVyUCuW9jFrG4uQEPcJlI8zPbcHfCqixaReipIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9R5bJegcsZWWyYeicG2WfcUSJ/FlvI51DtM5E5q0IFNTfa9zkYHsEnKeVtWA?=
 =?us-ascii?Q?Yv+CNmPvps8GoiBNxOIcve7VoqCG4alcqZ9bQ5L/wBDECbyZfVNrNnRDJTsN?=
 =?us-ascii?Q?LDjXOB/Z7vJwnL3nbNu8AzwCTeg9rN5oJAg32jGbujazuQHdL+9ltnACcjzV?=
 =?us-ascii?Q?jKcmZ4jtl9k91Y1zdbw3TcU4AolprUFPy9mEpFevlkv4c/ZpRjiaSJo4ndah?=
 =?us-ascii?Q?XP6In4CLK+/gK7CpybW7q7dLe4nwVHiu7RE+vO9VM0KZyCAHEf02xekKc2ZX?=
 =?us-ascii?Q?S2GFEYoUkPD52PeZ2UuVfkQ0YC0yTJrK3lHSLXXj/9Xuf54YX1l0TiQg8Ee/?=
 =?us-ascii?Q?9Ln7pwdHov5A4WDSfaKZ5paGfcY1zbvm4xfA1NwSMz2sByYllwo+OTOhxALz?=
 =?us-ascii?Q?QnC9fpW/I/1Mn1t1LvPoDeXR5uCPFV2ufkFLEqXT8cUU2wbQlNWLd5d+6cZu?=
 =?us-ascii?Q?JUbtUM3BhpVq+toZUS9Nvg4IxC4qsJnx+9GDJETa+T3aTdMHiYVlYqXettm1?=
 =?us-ascii?Q?XhhBefsV5bi+jRwsNZjseURmy/VfGT79FGE5SEX2Zl8ihN5wCv+PLjq+enUP?=
 =?us-ascii?Q?fInlyohh5T/MwdSXqpitTFYadotq5+pDpvZjROWek4APM+G0ZbjhfQMnK6hV?=
 =?us-ascii?Q?wDAd81oGNWnvIU8RvS2rLpeX8425meTlrSYqrt4Za1EgZeJvaJbgtDsuHhFe?=
 =?us-ascii?Q?W4iRK5DkOLFddZC99FAh2fW6rwrexsMLSH2UrFIIGtUtKZjIfKm36OvEeepM?=
 =?us-ascii?Q?bZ63snGn0Yyeh4AARN1Eh/d7eMASZrHvYjvwi7S3yWs15VqfAbi+pk9QkJGX?=
 =?us-ascii?Q?CE16Oi7bXifHqg16cyM2YqLSHzByMMK+JJjoLzlsRkkib6+VF00AQJL7+oYx?=
 =?us-ascii?Q?z9TH5nezF425jSSEmQPljw9rvewaoNluA/bbmFKunsBPDwfQCNpqLMoriFOZ?=
 =?us-ascii?Q?0DfBQ/OJY1WdFVDWAeL3qP2oIxUFcT+2pSHX+f/spUGq8E3wYxFN5BgYMM+4?=
 =?us-ascii?Q?uMrJlcskhlByYJmc/JcRKKbm1a7frpQkxyKM2fgukdoS0tAXtcBT3ny5YCgY?=
 =?us-ascii?Q?saLxVEVIj+p8ZYMs5hA0IQ+oHe1/L5jjwjaZDtM6pvuHlhl8XS5yy9nWR7xZ?=
 =?us-ascii?Q?jgiLWLGjxkxYdupx7x/1oPrtDO+MDaC31tr23p4KtQxTXc+10KmaJdlMeC+h?=
 =?us-ascii?Q?1DH8c9pFxMyXsqEUfl+lSI6qCEfpJD77H/DyBoH7meU7fcwguZ46VKHyLV9Z?=
 =?us-ascii?Q?E2UYCFD/cImwG47JNCkX3WfILZZXdDHzhj2oyrhxxkK89ZkXP9RE6vQDPL6Q?=
 =?us-ascii?Q?uPTDSTJ/Jn4kyZf5xBEWK1v/0Jkj8g3EnwkKBHZh31gpPnSZNzMYS08YkefX?=
 =?us-ascii?Q?ed4lvdlqj/tBtBJ9A1Ur4WJWrUOS6mkXRrrJv4G9crU4chi+hvs+shH8/qUF?=
 =?us-ascii?Q?kylI5TVnRhFqseCJXvR2Jn5jOULn4CE1/Zg+bln6JjVt2RoVvG1VZECNa9sT?=
 =?us-ascii?Q?IUd/cqjc6DtjtLMeoB0SRJYCnHSe1fcU2ypEvjKvMvQMVpIDyIBZZ+ZdGCIg?=
 =?us-ascii?Q?P5kQQNVgP7JD+ASHtMdNgU+o+0kB9Jr2CXj155vg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f9a8b8-1a27-4f30-ec32-08dcc76d1cfd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 14:24:23.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3765aICsCBp3pzgEjoRk4Ch5OZjk8k5rbaZ3XSmlgRn+Wu/hIulrmHaYnqRipQIW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4439

On Tue, Aug 27, 2024 at 05:42:21PM -0700, Jiaqi Yan wrote:

> Instead of removing the whole pud, can driver or memory_failure do
> something similar to non-struct-page-version of split_huge_page? So
> driver doesn't need to re-fault good pages back?

It would be far nicer if we didn't have to poke a hole in a 1G mapping
just for memory failure reporting.

Jason

