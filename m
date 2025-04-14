Return-Path: <kvm+bounces-43263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0644BA88A15
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 19:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41F763B5C57
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 17:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC53028BA9C;
	Mon, 14 Apr 2025 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nel4hWUS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BOMstMBj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71449289342;
	Mon, 14 Apr 2025 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744652468; cv=fail; b=AyCnhbiXuw0Yp6/uPw0ZBcvq99OdEY/or0032mW1S+msFaf7abVug2pTDxJlklfLFyMnM5tBrt6InbJO3TT8XrdOTMtaFPa6SGvb4yPnascWIJ80RiuOvrvFrNolcRlsA5lk0YpD4eWf1mY/LVZVQPjkZAkN7cETlpilqcSVQ3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744652468; c=relaxed/simple;
	bh=zBWFyWeb3D52myv1+41u9abYKw3DYzdEtCe8Gug/3HU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kS5FpOWPk8MiA1FqL1fna2If6qAt5oeH6WFCjR+/29m65JYOclh0xPmfogoQx3Dat2Vu34fZFmT4g80uhrdLOnZMv5RIzaSbUySd278a6BGGWflzkbx+HGe/wGezIPkDt3BJ8BWGvyiyW0TE94O18DdpbMP2MWYsaiJKIbNAj4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nel4hWUS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BOMstMBj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53EHHO2L011666;
	Mon, 14 Apr 2025 17:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=twvTjhFahYt/Bj0vzZT85afB3JN3REzO22d/+S1+MC4=; b=
	nel4hWUSu+xQ/j4LJaDNdEQEJXVYWSmWwCqxRG/ThD/CPcdZp0eeh40Y9VokrgvM
	6kPn5uiPgzAAxL8kZBOMr+/GpE3TFw5ozWPqssuMbHbcBJtrEMmsbMQ4/t/28M0w
	RMwCceFpn3Om6jF8uDp7d+hyoRZCXovuSwUasUGD1DWLm26EF3nowYt5o1l8IWaY
	bP9HfGzEUpfHIoim/HhZOvGJJQcJvX/WZcQ1QXDePu+vpzLE/OX8TcuN8SE+CtOo
	LpdbOKCJAyR+mtOfRBwHAFANggn6azo8zgdLIYRoSPKd3bNb3bwnSdWGejKxFz+Y
	pzA4ys02qFh4IAoybrp6SQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4616mf82c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 17:39:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53EHa73w009275;
	Mon, 14 Apr 2025 17:39:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d3gtxhf-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 17:39:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2wHyCA/+B7u1+4PecQtdQtPRe+0l/zlrS0f/Id2vv3q1YabNZhPtyNDvEJ/1vYnVIx5Z2I2fLPuvo3B0pvFxg3VRTTxLLeGSYUJymS5fj1ICjzHaxeasQ1aOlQ7pgea6Xg2w5Bmjjfz/d/y44LmcrnP3ldAdSIRM0fYo1LtPC5pJ9FCZqCowtbSjJ5Jh64rfu6KiR7F7uCP/Ll2mlGDz9wxQbcCqUZmYi37T1qXz9Z5E9li3RLNi0YcvsmUjKmJPkppFYq21zFaRR5nK1ZrVRI08748rTCTCbY/YVwVHLoYI6vF7+rIAx5h76PCnsDJ15XR2X6JjRWTJRxhvtTd2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twvTjhFahYt/Bj0vzZT85afB3JN3REzO22d/+S1+MC4=;
 b=STiL0dNkDnOMGIE19IFE3NVscW6EaW8H6sVpE71E8MfpjJb07/8GhYEbw1mHNhdrx0KsJYdbbFUPfx1sB+8wMm8DCCXuChFLSSaO4EkdgSazO2QClyde0B0fqiEslDBjA/XplYfs/u/lJT/6sGTau5B528S7Dkh5FRP1L5SbRc0Aboe5IPY5hsavlAxUvXkLgQgLK9iLxEWrE9SjLi8oJlIdCD+aShTKfNf3YdBLK1SbJQlZwSfrTkfH58gzEoC3jpbv4BXgZhBNxoKWSyQexa4NPfJkMMhRdR8y+XrVgkYIw3C178LEQiO7HRJnNpCMTQmxjW9xEroK7bySATcD/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twvTjhFahYt/Bj0vzZT85afB3JN3REzO22d/+S1+MC4=;
 b=BOMstMBjpzmetOw8FjNwG9Ej9ErDUnFfF8GXlhHd2WtaadLof+Ur+sYB/FPKMUVXLyJBRTCNdjthrWeR98ddEP57bbOu9YfGHi79eOVKagZuPWlLluZzZmPorDfl2K8RhhbkQqQbSJwkn2eVvGB/wMy9MoSxUZS209Wbdfg3I0E=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6837.namprd10.prod.outlook.com (2603:10b6:8:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Mon, 14 Apr
 2025 17:39:48 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%7]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 17:39:48 +0000
