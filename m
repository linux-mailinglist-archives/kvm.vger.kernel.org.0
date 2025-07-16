Return-Path: <kvm+bounces-52670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E94B5B08057
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 00:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1941E1C28781
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AB12EE986;
	Wed, 16 Jul 2025 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CoCqswgs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6F2EE5FC;
	Wed, 16 Jul 2025 22:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752703984; cv=fail; b=dQQXmqjaAhOvDBpFVXZumo9toN22bIPRnypFY2jPT30gu6TvP3WqClKib+ztptubrRHoe7IdEpar6KBXdrjRk71iyJN5nbz8r73jVg4sdU+myqN4Wgpir2HHXVNsd5o1/7vOzIxkdTvOGETV8nOVPyC0XccMmHkNNQXV0CADxxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752703984; c=relaxed/simple;
	bh=cyiiQmMm7SOrhYqC07VaDb8VeqyOTIkVo9wFCVxsDCY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nZEyfALwrnPWVh+4wrTCu70D9RiVnri8sA5O4ctYD6eqowmVb7YfkPdKoIXiMUX2ooALw7LF1SbEHMbahrbN3NAQPrPd3mxwffJ386OEJ1qWL9/mBXRsMpOC+GaG0Qp5VfqsN71F9Qa2m7rq6llhyidolFXBl3Y2coIDpA/IvRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CoCqswgs; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJb3p38lVA+fBvHPbHH3Jr8kr/lFWBOtEf6JtOuEXAcZzCKKN0st4gq+lFdzIkv5gzO7y9O9Wv3o02ZUKPviV1ufXWSl8j0MYSk5diWIUvyPc25X/tG9jcdW1lHXgRQCtwsOevXZ0QPBxD6o+O6aXBcfABK6fMRSy75xnwhKBySlW29b49nKaMuuWmNNmts1fAfX0/79ylmTXD+P2TocKEKgfintU/1wpDAZMxchfOcgU4LhQmUGx8XUkmwFMO4m0BB/c6HM0pbuDnCLcliPIvapknOzBjQAWwxb/Fd5hghcVdpcl6ofRtTWQVzJc/3jx9es4mxXfnkhbhAH0CkcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGamU1ObmDnwseGO9b5JZVegO46jZZjVAhY5tx7XDFI=;
 b=PKKCY0Q3Vjp+NStsfWDEeNcp0YueCJO+bV+7QNIT1uQXaOnIpeKpZHRr8T+q/2Tnb+riBh0cJ4TEMxrEVShh5BNbv2jjFu/p7vZPQ5yN0GnEAlofjdVWNIIv5+w4CwapsZgqbH48DHfKJyPqX4sO3X0s2ybHutOqOEShdcjRYOaQ3d1+Dk3DEdhlo0OSHfx3xEgY3CXRUiGpDNNO0V42oOmD2Lu3j6w1J5qFM0WWCYgK/cEl+IEOjNsICHczxhFLkBHhPQ6ySyJ/HVSIRTszRTmVoM7Lz/0HpAvoHJWOg0dIAvaOlRJ/cPK6RpF0tP5NUJvUHy45Lj6LPwb6UzXV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGamU1ObmDnwseGO9b5JZVegO46jZZjVAhY5tx7XDFI=;
 b=CoCqswgs+A6IDAMrOWVLlM9ItWkmZnUFWYaq3qzZ2/tojaxIB7EMt1fqMRkkHX9+UokL/qiBAj6K/0PikRywLdieIbT/zWmElGbwx4W1P8QNlEm3abdA//C29TUxJ+gLm+4cja9yjEAaQLP/XEnDaeaPxRFcdp0h+/WLgulMPUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB7668.namprd12.prod.outlook.com (2603:10b6:610:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 16 Jul
 2025 22:12:56 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Wed, 16 Jul 2025
 22:12:55 +0000
