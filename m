Return-Path: <kvm+bounces-48746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C4BAD2538
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EDF57A6403
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 17:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8802D21A445;
	Mon,  9 Jun 2025 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="EQpkiePb"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020119.outbound.protection.outlook.com [52.101.84.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEF374C14
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749491657; cv=fail; b=AWSkIdxD3+aZGcKAOfg8WqVazDbqjamjiXnz1rCm0Y60cU87eOCbmsGlWxH5o66OF9aIRQ/MKjsmEKBx+gctcu/eeLOOCnWVxRz4h/NAEuF+0E2A+z7x2GAMLrfJZLZMgs4Nlbr+Zf8b5L3BoqukMeQO4PIwtUuuxPk2kr5exT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749491657; c=relaxed/simple;
	bh=avMpPiGvVERlr+WCW6IJjnmvaBdWh3VsfGd4cX1Iyxk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R89b1fhkyjPp4Oiyntg6PHPnJKD+HFEzsbmNb3cUEESlSqFMM4UWRJgZEIhZk+K92ItXaMVcmRax3lOqbpQoOnHC4qWuhCTT/B1FfYdbI3wGpO6qdYvR63xBlwBD0o4ZwjDbebn+JQRbVY22TvOxxzoAFmnWjHWB/or4rBkuFmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=EQpkiePb; arc=fail smtp.client-ip=52.101.84.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eZvRGl4AkBCfBNHkqQbpPKj7OQNZRqggZ/G3oJ9/qT9QQth3F7X72puK6L2ob2ySC2GN8DIZrhuS5OK9ft/Pj+wcrQEC71U8quEromXYFTK/X/emWlnlNPqztlY3nlpZj0libYh8Ig/eNBbarWRm+T0kZDfRE2lhq+bjkw5jtPiDP6qWAifDklktpWp1v2SIWeokCws76fNyM79IfAV02ScaNOKEx9uVl9xhmsUd5tvN3tDlCALN0NtHqX+v/h0+fzRGINFfIjPYjUZotWVVj13HR7SBCv8sug3DjOVlBebiOrl8go2btiz3ROUMbMTSL4PSjq0QNPFg5oxc9GTphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4CQReFl449BtK9g3hzvJWqWBehIu9udqrdb8+AZRak=;
 b=NG0ZrM3bwckj67O8Rv7Nk0TMAiczi+3WMInbRQaCKog4ZXIR4iI011UXmnIn3iC2Q8r7vQ9vgi6BKlzDsNRZpPdFGKvSW4n9MKr9Umfb/MBrKftvuTG8/RyBOXSc6dyVV2DX4en+kRzAqgXiBHicPM+zC3TEgivfzUfSS0LPrG6r1FwwBH4QpOL+xuZfsfl4dvoXaBXopX4U+ZjIhajSlIwVAVdnpJ8ZZf9Z8wHeF/E092eYLfw6QS6WnAJrw5a+xvWplurNSrhmdgZcq9Vft1uc/p2L+Bp/9lTXkACJt45iRzuw3WUVFfrSKSa3Xs5q8YPWVlZMQZhzAkyW6FKd+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4CQReFl449BtK9g3hzvJWqWBehIu9udqrdb8+AZRak=;
 b=EQpkiePbkBkFnQ3sGjyfnX1Cx0Hxze4Zc9PlOEbxq3PuRMqj/RUz8l/VnlIx33w7cDEsnQf2dSIEUV5y3qhd9NpiMD0NrIQSn+z6DiRvQ3YWRZkKLX2kKSyOUtc6eNEutLuYT+sMJxf5RrrazjjRunRKuQH2i+ZPXG4eerTBnDyqIpYQqib9VwPK2tHNEm1fYMQ9HKj69IfPWc4pJlYn772BC68Fc6YHeD7OyHC5fzEthpmjGFhI2TxdYyRLySlpEpbUwzPkgznESJ9Ozw/F8OPNXPdIjIhSk0Howql/+ctThPKsanTYtmg6G3jiV7LZsOVKfA80lL2yNA7xfDoduQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AS8PR08MB8708.eurprd08.prod.outlook.com (2603:10a6:20b:562::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.25; Mon, 9 Jun
 2025 17:54:10 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e543:a83c:a260:602b]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e543:a83c:a260:602b%3]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 17:54:10 +0000
