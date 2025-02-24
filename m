Return-Path: <kvm+bounces-39054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC1BA42F9F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27191189416A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F53B1EE7B3;
	Mon, 24 Feb 2025 21:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rV1v0j7C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E245C19ABB6;
	Mon, 24 Feb 2025 21:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740434317; cv=fail; b=Z2pwWZjNPY0RYb6TckfWJZt0nCbICrdJL/2HXniJOsqITS4/aHdrjeR8J0mMFIg+1kq9uQ9Pw9C+ayp4BLo/qImXsDz33tAF63KyePcNDp+xVqOpifQ2gvW4rcCLnI3wzXj/46Bs6DZonrASxy+Umqe6mdl8FqAEdXypcvCYAmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740434317; c=relaxed/simple;
	bh=X0b8lVftd8B6B9JGpG8Mf3GQrVFtNS598ZuLiolsHBk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=usaxmORkiwC6xdBHDIpkm+w8Ha+D/faXusjjj0EGwDx7CIVA3Nzl83Dnqsgq/cd44nv0RkIKLEKzCmAgr6Rp5i5V+vvhlBD0SNRKploscQybeSgoWMADYh53NsBDQqCPmX5qbZwmeM/h1wV4/o76do95ic5n4006Ckke8Xu36kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rV1v0j7C; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UsW5nRdL1w5PNfi2MRhDrKpKn7yIxIXT3ySM8FO8ZWZ+kqQSAMT8loannKMKnFX3yy/XjNqClgIjba6+wZChQk+6M1qvG+2OTpaVujwHkUOt/c/2Vmp2Qz/z4bmUjlNzXJAJGhU9Zvebm3y3MbxFKQ0lRxuV+lB2zt+aANfMBtjgNrs2JoCbOyoeef5Q5+h3PLch3C1EBxJ+VJIYQ6KGyY0anjFtDTqPh1qouWeGsTWXXGDO6D04Y5aqaABMYi7LZVsbMK557igqDIkWRf44Ait2gLkfH0pYvpTlasw6Yn8atIEuNZbFDKnzFihx2QVODg9lXOLye8WZ2v0bM4XH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1DYQR8MM8YqJ7b7bngqOVD1Vm1+2QZtjl7gqdcreKI=;
 b=U0qvq/pcKjobM1xtssynBcsXQzlxQxwER8QhCK4b/clPZJFQPpD3Oa31pzm1eoi2sh19lpre1zTkppZWaMAoz5lCuxr+R2AzSJCJAZJs0nHhErGBUnpTVbXxzmuRfyDqS2B0adDkKuHIABgCfJsDpqshG21rax24BzzK7noJMQcHfIk5unnzE5qjDK35SSPP8XGZMlx+7eEqNZBBqi+LAP22BGUZH3tn0d+ih7K/dffELQkmF2QmqFRzSLqCMNXiedosq5JNn+glTvXxgO3qlo9SldpVXH7eYqQCosY3BBlM5vKaQFZ06Ynr43JseFkDX6E4gBw6aKKX/Fl+oZ0YCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1DYQR8MM8YqJ7b7bngqOVD1Vm1+2QZtjl7gqdcreKI=;
 b=rV1v0j7C3O6Ndo598Olk7ztMPXiMkGHbwQdZ1SstRHhnnjgJFOc9egBvvpu54fUCFa8Miew+fFN3clX23+NaS3DYrYW9gFtQ0zYR6JMZU3/g+iRERQO3IE1SDEFC9B4eTNqH36YKyw9A0oLs7vJlzFbGRSgcgY6RaAl07hADeXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN2PR12MB4301.namprd12.prod.outlook.com (2603:10b6:208:1d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 21:58:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 21:58:29 +0000
Message-ID: <d9c8f6e2-36fd-7c6f-c755-e74e9d862714@amd.com>
Date: Mon, 24 Feb 2025 15:58:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-9-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 08/10] KVM: SVM: Mark VMCB dirty before processing
 incoming snp_vmsa_gpa
