Return-Path: <kvm+bounces-19818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A1C90BC5E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 22:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A76E51F23B4D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 20:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E13198E96;
	Mon, 17 Jun 2024 20:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BJ0vSEl3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64A37492;
	Mon, 17 Jun 2024 20:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718657506; cv=fail; b=PmmpHKG68UzTRdul9h549r65zJmn1C6I5cRiWDkmxqhaSDq0n2TQ1vCO/AKSG+xQ4/yl7I48pjye/xyfx8am8WS4U6838fB0hzFKamyYA1bUvQACAdxMacN0Y7Yl+PwIeqfYGg3vabgmBNZuwpGKHmza/+fuhKSI9siNsxteybI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718657506; c=relaxed/simple;
	bh=saHNH1V6389O6x7m8xYru5C7/jgAfsZ4ujxxLIxMPt4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C12b//LUHO0oQysZ2SUHkDHmNM/tkiEh799nIflYIpnYHyTypKRD+tGGE/i8RRwyzcyIuSjNn1IyMuj1PORx6zhTVgLHiFb9J22jUVuQFmbGPkYK2TrV8J39GMPjUP3e85FiSZfZgFT34EK+zdXczYq0h6VB7UAjfUX3YbaaAPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BJ0vSEl3; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LowEsj+JzTPDNxD9Hlk38bRgmxt0dJQ1PpGKEAh5HFsfQ/VF5ofZ7EoOX7DXpJkYPRVD9xOJpXNuImFYWmwBGk7z4WFiTl2oAuFxkIAAmrb++AE1WRTQCBkBEWtz00i1LKkngfDwtHUL5f3YRcOcJbiuE92OL/dm9FmPiGe4M6y5poUsgyxgDBiDec+bwi2uOKBPVqSP6iHsCYU9mEffqVM1wqGa51E/C3YslPaknaILDiScCYLpXhzTaXInJH9WkabmdnjlFECBQHb5zgNelJoULlV9c8R7kgb2gmUNs0WfgYsS18UihkDUiEyI2ctKR1f0PhnT4K2in+Zq8rDVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jScOZZVoVrUK7ErJbp7erMw+tC+acHiHeMtfFZSEDTY=;
 b=eO0drgm+U9AGrS+SYrE4JMI0N/2/aq4xQM1If9/o4QUkprr6vtcIFzepaaYQ8YYr2z+74AH6XRaiQBvkEWld8ytSp0ki0njO0R/O8a2Qvymjo35DuzFQ4zb6+jE0sE3hfk+sELz38R6HImUYe6suchm0Hm9LviV0ITTQIdIDrwVGTv9gskijeIjCSHdk8LApc0y9JEFyJibNTHBZOzquADNV8U154YGSOprjmkfn6JcLG50DWtbGhgd/7t7K0JruoaGz0be3oNAE3+FdKrbczEHnXgKkfYeJ1Bn2CQTWo549T3HhoKc0FiZlsMKliokroUpddK/JVGjzBcAa0oRwfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jScOZZVoVrUK7ErJbp7erMw+tC+acHiHeMtfFZSEDTY=;
 b=BJ0vSEl3sI+0cw/tTZOsIy8kEJuE00JHrIApfezCpo/olFN+DmJOFz6p9CD6VzJD9R4j5bd1ytLxVwwCyzgosbWTSRbtBdIGO/96vtX0mF6i/E39EhUMNR16Ete8Ks2mN0CGf5kVon9DO9QCgCBXjYtWpch9fE0M7GR+sc679rk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CY8PR12MB7707.namprd12.prod.outlook.com (2603:10b6:930:86::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 20:51:41 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%6]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 20:51:41 +0000
