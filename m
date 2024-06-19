Return-Path: <kvm+bounces-19992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C8490F1F8
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 971E92817C2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF9A1411D7;
	Wed, 19 Jun 2024 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zOt2UzYd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E301802E;
	Wed, 19 Jun 2024 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718810437; cv=fail; b=VHCm98c24DKjfu2eV2R1xU++LbLC0wA/IQBdF60guAOxeiK6Ff86R5LmLkZFoVnVSbLr+KY5s/ZqpcVmsPNX/9IzkwtK5keDUn7lziYs2h2g94ytXQ8FpYfaQUq7pAmfO2OLtwl0mM1NwMM1orvKi7FROKVQW51OukpGlTDxRLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718810437; c=relaxed/simple;
	bh=KOWFupVvRno4PQKS8wx2B4Jyxl10BSUP3jbx1rj5+T8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cppPYRsAC9Tq9XrsPYwdNF3Ld5z8gw+LgqWURvZEYsSy0mdynWLzqmRWN3Aq9HpwXq9O97WQUo96IgeYJAe4Qa7fpgpapr2MOwzlyYUEWqKlkwPc/XVn7IzumVHO0hWMif4c9qRbdf8TqjcP5xQNgZdmHtZ1yvKjjwpgbkC8WIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zOt2UzYd; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5kQQjWjMuPWhhD/xHJeQrAMoc5Ikj31pEhQ54NBzl5wnmFNQqSQidj81q5jF7lNID0x2j/NDBdxU+4afr6ENFsPkX9du6WhMjLs5QuPXCNEaVnb8Q+639/d/be/1Y6GanN2c/kCZdD2Gjhs0zyaU+eMlGeMLn7tZtIPGqPQSpXqyUrkvsMp8yroZF/KmKxoXhpwARdR/Yvh6FQZilwaueDkWg4/hu/XPxU1vAG0djqMH6fNgNO5sso5fzdMOAChvGSOdVBK5A16c8L4cbyN4QLncSciqdWXxbF1sDgFtWSijgDtuKSrL4MzPJWIGd0zRf36zh7LEsWEuJMZA9bb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDM1PM28LT+jf4jC094DJaYXK1qBtI+JfqUVZOuM1uQ=;
 b=HfXUCegSjE+Ltmj3glZDgLx5o4j+H40FUGq88keC9w187GjQq6v7wuAYGoNIMM5osAbwlcovZ8s3Nv8KYbVfLMkX6IzEZbdWL8LqjD8GgNVn8PpGb/H5xjnMMAsXTZRd2XhbwRlnh7j5TNtlyZtq0a2c6dIC1J0m2ytFdXBKkZKcZAq7Kp33Ol9Z3QA29kFZv+GCCdOor750Sk6ntHu3vGON7Xs/+i1t0M0cfZF5yYOBA/8GYYY2Wh/o1pBdY4WkNBu69ApdzNHBk43Fnv3kVK7KcRfgro0D2YyMb1dXy+5jy78AbKrtqViPh0msWJXhX0BLCjcZVCTaRtBYPbDfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDM1PM28LT+jf4jC094DJaYXK1qBtI+JfqUVZOuM1uQ=;
 b=zOt2UzYdAASbsRaGQLKi0s2jd3ZTCvz3epG0BNT07tjaWjXQD8KAXXbDGSZZsmhs4lM5HdiCMZwO4JISOd/s5SSpdq3QwxDCh/5/tm0Spur/2B3RViVSqnqzxzDUGhZCWdSRxHwfW3bQo4pSpc02wpCrm6VbsEn4wzyWIu2PZGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS7PR12MB6360.namprd12.prod.outlook.com (2603:10b6:8:93::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.30; Wed, 19 Jun 2024 15:20:33 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7698.017; Wed, 19 Jun 2024
 15:20:32 +0000
Message-ID: <9b4161be-b375-a533-efe9-f45e05fe1db0@amd.com>
Date: Wed, 19 Jun 2024 20:50:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v9 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-7-nikunj@amd.com>
 <64164798-3055-c745-0bc1-bbecc1dd0421@amd.com>
 <9b8c57e7-a871-6771-dcc0-99847bbbcbc0@amd.com>
 <24903cd3-f5e1-c770-212b-e46149854792@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <24903cd3-f5e1-c770-212b-e46149854792@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0018.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS7PR12MB6360:EE_
X-MS-Office365-Filtering-Correlation-Id: 8633ffc0-ef46-415e-2af3-08dc90735c64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHNiSW4zSnVEcytCa1VvR3pzT0wrWmpxMitpSUFNZjNsdGg1RS9mUkFDR0VY?=
 =?utf-8?B?b0hOanQyTnJybU9pK3NBZU5KeXFzTFFzRTBHWnhYRC9XbS9OZmtFQW1iL1pC?=
 =?utf-8?B?elN1a3VrV0NnZ2lpQjlTazc5MHNRK3VITWx6RW9iRUVOUUQ5N21RZ01hbXIy?=
 =?utf-8?B?NXlLMHhZR0tXdXZGU0piYW5IdE13QkxIRUhobHhUMGlWZFA1NTFoT3FNZHcv?=
 =?utf-8?B?cVFBMXVROFBOb01qM2QvNVdVTjA4S3F5VG8yN0tIYXNGYUU0SExYK05xdk9a?=
 =?utf-8?B?MVZPVXZMY1ROTmlobDVHbmhmQWxUMy9KVTBSZk1iVGdBYjVOMXQvdGE1SFRr?=
 =?utf-8?B?bnI3Ym5Bem1YVkRVbHdTZmFJQXJ0SXZaRXdxbWlEUHl1U3RudnZadVNUZkFZ?=
 =?utf-8?B?VUNQVGFpT0gzbzJPWTJldGRsZkNtQ21La1dPNVYvVWI5ZlhSbEZtWkxMZ2JJ?=
 =?utf-8?B?RGlDeE14WWt5WkUzcElzMUFldVlISm5Hb1JYa1loMzI2S3NMVFdTSURSRHRz?=
 =?utf-8?B?aDlNUHduYVF4UVFITFk5QUxBc3o4WHhSZWR3RmZNUUdwdXdCekt3ZnJvVVFW?=
 =?utf-8?B?SWpUQmVqN1B4T2RZTWEzRmZPeTFQOWlWek5mM1JFQ2ROVE1yY2g5V0ZQUWZ6?=
 =?utf-8?B?Sk5NMVliRFVpeGNMS1hnMHR6UmZCWGNLNDJYTVZpMTd2TkVLclFRUHFqUnJj?=
 =?utf-8?B?bGFEZnBOdjNpdUJoaGZ5QlRGcm4zdEoxanJKbVoyWCtzR0VRNGFwYmhxUjlI?=
 =?utf-8?B?aHFOTjdnRFJqZDZsODVDNDNwNUlnYjJGTVlSd3ZzQ2orZG9pTXl2cjVXZ2xU?=
 =?utf-8?B?ODljQm1LZDIvbXJrS1VNQzRqL0ZxdjVaeVdZTFhub2JwazFkT0ZPT3JPRjUv?=
 =?utf-8?B?WlY1RVZsSzZxUE00OTdVL0JsVWRTMGVUbERCblJDOUt0MVVMWjhqL1lWcm5w?=
 =?utf-8?B?YXVRQk9xc0ZjaUZsWTRHN3Y2WTU1SzhQcEQvTlVRUk1rR0k4dGpQc0VUdnBr?=
 =?utf-8?B?MjYwV1MyaVhrQ3pzRW83M1E1WkxIQ1AzTDdQVC9MM0tWM0NPeTFzREZyS1Qx?=
 =?utf-8?B?elQ5Uzd0Tzl2a0RMN09UejlWeE1NUjFSZTVkVUFIT0xmZHk2MjFPVHJlNzlz?=
 =?utf-8?B?ajJmYUU2SmtLOUcyakdmd050cHNweTJZc0NKVG1GZFUvY1RNRURLV1NqaW9G?=
 =?utf-8?B?U2Z0YVd6UDZHdmxKcHcxSC9DaElEaVdETlFnTXVOZVRNUTBhKzR4ZTA3UEE5?=
 =?utf-8?B?Nlk3SnZZWFdDNnBDUkxyZlhBSXhnQXFqakROaUtoTDJpTVFIdU0wL1VrL2hz?=
 =?utf-8?B?Z1hpK0xQYUVPbHk2dEQ3QWZQbjRmUFRtQnRjVUk1MWhIK01ZdG4wWVV5dWp6?=
 =?utf-8?B?d3hQaDJUNkR2SVJGMXIzZ0hsbEo1b1M1S2hxc3RiNHVZbTUvdWhobnIvNjMy?=
 =?utf-8?B?Y1IwcExydU5pODlXSWxoMWtGbXkrNzFWSmdTa0M4alNkNk8zMGNOZ1d0L2h3?=
 =?utf-8?B?RytPUElyZHJiOGkwaDIrQnRkRks1M2VDeSs1NGZhRWxMRkRPZWlxRWR1dnM5?=
 =?utf-8?B?c1ZWcjBVK25Nd0tUYi9HcmRXOG9PaDhBVE1MdU5nd2xycEluTDJHc2F0V2RT?=
 =?utf-8?B?MG5xazM1UFdpVGJ6VjJDbFF6aXJRWFgzdTkralQ2N0FxVisxWEk4RGVGaVdM?=
 =?utf-8?B?emhNTjhVb1VMM2hUKzg1aTh6TGRrc3FabXBZMWZJWHNEL0g4ZmJqT0hUZjhX?=
 =?utf-8?Q?USWLP+TCnoHWMo6fz7gXOHL9kbXksKmgR43nNn4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmNMQ3pjZW02TnZjNG1odjVvMFNLekFBSjdBbWMxZ3NLVmRTNUtMa2Z4OFF5?=
 =?utf-8?B?QnlvUXpDT1JrMThTd1hBb2xNNDgrN2I5Z01wZE5NbVIvQi9qQ21HQ09nVlhU?=
 =?utf-8?B?K2ZET0c5VnE1MDgzbDdnN3ZuVm5zV1pnaDFOQjI5aHg1ZWdTUzZGVm5wYTZo?=
 =?utf-8?B?amZTNlYzNFNpbS8wbHZWZ1BRQWFEeEJndjlzc1VXSDdrM2x5S1pHY3ZHYURs?=
 =?utf-8?B?RUE4bEJuS0FjNkFHWjJ4UVBkdDBPQ0xEalRNU1k3TEd5ZUVxWnN2ZzdwWjZO?=
 =?utf-8?B?aVJyZWdpMjJ6WmFac3ZPZ2JJL0xUWWxnWGlUcER3dDdQUVgyajdEeDBvMlkr?=
 =?utf-8?B?RnBPSHhlNE42UnluV1FtdWJhNmJXT1FsbXo3TUM3NEtEMHlBUHl1Qmlad1VE?=
 =?utf-8?B?bUJ3bUlraWtxYVZpT251NHN6aXI1aDcwTGNndGJGTEtmR0JPNjJvWU1RcmZx?=
 =?utf-8?B?VDlmSjRncnpQVFhrQjZmandtS3VNK1hCVWNZeGZzcTlSVjlPc20wazBVa1dW?=
 =?utf-8?B?QjlBUlRIdnkrRFZXd0pmWjJBVC9RRFNMdlV0cWhLdE94RXZ6MUcrRHFPbEhq?=
 =?utf-8?B?OUkzdzhRQXBNbnpQMWlpTlFhNUVLOVAwSUVsY1JGQ3ZkQ2p4a1VTanhrb3JT?=
 =?utf-8?B?b3ZsVzRYMFhOR05BdFYwaE9Edzd4cTRKNnI5b1UvRzNqR2FUWDNrNGJxdXFO?=
 =?utf-8?B?QUkzUFlhUjdPdW1OYzV0SUpmWUhUL2tpRHJuTVdYcG9ZVThod0NBV1dPZ2Nm?=
 =?utf-8?B?blZwMi9ja1NBN09sS1ZxakNsWDdtNUdxTmtDSmZXajBPY1F3ZHZMbDdHdVE2?=
 =?utf-8?B?dUZITDJheUs3UWVhc3dpb3VmOWI2WHlJaDlqVGVGRlNHYkxyVHBoTE5QR0Ir?=
 =?utf-8?B?Y1RZbDh0REFZaXpLOGMrMjZiY0dmZWdHNk9vQ3p3MERDTFNhL0JRT2lrdndJ?=
 =?utf-8?B?eG9OQ3JBOHZrQnFCN3EyRXpZUVpOR3pFWUJPclhqTzRBNE5vU21lUzBEVnEx?=
 =?utf-8?B?L0syQzE3Y2RhVkZlUTUyZ0sxYWJGelZEOEN0NUdRdUVZaWFFelNZbEZUcG53?=
 =?utf-8?B?SjB4bEhXdk9UcUQ1NnJkeXF6bkt6UWo4RzlLWlVDclVlT3FodEV0bkNBdEp5?=
 =?utf-8?B?YWpsYnZ4Nmt1TGNZaVBXTzg0L0RBekxFRTRvVGxyOS9nNG9nUS95aDF5bW1C?=
 =?utf-8?B?eVJRRmJVYUN5eDhZVGVPRWNnbWY5dExndGR6M2NZK2RoSmJzUU5HdEFIT2Zz?=
 =?utf-8?B?alJMWS82Y2ZlejdIeVZGVjlTTmY2dmJPUlpsa2NxblFJSFVSVy9sK2VTOHlW?=
 =?utf-8?B?QitwK0QvckxDSHZ3bHFMSElFbGFMN2hra25OQ1FoL1o2YThDY1ZpSTA1dVJD?=
 =?utf-8?B?Wml5STJEaE14dXF2cmVmUnIvMDA5bmFRNXFqcjRFVUo2MGprMWF0REMvSlhX?=
 =?utf-8?B?Y1R1VEdaZGg3ZXpkOHIrTENjQUQzQXAvZDNJa2FLOEdFYWtzT3RIZnBnNnRX?=
 =?utf-8?B?WGNQRlJWcVBITGNJUytCcDlxdkVoNm9mK1BmaExZU3JYM0lodjdjNDNSN1k3?=
 =?utf-8?B?ckNoVUFMYUpIWUdWdENNaVE3bnFiek9uektLVjFueFpMRStIYXErUEFyTWRG?=
 =?utf-8?B?OG1vQUNyQnVqaUhuYkZZUkZUSVdxQmNEdzlzL2Y3ZUlSODVEUmFYaVdiZTZL?=
 =?utf-8?B?TTUyZHhBcEIwTkpDbVRBYUJwZk15UUVvSnl2OFFNRFJEZVZCTjd4TklnVEFC?=
 =?utf-8?B?UXJIZWczNHY0endIeFFjV1Axek9KOVBNb2tEdnpsbHd0cW5MbUMxdmxSeG1n?=
 =?utf-8?B?TWErY0FFWjNkUGgrYk5WNFY2bkpqYXF2Z2dVdzFZZ1gwNWpScVl2bUhxR1FJ?=
 =?utf-8?B?aDFoUGdCbnF6OFcrMkdKVzY1eGx4eFJLUTFnL1NNbnpYb3J6azVMNkRFWWs0?=
 =?utf-8?B?dkZRcnNMVnY4Mlo0aVZ1NXFZSjl5NmlDdnhFU0kxbEJRUDFYNFBGOWNMQTQ4?=
 =?utf-8?B?Q3htM0c5emQ5SU9hbTE4YVlpSnFFaklTSURhNDNsQ1VyZEN1SlhDc0hYbTZH?=
 =?utf-8?B?UnVxMjdNWWxlSUl1WmVlU05EaEtuMTExWWxzaFZINldLT3BWeEV3bW9DR0Fj?=
 =?utf-8?Q?1CGgBB/zJIz/g1oILOk+kBz5w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8633ffc0-ef46-415e-2af3-08dc90735c64
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 15:20:32.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWMnUBKnOOOk2HD1XXamJyXH9y/2IY99ZQJw9BohNqjNpN5MoJ2CnwVH0hqPpfyQFwC4vCG2ruFay6Mvpv4MLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6360



On 6/19/2024 8:42 PM, Tom Lendacky wrote:
> On 6/19/24 01:06, Nikunj A. Dadhania wrote:
>> On 6/19/2024 2:57 AM, Tom Lendacky wrote:
>>> On 5/30/24 23:30, Nikunj A Dadhania wrote:
> 
>>
>> I have separated patch 6 and 7 for better code review and modular changes.
>>
>> The next patch simplifes this further to:
>>
>> static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
>> {
>> 	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
>> }
>>
>> static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>> {
>> 	if ((vmpck_id + 1) > VMPCK_MAX_NUM)
> 
> Ok, this still has the "+ 1" thing (and it should be >=, right?). How about:

For vmpck_id=3 which is valid, ((3 + 1) >= 4) will exit, which is not correct.

> 
> 	if (!(vmpck_id < VMPCK_MAX_NUM))
> 		return false;
> 

Sure, this is better.

> Just makes it easier to read for me, but if no one else has an issue,
> don't worry about it.

Thanks,
Nikunj