Message-ID: <49ef7e43-6a5d-452a-936b-87a573225d1e@amd.com>
Date: Wed, 16 Jul 2025 17:12:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] iommu/amd: Fix host kdump support for SNP
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ce33833e743a6018efe19aa2d0e555eba41dcb96.1752605725.git.ashish.kalra@amd.com>
 <529c8436-1aeb-41bc-94bd-8b0f128e6222@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <529c8436-1aeb-41bc-94bd-8b0f128e6222@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:806:d2::13) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: f29522f5-f33a-462a-560d-08ddc4b5ea02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0dYejhZSkZITWg1cWM4aFNGOVVqeFYrZHl6OWYvTEtmR2pxQzNqOWoySFY3?=
 =?utf-8?B?YUJwNlI2TG1ZbXAwbHhhL1hqVnpvemNFN0xhYmpCVXJENnhsZUtyRDkzTEhm?=
 =?utf-8?B?bFBXazZTZFRUTHUvRDFJVUlPcXA4QS9WZDZ0S09tRzgzZ0loSWtFUmtNR0tO?=
 =?utf-8?B?TEx1RzdMcms1MVozWWVKYUpHZUJEY1hHd0FxOEs3WEVYTmg3d0dUak1WTkxx?=
 =?utf-8?B?QWdadm1VaVd0cnpHTkZTdjRST0FGOUZKQU9vVXlva2lzUmp0aUFPOTFuaXVv?=
 =?utf-8?B?bUd1Vnc4cDk3bHVtaFk1UWkyckZ2WHQwZnRnZnFPZ1NpQlhxcFJteXRuNmJh?=
 =?utf-8?B?bWcyY25tdmZFNEJzcE5MQ0h5RGxDU3ZJVFNXY0QyK3ljMyt1QkVEbzI5MVl0?=
 =?utf-8?B?YzBLTnU3VFRuYkRtZzZGblMxcUhGOTdBOC9tWHZsU096Zzl6QkVCeEpwYXh2?=
 =?utf-8?B?VWVvUWROM0psbjQ4azZjdGJhK0tqcEc0QWhpTWh4ZjBDMkRqL00yQUNsYW9I?=
 =?utf-8?B?VXNxTUtKSHFKVDNKQ3E0eW5CcVhsZjZKVFlKQU0wdnB5bmJUdDZaR2Q0S2NN?=
 =?utf-8?B?SVVaenM1MEI0cXhBMVA4Z0VKT2ZYWklqQnFRcDQ2Ny9XNm9pQ2hTMHAxMXpy?=
 =?utf-8?B?RXo0SWZsdkdZZzV6a1AvdVFxWmpVNU9hMFJLUEpISU8xSzFUSDZwSE9nNndM?=
 =?utf-8?B?SitVcTVWeSs5S1dLdkxsUGgvNEdZcGpCYnBMK3RNN05mNFlCUDdsVDVCLzJJ?=
 =?utf-8?B?WTRIRlE1b0JBYlA0WVJiTjhZNDNTS2R1czVjL01Gdm5vbFRRYUd2VmV5UURR?=
 =?utf-8?B?OCt0M3ovTTZsdUFaWTBKUlVzOU5wQ0NpbTczcUp2eHZGUjM2U243YkljRzZX?=
 =?utf-8?B?d042Uzk2NzhjYUpxRTd6a3pOMGxzMmNXcVNtcFpwdXdtUkFsaXRDbXZtK3hs?=
 =?utf-8?B?b0U2aFBQNlBXNHpDQVVUOUt5UzZkVjM1enI4NEN0MTlvWFlTZVFsTEpibWhZ?=
 =?utf-8?B?NDg5YTgzRzVud2t0TDMrYlRCWFp1ZkQweU1jYWlWRTIxemsrNzA1TkZrR1J6?=
 =?utf-8?B?UkVPaVRHWjlISTNuOGhCQjgxV1doT2E1V0VIenIwZjRZVmZ5VVhMRlg0WVlx?=
 =?utf-8?B?RkY5eVVTcStmakhRWFdPZUw0Zzl6dWNQM2QwQ2VNakdRNU9ybm9WK253S2xI?=
 =?utf-8?B?eWFrakdvY0UyczZoSDZTMkRXUDVpL0JjejR5L1BENUpmOEd1STM3c09PR3My?=
 =?utf-8?B?Qmd3dDVUcmZPUEpmY1BCVEpyK3VSRG91TTNWNDM5c0p4MzRWNGZrMzZXUUps?=
 =?utf-8?B?dnU4Z1NwY2J5WC9xWEd0MWdiWWRzVlJWNzVJNmFmS0loMDIxWlJsY2NWL3ls?=
 =?utf-8?B?M21qUVpkbFFaUjlOQTNwOWIyOVVBdjJqK2IrZ2xrbUptVEVXdElxWW12Nmsr?=
 =?utf-8?B?STNuYmJJYXM2b2czckRGRzNGcFFWb0hQZDFQRHNnK1ZIZjZBUVZvYXdrUFNk?=
 =?utf-8?B?N3BHcXF4bUk1enFLcDlMbEJLTWtEbEVDaW9raG5KV2o3RWJqZUlOUWJ4RG1t?=
 =?utf-8?B?ZmFIYTBSUjNrZHpjK01MbnY0SksraWpoLzNVM0pCQzNCVWhNMm01citRby96?=
 =?utf-8?B?UHZMNElhV2ZvcVlmc3dhS2lnVFk1d3lwcGtqeHpPR0xiZXFBc0VKTnZEVS9a?=
 =?utf-8?B?TjdsaE1rb0x6bmtMMDN2bU9tZFo5TlBoQkxtNHZpVjQzcDZtUDV0cmVPcS9M?=
 =?utf-8?B?Y0dzNlJleU50R1JwZ2RYbldGa05XVWdzVk0vcGUxUmsxQmExZFE5ZjBueXZx?=
 =?utf-8?B?Rzl6LzZGM2o4ckpCRmFsMlhXakRBenlISjV1Nm1uVDg0WTJzZ3Yvdy9ESXZk?=
 =?utf-8?B?NzhiM3Bmb3p6aU1zeHdGbnIrRjdzdGpIWkFjQzdKNzdaaEpvcVBRTXFNeStE?=
 =?utf-8?Q?+RYYFeYXBPo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTZ5U0loTURpdVBvVU9zeElYQkFoakw3VUF1R0kvKzd2Qm9Ga3VvaXU2cGJK?=
 =?utf-8?B?NVNRNmljTGk2YzZjY3lwQlpQWGphNzBsaFBPV1Bmd0wxcjNQY2k5REpDdFZL?=
 =?utf-8?B?RWZSUnAzWUZPM0pFOWhXc0NwNmxiUExPNXptVDJzMTRRTURMN3lVbXRsOFFz?=
 =?utf-8?B?Z0NUWHA2cGkyVHZzMEswNnlBdnErdGxROGQyeGhndVNGdTJiZFFmV3lFRjNn?=
 =?utf-8?B?MmYyNDNuYnE5TlE4TnlrOCtrN0NTaGplaFIzaEhpMjhkNzk2KzdSUmQ4eTM0?=
 =?utf-8?B?d0tOT1phc3FwUDArYkszTVdlZkdzNmFneGxRREhRTkt5dFlPT3A1clNCdGEz?=
 =?utf-8?B?RWxPV1AzZS9Ud3Nlc0tYQTVtTVpLcjRPT1hmZld2QXNVeU4za0E2TnBSRStS?=
 =?utf-8?B?VndLMGJaVHdHYzZDTVFkSS94WXROckVIZ2ZZemU5OVYwT0RTT2UxU09Sa0dC?=
 =?utf-8?B?SGNJaVJyaHRCdkk3dFRwOVZHbGxPSE9Gek5td0hqV1U5blJ3TlZPSHlhM1Y1?=
 =?utf-8?B?ZExTSDJsTFMxcVAzcUJ6V3BJRHNIMVYzTUgwci9IUmtEOTE5Qnl5T3JWQ1Nv?=
 =?utf-8?B?OW9mdzhVOEdhVUxNYW5vWWpsMytwTU5ucHBRYlI2Q1Y2MFBKdWlVYjJqZjVy?=
 =?utf-8?B?dm1vMXNSSityUHVmSXdCelhWclhTYVR2S01DRUhrdkV0WnlqUnM4M3FXdnNB?=
 =?utf-8?B?TDA4bkRUWFRqL21sdzhBQmRnalZTQlNOamVIWGhxS3dYdlpGSjArSHNDS0FB?=
 =?utf-8?B?ZjhIcVVkSlRNeGpWUFlaRkRHNVBGVGRXQ3ZvcllycU01Z0l2UHdxU2prdlVC?=
 =?utf-8?B?UGtsVjJCNSthcDljNllTOHpjVENjSkFvb2tKQmVhenJvTEw4L3pKT1EveEtm?=
 =?utf-8?B?REFsTFFaYWJERTVaSDZvMyt1eDdmVHE5b0VCUFVnU2NZU1E0REJ0MDBEc1VC?=
 =?utf-8?B?MkJFK3c2S2dWa25SU1VJdHY4T0xybWV3WGhDSUJYaDQvd3hYTXZBTGRhRnVP?=
 =?utf-8?B?bEtScXQzai9kc2VXaEFnRDVNaFMxNEh3QmxBMmtXVFFlWDAwQ3N6VHdmOTNT?=
 =?utf-8?B?R1E4dDUxWDQwcFQrbXhxNGczOE9jT0NQN0dCeWZ3a0I1a3k5K3FDWDc3RFZ5?=
 =?utf-8?B?OFhEdFlYaElsZDNwY3lsUG4vVnJaMkt6Tm56ZjFFOTJpZXVUeUdYUFE2QUw5?=
 =?utf-8?B?M1RROGp3bWExckcyVUJucDRlcXcveHVqbTBRa1RGRTVKb3hZTGExQnBvbnE1?=
 =?utf-8?B?cHIya3VtNnU3Slk2cDIrelk1M0FtRFhuc0phSkZ2M2lSalovbHNrL0RtYXdR?=
 =?utf-8?B?Z3VUUFd1bTZpQ2JjYjBtVVU0cjN3a3RKMUpmaWd4QmM2VlRpQVBWck1DdE1u?=
 =?utf-8?B?NnUwZGJqQ0RLcnZEcGUrYXp5NHZTN0VMZ0pWSVRrVGFwQUtvWlE5NWdEWFAx?=
 =?utf-8?B?OHBxVGZuSW5oaGQrRTlUODdLTzFUS2MwMmZGRXBIeGd6SlNxTUNETGtvdkdX?=
 =?utf-8?B?MXhBaDQ5dkE2emZTZEhQUzVzRjJ1NkdkZXBKdklGYWVwV05lY3YwazI0ZEdY?=
 =?utf-8?B?RGJETlpuL0ZROHNodkVVMkttOEdMSHc3TXFUVGlNRko2OWRoNlMvQ0UycXAz?=
 =?utf-8?B?SDFFWmhMRDlKcFZMVHk5V3JtMnV1VkQrMTI5Q0xaYlhuN0VISDNiNnR3UStN?=
 =?utf-8?B?bmtublQ0dWI3VnVubHNhUStNdzcrSTVCa2VJekVNUVVJZS9mQmIvQ3NIdk4z?=
 =?utf-8?B?WGRwd2xYZmF0OVhUUGg1T1M5L0JhTkk0YTM1YXhhblE0SzRpd284RkFuNG14?=
 =?utf-8?B?QmszQm5ZcFZna203STVHZjJHVEswdEt2aytPajVNRllNYisycFpjZDZybU1t?=
 =?utf-8?B?YkRPYytJQ1FsWTRoYitJRnFuWkt2b2FYRUxzc3RzQlN4V051UEkyd201WWtp?=
 =?utf-8?B?WW1pakRVQnlTZHlPWnQwcWl0aGl0VXdRYUs1Rkc5ZHZMb1dMTUxwVTFWRi9Y?=
 =?utf-8?B?ZE9CM1creWZpVFFjQjNSM2d0REFoaCs1OEVnRmNoOXpXZWZTcXBUYmlPYVpR?=
 =?utf-8?B?eHZEa0ZLV09udVUra0pWK3o3TEpFM0lOL0RDKzlUVlY5WWM3VEg0cCs2ZEFJ?=
 =?utf-8?Q?uRoBophPjcWwo0COf+JWTGH+P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29522f5-f33a-462a-560d-08ddc4b5ea02
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 22:12:55.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mlzaq0FayCNJqyN2g7TphIvzD3EEi6lriU6vfGwHypJH3m4itqp0ZiP0GX1xM9Ks7lGbG6V6qRGcAbUCw9fPvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7668

