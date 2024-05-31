Return-Path: <kvm+bounces-18518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEEBF8D5E22
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 820A2285003
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A587BAEC;
	Fri, 31 May 2024 09:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OBsBEjJz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D17442E;
	Fri, 31 May 2024 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717147368; cv=fail; b=TjPJoh0wEpqRhLBa7fFlPeMZi/gerv7QPEwiMd0Pna36tON4gw0IwCQFwLqSltkSgDD9pGaDx0H+7gIHttTDwJHDdX8EweDJZ3ci2tOKEJ2byaw8OH9DTY3aRhda+spCspCGEkUnujWfb/9sQ4s1Wl+DIJbDObeUOdyLrU0togI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717147368; c=relaxed/simple;
	bh=BBnQRWomeufw8zlO2A160+UO9XH6jaOo5nUIjTU+mrI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hmu6faHQqoC+jJU/tt1jymKPsc6kKBRaACinD3YZmFcf2xlNrd+5UL3Q1amSuOy+9JEsf1MphxQnGPmEpr1laPFMHpesxLMEjkBVtK85EsxOEm14+nMAXZzZWUOydqidtGzBRZTvX2hD9XvWCe/p3ReFMIPL5yq55hABhLYfPTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OBsBEjJz; arc=fail smtp.client-ip=40.107.95.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/YCzabwsZAu+invrIxlapTWEMGkghYZhG311zv9GU9zNzNL68/5OSYZ7B2cLaeW7poL5/mhkqr5ofPNvQ3I+G1AVe6OvhdiCyQGSnKE/bDVwUkIO5m3Wjwd5xvYFcR9Xc178OGLmU+VUkf2wb6zE2q2q+c+mcc2NdYEQl9XrmNey7A+wxRgZein4hI2SDBCvJG4UMVBSgeiLelcoNEZ5Gdxxe6G9pPQsSsHHw+nJ/b9OqPD3YFOybcZkTvyHWLbF03KB4GyLY2S1/0pc0WtN9KzC/mSt7UsPRimtfgdKM44nnK6mkLqFKRAnkCG+DuBVbBtUWZ3d3q5NfY+mU1E0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUVXD/wrvOhIw8YqiATz4DBgk3GKTIX1edwDMMiyWuw=;
 b=Zub5wMtoy4G3uvuSQwgCHinxsTaGeSqVAyrO3cxAbyGVs5yx9SE0aS5d3RhUwL8JFIDpqcmtJI9DjuLUygLHjaoiXMaLaQYh6czZ+ZVp7wqUSnDn7621IJGNSE8Kn1OrsFnBflDHi6cBZi10suRXcMkt5X4S2SsSkI7eeFwmW5jB24VwOMm4pa4xcSAAzt8P/u52cOAPpxm0P6b0sDIBmnZRbq9yk7efusZQ+Cf1REPKJ9+V+70w3KusYDL7jZTSLbJOqrNvH0pYygQbBjKQc1DQSZb9uRq+dlSmIIViZh41lez15QazlevwxfLnxg2YN8c8HvWA8gL0GXlsd0+dow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUVXD/wrvOhIw8YqiATz4DBgk3GKTIX1edwDMMiyWuw=;
 b=OBsBEjJzXVKe/oX6alj2O5b/PXYexOhOtc1zeOtf3lnvul6G4SqiYKktRTw8etJEmf9ZQRK9fcane2eh2rPTq59E3GnxFjCAcGr9wJFZEPpKC9b5OVLFj7jnuhSouCIUGetRRpN/b3o8O0L+dVB0NratDsiz8y8hIhRhKL7Afm4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB8341.namprd12.prod.outlook.com (2603:10b6:8:f8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.22; Fri, 31 May 2024 09:22:45 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 09:22:45 +0000
Message-ID: <6a612d9e-e488-4604-b3e2-801767115f2c@amd.com>
Date: Fri, 31 May 2024 14:52:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] KVM: x86: Add vCPU stat for APICv interrupt
 injections causing #VMEXIT
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
 <20240429155738.990025-5-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240429155738.990025-5-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::17) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: 7092feef-651d-4670-7d98-08dc81533ac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UG1BM0VaL1IrbTJNMWtZQjJacmtqTTJtaHBMTlpqVnA1Y3gvZ2JIak1DR3dt?=
 =?utf-8?B?Q0ZxeW1DNVFIWGRWWndzZkJxNG40bFIyTVZWVDdzS1IrNHBqdFFRWTBNZm9v?=
 =?utf-8?B?Z0g2cExPRDN0aUVXUiszc003L2d3ZWRia3luSGJ2UWNkMlVJUkFYWlhhWHRy?=
 =?utf-8?B?cU13T2t5Vk1GQUI4UkI4ZlRPaG1EVmhKYVVwTWxrdW1HNHRSODU1QlVRbXYx?=
 =?utf-8?B?T0JTWkZCak9qNURjU2s1NHNadWJPcCtrQUh4ZGk2bzFVWDl3aHpkVndvRkkv?=
 =?utf-8?B?QWZ1SzRqU0hRUm1sOVRhMGJaS01uWEJlZGo3dTF1ZGw2bGxWTHdoWGVkUDNY?=
 =?utf-8?B?OFNYNWJIMEdKYkdySjgxQ2I3NDJYQVF5alhlblc5aUFvNkk0YktxSlpvWHJr?=
 =?utf-8?B?MDdVT3VNVVVmS0JnemExK1llSnhKQVdaZnAwbDl2QnRlYzVBeHdSTVp6U1p3?=
 =?utf-8?B?ZGNqT2VJK2NHYnBFZDBFUENQV2ZNaUN6aXdJUVZEdVdabU9hVXdlb1JRemJN?=
 =?utf-8?B?U1pzN0pkQWk1SmFrR2VQam41elZpeGtoSU5hVFNFQUU5YjUrSnV4YVlydktP?=
 =?utf-8?B?Y3NJYkxDMXNWcitZZkk2TVdOZ29yWDM2ZEVQcm1DejRIL1V5YXBjM3NPeHVI?=
 =?utf-8?B?UzExUGd6M0tsZ2Qydkc2N0pxTVVOWTFMWUd5ODBhY1dRV1pzaVZIUytncTNv?=
 =?utf-8?B?eXZnaXFQQVEvRW5ORXpXaUU5TERKYTQxV0xRRlUvNXVZM1ZWY05mVFZJRHFh?=
 =?utf-8?B?Q3NVK1pZRXRqQVdqZXFoUGZlVmd3SFNCRmZuV2Z4T2Jrbmp5WGV0T3diaGZj?=
 =?utf-8?B?NjJhU1BScnhjbWN4dlZ1a254NC9nNGFESlhvb0YwNU5SZTlyMVZGakN4eXNK?=
 =?utf-8?B?R002Qkx2ZlNyakFtQjV6OWJDaXRXK05ORFlwa1ZwY3NkSDNmSy8xcTRoQmVI?=
 =?utf-8?B?djZ2djF2a2VuWGZRc25XN3BMMFhxOS9CSW95Mk5ubXRyRlR5U25Gcnl4M1JC?=
 =?utf-8?B?OVVXa0RWNmVGazBWRHU5QVloSkYzYTNzeXBwL3JUb3FTM3JQQTVRaDZKd0Ro?=
 =?utf-8?B?WU9vYUJVbUwxNzZIM2VVbkZDc1V3bVBhc2VBejFXQXlaQUxkc3lUZEdQWU11?=
 =?utf-8?B?Nm82VlE5MVg2L3pubHFta1BQQ1JZelhqTVpjaVBkVjNDeTlhM0J4Z2g5Qk9G?=
 =?utf-8?B?QmhyeDAxOWtOR0xDV2dDM0VST3IwT0tRTWhvV3ovVXRtUytJUGRHSHZvaWJR?=
 =?utf-8?B?aTFXRmpnNVVRckhyZ0pSdXBMV1hEc2ZKU3FhVWxuQlErbnRTREg5R3VlTmVa?=
 =?utf-8?B?OFlLK2txdDB4dm0rOFB0V01yVWx2WDFTZVhHbWVYL2FjM0ZzeDE4WXc1L0VB?=
 =?utf-8?B?bXRmN2lVekMwajJvUHFlQnhrNlBUWW85MnhxVDdvcHYvWmJpS3dhd2U0TXA5?=
 =?utf-8?B?UFVZQVVtdWErWkhyZjM0cGlQVEt3cG5MZjRmamFUVWNkUzIrQ2ZYOHA2NUpK?=
 =?utf-8?B?STlUTHNqNWsrdnZ1dkxYTWdtNmtrT3hHeWhGeU9udEJCN0llTnN0WFdpanEr?=
 =?utf-8?B?V3hjUG1Qakc3TDVTNnVhc1p6aEtyUXVqM3RoQUxQR2k1NktONFRIOVRRRUJx?=
 =?utf-8?B?UERQYXk2Q1RzSXRKUGUzQk9JcEhEYk8vTUc4Tm9iS3kxbnduYy9JOFNEZE1a?=
 =?utf-8?B?QTVsdFhQNUVXeXp1RmF5WVBvZ1dBbXVXRjRGUFRBSlAzQmJCRFV5WFl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2NrT1k5VWRqYzA4Z3d6SG11NXJnOWJQaGovY245VVEzNUdkaVVoRXVPUUkw?=
 =?utf-8?B?TEhjMm12TE5RMEd0cmU2ZVVzVk10ejEzZHFJYzkzWXEyczhEcSs0T2k5c2gv?=
 =?utf-8?B?bUtOdHcrSjg3RStLV2RzZy9iNlpqTzRCREhzVnYrUDN1c01LMHFBUUx3S05Y?=
 =?utf-8?B?dFFxTyswN3dJMXZLYWN5VWZiWlV0NXJTWm1RK1UzdzRMNHVjbTE4NWcyWmtU?=
 =?utf-8?B?L3VENUI4NlRCZk1YZXZYc3hnbG5jL3JPZHZFalU2ZkhzdWZOSEE2S1pNMjJI?=
 =?utf-8?B?b0I2TWF0aG9RWjl3VDI4Rk9PWHUrSUVvVk9qUFMvZ0lYR1k5d1kzSzZPbmow?=
 =?utf-8?B?MDQ4RWxEcVVyMmhJK3V6MTVaZGl0b09uUkN2dEN1NllEYkFDdzZtZGtBbUFF?=
 =?utf-8?B?TjJnUmVGUUFPbG42SHZZUmZzQ3ExK2ZwWHd4TDA0TlpFVzMySUllY0VQQThm?=
 =?utf-8?B?UjE5bU1SanFFeVNWKzFqZzh1NVVpWURNVC9KYVc3bytZV0NOS3R0VmF2UDFo?=
 =?utf-8?B?ejRjcDlQeFRYSHgzekVKMVVaY2IrKzN1OEQxczVaZzFaa0NjdzYwb2tVZmJj?=
 =?utf-8?B?dFVsQzFxZEhiMEhYQkoxVldNWStUbEpMcHZOMWEvUTdhbFpIMWdOcytaQUxN?=
 =?utf-8?B?TW1JVWJoNS9XVnBrYkJldnZvTkFycHNXTEJrSUxTNUV0eklqM2RURTNJM2Y5?=
 =?utf-8?B?MzcvZkMyZmtEdEpFZHlZUnJBSER5TjhLeTRBaTh2TGNBYVNSWUxjTTNXZnB5?=
 =?utf-8?B?ZktmUEQvMmtIV2hoT3htK2tXeUU3T3loSjFRVEdYN1dRRTNXZjRnRDA5U2FJ?=
 =?utf-8?B?Zmsza0JsRWwyS1JSd2dwN2RBT0JUSVlJcUtNQTYvekVHM0tLbUNOcVZzUUhu?=
 =?utf-8?B?R3NxdFpSNWZ6OWFEOE10QUMxOWFoOWl1RkJBUlRIRnBLRXcxaDBuTktUL3A0?=
 =?utf-8?B?T3pUa0ViTFlhRUVGRmtrQ3orb3pTK0dsakQ4L1RQc0dsQll3bklMMy82RVp2?=
 =?utf-8?B?eFpWdDlBeXo5MHB2WlRGK240dFI3c1IrcmUwcXhqWlA0UjFQV1QycFFkSXJE?=
 =?utf-8?B?RnNNcGtNTnVxWGJvalVKaERjNVZNa1R3dUdjQlhDMzdYUW1idkMwOGhzWFk1?=
 =?utf-8?B?SmFrN1NPelpYTW55NDZRaWhiejJhUURxcDFRSDBodDdGdnllN3pwYnhDV2t3?=
 =?utf-8?B?bU4xcmJXT2pIZE42dXNFbmxkb1AwVTZ5Z3lvbXIvNnFIUzc4bXV0M0xtUzVQ?=
 =?utf-8?B?L1ZHOHlhLzRsYm42dVlSVHBDbGVOSkdJWVFldkNJamVuV3BObjFHVk1JZW1V?=
 =?utf-8?B?TnRodStwc2Z6ZC91SFk5NGxVWlZuK0N5ckRvTGVBUzBPejlYNTVnWUZtRjFW?=
 =?utf-8?B?RUNJRXl3T2UxRWFvU0hRK0JwbmdtUlR4OGhiUXJMUnhtSEhNdlVkbm43YXJW?=
 =?utf-8?B?Qmp4UFFaZjhpaWU4TE5GVzdyMjNyRHVFVDIyQkMrM0ZBWHF5Q3IxR0IyVm1J?=
 =?utf-8?B?c0xyU0U0aVprQkJzaVB3cW1FQlVoSVBobndMUDEvRkk5NFliTnhSTjJYd0xZ?=
 =?utf-8?B?QUZTekthWGtVcFplaVhwWlQ4UTE5VzVneUJpcGxjRFNJN0o5RndWSHc3RE5O?=
 =?utf-8?B?dkwvSFEwTG1WY25kcllKdDNVVjdrQU1aTzFSVGxjQXpZWVZzMmdFS2RxTStR?=
 =?utf-8?B?QXphemFJMVpKWXd1ZTgzcW5sMlRTNUJnRDNDVVBYN29qcURWQy8wd2FYeUdZ?=
 =?utf-8?B?T01CWEhLRHdwYTc1T2JpMzdnYVZtdlp3ekc3TmR1VHF1RlExU3lFWFYrVm84?=
 =?utf-8?B?aktPV1ZuSlRYb2MyOWdjSmRzdUJxbzBMYUpzblFPQjh2SkhVRHByMHdwVTdz?=
 =?utf-8?B?dTRIdXNxUTlHVEJrMkhMd1Q5QmwwTWh3VUdYQ0hpWEhOSG5rQytNTGVITS8z?=
 =?utf-8?B?Qmk2Wnp3ZmN3bEt4NFhockQybUE5VnZtUHUvdUpMWFROL0ZrL2tkZGxjQkJV?=
 =?utf-8?B?OEtydW9UTUtZR0dHdERwdEhqanFXUWx6RGtoWUJ4bkRydkJrRjFpUWlYQk1j?=
 =?utf-8?B?UHBKcUNBeXVpeDVlcE13OGtFTkRzdDhpVjFTdzZNMVEweHRsWnFoSlRrNjgz?=
 =?utf-8?Q?bDWVxCJ6jwoaWVn4RgiuRPxp3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7092feef-651d-4670-7d98-08dc81533ac5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 09:22:45.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDV7hi0FYyH7dkh+VFiliT0YSypudnLCkCDfnvuAnGVZBGNgzBizfjUTk4d9f9T+N8SfjNmte0V9ko2Ex0uPGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8341

