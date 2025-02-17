Return-Path: <kvm+bounces-38379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77982A38B49
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:29:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B63D1888BC3
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 18:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B9C235BF8;
	Mon, 17 Feb 2025 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wvsnzFCQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E5222F3BA
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739816936; cv=fail; b=IXJkLQMwk3kSN3qmzOnGd6AsA41tv+xT9xpf+PZCeQzyEN3Ssvf1SUQnmwEhezXEQwNJUl5ayjFs78ec6L3lSO6QLqU09q0Vxhh1J1F+JdFfZGbYWp/3UKnByZZT4EOEX1yfWxc87xdx2zudFaO8KaZ45839YpE+FHB96HS0olk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739816936; c=relaxed/simple;
	bh=b+g2kcIZirSu1zGSPpgtTellPCIeEOkWdbxMcGL+lE0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PFgQ+wrROQNOGVYh3oSXjs0xwJ5Y7IRkh31eOssjTgMgs7oucCI8h8paNxvhOuB8HrLZ00k6Hrn5bOyxPE/4ApuYBqZYZsgCbH0KLF2A4sW71CJx5jIJjZ0egA/Dj493bunWtJpsK+AV46pgpTxjIdNWygO5aaHh8EsCH/CYHc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wvsnzFCQ; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N90J2msuQwpc66US6C10ZaMa4k04sfCBW2o5iAIKnPnj+BejdSx9LMWW8Vp4ulNBmt3B5a+7KVTNOXrtdCPpMEceB1sk1+4pHlaQZcYu5TDxY1esvctSUOXti3pr3b2JEeqLxb6NuChgNv/5ke90qh2CWwCcvI8iILUIB6niESJ6Ww4YbRoJhB0rmxNlgIoCVudGhdDvkwIXJ514s4XzIc3W3kIE6kia6DmK1+c7q8IlzyXG/g5snIAU/HNkogziap+HhMmCwALMb2nYyLtkXSmO1zWaPbFsdOS3S4YD73TcLMp/qcIjg8MsHy7AANVObkIxbEkqRg9EZHCCqBlsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YB8X+yTL4vSDmpQyRY4d8EqrxV1fT8y60hb89XwiJq8=;
 b=yzqD4aPLT3YhHNQ5jmkR/s+OFskP5+bSN+73j3yzMux8KfjcsDFCkw3pUiAr0cyEo/kOdb6a1h82IbWcHzvwL0fIHLhGATpeNmF4tAmpukJVuRfkmPyWB/3Bm7Iet3Mg5oRO5UWZybKszCFC5m4WIIEXGvEL4OAfKowZH2B3/SPcPZ/z9udfpR/w1DJUUd2pSapBmW3wq1p3ChwsNnoTuC4M5lsvHO+MkyKt9DZJOJTyzI24XqI6m28rztztCbeZltHJFb70cRE2EYzJwOu1SneWGMk4OaCBmEPasfa+VY281m/mndhl09fkVRETC7RXskbDMhKD3Ql8euVZQNdT2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YB8X+yTL4vSDmpQyRY4d8EqrxV1fT8y60hb89XwiJq8=;
 b=wvsnzFCQvHBh3wnifcZik+tfCc2KzcQ1m1gRXhPyiGlhROMh95DjTnWCUUsvpRGxTQViFcISGM+dxA2bd8gJawsJypCFrNexgQn2zeUo2t9xhmDK9Cw/CFKDipQDLj6vI83De/0I0jIGeRzeZD1PXbgAKh+3WNoxtdImfgqURdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB7949.namprd12.prod.outlook.com (2603:10b6:806:31a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Mon, 17 Feb
 2025 18:28:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 18:28:50 +0000
Message-ID: <6ad0aa86-fb21-872a-5423-8eb996b0e7fe@amd.com>
Date: Mon, 17 Feb 2025 12:28:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/5] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC
 enabled guests
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-4-nikunj@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250217102237.16434-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0124.namprd11.prod.outlook.com
 (2603:10b6:806:131::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 591f51f6-aac0-44a6-5bd0-08dd4f80ec84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmU2VkZhNFpyM2dBZ3RZK0ZQWWoyRytxemszaGVjV0RTNDA3cjI5RTU3cFpX?=
 =?utf-8?B?OG1lTlVqUHI5enAvUjd3V1VTWmxrSldDSHpLUSs3aW9Ib3F5K1YySHl1TkE1?=
 =?utf-8?B?L2Y5dEVGSzg0WTNFOGFSajFBM0pHZnVVTGtzbmZuOVBTOEpDSFJGNFBkTHM4?=
 =?utf-8?B?S3M2R0xUekg2MyszeFhrSlRrOUN0MTVsTElQRkdXZytKd1ZYZ2RMRGVIVjdB?=
 =?utf-8?B?SUsza01IcWI2bExHZForZlhIaHFLT1FQekRDbVZOeUlIZHJKWFIrUzFIeExv?=
 =?utf-8?B?bXZYcGZOL2tCYkhTVEF1T2NuZHQ0TkFJRGJZUmx6VURUcmtyOEFFbmZud1FG?=
 =?utf-8?B?Y1lQQ21MdVRHR0pwYjFudGJUKzA3aXQyODNmZUpReHpIbGwzeTNwL012RkpB?=
 =?utf-8?B?RFdiNUhrcng5cDBiY2pYWjEvQmdOa21CSFNRNVEyWTh0VFZrMk1GVHJsK1o2?=
 =?utf-8?B?bEdnU1l0R2ZQa3dWbDZCUzNWblR5M2FKMXd4MDlQQUc0dHc0R25IaWdNdGxt?=
 =?utf-8?B?Y0NkS0UzR0NoUElxOHRxcTYvYkZiUzN6NHBqU0VEdmIzSkQrZm9JUW9LQUEx?=
 =?utf-8?B?RTliL0hPQS9DMWdWUmZaSjE2TkthR09GN3RlNzQrQjNiUUZtQUJ5ME5XOW9z?=
 =?utf-8?B?Vi8vcG5zMk1kaDNsaVpGeEJiREUySkwrZDVNazYySDEvanBKM2E4QXVKZWI3?=
 =?utf-8?B?dUpZbnVhOHo2QUUvWURLZld3YzdKWERDeDJJNllkOUxRUTY3aC9KeGFqQ25R?=
 =?utf-8?B?YVZsa2dyNWs2RTVXd3plTXFmWThOWmhFQTZTSzZrY1NRZlBxWndMWmF3Z0No?=
 =?utf-8?B?UkoyMlVhRURjQmFmRFVkM0RSSVdLTEVkVDB4MkhBemlBNUVUMVRqUDlXalhn?=
 =?utf-8?B?TUtaMXc1eTVKTnJ2bjU5K0VNSHQxR0tRdkhoRXliNzNkaHJ6WUFldTlqcEZo?=
 =?utf-8?B?UGFvM0lnU3pTYWQwczhucktNcnAvT3Q0bThsRHhOTDA0RUNtTWFueWlyRXhu?=
 =?utf-8?B?N1ZpTC9sZWV4MEpMaTRSVk9lbFlmYVE3Nlp4aS9pcDhIY1JEM1djanoxS0V1?=
 =?utf-8?B?aStUTnEvRmZ6elZaeHZNSEpnKzgwc1hUZ2lIdWxPQU5acGlTTmVLOHB4Q0gy?=
 =?utf-8?B?Z1diVGQ4Q3BpZjZtQjdEd1dQNHIrNWNjNldaSlVxZnZoRTlUKzk1Mm15dnUr?=
 =?utf-8?B?L3NWMm8rWW1xU0VKOUp6RkRBYWJ1NStyUC9qblJHUHdiQy9IeE4yVlRFdm83?=
 =?utf-8?B?NlFaVGtQQ2REYmcwRnUxWnJSWDJkTFdmK0w2N21JQTZndkVseEhSZzNDSUp2?=
 =?utf-8?B?YlhsL242dzhQM3RmdnhTOExHbFFzY1dreU5qeXl0RUR3VE01NlI4ajdLZ0Jz?=
 =?utf-8?B?WDN1dW52dkhlaU4wMmVtT1VOWktjZ1VtZi9tQUxnYUhTNjNaMGl1Y3RKNFhw?=
 =?utf-8?B?Zkt4SzFYbzdmeDgybkNjZWNnWHpRKzRXbmpVdHM0RG9QVU1KdU9iZStWamJN?=
 =?utf-8?B?eVdWRkxnZmFPanpMQ04vSFdnN01PbUo1VUxPSU1xV0lUNmlpOGVMZldsd0x6?=
 =?utf-8?B?dVNod2d0ZDVUOTRORTVmbnR0S05lV1hmNlpWVjFPWm5uV2pHWXdxRW9jeHZQ?=
 =?utf-8?B?bTE4ZUt6Y2NmdWhGTDFqbVlXKzFlSDlEdU81d2FHRzhZWkFSZ3lnd2hnWlor?=
 =?utf-8?B?SVUvcjlQY0hBZkU4eStrMUdITHlOdlVIZjJFVngvcUNxbU9TV1owd1AzRmZp?=
 =?utf-8?B?RlZKb0MwUXU1QWdGMDdDM3RKdUxqQU5BOEp2QzJ1M3V2b1VUT2FMWUF0ci80?=
 =?utf-8?B?VElUZ3BpUTh4WGFuU3d0QjZKMmFPajluaDBsVDFjQURiU2VVMG5jNDRuL1Zz?=
 =?utf-8?Q?7KntSFX8etOoC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnhDRXdoR09XOTlDNVRjZGdCeHk4SnovbjJPQmtuSzE0MTcwd3VFNk15MEVm?=
 =?utf-8?B?K2VKTkM0K05YYU0vV0RBekRMaDg0NG9nbzloNXBaVmhSQUVDSGR1NURKWCtI?=
 =?utf-8?B?TXZua05reFRHdmJMNUd5dC9lV0Q5RlhNQUpmekZxRlVFTlAvT2t4NGJtbm9H?=
 =?utf-8?B?cnRScTMzR1oxazI1cTQ2VkdueEVieFRkaE9HRnRaY3NlZjFOTm5OQ3kyRG16?=
 =?utf-8?B?NkNIOVRUWjNVSnIzc0dWY2xJaU1NblhpVjdXcUszaURONjFzVlNzY3ZsMGls?=
 =?utf-8?B?VGFMM0tYVGlyOTBHY3N0LzBESnVBdXBYUzNmaGhKamZOMkViMk1zL1N3K0hW?=
 =?utf-8?B?U1lDSER4b1ZWUzgwK2d4QXpFUUN3Umthb2JxQTVlN1JOQWR6UkFHOVlCQjk4?=
 =?utf-8?B?cE1TSklnbFJtTHNjL2gwSDA2V2pSUmx3dEtKZndxeWw3eFNyL0xEc3lJejVO?=
 =?utf-8?B?NmsyTk5lMzN0T1Jpei9ITUFGZUY5cURCV2lSYTB0MFI0dDNUdlM1aUIvV0FY?=
 =?utf-8?B?ZHNRV0tyaUlEaTJKUGROdG85Z2tQMzlCRjhuME1xWUQ4MERBVm1ybGtxS0xQ?=
 =?utf-8?B?T0w1RHA5YVI4NzAyU05qL1U5a1dETC9mSjlKc2ZydlFoQXVDVkRZUS9DNEM1?=
 =?utf-8?B?NGZOaUtOSmxMMXZiMk5oWnA2RXZjTDRuWnhnVHY5YVNXdWJBYW52U2Yvb3oz?=
 =?utf-8?B?NlYrbk9lWUd1VTFwVEF6YnF0TkdYU3A4a01keE1RU1VSdkNKQzNxSXA2NXZC?=
 =?utf-8?B?Ky9CRjBaemVjWG1ZR1VPU2Mzd2RNRGpDbkxILzRucGpvSEFiRCtaWDZGNXZ0?=
 =?utf-8?B?dmdkV2g5S0p1Z28vdGFhU0J2eGM2UFFqZ3ZBOENDVEp0YjNsNUVQaXg2dlJK?=
 =?utf-8?B?bFMyUWViNDBVNENUcEE4VnVQVFV4SmhPVDZhQ0JYNU1aNW1Nb00vcmk0dlNM?=
 =?utf-8?B?dFdoYXNwNW8remxOTkM0QjZiOStZTythU09Mc0Mya1FpUXowK2VSaVBNOFhP?=
 =?utf-8?B?bHk4RnN5K0N3OVNCejRiQjRZUHZRbDFPamt6V1B1azJyUVg0ZGNXN0hwbEJD?=
 =?utf-8?B?bDN3WlZsS2ZZWUZ5bmVlMERMYVF5OS9BaHNMSHRaUVN5bSsvWUhtU3pKb05s?=
 =?utf-8?B?UWkxazh5VFVwb0tvY1JaamNkQUVzcXhkemkxM0c0M0IrTTJ1TVIrSDVZSXhS?=
 =?utf-8?B?U3Z0a2xKVVdDK2xrK2FQazdCWDk0bUlja3JZTG81Q2hiOVJiRGN1Y3BHNWpx?=
 =?utf-8?B?RWcwNTY3NnhwZUlEVWovT3RhUWU1aHkza2NLU0k2Vk1yQlEvQ3dXaEpScTRo?=
 =?utf-8?B?cy9vS2xSZ2FTN1dTSjQ2VlVUYXRSbDB3MEFxT2QraDNlWE0yM0JhNWY2T0xy?=
 =?utf-8?B?YXhzcS9qQlF4a0c1VVREdFFLVFBPWkJPUEI1WTV1dWFyMEhNeFdRNGs4K0R5?=
 =?utf-8?B?OWNZb1RIN0dVcVJYb1FvK1dRQ2F6ejdhd2lIRVBaa0ZVVEZURFB6WWM3aWxs?=
 =?utf-8?B?NmFJS1JtRTIwYXdwMXVQVkdSQkRrYXBDaE4rL1c4bFg1aEdzUThJMTR6YTJX?=
 =?utf-8?B?MEhVZDRJbXE4YTNzanFMZ0JIZVZNRDYvQWw5YlFzSVBtMkhTc0lJOGlHb3NZ?=
 =?utf-8?B?SkxNdUdDRWhORVFMWnhWSWEzRWtFbkgvaWJvTVRtYUhBWk1LTTFLOXVJQ3Zq?=
 =?utf-8?B?T2tuT29JK21JaWRjS2RlNjlKWXh4OHVpZ3ZyR2srVWZMN1hwZFVoRGtzRkcr?=
 =?utf-8?B?cmo3MHZiY3FFd1Y4eHA4ZENwV3VNL0ZINWJoM0pjRUo3a2JVZjErL0NYbWVF?=
 =?utf-8?B?Rzlxb3ViSDRvNFJwTm5ZcE40MEpVamNEZmkyd1B1V3gzMGxyUXgwOEIzT1hQ?=
 =?utf-8?B?UkVjamxEM0FKRVBvNHNSelZOK09vcDNqd3BDTUk0WTF4ZFJyc0FGNnJnTmZY?=
 =?utf-8?B?ck9PSEV4N3Q4N28zR01zenpOZlRsVlFmb3A1dFRKM1laTmF0Z3YzZVVSNXJu?=
 =?utf-8?B?OTMyVXBTRGFxancrdGxKYWVWbzlKeU55a0JtNS9za0RrRUZWVXBVZlA3RmtH?=
 =?utf-8?B?bGF3Q1N0USsrM0plUzNFaHlLbnlKYVNBRTlqa2RRTmg4TmlQMVBmaUtqUzlt?=
 =?utf-8?Q?Y3a1ICxSCRVF51ICbEXx1kBsz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591f51f6-aac0-44a6-5bd0-08dd4f80ec84
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 18:28:50.0155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hjWRJvKXiUiXiLp2vWUvcyWpSfIsORBXUh1OT3rwaHOq74bi15J7hLTPDQAgxr7Gag+aE6I+jbBcY40is1mXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7949

On 2/17/25 04:22, Nikunj A Dadhania wrote:
> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> hypervisor context.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/sev.c     |  2 ++
>  arch/x86/kvm/svm/svm.c     |  1 +
>  arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index e2fac21471f5..a04346068c60 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -289,6 +289,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>  
>  #define SVM_SEV_FEAT_INT_INJ_MODES		\
>  	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 74525651770a..7875bb14a2b1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -843,6 +843,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->dr6  = svm->vcpu.arch.dr6;
>  
>  	save->sev_features = sev->vmsa_features;
> +	if (snp_secure_tsc_enabled(vcpu->kvm))
> +		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);

Seems odd to clear the intercept in the sev_es_sync_vmsa() routine. Why
not in the sev_es_init_vmcb() routine where this is normally done?

Thanks,
Tom

>  
>  	/*
>  	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8aa0f36850f..93cf508f983c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -143,6 +143,7 @@ static const struct svm_direct_access_msrs {
>  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_AMD64_GUEST_TSC_FREQ,		.always = false },
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5b159f017055..7335af2ab1df 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	48
> +#define MAX_DIRECT_ACCESS_MSRS	49
>  #define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> @@ -377,10 +377,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
>  	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
>  	       !WARN_ON_ONCE(!sev_es_guest(kvm));
>  }
> +
> +static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +
> +	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
> +		!WARN_ON_ONCE(!sev_snp_guest(kvm));
> +}
>  #else
>  #define sev_guest(kvm) false
>  #define sev_es_guest(kvm) false
>  #define sev_snp_guest(kvm) false
> +#define snp_secure_tsc_enabled(kvm) false
>  #endif
>  
>  static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)

