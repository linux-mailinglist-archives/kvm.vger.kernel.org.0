Return-Path: <kvm+bounces-59983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43043BD70D1
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB4A7402E0B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5049A303CA0;
	Tue, 14 Oct 2025 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g0JChg69"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9FBEACD;
	Tue, 14 Oct 2025 02:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760408048; cv=fail; b=PXfJ6xZD1ZFhJXetjEUae3FpPJ+j4fZiCOEXaKqAfMlvtemCvxeBYWvPHWXEVmyyZROfK+4cFZNybXSyqcCKEDAWdNvne8Th9884q5YwiqI1qk2SpUbUq09BYw7W1/mK3W4OPqs+S+aqto64c89Aos5tgPmm89UxS+596c1Coxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760408048; c=relaxed/simple;
	bh=OJuH+57HUZxOb88uL+fhvD+Dc7JNLS4F7tSP4KEPdVg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jzZWYX/P50l6uf327NBKvQuS1ZqAj7Z869a7VPaXSS7saPRAqwOHB3ppGe7Bly+xXUWy04yFe1TqgOBeVD9DCbRdwK+9aMEU881bQhrzGNstKtmg+uw3S2sSbE2maHuaxeia/AtTHoGJllzXK8+FDwSN73XjagmFko1u6iM/cnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g0JChg69; arc=fail smtp.client-ip=52.101.43.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aly1TA09rP9s8918nz8S0A23JcQgJCedTncu6Tlw4p7jG6OQWfvSrd/NCNFjuedwGqUXRJWTIVy8SfI0zyUr3/yDwsR+eDHWidTqwuFwXEW8/QTeFvz1gmi4+yfQmG4+P+Di/t8Zg6oFPbf47b706xOfQ/x4JIoJHdJZP5vbC24NkiYgiZEve2sQoXwwl6p+QqHnF8/A8MeP6vcOaBiCpUKBU82LiscroKuaUie38+DTGPNwkLgbXEQNCPNUp+qqgpmuxFe2qS0Ieqkh9eOTPCq1MCHpSQZ4wp08lKzD6uQM0XMBktWLUg3uRPqf9otm1T7bUAKveTYX5nTVI3XyhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owqF/jWEKVpTFDwwo4LAJCw3S3isezGle0WHnspu0jQ=;
 b=RC/SO07Or+7B1Ure144eQ1UsSLL19qfalEmw5ymevWy0iXstwdwC6rqS3bIM7ZcrPzVOCjmXKKw3TyT8GlRcj815paTObSEhS4NwOKGXAaAyS7hQBb4mr4bBfzpwxHd4yJybSCql+SSRh+Zg7kEigX6JfhjrfLgMQiQ2cUdQZomlYtj2HdvmmG9ePjQ9MlKvuSesVPmxnbwpzWX4QOedo9rpANGzac9xiANfI1BtgEqVFy0ZFJEp0HYAFvo2B7YulpDfF8pEhvzNzPnXpXS/e259JsfgtnoWFPkwoqW/3fRmrywmdtSzv+BZN/zY+zLobLByk3QQOGxpeiTGZr00yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owqF/jWEKVpTFDwwo4LAJCw3S3isezGle0WHnspu0jQ=;
 b=g0JChg695vKE1PnH0GAauroasrcKMr3x01+cB6FjCEoMO5IaSkyBL4sAlO0wDSmNp0Clux47vhYd6yVEz3hejZ9nUiOoATlxtuPbIkWrA0ilvtC7X13SZYi/RucQ/rqotZr0HsptKMggqobkbdr+Zw0lYTBuklsZJZf/1GzyHVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SN7PR12MB7452.namprd12.prod.outlook.com (2603:10b6:806:299::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 02:14:04 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%6]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 02:14:04 +0000
