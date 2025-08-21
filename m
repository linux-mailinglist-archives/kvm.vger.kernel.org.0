Return-Path: <kvm+bounces-55324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1FCB2FE53
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 17:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD2AB1BC3936
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2BAB2749C6;
	Thu, 21 Aug 2025 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cmaQU1XR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9C25A33F;
	Thu, 21 Aug 2025 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755789669; cv=fail; b=lGaERc3l8eKIFCVOElnKuXsEZVwI5SbmMK9JT9SYHFxBh3mOcgELNdB4+bNfUNbhrpJW00vwHdJ0e/2ZdqVB3tYUyO9z15kuu2/Q/mnN5maq64M3wizNCtPD7j1EwICIVk/OoalFDOUfctBgK5SlkwVbMqJ+zdLdMAb4gJrnSk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755789669; c=relaxed/simple;
	bh=0b0Fbrmcxw3IUIZBMsnvVlEh2+MIbOzaT5qATFkRGFE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q7Yd1EQjLzwBH0Am+F8Nl5r1aNuTugLj7evRzNoWJ9ucvTrHopPjBzWJhKlDl5t9Ti8mfYYVwt79kvJp8MdWgJ3rK7w5CiP3eMy9TPx+p+6COnBK8Yvt2rVHrWPdyB8kFW9lxXlFSG82R3xWLepa4O4gBuismMephX3/Ag4LdS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cmaQU1XR; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SmbdJUPpjd5HK8loxNvaw/mf7qskk6kvpDinnOZ0KVhYPdLXVuiCQKVlwzEH3DktfYgOm+sMAy+62IiciMGSl2ZlZi6THsHiqAino5cBTYDcmqHI+9CcTv4fMYoICTmX1EBEg2icQmmASBKDnnALzh78S+/Ipkfzkmu318z9SKyFYxPTJ2a1UFnB3TIeEwV2yibzwcjVjTdmq8JM3HnW0L653WfGiS8CLfLTWHI0lhx4kR50pK6L+J7tmbLRJLadT+dm876QIj2wDrAtabv79kHphoqobjj9GqffHMmrIY1HoQoO7bu0f7aL6dbdtBUKbSGYsVRvw5/3O9x7sCL6XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWNX293L3gXfJona+ntdNT2rRv2Xd3NtVd19oojKliE=;
 b=FJl7e28yzNSizk8apAIxlSqFN+ySfezYTGbjstI8CWbrwo/UIvbtpZjs12MUCBTfFSFhOy8p4vTdOvqVjR9cvjXjimUYMuPsZtWUuCX7KgaYBHIPVfeY5sS6ANe2eKdTU64lgfxqWDExru4B99bOtmebm7h6uekfQz9y4SD9OkhbaZ7asnA6O41V973m1tSEIozXGRxWMNottMp7GOT5Hlo6RLO70W7J2mkg0szlOIenvrstMp2c6dyJR/W+34L4zrESHCRwSMh1ozI8he/n+Yw9bWtoYE4x/0JU8kwOSjfnwMzJGMtJ2sT8xJvBURFgs4tQvNdcy5lyn0iHqiLUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWNX293L3gXfJona+ntdNT2rRv2Xd3NtVd19oojKliE=;
 b=cmaQU1XRAMVcNkvj2OKN+pVWw2AKOwROm99dwBurhybqQ5CYa9HDNGDBDZ2cG0S8MDAiMGkafmdfugq+KavBPM4t9Ma5JRD3Tdhbr0baC2NsfNF90uxq/Jr/lmFWJqhPniIzP3ur5pLmzDFUGuelF6l0cTnL7XwvCDxKM76tk5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB5815.namprd12.prod.outlook.com (2603:10b6:8:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 15:21:05 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Thu, 21 Aug 2025
 15:21:05 +0000
Message-ID: <24fde6d2-6676-48ca-bc2b-c43b87aa1468@amd.com>
Date: Thu, 21 Aug 2025 10:21:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Sean Christopherson <seanjc@google.com>,
 Kim Phillips <kim.phillips@amd.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, herbert@gondor.apana.org,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org,
 michael.roth@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1755721927.git.ashish.kalra@amd.com>
 <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
 <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
 <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
 <922eaff1-b2dc-447c-9b9c-ac1281ee000d@amd.com>
 <db253af8-1248-4d68-adec-83e318924cd8@amd.com>
 <46cf87e2-8100-47ef-b19e-f6a1b76f660d@amd.com> <aKcpu-EilR04YAxX@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <aKcpu-EilR04YAxX@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0075.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::22) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB5815:EE_