Message-ID: <791ffa24-261c-4814-1fb0-cf03a0753afa@amd.com>
Date: Mon, 17 Jun 2024 15:51:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240531043038.3370793-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:805:de::14) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CY8PR12MB7707:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ffdc23-9ad3-4896-57cd-08dc8f0f4a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|1800799021|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MExFL2Frd1R5ZGZ5a2JKckxDdzN4N1lLenZWd0cyRnFLWmtJSHlYMTFwVlpU?=
 =?utf-8?B?a2FqUWd4eGpmZWNLQXdNNzQ1RXhOZlhNK1pjL3Nlb2MwK3dkSmpPMlprWHFs?=
 =?utf-8?B?ZDJZNUlmWmxONlRZcDVGbTFvUlkxaHk1bzA5a0NYQUd2Wlc1M3lKSDhMS1pW?=
 =?utf-8?B?eFo3N1dyMjVKMGlzMU9GcGhFbysyOTdYVEkzWElCcEpDL25obmNWZEtxMmdI?=
 =?utf-8?B?YWdDODFRS2JmemNtb3FOWUNOaXRzdGRnMlUza2tIS0JrekgzRFVyM3YwZGxD?=
 =?utf-8?B?cGwveE8rMnFTc2N4TVZJT1c5NTY2VloyR2VXRlJ1N1E5bWM4RXNJeWJTM1Bk?=
 =?utf-8?B?QkxTK2R1WVptV3NLb2FTTFowOVRSNHRPU05xbkt5S0lkL3NpMVZ6Sk9WZEE4?=
 =?utf-8?B?Q3d5OWVsb3JqZUVYWkVFckhBNnhNRlQwT1o5RXpscXlKb01GbmZNbVZFdHQ3?=
 =?utf-8?B?UHdMRDJseU81ckpBRmh4aUwzRTJ2MFc4ejJFTkIrdmdreE95Qi9rV1o2WXdY?=
 =?utf-8?B?LzhxL2tsdTE2MlMzQmtVSzFoNDkxSWRaMWZwWDZSUjdhaHlJVUVRWXczM3JY?=
 =?utf-8?B?eFNEMUczVVR3L291Q1FYU3Ewb1pFSXB0eW5WSUdoTFc3TWdmVU9ydzA4U1d6?=
 =?utf-8?B?NlJ2STRpNDhXYVJYSzh1ckxHOHEzZWExVlBkNmR6NkJoaWNUOC9NRkZWeEJl?=
 =?utf-8?B?L0cxc2hTcCtSL28wU29GaUNZd084UHpLVnFIQXlQajNQazBNQ3M2c213Ymxo?=
 =?utf-8?B?ejRjOVQ4S2lrbXpMWUJEOS9XbG1wRi9HSDBGRFVEdGRuUjlJeThLZks1a1ZO?=
 =?utf-8?B?alpwaGJuWCtka1FiTk5QT1RObnVPVU0xRno1ZnFZMWZBUDZDSGVWZkVCTytK?=
 =?utf-8?B?aDZsZ1M0SWlwZjgzT242UkQxRVdLSjl4WmlrUDJISDY2UFcrNFAvSzAvT2cv?=
 =?utf-8?B?eDFsS1ZqeTZ5RWQ2TFAxbjdBL2h4Z3hXTlgwaU5jUklmcDFPMWxnRjlFcWF1?=
 =?utf-8?B?SE91NVVVT2l2THhYNkJuUXpQQXJ4Y0VGdzZKU3J5RUZIMU1tRE80M3Y4bUVG?=
 =?utf-8?B?S2NKd0NEVmpxcU02Ym04K3JmNU55S1cwRXMwd2cySktYdHUya0pjMkNoUkt4?=
 =?utf-8?B?SVEySHlueCtqMGlpSFE1VTNTcC9BcExydEEyRUJVanY4dlhUcFJnRytya3pv?=
 =?utf-8?B?eHcyaHVxdmRmNHJ4SDJnQlMxNWhpTE5KSzJUMW15RzAyT21GazgwRmwzWmJL?=
 =?utf-8?B?RzdBTS8rZ3lLY3lNdTcvU0x4WWZkdWh6SzJQVUIwWU05Q1dha1Y0N0xIeVdK?=
 =?utf-8?B?alpLVkRTQkN4dXFhRzFwWGpGcUJiYUJDSktYYXl5bXRCdjJoMFB5TEZkWno5?=
 =?utf-8?B?WkpENkxLN1Y5RHhkc21LZ0RyZUZURzZhVEFGMEZHWHNNSHJwUGZDYU9zVWxx?=
 =?utf-8?B?Nmg3VWd2MGZNRjBOU0hJaUNQeWpMSmxHcmFOUlBNSnkxd2VYM1dBQ3Q2TTZF?=
 =?utf-8?B?eCtydjU4ZkRQTEdCbWZiTzVoVnlTYkZuUXZBM25mY3JEVDgrQkIrUGhCeGlH?=
 =?utf-8?B?VGN2cHV2eWtINzhmaFhvK3YydTNWaHlIVkVhMG9NbUY2SnNKbFU2YS9UN2hq?=
 =?utf-8?B?d2tReDZHRGZ0S1Iwc25NczB4RzRPRGlWMTB1d3RQR21GUk1wTHpGUTN2ZzBm?=
 =?utf-8?B?RGh5cE5KZjMxVCswNkxSRjd6Rk43TG9nOThIQ0g4ejZEaUZzNDRNbjNVUzRW?=
 =?utf-8?Q?9YqAI86bncrL2YOf9M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWhXS3p0UUxrVkFmdnUySWVFUHc0aUt5SWxCYTBRTTNFMDJYOS94b21UZ01t?=
 =?utf-8?B?aUhsZGZUejE2aDNBaVppQW1ZUUtkeEQraEZwVDZobEU5MHc5bThqZktxMkNo?=
 =?utf-8?B?Ly8wK2tLWjE4RGR4WnRpWWdtYmovNkowRHptWEZBczZlU253K0ROWlJpamxu?=
 =?utf-8?B?UVNHSTNrSnc1Rk1ldkJYa3NTRXM3eWU2T1g4clZCMHhzS2kwb0VMUU1wcjZk?=
 =?utf-8?B?UExSVUltR1NvVlZvWVpRalJTUmlSMnUzcktERVlvMjRiaGNzOWNwdjE5NFg2?=
 =?utf-8?B?UlZIS0U0aUNYNDY5dHZhSWZLcGlRS29FdUgzS1huc1NrZnJFWWUwaHU4RjBD?=
 =?utf-8?B?eCs3UVBKU2hVWEZ2Rzgwazk5b0NGOGgvUzBheEtSOEdDeGQ0QVNCSk5MRE5q?=
 =?utf-8?B?NFc4Q2tRejV1VnZhWVdLejNrMUtTUWlia0VLamxZcldkdjJBU2FydlUwYmFX?=
 =?utf-8?B?TmpCRjJkblRuNE5lUjhMTnI2Rml5RWp4N0FWWmN3eE1jVkpwOUc2SEs0dHFw?=
 =?utf-8?B?SmRRVkdyVnBHalp6N1VYYzFCNDFWZEk0dXBCOVFkRmw1bGRtUXBzREVpVnd4?=
 =?utf-8?B?VWZpdzN5WVd6R0dkWXdHOWZXaG9CV0RXSzN3MFF6bE1CNGxVOWJ2Z0JtSjhE?=
 =?utf-8?B?NzhZNVJUMFV5SGxDaE8xZzVRckxETkUvdUZzbi8wS1BGbHEwemhBREtHUjlG?=
 =?utf-8?B?RlVMNHo5UHkvcERxNHJrTzh2NTd5d3VYTElOVlhSYXNLMk5JazZrdExWRmZ3?=
 =?utf-8?B?ZHU1cmZ3Vm5tR2hHZFA4VnlUZzg0WklXRmNmVHBPQkdlUitwVUlTNENLTCsy?=
 =?utf-8?B?Vjk0QTRhOG9Pd2dpT0syQjNjcDBOL1d3cEN0by9URytFdlQyaGVZaWl1bGZM?=
 =?utf-8?B?OG5OSUd1dlU0a3NnQ1lSZHkvemlVYW94TTZJTFNkQSt0QTRuSXNlSi9yd3Jp?=
 =?utf-8?B?a3NMWlhPMXkwWk0wcHZDMGN4RSt5cnpTdTQ3Zllqa0UzV2tRazBpbWYyWmJh?=
 =?utf-8?B?SFdsWnRVbWl6UWhuL0o5VTZ4RWpIMGxXWmJ6TEFOZzh2L1FQaWNDMkoxdFNo?=
 =?utf-8?B?V1F4SmZoSlZxcGwxY0pOekszQSsrRkN1M1NsMW9lQVBwN1lRM3Y0Mm9vWXA5?=
 =?utf-8?B?dnR0ZVdQeVV1bVdjdnB0eWFBS1U5TUczNy9JYW5hdXI3V01mRS9IelhmdHhK?=
 =?utf-8?B?VkJDWm5hUE5IaURsRWFpR2phLzRYdTZ5UFpienJqUFQrTzV3NU9uMmlJbFhB?=
 =?utf-8?B?THFMYXZOcTYzdjVXeUd4dy9pV1FGcXhkdS9VaXBxSFBNdStxczNBY2VucFp4?=
 =?utf-8?B?VXJya3VqNzBqNVNrNzhpY1FlK0pOTjZENzlYaVV4ek1iT20zN2lyODlpV1Nh?=
 =?utf-8?B?ZWRTaXhXUStiNnUyS1owUVl2YVRlZ0l4eGtYRjY4ZmhGcTc0aXhJZm5YRWR5?=
 =?utf-8?B?bWFVVFY5N3EvSmhWdXBmSWtWV2hRZ2wvVGFWdkFPTCszWkJMMHNGT21LVXRa?=
 =?utf-8?B?V0pOL1lzWjc1bld2REhrZ3BGR0lPTngzN0xjenp4REVFV1ZJYStsS0Jwb3py?=
 =?utf-8?B?WTQwSFB4d3ZBeWV2MW1vb1pCdUtLN1dwTkFRc0tUanF1eUNlTHNyc1Q0b0Qx?=
 =?utf-8?B?SkZmdkZoL25SNzFvUWZZSUdINTJJY1g0aHRuczZ3dG5qSDBRMUdvWlE2U2JZ?=
 =?utf-8?B?NkF4cDNBaFBRVXVCa3JodUZVRnRiSzlONWlUcnZtTDJ4eDBnL3ZlMEc3Y0NK?=
 =?utf-8?B?NGVYVmNsUGpUb1dEUDBJMStCaFViZzcwekpmNi9rdDhYQUZLNE9EWVBDdlQr?=
 =?utf-8?B?bmNTak5DN0kyRWlrc1Y0S2VVZG9tR2ZWR0YrcE45L0NDRHhrSG1DUnZSaStX?=
 =?utf-8?B?T0xJbENDU0wyNitlYUNvaldnSk1RYUhUQURTc1loWlJyM1hSTFhKYnN3UWdj?=
 =?utf-8?B?ejdqWFJ5eVJBWjdoeVZIeHFlTGJ2WG5aYzBKaG9uRzlnVlhJSlhzWnVXbjl3?=
 =?utf-8?B?V2RUNkRmMEJkTzByc1JrV040S1BzaXhobzBSVVVHQ3phTjFXNXpaZ2hhS29u?=
 =?utf-8?B?ajlSK1lXTDcxQnZlVkFIdmtvOFowQ2llY29STEYwMG1nSWl1V3pjdTBsWkZP?=
 =?utf-8?Q?6YH4GWjpzZt672uKu9bCeuey/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ffdc23-9ad3-4896-57cd-08dc8f0f4a0d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 20:51:41.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /g3Qug9pdXYr1pveGkF0li99AyouHDqYExGT09GWnVzBEaCv2cJaDrmVpPTY28Bt2iyuxCKMwx2G06+x3F/5Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7707

On 5/30/24 23:30, Nikunj A Dadhania wrote:
> Currently, guest message is PAGE_SIZE bytes and payload is hard-coded to
> 4000 bytes, assuming snp_guest_msg_hdr structure as 96 bytes.
> 
> Remove the structure size assumption and hard-coding of payload size and
> instead use variable length array.
> 
> While at it, rename the local guest message variables for clarity.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/virt/coco/sev-guest/sev-guest.h |  5 +-
>  drivers/virt/coco/sev-guest/sev-guest.c | 74 +++++++++++++++----------
>  2 files changed, 48 insertions(+), 31 deletions(-)
> 

