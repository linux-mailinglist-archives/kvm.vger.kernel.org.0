Return-Path: <kvm+bounces-41985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34380A70874
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 18:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8568F1761B5
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF69263F32;
	Tue, 25 Mar 2025 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bMxxJcjp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8246A823DE;
	Tue, 25 Mar 2025 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742924974; cv=fail; b=Zsku239gfN+Ker6Ubyzp2Uez8nlRe/dFShS06ebrIdzZCAH4cai5jgGtgGfgDeCCtq7Qr8mxuUEy+2TZt4IVRodcG4A1opuKqCTbu7WHXSGlyuZHAoj47x/iw1z7OrAQP/mjf7l5tTWaLUNiQ1QPw8SiyFPITbJNxdqprPx9C1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742924974; c=relaxed/simple;
	bh=g6LFBq7jjMkmu2BcpASXaVtEISiJD66JSFdr6d7TnwQ=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=kEiXmXdKFZOVurhbRc4UbQbU7KnzXUYow70PzbMu/lgDzBimtsDyNXqRQNDOw3P3/iaZFgj4fVKkkQCtAbVhkPmff7/lXIuupCOZVSo4pKRVKhzNgovCNhaGvalzzL4wMfChHwnbcH+6iIb2djIiLKDEnabBhSoGnRiZ9a6ykiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bMxxJcjp; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0T7pv5kVYa8WKmVb/hzlyqD9OXbLs95Ji+NJpdLHyKdDFtksuWxl92+bPbmihQ7KtT2SLDFhodc3tgUB3UJM2WZKxjrjWgAG31Rbu7OM9S5ieyb2jG6y4rDgy8ptv5qYCb46RtW0A+h2PM5K+VKyA1LLgXVWXkOEJFYvYBiXgzi4UynTArmkoVx8HNtxfjsbobjQdmJKX6/CAAoTdO7U7gfhVrdGDrMW3ycERfU9+x3x+hEMVf6q/4y8VhV/1mA9COF94MuohuYu8+jNSaC9YBGhMQV1q91s4DJGwXlEwKj6fwjB1w5mjIK9NwcqohMHVrjGsOzE3F8NR8bl3rZ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbGOMqp/fwjcyFBnpt9X+vGK2VIxs48dRSkpYBEEUZY=;
 b=oCIJzZ8hiKXI01qD8iVZDr9u45Gd3JBAiafKrShiW7VrQ2vVHgcEG1VK3zYzEIYTb8K5UDQfmj+Z7HMEa0UlExaC1YcACJnfIsA3NnLVs4jbP9+wKnHlTAltJgY8beLtsVYiY++zmv+WmQoA4Kna4Y4BxozIGKHgOP1iSZhMDT2UXvWcSwLBV75vZ2c+hifUTCR+2xnMrkP5ZjeOgGHaMwDfoKGTymx5Yd/LXPSSc6f7WxNB91El5Fd1pQVXoakwBncBfYHkwLqxV6rSzO8Zq2YvEpAkkDP5fQPmy2G4+kgenuW96xM5oaEIWMb86XCC6Q2tYjqdsBQV5dp4x5N3PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbGOMqp/fwjcyFBnpt9X+vGK2VIxs48dRSkpYBEEUZY=;
 b=bMxxJcjpQJmIVUj38tr6GT/eLTF5aiHK2GtrTidmV2MQwnuK88YOSpBPz48n9bVT1HZ7fqUIQU8BfN75f5nm0wSSeBHGDVK47DHzpYVzyP66kZjTszv4UDY2GOCaLyKJnTeA3l1ZpPzOeH/M6B9Pbq2TA/oOLk9x56VFcaLAjJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH1PPFD8936FA16.namprd12.prod.outlook.com (2603:10b6:61f:fc00::624) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 17:49:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 17:49:29 +0000
Message-ID: <9a36b230-bf41-8802-e7ba-397b7feb5073@amd.com>
Date: Tue, 25 Mar 2025 12:49:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
 <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
 <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
 <29b0a4fc-530f-29bf-84d4-7912aba7fecb@amd.com>
 <aeabbd86-0978-dbd1-a865-328c413aa346@amd.com> <Z93zl54pdFJ2wtns@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
