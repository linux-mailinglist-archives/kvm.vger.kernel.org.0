Return-Path: <kvm+bounces-46926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 983EAABA6EE
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 02:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D61016A415
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39A24409;
	Sat, 17 May 2025 00:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TnAvt9Yd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B79410E0;
	Sat, 17 May 2025 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747440540; cv=fail; b=FEwLDntked2yxbBtpBvmjpOz+/Ln5cWJUIgZU3eEM2317foxq1RYQipljC4Btqs2dAevVZcefuXHWlk/G5stGnRZc+yyMPLSJnIlEfg8cGG1mLTnadQqMSVl7bJWRjwALFzM97WMcCSvkKsw2tNQZ0nu8+8w0TkhHX1RAP2vF7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747440540; c=relaxed/simple;
	bh=8nRZ6Fu9E12kXBfyaaGlH/TMn4TfIyQ/W8VAPt+S2Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uB0Uk36jjYH2RqaUYieDsaRed7QHj0DRCEf4rnmDNPC/VG5obSR/0j0NK/eVccKsCtLMTPGXc/OubwECJ5Cg+jstk8RBvwJaDsACw2PXaeFLFHEtbj60d19RM9gXfWr2VQO3ZB/XXINpTpDycWal7pGrJtnHN65c64fC9F/IV2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TnAvt9Yd; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cEzB0A6ZII4lMdW/f2ll6PT0KpVXn6aCk4qBlamarp2HusQf6KLPw+Cp3WWXoT3UF8Ypsas/eJt+jnh8OJSgi3nEl5xXqe0dyLSPLznJClzEul0EvXF5H2VLjusFW0CzwgjHCCidr5jMJIsKIz7Paw8WKvwsOwepuD6mNnLeLEs7Q8T7xJfgqKyhK6ws607F1S5/x5Fl5i3pT6EWibUxI0g3UReeNY/jFxwTE7kkPBC6+s9qvDfHC7U519ilfXP7ZHy3EG7nedCweWEwD7QOyLOFzb27+PIV2SLQ6kS1JwCx4aXYAZyjecN14z/OCjuGv0rQkLiEV5AUuJ/wI5570g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6oVxWtMMQg54NZ+huvySA3grEfsBBuGJV3RAMw3Zf0=;
 b=qUBOsydDW6lNW3gvoKOZF/8iV7mEjaehRS3k6euCvH6VqFLfFSoYpok+VUYTHA9OsVKFDf0AIsFM0iHA1x8RsOD0L3huPderaC9mQ14fCcPlYFCIJQhU1tMnqAz3n6tlOyYJqKI3iv08eoFkWRvltrQ67o0m8e0YSeDGILyAj0dRpcvzEk9WfPGQsESYJQ9vfEIZpqGZ2dPYFSiDZF0HPJRmAu+kKEfgACFWkOTS8eGyoL6KbasGoWZFiQcNVvSmLtlsW+Nztu0XXD9DdYfq3O9vCSJ6IKdjT88odOF0CCUWxizrW147GbpQOTz5IbSJy+TEWqb7aeWvb3F0EjULRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6oVxWtMMQg54NZ+huvySA3grEfsBBuGJV3RAMw3Zf0=;
 b=TnAvt9YdgZGfNYZtwOtrMccA6yZS2JZCMq4ZicKQ0WApYkIDOWdwYAXc990bSVwdreE7LAgLYPDbXpOtku03yI2GQdN5h5HtMYxs7uRcJu3hBZgbNbZU1c9IwMAOSYBV1jmrlid4A3kCst8UtfySx0j7Qkfdn8w+grGIgPMGyN4ehBUQsJjjPN0w1jjDQkAmEn6Vrb3kyxQXDeclR2qaq5Dn9g/z8A06rW11wrzskFv2dRl0ABmKIeO0FAn2BvLkNzHwXXn6oxtmHB1jLvOdCtUyqA+1f+/Oojd8CePFGzUQc4GTfip7u2wBHdt8YDpbBWXaQAfi+295uZkjpPyvdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN5PR12MB9464.namprd12.prod.outlook.com (2603:10b6:408:2ab::10)
 by DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Sat, 17 May
 2025 00:08:54 +0000
Received: from BN5PR12MB9464.namprd12.prod.outlook.com
 ([fe80::e83f:10b6:1259:d000]) by BN5PR12MB9464.namprd12.prod.outlook.com
 ([fe80::e83f:10b6:1259:d000%4]) with mapi id 15.20.8722.027; Sat, 17 May 2025
 00:08:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Sebastian Mitterle <smitterl@redhat.com>
