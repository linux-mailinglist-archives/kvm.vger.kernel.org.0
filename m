Return-Path: <kvm+bounces-28568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA95B999337
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 21:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A50DB2AC1F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 19:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6E41CF7CF;
	Thu, 10 Oct 2024 19:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NJ6BVJz5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2271990C1;
	Thu, 10 Oct 2024 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589765; cv=fail; b=aFrkL8f2Zj6Su1uHGGRzVvBnMJP0jHNx7a10/9nxGPhOugfCTGBrqyHP8PFlKIh3bIPj9t/KU8hJRZzxCHJApCFsBu2GcdRn8neSJmKTMHigPwu9vWcY+IcstdN086IugIeUyQXr+3HKtPvPETimo1INaSnRQFnXHddKqwByoZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589765; c=relaxed/simple;
	bh=qUEstWqX3cPM6HYDj+bHQ/UA5Q+vXJiep5vA+wVsLF0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=H7mM/PLpNSduCRgLHNEUb7Sig8shdL+dW/wxG5Jc+NOsxr1zAnV/eT0l5hbkhJOzFzTNm/CAzba3YRGnFBUmoGQkoJEpCqW0u78O3W7/BkAeqbKTMqQ4JaueCdYB0ENUGoWiwAAd5g5Bjat7cTU1GVIY1vLBLxELR/vbK9aC7wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NJ6BVJz5; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nySP5+4GdWIpZkJcjBs4UJbom7lnaeKnpA2svW9zwLHxxwygZPiSCL6nsXvhLaPKONYwZZo/uDGkyTe12rlyNN0iLEDcbm1Byt8EoC9bhnGPZF6fZt6xcDfEF9ULd5jGjOvXel8HovN0izb52GzFfsTQmZlqSlhUpf9WbhjKDNTQQZ31HGmg2zHmBrQHIPmH6nWMrbhdQJCLIMp3UkGf3TxZRzPkNJ/F4Jg5W2VlB9NyGV1mZTfMRq1RQmlz42eZfjjGURGAIWz5OAHe+XEBouu9vFEdpbks2rI5SGhCQCgtdFF85EHK8mo/dC5c7jqoXsB8wGFRaEUYGPuhEVy+3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABiCLnHkj2TrbeFwxyODPQ9xgfIGxkNGP3VKAno477s=;
 b=YLcR7itC7CWtxQQrHqtEWZRxPyoSbU/tfSk5TDnkWOvk9irbxi+VUHPMO96dayoexk3MXgTDhKYAWWq/0z1fBpcmfTKaxTCTEYdnziDVN6fLDK1XIox/9Do8F9Aro67kvNOwLRIg5TN2btJ18hz78ZGtUk+6six2OytNWTZMo0oxRfDbnLMtRYANr8PqkYnF2DSmvoh/DuNrSRYyuyghlNSlSashzUjcIL8WMqGbve/p5DkQiEvrP2n1LiIUGJxDpYonU3OkIDYxiATc2nXWBtFfREVrZn/46INSe5YnGjPrFgHricALZ/iCiutAfJtS5bRTc5129vRersCvJ/iyVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABiCLnHkj2TrbeFwxyODPQ9xgfIGxkNGP3VKAno477s=;
 b=NJ6BVJz5C0o4n+TqtPzth4qY57IxVK8eoY9wmFnjou8covd7kS508dnaTklq5mTJlfpxhfH6YGSkPizye6K+VeAdEF8FNZTm4mg+iCcJPEGWCIhTs2sLLe4vWfLQFrAsW8+ufq2rcdoFJSsrIyUpRq8wba+bDE3GGlqkZj4hdlI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CYXPR12MB9425.namprd12.prod.outlook.com (2603:10b6:930:dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 19:49:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 19:49:19 +0000
Message-ID: <75780a58-5070-e111-5d77-d29093305c8b@amd.com>
Date: Thu, 10 Oct 2024 14:49:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-18-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v12 17/19] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
In-Reply-To: <20241009092850.197575-18-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:806:28::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CYXPR12MB9425:EE_
X-MS-Office365-Filtering-Correlation-Id: 3369aafc-49dd-46fe-4f7e-08dce964a191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3BYYU4xbVNIazFoTmR2V1pvdE5FNVdHT05GeU40RWhjR2trdHhyMWJUcmx0?=
 =?utf-8?B?VVkva21RZ3U4ZEhiOWRVZFAzOG1TdThHbEFlUHJ1Rng4TG5mdXM5K24yeGtr?=
 =?utf-8?B?TUt4aDB0S0tXb0phRjIrTmVvaG55M1B2NlNvMFFra1lPTXpJL0laL0k2ZEVQ?=
 =?utf-8?B?bGY0Tkp5a0Y5RSs3ZUdHOVhNcnA4R3BKQVc1L0hrSzBGdU8rMmpqUEgyMUFK?=
 =?utf-8?B?UW1mbldGMmlvak1tWEJJb01YY2VTcnZnR3Y3WHVXb1JUYXVkV1VZUktBaDNo?=
 =?utf-8?B?NkExSDR0RXJSaXhWTG95c0JyNGQ0NHpEcXZqeThTM3lyY2tGRzg2Rm1mL01G?=
 =?utf-8?B?T3QwbUpnV2tjcS9NYW1NRkdKNERtdk1qMWs4cThpb1lzamNiZkYxdG83ZnNZ?=
 =?utf-8?B?M1JVR1ByTkwzWUkyZ2dJbVJ1aGU5NWx1KzBwVUpzSXdmeEhPNWpTOXpHYTBZ?=
 =?utf-8?B?V1loVlFlQmNkU3FIQ3UyRlovdmZ0WGtUcmlZNEZZY0ZINVVtRjBkdlNFYWly?=
 =?utf-8?B?MW81MGMyTzg0SVNDZmlrZThjMDQyWnlyRXdDWitWY21oNzNrSUVlOXBNTk5O?=
 =?utf-8?B?ZUNoMnlMNzVlVDQ4ZTZGb0gweXNkcTJTdmJUSjBzemlxbVJTZWZML0VmNlNm?=
 =?utf-8?B?anYxYjNkN3J0dzdoRlAzTkVMbHRhWDFhOVJwbkFFM3dCdmMrcXJYQlFrbWVn?=
 =?utf-8?B?WW9EZVNuZEt4cFZ0QWF6R1YwZEZ2YTIxOTdnTWhlWktPV3FVSXNtbmRlTVlJ?=
 =?utf-8?B?YXErUTZWeHUvdUx3TkJlMUtsLytLemkyVXhPOHA0WC90eDI4TXpRbXloYUM5?=
 =?utf-8?B?M0Q5d3RGSm40S3dBY09hV2tZY2VEYWprOE9mUzIwMC8vL3IwU0I5dWtyMytD?=
 =?utf-8?B?OVVLbW53Mi9mV1orS2NzdGVGOElYejh0bnZ2VU1pNlRkaGwzYkFuaFlCbjNK?=
 =?utf-8?B?c2k5UWhQbjNTdlFXbnM5UUtsRWg3dkROSjh5SitRdFBKNEs5ZE1LNk9QeTdv?=
 =?utf-8?B?ZlgwU0pYQmovWlRreldTNzFPbWtNRDdzZkM4b0F5V2VIb0kvR0dxSEFEbHAz?=
 =?utf-8?B?S3dUTDRVanAwekFKeEpaKzViN1NDT200bGIxREJjdUZ3UU5lQnMwK2NSbGc3?=
 =?utf-8?B?ZlZyLzhwek84TGJSUlA4MDBxZlY1bTVzZ0hoeExFbmNTTmRITXlJSDB2VWhj?=
 =?utf-8?B?VU0rQmptWnZnYlJTTWFhYTVxaFpvcStiUlRvK3I0cGhxdlNCTHovRzJiYnBr?=
 =?utf-8?B?Y1Ftbi9zbUNnNG90b3UyUFRmU0k4T0V3UDlLU2lqWTdrODlldDZXMU4zZ3pz?=
 =?utf-8?B?U2R6aXZkTXVldEpaT05nRFhtU3NnamZnaEZsS3FqbWhoMS9tempHaGU5QjNi?=
 =?utf-8?B?bXJtS2NWTVpOV2N5d1lKWFh0VGlUci9VNEFFdGN0enNuUzU5TEZibVlOSHZn?=
 =?utf-8?B?MlFJTHlYV2pjMmpTS3ppZFVHTWQ1Q2hXQkxjU3FlR2dsYkhIdmxQVWIwVjll?=
 =?utf-8?B?aTlRMmkvUUZYZ1NBbEFINnFKcDhnM01HTU1aeFdOTDVFMHlBa2hiOWZTRU5l?=
 =?utf-8?B?bVBKd3VtZjNQZ0xMNU1IYTRJSklTNWp3ajN6Z3pRZ1B5eFhDT1FGeGNrZ1Ns?=
 =?utf-8?B?TzJNSDV3RGJjNFJINXVEQk12cW4xRjI2T0NLMzRxdVRKRjVJdzkwZ1V3QkNu?=
 =?utf-8?B?ODJJUHA5eFBPYzRJTnJzc0s1VzVMbmRmZHMvQW9WaWpZK1RLYWhOS05RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzhqL2l1cG0rV1kxZTN0RHErMDRIaDRmTHFmZHJrRncvL1FpL2FMV3RPTWE3?=
 =?utf-8?B?b0N2SlRPejVPaWJGdUVUR0dCMUVaNENKeEQzQ1NGQmI5WUJvUGlzWDZRWm03?=
 =?utf-8?B?c1VNZERra2ZBWlI2b2d3UFQ3VFhhczRmS0V4OVZiNG1OZjdjbS9HbHBaTnVq?=
 =?utf-8?B?emRmYzVMbEU0dmFGNGx2M0M3cG1oUUpDUDdORHVLdGdJbHM3cG1QNGcyUjg3?=
 =?utf-8?B?VGhaT2VBSGpBS0pwZW5NSHJ5YU9WNkFoM0wxQnVEY29nTUZHNjVYSjBNZWV2?=
 =?utf-8?B?R2daUnZrOVRNbFJiaEdtR0NjcnlodTRrTWlaVUkyYXh0OHhVZWg5dWEvL2pX?=
 =?utf-8?B?MzdibXdublZKUzhLTHp1WUV2TzdXNFJubFBFTndrbmZCRVR6NlUvOWZ6WlF1?=
 =?utf-8?B?ZnJObTUrU0hnRU13TGN3YTdmcXE3dEllNm5KcUNJbFNySEdRU1ZzYXo5Q2pY?=
 =?utf-8?B?SGJmQWNwdkFieXBwS1JLZUhnOW1XamtvYTFjd3lTdW1WK21ZRlE3VEF4MWpX?=
 =?utf-8?B?eDc5MDNnRFRneUc2T2lHeGo2VDN3TVI1cFJxRUwrQ0FiOXJOWUxvZHJwWkMy?=
 =?utf-8?B?cWprNWpSQUw4RnpFUDJVdWJSdEtqY09uQ1laRDJWTHFyTkhwWHFxazU5ZFZh?=
 =?utf-8?B?VGNJT1M1QlRRRG1qdkpOUmYrNXlMRmVJZGFzU3dxR1pqaVdJMHpqOEM2NmZ6?=
 =?utf-8?B?bzJpWjNlelNpdVg2QUMrUER2bkExekl6dGloN1QxMngxSDVLTFJvSktXcTdl?=
 =?utf-8?B?YXJJWm5HeEJaOHZJb3ZNcmVrMGZGQjYvTTNRUmVSYnFNaWRYdlV5ZTFhUmhI?=
 =?utf-8?B?U1NiSDhjeFB2cXhKVmlHUTJIYmtqTXR5OTcvYlR5ZFcwRUdaZ2daa0tpaUFQ?=
 =?utf-8?B?ekJVazJxaFpJMTBaMGxoYUM4LzB4bkFodm5ncUpFemVEbFhPODJGNzlXcDc4?=
 =?utf-8?B?clJPbjBFeEczWWl1VjAxTTB4MW14aXRaRVZrUnhFUzNjSmhRN0g3Rmt4RmRB?=
 =?utf-8?B?S1pRVnJvZVJwenBZQW1UOVpWeVhjcUZRM0JCdG50Nlg1VHlJZVhlb3p6Q1N4?=
 =?utf-8?B?Y1dnVHBrM294ajJCTnF1MnpTVVljdEZBTkFJRHpZbWREN2VNNnlkc2E4OEtz?=
 =?utf-8?B?UkVWZFFTeFZMcDlITzZrUTE0M3ozZ2tsVXpEQWE0ZXQ5ZnVLZDc4aXlhZDd0?=
 =?utf-8?B?a1B6dkNXS3JmejNGT1FiMXYzQmpuOUxKK21UR0FGMUVlTG84U0tHc0RjdWpO?=
 =?utf-8?B?VnlzN3NBSk1ra0hPeWl6NVNqVkNMYjMxVHRWcVQvYkQ2TWhHcDM0UHNtVVV0?=
 =?utf-8?B?Q0lZSC9vTTFZTXNDWjU0VTZmNDlSaStUNXNxY1pHZ1hZT3pVNU5BaUJxUjlS?=
 =?utf-8?B?cFBwRnpadWRnd3ZYR2Q3ay9iOGQwN28xTWhuQlBKQzB1aURYVmxtSmpkb3du?=
 =?utf-8?B?OHY2OW1ML29UUnNlRDIvNUVNc2NaVTdyaTlkRmk4WlhuNXlQZnVqeGxLbzBv?=
 =?utf-8?B?YmFDWUFWWFY1WHBFcnh3b1Q5cVV3K2NMSTd3dHhMc0UwNkVudDd6c0U3WE9P?=
 =?utf-8?B?SVpWMGZLb2EyZWJmTVYrbVd5S1VPVlNsbDl0VFRuNEEzdHo4Ky81RURxRWlL?=
 =?utf-8?B?OENyM1JERWYwQXJZZXBlMXMrTE1hNENzMFRSRml4bjBRYWxsUGVOZGlJOGZS?=
 =?utf-8?B?bzEvUTkzaWpLQXZwVUUwRnBwZXBHY25qVDhmQU5HWkFEWUJTYWp0TFhZUDFL?=
 =?utf-8?B?STRZQWVsRFh2dWRrRjhSVUpMTG1iNEdxMVVUbEtJbUFBd3UrbkJyT2NIQ2Rs?=
 =?utf-8?B?cGtWOHVSTmtORVNIV0tMc0FxVDVjR0pvZjBIUlFVc0JBb05FejZvV01EZWYr?=
 =?utf-8?B?a3JDU0RBY2lXT3NQNWdWMWxtV3g0THVCWVp3ckQ5Z1NBRjQzVWd6aE1WbC9q?=
 =?utf-8?B?VFNoUVVta0VWWjhHT0VSUm1MZFkvN0p0ZjdBcS9zZzRvYWdDTlM1ckw2YzVh?=
 =?utf-8?B?VU5GZHhlYVNodkJqN3M4Vk1lR1ZjTDZVQjRFNWladU5BQkR0SDBlalRGb2E5?=
 =?utf-8?B?MTM4Z25JWWNXSGswSWgrYXFmL2Z6UkVhUGJCcy9US0plSDR3eUNzakMxTDJp?=
 =?utf-8?Q?qMHarm5BBSau5LUuMQ4VDu0BR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3369aafc-49dd-46fe-4f7e-08dce964a191
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 19:49:19.7450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRbIeTtvTS6rtMBr0KETSo3SmDG5jGsGYh2ID4R46ixlUsVZp9m3nY77HLpuOKvVL43vnZfR5AhSMkmczrllDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9425

