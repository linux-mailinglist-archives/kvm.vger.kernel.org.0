Return-Path: <kvm+bounces-828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F6867E32AC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 02:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F353C1C20A0A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 01:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EDD20E7;
	Tue,  7 Nov 2023 01:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fHVChFJj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u67HN2Aq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1790186E
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:45:52 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480751BF;
	Mon,  6 Nov 2023 17:45:50 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6MJ1te022015;
	Tue, 7 Nov 2023 01:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=agTvBHR02OeyygRZgLboqrzt5YRrjSlw0lxXJ2iVB60=;
 b=fHVChFJjqsDU9jgUT78oLXeVn82moyk5/qiGg+53VnHOZ19uDfQlp1fXMliOvBzfnizA
 DzemhQVJyJS50qrH0IALWSCEuzvaGYW9ww4JdFCuoO1MAhCEysVLPOe1RsFdpNnIJTSh
 nxz9gpZnEndWWTtQGSb4/H+BSKLgz2SquqEjcgi+zvDONh0HjKuL5RJzvI4dnZpffRtB
 TO/KXvlFuBN4CMb+LPcSXZLlPLnCPJpyjFvYfCN0LMzak+UYInC9zxEffrVw79z7eVcE
 lAMuDA0Kx1C7IyyZWx5v3uuWh/45BJLRQnw3EL3VhUVacAEac8Q/Ip9IkaIDJyawhRaf jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dvux0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Nov 2023 01:45:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6NskFb026788;
	Tue, 7 Nov 2023 01:44:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd62a6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Nov 2023 01:44:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgM6ZTq058oJTLvchLcwpwJQwaS1wG81tV4viBPwdj7xoVUGSOXpOGndWvfdGRpzpatpBlqajAcxH5uNH+fuhtDRrp7e6TIoAEZwaSV7pJa1+iBToE6cNLvBrJDsgmKbpG5uWjbJ6kb0fQd0qwpG+8+Xt4fnF4tf7dOqMtyeLcbczfuhKBe//ZZgmqFNpT6i2su2Q3l18FqB0+KTLX+FBdoTTqRhZIcIsRD1NNGR5ai8VtlmiJ8dFHaXbD5m66TXkw95CSg3LBMxToyv6yQ/XJ7lsGDkRW4gdWx+yoVX7qH89jr0kTkdAW+YnBQIzZfwZgTiJx1U+FiP7uyyclZbuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agTvBHR02OeyygRZgLboqrzt5YRrjSlw0lxXJ2iVB60=;
 b=HdTXgGO0hkIk5wdmjwkyTM85RbyyyHM9ItIRlIETYzasa+u3baWpEwAvgchqtXxnVY4IcwbTkni7KBw8G5KvXmSYKZP6IGmDTLfwEZB7O4G45B41qmp8Amc0yhV4XlpUicmlPSkBgrhDVtWKwCqT6gpke4nnTvwqZq5iyHo7it31wVe//FTSnZaWUM9gAosy1MEXjr4yyNo64qYWV2aD1rS4n9ZPQ/64vwb7Idj1b3WygTDRhoH6/wDO8WTNRf31PqMoPOnIfdQ0ZKNo3nyIxnptqB9fWzJ4haj4nYXIMztQ1A33HMI5UH+iEOqHcN7mUdYke27QcCOA8xBw4joqyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agTvBHR02OeyygRZgLboqrzt5YRrjSlw0lxXJ2iVB60=;
 b=u67HN2AqupUezbp+inUb6kiWQo1Ks0uhL0PVPovEZZSatSIk3dTUQyAW3C3QQwwi5f9dStX5U9/6HF8sJ3ygRxObm1Hpfe+tKbmaZp1k2qGN/j8+6hK7UcYQk9sORRHsEgxlACU5l7PjnMN192lqkCU4eA2k88yleJWLrvZwMfU=
Received: from BN7PR10MB2659.namprd10.prod.outlook.com (2603:10b6:406:c5::18)
 by CH2PR10MB4293.namprd10.prod.outlook.com (2603:10b6:610:7f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 01:44:54 +0000
Received: from BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::2ee7:8dce:dd6f:4b5]) by BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::2ee7:8dce:dd6f:4b5%7]) with mapi id 15.20.6954.029; Tue, 7 Nov 2023
 01:44:54 +0000