In-Reply-To: <20250219012705.1495231-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0171.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN2PR12MB4301:EE_
X-MS-Office365-Filtering-Correlation-Id: 101d30e1-6117-4dad-8029-08dd551e5f58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVZDRktNRXhNM2E0UGdVM0x3cFFnNE9WVjYzRTVpemUxbjdkSHBIU09YY0lU?=
 =?utf-8?B?UjdtUnk3RVNLU1ozbFRsT3NvVVpzUkVka2k0N3lLNHYvR3lkTGd1YWZGcDBp?=
 =?utf-8?B?UzR4WlFJNm9CcTJwUlRhcUdpY1RGNkh4b0VPZEE5WHREeHNoZG1aNHhrSVQ3?=
 =?utf-8?B?VTBIWGFjeTMrVHpydHJnbzBHdCs1b1IvWGw0NXNSVXJsTUkzbzhEZ2dIdGtV?=
 =?utf-8?B?TUdxRXZ3anR1YVA2V2JVQlhnd2FFRFBVZ2NNU0ZIQU0yQWFSM3Z3cXQzK29n?=
 =?utf-8?B?NUxMQ3FFVWNLWWg4dGdhczdBQnVQenZoZmJzTGRkWENicGF1c2dtVHA5MDJ5?=
 =?utf-8?B?WjduVGFVRlkvT0drNlg5bCt4bWVrVWhpSVFJVm1tbmF5YW1wMzJIdzJsOHpK?=
 =?utf-8?B?bnRKU21PNjdHQStyUldJR3RmMTNQbTNLQ3VhNERRMHg2dlM5YTlITHZOQjNM?=
 =?utf-8?B?UnNxQTFOdWtlVlpVa2JxdktiaDBqS2N5ZGVTRFhwNTJkN2N0d2hjcEdDVWJL?=
 =?utf-8?B?SkE2OFR4VVFFVE8zcy8xQzUzWmc2TVF4TjVhZStTazZVN2RHT29zdTFRQStW?=
 =?utf-8?B?UGppTDBaU3BRTjdPU3VpS25ESXRNeHp1emZUVU9qd0FSU3phaGV0dDVDYkcz?=
 =?utf-8?B?NDJVcUtXblpQanV4SzZGT0NkS3hBaW9UY1pwNGZRMEpJSWhGNm9ycnJvWmFk?=
 =?utf-8?B?K1VKRytKR1YrMmh0eC9VcFFlcUFOTUdzSU1NRFVWTE9OWEhwWDhkbDVKWGFH?=
 =?utf-8?B?MzVmRTVzY0FXUk1MMDIzancxSnJtYjZEcUJ4UE9DUjBLcE45bWt3Mzd4cExo?=
 =?utf-8?B?d09md1lYdm1wTzMydXV6WDRjNUVVTzloUndHbHkxb1U4WVV0b1o4bkRBanZB?=
 =?utf-8?B?UCs1bVU0T3ZGazJCWnJjd3RUS25hRENSRWV0TTRHcDBKcUFQUHFwSXNKcEJi?=
 =?utf-8?B?Z0dBc2VkQ2pheWhOMVhZRlJZYVJKYWc5NVdmV0x2NDUzalNnNWxET3o4VU9S?=
 =?utf-8?B?T0FFRWR3N0FUa3BuUXZ4V1JhdDVOMlUyenUveUZneEFUSlg3TWVoWkpLUWJT?=
 =?utf-8?B?bzc5SGVQMzFpcmxuMGt2WFlnc0RVVERpZnhFbWhtRkt0b0xXRHJPMTdvLzAz?=
 =?utf-8?B?ZEtVYkZiKzhRd0lZcFJmVHZUcUZtTG5veGl2ZmFnV0tpOFRGY1c4S09QdktD?=
 =?utf-8?B?ZnFYeGVNVkE5RUxCWGZZWDBGZlJ3UFpBL2RTRWpYTFFtSWFjSC9ObGRGVlVZ?=
 =?utf-8?B?N1lUcThSRzlZT0hTdzI1Q3ZDNlgyZnUzQlByOWM2blVHU0tDakQ5UFZ2UUEv?=
 =?utf-8?B?a1dOSzJiTml2NHUxRk9DNW1MdXlqT3NBTnBlbDdNdC9ab3JSMCs0UFZnSGVL?=
 =?utf-8?B?SmZIbHU3LzRtbTZqV0RwNFl2a3FzUk85ajh1TG5VK2xEb09vK2tTdWR1OGlH?=
 =?utf-8?B?eUF0WXEzeGoyMUlOejFhSU40ZWdaMlZkbk1ZL3hSNk9rREk2bmlxRGRIZVJQ?=
 =?utf-8?B?cExPMjQyM1lYU2NRT2VCUEdzKzZEeDc3cUZTQjk4ZTY0d3l4MmthZnl2VWU2?=
 =?utf-8?B?K01FMDNBdjd3WEZ5cGtiK0ZaRm9YWTRGZi94OFhvbTluRDVVa3dTUnZ5RGQ5?=
 =?utf-8?B?YTZkUC9UZFh2b2JxSkFzM2tVNnVvcXhUV240UDh0WHRieEpZTjZmdEVESFM1?=
 =?utf-8?B?WGdPNTRyLytYcDI5QXBFZUVOVEQxRUFWV01kVXVKQklWN2h4TlpwbVhzTkdp?=
 =?utf-8?B?VHNuaElPSDd3LzhRQzZYUGJyWUM1WW5yVS9pTHpIRWR4NkVsd1VkWHhCY21B?=
 =?utf-8?B?WEZ5K1Bzb0JtZ2N0T0o4NjNaQVo3dDZ4eXN3aUlhM3ptZm9jbGYxa21GRndU?=
 =?utf-8?Q?O/YnZ+Ek/4nVy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3EzNUNTNFBxWDN0ZzJ5Wmlsb05PRnhGV05PYnZYOU1MVllRZ3FLQUZqTVZW?=
 =?utf-8?B?dWtwUUs2cUhrcllud1NsU2JjV3NaMWlBRjZDY3Y0QUM5L1hCZ2tHUGg4YXhO?=
 =?utf-8?B?UjFqZkdNMW5MY05UMHp1TW1HQkl0dTZSckZnNmpyWEJaNXl3d1doWGs3TThO?=
 =?utf-8?B?emZhNExQWHRNNzZkWENPeE9LWlpMbnBLcnA1aExIYWZMMFU1akowYmQvUjVJ?=
 =?utf-8?B?ZWFBVGdyYUNFbm9vYlZ0SXh4T0tpNEgzcTdqbXJyVnhzMm1SclNNcGdBN0JQ?=
 =?utf-8?B?WFh5aEY2eSs4NmV4L2hTRDNKbHptM3AvNjlVU3NZeEFNNEpjUzA0bWpNSEND?=
 =?utf-8?B?YkMvU0NzS3lzZi90bDJTTVFBTXhnakUrNm5QdGZKZkRjMGs2ZStHMUdVOUkw?=
 =?utf-8?B?TUlSUU1PSENtUHR5MGxUclZMZUlOQkJZY2I4Y3RweUtEamVxSmN1bzVub3FD?=
 =?utf-8?B?WEw5bFE3ckMxQld5WW1HRStnRXV5bHVBb1QvYnd5RHZhTlpaQWIveHYreTk0?=
 =?utf-8?B?WU80bjBPb1I2VTRPVWpDRGp3Wk5NYitJczI3OEhTTU52ajA1WHNjeC9mSE5W?=
 =?utf-8?B?K1JaVHZseHpLdjUycmNMM1ptTy9NMHNSZ3ppMFZGMXhkWDZHYXZnZ2JEMXc2?=
 =?utf-8?B?UnlRNzFHWVNXODA1QVYxS3ZpZzZtNXdnTStIdEw3YWNVYlprOHJIbzQ0ZVVB?=
 =?utf-8?B?U3A4UURtWDVsZ0QvOC9TYW5aUTVrV0k4dFJIT2tEK2hmZm9renJ2ZlRKMjQ3?=
 =?utf-8?B?MVhjM3FwSEhWMlptZVFFTVVqRVdxWHREZWp3ekRLb0JaamlidDNXNElVazk4?=
 =?utf-8?B?NDFwbWhMSFAzbWdZdGxXaEZ2bnJOMUNXYzFCTTVhRUFSQ2FjQWVxTjdGMTBF?=
 =?utf-8?B?bEtHU3NqYVAwU0hqbVBQQjF0cXkwY2tQeHh1L21wRGJtNUMzSm80TW9SRHRQ?=
 =?utf-8?B?MHI3b01HL2t2UmtpU0ZyY1lNbmJob0QybWNsV2ZITXUwK3VmOVM4NXVtSHpu?=
 =?utf-8?B?SWtWRkRMNEtuT2dXUjY5L2dIWHJBUXpDbUxVeTBHWmtJUXBpUERUQ0lscGxr?=
 =?utf-8?B?TGlpVmRqQUNuSStTcEVBV2pDa2laRzlJbURjbGtiak5UUVJ3NjdWWGJOdGxO?=
 =?utf-8?B?RnNTTWlQL2lXaU81ZjBrQk9kYzI5UDRmcm12emZwdWtVV2hpSGo1bUVBTkFN?=
 =?utf-8?B?S2U1UlpEbkFKOHE3N1ZmZ1pLZi9kNW1tZ1h2ZmVla3R0MFk1S2tpUjVYMXdy?=
 =?utf-8?B?WmZObGl6N1VKZjFRQk5hYUxQRzlTVnl4cGtWMXVBOHBjR2JFbHd4NWhtT0hv?=
 =?utf-8?B?aVFETXV0c1V1MWwwZ0kxR0FBc2lkQk9wRURTd0hmTjNhdWkxVE5NcEhNQzFC?=
 =?utf-8?B?anBaMDFIR1hrbE5ZOGk1ZjlVc2EvcE1NMWZpR0JrUk94Z29ZTm5IVzVDWXNN?=
 =?utf-8?B?WUI2YXc1K2ZQSUhTdzFXZzJEMEk1aElnRmhhNERFYnF4c1VRVCt1eEF4RmRL?=
 =?utf-8?B?OUlrWlIwRU1rK2R1clhsd0pEQm9IWjdoMVp6SFJpenR6L2VGdDM5d083cWs5?=
 =?utf-8?B?ZXh0Um1XQWFWQTFNVzhLK09xZ1podkdMVzdhNmJ5RlNaR1hoQkhzWkEvOUtl?=
 =?utf-8?B?RXhPMjI3MlIvVnNCWUkxTm1ZUzQxMzZOcmhFd3EzYnUySGU5YmFlekJ2OXc3?=
 =?utf-8?B?VEtVSTQ2N1Z5aHM4Rmw5OE9xMmxZdmxPR3pkaWpjQWoyQWNNVWNNeXFhMHdv?=
 =?utf-8?B?RXBsdC81WTlpKzREeWcrNWRHNzdWT01TTzNnUCt6cEJ5LzhRV0N1QVZiRmJ6?=
 =?utf-8?B?dXFhbFNYU0FlSFZPYmJxZWJvK0htcW9kVnlQaWZDK0MxMDI0UktUYTNyTm1q?=
 =?utf-8?B?RjZxYmNwZGl4V21HWTVvVkpHMUVPM25HbWlSbkpTS0RzNnJHblJJeWNVSVhu?=
 =?utf-8?B?ODhDVHhVODNyR1AydWs4S1FTaXZIZlpaU1FOVzgwZmxnWGprTm11RmVhSkY3?=
 =?utf-8?B?bUVlS1J3UmZqdHEzVlhSNWNhaXBneHZWQ3RHNVZESG1YdldOSFFFUDRmbVNW?=
 =?utf-8?B?RDk5YVhrS2lUTURFMUUzbzVJeHYreUY0dlkvSlhTZWFtWkQvWXdrWHJ6YjJl?=
 =?utf-8?Q?cJreMyFOl5c3VwlEOchqQiQk3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 101d30e1-6117-4dad-8029-08dd551e5f58
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 21:58:29.4993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq647goONcA5VohGp+vCbvNT/n5FG7dwnz0uDejgIfqKtyDlMLUcgwAHIBwmMEbgh4zJn8BvozXWLNET7JcYGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4301