Message-ID: <18713073-342e-48b2-9864-24004445e234@oracle.com>
Date: Mon, 14 Apr 2025 13:39:37 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: alloc_pages_bulk: support both simple and
 full-featured API
To: Yunsheng Lin <linyunsheng@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yishai Hadas
 <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>, Jeff Layton <jlayton@kernel.org>,
        Neil Brown <neilb@suse.de>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu
 <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau
 <martin.lau@linux.dev>,
        Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20250414120819.3053967-1-linyunsheng@huawei.com>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20250414120819.3053967-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0042.namprd07.prod.outlook.com
 (2603:10b6:610:5b::16) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|DM4PR10MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: 68dfc740-0b6f-4f3f-e5d9-08dd7b7b5a45
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?K0wxNlkyVGlhdXh0dTJobWVINUdXbTRMR2VZSjZoU1hydHJNQU1ReW1PekR4?=
 =?utf-8?B?WDkyUkZLeXBZOHRHV0F4U3A5NEZlWDBsQ28rTERuT2hYMUVUdUliM2tqejRy?=
 =?utf-8?B?M0tPMzF0ekdwQVIwUi91YjlEbzV6YVVLQkJuS0ZtSWVYMzRxVXE3UG12NEhj?=
 =?utf-8?B?ZXlLcGJnRlZ5M3ZVY1NpTDhiTnpYUmxzb0VPYlZKYkREci9pOVBzZ0tWekdX?=
 =?utf-8?B?ZnF0V3IvMWd5T3R6ZGoyOHE0NE1IY01CbVl1eHk4QmluSjF3MzBWQnA4UDlV?=
 =?utf-8?B?REJBcWorZkZ3M3Nlano1YWRMVHd1RlBtMXJCUU50cVNYblFTTjRlSnBnNnJ5?=
 =?utf-8?B?dDhEaHk2NjVaUVJUYm5nNTdkYWEwdHJaY0tCMFNWOU9nb1lxdWtXQWhEZm04?=
 =?utf-8?B?eklzaXdlQkVrcDFNaGtTTHVOZm1PNHVyU3JBdkh0UElFQy8ra245Y1RqTjlW?=
 =?utf-8?B?aFZoTUpNMDF4WHExTmNLSnVOOU5rSWM0YWN2bFFuWEJqWE11K3FvcU9ha241?=
 =?utf-8?B?QzhSRXFxNUt4SmtVU1pFMmJvbkcrYkNzVXNoU01ZUDRqTmVhWlhmNi9RM3JU?=
 =?utf-8?B?bGs5QTM4T1M2d1ZIZ3IydEtvclJQUTBvSkJEVGVCbXpWL0NycXhSWE5PRDBN?=
 =?utf-8?B?bjV4bXNIa2xtWmU1b041K0JDMEIvTFg4a1YvSVVpUHliS084Q2ZRVUQ3cnU0?=
 =?utf-8?B?alovYkhCM1h1TGc3aElraDRNbUVpc0QySlFOWVpzbjlOWHBqdG84OXhmYTNz?=
 =?utf-8?B?dk1oblljcHZ3SjdZeXZuVUttZEMrRWRlZkljVUdadjYvM1dZdlphM2h6Q3VJ?=
 =?utf-8?B?b0pDa0c4NTB2dmE4dHpObmI5emZ2NVFWa0JsWS9zZVg2N3E2dDNsa2ZIV3NP?=
 =?utf-8?B?VUtvN0NTTkJrWmR5ZkduY3V3Y2wvamtFS0Zkbys4UHdQUFVFUXRQMGdWTmp6?=
 =?utf-8?B?NHROZklzNFgveFFrSDh6cGJuQUozbDd1eWZ3MkZKRE1WcmhZZnV4YWtSdlh2?=
 =?utf-8?B?VkMvMzMvVVRHSmlVOWVTWjBaYlIwUHJiWDFUcGZRaDhpLzhySUQzaGJTdTVG?=
 =?utf-8?B?aHhLRVEyTDR3RCthSm4wNUpkRERxRkQxbkxlc1Jyc3prREhjVWlXWFp0K2wy?=
 =?utf-8?B?OFRjazhqMStOSkF6RnFnYnVnSTZFMndaK2tRMEtxUUJMaW0yOThleU5qT3FC?=
 =?utf-8?B?UVBuWWZ3ZlpTVG53eEVEWmV3WTBOSE5kdlNsVnA1THRqWStqSDFJeklDR1Yy?=
 =?utf-8?B?QUFsUi9PblhzZXVmVjBvRlhvZ2ZNT01odjdzTHYwL0ZURE1IU29abUVjdHR6?=
 =?utf-8?B?bUl0Nm9qZVVWNVJMdSsrbzFJQWx0NlZwZEY1RlZBTjFNMVNkci9pS3FGc2Rx?=
 =?utf-8?B?dzF6K1JYeGVxSHA2WTBTSnBjS0Z6WUM0N3ZnRWdtcEQ0Sms4TDlHc2VwQjVO?=
 =?utf-8?B?bEJ2ckN3ZjZTaC8raTFQS0FRM1JlTFpCYi9rcEN3anZJUHFDeDFWaXBJS1lq?=
 =?utf-8?B?Mis4bGkvUDBMMUlkMlQ1UVl5eWNURmlVbWIrS0I5eHFuc3czS3psMS92SUZB?=
 =?utf-8?B?MWFtUCs0WW56RG5ib0VOYnhNck0xOXZqZnRwRFJHc2JNbUYxUkQwekIram9o?=
 =?utf-8?B?OXdmQ2lKblpBRVg3WEs1ZTEyQUJuRGZxTk1jZkhXZVA5bS9LVEhKc1JpbWxm?=
 =?utf-8?B?elNIclowTC9BdEJlWUZ5Uk5ZTSt2RkpkdS9nS1J2a0hLelpSRzhwNEJwU25h?=
 =?utf-8?B?SzZwOS9kd0RWUllmY0NYdll4SzVmV0E0SWVsQWp0R0w3L1FqOGxhamEyQ2pT?=
 =?utf-8?B?VlllczRjR0Fhc0VSODczZUxvZTZBblNwVUpBRzc0aWZsRUV6V2Zucm9FRGdJ?=
 =?utf-8?B?N3hwWFpvZVowY3p2d2lpRFNlNkVLUlBXaDlBUUtuWXpGclF1UXJBWE1QTHNv?=
 =?utf-8?B?YWkvWCtyRXY2YmxSa1ZlY1VzZHJRNmdsVlpEbEFoQ1VaQ0xUQWlITHV0azF5?=
 =?utf-8?B?RE9mU2NTMWNnPT0=?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?MzNZb2lRbm9CZU1ra0F3NXpvREcxdG9uU3oxdWtYY2hLaktmYi9nMkVGcnI5?=
 =?utf-8?B?ajR1SEVMOGVXdkVuWnNqTmhTL1VQS3E0SXo2RzJYRHBrTFhYVUxPRmg1cDNk?=
 =?utf-8?B?UFdBU0xCN0tsOUhVU3R6VTVka2RsM3VvWTZjblNicDJCYXFTZE4wRHh2WG5T?=
 =?utf-8?B?QW1UUXVkY1F0UDhwTE02Z2ZGVXZTLzkrb2VzV1BTZ2dUckFyMUtKbHVRYS9S?=
 =?utf-8?B?TDF6VG5wOGovUjJvNG9OeGljR21qdXBkcERWanp4Q3FiNTIvbHVCNTVKTzVD?=
 =?utf-8?B?bHVxTkFTdXl6M1Z3bndCN2JtQmRUTmdrZHEyMjd0aEZpZTNSTW52V3VLRTJN?=
 =?utf-8?B?QVZGS3JscXNJSWExTFNicTVWcW1aQmhtZkE1WWhNZnV4dmpCNnI0eWdmb3ZL?=
 =?utf-8?B?R0JJS1dCc2ZyRDYwMjZuZVNvanVWWGRNU2x4cW5idnFkcUUzOUsvWHQ3WUh1?=
 =?utf-8?B?TnZ1Y00xV05wS0x6ckU2TmhxS1JXbm9nTnhDUXBrZmFVdG9Sc0Zla2N0UWN6?=
 =?utf-8?B?UVNKaEp3eitOcFVSa3UwcFNhVjhCazQyM0diQUZmb2hhS0hqZ0ZnNTNMYXFt?=
 =?utf-8?B?cDk4NU5RYWxrMVBGNUx1L2twYlFwRWtQWnRwUU5RbndaVEI3TnV4TElWTG5L?=
 =?utf-8?B?Zi9vMTRSa2Vtakl1UU8xc09sQ3FQMy9XZ294aU1HeFJ5diswV05YbWpBeDlj?=
 =?utf-8?B?NVFZV2Z5U0dFeDZwRGdISHZ3RUZlTWU4emRnUGFHMS9JV0JaMWJld2JCd1Mx?=
 =?utf-8?B?R3N2dmE1Y0ZKeUJ4K01lMzNsWFNLTU0wbnkvYjlic3UwdVVkMkU1bnRQbXZF?=
 =?utf-8?B?aUliVllXeUQ0SE0rMy9XUjlPcEtRMldORFBocWQ0K2Y1Z3E0K1htY0VhOTZj?=
 =?utf-8?B?cFJpV1RMQ3VWSk1jS1ZSTzQ2bnV6OVdBNTJKNTVEY3BWNkFqY0RtRlZrZXYv?=
 =?utf-8?B?Q2xEVHhkbXdmMDFaMTlDZnJVekZMN1ZoR2VyV0pIR2hldFNLb1FhZSt3ZGZs?=
 =?utf-8?B?YUpTNjMzYXh1Z0xQRUdBcWpHaXdaUjZoL2NaZWlQVEJBWHZTOS8xMk4vT0hX?=
 =?utf-8?B?cG1saHU4N2dqSEQrbmVjbXd2bkM2QWFkMkg2dTAwRm9pWm1rNGFjMTNVRHZ4?=
 =?utf-8?B?cFh2V0tRd0VWbG1yYUVaUUpCdmpaa1pvSHluM25tVDJkSEpyN253WlZReTI0?=
 =?utf-8?B?a3pnMVNNSGplM3d3cVBBaGJpQTJvK2VjejI3a0dZZWdpSjNneUdvZDQ4UG90?=
 =?utf-8?B?REE1bHdhVUJmQlVpQWMxUWplai9HeUhnb0E3R2dtNDF3TCtlQmtIQ3NQWDZY?=
 =?utf-8?B?SnpFS0ZkdzQ1aEZOclUyOXQzekJBaWtjQVVVamZEdEJ3RWdjQjF4MER4Q3hW?=
 =?utf-8?B?c3dWbVVzNzlhcU1nNWNFR0VvbHpUcVEvRnRGTkdwUFc2aG05Z0xEcVVUNmhq?=
 =?utf-8?B?bWU0aHNGT25maTZKMkRNYlNJSlBoQmRvU1F5aDkrS0tQOUlxcXZ2dkNnTU9t?=
 =?utf-8?B?RWMybmpEb2JINEdic2RMTU5UUTZDYUY5Qm11eU9FbUJ4Slg3aDcvR3hMMVlN?=
 =?utf-8?B?dlY4N3diN1NBbzM4cGFZUjFRK1ovRFdFcDhwMnpjdi9FOEJuSGkxL3hGOFJL?=
 =?utf-8?B?Z2lHUlJJMERzSDJnS3laNUF3TDRra2VpQlVueW5hb3RPdDQ4UUJMaHhKZEcr?=
 =?utf-8?B?cU03NW11WXI0eUk5Rk50SzdmdFV0RHk0MHZVMnZMQ0hnWU5sbTVNbGI2UHRW?=
 =?utf-8?B?REF2dG8yNVRGOTFGM2xKMEk3Q25MaEJMZUMraWI5dm9mQWN4ZmlieWVobis5?=
 =?utf-8?B?UW5jVHNsZ3Uvbm1FWVFteG4wdk9kclhxTXBZSDQ0U1VnL0QraDdET0pmb29O?=
 =?utf-8?B?VVpud0dNYW1NRkZsd3A4Q2hEanJNWlJLcStWRU55UVE1V1gxdFUyMHBtQmFs?=
 =?utf-8?B?YVJiOG9lNDRicUVhUjBhY0F6YnVZL3p1WlFRZ3UwaW5aWis2M0NGREpWeXI5?=
 =?utf-8?B?RDVtV0RrallJUWtsWGFYSDNnWWRWTFQ4bDArZ0FTcTBVTXJZdmlkMjc4NnMr?=
 =?utf-8?B?WFcyM1hQcFF5M0ZlcysvdGFWN0hveWFQRzA5REdSUVduVXNiN1hGTlNyNm45?=
 =?utf-8?B?R2RZbGpOcU9MOEwzRHRVUXQzb1pQeEFuZmdIOHNYb1J0OGhwUW9nMi9XemR0?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i3MnWikRG12s02G4TAkfV4sVof+iJejWPlosUfTjXjI8vV1jWQFyVB3NGAzsM47bx9Kn42jVVnxTARbGBSGa+Prl1926te7aNFMyLDNweSfGdJXnBQqsfL2CWVM0yp50bYE/5iCQ/IHK4YwFrmj2gxX3HzNKFBWOy9DTL9Lw5OLnCvkTrt6NDsTxvbkpYaUZw3ls2qWzZpE4csflqRldGKZUFRoREDoK3PdID5Fv7dO747L7SPF+qLUxooy/fSUHoXzNlazCBH+ZMAY5aXfyMYmDEa+H06Y6tgHIvnUdHAJX/Xz7MM2VfkJa9gP0Z1/rwR/KrCThAWZamSpNU/mLgjVlrwWZqy8jWlTEnXcPr3lnRlL/BtnfwpGjsgzK6LQebmCyLcCaZfUZFngQhACn+0lEBQDaKLytegbn+6gnzbX9PFufzZfIQG5kVKDBDxOfhzmwexoQSpGsM5nJhOYS5YOzQXVwLXn4mSl1SBgXvKUNut/x2bJo8DH9WCWhAIUPTgFA/cthkff3F+PNJlHz9wZzGbLuC9AM4d2lLE9DnYAT2CGhU/zVo5Ffop0VtpQWlOp6x7zrsRrKxkGydft0Koo+aMupkCjeLp8QFt6aeVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68dfc740-0b6f-4f3f-e5d9-08dd7b7b5a45
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 17:39:48.3556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KldcPxEnlftYzdJ4zHBTYoi2p32hP6mQ812N4twiMjJDXU7IOuzRaf1LvWHSiWn6U75O8y7YzCmZRtNkhzteSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6837
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_06,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504140128
X-Proofpoint-GUID: ka1G80Hla1V6DvHCRvbXKQeHrC9Pm626
X-Proofpoint-ORIG-GUID: ka1G80Hla1V6DvHCRvbXKQeHrC9Pm626

