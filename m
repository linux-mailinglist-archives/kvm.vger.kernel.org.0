Return-Path: <kvm+bounces-45396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8239BAA8B76
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 06:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 902C0170049
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 04:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894231A5B87;
	Mon,  5 May 2025 04:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="De2rO3p6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A334C98
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 04:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746420653; cv=fail; b=l3lWn9r+K4/LwkgjXrnHhLR9X+tcx0XUQGcq2eQ74CnJpp1xV7I6HkhlkEyYg1zpmiiLAp6e4PRSxcVeq/Ab05I4aXRXo6jXsz+6mZeTwjJpPd4qSiY8MJBnxG3SVpEMKUZgmGv9mnceO99GLoHgNpJ2qhTItOqsgaBXm575O/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746420653; c=relaxed/simple;
	bh=L0VS65qJJzBx4Kcmm7GzwhDP0YZh+8fUmZd/BaGwd3U=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=byFhmT30ihjRG9pLMiWj7CNBkpdY6vN12XzGBta3pfVHT0XSFIEhx2+ZU5/eB6pNz7lh7fWIt6UYP50du96G2s9uaMWXb+tHu8Jt/8P91gm7bmhTYp7J65iSenbY9uzuWraCGI9PlsfsCUmb94Any+VgKRSW7eRqzQeED5FKEJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=De2rO3p6; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNesimY1W9at8t5NTJhlNJaDT0YLbFwVolWvYStPRUza9UBi5ng1fV0pA4hP7V9rv/gvmIPEAGlF0JcWt+bJV/4GG3+Y7i8eHWYKA440SIb2gK1NE0W6lj+Q+bOD7L33XNMpuQw3/qs9UtfHs5//oN1hT8uT3b8SL46FgWsq7LNeiGh/X2Q+V2KJDXFWT0rIEhtsoNswSW9CEVpKoOevbNVNoPJn5k0qERqkyqyxh1MpYrMNHkWMztQa5G9+2S18lOJIa5hfOmwMEGOB1mTZo/ikj+vhnT3g81io5RlRIH3MLhRvE/i1arGkjZ0Dff9t7CCde1VsXHLAu6123L2/6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YB1lx4KY/xU3WEEsGB/D5hNBA/ni+u1bEkFVhe7XSI=;
 b=XXufGnWWT8PfELUxro19BsIuulb89FK1aq66H5LGAgm28Tf6Yxxz+Ubq+k0bEsUCtIvdYkJxy828CujAZIIvSPjqbguYb16rDPlv49FDyNZiSOlg5oYDVo582X/rBkMTFWUVunHDcug+OxA/3bfyr29gaJEdXEcmA5p0RvDUJ3QO1j4yjD0Pe9/11rrR0WPBj9aUiPAgpVVGdYknlLhfdXHfziJaKIQwmga/IrAjCb1yq8Oe0KcxVsx/GVLnWFDNz8dW8UUGDFbwSZUri/14SDzjWXZ8IoERGRIzHhFG4ckwC5zFH0UPKGpxT7WejPbEwrgKI7+QvCCaCoJvxMR3jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YB1lx4KY/xU3WEEsGB/D5hNBA/ni+u1bEkFVhe7XSI=;
 b=De2rO3p6W0f5dNY1RwgKQ6MgLrbfHZZJaXtzFi5Jzybql2dgEy9wbscufqaHF84T4cTvsL+SQYpXxCXSk8kuaGNRbI0NE1lu/gWM5lmAr0/dEbhIE+Wp0sJkzANfvrJwiIY5isRhAZkja09tsYpPlhjsIdOf6vBLSe6Jwz+qVLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by BN7PPFEE0F400A9.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.29; Mon, 5 May
 2025 04:50:49 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8699.019; Mon, 5 May 2025
 04:50:49 +0000
Message-ID: <4f6b6a8a-0f75-4123-b06f-a8bf7eb36f06@amd.com>
Date: Mon, 5 May 2025 10:20:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Enable Secure TSC for SEV-SNP
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, vaishali.thakkar@suse.com
References: <20250408093213.57962-1-nikunj@amd.com>
 <7dd702a3-e9c3-4213-b0b6-799976d4736a@amd.com>
