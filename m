Return-Path: <kvm+bounces-24202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC8E952500
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 23:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45F45B235C6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 21:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917E81C9DD4;
	Wed, 14 Aug 2024 21:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lym6aHT3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE141B9B50;
	Wed, 14 Aug 2024 21:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723672443; cv=fail; b=Fu3wuo/3x0z2+o4Cfdg5wU5u51uoq2+MwPacCcQeBLZMmpV//yEHDnNxEWf6uvAUd3bZ3Q/AJL379EAAKHr6lShezhn2fUf8HRDgP6W4wedruJBv0rO7ALHDUYOv1K4BhV0bdnR5gyJ+Tes6ubEq/Y5Wi2EJPATM16CP61h3G+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723672443; c=relaxed/simple;
	bh=UAvaBLzdUa3f9xAi+s5sZunTvF7R1fZGWh9sQQxlfZQ=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=kbarRMuJBOlWBF1XzRUupTk/WpkByK1a4L7shjoCKQntu7sYPKjQUgyFhEZhQkvXxjvRDapyveCa4PkE/lrga2h3rz0bhb+ENCOXUNcPc5M5uFMlXu40G6Z2fKHfb4GNMrVatgnUbAVN5aaszF5MrHSCvPu0LeksOReFUlCLkWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lym6aHT3; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWfdU2viiOHCDGlyiNS50xh6WazD7oczVk5mbgFVnVp42FYBr2j3uOxwTuvHptIHS21kBQK2IRv2wemaquzfXUrSqb/CvjVSDZ4ZyQtYyIsxUk58iKvCxFHyhupxBNqXRSYi0rZETNDd0KkT/Af6MX5WqTIKKKzmLFbuxL4ZUnpigN5RqDtiqUiXoVm4gxNP536/LPGIXqLVMcFRBE9FVGc74rqmVcXfFxubi78z05iKX1tHVuIuAm0B0b9jNBZZ6JMFi3yAtkoBrrfENi3So1whaBHqxbRI/+FA0oDA+0sykVjr7VoRMbTtI5inkPkmIEh/ChLratn1ayXHfH3OqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbnK9NA8q3juN2EzxjnWzagET0r1rG7j7t8FP+rO9r0=;
 b=wB6R1HhAnKnYZDld+YkhFMGRpL3QWmAZ5BDJpzHLM04gdjbR9AZJbj0aqf99841DzDRDSKfJ/lOVK3t9FzI/f3LdZXSTONmng+DgjsrS50mXXLswpDIqtXINEUO+HcPoA3+KeK5fmKtk1XhVLOBf8g84qiwIMQEvM00F2rv/cTEPNqv3RrIdqaxN4neJPbQYVIqgqlHWo9rxKLbT9ufbFFQBjPul2IopctX8kV8yez8eCXI1eQgbwEsRpdRxCERp4iNm6YBf9R6XFjXdysktgd8QPRTS6Vd33VCuV2+k7XtO5+af95j0QmSTUkqsjmlF/hvOllbWwY0qsSBUNHnFPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbnK9NA8q3juN2EzxjnWzagET0r1rG7j7t8FP+rO9r0=;
 b=lym6aHT3AjhXMWnte7yXzO5WKgn9Z8Llubwy5ywbXpHOe32lDMnqiHJgh9DuEAulPw0CI01ZDN8rjUKJFA9hGX6ratRejIVAIG+2481iCwCc9m4TPzR++MLJQV0jb7xl+98LIhXHa4Lznt9+kd5/0rscZdmMZ2BZ0Fn35RpDZow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7786.namprd12.prod.outlook.com (2603:10b6:806:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Wed, 14 Aug
 2024 21:53:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 21:53:58 +0000
Message-ID: <24a87bc0-11a5-eec4-d9fe-a1b28381b971@amd.com>
Date: Wed, 14 Aug 2024 16:53:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1723490152.git.ashish.kalra@amd.com>
 <be626a28eeecd08eac7f68fb23283c5ecf5e2c68.1723490152.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/3] crypto: ccp: Extend SNP_PLATFORM_STATUS command