On 10/9/24 04:28, Nikunj A Dadhania wrote:
> SecureTSC enabled guests should use TSC as the only clock source, abort
> the guest when clock source switches to hypervisor controlled kvmclock.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/kernel/kvmclock.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5cd3717e103b..552c28cda874 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -22,6 +22,7 @@
>  #include <asm/x86_init.h>
>  #include <asm/kvmclock.h>
>  #include <asm/timer.h>
> +#include <asm/sev.h>
>  
>  static int kvmclock __initdata = 1;
>  static int kvmclock_vsyscall __initdata = 1;
> @@ -155,6 +156,13 @@ static void enable_kvm_sc_work(struct work_struct *work)
>  {
>  	u8 flags;
>  
> +	/*
> +	 * For guest with SecureTSC enabled, TSC should be the only clock source.

s/For guest/For a guest/
s/TSC should/The TSC should/

> +	 * Abort the guest when kvmclock is selected as the clock source.
> +	 */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		snp_abort();

Can a message be issued here?

Also, you could use sev_es_terminate() to provide a specific Linux
reason code, e.g.:

  sev_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);

or whatever name you want to use for this situation.

Thanks,
Tom

> +
>  	old_pv_sched_clock = static_call_query(pv_sched_clock);
>  	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
>  	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);

