Return-Path: <kvm+bounces-25913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05FAD96C98F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 23:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 875EB1F2651E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 21:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7BA155A4F;
	Wed,  4 Sep 2024 21:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gy0rE2JY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026E13CFBD;
	Wed,  4 Sep 2024 21:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725485472; cv=fail; b=VWVtdXH09tOlrW0ITwY5Q/64RSxSLabEfSUE7vooT0wb0lxSv61Hi+yfbvIZA1/ZcdihoPQuuevXe/Un7mdUPkkROXfhT1eJ7xVc98l9gA502ZiadjN+AdSxm71PryS21FXV0qqrk3VJYQ1BAy543PYw4PbAiLA/oSTqJPrQTrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725485472; c=relaxed/simple;
	bh=Lndl9LPJCN2FiRUMPoHzAHwCsueWBrDJGiivmnrkOdY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=geLvTz7Qx29msjA4wdXlcctxNupOofDPc4QwhOvChygSEO/2qASwtJiPdGQ8Mne1pSh4R7bwY52OKW9ok9ixMbt4/ohRcyehXK2LMXaGOxdKBM8ISwrGNLgiZCwtvo/H2HplqWabbpPFFt0uC/28NJulaKppR1XUc0aGR+8Lpgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gy0rE2JY; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfEnyW3KxMYtXFG+IJMxDhBunJsF52r57PdSUIWF0lXWVuUyQ4ri4BeyMJGNZX7FaBgu37kWH8qvyzT4mNcpLiiEa7xLaVadPgwRA6a3POqCTfyi5fS+/QT6MRWL0oxX2IJyClQgd3zpmgO5IlLLk5TbZhIWCah6Nt6jcChKIXrc1mEyRdAh/WZBtA197R+OsRGgzRtzUexw/jujXjjokAff8rsnJg2CHtWuXdxatkSvQTbkhd4wSYC3rlci90eahZT13Rz2PNOWAdLdEuFv1NlSP/mXUlTK4EI47/nFfFYDxfNzcDd0pqcrOmYzTnAZ5s3YsWPtjbLpsBH/z3cEHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upAaKR9qcxRa1Kwl96ym2Yl2hKWK8pG9IqYh9VrNrbM=;
 b=xX7zci852oIyAzz8IIxhDok8OtYtfICNvTvjLkh5SKycvHYct6z5KOHOS+c6MSDYlTsDdxCayM4ReO30tiDtohr9Vjq4VNrMPQUqG4pOZ1JUdGpB8CD0MhZQ2WFHbuoYDaB3tL+Noa3Pn8D5rXK0wpfX9BSr2BktNoQNMD+Td1Ee3yN27tpkR+aoyveCiNWSFyVZHznwyUwcb/fGqEr4VTsT9ogmBv2v13eNWKH44JUP1tuiL2LXl8YOXsRJG9aAvrDxP0DxFskH+9STJDO8p40ySSucd/2oHKvBcne8zH6ov/nLzBz2nmy9foQ6L0h4PUNoBcaT+A4eXoPtqU+oIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upAaKR9qcxRa1Kwl96ym2Yl2hKWK8pG9IqYh9VrNrbM=;
 b=gy0rE2JYe0nXObApNixxgNCVcCWFafX9ZdrkpYL2JQZBdixEzHvc1iKL0omA6SiTRdiNRoYqm8TJIGOOlcqaPBqS4R3YudG3Y+GfEuUFeK3uXWJg7dfw34JYEKgvpKMGc5ZfvM1zO6V97mF4HYJE8CvSku/2fz5N6Ml5C5HSgi4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB6884.namprd12.prod.outlook.com (2603:10b6:510:1ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 21:31:07 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 21:31:07 +0000
Message-ID: <c24deb49-4369-4dcf-bb71-3160f2466ac3@amd.com>
Date: Wed, 4 Sep 2024 16:31:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, dave.hansen@linux.intel.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, thomas.lendacky@amd.com, kexec@lists.infradead.org,
 linux-coco@lists.linux.dev
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
 <ZtdpDwT8S_llR9Zn@google.com> <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com>
 <25ca73c9-e4ba-4a95-82c8-0d6cf8d0ff78@redhat.com>
 <14b0bc83-f645-408f-b8af-13f49fe6155d@amd.com>
 <20240904195408.wfaukcphpw5iwjcg@amd.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20240904195408.wfaukcphpw5iwjcg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:805:f2::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e34b2a-f29d-4749-8363-08dccd28e2e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTZFSjFDbE1rTU45UGMwcFRqdFY5UEdkVFU2MFVWZzhlVExDQXlkZ2lXU21W?=
 =?utf-8?B?YUdHMy9TQS9EODRGemRTMVF4VzdhblFzNmpoeU5KZGFVZm5xaHp1K0RlMTlQ?=
 =?utf-8?B?L3cwSm1VN29EVDR2U0pnTkZGRDI1QzJsdEhRd2l0V1JFZkcyMnlQZ0d1cTJj?=
 =?utf-8?B?cjZZY0tlQk5NL1lwOHVkcDdueHo1eCtKSFhub3d6Z0lLMVRXNUc5VzlmckpK?=
 =?utf-8?B?Y2tjQTdmZ29Ia00za2JwNEtUTCswTDVFdjJtdVN6YmtrSkxFVXBDdHFRb2Ri?=
 =?utf-8?B?b3JRT0VlYUZVNkV6aWM2ektiZ0VzYWVTNWNrZDcrWGxPRHFKaXRBazArQUFl?=
 =?utf-8?B?NGxZd1psV05PQjJld3lsTnppZGllV3RXaHhpamkrdjlYWCtPaDd0SGRxZGNW?=
 =?utf-8?B?NUpLbUg4aGwvd1dqMlV5eThEZEdSZ01ST2g2d2ZsOGFxVHY5a2V3QXhKMERY?=
 =?utf-8?B?cklteWErSE1PR1AwcDRMODc1ZHhpVWxuTkRnVCtvWlNGaW52cExvT0VpdjFK?=
 =?utf-8?B?ek5NaEJIWVUwZ2VMQUwzbVhHSDJlZmVXekcwNEh5dGJodVlrbWVxdk8xY01m?=
 =?utf-8?B?cGFVQnQwVENnN3VuL0tMWGZvZkkwTlVrdUxLWTZxSkpJdENpWi80emhVSk9K?=
 =?utf-8?B?bGhBelhVellXS1BFeEdDdFVrNlhoTFpXTDNjTllhZE1ITW5KY2ExemJldEZq?=
 =?utf-8?B?NTNZdjFpUmk0MUFRdjVKR0ZmNDRqRG1ucDZRR0hvaDdHYUFmcUlaZGFHQUVH?=
 =?utf-8?B?KzRnRXhjVHNoK0xsWDQxeGVkWk9nN1dCOHk3TVVoQTVqQTFkaFhSS2lnQjB1?=
 =?utf-8?B?RWsrU0hSazg1NkErV0xjbjBFODB1TTQ3azVvbmxnOE9YWjFwMmlDZTJTT3RP?=
 =?utf-8?B?SWV1Z1JlMWVTM0RYTGY5YTYweVJ1TnU5SjYyY1c0cGg5dlBraDBPQk9aZVlt?=
 =?utf-8?B?YUFKY3pkSGtvMy9IVEZrVzZENXV0cFFuWGNtTzV0UlhuTU9ZbVRhSVp3bktF?=
 =?utf-8?B?TmdvcWlGZnJZT3dpckVQRms1MTVueXN1d24xM2dsMW96Qm4zWEhaYWVEVGVF?=
 =?utf-8?B?ZDRBZ01DRFU4S1NIR2NoVEI4NVV4QVhkanpiSG92RjVhOUtFQWVIQnNuZkZC?=
 =?utf-8?B?bVlKNHNrKzJQcEhrN0krLzRHdjhvRGticVNEMzFYbzFOeitBeUJRZ1EvRThr?=
 =?utf-8?B?Ymt3OVU5QktNMHdDbXRSOGE4MTA4WWl5QzlLVWd2V243NG9DTUxmbDNPN2cy?=
 =?utf-8?B?WXlnTjVCMjdkOGlxYlpzbGJrVGp1STV5NDlsUGU0U2JpdDlhcmdMSW1kVkw5?=
 =?utf-8?B?dVdodzV4RFNodGtQTXhvTUsvZzlkb3cvRDNZSExBcHU4UmNNZEdnOHB3S0U4?=
 =?utf-8?B?WDZqbi9GQ3IzQ21rT1FaZE1NVzBXQURSS0VaZm1scnl5Z3NJRFF4OUVhdmUr?=
 =?utf-8?B?NEs2Mk1uL2dOQzgzT1JOMWdLU1dHcnBxVEFyS21ZWGpmZlF2b0M3RVF0dHJB?=
 =?utf-8?B?NnhqcHVmOVE0NHRJaVdVOFJISUMzL1htN25GeDdPczdUMlp4ODcrWko0QW02?=
 =?utf-8?B?Z0tXRWxpZEVSVWc3dkl0UWJ1bDFCVENKTUo3ekVJYU5TNW1BNTAzMWlVUFY1?=
 =?utf-8?B?d1ZVeXJGa1NSekZWblJpSkEyTjQ4dVRMWTlPNm15TkRxK09QQ0Q4N3lqZnJD?=
 =?utf-8?B?QVpsWWwrSDVXcFlBbXZialpDV2Q2N3VDd0hIKzVnblRxK2hLRDJTYU1wQWQv?=
 =?utf-8?B?Snl0ZEFJdXRCbkp3Kzc3K0l5SXZzdnR6SXlmUTlhQjVLYktvUTdaelF4VG43?=
 =?utf-8?B?Yy9HVFVBQUFqbW5ubFE3dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dks0S3MyeWo1Z0FTVk55RlNYb055VldLcGJOTlM1MjA1a0wyU1ZrRnpKWEFB?=
 =?utf-8?B?VHM5YjhOU09iK0RJOXRrZHU1WlVwRGtsd21nMk1UQTEwS09IRndTTmdnZGlJ?=
 =?utf-8?B?K1hWNklZTllkWTNxNXBOVStvTmJGbTlqdTR0SWtTRXphWUV1N0ZOUVJIczFR?=
 =?utf-8?B?cGRqZk81OEc3TW1BWXEyL1IwbVpSbEpIT1RvUSthcVVkWGNMTjhpdHJWNU1I?=
 =?utf-8?B?aHpLdkZUQmwrUmFlZk10dGhDTjcwUyt1c0xUTk1WTjlQc0xyNi9nNDlnT25o?=
 =?utf-8?B?NUUzQ2wzM3hOZno3MDNWQ0l0YnlqUmVQVmdNbm52R1A2QXZabVJVd1BRUHpP?=
 =?utf-8?B?RzVPN1AvQldUNDNvT0dsb0daS3Z4UXc1THl2Q3ZsSkVOb2ppUHZmcEZIcmlo?=
 =?utf-8?B?MUVQczlYdmVIL0FuNEtyVHNhZmZMaG5RZEUrOXpLMDcxVk1sK3dhZDJZRW1L?=
 =?utf-8?B?UGxLb3k2OGd5Z21EaUcxeW14S1puZk9YbnUxTmk3d3h6U2hlWU0rVm9pU0Ro?=
 =?utf-8?B?azVVandXNHRZR1VlYWJucG1JQmlyZzNFM0FIblNndm9yYzFMcXNBVlh2OGg1?=
 =?utf-8?B?UWFsNTJ4VDZPTkVhSDhVVDdjUmhiYUZIeVhUYnFuSEJiTWFhc2tlcXc5eEN2?=
 =?utf-8?B?dUkxL0tkYW9nOTRRNUxERXo5Zk1ZbWJTTFVCOXBCaVFxM2pvZGZXc2s2eGty?=
 =?utf-8?B?Snp2dldOcUJrVnBxNkwxVnBlaTNYMU1DczMzK0ZiUXVvRGhtWkRlYXg5NS93?=
 =?utf-8?B?NzlkeDY5Nmt1UWJLRlRyS1Z5VWFzM2lRYk5vQ0lhbm5jcy9ON2VFTExuUU9a?=
 =?utf-8?B?ZnQxL0x0TE5aOVhqQXJDbndoSElvcTlha3QxMk1hNXI2UDc2d1NPaUxadHg5?=
 =?utf-8?B?WllLNGFjR05uZ1VlT1V3cys3Z2xYc3plSUhYdmkrcE1PQU9BZVlva2MwWGdv?=
 =?utf-8?B?SWU5V1pKU0NEMndnbno0bHdXOUQ1N3FXcnhBRXQ5ZnY0dU9Bc0ZUZ25GbUlI?=
 =?utf-8?B?SWdaaGpNdEhmQUhXSGNlM2pFYVBVYWgzK3VwVVl6elUzaTdHbS95QzkzS2g5?=
 =?utf-8?B?czd0VmFtaXQ5Wk9hWHhvb0VndGFiclo2SkxyR1F2cmtmVmtsTXFNQk9kSDRt?=
 =?utf-8?B?cDNtNks1L3NBQ21SY1RCM2ZKT2RGQTkyY0FsSFZ2Nk9aYndLM1NJeGRvTXZK?=
 =?utf-8?B?TTdySXBsUCt0Qmt5WE0xSHVOajA0RlpYRlZBQldwMmFnZ0V2dnBMWExlWjJz?=
 =?utf-8?B?Z1Vnamc5UitIYzlVZDMyVUdldGl1Zm5SRnhmR0tTdkcwV2hHRVUxQVFQU2Zu?=
 =?utf-8?B?UUI4VHNXMW43MlN6c08wbWhoY2JPT1JwakRBbWVJMm9VaU96OGNSOVg2MS96?=
 =?utf-8?B?K2REN1lyZUxzSUVKM0x1N04wRmkwUTFJa3dkUi9JSWZvTlVrblVyaksrVVhk?=
 =?utf-8?B?WWYvWGQzaVBjZjlySzdIZlpwZk5jU2J3M2Q5OCtMZ0l4cWlSUWRWdUFBeTE0?=
 =?utf-8?B?c3FyZ2dVQmF0SFdoZ0dzT0U0d1piWU4zcm50Q0FvSXE3U0U1WXo1WVB1M0xt?=
 =?utf-8?B?Z0EydnpmVzB1S3drVnlNYUhnWFE2V2ZxSjJNRSs1Mk5GbmVqaWVPd1I0bllr?=
 =?utf-8?B?a1MzSmJVUFFselhwU25uZUZFZmloL2JXdDFCazFweU1rUG9UWkR4MmZkR2dO?=
 =?utf-8?B?T1JNRTdCQmFLZzh0b1FQU0FGRzJBeFY0SER3NWdNcWJoOFdvRHdOS08rVjBQ?=
 =?utf-8?B?NGplN3FQNUYzd3c2QlVpcURuUlI3WUVSMUZyelRiOVhpUkFSRjBFcGZNWGox?=
 =?utf-8?B?NFc0RDRtUmJjckNnSWhIMjA2eTlBZ0RxMXRjcElMdFo5R1VTMmpVRkxJNmFt?=
 =?utf-8?B?bE5oUXJKcXFoV2VEcU5BNVlybXhMNXZPMVc0YzhFMVYxVmZRRVBXYjZReUU5?=
 =?utf-8?B?TDUxdllpRDM3S0hTWVMvR2hiYWtCdVhwMXlqdlZ4QjRrWnlsN1ZtMFY4WFpq?=
 =?utf-8?B?d3JLRTd0MU9HYm8zeWRmcm5pOTZjV0sra01jQ241TmdUOVFacCs3anFjOEg0?=
 =?utf-8?B?M2x2TThmeGMwTW0vOStGalVjR2hzQzJ6QUErb3k2ZWJESVhQYWtabXhWbVJM?=
 =?utf-8?Q?5ftwaC6QX0BwpTSFdlN3tKabc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e34b2a-f29d-4749-8363-08dccd28e2e7
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 21:31:07.0916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlE8Sa9ZFDq2vAePjfW7EzKdqEagGIGYHH8UZioCualAjEMikWVI2Pa+Liy0jJnSZZoFT32YYNsissowon52bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6884

Hello Mike,

On 9/4/2024 2:54 PM, Michael Roth wrote:
> On Wed, Sep 04, 2024 at 12:37:17PM -0500, Kalra, Ashish wrote:
>> Hello Paolo,
>>
>> On 9/4/2024 5:29 AM, Paolo Bonzini wrote:
>>> On 9/4/24 00:58, Kalra, Ashish wrote:
>>>> The issue here is that panic path will ensure that all (other) CPUs
>>>> have been shutdown via NMI by checking that they have executed the
>>>> NMI shutdown callback.
>>>>
>>>> But the above synchronization is specifically required for SNP case,
>>>> as we don't want to execute the SNP_DECOMMISSION command (to destroy
>>>> SNP guest context) while one or more CPUs are still in the NMI VMEXIT
>>>> path and still in the process of saving the vCPU state (and still
>>>> modifying SNP guest context?) during this VMEXIT path. Therefore, we
>>>> ensure that all the CPUs have saved the vCPU state and entered NMI
>>>> context before issuing SNP_DECOMMISSION. The point is that this is a
>>>> specific SNP requirement (and that's why this specific handling in
>>>> sev_emergency_disable()) and i don't know how we will be able to
>>>> enforce it in the generic panic path ?
>>> I think a simple way to do this is to _first_ kick out other
>>> CPUs through NMI, and then the one that is executing
>>> emergency_reboot_disable_virtualization().  This also makes
>>> emergency_reboot_disable_virtualization() and
>>> native_machine_crash_shutdown() more similar, in that
>>> the latter already stops other CPUs before disabling
>>> virtualization on the one that orchestrates the shutdown.
>>>
>>> Something like (incomplete, it has to also add the bool argument
>>> to cpu_emergency_virt_callback and the actual callbacks):
>>>
>>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>>> index 340af8155658..3df25fbe969d 100644
>>> --- a/arch/x86/kernel/crash.c
>>> +++ b/arch/x86/kernel/crash.c
>>> @@ -111,7 +111,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>>>  
>>>      crash_smp_send_stop();
>>>  
>>> -    cpu_emergency_disable_virtualization();
>>> +    cpu_emergency_disable_virtualization(true);
>>>  
>>>      /*
>>>       * Disable Intel PT to stop its logging
>>> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
>>> index 0e0a4cf6b5eb..7a86ec786987 100644
>>> --- a/arch/x86/kernel/reboot.c
>>> +++ b/arch/x86/kernel/reboot.c
>>> @@ -558,7 +558,7 @@ EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
>>>   * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
>>>   * GIF=0, i.e. if the crash occurred between CLGI and STGI.
>>>   */
>>> -void cpu_emergency_disable_virtualization(void)
>>> +void cpu_emergency_disable_virtualization(bool last)
>>>  {
>>>      cpu_emergency_virt_cb *callback;
>>>  
>>> @@ -572,7 +572,7 @@ void cpu_emergency_disable_virtualization(void)
>>>      rcu_read_lock();
>>>      callback = rcu_dereference(cpu_emergency_virt_callback);
>>>      if (callback)
>>> -        callback();
>>> +        callback(last);
>>>      rcu_read_unlock();
>>>  }
>>>  
>>> @@ -591,11 +591,11 @@ static void emergency_reboot_disable_virtualization(void)
>>>       * other CPUs may have virtualization enabled.
>>>       */
>>>      if (rcu_access_pointer(cpu_emergency_virt_callback)) {
>>> -        /* Safely force _this_ CPU out of VMX/SVM operation. */
>>> -        cpu_emergency_disable_virtualization();
>>> -
>>>          /* Disable VMX/SVM and halt on other CPUs. */
>>>          nmi_shootdown_cpus_on_restart();
>>> +
>>> +        /* Safely force _this_ CPU out of VMX/SVM operation. */
>>> +        cpu_emergency_disable_virtualization(true);
>>>      }
>>>  }
>>>  #else
>>> @@ -877,7 +877,7 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
>>>       * Prepare the CPU for reboot _after_ invoking the callback so that the
>>>       * callback can safely use virtualization instructions, e.g. VMCLEAR.
>>>       */
>>> -    cpu_emergency_disable_virtualization();
>>> +    cpu_emergency_disable_virtualization(false);
>>>  
>>>      atomic_dec(&waiting_for_crash_ipi);
>>>  
>>> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
>>> index 18266cc3d98c..9a863348d1a7 100644
>>> --- a/arch/x86/kernel/smp.c
>>> +++ b/arch/x86/kernel/smp.c
>>> @@ -124,7 +124,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
>>>      if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
>>>          return NMI_HANDLED;
>>>  
>>> -    cpu_emergency_disable_virtualization();
>>> +    cpu_emergency_disable_virtualization(false);
>>>      stop_this_cpu(NULL);
>>>  
>>>      return NMI_HANDLED;
>>> @@ -136,7 +136,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
>>>  DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
>>>  {
>>>      apic_eoi();
>>> -    cpu_emergency_disable_virtualization();
>>> +    cpu_emergency_disable_virtualization(false);
>>>      stop_this_cpu(NULL);
>>>  }
>>>  
>>>
>>> And then a second patch adds sev_emergency_disable() and only
>>> executes it if last == true.
>>>
>> This implementation will not work as we need to do wbinvd on all other CPUs after SNP_DECOMMISSION has been issued.
>>
>> When the last CPU executes sev_emergency_disable() and issues SNP_DECOMMISSION, by that time all other CPUs have entered the NMI halt loop and then they won't be able to do a wbinvd and hence SNP_SHUTDOWN will eventually fail.
>>
>> One way this can work is if all other CPUs can still execute sev_emergency_disable() and in case of last == false, do a spin busy till the last cpu kicks them out of the spin loop and then they do a wbinvd after exiting the spin busy, but then cpu_emergency_disable_virtualization() is/has to be called before atomic_dec(&waiting_for_crash_ipi) in crash_nmi_callback(), so this spin busy in other CPUs will force the last CPU to wait forever (or till it times out waiting for all other CPUs to execute the NMI callback) which makes all of this looks quite fragile.
> Hi Ashish,
>
> Your patch (and Paolo's suggested rework) came up in the PUCK call this
> morning and I mentioned this point. I was asked to raise some of the
> points here so we can continue the discussion on-list:
>
> Have we confirmed that WBINVD actually has to happen after the
> SNP_DECOMISSION call? Or do we just need to ensure that the WBINVD was
> issued after the last VMEXIT, and that the guest will never VMENTER
> again after the WBINVD?
>
> Because if WBINVD can be done prior to SNP_DECOMISSION, then Paolo was
> suggesting we could just have:
>
>   kvm_cpu_svm_disable() {
>     ...
>     WBINVD
>   }
>
>   cpu_emergency_disable_virtualization() {
>     kvm_cpu_svm_disable()
>   }

Something similar is already happening in crash_nmi_callback() :

static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
{
        ...
        if (shootdown_callback)
                shootdown_callback(cpu, regs);

        cpu_emergency_disable_virtualization();

        ...

shootdown_callback() -> kdump_nmi_callback() -> kdump_sev_callback() - > WBINVD

and that does not help and still causes SNP_SHUTDOWN_EX to fail after SNP_DECOMMISSION with DFFLUSH_REQUIRED error and then subsequently issuing DF_FLUSH command after SNP_SHUTDOWN failing with WBINVD_REQUIRED error.

>
>   smp_stop_nmi_callback() {
>     if (raw_smp_processor_id() == atomic_read(&stopping_cpu)) {
>       return NMI_HANDLED;
>     }
>     cpu_emergency_disable_virtualization()
>     return NMI_HANDLED
>   }
>
>
> The panic'ing CPU can then:
>
>   1) WBINVD itself (e.g. via cpu_emergency_disable_virtualization())
>   2) issue SNP_DECOMMISSION for all ASIDs
>
> That would avoid much of the additional synchronization handling since it
> fits more cleanly into existing panic flow. But it's contingent on
> whether WBINVD can happen before SNP_DECOMMISION or not so need to
> confirm that.

