Return-Path: <kvm+bounces-40658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FF5A5990E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 905661668E4
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221BF22D4CD;
	Mon, 10 Mar 2025 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cPWnbhG/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D522171C
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619040; cv=fail; b=dOBWv4u+2IVuBuVO5/r1mUolnYBFcbAqZjOvxwlqz0a/NeLg2uhCGGcqXy6vZcDomr4W3w4ToRVz04rcM5hLPGMrlDuDCeIE6mMl3W1tqei9gUW96xcaDhqU6pVxssqdbckt7qJYVWWmU4Zb6J1TsYD2TfFcgfA6fQR0VLhH6vE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619040; c=relaxed/simple;
	bh=pwQ5cPkYdnE6rYE7+9r0tINgr534a3EgYh6CoZv0i80=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rb/Ax8pGF0ASt8MDZIiw7/HgdErh/GW+rJijj9ASEC7FGpaH2RvQbQHP0KU5UEeEWW4wgbpsOuZEtJUGURz30M0nTt9LHdSqye0tjgfm/TYmWR5nNMuMIYcNQVP94/HsyQpN9tZRscjtu8qnr5iDbx0haVcIio17SiLbwEqz4og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cPWnbhG/; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQUOxhAG11r/3RM/zsNzROgthisBUSKBY5EDWgmReBgEstYBC9dOfX4okdYIceeVcT/B/Zk6w+jgV8gf7Z2DKcVCMMdDb19efnEnmEbf6G87MWI9z4UVUGzyEvG1mUIP1YMQPNIEsIPPfY3fe+qzimgCuofdmvwB2SASByzO+irboPoj/sf3zJ0Mk47HNe1nt/Kzwg8PVAsTYTEjUtyf1sVRDkHIN8BvP6bb2pfjdWiofsUCMtsyBssrplDYTKME96U7GVHPFQeNu98epNbxDLKqOGmtJm1paGuNy6JyZxLEZ2qRoIeYYdpCKUKFRF9LeJ8S6Xa67qSaZo0SdSeJTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1GGhXJhXwt+8p77JiNoC4O2ooSxGMd0sRAJQhhGeEk=;
 b=DHcPJcThsB50RptMNdapVtu0iaOhpdl+dXcW1ogUW82ceJPZShj6jebZQmcJXtlIYxt8501zYd4CCR22KVGmL2zQfm8nuG3XSS9nV4VYm7et9CcB2R7RHkjiF1z8kIkEVkVnau3IbaGx/mUSNnbwY45xP/LUYZU3E37MuK0x4KP8X3UhQpX7NG5PBI4kvOxV+FPYQQ3tVCkE+6AoGVnsV3dcoN/dy9DRbtLGtVGHm0l2VJwtQPz/Ow3HdT8q7FqiMrhlMZocTU/ORl4AGOnVahmsMOiymkAtGjgWfujmO5Vc7P0sYmMC5m9UCzF0pCF0n6BfVpdAhYAM0E3CuxmTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1GGhXJhXwt+8p77JiNoC4O2ooSxGMd0sRAJQhhGeEk=;
 b=cPWnbhG/SvtpYoAnMuOKyqlNYBQLPdtitoUR1CGmVY3m5VJR2qRccoRWA83wPIkKZ+sZamo2qYeo6NLXITCO3pSx5TJqE5uyWq6eX2oU+UtDEqyYWY8rxaJYO7chWLuLNggxo5qfm/KEo3uSRByVBdfAd0iEO4PFG3kNLdVom2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.27; Mon, 10 Mar 2025 15:03:55 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 15:03:55 +0000
