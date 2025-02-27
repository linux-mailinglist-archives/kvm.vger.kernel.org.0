Return-Path: <kvm+bounces-39578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB385A4816A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B5A5423DE8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A8F233D85;
	Thu, 27 Feb 2025 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dnml4sda"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5777F22FF44;
	Thu, 27 Feb 2025 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740665364; cv=fail; b=NwIKbBjT2ovxzKZJVZ7xz1uFkALmuEVFGOwjoz5eixs/vGoEoEUiLNSPhQvv/GpHDSXB2vaWlEr5cJDlXGKLsBSZNSzB3WuJegr0TUGaWSdwX8Y3rGFdgATMItQ6LRwKe6NTKEswm3LeePWiOcpWw8mPVQQH+iFf2Kx47fqiQ74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740665364; c=relaxed/simple;
	bh=4/CNmdc0lAXTKdO06WHXGQAekTNlAOp9Abaw4Wb7b8Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NnS2QwCLpHBExuGi2+K/RH65ru5vU+PTqV4U7q7KGOk7OK+Uad9ouf6jGAwezdh+eNmvWQTzt951Ns/3g6sC1GAo1G+XtiNeeHeflPOjwCNBG9rrnuZviYuNheKaAOobabX253rwZukeEKdzcdUryDdCpZpesOSadmY+BkoTj5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dnml4sda; arc=fail smtp.client-ip=40.107.93.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KFG3zzZHz86QXtfhlJwNWoQbMBELKcDmS1dsHxG6GHFmciQvmmeY07M9I9sczx+OFFeNX3e5342UZTtteJpLQaCbgzJlN5zUcj2CFq+lyypUYcnUSwQP6YETBGaYkmVWJzsAJ/wJ5OIpBLuLaQ5xmKZ2LG7hqkrbJfsBZiI1ArWN8IRMOvOblOVdreC559YksvrvHPatNXB0jRhKgoF1hvdn9N9LzKHfp95gMKgwkOrzBPJ1k6Z5p/7IbIN2mcdO/VRo9jw2cFC65eVE1ivsOuLH8rtFfnrJ7sR76tu6cBR0WKX8YYNQX2dFNbO/dY9zZwOwxzteIiWaHzrjFWcE8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swSuLrOJJzJHL7dX3GnUfTgq8B0O4rY3yMtmxzS2Z2U=;
 b=fgZXiZ4Q8+fVeV3t+m/1tS1xfQ+IQbtqE5GGRY3Q0QtLAGYzFclzp7eXvIFOzSSVOuNmsTU8A6RQuXQR4PCXbsm21u+FzUrTn+Wsa9t2JCSiSQrsc7c4VyrTA1Fke5ah+nSIh9nyP2+t2maoREx14O7cs5l2pxaHh9xCkyTcBiJbTOThJZnCP/+/dWSFT9i2uKeVFO30kwz6JvH8KTxZiBGEmBpqetsQgk3U2Xp/87FW6exEtgDmcbzwlw2XreRsB3TDVl7iPPx+i0Uy2ggN+hE5/E7EHaXlOd/ZTHlhcfftyqpcorNUQ8dMO2ONMqu2XmYIaz7a3JM96QJ/7DB/Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swSuLrOJJzJHL7dX3GnUfTgq8B0O4rY3yMtmxzS2Z2U=;
 b=dnml4sdas8+tgkNyiklOfGoZpsuvB989ngmpt2R9UppMRM2MDade61Usp74lJ4EPuNU+/FMh1M5NQP9QfKQJJUQoB42FOSL7NWbcNEGhUqAIWYBI/vS1KW+jP5w+MHZO+CmbZSlagXADdnYSSuaE9Ctxe2Dn3MzMOiKNzMT+yPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by DS0PR12MB6605.namprd12.prod.outlook.com (2603:10b6:8:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 14:09:20 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 14:09:19 +0000
Message-ID: <1fe17606-d696-43f3-b80d-253b6aa80da7@amd.com>
Date: Thu, 27 Feb 2025 19:39:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
 rangemachine@gmail.com, whanos@sergal.fun,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20250227011321.3229622-1-seanjc@google.com>
 <20250227011321.3229622-4-seanjc@google.com>
 <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|DS0PR12MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 63430047-f456-4905-bc47-08dd573853d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlFPOTZZQzB5dktsNHRKcWc3akRacnZyT0FSMTJsR0pYVGx3RDlub1l2b255?=
 =?utf-8?B?NVl6U2tOalhwNHU2UGowdjVjZ2hrTnQzL0taRStWNWJBcldybk1nNnpVY1Bi?=
 =?utf-8?B?czJyMDRVYVN4R1hsK2xxQW1CUkt3aEM1eHgvM0hBaHlsaDZVUlMrOC9HZjVZ?=
 =?utf-8?B?c3hHOU5FaFMrVXZ6TXV1dnR3ZlpMSWExUjVkdXJic1huL0ZlZSs1VUtZOE1N?=
 =?utf-8?B?NDE2dkhxQXlScmhqbk1hUmVMeU9YN2lvRnVxZ2gyVUEvMDdYRmtBTFFkS2Vj?=
 =?utf-8?B?aGN1UnY4a3N5UlgzdlBLRGltRnNPZTNkbFM3UFYxYzZpUi9iVnByOHA1QnNL?=
 =?utf-8?B?MThFb2xpNk8xVTdwVHJqTU9WZzFTWlJZS2NwZE8veHRRNVd5Mm15aUQ2U0du?=
 =?utf-8?B?dTVlY0FPMElOWHRyY3ZqUmV1YWduTW9DMkl3NDFmYWVaaXUzZFk2NTFXaUNS?=
 =?utf-8?B?TVo3S0JvNStkQVlKZWgvbmtXZ05vaEIvY1o3V216T2oyTEJFY0NNZ0drT1pv?=
 =?utf-8?B?S0F2US9lVmtTN0VoMUlmSGtSMmhzOUlrYnNmQlFDeWFHdGJJbGQvS25MVFYv?=
 =?utf-8?B?WndWMFBLeUxvVFIvN3FaWXpzb2Q0OHNTS010MElGTEdKZlVDakxRZGVqWUlQ?=
 =?utf-8?B?aWVVbzlkNkJSVkRLRUoxb1ZpWjhCdXg4UHNjUHlMRFBpeTVCb25ZdkJkaGRS?=
 =?utf-8?B?MlU1SFN6U25ibDU0SlZYTlF2QVJOaG5IWkM5YlRIWU96Q3FrYVEwQnV1Mmpu?=
 =?utf-8?B?NnYvYUdHMHBvdVpWWG9FZ2FpelloT0dXTG1SWm9WZHRPYW1PM1k0UnQ1d1VP?=
 =?utf-8?B?cEU4MDhtUzFrRmNNakY3S0NzMjhFSjd6bHgvbTZKeWxmeE5USlgvUHlFbW1Z?=
 =?utf-8?B?SGtzOXQxTXd0YzU5K2hsakhlZ2dpa08vaVd1dzlWQUZVSGhCdDBLVWtqWEM3?=
 =?utf-8?B?ZllUK2dJVjJYRXl4SmpBOE5rajd2YmprRi9wSldJTjNiVThKc2xpb2Y1dEla?=
 =?utf-8?B?VTA4RWtHbFdIamdHQmdKM09lcEYwdXZwRTVnSWVRVTNqR0xtbzExdXVlaHdw?=
 =?utf-8?B?c05tekhBOGpkWk9qNUhZcDFjYmZMbE9FdG5pOFdybFhYWmx0MU9tV05na0dX?=
 =?utf-8?B?Y285OFlHUGEyQ3QyK2p0NkRrY3Z1SmVxekxrOGV2cTB4Z1RiZzR1emZoQXRh?=
 =?utf-8?B?amJIOUc5eHhVYzJ3SDlTemdYdVBSaXZBR2dWbUR5clpRdkRsYVA0T1BWWUts?=
 =?utf-8?B?b25qczhhR0VOaDR6RnNWTUNDdW1TdVBRMEpkZ3l6cWZzVmdRY202b1AwbTZO?=
 =?utf-8?B?anBkSUlUZjNBNGUza1JCN2krSGtZRThud05RT0xhay8xd0hPcHZjWEVnemhq?=
 =?utf-8?B?TGM5R0xJa1l1WE8wZXRIcWtCaFBPRDZkZ0YrQ0V3VGI5Mi9MSkx4Tjd1N1JM?=
 =?utf-8?B?TlZoN3p5N21wYUt1a25lS2ZNSDA0OW5TMHVSV3ZkZ3VZTTdLSWRwSXpsRXpj?=
 =?utf-8?B?T3hqaUlKVVFHRU1MVzUyZVc2ZU5LYWpzelQ1NWNua2lFZ3FOd1lrU0h1aXJV?=
 =?utf-8?B?VDBURGhYeHVJSEJlR2FyelJ0ZHNPOXM5S3hYSVA5cFc1dUpLOHlVemlMd0Jv?=
 =?utf-8?B?SGZDcGwvREJoa2drRTRSeGxFOGtKeks3elJ5Vkx5WjFWemc1L25UZHZ0RUZJ?=
 =?utf-8?B?M0pxdlVUZzNHWmo2NWczNEk1VjIwc05OS2E5YTd6V25vbnNIakp1VWxJMUpr?=
 =?utf-8?B?M0d5MjdtOXpYWHg1d05RL0xKeEFMNEE5cUFwRDBqZkh5b21ITUx4bzJmemEw?=
 =?utf-8?B?U0VUNHlEWE5QeWtyb2U2WGxiUnZZRGRMdHJCRTIvQ3AwYWtFSDdhZXI3NWor?=
 =?utf-8?Q?jHy+7AZWFkPbQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T25DTWEwSzNWa2krWHVyNEJ1ZU50Y3c4enZqWUF0TXd6a2F0dFZQYlViUmhi?=
 =?utf-8?B?bzRJb29VQXRBYmFSUmlCeHkvRkNBdnlnMlltR3RsMnRNRCtwcldHYnFTQXRm?=
 =?utf-8?B?TzErWDh0c3NnYU1ka0YrbWZGbGhZZEsrTUxvVDRSWllVN0R4dVlZQVpXZkJj?=
 =?utf-8?B?dUhlSzhic3l3WUhwaXJXbUJlR0JQdXNjbTE0ZEZGMUtISWIyZFB2VktWQTVL?=
 =?utf-8?B?Y3NLN2E5MDl4d05sWFk5SFc2V3VPMzZHNTJnTTFpeDZlL1NCZlp2dVk3NUlz?=
 =?utf-8?B?TUUzREEvclBEVm8zODFRV2ZMbThBUE9OdENyOUtoVGsyVmVxbjlXc1kycTlU?=
 =?utf-8?B?OWN0R3Z4ZlpXbjdRVXROTDlibGRTQU9yRzdkRGo0LzV2cUExY0VzdDNOMDNM?=
 =?utf-8?B?WEFGZyswMXdzd3pJVTAzVDJSWnV5bmM0NnlkY0JScCtaeGJrNFFnOFh0T29n?=
 =?utf-8?B?ZUt5OW8vajVmRnBYSEMvL2VuSmRZcURlUHdhM0xuZ01pSkV5NUtVZmhtb2tr?=
 =?utf-8?B?U0RXRlNOaHNEaC9DdnVFNER2OGVMMmJoUWhiaEVwanVLWHJmbkZnV2NHVWR6?=
 =?utf-8?B?aXBnM1FzdjQydUQrRlR1aENvWmpPbFc3VE5nZzc4N3UrbmdISnVOMlgzV05n?=
 =?utf-8?B?ZUQxMmJnVUx5d2ZLMFBrblh6SFRCNllvc3A4UFRNVk9kNXo2Z2lyaXBJT1NQ?=
 =?utf-8?B?K056NmUyTzVNSXlrQ1pkUEIwVTFWNERMVmNpTEdaRnJPSy9tQXJPeWdGdzJY?=
 =?utf-8?B?WitFL1FpNUpob3F2cExPQXg1VDk0TlFURWwzN2VRNXpJRmdlVy9jbjh1Y2tr?=
 =?utf-8?B?Vk1uSm5mdUlldzA3UVJjbFI4SFI3UWhQblFjRFlEakNMNTZ5bXY4S3ZzaGtU?=
 =?utf-8?B?VmswK2VpMldBVkcxU0VKQW55RndBUlNCQmlSTnJuODgxdVQrbDgwRkJQWTg1?=
 =?utf-8?B?em5wMjh1dHA4OHVONWJiSkN4b1Y0eDZBcURYTUxpdjVrRG1DV0plRHVqSHNY?=
 =?utf-8?B?VnhpOGVtSkNIcDNNd3JkK3RDd2F1OGwxd3BDVzNZblBwWmVrS1pWT0REVnZq?=
 =?utf-8?B?UjRoc0x3RWNtNzZWZytjTG1NcCtjSklUMkpieUpPQVk4aStKZzJkRTVqQjFJ?=
 =?utf-8?B?YXptNTNKMnF1TXF6dUJOKzdsbVFFdVRtNDZhc0Vib3I3YUhHN3pvamRRclhL?=
 =?utf-8?B?OXE0T05LcEUvSW5RL2F0amFReHFIdUFodk1ONE1reGloOEpybG9vVFByNDZD?=
 =?utf-8?B?Rm03M3FJY3JOMURPdytDOC9kZk9iSlZTeHV1WDVQMHhEczlzaEFLZTRsM2Z1?=
 =?utf-8?B?ZU95bFlrYTg0N3YyNEV2T01wTEI5SmhkaFZ3T2xPd2pSK1FDTTlLWFY5WFdJ?=
 =?utf-8?B?NUNWSkRDaXo3TURlTVJJZ0xkRjVQUVlzVVBCSjA4Qi9mOE5TZ3NGVDVLaVov?=
 =?utf-8?B?ejYvUUdMSzZ3MDZoTTBWNUgrYUVVWEh1ZWFEV3J3bW5Pc05JTm44S0ZaTHZB?=
 =?utf-8?B?VVJ4cFpHTEI0eWR1Tkd4NmhHZnk3TEdKeFpvYkxGcHIxZUVPM05LTW94Ky8z?=
 =?utf-8?B?Q21PclNsWnh5aUxNSWRtbWhEcG94M09ZbytTekdIbDlKd0VpRndFMVRnNUZj?=
 =?utf-8?B?OVErb1hNK3VOTnpFajN1ek9GN2NOZTZEOTNwV0t6WVdrSEhNQ05jdUpGMnZj?=
 =?utf-8?B?dzZuR2FGUU5RdUs4aS9sR3U0d2pWSWwxVXBzaDc3NU13eUcwUXF4MkNHKzNZ?=
 =?utf-8?B?aEJmbjlLNlJYMHNrWms2Y3p3aC9RUU5RWVRTU2dGdUdxVUtpRGNXYngyMzJl?=
 =?utf-8?B?QmlhbVNlL3R3ZFlucThLbmlkZDNlTTRyYnY1NGdsYXV3M3NrdzRsaHp5ekZG?=
 =?utf-8?B?bmQ4dk9OWVJkTlZ1TTVoVlZoeWNEcVMzdHYxR1FLa1Bob1BTd1pUOWxRY25L?=
 =?utf-8?B?a3JzNTYwayt2OFRwdUlrVFJERENhWThVMmhkZjVvdEQ2YXNiVmV2K2xHUndx?=
 =?utf-8?B?UDBocFlYT1FScmlXK1RDdTFoU0NYMFlBYzE1MlpJRG9xVlRLVGZmSjIyMktQ?=
 =?utf-8?B?bXBjWjFCVFZNV1g5NWFDUmp0ekd0WHFYODlGSDZTSWRYTmNkbzhoa3lYbFFa?=
 =?utf-8?Q?FnAypbQEdbjAqPx9VG3smninj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63430047-f456-4905-bc47-08dd573853d6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 14:09:19.5780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONaKSwzwLZ4UIcAi0iZ+5HIQXa6nT0rsyQlDvtiwpsHcvXXN6Qyrv3jBW3OIIJjLmz4RKx7b6jWddkzo1cj+xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6605

> Somewhat related but independent: CPU automatically clears DEBUGCTL[BTF]
> on #DB exception. So, when DEBUGCTL is save/restored by KVM (i.e. when
> LBR virtualization is disabled), it's KVM's responsibility to clear
> DEBUGCTL[BTF].

