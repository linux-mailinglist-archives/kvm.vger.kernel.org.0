Return-Path: <kvm+bounces-35501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A209CA1183F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 05:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4018161D61
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 04:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6756722E407;
	Wed, 15 Jan 2025 04:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tX4Bi871"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DB42054E9
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736913975; cv=fail; b=AKd0xJv9blwoyUVsUzsfXPU/d7Z0MSyGbJSm7BHHF2bE7FUL5N8ADFs6dXONY0C0FCXbNYO9T9LhXXG8axiIfjtiR7v4qbX5JjpO67Gx1Ug6+3sggBFKOLookocF9c0PUph6jldDE5dFN1czFNQfg3ifPmVQh5hTe9Kwf1ZfABk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736913975; c=relaxed/simple;
	bh=jdUEWGFpJlrepU3AT8Vn4JQ9bGrzgkGTEcc9Cz+BXDU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rvdc/4Cujz13B3+6z5ZOTSEZJ9Kmf6tCZ+PGtcsVfIiWmFxtnnSxEdXikfbnl4j1nUfe1OQtQSmfJE+fW+UdmRgqKchyEdpS8WnPVDDD6f4ker/memhKJFHgCPgf7yDAX5jfRDafDsn3pqxozl2rl4QvThDPTO9gSVEMUx744+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tX4Bi871; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WVv5XncJyi7C0Z5ONLU5TzcBstrtq3Y54THwNmainjiAyNLlSyCS7/IK522Y+8EA4a5PpqnLTD6ORsVg7BG2VyIZEZJdUSd48k0315hXPNtvQFQ87xmLZ+XhJWjydHWSWNcedkjO3SwhY3oLfHy5jMyGb3q/YCy+48SqIPhID8dHrimtybnuWEV2xgk3aWrQwalNc2WvWEOLRtKehOlcprGHCodPfpcBQD90hlEQoTWL/h/1MVOXIGUy/TtxGDf8TvukVtTyY7z8sPiXBEWDbDMpXSjdI8RioDUCuIN9Qfa4smOTZ4aOeAWeYa0AGVAmoMtKG1YL5bfCt9YhfXTSlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbE86IG8SET1ZXqpqhYV5mijBXGVFXp8nkwzDoVHE0Q=;
 b=ln0KFnxNkmd3TNGI7F0rqNRr5aOBUYnxLBLSnfQudOuM6TEyZZefQTytA/Hr1lYLR/ipIsHIPA30vBzYb+DquxgqZd0ta6iKQZ5rIGSlz/WyJkdz5X0xu6yE1cy5J07q6hMMvubgnx//OvYpsUDDdr+u5N1GAuWByCMLPpgoOGHTia4kN2shcQy3XQhmtz1wYUrECkzLdVQRbQ9+Z+yF+04it33r5Iq6F2tP3a4EJEn66g4n9tgFNLzHNvRIz0x01WFM32XxnOTyvMPfaTMdSE7yxS2ueBaIKTnJA0DwOsz8PIuKFEip4gZ/hEnzMBr9i0nJNfVe4W6fQnGJIz3lWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbE86IG8SET1ZXqpqhYV5mijBXGVFXp8nkwzDoVHE0Q=;
 b=tX4Bi8714EwTKulSNEb1Q835uYLIFBB17DxidsVYyYq7RvzfdnGt4AL3NefGYMfCL+kdnN+mO9ihS3pgNXgIQ3Cqp440hiTQ8IDnbN+rX40CRby3LEMzpUqWZsl1mmpcgwPixoXKZsGQ57M3o+IesxD7qkcIw9zzST8RykV15aA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 04:06:11 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 04:06:10 +0000
