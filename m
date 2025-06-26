Return-Path: <kvm+bounces-50791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B88AE95FA
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47D7B1883240
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 06:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D7A23535C;
	Thu, 26 Jun 2025 06:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QLQ3cTOE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2084.outbound.protection.outlook.com [40.107.100.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF82C2264C5
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 06:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750918267; cv=fail; b=rEEMsctyLKIBMeWCdTZ8JltGuiT6URuBXHLJO7UcF0MGDbOUGg7UtTsyEtUk1o2YQVXVQeNlDN+MCjBogREIMu7wFJ34I7XFfmjFY4UE5Z4NnWcP7j5z9hGsmgOYkuYDemSFR5Gu1L/fQ+ZnTnOysxwLdC2YhOomS/6md0eGM0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750918267; c=relaxed/simple;
	bh=AUyn5uCel46aaIMVMZd49vn1rrQ3rO7Ep3iBSPVWoFM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dVXocd2n467JDoTfcID+LjDZrpMzqhbbMTZmwJacla7HQTrp8MJs9NJLLv5KmC68FhLeHcc4G7cb41pv8rq3h0byrkXMEaBUrl+66fou6GyTzQXuBc9aBhrv/ttSxSY4c7JMat0O1KTkqe+IHoObGria42BUO4lKn/xMRphmqx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QLQ3cTOE; arc=fail smtp.client-ip=40.107.100.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wh7n6sURL3umfKWvEJ6YCxc69bgWGiw/6WU8PhQOPJ0N7DdZfxE3RtCA97SybOWl5bOiMl4zD9N7Ly+KKqw89C92roF9bVudh1MuLcRiJ1RLqxVEjDk86chnSJXVNhcqEG7CnbeHx/12jVOlfAlfwt/iq8z0XNHhoRU6x7F92NZFHeuOKM4eO0PQrX/pn+q/BME8ZM28NW7wso5exAuobAbMZkIRkdtDbVWIlftdyZPER8INNkUAuxSHVzxgRAoDzgZYWitElVe2Nk6sBgxcwcncBzd5d3qJCTCLkvp+nvlIT3c94ePUNYLVTbLZXszvuIFj1sJHMSwdqGhscVzsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zv05Tm37aFuAf4gBGXKpKoXmc1k5djf6LA7J/Xb9BCw=;
 b=X2U1m8T8XLglLU1mfwu99kbYudJ0RY4KsIwXq+PFxylWJQrDOtO5lMzlhl9+ELPsz+xci26rnx8Cb4ZiiogvMB3GucKHYd6TUxSaZUh0cinaF7iMXkq3Q3qfIJuziLCVR3BL3FdBK6ewzK55MoXzXomSCBGN36aO8gA4mTREU6AA4IbaLCDsFTlNv7XlUj3TelF+Czvq5r3Uxh0G3bk5J/TeZ1Byn/5DnR56ba+mGMmQuuqhkwFaWhKxOhWzcfcMlcItMxeIevQGMdzhSX+NitvH2GL7fBH4xHZU+dHI11AZlSNepgI0g+qUBwqZIVxm6JZf5S7yjsg4YhkekK8CgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zv05Tm37aFuAf4gBGXKpKoXmc1k5djf6LA7J/Xb9BCw=;
 b=QLQ3cTOEy4zJPCNAEw7zyC6FJsjwOZEAgOeMdZGv+7RhGlBN6x7/EhJYPh+nn46LrO0vrc9z0WU2aLcyTihvjIs23B/vKtf8JiWmIKZJhP4AocJMxHAUqRoHszfk2Om4ifmJkCuvmN+fBgo7w72qSWydruy896i/Xq/ntDRCBbY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4SPRMB0045.namprd12.prod.outlook.com (2603:10b6:8:6e::21) by
 DS0PR12MB6390.namprd12.prod.outlook.com (2603:10b6:8:ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.29; Thu, 26 Jun 2025 06:11:03 +0000
Received: from DM4SPRMB0045.namprd12.prod.outlook.com
 ([fe80::3a05:d1fd:969c:4a78]) by DM4SPRMB0045.namprd12.prod.outlook.com
 ([fe80::3a05:d1fd:969c:4a78%4]) with mapi id 15.20.8857.019; Thu, 26 Jun 2025
 06:11:03 +0000
Message-ID: <ae800085-f3ec-4481-87f5-b72a37e947d5@amd.com>
Date: Thu, 26 Jun 2025 11:40:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Enable Secure TSC for SEV-SNP
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, vaishali.thakkar@suse.com
References: <20250408093213.57962-1-nikunj@amd.com>
 <175088961694.721025.5248353991381426195.b4-ty@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <175088961694.721025.5248353991381426195.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0130.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b1::10) To DM4SPRMB0045.namprd12.prod.outlook.com
 (2603:10b6:8:6e::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4SPRMB0045:EE_|DS0PR12MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: 2344816a-60a2-4c94-6a9d-08ddb4783a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RCsvckZVSmNTQURFNWxna2UrN3VCdzVGMEtHMHMxbEs3TmxRbEE4TTlxamhB?=
 =?utf-8?B?dU9YZUdRd1p4SWNyeW5jNmVwUUJiaENPQWM3Qk91b0FjaG5SKzRHUFlJOFNT?=
 =?utf-8?B?MGszdUY2c3g4Rzh2dnhDWHdoWGZCZXNBV3pYQytNWFRZeGlkSlhCRHZNUFpW?=
 =?utf-8?B?akQ0SllHVWF6YmUzeWRzTkFMVlF2elRENVkwRVJTL1NmZjZKQm1icjNYR2RC?=
 =?utf-8?B?RlRMaU1PRndYMnRMTDFscmtlckEzUDFtbjRVVzlYa1kvcjNDMFdkWjY0L0VY?=
 =?utf-8?B?NUpnZHI2L010eUkzRlcvSGxIbGNoYjN2YlhoT1BRSmpSa3oyZ0JHZnZTdWNG?=
 =?utf-8?B?cnlQaWdSYmRta3ladCtENnNRelovS1dHcndkRGJGZnR4bXRPRndPMnpwWmJ4?=
 =?utf-8?B?VWdiUG9BVVZvSDllVHZ3WlBRQ0QvY3VRRlN1S1p0VEJNd2RMM05VMUpRZ3ZY?=
 =?utf-8?B?NjdEVXFLTlQ4c2FzTjVWOHZzN2pnRHVGOVVlWmwyVXp5dnN1N2hzalIzNi8z?=
 =?utf-8?B?SUV2VEdzTFJoajJ3akt2YWFuNEtDSDNhSjVtUkVKOTQxRUZWMjkyRVZSWHhs?=
 =?utf-8?B?Um1tMGpvVEUvSnQxRXRHczVIWTQrdlhHVlA4cm1YZGEvbGlWM2E0N1NoTXRr?=
 =?utf-8?B?ZGxtWDU1dXBxWHVCaHEvUFFMYkZkZThpbEZRalhpd2YwWEdkQm9rQ3FvMkp2?=
 =?utf-8?B?TXBKeFoyemRLZlRLUURnTmJNaExLWnZWTFl0S3l1RlVubkYyTm8wRFk5Ymk1?=
 =?utf-8?B?aE8wQTNpMW54bnRoWTlVNnlScmF1eUdLcSt3REo0NExNczhMYUlGSFlzSFQ2?=
 =?utf-8?B?dm9sdjlyUXFBeXhhQ3ZUVzE4b3I2b05jblh5UkQ5a0FxaFVmdVVUcUFIUUli?=
 =?utf-8?B?cGVLYllZbVRlSnlMd0xHTWFkRWUrSDZzZ0pLVW10OUNldFgxUkJFem1MVHNT?=
 =?utf-8?B?OTJrS1ZtcDd2MGg1OUhMSDE0RTI2ZTdaMlJlclZaM1cyN1R3NS9pUG5pWVNB?=
 =?utf-8?B?RkNnaU53elRVTjlTbXQvb2RQZnBXQzJJcFVlbU01Yk14OWtsWU5NbVNhOFFq?=
 =?utf-8?B?TVF4QmF4RzgrbElvK3Z0Nnh0Tk1zQm81dTE5Z1hDTWFlMUIzQytpS0dWWTdW?=
 =?utf-8?B?V3c3dDNSMnN5Y3BTVHl0K1hvMlM0WTBENVNWOE55dnp4eGp0cVJvS08zSVQ0?=
 =?utf-8?B?VFg2MFYvZmx2ZVViVUhwOGJJcjlpdEZaS3g4MmZYUHhyS1J1d3cveStjenFP?=
 =?utf-8?B?L29uRXl5dE9TNmZyWWZ1UVRsTnN0LzZGQXJXZGFwQ05jUmF4QWh5U1dGSVdM?=
 =?utf-8?B?Q3J4d0pBTFNZa2k4WFF4eVZGN01zOFZ0dW0vQU90UGwrS0FyVEpBTTlOMkFQ?=
 =?utf-8?B?bmhEOXRtUU10cHg0blBCMUMvV0ZnL2IvOTdac3JvNTlUVmZXVzhhU0R5c090?=
 =?utf-8?B?TlkrS203QVh1TzBOYll4MGpHSTc3OFVnbnRzckIvME0yY2RGUDJsdDgyQktF?=
 =?utf-8?B?aWF1YnJuSnZmVmllYUEvK01jRk1VbXdjTDYzazRhZ0xQM3hJU3o0VmJjbis1?=
 =?utf-8?B?WUNMbGx0N0lvQTBadDdxYVRwaGdjUUJHUTdkbDFCZjdlK0JJZ2JjYUFFdVZj?=
 =?utf-8?B?dThZcXd5RXlvMXliS1dCN3FvTG5uRmp0L1RZV0l3VTV1ejFrcU5BcjlzN0NS?=
 =?utf-8?B?TU00NHpJcWFzU1djK3c0bUdSakpCRDk0RmZ5ck8yQWJtU2VwK1lQbFkrQUt3?=
 =?utf-8?B?L0VBcHpMeHF0OEw0azk4S3BFS3U4TncxaEpNNkdpTmo0aFdKR3dIMlJtb2k2?=
 =?utf-8?B?WGE5d0NpcUIyMEVEcHBtUjM1ZmxFcEZwZlNLZldsRm9XV1dZMlNsT2M1ZENs?=
 =?utf-8?B?dmU0M3pxczdKTGdYU0hVQnNabVRpcDdybDV3bDB5bVJTVHY2NEY4dzdIelhn?=
 =?utf-8?Q?2uq7gxT4Fjo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4SPRMB0045.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzJsVnFLSTFtYVdDdW9QMkVNS1JXT1QrUXp4TWgyNGdJZWFHdEhDRTNDcmdP?=
 =?utf-8?B?L3ZsaHBweWhUNnZPZFlSSkxlTTRRTENhRkVEOGdqODEwajFpMUF0UVI1ejEw?=
 =?utf-8?B?TnYwVUZNUndyVXdnNHFWbzdKenpBT3ZRZFBsRGc2RWoyb3IzQW8rd1NjbXd2?=
 =?utf-8?B?bjd3QlEvakJ1SnZDaEpTSkFaMWt4YXB1RTBseWFJRUEwRGQrTGdnL0Fya1Rp?=
 =?utf-8?B?SlJaVTU0OEtPcXUwTFVOdHQ1TE9yYW5YUnJ3YWN3L2JuTnNxbWllblNqcHd5?=
 =?utf-8?B?b3JFejExSEFnUDdiK1Y5Y1NscTczWWp1QlNpaGU4d3lqa1RPR3pXMWJJNGth?=
 =?utf-8?B?M3Q5eWMrYkFjMTEzYytUSnIvdmVFQVU5WndCZWE4b21ocUdUQlpnKzMrckxh?=
 =?utf-8?B?djgxOVhueFhsQmc3b2lTbmZTVUU0WFRPWlhXd2pxTkxIVHNEcERnd21MaHQx?=
 =?utf-8?B?ZFZtekhIKytDTk41MkRISkNnMmlIcEVqZkFDckZENGJMQU5IRTR4NWhwa3FG?=
 =?utf-8?B?cVBzRGV1TUNPdkZ2ZGljZWdBMnFPLzNIUG1mNmpkU3RVaW1MWmdQaEVSaTBQ?=
 =?utf-8?B?TmFoSlhLMzFrelJsdHg4d1podG1rQmU0Z2VCbU4wZFdSZlMxNTk2clpFNFRX?=
 =?utf-8?B?Um5hNDk2VjQ5TkJjVDNZdTJjNE1ta0VWTUQxWmRyUElMRDd0Wmk3aDN1b0Fp?=
 =?utf-8?B?S3JzVmxzU0NRUnJCUWZBbE1MZXMzYXJtRXFYL2Fjb3FtZDhjMlB3MklDWnc5?=
 =?utf-8?B?R2FYY1RCRURaR1huT0NuVFVIL3R1Tko1b1lQUVgva3JGZTN0UExNcTVwZUND?=
 =?utf-8?B?Vjk4T1dtb3Y5aGc5T2Z5UGtoRFRDbjNmVVJaWURoS0FHVUJkRU15TDM1VTZY?=
 =?utf-8?B?SGpPL05CcjNzSDUrSTR1ZnNVdVAyMGdTQStONVYwa1R5dDR6a2lPRzlTM3BT?=
 =?utf-8?B?amc3aEErZ2UxaW9WMjlXZFVLYVBSNnBHOVlUZklZbUJwTC82VHFhY2ZzclJH?=
 =?utf-8?B?OFcrcmZDeFhrb1dIT3UvU2JqL3pqRlJlZS9FZ011cGhyNDFFSFp5WEN5b2J6?=
 =?utf-8?B?U0hFWFZTUElTaEkvYUNqb093OEVtZ0d0bTJCYTIrZjNyTzVJNzY4dlFXTnlO?=
 =?utf-8?B?UDl4N2VNR0tEMUNyNUkrVTdkY2dubWw4bFBFU0I5Q0h5RkhXQVhuRGlwaGll?=
 =?utf-8?B?OVJqYVF0S1VxcTRUWWRXaFkvdnYrNFNqRVUvM09lanp2Mm9rczdPNmUrNjgv?=
 =?utf-8?B?T2p2d3JyRFBCdzd5UnQveTlnWlhoVGpLY2xMaUhVRmhjeFNoTGtIZFNCbERo?=
 =?utf-8?B?RlpJYVVJeE5QR08vU3pOK3k0elBpOG1FSjdrdkNaSUZWU1NhYnpRSkJjbTM1?=
 =?utf-8?B?UzB3blcxdUx6cCtkZWpsdnVYaHFyMVRKSzM5ZmJRWjFIZHkyTzR5M0lhdHVR?=
 =?utf-8?B?ZC9Zc3JFU3RBTWdtdVJ3Ty9yN3JZaTU4TjFMSHVDbEcrTWRHSnZoMm5ZSkMw?=
 =?utf-8?B?Wi8zZzE3TXNHcXRpUThJWUhGQWxtRXAwOVk1ZUN0d25jV242dDY1WSt6UDYr?=
 =?utf-8?B?VzlxTGxHNFBHRDRUOVFuMGpuRTdHdGxJT3UvWTBuaUVKbmU4dFFiY0ZCb2Ji?=
 =?utf-8?B?Y0xQV3pZQldKUHU4Z3c4V3FyRzJxNFYyZDZBQ0xrMWJTcWRneE9GMFROc1pn?=
 =?utf-8?B?OTJxOWdWbmlyQVRibGhUZVluNmozYmFjZWRHNk1uQkRWR29uZnlDcHE1ejIv?=
 =?utf-8?B?cE0xVTBFVGhaeWMvU1EyMnIvN3dPRGdhdWxmR2dLZU4xeHJmT1lVeTJoOEZR?=
 =?utf-8?B?TzQ5RXcvbkhsQW9jK0xaYXp2L0tiU3JxREpUSi9zaytWODdRL1BiaUF5Znh1?=
 =?utf-8?B?T01wT2ZjbExleVV2ZFl0NVJwcENVQTh0SjZQMnlUOWVIemhDNHBKNjRUZ0o2?=
 =?utf-8?B?WUx6NG1yTlJ2R1JPZTVtUGgrREtaSWZjdzBFZ1ZuZWc1bC95RnF1SzVjM21u?=
 =?utf-8?B?bVNWdzF3SDh0T1dKR2prdHBRT1pyZTdmK0VXN3lSSnIxYzBmdG16QWIwby9E?=
 =?utf-8?B?alJRSGIwblErQWxGbkxFVlVJMjZxc2NDNkpvVDJLZ0s4YXFpV3ZHNTBuaWN6?=
 =?utf-8?Q?+0/RwERu2TfQrBdMRUdx9pTYu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2344816a-60a2-4c94-6a9d-08ddb4783a82
X-MS-Exchange-CrossTenant-AuthSource: DM4SPRMB0045.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 06:11:03.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LquKhVowOGsGNFn6/isWPfVQVKFkZNHnE9DmBC0IYWk2c9N4pe4wS931S3ouT2iD2sv88ZLnWfyuwUeRi5kAnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6390



On 6/26/2025 3:55 AM, Sean Christopherson wrote:
> On Tue, 08 Apr 2025 15:02:09 +0530, Nikunj A Dadhania wrote:
>> The hypervisor controls TSC value calculations for the guest. A malicious
>> hypervisor can prevent the guest from progressing. The Secure TSC feature for
>> SEV-SNP allows guests to securely use the RDTSC and RDTSCP instructions. This
>> ensures the guest has a consistent view of time and prevents a malicious
>> hypervisor from manipulating time, such as making it appear to move backward or
>> advance too quickly. For more details, refer to the "Secure Nested Paging
>> (SEV-SNP)" section, subsection "Secure TSC" in APM Volume 2.
>>
>> [...]
> 
> Applied patch 2 to kvm-x86 fixes.  

Thanks Sean.

> I'll wait for v7 to grab the others (and stating the obvious, not for 6.16).

Sure will send a v7 on top of kvm-x86 changes along with the suggested changes.

> [2/4] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
>       https://github.com/kvm-x86/linux/commit/51a4273dcab3

Regards
Nikunj

