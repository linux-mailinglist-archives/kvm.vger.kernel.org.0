Return-Path: <kvm+bounces-13576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8712B898BF3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63E35B297CD
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5928112CDAE;
	Thu,  4 Apr 2024 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="NFKH0v2v"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04olkn2047.outbound.protection.outlook.com [40.92.75.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B235412DDBF;
	Thu,  4 Apr 2024 16:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.75.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712247278; cv=fail; b=qVbuNuPDyQC+hQEjv8jEbOSk1xJZqO30n8IUrSH5ipviADfbsb0XkAdy/aBSxg+BHp+hawriz3oscNLN7za71dC8N6wyA2FnpFMn7A45x6hzYeB0+rWI22StetUtqjAoAN1Cx1YY6jJId6ap37iSD8Cr33JpusoyaUlh2XlQe+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712247278; c=relaxed/simple;
	bh=MAmHu9YY9DWnabA8QzOQKIRYM3B6FTI8ycr/bHF9sys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e2HdKq0SXchPPVroDyymbkpbyu9YqMxQ8Uy+7s9hGREesNsaDFxagkBSity9GDDiQERw8SvZNUSXgydENlKVJgKMeuThSqqEFIp9I3TpYOmD0Fdy3J2myKXiBXW2B8OAOw3xEZoCK6dK+cL4kAt3PDEnJPNW5PgH/MGBFarKuDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=NFKH0v2v; arc=fail smtp.client-ip=40.92.75.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+bO8yoFhp9Rjq/rxibU9c/398DwzeiUwiUwEQTDDzqtJsOHBGs82aAVWYginEql2rDjFB9Uoihccd8wcTNAxEe/ABXxJ4yaeaZkwBJePlxEebIPzp8b83YU+nPX6duCZJ00fMpaP5EcpIJ5rbK6BTktf57+6JOsj39/3hqTk5zjqEtMu0iFYxmJ7xFKKO+Nz6LucPhcr8D5j82z1/0m9d+tht0R+d6Rt8+a+OD1jwh7Qup/Ez3i1uh1ZQBqzgsemwumueyH1E8fLYld1TeBWFnMtDmBp9YizC4b+uRX8lOJbYqsBbf81etQ8kLwEJYywF5GbzvAjPAgkb51HcYhcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQDs0ib4dnCDeZfZW+2JLkP9VU+5eA24z54TCb24apo=;
 b=W+/zcQJH3WR464+89IlSyiT9vr/skphDMZRrHh95aAp2CnaTJaNeZu6xwA/LgMc55+cscIcLQA3nnty9roCycLqA/LCLP/U/xtQfP1ObVF7wYCSKBuAMeOPS3xd2Er5X8Xwnjpjh6RdyxiPbEqZ96v6/CaM+uKz0jPSAyNFaMOoN6zSBd/uY+bLnuCtj0LoLOcH+7uVceeYTmJMDULTLiTamt05hhsqYtnhWHqXaP6Cr4tZgynhZ04Z3zLUdsXmpPsuGLUk20FOpJV/YE76VCPyCvS2PliJTj5HkYHnLLAMhvU0iueDheg6RXfPvpp0RSo/DchqKOOz03qPUCCQ/ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQDs0ib4dnCDeZfZW+2JLkP9VU+5eA24z54TCb24apo=;
 b=NFKH0v2vK8R99Ldmeay6CAfQelCJeY8LTy7pOFNAJfL+jpjbFaCuXJpSDw2lAh1JCHGUlCNiTsQXGzAnfUf7ceZNzkkuch4e4XQkQYRwowq5DUPOf3Rigc0fOjlS3RAORgFxdU9Q+wjA+Mq56nLcX+VK2xWnGoruEDrYQ/ufTZ7iMaIMx0sYLzDMt9tDdJYXLwJETezN6YPsb2detz3E/CUweiV+o7AaAqHJkc2Dt+yIMCJpoWigrA8v1vUc/UHKknzs8iPz+TyFFhpSwzfDo4+HGyVxvU0kY8q3tMWd75SBJAK28QsfqRlCFSJEuYwXMGXCVE/sZjtJLZDzeQLi7Q==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by VE1P194MB0909.EURP194.PROD.OUTLOOK.COM (2603:10a6:800:16b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 16:14:33 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 16:14:33 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	luigi.leonardi@outlook.com,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] vsock/virtio: add SIOCOUTQ support for all virtio based transports
Date: Thu,  4 Apr 2024 18:14:12 +0200
Message-ID:
 <AS2P194MB21702427C769FB68A13AF54B9A3C2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <3n325gojjzphouapo36aowmcgt3iqjrqrmckqjjqgqmhvjdz4x@4givlk4egii3>
References: <3n325gojjzphouapo36aowmcgt3iqjrqrmckqjjqgqmhvjdz4x@4givlk4egii3>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [m5Pdr/5FTTvQKDDpTjNnZNBacqZhR17c]
X-ClientProxiedBy: MI1P293CA0004.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:2::13) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240404161412.3394-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|VE1P194MB0909:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b5205f-273d-43bf-1418-08dc54c250b8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i6TOCNL2DA9oYvKga8VmVDGnSOxBl+zCPzwEIwXxlpG3niFs5mHu6IYBQ7l8H+rPqv+i5EY5P47AS9Ix3IWLWYGwnM5UBcIoqJyizgWYvvYOdWox4HotKlTvuFUI0YO2wpnNayOPLS7QkCldDioX8VLNt+gSK6/ng1asZLq4w6N1b8T7RwLF7Nfd0snx/m5v/cxO+5vXxVRnMlWgELuqeTs5By4BJYe0XLxCAAPLXN+E8+MAUm9mwM/lCTCuLz3y2qftAh2FRgPKy9bqcFO2ru/oF60IyZaFaRrai7IRy/hNUzBm6AZKt1QPF0TmhIa/RK071FZt3NcJnlE8n1DM5wpw+Rtv0mCf8GZvyPwghNQ8QtI21EkVjSN3VBKcKloWzbXs2WsWlqk4ytWVGxazLCHSTGKLwyeZEXEKFBeVftjjTUDXNKDwp6+vIY/zHeml0bzNyiji1P5aAAMFg1gmzEtiiI9FcLtm0N0FOlGVdYiX7UGmrXnMjxQt1m5hhvauILzYe74Jo5Ymc/fsJgBOQxcR1CjhT+t3qYrg7FmImQ6aEMVkaIHyLAQD7VG095KerRGqGmk2a1Wi1tetRy5iiDNTWkpAJEcxAzBXl974u1kzrigap8RvT+hKINVRt/sa
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1iQsM6eHjqc9wUPmimLCcjjbb7TyNxPrT2hKvLtecCGMfcd/EGtoU2xHgv3l?=
 =?us-ascii?Q?/xTf2Y0ko/0hNf2ifp7MroMMQgIUdihcTwzXj9hqKtK3j5tMVflNKjTa1BMa?=
 =?us-ascii?Q?toZmzLn9uypMIrSRF12hWj41bEXrRsCWkL7IvxV/8+UXxemLt8FSrBr+fscV?=
 =?us-ascii?Q?d95DJxNsIFZmS7REDzvqZlnUaKRfyc/R4SU8rA3es4d5xnlOY/JBohp7s3gQ?=
 =?us-ascii?Q?jWpy2UfSJE7wSISL4vn8N/YTv1qJ3TWM94skPqRohBOGybO1LUWPcnFvsets?=
 =?us-ascii?Q?JyiAQGtyZWj/XbrG9l4gj4CEl81WYl3siKPxfjSEGvmDueK5/YusmSRbgoNW?=
 =?us-ascii?Q?R4LUbldCLrR/5HrcxnYMF9YrmS4crB4/e7qNQYYrDcoa7lDZIbNsbkJb3/WW?=
 =?us-ascii?Q?CAbYorXUQWEOVmjzkPbKT1a9V+4kxg8GAtwS3qdLvgmTk5NEOvz+EpsY9B4W?=
 =?us-ascii?Q?zyylgJ4LM/4xSEFHr0C9+BnDwl22gRW5u23c2SmkSZgvlPksdq3z3hUeX9TV?=
 =?us-ascii?Q?3OOjMV3b7AEfUvJOjlW4zhihDpNa4pvS6TQkId8NazN2ev0enYzcfXJ6jO0c?=
 =?us-ascii?Q?gaSJttdRtJOkLOM1luEOdA4AqVez9aoWoOjt6qyP5DbXLcs9PMM+s5xy+xDd?=
 =?us-ascii?Q?WvsBShE9cGH/BzfMm2XrjVWgo0DY9oY0Jus77gR327MxJyU2bR3QVfhl9ClI?=
 =?us-ascii?Q?OLPJnSi9ZrEdZWWCl5CxAymU7tOaZ37zg3sj5niNVTOTQQ65xYmccI3UZRnD?=
 =?us-ascii?Q?aBUuMzgHXg3xha3zlwTPIBLuQX+6yOMj5lri+fjTlN9vdPxE1Y+WzKZh/FBs?=
 =?us-ascii?Q?lb/S15tnE9aVRHvfGUIXoMy40DTMw9qs6AkGNi0o2OhBmhybd40Np/VrDHk6?=
 =?us-ascii?Q?kzOtUKrUjmwcl1FTgaakMA1SVvAnJqcStknO3IFSgagHCmMNv5eMPHxcgQI0?=
 =?us-ascii?Q?H+suF3GegK69UX0ypmNhw7tg7NyF9c+al/jOIwv6bxPb3e/0ojo9wTcnASFz?=
 =?us-ascii?Q?Uw3oigXMlN3v9HskzsXrEryL3nYo4Chr6Kp19g159c2Dg0bgFX2NhkXJn1nt?=
 =?us-ascii?Q?PliG7ueoj//oI7tnJ4vF6AS7tpemQAfmkKPYibJDvi6dAy2C8pwyutc9WUUi?=
 =?us-ascii?Q?kdeS40dbuSiDiAeNyvWKJyhOA456QLqPo8k+OVHQKUxWL26VWGyBQuVTEiMy?=
 =?us-ascii?Q?6Ur+/Dx5HwsU9p+rCQH8Wkm5UQt85r0l3eVjEGKiDKnISbyf5Uao9yILAp1L?=
 =?us-ascii?Q?fyzHPAbDJqsaCUsgnrQQ?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b5205f-273d-43bf-1418-08dc54c250b8
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 16:14:33.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P194MB0909

Hi Stefano,
Thanks for the review.

>We incremented it only for VIRTIO_VSOCK_OP_RW, should we check the
>same here?

Checking for the length of the skbuf or checking for VIRTIO_VSOCK_OP_RW
AFAIK is equivalent. Since the only packet with payload is this one. 
I'll add a comment in v2 to make it more clear.

>What about rename it in `consume`?

Sounds good!

Thanks,
Luigi

