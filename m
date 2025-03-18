Return-Path: <kvm+bounces-41381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 656D4A67582
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 14:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B59E11762A7
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 13:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5403220D50A;
	Tue, 18 Mar 2025 13:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yINwEpBG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEE576026;
	Tue, 18 Mar 2025 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742305667; cv=fail; b=DZ8dpBLEz05HeD1tN3ue4pY/3USkaE5Z0kBEKUjiingG+pv7kOIoxcUJ+3+f/x/igfvxvMjjOoBhtKNAEO2MQs4rA8BUtEXINzv73fZbeKrvnZ+qqkfcsz7CDB8kG9E6nh2gwH/Xx4d2v/wsfEfeG6hXTo3wJAimrbFq+7ZWqzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742305667; c=relaxed/simple;
	bh=o/IeuHFd1ijzOoMtX0TeWwRGNO4uUofaPuM4+Vcs+hE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qiPPH1Y2h2dDIM0r99S77wS7w09LOtJWAbq03JbRDEJSWs6sp+/56G9lZWAVVFesz/E2XgO33gq7Om3VjxJdb7/oKVbJ5kB5d2k+/GhnmPL3tlKvS2E4YJxi9iM9AVS2Z4AuplFeidmg5Z+8k48yHgp3y2d2nOEQFsSPCrbzHqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yINwEpBG; arc=fail smtp.client-ip=40.107.100.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPotuhTbpT5c/5OxyJ6KdsamiUR6rFf6k0cnr3+yLTYCgJIVOK5shtNMLO64ENH48+Oxq30FUc3QPO5BNOHpEfnREpr4oaha1sCsijHMnPIfhjCCS0D01yqo5WB12GZ+AxINNv1xivKb5/Zm4cU3z1iGBj9TL45TzNI5xpn4qkO+CZC183y5R2ymMXjShqjTL5eEGI+u+hkTv1K5SqtG2zNoeAagiERhhsCwPHk1vGHA/qsCbYD9ia5UxLbknS9r4yT9h+hDCwnQgYkWjnZHHad1OuI7V2RUrbsNZX77EAzdMDMoxxlmeNsipGPHzAq7Bfn9rN7feT6G3jts7fso9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eITy3g9sjT80vJbyrnIqT5sjD5emTOUdh5CN+FIbw0=;
 b=QIImvjqO08ur85gvsvtB+T75eoBioZq+aVpMe5+LQgDgmo3EmMe5kotHVAuWBI8IhlILnVxh7dRDsRzSj77z1PUZ3WdUiz/SOzSfqcW1Lvj3iF7O4e6Y+6UX+XjhN2ZcpXuXLjgeNfXuc7RbZgJIpy60sz+dv5vEmkp94bdUcLqQ9bqjoO40qnIaGBAlR5uGGujCXCptU+8Wy0LBtodza31eQ8bEFyeeCnLHhgap3L4kHf9vdf/ctXmaLVMX8x0aPHNzvFJSnmxHyLjwUmFY1wMTMYqSrRHrbAZSfWJlnNtvx0s9dz0lqQLRLDAHCEF1O7eCasUcCfeE3Gy2Ylu79Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eITy3g9sjT80vJbyrnIqT5sjD5emTOUdh5CN+FIbw0=;
 b=yINwEpBGyrLlS1bn7OwTEp69E95e3kbW1fadKPr3QUao5EptoS3Ogpb1RN2XUDH7si6Z6jOt1OtWcL3lj41ncxFCpjkEy1OwJLf5YEVlqMv2rlQSFh8NepXJo8wFLinTpONm9dOzEgJMJu6n1PhYnRfVDIV++W72jaofpwlSXkE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB6644.namprd12.prod.outlook.com (2603:10b6:208:3b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 13:47:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 13:47:39 +0000
Message-ID: <29b0a4fc-530f-29bf-84d4-7912aba7fecb@amd.com>
Date: Tue, 18 Mar 2025 08:47:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
 <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
 <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
In-Reply-To: <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: 265a7987-a147-4267-f355-08dd66237277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bG9YOWp2dFZ5dWtlT2kyKzd5Y3N1aE9qT216cWVabjF0VkxZZjVhb1JpN2tN?=
 =?utf-8?B?Z28xT0Z6dlNFaS82Wklmc29TdFg0QVdNUFUyT21HSmt0c0NUblF6TjFpSnNT?=
 =?utf-8?B?UDVPNldZMTFWZ1JvenhnaXpJZTZkL05hMmJERFJZZlFSOVpXN0pZMmQvNWpu?=
 =?utf-8?B?S1drRXA1ZFEwczloUE04UTYzREZGamFLNldNUUxtSFlHMEViejdBNWlsWW81?=
 =?utf-8?B?eGc2T0RJS0tyeW05TTJqQ2UvZ29DdHZyeUdTV21kMEx0Y0g2YXpvaXVkckEw?=
 =?utf-8?B?VCtIeEF2cHo5RTdMc1B3Z3BPelhFakt5c0ovZVltaEhjUmZzN20vNnlnQk9Z?=
 =?utf-8?B?RURXcHVQTnFaL1ArRWZ1aXRkbEZ5WDBvSDd2QlhPRE9MRGhKQU55cFVlR0tP?=
 =?utf-8?B?d2dublNaREVVMG5CeEM5YitPWVh6WDJTYjVndnErdGVNdlg2bjc2L0hBYzFl?=
 =?utf-8?B?bHJ2VmRRL1BYZ2pma2FoSTlNTjQ2aXZZWEtYOFIvaXRRVlhESThLWm9KTnlP?=
 =?utf-8?B?T2o5dlRMbGQ1TEFCYmdEQzJUdDR5dWFZNis2cERxQjhCbmpXUXMyMkVQQVdh?=
 =?utf-8?B?b0xRMnZSby91M2w0OHpTM3gwMWw1QjM4V0lXaU1aK0NIWTdqRitsZXlrdVha?=
 =?utf-8?B?R3RXS1VldDk4b04rWnZhQ3pBV1RIM3hnaW00eGVUTGJXY2s5VjlqUVA5MDV0?=
 =?utf-8?B?TXNJZVpYTWhsaDk2WTJCRDE1NkJtYWJiT2UzUFhza2NQVzI0SW1pOGlUZVZh?=
 =?utf-8?B?ZVQ1TEtjM2R6SzRnNDNMZVZobGJHYWw0U3c0a2luNUdvYmZLQ1pjL2pHQ3o3?=
 =?utf-8?B?Y2xrVzE3eEpsVDhhQmsyVGZ2enpOV2MzRzFvbEw2Z1F6R0xDVytXMlZRRHBT?=
 =?utf-8?B?aDhZa0VoYzdQckdwUXZKNWd4MFFHSkdZUXR3bkk4TDhQWFB5dXlseC93anBp?=
 =?utf-8?B?Tk8xeWFYNnptS2tSVFNENkJVT1kyUnpUSlNkSmMwMTIwaGxGcFcrZVduUnpz?=
 =?utf-8?B?bFd5eHhHMlc3c2Z3QzM3Qnp4V1M4b2J6OGJJNm5TM1ppTGpKODMrcUVFcXEy?=
 =?utf-8?B?WSs2SFk4ZzVRbDVmNmNhYm5OUnFxQ2RoeEl3L1I2TnVac2JNaEh6MGdsRDlk?=
 =?utf-8?B?STBBWjI5SzR5ZG5URmhoODkvREN0cHZRTndhQ0dRV1NjekNtNG03RlBTY2tM?=
 =?utf-8?B?ZnEvUXMzVDJadFBuODRoOXF0dStWNkJrMDVIVVRHbDNOMVFqOE1IN3dwLzJy?=
 =?utf-8?B?TXVnRi85alFhcjhEQ1J2QmRpL2xJSlcycGFMZzdUNER1YUJGQTdoYlBiSU9l?=
 =?utf-8?B?c1JEOTRqSXBpWkhiWllJYUFCYWtWb0xlcGxZM1RIcjZCRFAyVzJGNGhmNEpy?=
 =?utf-8?B?a3Q4NitVQm5lTFJGVGVBYllna25xaHpvQ3FwUStsd0h2TGRKTkhJdEZWVkU3?=
 =?utf-8?B?d05wSXJHUUptOVZnRVEwTHBJeVYrZnd0SENtMUtWSUFCNHRFYm1CY2lmaG51?=
 =?utf-8?B?RzhZdElQZllRb2syNy94TW5wWkU5dWNZRVk2clQ2alhDNGhYcUl2Vm1TK0pE?=
 =?utf-8?B?QVZhY2pIQUlkbzBZa0tiSzdJYWpLZ1dWZk1neVpHZGtTTGJKb1RpU3hwbTNl?=
 =?utf-8?B?anNwc1hIU0tWdlc5SUU0cVpCb2hKVGNzbFUzN1lYU2hYZ1ZDb200Q2dCUGV5?=
 =?utf-8?B?RlRrNkJWRUIxa013QkpQQXRCSkMzVzJWbnZDWjFZbVlvYXJ6N2h1Uld4L2NK?=
 =?utf-8?B?V1h2QjBQNWZsQ015NVJlbGZkTDQ5d2xrNUpZQ05zTXEvTVVHak1qd09tQnZE?=
 =?utf-8?B?TTRpTzArV3UvbTRaM2pLS0hPT1RESEVSa1gvQmhiUWNBMHpjNGlFNnJqMU1n?=
 =?utf-8?Q?dO8iUzsipNZSy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEVzWjFURk80V0JhaFVBdzBpRW9MZDExdDhEL2QyeWVoY3NSaHNMaHBGYk1P?=
 =?utf-8?B?ZlZkRnBiR3BiRHdFc3hhbE5qbjN3TWJVSUhqc29KckxsaTYxTnR5aHZOdDBI?=
 =?utf-8?B?Q1BmdVJRb3RaTkVCSlNpRWwvNCtCZlJpeXFvNGZIYXJNR2RjYVNrWFlEK3RN?=
 =?utf-8?B?dk9tNFFqaXFNc1FyMlBhdnlMUVVkVlNiR3YyZHkrTkx2U2huNEZ6UXBoVFVW?=
 =?utf-8?B?WkxXVUljaTF1TkhWN0JiaFBVS3dtUHdGM2llUTg2NGp0S2FiTjNKUXYxVE1H?=
 =?utf-8?B?R0FxSkp6OGlmTmVOU3k3UG5ZK2NTQThaQWtBTE9GM2J3MGZaaTRyOGNDRDlX?=
 =?utf-8?B?MytqQ1I3UEtBQUJIZUtzZ1dCQmpNOHVEcFRUQUhKOUcwYU1aRTViaXJUeHJl?=
 =?utf-8?B?UEIyOStKMVdXRmdjK1JaK3UvOGwxRld2UzMyU3hEdzRXRnR2Wm5wZ2ZLM2tm?=
 =?utf-8?B?ajZYWTZFT0ljVmZkTUw5UEVSV3NMamZmdXZwaWd1ZHczTWZFM1FuYTNKdWJl?=
 =?utf-8?B?RkthbnpEdm9iRHdZNzc3VnNGc1pneGhndFBsdFZETzM5TFdOV3FoS3owamcy?=
 =?utf-8?B?QTFTWE1tcE5YQnVNUlRLUlJRT1dpZ3RtVTBGcEpoSjRXQlJTdCsvV2plaDNu?=
 =?utf-8?B?WldFdUVBc2Y3SkxZbm5iYXBMSUE1Tjk3R0xjUTdOTmJmYnZ5aVBPbHgwMGNE?=
 =?utf-8?B?bnBVeW5oS0NDaEpySDdHcGVrZWp4K0xxOGlwL0xJQnM5QTlqaEJ3V3Q4cVpS?=
 =?utf-8?B?QTdnS1VTVVRwR0lzQXA3aGlKekJ0WFVmY0tkUThXWTlTMGFzck5aNkpsdFV6?=
 =?utf-8?B?ZytqSHN3NVc2bW5zTTFJSzZ0d2g0aTZkRG1oNFJtWDcwSFo1ZVluODlrSXRD?=
 =?utf-8?B?MHFwSjVpT1VpUW9xM3ZpL2tCdSsxUk9HTERuaXozcDN3WSsrZUp5VUloN0VO?=
 =?utf-8?B?NU83L2V6QXZvY2hQSjNBRGtOTUtocXVudDRqQWdKWjh1ZzR3RzY4MTFvNC9u?=
 =?utf-8?B?NXpGSUxhWnhIQUhOb3hWM2tRZVhXRVBaM2M1NXovNDJhUjE0bXh0bDFJNURk?=
 =?utf-8?B?bFcyQjNkN0hINmJPOUlvMFZWalpTcXZKSnFicDVkby9JcGhSNlJVZURlWDQx?=
 =?utf-8?B?QTI2a3ppWlZKQ3dSMngrK3BJM1dnUEtiazNmNDVrbWJwenFra3RjWjJCSGFx?=
 =?utf-8?B?SDl6a0VqbXF3ZnZ2TWRJbXhFRGdubVNBRjVQR2lmZ29PcVNSeGwxS2pCQ2VT?=
 =?utf-8?B?TzVKYk9seCtCWWpWV3NkaHA2N3BSM3pUZE1GcDNtQzhzRnByTWk3Yk8vSEs2?=
 =?utf-8?B?NHdxeWx2anc4b0c5V0h0Y0NnUmI1RCs1TEhLU2Fmblc3ZDJ6Rnp2S1dwS3NL?=
 =?utf-8?B?MjkrMkVrSzZOUVQzN0JoTDZ6Y3Z0WWNSR0RuVXN4VjZaeHJCVVo5Q3pFc2I2?=
 =?utf-8?B?N2J4OHpWdzRVbDdoWlZNTS9xejczMGQyZlhJNkN4aU82UWZSWkk5SUcyaVFK?=
 =?utf-8?B?NVZHSnBZOTFjU2E4R2N2T1ZTZ2lyUlJsc05NNmpVUWYzckxoODM0cFBlNDhD?=
 =?utf-8?B?a2l3QUlmdlltZytldTlvRlcvN1VVSmtBamwwRWk2UHBVS2U4K2g4TGFpQjQ3?=
 =?utf-8?B?NU1aWkVndTFqVXdtcXZ6NXBldUNFdmcyMFQ1YmZDZmpHWWxYOTdBSFhzT1hU?=
 =?utf-8?B?bXp3ZkEvK1gvN3daRkIwS1YwQUt5L2ljN0FFdmRBWWxPdkJGTWgwSzN0dnF3?=
 =?utf-8?B?ZWtNZXAzeUh4S2k3UG92R0tOSERUVEZ6Mk01eEp3NmRjTnBxRGdFcWNTMUhZ?=
 =?utf-8?B?bHJ0a1g3dlVRYmdZa2pDRzlLSFJZNC9CNXNkNDF2UUU0aUNCd0dPWWZZczNP?=
 =?utf-8?B?R0ltbk9QNnJjcE13cXE4S05KNE8rdGhzRUFha1FPVm4wQ1NzNUt6Z3VrbjYr?=
 =?utf-8?B?MW0rYWZBMk0zUU9oZm1oVW9QbVZmbDArODNhZ2IrNXZOMmNSMDRITU9ONS9V?=
 =?utf-8?B?TmlHOWh4U0NTN1BkamJUcHhmalBHWDhNaXhOOGZwNDAvNmhNTkU1Y1hycm50?=
 =?utf-8?B?K29SNmdhZUwwMzYvbS9sUU5PdUtIYnVsWHEvYUZEZ0pNZERNTmZ5TGVZQTNK?=
 =?utf-8?Q?pzH8R168p6sAt6uE5HTteHelw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 265a7987-a147-4267-f355-08dd66237277
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 13:47:38.8591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjDpt2Ivo/kbLZ2plSQPRs9JU0J081vaCR5hf8b4Wq0FfaUcMWQw9rGcbm5MwJbO0LKlL9AFukWURmOQ00qqRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644

On 3/18/25 07:43, Tom Lendacky wrote:
> On 3/17/25 12:36, Tom Lendacky wrote:
>> On 3/17/25 12:28, Sean Christopherson wrote:
>>> On Mon, Mar 17, 2025, Tom Lendacky wrote:
>>>> On 3/17/25 12:20, Tom Lendacky wrote:
>>>>> An AP destroy request for a target vCPU is typically followed by an
>>>>> RMPADJUST to remove the VMSA attribute from the page currently being
>>>>> used as the VMSA for the target vCPU. This can result in a vCPU that
>>>>> is about to VMRUN to exit with #VMEXIT_INVALID.
>>>>>
>>>>> This usually does not happen as APs are typically sitting in HLT when
>>>>> being destroyed and therefore the vCPU thread is not running at the time.
>>>>> However, if HLT is allowed inside the VM, then the vCPU could be about to
>>>>> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
>>>>> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
>>>>> guest to crash. An RMPADJUST against an in-use (already running) VMSA
>>>>> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
>>>>> attribute cannot be changed until the VMRUN for target vCPU exits. The
>>>>> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
>>>>> HLT inside the guest.
>>>>>
>>>>> Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
>>>>> request before returning to the initiating vCPU.
>>>>>
>>>>> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
>>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>>
>>>> Sean,
>>>>
>>>> If you're ok with this approach for the fix, this patch may need to be
>>>> adjusted given your series around AP creation fixes, unless you want to
>>>> put this as an early patch in your series. Let me know what you'd like
>>>> to do.
>>>
>>> This is unsafe as it requires userspace to do KVM_RUN _and_ for the vCPU to get
>>> far enough along to consume the request.
>>>
>>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
>>> to be annotated with KVM_REQUEST_WAIT.
>>
>> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
>> This is much simpler. Let me test it out and resend if everything goes ok.
> 
> So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
> me try to track down what is happening with this approach...

Looks like I need to use kvm_make_vcpus_request_mask() instead of just a
plain kvm_make_request() followed by a kvm_vcpu_kick().

Let me try that and see how this works.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> Thanks,
>> Tom
>>
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 04e6c5604bc3..67abfe97c600 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -124,7 +124,8 @@
>>>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>>  #define KVM_REQ_HV_TLB_FLUSH \
>>>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>> -#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
>>> +#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
>>> +       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
>>>  
>>>  #define CR0_RESERVED_BITS                                               \
>>>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
>>>
>>>