Message-ID: <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
Date: Wed, 15 Jan 2025 15:06:06 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: OS7PR01CA0190.jpnprd01.prod.outlook.com
 (2603:1096:604:250::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 8552f372-5a88-4d48-cfbf-08dd3519f204
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejhRTklaWFRneHdaWDJJQnpQaHlBaVFtZnpQc1VTbG9NYmVHRTJxK3BGc1pS?=
 =?utf-8?B?T1dLWVZZZ0Y4TWR4UWJ0QWxGT3FyZkVCeWhmbVhORGY2dnZnOHd5YThxLy9p?=
 =?utf-8?B?UHlmQmw1bldXRy9RQ1AveXVDMC9Xb3NqZWpLM1BTTitwUHpiN1ZHVDBveDhD?=
 =?utf-8?B?b01qY29wZ05qMm55aUNZUS9zbWkySmZzNlRqcUQ4LzJJU2ZLaVdzNE00MHJw?=
 =?utf-8?B?Nm5GNmdydUVHdW5QY0FoNVlIRkdXL1FTQ0FjWlZtaDFyY01HMEZaSWdpQldl?=
 =?utf-8?B?Q3lCQU0vWDNNR3BJbC9VZi9nZ1FDeHNmRmtMVU10ekg2d3BPUVk1Q2xZcldZ?=
 =?utf-8?B?QVoxaGhKMno4M01ybHdwOGlyeU5mWlhRc3BpT2JUaWthQUkyc0w5UU4rcDU3?=
 =?utf-8?B?YmZ2SmZLSGZmeTBQSWtuVzE3VDFIVVl5YmRPbmhRNXNYaW1OZFREbUNBdnpI?=
 =?utf-8?B?SEtKRFJQSXhHS3lXVmdLQXNnMTVFcmpKRm5NTXdzN1VYTExnMndXRldQbzFi?=
 =?utf-8?B?aU1oWTJGdkNwaVpkb1dCa3dhUzV3QUszQ1RnMXFwZC8zcWtkN2RFRVBvUzEz?=
 =?utf-8?B?RkhLR2hXVWFDUVNjVDhUWGFQQlRGZ3JTQm4vc1djWUNuR256SFRWejhUdFRv?=
 =?utf-8?B?aktGQmp0bzdXaDUvSHJvSDNCMjFQaWluSm1OTkdhN0czUHBlSVZEM3NKWU1h?=
 =?utf-8?B?azJGM3RJbGtBWlBKUVY4T0lVM1FGQk1UUFdUZHl6eFVqeXJZSnBCTkRLWERS?=
 =?utf-8?B?TGtURjNVUzc0YjhhUHkvM1hVbFFqT05Yb1hESy91VXJ5MTVqNVpxeWpLN0Fl?=
 =?utf-8?B?ZmJaemQ3VmZ2SFpOMENLUU04eDg3cXFXeVJEV3I3ZDZ4bVlrQ1BocTZTQ3RJ?=
 =?utf-8?B?YmxaSzQ2c0NzNjF2SGlUY1dLcFUraURvYUpqZ1pJd3NSOFdJRVJYcnZsbklH?=
 =?utf-8?B?ZEZYMWxsamgrQmxrMUF0MW5Nd1hWckNPZ0NnSjFDT2tHR2JDeDA3azRxNFM1?=
 =?utf-8?B?aktxRUg4QWg3VGNybUxzS1lsNytheHdaR2pndDF6cUt0RDFKT1Z0ZW5lREN3?=
 =?utf-8?B?VjVvZk5WNk11WWxqT3BLNno2Q3dxQ25yTW1nZXJwZmZUU1hNcmFQNU9EcSt1?=
 =?utf-8?B?U0k4QnFWL2ZyYkV4NVEvZEdSK3lZUEM4OWQrU0drWkY2RFdrMGRYazZoRC8v?=
 =?utf-8?B?NUFqUDhqUHJjV2F4RFMyeEU0a2pYS3NZU0dDSVIxb0t0cTR4VytLNS8xQ1lL?=
 =?utf-8?B?WjRYY2ptbThmZ1JvSmpmbW8rTWdhd1JLYWFYYVFtZXhTbEtJV3RqN1hTTWNZ?=
 =?utf-8?B?cURwb3diT2lHd0d0clJjVjJRZXVxc1NVNi9EUW04SVdaWkZIQWNnbm5JNUxl?=
 =?utf-8?B?clo4V3pkbXA4MVFQaENzejhZK01YbnY1RFY5L1drMGdURnZMa01hYXpxS1B5?=
 =?utf-8?B?QkdoLzc0L3dQVm1CWVZNUlE5VGVKSzFuZ3c2UnJJK01RaEdraEJnM0svQ1BG?=
 =?utf-8?B?bWhNa3l6aTJCdW5BREtoK2ppemJEY3FXcUxvTFZnSjlEaXJxR0lwRTNaVW9R?=
 =?utf-8?B?UGZYWWcxZkhWeTFtSDYwaFhIZ0EvRTNVZXVncmt4ZGFUM2I0OCtoeWtiL3FO?=
 =?utf-8?B?WTh2cmo4a21IM3grODNESlA4aU5nd0F5Q2NNeWVCSFZNZkpDOVZWeWkrSk1H?=
 =?utf-8?B?SUR2SzE2djY3NVBoMGhRYTNENDA0ckczTkE0YTVsVWd2YUVWVDArdXJQVUsr?=
 =?utf-8?B?OExaTk80SGxwWmp4b2VCeE9vTzVpN2R1UnRvdHd6SjIrQkhJNVR2T2dWWkNR?=
 =?utf-8?B?dUpPY1A5N1dETm9LTG50UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?algyNkFtTjRWU21BOEhTOW1aVUF2VXFDblhvZ0RzR1N6MHlqNGFtMlBnaWg3?=
 =?utf-8?B?bytvS041SE1nQ1VMN2xzT0RDYmN5SDdnUmZac20rL0h2ZDZrWUltTHFvTEN3?=
 =?utf-8?B?RXBoNVpoVlV1Yy9YaVFqaG5yOU8rNmdmaGM0QndqZUNDakg5UVJ5UThra1BX?=
 =?utf-8?B?R1Z2R3R1Zzg5RWpFM1VGSWF3eGlid2U5SkJyajg0U1crQytHOGhBMllzeFRz?=
 =?utf-8?B?NS8zdjlLU09uWUEreEU3RldkNmowSDZCd205amVWbHRxeUV0NlJ6THJmR3pY?=
 =?utf-8?B?bXk0cE9waTdtV3ZUSjhKNjNwZWpKcVJuSnROZ0FJSXBsQ2NUNFJLWFZ3elJX?=
 =?utf-8?B?WHlmMm9wTDhQME9JcisrdjBxcCtRWUpySTRBQ0R6NGdibUdkWFpDeW0yZkU3?=
 =?utf-8?B?OTVZWi9oQ3B0bFhpS1JMR2MrbzBxSVdWckFjcVBsTXBnVk1BV0FOendWSUc1?=
 =?utf-8?B?cGMvSzBVQlREblk2OXd5Z0VESDVZcVV1TDhHRDhRWmZEa1ZxMW1DemNzcHJz?=
 =?utf-8?B?MG9OVDlpeVNUZnFuTGV1eGd0czZCVEZHV29vTUJYUTBDbCtHeER0N3lIQVVU?=
 =?utf-8?B?aXljWGlhZzhUQnlUY091R0JITWVJcXppMHh2VEdhL01KTmV3VWdJNUlKN3pn?=
 =?utf-8?B?NC93VjlpekQ0ZElrbGpjL2VOK0xyS2liRnVoSUJBL2pBVVhFZWlFNGw0eTVo?=
 =?utf-8?B?T05Ebk9lUnZvWXhRcDdLSUNCTGdqL0ZVTmdnTklvSkJrYnRjWkRoZVMwRDcw?=
 =?utf-8?B?eWRraVRBamJ4SndlWXRsRTh3Mlg0Y3c3Q0ZZZjlGQUVvNE5DdW5McHA4WkpR?=
 =?utf-8?B?T2xvYnV2YTZGZmpadFhwOWk4REYyL0htZThjcEN5TGh4VnRHUGtvUFpnSWlv?=
 =?utf-8?B?ZHdnQ0xwOWhZNTBMejJyeUV0bDRGN1haUGdaWEx6aVdOMDYvYVc4ZEcvTkZa?=
 =?utf-8?B?ZzZtYlRJTmNkU2RyWlVYeFJYTmptVGw1SUV6cGlEY3ErSzRKbzZZWi8walNP?=
 =?utf-8?B?WGQydTR3SUsyOHJZWGtzYnN1aDkwWE1VZjE0MTRjUVl5V1RJclBxanZPbjFC?=
 =?utf-8?B?MEd5eENZYU1jZWIzK25FdGI3V29qaGtaL3V6REJpOUY2cWFjc0xIMCtnSkV4?=
 =?utf-8?B?YmhZdytOcStVd2pKSWlSS2V3L1B6a2s0L2FSVXNrVHZTaDMzcExSaW5WQ3RD?=
 =?utf-8?B?dTU4cEx6cUhSQTVDUzk1d2FlbllpKzRQUW1QVEtabjluZnZ4d2d5RG1Xck1p?=
 =?utf-8?B?TzBYRE1UZ1ZobmhQTHZZN0FEdHorOEJNbUNUZkZwNEQ1SVpGakhlMlhTaWI1?=
 =?utf-8?B?TTRnUkFrejRIZDhyVHpleFVOTXcyWTdtY0V4Q0Z1Skp1WVlGYlhaL3I3cDdR?=
 =?utf-8?B?VlE3Y1IyaTBFOU9xeGJTSzZHMHNndEw5WDdjSVdlZmRyc1JzRG9tSUd2d3VN?=
 =?utf-8?B?Y09tbnBWNWpMaGl5bXlYVStMN2M1aU5UOWdkR08xK2Y4VVV4OFYzdnlzbGZF?=
 =?utf-8?B?WTd4YzRadjNBOUFGRUN6Wm9oL2J2T1Qzb2lVMlNWZFQxQ0dtbUFBWk9raWtu?=
 =?utf-8?B?UnN2MWVYR2RxTythZjRzUEdtdUF0Y3VmS0JrbDlabjRnbnJ5TUZjNjR0aFpO?=
 =?utf-8?B?QlB1VkdsRTJ6RSt0Ty9IMnRmYmN6MVVvVWhYeFlrZzVDd29NcEczMHlycDhi?=
 =?utf-8?B?UXE5VFFyNjRmdjBnK0JRaXZUVmZDYkJTY2E5enh2UEZnSFlKeTExdi91MTlt?=
 =?utf-8?B?WkdZTklKQUV3NDZTakZSc3VTZGtkWE05dnF2RkVXQ2hmZWl5RENydVdoR2xJ?=
 =?utf-8?B?WTcwZG9COUgyajRmOE45RnB3c1ZlaGhPSXg0UTlWcVF1Y0N2TTNMMytKd2RZ?=
 =?utf-8?B?bnFXdXUwbWVNZDN6ZFpXdTdVSEs0MmszWkxPMHZXR24zNDl3a2lNdjg1Nkpi?=
 =?utf-8?B?MDY2ZDhlcnFFRnVGM3Ztc3JTLzZrRHF4T0s3WFZtanpGNmhkcnVhUTgrM0xL?=
 =?utf-8?B?eStNSmRXaSs2eTRXeHVNdk93VUowNHdPMk5FbWVodi9mSGVNUkg4ZEl5cTZp?=
 =?utf-8?B?UmorNHk3ZmxkZVE1WUpNOFJ4dkhWT0FRUlNtUG1UaE4xL3NCNWd6ekZpc2hU?=
 =?utf-8?Q?Zeu+6Ea/NeeQ28S51J790v8IR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8552f372-5a88-4d48-cfbf-08dd3519f204
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 04:06:10.8432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqAymQGaU7fdgsG6D+FELGOKlodHArK3tXKHoNqAgrhvv6fFDotzsQlRHelIYdBultq68ojqYUz7ECp4+GmqJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915

On 10/1/25 17:38, Chenyi Qiang wrote:
> 
> 
> On 1/10/2025 8:58 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 9/1/25 15:29, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/9/2025 10:55 AM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 9/1/25 13:11, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>>>>>
>>>>>>
>>>>>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO
>>>>>>>>> might
>>>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>>>> discard
>>>>>>>>> operation to perform page conversion between private and shared
>>>>>>>>> memory.
>>>>>>>>> This can lead to stale IOMMU mapping issue when assigning a
>>>>>>>>> hardware
>>>>>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>>>>>> pages). Blocking shared page discard can solve this problem, but it
>>>>>>>>> could cause guests to consume twice the memory with VFIO, which is
>>>>>>>>> not
>>>>>>>>> acceptable in some cases. An alternative solution is to convey
>>>>>>>>> other
>>>>>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>>>>>
>>>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>>>> adjust
>>>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>>>> adding it
>>>>>>>>> back in the other, so the similar work that needs to happen in
>>>>>>>>> response
>>>>>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>>>>>
>>>>>>>>> However, guest_memfd is not an object so it cannot directly
>>>>>>>>> implement
>>>>>>>>> the RamDiscardManager interface.
>>>>>>>>>
>>>>>>>>> One solution is to implement the interface in HostMemoryBackend.
>>>>>>>>> Any
>>>>>>>>
>>>>>>>> This sounds about right.
>>
>> btw I am using this for ages:
>>
>> https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
>>
>> but I am not sure if this ever saw the light of the day, did not it?
>> (ironically I am using it as a base for encrypted DMA :) )
> 
> Yeah, we are doing the same work. I saw a solution from Michael long
> time ago (when there was still
> a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
> (https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)
> 
> For your patch, it only implement the interface for
> HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
> the parent object HostMemoryBackend, because besides the
> MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
> MEMORY_BACKEND_FILE can also be guest_memfd-backed.
> 
> Think more about where to implement this interface. It is still
> uncertain to me. As I mentioned in another mail, maybe ram device memory
> region would be backed by guest_memfd if we support TEE IO iommufd MMIO
> in future. Then a specific object is more appropriate. What's your opinion?

I do not know about this. Unlike RAM, MMIO can only do "in-place 
conversion" and the interface to do so is not straight forward and VFIO 
owns MMIO anyway so the uAPI will be in iommufd, here is a gist of it:

https://github.com/aik/linux/commit/89e45c0404fa5006b2a4de33a4d582adf1ba9831

"guest request" is a communication channel from the VM to the secure FW 
(AMD's "PSP") to make MMIO allow encrypted access.


>>
>>>>>>>>
>>>>>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>>>>>> target
>>>>>>>>> MemoryRegion. However, this solution doesn't cover the scenario
>>>>>>>>> where a
>>>>>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend,
>>>>>>>>> e.g.
>>>>>>>>> the virtual BIOS MemoryRegion.
>>>>>>>>
>>>>>>>> What is this virtual BIOS MemoryRegion exactly? What does it look
>>>>>>>> like
>>>>>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>>>>>
>>>>>>> virtual BIOS shows in a separate region:
>>>>>>>
>>>>>>>      Root memory region: system
>>>>>>>       0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>>>>>       ...
>>>>>>>       00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>>>>
>>>>>> Looks like a normal MR which can be backed by guest_memfd.
>>>>>
>>>>> Yes, virtual BIOS memory region is initialized by
>>>>> memory_region_init_ram_guest_memfd() which will be backed by a
>>>>> guest_memfd.
>>>>>
>>>>> The tricky thing is, for Intel TDX (not sure about AMD SEV), the
>>>>> virtual
>>>>> BIOS image will be loaded and then copied to private region.
>>>>> After that,
>>>>> the loaded image will be discarded and this region become useless.
>>>>
>>>> I'd think it is loaded as "struct Rom" and then copied to the MR-
>>>> ram_guest_memfd() which does not leave MR useless - we still see
>>>> "pc.bios" in the list so it is not discarded. What piece of code are you
>>>> referring to exactly?
>>>
>>> Sorry for confusion, maybe it is different between TDX and SEV-SNP for
>>> the vBIOS handling.
>>>
>>> In x86_bios_rom_init(), it initializes a guest_memfd-backed MR and loads
>>> the vBIOS image to the shared part of the guest_memfd MR.
>>> For TDX, it
>>> will copy the image to private region (not the vBIOS guest_memfd MR
>>> private part) and discard the shared part. So, although the memory
>>> region still exists, it seems useless.
>>> It is different for SEV-SNP, correct? Does SEV-SNP manage the vBIOS in
>>> vBIOS guest_memfd private memory?
>>
>> This is what it looks like on my SNP VM (which, I suspect, is the same
>> as yours as hw/i386/pc.c does not distinguish Intel/AMD for this matter):
> 
> Yes, the memory region object is created on both TDX and SEV-SNP.
> 
>>
>>   Root memory region: system
>>    0000000000000000-00000000000bffff (prio 0, ram): ram1 KVM gmemfd=20
>>    00000000000c0000-00000000000dffff (prio 1, ram): pc.rom KVM gmemfd=27
>>    00000000000e0000-000000001fffffff (prio 0, ram): ram1
>> @00000000000e0000 KVM gmemfd=20
>> ...
>>    00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM gmemfd=26
>>
>> So the pc.bios MR exists and in use (hence its appearance in "info mtree
>> -f").
>>
>>
>> I added the gmemfd dumping:
>>
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -3446,6 +3446,9 @@ static void mtree_print_flatview(gpointer key,
>> gpointer value,
>>                   }
>>               }
>>           }
>> +        if (mr->ram_block && mr->ram_block->guest_memfd >= 0) {
>> +            qemu_printf(" gmemfd=%d", mr->ram_block->guest_memfd);
>> +        }
>>
> 
> Then I think the virtual BIOS is another case not belonging to
> HostMemoryBackend which convince us to implement the interface in a
> specific object, no?

TBH I have no idea why pc.rom and pc.bios are separate memory regions 
but in any case why do these 2 areas need to be treated any different 
than the rest of RAM? Thanks,


>>
>>>>
>>>>
>>>>> So I
>>>>> feel like this virtual BIOS should not be backed by guest_memfd?
>>>>
>>>>   From the above it sounds like the opposite, i.e. it should :)
>>>>
>>>>>>
>>>>>>>       0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>>>>>>> @0000000080000000 KVM
>>>>>>
>>>>>> Anyway if there is no guest_memfd backing it and
>>>>>> memory_region_has_ram_discard_manager() returns false, then the MR is
>>>>>> just going to be mapped for VFIO as usual which seems... alright,
>>>>>> right?
>>>>>
>>>>> Correct. As the vBIOS is backed by guest_memfd and we implement the RDM
>>>>> for guest_memfd_manager, the vBIOS MR won't be mapped by VFIO.
>>>>>
>>>>> If we go with the HostMemoryBackend instead of guest_memfd_manager,
>>>>> this
>>>>> MR would be mapped by VFIO. Maybe need to avoid such vBIOS mapping, or
>>>>> just ignore it since the MR is useless (but looks not so good).
>>>>
>>>> Sorry I am missing necessary details here, let's figure out the above.
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>> We also consider to implement the interface in HostMemoryBackend, but
>>>>>>> maybe implement with guest_memfd region is more general. We don't
>>>>>>> know
>>>>>>> if any DMAable memory would belong to HostMemoryBackend although at
>>>>>>> present it is.
>>>>>>>
>>>>>>> If it is more appropriate to implement it with HostMemoryBackend,
>>>>>>> I can
>>>>>>> change to this way.
>>>>>>
>>>>>> Seems cleaner imho.
>>>>>
>>>>> I can go this way.
>>>
>>> [...]
>>>
>>>>>>>>> +
>>>>>>>>> +static int guest_memfd_rdm_replay_populated(const
>>>>>>>>> RamDiscardManager
>>>>>>>>> *rdm,
>>>>>>>>> +                                            MemoryRegionSection
>>>>>>>>> *section,
>>>>>>>>> +                                            ReplayRamPopulate
>>>>>>>>> replay_fn,
>>>>>>>>> +                                            void *opaque)
>>>>>>>>> +{
>>>>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>>>>>> +    struct GuestMemfdReplayData data = { .fn =
>>>>>>>>> replay_fn, .opaque =
>>>>>>>>> opaque };
>>>>>>>>> +
>>>>>>>>> +    g_assert(section->mr == gmm->mr);
>>>>>>>>> +    return guest_memfd_for_each_populated_section(gmm, section,
>>>>>>>>> &data,
>>>>>>>>> +
>>>>>>>>> guest_memfd_rdm_replay_populated_cb);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>>>>>>>> *section, void *arg)
>>>>>>>>> +{
>>>>>>>>> +    struct GuestMemfdReplayData *data = arg;
>>>>>>>>> +    ReplayRamDiscard replay_fn = data->fn;
>>>>>>>>> +
>>>>>>>>> +    replay_fn(section, data->opaque);
>>>>>>>>
>>>>>>>>
>>>>>>>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
>>>>>>>
>>>>>>> It follows current definiton of ReplayRamDiscard() and
>>>>>>> ReplayRamPopulate() where replay_discard() doesn't return errors and
>>>>>>> replay_populate() returns errors.
>>>>>>
>>>>>> A trace would be appropriate imho. Thanks,
>>>>>
>>>>> Sorry, can't catch you. What kind of info to be traced? The errors
>>>>> returned by replay_populate()?
>>>>
>>>> Yeah. imho these are useful as we expect this part to work in general
>>>> too, right? Thanks,
>>>
>>> Something like?
>>>
>>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
>>> index 6b3e1ee9d6..4440ac9e59 100644
>>> --- a/system/guest-memfd-manager.c
>>> +++ b/system/guest-memfd-manager.c
>>> @@ -185,8 +185,14 @@ static int
>>> guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, voi
>>>    {
>>>        struct GuestMemfdReplayData *data = arg;
>>>        ReplayRamPopulate replay_fn = data->fn;
>>> +    int ret;
>>>
>>> -    return replay_fn(section, data->opaque);
>>> +    ret = replay_fn(section, data->opaque);
>>> +    if (ret) {
>>> +        trace_guest_memfd_rdm_replay_populated_cb(ret);
>>> +    }
>>> +
>>> +    return ret;
>>>    }
>>>
>>> How about just adding some error output in
>>> guest_memfd_for_each_populated_section()/
>>> guest_memfd_for_each_discarded_section()
>>> if the cb() (i.e. replay_populate()) returns error?
>>
>> this will do too, yes. Thanks,
>>
> 
> 
> 

-- 
Alexey