No, WBINVD needs to happen after SNP_DECOMMISSION has been issued, followed by a DF_FLUSH for SNP_SHUTDOWN_EX to succeed.

from the SNP FW ABI specs for SNP_DECOMMISSION command:

The firmware marks the ASID of the guest as not runnable. Then the firmware records that each CPU core on each of the CCXs that the guest was activated on requires a WBINVD followed by a single DF_FLUSH command to ensure that all unencrypted data in the caches are invalidated before reusing the ASID.

and from the SNP FW ABI specs for SNP_DF_FLUSH command:

8.13     SNP_DF_FLUSH command:

8.13.2     Actions

For each core marked for cache invalidation, the firmware checks that the core has executed a WBINVD instruction. If not, the firmware returns WBINVD_REQUIRED. The commands that mark cores for cache invalidation include SNP_DECOMMISSION ...

I understand this Actions section as saying WBINVD and DF_FLUSH would have to be after the decommission.

> Sean and Paolo also raised some other points (feel free to add if I
> missed anything):
>
>   - Since there's a lot of high-level design aspects that need to be
>     accounted for, it would be good to have the patch have some sort of
>     pseudocode/graph/etc so it's easier to reason about different
>     approaches. It would also be good to include this in the commit
>     message (generally it's encouraged to describe "why" rather than "how",
>     but this is an exceptional case where both are useful to reader).
>
>   - Sean inquired about making the target kdump kernel more agnostic to
>     whether or not SNP_SHUTDOWN was done properly, since that might
>     allow for capturing state even for edge cases where we can't go
>     through the normal cleanup path. I mentioned we'd tried this to some
>     degree but hit issues with the IOMMU, and when working around that
>     there was another issue but I don't quite recall the specifics.
>     Can you post a quick recap of what the issues are with that approach
>     so we can determine whether or not this is still an option?