Found this with below KUT test.

(I wasn't sure whether I should send a separate series for kernel fix + KUT
patch, or you can squash kernel fix in your patch and I shall send only KUT
patch. So for now, sending it as a reply here.)

---
diff --git a/x86/debug.c b/x86/debug.c
index f493567c..2d204c63 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -409,6 +409,45 @@ static noinline unsigned long singlestep_with_sti_hlt(void)
 	return start_rip;
 }
 
+static noinline unsigned long __run_basic_block_ss_test(void)
+{
+	unsigned long start_rip;
+
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_BTF);
+
+	asm volatile(
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"1: nop\n\t"
+		"jmp 2f\n\t"
+		"nop\n\t"
+		"2: lea 1b(%%rip), %0\n\t"
+		: "=r" (start_rip) : : "rax"
+	);
+
+	return start_rip;
+}
+
+static void run_basic_block_ss_test(void)
+{
+	unsigned long jmp_target;
+	unsigned long debugctl;
+
+	write_dr6(0);
+	jmp_target = __run_basic_block_ss_test() + 4;
+
+	report(is_single_step_db(dr6[0]) && db_addr[0] == jmp_target,
+	       "Basic Block Single-step #DB: 0x%lx == 0x%lx", db_addr[0],
+	       jmp_target);
+
+	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
+	/* CPU should automatically clear DEBUGCTL[BTF] on #DB exception */
+	report(debugctl == 0, "DebugCtl[BTF] reset post #DB. 0x%lx", debugctl);
+}
+
 int main(int ac, char **av)
 {
 	unsigned long cr4;
@@ -475,6 +514,12 @@ int main(int ac, char **av)
 	run_ss_db_test(singlestep_with_movss_blocking_and_dr7_gd);
 	run_ss_db_test(singlestep_with_sti_hlt);
 
+	/* Seems DEBUGCTL[BTF] is not supported on Intel. Run it only on AMD */
+	if (this_cpu_has(X86_FEATURE_SVM)) {
+		n = 0;
+		run_basic_block_ss_test();
+	}
+
 	n = 0;
 	write_dr1((void *)&value);
 	write_dr6(DR6_BS);
---

Thanks,
Ravi