In-Reply-To: <be626a28eeecd08eac7f68fb23283c5ecf5e2c68.1723490152.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f05058c-0ad4-4eaa-f6eb-08dcbcab9966
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGg4cHlvQ3hnU3B6T0h1SnNjTGVOZnJXVGtsZEZ2dEV3MExzKzF2SWREbnN5?=
 =?utf-8?B?L0pldWhvdGh4Wjk0bnRubVRybk5jZjVCQWxzcUZJT20wc0xTWWV1dlc5eXZy?=
 =?utf-8?B?bXpzTlUvV2g3eEFscXF6MHZJVEZKNlpWWXZsb1dKamU4cHhQaUQ4RTRhZTBu?=
 =?utf-8?B?U0RRL2NWaXZVWUNYaURaZXcxWi94NGhObkczVy9IS1RBS3liMDluSnB4Rm5Z?=
 =?utf-8?B?SUhieUU4ZkJCaitvbzBFSXFSZTRKMDlsemYwZ0lSeUExNWpjejU0MXRBTzdE?=
 =?utf-8?B?RUhIbFl3QnNNNmV3TGxxR3Z5bkNWQmpkdnd0eUVGbXptazNQNy9aOVJ6RXUz?=
 =?utf-8?B?T2ZDSk05V3JhazJ0dEM0ZTB1S2RaV2owZ1dNdEZxeUN6K3M0a0Zrbi80YlZ6?=
 =?utf-8?B?bDVybWpldWFoS2taZ1l3ak1lNUszQk5IMHNwemdzQ3hlZ3N0SHQ4NXVYMUQ4?=
 =?utf-8?B?WlYrc045YU1MTTlaamF0eFB3Y2xUOElmZnhucXhyaUdWUFg2ZW1xeEY2cko2?=
 =?utf-8?B?eHdQS1A4Y1oyREl0ckRXYnlnQU9UbEJPdkJsWXRTMUc2K256N3BpeGZMY1dH?=
 =?utf-8?B?VDlRb3kwUmdTL2ZNYm5ZaWU0MFRPOVFaWlVVSENTSEkwWjV1Y1FVWFlPNFY2?=
 =?utf-8?B?RkZQMTRXOTFzRnJmbVRCTldQVW9HbWpNWDFiVnJzQUFpQUZ6Y1JHVFhpNWNt?=
 =?utf-8?B?M3NiV3pUOFpnYmdMYzl6RmhmOWFDRXIrZU1XL3pGSDVDcG5HQmNZM1JTbDZD?=
 =?utf-8?B?eVVlMi9Qd25HdHlEUWMrUzBTeGxXUDQrWW5ZRzkvTnorT1ZldjcxbmdZWFFv?=
 =?utf-8?B?QnoyUEhXMU5Qd1dkZTNpelN0MS9iak8wT0JzR2pxemtyS09aa254OVF5WlFW?=
 =?utf-8?B?VCt5MjMxemN0WStHL005S1M1Y0tVMUYzWlMvWEZhaGZEc28yMjVES3BhZFp5?=
 =?utf-8?B?RVRDT2NNTVI0UkFrVGdJNVViWW1CK0ZFTDVBY2x5cFlFVEEvWmFCekM0UUtq?=
 =?utf-8?B?a05qMi9iUlZPVTI4dHFiL1l5ckI3aUx1NXZOT3NTdTNqSmExeHhGUlduTTFU?=
 =?utf-8?B?VUE5WmJhWTcvVTlNNzNPenNYbjNuanI3aHR4L1lCTUhtakR5ODA3c29IS3F0?=
 =?utf-8?B?c3FvNTZwb3VlOElxYU9NVC9nWDUzTjBiMXFiQ0Jpbk12aFhrMzN4SDJQZUZ1?=
 =?utf-8?B?ZXRrMG1sMzZHMkhvMm1UZi81SDZOYlV4MFB1dzJ0YjN4YkVmN0hwazB4cWV6?=
 =?utf-8?B?NTJ4RklYbG8ralFhejFCUWFObzZJZDQ2VnZUMzJ2cHdBbWhxZUxpU0RxSnho?=
 =?utf-8?B?aHo1ZHQvY1BKQ0YybC83Q3pVam5wZmg2YWFXanZ6RHo5cC8zSnJkZml0RlBu?=
 =?utf-8?B?SlRnemJBdGY3M2RZUUVPMFJTZDNWRDdlOUJ0ZHZ4TG14cHVpdVA2aHpNVXg1?=
 =?utf-8?B?WG1DWEhTa1VwQTg4WHFFSXM3UDh6NUFDR3hjZXFWbzRLaTNxLzRzQWlRazkr?=
 =?utf-8?B?SU5DbVdGam9zNzdDQTdqaU0rcy9mdktVNk9WK2wrSEdlMkozOExDSlVFNG5G?=
 =?utf-8?B?QVNocmpRN0xKSzBRenFvRkF4NE1VakNjMGtDTDdmTG5HVVY5NW5mNDdxU25F?=
 =?utf-8?B?SnN2bG8wZWRta0RGSWhQU2dNV3NGRm9QV0pkMERIZ3lhVVF3Y2s1a1VNNDRX?=
 =?utf-8?B?Ni9jT1NCQXU5Z3FYdjI1MXZ3MmhxalF6QUFsaDZ0L3JXODl2dldXajh2ZjF6?=
 =?utf-8?B?b0tyMkJnR1hnU013VUhydkNLNlZPazUvZGNLaDVYQzdvYW5veFV2QlpzVW5K?=
 =?utf-8?B?QkJsODJFcVk5RFVJSjdrQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjdsUUtLN1F1NmdlUmFpQW43Z0xZWWJWa29QNFh3d2I1b1hjZkRSN1lId2ZR?=
 =?utf-8?B?d3RHN1laK3U3QmYzQi8yRHA2Y1pHYS9YSW5kaEFIYWRUZ0JiRUpodHF3S08r?=
 =?utf-8?B?U0FsdzhyZzRJTWFwSXhEb054QWNBTGRxSlRkeEVkSGY3VXlUREVOY0JESVZy?=
 =?utf-8?B?eFcyNWFnZjdIV1k2dFJPU0Vuc2JiMzNOSGtwMkdQMjZuZGkwUU43a1k2b3BT?=
 =?utf-8?B?T3k1OSswdzArVjROYkJadFUwZWhvOG1pT1lVZ3piOG85bkhHQi9YY1VkR0dh?=
 =?utf-8?B?ZXBheXR6aVlIdGY3TERIT0JPS3laRVRhRnRsZ3JEekExcStDU0xscDI0YzlO?=
 =?utf-8?B?bHV0UUxjamR4Vyt2a1lPQkh5ajhYbWpKWVM5Ri9vaEVPRDVYYTN6SmpjeFlM?=
 =?utf-8?B?UFY0bFMwaytGSk9zVlV0UnlPTytma2lGdDQ5cmJidFdUL2Vxc2l4dHR4RVhL?=
 =?utf-8?B?OXVyTFVNbEdSSFVnMnYvSCtJWmhRZGVDUkFrTlJLazJDaERrbXE2MjR1Qjhn?=
 =?utf-8?B?WllMSGYzM3NHNk1zUlRwU2piWnFVcm5Yb3kvSkRvQi9JMVdsaExjOEhoa05I?=
 =?utf-8?B?YnBDc1UxZXBTaFZVck5CWGpsTm5EZ3EzeUx5WG9ocXB0WlQ1WEU0NzZUMHJB?=
 =?utf-8?B?VW53OENPZlVmSU5ETk9yMkFVMjlpaENXa1dGbEhIeitFN283V0JQMFpaVHdn?=
 =?utf-8?B?M3U5Tk9LajdUdWxXR3ZqSE9LditpbHAyVlpwT0tFdElhYXdJQWFoV3JrRVll?=
 =?utf-8?B?Y0FSQU1qUWMrWlhvekNnYmxFUFNVS0xBaUxLeDVEUVROY2pQREVGdjN0dTNQ?=
 =?utf-8?B?bUp5SkRveGtuYklRZmZsUFVLOWZmRGFnYVovYmtwQmxXM2RtSzAwZG90TkFn?=
 =?utf-8?B?SG9tRy9pcTBRK0w1WVJaVldLakF6dWpBM3dkdTNsWm53SkhGRmNOL2dpdFVM?=
 =?utf-8?B?elhid3o3UTNTUlozM1g3cW1JbWJmU0ZIV3VQMGR2amdzLzNBc3RVQ0Flai9E?=
 =?utf-8?B?azhmTEF2bWFZbFBFNXI1WlpkYWwydTF4d1VxbUM5aFh1b3pxMVM5R3FQYkJS?=
 =?utf-8?B?emthTmhCY1krWGJxT1luamJXOVdTTGpJMVRRWVhkOEpDR1BPM0lzeDBpUEIr?=
 =?utf-8?B?T1kyYU1YaUEzREFnZTl0ZGE0MnVjM1JqSkxGaHFBalNwdnhPY2dJcUIxbzFx?=
 =?utf-8?B?M0l0U1k4MldWUzA2alQ2RG4vVWNmV1JqVTN5Ly92MFNYY1RhWm5MWFE4YlYr?=
 =?utf-8?B?SjVGVkNGeWFFVzAyNTNjajcwVGFKWEhGUm9ycmlKYnpGT1hicS96R1FQWEdt?=
 =?utf-8?B?MEt4V1hnTytRcERHcjlwT3pyaUNFQm5HenF1eWh2dEJCMEFFT3BaZlVPNU5r?=
 =?utf-8?B?SFJ0SEpndXA3amFqcUM3MFg2NzNBOWZYVjRNRStoTXFDSXYzMW4wa1Q5azQr?=
 =?utf-8?B?SUxPZklNOE1KUnJ3YVVtb29raCswT2h6YURIWldkVUswcTVrcDZOZy9PUHVO?=
 =?utf-8?B?UlNhM3plbjVVNk95amNzV2dHWTIyT09oWk4zZklNOTNveGJHYzNMN0JtUFdl?=
 =?utf-8?B?NGg5OE9sa0xiUGFTWHZmdTdKb3NQWEl5Qy8rby9SVm1Cazlhejc3MHdPSDZD?=
 =?utf-8?B?NFZoZEhGRGp4anNhdFVMUS9lM0Z6K1lLUTFhMzIrWVJ2S1RqRUJxSnFCUmtU?=
 =?utf-8?B?K0ZsWStWL0Jaa29EMXRmS1NxRlVDU3JCZTI2SnA3NFlzSTJNMm50bkVPWWZL?=
 =?utf-8?B?cjg0VWlBaHkwYTA3OU45MDFnNFNGMFFIcVZ2a3hvdSttWlpuMHdOMWZEQ2dE?=
 =?utf-8?B?Q1FjK0ZnZjNlamE4bi9XaGQ3UEFWSFhQeDZrRVkxR2ZmV3RhOXlXb1ZaQXQ3?=
 =?utf-8?B?a3ZVY2Q3dnQrZWNuNHA4c2hldU1UWFU4ZXN4Mk9MV3BqZHhhRjAxcVBUaTk3?=
 =?utf-8?B?TkV2anc5S2tlWnpJeFFDWldxS0pLWEhIdTAvdkgyQ3ZtUXVEcDZqQmc1SUk4?=
 =?utf-8?B?a0pUbmNMaW9Nbk9QZ2gxZWtxR1VwSENQZ0NFN01vNy9VTC9pcERuaTVZcTBM?=
 =?utf-8?B?NjNEbnZNeWg4dlovU0FLeVlMMWIzelgxTll6c0JMZ21BV25qK0xtY05oNU5a?=
 =?utf-8?Q?nwCVB3jufk7OpX7ED/zOJibuA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f05058c-0ad4-4eaa-f6eb-08dcbcab9966
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 21:53:58.0416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQ14g2mXl0wXOvAo9rvq0RC2FGP6+tfyGxHpJGuiQTLIKvKkgesT1zBd1fHAZ7N+7hen4p6pe3tA1fIhLnKauA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7786