On 2/18/25 19:27, Sean Christopherson wrote:
> Mark the VMCB dirty, i.e. zero control.clean, prior to handling the new
> VMSA.  Nothing in the VALID_PAGE() case touches control.clean, and
> isolating the VALID_PAGE() code will allow simplifying the overall logic.
> 
> Note, the VMCB probably doesn't need to be marked dirty when the VMSA is
> invalid, as KVM will disallow running the vCPU in such a state.  But it
> also doesn't hurt anything.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 241cf7769508..3a531232c3a1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3852,6 +3852,12 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
>  	/* Clear use of the VMSA */
>  	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
>  
> +	/*
> +	 * When replacing the VMSA during SEV-SNP AP creation,
> +	 * mark the VMCB dirty so that full state is always reloaded.
> +	 */
> +	vmcb_mark_all_dirty(svm->vmcb);
> +
>  	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
>  		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
>  		struct kvm_memory_slot *slot;
> @@ -3897,12 +3903,6 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
>  		kvm_release_page_clean(page);
>  	}
>  
> -	/*
> -	 * When replacing the VMSA during SEV-SNP AP creation,
> -	 * mark the VMCB dirty so that full state is always reloaded.
> -	 */
> -	vmcb_mark_all_dirty(svm->vmcb);
> -
>  	return 0;
>  }
>  

