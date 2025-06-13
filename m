Return-Path: <kvm+bounces-49425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B07CAD8F5D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1356188657E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC6F1537DA;
	Fri, 13 Jun 2025 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S4rbxxww"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFB63B7A3;
	Fri, 13 Jun 2025 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749824273; cv=fail; b=qjYczzk8dzoU5w3FYBx5NkCyHpziyeVymThkLTpYXjdbt1flBH3IZ+c5a1kF6EPR43M2uthxwwsepgYOZpBuDeCVR9DcPiAem0b6xxpcYYjyYmciTzpTxnfOv7DBpSp26H4QU3JBjLIm1eGPpeBkp+/oo+iZGYlDCAziTLemYoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749824273; c=relaxed/simple;
	bh=AC3SSSLk3QxZ+k25NA1P0Vz8e6lqFVtqXo02MOgOpz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TvL2Uw5TK6LcpIEkYv9XLP17lxDeyjSGEtDAiYBZRlERzo3NVYkeSQpIc1Qsw0bXlpD1ov9/C1e82euO7LGj4L/3j/iEI9Rh6IBMDMK+9xT7GdhDUvj/mVfDdTidCEilyF882sTwDy2nl7GdSVAGVcjlrNl89DIw6VxGAVpBmiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S4rbxxww; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5WS0f10t1CMZ0L4q7eyKRKZLU9fJ3ZrzArnBO4qC4oMwiqxMeQmWAFhcf29mnrIA3ATENujQFdEUdv4kRD1M8D6nciA4rrh1DNX3+S8mnXldhe3aYXKjyRhQeKE2pqk/aHEbgPUqOhqk84iVnK6Y8LfYSqmgOwd+K2DJxqTXPxsdBSAzuZWlD+EZr8XG8gRQjw0IiJinmx50vD4fIg0KALAzYl0CwsfbQDOlo9FVPxqY44eKx3WKLj+xTmhebNJpUgLsteyVpDV1cTXXKXXOx1vtslwGqotoJ1H2/h+yNLGPrU2AmlL3PcIY7cYYBOfio6RBrJ/W0o5lJezpZjo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgzJOWzmRJvqH479gTFszeKWD+uz0cxLc5dh5Zglles=;
 b=C6n1uw8//vdP8kZcpkYJROU0WHaH0NBVfs5liSNnIl54QkOpjbe1GRlcmuHrRw0JJVDxHFLR80JKDOE7mMZT+iUiQyOX483+RgwVXCFEPNTNHYHlsZWDRvYTKoGjSoXJ2oMz9SQuTHrRHfr9dfMQQZzAg8zXe8+5KWa5ECkUyucdTGJnmwjTIbDSSnK6EVrNbz57jXOZ/PloKHlrYFCA0diH0i08+KDF2jERIqMrMskGIhoR5ae6NFRWbqsuwkLdlS89PtGAU/d6nlBAa/Xzt7Wwpiyw+0hIrQzxs4R63TboqbX+PbjIUY+bx55QoJMJBWolHOo9H9lEMh9t1hDIEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgzJOWzmRJvqH479gTFszeKWD+uz0cxLc5dh5Zglles=;
 b=S4rbxxwwZV64Ido2V2/BDDIVsVbZqYNRglDSixrp7vWfBb8281MbcUyQlnDYU+HkKU3SzfATGZjGqVaCly6hTHZPdctQdlS+fsv8sQdjtUJWhfRkMElJVmCVqtDD6iKjJ6SMaYucWeQAePD0XfhdV9SHCppfzViVeoh89UF8jLdSmuoeAkmlcQ0jJK7O/FGPD47/fEqDMNB9J7AJsAc2LPrztMr5TJcR13jWMsrp25aiq34JLlkEecqpnCjMDXX6blabN0hqsbdJDol8v2SXOr2iasEdXfONW8VUPatGat//lZnZaOFJp/0PzC0gL8UW9YrVv2iH2966HwAVyFjdtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB7151.namprd12.prod.outlook.com (2603:10b6:806:2b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Fri, 13 Jun
 2025 14:17:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 14:17:46 +0000
