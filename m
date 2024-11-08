Return-Path: <kvm+bounces-31313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6FB9C24AA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AA5E1F212D1
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 18:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0D6233D92;
	Fri,  8 Nov 2024 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nrf/I9HN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2EC233D6E;
	Fri,  8 Nov 2024 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731089313; cv=fail; b=UifQSDsZH7blcz4cOkUZ6DJ3H2VJwlIEL2THzZz8OGBFJFnBUqqUH8+N2NR6PMAdo6wyeoM+f43sx9VJd7CqidGs+tMvdAJoF3rDZsuc7bUG9c3kdT5fmrfwQalhC5Ggwx+2xMVl/iF5VU0FTQ9sZGwY7b8DOJyB5IF74AHgqdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731089313; c=relaxed/simple;
	bh=hz61fS2TyiEOJWh1bRurKUnmdkVA/uOAisQ/dHx1Y2E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dlN/2801/kCFtBXNQ7Qsxwl2BG4Bqm9h90NUQJBqCoh/cCVTOI9TUbPQ9cqeH+xUKlMGQqsk0G2F8LHzR31+0kOMICayByTlIF+oQFikVERi4Y7lbxOE3th8TGZNxdupbIlrT/NWdkYP1KLaZ8kt3mTysAPOAwRAzsqtoRQllio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nrf/I9HN; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh6MHbAGxMTT9lcSHw2/i5aQ7/8tMa9XcQI6vGL4lF19TgAyekLtqFpzI7AyRgfJP0yExoXuEdR+QSo5CnIeBVDFwGgh/z4RE8kOXCsZcAXH3W2NNAYuzUsMApBpIJ5hEXfJJWzc5dW/QonQqJ0fhWd+/vsP6ebt8sdN1JPbnIQIrw83C2O4NHwouDSe7vb/gveZLRY74MGYPrR+XSdr9DNtHvkvSY5JKTW3RJ6bjkpPWQ91gQN8BFT5ykTmKdd3tZG1R/eFrSfoOOwTGTCfgoH2AS5tGoNngA/cKw1YO6bsTQi6eHGWZq9WpkddsTeGwy0TvLuX8gTJn/zOvOvYOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lm8/2keMAVcsarlfPdbv8AGLUPEQUES0grU7ofIt6eI=;
 b=TVjafIwj6OAdNbQi+pY4PezujB5DxHQEcvAHF31uGd205d5KMSCGMcdYaQ0M1akdg9X6YZ3IiY53Dp59zDlXw32uSVLJyruJ2CH53HqG3nFKPUkvlO3+8rzM7DtwxjC37LA210mQQe5dbaOGob8lQaS6UWugxWPlZTS7UGOHKCArj3nwmqC8fUFKVDpSKBJoVeO6FD0QFtJAyvFvBi5Te/nl25YGl+BURfuuRAqrrStrBJP6XDywRZw8Jlw1pHyZcgEiRcqh+1Ynk09VRzjji0j6KcbP4AENgm3ECnViqycgIELyNqVU7IDAxaVAdMZ1Ay++FQYgRnz8nM5ywgyeIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lm8/2keMAVcsarlfPdbv8AGLUPEQUES0grU7ofIt6eI=;
 b=nrf/I9HNlHyxaJpQsVEVN1NBfMjWQWsQfzaNKv/MxpPmk0aHIbJqqPF4p5jlzMRyh/jSpCj4J/ND/+rdHI+rNLbPuaVTHPpg+eH1nyDh0v/f4BlRUEI6OtYjzvQMgeHG+WXt5p2wg7f7luY/zvO0GQ5UITUohbBxFzalJsbtme4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11)
 by SA1PR12MB8968.namprd12.prod.outlook.com (2603:10b6:806:388::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 18:08:29 +0000
Received: from CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0]) by CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0%5]) with mapi id 15.20.8114.028; Fri, 8 Nov 2024
 18:08:29 +0000
