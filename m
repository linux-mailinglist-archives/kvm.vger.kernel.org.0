Return-Path: <kvm+bounces-39609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C074DA485E3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 264F6188F70D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C4E24BBE5;
	Thu, 27 Feb 2025 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="43yO+aiy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322D81E51E7;
	Thu, 27 Feb 2025 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675095; cv=fail; b=uFbMe+JXcNUwc6mi3gMdYuF7Z78U6XAJyEZLnisgjrPSewOifOezpQc8RCS1XsllLtwe0rjJIrYUyLmcydURYajEq0NkW8aKXuts+znp+QaM1q3cto3zByzJYPG2+J2Ah+/sGPpYl7VWG19Zrgd1v9qV/PABxvwONRCerrt2sdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675095; c=relaxed/simple;
	bh=18bSMJAlrylk1r4qGBOxYxzk+i2VyGG1kiDKcbckln8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FCNXa7HWKcuNrIutBEa+Cm34psW7WrFzAiMgRgA3DUscBaYwU75iwIu9/F8rSTPrbk8xbEfeuGaSw4I72xD1UX3YP5MYWzdzDn+q/KIk9q/HAPFd93+uMfo+V8xqIdmvrFtpYtIs054+VcrgrTf0Yle3VhgGkiRiBl2xEmITZ5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=43yO+aiy; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BXhhKwMjvhMrexV9uoLDmc7bT2c3eGYhR7dZiLWwyvA3gIBZ1QlSJJBgz39NQ/JNLjZEmXceAOQobhMcdHy2AW/W4GSEbZWnAG0NupbnqpGWCJzpHgmn/v/sVofr+m3344VGK+grioSpNe9jfzrDgLCox/JNYmjBZQxPGgcDhqw8CAmyJx5wPpxJkJtsQ5qhZi+lN33jRdMOisJaAAbcMTovWU3H4lhqx+bWk0xVWh0hc0mSsA/C8IIK5W74zgOPyuqpcjkJ/JoJL2U4cqAd18BQgzjdRpTI6r6rNP1vemGz6aFx57+Y2n8VWeNa+a77WBHk0hFY/m6e9HUpJ4SBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgbinZAv79qHIYUMgjpWMBxjue0wy0PCG7HEOS9Y6/U=;
 b=pMxvaOXZyrJlDyhGF/iSvjLlzKJWtqTFbZzdNXW41YXmgR2FSrA+qeu9QodGAQDp5wgQ1TYyox08l4dHZXAte/9x6HQdIZ6Y0FZqECPncPD/Sv8rGv3NqGpBFhH8DynuvYC/C5yzhsj2c+ekkVK/MWMZiIOp5i0rTxWGOYNcmP4k6O9RcfBfXVrIQKPpAuIiH6SlW9HCGVW3hAaYAYLmG4u+zYrjt5iXqhviwMXxzBv0+BrbQokEidFvfdNcybFK623aSqMySB587cyNSfMI5x3azTlPrSor8eLh35qs1z9pUUOxfMRbQf3ApUfnqSEZ3kyvkWkzW52aEvEnN0tDbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgbinZAv79qHIYUMgjpWMBxjue0wy0PCG7HEOS9Y6/U=;
 b=43yO+aiypQ5l07f96OCV8faQFBlr1NKRwvUO8uafggfSkVvm/4iGCYaDAEMB2Iose/fVL8vs4OmlOsbc9zcCZgo6SjjxrKPPG7M41ozMhccM7wSJvRoKPd4N7+RoUOrYnfZuv+tWNZWjVmVb3aved85UU0Uv/OgreXMRWURFALk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SJ2PR12MB8036.namprd12.prod.outlook.com (2603:10b6:a03:4c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Thu, 27 Feb
 2025 16:51:31 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 16:51:30 +0000
Message-ID: <8e9b3db1-2b74-4db1-8daf-3b66b407ad9a@amd.com>
Date: Thu, 27 Feb 2025 17:51:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/10] KVM: SVM: Use guard(mutex) to simplify SNP AP
 Creation error handling
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250227012541.3234589-1-seanjc@google.com>
 <20250227012541.3234589-8-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250227012541.3234589-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::11) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SJ2PR12MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: b49f1faf-a686-4e6c-5229-08dd574efbc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SU5XNE1Wa0FnODVOQ0UyWnA0MHduSU9BejA3N2M2ZGppaFVyVUZOR1ZubVFa?=
 =?utf-8?B?VU8wNmFHL3RjZm9XTXFwOUdtZ0hEVWMycWhsWTl0QU5JaUVyUjI0WDRXWXda?=
 =?utf-8?B?RS96OUNnRk5PckNEdXJXYjZtdjlQS2h5UmtOcGFZeVFYUFdQZDVkRlNGcThN?=
 =?utf-8?B?WnhFaWI2YUhITGpSMll0TGQ0YkRpUjM3SUxIS0NERkxZS0NsTWdMRXVpUVNu?=
 =?utf-8?B?djRDRlJMVDZvZS85N2c4cSttMk9ZZXhhNld4MXU3MlhPU1ZyNGViM1gxR3o1?=
 =?utf-8?B?Ynp2cTNxQ1BobVQ1bDg0U01iaDVzUFQxQzRlVWZQVXlnMHphNTNvZG9RaXU3?=
 =?utf-8?B?VmJVRGEzcXJjeUxndzhJNWNUdVNmdzZsc0pKc2VSblozWE14ZXNYV0tKUlUy?=
 =?utf-8?B?U0pMZW8wS2VkUDloT1RYbGRpdEdNUk5JU0tHM2gzRDU4a1hvSk83ZnhWUmxB?=
 =?utf-8?B?QWtNSXdOaW9veDhOS1ZkeCtRNVE1SGE5RzVvemlKd2kwS2NGQXBSWDY3S3VB?=
 =?utf-8?B?bXZ1KzM3UGJxcDR2QUU1U1hSOFVxV09QQU9rQmhFRGd4WENpR0g1cEJjZmEz?=
 =?utf-8?B?SlhXT0tRTUkzNmZaWENRWnZ5YWJVeGxrM2JBUnUzMmd4ZWZjb2s2MC8wYlpD?=
 =?utf-8?B?VnMvZ3J0enc3TVl6eVJrc28wNkNHRnFSQmZSZnRCNnJvbWZ1L3B0SWc0a2Zv?=
 =?utf-8?B?N2tiSS83aU1Cb1BMUXA3YlAwRitkZ1Nva1Mzd0U2S0p6UURnQXFTNjQ1QUMx?=
 =?utf-8?B?bG01b2NTNkFWZ3Btc3FQQU5yU0ZUYi9pRFg0ZUszenhaQnR1bjVOS1JUMW1B?=
 =?utf-8?B?U3VQaFdaT1RrWTYwYnhRUnZJeERaOFExT1Q4aHNnUk5hVTlnVG82SUJnSjdM?=
 =?utf-8?B?cjBTcGJjd1FMQjRQemgrWkJGeFNDZFBhanhjVGhKdWt0K0lOWGlBMEFqZWdE?=
 =?utf-8?B?bkNOZXo5WGZJSTRrVVJja0VQYjBlajNtOUVQTjdNK0tTY1doY1k3VHhCRVYy?=
 =?utf-8?B?SUVTOTJXWnRCRGFlb1hpVDhyYjZrREFKclpHbzdVS2tQVzgyK1BUQmdrQUNK?=
 =?utf-8?B?NG9tOXhDcHZDYTJVVGphZVFwM1JlME5Cc2E4U21JSUFVeE4rVjkrK0pRZng0?=
 =?utf-8?B?d01haVlzZkpPblBKODNVN25tUHQ3UXUwL21DaGJNK3U2ZlhWQlVuV0pnRHJP?=
 =?utf-8?B?T3BmMmZkdkZhRlp5TzYxNWx1WGZmUHhwQmZqSmpSU2syV2Vack9NOTRMVkp1?=
 =?utf-8?B?YjdaTUtVNnVmYThuOXoxN0Ftb011NXVic3kwOEJocU1jRERPSW9wd242M0sz?=
 =?utf-8?B?L0ZHMWVUQzBJVWpHcTFCMFZlZVRHVTdCeGRoTDVuRSs5Qk9KTFZiYzJiVEpu?=
 =?utf-8?B?NGFFbVpyVGoxZHN4OXA0MmRUdlRqYUlnaTgwVDYzNlRldnE1VmwwM2dPWCtq?=
 =?utf-8?B?S3NlVVhIaVNxeFVPSXc2aGJ6RXFEUEtET2VMT1BMS0NCcHN5U1JobE9aVkNi?=
 =?utf-8?B?RVJGM0pHeThGdEN3UXN4QkJOLzV0Z21CckM3QzVSenBQVUMzQ2RsVm9mZ1I2?=
 =?utf-8?B?TUVmaGhvVUprbWtwOGFhZEpkQWc3ZUVlMy91c1lpcUJSckVyL2hibjYxQ3lq?=
 =?utf-8?B?blh2MHFuaUFTNGswOWZRUVVqZzNmM3ZUc2pNMERqVTRMQVBQQmZUTVAyZWwr?=
 =?utf-8?B?OXFPbzQ5bFdwcDBGd09tRUF5Wk9aMWFlL1RaYjkvdHhWMUx1UXJOaGFlMTVo?=
 =?utf-8?B?eTJKSlpvK04rS3ZoaXVRTitHWHg1TVRXd2xSdjZ3aFFXSWJvN3ZDZTNuWWwz?=
 =?utf-8?B?YmZmVS9pd0hxalpRNDRNY093YmhvenJOZ2ZiZTRhTFhNSGlLN25RQjhBS0Fo?=
 =?utf-8?Q?zYSVgW0JHNjba?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjhOcjBEM3NhRXUzanBVN0xzZWZUa0RjckhIYnJjdnAyNitGNU9UUWdlbHVV?=
 =?utf-8?B?Q3NlZUlQNlZZS1NoYUJYQ2VJTllLQ09vYjVEN3JvcDNzZzA5cUlKYkRUL1Nx?=
 =?utf-8?B?VHNUSnhHU2NvcExxRndMeWZ2THcrS2JWSFhrUmJ1TjlwcFlMcnU3QlZ5N0hu?=
 =?utf-8?B?M1ZQRWx5WWNsSWRVdGgxZzdCWkp6RzJwRlBUd2dENEt3NGdrcytwSWlOdEhx?=
 =?utf-8?B?WmhjbmtmdlhOcTdGM1hBSEExTzhtdlRNY3pJbjI5Y3RQVFFKaVdzMmJkSmQy?=
 =?utf-8?B?NGdNMkVubVRNbnRUeUpQUWJ4YzkwSm42ZWtDVWVJb2lEOHNiWmFjaXpiWFEy?=
 =?utf-8?B?bEFPckNpVG1EV3BEbGhyUUFueEJRcGdaNXFDTnFXZW9ZUDRQMVl1YTM3WDd2?=
 =?utf-8?B?djNYeVI2anpGK1RlM1JSalJ0dDAzcXpLNDZYR1UvL2JjRFRZclgxNnZMSC9q?=
 =?utf-8?B?eWVHeWRxRHB3R1NsQUwzQ29wSUNOS1lZWUdZcmN3MXFibm8wUEdRZFIwKzhy?=
 =?utf-8?B?NWNTZU9FanhxRkJNN2dJNTEzczRHT0ZRZUlUM1dLL2I5bTZ6NUR4RGZRdHNL?=
 =?utf-8?B?SkhYU2xza0tKS1pIVVRLeGlOekxHUXVVTGFRcURib2J2RTlTZjkyZVZQamJY?=
 =?utf-8?B?Ti9XS1ZKSlpTNy9ueFU2UjdSVDc2L2NTL2NNdFpPWnlzYW1oZWxjK1p1a0hw?=
 =?utf-8?B?TFhnY29HbkJUNzM2S1JIYkhzMFl2OXBlb2s2UThvSDFGUWIrMkdLVlo4NU9C?=
 =?utf-8?B?dmFYMUx6TnBKRFB5cWNGcjQwQTJDcVQvRk9OSlY2WXRkK3RkbWYyMk9VRzVs?=
 =?utf-8?B?MHJ1QXhNN0pCNVVJSHc1L2FtcmVvMkduTUpTMTh0d0lIdldKQWpYbUFBVnNj?=
 =?utf-8?B?NE1IOE1SU1VyNEVOUHg1aHp1QWdMc3IxNm05bnBMVUZ4V2E4Tk5LQi9RTXJZ?=
 =?utf-8?B?TFR6K1J1K2pqMFpkVklvdnhRUWIyVklvbG1INzBVNlNxb1VQOG5MaFJHcFN6?=
 =?utf-8?B?UGZqMk1tUXhUM2p4Yjc4MFhQYjQyc1hmTUI4Z3JJRFJkN2plTlIyNWRRQVZS?=
 =?utf-8?B?eFR3RFR6MTB5TkMxak9SQUVXZ3pWV3ljT2gwak1zejFqY0g0UmZwQkpmUmlF?=
 =?utf-8?B?NjZEbEpsVm41dWdBamVCbVhyTDhJdVJPMityZlBHT2Y0djJMcDNsK05oeGl0?=
 =?utf-8?B?eXlYZVRSTUFiUGxIeU1pTWtIOS9KemRlb0UydE1JTGFKWUpKMXc4b1ROdWV4?=
 =?utf-8?B?L0R1WElZWGlLK2xqVmxFeml4WGZmNk1QME1odlBmSkVNK0JCSUE4aXoxVzE2?=
 =?utf-8?B?QW9KRlpUN3Q2eWt3a3hLL2ZHVFlyeEdJd1BQYnhxT3poZVZ5WnRtdG9Rd0J2?=
 =?utf-8?B?cTA1Y1lvcHdkYlVQcjZjMkZuTi90b0NrelJSMXZLT2xTcGdTVnN3ekN1OWQ0?=
 =?utf-8?B?a3F3T1ZtMmsybEZxNUZkdUJGbGMxcXFicjhqY0tOOXRmTGZUQnkvcHphK2dD?=
 =?utf-8?B?R1UrR0RPMDg2d1BqSEkrN1NUSXBITkdFRDd6VzMzKytOWFcvclF1S2FZcHJt?=
 =?utf-8?B?QitrQXZsZTJjN3FKUkVFZUhQbDlmM3k3MzlDU2tEOGZMa0NnanBjMXdGSVNS?=
 =?utf-8?B?YU1rM3E4KzRmQzlMTEsrajVhTGRYNXI0R01RdlNXQkJDbEhCWXlRNnQvcWN6?=
 =?utf-8?B?bVNZVmU5dEdzeUlwbWdMTGgzUWd4WFdmOWhoYU10NEhZMDN6MlNlYktjNHBZ?=
 =?utf-8?B?ZThlZmhmQWtsZmQ0M0ZaeUlhZWlYK0JzcHhudmFOQWxpWWNxKzJtMWdmNzBm?=
 =?utf-8?B?aG1sc2R4MC8yQU5NQzdzeXpaS0x1SnFWK3EyYkZDREhBTjBReGZUaG9BYkF3?=
 =?utf-8?B?YjdicUM1b3gxSE9TcjZNK21ndlFpZDVlNVI5em5hTVUvbkxVUHhHRFQ1TGNQ?=
 =?utf-8?B?ZHVGNzIxbnI0NmhFUGR3UFBtQzZYeGlyZWhJL0lhZGVuTkJEakNqbjJCUnNj?=
 =?utf-8?B?WC9yaXkrNVFWOHZZUjhkb0ltUGFkU2tVMFVjZHFRMUg4N1V3S3VCUFArU25C?=
 =?utf-8?B?aTRTNnAzWUI5QTJCL1lIOHoySG1QWkYrSG95V2JSUUdWZkhUUXV6T05Majhx?=
 =?utf-8?Q?9NpHtPSxhna3rnNMNRYMMkvHH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49f1faf-a686-4e6c-5229-08dd574efbc2
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 16:51:30.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKHacFlxtuVO+4y4OhDS8Va2GnrRQ5LzAEhxYApk1f2xaHvmm6bXklmDP77xMQxTw+nUs0PXwWUKjl/4ILF3Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8036