On 4/14/25 8:08 AM, Yunsheng Lin wrote:
> As mentioned in [1], it seems odd to check NULL elements in
> the middle of page bulk allocating, and it seems caller can
> do a better job of bulk allocating pages into a whole array
> sequentially without checking NULL elements first before
> doing the page bulk allocation for most of existing users
> by passing 'page_array + allocated' and 'nr_pages - allocated'
> when calling subsequent page bulk alloc API so that NULL
> checking can be avoided, see the pattern in mm/mempolicy.c.
> 
> Through analyzing of existing bulk allocation API users, it
> seems only the fs users are depending on the assumption of
> populating only NULL elements, see:
> commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")
> commit d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
> commit f6e70aab9dfe ("SUNRPC: refresh rq_pages using a bulk page allocator")
> commit 88e4d41a264d ("SUNRPC: Use __alloc_bulk_pages() in svc_init_buffer()")
> 
> The current API adds a mental burden for most users. For most
> users, their code would be much cleaner if the interface accepts
> an uninitialised array with length, and were told how many pages
> had been stored in that array, so support one simple and one
> full-featured to meet the above different use cases as below:
> - alloc_pages_bulk() would be given an uninitialised array of page
>   pointers and a required count and would return the number of
>   pages that were allocated.
> - alloc_pages_bulk_refill() would be given an initialised array
>   of page pointers some of which might be NULL. It would attempt
>   to allocate pages for the non-NULL pointers, return 0 if all
>   pages are allocated, -EAGAIN if at least one page allocated,
>   ok to try again immediately or -ENOMEM if don't bother trying
>   again soon, which provides a more consistent semantics than the
>   current API as mentioned in [2], at the cost of the pages might
>   be getting re-ordered to make the implementation simpler.
> 
> Change the existing fs users to use the full-featured API, except
> for the one for svc_init_buffer() in net/sunrpc/svc.c. Other
> existing callers can use the simple API as they seems to be passing
> all NULL elements via memset, kzalloc, etc, only remove unnecessary
> memset for existing users calling the simple API in this patch.
> 
> The test result for xfstests full test:
> Before this patch:
> btrfs/default: 1061 tests, 3 failures, 290 skipped, 13152 seconds
>   Failures: btrfs/012 btrfs/226
>   Flaky: generic/301: 60% (3/5)
> Totals: 1073 tests, 290 skipped, 13 failures, 0 errors, 12540s
> 
> nfs/loopback: 530 tests, 3 failures, 392 skipped, 3942 seconds
>   Failures: generic/464 generic/551
>   Flaky: generic/650: 40% (2/5)
> Totals: 542 tests, 392 skipped, 12 failures, 0 errors, 3799s
> 
> After this patch:
> btrfs/default: 1061 tests, 2 failures, 290 skipped, 13446 seconds
>   Failures: btrfs/012 btrfs/226
> Totals: 1069 tests, 290 skipped, 10 failures, 0 errors, 12853s
> 
> nfs/loopback: 530 tests, 3 failures, 392 skipped, 4103 seconds
>   Failures: generic/464 generic/551
>   Flaky: generic/650: 60% (3/5)
> Totals: 542 tests, 392 skipped, 13 failures, 0 errors, 3933s

