Return-Path: <kvm+bounces-49435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E94AD906B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B7903AEAAC
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136D71AF0A7;
	Fri, 13 Jun 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GNj/GFDS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D4919C558;
	Fri, 13 Jun 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826744; cv=fail; b=CuffJrjo4L/Jn7ugAH6vuXEq7wdkWPdeRNczQOo2AX4IMtUyP3g8MB9JwmcE26JeHVGfMxoYIlCksex9lfB2YC21dH/nAGx0A94RRxJEE7fDdTtX9zBdsRURxyb/VVNW6E6O8AwLoWUswm/KXyI281X68hbLGZnLc8KTtn12Ftk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826744; c=relaxed/simple;
	bh=0709O5B5wtLYY07dXvpOUMbWDjWDlt/HLYvFj5CNNes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NyYihPymB1rGn8Q5sAfyYbMzPhqh//A4mrCJ23ShTxK9RgytXFgpUGwxKxeFerhOgh587oz7juomLV4S0azdmehJHs0CcTleqJxckqIzoA85MJTDEmyMt/29TGA64/0ZwZ3/qsu9tUL0cX2eEjYN99Iti/rVo0SX72xdALE0Wpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GNj/GFDS; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b13tLawUt+5RChzlq3DRsScyfWW6OjZk/0/He3OSdgH5TkbA+RXB4G9eq/7cgiAFcsww22rivEYUcySsxGELYq4XX/onXytfUtIp4optdYPPcTo2CnCYY/YQMLDVBlEgJCluMCmb9cSgAshfT9u4ZZz7lrTRp/LJeji55KzO+5rrt65mZApO7njuZYTn1LBrhdrMkcHeZgIXeluazsmm0aO6cv0snByJWutVZ9i0fv6Q4uPcNZhPo6+CPqdDI+Wmp5N3KLH3XruVsVhVSpW5ipOK9bPr1zAJ1fUFf/uA6BHSIf51zxyYtlqFld212BnVOTU/GguHtJ92y5Z2IIQfdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNmK3jDCl6S7wPLPwkasrtFMsCs3jVHwihq7SxhLl5A=;
 b=e5Etyitmi5vzOqqzFM7WR32d8MjyG0rJ7lnPd1RWYPRbwEIJ1/nHpAjURFmT1vKw8BniNXod2ia35SmnMk9EYI/xZIGXkJO5qEufw4p3mnVrT+sFmbd9cSWkgQnuFygL3b75AaEQoYMYA5BoDXzhydpqQp42+wjg25QIE6v8/6uk+7NxMpfoLpEycbVL9444gWoZLY3kCldDL9kMdBCmENO+1E7hJxoJPsWKyhVrluFD0iVlbOUqsx+mLVZdK2t2y3G37679ORCeduTMMTJhIkacb4NlRs9Q2ASE2P5NMutGi1Egbg9LVxQnbxS4mHANG5+3hqXBfXKut71jhPh1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNmK3jDCl6S7wPLPwkasrtFMsCs3jVHwihq7SxhLl5A=;
 b=GNj/GFDSK6+N37gdOGSmydM6cY6ZNfba2tpb665d7r0AnL7qRB5y3a+KEJWxLVWVGYbv5gdVsKR9il1jkH0Yw28LYmhuT2pldlM+L4wbuXwOs5w9FSIjxvewEMFzmhXNXiBWcv47fJg05KCqAUWAFwmR9aa64hzzuUm5bFTy5Lzzha5wHi+4t+PhFANcTpalH8pQVzO+eJtbW3T9C5EodWzgVWqHnLVFxTuJNVGjH8IUvVpS+koT8RHPT8H0HG1qpTWpDeP1DxwlaTwgHfp+3L10nJXgpYY7MolskzTG2OMJbdI5HDD5KvbM/le5CkZ9WK+yWxKqE3Sf3axr0XfcpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9272.namprd12.prod.outlook.com (2603:10b6:408:201::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 14:58:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%4]) with mapi id 15.20.8792.038; Fri, 13 Jun 2025
 14:58:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
 David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Date: Fri, 13 Jun 2025 10:58:55 -0400
