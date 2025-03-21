Return-Path: <kvm+bounces-41694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE6FA6C0C2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD374468415
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6089622D780;
	Fri, 21 Mar 2025 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u+GcJPyK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA781C84CE;
	Fri, 21 Mar 2025 17:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576418; cv=fail; b=lA7vYKWK/mtv80TO3f8SAP7uF0XEhbmhU3AOaJXo/FyB1e3LMeiiMFe2c/2fp48f2WfGF+vE/W1T2ZeenRexI8yME355m2g+mu+3eZrtgdxcaUPpcUeUraKzDlrnyR80Jezo/E0GT4lv/hFyDqaenZjBalHKzMV7in3O/Rh7VXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576418; c=relaxed/simple;
	bh=Fj8RlHSesQDwSmEd+truOy3zxcvdPoNaxLgIfi+Oj3Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FPeSpE72iBbV2YP1ILaxTrg9UjyKiUyFGJM/da8pDBiiCc43o0Ud0y7D5rN+FycvVrFc9fheLKiiABLKJD1I+EqepbvIa9j4ObF4z8XUjx2tETs6Cz11igEXAylHTJV8rXEE0AlAxgyr9tjtmPTAfcHBR0SyjDVIWrS4YWOiuL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u+GcJPyK; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAaHllJuaDY2qVWAsBiGLcfUfSO2N9sQnBOc34GSU2ojCb/+10A2hJPY5T9qYLL4HhMBSqxxCwUm/nScb5oRQfmWuER+QUN+Qzg0YlOQ2r1wP1LYwzG1U08ePFVh9oyw6aZr8fu7qfZPbWlu/R1rb2oCUFoN6r+OFut65BHAWvnq/O9x5QONcHZs1wsBgBgwGz+v3K8kWz8jDMjRIb9djD2icg87bSatlXVgKr5JDQud+uK566QZ9nrccOKlfVytoGlLybX8F1QZ1vaLgsGNLDPkhBcUjINthLmE5Qwq+MDjWQEeklAuat76xbnF+/+0wiUKpQOdvYXX8WEPbhPSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJAybqN6X8/eMkkOFjUp3r9/zC/vRT2TjwaSI7d79Kc=;
 b=sclYGdcJoPIAmyD0wU9KxZIKTtMUu8n9dIkoT4ZNVk7e+2k1rBReED823CfFtnMLVCpsazVIEzntZTz908q6Rzdi2/PoZnqzkTXTR+bEhUkv1RC5E0FzoF7BuIEDcNVcP37hDY35erQ3ts/nDioFd8lcz/PxPhTRHXird9gME3RS19qW/QLfNQtnjJK8g7AtX744/TFQgw/smmHjGSnR7AkMtXnZiqrQHtHL+CYh7KckI9hSVNVIy2YGvWipyrL5htleWlXLAzV7OM0Xokud0cf/5sM7pMrafG4PUaYaFduA7hxg+5CuEL/QbRL97o1QbdLFEDzYRqR4qhtVlrdtdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJAybqN6X8/eMkkOFjUp3r9/zC/vRT2TjwaSI7d79Kc=;
 b=u+GcJPyKg5CqOkuepM2ldGSfvpgl53Dr3r+BpAe4LtgKrGbdk2DeYtCA7YJ/Cf15OqyeEnWGsY5Fw8kccTzogWQLPmBsRRn63jho/gSdDkpGoazrhYblwy5JWUrSJzHcijGgsSdBNs/5MaIiAcsdM2b3wRCt0b2wZ/NvrNjydpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB9126.namprd12.prod.outlook.com (2603:10b6:510:2f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Fri, 21 Mar
 2025 17:00:12 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 17:00:12 +0000
Message-ID: <a4b25253-bdde-47d5-bcc2-648d7a9c62fd@amd.com>
Date: Fri, 21 Mar 2025 22:30:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 02/17] x86/apic: Initialize Secure AVIC APIC backing page
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: David.Kaplan@amd.com, Santosh.Shukla@amd.com,
 Suravee.Suthikulpanit@amd.com, Thomas.Lendacky@amd.com,
 Vasant.Hegde@amd.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, huibo.wang@amd.com, kirill.shutemov@linux.intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
 naveen.rao@amd.com, nikunj@amd.com, pbonzini@redhat.com,
 peterz@infradead.org, seanjc@google.com, tglx@linutronix.de, x86@kernel.org
References: <e5f0ffa362ef8731a61c03882738956bb9f4c13b.camel@gmail.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <e5f0ffa362ef8731a61c03882738956bb9f4c13b.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: JH0PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:990:4::15) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB9126:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b520953-304b-4197-4dab-08dd6899d7c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WThhdEUxVnM3M0pyeDVnckdKd2F2S2pETlVTcVFJblA2YXhEQ1RVTHJ2ZHBk?=
 =?utf-8?B?a0NCbm9rN2Y4aWZNbGNPRG1ZbHNLUWNSMVk1di9adjlBWEFTcWhlVFpmTTNN?=
 =?utf-8?B?Qnk0cTlHa0FYeFhxaTlhdFN5a3dmaCtIelc1akhhbGYwdExUL29DNnhURE9E?=
 =?utf-8?B?bm1WU2tZUG9qQS9yQXgrdU40OE5oc0pBUkp3ZWtpWm9tMlQ0TGpPeXZVOFpv?=
 =?utf-8?B?WVdUS3BzaTNiMlNzRTRwUHJXK2VZRGhabXJoVmdDdC9pc1FDMjRkMExMK2tV?=
 =?utf-8?B?bHZZQStzaG9UWGpWRnJ3cFczVlVBVUcyeDNTZzBSVFdFUFNVSXM3Q0tsWUpo?=
 =?utf-8?B?TWpaYVJzYmlFMXVDaFVHZVhPTk1ucGliYkhBSE1GWEI1Q3NQaWtRTG5EUEdP?=
 =?utf-8?B?c2JQRkpaejNQaTdNQkpBYjM1ZjljeHZ2VDJtTE1mRmRKNDJiQktEZUp6Q1dr?=
 =?utf-8?B?NUdXaVowRlpwK1RBd0YzKzYxMjFjb0dNSFJTSnY2UE9qVTR0T2lVYk9Md2RZ?=
 =?utf-8?B?bFVYRXJ5N3l2YnNMei9SQkw0TnJPOVVZa3FENGE2aTR1YkVHSzRmVUd4NWsy?=
 =?utf-8?B?UmJYTDBtUnFGNUFnR2x2MC9JSTM5VExxMllRc3NENEhCL0xWNzV0bjhGa0Nj?=
 =?utf-8?B?bFp1UHNKaWNsZ2EyeDVXUDZBQWpFMHdHRS9JZ244Z3RtTThVdzNZUmRma0M0?=
 =?utf-8?B?THNtTUdGdEVQUGIvMnFCNXdmelFESmUvYnJkSmFWWi9xZzFvWjNsemRqNTY5?=
 =?utf-8?B?djd1aEhjT3d5cnVtSTBOWlh4Snp3TklOSGM4SlNQdE1mNkc0TU9UN2w4a2Rv?=
 =?utf-8?B?cjRJc1paOEdRdXN6R3UwWWozZFdXSTJuQjBzbkhLcE9EMDNveWxXVTNoRi9s?=
 =?utf-8?B?NDB3SXl4S0VJKzF0amlkT1Q1RVk0cy9oUEUxeEV0dDRpNElhTGJZUk91eXJG?=
 =?utf-8?B?dEQ1R2tIUWJiSm9QMGthZ2VJTTMrVzFxRk9aL2E1ZDI4QSsxVVNYWVdVTGN2?=
 =?utf-8?B?am9raXZVdFY3U0pOUVM5eHA3NGV3NGJBdDFxRVJLNVYyMkZDaGJ6cGROWTd4?=
 =?utf-8?B?MHM0eldoT2FIU1RHNjhQTEs5a0JLK1BSUHVqcHkxcFNXWWRQME9zeXhYTE9E?=
 =?utf-8?B?MVFqRERQTDZEK1VqR0FJdmdTZHpvWTNjbk1oallIWndXcTloZE1MZWpzZUxp?=
 =?utf-8?B?dEZXQUtjZFZsTGRJeGNKY3VWbC9TU3RjeVVwR1g3WmdPaDZvaUY5ek9pamtX?=
 =?utf-8?B?UDJKMUw3Tnd5OWxyYURjK1RXcnlHZFFjbnlyYk51eU1oc0R2cHRnNVJaVC80?=
 =?utf-8?B?c241VThYVVo2VGZhem5tVURMSDhvbDRlS2ZUdDJaZm9idXJKY0JYUWIrMFpW?=
 =?utf-8?B?bWdRTk1aSk5UaUQxSzhza255cmJQc3Rqa2JOSkJKemdnODZLRGo1cUYrbWVn?=
 =?utf-8?B?OC9tZ2dVUHVGM1o3SnZLaDFZa1pYeGpQcGcvMC9rTGhlc3k4bkI4VlhVWXVU?=
 =?utf-8?B?U09mc2pIbXk3Q2c3V0pSc2RlY1lwZldzdk01QWtHWTdHOEpTV3RPUnFrRWRI?=
 =?utf-8?B?RnVvMGNucTZ4ZDhLb2VTcmJxRmRTOTBianJzemZuMXJyekdkd3grait5ZWZ1?=
 =?utf-8?B?L2I4V2lZSVJaNnhpOWhZUzZNbWg5ako1a014ZnhvMmYzSHRlUXlhQ0RaWXVi?=
 =?utf-8?B?a3ovemdkWmRBakNneThkRTQwek54S1R6cXp4L05VaDJzQlhwd2lTZGxDSmlj?=
 =?utf-8?B?MXI3UTdNNER6R3J6T2diZHhFd2F2MTVNdjY4VW5oR0ZINklKMk9DR3NnTnky?=
 =?utf-8?B?ckpmWjVZSkQza2NBVllNYlUxSGdjK0J4dWdZcnlrQUM5aWFPRDdXRmJvSnN4?=
 =?utf-8?Q?TdkzF2aG8T8KA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXdvOVdnRHl4OTFyOFYvdFhDRGJlT0hRVXI0OG9jYm54dFhZQjBBbWNRK015?=
 =?utf-8?B?cGhTNTZoTjRRYmMzL1JYRG42MmhJdGdzc0crZTFRbHNrNmVwNnBLS2dNVXRH?=
 =?utf-8?B?MmdXUlVrSnk2ODhJWW1nTjRKOWQrMkREZDlyQTZPbDBLNjlpWkZ5Nm1rK3h5?=
 =?utf-8?B?dkYzUldDNDNtckNvTEh5dDQySkV1UnBENHB6L3orMUhOV3dhNFFlVzFaaDVm?=
 =?utf-8?B?N2QrTE9CNEtnQks3QkFVVDlKb1FDTkFESDErUXFlNWZuSU4xYldwZGdhOXR2?=
 =?utf-8?B?ZnM3YUNSdlVxSy9uRm5sUXM3ODB5WHBkZ3RpWmgvbzU0QXhYR3FZeG5md05G?=
 =?utf-8?B?YjhMWDlJSjRBcU9tbmxxTHJlWi92T1pIU2lHazdvaE91dlpBOU55WVBRZStm?=
 =?utf-8?B?MkM4U20rRW1JK0tIcWdGYzh1bUNxK29sVnd2VGhTZlBUamJDQU5KVGUyZElY?=
 =?utf-8?B?L2ZZdHQ1anA0WmpKVnFJRTVlYzFIUUZOcUk3WUZVWUtNUDhnTW5QOVExRmZk?=
 =?utf-8?B?c3NJbDh5T2Z6N1k3YW1Bekk5NWdwQ2dlemJRLzFBa1JUalo4YTRneE1RWVFT?=
 =?utf-8?B?bStxZFZGSHN6Nm5VVzdXNzBsaGRENlBhN2FBTTVUNXVNM3VSSEIwa1pDUEJF?=
 =?utf-8?B?UGZUcUVxZ0FGTFdUUGVOVGx2VkUyajd5OEF4OEVBM3BRMTRRYUJjSXhyUzli?=
 =?utf-8?B?T1NLdnJNeHYwYzJrcFVZSWdoWWt1UkRYS3g0NEFOcmEvakloa0dveURMQnZq?=
 =?utf-8?B?WmxDRWhrQ3cvTU15eCtibVIrcUVGbHdHcXJHK3dETFV5Y0d6K0FWQUVwSGZv?=
 =?utf-8?B?MFRuV243VHhkY0ltZENKdy94TGpwRlJUejVBUzhPRzQ4ZUhKckVBSDhaazhN?=
 =?utf-8?B?WUhLVnMzTVBGR2VPbk92aGFhL3FKeEE1MmVIczFPZGlyYU50L0N4clBWN0l5?=
 =?utf-8?B?UFBqMXdQUEtxcUdWSnVhTjQ2L2t0RzJtR3ZUUjR5R3dnZEk1eGdVcnIwYkRw?=
 =?utf-8?B?TkE0V2hlRm5tQ2ZMaHhCSVVaMjhSbncvNUFuZjlUczFOSitScW9PdXNpYkEw?=
 =?utf-8?B?bExnaDQxRWU4NFFUcU1LMW9HaFFkZzRUcWx4NkFzUUxDd1grbS9ham5GTnpW?=
 =?utf-8?B?MHlaMU5KSWR5djlENlhhbi8rdU5VNmJGZmE4SCtnVXJBdzVBNVFOT2d0NjFa?=
 =?utf-8?B?TzZtU2ZNNnI4RGpoZEU3c0VKeE5ib3ArOGs2WWY0MDJtYlhuSSszWXBVOWZh?=
 =?utf-8?B?ZG1Yb1dRUnhLRE1mUTNMSlk1Uk03ZFJGdFo3VGNLdng3emRoQ21FL2NZOVJO?=
 =?utf-8?B?Ykowc01VbzVoTkJIM0hURmNxWUk2Q3Y5ZVFrZXI4T25LakVleEVOcFJEQUkz?=
 =?utf-8?B?bGVieVFLZzJkYllLSVNyWk5TTFpoSHFJK0FnYTNyRmwrSDhjc2d5VXV5RVVC?=
 =?utf-8?B?KzJZekVLc2FQUXp1MUoyL0dqRG1Ednd6NW83SFJwd05EMUZETEtXRjhReGQ0?=
 =?utf-8?B?bHIwam12TlB3UDZQOHI0Zzc2WmJDei82Z09qY3p1c0o5Z3RxNWdNS2grZEVu?=
 =?utf-8?B?bEt0eFkyTHExS010bEFIbHg3SUN4VGczbE1lNjRDbmNVaEZlSVpVVnJIRUMy?=
 =?utf-8?B?R2F2OTV4d1IwdjFLK09BdWcyZGtIK0FMaXlwUXdOenRrRkluVHVZVC9VcnNm?=
 =?utf-8?B?aXlHQWNpc0NNSlpJZkxBSyt2VjNsSlE5K21GYzM4RU9XZ28rZGUzV1FRbUNP?=
 =?utf-8?B?V2pBVURRRFNrcmxMbFNWaHlEU053SVY1RVBQOXBCM05QUk1ReE0wWDA4NFhm?=
 =?utf-8?B?OUVpdUdJa3g4UEZuMFBwa3R5OG5Na3hCWCtFS2JEZk92Wld5Yk9WWnhzRFRm?=
 =?utf-8?B?TjhBcy9tQ2dhZjJGdG1ydFN3cjgyUk16QlhMQkJ1cVEyK0lRblFTb29wUkxV?=
 =?utf-8?B?cTFzcUFXYlRLcm5VejdnRWZlZjNuL2NLb3QyaUpERUJneUplNjdJZ21zbWtx?=
 =?utf-8?B?aC9VRnFld1NKNC9LbmlBbGRKZ2lHR3d3UWV5NHF0aytiQ1UzNEF3UklzRDh6?=
 =?utf-8?B?NzlUTHdvcTlURTJJaWRDV2h4eVB3V3ltTW4ycExhVC9tNGl0UjJJRktXQ1Rm?=
 =?utf-8?Q?om2+KW328KzchBtitHw2fqrjZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b520953-304b-4197-4dab-08dd6899d7c0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 17:00:11.8858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXkd/v3LY3JA5x/sllsIsHSpD6ccnKdV6TmN8ykOHdl6TTKRt7U41LESKCi6+GNtoeIAs7bQHr3937sgiFah9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9126



On 3/21/2025 10:02 PM, Francesco Lavra wrote:
> On 2025-02-26 at 9:05, Neeraj Upadhyay wrote:
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 82492efc5d94..300bc8f6eb6f 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1504,6 +1504,38 @@ static enum es_result vc_handle_msr(struct
>> ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Register GPA of the Secure AVIC backing page.
>> + *
>> + * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU
>> + *           doing the call.
>> + * @gpa    : GPA of the Secure AVIC backing page.
>> + */
>> +enum es_result savic_register_gpa(u64 apic_id, u64 gpa)
>> +{
>> +	struct ghcb_state state;
>> +	struct es_em_ctxt ctxt;
>> +	unsigned long flags;
>> +	struct ghcb *ghcb;
>> +	int ret = 0;
> 
> This should be an enum es_result, and there is no need to zero-
> initialize it.
> The same applies to savic_unregister_gpa() in patch 14.

Ah, yes! Thanks for pointing it out. Will fix.


- Neeraj



