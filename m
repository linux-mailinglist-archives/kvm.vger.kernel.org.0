Return-Path: <kvm+bounces-26953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E95979A6D
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 06:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98D55B20CBC
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 04:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1164E2868B;
	Mon, 16 Sep 2024 04:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qiJeZVKD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4FC12B8B;
	Mon, 16 Sep 2024 04:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726461759; cv=fail; b=gjipdWe0pglMMojiAQDRP/dTWb5mf9XF8BWDzwQ5rI8lgRt4kg5YHXFzqC0jalaDfvLR+myU14kjnsA+iycT0148pvAVIc4Xcmpu33NH9BYTA6VNIDiTMQuUUyhRdvMYpUT6tfKxRRUZPUVNQr735WmfjRa9sdo/e6C7c2XNY2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726461759; c=relaxed/simple;
	bh=HhPzdSQ5ds0r+RnQpPVJB5li+vQ2KFYI3KhS9LD9bXo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h/sE0bJ69omlOyGVOCKvjhn3ByefzEyboGANH7/OLrldaobPQ7iOGfg3Km9fYhXOgSO//cJu5/jiPnTDuMhuigSi6hdp0f08PG2KkpsP9bI2LTQZtztGjiN960XZYR3kmlDWsXwbF0WQ5i2t/6XCKvRqdutCCf9Si0Dss65/vN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qiJeZVKD; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnmazY8FatdE/GLFQ93zLKFV+HHVxEGfTK3iwM49+alQR7QfR8x9d1k1fMwdhxUyLb43Xj0q9NRnrxYSUUzthX+U3WIT30EcMDoxWQqCz3ERPoelbi93I7uIiiKwy4Z+GtIqY2RhiqmYsxlTC/foYoLmTA0BrX5O4nz9D94mddh1WqDfQYU6d54w6oAPVVYplQUOJYqHZLfVsLsjNMjQN7xdJ5Udq837djgbEYIkYjdUJ9P/GSGxFt4uqvxX1mbtl1oTvSvcnwiX0clCdLhO9lVCoLpyQozbb+zYyAM/8ktipCK3U+iCwMJl7iJT7PV+7Vm7HtmHZ2eAF92BrYz2mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0LgT94Q799yWGEe/BSoKLhkXANTdb1B23Pum4a5xvo=;
 b=vYsbBgpq1DFtEQ7R9BV9vrLZoVHx+gyiV/5G0aTp/7nDuVSTyFWG2bz9FWkeE6zGxDY17KhQ/cuOF+0xowhCVV/I7b0HiCzFFTSI07bBNI1bd/PEeXXGz8YYTbwXfzGs3mE+PEfPH7Cl8FPKzpr56SaCRgCoGAgiBnEYNbEX65xSvPEcuHNzg9Fe68sCV705lLvfTLprN2NQI2AvwG6TkBG/PuRRA+TA0bkchogm8Srwe4YZhG4MynIdSiwpIddGlUV8+kwUSPEa3gpq/yNyeDG1g8Tf0Usdq/r5SmP0a15jen2lEpV9YXHs32IFAx9y8W+BAn10kCvV9fhY93jT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0LgT94Q799yWGEe/BSoKLhkXANTdb1B23Pum4a5xvo=;
 b=qiJeZVKD3xEp3N9dNxNaSretwqLimpk5Sye87wkh1/wkL0YbhjnCSqqcf3TWhCizqEwyd3TD8SHgHe9+me/UxBDXFyIVfPMfr1XNaYaubXjN5vf4FjBbXM5qzuAhqgNEkP4P0Ppk5k240iWNWVcgQjnZrR7pu+2Ms+Zqcc5KF7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by PH7PR12MB6000.namprd12.prod.outlook.com (2603:10b6:510:1dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Mon, 16 Sep
 2024 04:42:34 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%7]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 04:42:34 +0000