X-Mailer: MailMate (2.0r6263)
Message-ID: <DC6C39B4-ACFE-45CA-BA31-BA0E81AD13B0@nvidia.com>
In-Reply-To: <20250613134111.469884-2-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-2-peterx@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0238.namprd03.prod.outlook.com
 (2603:10b6:408:f8::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9272:EE_
X-MS-Office365-Filtering-Correlation-Id: c89c9b6d-aeb2-4b8b-e8ee-08ddaa8ad370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X5WvJlyxa2NNVkd3O6SBC+QMVEUEGhwAIHKlt+nqxLzyR/sLTf5tHEJ7hnVD?=
 =?us-ascii?Q?9DKPj55eOprLOrqI/fUq70PimN/47hGV462SV8nAelfZEUcJI6w8nddmE8lo?=
 =?us-ascii?Q?wWUuKmvVx4M1DdJgLtrYbxetuQZJj7fHuuhJhQU+XLcwiy+PR9zv7xWD7nzz?=
 =?us-ascii?Q?81V4UyRtnc/ykqdrawWOLH/UzDFr7VL0ltWq9YZNuHdXKZfWKA3eQ3Y0UXHG?=
 =?us-ascii?Q?tqtjVRYXTam7DjZnKzeym0bjMI/4e7tyn7f/HIiE0yiuHxU3X2IjUzDC/P2b?=
 =?us-ascii?Q?776+dBzEx1T99ZNqk1bp10WNaRu2JogCICOjXgOYdwg2IKGHErdCX1Aa0M1J?=
 =?us-ascii?Q?a3CChsmethGPba9NERDdj6eeQqXMt5N3BWEn8RwWTVCugQVvCQvyFr+rPdy5?=
 =?us-ascii?Q?AHMvdC5dP2G3f3svSyR5yAu7PKO+9DkXuQCa7iNu6tWCaC6Hay9WWRz/p+81?=
 =?us-ascii?Q?9MGe7AJglVWF0GHvyemFjh/3yE3zQWxvhBNOv6vvfZ3nouX1h3qs5+6SVYmI?=
 =?us-ascii?Q?imd9PXFuR1L5JHx4eUw9yofd8+XGH73RXj0w67xKUHGTSsPd+XYWe8vAgDVX?=
 =?us-ascii?Q?+F6oVJKWe3kf3L9Qqn7cjApteE4vapSPQpYijNMm4BDeVQG/sHPotVX+8EMn?=
 =?us-ascii?Q?9HbcEXyQwmuXrac/dBu2eKEiHQ5HnNtWT/GqE0/yKijcHQgY/CV0v5DWS0xi?=
 =?us-ascii?Q?eg0kVv95aCk1aqb6EtfZKZPNJHSQWdI8XRntDJoWLdmFSYtdqhEuSON9XMYV?=
 =?us-ascii?Q?/dXmeose5ec+gNk3Pr/fokHfSiMDVVQKUZpmSxOOZK6a5B7tTiGhSvFU0yAH?=
 =?us-ascii?Q?gLV3s+mddU33UCGEMIwb6WPJCNV9KZc/hwqSLTrZ7jJRV6efhRttgI92zs5m?=
 =?us-ascii?Q?HGazbs+Tf5u9UlriotcEB5IHE1Ifm+UftzJEEHzEVbu4Ikp0CcHNYfewTd/G?=
 =?us-ascii?Q?IZuNyNmc8NDBTkdsunfM+NZvCa+Y6jhrsGMEqcpWuUjcXeCTKctDMJnbZWCT?=
 =?us-ascii?Q?eTil8c/iXTRhC8RTYQF8pQ40lQkmwHR1CYTgZ/aXAb9WH2owGOoSLpjA9RIW?=
 =?us-ascii?Q?N3maZubg5D5j/TyJHyoVHIaDVSZb0SonNdKXaHPlcR0Cs3kqZZTWMAXp+fVq?=
 =?us-ascii?Q?YCcxH3CZIh5UaAkbXQYZxiLAcfAu4Ug8h8AhMQCFLAFzhGj1/jPeM1trFjEg?=
 =?us-ascii?Q?kcSAfJAea+Dula5XjIGiEWkgwCjE1OCdstI1hblHY0awtSW8Saw4toa6I1uh?=
 =?us-ascii?Q?91lFWwreQ6Rplg2MEPutQBPZMDYrmwbJoHqXD9Vr1bR5FTIdDyC4R9oNNGFP?=
 =?us-ascii?Q?OofJfwNapjneiVIgRZ3a48HBDfzQXYjMmj5g/qiiNDueT+1vuYr9TzuPUngX?=
 =?us-ascii?Q?Fh+HmrNFqZLaOB3h6bllsxZq5L9LmQ8Zbl5/BgLkF3KFgSoNbQ8Cwh5X4iX9?=
 =?us-ascii?Q?eiMOG1svJws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/k3u6Pwqjei4154kP0hf2rEiFbVk70ILMHBOsxzvaCXoeuMHzDpcXf2AJJ4u?=
 =?us-ascii?Q?eI5RK+u8amRfEvkm7QA1YIxcSJh8dnC3qRalKm8aiIQoGJpk+knJLqFY1wwX?=
 =?us-ascii?Q?NvszP7IP39GFOswqNcjMtQTjsKq8OmlaZ+BVJRGP5WNDIosgt3ZFTQJ+zEWl?=
 =?us-ascii?Q?voE4xxhII9zmSnavZ57f/TYQ2VGcGf0V6JCA8PoaAtu/v+c/Y5wGCsXAzuj5?=
 =?us-ascii?Q?ccZ4ByGCrFcgP4s6sAkDAedkvPjWFZ4tXJ87TSu9km44qE9t8J5BRQRr0I3g?=
 =?us-ascii?Q?xyhRnwkHsOHMBHktpuLWOsJ8oXheO/zb1+7lEud5OJ32uhg8H8/dUyVNsA0V?=
 =?us-ascii?Q?32Za/bda9lYRLwQ1dQ1Z5fCzNYnzt5FjhjGTHlrCFOSj904KgQNiL7dS7hgD?=
 =?us-ascii?Q?diNPl9yB/Q6R8BRXY3Ri8OR/1cgOD/pgzen6IMJ5CaexZsABSO2R+CyFzXCd?=
 =?us-ascii?Q?TASGboHnF5VfIlg7aj62tsyoiPzqrQdeQfEB1OVZhM0XePyWRgirdJg2N/6T?=
 =?us-ascii?Q?0BUKq2LbDeumqZ4Skz5Gbrv/vR/DIBWqgXP4GjBrVHY3Ai8cSBjA13Owq79O?=
 =?us-ascii?Q?tZSAsKtFg1baNH1Zjwkrpr7sWH9LrxBrtnmAjtEmOPXKKibJBsNh01Shk7tV?=
 =?us-ascii?Q?s2lbs6yk63Kk/yhTYGNtrplgZsueuw7rBGbDzF1q3K5TWkyggNL+T8d4kkNj?=
 =?us-ascii?Q?Q6+6UoO11M4JWwVhGOXSNFsXDYS7N5tdpWFKZduPswmGgWvc5f9cOHLT2sXA?=
 =?us-ascii?Q?y6CSXnDtR+EQ3kc2KGvrC6WLXKvwDADcbJZIlq6pQd69Y46BvwQixRa6HGTx?=
 =?us-ascii?Q?0C0oeCXqma8wj8Ga/8QQCIXBKo0fzionJQ2NjvIxyhGqDyo4xokHcQPBOY83?=
 =?us-ascii?Q?hE+NNI3YrE+E2XDgncrIrFJQMXmtE45JZbF6mdE5bgnS/iXib5kABtGteS7/?=
 =?us-ascii?Q?T3SSlKgAN/z2xcl6+vHkpRiMY8joBQDJo7FGokYSXtMbFLeyJ7RfhWNiFTZO?=
 =?us-ascii?Q?TpKK0rK4NchkYfbxQk6OfLYx/+GzCEzYLTNBOi2tjMJ+OjOENRH3u+rRsYH9?=
 =?us-ascii?Q?Q86Ngl/Q7m/ccaE3tWSvqcY3IEV5Rw2REzi9D9z1H/HAktogCp/1QJhPywVh?=
 =?us-ascii?Q?K+5y5SRvROoB/wKhNjf2NVLlWJ41QFFXtaGsHm7lX6a3Uxrw72EnQbBmNEy+?=
 =?us-ascii?Q?SjrbRuW2J8UUFdTxEte50F5e8Ytj1QbmtrMngOx+ux7NEIgaJamfoNIQYxbY?=
 =?us-ascii?Q?VgFCPRb93gAshHVzYUP7Cl9+zFtoae7BVPxRaaqL9bNYf+sjCOOd4OS6EKGM?=
 =?us-ascii?Q?gJrLJ9dciRyJ+1Oig9XSUSpt2gWpLUMvOU7krtCK6/IgyHKnR+L7LbbWppCU?=
 =?us-ascii?Q?G6KGVh8EC/EurP7rNXZzMsMWqCpgWmHmb6WEWNzOJx7cYJI99vSA6xeMcRd3?=
 =?us-ascii?Q?sAaG3ADq/5r4/ad4RFLNA06bUxHc4cH0UuJP1pEMIS3BNl5K/qRRavLHF+5p?=
 =?us-ascii?Q?7wVIjrjKld97QtFN5/nD1YZeapy5+V7y0DE5GRlvX2nVK5cyFt9LT9fmARsq?=
 =?us-ascii?Q?dmkq9z2O4lYksAYonGA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89c9b6d-aeb2-4b8b-e8ee-08ddaa8ad370
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:58:58.7309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0D7jqDfaVDYhQY5sxNyOFovf/21BhlIDL/jR44Ak0x+RpllCRnJShNo5yhldQz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9272

On 13 Jun 2025, at 9:41, Peter Xu wrote:

> Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> the helper instead to dedup the lines.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/mmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