Yes, i believe without SNP_SHUTDOWN, early_enable_iommus() configure the IOMMUs into an IRQ remapping configuration causing the crash in io_apic.c::check_timer().

It looks like in this case, we enable IRQ remapping configuration *earlier* than when it needs to be enabled and which causes the panic as indicated:

EMERGENCY [    1.376701] Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC


Next, we tried with amd_iommu=off, with that we don't get the irq remapping panic during crashkernel boot, but boot still hangs before starting kdump tools.

So eventually we discovered that irqremapping is required for x2apic and with amd_iommu=off we don't enable irqremapping at all.

And without irqremapping enabled, NVMe is not being detected and RootFS not getting mounted (during crashkernel boot):

...

[   67.902284] nvme nvme0: I/O tag 8 (0008) QID 0 timeout, disable controller
[   67.915403] nvme nvme1: I/O tag 12 (000c) QID 0 timeout, disable controller
[   67.928880] nvme nvme0: Identify Controller failed (-4)
[   67.940465] nvme nvme1: Identify Controller failed (-4)
[   67.951758] nvme 0000:41:00.0: probe with driver nvme failed with error -5
[   67.964865] nvme 0000:01:00.0: probe with driver nvme failed with error -5

...

Gave up waiting for root file system device.

...

Thanks, Ashish