Message-ID: <203f24da-fce0-4646-abed-c6ca657828d1@virtuozzo.com>
Date: Mon, 9 Jun 2025 19:54:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with
 SGX
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: zhao1.liu@intel.com, mtosatti@redhat.com, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, andrey.drobyshev@virtuozzo.com,
 "Denis V. Lunev" <den@virtuozzo.com>
References: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
 <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com>
 <4f19c78f-a843-49c9-8d19-f1dc1e2c4468@virtuozzo.com>
 <aEcOSd-KBjOW61Rt@google.com>
Content-Language: en-US
From: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <aEcOSd-KBjOW61Rt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::19)
 To AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR08MB5732:EE_|AS8PR08MB8708:EE_
X-MS-Office365-Filtering-Correlation-Id: a96e45d7-1735-45df-9961-08dda77ea33d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGNKYVVtQ2JzNXVhS3hwV3gwVkNEWHBidE1jd3F3ckxSWXBKblZIWVllekxn?=
 =?utf-8?B?Mm05QzlXaVlVV2NhTGVEZStsTS9ncWFFNnhNS0ZZdDZoRFN1eDB2K1pyNDU3?=
 =?utf-8?B?UGthVSswTGsrVXNNdVAySVBHTlI3enpleG0yZDFQT2pDL05JT0dHS3pCVm41?=
 =?utf-8?B?QXVqRi9tRE9IMWxRd1pRQ053bHV1UXJGR0Nqc2FzL1FKVWxsU2xOMm1weEN0?=
 =?utf-8?B?RlR4d0ZFcmoyUHFuZ3B0MzI0VSszY3hLZi9WbzZ6U2NMV2NYTnRnSURvRnpE?=
 =?utf-8?B?bXg0UGFtWDgreWkrYTUzeUkrKzRqdDE2a0EzSlV4RS9MSXhGWFh6WVNHQ1Ew?=
 =?utf-8?B?WFM3YW52Qm1pYWtJS01peTRNUHY5L1RBUExYNE4yTlJnWmFMNGwrVUVmN2lW?=
 =?utf-8?B?Qlo1VUR2cVdEYVQxKzh0M3M3Vmt3TlVqTDlrMzBGVmFuQm0xN093aDBQK2pv?=
 =?utf-8?B?Z1Q2TEdwNkxJTisxWmZSZVp0cis0Z2x0RElUazA5TVRpeHd3bUluSmdvUlAx?=
 =?utf-8?B?WHBTMTZvTDBYMzdHaE5hSks5a0FvMW12V2tLd1JkaDNkdzIvQUtxTElKeGJk?=
 =?utf-8?B?Z0FXWFJMSXRQMkJkeWhRSUxLV24ySElNdFBEdy9adWNicHdCM0FkU1VSVk9a?=
 =?utf-8?B?OEJnNU9KRzVIUmVQU2V5bFpRc3NjTGJYOHlzS0hvc09RbUJIaFhYT0lTN2JO?=
 =?utf-8?B?aEMvQXorUE1MVnZQSnI0eWtZK0wzS05EbXNBbHUvNTBoU1JncGJUaGN5bnph?=
 =?utf-8?B?ZGI3bGFLV0s3eXVhbVRaSHIyVSsra0FQRjd0c3hXUWwzTHlMWlZERzcrUUN6?=
 =?utf-8?B?cFFWcE0xYUVHRXh1VUswYVRvNitDbEdMd3ZuYVhnNXhsWStNS2dOTEMxVXZH?=
 =?utf-8?B?a0NkZXF3SXI2bzNEYk41UkJQQmdnQS82elc0dVFOdSt3T3h1UjdoY0lmK3ky?=
 =?utf-8?B?QVM4cHZCYmNyZWptUGR5WWYyWTFpWmpYMUhPMlNQb3B1UnNwZzgxUnFhczY5?=
 =?utf-8?B?bm5WVDI3N1FVVkdFNit4L29wbmRBM2Y0TXlROXlneWlEcHgzTHdiOFFkalZl?=
 =?utf-8?B?NzNiRTN1YW1vcWgwaTVjdHBhSmtOdUNkUzRvYXZXZ3ZLV0JKZlA3QnpGUWMv?=
 =?utf-8?B?SWNTSG9OSUZ4WHNPYWttKzUyZXFoWk5RNk1VVlNCNjRRQklSbWFKZjJ5dmRu?=
 =?utf-8?B?bVpxRmR0WHlIdlBRN2ZvdTVwcjkxVXJvWGVackVpOHZwRGozRFVrcUlBTTd1?=
 =?utf-8?B?dWFGVmduRm1VQ1FzQlpXNGdFa253Wkx4Q2RycFowVjdoYWVrZEFseDhTMnIr?=
 =?utf-8?B?VnJPbDlFT0paMldKcXcydzNHTjk3RE5xUHJsV0t1c0srdVRoSkZBWXBJZ21B?=
 =?utf-8?B?UmlDb29VK3dqenhOQ2Y5WUpHbDg1TUo1RjdSanJUY2NGMDNSejRiN3IxK0g2?=
 =?utf-8?B?K2xZckN1L0IrTUJMVlhNUlVLTVJoVi82WUFiTXBkOCtQdzRFVFppdnFOay9W?=
 =?utf-8?B?N1paWEpRWDlqOEpvT29pYTdSdm9zNWVQTzNOdXk2QzhGRktsTkxwZkVRdnA2?=
 =?utf-8?B?WmVOTGVjdFNGMS9qR0lXV1loY1hGNlR1VHhoKzVrZVJUWkNNOVVPeUtZNjhx?=
 =?utf-8?B?V083VUozSWlnRmxKaTNWV2hxWFpSaXVlWmYwUWRKVXFOK1h0RGJFUVFEaXJE?=
 =?utf-8?B?SWJGOHhBNkkybVJGazVtcUhXL0dXUXQ0czBxQWxQK3ZDYmZQYlJRMGVSKzQ5?=
 =?utf-8?B?N2paMGpLV0hNeFV1cUUrbFRZbjdHQkdZT3ZIeVR1ZEtIT2hVWHhwSTlDOXIw?=
 =?utf-8?B?aTBIU2tqTm9sMkhvdEFUOThNeU12MVV0TEVJYnErWnkxaUovdE53L08wa2pK?=
 =?utf-8?B?Uno2RVRHems0bDB5R3ZvQVZLWmJYY21OdnVOV3RHb3FhUmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1RVY0ozSzd5eDJuUUVuNUdMYS9MaTNnRk9KVWhWMGt5Y1V1RVNaRzhBYmFO?=
 =?utf-8?B?cHZtcWE2SjZTcTZlNlo1bzErUitqNjZTYTdid0tQeEpYSkxKNGtqZmUzN0w3?=
 =?utf-8?B?TThXNTJUekVhdmdQdUNEOGRqNEdiWWk1NllFUm5rQTVnc2ZPdVVtZDRpUHYw?=
 =?utf-8?B?MVlaNEVSYkRMZkgwOXFSTktoYk4wQ0NLZGlGbjhiVGwrT3JQMVNSSVFZVmhm?=
 =?utf-8?B?bWtRRU1ZcW01THlBVW1YS0ZENE03allneUNYMEYzVTFaaisxYUYyeFJveEdB?=
 =?utf-8?B?VTVXWERZTTZCWjJVd3FXM1ZoSVphZSsvb0tReHBmQktzNHRLRE9oTFBONlZC?=
 =?utf-8?B?dHo1Q0o4dTZsdGVpM2JqUWFtNkFyRnI0anQvdkMyRmtiSEUyTmt6dnRkSWVD?=
 =?utf-8?B?aWlZRDdlbDF6T056Tmh5Ky9iNGNZN2RxNVUzWlFPeFplSU9IanJOZDZqU0FO?=
 =?utf-8?B?ZWYxd0RKRVA2UnI0QU5ta1F0RDQyQ1pVTGVBeXNOSnpYZ1VDczFadE1BYmh0?=
 =?utf-8?B?VmJTMmRmTXVrWlE1YlN1dHlxQ3J0d3dTbGNFTGZoN3hNV2hjdGF2SjJTNGNn?=
 =?utf-8?B?Y2dRa09ZWE9mZzU4UHVONmhEMTM3N0VwcW94UnBDdUVwNXgxc1JTd1BFaEJN?=
 =?utf-8?B?R0dWNUovU2NYYzFnK1dEcTBZMUVkaC9nTFZsVEJJdVE4SkdOTSt1bzZyVmlM?=
 =?utf-8?B?QTh6dmloNkVIVzV5WWlUWmFoa3hJMW45Mjh6cyttS250Z0t4em81MzRFLzdR?=
 =?utf-8?B?ME1wVlVkeWFPWTRFRFFmNWJlRnowR0JnaTFXWWZGUE0zNDRlQ3NJZ3NnSzJ0?=
 =?utf-8?B?aEJzM3pqQWtvdDdkS3lmcGxMUzFVblNTTm8zbE5HRXdGYkoweFlGdVdmeG9Z?=
 =?utf-8?B?YVE4MFd1cUNhUXAzZXN3UzVzbGZJZDVUSFZuNXZSWUFnbXVEakpnWEFveklH?=
 =?utf-8?B?bDI5aEd5c1R4T0VUSHlTYTZLeGc1dGZyTlRNZTJZUklJZ2c5VFBMeXFuVGU2?=
 =?utf-8?B?M3czelBJR09pYjFhNUhLSENyWGZwZVJJUG1nY3J1dy9Ub2Nsd3pnQ3JhNW0x?=
 =?utf-8?B?N3dYWFE4NlpzWlU2a1E2aHIyeGlCUGZaWExBd2gyNU5PQU1VS216TE8zdzlI?=
 =?utf-8?B?QXoveGdUbHVHcHIvciszc0xhY2VQWW9zRlU2YllQd0ZnejZBSURYN2dzaVRs?=
 =?utf-8?B?MmU0TktLR0dTL1owenZFUm44MnlmQ3JIYWIvRDQwb0liYWtLWlNiOVgxdEdV?=
 =?utf-8?B?R0lVdTFRNm9Nb3VTdHZqNmYzR1I1UnZFbmxYek1YNlhEMnYzSnFrQXYxOFRi?=
 =?utf-8?B?RjFPZjFNYUtjZUMxVWxyclc4OW9OWlRCcmdsMmt4ZFRPMWFhSUh4aW1Va1F2?=
 =?utf-8?B?a3FocWFuV0ZXcXVaTTNVMjJXU3VFWVMwYzB4aTF5bWEzRjh1YjloWkl0cjF4?=
 =?utf-8?B?ejUybGtKa1NVSy9kQkx6bXkzZURuQk1vMytLZDZqVG02NVBNd0dDMWNxMWR2?=
 =?utf-8?B?bnNPSW5MZzk3TkhZaStuL0o0N1UrNUYwWjVLclQ5dlN1V1VsRkRIYmJtbms5?=
 =?utf-8?B?WHQ3TzB3TlhtQWNkdE8xR282TW8zcnlEVFAzVFNrVzhnbTRxS1hoMzVkTDRH?=
 =?utf-8?B?UDBVeU9vaHN4b2Y2UWlRSjljY3FmZVlvRzNWYzRMaGxmbEJSdEk5NXdFcjR0?=
 =?utf-8?B?bnkzVVloaFdrbGZDMDl5cVpHRkpMcEk4QUs2STE2U0VoN1F1dGhMOGlCb0Fj?=
 =?utf-8?B?TnRqeFFvRUJVU3o4WkZlVlR5UXJOUjhkYjVqZzlpQlF5blJnYkQ5MGt1ZFdo?=
 =?utf-8?B?dkMvRmJKaXhKMk5qSXFtK2IzVFFsV1hDb05WUWpPWG5WRStKaW5Ma285OVVH?=
 =?utf-8?B?VDhQaml5dG8xWEJBRlFyOEZyc1JPbjNtcXFJdGVZaFJmTVFnOXN5RUNOMmdB?=
 =?utf-8?B?N1lzYjIyRG52UnZDdGxRNWRjQ1RjNUJJbVg4azg2aWY5SWZERFlGWXdNalFo?=
 =?utf-8?B?bWpGS2x2eDhJSkg0NW1JUVNYczZnTDRUeWE5QUpvQi9zbDY0MDVheE94THBS?=
 =?utf-8?B?ZGtHaHNNdWJwc0hvZW5adWpDaXJWcmZGNEJRd1hOeURZMjJNSG96NW5zMFpT?=
 =?utf-8?B?ZG02NUYyd1BLbzNUL3U3SEVoWGthOEZ3V2loZlNWTHZhR0VRTHVZZEFGNHBo?=
 =?utf-8?B?c3c9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96e45d7-1735-45df-9961-08dda77ea33d
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:54:10.5920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAtMkhsi0fuAdNQrCufSeZjtvXRijoWBM/yVhxyCuh/x7QyM++XMd8lbkIT4aceX2EhdtPIReGZM5mCXsAdpNreCf3fUKImX9+OAqbtiddg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8708



