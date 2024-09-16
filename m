Return-Path: <kvm+bounces-27018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CFC297A861
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 22:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EC19B2A0CE
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 20:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FFC158527;
	Mon, 16 Sep 2024 20:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F/Vi2tPg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qw937N57"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D2AF9FE;
	Mon, 16 Sep 2024 20:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726519326; cv=fail; b=TRZfBhcGCu1frxgC7Q+dAuLcErNKTYElhJ8lQmkUxm0gNUURC+sILaIpbq42378Oxy2t3xhKWyGN9Y//cRMmc4rfYz3d6JxdIWCz9Z7JZfxmIV/QS27whLbXnQprrihJ/DfVxy6KtghnJf/tol0nP3a95E//ZPfk88RXgY58png=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726519326; c=relaxed/simple;
	bh=Awt9FtpN+VIp9CmZvrXZV0+mPqF9zfXy4CkhLo/fAg4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ya9tiSKwo0TrMrqwBm9UkP/weNRtEvD6ZpSGbuBQ86xv6+GKZEWT2KXRVRNj4ivwBSZh/kawGrQEK8vOYaAlKxiuQXWK28NKnxWLQr4eT6D6DF3CCP2nuhUJf6IWCRFbF8aKXOK4PIOUgFRXO3MFpaGUALvDei4IFuWqCjX9MFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F/Vi2tPg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qw937N57; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48GJtfiB027097;
	Mon, 16 Sep 2024 20:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=NSk0boGRapiOTDU3x4EYyryE/lLnQhpszlHGO7+Ccqs=; b=
	F/Vi2tPgrL4hs5OunGNyUAfNa5uTaNWEh439waCAIcHM9z16BC7XIgrZ9BTl5OYf
	fDGEzKYJ+u7oLni0M674zn8CEp896NrzQjg/1+HJYckEMQMxzt04jrQ9fCOr3T9l
	OGVLQJ7KfD8RSGUnJKeNAZfwGpdm17YKJkHq40fseMPw/CRoR7EIO12piFIS0yFR
	DBtrWbGXShFIL54c5TZcqoOwsrWtUy0FrMPrieLyLE4ndAH2GoZTiJ1KRSxyQwhu
	WznSmFaxvD8+wAzl3RdO3BEPEgslx+2CxkAMsww2gW51cCkROA4OQR34GfrErp/W
	iReWn6UKpoOo1ljyb3kQmQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3nscfsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 20:41:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48GJYjoJ034144;
	Mon, 16 Sep 2024 20:41:56 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nycfx73n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 20:41:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hsDQjyhhG20bmXahdHk2FcfblFZzPjmhxPt1lvugxZASiWqulaZmc58cQf+27F3HEMGPn+xcv/coE/Y7Hpzyd/mJyOBY6R7dy22I3bSC3STfWIuAf8WR/iGeL9Olg9i8/Ionef7AdAZnzwJYvjDJZwoO+V43xox7RZBDIxlEv5rw0jsyy7dO6hs67oW/rN5MlUe9XVoBlJS74Dgcum9e+iZ4HSfWenxbA+ofzkIJC0UlzUPx72dfZ2uyMiXjyXlbQHOJ3Xn7RbBqwz1XrosS3XVEDS3My2L0KR9A4cC155Q/XBltnTs+oMTUYUheOPGbBLHjUrMOzznYz21QNAqr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSk0boGRapiOTDU3x4EYyryE/lLnQhpszlHGO7+Ccqs=;
 b=A3Tfvq1QsZd7QLQH8VeFU0V6i8lhOTRNmeFzSLCfrMzmrMVcwP2zPZbCUEqOt0u3tWUAQ7Tjr7A/730lRvtkNVfvMjtx5HQTnAIyYpAKgqqUg8V2FtG/57aPIXop0cIdEP2srAx8K69zRkjrFZRqr0ZFyLtlD9WhdfObgQ6PZdkU+kCTPEDiN0mloz1fcr8+S+lktleAO5daalFxaw5UtnYI9LoubGLuOFbJi0D9fvqtwkazTB1gr1mfmZZw242TRnkGbHQJP60LvbsKNLT0U9elil5YddnupZrx1Zhej2PB/4YMX5w5psYGGYmcXmlNwkP3MANmxSVGJkpgVhwSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSk0boGRapiOTDU3x4EYyryE/lLnQhpszlHGO7+Ccqs=;
 b=Qw937N57fCuXOiSguZSypAgFqkiKTahBjL9yzE3wCRYdXHjcsdTstPRGTzXYRkBeY8PIkepCzRXo0NWZuN8iGvQ07Aw2eYKpHremGtFaAJ9LTb8XIQs9JIXdA2jCU3j4iv+EFESruzphIgxL7XUAK1Bi6FMnMwWEvPjhyyQacbU=
