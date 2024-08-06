Return-Path: <kvm+bounces-23387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0361E949364
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84B2B1F223FC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD5B1D47A2;
	Tue,  6 Aug 2024 14:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KWmNbfp8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E5D1D1748;
	Tue,  6 Aug 2024 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722955179; cv=fail; b=rriE75JZPkaB2HKXSOzq3qcyfmSFkS02i0omfXQfp3ydkn1Xgto96PSgC9CIRYkI8KNLeG0c0Gk9H3nsXkgmCoiggM+z9PePu8eIcFuR2BMmXv4dy3w9eJhNQuBs4jJhkkrupMXXovrQGNXbAqEGhxVtHVd98EpInSA1qB9eRqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722955179; c=relaxed/simple;
	bh=TP9t7g0O8xlL2KDdP28kt1+dHFLDvbB4AuMk7BcXT9o=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=jx50NcYFPmT5izSWMh0pK2OUu7gZiXBOyJkhBFCfUDpJONH3lHvvse/YaOYKfc8wPoJv6iYlPAGbQDKsoFkvMsZ4tkX3E+WOl+wjuYL2pT8vqOJHjrgAtYPFAxmvBALltu12nSJ6dtTny0GKwQdz9eC5wU5y/UxLzzJQVfC1Vnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KWmNbfp8; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSpR4Vp0YZfVz1KtGfVMokr1PXlCmdVkFSHO64YGzMDvlpsaBxhOnPDd5e5/cCsr1HDpPzs6IRsu1taiA2KntrRkaanPIhDTZ8m5KoZ8WxY38I7KFMoYUyybNxZkozO5cosd5q4guSjFWz5Y+d1FnUYN49b2GEUbeTOosbLKYWvw4V0Wzf72kbGDpxHyZRjGyEgnijRCbY7S1mTvKtkvdNlL0U0dewtM8io1iHSBR5uvwel7L8yfTG1Lo5RRN+3Xw/vWDJdSiufYkwUCs+OKOPLOHQpwU2QxviTr4IRxmkikrWZt0Sp+nyCdZIbPcUVOLf5qFzj2PDV+PFdwS4wqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsXsptiea1VzXkLn8bVgssLs3/gqmh/gryJVDY8fbMg=;
 b=rwluX27JlXbY6kqBAZTZao9z5D1qJEBO+apsllnwHxUrN+tn8NkHQ90EOJHbmTvd9THwfBjSVPd+RnW3hzhnl34So5yB30aURZx14gKkZWXd31X9Fhg8dgxKJLk+T/6+qwgwNQomhSirgsQOpNErpXn21QydbkIqcDEyjb3xGiXzL7wUo2B8ZW8nez770RAV3q4Rdpf2QSh2HuH/QGmfMPMsHX0V+mS9AFYDdndR4kaox+CsbdcQ7J+jF9GDyStWCOXKyGDbvm9EWPoFThty7se5SJZXEHd/TLgDrv9xEgE6rdywsjZtsOVXW5Qz9lahBZFftY+jY8Y+bgkQozE4uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsXsptiea1VzXkLn8bVgssLs3/gqmh/gryJVDY8fbMg=;
 b=KWmNbfp8dbNB/NAVfJoDLs7m/q7lTffyOOQszTtfc4KEM8hQXPYpI5Cj3U1D40Sov11hRJ4eSrL62CLi7snTol3bbu4Apvsq2OJUdfKPrYg6Aiz9ehSaFQoTwS/OG8NwxtAJdGtgJFwVOWSZikAbS1T9sD9Ezy0+IXsPYKK2gXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7425.namprd12.prod.outlook.com (2603:10b6:510:200::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 6 Aug
 2024 14:39:33 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:39:33 +0000
Message-ID: <8890482d-22b6-2ffa-9902-cb970ed20013@amd.com>
Date: Tue, 6 Aug 2024 09:39:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
 <20240806125442.1603-5-ravi.bangoria@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 4/4] KVM: SVM: Add Bus Lock Detect support