Hello Vasant,

On 7/16/2025 4:46 AM, Vasant Hegde wrote:
> 
> 
> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> When a crash is triggered the kernel attempts to shut down SEV-SNP
>> using the SNP_SHUTDOWN_EX command. If active SNP VMs are present,
>> SNP_SHUTDOWN_EX fails as firmware checks all encryption-capable ASIDs
>> to ensure none are in use and that a DF_FLUSH is not required. If a
>> DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED, causing
>> SNP_SHUTDOWN_EX to fail.
>>
>> This casues the kdump kernel to boot with IOMMU SNP enforcement still
>> enabled and IOMMU completion wait buffers (CWBs), command buffers,
>> device tables and event buffer registers remain locked and exclusive
>> to the previous kernel. Attempts to allocate and use new buffers in
>> the kdump kernel fail, as the hardware ignores writes to the locked
>> MMIO registers (per AMD IOMMU spec Section 2.12.2.1).
>>
>> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
>> remapping which is required for proper operation.
>>
>> This results in repeated "Completion-Wait loop timed out" errors and a
>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>> through Interrupt-remapped IO-APIC"
>>
>> The following MMIO registers are locked and ignore writes after failed
>> SNP shutdown:
>> Device Table Base Address Register
>> Command Buffer Base Address Register
>> Event Buffer Base Address Register
>> Completion Store Base Register/Exclusion Base Register
>> Completion Store Limit Register/Exclusion Range Limit Register
>>
> 
> May be you can rephrase the description as first patch covered some of these
> details

We do need to include the complete description here as this is the final
patch of the series which fixes the kdump boot.

Do note, that the description in the first patch only mentions the 
IOMMU buffers - command, CWB and event buffers for reuse and this commit
log covers all reusing and remapping required - IOMMU buffers, device table,
etc.
 
>> Instead of allocating new buffers, re-use the previous kernel’s pages
>> for completion wait buffers, command buffers, event buffers and device
>> tables and operate with the already enabled SNP configuration and
>> existing data structures.
>>
>> This approach is now used for kdump boot regardless of whether SNP is
>> enabled during kdump.
>>
>> The fix enables successful crashkernel/kdump operation on SNP hosts
>> even when SNP_SHUTDOWN_EX fails.
>>
>> Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
> 
> I am not sure why you have marked only this patch as Fixes? Also it won't fix
> the kdump if someone just backports only this patch right?
> 

As mentioned in the cover letter, this is the final patch of the series which 
actually fixes the SNP kdump boot, so i kept Fixes: tag as part of this patch.

I am not sure if i can add Fixes: tag to all the four patches in this series ?

Thanks,
Ashish