On 8/12/24 14:42, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Extend information returned about SNP platform's status and capabilities
> such as SNP_FEATURE_INFO command availability, ciphertext hiding enabled
> and ciphertext hiding capability.

Just saying something like:

Define new bit-field definitions returned by the SNP_PLATFORM_STATUS
command.

You're not actually extending the command or struct.

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  include/uapi/linux/psp-sev.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 2289b7c76c59..19a0a284b798 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -177,6 +177,10 @@ struct sev_user_data_get_id2 {
>   * @mask_chip_id: whether chip id is present in attestation reports or not
>   * @mask_chip_key: whether attestation reports are signed or not
>   * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
> + * @feature_info: whether SNP_FEATURE_INFO command is available
> + * @rapl_dis: whether RAPL is disabled
> + * @ciphertext_hiding_cap: whether platform has ciphertext hiding enabled

s/enabled/capability/

Thanks,
Tom

> + * @ciphertext_hiding_en: whether ciphertext hiding is enabled
>   * @rsvd1: reserved
>   * @guest_count: the number of guest currently managed by the firmware
>   * @current_tcb_version: current TCB version
> @@ -192,7 +196,11 @@ struct sev_user_data_snp_status {
>  	__u32 mask_chip_id:1;		/* Out */
>  	__u32 mask_chip_key:1;		/* Out */
>  	__u32 vlek_en:1;		/* Out */
> -	__u32 rsvd1:29;
> +	__u32 feature_info:1;		/* Out */
> +	__u32 rapl_dis:1;		/* Out */
> +	__u32 ciphertext_hiding_cap:1;	/* Out */
> +	__u32 ciphertext_hiding_en:1;	/* Out */
> +	__u32 rsvd1:25;
>  	__u32 guest_count;		/* Out */
>  	__u64 current_tcb_version;	/* Out */
>  	__u64 reported_tcb_version;	/* Out */