X-MS-Office365-Filtering-Correlation-Id: dd50654b-53e4-4ccf-9f99-08dde0c6588a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmpBcFphREFzZGxFUnRkK0o1VVlMMUxDUDRMM0crTmowK0ptaUhteGpPRnR5?=
 =?utf-8?B?R0VtSUJpTVVOK0RaU0M5SER0ZUIzOEhrOGNhNHdOUVZabHhJa1lrUHFlc3FC?=
 =?utf-8?B?QXRXYjlTNHd2QmlUZTYwdmQ2eElLOHZFdlJWMjdmOGdkN05jR25OVmcvVnds?=
 =?utf-8?B?KzdSOVo1OFQ3VnNhWFNGd1JIU1JEeCtTVGE0czZwMWVFaGliV1IrbUVmYnB4?=
 =?utf-8?B?cnBDRm1yd245dlFxTXJnamFYM2VvcFppaGdPYVlnZURaQXVLb0R3emNpTE9J?=
 =?utf-8?B?TjBlVVE1cGlQRnBLVWgrU2wyakRUN2wxdXVrbVZ1ejVHcGphVlFLYUJZVitj?=
 =?utf-8?B?U1psb2VRRVZwaUdDQUNwN1MxZTZXWVlNNE0zb1RSMTFYdXEzdzZjVFNBTUd4?=
 =?utf-8?B?TjlFcjI5RkFFWE81WDVya1BFM0RBSEVya2tZamxaT0FhbTF2NWRYU29zRmFz?=
 =?utf-8?B?VlhUWFdHQ3pmVGZhRTBkUFZYeHRKcHMwVy9sbUpPdnVJaGptMU1tenlvKzV0?=
 =?utf-8?B?Uldnamd2YzN6cmk0dDVqM3Bvd2lobmc2UzNSZnR4V3BRa0kwdFRoWElqSFhk?=
 =?utf-8?B?TTM3OVhTYUpKYUtteVBNam9zVEV6ZVVQRkFaVlhuQ29Qa3hlNXNKV2JUME52?=
 =?utf-8?B?MjA2cU5wVEN2UkZucytZM2pPc3dhQUZSQk42NWJFdGNRNGNJd2lDc3o3aDhx?=
 =?utf-8?B?WG9TTTFrSmtyd21zYXhBcnd4Y3BUd0QrdVFseXl5VHNyVkdIaEFoMGRnZG0r?=
 =?utf-8?B?b3BjcXlJUEpkTmF2cjYyNnN2Y3ZidUVnZmNvTkkvL1crNlRDeDJYZTJZZ29K?=
 =?utf-8?B?b3dYeDVvUlBMNi9Xdit6ZnhoMW43VUMyZWZDTDdveFRLRWJPcTY0WXVBN3Vq?=
 =?utf-8?B?RlQ2ejlTY0N0aFpJWVA1d2t3TkVSTG45d2h5RnkrWkNhbnIvNzMyZkNjNERp?=
 =?utf-8?B?WHg2aWlmMDlRTE5QdU95ZUtsbzI2ZWxjcHdhT3lMMnJDQnNiS2QyeHRzUXhN?=
 =?utf-8?B?NlBlTnFyNW51VHlRK0tTSG83czA2TG1reEJGTmdKVDJwdkZUeVRaNUtxYWVn?=
 =?utf-8?B?blg4dG9wdjJmbEo1RGFuUHBRc2I4OGlxN3JDK0hBOEcwUkxhVmhhWXdxU2Zu?=
 =?utf-8?B?UUkxWGVtQzB3b3JoMnZUR3RBTUpTbGpCWDUxbzBqQUQ1MnRKQXdXUTNHMkVE?=
 =?utf-8?B?d2dnQU16MjhhdGhCWDVhcldkU21JRFJnUUxybjRMNW91OEtZM3hRS0dkaUlr?=
 =?utf-8?B?SkJwOXZjUjJUYzFYU1JiZFRiSEc5ZEF6eTZONDZCRGpxVVRjRFBwbGlSdmda?=
 =?utf-8?B?USswbFRKTjY4TFRKQTVZU3ZMZUxiRG8xTXpyYXRrZkNJUlBJT2U3R0xEZThT?=
 =?utf-8?B?TlNDSUJQeTlzTEk4RjBldHlRdmZHUkhYNE5ldWk4VkVRNkZua3ZRbm1pNUpr?=
 =?utf-8?B?THdTMDFiWGx2b296K082cGdsS3JyUUQzaXJRSEV1VGFSaUVSUDd2QzJ1aVl6?=
 =?utf-8?B?VVZHYzhiSENkRmZKOHBScktVTG9Lay8yOEJjNTlIN25GZXFGKzdHVU1hZ3lE?=
 =?utf-8?B?cDV5dXA3SnkyWk9heEl5TTIzS01wOS9UTm5odis2MkxycXJzZ3M0YmEwS1U5?=
 =?utf-8?B?Y3VvNkMrNG8zR3VKSk5nbmEwZWxNTko4ZGZHQ0hUd2JjN1BockF3d2ZzVzB5?=
 =?utf-8?B?U25GUVFIY2RDMEkrTFpHek93QTU2KzM1U3dwZE8zbUxDQ3I1UzEyeGdCQWd1?=
 =?utf-8?B?M3RxRVpBa1ZkR2liZVFFOTdnWDJXaHJmY2drc1RTcUd5TXpURUZ4bUZmRDht?=
 =?utf-8?B?TFkrUzg4b0ZQTTFyYWxvMzdDVW8vdm9JUFlYak05REJvWDVGQkRJOG9iL2l5?=
 =?utf-8?B?MVpFNjhhdFJINmxVaUY1OEdwSHpPZGZIN05SREdHSUhubW9OQXJ0c1JrOGJw?=
 =?utf-8?Q?sr1GtCnT68Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGJrYXBVK1RGbjZmNExYVGFkd0JTdVhMbWdoaWpab1BIM29MTFdOTjhHZ1B2?=
 =?utf-8?B?ekM4QWl1ZkpFbk9nRC93elBjUmRqVGVjelpJcVRZMXlJNUlPc2ZmQzNJMHJm?=
 =?utf-8?B?c20xOG4ySmE0Y3JjU1NTaU02bU5DVkZoVi9RVWlNNWtQSXVNSStFM1V0QUs4?=
 =?utf-8?B?a1pVZldsMmwwTWhrY2NJVWE5QzkvQVIzMldrQUxRT1BFQTJkNmMxc01jUmx6?=
 =?utf-8?B?UUovaTdBMVI4Y3BRcUJhYWwyS09QZDNmZ0d5OUg0ME8yQkkyNW93L0dyZ0F0?=
 =?utf-8?B?c0VWRHAxSXVUU0dSQjN2RUgxdFV3Q1QyTVBTR0NFYU9QK1htWTN4anRnZ1JL?=
 =?utf-8?B?UiswUmNsVmVxTWJWV3d2OWt5OHl2WTY5c3Q2bXgzUWVtMTRYOXowSFdqdHNm?=
 =?utf-8?B?eForZ0pJWnZHVWtGbk1YbmVOQUtuSlNjZFNGclRmK09NNkxmRnUydTFOM3hR?=
 =?utf-8?B?UmVSUWY4SVZuSXd1NWJqT3VhNEg3bkp0NlhVMzRwRGRlK3lDc2ZuaWZXR3VT?=
 =?utf-8?B?ZStWSnNRTG5uM0M1Z3BuM2RmckphdVdsWmxBaXh1OVRzajE4VG04QzJPK1E3?=
 =?utf-8?B?MHFkekQxTXNaOUkwb1o4aDBoYktHMjRtN0tRY2hJenhIcW4wM3NxaUJXWFZ1?=
 =?utf-8?B?dTlacWlITEdXeHZQdG9TZ3BCTkpORkt5RDZvZzdYQ2xZTWJIREQ4SFp1SzIz?=
 =?utf-8?B?Z0dPbmlKbUlySFdJMFUrdkJwZXJzY0lneWlMbmo4TVZnaVJ1aDA2NURvSmdy?=
 =?utf-8?B?M3NhaGZyR1cva2Q0b3oxVWVPcEFtR01IdUdLTi90R1NMNlVBaEZoTFY0ZmtZ?=
 =?utf-8?B?amNaY3VlVG5sODFhK0xwdld4RW1ZYUNUd1JrVzNvQnBqN3JrRlZydEF4ZE8x?=
 =?utf-8?B?NEJLZnFCNUVJSnFwdHlhV29vcGE4VUVndVgyUVFvMjBkVEdiQ1A3RktIWUpo?=
 =?utf-8?B?Kzg3SjdGNzlRck1TTjVnZFFYVk5qSnFaVG9SMS9jY3UydVlQbUw1d1V3UURa?=
 =?utf-8?B?VTBWTmlJMlp0S2kwVmlqdk1BWXNsOS9yTTU2UnpnY1JUUVdLTldmL1k0WjRS?=
 =?utf-8?B?OE9sanA2dStxM2pNWmV3SkIwWWVrQnM0eGZGcEFoY2c3OUZZRkx4M2hNd3Fx?=
 =?utf-8?B?aUZUQkwwZ2VoajUxNURZekpDQmk0OTRlcFdvTnpkMkZTenJpeTcwOVp3YWZk?=
 =?utf-8?B?c0x6Y3dieW9pUGY5bVMxazZBQ1kxZkJFbDNOL1JUYUtrUGpha0crYmx4ZXJy?=
 =?utf-8?B?YWY3RERnKzJNRnhnUnF5U1VYdlZVL01hRDFQMkZ0a3VGajFROHRNVnBadi9y?=
 =?utf-8?B?Zm5lSzR3R0xHbDRqOHNLRW9iMVRJamRvRkRxNndIVlZ6QlRmMkpuYUNRM0pY?=
 =?utf-8?B?WFp0TGR0NkVrSXFhUklGL29yVEdFTUZhcllrZWRaSzRDeTgzbWs1TnlBKzU5?=
 =?utf-8?B?c1VhQ1h3cXFyZThGVkFEUFJUSS9Ha2Y1dS9CMEh3RFZGMmxSRFEvWXhZQ1Fz?=
 =?utf-8?B?S3NEZFF0NDArRGdLUlE3b2hBQW5NRGFIb3QrUDZtZC9VTEVTME5IQ3RmNUZN?=
 =?utf-8?B?NDJGSmJtMG9UYjhlM2FXSXlqRXpOeGF4T1VmZFIrK3lNeU1MQmpyN215K3N4?=
 =?utf-8?B?WDAwMG4ySG1mQ21FZlBzdHg4RzF4NVE1bzg1S0xkNE1SOVJvZWM1c2JITGJE?=
 =?utf-8?B?Z002RmFFMXFmc2RMY0JjekRpbnJqSzJlaGpVTHhaRmNpTTZ4Y2hyck53NWx1?=
 =?utf-8?B?T3NFbVhMWmJMQ2gyWG1nN3JtYXpvMVArREhrZGlVbUlEOUtLVEtqWHR3NFlD?=
 =?utf-8?B?NzlhaG9mVzVGQ2l0WHdvVlVFWldXWkJHWjc4TjZPaTlzVlM4Qk41S2oxQWpV?=
 =?utf-8?B?cVRNaW1LaVFDQUdRRTYxd1NDTmxkaEVObHF5dXo0eXFuak9NZ0d2WWJycmtG?=
 =?utf-8?B?TkpqWlkvZlYxSkpQOU5jMm5KSENPRm14RGozNW5KNW9xLzJKMzg1S0R6QVBu?=
 =?utf-8?B?ZnpZNUFwVnFoWEE5ekpsczRlL2ZoM3NKNFdQSlhjUlM2dE56NlFkbFhFRmxY?=
 =?utf-8?B?WmkwSXBhMCs0OS9IZkdQTm42U29NTXlKMmh6a1J2WjdkYjRUeTVsTm5uRTBF?=
 =?utf-8?Q?ha2WFYAA/p69BiHhYg/gJccen?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd50654b-53e4-4ccf-9f99-08dde0c6588a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:21:05.2433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kl0a3I80Yn0WSvl/e0DweTHefV75cmi1gnRkz03j+GwV5fEvFn13N1N+Qwmae5cTB/rnbLQqgLL3duqO9Kr3bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5815