Message-ID: <ba967bb2-911e-836c-3488-796af146215d@amd.com>
Date: Mon, 10 Mar 2025 10:03:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/5] x86/cpufeatures: Add SNP Secure TSC
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064347.13986-1-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250310064347.13986-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0327.namprd04.prod.outlook.com
 (2603:10b6:303:82::32) To BN9PR12MB5068.namprd12.prod.outlook.com
 (2603:10b6:408:135::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: a39459fb-e59b-4d17-c07d-08dd5fe4c6d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHBKTCtWbGZ3Z1ZNQTAwWTRsYkZUMDZsZjNKeWhOZzNyeFFBbk14OHZaTGZR?=
 =?utf-8?B?eG1lRjg2UU1sMFlObktTcDRGSkxrMUl2dmlsNEVUc3hSMGJWODBOTWE4VnBr?=
 =?utf-8?B?MEpMWGRSUUExWFNtSjNweGs1YmRvNUVyRkRjOVZ3eFZ2V0xlLzFmMFlQNUc1?=
 =?utf-8?B?VVdJKzR5Q2dUUW9HSkdVVGxvNG1nK2lkbmVjMlNhY3ZIaEJBR25LRVlqRlcv?=
 =?utf-8?B?dXBGYi9CczNiNS9nd0gxK2N4RnBFdFM1STUzbHZON3NXam9vWnF2TGJqR2h6?=
 =?utf-8?B?NVRwQjdqeXZFek1YYmlMdXYvbDdUdjl3R3VlUStNTmtoR20zTHV4U3d1U3h6?=
 =?utf-8?B?VVhyWU5tUENSdTJ5S3ZDSStndHNqcisrV01zWEdhNm4yZ1BUak5jNTJoOTdF?=
 =?utf-8?B?MU1GcTRlazhCNnBIMmRIOERCdTVRWkJ6OFk5MTl3Y0JIaFhzcnl1WE1oSEdj?=
 =?utf-8?B?c21BWFprNFNkUG43MU9GTEVoYzg0SEM0QnZJeW1YRzhIb0J5eElpYVRsMTRl?=
 =?utf-8?B?bUNRR1YxbktqZFRWOWZPc0lpNGdXeGpvUitNQXBEQk1CdUFrTTBGMW5JZnhj?=
 =?utf-8?B?TC94d0htdzVMakJ5N0RHTkxzUWxHdWZRRG1Tc2ZIYzYzZ3lFNDhRUVZ2Y0Yy?=
 =?utf-8?B?ZEhtNWJZcWF5RlR4QndWU251N0ZCRHdUdkhVTXU2Uk9pbUJ5SzZUbGlNWjF0?=
 =?utf-8?B?MGRVZUZDNWFXWmYvaSs2eXc1bFlLZnZqd1hUODFoTnpzUnAxMGVZM0MvRW00?=
 =?utf-8?B?ZEt1eDhSdjhlSDBrV1RNR2RKUjYzYzg5akpFSGhPbVpvbzhCTmtOU1NVcHgy?=
 =?utf-8?B?NUJxallKU1hFc3hCa0Q5TTlqaHpTbVRiZVFLMGcvZnN2dkxTUTQ4NXlnMjZV?=
 =?utf-8?B?SkF3VmgrdWRwL00yUExWUXB3aTdoVHV2S3Zjckd3VitZL1lWUm1wY1QyRFMz?=
 =?utf-8?B?TlkvL3o1alFyVytWWG1LcWx3WVhvU3Mxa2lBcWwvd1hjMnpZTnRaOHlEYUpw?=
 =?utf-8?B?cStZYmg5ZnExNjd5YlFxMExCWC80UWQ0dm9lZUw0ZS80RVYxOUFVSUpGM3RN?=
 =?utf-8?B?Mlp2N1ZZRlhoUmNwblVKRHBlM2R2OHZkWEZqWjlDdkt0cm1CbWxFT2tWZlpN?=
 =?utf-8?B?RTY3dmVhdE9GY1h6TzVSYy9GTG54Z3NyUU50bi9oNkZoSXlyRnVhZlVOUjBB?=
 =?utf-8?B?V21wNDYva2JMNEdWanFLYlBncWtBK0U1TnlDbGxTMGRsZGZHakpuN3doTHFV?=
 =?utf-8?B?bGhUamdRYmZNcFdIdXVSL2VqajJYMVJ5U1BZRUlkUlNqeWQ0cGl0dVRmY3M1?=
 =?utf-8?B?WTVaUnJzTnZFdnN2dDFLdE1KdCtmVWwwdUYrbFB3ZlJrSTY2c0hudm4rREZE?=
 =?utf-8?B?bG12eS9FakU4QmhwWEcxOEdyKzBqWDJGZlpNU0l0OTM5dzRWMHY2N2crVko1?=
 =?utf-8?B?V3YvNzRpZGhGOTNsbVNFWm8vZkVPTUljMFJ2dEZreFRsQUU5bUd2cWJKZElV?=
 =?utf-8?B?TjRCeTNnSlBvNHNHTzc0SzFlS01pQXhhZVJRQlpia3RBQU51TVpxMmoxOVVO?=
 =?utf-8?B?eDVHQnhNbXNscWx2S0g5bE9aRC9JaGF4V2Yrak9OT1JPd0toVWVlN25JN0Jq?=
 =?utf-8?B?QTJHR2ZjbkdMTnFUUE5IQWJ6bEt3aE1zQWtRQmdocDNNRjdMeGdHL1E3ZjIx?=
 =?utf-8?B?cWcrNHJiU3N6U2k5R044RUEzTmRRWEU0N0VzQ3hOM1FtNGxIcHZ2VUZzRjBE?=
 =?utf-8?B?cFBGdThMUm8wSVZNd2trekV6U3dkbWd6dGtuUkhqdElaU2g0V3RCblIxdmFV?=
 =?utf-8?B?Q2JDRm85VWxUWXVoNlJiaXg2VlEvTFJjSUYyYVU4SkJ3RkhUMStvS081SGhj?=
 =?utf-8?Q?dckYsCABJiL2L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkJPSXVpN2I5dGtaR1VVcHorTmJoT2NYS2RLOUFxR1B6Q2JkQU5QMjdBbVl5?=
 =?utf-8?B?bzRvNGo0Q0k3Rlk0RVo1RFdBWTRodlpYd2FCVlM2Q0NiVXJHV2ZDSnNZVTZF?=
 =?utf-8?B?YWZIS3R3RVROOG9aZndXTTByamtaOUo5dWV3M09HT1pqcmppRURobGREcTg1?=
 =?utf-8?B?bXhacGZaREttc0xKQVh3TUkrS0ZUNU9HRHpKMjBFSXJETTUrVHpTd0h2ZFZL?=
 =?utf-8?B?cTVaTXFndzdXemJ3UDQxS2FZOSt5TFVnWlExQ3psNEtZNlRja1VaZEc0TGZi?=
 =?utf-8?B?VTZxajdNZ1FGL0EvWjF1VVlVK0dYVUxMc0RlSjA3aTF5N3dWenNUL25hTkYw?=
 =?utf-8?B?MnlhZmt4UlBHcGZoV2Vhd1ZPMlBhQ1hrVGxybFIvdGFKODd2UVV4cFpldlhZ?=
 =?utf-8?B?bTBIME5sZ0g4UDNISUczYUlzb3RXajdob1B5T0xpWGxnTkxMcTc3Q2N5RjJw?=
 =?utf-8?B?cmlJMlQ3b0pZVytXTWNNY21QYkExKy9NSUJ4RitEZm92Mk9CV25RV1FWZDRJ?=
 =?utf-8?B?eWErUkJnMUhReGRMZlJmcFBGVEE0QSs4cVVPVzcvNXBMVXBPVFFQVk1tUnRK?=
 =?utf-8?B?b2xPaDVtMWdOVzM4QTF6RUI2S3MvdHhnSXpOT0JrdGt3dHA2b20zT0hjL0hB?=
 =?utf-8?B?ajUxb0NlRmFVeUFmNVN0cm9LaFE5RFNoTzF6YWVXYWNGQnU2Z3lRanB2RzRo?=
 =?utf-8?B?ZFltL21KQklvaXFoY0xDcUw5Q1IrMktnSUVRbkxyZVpzV3dobEFFUXdJSnNs?=
 =?utf-8?B?SVM2ZzFMU0FoOExUTG9SNHAreTRMZnR0S1JLK1htWElKOUphRTRvczRVZ3Uv?=
 =?utf-8?B?NzBSb2FDN0FQK0FHdStDNmdUOEpxM29rVy94K0drRlZkTWxLdUZSVG12ODNE?=
 =?utf-8?B?aEVkdjYzOTAweG5Jek5sazhaMStWaWZKcjRxYUlEYzkzTms2SDNXRWF0YU5r?=
 =?utf-8?B?dlFMQk5pOWlXdFBEaERWbVFhODBNRXFBYjBXK2wvanRaRnBSZjljdTBoTHdH?=
 =?utf-8?B?TVBqeUJBN3lTQ0VOS3ZwVlM4aGV5ZnE1NnljN3dRYkk4NXFmb1Z3bVNjR3pw?=
 =?utf-8?B?SzZMdzlzL0JPbXp5VjV5dkozNGltaVIrbG05dmFVclBIZ1AzN0lsN21OR0Uz?=
 =?utf-8?B?dzI4Z1pFZ2RqdmsrVUtMU04yc1pJZS9HQnQvUExtYk5tNElxSjZ4RmdRMmFl?=
 =?utf-8?B?NFRPNXZVVVp2b00zakYzYzlNc1dselBZMEdlNDZJQ3ZFc1Q0d2RMZkFjNFE5?=
 =?utf-8?B?ZW81bWUzbnFWM0tmVVU3WEFkRS9sdWd2LzkrN2NoT21xYVVnTzdDb1dPRjhB?=
 =?utf-8?B?VHk0b3V5VlVlYUgrd1dHckRxMzc1L3pVWWxOT1VtdGJjbFJpQklCV0VyUnpk?=
 =?utf-8?B?LzAycFBRZnh2aUhoTjlFSy9YSTZDdHBoN3VWQWJGZGMwQmVqZENUR21RMW1M?=
 =?utf-8?B?REI2djZxcFhGVDgweDMxRnNiUFB2RC9rbEJoeTRPOE1Ha2FyaGtMeEpXYTRo?=
 =?utf-8?B?cjFITHJGRnFBeUdua09hMGZuTW5YU05QSVdTQzc4elVhbS9HaTFHSjc2SG1s?=
 =?utf-8?B?dzFlSzlGaEY3SS84MURIcmZYSUh0d2RwVUh6TzU1c1dNSWxGUjZSelBvaHlO?=
 =?utf-8?B?SzBMWWhkVmh2VWZCNVVJYjhxNXltSWVHY1c4TWFISU1hY3o1UENxSHNJaEMz?=
 =?utf-8?B?RG9XdGhZRWo3bTgzZDU4ejZ3K2RKSjB4c3dWc0p5TE5XQStrMVNsdzFGNGJv?=
 =?utf-8?B?ekZlVXcvNit4bmJaczFLSlI3aDFBZHQvZTdyMUFsS05rb2phd3dvOEZMZmtH?=
 =?utf-8?B?aFJTbDY0SlQ1ZWdJT3RSY3ltTEovblFyamNWZ3BqTHpsSzhIV2hyTHh1UmtO?=
 =?utf-8?B?TTdVWWhRdUlsdjVRRkVsbXRLQlc5MnhhMzVZWTl1ck05K0F5YmJ6SmVraGlW?=
 =?utf-8?B?U3pEMmdTSk1jakNWeFR0dGVqczZJSWEydEhEM0ZhSXY4ZlFMcU5zOFIySk05?=
 =?utf-8?B?Z1hUNUxzQndWVERSckZHQkxUeUtZbmU0T1BOSGYxa0grVmx3bEQ1c09FVjN0?=
 =?utf-8?B?MjBSc3lOSS8yQjVoZmhOWW1UYnJCVW1ZUG5ob0YxcVlheWpabFhVbksvM2U4?=
 =?utf-8?Q?D86mt/RRkJ3W3+WAlEUui2THN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39459fb-e59b-4d17-c07d-08dd5fe4c6d0
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5068.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 15:03:55.3332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0AEVXDq5sGeKhUtMc/5HHEHDvs/n2qIkIY4UJYm6aaHkIoasnekwiLLBbcPvSVcBdEVpag/d3ad3E7szuwcaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

On 3/10/25 01:43, Nikunj A Dadhania wrote:
> The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
> and RDTSCP instructions, ensuring that the parameters used cannot be
> altered by the hypervisor once the guest is launched. For more details,
> refer to the AMD64 APM Vol 2, Section "Secure TSC".
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 8f8aaf94dc00..68a4d6b4cc11 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -449,6 +449,7 @@
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
>  #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
> +#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */

