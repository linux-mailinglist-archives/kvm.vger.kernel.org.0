Return-Path: <kvm+bounces-29011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C679A0F77
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 687021C23121
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 16:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA5B20FA9B;
	Wed, 16 Oct 2024 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KVCx4H6g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7CD45008;
	Wed, 16 Oct 2024 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729095417; cv=fail; b=gJ1XkXeUbCPz6YR+XFEnN5rdHg5Wyhrc5dVZbcDWHadTaXjmWLt6NRbSNrLUA+PlAQXyfpKxnqHkNeB4TnK8ozgQfYKA2RaYu6f8A7qNH+5/7xyNGmVJ9l74en5YJiNooQ2QXDMjn+Gz4KiGageveASR67qwBMF4tnduKmEJhcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729095417; c=relaxed/simple;
	bh=QrDNW0adanUOde7UKeyxRSeuT5QoKZYXxVVWdPEPgCE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q6EWcz/vqOI8FRf6l1C4jJjsrjbw0LbVeI6IH0H6k1FF8cy77V4TfTDtp4OsZ0BVrKZXBvXrINCzlemLZeSr2vLgnFJWojZdW7XEPbNg1NqQowo+fQHp3pmo93qLkxaNMMRJ+/zsz5/eZ6H2IBo8Ts01yHHiKdAOwwxbswerdOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KVCx4H6g; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0UyS29hKcI5rQjqHRJkEBrID8wJmBjaPQ6jfdgjSZynzCUMt88eBNWOQvqTJZef4lnDb9umj8uQVgQK3/dja0Xqh6BLLI1APyZGsJ7UDLdocSUYjNSuroyUrrFrnDr2V03HVtIapX7C004G7Korsq+ewX2wmEiVMwkLmmBAd/1uV1ZzO1G2iOhao0OdlPFQQ/mKr+XkmvcTDmdBSeAnY5twwjDwc7zxE2BgIVDJw/BC+hpe3+/gYfw0Chm+eIDWvXFxOni1BdNMs/sxNntr0C+dl5Qez9ceQ/lVPjwriKUrbg/h96op6omZcbPgd3wMvnHIFXP0iSnpqnhw4aJfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DS3n6y7SsW5/naHRIQBlYEV3P1b2B8tQcXUv5w42ywE=;
 b=zVy1iZb2JEvkWbdATBqwgZvSIE9RUi2mUnR9MHYpJvgOz0Bb4n8MhZMR4MsObvGoY9Ea5OqsX7pcNE67+lMioVrgS7uSJgbKeEaPSZmzBY+zMOIcJ34h42AVAGoyM74wqHQcItEdqXTUjjFEliF/dFDCDKyMZvhD9AWRODoDQMCCiY+uQSrV6SbUwzeQeuJC1sIYncwFLaMlJieZROoiKrvp64XIcR18i3FE07VBK7zG2dS3E0HWBoQ8fgyAej0fPbgfbyMmBfIBUT0hMo5Al3SaEGpo+vkmlnWP/B222kJ2TIWgB4zsYAXt4Sibb/Hlgg/S9xj6PBXwracqcoviEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DS3n6y7SsW5/naHRIQBlYEV3P1b2B8tQcXUv5w42ywE=;
 b=KVCx4H6g0t3gSDRtMgp2woO/eqzMlFK1I+6NZ9Tkpyjsz+6m9mdwY9TpWt1XBAcdV8nYUF7RybTHT6tHYB1lQhkKvRcjeXlmIm6l1xevGTAKSNvdW3Q5IKeM/tWOCyQLNy/bfNSTLDcROFPK/+RoSw2lNDRARWC7q/yA3D2DfK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB6262.namprd12.prod.outlook.com (2603:10b6:8:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.27; Wed, 16 Oct 2024 16:16:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 16:16:47 +0000
Message-ID: <03840d96-8fd4-b0c1-f6da-f69ed25cb4f0@amd.com>
Date: Wed, 16 Oct 2024 11:16:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v12 02/19] x86/sev: Handle failures from snp_init()
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-3-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241009092850.197575-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:806:f3::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b0fbde0-6e38-4492-a837-08dcedfdeec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVdhZzBDMEt3L3kvdWg2MjlnZGVPZ1BtY2YwcUoyMGdTM3I4UXRoMkh2R1Nr?=
 =?utf-8?B?a1lYZXRtcW44aEI0VzZGdXRtSENTRDVGaDFYdFAzTjVydzR4Yk11bWx6eU9v?=
 =?utf-8?B?d1RJSVBnVUNqSU9OL3p5Z3VQemUvcmpMQUpQcmhvWkJsQVgxTFFkeVRtZ3FT?=
 =?utf-8?B?WmN5VmhPcGZqa3QzejgySlo3dHBUdmZ0bmhzTzBXZUtZVkljZDdmMkZ2WWVS?=
 =?utf-8?B?ckYrWXM5QjYyVityVEJwOVpuNU9RWHk2S2ljaEZzemFoZGF5US9tMHkzMDBu?=
 =?utf-8?B?blJxYTVkNU9jWklKVVVlTGVnT2pLL3pSVUxJOHd1ZjZ5ck40cTRKcm5MWGRh?=
 =?utf-8?B?anBtK296NDZ2RE4wckVQYkVUWXN5SlE2RUo2UVhscmdWbG8vbkR4Q0hQRlhH?=
 =?utf-8?B?QmVhYXZEcHltSjFUOUdrWUNGYUZGUXJEdEwwdzdPdDBvd1o5QTJnaklFZll0?=
 =?utf-8?B?OXZSSWdPdm9NaVVsSG1tZmZTRVZPNGZNWnBTa0llVFNTQktzb3lIVGJkdGZy?=
 =?utf-8?B?elhWaWo5amN3T1hXSkJibWNBWXdaNjhRcVRhSmRER2ZpUjZZZXBEREpaS25O?=
 =?utf-8?B?Z0RoV1VOcDlSaWNQMzhiei9ZcG42UzlCemYzV0Nnb3RqWCtJVmJ0dEZBR0Q1?=
 =?utf-8?B?ZUhFTVBPaTZQL3NxSUJxV2R1bHN3UFpEYzRUUnFRTjk5YUhWaG1CRGZHbjl4?=
 =?utf-8?B?c1BISm41aFBrWHFhdVk1Z0FHcEZnMkZ3aStsMlQzcS9MT1hmVFdTTkVLMEN0?=
 =?utf-8?B?bjF0Q3BNVkFKMlNjWGhsZlZ1aUZjNTZ0Mk1IOWM4em5BOEs5Y3BNWkJUVS9M?=
 =?utf-8?B?TjFmQU9PQzU4UUkzOFdweTBYNDlXMGFUUmpYZmM0U0RIMWVUNGcyMjByZGdN?=
 =?utf-8?B?ODhOamxReTRnVWhMNlFzUHBmWTVFdU94SGxyNzQ0a0FjTG1jSXptZS9TcFFP?=
 =?utf-8?B?aGxibDd2NWVNbUxPUkZ0dGNCUHJRRkJWdmJZS1dJTU82RGRDQlZIRnlrK2lr?=
 =?utf-8?B?NTBYY0tvS1hya1JOUHpFeDBzdXJVeC9Oa3oyemxaUDJwKzRsVlY1Tm50SlM2?=
 =?utf-8?B?SEJzaHdqWkh5SDhLQ0thREsvckh3SW9mS0tXRE5tcVJiZ2liRENxQnpSZXYr?=
 =?utf-8?B?MmRtU0ZZeWZCeUU0NGNVVGNkYXQ3bWtoaGFrNndMSWxBK0xnQzBDZnhzTm1Z?=
 =?utf-8?B?NW41S2FSMDVPZ045U3JWazR0bjNiRzlCcndNT0ZsRk5WT1BpY2ZKUklISXll?=
 =?utf-8?B?V3VRVU16SXZ3T2QyWTZmWWZ4YkhFRkVyd3lXaXhlQWRDQjRkelBmb0FsY050?=
 =?utf-8?B?TUhCSVZHOWw5U2svNjJORk1KVitFZjdMT0FmMk1mZWdTa2MwQTRDeGFXbkl4?=
 =?utf-8?B?VWdLV2k0N3ltRmlUOWRsR25xU0ZMcVFJcTdRVGJ0bjc4Vnp6ei9qSTZycmx5?=
 =?utf-8?B?UFVXdnZBNWFRQ2NNN3ovQVE0OVRLcUFjSzArUk9UdzV0OVJjRFdlaEFLK3Rz?=
 =?utf-8?B?U0JHdVYwajlmcFBwdDh0eThpQ0JZVnNZVXowYVZmV05VamlqTThpQ1ZzRURq?=
 =?utf-8?B?V0huaFB1MzYwSnlxMFBvQVVpVjZ3Y1VFSzBLTFhhYlpORGdpcVpGUjRMMERZ?=
 =?utf-8?B?Zms4RTBOR1N3TGJpejUxVm5ZNm1XSi9CbG9NSW9BclZuRFBjS0pTeSs4aEJo?=
 =?utf-8?B?ekIvbjZ2bHJZQWlyZ0RDRjNNaC8ySWlUMTNTT0RaYTRCY2RyVUk1VjJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjVKWUkxYXVEamp4MDMxOFFGUW1ibzl2V1N4SU1ndWJjRUIrSVNWbjY0QUc3?=
 =?utf-8?B?SWI2cnNXSkJyalR3QVUxOXBwWVBNeDJXY3hGbE40ZGxIM01lOHprWWFpa2tZ?=
 =?utf-8?B?eVVPOTZXU2lFR084SVQwREpNSVNCMWhCUG9JTCtybkFsb2FTemo5QVFPSWp2?=
 =?utf-8?B?cldDL3dVRFR6VWt0a3ZsU2F2Y0Rub1RWRndJYUZPY3NkbmZNS1dBNjRZLy9O?=
 =?utf-8?B?NUZ6R1JtMmNHektiWldXZ2d3N0ZESWloNGRvRHlLNHptNVh4MDEvUENnQU13?=
 =?utf-8?B?TnRKMFp1NFplSDdhQ1V6VG5qMmEzZzQzR1JtR3pzWnR6SWVDbktKRHJuaGpU?=
 =?utf-8?B?eHcrVDVUeklGZDBSQmVnUjlrQm9mRFNOa1dPbGpaSnFaSGRyQ2ZIS0t0U0oz?=
 =?utf-8?B?TjYvY3dTSGQ0dXYxaFdCVTNwT0ladlpaOGVITUxYaFdTZGg5RWlaZm9NZUpY?=
 =?utf-8?B?UmtVT2ppRUVkdmJXbHluWTIweHBTK3Y0NUxNWmlxb2d2Qm9SUURrdi8vMjcr?=
 =?utf-8?B?Vzk2QTVLdVhocEd3WmRBZERZRkFSL2l0Z0VsbFgrS2NFSGEwcGc4NFMzSkNh?=
 =?utf-8?B?NTBSVFhlMDczenlhd0VxeE9lNy9uL2kwRndkU1k4YTFTSVVTTE53QXJ1cTBC?=
 =?utf-8?B?WnpYSnZGVHhTaFJXM1IrSGw2bGFQUDBCWTBoLytxTFRaSGpGOGRBR0dhcXBq?=
 =?utf-8?B?WEpkRzlGY2pkSmcySEV3RHVET1ZpNVc4a0xvaGxaYTRHc21jL1ErS1NPamJh?=
 =?utf-8?B?NW90V3RwbTl2RWlRQjBCNmdHQnFPWGdUWkxQN3dJazZ6SndpVkhIbHBjWWto?=
 =?utf-8?B?TWI5Qm8xUHl6RFgvWURwUHNkSGhuTXAwTjVIVHVzY2hjU0pnUFJPWkRqcm8z?=
 =?utf-8?B?UWtkdnhEU215eE9yZzNiZnFjRG8rUEUzUjZTZ3RNTjQ5SWtQd1dPY3pXeml5?=
 =?utf-8?B?Znh0UWFwME1NbnZic0xmK29TeFlxRW8wWmFwV3I0OGoxczgwckJKamVXczBD?=
 =?utf-8?B?U0NWblBzclF0MWZDUDd5dldIeXZEZDVCV2ZEQ2l2aVpoL1YzNFRkM2V5VjJu?=
 =?utf-8?B?L1FsUGg3YlZjbkJIcEZERTQ5NEcwZ1B3c3BXTU1aWnB6eFNmMWVkM0ZIRm9y?=
 =?utf-8?B?alR6ZUFhMVlTWXJVdmQvb3dYWFIraFBTRFhGUGZFWnV4alpqYUpuZHBOTlV5?=
 =?utf-8?B?bUQ4SWpqenBMMlV3RFBtMC9NZ2hUemZlWERraFB1MU03U25VNVF5V3JhcXVa?=
 =?utf-8?B?bUpvK1ZxdWJKd25LdE1ncDN6ekhoWnBZaVJrZ3lBSHV3a2l6RFdHanhvczNY?=
 =?utf-8?B?czd3YlZha3FLVS9uMDEyWUdaTFRrYStnMlpheU5tTnhpeWRFM3A5aWxpaThT?=
 =?utf-8?B?dVE2Y2s0K3QzRVliVnpPYU1VQ2lMd1ZQS3NUeW5QeGRFQUp6WW9MVytTdSsw?=
 =?utf-8?B?ZnlYWDR2OUxSeW1mME9ueHo0d08vTWFBSzByazhmZGxPVmRwRHV4R3VpSXdT?=
 =?utf-8?B?Z1ZXU1J4dmhHUUhTVmlUVGFLZEpwKzdEaHp6Sy9tUXMxZGFtekpQc2NDSWNF?=
 =?utf-8?B?aTJQeDNIR0ZDdXdDN1Yvb0o5anhuNmc1enBmRnBOZVp2SnY0V3A0eEJ6OEVi?=
 =?utf-8?B?bkUvNmdlMXZXTGRUamVoSytldUc5cDk5ZkMxSVpvcDUzNnM2Y2VmN2p3djBs?=
 =?utf-8?B?dHhBVm9pUnRIRllxMkg3T3gwc1JOUlJYM3NMMmd5RUlpZThWNWt3UDJVNitn?=
 =?utf-8?B?cjdnTE91UVNNRE5VMThTVHRZNmdyR21lOUVpQjdENWorcnRSQjVCY1Z2U1RX?=
 =?utf-8?B?NVhaOTl0NktjampIUUNTRWk2WXFocjdWMTUzdjBTU3NDTWtUL1pZSC9yRVA1?=
 =?utf-8?B?NnZRcTB1aVVMZmh6ZGVUNlc2anlXQUU0b3JpOWNqcmRpWEFjM08wVzQ3OFM4?=
 =?utf-8?B?T1ZieTh3QS9yK1NXdHRUd0RUZzE4MExtbFkyMWJkdW9hOEVhRVhrZDB6Mm53?=
 =?utf-8?B?YTNqdHkxZ0RKZ2JTMnF4VEJWMkNkUFZYdUpBNEROMk1ibEt0SGpQaFdOWjBJ?=
 =?utf-8?B?QkhWeGNyclBNMDRtT2o2aW10WHlGNm9tMHZpYTNXVkhvRXZETllhaUFXNUxD?=
 =?utf-8?Q?YLKkskKLl+Yc+i5mTmygSU1WA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0fbde0-6e38-4492-a837-08dcedfdeec6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 16:16:47.0146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5pQ6UAZB6EP47eQG98AhHMI5JDAaI04/iI3RKkk0HJieQ9apz3nEWeWjLsEjhVQeLtiJvu5DBgstAD79Z4QUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6262

