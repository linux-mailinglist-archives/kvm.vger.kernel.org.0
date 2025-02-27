Return-Path: <kvm+bounces-39601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF311A48458
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B3363B87F1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E11F1B21AC;
	Thu, 27 Feb 2025 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AKz/fGqw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E81B0430;
	Thu, 27 Feb 2025 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740672207; cv=fail; b=iwEzhdU0O/qin1TbIocDH9OJLdYhpSpfzddrqPs9HzFa1BpigAI25liwmcEySAcsLDq+xmZswRH48Iq7MvrvxRTRKWGLR2fUD9PCLGHIgRBSWcxv3JEcB7pZmHU7J2rq5DZmOTlrYnMa0cxBLkVHPtu7LOkMO91vQOSoHQ1o0Go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740672207; c=relaxed/simple;
	bh=qbbndpxXfkJ4141yG4/GWQuiik3d+sMCoRefGeNWd2I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qr3Ab6SA1xWYfdgxqIeSJwV7qUfnwuLEE0wE/GNlbwsR37DuBttQrtp4bVWqVH2/lfLvjmn5uJVB3ixew36utD+taGTd/m01/6/yoFVK+U78ntls8+O+o4g7zOVmwKqfNu1YMWLWQkceBhR0fPSlR5w+mp5LCe8H9MrXe5WgnUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AKz/fGqw; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFVt9jcirP8CngjqV8vRoez/1fwuSggqyGz06+kfAN/5rwKrDyQeA8FLpXNWXjzvby7WT14MgUcVhy8pY6wSzqkv+ZI1Vw2LiSPGhlvuq1crFEne67/bCAA9lUejkj5Ob6ysrHZI9MYEvHzdR7WAwqhKG9fKa+PGhcu+/CKL7W+84FP4Wa56B34qtDfUNGRyBVJjIsiPAo2/Ef359GsQUW+QWfwjdziWA3ZhipkesuYSs8vRNOAnK0FmjhKejZ1HE7Jwf3nP+eDeoxcadi/pTILaGivM4OvQsjSMisyGhFAadgqXi0bnowKpb7GxGXLcpLA1HuBAyWDmmJqt8dHKFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOkteXLK2hhlx7Kv9qEEKuvHsIlJtTGFOPU1GFa2TSQ=;
 b=Kf/BaEC8Msh5Te2pAeP9P60WbqhubuUszkyGLW8rgbh7+qF+Zwy9IhxzmZIrE/+i8O1BRNRkrb8KROwHncpfyus9eY0L2J8ySa407m4Us4c3WzuFEiUPnj9bEiBEkPAhLERTICEIVJbM+VJqVIhZ7p/EsPmO7eSspKJGGWN4noCDMahwB/3f4ZYmjnmZqCdnOCQyNx6kLB68U/AUOB2i7GJ010bBLXLdcgKyrBPnaEdpMrKo00rzlxZ6uGiIIxUCCmuvykXe6oJKRTeJoSPAC577pSN8yugqJ5yK98vfgrOE2pqCkMIcjRCZQqzbpxZ3xpUk1Cm3i9qDqEImPLs4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOkteXLK2hhlx7Kv9qEEKuvHsIlJtTGFOPU1GFa2TSQ=;
 b=AKz/fGqwLvOR7qSig2DcplRb0QSALrB1LFe1Fzg0pEnaVrFwiS3uFxvVeR8Lz+2f6wdkEb2HUn8p69RDwKRbkhf9PhVADEQ6z6eitot/Zk62UZlcc0ndmUXJWUk13Ji6wC5g4oj9bcWYZqvHT2ZGGAqLaurZUQVIKIjnvZb49ds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6834.namprd12.prod.outlook.com (2603:10b6:510:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 16:03:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 16:03:20 +0000
Message-ID: <616e0b28-7ca1-a0d6-3e5f-ab4073fd9e7c@amd.com>
Date: Thu, 27 Feb 2025 10:03:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 03/10] KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+
 guest has an invalid VMSA
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20250227012541.3234589-1-seanjc@google.com>
 <20250227012541.3234589-4-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250227012541.3234589-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:806:121::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: e3a04109-da7b-4d5b-20bc-08dd57484100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVl4bzQ0bWpTMzdORHJQS0hTU2V0cGZUSm94YW9JWURlRFgxMmI1M3YrUXZV?=
 =?utf-8?B?VkM3YUtDY3hkNXl5RDV5OXFnVzZqbWZkdXFMaDBYSC9SQ1dibHJUWEROOW9x?=
 =?utf-8?B?aDZXaE9HK3lBYWVtTTJTSTRSeWtYTlRlcU5iK2lJNEp5dWtVTXJaWTR6ZEdt?=
 =?utf-8?B?UjZ6QW9UdnFWZUNYRWRSKzJ2TUFzYkRZeEFIc2VnOGNuUFNCMjdlQkZ5RVVN?=
 =?utf-8?B?OXhsVTUxV0JuREd5VFJkTnVSMWwxUGZpT1BZRndicHpSZE41WDVhd2Ewbm52?=
 =?utf-8?B?c2ZyaTZyalFqckxob1YyMGRSMzYvbkI1M09FUWFJU2JlN1NYVW1Bb2RnaUVM?=
 =?utf-8?B?ZVlSdXV6OVYreDBjaWZ4Umx2MzVsdndUL2J1WDRHUm9hT3NLQUpuOWNyYTBB?=
 =?utf-8?B?REhSWjd5RVVUQ3UzZEoxYURrQThJYkRHMnRBcHQ5b0xhbkc3Mnhxa0w5Y0pV?=
 =?utf-8?B?RlBFUmx3b1lGT3pNZ3lMZEpWazB3YWlhdmdtayttVUFVTDE5VHVIVWc4MUpI?=
 =?utf-8?B?dk1zSi95emVtQ3A1Yk95VGR1R2NxUEMwSTM1SUR2TzZQdG9GbU13cC93S2hz?=
 =?utf-8?B?Uys3eUsxRU5sbXhvUUpCMTFYS3NJcmJJRzBjZVNWZlRZTXJjV2lmbmhvNXor?=
 =?utf-8?B?dy9VQ21rbWNvaXBzZXZvd3pnTFJaOTJTYjQzc0FJMlZ2MEFMb1ZlOVdCSUhL?=
 =?utf-8?B?UENTc2FscFN5MDRZeVc4Vy9iRDFGVTBnQ0IrN1RLVDl4Q1VWMFZwTjdmVDZE?=
 =?utf-8?B?end6UDJwSW1zbWJLaXdaQUlURE1oV0djTDJjMnJaWUdOMTFVakRrZVV4bENh?=
 =?utf-8?B?VU4xMjQwUk9HNlRlVm5QWGVZRjBzbE1OTjRkQnBkRjVibjYzc0RGUVBZZkZJ?=
 =?utf-8?B?SDFuWUJvOWNyaVNEV2ZYQy9lUWlsbVRhWXhlK09jNloxMnU3ZkNDbTlnM2VJ?=
 =?utf-8?B?aDR5QUg4SVJHNmZyV3NHR0hCd3FDL1RLUXg1bWxseUJTN3N0RlgzRFdqM3px?=
 =?utf-8?B?Sy9mTmZEODBRSWtpUGNZa0gzTHpRZ1ZxYTNROHhSK1hWdjRTaTJ1a2xLQ3VG?=
 =?utf-8?B?elNNODFEQ3phSENvSWhwNUlSL2s2ejBaVTlpU0ZIRnFOdUdWb05mV3FKZFRI?=
 =?utf-8?B?VGF6U3VmU0JRaEcvRnRBWEhkK2NYQThZdDR6OGcrcXRPclhFdGVEYUtiRVl5?=
 =?utf-8?B?KzZkZkswS3BrNHhZTnRMdzN0NGUwdWVpZjExNWtFbkdSeDJSVXVNMUI2V0Zt?=
 =?utf-8?B?V2xaSTNCTTNsOXhCNHhETStQSmFJdmFRZXZqZ0E4bW1ELzQ5NzJKVzg5TlV6?=
 =?utf-8?B?SWtHTjd3ZXlZZ0tqa1hPa0Z3Rk5vUmh4S0k4ajR2c3JSSkU1S3B3Ukh6N21o?=
 =?utf-8?B?NU1lazJrV0pCODZiT1BtMEZPUDUrRjIrUHJ4WGx3K1NwZHVuRGQ1bEtOd0pk?=
 =?utf-8?B?WGpUM1dKMDJiL3JGL29jZ2g0M0VBYmlUVGwxRE9kSlJMMU9nK2l2a2dCUnEz?=
 =?utf-8?B?bklIdVdybkU4ajZuQWs1YnJPVDZrUnBjK1grMEhrSVJwTmluZm11NXppQ0Iw?=
 =?utf-8?B?VjNSWFJ4ZXVYMUlQL1dkUWVKWXQ2TEp4WjJnRXVnM0srZWhwWHRaLzBRR0pB?=
 =?utf-8?B?ekpZcVQxWG9pUm9tdVlzVmliMFRlbWNyTDBXckxuMjFpMzFCbyt1Q2ZsYVpH?=
 =?utf-8?B?MHpmbWZNVk1qc2FyRDlhSVJTakk5K1RPN2hCc25QaWx6RlNlaWNQM0NuY3Bk?=
 =?utf-8?B?L1pOTnh4VWVLb3lmMVlPeVoyanZKQmxJODRkdy9DTVVSTDNab3kzUUFPbXFy?=
 =?utf-8?B?ZzBmRW5OWVFPdFl1enF6RUhWWDZqQTZsalJJYy9BaXZBVHphbCswelZ2Z1Vq?=
 =?utf-8?Q?HSkK6qcOD2WLT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlUrUkdqZVgvZEdXYXlVMlcvR0IrY2ZIWGg3Q2puaWorWU1oMWtPK3ROUzVP?=
 =?utf-8?B?Q1NOMG1UOFRNT2lQVXN6bDFlNXZJa0ZINGxXVW9ZaFM3WWxGcFUxdXZFQ1Fy?=
 =?utf-8?B?RThBOWc0MFlvWGIwSlNrMDllWHFwTWJLazJGaFlhZXFjbGdka1U0SXQ4TThz?=
 =?utf-8?B?bXpSNjlydDhqZlhBVGVnM2o1WEVhdHlndjdIdXNMWmJsaVpvZ0lQOUI4anNS?=
 =?utf-8?B?Yy9FenJIZ3djRUx3eWNxVnBodFhSbGJjcm9zK2FNL3FpOW9ibUV4clU5M01G?=
 =?utf-8?B?anVDRnM4R1hEek4xL0FEYXJYYTNlV0VBRk05WTNSL01nWDRvcTBYS0tvMHhN?=
 =?utf-8?B?ejRWcmVrRHV6T1dnSCtQazJIaEYzOGVlZjRIT0ZRWFYzbEEySWlvbE5JVm1l?=
 =?utf-8?B?a0ZhTk9ZbG1XRERDenlEblBwSHJTTUlWMTN1MGY5T3pUTjdJMVA3MTdoUmJS?=
 =?utf-8?B?d0NMazlXcjI2YWdSRVRLSkhMRWZkb2M2YkFUTWQxcjhhclpxaUEva2tXVEdj?=
 =?utf-8?B?TUxzR2xBNUlveTlFTmdYWnk3SWF0Qk1FTEdxeHJUOUg2cGJBS3U5SjVQR2gy?=
 =?utf-8?B?ZUlzM3ZOMGVaWllGSVAvNmlTL3ZLbmhzS3V1ZnVrMnlUMWJTdkFueUlvNlkv?=
 =?utf-8?B?YS9vTGtIbjhzOGw3NlBJaWN3L0dPZ1VFaE9ZdkkvSG1ESU5zdEZvTEp0QTRR?=
 =?utf-8?B?OFB5cG5Bd2R1M2dOSlJxenVZNnVWUGF3elBhQTM1RHlCaXNwNFBndVAxalBj?=
 =?utf-8?B?MnVKUm9EVTh3MTI3R3lleWpGc1daN3lvSGsvZVd0WExSaGdTYWpPdmhIZW9T?=
 =?utf-8?B?Z2lQSGNQdXdodGVBWmZSUmpVbTNtWUE3OTRmOWN6eDFYd2o4Z1FlNExNWkZs?=
 =?utf-8?B?SlNNMDVhL0EzbThZWEUwc1lrT1Z5dHE4bjFaUk4zamxjaEpOejB6ZTRscDJ1?=
 =?utf-8?B?TmViODlSUXlxaUlHaG4rSTlTY0ZqUFVINk5ic3hXcDM3Uy9JcktrdEFET014?=
 =?utf-8?B?RFk5Wm12djVHTDV4aGtWbm9tZndTenkxc05JR1EyUm91dzF0T3ozbndOSmxw?=
 =?utf-8?B?L1MyRXBsWDFqWUxxZktYWFRSRkNHZmhwMHUxUCtkdVkxUFVNd2JFR0JUOVlV?=
 =?utf-8?B?bkIrUzUxTTRpWXJpSWVreG5NRDlVWUNmZHNJSlR1VUFicDZ3dkVqM2ZIZ05t?=
 =?utf-8?B?K09naXJoQnZ5UjQ4WE5ZTzkwOHc5eFFNQXIvTkdYSUdRUWttM3lIVlR2WGdJ?=
 =?utf-8?B?N2Fqak1qRzRRSVdveUJCZk8xaWlISzBLTDg1NkxhdmFPd1NtTmVtVnBjTXAy?=
 =?utf-8?B?cGpveDdMaDYzaThwSWZiS1UxWldVTEpCZ1dkWTI1SkhIU2ordFhZZ3BkSjZF?=
 =?utf-8?B?QjR6ZkFVOXVwR1VsTHdaMkZYNVJMR3lmclBjM1pUc2FsQ29uODZkMVFDaXNr?=
 =?utf-8?B?bXJ3SU05UzU2NGN4RXhtckdydnNMUWpZUkhCdXFWZm5mb2M4ZVp4V0FLTkpJ?=
 =?utf-8?B?aGZpSEwvNXg5Sm1xRFFST056SFp0dHNhQmFKUkplODY5a2U3T0dLdzUvYWZQ?=
 =?utf-8?B?U0tUT3djZmQ2Ym0zTG53WHVqNXp5SGdhMTU0L3E4bFFSYjU3TTNnLzgvNEts?=
 =?utf-8?B?MWhiQmxVRzl3alhWaWF2SkF4Z3JZRlZaY2RSbW44K1Y5ZTh5Z2poQTZHRnlt?=
 =?utf-8?B?aWwra3Qvc3EyVWtrT3FuTHhTaU5yc0ZFMklSNTBvTFdUSXJJK0JFSXpySnBW?=
 =?utf-8?B?Q1NTOGdtR3lrbENlZ0QzczRXVWw2OUJNNy90VVRsbVVod1pkVGZtZElyVWRx?=
 =?utf-8?B?YzNKYTY0Y2NObHNTVCs5eGcwRVNhT1RLKzhYWmxJbVV5VnBSV0krak1HYzVN?=
 =?utf-8?B?QkVEZkdBVVVNOXI4U3prZU1yaXF3UXZxUUNabnlja1NvTERhbGNZTzc5YzBS?=
 =?utf-8?B?MFdpaEF4Q2R2dWFEeUsrYVBIbFMrajRsSzc0TWtCOFlCam00eXBTazlxUkhZ?=
 =?utf-8?B?WCs4YkxlRHIvYklDcURUN2J6NXBZZWRwWDlGTnl4S3l0TE5naklRVnd1WUEv?=
 =?utf-8?B?akxxZ2xwZHZodEtpWmhqSlhVZHE0MmdCQUM4Ui9yUXNIZHp3R2N6bWE4RnhO?=
 =?utf-8?Q?R5oPblGh7PhbF6j3aGFv2JnpC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a04109-da7b-4d5b-20bc-08dd57484100
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 16:03:19.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvGy0+y8StxiQB7p46uybLvxiByLcG32m6QOSmBXnldctbL1rt/K5QV7YaBR9fWyaqxnzrxXZW3DXzZy0OFI7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6834