Message-ID: <0e11cc42-9521-46b4-b62f-7268fed12d6a@amd.com>
Date: Tue, 14 Oct 2025 13:13:55 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 0/4] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
To: dan.j.williams@intel.com, Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "Kirill A. Shutemov" <kas@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>,
 Kai Huang <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8PR01CA0020.ausprd01.prod.outlook.com
 (2603:10c6:10:29c::6) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SN7PR12MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: 7984ee2f-54a2-49a5-d63b-08de0ac758b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVUwNVBwNVpmL3hIV1dtcGdZbUlOVWtEUlE5Ly81QVRXR0xpTGphMk1ZQ0p5?=
 =?utf-8?B?TURoa2dhKzhjQUNoN1VJVUVMOVIwYStiMkNuYjJXdzMxZ0xwQjEycmZncVR6?=
 =?utf-8?B?MnpRU0ppQkpPUzNEbWVBTUY0WjN0UnR4d3hhKy9UWDJxVDRUNzk3cTg1UGhp?=
 =?utf-8?B?K1VyK1dzSEk1eVhVcnFYdUphaDBoVE9Hd3RBblJsSWhjQS8ycG1hSk9RTGFS?=
 =?utf-8?B?eHJCVVJMMk0xRytBTlBSUjZIeDlkRTZpUEV3dmVLcGhJMHl5SzJ2bXhFakpE?=
 =?utf-8?B?Tng3R1c2Vi90UC9jZFpTbHBiaHBHRGVrbDBwaitvWGxYcDZnT09vTDF3L1p0?=
 =?utf-8?B?cHByV3R0bnNULzF0WkNoNlZ5ZlBJMUhUWDkvenRmQmJXbStlT2FFZlNNZjlh?=
 =?utf-8?B?TnVTMXBrektia2s3UzlVSjMyMEhsRGJnK0hOeVIxL093ZmFSQWpWbUlDdFEz?=
 =?utf-8?B?ajl2QXBnK0s3OXNhS1pwU3A1SHhyRXUrbjh3Zmt5UjE3ZGUzSlAwZ3dnc2hV?=
 =?utf-8?B?TGsycU1WL1FOU2xMVzRabGZPWHNYaUJjYy92OUxLK2g0bjZKMi9NQUpGenpy?=
 =?utf-8?B?OHpKY3BaUWxabEUvcmVvMXUxMkx3K0tvT2hlRjR6TkY5NGxYaHZVMVdGTk5t?=
 =?utf-8?B?cVVjMXA2cTE0SkNDa0JXNEtDZ3pFSnJrQTVEYmNEcG1LR1hZdlNXTUg1NzVL?=
 =?utf-8?B?djVzRHpzU3YwdjN2YVE1NUJQWUg5TU9jajNqTUVlU3RsYTFaNlNDTzhDcXpB?=
 =?utf-8?B?R2pjVmVKbzhUNndSeHJRN0V1VElzbU1DSk1TMGQwT0V3UWNERzVmZk9NTG14?=
 =?utf-8?B?V00xVnMxSDAycXlSUkVDNHFMSkVIRm9QMGQ3MGtUeFhkYjRKZ0RLcU0zcm54?=
 =?utf-8?B?V001b3pTM2dmNTJoRlRDZlRvbGt2Z2pEbEIvWDNFZXJDWWErdzJNS1JYV0tM?=
 =?utf-8?B?cTQvLzdqN2hRRDIxSm5xaTgxNm9URXMxVWhkMlNLcFNpdHlTNkdCWHE3U21s?=
 =?utf-8?B?Z04rTU81aGk3dlRUUFUrYWFib0x3eDUzMjlQZ1JTNnpvVUZlU2lXa2VUNkdo?=
 =?utf-8?B?dFZmVlJBdm1IUXBJL28vdkVOcnYycjVLc0ZJN29kWGw1YllsMkwyZHZ0M2dL?=
 =?utf-8?B?VjZ0YmU3djlWM1ZsbUZTVC8yd3lWTU9VN3ZMRTBvcktaZkliQ3NzQ0JWOVZL?=
 =?utf-8?B?Zm00RUwwNnQwZnNmUjhzcWJZZURUS3ZldzMwNllYY0ovWmFTWVE4M2tKTkN1?=
 =?utf-8?B?SGJOREJPNS8rbnYwczVYMGFPUHVLL1BGMHI3aGdLRVhScTdjWUQvaklPcU9G?=
 =?utf-8?B?RUVWZjNuQTZjS1U0Z2FUM1pWVm53TjVDSmlIS0o3azFJVDZXb1lGZ1hBZk9N?=
 =?utf-8?B?RmRmQkdrcmwvd2dnd0pVbHVtc3F6Y0RXU0FqVitrRGxRaTR3aDdnZVd5OWF3?=
 =?utf-8?B?RlRVNXlWM2tRWXk1blc5VExxaEV6WGUxZU9PNDR4c0NGSlJlaFRhMG9qNGJn?=
 =?utf-8?B?ZWY0ZUNXdzUzaG5kQVoxbFVRcmY4VlJqQlNhWFJpalZTNnc5MzN6NTJveFpP?=
 =?utf-8?B?WlRxaXZrWVp6NkNqdnhwVHZBMVM3Y3pNOHdhQVM4enpPT0ZDWU1wanZvWWUr?=
 =?utf-8?B?ejEvdms3SzVTT28yeTdrdnNmOFo4N3F6TmwzdEgwZnRkUjY2RXd1ZzgvbHM5?=
 =?utf-8?B?emQzMWFNeDNPU09nY211NU1DRUJSeklSSW9SUFNqT1o3YzF6K3c2WmpwelNq?=
 =?utf-8?B?K3ovWmg0L0x2VVlyUkRrMTRnNGVabUJJNkR3MDRTQVpzS3lzZ0YvcGFZcGI0?=
 =?utf-8?B?QXVsSktMTnVUSnZwc0xiOGFaM0hra1pyQ3pIeFhIS1RrUkp6ZmY2THdNOUY0?=
 =?utf-8?B?U21kcC9rRElHdUs2SDA5Nk5xWHU2c21Lc0x2WkJlNklwSFJnVGdkL1lPNjJ5?=
 =?utf-8?Q?EKbo16JVX3WYL7oAWkdHCqb9wtQtxx2J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1M1ZFk3WXNYWlEvSUFaMlRjTUdrK1JNdDdOK2c1c0ZlRWVma3BzcjMwaVFW?=
 =?utf-8?B?amRta29MZExHYktGVHZQSE9Hd1hCOUxCeG8vZThGU29kNHdwdE1CRUw0UlU1?=
 =?utf-8?B?T2ZaS3RlTW5XamQ3emJJR09EQnNZK1hISUpKWVVUdE9HY1V0d0Fua29Ecks5?=
 =?utf-8?B?UUNnZGpVRmNwZnNRNkg2VUorSHY0ckN0eWtpMmJrbkdaSE44Z0grMG9NRWNp?=
 =?utf-8?B?MDMxWmdoL09FQ01oakY1dERkY1ZZSUhTenF4UXBUNUFiN0QrVm1WK0NnTzU0?=
 =?utf-8?B?aWl4YjRwdGlBRnRKV0NhaG41N0FRRXloOFlqeWpwVEwvWVFoazRmdExhUlR4?=
 =?utf-8?B?eThnZ1ZOY2V4ZUhXamNkN1plSVR1RWlPOHFDa2hnWVM4MDhVRXN3UHdyYWpD?=
 =?utf-8?B?L05vWXM4NDRlSGhrSyszV1RmRk9jTFA3aldkaktVazJUOGFRQjE1OUEvR01E?=
 =?utf-8?B?UXAySVc3SlNYMkZnVi8yckx5YkxMMWNOKzduOHFqR1U5TjZ6bUQwbklaL2R1?=
 =?utf-8?B?cmdhUlp2OUxTUzc0alpFL1MvWXZqZE9vbWNNWmp4YmlxWWV3UktiZk9Wa3F1?=
 =?utf-8?B?S0RxMzV0VTJYbTNpOWZBUitDNk94SXY2VjhRVFpma2JKVEdVN0dscGlNT1FN?=
 =?utf-8?B?NmFlWTE1MDA5RGt1Tlk4azhkNHRTWG9YbVhJb0JwRGlsblRrbXJrTElieFR0?=
 =?utf-8?B?bzg1TUpoMlR2aWtvYzQ4WmlIY3JwSWY4MlI5OHR0cmp0aFQ3alQ2bnFXa05O?=
 =?utf-8?B?K3gySUlWQm1sMVlTRTh0UWRFT1JyWUhoRDhza1pkN3dGOVB1L3p4TFk4OVpD?=
 =?utf-8?B?ZXoyenVhMVp6cXNOdHVrWFZOcVkzMkZ4NmdKSnlXNVhWdEEyNnlxVHcramF2?=
 =?utf-8?B?UmJFQ3kvK1o2eXBIYlIxV1pWZ0UyOHFqamxGUEQ4OEo1V3NtakdrWmdCaTlY?=
 =?utf-8?B?VXNEZnpNdkJBQVEyNXo5VERkenR3d3l3eGhJdURmUXhWRWxQajNYelJHMFdy?=
 =?utf-8?B?WSt0R1d2OUFIY1JOclhva0dIZ3doYUVUbHo4S0tRQXI1TEViR1NTQlc2OCtT?=
 =?utf-8?B?eDduZHo5aEhScWVxRUkvNEowZGFXczN4WXczNnZ2ZHlXazgvRmdQWjBEMHpi?=
 =?utf-8?B?SXl0cXNyWTZxaHNucm45aC9Pc1hvOG9zRFpRMlJtenVSY1FtVWJWQjB3VGJ5?=
 =?utf-8?B?VW5KQlNBbzBiUHhIaWlMeDh5WkxoWDBoYUR5emlWMWZCdkdrVmRiY0gwNUlO?=
 =?utf-8?B?NjdTT05jc3VDekdKUHBISzRMWFNuSUswTmdwcno4K0lLNEE3NzVoNFYralhw?=
 =?utf-8?B?OUd4OTF5Ym14UDdYMHNBZGJjeDFmNlhFUU5wQ2ZCME94Q1RhSDNLTGtEckZS?=
 =?utf-8?B?WHhnenBkd28rWnIweS91UGVsazJKSXIwVEh6MUxiTTUxKzR0UGFBQkdSVEFv?=
 =?utf-8?B?ZW12dkdCSEJneW9TVERySjkzREswU3NEOWpLSGE1QTVxbnRHTjJ1THhHSEpJ?=
 =?utf-8?B?VGZOejBRc3hibm9yZlpkamp4SVptQ083Z1hQaVI1ZmtTRlZxTWtVL1JGVjVv?=
 =?utf-8?B?ZjRGOGM3a0NNMUUvMVVCYnNSR1JIeUJFTWJGeHdwWndUMUhrUHhpcjY5ODNE?=
 =?utf-8?B?YUtNbVRpbUF1Z0doaUI2M2piWE5uRzhRem9lc21LVkZROVViVVRuTTZSbk1F?=
 =?utf-8?B?QjZnV1F4K2F4VjQrY05uUzRCY1ZrSGxLNEpTcGIxUVkyekw4MVc2MVhjekF0?=
 =?utf-8?B?SXRlR1B2OVQ1ZFpXeUJvMnhRai9BMlFiMS96dFQ4akh0NkJEKzYzaVJqSEFs?=
 =?utf-8?B?a3BCUDB1VVRiUHQrVE42WVNNR3p4WEpSSWJFUTE3c3hVUE1GZEdheHFvWEdj?=
 =?utf-8?B?WjhMQVBPaHdLLzRTYk1ZVE5UYmdXMk5MSklJOWJnYlpPWWp0cnZ0SlhPUUtK?=
 =?utf-8?B?ZWdGbmRtbFVUbU1kMnVZUHA2NGRqY2JXOTd3SkFOakNya3Jqb1NlZEJJN2JT?=
 =?utf-8?B?MERVVTJWOWJSaVVKQmVKQTMzUDA1aGpuVHlCajNEWXl3MDVDR3pyUkp5WFN4?=
 =?utf-8?B?SjNKOEJZMHZTTWRIcExFYjkxQUdreU1IL2s0dTBURzdncHJtVTNzLy9zRE1I?=
 =?utf-8?Q?FzYdBRXfv01gBliGZd0VCm7G7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7984ee2f-54a2-49a5-d63b-08de0ac758b7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 02:14:04.0447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ac4fm31fWkPbxMJi8L75APHGh0TM17jGbijyR/R1Gmn25NlplsbKkLTuJ34/VaKdRYm2xeHIQBhCzjHgJjckSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7452