Received: from MW4PR10MB6437.namprd10.prod.outlook.com (2603:10b6:303:218::17)
 by SJ0PR10MB5568.namprd10.prod.outlook.com (2603:10b6:a03:3d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.15; Mon, 16 Sep
 2024 20:41:52 +0000
Received: from MW4PR10MB6437.namprd10.prod.outlook.com
 ([fe80::760e:8e97:cfd7:8cb0]) by MW4PR10MB6437.namprd10.prod.outlook.com
 ([fe80::760e:8e97:cfd7:8cb0%4]) with mapi id 15.20.7982.012; Mon, 16 Sep 2024
 20:41:52 +0000
Message-ID: <2e3f168c-3b0f-4f18-9db3-0cb2be69bb5c@oracle.com>
Date: Mon, 16 Sep 2024 13:41:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Small question about reserved bits in
 MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
To: Maxim Levitsky <mlevitsk@redhat.com>, Sandipan Das <sandipan.das@amd.com>
Cc: linux-perf-users@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <5ddfb6576d751aa948069edc905626ca27e175ae.camel@redhat.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <5ddfb6576d751aa948069edc905626ca27e175ae.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:a03:114::29) To MW4PR10MB6437.namprd10.prod.outlook.com
 (2603:10b6:303:218::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6437:EE_|SJ0PR10MB5568:EE_
X-MS-Office365-Filtering-Correlation-Id: 1216d04b-c719-43d5-e5fe-08dcd68ffe82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlNlb3JhSWNmL211eG5FNE13UnI1bnNlb3cwa1pTa3UzN0tNSzJHbE1OREV5?=
 =?utf-8?B?ZVFETFMrL0ViY2ZGTU1qRnBnc0N5UklVVVRlTVRoOUtFeDQ5S0s5Q3NuQ2gz?=
 =?utf-8?B?cVdFMU9sVWRrenkxOXJzYVBHaXM3U3BGVWxVSnMxcDkzWCs1V0xrbndIcmU3?=
 =?utf-8?B?Wk1SbW5IeWNYRWw2c2xaMDE4RS84Vk4wcVJiY3pVQ1NtQnRkb0ZLVE0wL3Ni?=
 =?utf-8?B?blRYeGduVVo3bktNdlVxSVVQQVFDc25ndzF2eDhCZFRpWFRIa0d3Y3N3aEd0?=
 =?utf-8?B?OStleFM2WlpQUUdiNWtadXI0dDRYMkRKYWQrTGtod2lKTHNQb1M1K1ppMHQ1?=
 =?utf-8?B?OWJUMkhCc3FPR1Q5QXhZZVc2b04rc3ByNUZ4ZHpoclpYMUp0Zm9TL2NwaWls?=
 =?utf-8?B?dERsa1Z6bWVsN1lLTWhjaFZiL1I1cERkWHp4bmNYYkhsczlsWjlYa1J1dnkr?=
 =?utf-8?B?NFNPZEwzQTVMWXU4WEVhOFR1U0dYUzNUR1dyYnNXOEpQODZZcmNHYm5iR0pQ?=
 =?utf-8?B?bjlaVS9aSkVvQWpoRmdSalZaUFNDc3RIOHdyOE9LL3g5Y1lNRUg4djdsUXFi?=
 =?utf-8?B?aG4zSDJCN0owZFFRQnFMbjNyT2xUdVl5UVVjMUU5d2dha2tkSCt5NXhqZXdj?=
 =?utf-8?B?bFR3VVZDRzkyTGZOTG1CRUdlY1pGRUVuU3QreVhtR3Z3TXFhWWIyZkl3akNF?=
 =?utf-8?B?VWw5Vkhtam5QY0oxZCs0Vk95K3dUZTB6WHc5cTlYOG9qclZURXR5SzVtQndW?=
 =?utf-8?B?dFQ2Ym9KcUFaYnZnTGhLYktJYUNrelN0MHBxaE1QRjl2WlZYVDl2VVNGVUxV?=
 =?utf-8?B?Zlp1bmszVjZnTFAwcDk2YVhTTEZUb2EzSktIekJVY0FBNlczZDl5NHQ0ZEpq?=
 =?utf-8?B?YU1BQy9WTm9qMmdnVHRTRFhJZWVNVkZDZXZpeUxKT1k3Tlh5MkR5QlBZQ3cv?=
 =?utf-8?B?c2VxYW5kTFNVYk5jUWUyMDBxbEJOR25oQXFLV2FhR21EbXFvTFdCbGFMZmtI?=
 =?utf-8?B?YWxXWFB4aWJReWlBSUxqNzR5RnVVdllUNlQwK0F6aytjdGlzTituK0MvMHMv?=
 =?utf-8?B?Rm5OYmpNS1hqLytuZ0pmbFhsa01QSXNJSHJWb1IrL0dCdjR6U2pHdi9ZQzlW?=
 =?utf-8?B?NUxFbSsyL0NnYzRJdlQ0MGY1aDFOaHVqUTlsUTh0amxsVTFzUDNEYlA1aVkx?=
 =?utf-8?B?cXdBMWlPZjBVTFlEVVF2blhRUVFjT1J1bXc1dEVPM0pHejJQU1BDTnp1ZzlB?=
 =?utf-8?B?ZHROdjBjTC9WeHU4TmMzWjh3dUZTelUrMWNrUEFwL2RaYzJzdmM0NThFS2J0?=
 =?utf-8?B?Uk5IOFM5STJWMmc3VlFMUTVTcVhMbThKQUNMUXM5bFltZjVUdmFVRC9nY3di?=
 =?utf-8?B?UVQzaUw5L2xnQ28zWUxncy94andzVGxhdEpNVHBMQnJENDBhamNKOGlzYTdl?=
 =?utf-8?B?MFRRSm5pdWFFUG5GQlRud3VvMExtcGQ3NFJkNHc3c2R2akIrRDMzY0ZWWVJj?=
 =?utf-8?B?QThvNzlBcHNwazdaUjFCOW9MTWFLVkJsdFYyWGFxdjJBcWZHUStncjA1SnBX?=
 =?utf-8?B?WkkzQXB3eVVLTWJCUFowTEFGRmZ2aTRNS1VoSEdIN0Y3VTNsT09CdU1rRDNC?=
 =?utf-8?B?YjdpUVVaOG8vQ0J6cHZENXB3am1kZW1xSTJCOUNpMTBxdVUvdUN0UXUyakty?=
 =?utf-8?B?SnZOa1V4b3F3N1RYUmpHMW9xYkJHZUsxNHpuekh3aE52eXlYejNwTlAxKzJa?=
 =?utf-8?B?SFZabzlRVEVMVVc3YTA1Q0w2MkdrWTNuVnlqUnNodFZjMzRheXFaeUF1MWZO?=
 =?utf-8?B?NkxNTi9FTzBwbUYyd1ZRZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmxlaUxwY25jYlBtMnZXaFJXcDJuWld1MGg4MmkrY1c5QVB5Ty8weGhDUmF1?=
 =?utf-8?B?K1lhemJQZ1hGV0tIRHRMcUdIWTFrMjBadEJqb2haWFZQQmJ6K3QzZVFYLzZK?=
 =?utf-8?B?ZmpEWC9vcUhMZGNicEtIMlhPSzVOZFJBbmg2MThGWnRLRkg1bEVjc2lPOElw?=
 =?utf-8?B?aWRORUVkTzV0SnZUK3ZsVnRnMEQ5N21HVWNZSFpzcG40dFdabVA1dTAxMExC?=
 =?utf-8?B?Z0VkSXF6c3pwTUgvOVZWaXUya0NHU0NWTDBtWTl5VXRaVkpFS0VXZ3RKWW04?=
 =?utf-8?B?Z0hSbVVuNzZma0taK2x2UG0vZWNzZ2hlcHBEVkk0MUgxcENPcWdpWVZmVTln?=
 =?utf-8?B?Zk5xd1djZGhheXpQRG15TzBtM1pPZnViQnh0aXB6NCt5a2lzaG9vRzU0ejlz?=
 =?utf-8?B?bmFpQU9WV3p5eU12TGVxYnh5MmJWVTZPb3pYRzgxZ2NDcnZQQWpRYUoxNXhH?=
 =?utf-8?B?eE5tY2NNaWV3N0lXTnIvTE9XekYxSXpXQTFPcWdPbmhXRDNSRkl6clRqdDVY?=
 =?utf-8?B?RkJrUFRIaVd6Y1VhbnFWVTJVMDh2Rmp4bktIU1Z6by81Z3FwZ0hyS2s5T2tL?=
 =?utf-8?B?Z0FjTUxmVmgyaEV3VnpINXF5b2prSlFNY0NiWVlycG52MUF1TlpZZGVBQ3JT?=
 =?utf-8?B?d0VqSFZwUk52clhxZGJLWmw3M2NZOEJOSys1S3ZqYndJMTU5ZzUwN0RqOUdn?=
 =?utf-8?B?NXduSzdXTHMwQ1FZTTNTREtIcFVrZHhIUVBVekJpYlpVOG8ycVFFdEhXYlkr?=
 =?utf-8?B?ZVdHeG9DRUsvQjdjbTdGaithcWQ2YVJhNmxtdWRBcVU1dmMzWVdPUTNqT2Rh?=
 =?utf-8?B?TTg2S0FiakJCRDQ3WFBIUUt0NzltT1FzaHNZMEsvYS9adnp1NS9lbFdXWkhY?=
 =?utf-8?B?TURQcXppc25PZmtvcytxQ1lyYUFHbXRSaFg3c3lCWkhEMCtvRksrZTVzeTU3?=
 =?utf-8?B?aStVQ1ExM2thR1pobHJ4aGVsSHp0Y2dZNlJxVWFRMFRlY3EvMUczVTFMRjM2?=
 =?utf-8?B?QVVXZVViVUprRCtlalVNL29xNit1eUNFRm9TdStxazRBVFNFRWgwcHJEOTFT?=
 =?utf-8?B?NDYvQnlBRkVEWHcwRmFYcW4rSk4rUEU0cjIxT28wS3FPei9iZWhzQ3kxaGpP?=
 =?utf-8?B?QVUvNzk1VDJWT0l1eWRqbW94ZDFJRG1IVzh2ZllVTllPMzJIbk9YeDVCdFpz?=
 =?utf-8?B?MkViVUdvNWZrVVpMRHNvMFpHVDFEam1vOG9ZOUM0eXhEcENXZnFnanMyZndN?=
 =?utf-8?B?Vnh6Nk5yVE1rU25wVWdrdVJtSS9GSDYvR09kdU9NbHpIK24vbENMMUMzSUlU?=
 =?utf-8?B?WlByeDR0M3F5VnpzK3Joc2x1VE8wWFJTaENMS1c5SnIwTDFWQzFyWFdIWWpo?=
 =?utf-8?B?ZUtnNDZqMSs2S1I0TWNqWHV6Vkw5Q1pWVlJrTTY4dCs4VmxHWW82S2V0TXFN?=
 =?utf-8?B?VWlSRHZjYjRhaTRKOXJadjdUdXhnd1ZOSWNLL2FZSHV2K240bElOek9JVFUy?=
 =?utf-8?B?V1ptbmdWSTZwcmR2UWtOUkhKcjgwNkhLM04zemNvUVJwZTJmT1p0NENMVnE1?=
 =?utf-8?B?ZjJjazBZUjFnOGNlbEdIRGV6TG1BbitMN0tSNVNMeGFpZWRhZGVqaC92OG1x?=
 =?utf-8?B?TDVUanltRlpXdGZYMkk2OUJlMmk3cnozVmRQN1RBMCtWOUlidDJMRU54d2VS?=
 =?utf-8?B?a0R0dCtlbHRBbUo1YmxHYVBrbkhkeVJLczN4SHcvRlFjWEJHdEVWNFd0WFNW?=
 =?utf-8?B?ME8wNnNaOURMb2Zld0FldFljZU5pYk5tNGtPL1YvNmd4cS9NMzVhcXovN3Nq?=
 =?utf-8?B?VGxFYWVJRHZpQjk1UGY2dCtKQzZyMStiL25qdDlhekllSWx0NDF6Sys1QUsv?=
 =?utf-8?B?QVp1Z3RWM0hiZTZjYXB5eEQ3amQyTVE1dFNjdGM2elVyaGlOM201QURkK3lP?=
 =?utf-8?B?L3RFYTdYemRoZGZtNXFUc0dDY0M0SDhzRUtJYS9XRzRQUm9TRHJwRnB4c1lX?=
 =?utf-8?B?Smg2SEE1UHBvR2RnTDhXMXpNWlRYekdqQXArUkU4ZkFJdEY4Zmo3SDZEVlRq?=
 =?utf-8?B?dnNaMUM1ZHlOTWduemQyLzhKWkd4YUNPSWtXMmtSYXViVUI4RzNNUzZOQlVW?=
 =?utf-8?Q?7ISOd2kG/LWRmKlGBki++841g?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zJHZ7WnFHDmG08mDFY1a5vCUMRd25jUbPzCJO/FOJURtqPyu+jKegTUDECdOct/a+pSoANVowZwMdF2H/f/h6gQ48yNB20nYRESbOwfBYNyIrUTEyS/rStb8ryhi5cUl5YK+L39NhxIQ+BCNwDbb/Q2pSklXpTk2Ye2hG6YkcBsiOCSsgQgJlmvGWNZGZ2KDhs5QxNXQ/5wmAcU9ZaJCe6uiwA9A4xkdUoeXoXLTxsnVTGlGW8DJhf3eO4mZTWLjUwsda1KlpwYxXUP10Mr1bE5VRB4FG8QsoFHYphlaRx0C7tt6qkiSS+rYDvEVyMN7nV1WtouEQbw6E719PtoC8ce9GxFqmw5Ta5XjcKL9HlwNvW8bQOqg81EZQyRCDPQ6hb9KRgENeUCTO2dfTD+uM49JutTocc2P7U5zW36FAGwbL4oWeBi4EortBkDYSROZ7UqOJJIDCMwFjjaLjoHNIU76fgqdYow0PJenq+PWrcuWdqy+vuW+KCCDvIQCCJh16B3uaFEQuPkvvyUB+LZHa4CgCq4vJ7qzX73lSebswd6dxQ8WUxXE0eHYUvqIkTYTqYo87VMwmg0Qk48QQRXr5QpO8HaJ4SQKoZ/cbJ9Zz2g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1216d04b-c719-43d5-e5fe-08dcd68ffe82
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 20:41:51.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRPdNFzPt/jHT6sueFcDWid9r0z+pTtehQYQmZ8U08z2s3HBdAQoZzD8owTDvy4ebZR8mD9E00JdyahZ9OkJ+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_14,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409160140
X-Proofpoint-GUID: XCh8wYBbcWEd_vphgny0w-H8jclGbOsQ
X-Proofpoint-ORIG-GUID: XCh8wYBbcWEd_vphgny0w-H8jclGbOsQ



On 9/16/24 11:54 AM, Maxim Levitsky wrote:
> Hi!
> 
> We recently saw a failure in one of the aws VM instances that causes the following error during the guest boot:
> 
>  0.480051] unchecked MSR access error: WRMSR to 0xc0000302 (tried to write 0x040000000000001f) at rIP: 0xffffffff96c093e2 (amd_pmu_cpu_reset.constprop.0+0x42/0x80)
> 
> 
> I investigated the issue and I see that the hypervisor does expose PerfmonV2, but not the LBRv2 support:
> 
> #  cpuid -1 -l 0x80000022 
> CPU:
>    Extended Performance Monitoring and Debugging (0x80000022):
>       AMD performance monitoring V2         = true
>       AMD LBR V2                            = false
>       AMD LBR stack & PMC freezing          = false
>       number of core perf ctrs              = 0x5 (5)
>       number of LBR stack entries           = 0x0 (0)
>       number of avail Northbridge perf ctrs = 0x0 (0)
>       number of available UMC PMCs          = 0x0 (0)
>       active UMCs bitmask                   = 0x0
> 
> I also verified that I can write 0x1f to 0xc0000302 but not 0x040000000000001f:
> 
> # wrmsr 0xc0000302 0x1f
> # wrmsr 0xc0000302 0x040000000000001f
> wrmsr: CPU 0 cannot set MSR 0xc0000302 to 0x040000000000001f
> #
> 
> The AMD's APM is not clear on what should happen if unsupported bits are attempted to be cleared
> using this MSR.
> 
> Also I noticed that amd_pmu_v2_handle_irq writes 0xffffffffffffffff to this msrs.
> It has the following code:
> 
> 
> 	WARN_ON(status > 0);
> 
> 	/* Clear overflow and freeze bits */
> 	amd_pmu_ack_global_status(~status);
> 
> 
> This implies that it is OK to set all bits in this MSR.
> 

