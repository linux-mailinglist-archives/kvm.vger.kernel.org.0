Return-Path: <kvm+bounces-49422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4841AD8F4F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4D031C217C0
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22192E11AC;
	Fri, 13 Jun 2025 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HBnDAynT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454D2E11A2;
	Fri, 13 Jun 2025 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823929; cv=fail; b=fTM0DRMBhv1bjACivAUadcpZPsZJh83HkW6uhC7ZN4LXs+lVkHpmLiNy+ctMtH8T1RrfMLzv0Hx3gMtBO98o+9Yi7VQ54fsS+utcew68dlcskIr8YQ880xMOIdeygYSAI5VxW1Upx+wO0kKWmR9jpKVtqkkYMKRD/+p33W5b6yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823929; c=relaxed/simple;
	bh=f6X7ek9RFp1XMbQUtYLANV/wRQD25Wk8W+27X7P6Jb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YwjEcolkqmRdXLt1YqtX/NZxryjhje+s/y9QagqXHFcyFbBQP+evD4gJ+Ri7ofgn2oky9T6PWPdro75TwJKi+vs6sBSvFQBgPp6cTaOWgRm6zVkiZpDmlKU+K5TB+Bp6HHRtG0A+hMHf4LAZoU+1ncu+VJ31A8yHpbq2+w31njg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HBnDAynT; arc=fail smtp.client-ip=40.107.102.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkmp1m81+0AZQJw82bWVRn08mpLsJ4woppWQZbgl3Le61T7kogQAIeKbF5xsomOu0SzfkZhE5KX1ASsVlfPGXIHdoeq5CLOI3I4/w6daX2x7gQaNQb9mwe/WGAdje7QwImXPvB2+YmUp73dY2V/1X59JzYINrYkU8nNu6lkYv6eiaLH4SSeiC9SX8YhK5kUs/lCQL0M6bRS9ZuqHpOJMsU6coBwxZ4hxMhx+fvgX4ubkcYB0kiWDlIeC2MgyY7Sce5Hnvr3kqBNhI8XiQQ6rrd05yz9zMvW6SBtgk+wLOYdKa9TRbu9S8Thgcd3sblDZobbfbK5rHNT8wLk7A5pVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lX3pRiDCLsO5bJKZY9kCrmI7ZZ48mGZte8w/OeZjgH8=;
 b=I8K31+REBHpRktFsVwNPSMPnflJZLNhvjpMvY3MDtSHP4BWWl0rkp/LmVxUzxdTjKOoaYc2MLdN5XNlf6szuRk+VsAeuAzRPyvZLZD3P+w/utYo5ti9sREoeo3o8ozUV5RlJbWf3TLTRm2QTUYJxnHUz8e6LfrRlCrixPOM+kp5eXFiOt8DhS5RzR721xXoxV9Ql05BUrpyivxzm+I4hLWYpc94KR5Xm5Gr7dq8q90kdAkoerf6v3Z/BkLWkVx7hOc4aFhBPZEA2p8C2qIIzw29aIkFEUgkSgSfUzAeB3qeUHQ5z4VepJlqGG/POxb6S+8nVPfNvsVACy1kQgP7plw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX3pRiDCLsO5bJKZY9kCrmI7ZZ48mGZte8w/OeZjgH8=;
 b=HBnDAynTZ0fE5y/gzLkU8Xjd3mj1BsruW3kNXo0CBXRw/7n4G+hAuzSvlmhz5T6whMpWVbpLi6PkbZdsecxpOVBWwaozWTL1YkbXWZSRKs8yIZJ0jlniErvFC5Jw4UQjat7jVWP4ltc/dDKrc57tV1Rn8K45hIssVrZ5LsrcVPbQnuN/FEOcG36hpu5i5Ah39TVO4RkTKIhjmJjRSm2Ph3aCACpgj8OVYs9PMbRaVQfEhT5PNYPCWmB58czveWJYGTJ61sOK/XPjOUKcH9E0bOQwQJPzfNXGVI/FIRc7fOgA4EtbKjyZcNkZfQRgt+hM+vNLi5A887gFQ55evlxRSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB5939.namprd12.prod.outlook.com (2603:10b6:8:6a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 14:12:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 14:12:05 +0000
Date: Fri, 13 Jun 2025 11:12:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Message-ID: <20250613141204.GH1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-2-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-2-peterx@redhat.com>
X-ClientProxiedBy: YT4PR01CA0256.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: 88106beb-7d13-42d8-d35d-08ddaa844665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zVaNLx9julfav0msR4rZS0x+vB5gXJCrmWi2NvVEwJ7OgBgxsLNW77ZNDQVC?=
 =?us-ascii?Q?QUE8e1TN4b/7sSj7CDdLGLMxKwZswA8jlcg1MZE+Na4obnZnGYJABxw8TH0H?=
 =?us-ascii?Q?75q37Nw2GIkCMThZ6HDsCHH03j5PIrG2XfL+OLT/PaEB73kZ93pJ4kaDay3q?=
 =?us-ascii?Q?UhEZc87xA1pszV3jPxmJfLyQ2IekO6V8Z6Fesbv1dJ0iD1OsDlA1vi9sgDGN?=
 =?us-ascii?Q?HZZZ0Nkch5+iI7mmr86bNWN1/88hD6owb5gg1mZ5A+I90uEqIwtRvNnGX/2B?=
 =?us-ascii?Q?AOBJptXej0IIMQSg4nWnyfcyFNCDy6+osns6+M8gWR6CDoG0lkWrRp1W+3J4?=
 =?us-ascii?Q?t1benvpH5+dp/tEtHhX8tT32sV0qGxkfRZGgQP10bKypKUBPk3VLNQPDCPkT?=
 =?us-ascii?Q?+LjskLzCEuUizSDlEGLpM8s+aQ71d4jS77ebeELZkcXpQdUp26GHoxYmIFL4?=
 =?us-ascii?Q?J8H50XDoIpx+fEe38TgI2jAbrZ3tzRMqoq5hMWwwGqOvZiDnjg5xFNqkGy56?=
 =?us-ascii?Q?ojgOgrlbma+XirqLut8C69F06mQ1xBdHO4TllWKIoz4r6yu1gHSGcrWeXHxo?=
 =?us-ascii?Q?zGpxwjhVtPpmu/ptlOaL1gs70AATYA9DnEb0etvNSH/+fZkvgKZsa4/XquRb?=
 =?us-ascii?Q?1nKb4R+sc7oluERyDv0eI6pC+QwauiZKV+mtMteZ8K/XJUj5hhMMmKDIIL1x?=
 =?us-ascii?Q?EthmGvevVHHkoi0CAs/LVUkh33mY7w3/2JFm5Tma/p3aMayTcTA7xnY1ZLej?=
 =?us-ascii?Q?anhTPmaZ2JGmOvNOMxjHlbu1ujUykwzuoTTrHwZZbE5Czy5BLTt7voQhr/jV?=
 =?us-ascii?Q?F5P3jMmcq6YGZuyUVh7eC2h6xgkSS6ndKw7IUmFm+cnuBSjDm3Ps7kmWBvXt?=
 =?us-ascii?Q?veyzVN5UnvGB5OnciuAHFawbKkMrogt7Pqp5KVFi7wl/4MtF0MdLKPoMRtMQ?=
 =?us-ascii?Q?PEKeIYfpGN06JoBEkg29XS3ohbF4DUyy1csvi74NW/E8bBTd9HgQ+FdMwubZ?=
 =?us-ascii?Q?tOw4CUYog1K7Gr23nvAkBUfoLkN4pc7seWL21H8HmeGvXZ+H8uGV//3qutY2?=
 =?us-ascii?Q?zNcREN/Vl5QFnbW/qB8FrPHo8d5IywzJYSNhuI47PSyXXTUVJ5gt3ulC3VCr?=
 =?us-ascii?Q?1mVDy5y1ETMUeiPhLsGheGd1txm2vXRe3jj3XgfkI0UNb2H5M0c7nVvgW2an?=
 =?us-ascii?Q?robtpThyQ4vbGKrA67DML9TItYxRvIZBp9P5icaUciaRIDQVqIR2o9yllHp3?=
 =?us-ascii?Q?/oDfd9jB+8VF3ILK3dqoc7kh/0HYflv/HLAkPHQdR62JOeo8SI0hZKlFmSiD?=
 =?us-ascii?Q?zuF/L51mAXPSZX1Eepm+0s8NhznRr8QdC6GMoyZxy5m35QkKa7/RFuT3T/m+?=
 =?us-ascii?Q?JEJsby1h/N5X/tRLrzoSGG3GPYRKJ+G63NRv1sn+63/wrfDTfz2jvcO4ymn5?=
 =?us-ascii?Q?6BrLXGgCtpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q3LNRoQCoWlZ2MxLFFymW7hXLWk2Xjpn1gSc0942vvbZJXKklJymUFfOF2Pl?=
 =?us-ascii?Q?d+fz2V8ot5fBilIyEn1lP18PulId5obQdRYXQ2MJcv6+ujUspcuHEA+f3vZL?=
 =?us-ascii?Q?XlDiiEqisHU10Y1Dl79T6ehK0W+SfuOzKf94n5XAM/EsLUAPYKc3vLOCmoBQ?=
 =?us-ascii?Q?qCA5REEfQx71Besf0HuOnX9aR/1hieZTZ6vnA0NJ/fy/MJC5aiFQv0ju/cwK?=
 =?us-ascii?Q?xI2xsiUfghNs+qph9C7HtcMsAoMW77vMx2Anzn9MKKCzHSPvvMqfVa8cesJP?=
 =?us-ascii?Q?yy5UL20siLhlMxIF6Y/JKt4lrgN5H8/oqOKeDCAfX2sIrgLp8650tpwgInbb?=
 =?us-ascii?Q?Q2/Kpvx4jgYEhVnfV7JQ6gwfTE23LpcQ/JD8rpU8RPTkZaKBBA8vmBwKuQ2H?=
 =?us-ascii?Q?2c7ek8paC8xHP9Yo6tpFOFR8KpZo66YpFaVtY7gT95ch4yUUPccXVmVipaCE?=
 =?us-ascii?Q?Oph5WXrIO7QBEHBKcT6DroSX8oDrPxlh1xFYswGguJTHp/dWL0CfEJDNiUGN?=
 =?us-ascii?Q?+tloQX/n/YBGS/czW+XA7AfX8vv/UydNIH5kY5qcaloA5as99WX0zKWZ5e1A?=
 =?us-ascii?Q?wi+o0INpYDq1d8Vb2Odur8G5r8gkAFIE0ZvAfZ6nK2fVv/rU/pSmJnyaDwUb?=
 =?us-ascii?Q?00jzsDjxoWVN7DM506NCuzOmlk0LdYn3KMzgZr3Klc6+5kxqtz5HVli1TlT7?=
 =?us-ascii?Q?PViMQ1kax/pof1FJjJZA18J3B/3FJISRe3ILrklZ2PFwIsC6PZFKQrQZj/Zv?=
 =?us-ascii?Q?heOufl662CM+gT0rFqEYrU08xFR9wfd65ErXLDL0dSu6BD/yzuny9TsYl9JK?=
 =?us-ascii?Q?HSNuc4Cu39TH/8ycRDhXVD/xjoqG6onIxbTM2xYvZaY445TwTQveTMov8GGm?=
 =?us-ascii?Q?fqYTi3SmuEktiMa5lY0sH3nJaDvcxbzE3WccKdAUDi4ASqRv4HJhbHKdpP3Y?=
 =?us-ascii?Q?IYVL1Fcc+BxzmK6ti9yrWhn2YFl8PMbhp2ABptmnFukjVbRSLlFvRJC69+wz?=
 =?us-ascii?Q?1QY6SKMZAeUoaald1eOwl14J3iNSn5/xG4L3kPmNcqxJ4+NBW0Ol6kCWd9y4?=
 =?us-ascii?Q?EPsBVk48u2AYmkqFKB3VYJFFjEhCUcbOS+xMQCZ4AmldbO6kXR+fc1lTSTjT?=
 =?us-ascii?Q?pVKneK4XGpjErNTwl2nwaf43/xqYGkoNNfiEtToqvdqvhIZg3J0MqWZJmYgh?=
 =?us-ascii?Q?ijiK1Ygn/u0fItQ1VNkCby8zCI9EuJC8iKrEYuAao5+/J9q1uZHj7HUQoUrc?=
 =?us-ascii?Q?rPtGbYb/50kpTeJJxUq7NavVEjOOmE0cASPr+d0D9R5oktRJZBAlWIUm0Jvt?=
 =?us-ascii?Q?qWwKu9xtlEi628/FrWNYnCiCqUTfYC3s3TKPQu6s+BMZZBM72u90GY0FyMjc?=
 =?us-ascii?Q?2sd0t/OpLrzxqn2ULk6vgk11iky1KqQBnFlxlioeoY4oqbPvm1pxhnfz+hMY?=
 =?us-ascii?Q?6tzNY1pdlMhA6fWmO4qZuo5txuOphdjvuQS+g1+4dHmk2O8If5Hb1t+ARwPx?=
 =?us-ascii?Q?DnhSf8sUROkHfx0RJmM6c1e4aFI2aCNVdOYI+g7LTOzRgLnQs9dt5+iXnyz7?=
 =?us-ascii?Q?NionWKv/3WJr4wYzMLGDSKiCPI7MsGx20dQh9okj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88106beb-7d13-42d8-d35d-08ddaa844665
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:12:05.3980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MeIIVn+J635keJukfXRUZ4pybTRG0HPCxtG6xX9RTdKPmKSYUf+YNuoM8Rol6rCa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5939

On Fri, Jun 13, 2025 at 09:41:07AM -0400, Peter Xu wrote:
> Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> the helper instead to dedup the lines.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/mmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