On 2/26/25 19:25, Sean Christopherson wrote:
> Explicitly reject KVM_RUN with KVM_EXIT_FAIL_ENTRY if userspace "coerces"
> KVM into running an SEV-ES+ guest with an invalid VMSA, e.g. by modifying
> a vCPU's mp_state to be RUNNABLE after an SNP vCPU has undergone a Destroy
> event.  On Destroy or failed Create, KVM marks the vCPU HALTED so that
> *KVM* doesn't run the vCPU, but nothing prevents a misbehaving VMM from
> manually making the vCPU RUNNABLE via KVM_SET_MP_STATE.
> 
> Attempting VMRUN with an invalid VMSA should be harmless, but knowingly
> executing VMRUN with bad control state is at best dodgy.
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 16 +++++++++++++---
>  arch/x86/kvm/svm/svm.c | 11 +++++++++--
>  arch/x86/kvm/svm/svm.h |  2 +-
>  3 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 719cd48330f1..218738a360ba 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3452,10 +3452,19 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  	svm->sev_es.ghcb = NULL;
>  }
>  
> -void pre_sev_run(struct vcpu_svm *svm, int cpu)
> +int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  {
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> +	struct kvm *kvm = svm->vcpu.kvm;
> +	unsigned int asid = sev_get_asid(kvm);
> +
> +	/*
> +	 * Reject KVM_RUN if userspace attempts to run the vCPU with an invalid
> +	 * VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after an SNP
> +	 * AP Destroy event.
> +	 */
> +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
> +		return -EINVAL;
>  
>  	/* Assign the asid allocated with this SEV guest */
>  	svm->asid = asid;
> @@ -3468,11 +3477,12 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	 */
>  	if (sd->sev_vmcbs[asid] == svm->vmcb &&
>  	    svm->vcpu.arch.last_vmentry_cpu == cpu)
> -		return;
> +		return 0;
>  
>  	sd->sev_vmcbs[asid] = svm->vmcb;
>  	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> +	return 0;
>  }
>  
>  #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8aa0f36850f..f72bcf2e590e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3587,7 +3587,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	return svm_invoke_exit_handler(vcpu, exit_code);
>  }
>  
> -static void pre_svm_run(struct kvm_vcpu *vcpu)
> +static int pre_svm_run(struct kvm_vcpu *vcpu)
>  {
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3609,6 +3609,8 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>  	/* FIXME: handle wraparound of asid_generation */
>  	if (svm->current_vmcb->asid_generation != sd->asid_generation)
>  		new_asid(svm, sd);
> +
> +	return 0;
>  }
>  
>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> @@ -4231,7 +4233,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	if (force_immediate_exit)
>  		smp_send_reschedule(vcpu->cpu);
>  
> -	pre_svm_run(vcpu);
> +	if (pre_svm_run(vcpu)) {
> +		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> +		vcpu->run->fail_entry.hardware_entry_failure_reason = SVM_EXIT_ERR;
> +		vcpu->run->fail_entry.cpu = vcpu->cpu;
> +		return EXIT_FASTPATH_EXIT_USERSPACE;
> +	}
>  
>  	sync_lapic_to_cr8(vcpu);
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5b159f017055..e51852977b70 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -713,7 +713,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  
>  /* sev.c */
>  
> -void pre_sev_run(struct vcpu_svm *svm, int cpu);
> +int pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void sev_init_vmcb(struct vcpu_svm *svm);
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);