Message-ID: <2bd5d543-08a0-a0f6-0f59-b8724a2d8d75@oracle.com>
Date: Mon, 6 Nov 2023 17:44:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: x86/xen: improve accuracy of Xen timers
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
 <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:334::15) To BN7PR10MB2659.namprd10.prod.outlook.com
 (2603:10b6:406:c5::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR10MB2659:EE_|CH2PR10MB4293:EE_
X-MS-Office365-Filtering-Correlation-Id: 174b6b13-d1df-4034-bb4c-08dbdf3323f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	HWJFNFUZ2M1S6sL9tT89k3lo6EmX3hCHO/WEaURJnf8T78/f24pGxw+u5UiFbofdvY5sbh4W0LHJ4RH/RCJaRqxM+5ty8rCxIWcmzbR4drEt4h0Nmw88VplyF4An5+tWQXHB6qlDIBtrfQ78JEHnGHFK3O/Cd5COIRzOjSMSqy+EHxWi/SJhoXEVjg/9f57wYY3J97sqXyTjLAew1q5woG1/93+/Y5zhMbd4V8NG14RZDKrlJgjVTYKj1FVH5/oRq/kQmbiRuUSsopmNFNJ1gCszEnozPRua3LiMMi++pKQwjahfV+N5saQvodPT6mM5DOWXIZrdKqc63KHKAAu5f7nJoC7nUevoi2ZFsN0gwppsRyZFgu9CCPaj8u/Q28uACiOr5qs7ST95L9OvzVPba8bV3yYHTc6iaVwCjtRhQM7SmfyJHFzA912reK8+ucyhY1fy4k3XUrp1Eonk10toyAAdJKfckPwV706CjkHtH/1luIdneJcR3bXIX2GRFO2xeg3osZE6e5loXwINGaXGoUclfmpl8wICktj3U3BI+R3w0MN1HeIzJN5dZ7dWFlXzkd6V4lDpUUDYKybiwp0lQkYc432fV10/gawF2OB6sHsAa4IPQ4+g7aw4Pkon83G/OLvL6NWeIzPACBBdiCy7Iw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2659.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(396003)(346002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(31686004)(6486002)(66556008)(6506007)(6512007)(6666004)(53546011)(478600001)(66946007)(66476007)(36756003)(31696002)(86362001)(26005)(38100700002)(2616005)(83380400001)(8676002)(30864003)(2906002)(7416002)(5660300002)(54906003)(41300700001)(316002)(4326008)(966005)(8936002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YUFKTGpwdGRqTHJoenljQWkvS2dvRSs0U1FJMCtQSVNodk1nVE42ZGJLc3NT?=
 =?utf-8?B?dEY1VVpIWnM2LzVuejNTK0RUQVcwQUVjTVdKOUdGYjNQcFk2S3RXcHRqclR3?=
 =?utf-8?B?S0tJVHdSZy9JbytrMzIzQ3MvNHVhckhsNFhPeXFBazUxaWJWT3Z1RC9yMUs3?=
 =?utf-8?B?a3JJcU1Ua1BVcW45VU9VRUwweHBuell1QXhzaW54Q0xPalpPaVFWRkJSblVF?=
 =?utf-8?B?Rm5zNnhBQWxCbkZ6djVaaWdsUzFUT0t3L2tXb0JUMzBHU2F1bjJTSjZyRVVi?=
 =?utf-8?B?Y0E0VlBMUjdoeWh5TmV0RW0xbGRhbTMxUllrZDh0TUx1WnVDNVNCbTZhajBx?=
 =?utf-8?B?VERTdklPd0drK2ljdkhvYi85ajhsTEFZTjZxUHMxUVNScVRzUDNCTUMzN3ZN?=
 =?utf-8?B?MkRZMTFzd3hZalZoYVFNTzFiZWxHSmJJOHpNZTQrSVZ1YU45ZnhYWGY5OXBs?=
 =?utf-8?B?T202Y2J1VXcyRGlNOHIrTkZDaVlxek5xVU9jTlhDVklkS0VXM1gzVDJPTksx?=
 =?utf-8?B?VExIY2lYcXFlWEkvQ0ppRkhuc2VpUDlsTktRN0NnZ281dmZaaFY4YUtXUVJW?=
 =?utf-8?B?Z0k3L0JxL3dCTlF4cEFock9ySVNBRFFlby92U2w1U1lZcUU3Z3VJd2NZSHgr?=
 =?utf-8?B?M2xYODZ5SWNOak1XK1NQcGRQM1BrNEhsVk9xb1p0akxoTGl0bkNRMktLR2JL?=
 =?utf-8?B?OVBha0Rvdk1VV1NXL2l0L0xQeEhaTXJLR2p1ZFpMTUxIbFAzYVVUbmZmUEEz?=
 =?utf-8?B?cHpPeTh6OFFBTjlNTi9JbXZWaE9QZnNzUVZDZGtTQTE1RW8vRmhwWEdyREdV?=
 =?utf-8?B?dVVicE5RZnIxZno5N25tZ2pmMG5WVnhWSTR6bVpnM0dOYjdPUTZDYzBoTm9O?=
 =?utf-8?B?YlFnWkRnK1dYQUFLY0czbVcySmIveWZuNFlXbElWcWQrNW5UN3dHODdqY2Fx?=
 =?utf-8?B?ZDg5ME10eVdhcVIrYTRrd2VwUUZzdk5aOE1XZThtNnJFNEpscWdKN2xJemdy?=
 =?utf-8?B?Vk5iT2s3d1RuVU56eWYzcE1qdzZtcDlYQzIrVXVjcTliR2JRaVRZY3BObkFk?=
 =?utf-8?B?WFBxeWo2UVkwVktrOUNNUGFqV2s0Q1d1VkkvL20wWTg1QjZXNW5SV1lVYWl3?=
 =?utf-8?B?eGJQR3RHVm0weDFFbG5tMVY0ak1QRzRUc0ZYMEhOWGJYeXZQbVUzUlFwa281?=
 =?utf-8?B?QVhQRy8xSnhhb2hnOTlrelVaekNiL2RPTjdYM1hJSGhXTHdWTEcwaEhwelFl?=
 =?utf-8?B?RGp4a096dGljT2F5c1o2Zk5OT3pNMXp3SUQ3Z3BvTjM3ZGJaMnI3TW56WTBY?=
 =?utf-8?B?Ty9jNWpUczlGTm81Q0UxNkVQUXdYSm4rM3ZiWGZtc3EwWGRRSXUwMy9YNEJi?=
 =?utf-8?B?WlduWmVJa2p4ZzNWK0lEbVBzd2JiQkRMMG0yK3g5dEJVaktSVSt2eWF3WUNl?=
 =?utf-8?B?Y2UzOXdCL0RlL0x5disyaDhJWXVEYnB0SHhldlZVR2RiNnZ2eWJ0Vjc0c2kv?=
 =?utf-8?B?NXppd1Fza3VsekQzem9PdXBTRzArcm1OamJXWm5HZWtWZXVrdWRaNzRRZHdu?=
 =?utf-8?B?ZmVZeTBhUm5yZFg0Rmg3QkFIYzVyWDhzMHkrY2RQTnErakdDS3BoaWd4bW41?=
 =?utf-8?B?bngrdU9LZmJhdWNHMWViWGx1bFErMzhZTFoxdktVbUNHNjhkcEZGK2FPbVNP?=
 =?utf-8?B?RzNyUEgvdGVXZUlJWC84aDNPb2hwcXlsWm9RZ2xaTXhya3VUbG1KdDhZVEdJ?=
 =?utf-8?B?QU5KUXFwS1NEWXhsTCtQTzArTjY2L0k3a3ZTNXUydW1jYUtzQUpQOEltRU43?=
 =?utf-8?B?NHUrU2pZUHluZFg2WlhmdjZYVjRVWDdpM1lOQ2F3STdQOElwL3NQUlBmcG9k?=
 =?utf-8?B?MHVobFJ4UXhLZituVmQwK0VhSEY3TXZUQ3ZFTENXT0pueTRQeDU3ejlhRGNO?=
 =?utf-8?B?ck1ua1l5MDVpQ09nZkVUVExaLy9IQmt6QVVBY1Qzek1BTFRlVE01aVZ5Rnpo?=
 =?utf-8?B?R1BYTXJkNEwrNnZBUGV5ZitkQjZkcTdHZkF2SXVpRm9NRk9NSHE5L2d0elNk?=
 =?utf-8?B?VmwxRlp0SjZlYlhIc0xtc1BIdHhLUXdNK2gwQlJTdDBhUnJ3ck1uMVp4Skww?=
 =?utf-8?Q?8mgVy9aE2mqet6tXiGv7Bmxm8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?aXlnTnJGSWlEMFZDMzJmMlVtVS9QREIvOWFyamIvY0EwK0JlSlF4b01ObEZ1?=
 =?utf-8?B?cS9MbTZWVkFCWlkzNnMwVCtreVdwRDZIVEtaUDNUM0ZEUkM3RHlTMFI3cG04?=
 =?utf-8?B?KzRKY09JNWt4L1VaQm12ci9iOWIwQ1k3Q3lUVW9iU2R4YlBRSkdHZjRXa1ZG?=
 =?utf-8?B?TldhSWhSUzNxdXNjcHoyTnRjTkkzWHc0SEtVNFNkV0ZrT0JudTU5VTF6RC91?=
 =?utf-8?B?cHdodUZsMVRxL250Qzd3SmRzN0sxR0JIK042S1V5bXVFaUk5SmZhSjYyd1Fq?=
 =?utf-8?B?Wnl2dVdLUWVzTmJKLzdTSFp1Mmk3S01jRy9zdjRkd1pPWGhLbWVuVHQ1SXps?=
 =?utf-8?B?QmVZa1RNRWhYSUs0aGcxdnZmTHpmUXVwTzY3Z0pSQ0hrZ3FKL3NHTDZydlZo?=
 =?utf-8?B?L1ZhampLWk43ZysrRHFybG1VTGZnN2lEZmJVUUlLbXRSdkJzR3hRcWtOWFNL?=
 =?utf-8?B?eXNIaWJsQXZzYjJGc3RGZHFkSVM5TnZheE5MejNCV1o0SGN3ZEJvS0NZYjJ0?=
 =?utf-8?B?dzdnck9yRzA2T3RmcXkvVDA1S0x3U3YrUW5WcS9wdzNKZytkOEU3ZVVYQVM2?=
 =?utf-8?B?ejFudXgrdElWQlNrdFJkUjVWRUFkWHBsMTJsdXB2NHdJdWF1Q21iYzRsQnNG?=
 =?utf-8?B?ZStOaU5hZ2tJeUFUUzFUM0srYVRJcTY3V2JRWko2SXFCMkpvQmR3ZmNraW4w?=
 =?utf-8?B?STZEVjQwTGF4QjNOa2xVR2hBWUQwUVVZUEtzUFo0Rk93S2JFU1VHT0VTLzhv?=
 =?utf-8?B?ZkJsQlpxeVNQdDQwUlpyZmxpUCtLQ2JGQUJqNGZ0QVNaZGJ1T0RxK0JCb2Zu?=
 =?utf-8?B?QXR3dlhsU3lTVUc4aEFZNjZKa0VUZ1RjU3BuMzB3Z1puR3R6alkxajIvczNK?=
 =?utf-8?B?RE4wN3VTUTN0Z1NDVzkwZEhJNnFHU2VLcngwM2tSY0xUZnloejJUN29GREFP?=
 =?utf-8?B?QUVpSk02a25UcTRyTXhLQ0dxQXR0bHdKanQreGpDblR5WXkrSFVXUk54ZmNM?=
 =?utf-8?B?Qm9UbXhNdzdsZmNhUStwREJ5YzdXRlJEaU14eE4zNmNNKzg3WlFtTmgyb0Y3?=
 =?utf-8?B?d0ovbXZqYVZoN0NZVUVlaVJLN1IrWm1jTGV3M0RVUytEYmp6TFRNRjZtVUd3?=
 =?utf-8?B?bFV4ajVQaWhhdVBxMStmRVBmWnpZNURza2gvbmlpOWdiZlYwejN6NXNCelM0?=
 =?utf-8?B?UytNTjFnUHN5L3EvWlc0WWxvOTZNS3pwKzN1WmlaY1lUYWVPV2NPV0VsZ2gv?=
 =?utf-8?B?U1ZiMnJvcmtvcHJuZmdFcmVHa0Frai9ieW9hV0lweTVuMFNKMlpCazVzampj?=
 =?utf-8?B?dWZ1OE1vaU5qRk5DTTlkV3liUy9UcisxeHViMTJmem1sRGlWWHdpK2VzaFF6?=
 =?utf-8?Q?6k+kHgfsnDbLUiaJaTGjeDbMrcrKz8Mo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 174b6b13-d1df-4034-bb4c-08dbdf3323f3
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2659.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 01:44:54.4989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0mv7+LBfOqHwq4Ky2Xp+es3tHZIxmEBLoY9Nh5md8C74dsBzh6SbawoSLRtzbb8742o6gp5H8BDo+WEV8IjpFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4293
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070013
X-Proofpoint-GUID: z_MNbGls7wEOhqE0UXaWJXgKyTxD2t_w
X-Proofpoint-ORIG-GUID: z_MNbGls7wEOhqE0UXaWJXgKyTxD2t_w

Hi David,

On 10/31/23 16:13, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> A test program such as http://david.woodhou.se/timerlat.c confirms user
> reports that timers are increasingly inaccurate as the lifetime of a
> guest increases. Reporting the actual delay observed when asking for
> 100µs of sleep, it starts off OK on a newly-launched guest but gets
> worse over time, giving incorrect sleep times:
> 
> root@ip-10-0-193-21:~# ./timerlat -c -n 5
> 00000000 latency 103243/100000 (3.2430%)
> 00000001 latency 103243/100000 (3.2430%)
> 00000002 latency 103242/100000 (3.2420%)
> 00000003 latency 103245/100000 (3.2450%)
> 00000004 latency 103245/100000 (3.2450%)
> 
> The biggest problem is that get_kvmclock_ns() returns inaccurate values
> when the guest TSC is scaled. The guest sees a TSC value scaled from the
> host TSC by a mul/shift conversion (hopefully done in hardware). The
> guest then converts that guest TSC value into nanoseconds using the
> mul/shift conversion given to it by the KVM pvclock information.
> 
> But get_kvmclock_ns() performs only a single conversion directly from
> host TSC to nanoseconds, giving a different result. A test program at
> http://david.woodhou.se/tsdrift.c demonstrates the cumulative error
> over a day.
> 
> It's non-trivial to fix get_kvmclock_ns(), although I'll come back to
> that. The actual guest hv_clock is per-CPU, and *theoretically* each
> vCPU could be running at a *different* frequency. But this patch is
> needed anyway because...
> 
> The other issue with Xen timers was that the code would snapshot the
> host CLOCK_MONOTONIC at some point in time, and then... after a few
> interrupts may have occurred, some preemption perhaps... would also read
> the guest's kvmclock. Then it would proceed under the false assumption
> that those two happened at the *same* time. Any time which *actually*
> elapsed between reading the two clocks was introduced as inaccuracies
> in the time at which the timer fired.
> 
> Fix it to use a variant of kvm_get_time_and_clockread(), which reads the
> host TSC just *once*, then use the returned TSC value to calculate the
> kvmclock (making sure to do that the way the guest would instead of
> making the same mistake get_kvmclock_ns() does).
> 
> Sadly, hrtimers based on CLOCK_MONOTONIC_RAW are not supported, so Xen
> timers still have to use CLOCK_MONOTONIC. In practice the difference
> between the two won't matter over the timescales involved, as the
> *absolute* values don't matter; just the delta.
> 
> This does mean a new variant of kvm_get_time_and_clockread() is needed;
> called kvm_get_monotonic_and_clockread() because that's what it does.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Paul Durrant <paul@xen.org>
> 
> ---
> v2: 
>   • Fall back to get_kvmclock_ns() if vcpu-arch.hv_clock isn't set up
>     yet, with a big comment explaining why that's actually OK.
>   • Fix do_monotonic() *not* to add the boot time offset.
>   • Rename do_monotonic_raw() → do_kvmclock_base() and add a comment
>     to make it clear that it *does* add the boot time offset. That
>     was just left as a bear trap for the unwary developer, wasn't it?
> 
>  arch/x86/kvm/x86.c |  61 +++++++++++++++++++++--
>  arch/x86/kvm/x86.h |   1 +
>  arch/x86/kvm/xen.c | 121 ++++++++++++++++++++++++++++++++++-----------
>  3 files changed, 149 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6eaab714d90a..e479637af42c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2844,7 +2844,11 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
>  	return v * clock->mult;
>  }
>  
> -static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
> +/*
> + * As with get_kvmclock_base_ns(), this counts from boot time, at the
> + * frequency of CLOCK_MONOTONIC_RAW (hence adding gtos->offs_boot).
> + */
> +static int do_kvmclock_base(s64 *t, u64 *tsc_timestamp)
>  {
>  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
>  	unsigned long seq;
> @@ -2863,6 +2867,29 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
>  	return mode;
>  }
>  
> +/*
> + * This calculates CLOCK_MONOTONIC at the time of the TSC snapshot, with
> + * no boot time offset.
> + */
> +static int do_monotonic(s64 *t, u64 *tsc_timestamp)
> +{
> +	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
> +	unsigned long seq;
> +	int mode;
> +	u64 ns;
> +
> +	do {
> +		seq = read_seqcount_begin(&gtod->seq);
> +		ns = gtod->clock.base_cycles;
> +		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
> +		ns >>= gtod->clock.shift;
> +		ns += ktime_to_ns(gtod->clock.offset);
> +	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
> +	*t = ns;
> +
> +	return mode;
> +}
> +
>  static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
>  {
>  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
> @@ -2884,18 +2911,42 @@ static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
>  	return mode;
>  }
>  
> -/* returns true if host is using TSC based clocksource */
> +/*
> + * Calculates the kvmclock_base_ns (CLOCK_MONOTONIC_RAW + boot time) and
> + * reports the TSC value from which it do so. Returns true if host is
> + * using TSC based clocksource.
> + */
>  static bool kvm_get_time_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
>  {
>  	/* checked again under seqlock below */
>  	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
>  		return false;
>  
> -	return gtod_is_based_on_tsc(do_monotonic_raw(kernel_ns,
> -						      tsc_timestamp));
> +	return gtod_is_based_on_tsc(do_kvmclock_base(kernel_ns,
> +						     tsc_timestamp));
>  }
>  
> -/* returns true if host is using TSC based clocksource */
> +/*
> + * Calculates CLOCK_MONOTONIC and reports the TSC value from which it did
> + * so. Returns true if host is using TSC based clocksource.
> + */
> +bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
> +{
> +	/* checked again under seqlock below */
> +	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
> +		return false;
> +
> +	return gtod_is_based_on_tsc(do_monotonic(kernel_ns,
> +						 tsc_timestamp));
> +}
> +
> +/*
> + * Calculates CLOCK_REALTIME and reports the TSC value from which it did
> + * so. Returns true if host is using TSC based clocksource.
> + *
> + * DO NOT USE this for anything related to migration. You want CLOCK_TAI
> + * for that.
> + */
>  static bool kvm_get_walltime_and_clockread(struct timespec64 *ts,
>  					   u64 *tsc_timestamp)
>  {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 1e7be1f6ab29..c08c6f729965 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -293,6 +293,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>  
>  u64 get_kvmclock_ns(struct kvm *kvm);
> +bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
>  
>  int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>  	gva_t addr, void *val, unsigned int bytes,
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 751d9a984668..e3d2d63eef34 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -24,6 +24,7 @@
>  #include <xen/interface/sched.h>
>  
>  #include <asm/xen/cpuid.h>
> +#include <asm/pvclock.h>
>  
>  #include "cpuid.h"
>  #include "trace.h"
> @@ -158,8 +159,93 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
>  
> -static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_ns)
> +static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
> +				bool linux_wa)
>  {
> +	uint64_t guest_now;
> +	int64_t kernel_now, delta;
> +
> +	/*
> +	 * The guest provides the requested timeout in absolute nanoseconds
> +	 * of the KVM clock — as *it* sees it, based on the scaled TSC and
> +	 * the pvclock information provided by KVM.
> +	 *
> +	 * The kernel doesn't support hrtimers based on CLOCK_MONOTONIC_RAW
> +	 * so use CLOCK_MONOTONIC. In the timescales covered by timers, the
> +	 * difference won't matter much as there is no cumulative effect.
> +	 *
> +	 * Calculate the time for some arbitrary point in time around "now"
> +	 * in terms of both kvmclock and CLOCK_MONOTONIC. Calculate the
> +	 * delta between the kvmclock "now" value and the guest's requested
> +	 * timeout, apply the "Linux workaround" described below, and add
> +	 * the resulting delta to the CLOCK_MONOTONIC "now" value, to get
> +	 * the absolute CLOCK_MONOTONIC time at which the timer should
> +	 * fire.
> +	 */
> +	if (vcpu->arch.hv_clock.version && vcpu->kvm->arch.use_master_clock &&
> +	    static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {

If there any reason to use both vcpu->kvm->arch.use_master_clock and
X86_FEATURE_CONSTANT_TSC?

I think even __get_kvmclock() would not require both cases at the same time?

 3071         if (ka->use_master_clock &&
 3072             (static_cpu_has(X86_FEATURE_CONSTANT_TSC) ||
__this_cpu_read(cpu_tsc_khz))) {

> +		uint64_t host_tsc, guest_tsc;
> +
> +		if (!IS_ENABLED(CONFIG_64BIT) ||
> +		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
> +			/*
> +			 * Don't fall back to get_kvmclock_ns() because it's
> +			 * broken; it has a systemic error in its results
> +			 * because it scales directly from host TSC to
> +			 * nanoseconds, and doesn't scale first to guest TSC
> +			 * and then* to nanoseconds as the guest does.
> +			 *
> +			 * There is a small error introduced here because time
> +			 * continues to elapse between the ktime_get() and the
> +			 * subsequent rdtsc(). But not the systemic drift due
> +			 * to get_kvmclock_ns().
> +			 */
> +			kernel_now = ktime_get(); /* This is CLOCK_MONOTONIC */
> +			host_tsc = rdtsc();
> +		}
> +
> +		/* Calculate the guest kvmclock as the guest would do it. */
> +		guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
> +		guest_now = __pvclock_read_cycles(&vcpu->arch.hv_clock,
> +						  guest_tsc);
> +	} else {
> +		/*
> +		 * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
> +		 *
> +		 * Also if the guest PV clock hasn't been set up yet, as is
> +		 * likely to be the case during migration when the vCPU has
> +		 * not been run yet. It would be possible to calculate the
> +		 * scaling factors properly in that case but there's not much
> +		 * point in doing so. The get_kvmclock_ns() drift accumulates
> +		 * over time, so it's OK to use it at startup. Besides, on
> +		 * migration there's going to be a little bit of skew in the
> +		 * precise moment at which timers fire anyway. Often they'll
> +		 * be in the "past" by the time the VM is running again after
> +		 * migration.
> +		 */
> +		guest_now = get_kvmclock_ns(vcpu->kvm);
> +		kernel_now = ktime_get();

1. Can I assume the issue is still there if we fall into the "else" case? That
is, the increasing inaccuracy as the VM has been up for longer and longer time?

If that is the case, which may be better?

(1) get_kvmclock_ns(), or
(2) always get_kvmclock_base_ns() + ka->kvmclock_offset, when pvclock is not
enabled, regardless whether master clock is used. At least, the inaccurary is
not going to increase over guest time?


2. I see 3 scenarios here:

(1) vcpu->arch.hv_clock.version and master clock is used.

In this case, the bugfix looks good.

(2) The master clock is used. However, pv clock is not enabled.

In this case, the bug is not resolved? ... even the master clock is used.

(3) The master clock is not used.

We fall into get_kvmclock_base_ns() + ka->kvmclock_offset. The behavior is not
changed. This looks good.


Just from my own point: as this patch involves relatively complex changes, I
would suggest resolve the issue, but not use a temporary solution :)

(I see you mentioned that you will be back with get_kvmclock_ns())


Based on your bug fix, I see the below cases:

If master clock is not used:
    get_kvmclock_base_ns() + ka->kvmclock_offset

If master clock is used:
    If pvclock is enabled:
        use the &vcpu->arch.hv_clock to get current guest time
    Else
        create a temporary hv_clock, based on masterclock.


Regarding the temporary solution, I would suggest create a new API to
encapsulate and fulfill above scenarios, if we are not going to touch
__get_kvmclock() at this time point.


Thank you very much!

Dongli Zhang


> +	}
> +
> +	delta = guest_abs - guest_now;
> +
> +	/* Xen has a 'Linux workaround' in do_set_timer_op() which
> +	 * checks for negative absolute timeout values (caused by
> +	 * integer overflow), and for values about 13 days in the
> +	 * future (2^50ns) which would be caused by jiffies
> +	 * overflow. For those cases, it sets the timeout 100ms in
> +	 * the future (not *too* soon, since if a guest really did
> +	 * set a long timeout on purpose we don't want to keep
> +	 * churning CPU time by waking it up).
> +	 */
> +	if (linux_wa) {
> +		if ((unlikely((int64_t)guest_abs < 0 ||
> +			      (delta > 0 && (uint32_t) (delta >> 50) != 0)))) {
> +			delta = 100 * NSEC_PER_MSEC;
> +			guest_abs = guest_now + delta;
> +		}
> +	}
> +
>  	/*
>  	 * Avoid races with the old timer firing. Checking timer_expires
>  	 * to avoid calling hrtimer_cancel() will only have false positives
> @@ -171,12 +257,11 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_
>  	atomic_set(&vcpu->arch.xen.timer_pending, 0);
>  	vcpu->arch.xen.timer_expires = guest_abs;
>  
> -	if (delta_ns <= 0) {
> +	if (delta <= 0) {
>  		xen_timer_callback(&vcpu->arch.xen.timer);
>  	} else {
> -		ktime_t ktime_now = ktime_get();
>  		hrtimer_start(&vcpu->arch.xen.timer,
> -			      ktime_add_ns(ktime_now, delta_ns),
> +			      ktime_add_ns(kernel_now, delta),
>  			      HRTIMER_MODE_ABS_HARD);
>  	}
>  }
> @@ -945,8 +1030,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  		/* Start the timer if the new value has a valid vector+expiry. */
>  		if (data->u.timer.port && data->u.timer.expires_ns)
>  			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> -					    data->u.timer.expires_ns -
> -					    get_kvmclock_ns(vcpu->kvm));
> +					    false);
>  
>  		r = 0;
>  		break;
> @@ -1389,7 +1473,6 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
>  {
>  	struct vcpu_set_singleshot_timer oneshot;
>  	struct x86_exception e;
> -	s64 delta;
>  
>  	if (!kvm_xen_timer_enabled(vcpu))
>  		return false;
> @@ -1423,9 +1506,7 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
>  			return true;
>  		}
>  
> -		/* A delta <= 0 results in an immediate callback, which is what we want */
> -		delta = oneshot.timeout_abs_ns - get_kvmclock_ns(vcpu->kvm);
> -		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, delta);
> +		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, false);
>  		*r = 0;
>  		return true;
>  
> @@ -1449,25 +1530,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vcpu *vcpu, uint64_t timeout,
>  		return false;
>  
>  	if (timeout) {
> -		uint64_t guest_now = get_kvmclock_ns(vcpu->kvm);
> -		int64_t delta = timeout - guest_now;
> -
> -		/* Xen has a 'Linux workaround' in do_set_timer_op() which
> -		 * checks for negative absolute timeout values (caused by
> -		 * integer overflow), and for values about 13 days in the
> -		 * future (2^50ns) which would be caused by jiffies
> -		 * overflow. For those cases, it sets the timeout 100ms in
> -		 * the future (not *too* soon, since if a guest really did
> -		 * set a long timeout on purpose we don't want to keep
> -		 * churning CPU time by waking it up).
> -		 */
> -		if (unlikely((int64_t)timeout < 0 ||
> -			     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
> -			delta = 100 * NSEC_PER_MSEC;
> -			timeout = guest_now + delta;
> -		}
> -
> -		kvm_xen_start_timer(vcpu, timeout, delta);
> +		kvm_xen_start_timer(vcpu, timeout, true);
>  	} else {
>  		kvm_xen_stop_timer(vcpu);
>  	}