In-Reply-To: <20240806125442.1603-5-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:806:24::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: 93ef8e5b-daf9-4e28-25dd-08dcb6259673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmttUDdCZ0F5cHpNdWo2blFaZ3lQVzVMY0xpUHlXc0JPZDFBaSt3djk3QUNL?=
 =?utf-8?B?ZXFESlFZRE9PNThSekdmeTNtTWNRczUwU3RzTDV2UUNxUWRaOHJ4ck9mMWU4?=
 =?utf-8?B?YnlYNFBVZ1NrQUZCMWJGcmo4UEhGdEJBVGNjbzM0VDlIa1ZKOEo3U2VzNjhy?=
 =?utf-8?B?Z2s5cmQ1Y3hoSW5OVTVSSGdiUi96T05pM0dXUytWUy8vNVlhaVRFLzN5Y0M5?=
 =?utf-8?B?S1h4ZjduL1BWL2VrbkV4cWRIc2NxSGliVkptWTBLVGZHdXJVZFZrUTVCRGxQ?=
 =?utf-8?B?bWR4VVEzeWkxOUVhY3QyMysvMzRYOThWVHpkU1BZZktkaHljUXhwbElIeit1?=
 =?utf-8?B?TjlxaEZFU3JuY1VUV3pydkVWeWVMYkF5aW1vSkhLN2hZdWlJSk1Kd09jaVFO?=
 =?utf-8?B?RnZPUkY1M0tNK1o4eUFpMHBJZDZlTmoxRi81NUo3SUltbFdPVDhzUTkrMkh5?=
 =?utf-8?B?TEUyNkVVZlg1SFZldlhFam1KbTEwaDZ1R3hiRVdEa3JLejEyM2puS1BWMmpq?=
 =?utf-8?B?MTBrV2w0alY2TnJOYWZORU5DQ0xGclBRcVJZQXM2N2h2MnpSSi95K1FPQi91?=
 =?utf-8?B?RTBiNGh2KzVHOWRwRlk2NGkrVmQvdWRCazhHdGpUMUM1Z0lUWmg1N2lLWkN6?=
 =?utf-8?B?cmk2OFpWZDF6UnZ5b0llaFJ2ZFdna3ZJMHd5YnlLbWVZTTlxS0pERzBCakIv?=
 =?utf-8?B?UTQzRmlxTDhFVnUwTmtvUGM5NkNVUUtud1RSTzhWN1F4WEZSR3FoQUtFaUNC?=
 =?utf-8?B?YWFKYkZKZjJCNkVPRDNuaVhNZW1KNWpDalBodi8wWlpxd01JUFVtaGhQQTYy?=
 =?utf-8?B?UzBOemZrd2VXSFNtSUt0NXZrWlBGN0FuN0VTU3FLMGp1NHFmcE9zN2ZlamZa?=
 =?utf-8?B?MUVHM1Q5NlRERGNzSjMycmsxYlljM3cwY01ScEsrTWpFQytNbjJTNUJPekJJ?=
 =?utf-8?B?VEsrY2tWdnNBaHZ1a0RiUzdFVnc0d0hVYlZ0dUdKVk9uU2JvVCtOQy92bGNP?=
 =?utf-8?B?KzR3NG5rU1dlTVU0djdOR053emNzRVkxeC9zK2dVUWZEd09iZUp2SXN1MWFp?=
 =?utf-8?B?bGxOTUtFSmxtQTRPd1YvV0FlSUFMS1RKdUV1NnM5ZnM2aU5KOWJOck9ScGE4?=
 =?utf-8?B?aG8zK241TFI4V21vc1lkTE5sdGlTZ1JXZ3V2R0UxR1NwRGRKTWtibG1MMHNN?=
 =?utf-8?B?MmV4Tk9jT2dHVE51VjNQOS8yQko1Zmo5V3JzMk9LbjJCQlVZY3lQRmtvQ0kv?=
 =?utf-8?B?THR0a1YwY2UyUXpESXJNVFBVWFdhNkZYeEFQdXdkcDVsSlVyVWJVNnZKRy82?=
 =?utf-8?B?MFVTVWVtWm5ucVA0Z05FRjd3Uk0zYUFoMVJlZjZlWkh6T1RacG1wR2NhUk05?=
 =?utf-8?B?ckpQMy9UYSt5Qm1CVUtoU0xEYUxFNjRIZlMxaXdpTVVONFQ3VTBRZmFMTUxx?=
 =?utf-8?B?Mkk3bE1mQnhtaUIzLzBmZzlGN3kxd25aYW8rVmowbXRSSldXTWpSeVJCVXo3?=
 =?utf-8?B?TVBnUis1eHlkZ2lTMGVlSXpnRS9RbG96ajhVa0RGLzh1OUFiSkFIcDkzTE9H?=
 =?utf-8?B?YVM4MmZPeGxIR2xDQ1gvS044LzhOMGZ3L1BYZlhiNHlKbTVzdmJ4bFBTQTAw?=
 =?utf-8?B?b1JWQmdDNGEvemIxM0ZpMWNyOWt1WU44ejVaRDdUWEF3TzdTcURPd1NxSWhY?=
 =?utf-8?B?L053YjR3ZzY5QTZ3L2V6UXIrd2h1SjhzZ1BKNDJJc1JyOWFtcTdody9Vdkli?=
 =?utf-8?B?eDIzTVVTbTFsWGU0RGtkKytOY3hCbEZLbDdFV1FMMGdqMU9OQ1BPUk5OVC81?=
 =?utf-8?B?eFhUSkdZVWdNQXdtSjN3dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWV1amhXZzdhbzBPYjJzN2Z4RzZhREZnWkEvTFdKMVd4OTZzbE9MTmlic0Mv?=
 =?utf-8?B?TmlmR29jam1Hakgrb2JpYWpDWXlPR0dpbGRud3FKaUVyemZiK3FaWm9Hazdm?=
 =?utf-8?B?WEsrVytsLzd6bFRLMzlZSVFnQzh6THJIV2lqNW43WmhpUXFybFZ1NThvY3hN?=
 =?utf-8?B?N1p6enltVktTNHd4Q3dIWGZtcEx5Zi9QZG42WEZpUmV6UVZaeVZOdlllNFpB?=
 =?utf-8?B?OFBYUmE3c25jWG9TRGphSHF3aHlJS054ZXZTZlpDaXlVVHVnTFQ4M2dKQ0s1?=
 =?utf-8?B?QkZDYktBMmpRRmIvQmw3dVAyV0N1a3BNVGpGVnRPNnJ0UXZXY3JwTXBZakoy?=
 =?utf-8?B?RHFyMkdSU1VOMHlEUjl0N0pPcWVJVUNJa3NKdERwU25PRFU1ZmorQ2pzNDdL?=
 =?utf-8?B?aWprRTIwaWpsNjlwMDNwWEcrWDBtTXFLd0dNMDRkMnBjRjl3K29VU3FOYjhE?=
 =?utf-8?B?cWp0TU9kQm1oY0lJT1hnTE96azVwMnIySGd2Z0I5eml4ZkM3WkdnVmgyMG9o?=
 =?utf-8?B?Z0xIc3kyYVJkZnJJUUM5OURLZVRXWUpuZE9uazdldURhRlN0YzVPRE0yWEUr?=
 =?utf-8?B?Q0o0ak0yQnQxVXBCN2RCNjhrMTF6N2tYU1BPNTNzaGxCZEVmbExiODluS1dF?=
 =?utf-8?B?VC9LbWt3VkZ4a2JVczFjQjJtZWJnTTdZR1pTclp6TXIwWDRXd3RxaHRGOCtX?=
 =?utf-8?B?eGNGa05iWHZ2M0tabXllam94SVQ4WXFTREtOeG9FdUl4TEdBNGx1djlWeTQ0?=
 =?utf-8?B?cXZaNVpqd3pSbVEyZlU2MkxIZ3hZS2MyV2l0RDhXZ2NxU2xTSFQrTktmMFlH?=
 =?utf-8?B?OHhoQTkwMXRTbys4SEFXdUNKQmdkK3ZVdWY2OWZOelFkN01Zem1oNU1wNExo?=
 =?utf-8?B?V1NkSDJ0ejJxZTROM05vRWdoNzloYXJ5czdxQzB6SW1HaVVkbWoxV09sM2dw?=
 =?utf-8?B?cVhoNHIvVWE2SSs3RVJjVGtYeFJGWkxYZmJYZDdkZmhRUFVubm5HMnYweUlk?=
 =?utf-8?B?V2pEYWNKaHI4ZmlqZWxISlk0OWU5eXJTMWNwSXZNdHpRY3dhaU9LcHdLM1hF?=
 =?utf-8?B?VXA2YndKSFAvQVVBRi8yT2NPdSsyaWE0M1hmQ1JwckJWbTc3KzREY3QrR3Qz?=
 =?utf-8?B?SHZSQTUweEg4SEFQaXRNSTh0S1dxeDVaV0NHUXUyQ0trKy9JcmxyRG1hengr?=
 =?utf-8?B?djBLcHAvZWJZNE5nV2lOZTM3M2VBd0Fna1Z3ZTU5S1JsREx3VjU5UkExSnhP?=
 =?utf-8?B?OENJUFNMMWdvcUFVaHdwSjA0K0dySG5OT3NOMHNjb1U2dU5tR2sybjd4ZVFp?=
 =?utf-8?B?TlZjYXZJNFZ5TEFxeGdtWVdHUFpDYkkzUjh3QVZoNHJHb0NYMzVWSHp6Qjhw?=
 =?utf-8?B?dmlySng1anVVb1J5QU91THlzcGlmWmFCbjErU3A1aEU2UFl5Y3Q1aTBvbWlF?=
 =?utf-8?B?N2laMkttOW9QOGJEZmp5ZFdWUjllbllyRzkyZkpjYkoveWZQSnFkTGJ4ZkMx?=
 =?utf-8?B?MTloSHR3bytFT2d6TkdHK200d0g3WDZvaEt6OU8wbEg2UThOM2pQZTcxRFVJ?=
 =?utf-8?B?NTVKMlJVTlMwdlVjNWthTVFqeTM1REF3NjhDNndGYkZkZGZweVhTV3NRU252?=
 =?utf-8?B?bGRkNFlSWEpzZjBkT0lJeFQ5OG9jOGdvYlplcXozc29HRVorT0FIMUxZZlpq?=
 =?utf-8?B?Uk40RFdkb2RPcW9KYVcvZ2psSmxyRS85N3pSWlRZYkpvUFVlelNwNVJXRHhv?=
 =?utf-8?B?cXo3S0JlTGx1VldLZ3R2MHNjSlJJa3EvMXJZSE9jT2FQYUxCMXFValY2b2Zi?=
 =?utf-8?B?RTdURi9QNk1yTWl2WFkzZFNUMjBvMW1DYlhpbFVoek9MdnJsZklENFF0anZG?=
 =?utf-8?B?QjRteFZ0ZjdpbjU4SVRzdjJwMjR2QURhOXg0RGROM2lCWWVsWnJwM3pKQVM3?=
 =?utf-8?B?aE5ONldJUThnTGJVMmd1cmlKN3Vha2xZRmNQclBqV1AvZXNFalQ5Ry9HL2gx?=
 =?utf-8?B?bjVXSElleVFxallTYTVVbnVMTE5Nb0VYUkFOTDhrdktrZE5jYVN3RzhHVWNH?=
 =?utf-8?B?Z1FUTjFHVXVuUkdFUW9PcWQ1ZkZUMWJiSndUcVYrWGNEaURzS0F0NW9FMndt?=
 =?utf-8?Q?b26c7W/7a8DMeEMkocJ251hOi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ef8e5b-daf9-4e28-25dd-08dcb6259673
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:39:33.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RYIZUpjxWU1jEoJDUOmx6n/1BuHakbzVbhQbvpqbdTPbh1njknQdX77yapRfOqLjOyB5E9WMffRPWzZF4bn3Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7425