Message-ID: <4af5212d-a6db-4f14-ace7-c6deb6d0f676@amd.com>
Date: Fri, 8 Nov 2024 23:38:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/14] x86/apic: Initialize APIC backing page for Secure
 AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
 <20241107152831.GZZyzcn2Tn2eIrMlzq@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241107152831.GZZyzcn2Tn2eIrMlzq@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::20) To CY5PR12MB6599.namprd12.prod.outlook.com
 (2603:10b6:930:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6599:EE_|SA1PR12MB8968:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c69436-cf58-4f74-ed3d-08dd0020589c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nk5ibkFVS2p1bDc2Y2NoNEdMbU90T0FzVWUyd3IwWEdPT1Z6K3JBclRVTjFS?=
 =?utf-8?B?b0lxVDMxaXNCVWxvREo1VEIzTXQrUWRzZmFnNDk0NXMrZTBJY2lTNmhraVNu?=
 =?utf-8?B?VnFTbXpRMWhOa1QrMFhJdk5tTWptUTl6TGhqaUt2TDRhR0tmb01XNEgvbHQw?=
 =?utf-8?B?R1owSWQzT25TQitBZUIyZzZMblg3aDh0bXVsMXArVzdEbUI0QWptaXNZbXBG?=
 =?utf-8?B?akYrSUF1NzlTeGw4aXVWMTRscU16VjArME8waEd6NXlkSS9kbnVxeWR2L1gr?=
 =?utf-8?B?VDNNbE9lL0R6TjNDVXVyWnkxYUhVN283ZDdRRFpoWDdoTklFWlN4K05OeUZr?=
 =?utf-8?B?YlpoTjhDczMyR25Jc2hHTHBBSGorb2k2K291Qk5uV2Q1UzBlNlVNdnJGc21k?=
 =?utf-8?B?UityUUVjS2l3SkFmK2pBckJVajNUd0Era0hHU21yQ2dRMHZtZFNoVjR3bWZI?=
 =?utf-8?B?cDRpeEJTSXBEQVF1VVBPaW1wRUIzSFF3WEhjRXN1cWZ2c2RiT2FMemJyZGY4?=
 =?utf-8?B?MjRsLzlrUTRwUTZTaTNmREZmb0dYRlQybDREVGMrbmFiTC95a05vUk5RMjJn?=
 =?utf-8?B?cXhoNXdoUGoyc1BHS0c5ckJiQmRWWXBIMDQ2T3cvU1NCbmhlUTAvL2U4M1Br?=
 =?utf-8?B?U3JXRHZxQ0VFK0ljWlVUUmFic25nanc5b1pzb3hjSEV6NjUwU20ydHN4NW1o?=
 =?utf-8?B?TklLMnJwRHI0eS82M0w2QmpFL2s5d3JhV2U0blFYc3p4SU1TQUlEM0svN1hs?=
 =?utf-8?B?VXlveWo3Rk0rZll5NmltZXhMazlhWUlPTHhHVUl5YUhlVnBTWjZTRlFMQ1Vm?=
 =?utf-8?B?ZmJidDBoWnVtamtNZUpRMTc0YlN6b3hSZEdRR3NUSnJmVGRXTzJhUE1MaDR6?=
 =?utf-8?B?T1doYVV6WjJ6L0JEeFJiUXVUTS96WXRaVjFQSisrWk0vRGt2MEw5aUZ4WnRX?=
 =?utf-8?B?NnMxbXpnQ215NnRiOTBwU08xdXZuYkJ5cktVL3F0cHJsOXY5djdueEduZ0Nl?=
 =?utf-8?B?QWw3KzBuRjZXcnd0TEVDSFg5TGowb0ZwYVJzcnh4Tzc5VmkvMm4zWEdUc0VF?=
 =?utf-8?B?V0djY1QxZEhHKzlHWlAwek9VM1Z0ZHNMeEF2Z3B1MlZaVW82RWQ0U0kvOVlY?=
 =?utf-8?B?TjhacW9rTFBseVU2UkZTRHpiQTkwQVNlTk5Ld21YbEkwVW1SWURKbEdORWpS?=
 =?utf-8?B?Y0VsY0xFdllJcTd0dlJ3dzU2bGNDUVIyNDZuMkd5amk2U2pCZ1dzNGl5eit2?=
 =?utf-8?B?L3NIVkZzQWx0b0pzcDZ2dzFGM2Vxa08vbDZMTmFUZWhtZzJ0VUllZ25Wdi95?=
 =?utf-8?B?cHk5QmJpSThaRGgzSWJ0TUppdGFWdVF0Zjh2Ym4zem4zZ3BGU3dxRjI0eWJi?=
 =?utf-8?B?S1U1azdGWWhDdWl5OFUrd1JPcDVvRlpDcHRQMjVRYWZPa3lYUWdSejU4UUtZ?=
 =?utf-8?B?Y3kwQnpUclNyOW9SYkNOZ3F0eXhmQVFZaE1JMzdsbWJ4Q3FBTlJubEtPcnZ1?=
 =?utf-8?B?b2YyUWdmaUgyZnZJNFB2TnE4eGUwN1R1THZlT01yTThlTmtHOFllYlZ0M3V0?=
 =?utf-8?B?Ymg3UDMxL05MMnVKZkg5a3BxK3RDQU9nL2RtdzYrVkJ1MEFYSXdrTnhEZ25y?=
 =?utf-8?B?dENEYkllaURrbG1yWXhQRlNkaWFGdHQzS2loTER0NDF4Yks0dkNUU2ZudTI3?=
 =?utf-8?B?VzhscnptejFLZU9pS0tkekVwSkp2aGJoMHRzWDkvNzQzTkM0OVdSMTg4QllS?=
 =?utf-8?Q?31zvF5BN9TFtm2C4Kf51KK+Kt7asfXTdmUDeJa+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azc5a0k5SVY0M1lUUnBnS2x6cnpuTVFPTkxXb0x3bHRpQkdUeVN0U0pzUDY3?=
 =?utf-8?B?OUZzay95ZTNXTVF3WjNSdHNLV3ZYZy9FQWxhdjE1SEMzUFlrV011Z2l4bDJ6?=
 =?utf-8?B?MWRDM0FyZElMbTVnQzBacHpISXdNSk9wSDhoVFRrZ3lYWTZ3Ly84SDdUekNQ?=
 =?utf-8?B?RzFpZlBPZDBDUkVZNVRJa2dWT2ZmbDJMc3NWOEdsWlpYenFkWGRuay9NSTRQ?=
 =?utf-8?B?c3NaL0NGREpkcTUreXhGM3JzVnJtSGg3OEd4ZFBkYmZzcWFVeGZqRSs1bXZk?=
 =?utf-8?B?ajZOOUZ0UzdTUzFqdmZUZ3JFQ1JrS3VRa3NwVDNQbWRXRitWbkJFanpVS09P?=
 =?utf-8?B?Y1VoU3NWWTJ5NTFTcnJ0UXl5QzFlMS9iNlN2RVhPbndLS0RtMlplWVA4b2l2?=
 =?utf-8?B?VHNYaXhvSUhkVlFwam1CeU5mUmNXWlBid1hORzBsSEI2TzNQRGFlUmVWUE9w?=
 =?utf-8?B?MTV6VzJzOGFERG9OTWl3MnlJSm9raEFSbFBkRHdLeU1RWEorZ1ZxTWRMYkFy?=
 =?utf-8?B?SEtLM1BsTnZmUmljZ2IrQTZ1QlU5OFlCWVBJZW92bW1LT3NXZVR0V0VkbEJM?=
 =?utf-8?B?VE1Ld2R0UGMyMkk0a21oU3o0NmtKSU56QU5RQkZDUjE4Z1Vjdk9kU1BWYTlM?=
 =?utf-8?B?d3RNb2FvakhMK0U5ME9KSFBoWWJRZXdoWC8wbnhkR0QvOFoyN05Tc2FnaU1L?=
 =?utf-8?B?QUF2VkZqem1SS01UVXVBUStTUmVaUTR1NlF1Vm5zcy8xd2RhQ3IvWWRtWTNI?=
 =?utf-8?B?ZjJHNXJsM1FkQ1RWM1M4a2o2Szd6a2VQWlVEMWMwTWIwK3M3enR6Mi9SU1lr?=
 =?utf-8?B?OFMwZ0orc1RzSWVidTFzM1JDcHM4c2tEeEQrY2VYZjBwdTJtMjgxR0RsMWx1?=
 =?utf-8?B?NktSdS9OdE41cXRiejRmNUFDSDJvbjQwM3dHMXFCSTVLTko5VmRYZVdJV0pQ?=
 =?utf-8?B?ajlva2loMVBxb2U3enhRTVdXUmVRSkluQ0cwR2szZG85dTladDE2dnRQU3Za?=
 =?utf-8?B?RUpHakQ4R3IzZnBXTkRlb2xVcWJjN1VHSEV3cjBOZ1prTldkZjBIMHovR1Jz?=
 =?utf-8?B?d3hBdCtLWENSYnBWQmVqcDhQUndJMTA0TjZFYWppNXBVVTBPTUZNL3lOUjlz?=
 =?utf-8?B?MjMzKzY2MzBWck1wYkNhbGprOEpVZlpiekNoclBEL3NJOTYwRkMrSlhxZHZm?=
 =?utf-8?B?TUhLTkJDNHhxaSs2bndXbncwc1duNElhVFlNY1Fub3psK2tSTWdsVnUvQmw3?=
 =?utf-8?B?UWhXYkRFbmhKdUlqZ1hJVmZJb1hRUy83THducFBHYk8vcFV1TXQvdFpoYkNn?=
 =?utf-8?B?L2wydFg0T0Z2ekVhZFdMNWJtTlpOdmN5SkpTMm9ZR2prU0tRM2FNMWl1cTF4?=
 =?utf-8?B?ZDVMb1dmTlU1a3QwNG9TenRjdmswNG1WT3FtK0ViT1hIdVJuTFZXM2pObWVp?=
 =?utf-8?B?THpNd3R4RGpLaHo2SmRJYXBnYkZuRE5ObDNwbHNFanNhallzekxaYSs5NUVB?=
 =?utf-8?B?Mm9TZ25hYVVxbUxtT3BGaVBPREJRQWx1M3lJSUIyZm1WZE5pUjFiaC9KbUV0?=
 =?utf-8?B?TWZjNHpsaWxkblFUSmxNQ1ZEWS9rR1lYK3E5SC9BRHRZWkRRNkErRUQwZVdC?=
 =?utf-8?B?anhXY1FhSjlDSmQrVTR0WGkyZmF3SlZqK0dsV2lHYlYrenFLeUtWaWk5eUI3?=
 =?utf-8?B?bHpPOGo0cDNWaUNnZUYzdGVIZ3RSbWJsQlRSdFJKb25jYmJWdGlXak1KaWlU?=
 =?utf-8?B?RFJBYlBMblJ3Q3dvVm1SOUQvbkg0QUdZd1hOSjdVQ09qNjV0U0FPOWpNWmVn?=
 =?utf-8?B?Y1NVbVdaSG0wNDFGd3p6YUpEMGYva0g3S01FUWs4c1hFVUd5MGY4Y0JIbVR2?=
 =?utf-8?B?dlhDSldSYU5NSUVzcUR6T0tpSyt3N1J5dnBPV1BjT1hKTUtNR0JPYytEOFBV?=
 =?utf-8?B?RVFLemVIaXVUZ2o5NzNlRWlLU2dOWGNiUFJnQ0dxNk0vN2xJYkd3VDZTTW1X?=
 =?utf-8?B?MDlLNVc3MWltNzliOTk0VjdlMFE5UUl5cjd6M28wTXlhci9qc3Y4MTZEOFFQ?=
 =?utf-8?B?b20rMkFDNmEwcC9rUXJ3TGdCNTRXUHBJSCtoTDFkYmswRFQ4dG9Qbm1ZSEhi?=
 =?utf-8?Q?4CJIVkjaDEJKzVri2NTWuCp0Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c69436-cf58-4f74-ed3d-08dd0020589c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 18:08:28.6037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edB8URlw50Qr+iuy7nKscv/xQLXgesXTdO7wZID7HxpEmtUq7JgPhzXRcUfL+YSltB5442a+RmGBlhAJ3fvHTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8968



On 11/7/2024 8:58 PM, Borislav Petkov wrote:
> On Fri, Sep 13, 2024 at 05:06:55PM +0530, Neeraj Upadhyay wrote:
>> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>>
>> Secure AVIC lets guest manage the APIC backing page (unlike emulated
>> x2APIC or x2AVIC where the hypervisor manages the APIC backing page).
>>
>> However the introduced Secure AVIC Linux design still maintains the
>> APIC backing page in the hypervisor to shadow the APIC backing page
>> maintained by guest (It should be noted only subset of the registers
>> are shadowed for specific usecases and registers like APIC_IRR,
>> APIC_ISR are not shadowed).
>>
>> Add sev_ghcb_msr_read() to invoke "SVM_EXIT_MSR" VMGEXIT to read
>> MSRs from hypervisor. Initialize the Secure AVIC's APIC backing
>> page by copying the initial state of shadow APIC backing page in
>> the hypervisor to the guest APIC backing page. Specifically copy
>> APIC_LVR, APIC_LDR, and APIC_LVT MSRs from the shadow APIC backing
>> page.
> 
> You don't have to explain what the patch does - rather, why the patch exists
> in the first place and perhaps mention some non-obvious stuff why the code
> does what it does.
> 
> Check your whole set pls.

I will improve on this in the next version.


>> -static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>> +static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)
> 
> Yeah, this one was bugging me already during Nikunj's set so I cleaned it up
> a bit differently:
> 
> https://git.kernel.org/tip/8bca85cc1eb72e21a3544ab32e546a819d8674ca
> 