Subject: Re: [PATCH v1 2/3] s390/uv: always return 0 from
 s390_wiggle_split_folio() if successful
Date: Fri, 16 May 2025 20:08:53 -0400
X-Mailer: MailMate (2.0r6255)
Message-ID: <E1DF5F15-1211-4E4A-AD1B-BCD2396DEFB6@nvidia.com>
In-Reply-To: <20250516123946.1648026-3-david@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
 <20250516123946.1648026-3-david@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:408:e5::21) To BN5PR12MB9464.namprd12.prod.outlook.com
 (2603:10b6:408:2ab::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PR12MB9464:EE_|DM3PR12MB9287:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f395e2-4869-43c6-acbb-08dd94d7030a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9o8EKEXOkzOPZrFvlj3sD6lfXP9TqJYuJEIX2ru6qH5q82q536G8/OeCW3oU?=
 =?us-ascii?Q?sTrmy/XDVj4lPA4r3lLkEF6T/4H3CJZmhDjg8JXCwYz7AihVd2VJKh0aXQPy?=
 =?us-ascii?Q?Xc15LsF6ZvW39WiV4tS1NUHCfF6X2b+D2uxs6rCZvemCI4UrMN9hgLHueZwG?=
 =?us-ascii?Q?dkSqaBJ84M3JCM/7FxZtyj+MKFmYdskW7Dx6MczmL3Sz2IzvKTr3orI1ARbl?=
 =?us-ascii?Q?e0TtelKMPlOSo99Aw0vwMnganHjDrJZwTmnQPkVaf1pLS91LL5OZZbTLKZFS?=
 =?us-ascii?Q?uezXBCbR3h7bImSDc32s42HGIBDAE3RYgxxNEj9doPulJmBWvpGWwMtsh7En?=
 =?us-ascii?Q?zoRIf1zcNa2A6wf7+Eb9JNG6YxKmu7oc+wXtD0OlaKIsWItn/Cxfz74oHIgo?=
 =?us-ascii?Q?7XlP4dpGWjjxDKsWz0vcPRHptBD1lhJm2BPBIoaa3B9gG1VaVKU+SfsdQAQL?=
 =?us-ascii?Q?NT+uYtcDapMTeOPy78K+WdtH0RFks3v1CmvvL2ITabj1+S/WiGViFubwa5d0?=
 =?us-ascii?Q?zxqDwbTXXL7Sg30u0jt7kFxVIv+7oGqZsGnfBmsXF36TWl5QiSi3Q9MJ+G4d?=
 =?us-ascii?Q?yj7c1CqZe7frXRHBDCptKOS2M6gSnoSq0zhiC1M7HgYNKlSJExyJpd0zNABF?=
 =?us-ascii?Q?ORx+P0LCW3ckmYVa1nlZ0mrrGiN1j0r5VYCtDnbfGG53O7t1jh8Pjil7mS/u?=
 =?us-ascii?Q?WO5bH4Pxxy8oft81FcFV8jpnqY3jcGbSiS85aqzqvxFTh43IM0MnurkUtUny?=
 =?us-ascii?Q?DUJaKOnlxTA2mJjakBuPZUIkjPwMQp+D0Becsko9EkOCb/HYnr6lJf6ISWrr?=
 =?us-ascii?Q?Xq6pIY7Q7pdiBOAGSTsgwNjnyCtz1UFRhZqLoYZoKw3x/uuvnua/w/m7awlr?=
 =?us-ascii?Q?9YgoWAUgBsOqLslLaSfYHrs4sytKrFyJv4iQRbVGG2L8NnHHiT6jzm8RAT2t?=
 =?us-ascii?Q?MAMvD+v8Wqkdo2W1baoxdhZCKPP3ZE/ba/SMWIBbEykG2hz5Z5mLa9NeoGaT?=
 =?us-ascii?Q?57Ne4wYryYeVirdYlhJAA/9gSjMMvkbKRS0kXNlC9FIjk2TP8x/t7y7AtWB4?=
 =?us-ascii?Q?STHZi9xAdgOz7MBTE+w8oemJBTNjE5h6Wmhaws5RI6bSIOR6uCJEmUfXAn85?=
 =?us-ascii?Q?rdH2gRL5GZxD7O9xHZCG6MKm97tnWhU8kUKuudpX37Y+7fUdIkmt3FhdC6nZ?=
 =?us-ascii?Q?VNq8NnyQ4ZARinYr2uI3IErH1HS1YSzcosGz0v/MLFBv5SsD0BleIgg4lPHw?=
 =?us-ascii?Q?9F19qXkcUxMvE2nL3GKFRZzsBHO1vjo3Zv3O/zLy0Iw+v8R0n2cngbPP+InM?=
 =?us-ascii?Q?9YSV8C5QnQT+ptCJoXwVJPluOtgJf5FXoudPPM7lrkCVBvbsIqhpAetXmoht?=
 =?us-ascii?Q?pHRyGjnl0+vTczwJ43eWckGX9SVyzkTzSwmdAdAaik3oI/ZWu7P9CAFSTiEN?=
 =?us-ascii?Q?NeAl3X6gkpQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN5PR12MB9464.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cVSY6aUK4rsndB/R/FBT8we2WqDmUGjhmFB7TPxvm7JUb/EDJjauHSKvgfLt?=
 =?us-ascii?Q?WYyGlOdJ6GOYwnCplLGVBqRlMVIdQK2XDcc7g7svHl25yeQgKPDpNL7haGu+?=
 =?us-ascii?Q?ZC43Dls8WIoKGXzc9wbZGO/KTQdgsJW9WOblddtV+DOKbyJpIxiXZTV8q24m?=
 =?us-ascii?Q?Ml2Z+Y6+L1lL298Ib9ktdjWpUtaUUfpXaUbRvDZzRtdNN0BTG0H/RqUJId/S?=
 =?us-ascii?Q?Om08u0QvgpEXUd4S/3SETS0zt+otjftJZTQqYJa8XMGKzBU+C0E1JMnK6j/r?=
 =?us-ascii?Q?6JW02WR8N47VOFkHvGgjltl7hpazVtlOgASjnjBIFMCDL7ZEBsmlYwa5wmof?=
 =?us-ascii?Q?HECGlSRVZM20rZlvaXtTXsun5WNR0KAEnyinF+o76JfxHEx+zkha8wOHDnDQ?=
 =?us-ascii?Q?oj2uWGQCjXKZbMva7rWkdtViV/5MHfAYFPKSBUVKSLzCAOd6pdseenpIyIeD?=
 =?us-ascii?Q?72khoLEsz0ENpbUSdd+FyUg0VyBYXK4lLqdQ+7LfXY2Y4XNA7rUllERioBWt?=
 =?us-ascii?Q?9WsPGDnzsWmZelpXdnyQllQHTnbu9nHZ+7DYxy8TqqTUzk+BHIYhYtVfhjcW?=
 =?us-ascii?Q?hyM6jlEwaq9dQUmLkxGI+U85PfnaCQuYLk7RzJcA89YB0K32w0Z2cqazndL3?=
 =?us-ascii?Q?Ncc7aFTI5SyZ8spzr1ihy03ykbkUTkPd52WfqxjxDfn9F8sho8e28/nkTmxX?=
 =?us-ascii?Q?QOsDce2D6MhqcOXDcrkjjr3yT/2FItiU8T10rTvLyO9YjNbjMkTptAPpbbuB?=
 =?us-ascii?Q?xiOLryQE4uz+FDxRmJ9Wg0KBJ2SQ44MxHQjhvKCz+OGNLWKf+0psN12ekFR9?=
 =?us-ascii?Q?lvWkEvjKCjpkgqc0qzFrdoiFUk8hEUusY4Jql+K63etstfZqBKVKJy2za7WS?=
 =?us-ascii?Q?52va+PR+89Y3Ivz4IxDn4aGumrHxr5x2SC6n0uYohUOCsx+q7ZtlzP2VtssP?=
 =?us-ascii?Q?6kJl9m00/BHAggCa2GXffGwVIiAxPRDwGcs1K+xPfbyNJ3sDI/E5cmhRutyG?=
 =?us-ascii?Q?0uRKQrjPruPfgU+slVbv3F+EEKUVG+wXZzmjdQGkxrlPi5IvHE7RiduIrOGY?=
 =?us-ascii?Q?OhZpDW1GcIWwXpl1Xng7eLhelp2ARA3EbUOxAfXsYyhp1YyZFwD9PP7m45Ip?=
 =?us-ascii?Q?k0Ztex1Q92L1ZsvmXjCGYn7M4p6u0ahbgExxzz8IFNZPLV/I6etsSv5/Olyk?=
 =?us-ascii?Q?jCZQlsJjo2ZYY1iL/2Lxwp/QGEEnS4E6jnKiHfLjx/zQQMKRnil2aHkpbYfR?=
 =?us-ascii?Q?0O8t+t5eYTPlHSzWDHS3pLfKTGOrtH4Z9272pQroxNmzD7MKCnpLcSkgnqin?=
 =?us-ascii?Q?hfhbdO2FqIJu4Y3648hjSb1NURFekPHTLf3jALyRwOn6JrlnlmXk9hgYsrnC?=
 =?us-ascii?Q?trWU8ycSiOkE6e3Cd1/rws5clgsWud/ib5PJA+cBAUodFpmqD712nroCkJx4?=
 =?us-ascii?Q?e1sb6AjNuCcoLMVTndPtyDS+AYHu37LlFkSE+RLtzsr5+VAiUYVQEdiInRKl?=
 =?us-ascii?Q?S7aJ0m0z7PlgAbQZUbTRrqrJTbYdJONHPAHbvm+uYEuybbA0vBJua5PLpm2D?=
 =?us-ascii?Q?PztqqNnK9yauS73hPLokCyE3jmURnE5vCvBSjYx6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f395e2-4869-43c6-acbb-08dd94d7030a
X-MS-Exchange-CrossTenant-AuthSource: BN5PR12MB9464.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2025 00:08:54.7964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uS+1hFEZjbv1wF7DTyDSlZyf/wEecp25cmelwVZT/ck1XtORk5fW0UkwAaNXruo2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9287

On 16 May 2025, at 8:39, David Hildenbrand wrote:

> Let's consistently return 0 if the operation was successful, and just
> detect ourselves whether splitting is required -- folio_test_large() is=

> a cheap operation.
>
> Update the documentation.
>
> Should we simply always return -EAGAIN instead of 0, so we don't have
> to handle it in the caller? Not sure, staring at the documentation, thi=
s
> way looks a bit cleaner.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kernel/uv.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 2cc3b599c7fe3..f6ddb2b54032e 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -324,34 +324,36 @@ static int make_folio_secure(struct mm_struct *mm=
, struct folio *folio, struct u
>  }
>
>  /**
> - * s390_wiggle_split_folio() - try to drain extra references to a foli=
o and optionally split.
> + * s390_wiggle_split_folio() - try to drain extra references to a foli=
o and
> + *			       split the folio if it is large.
>   * @mm:    the mm containing the folio to work on
>   * @folio: the folio
> - * @split: whether to split a large folio
>   *
>   * Context: Must be called while holding an extra reference to the fol=
io;
>   *          the mm lock should not be held.
> - * Return: 0 if the folio was split successfully;
> - *         -EAGAIN if the folio was not split successfully but another=
 attempt
> - *                 can be made, or if @split was set to false;
> - *         -EINVAL in case of other errors. See split_folio().
> + * Return: 0 if the operation was successful;
> + *	   -EAGAIN if splitting the large folio was not successful,
> + *		   but another attempt can be made;
> + *	   -EINVAL in case of other folio splitting errors. See split_folio=
().
>   */
> -static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio =
*folio, bool split)
> +static int s390_wiggle_split_folio(struct mm_struct *mm, struct folio =
*folio)
>  {
>  	int rc;
>
>  	lockdep_assert_not_held(&mm->mmap_lock);
>  	folio_wait_writeback(folio);
>  	lru_add_drain_all();
> -	if (split) {
> +
> +	if (folio_test_large(folio)) {
>  		folio_lock(folio);
>  		rc =3D split_folio(folio);
>  		folio_unlock(folio);
>
>  		if (rc !=3D -EBUSY)
>  			return rc;
> +		return -EAGAIN;
>  	}
> -	return -EAGAIN;
> +	return 0;
>  }

I can see how this function is written to service as two purposes,
trying to get rid of pcp ref of a folio and split a folio (to avoid
the extra pcp ref from failing split, lru_add_drain_all() is
called before split). Hope it will be refactored later.

>
>  int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv=
_cb_header *uvcb)
> @@ -394,7 +396,7 @@ int make_hva_secure(struct mm_struct *mm, unsigned =
long hva, struct uv_cb_header
>  	mmap_read_unlock(mm);
>
>  	if (rc =3D=3D -E2BIG || rc =3D=3D -EBUSY) {
> -		rc =3D s390_wiggle_split_folio(mm, folio, rc =3D=3D -E2BIG);
> +		rc =3D s390_wiggle_split_folio(mm, folio);
>  		if (!rc)
>  			rc =3D -EAGAIN;
>  	}
> -- =

> 2.49.0

The changes look good to me. Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