Hi -

The "after" run for NFS took longer, and not by a little bit. Can you
explain the difference?

You can expunge the flakey test (generic/650) to help make the results
more directly comparable. 650 is a CPU hot-plugging test.


> The stress test also suggest there is no regression for the erofs
> too.
> 
> Using the simple API also enable the caller to not zero the array
> before calling the page bulk allocating API, which has about 1~2 ns
> performance improvement for time_bench_page_pool03_slow() test case
> of page_pool in a x86 vm system, this reduces some performance impact
> of fixing the DMA API misuse problem in [3], performance improves
> from 87.886 ns to 86.429 ns.
> 
> Also a temporary patch to enable the using of full-featured API in
> page_pool suggests that the new full-featured API doesn't seem to have
> noticeable performance impact for the existing users, like SUNRPC, btrfs
> and erofs.
> 
> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
> 2. https://lore.kernel.org/all/180818a1-b906-4a0b-89d3-34cb71cc26c9@huawei.com/
> 3. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
> CC: Jesper Dangaard Brouer <hawk@kernel.org>
> CC: Luiz Capitulino <luizcap@redhat.com>
> CC: Mel Gorman <mgorman@techsingularity.net>
> Suggested-by: Neil Brown <neilb@suse.de>
> Acked-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V3:
> 1. Provide both simple and full-featured API as suggested by NeilBrown.
> 2. Do the fs testing as suggested in V2.
> 
> V2:
> 1. Drop RFC tag.
> 2. Fix a compile error for xfs.
> 3. Defragmemt the page_array for SUNRPC and btrfs.
> ---
>  drivers/vfio/pci/mlx5/cmd.c       |  2 --
>  drivers/vfio/pci/virtio/migrate.c |  2 --
>  fs/btrfs/extent_io.c              | 21 +++++++++---------
>  fs/erofs/zutil.c                  | 11 +++++----
>  include/linux/gfp.h               | 37 +++++++++++++++++++++++++++++++
>  include/trace/events/sunrpc.h     | 12 +++++-----
>  kernel/bpf/arena.c                |  1 -
>  mm/page_alloc.c                   | 32 +++++---------------------
>  net/core/page_pool.c              |  3 ---
>  net/sunrpc/svc_xprt.c             | 12 ++++++----
>  10 files changed, 72 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 11eda6b207f1..fb094527715f 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -446,8 +446,6 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
>  		if (ret)
>  			goto err_append;
>  		buf->allocated_length += filled * PAGE_SIZE;
> -		/* clean input for another bulk allocation */
> -		memset(page_list, 0, filled * sizeof(*page_list));
>  		to_fill = min_t(unsigned int, to_alloc,
>  				PAGE_SIZE / sizeof(*page_list));
>  	} while (to_alloc > 0);
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af9..9f003a237dec 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -91,8 +91,6 @@ static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
>  		if (ret)
>  			goto err_append;
>  		buf->allocated_length += filled * PAGE_SIZE;
> -		/* clean input for another bulk allocation */
> -		memset(page_list, 0, filled * sizeof(*page_list));
>  		to_fill = min_t(unsigned int, to_alloc,
>  				PAGE_SIZE / sizeof(*page_list));
>  	} while (to_alloc > 0);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 197f5e51c474..51ef15703900 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -623,21 +623,22 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
>  			   bool nofail)
>  {
>  	const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
> -	unsigned int allocated;
> -
> -	for (allocated = 0; allocated < nr_pages;) {
> -		unsigned int last = allocated;
> +	int ret;
>  
> -		allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
> -		if (unlikely(allocated == last)) {
> +	do {
> +		ret = alloc_pages_bulk_refill(gfp, nr_pages, page_array);
> +		if (unlikely(ret == -ENOMEM)) {
>  			/* No progress, fail and do cleanup. */
> -			for (int i = 0; i < allocated; i++) {
> -				__free_page(page_array[i]);
> -				page_array[i] = NULL;
> +			for (int i = 0; i < nr_pages; i++) {
> +				if (page_array[i]) {
> +					__free_page(page_array[i]);
> +					page_array[i] = NULL;
> +				}
>  			}
>  			return -ENOMEM;
>  		}
> -	}
> +	} while (ret == -EAGAIN);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
> index 55ff2ab5128e..6ce11a8a261c 100644
> --- a/fs/erofs/zutil.c
> +++ b/fs/erofs/zutil.c
> @@ -68,7 +68,7 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
>  	struct page **tmp_pages = NULL;
>  	struct z_erofs_gbuf *gbuf;
>  	void *ptr, *old_ptr;
> -	int last, i, j;
> +	int ret, i, j;
>  
>  	mutex_lock(&gbuf_resize_mutex);
>  	/* avoid shrinking gbufs, since no idea how many fses rely on */
> @@ -86,12 +86,11 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
>  		for (j = 0; j < gbuf->nrpages; ++j)
>  			tmp_pages[j] = gbuf->pages[j];
>  		do {
> -			last = j;
> -			j = alloc_pages_bulk(GFP_KERNEL, nrpages,
> -					     tmp_pages);
> -			if (last == j)
> +			ret = alloc_pages_bulk_refill(GFP_KERNEL, nrpages,
> +						      tmp_pages);
> +			if (ret == -ENOMEM)
>  				goto out;
> -		} while (j != nrpages);
> +		} while (ret == -EAGAIN);
>  
>  		ptr = vmap(tmp_pages, nrpages, VM_MAP, PAGE_KERNEL);
>  		if (!ptr)
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index c9fa6309c903..cf6100981fd6 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -244,6 +244,43 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>  #define alloc_pages_bulk(_gfp, _nr_pages, _page_array)		\
>  	__alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, _page_array)
>  
> +/*
> + * alloc_pages_bulk_refill_noprof - Refill order-0 pages to an array
> + * @gfp: GFP flags for the allocation when refilling
> + * @nr_pages: The size of refilling array
> + * @page_array: The array to refill order-0 pages
> + *
> + * Note that only NULL elements are populated with pages and the pages might
> + * get re-ordered.
> + *
> + * Return 0 if all pages are refilled, -EAGAIN if at least one page is refilled,
> + * ok to try again immediately or -ENOMEM if no page is refilled and don't
> + * bother trying again soon.
> + */
> +static inline int alloc_pages_bulk_refill_noprof(gfp_t gfp, int nr_pages,
> +						 struct page **page_array)
> +{
> +	int allocated = 0, i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		if (page_array[i]) {
> +			swap(page_array[allocated], page_array[i]);
> +			allocated++;
> +		}
> +	}
> +
> +	i = alloc_pages_bulk_noprof(gfp, numa_mem_id(), NULL,
> +				    nr_pages - allocated,
> +				    page_array + allocated);
> +	if (likely(allocated + i == nr_pages))
> +		return 0;
> +
> +	return i ? -EAGAIN : -ENOMEM;
> +}
> +
> +#define alloc_pages_bulk_refill(...)				\
> +	alloc_hooks(alloc_pages_bulk_refill_noprof(__VA_ARGS__))
> +
>  static inline unsigned long
>  alloc_pages_bulk_node_noprof(gfp_t gfp, int nid, unsigned long nr_pages,
>  				   struct page **page_array)
> diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
> index 5d331383047b..cb8899f1cbdc 100644
> --- a/include/trace/events/sunrpc.h
> +++ b/include/trace/events/sunrpc.h
> @@ -2143,23 +2143,23 @@ TRACE_EVENT(svc_wake_up,
>  TRACE_EVENT(svc_alloc_arg_err,
>  	TP_PROTO(
>  		unsigned int requested,
> -		unsigned int allocated
> +		int ret
>  	),
>  
> -	TP_ARGS(requested, allocated),
> +	TP_ARGS(requested, ret),
>  
>  	TP_STRUCT__entry(
>  		__field(unsigned int, requested)
> -		__field(unsigned int, allocated)
> +		__field(int, ret)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->requested = requested;
> -		__entry->allocated = allocated;
> +		__entry->ret = ret;
>  	),
>  
> -	TP_printk("requested=%u allocated=%u",
> -		__entry->requested, __entry->allocated)
> +	TP_printk("requested=%u ret=%d",
> +		__entry->requested, __entry->ret)
>  );
>  
>  DECLARE_EVENT_CLASS(svc_deferred_event,
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 0d56cea71602..9022c4440814 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -445,7 +445,6 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
>  			return 0;
>  	}
>  
> -	/* zeroing is needed, since alloc_pages_bulk() only fills in non-zero entries */
>  	pages = kvcalloc(page_cnt, sizeof(struct page *), GFP_KERNEL);
>  	if (!pages)
>  		return 0;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d7cfcfa2b077..59a4fe23e62a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4784,9 +4784,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>   * This is a batched version of the page allocator that attempts to
>   * allocate nr_pages quickly. Pages are added to the page_array.
>   *
> - * Note that only NULL elements are populated with pages and nr_pages
> - * is the maximum number of pages that will be stored in the array.
> - *
>   * Returns the number of pages in the array.
>   */
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> @@ -4802,29 +4799,18 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	struct alloc_context ac;
>  	gfp_t alloc_gfp;
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	int nr_populated = 0, nr_account = 0;
> -
> -	/*
> -	 * Skip populated array elements to determine if any pages need
> -	 * to be allocated before disabling IRQs.
> -	 */
> -	while (nr_populated < nr_pages && page_array[nr_populated])
> -		nr_populated++;
> +	int nr_populated = 0;
>  
>  	/* No pages requested? */
>  	if (unlikely(nr_pages <= 0))
>  		goto out;
>  
> -	/* Already populated array? */
> -	if (unlikely(nr_pages - nr_populated == 0))
> -		goto out;
> -
>  	/* Bulk allocator does not support memcg accounting. */
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT))
>  		goto failed;
>  
>  	/* Use the single page allocator for one page. */
> -	if (nr_pages - nr_populated == 1)
> +	if (nr_pages == 1)
>  		goto failed;
>  
>  #ifdef CONFIG_PAGE_OWNER
> @@ -4896,24 +4882,16 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	/* Attempt the batch allocation */
>  	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
>  	while (nr_populated < nr_pages) {
> -
> -		/* Skip existing pages */
> -		if (page_array[nr_populated]) {
> -			nr_populated++;
> -			continue;
> -		}
> -
>  		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
>  								pcp, pcp_list);
>  		if (unlikely(!page)) {
>  			/* Try and allocate at least one page */
> -			if (!nr_account) {
> +			if (!nr_populated) {
>  				pcp_spin_unlock(pcp);
>  				goto failed_irq;
>  			}
>  			break;
>  		}
> -		nr_account++;
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		set_page_refcounted(page);
> @@ -4923,8 +4901,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	pcp_spin_unlock(pcp);
>  	pcp_trylock_finish(UP_flags);
>  
> -	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
> -	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
> +	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_populated);
> +	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_populated);
>  
>  out:
>  	return nr_populated;
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 7745ad924ae2..2431d2f6d610 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -541,9 +541,6 @@ static noinline netmem_ref __page_pool_alloc_pages_slow(struct page_pool *pool,
>  	if (unlikely(pool->alloc.count > 0))
>  		return pool->alloc.cache[--pool->alloc.count];
>  
> -	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk */
> -	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> -
>  	nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
>  					 (struct page **)pool->alloc.cache);
>  	if (unlikely(!nr_pages))
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index ae25405d8bd2..1191686fc0af 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -653,7 +653,8 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>  {
>  	struct svc_serv *serv = rqstp->rq_server;
>  	struct xdr_buf *arg = &rqstp->rq_arg;
> -	unsigned long pages, filled, ret;
> +	unsigned long pages;
> +	int ret;
>  
>  	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
>  	if (pages > RPCSVC_MAXPAGES) {
> @@ -663,9 +664,12 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>  		pages = RPCSVC_MAXPAGES;
>  	}
>  
> -	for (filled = 0; filled < pages; filled = ret) {
> -		ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
> -		if (ret > filled)
> +	while (true) {
> +		ret = alloc_pages_bulk_refill(GFP_KERNEL, pages, rqstp->rq_pages);
> +		if (!ret)
> +			break;
> +
> +		if (ret == -EAGAIN)
>  			/* Made progress, don't sleep yet */
>  			continue;
>  


-- 
Chuck Lever

