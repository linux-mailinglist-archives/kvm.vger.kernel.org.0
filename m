Return-Path: <kvm+bounces-41540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DBCA69F5D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 06:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9EAB189E216
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 05:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C5F1E5734;
	Thu, 20 Mar 2025 05:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A+sZvOjb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3671DE3A8;
	Thu, 20 Mar 2025 05:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742448883; cv=fail; b=cPD4sN2KcXJUMXmZgx6elp6UVKyT7vgTMJQje3h9fB7iwXCB/ws753okCm/KZY1iTVx9JAh/c2BzQYAhBRtR3DHaE1gIZlszlss/uX0Mie/6vopMbb/7C12cdUE6iiGd8zwhAII2kQSGmN/D1Skz0KM87BHN5eYSlhxZlp4JsRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742448883; c=relaxed/simple;
	bh=w2fYFYyCph0huuTBuIvANv9XqTa83RNHkOO9g1srgSw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l6GHE3Ks8aoYMgQ2BRH6kBYfGT5k7RER3yLKikEw7xWrnj9AplKwUfxFOme1fDhNKuiOR/O5wOhn3kneKPDU3nBdwhdkYHIQwT7gSWTlgTalb4sdPMGt7fm8ukTqw0a3BROYw/enTgwq/qvqm+dqmWr4DvO3YuouGLcu3xJpRt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A+sZvOjb; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=up8IlvMGVSKZOuCyH5aCqHwGizu6Vtehd2szw5rLz4vqvC62GfTYXGqOFlvCNfnMxGcIo+3RR1Bvv6/aFjfhhauGkZYxBlB3EneEchG8D5KS7UPVzvJu/DkBzwKykO7ie9A+FxfeqFRmJ7OFqDDWcPGBjjD8UYMSSkkfyOP5ge99ShbtBUTsDw1K4W16+sP0sqF+iXI1AseQoPh3UTMzUPe8ocz3cnP6TvukbijRlE42M0FzMAsX1CabSdNkOpBZdftf0cg0uc5GvBIExnR2BFew8g/Z90w5jX+VwU0fORXTRSTjOpd8Up397tIdvXgF7UFul9qZvI6Md62vZOD8Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOZwjOmiqDJJ2srqH9lnYey3x7XaBNktqWlfkalEK4E=;
 b=IrEEpKYTXiHY56bFJv84oDW7IwQFE64tQbV+W2r9/KDI81LGNRvgNFGVSQSJ/bB4mLZ8KK61oWjz/xXMinLmoKG9imXLT69DvXL8+vVVtrW0kdpQ0tu5qZTTB5mXSqqID014HuDtjU9/w+2dBgf6J4WXXJWnTwcCCSB4jrPdw0Oc1fCh6p2WsavadlR3/dm1ikBeUB4WXXObUdPnoUK90q0v4lzyrdlcLqng9lvg0fRTYSOpTma18lCEN5vaWIOBFNGPa7baXF2x0q4LWNi2hKbBRFl+pWmdLDg6q1zGpR5XITtqKP/W3s4rWli+brJDo2piv/QAHQismiRlVK3VGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOZwjOmiqDJJ2srqH9lnYey3x7XaBNktqWlfkalEK4E=;
 b=A+sZvOjbuagTH9Zp439qp4SAGoqqMrD8tLk4OKoYpTMVXX9xmSQkHUlmn9nruJlaJZtXLYhFDqhYgrWOqaPlSp0ChXxTs/lqUiBVW0f0tVnLmGZvJbHqxI6zO3C2spNdtRuDEqCQETVPXRAhvI04tXNKW04i/We5huMF8SBiHbk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB7377.namprd12.prod.outlook.com (2603:10b6:510:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Thu, 20 Mar
 2025 05:34:37 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8534.031; Thu, 20 Mar 2025
 05:34:37 +0000
Message-ID: <aac3b9ab-8dbf-424e-856a-d02135323c8b@amd.com>
Date: Thu, 20 Mar 2025 11:04:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] KVM: SVM: Add support for 4096 vcpus with x2AVIC
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <cover.1740036492.git.naveen@kernel.org>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <cover.1740036492.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0174.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::15) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB7377:EE_
X-MS-Office365-Filtering-Correlation-Id: c45f4195-a247-468b-42ef-08dd6770e707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUZaRzNOVVdXSUFpb01OUklJakZJZC92MXVNUDFyTDYrd2JnNTQxd05qYlg3?=
 =?utf-8?B?RkdrYWNVTUNtejdSdUd2NGRXMmdPYzJ6N0ZWOFNEeUN6bG1uenF0ZEc5d2VX?=
 =?utf-8?B?RkV2UDNSRFRUK29VYm1USnFXNFUxbVRteVFxNVlPMU1QOUJ3cnNOSG1jYjMx?=
 =?utf-8?B?aWM5aTVrYjBDcHdqMVpBZUpoRGZ0QVpMTks1NUVJUHQ5ME9GRkN1SVdsSDBv?=
 =?utf-8?B?b2RNa0JPc3NWMVljMDcySFRBS004cWpQQjNKRStseHc2OHNRT2IzZUJNayt1?=
 =?utf-8?B?SlduQnU2cDZBb1JITlZPdGdDNy9FWnZGdzhpeWlWSjdnSDRsdUt0VTZUcmpO?=
 =?utf-8?B?S25wOThIaTlzNm5BcHM1WWhxNDE0d0xFdWtIR2dlR25uS1J5eWxIUnBkTVkw?=
 =?utf-8?B?OSt1cWY4SUhWSW1VNmpPa2puMnZOcGZkN09QWFZydWZFYkE0RUhBZDBNb3Ru?=
 =?utf-8?B?YmNqK1lsbW9YNzVLbm9YMHNjVTdHRjNicVByQW5VejBGSm9YOTJjTXFDMzRs?=
 =?utf-8?B?NkNpTUg4RkFaeEo0bEt2akQyakk4NUZyMnJOaW9CTUxZZFlIVzZVMHVYTHZE?=
 =?utf-8?B?cjVxOTBBWEFDSFhLcm9hNUFHdVlaTUNUYVN5R2R5VUdEY3pzOGJBa1JJMmJE?=
 =?utf-8?B?Yml0STRaam53cHo1cVJROHFiM0NTcUhNb1V6L1pacnR1bE11L3ZoWWpOSnZj?=
 =?utf-8?B?YzZjSnMxR3RWRnlWYVpVVkZ4WXlzYUVoaE9xUU5TdFdZSi9rbnJUZVMvMTdu?=
 =?utf-8?B?a25scUpTRy94bG1FWTZTMzNqcG1KVnRJb1RvR2J6SFpJam1xNXdhbG1qRldt?=
 =?utf-8?B?bldpSitkbGE5ZmQxUjBsc1Z6NTVzaGZSU0thRmlHM1gxSlhCS2VxdmJ0eGcr?=
 =?utf-8?B?UUE3elZhTHlTSlZzQ0ZrbjhaVk00ZXhTQlAxNWRJd2JUZUtKSTNCYks5K0FQ?=
 =?utf-8?B?K1VRTHlYaWZEc0NLRVR0SGV3TzdhaHFrcG8vZGVaYXBMRGg1TXJxRmcyRkkr?=
 =?utf-8?B?ZysvM3hVcE9vTThLZERnRDg0ei9Ec3RtSUpLdncwc1hpN0ZFNUlXTTB3ZFdn?=
 =?utf-8?B?U3lGM21GY3EzZStuaW9EYkRCWkdvZEJKbHBwejNyZitnZ0p5a29vSVJXMEg4?=
 =?utf-8?B?TlZMTjFVekFzMEdRZE9jS0VDQTg4NUZxcjl1QTBCZzIzNFlOaVN5TVMzT1lv?=
 =?utf-8?B?NTlyOFFGTWNzMHgyd2RhSGpKSUFzbDdLVEZEYVZEcUFxa0UraU5EaW5Lem1k?=
 =?utf-8?B?VE1MRFZ2MzBKcGJvTWQxd3FzK0pVM0lvY1pXS1F6RTdVQ0xGNTVpYnpmaEFn?=
 =?utf-8?B?Ykt6N3NzT3RQUVlVUmFDb295enNRaUQxWTVob1E5clJnemFiTFJwUGNkNTl0?=
 =?utf-8?B?Y2NqcVV0WGVQWjJ0TUNXYnR3WFhJbk1RZW1CMnNGN2RtSjZXWTN5eUhRaXdt?=
 =?utf-8?B?dk9tRXdoVFhLRlN3VVRYc3A2OEQxRUJuMlZJYTJjTlpKU2lWaS9SQUtkdlFU?=
 =?utf-8?B?RTNnRFpSRU1WVnQxVWwrLzlma3BFeFVabmd3M1RwaVpQbko1blhTK0JoRWkw?=
 =?utf-8?B?TUxLemtId2oreHpRQ3VYR09yejdZSUNneVNNRzlHVjJublU3R2VuZm45Tyt5?=
 =?utf-8?B?Vi9hViszK0pJZm5uWlhxc0dsWjhibGZvbzJycVVKbEczdFpTd25EdmppQlRV?=
 =?utf-8?B?MG5Jd2VFMFBaeFowbHlBUStWYloxRDRnNnMrVDk0dndrVkt6YUR3cURJckdy?=
 =?utf-8?B?WUNXSDZqbHQwZHpZaWJwcjRUUWhxZmpzWGZpejB5NGtSMFlWSXVKcm1tSWQx?=
 =?utf-8?B?T1hKNElwMlN1NHQ2Zjc5NGJCdjN6RnY4U0pYMXI5eEJ5eEY2UkY3UVpiNmVR?=
 =?utf-8?Q?NSP47TDfF4do9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXFSTjczWXVFZFNqaGJncW9hZHE3NGUrWW41QjVPMjZNWnFtbjdoUmhycmRP?=
 =?utf-8?B?SkVYUW5NZ3ZSd29ibytXWnlxSmppNWVHQVIwbm9NejhZTlJuL2FIcDBLOEJy?=
 =?utf-8?B?TjJEaUd1TlhiVmVPZGJnRk5WS2srb21SdjAvUm5TV1pOVkxvOFh4dEZTa1p6?=
 =?utf-8?B?eXJ4UkZxWEEzekFPeVV1dG1hdEx1ZTA5Nlg5OGFDOE9RVFV0RFptTHFsWGFw?=
 =?utf-8?B?U2lhbFozV05FZWpuejZXV1dBMzhZUUpNb2NmdlU1ZkRYVldQaUdQZUo0U3J3?=
 =?utf-8?B?MUFWZHFIa1FFRkczZHdyUGpNMW5IcTBvdzJjMUlFeWdYdUp6ZXRId0srTFRQ?=
 =?utf-8?B?Z1BTazIyZFB4SHpOK0wzTVRlVzMzZnlIcVRrcktSUnFMQjB4eWo2aGR0QWZz?=
 =?utf-8?B?KzJXeEFxMUFqcHN2d0ptakM3UzdScnRPbVJNckp2am9zZ0c5ZmRYTGIyTFBj?=
 =?utf-8?B?a0tNUlZ5WWgvMVFOMTBVOGR5allJTXg2eHdjdUR6em9OeXFkVlJ5aXJrYW9t?=
 =?utf-8?B?WjM2d1UvWldXU1VXYjg3TEl3KzVJdzBMZE5DdVk1MXYvWHZPMnA4bXYyNkFs?=
 =?utf-8?B?MmtUaStFVTFzci9YMlRleWtJTWJxaHE4OHpTc2pnSXF6VURWOElKU2NwRk5W?=
 =?utf-8?B?eHdjZVVqNkFGVnBEeXovaUVKL0lKb05Va0hHdnZ5U1I2OG02ckxDaWU0U0o5?=
 =?utf-8?B?UzMvVnZXYTErWUpxVStDb3BZdEh5UVkwcURMYWc1ckNDZk1uLzdzbVVMZTEy?=
 =?utf-8?B?TUZmbWRvYXJLNzhRUHpWU3FWaldyajFER0htQVdFOUdITU5DZEJIM0ZHeGVJ?=
 =?utf-8?B?ek5JbWZzUXJwNUVGUkVwVmozYkRBZFdZcFBMZ3ZML1I0VEs4dkErT3NsVVMx?=
 =?utf-8?B?ODBFQmphYUJPdlYxUXJ3WGRMaVNqZXZ1ZWJRQTZ1SUVnR05IVTVuQW01ajhk?=
 =?utf-8?B?R3A1YjhBU0tTQnR5V3J1Y0pZZ0ZoM2ZHY0k0cmE4dHVFUjFHYy9MQ2NUcWlw?=
 =?utf-8?B?RG9QWFNkUElDQ2FCdy9uamdtOFlySHM5Y1loU0xZVlBZQ1BGbUtYVGtSQ09j?=
 =?utf-8?B?UUN0dzd2OEM2dDA2RGhqNzUxN2tTc2VPNzZvRTJHMnVwT25UbjdybDNsNE1D?=
 =?utf-8?B?WEI3ZlVFZlFJVU1PcW5sZEptYlNrOFE5ODVoNDFFTllEK2lJS08xNWJvRTRt?=
 =?utf-8?B?QzBQdjRhMGxsZ3BTdUgrV2ZNUmtXMVJZRGhyWmZ1MkxDdE9nNk9XdzlnUTh0?=
 =?utf-8?B?STdCZVNTWjc0OU15TzZkS0VUTzNEMERoOW9vUVBkUG1sblpEdUxJd1hKN3NT?=
 =?utf-8?B?TGZqdEtHOXJwTGYxMmRxM0JYcUNpL2g3ZXlIMFNNQTRlQzFOSWJmb3hLYzl5?=
 =?utf-8?B?ZDgzdnpIV2p5YVlDTmNKcCtkVkdvMHJiNVY5WTN6L092OTJnTHplZnQ5VGRw?=
 =?utf-8?B?eWRNRmRjbUVYcmlna2ZRMkdFOVo0enhWZFBpcHo2Z2lQd1VpN2gwVW5CM0tH?=
 =?utf-8?B?bGpadnhUbkxNWTV6ZFEyTG9TRUZSZFhRRlliSkdsVHlIclJId1RpRWRGMUc1?=
 =?utf-8?B?ODFDOE5vZW9NU0E4VFBGMTYyMW1jaHlpSmNTYmQ1V3BhTWc2T05QMkFQL0pZ?=
 =?utf-8?B?TFZ0aDVXZktKT2x4ZC9CMFRzNmEwbGZFMXNRdVdtbUNsNjRveTUzck9zQTE5?=
 =?utf-8?B?c0M3YzNZMGl5bFh6UUY3SkRDYmM4bkFTcHdScmFYd1Bqb2hqc250eXZOTUlp?=
 =?utf-8?B?YldXZnF0V0o1TUNKSkxycWN0ckMwZzcxRWxxaUdybHgvME9XVmE4Njg3LzZC?=
 =?utf-8?B?Ry9ibTZrVyt4c3oxelpYRDZUSXZ5TDVPOHlSUVhhMTlIOGVaU0hrVE5iZ3gw?=
 =?utf-8?B?TGppYk1RdnlzTm9RL0NTZEhiSEdUVUJwQ2JEeENaRnFoVFNsYnVnMXJOL3ph?=
 =?utf-8?B?TytvTWVST041VHpIK1VoazRWdHR4dHhmR1A5VTB1eVYrcEpBb3RkTm5PTW1W?=
 =?utf-8?B?K3NucG53czVOdnAvODNRa2dzZUwzMjR0OVY3TFJuNTJzK1FodjJYczlnbGQ3?=
 =?utf-8?B?RnpidnAwY2lMY3grTnZtdmphNWhQcDhRMVY1dTFWMkwyRVZ3RmNnbEY5Mjl4?=
 =?utf-8?Q?xur0u5NJjArbes7oMMXcgEPpy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45f4195-a247-468b-42ef-08dd6770e707
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 05:34:37.0894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGztK/TxoB8Pfnjd9fnBncLuCKjvKOJ2JQLdYZMFVWlQyquX4xYcp7Nk3atxNP4yaqGCKKLKE0caOOQoFgfJ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7377

On 2/20/2025 1:08 PM, Naveen N Rao (AMD) wrote:
> This is v3 of the series posted at:
> http://lkml.kernel.org/r/cover.1738563890.git.naveen@kernel.org
> 
> The first patch adds support for up to 4096 vcpus with x2AVIC, while the 
> second patch limits the value that is programmed into 
> AVIC_PHYSICAL_MAX_INDEX in the VMCB based on the max APIC ID indicated 
> by the VMM.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