To share my data point on QEMU+KVM: I am not able to reproduce with the most
recent QEMU (not AWS) + below patch.

[PATCH v2 2/4] i386/cpu: Add PerfMonV2 feature bit
https://lore.kernel.org/all/69905b486218f8287b9703d1a9001175d04c2f02.1723068946.git.babu.moger@amd.com/

Both my VM and KVM are 6.10.

vm# cpuid -1 -l 0x80000022
CPU:
   Extended Performance Monitoring and Debugging (0x80000022):
      AMD performance monitoring V2         = true
      AMD LBR V2                            = false
      AMD LBR stack & PMC freezing          = false
      number of core perf ctrs              = 0x6 (6)
      number of LBR stack entries           = 0x0 (0)
      number of avail Northbridge perf ctrs = 0x0 (0)
      number of available UMC PMCs          = 0x0 (0)
      active UMCs bitmask                   = 0x0


Both writes are passed.

vm# wrmsr 0xc0000302 0x1f
vm# wrmsr 0xc0000302 0x040000000000001f

Here is bcc output. Both writes are good.

kvm# /usr/share/bcc/tools/trace -t -C 'kvm_pmu_set_msr "%x", retval'
... ...
4.748614 19  43545   43550   CPU 0/KVM       kvm_pmu_set_msr  0
10.97396 19  43545   43550   CPU 0/KVM       kvm_pmu_set_msr  0

Dongli Zhang


