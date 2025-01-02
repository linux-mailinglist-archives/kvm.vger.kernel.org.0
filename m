Return-Path: <kvm+bounces-34469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF649FF62B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 06:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51EF83A3236
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 05:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F21D17C21C;
	Thu,  2 Jan 2025 05:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qIr/P8DD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF32520322;
	Thu,  2 Jan 2025 05:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735794622; cv=fail; b=GoZrQNT5nKB9uxKqKtY9tEpLije8XFNeR6vR5Jwjk7maW0V2mSjMuIvI3DsfVxKbbjUfo41AsgKIkEJF3+IK7QsEHjy38XS8xP1wl/5DLAHJllW2KeJlszHrcGXfIrenXMBIyCw5btzgKfygi97Zg3WmJ4jjn9SSJVK83N5wK3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735794622; c=relaxed/simple;
	bh=BldUcTomx+insWfXPgqaI59jwZWoCLxRjMOG/GpshYE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sNc47idto0/loyL7ujKqmmXLpdK6i9Jxbhma+ETVUjuuYlp80NqGkOCU/tNeHPhiitKRHvEpLgqEFX/GlhO2w9PMP1B2VJm0qyXjxrZ59GJyElhh4DbR/nu5caw7TWxSWz109n0ypXH/serNPW3lWXypZbpnNnLOapFxfQJGHeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qIr/P8DD; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rCe8/OwGoI+aJLuu9Vx53752ZakgqaWAUCFTFZGe5UYjOocL6NmSCOILieJNzmYgWYgvKBjF/zYZeIRscEr0/b0LCaUdvwiAV5lHf5yd1FPpP4XCsge5z4CO+gYPtAWj1hkj80RpNgt7YmaiIwzFDPLx7fnG+4i+kXwQ5dPZ9LxJJagWGy4l6CnsRhdhzQL5F2zI8eazVgMM9go2pk6Opr4rMfH3y05wlrk2vUCvUywHWgq4FoEn3Ga6C/HeuibiENDPVDpoIusSIKtZEiFFtIUMm25OankRli+Zy2wrWxwjplHs+zOpyeLGUEc3XbTm6V27NJN5ly0HWp8mCJdG7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qus0TU5J9/Umnd+e+7JtA1tPmjOoLhzQR2PTYx4gJq8=;
 b=kjRPaD/Ro1uZvQA0D/kgYXNqKd6gTZUmvbSB4VJNCGtA9W4J6ifVO78D2Y+Mu++zQOxy9AoESVBadE4HWfFrjAH0JcVC2FDwJY2XZxsqsqm+r7TgNwvlHKQEwMRvZB2oZEuOoocY9iKmjEdtu3rmHb3r2rEWYeH/kbFwAPd97eNbzmuBFPSX6PSuFiTyfiij+OhREhkIcOY0tTkycJ5v5pzeBEbgfpW+EmiEmeJIc3iFk62ByjcF2tjvWvRbovRA3p1LJXnLcKWpp2/QJh26mEwmSXsgwbrR60SxGGljZlDS6x1cdWYyqfCJxlIzWRzQZvWSREza33yz6pIT/yydVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qus0TU5J9/Umnd+e+7JtA1tPmjOoLhzQR2PTYx4gJq8=;
 b=qIr/P8DDzL7iQiuNjtc/ufNXsSRw44sBUeaPWNWm5jR76Yu+KT9h5xzMO6E/QfOAJ78fV1IhgbZMqMeAOKiJ9O5OGYm6HSXbispk+BXfjBiylh7GwJg46JFE6smsDOvqz0gA/hu8mXEyiw1BLmdA97ZwNzjAK0UkbQIMsVHuEgI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB9322.namprd12.prod.outlook.com (2603:10b6:8:1bd::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.12; Thu, 2 Jan 2025 05:10:14 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 05:10:14 +0000
Message-ID: <a978259b-355b-4271-ad54-43bb013e5704@amd.com>
Date: Thu, 2 Jan 2025 10:40:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Borislav Petkov <bp@alien8.de>, thomas.lendacky@amd.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <20241230112904.GJZ3KEAAcU5m2hDuwD@fat_crate.local>
 <343bfd4c-97b2-45f5-8a6a-5dbe0a809af3@amd.com>
 <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250101161537.GCZ3VqKY9GNlVVH647@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000018A.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::55) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB9322:EE_