Message-ID: <55c3446e-87dc-b796-3484-2d66b008baa2@amd.com>
Date: Mon, 16 Sep 2024 10:12:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 12/20] x86/sev: Relocate SNP guest messaging routines
 to common code
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-13-nikunj@amd.com>
 <320d1d25-ae9b-a474-086d-95b43cccfe32@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <320d1d25-ae9b-a474-086d-95b43cccfe32@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::10) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|PH7PR12MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: beb275a1-8c3a-4500-f123-08dcd609fb5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVIxeVZzWWQyWk1nNXBBbWNWUFVLNkVuU1gvTElJZmlTdnBteWVWa1dTaUQ5?=
 =?utf-8?B?NGJCTkFFZHlTSTNFR2FPQ2dpejdveEY4NENDREo1NjZBUEVTZFMyNU9KT1k3?=
 =?utf-8?B?VW5Od0ZGOWhiZHZyUWEwRU00dDJYSk1xNURzV2RsaHVpaXBzWW1BNEdQMDVG?=
 =?utf-8?B?RkFGSzVNaWVIa2lTcEFrWW9TM1Y4aUhNK3RCK1BZbEYzODhoMjh1cXg0NW5S?=
 =?utf-8?B?bDVvRjNhb2l4RHJwMkhTbUVRNWUvL05Kd0gzOEMyTVE4ZmJidU1EZ2E3VGdG?=
 =?utf-8?B?RythU1VJOHd5TE5xU3dJR0hmMld1MVAvdTVONVR2NWRrNmFOc2tsRUxJTTBv?=
 =?utf-8?B?cmpZVGN1YmJxUWx0U2ljT0VSNmRwUlQvTjFwVWxTci9nZFg3L0E0UWVhaTZK?=
 =?utf-8?B?cU82QzBxS3BRRW1kTVVNRXJMYm5xTkNzejhJL2NuSEE1amFualViazVURGZl?=
 =?utf-8?B?VkcwS0tseGcyL2c5aU9kS3pHbmVuRlFKb2hiRC9oUEt0WTNmdzVPYm9ORFFO?=
 =?utf-8?B?cFdxbHVNcGtaQUkvNHBFUUxlY1Z2MFlBeTNzbUJBc3gvZG5lQjQ1bWlTNGgw?=
 =?utf-8?B?NjExRk1pS0VKTVFOV3lHUmJ6UThLOEo3ZDF3YWtkV1RwU1hneEhSVlN2VmY3?=
 =?utf-8?B?MVIwTDJpNnlMZXdDQUxXemRPQUlERHFxakRJL3NtNCtzRFg1cUZ5eDJ5VG9J?=
 =?utf-8?B?SXVyaVUvajE1UTRMSGZJUDJKNGxxZm4rMzVJSlVkUTh5UkxyNzVpVENLSEs5?=
 =?utf-8?B?b1Q2bjFONWR2UUR6L05ma295T1A4MHd1enZWTUVkSVBuSkIrNHk3bFg5dWNQ?=
 =?utf-8?B?SmRsUW5LYTVLRU95V2RVRjcvK2x0eVRacFpwaWVHOUJ4Q1R5eWE1b0FhOXBZ?=
 =?utf-8?B?Zm8vR1dPNkhzajFXM0I1RWRlRVJtVGRaeTB3WkUrY0ppeTRnaXlkeTlIb2Na?=
 =?utf-8?B?Z0dGM3ZGVk9GelVWMWJhcmFScXVYTit6NVcrcXh3bU1Ba1dBZS96NVFiWWVi?=
 =?utf-8?B?azNiUE9KVHFDNjBaS3k5SlUxcTB3Rzg0NjhDckxxV0U2OUI3cytuMFV3K0Fa?=
 =?utf-8?B?TVBDejJmZUlTQVlMZjF6aytCa2F5d0xQS3l1MEZLaGgrT3J2azFkUUZKUjhk?=
 =?utf-8?B?V0pPMjgvd3ViMnNEOHlYcDhTNU5lR2doR2tvWEtqUGVMZ0xMaUJ4Z202K2FM?=
 =?utf-8?B?VXpRNk5KT3U5ODlvZy94d0JRN01BeXRmQ1ZNNEppRVZqZWZnQWlXQTlabmlj?=
 =?utf-8?B?RG8xQTZJL0k5cEh1c2c3ZENIS285Q1BHNm9RK054YW1lak9uWCtXcCtjWUNk?=
 =?utf-8?B?SHM2RUxBWml0b2laUUcyM3NWbUhzZXpQSU5ORHlKVVRXVlB2YjhuMXNZUE5H?=
 =?utf-8?B?alJaRGFYTnZUZlRNN09iSW1obVdQS0p2UUp4SzZ4UldmQlQ3OStLcE05Snc5?=
 =?utf-8?B?RHRhQklxTHY3VzREQ2p6YW9jdG5SSC90cDZHeVpLeHV2R0tvTG1Sd2pQdmxr?=
 =?utf-8?B?K0tSc0RyNTBsOHloclM3SUZNbXBBS1lJQVdCQjJpMXlOUkIxT1A1bXR4S2wv?=
 =?utf-8?B?M01mZmFXUG9sRDR6T2ZmNjlFMHVTdFh3SHE3VFMxcFpQeE5FeWFGL0hZY2JZ?=
 =?utf-8?B?eFpsTEN0bmxiV21YQ3dNdGV4bDJ4aU1xVlRSQlYxa3RrRGEwUDRMSk9IRTZ1?=
 =?utf-8?B?cHVnZmJyazlWTmVzVEh5QXY0Uk8yaXVzYXZhVzZScllZbGFuYXNJN2RMRVRu?=
 =?utf-8?B?amZqdjluczBJQ3BKRDRWcVJMOTNyZDBxOC9CaWtZcHlIWllUaU9WOHRuMjBp?=
 =?utf-8?B?NlNORHJDSHkrQklHUlRvQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R25OM2FRWjJaTWRJd2xZNkZjeUpnbEpVSnQzVlgyU1RnNWQwTlF0YnNEcGNY?=
 =?utf-8?B?QzFJUFF5VDExQXdLalZ2WXI2WW9QOHAvODVrRzFPYVFYUXRTYndBYmNCNWxN?=
 =?utf-8?B?MDNXZjViSnpMbHVkbVEwZFM4aWxtSEs3OW1HMWVFTm1CRHpiRHdkQzZ3MUJy?=
 =?utf-8?B?cWZUY0dtYnhJbENIY2NSSzBCQW42RytPU0YydnNCcE9NaHVKMXQ4S2dCU3hO?=
 =?utf-8?B?MzZFQ2IySmFCakZwM0NOb2tVd2ZBL3RDNGt4dzhHQnJNcEpXN0ZUU0FzWTJC?=
 =?utf-8?B?cHBxTzB0aVRhUTBWSHFxd3Z4cGVrNE9CLzcreG5PdmczcHh6WVVkVTMvYks0?=
 =?utf-8?B?d3N1TVg5bDdiWXdEaVpSVWI1TU5NR0c3eHNWTVBhdDl3TEFVRSs4Zlp0Y1E2?=
 =?utf-8?B?V3FmRTRVOHhja2FqOUkxNS9idE9tVjErTFJYblpiOThyYTAzemVGcDJpdUMx?=
 =?utf-8?B?V0k0aDdzZEx1OW8xc1doVUg0clZwajFBL0M5ZlpUK0l0RWJUUFVQekpWZlZ1?=
 =?utf-8?B?UXVYUHhmbktBNXkrdXJaZlBWMmhGOWlWdzBsMXgrWUtkdWsvbjI5bWU4bk13?=
 =?utf-8?B?eVc3VEdsNHlOYW41VjduNytqaFg2MVNuZHVYeVdmTE1iTTJDSW9ya3Z4MzJU?=
 =?utf-8?B?N1JqWjB2akZDSSt5SVgya2orRDlUQno5VHZrUVE4TTY0eHdYM0xVSmx1aW5k?=
 =?utf-8?B?cnVOUFB0MWVjbVBIWGtrVzkxTkpaSHVzL2p5Qk1sZ1Q5NWp1T3JmQ2xzeGN2?=
 =?utf-8?B?cEVkL0o2WlRwQ2VCa21ZcnFoS0Q4SEdZTnlaTFdHVmNPMFUreGpGL2ZDanZJ?=
 =?utf-8?B?VG00T2lWakFEeklMKzhhOCt1S25VTU1VWUVZTFV5MFVncjlxRnlhSVZiR1U1?=
 =?utf-8?B?YkI5ZXdJd05CSGJZNk1jZUF5d2pVcWErSlNtMkkrdmJFOXQya0UwK3pGY2JQ?=
 =?utf-8?B?bkdCZ1dqY2FKREdsTGZxVm4xaG9ha1VXaE1sd04xeEJuczhseHV4S1JsbEc0?=
 =?utf-8?B?YjNGalRiVTFkNmtZbGZ0SldoSU40RENVWEhvVmJmd2toT1hMNTZZSGdGMFFD?=
 =?utf-8?B?bGp4bDZjcVpYWlF1RWZ2aUxMdXU1UG9adkwwZUQyZHNYTWdNMmt1OUxCMGRy?=
 =?utf-8?B?dGxxc1NTSDljeFBZRmVTVE9yZXhlQVR5RCtPd0c1b1ZnbnVtbithMTlTS2x4?=
 =?utf-8?B?bjVySUI3Nk44RW1XdzQ0MWJjNW5qRkFicktxS0YwcytWVFpxQmpDSkkvMnBC?=
 =?utf-8?B?VDZvbW5maVkyek5VdEduUVFwZStjTEtsQ21pUkZ5ckQzM2QxSGhqVFBMSzc2?=
 =?utf-8?B?dHpYSWE2TUVpbmpCaHBVRE5tQVdUdG1BYWY1SVhMYi9EVU90TFBTTkcyaFpm?=
 =?utf-8?B?RGZnbFpQRm1JOXBFcjZZVGRtUnJYaFh4ZjYyWlFEMzh0b2xwZWdFbzVWT2dy?=
 =?utf-8?B?RGhBcDIreDRtZDhwVnIwT2N4b1dIN1ltZGdBUUUrcVhkY0ZUN2p0WWZOMEpI?=
 =?utf-8?B?QVJGVHd1dEJ2dGptNDhIaEdveHM5SUJJeFA0YU5JbGZjK1VLMGtYa1ZYRmpI?=
 =?utf-8?B?dlgrKzdvVjNmN2VSUlpLTEVicjdPQXovaVVoL2k2QW50R3ZIaUJTNWRDNVFT?=
 =?utf-8?B?cDFZN3NDNWd6bTNsQWR4R0E4R3FmLzRMa2FVbm5yUmZTc1hybGwrMDlNRlFC?=
 =?utf-8?B?a0FBcFhYb0N4Q0poNVRZVnhhSUVBN1Z0ejlhMmZLVVZZcExVemgra1F4M0x1?=
 =?utf-8?B?UDdnV1lSSllUaDRwUWUyWk5jVEZQS1R5djVWTzRzdlNCZVRQUnBYTzVFZG5S?=
 =?utf-8?B?eUJDVmJZWWR3UEl6SEtIU0p3ZjRHZmRlKy9MZnNST0UrcHJpVmpjYnQwSmxX?=
 =?utf-8?B?LzRLRTFGM2hDQUFLNFVKaS91MXN0RFZXR3VHeERSTGV0KzZVM3VOUCtkZWEx?=
 =?utf-8?B?SHdkb2dub0g2VnhnODJ2NTRXVVVWdzR5QkxCLzJnQzluTFIzd1RnSEFteDZF?=
 =?utf-8?B?cS9tdmZwY2RVbUxNMkJrSWhCSDRhVGJaK0gwWjhwMUQ1RWxESWs1dDY5MDhn?=
 =?utf-8?B?RVpzNWYwWEptQmhaSURBeWdSRTlncjVZd0RwYm5GS2tsR1pyNHNkRk90bGhX?=
 =?utf-8?Q?MeBQT2vsd7Y7aTru6MV7ikmw/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb275a1-8c3a-4500-f123-08dcd609fb5c
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 04:42:34.3246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ywJm+j2kr/hwixgl/NRqrC19hYI6DGE3303uDKgsHt5cLwX39cgvQFq56iQEhzpw850D48njxdBSF2msVnw2zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6000



On 9/13/2024 9:57 PM, Tom Lendacky wrote:
> On 7/31/24 10:08, Nikunj A Dadhania wrote:
>> At present, the SEV guest driver exclusively handles SNP guest messaging.
>> All routines for sending guest messages are embedded within the guest
>> driver. To support Secure TSC, SEV-SNP guests must communicate with the AMD
>> Security Processor during early boot. However, these guest messaging
>> functions are not accessible during early boot since they are currently
>> part of the guest driver.
>>
>> Hence, relocate the core SNP guest messaging functions to SEV common code
>> and provide an API for sending SNP guest messages.
>>
>> No functional change, but just an export symbol.
> 
> That means we can drop the export symbol on snp_issue_guest_request() and
> make it static, right?

Yes, let me remove that.

> 
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
>> ---
>>  arch/x86/include/asm/sev.h              |   8 +
>>  arch/x86/coco/sev/core.c                | 284 +++++++++++++++++++++++
>>  drivers/virt/coco/sev-guest/sev-guest.c | 286 ------------------------
>>  arch/x86/Kconfig                        |   1 +
>>  drivers/virt/coco/sev-guest/Kconfig     |   1 -
>>  5 files changed, 293 insertions(+), 287 deletions(-)

Regards
Nikunj