On 2/27/2025 2:25 AM, Sean Christopherson wrote:
> Use guard(mutex) in sev_snp_ap_creation() and modify the error paths to
> return directly instead of jumping to a common exit point.
> 
> No functional change intended.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 22 ++++++----------------
>   1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ccac840ee7be..dd9511a2254b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3938,7 +3938,6 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   	struct vcpu_svm *target_svm;
>   	unsigned int request;
>   	unsigned int apic_id;
> -	int ret;
>   
>   	request = lower_32_bits(svm->vmcb->control.exit_info_1);
>   	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
> @@ -3951,11 +3950,9 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   		return -EINVAL;
>   	}
>   
> -	ret = 0;
> -
>   	target_svm = to_svm(target_vcpu);
>   
> -	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
> +	guard(mutex)(&target_svm->sev_es.snp_vmsa_mutex);
>   
>   	switch (request) {
>   	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> @@ -3963,15 +3960,13 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
>   			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
>   				    vcpu->arch.regs[VCPU_REGS_RAX], sev->vmsa_features);
> -			ret = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>   		}
>   
>   		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
>   			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
>   				    svm->vmcb->control.exit_info_2);
> -			ret = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>   		}
>   
>   		/*
> @@ -3985,8 +3980,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   			vcpu_unimpl(vcpu,
>   				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
>   				    svm->vmcb->control.exit_info_2);
> -			ret = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>   		}
>   
>   		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
> @@ -3997,8 +3991,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   	default:
>   		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
>   			    request);
> -		ret = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>   	}
>   
>   	target_svm->sev_es.snp_ap_waiting_for_reset = true;
> @@ -4012,10 +4005,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>   		kvm_vcpu_kick(target_vcpu);
>   	}
>   
> -out:
> -	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
> -
> -	return ret;
> +	return 0;
>   }
>   
>   static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)