X-MS-Office365-Filtering-Correlation-Id: 64389b97-7495-429c-9053-08dd2aebbd95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzdGTVl2bG1OdzllZ0hPZzZNUDVsSlEyYWx4SHM5TytGSGtWRFlHaUVTQlBD?=
 =?utf-8?B?ODFmYWJGQldOb1RZOEwwZ3VneXAyWjc4NS93MUd1OE1EZ1d4V0VFS3I0THdx?=
 =?utf-8?B?SXFoY21Ya0x3MGJiRkYzcmZSWUdnbzNGQlp1UGJINXNpSHBDRXVHQUtUcVIx?=
 =?utf-8?B?K2RJajdFK0Q5V0dMMUo2ZE9MTkJGbW51cHROYWo1VVJ4WUZTNTlzbXk5czUz?=
 =?utf-8?B?RXc1a3Q3SFhTZFFPSEZsOVA4N29Ua3VXOS9EMVFWU0x2Rmk5SFpqdGFNZDQz?=
 =?utf-8?B?Qm5kVE84L2ZPTmlsVUpPMnE5Vkhrd1QxL1o1eUMyYk9MSXhDTk5WcEZaUVdJ?=
 =?utf-8?B?Unp3MHFVNkEyUkR0SjhvV0MyTnVTNW8xNzVJY0MzVmk2WEFBaUZOL2pxeWcy?=
 =?utf-8?B?YU95a2d1bFFjNUYrVTJDUUw0bDVzVTNzL1VUZFhiZjFnWUp6ZThQUS94ZUlQ?=
 =?utf-8?B?ZGg3SENzL2JaVHlZTHRnd2NDR2VPNmt6bFUveTBON1Z2S1pXSExCaWZyTG5W?=
 =?utf-8?B?VTdNbVBRdHRZZi9ydHFoUXl5MTdINzBYSnNWQUhZWGdPYTNNT1NHOVRjNUJS?=
 =?utf-8?B?eWpNZFVpSkd5c1ZZb2xtL0g1ZU5TUjdzOS9pZ1ZRS3JrMk1HU1BlQVRzc0cr?=
 =?utf-8?B?VlBMeU1QaGEwOFBpMHhMdStpMUhUMmF1YlBIcERpRnRab3hYRS9XTUVkMjlp?=
 =?utf-8?B?Q0Z1amxRRVlXU3ZEUFIrQ21CWDlENzdHUmtYWnRvK3pGZG11YnBMY0ZsdVpN?=
 =?utf-8?B?VmJNM2RGQ0I1K1NydThtaVlmb0NNbXlYVjRYamo0Q3RiMjZVQ09kOHVZVUJq?=
 =?utf-8?B?VWdJR2hVNlhZZXBNWHFQbEF3anoybm9ReUgyNE0xT3dtNHljVG1lbGM5eXFR?=
 =?utf-8?B?VXVTODlCQWE3bjczNm52NEpiSG9PcjRjV3FkL2s5SWkvZkJPdE1PYUtNcS9m?=
 =?utf-8?B?d0t0cmt0NWMzMTBzYXZ6eC9YSGxwdlZPS2JzeXJRbW8ydEczZ3h6NTV5aC9Q?=
 =?utf-8?B?N1JHc1lQOS95dXlYbjNRdGd5aUkzSWU1T0RjSGdtSlFMQ1ZUaXBUTEs5V2hJ?=
 =?utf-8?B?TXpZenExMFNWdkI0elpFNk1SeWVkdm1ua2FZY3hQYm9Ec1kwb1MwRXY2ZDVs?=
 =?utf-8?B?TENrUnBheGNSTnlqb1dyU0txSzFIMmF0SGM1R2ZQcitTMi9QVWdtYmxRMmdO?=
 =?utf-8?B?dFFySlhnbHVUdUhLZnZaVXlrc3BZbDNuY2UveTUzVm8xZnBlNFp1dnRLMzd6?=
 =?utf-8?B?THVwMVhOdnF1TVVJSmRlcEJwNUZGWWpHZ00vbzV0SXk0RDdoUHlPeWEzVk1o?=
 =?utf-8?B?YlpoeVpGSE9GdjlIazFMVE42T2hwVy9TZ0FNR0xtNjBKa0NuMTUyY1VzVnN1?=
 =?utf-8?B?K0NXeTdKeUozNzlsbG1pTW5NU2NnSXVTYWxYR1ppYnRmcjh1T3VVZEoxT2xD?=
 =?utf-8?B?Qzdyb1RqOGRMVUF1dEtVbjhVb29SYjJodEJVNlhXTDJhdEVadm1BOXA4VmpN?=
 =?utf-8?B?aVhvYnlscDdKckxtUVg1aEhQZUR2dWpjckNKUmQxa0lTTjZSdE0xdFR4VVF5?=
 =?utf-8?B?UUVzSlVGZGFBZUFWK1RzaWZubUpkcGE3K3Jwc3dmR3JxOUpROEUxU2lmMnhT?=
 =?utf-8?B?UFBHOXBjdHdIMVVRQlRpS3pqaWdBVDJXWUZDakh2TnVkd1JUYnBZZ0V2eEY3?=
 =?utf-8?B?bnk4akVjNDltM3hnVy91OGZHYXI3blUwZ0VnT3ZxTGJoMnMrR05GOG5ZMmVR?=
 =?utf-8?B?WFpFNmVDMkdXNzVFK09JREdJS3p0ZENvR21uMCtTRU83VzRxdnNTaTlENTBK?=
 =?utf-8?B?L0lVTzNxemZGMERDN0lhTWpoV0FNMDAvMVkvY3VHVnVsRG1MaDM3WXdTWStw?=
 =?utf-8?Q?dq6En/esLxkv7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NJRFZ5b1E2bGZ5TzJINHRzOVZGT01FZTk1bmV0Y01lcTdaVldaZ1hoby92?=
 =?utf-8?B?OTZmcnBYaHdLT2M5SkFUcExqRVZhNXRDWHBWWitsWXZ3MlAzQXRFY3JsTG5Y?=
 =?utf-8?B?SkZMdEQ3L2VpWVk4aEM1Q242dGpuQjdZNUpLRStZKzFHQmk0OCtwTmpHZTln?=
 =?utf-8?B?c1RFd2FnU09wMWZOVVN0azI0OE03Yy9Wd3QrdWd4VTVwcWowRmNBTUNMSVND?=
 =?utf-8?B?ZVo0RmlObzJiMnZZNXRhK0ZMVVBJU1RqbXQxcXEyYmpING1taXVFL2JXdW1j?=
 =?utf-8?B?NmVIc2Q0L01sWG1NNW43QnZIUzZMVHhuSlMrTTRRaVJoQ3dQandKNkh0TFZ6?=
 =?utf-8?B?TVlxdDl1cjI2VExxK2dvNUo1aHlwbUNJTUtwYTZEWEpkL2F0alhwckxrU3Mz?=
 =?utf-8?B?TUM0aXN5WEZyWXpJNVQ4MW1vK0pRSlJ4cXlVa3dJZDIrbHZjaWIrQ2lENGRK?=
 =?utf-8?B?cnlwZXZGSW4xT1NYeElyTDZmamlWVElZS3RpV0Z0WngwUFR5V0JuSmdQcmJU?=
 =?utf-8?B?blNzZGIvN2pKQ0F5ZzN3YVlveXhURWNid1phOSthbDlMSTVQSzVKNXVJRStT?=
 =?utf-8?B?VjhlT2pMNXp1dmtaS2R5RHhaZ3ZZdjJlZ2JTYk41ekZIUTZ0T0JoT2NGcUtX?=
 =?utf-8?B?dzVHTmJiSllLNnhXUmp5VTk3REdoa0w0d0U2anozODh3aUhIbDFDdzEycGty?=
 =?utf-8?B?dmNwRVk5elFDR01ET0c2MmxMR0NlK0YrZ0lvcUtNMXVQaWRDL3d1QlVZTnJU?=
 =?utf-8?B?RmNQUTJESks2Y2ZRS0dnelJSN3hTbXcrc1hkNGZjTDB4OTFFc09IWENZSnl5?=
 =?utf-8?B?ZysvaVFPdVowUTNyd2M0WDdBVEx5d1NRVUFZTHFGQTJtYWlzMlVPQ09waDBq?=
 =?utf-8?B?ODl1OGFaUGF1NGEyOFFQOVdEdE0vdGoxS29mY3hMd2FRckVYa29sOGJqZDU3?=
 =?utf-8?B?eXp2aDdGeityNUJXZ1MyMStTdlR1aDEyQ0dkYVZWUUNmQktEUTVYMk0yYjVm?=
 =?utf-8?B?TThlREgwQUQvd2pxQnQ3azdZNSsrZVpOTHVkOVJ1Z2ttbDI4ZG1OMXoyT2lt?=
 =?utf-8?B?ZFkrQzhIR0FVOHhqNVJqdFJ3dWpnYjkwL3B0dEhzMzUvMXp3Q29EdVJpOVBY?=
 =?utf-8?B?alZYQTkwK0hyYkozTlVlQmFRdjI3UGNIRnUwdm04TFhGY2N3dE84dDFJWnQr?=
 =?utf-8?B?a1JjZ3c0d2l1bmZVWlM4dWZUbkEyYjhEVU5aMkVMTFpQdlZhaEt4Q21kZ28z?=
 =?utf-8?B?MlZqZGJBZ1FZWTVSL3dxZzlBVFhob0FIVE5Dd1JzejE4UitRMGpxaXk3MFpL?=
 =?utf-8?B?dnFTYThHM0JvMzdIUVlLN2dsVEM2OVc3V0FOZ25lNDRnTlVwM1Y3VW8zSTkz?=
 =?utf-8?B?R3pSWDV2L2prUTNWNlVFTWhlVUlXQTlJazVXS0dnRzhibms0NWFqZHhYVXFM?=
 =?utf-8?B?MytLYjYwODk2MTVUZDZhQldRMUdsclRjcFU2ZWRtZittMnR2R2NiY3lTcXZv?=
 =?utf-8?B?SVBSbTc5V0VVZ2RYWUhLM1NvWXlCWU5PWVBJTDllWXN0eEl2bi9YMERPNjF4?=
 =?utf-8?B?U3VtaUphbENiM3FIVEdMaStObWJBL2k2ZGQxTlRESE5ONVBEQjFUdW0xRnpX?=
 =?utf-8?B?VWNIMGRXNU9kcDhsNXFJL2VDeXZtb3BoK2FLQjhiT0V6TFVmeXdrL083SjJW?=
 =?utf-8?B?anFXam5abk5NSHZIM1cxNnc1a25DM2l3UkZkNzBrV2lRbHkxZHVPblU3aXZ6?=
 =?utf-8?B?TmsyNHl4WFJnK2VDRldsbUJIaDIzMDNRZVRsU3dTOWJFZTA0OEZqNExPbGdE?=
 =?utf-8?B?MjlqbFFyT0JDNFZtZXVWQzV0UDJSU2toM05NVmhtZG9mNjhqdnFqQzN4a3pN?=
 =?utf-8?B?anhydFJEZXRDeFQxSW5lMnpYOFIyNUVUajFYU1RMRVJlRENqZlJ1TXlva01K?=
 =?utf-8?B?WG1uQWU3ZHI2c2FuTm1hSHFZYTVWNzJNR21xYlNLeWxCRnN2cE5XRVcvbDNM?=
 =?utf-8?B?QUNNbVpLTDI2UFlGNHhtOUJLMGcvK2VFWVpFTVZ3UWc1VVV1ampzYnBkQklu?=
 =?utf-8?B?VmdYc0M2NXg4cUFIUkUxcHVTZVlXTm1xejRna1BUV0ZFWjVHQzBWc0RnQ2JK?=
 =?utf-8?Q?dk6Wt2X/2titjeqDoPnmW1WUd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64389b97-7495-429c-9053-08dd2aebbd95
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 05:10:14.6388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dK8etUuL76f3EYA1/Y161ymoxn4IUNcWuZkUpEfAD/sx3Ldm7RJ8kyagdoR2hoMulteVA3sk3YmLW0QzGDsMTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9322



On 1/1/2025 9:45 PM, Borislav Petkov wrote:
> On Wed, Jan 01, 2025 at 02:26:04PM +0530, Nikunj A. Dadhania wrote:
>> As kvm-clock would have set the callbacks, I need to point them to securetsc_get_tsc_khz().
>>
>> arch/x86/kernel/kvmclock.c:     x86_platform.calibrate_tsc = kvm_get_tsc_khz;
>> arch/x86/kernel/kvmclock.c:     x86_platform.calibrate_cpu = kvm_get_tsc_khz;
>>
>> For virtualized environments, I see that all of them are assigning the same functions to different function ptrs.
> 
> So just because the others do it, you should do it too without even figuring
> out *why*?

Again: As kvm-clock has over-ridden both the callbacks, SecureTSC needs to override them with its own.

Regards,
Nikunj