On 10/9/24 04:28, Nikunj A Dadhania wrote:
> Address the ignored failures from snp_init() in sme_enable(). Add error
> handling for scenarios where snp_init() fails to retrieve the SEV-SNP CC
> blob or encounters issues while parsing the CC blob. Ensure that SNP guests
> will error out early, preventing delayed error reporting or undefined
> behavior.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/mm/mem_encrypt_identity.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index ac33b2263a43..e6c7686f443a 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -495,10 +495,10 @@ void __head sme_enable(struct boot_params *bp)
>  	unsigned int eax, ebx, ecx, edx;
>  	unsigned long feature_mask;
>  	unsigned long me_mask;
> -	bool snp;
> +	bool snp_en;
>  	u64 msr;
>  
> -	snp = snp_init(bp);
> +	snp_en = snp_init(bp);
>  
>  	/* Check for the SME/SEV support leaf */
>  	eax = 0x80000000;
> @@ -531,8 +531,11 @@ void __head sme_enable(struct boot_params *bp)
>  	RIP_REL_REF(sev_status) = msr = __rdmsr(MSR_AMD64_SEV);
>  	feature_mask = (msr & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
>  
> -	/* The SEV-SNP CC blob should never be present unless SEV-SNP is enabled. */
> -	if (snp && !(msr & MSR_AMD64_SEV_SNP_ENABLED))
> +	/*
> +	 * Any discrepancies between the presence of a CC blob and SNP
> +	 * enablement abort the guest.
> +	 */
> +	if (snp_en ^ !!(msr & MSR_AMD64_SEV_SNP_ENABLED))
>  		snp_abort();
>  
>  	/* Check if memory encryption is enabled */