In-Reply-To: <Z93zl54pdFJ2wtns@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0149.namprd11.prod.outlook.com
 (2603:10b6:806:131::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH1PPFD8936FA16:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f86cc1-34bc-4b62-c4b1-08dd6bc5645e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3p1V3E1TVVtOXEyUTVmTEM5ZlBtSDhpSzBoSk50bklSVFEvdmdneGdWRDRD?=
 =?utf-8?B?S2ZNY0RXSlhaQ29OdllLWG13V1hiSG13RmN2emhSMHRLM3RPNTdERFdZeGwy?=
 =?utf-8?B?dSs0aWJhcDBBeDFXZHdWUElpY0lLYmRNQTBqSHVRdndHRitJRDNQbmlTUTZu?=
 =?utf-8?B?OVluU05FcDh1dkdqRWNOeElNK3FnYk1Sd1lVcXlHeTNRcks2RUJQTkVPZFQ3?=
 =?utf-8?B?WVRXZHlMZ3hsa05pakh5T1Y3ZHNUNW12aHFiYzZLbWMwVGtwdktGUElPODdF?=
 =?utf-8?B?TmlsUWFyd1plTmpydjFTZHNuVFdZbFVLWjA5aHhPTVdoR2tPZ2ZoTVAxOUg4?=
 =?utf-8?B?cjBvNTVBV2FrQXNYVExiUGxoM2JjYTFlUXRsUEUwaUFObHVoQWwvRFUxUG9p?=
 =?utf-8?B?K2w2dXVCV2xsZHc4SWFEZTVoSk52Kzl3SzlHMGJhSTVqS1RhVCtCaGVSak9m?=
 =?utf-8?B?eWVSVEwrcXJ6dFQvRW1xYnZJQlBmVkEwWDJ4WVlIU2trNE1CNFIzSEtJWk1X?=
 =?utf-8?B?NStGVEdsZTBYT09pTHlhQVdETGtUU3o1dGhCWlo5Y21jdHpOejFVUk9xeUlN?=
 =?utf-8?B?VFpYRFJLcUM3RXpFTVRhcUptcWY1YjlaTDVhVEFkcEFrb2x0MXNvck44MEZV?=
 =?utf-8?B?aW9nYXhyK2JjZ3ZnV1NFdDVqWjRETnZBT1VYaGIxUlBoM3loV0EvSXVBZkI2?=
 =?utf-8?B?dStkdU15M3FraE9PWFZNMzR4cTltTEltMVRGK3pmTHFlTUhjNkN5bjAzNlZX?=
 =?utf-8?B?SEtYVDFsY0dBa0pGTFFGdDhoNERVbU4wZWcyMnp1MHlKa0ZxL1MwWUFHVC9y?=
 =?utf-8?B?YWlWSFJNN0t6QThrL1FzeWNNZkNpRzdiMWlyOXNCOWxDZDVDWWEyZ0JoekJ2?=
 =?utf-8?B?enR2bFpKTHF6MTdLTVBxV3Jvd2tvaW1KR09weGV5TGVKazE5YUlGenQ3ZDVq?=
 =?utf-8?B?VE9rWDA5SVlKdGRlTnN2cXROYW1lMTdzM1VOWjhvOGhIN3RnV3hheFpDK1FX?=
 =?utf-8?B?Tk1nWWNWa0Z0dC9vdXYxamNEWXQ5QXN0Vk9aVWVUblhuVkxoVEZxRXRwUmhG?=
 =?utf-8?B?Sk9lcHloRmliZmRXV2IxbWZGNUEralRCMXo4OU4xMnF5aGpWNmppbXBsZHB3?=
 =?utf-8?B?WmFRNVY2NHNrSDMzNGhrVnFkTkxNQkgvRm1kaGk5MFJ5bkorMEE2S2g4N05v?=
 =?utf-8?B?ck1DWFQ3NFR1REF2bUFWZ3EyRDBDWWljSmJSVjBFRXBBWThuWWp6ZWR5RUJY?=
 =?utf-8?B?ZXpmSlNzTy81MFNFUzJSODdDSjg4WFhCSmFmZGRPMEMzREZLQmd4QWdRZDdx?=
 =?utf-8?B?Vk1MeWhaVkdQWDhZeXpXQW1xMFJhRlBtZ0V5cjhSZTZ3VzdScUE3aVhiSWow?=
 =?utf-8?B?ekV2UlJSY3JqQTIzNERVSGJuc0Z1dVVya1NybUJ6Q1Vqa3B6MmUxNUVudzZ5?=
 =?utf-8?B?TXBTTjBxZFQyaDlmN0hoeHQrM1M3Q3lRUzYvWnEzOXpmKzVZWE1uY3o0Nk9u?=
 =?utf-8?B?NUxFRkRrUm5pd2YxcjFyRi9DQ2gwY05Gb2hlOVhVSGNlN0JvUWhhREVVY1hZ?=
 =?utf-8?B?WnpVN1NlM2JlZXJkZENva3NDbS9PWXYzMUltbUR0cFpoa3ZiY3BaWDlwTEd3?=
 =?utf-8?B?M2V2bFUzSVVZMU9GT0lLcVAvYVcxQ0o1WG4xSThSNkxtZGhBZzR2RHdMT2Y0?=
 =?utf-8?B?cCtWQ0FxZzdLMks2b25HUmRYS25odVNmVjdjcXFjOEorY2Q5N3Vkd1NVYllW?=
 =?utf-8?B?MG9rdDBOL3ZUditMWmYvU2hZSG9IdS9pRXJmdlQ1S2hUcXZid1JNN2h4N2Zu?=
 =?utf-8?B?eVpnSnVIVlBna2RCY2NJY0dpSDJWT1NwajZYOGsrNmY4YVE3VmR0Qlh0b0pa?=
 =?utf-8?Q?tccOykgjg0bfw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUhZRlFWczRoNkt6ZG1aY1pPUWU5SENDKzFSMktzQ1lHc1FLdHV3RDF5S2pJ?=
 =?utf-8?B?akd2TW9heDFvalJWNHEzUVRRK2YwREFZT2pEaklhWkc2Q3FzV0V2b25UWncw?=
 =?utf-8?B?SGFmK0FYVDhXZGRIa1VHTjA1WFRVQk9lTWkyYytKendKcW1QbFpuK3FKRFBJ?=
 =?utf-8?B?VWZvcmtxQnRNV1BPMHZpb2dYRUNDSkthR2ltUDdBMmhTUjdGc2lqVTdwdXo4?=
 =?utf-8?B?S2Z1ZDQxby9za1MwV200RTROV0Izd1owM1hJSW9XbUU4RGJmdGdIRFFva0tS?=
 =?utf-8?B?dVRuS2ZhbGVQNFJmT3E3TGhuRmJFNUJKeGxVNEdjblNXYy9zSDBsUE5FUGRR?=
 =?utf-8?B?d1lNbG5HWUYzZjlvMDN2OFJOcWNYcHRDbnlwYmMyY0xXS2dyWTNlVStMQmNF?=
 =?utf-8?B?VnN2NzVkUmJibEhQbnpoRU1EeW03VElHRE9DVnAzZjdhcUVZL1paMTZVblE1?=
 =?utf-8?B?TnFTWUhsbjkwL01sejgxNlkzWHdvamNBYlJiZkdSSzVEVUlGUFlYditnSHMz?=
 =?utf-8?B?SEtnRUpwdGh1bEdSS3g3Zll3VDZyLzJLNjF0a0F5MHNXeDZOK3JtRzQ2cGx4?=
 =?utf-8?B?RzI5VVJNTXRKYlF4UEdRVSs5OXVmQ1hscmExb1pZT1E2eGV1ZTB3V1hvYjhs?=
 =?utf-8?B?Y0NRY21SSjZ1Z1lrMUxBMVpnMnpJa3piQW9WS2ErbG9VNWVmajlrdERianQ2?=
 =?utf-8?B?cUVrVDBBY1puTmNNMjJNV3hNZDBlelpmUWl6OUs3TmdUUFVSdEdZMlVrTnly?=
 =?utf-8?B?NlNjWUovMGxRbkVlaWtiTDh5MkY4Z0Zrc0hJaW5rb1dLLy9pLzdGcHVEUHJn?=
 =?utf-8?B?c3J2S1V5Y1Y3Wmx3cDNzQXpSdC9MZ25jMCtJblYxQlVzV2tGVWx1QWJXK3VX?=
 =?utf-8?B?RUxscThqem0wR1lGTkp0OWRrRnRJT2JhRmM4T1hJWUFJLzhJaGQzV0lRU2dQ?=
 =?utf-8?B?ZHhSOHRPUFNBMmV2QzQ1aThvM1hocjA3dDJLVnhGenNVd3dHUnpsVmtJQ2hP?=
 =?utf-8?B?eUtmekN2YmU2OE9pOWdyenF5azlHMkRLZUlkYThuei9CNXFCRkpCa0U1djBt?=
 =?utf-8?B?SVVtTXl6ZE8yMlM0T1MwSkVmaldPV2F1czh4YURVMDZVdzZsMXRqdHdKd0dW?=
 =?utf-8?B?ZnFvcmtybkdNanNpUktsVWRuN3l1VnozZXVERUVvMjhXRnJBQmxpQ1N3VWZm?=
 =?utf-8?B?MTAvUXZPWHNrRTZjQ2V1eWF1NDJOMkpnVGZxUGViY0FmcWdGYTQ4N3pwY3lv?=
 =?utf-8?B?bk5kT1VKM2R3TUg1c3VBZk0rbWMzejlsNlROMlJRTys4WE91TVl4TGFQdXFM?=
 =?utf-8?B?TlRuZ2RhMFJPeFFmWFRXNzRyNEpFL2RBWk41dnFDRXVkSGs2dFd4Sm40OHcv?=
 =?utf-8?B?eWRHS0ZqWW1ZSzJJR0NrRmJCOUVsdVdDR29iVFdMTGdyQS8xaXNhb3BOc3dD?=
 =?utf-8?B?bUFxVlVOK3o0WGtOZWtaZGpSMzYwRnpOQ05aOG9jZUhrd3RObFBEYmpUaGRn?=
 =?utf-8?B?bVZmK1lqcC9JNE1icC85YjFYVmtIV1JSb3Z4UmVaMy9IdjBvekJzUVM2SkJU?=
 =?utf-8?B?VWQydGx5ZUpXOVkzMmlQSU9jLzVDNTAwaWpod01ES0FKQ21SU1ZQRE5laG1P?=
 =?utf-8?B?czBDUlFzZHM2a2tMUnRaa29zNUxJWjVNZVlPZzJFSXp0TUZsSjBQZWFNKzQx?=
 =?utf-8?B?ZytOTDBqRFVmZUoxMjFNQWZHNE1IMDNOSmFCZGZ1OHQrMVM1Z09XUWZIWGJW?=
 =?utf-8?B?aTVzTEFBZEtHSS9oSElxTnVDdDMvZVBXWXpxdTRzQkpTditwNTVvNi9sajVl?=
 =?utf-8?B?L0dxK2RUSCs3MnFXQ3dPS0lmNCtlWkhGYy9oYWpQQng2ZzN3WWVtU0xyTmZJ?=
 =?utf-8?B?SGgzKzQ4RXRlcTMxZGl6U0V0WWhHVkgvWG1nM2RNVzJMQXMybWlnM01DMGdy?=
 =?utf-8?B?b1ZnelJGTlBEd2RRbjBVeVhSRzVkcTJOUXgxSUhXU0w5cFdXVTZqYitQZU5V?=
 =?utf-8?B?T2JGcTRIWFBoUkc5T29nandmRUYrMENacDd5TkpIazNFVzVhcjFGYk1WdUVq?=
 =?utf-8?B?SjlmQUd2M0FSaTN4Z1dLT3JVN1g5TE53RTYrQ3k2YmlFeFlBTGlqQ3k1anZm?=
 =?utf-8?Q?C3mCW7cofUDO9uuEzIoz/J0Xn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f86cc1-34bc-4b62-c4b1-08dd6bc5645e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 17:49:29.5231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: moXwPIOSG+5CSvpWHa522x2EkFZe8Uc1mv+TVERYYCwbWYe5D/iVOGXC637cJzCoRHcJL4xHEbIOBPTuSus7hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFD8936FA16

On 3/21/25 18:17, Sean Christopherson wrote:
> On Fri, Mar 21, 2025, Tom Lendacky wrote:
>> On 3/18/25 08:47, Tom Lendacky wrote:
>>> On 3/18/25 07:43, Tom Lendacky wrote:
>>>>>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
>>>>>> to be annotated with KVM_REQUEST_WAIT.
>>>>>
>>>>> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
>>>>> This is much simpler. Let me test it out and resend if everything goes ok.
>>>>
>>>> So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
>>>> me try to track down what is happening with this approach...
>>>
>>> Looks like I need to use kvm_make_vcpus_request_mask() instead of just a
>>> plain kvm_make_request() followed by a kvm_vcpu_kick().
> 
> Ugh, I was going to say "you don't need to do that", but I forgot that
> kvm_vcpu_kick() subtly doesn't honor KVM_REQUEST_WAIT.
> 
> Ooof, I'm 99% certain that's causing bugs elsewhere.  E.g. arm64's KVM_REQ_SLEEP
> uses the same "broken" pattern (LOL, which means that of course RISC-V does too).
> In quotes, because kvm_vcpu_kick() is the one that sucks.
> 
> I would rather fix that a bit more directly and obviously.  IMO, converting to
> smp_call_function_single() isntead of bastardizing smp_send_reschedule() is worth
> doing regardless of the WAIT mess.  This will allow cleaning up a bunch of
> make_request+kick pairs, it'll just take a bit of care to make sure we don't
> create a WAIT where one isn't wanted (though those probably should have a big fat
> comment anyways).
> 
> Compiled tested only.
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 5de20409bcd9..fd9d9a3ee075 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1505,7 +1505,16 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> -void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
> +
> +#ifndef CONFIG_S390
> +void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait);
> +
> +static inline void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> +{
> +       __kvm_vcpu_kick(vcpu, false);
> +}
> +#endif
> +
>  int kvm_vcpu_yield_to(struct kvm_vcpu *target);
>  void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
>  
> @@ -2253,6 +2262,14 @@ static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
>         __kvm_make_request(req, vcpu);
>  }
>  
> +#ifndef CONFIG_S390
> +static inline void kvm_make_request_and_kick(int req, struct kvm_vcpu *vcpu)
> +{
> +       kvm_make_request(req, vcpu);
> +       __kvm_vcpu_kick(vcpu, req & KVM_REQUEST_WAIT);
> +}
> +#endif
> +
>  static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
>  {
>         return READ_ONCE(vcpu->requests);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 201c14ff476f..2a5120e2e6b4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3734,7 +3734,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
>  /*
>   * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
>   */
> -void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> +void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait)
>  {
>         int me, cpu;
>  
> @@ -3764,12 +3764,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>         if (kvm_arch_vcpu_should_kick(vcpu)) {
>                 cpu = READ_ONCE(vcpu->cpu);
>                 if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> -                       smp_send_reschedule(cpu);
> +                       smp_call_function_single(cpu, ack_kick, NULL, wait);

In general, this approach works. However, this change triggered

 WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
	      && !oops_in_progress);

in kernel/smp.c.

Call path was:
WARNING: CPU: 13 PID: 3467 at kernel/smp.c:652 smp_call_function_single+0x100/0x120
...

Call Trace:
 <TASK>
 ? show_regs+0x69/0x80
 ? __warn+0x8d/0x130
 ? smp_call_function_single+0x100/0x120
 ? report_bug+0x182/0x190
 ? handle_bug+0x63/0xa0
 ? exc_invalid_op+0x19/0x70
 ? asm_exc_invalid_op+0x1b/0x20
 ? __pfx_ack_kick+0x10/0x10 [kvm] 
 ? __pfx_ack_kick+0x10/0x10 [kvm] 
 ? smp_call_function_single+0x100/0x120
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? migrate_folio_done+0x7f/0x90
 __kvm_vcpu_kick+0xa1/0xb0 [kvm] 
 svm_complete_interrupt_delivery+0x93/0xa0 [kvm_amd]
 svm_deliver_interrupt+0x3e/0x50 [kvm_amd]
 __apic_accept_irq+0x17f/0x2a0 [kvm] 
 kvm_irq_delivery_to_apic_fast+0x149/0x1b0 [kvm] 
 kvm_arch_set_irq_inatomic+0x9b/0xd0 [kvm] 
 irqfd_wakeup+0xf4/0x230 [kvm] 
 ? __pfx_kvm_set_msi+0x10/0x10 [kvm] 
 __wake_up_common+0x7b/0xa0
 __wake_up_locked_key+0x18/0x20
 eventfd_write+0xbe/0x1d0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? security_file_permission+0x134/0x150
 vfs_write+0xfb/0x3f0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __handle_mm_fault+0x930/0x1040
 ksys_write+0x6a/0xe0
 __x64_sys_write+0x19/0x20
 x64_sys_call+0x16af/0x2140
 do_syscall_64+0x6b/0x110
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? count_memcg_events.constprop.0+0x1e/0x40
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? handle_mm_fault+0x18c/0x270
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? irqentry_exit_to_user_mode+0x2f/0x170
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? irqentry_exit+0x1d/0x30
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? exc_page_fault+0x89/0x160
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Thanks,
Tom

>         }
>  out:
>         put_cpu();
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> +EXPORT_SYMBOL_GPL(__kvm_vcpu_kick);
>  #endif /* !CONFIG_S390 */
>  
>  int kvm_vcpu_yield_to(struct kvm_vcpu *target)
> 