On 6/9/25 18:39, Sean Christopherson wrote:

> 
> On Mon, Jun 09, 2025, Denis V. Lunev wrote:
>> On 6/9/25 18:12, Paolo Bonzini wrote:
>>> On 6/9/25 15:23, Andrey Zhadchenko wrote:
>>>> When hotplugging vCPUs to the Windows vms, we observed strange instance
>>>> crash on Intel(R) Xeon(R) CPU E3-1230 v6:
>>>> panic hyper-v: arg1='0x3e', arg2='0x46d359bbdff',
>>>> arg3='0x56d359bbdff', arg4='0x0', arg5='0x0'
>>>>
>>>> Presumably, Windows thinks that hotplugged CPU is not "equivalent
>>>> enough"
>>>> to the previous ones. The problem lies within msr 3a. During the
>>>> startup,
>>>> Windows assigns some value to this register. During the hotplug it
>>>> expects similar value on the new vCPU in msr 3a. But by default it
>>>> is zero.
>>>
>>> If I understand correctly, you checked that it's Windows that writes
>>> 0x40005 to the MSR on non-hotplugged CPUs.
> 
> ...

Actually no, it may also be firmware.
We are only sure that it is Windows code that crashes the vm.

> 
>>>> Bit #18 probably means that Intel SGX is supported, because disabling
>>>> it via CPU arguments results is successfull hotplug (and msr value 0x5).
>>>
>>> What is the trace like in this case?  Does Windows "accept" 0x0 and
>>> write 0x5?