On 8/6/24 07:54, Ravi Bangoria wrote:
> Add Bus Lock Detect support in AMD SVM. Bus Lock Detect is enabled through
> MSR_IA32_DEBUGCTLMSR and MSR_IA32_DEBUGCTLMSR is virtualized only if LBR
> Virtualization is enabled. Add this dependency in the SVM.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Minor comments below.

> ---
>  arch/x86/kvm/svm/nested.c |  3 ++-
>  arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++---
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6f704c1037e5..97caf940815b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	/* These bits will be set properly on the first execution when new_vmc12 is true */
>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>  		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
> -		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
> +		/* DR6_RTM is not supported on AMD as of now. */
> +		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;

This took me having to look at the APM, so maybe expand on this comment
for now to indicate that DR6_RTM is a reserved bit on AMD and as such
much be set to 1.

Does this qualify as a fix?

>  		vmcb_mark_dirty(vmcb02, VMCB_DR);
>  	}
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 85631112c872..68ef5bff7fc7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));

This statement is getting pretty complicated! I'm not sure if there's a
better way that is more readable. Maybe start with a value and update it
using separate statements? Not critical, though.

Thanks,
Tom

>  
> @@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (data & DEBUGCTL_RESERVED_BITS)
>  			return 1;
>  
> +		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
> +			return 1;
> +
>  		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
>  		svm_update_lbrv(vcpu);
>  		break;
> @@ -5224,8 +5229,14 @@ static __init void svm_set_cpu_caps(void)
>  	/* CPUID 0x8000001F (SME/SEV features) */
>  	sev_set_cpu_caps();
>  
> -	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
> -	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
> +	/*
> +	 * LBR Virtualization must be enabled to support BusLockTrap inside the
> +	 * guest, since BusLockTrap is enabled through MSR_IA32_DEBUGCTLMSR and
> +	 * MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
> +	 * enabled.
> +	 */
> +	if (!lbrv)
> +		kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>  }
>  
>  static __init int svm_hardware_setup(void)