On 8/21/2025 9:16 AM, Sean Christopherson wrote:
> On Thu, Aug 21, 2025, Kim Phillips wrote:
>> On 8/21/25 5:58 AM, Kalra, Ashish wrote:
>>> On 8/21/2025 5:30 AM, Kim Phillips wrote:
>>>> On 8/20/25 6:23 PM, Kalra, Ashish wrote:
>>>>> On 8/20/2025 5:45 PM, Randy Dunlap wrote:
>>>>>> On 8/20/25 1:50 PM, Ashish Kalra wrote:
>>>>>>> +        /*
>>>>>>> +         * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
>>>>>>> +         * ASID range is partitioned into separate SEV-ES and SEV-SNP
>>>>>>> +         * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
>>>>>>> +         * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].
>>>>>>                                        [max_snp_asid + 1..max_sev_es_asid]
>>>>>> ?
>>>>> Yes.
>>>> So why wouldn't you have left Sean's original "(max_snp_asid..max_sev_es_asid]" as-is?
>>>>
>>>> Kim
>>>>
>>> Because that i believe is a typo and the correct SEV-ES range is
>>> [max_snp_asid + 1..max_sev_es_asid].
>>
>> It's not, though.
>>
>> [max_snp_asid..max_sev_es_asid]
>>
>> and
>>
>> (max_snp_asid..max_sev_es_asid]
>>
>> are two completely different things.
> 
> Yeah, inclusive versus exclusive (I'm quite proud that I remembered which was
> which, _and_ that I got it right :-D).
>

Thanks for that explanation.
 
>> You also modified Sean's Documentation/ changes.  A consistent "joint
>> SEV-ES+SEV-SNP" is preferred.
> 
> FWIW, I don't have a strong preference on the exact verbiage, so long as it's
> consistent.

I have consistently modified all "SEV-ES+SEV-SNP" to "SEV-ES and SEV-SNP" inline/Documentation and commit logs.

I will post a revision fixing the comment above (if it is needed, unless this can be fixed during merge).

Thanks,
Ashish 