Content-Language: en-US
In-Reply-To: <7dd702a3-e9c3-4213-b0b6-799976d4736a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ac::10) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|BN7PPFEE0F400A9:EE_
X-MS-Office365-Filtering-Correlation-Id: ff57f1b1-d7a9-4b7e-5117-08dd8b9067c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVovbFNwUlF6Vll2YWZDaUVjMW8wWTdXK2tMandUSEYxUXNrQTJvNG9za1hi?=
 =?utf-8?B?WVRMYW5hOUZnaFlyamdLTGdidnFPaE52M3p5SFI4OFJBZU90T3BMZE5TRVp1?=
 =?utf-8?B?UWRoNHMyVmNDQVRXemg1Z20xVEhEMlFRekhJZ2ZOejd2bjEwa0s3L3N3emNT?=
 =?utf-8?B?TVNQL3lQQng5WmFWRURPLys3V3RpWGllQnNhSUpod3RIaWVLb0RrWXJYQUdJ?=
 =?utf-8?B?RnVzcm9yc0U3OGlKNDFMTVNRdm1RUHFsNVpyMzA0OUFwdHBQRDNyQU9pMFNa?=
 =?utf-8?B?dzhXUmFSNUtMaUNPYUxwYW93bGQ2a1k2bDhLb3pQSU9IV3Q5M1laZVpDM0g3?=
 =?utf-8?B?aHJ2ZUpOZVA2WThlVmhTaDRqMy9vNnBEVVhLNXMvL3pzMFp3akxMMHhleTlX?=
 =?utf-8?B?V1FhVDdnRzF5bXFaaVJaREtMTmNBY0xDbXo1VlZqeTZSM2tZRFhDaFl1aDVO?=
 =?utf-8?B?QnpicWNDY0NVVWpiU0RYREZtUE1ZcDVQdnUzcWZZMitJdDJxLzU0YjRrTFIy?=
 =?utf-8?B?b2hRSXpMU1dyeEl4RXJxeENuNFcyNVZURFJpcHU2VTdJc3dhNVJMV1EzaUZp?=
 =?utf-8?B?a1lDRXRDSWJIbzdBaFJCaTJSTFlBOThJcmFqN0RybVkxTDluaXZWVzFaV1Jx?=
 =?utf-8?B?TDNldDZmelBIMGNidzMvcytmQ0N6SkdzY1FENUM1c0dkSEtHUzIxaUV1QS9Q?=
 =?utf-8?B?Q1Zmdm01b3VYQjZVNjJrVmZYZE5JdVFQMTZ1THA5T0dUNFp6YzhhOC9WeHI4?=
 =?utf-8?B?UE9tcFczdk0rMkpKVzl4MmE4Y1N2cWMxMlBrWld3WTV0S3NQek85VzV6ZW1m?=
 =?utf-8?B?TTF2R1dQNmRDTHFiaktWSHNUZmFSTCs2MEx1MFllTDE3d09oY0lXVEoxQjl6?=
 =?utf-8?B?THliTjR5OXl4allLTVcrNXJyMmlTRTJIWStGT01EZHhLWHNRQzlmYWtMZEMr?=
 =?utf-8?B?QXJYR2tlaml0d3VDUFB5OVFlWWpQbnI4eFZVdEdlYnJkQ1NrK3NvYWd4OVU0?=
 =?utf-8?B?aDJpbEtVcEh4d29MTzFKbE9ZWHNYY0RYbGN1S1E1UFA1dGNrY0VCclJmcGpZ?=
 =?utf-8?B?MGQ0U24zclFyNmVldzRsNlBHWlJoaVNTZ2FwUEgrTTd0M2xCaFZXWFdDU2Fw?=
 =?utf-8?B?ZkdtSE9FRnM4aEZmaFJWMkd3bE5yV0pCNXZxQmN4cFRoUnJPY2oybDdwRW5m?=
 =?utf-8?B?dlM1ZkwrRFFpZVUxSUo3RlprV1dYK3lqRjlpK1dmQ3Y4TGVqWVVYeitWOTZw?=
 =?utf-8?B?VjF6enc4SEV6T3QxY0xCVmlPSm96djdheHErSVhWazNaVGtJRXYvMHd6cnZO?=
 =?utf-8?B?WFJxS3VJU0grRStlWXpmMUtuVWx3UXY5MXRCMDVLamJ2Mmc1Mi9mTit6R0Rq?=
 =?utf-8?B?dFZjckxvL1U1SGpLVWFmWVRVaTNScWZDb2RmZmp1T1dJbUI0ajZaQUxQcXdG?=
 =?utf-8?B?eDhPU1UveUdHUXk2UVVhRWhxTDN3ZzBVSUgyWGd0UWFNRnhVdDVwd0poL01z?=
 =?utf-8?B?TlRoK1lNSzNscDJlNDFuRmdxbUR1bHU5Z1ZBS3hMU29hdUtiaFVyZHMzOUVx?=
 =?utf-8?B?YTV4aXl6NERQNElzaStHd3Y4eFVtUnErNnc1Y2U2L3VXa2N3ZFdjcC9zMDFW?=
 =?utf-8?B?V085SmNsRGc1aHRId0J0M2o4bi9lWGlwZjhXNXVWRklOeEE2NWVBSHRDL1lX?=
 =?utf-8?B?aGF6M2RCMGNxYU1BSmU1bXp3TkRFQkpsSkhIWXp5YjVFUEZadWtpdlVNdnZT?=
 =?utf-8?B?VVJPWDlpb2tra1JzeXFQTTF6TU0za0xzZXpzT24zU2cwZFFGRWdCNFFVSlJX?=
 =?utf-8?B?N3kyU0YxYUpzSFRBSFpDZDNiM2l4YWFuR3NZcGVCOW0rUmcxTUxGSnNYQzE3?=
 =?utf-8?B?dDNxcTVWTjRCS0ZydVBad0w3Mk4vVVNSMmlUVTVFMk9aM2tWUG5uZ0VocGFU?=
 =?utf-8?Q?inKaHIxJtxE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0ZjSmdNaGVwVzNBRW1mblc0blpLaVk0RDhvVUR5UlRRYjlFNnYxNkYxZ1NE?=
 =?utf-8?B?U0NMVEdHcVZMSE9pU2twOEFPN2M1QWZVVUU1eWRUZ3BVY0FhcGZ3YTJlejZr?=
 =?utf-8?B?SWZjNTZSTktGVHJPdVZRQU9XMThZQzVhVUkvMUxUenJEaE1oSUw4OHNPTCtY?=
 =?utf-8?B?VXkzRWRCNkJqOHFZMlJuajZZOHZ3dXFudnBqeFBZclFiS1hwY1FwMWtKclpW?=
 =?utf-8?B?bklVdTRsTFcvOVZuaFhuYWlJVmxYZnhKbWtSYXRvR05JR0VIMGtCakFXR1FL?=
 =?utf-8?B?d3RjMEE5a1IyVE1nZWgrdTVVNUMwOW80SExibmc1WnRPOUVyaHhrc3JETStp?=
 =?utf-8?B?QVEwdzUrTVFWbmlNMlE5NlA3bmw2eHVaUEFad1Zha1hYWmsvYzhNRnN0VWtv?=
 =?utf-8?B?U2cxVVRvM21IYmt4cXprRXNOQmNOc1FBZ3ZVM0VLOHBSVitvZ041eFJaa1Av?=
 =?utf-8?B?U053bHdzU2NyTWxQdTNQVU1aK3lhVFIwbWYvT2xwakRaQjlMcWRkODd2NmFN?=
 =?utf-8?B?RUk2ZGlLMjd4QXRxRHNUbzhGQlJrZXMrS2VsOUgzZzFPNUlXU3FyZ05hd1h4?=
 =?utf-8?B?dm42VVhiT091MkR6anlseno2TTJodHpla243b0ppb0lVT2NKTjduNm11blNa?=
 =?utf-8?B?eXdPUGR0Sjllb3RWejB2RzU2MUM1K3JQMEdOa2YzUFFuZ1VUNEk0TnNhSE44?=
 =?utf-8?B?SnBKazJ5L0tXeTUxMkRJeU5ZT2V1Y3M4ZXd2M2RicDNiNit1MnRnSnlkNUE2?=
 =?utf-8?B?ZUdvV3EweUNBUUE4RFY4UnBjTG5iQmlJZnZualFmc2p1Z2taWnY3NVYvUGtT?=
 =?utf-8?B?bU1mYUVxSW5VNzZSdjRJdHUyUlVJTFJ0eG1kSXIwaElkK05qdHArNndwNFBa?=
 =?utf-8?B?aVZaZkZQdzNsai91bm9ORS93TFVrYW1iRDBkbjlPblpCNEt3enF6Rm1LTUxH?=
 =?utf-8?B?N2RVNUpjRVpka2FmaFhnd2F5YnoyRmhBQjUrejRaZFU2VGZsMGJQS2tSYmow?=
 =?utf-8?B?RFlsMUNQcEJvdEhtUitUY3RqUHRQWVVZa2F0SVdpMGRjaEdhdFJxSEozOEVN?=
 =?utf-8?B?RFhLcFpOdnRaTlBmWnR1R2ZZSW9UQTJLMWg5Z3lBSUUreDQ5bUZwSmpuNSsz?=
 =?utf-8?B?S1JTWFltai9yd3RNVy82Q2lkR28vc0Z3dWpPb3oyUEp3TElTMGlFOWpZQkF1?=
 =?utf-8?B?TkRkbGtJNDhCYlZ4ZGNaUm04YmZ0NXYwb1RIUkZxSjU4Yno0RkRkMXBBSGgz?=
 =?utf-8?B?N2JuYXJUWDhvTWxqVytxYlAwdDBJdGhuSVViZUl4OXhCM2RNS0lqRG1aVkRv?=
 =?utf-8?B?OHFONUZKQWhpMTZRUjliazhCZTR0UDg1WkQvdUxPdkVXRCtmdzFtQjdIUWlE?=
 =?utf-8?B?U2RFc2tKOXhwbkRhY05KRDVRMXJHdUtYcTFCREw0LzN6RzlYalVkcXhLY0p4?=
 =?utf-8?B?RFdOeEdsUXlGSHpQRHpUU0JCVjZxV1dvdDlSaEE1MlQwYXFXeDZPTnR3R1Rs?=
 =?utf-8?B?RTN2a2puR1RTZmMzTy9kYnU0NXpJUWVOeGN2akRCOG55UytnODN4WjhnN1Vj?=
 =?utf-8?B?dWx3YWQwNURJanlkem44d1pRUk8xZGtSOG8za3o3NzhVRnRPeS96UWNqTFA2?=
 =?utf-8?B?SG8rT2hycDJEQkZITVpwOVdKTWszNy95SGszcmdBZXJQcTNidVErdVRGWUVM?=
 =?utf-8?B?TEUybEJaZjQ0alV2V2czdEZQZUh0N1R2Z05ZbUtHUHZ3WTBvOVd6MmRoNCt4?=
 =?utf-8?B?WlJVYWs3SVpmeFY5MDVDM3VsSk1kaks3UFdrTUtmOTFpck80Z05kNTVCMTY2?=
 =?utf-8?B?TkYzV0JkN2ZHbk1XREpwbStvalFuY0NFZ0xEQVkxVVVLVmI5dU9CQVNscWQ2?=
 =?utf-8?B?VlQyOUN5S1RUaWluVnBNWkl4VWlhdG82Q0pEQjNtRDdTQTVUSEthUEc2Y3Zl?=
 =?utf-8?B?WXl3UVhDanhBZEsyamxKcVpraFlKL3FreVBSK0cvMld6RVZLci9NRkRvYkVL?=
 =?utf-8?B?b2hYZzh0eXN2dkM2YmhJdy9HK2RLbHNCZkZMamd2S0RJaEVub1pZYzRVWHJ0?=
 =?utf-8?B?RHJFcGhRbVVKYU9Nd0RnVVlXTzNOaVlpSWhaVVlibXJuR3Irc3NiaVM2citW?=
 =?utf-8?Q?cpbicgizH/Vbg3RqvxnvKGDD5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff57f1b1-d7a9-4b7e-5117-08dd8b9067c2
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 04:50:49.2875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88cE1BP1RJqsAWMAx6hlrU61gnXoRdV6LdNA5GjOlLHVjNIrRPWNlvqGTL7Y2JitsttKmWVcIA7STo/dNznpDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFEE0F400A9