Hi Alejandro,


On 4/29/2024 9:27 PM, Alejandro Jimenez wrote:
> Even when APICv/AVIC is active, certain guest accesses to its local APIC(s)
> cannot be fully accelerated, and cause a #VMEXIT to allow the VMM to
> emulate the behavior and side effects. Expose a counter stat for these
> specific #VMEXIT types.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com> # AMD

-Vasant

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/avic.c         | 7 +++++++
>  arch/x86/kvm/vmx/vmx.c          | 2 ++
>  arch/x86/kvm/x86.c              | 1 +
>  4 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e7e3213cefae..388979dfe9f3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1576,6 +1576,7 @@ struct kvm_vcpu_stat {
>  	u64 guest_mode;
>  	u64 notify_window_exits;
>  	u64 apicv_active;
> +	u64 apicv_unaccelerated_inj;
>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6..274041d3cf66 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -517,6 +517,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  			kvm_apic_write_nodecode(vcpu, APIC_ICR);
>  		else
>  			kvm_apic_send_ipi(apic, icrl, icrh);
> +
> +		++vcpu->stat.apicv_unaccelerated_inj;
>  		break;
>  	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
>  		/*
> @@ -525,6 +527,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  		 * vcpus. So, we just need to kick the appropriate vcpu.
>  		 */
>  		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
> +
> +		++vcpu->stat.apicv_unaccelerated_inj;
>  		break;
>  	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>  		WARN_ONCE(1, "Invalid backing page\n");
> @@ -704,6 +708,9 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
>  					    trap, write, vector);
> +
> +	++vcpu->stat.apicv_unaccelerated_inj;
> +
>  	if (trap) {
>  		/* Handling Trap */
>  		WARN_ONCE(!write, "svm: Handling trap read.\n");
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f10b5f8f364b..a7487f12ded1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5657,6 +5657,8 @@ static int handle_apic_write(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>  
> +	++vcpu->stat.apicv_unaccelerated_inj;
> +
>  	/*
>  	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
>  	 * hardware has done any necessary aliasing, offset adjustments, etc...
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 03cb933920cb..c8730b0fac87 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -307,6 +307,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>  	STATS_DESC_COUNTER(VCPU, notify_window_exits),
>  	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
> +	STATS_DESC_COUNTER(VCPU, apicv_unaccelerated_inj),
>  };
>  
>  const struct kvm_stats_header kvm_vcpu_stats_header = {

