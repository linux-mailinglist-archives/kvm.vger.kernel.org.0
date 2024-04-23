Return-Path: <kvm+bounces-15604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D80E8ADCE5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 06:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50FA71C21803
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798301F941;
	Tue, 23 Apr 2024 04:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j//iTyII"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3331B813;
	Tue, 23 Apr 2024 04:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713847229; cv=fail; b=DFZWjRoUlBrZ3EomTnkMzpAecHhv1Es7hMMb5ivQmxoXP8qLrYgqlMSofg9gPHuUC7Wsha+/ZHDOQeayv572CQQSHz1WeC1AXVTfhlZuF3EYQaFEmQnPe/rnDLehpvhUrF98oJN5bQoQtSf/C1FWU9UnI7Negdmw50mDoJGwopw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713847229; c=relaxed/simple;
	bh=SO5DVrizC3yzpCDrIeMmQ2IW7MLWa956m9VjcMRHkWg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UQErQH9DV2uT3pu6fTpHgQgGLxo+wD0o0eIW9d1enrlVHTyI4LeTK+lDilgRfKdsck4ZzrXwXoVhTLRJFb2PCPlVGJg5k0j4qQViXidW4i32rTUaz/JirxF+dxsKLWD/mR34VLBneRa5yxhJNzedqVCOZn3pNTuaMZQO4am4ZBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j//iTyII; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rn7U5/z42/XPb1cogejLiSEslHqtR5T78WlHSowaw+I2U3vSkW3phtPof/faf/4oA4E4Nof219eb1CSYZUlmxOumK4OWsHtvbIWLBt8YgWG1IyzFFd8rpXRWBzqtD2ESZ+HlPLIUJzPjbOPfXviSSumRwcY6sQWy7GVq40ga5H8kKfgLENgrn1z10R5aAGmmD+nCR1fDDcsjAKS/y2sjg1KTm8Zz4Rs4+luS2619cZGGyGxaKqdwzadjBgD32UKsYbo/0bQkS6pI7GJ61YUGOwE9cqREWCuRmjGTfpucJ8IPiBH2aJBlr1JFT70vbTTeatMZnas6ehNDt53BahmfWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a21A1Ie8FStn0uG97xkgnKdcRVphfGJliPrjHcuOrts=;
 b=SteBybPwGAP5wCvK8tFKrD6OyOYY7KxF9NV2JXSLiTBWXZBxcC5Aa2rMUEmrUE8DX9dKemAdBs/nelZv8DrstALnmkQ8R9Rck4chHL1BSRsQThL//SLQAPnKwIsstFHrvV25SZ7l60L9447yRn+QUYrdWAHg1bxLcBM43wYzTuRRK8yo3/bl0lxVRy5VV7W4UC9o9hYjNlWCx0B52WB8Pl8ZNXyAUiDdHufx2MESVEItafgefpQX9wlQf8md6Xy6Lxlw3UiMtccGTb0gLAZTTnMSa18+uT2q8N+64KaoVfFF9bhPD2BXfURIxYKCU/5kP1MVNAba1CPZoJLTEaXlAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a21A1Ie8FStn0uG97xkgnKdcRVphfGJliPrjHcuOrts=;
 b=j//iTyIIGDUvnbIB/dnfURjZJ6tAAfSh/7kzY5HKF/BKZenlxd6LpxN21NWpxC8sZsxtmB48YWtfADbMPqjMIa8JEChlGyusk5WLwayNHGCdNZOlKICBbK8R/AWz5akc90rALaSOhQU6yo9hAm7YPv0sXJO727x3iPKebc2B6M0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW4PR12MB6924.namprd12.prod.outlook.com (2603:10b6:303:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 04:40:25 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 04:40:25 +0000
Message-ID: <4109abcf-1826-4332-8abd-070a80ff044c@amd.com>
Date: Tue, 23 Apr 2024 10:10:14 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 09/16] x86/cpufeatures: Add synthetic Secure TSC bit
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-10-nikunj@amd.com>
 <20240422132521.GCZiZlQfpu1nQliyYs@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240422132521.GCZiZlQfpu1nQliyYs@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW4PR12MB6924:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ce02de8-d49a-4ba8-1325-08dc634f7e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODljZVoyZHZlUnJnTllSSEVFb1V2L1dpSFRSSk9tbGo1MG1qWUVBL1BJK3RR?=
 =?utf-8?B?Nnd6ZkczRWlKQXg3SWw0NEUvbTFzd0xtNm5vMjdwMzVFVjNDNnYwTVRGYjAw?=
 =?utf-8?B?Qkhra1NYRmRaZzVHZVcrRGlRZS9odVcxMWVMd2llMThaTFBvek1XajZzajc5?=
 =?utf-8?B?MlpzL2ZRU2ZNblFDYWNwSlZmUk9UOFNuK2FLc3lRVXEyaGZ6NGFyZnpUWEJN?=
 =?utf-8?B?TEtNUEVndmNzM21Sc3UrVk45M2J5WWY0aHgzZmdtT2I5WXBKYitmQ1ZNU2U1?=
 =?utf-8?B?NXJLWUhkWXpqRXpFbWdscHpKcDEzbXIwN3YwTlZoQXVrOHQrTTluWmEwNmlN?=
 =?utf-8?B?YXM3N0kyTW05L29RcDFoNW40SFU1U3RWa3ZQWDlmdG8wUEpUZEZKMm55T1pC?=
 =?utf-8?B?aTVKQjY5QW9DRzVxZm93QVpuYWdNeWZ4MTg0OGR0RFFIRnZ6NUNvTkkwSUpq?=
 =?utf-8?B?Q3orOGFPbXhWWVFTWHpRY2pQclVwNlBWR01uK3lwb1RLRW15OFArTC9yVTBT?=
 =?utf-8?B?NHA3UE1McklKNVM1eFFDRzF3ZU1YQ2g2anphWDNLRUh0TEpGYjJ5RTlkMyto?=
 =?utf-8?B?ZkpFN0hRVUdsMlAzNzVyN1lYd2NicWYwazdtdm8yY0VBS2pWdVRtNlhMZndt?=
 =?utf-8?B?SWZmVEFpWXJFblRPb0N3dXUvUXE2Ym90VkhrMTliaFRLUW80TVZwSDBYVzJy?=
 =?utf-8?B?NnNuVmw3RDR2eXRmdlpacE5TTExyZkZ1TjRwYXp2ZDZBN0hjVnE2ME54Z1hH?=
 =?utf-8?B?bGhUV1hNdjB1YjFOMmdtK2FVejVablFOeXVBOSszcVcxQVpMeEJLd21qNHEv?=
 =?utf-8?B?Tkh5SU9IYStKSGh1RWk3OVFZMjZaN24rZHA1em5raFIvRGIydFZjNlViOFFq?=
 =?utf-8?B?bk1OWkc3WEFBYnRXYjhDdjFMYnRXV1h0bkFiNDdvWHB2UVVlaG1MQWxsQkFK?=
 =?utf-8?B?SDdtazFQR3ljRkpQV0hDb1p6QXJCUy9md21XN1VabFFyaTNQTmtZMWxHRGpG?=
 =?utf-8?B?ZitEQXFWRkc0Yi9oeHdON1BkVXVpdERzbzVGQWRFajVxalQrbWdQbnVkSjU5?=
 =?utf-8?B?VmZ0S0c4blpVSU5KdDFFYXZUelZHbnMyZ3BpZ2JaQmZybTIya1JkL0QxdFZD?=
 =?utf-8?B?Y2dlNmFqbEI5d04xSFVLSzdSZS9GKzU0QUdhTGdaeTNBcnRXUUlTaDFGWGoy?=
 =?utf-8?B?c3d5N1NqZWZ4RFZDZDZYZ0thamFDQk5ZWEZDVWtEcDhOTnBQWlA1Zzd1QW5t?=
 =?utf-8?B?VkFaMVpHWktsVldEcEludThocjR2cGhrdDhrWS9QRkl2b2IrZUdTUVVQTXI4?=
 =?utf-8?B?amkxM2xuUU9ZZ2tjWS9mM0d0TTVrVCthaFExbHpjbzVWM0hFMTFBRUlnTUtX?=
 =?utf-8?B?bmNsYkNLSU40ZVgxUUVKN3l2aE9CazRqLzBEMFRNUEFyL3RySC9uZkFvUEda?=
 =?utf-8?B?R3YrUHQxS0tTNkl1ZWhLRXM2WEVoVkVsVjQ2Uk1GcVBzTnBvdzZKbis4cTNs?=
 =?utf-8?B?ZFY3RjZkanEvd0hsL2EwMWNzbzB3MDNKVGh0QzFLc1liMXdMbk1kVU52bVJk?=
 =?utf-8?B?bTNIVUN5Mi9WZmJJMnZuaFVaVXlnbVZ1WWtKOWt3MWQ0aHdRWk40UmJmQzBI?=
 =?utf-8?B?MTA0c0NNSnlWcWwvbWtleXN4Zi9lM25rOHdHc0RzamlKcGk2YnZNMEJoNGlE?=
 =?utf-8?B?d2VoYjBuYzh3cXpDVEdZbm9mdjIrcVJ6SDRmb3JWSnQ5VEFCTVNTQ2VBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L29FMTE1Mm1odUJTYlh4Yk1nWGppYzU4MWE1WmxZUkV6M3Q1MExyOS93WjJM?=
 =?utf-8?B?ODkrMXMvTUcvVmN4L3FObkJzclN3MW5NdGJNQzRnOVMwQm1PRVp1TGJUUHV2?=
 =?utf-8?B?RG1ocjRDR3Z1K0lFdzNTelhjR29wckJ2QnNqQjhJTnFaZG5EbXZLS3VXT0JM?=
 =?utf-8?B?K21zRFpwSUJhYnoyYmVIU0E0ZHYrSkg1eVRmNVhXY01wanFHZ1dMR3NMUmxX?=
 =?utf-8?B?WDhrWWpZN0Fac09vS2VZejJ6ZjV5NFVxSDIxQ1RGYktoYm9ubS82WnQvN1Bt?=
 =?utf-8?B?SXM1aW9GeC9tWWtMQVFpa3VRcFlsaUkzckduVTEwSlhZVHJqNG41ZmkzaUZs?=
 =?utf-8?B?dWZ1TG9ySTNmOXhJQnNCdFU4VkhGQm4wcVQxOGd4V1k1TXRINW83SEdsdDBE?=
 =?utf-8?B?dDUwSzJiUExNenZzRTQ3ejVzOXdkcFM5dTZFUmhUenRvWjNFTXBjdEtJcGd5?=
 =?utf-8?B?Y0ZGcitWSnJBMzZ3RWR4QVdZVGM0WDdXd08yNHVDdGk1UDVKZ29ybW1RMkdL?=
 =?utf-8?B?d3pFTWlXMWl6S2pkQ0JqQTFZY28vcm5RYTd3dk1BalVhL09vT25VOFZSbWpm?=
 =?utf-8?B?Q3ovMUdZZGVGOWhicUxUb0NGS2xYd05LRmtzbTJndUQ3TlJCWFZHcjlUS0E2?=
 =?utf-8?B?OXJtbzRhdWZBcFdTUnZyVXRRUnlCUm1qNlBYaWNvUWtpYjB6aUp5Q04rTWI0?=
 =?utf-8?B?Rm5iTitGbE9BRm9USjRhZmhBM2EveGFLekhHSDBvb1lCeXdoRmVaakxJb1Ar?=
 =?utf-8?B?ZzB3N2YyMmpDYzhBdEMyV1pZa1o2MjdUZnBKVkp3ME1Nb2ZZQkQzOG1OR21l?=
 =?utf-8?B?ZlV2Z0w4cFhmc2FLckdSREthM0Z3ZlBIYndVTEM0SjVCR1lZblhONnhvdXJ1?=
 =?utf-8?B?SmJNY1NURmlNWTcvTXkvcjliS251czM4aWxBd05hTElVOFdKU1V4U2Y3NVRC?=
 =?utf-8?B?M2FYUkFDTHMrb0N4eXgrN0s3TDFSempuSVV2OEF2MVVkVHNMR2k5Z29mZVFH?=
 =?utf-8?B?YXBaSUtBU0NZUVZjRGZaYzV3cnFJTEZHR1lRTUVMcWE5c1NkR0srQU9xbGlB?=
 =?utf-8?B?dERXTkRJaTB1SjNiUVZSWWZscHlqamtSZ1VHSURsKzN6WUtZSllnK0k1dHIv?=
 =?utf-8?B?WVpDeGRzRE5FdXFPb0RKRDZlVm9ydXhPcnZjVmVQK3dSYjhEQmQ4K2kvM1lH?=
 =?utf-8?B?UWR2MDVSMEJSeVlyell4Ylh6cmlZaXdIam51cGJDbEdwRWsyZEt2UFFxOUVB?=
 =?utf-8?B?ZmVQQVA4Z01tOXU1eGdEZXU4ZE05SzJ3MDIwK1RxbHFmUWxUbW4rMlgybTRF?=
 =?utf-8?B?c2wxMmlXR2VHSDhJSjNVTWp6K1gzejl0MUNqUUdQeUpaZnAzc1ZWb25BNVdi?=
 =?utf-8?B?SkJJN0l1K09mampkMmlOWWw1bTMyWXY1aisvQkFOS0lHZXlYNVFnWnYrWm50?=
 =?utf-8?B?Q1E0ZnpEVXFWWVphQjhobEtZOGVTL1Y4V3Q2NzFGc2tWdWpremNGeGIzS0VT?=
 =?utf-8?B?TnRaRHJrZmRzMlZFL1hPbXNTQVZhUGMvQ3hGOGlUTnBsWEZWSktLR0Nka2dq?=
 =?utf-8?B?QTlGTENFejNzK09iWkdJMmZuUVpjU29wUHB6d205cVhIZmF0WERrQjd5bVJs?=
 =?utf-8?B?VlI3YmdNSm02a0ZUUy91QzhaVEhycjNqVlJzQnBnK3NoZ2JmMjJ1SmVrU0Fq?=
 =?utf-8?B?bm9uQ0g4UmFRbkN2T1FaUTB0enZjeVVkdlZ4RFVCN2VWQ3N1TzRPWGhKTmZW?=
 =?utf-8?B?VlUveDJPWVVMOVFTWGJnMlBjL3Q1WDZtM2lLZ1N5TnhsNkh2TUptSWN2Z0c2?=
 =?utf-8?B?aVZCakdIR2crT29JdkFDTThheDZhZVhUTHJraXIyaC8rU1d6OHFBRmRlWFo1?=
 =?utf-8?B?bmRyR2toZE00KzRic1l2WTVNUjhmUm4yYTM5MjgzTDJvQTFFcExaeWlQUHFs?=
 =?utf-8?B?NjJrMWp5dWhDVlNrN3I3Mk9vQittT3Z0QkptRVV2SmpEaGF2S2FJdDdQVWk1?=
 =?utf-8?B?bzA1bEF5VG1aT1g0dHFLaVRVOUxXQ1FGMzU1SEJtSlZUb3JlYW9qTXUzbXNa?=
 =?utf-8?B?c1FSTk92cmV5VGpLWFM4WWdFMjl3Y0NBUWNEN3FEenZMSHNJMkdaUGVEL2ZY?=
 =?utf-8?Q?+oUzvs+QS8LUO0rsQW4awOpTY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce02de8-d49a-4ba8-1325-08dc634f7e28
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 04:40:25.3441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwXZsY8Z4x5+YuA6tHR/QBfvexGSechpqwk5lPKnY8e8P1EixpCPZS3GR+BR4piOkopWddOotN5mIJDilAUTaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6924

On 4/22/2024 6:55 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:21PM +0530, Nikunj A Dadhania wrote:
>> Add support for the synthetic CPUID flag which indicates that the SNP
>> guest is running with secure tsc enabled (MSR_AMD64_SEV Bit 11 -
> 
> "TSC"

Sure

> 
>> SecureTsc_Enabled) . This flag is there so that this capability in the
>> guests can be detected easily without reading MSRs every time accessors.
> 
> Why?
> 
> What's wrong with cc_platform_has(CC_ATTR_GUEST_SECURE_TSC) or so?
> 

That was the initial implementation, and there were review comments[1] to
use synthetic flag.

Regards
Nikunj

1. https://lore.kernel.org/lkml/20231106130041.gqoqszdxrmdomsxl@box.shutemov.name/