On 14/10/25 09:22, dan.j.williams@intel.com wrote:
> [ Add Alexey for question below about SEV-TIO needing to enable SNP from
> the PSP driver? ]
> 
> Sean Christopherson wrote:
>> This is a sort of middle ground between fully yanking core virtualization
>> support out of KVM, and unconditionally doing VMXON during boot[0].
> 
> Thanks for this, Sean!
> 
>> I got quite far long on rebasing some internal patches we have to extract the
>> core virtualization bits out of KVM x86, but as I paged back in all of the
>> things we had punted on (because they were waaay out of scope for our needs),
>> I realized more and more that providing truly generic virtualization
>> instrastructure is vastly different than providing infrastructure that can be
>> shared by multiple instances of KVM (or things very similar to KVM)[1].
>>
>> So while I still don't want to blindly do VMXON, I also think that trying to
>> actually support another in-tree hypervisor, without an imminent user to drive
>> the development, is a waste of resources, and would saddle KVM with a pile of
>> pointless complexity.
>>
>> The idea here is to extract _only_ VMXON+VMXOFF and EFER.SVME toggling.  AFAIK
>> there's no second user of SVM, i.e. no equivalent to TDX, but I wanted to keep
>> things as symmetrical as possible.
> 
> Alexey did mention in the TEE I/O call that the PSP driver does need to
> turn on SVM. Added him to the Cc to clarify if SEV-TIO needs at least
> SVM enabled outside of KVM in some cases.

Nah, the PSP driver needs to enable those encrypted flavors of KVM (SEV, SEV-ES, SEV-SNP) in the PSP (set up memory keys or RMP) but the basic SVM does not need that, and EFER.SVME enables just it. When those SEV* are needed - KVM calls the PSP driver to enable those in the PSP, and shuts SEV* down when the last SEV* VM stops (or when kvm_amd unloads?). And the PSP cannot see EFER.SVME at any moment to act differently.

So until KVM tries VMRUN'ing a vCPU (+few more instructions), EFER.SVME does not matter afaict. Thanks,


-- 
Alexey