Date: Fri, 13 Jun 2025 11:17:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <20250613141745.GJ1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-4-peterx@redhat.com>
X-ClientProxiedBy: YT4PR01CA0474.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ec40ae-be7b-4770-92a5-08ddaa8511f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/MA3rX6soXoRD9+wrRbqUQXv6KB/3XArM2LOihuhQwId4ANSL2QE9IHct0L5?=
 =?us-ascii?Q?uIXSwh8j/5UFbOmqmhVLNamYLcq1mzBtIa6k9XPK8ERmiF1wDp9M2nr9Xciv?=
 =?us-ascii?Q?pVvDe9L/V6V9G8grJMQvm7cHGoFFHdBpK4cerU+t3AjdoV9QZJsEBZHo1E+M?=
 =?us-ascii?Q?ZFLC7K90JxGPQY7nmW5GZikb0EcC2ixUw7spipBfBPvYkRcL/dsfl7bm1oNS?=
 =?us-ascii?Q?QTk1VAFH+06GyCUbVc+jq1aKjTOnRBeIEhWfBre47g99kFt09+Mxx3FQ9n0d?=
 =?us-ascii?Q?hhhdCwxRHBr+HFM5gwloTnAu80TxrKwvlqHmixY533Em5QBpWN4iyk19koTP?=
 =?us-ascii?Q?Z9doPRx5hh8DAP19j+6jpxak43n2QY5O4NfXe5hW23KMPD+Ljsi55w1P1tkY?=
 =?us-ascii?Q?z/90lOJyLIgA5IP3DuAxNpz/7UNp2Ffk8XRRfNaEPXJLLwTnVsmvPfTwMHvN?=
 =?us-ascii?Q?OsRvvXAxUVtVleS8xFWYdHeIqS3Mu9WD++wSPyzn1kbMiVipCkUXAYIuDZrc?=
 =?us-ascii?Q?0ThqF09D2BbVKpB0OLzSsTUt5eEqfO44qZk58DnTwhKvrRp5s2UJMp5id6w7?=
 =?us-ascii?Q?F8UICE3s7obeTXVuJ3mNDz40PPeWhDrMwFmuSQfvXp2G0+6QWAXmErCat0Pw?=
 =?us-ascii?Q?ECBpFR0VPUTaPmE6sHeH7JTelzOdE2pdJGwLy4abB6I/xMeclKo39Ay4AXOO?=
 =?us-ascii?Q?pImj3qyrzRJyCqQ/xX12WV6nfhShZarBphy4bOROkmLGYwqBF0Akgv3Q/KbE?=
 =?us-ascii?Q?8dE/8IEWi1dt1C1iv7MCpNeYTuGhG+AeoEeeIrrnD+/qkjhvkZJLK6Lm762s?=
 =?us-ascii?Q?kSjCoCSVdEJ6RaDhejw5u1tJ2ujNodZqP/e07ThUkZhhXTAMLlPORYvEO+lS?=
 =?us-ascii?Q?7rtZiEBEVVmY2gvwDtoYNzxuz738wNjKzxBotVqV1SRgQDO9RHXCqnOcfqtG?=
 =?us-ascii?Q?o723eMGDCrO/ZQC4p2tGpKr6pLTMxI7wqrAHsFXTFxqeJe04YrA/dbTEj3pK?=
 =?us-ascii?Q?A3Jb3jDZZtAa/yK9MrFNK22ey38vcySlLF3XW25I8emNeR9MxMOkM825DTUr?=
 =?us-ascii?Q?57NmRgdQcEcL/CrUEpfZP6A6MK7L671ZVlVKIyr5EUI9b1UHmBW66xmZpCSu?=
 =?us-ascii?Q?+11yEjUUmTeTQntfVQ/8P+8Q5mQLDQqeLCR0P0+R6uJBFreAnpJ6xoacKIZf?=
 =?us-ascii?Q?riBPE4FyuEnW8gDsIUqLBJZioAPUIwVvub/n29Cny2hUUxbZ6wX45Oa8+LuD?=
 =?us-ascii?Q?gEAKp+3jGl2ZR0NTik1CakhNpDxuUmknyTBh6XCaup3IoARjub3GQxIgEUNx?=
 =?us-ascii?Q?xNcY9CCsP7Z7CxQAh8P+gWnUeZosN67KNmK47wxG+ckW5gwXDgSBFxgP0wlN?=
 =?us-ascii?Q?/yW3FGab6KKgvgtXUOo88D6hIHZjC6mLnw007m7yZw38SPSdjr41QnicsLfJ?=
 =?us-ascii?Q?VBnS0ufslzI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8sHdreQkYoIg4QcLyDyuINH88FLfYfsU4NaY3FIQ5f1AXtaXDgAcNuRrB4dE?=
 =?us-ascii?Q?Of4tfK1G+xLFVqeWI4vB314Y0pSjOZt/RfpGHX1XIQ72rw0IAk2ngQcZuy/4?=
 =?us-ascii?Q?F0g4T21LqCs/06l6tZAt+dy8pX2HDELdwwhYZg5A5ktXFm2POCofL/e85Dn6?=
 =?us-ascii?Q?LlVipT0XOt6UFe1rtyh+eBd6FD32AaYIl5wDknG3fP7/iSN15YglkwKyHM+V?=
 =?us-ascii?Q?p22mZMkkK/g+WTjWYmfuREm+9/qa/d8RA3LFisxl5GfODIicmD4r79WBw0KQ?=
 =?us-ascii?Q?0nb2ehk43BZTWAzaTEdihvarCuJWAIw9hFrjKCK80nKqGx+95IXYQrUPB8LX?=
 =?us-ascii?Q?+RsAThihV5pmGnpvCzzj8UABPBfFE6QXg0uqYskwj7BvEmzsoex2d0KkdcO2?=
 =?us-ascii?Q?vwoe1Sd0JQ1OeXADEE5xzqzbtTZT8WzbyTIxRnTyu6HzU1nmZ/q0S52JXUzg?=
 =?us-ascii?Q?QdYXXrj71I22xO0hf0AkZbDywWLQdQe2wu5yqPQe4n4LaxDQkYgKytk5Hazn?=
 =?us-ascii?Q?UyZFaehZEk4g4B6uy0hmemxNVvCRXHq0Rp+xc/k1hdmZhB/8CorvVvhaeFFR?=
 =?us-ascii?Q?uTQv/S7gWZdontrmP/BX5xFGtA9e7Rmx1kZoyj7WaoLXwXZ0j5cl7nvMzwpu?=
 =?us-ascii?Q?2cVwuIZ8kcu+3nY3ydHIfYONfQBOibq7m0ttjx4Or6kdnuUqxdnKUf7Os1uE?=
 =?us-ascii?Q?Vhs+hFSwSlnWjytjrxy7SvNRE9AjOFTmfCIdZPjwP00q0PHcLjIgLApq2GTQ?=
 =?us-ascii?Q?b2w3vhQekezdEat0JGxXGwzXX/rsZtxJ9OkLpGjor6Mbo98J3L/V75CV8bHh?=
 =?us-ascii?Q?xtQM3vSyme01HVvPtnOx0VrcyUSkeg20+UId8wy7XhjjnDjpYY47Kwd8FptI?=
 =?us-ascii?Q?0ENTYrW7XtgpYPVcmrJp41Dg1sbGCinL2agdbQNrJDf+tLqVyY0jDnhiwtlb?=
 =?us-ascii?Q?93e2Y9UxhotkiQ5drP4qR3V7yg9GLX9lAQRoe8CwLhyMxDOx/XBBm17KB+SQ?=
 =?us-ascii?Q?3uNJJPo2vBe66bDfowrWj+nqJ8D4M+vh9kb8fz9SP6LoaAY9hMzPghTsOp8P?=
 =?us-ascii?Q?FShv1vvKCVAZ55d74QNnJV/pXmXaAPoRnvKv5kS33FmVw/IceIZij1gXWjKD?=
 =?us-ascii?Q?4MhAGdZNXM+dMUGZHE9TIbQc71YCdJyjxGsYwJSoqa3TO/8ToYOoqn1nzdPR?=
 =?us-ascii?Q?FApzxGt5J3L3H/kAl1dK5DEn3GPHfYNWbWkDZhPXrZ4BLFqiiEddY4jC+KGb?=
 =?us-ascii?Q?uqEytUYs+5qUSD5xaNlSAXNWeS9m1F0Ay8/dL1f0zeYHZZpuj7+88t3cuF9l?=
 =?us-ascii?Q?921aMLdRL5vqmgdbq3TVQF3hPnmEakMVoXBYOYEzS1k0OfJ/Q/w+HtBY924e?=
 =?us-ascii?Q?RMBLceGcsjJExduTGbxHsOj17YTr0nN/JCjpI/JvAkNG3lWaE6D/aE8f0FIh?=
 =?us-ascii?Q?qIHTuR+h7cSVqrzR9egMqdcQIYRqJvD/moUGRhakBNhhcvV60Q7UWRuDrvuE?=
 =?us-ascii?Q?0RVr0ArOwCXB6q7PheK3rxLowa1T7Y8AgGOA9DMoYBhvPuj/MuZSVFtRmk/Q?=
 =?us-ascii?Q?LGNaI9y30rxmcmAmuM603W5U6VtXClmIlbup/81N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ec40ae-be7b-4770-92a5-08ddaa8511f3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:17:46.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjMBTRhVAAqY8NscSTAcqCMxpm2LdhzIzrrKs7CWM2Cf7mM7f75GiXWWvgGCi9YH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7151

On Fri, Jun 13, 2025 at 09:41:09AM -0400, Peter Xu wrote:
> @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
>  		folio_test_large_rmappable(folio);
>  }
>  
> -static unsigned long __thp_get_unmapped_area(struct file *filp,
> +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
>  		unsigned long addr, unsigned long len,
>  		loff_t off, unsigned long flags, unsigned long size,
>  		vm_flags_t vm_flags)

Please add a kdoc for this since it is going to be exported..

I didn't intuitively guess how it works or why there are two
length/size arguments. It seems to have an exciting return code as
well.

I suppose size is the alignment target? Maybe rename the parameter too?

For the purposes of VFIO do we need to be careful about math overflow here:

	loff_t off_end = off + len;
	loff_t off_align = round_up(off, size);

?

Jason