On 4/14/2025 11:20 AM, Nikunj A Dadhania wrote:
> On 4/8/2025 3:02 PM, Nikunj A Dadhania wrote:
>> The hypervisor controls TSC value calculations for the guest. A malicious
>> hypervisor can prevent the guest from progressing. The Secure TSC feature for
>> SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
>> ensures the guest has a consistent view of time and prevents a malicious
>> hypervisor from manipulating time, such as making it appear to move backward or
>> advance too quickly. For more details, refer to the "Secure Nested Paging
>> (SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.
>>
>> This patch set is also available at:
>>
>>   https://github.com/AMDESE/linux-kvm/tree/sectsc-host-latest
>>
>> and is based on kvm/master
>>
>> Testing Secure TSC
>> -----------------
>>
>> Secure TSC guest patches are available as part of v6.14-rc1.
>>
>> QEMU changes:
>> https://github.com/nikunjad/qemu/tree/snp-securetsc-latest
>>
>> QEMU command line SEV-SNP with Secure TSC:
>>
>>   qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>>     -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>>     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
>>     -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>>     ...
>>
>> Changelog:
>> ----------
>> v6:
>> * Rebased on top of kvm/master
>> * Collected Reviewed-by/Tested-by
>> * s/svm->vcpu/vcpu/ in snp_launch_update_vmsa() as vcpu pointer is already available (Tom)
>> * Simplify assignment of guest_protected_tsc (Tom)
> 
> A gentle reminder, any other suggestions/improvement ?
> 

A gentle reminder.

Regards
Nikunj