Ok nice! I will rebase.

>> +enum es_result sev_ghcb_msr_read(u64 msr, u64 *value)
> 
> Why is this a separate function if it is called only once from x2avic_savic.c?
> 

As sev_ghcb_msr_read() work with any msr and is not limited to reading
x2apic msrs, I created a global sev function for it.

> I think you should merge it with read_msr_from_hv(), rename latter to
> 
> x2avic_read_msr_from_hv()
> 
> and leave it here in sev/core.c.
> 

Ok sure, I will leave generalizing this to future use cases (if/when they come up)
and provide a secure avic specific function here (will do the same for
sev_ghcb_msr_write(), which comes later in this series).

"x2avic" terminology is not used in guest code. As this function only has secure
avic user, does secure_avic_ghcb_msr_read() work?



>> +enum lapic_lvt_entry {
> 
> What's that enum for?

It's used in init_backing_page()

for (i = LVT_THERMAL_MONITOR; i < APIC_MAX_NR_LVT_ENTRIES; i++) {
        val = read_msr_from_hv(APIC_LVTx(i));
        set_reg(backing_page, APIC_LVTx(i), val);
}

> 
> Oh, you want to use it below but you don't. Why?
> 

As LVT_TIMER is unused, I will remove it:

enum lapic_lvt_entry {
       LVT_THERMAL_MONITOR = 1,
       LVT_PERFORMANCE_COUNTER,
       LVT_LINT0,
       LVT_LINT1,
       LVT_ERROR,

       APIC_MAX_NR_LVT_ENTRIES,
};


>> +	LVT_TIMER,
>> +	LVT_THERMAL_MONITOR,
>> +	LVT_PERFORMANCE_COUNTER,
>> +	LVT_LINT0,
>> +	LVT_LINT1,
>> +	LVT_ERROR,
>> +
>> +	APIC_MAX_NR_LVT_ENTRIES,
>> +};
>> +
>> +#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
>> +
>>  static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>>  {
>>  	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
>> @@ -35,6 +49,22 @@ static inline void set_reg(char *page, int reg_off, u32 val)
>>  	WRITE_ONCE(*((u32 *)(page + reg_off)), val);
>>  }
>>  
>> +static u32 read_msr_from_hv(u32 reg)
> 
> A MSR's contents is u64. Make this function generic enough and have the
> callsite select only the lower dword.
> 

Ok sure, will update.

>> +{
>> +	u64 data, msr;
>> +	int ret;
>> +
>> +	msr = APIC_BASE_MSR + (reg >> 4);
>> +	ret = sev_ghcb_msr_read(msr, &data);
>> +	if (ret != ES_OK) {
>> +		pr_err("Secure AVIC msr (%#llx) read returned error (%d)\n", msr, ret);
> 
> Prepend "0x" to the format specifier.
> 

Using '#' prepends "0x". Am I missing something here?


- Neeraj