It 'accepts' 0x0, but does not write anything there.

>>>
>>> Does anything in edk2 run during the hotplug process (on real hardware
>>> it does, because the whole hotplug is managed via SMM)? If so maybe that
>>> could be a better place to write the value.
> 
> Yeah, I would expect firmware to write and lock IA32_FEATURE_CONTROL.
> 
>>> So many questions, but I'd really prefer to avoid this hack if the only
>>> reason for it is SGX...
> 
> Does your setup actually support SGX?  I.e. expose EPC sections to the guest?
> If not, can't you simply disable SGX in CPUID?

We do not have any TYPE_MEMORY_BACKEND_EPC objects in our default 
config, but have the following: 
sgx=on,sgx1=on,sgx-debug=on,sgx-mode64=on,sgx-provisionkey=on,sgx-tokenkey=on
We found this during testing, and it can be disabled on our testing 
setup without any worries indeed.
I have no data whether someone actually sets it properly in the wild, 
which may still be possible.

> 
>> Linux by itself handles this well and assigns MSRs properly (we observe
>> corresponding set_msr on the hotplugged CPU).

I think Linux, at least old 4.4, does not write msr on hotplug. Anyway 
it hotplugs fine and tolerates different value unlike Windows

> 
> Linux is much more tolerant of oddities, and quite a bit of effort went into
> making sure that IA32_FEATURE_CONTROL was initialized if firmware left it unlocked.

Thanks everyone for the ideas. I focused on Windows too much and did not 
investigate into firmware, so perhaps this is rather a firmware problem?
I think by default we are using seaBIOS, not ovmf/edk2. I will update 
after some testing with different configurations.

