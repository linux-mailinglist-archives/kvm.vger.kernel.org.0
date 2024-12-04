Return-Path: <kvm+bounces-32990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9226A9E369E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60535169324
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 09:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48071AA78E;
	Wed,  4 Dec 2024 09:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l8bGM5bv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F09E18E056;
	Wed,  4 Dec 2024 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733304640; cv=fail; b=VK95PD11KybOQ7x+xMLHj4MRaDcJKCRt1rYWcR2s9trF2COYxRPO0NM4dp05hjQ2zLKTKlmNOezr2IkzMRcq1DRbwMpERt3S4t6oYohY88BgSWuBFOlo9t1R8GHhToPwmDGYPtxdHQ0FFkLJVZl5JxosvlF5Oik/Ra/v1PivBSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733304640; c=relaxed/simple;
	bh=1Y7PuOaExRLjgW31YEPQSPda1IPj0i+Ul40UhxCkLaI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E4D+rj1HBRhn6MCqoi9EGO4Yo6BCimEhebg3FS0Y/p2KciUesUSM+pVgsdn6EC0Jbih+QkGKKqXoAVEUk3CWdqsaU53at5TT0FQM+U+hSBXxJnRap8uKpoAmjkp4JfhGvgwwuvkrtZEKjxRWAjMgqA8UEQorG9XSMlaxCtOnoNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l8bGM5bv; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqR0HEMCeBIaXWoxUJ0GyqCeqrYpAgQ1gxxAJqRpEk58x6grE8YbOjfiAjO+QCDmZlvYSgCQhBYedzaQ/vjn7QSjSzkw+rdaUOE66AknAesvjeNlJRu/NGPpl3PR6sVW/xY6yHxltbYKohnVnwjqTeq+qhDbFsg7FK69dV99oAXsLU5euXVxWpcN6lA1O9yzAfcmlkTPgvyrbawCI9Q/j9E8l6INAPr5kUSZy+uNdYJTxxBk0nJ67lQzueFz1WSX6OkWWHDed9INDQB22wyov28SNf0pqfcdsbZZNVZI67NVSsx5KmEg5uwrxTZOrhAxjK0NXuU8FO7l8qBabgArLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQyh2lCf0RTJpgj9TTXuizDeTwh9DaPxdIrwU8OdiWM=;
 b=gYiYv2lklpMAT1EIL1+2xaIarOMIj3M57QphCNGrJ6wXV4MJ1Pudp+iVdrl3uA9lJcof6+om7LtGHrooBS+ouyWUMaF4ipMFaRopeAx529T7gzI2kyLtZTEEBJHabnhMAt42vy0+7/bnnQ3JXuNhtzwUfraDRFQ7vEkA0Xuu9FxVok33p3sbSc2HoWjwLMxjG0Vgo8QwbfrjmsGgf5epjpnkLtAOov+Pa+8WrYvUnKY79u5UqxrLa3kK4P83H5JZu5ssR4fibp9xQroUzyHha2USNqFJFW0F3MY5nMW9i88x16+NqM3KUJJUN3EFGKDOSkQda1Yrw8/S868oG2CShg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQyh2lCf0RTJpgj9TTXuizDeTwh9DaPxdIrwU8OdiWM=;
 b=l8bGM5bv+tpCbBfapAzE4Sx9+fSt14xjno+bqoa7qPNu397b8vFQOGxio7UC8YHZXQoxz9+SfAl3tnV6oQw562/ntKY26VtytOfyINPacTHV+yTBmVfGwYxt9gk+6FrghnMo7Hd9m+X9xtPKyqIkjWQ5849eDNnD1ujDdThctgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL1PR12MB5850.namprd12.prod.outlook.com (2603:10b6:208:395::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.17; Wed, 4 Dec 2024 09:30:35 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 09:30:35 +0000
Message-ID: <c49607f6-6548-4fb5-82ca-5de393c2bf36@amd.com>
Date: Wed, 4 Dec 2024 15:00:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0176.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::31) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL1PR12MB5850:EE_
X-MS-Office365-Filtering-Correlation-Id: f3cee10f-4cb9-4590-c96b-08dd14464e61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzB0UUJTWHU0a3J5UnVtc2pwM0ZrTlBjWHpxTUNmN2c2cHhPdW41dWVndTky?=
 =?utf-8?B?WmlTSXVJMGYrNWVyWEVkR0lrMG5zSkxxRE4zTnRGMFArdTBuRzJhYUJ3SFlw?=
 =?utf-8?B?b0JZbDZuL1JuY0hqejA0bk1kV3VEOGs4Y2g1bW9HOElsS2NRZ3NtSXQwOUhQ?=
 =?utf-8?B?cmVTUTdaVGEvREhGeE1GSHlHV3dUczRQY2tMYk5MdDVTc0VtNEE3WVltTHNm?=
 =?utf-8?B?TFBhajgzbFVVdVU2S2pKWXoxTStyWlBQeDBET0NvTzhDVnErWDdGb1NtVzR4?=
 =?utf-8?B?T3kxRmszOGtiTjBTU2JOc0EydnRTaGhkeGFGS0VwZFVQem9zZFdDMmtuR1NE?=
 =?utf-8?B?aWFZWUFWcGNCNXNJUVRLUnFMNnpEc2Q2RVBtWFR3OEI2UmZsaUxxRittUklZ?=
 =?utf-8?B?dkErMUpLWWVuR1RwZ1R6OVA1QnR0d1dvUmNCV0g3QkZreWNTQ3pGaVZocWFX?=
 =?utf-8?B?OGkxTVRWRkFlTGR4akNVT21kTjR6WGJ3RE5sRUpTNmFIQmsyN0prM05pWEVm?=
 =?utf-8?B?L2VsNUZ0c3IxK1pzNEFxS3RaL2dYNW1LRGZnTmIza1hQWm5IMVpuUzB3TERs?=
 =?utf-8?B?RHJkVGpSdmIwODJEZWl2SXcva2JNU3Y1KzFJMTNVbVNDa2pHZ091YWlydEpD?=
 =?utf-8?B?Vzhhc085Rjd5L0h1c3pCaGE4L1BxbThHbEcxRVR1QmdMMmxNUnZTbmJ0REJB?=
 =?utf-8?B?ZldQQVNMRDhZdTFuTFROd0dlMDRBeEw1MGRkVE11N05zNS9ZVENTc2hQcmox?=
 =?utf-8?B?cFRVUEd0UkUvRHBiNnQycnkwbXNKeXVpZkNpZTc4eWJoZHlhSGY3TStuckl2?=
 =?utf-8?B?Z2VZQWM3UFIyVng3UnpTRlAyejk1NnBOK2FObzEvRTFDWVpBTDRMVktwV0l6?=
 =?utf-8?B?Q3lXbVVDd3ZjMmdMTUhkSk5HWSs4dk43bEg3dGVwbGNRWjRtWDVZblo4cGg2?=
 =?utf-8?B?VVQ2eUJHYmMvbjBCR290VVZ0SHlzVDgvNSs5QU9HN0hyOUcvcm5ySmdxaDgx?=
 =?utf-8?B?ZUxDQlU3a2FrOE1wMS9aUExzd2o3YktrZUJTWEpwdUNMd3A1a1liV2NjUTkr?=
 =?utf-8?B?UEJ0bWJwQ25SYlk2ZjVhN21LQ0p1UjhXeldBenZnOVRKMFMzNUNRK2xLZkly?=
 =?utf-8?B?RVpHZ2kxcFk4dlhEcjdpNmNZVEdmR0pEckc4YjE1TjhhakpvcjRXZHM3YVd3?=
 =?utf-8?B?MVl1aTA0QjN5cmtLWFZseTk4em8zN0g4TXY5QkVCdFBxdDY3QTNycWZUdXhM?=
 =?utf-8?B?WjR5cVlNNVdxRzRjdktoczRoWFVnZ2pkMGN2clE3Wk9MVldKUWFwVmIxaUpp?=
 =?utf-8?B?ejZuVzBEYi9DYWtYRGtUWGl6VGJibXJxRDhOUmE1anJTZ051N3ExTDlBTnlG?=
 =?utf-8?B?MG84SldHV2ZGYkJUZnJsekcvQWprSVVseWlsS29Bd1lkcUJiU1BjaUllVkls?=
 =?utf-8?B?YlV2NjlHOGNPL0ppTjVPM0c5MittcEgyTUJaMTZ5WkpHU1JhRFpMb2g1NTlx?=
 =?utf-8?B?QzBFbU1vNlAzMmFjb1Z0YmhDV3lmRFI4MGoyTU1ocDU4Y2hmbmxUOEhYQ1JK?=
 =?utf-8?B?VHFmZ2JQa1pMZkFBTkZBL29WSkt6VTl2Rk1CU1MrVSt3TFpidVdMN1RMVERD?=
 =?utf-8?B?L1dVOStOV1NyUEtzS2ZxQzlyTm1Kem5uY0xuUk5INGFzU3M0M25Sd3djUjRZ?=
 =?utf-8?B?RHBPcnFqSEZvaEJjUkJpS2JTM29wV1VJM2FZMDMvMWg5amZQWGg1OVhMZk1Y?=
 =?utf-8?B?WWV1SGV6bUN3SWg0YVBwSVdISFczeTVuaGxHdUlUTlNIMDFxNksxUk5aQUJZ?=
 =?utf-8?B?RDcvanpZY0taa3pGeU9GUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzBXaDVsenZxZzMzMEhUc1k0cTNseEtkaWxqcmZ4TzR1UkQ2Q3h5aHN3UDJX?=
 =?utf-8?B?YUJHcGV5SVJ2T0Ird04vbmZ6OHU0aU5sdWdCb3RZRTFFYWxNYmpHSmxWSGkx?=
 =?utf-8?B?bVY2VnROancxRW0zVTdHTTAzVXpCYzZVVzJiMm53Rm9lUURzZFhhRVpsVzFH?=
 =?utf-8?B?SnN1T0ZYcTVQK3lyK2xGZVpMc3JHVFNXNFFhS3VDYUUwVDhlQ05VLzZ6dUdL?=
 =?utf-8?B?dkhWOWJ5UnRZWXNXajdIZmFHWFMxMzBzRnRLVzBIcklsclBKOHlZNFRZQThz?=
 =?utf-8?B?M2Uzd04yTG9HTUxobjgxS2p5L1VCblRLQkxCejFhQ0Joa2VLcXVMNHRUcTJ3?=
 =?utf-8?B?TndWT2dFamkzSmtJWlQzZzRkc2Y3T2tGbXNuZUxwMjdNN3d6NUFWN1RXZHpm?=
 =?utf-8?B?YTF3RFpxSzE4TTI5UURqejMvQ2hyTTdxeDI3VzdFQ0Z0WWxuVzJkMkZMcFhQ?=
 =?utf-8?B?RVUwT0RCQUNwNDdGZHFWMGRBaGoyZFRBamxpWHM1ZjFZL1JWT1FHRFFjRUta?=
 =?utf-8?B?Ujd5dnl3eDVCRWJlWnJEN0hZU25USHRodS80NzJ2TTlyRTgwTGdGYVcrQTBO?=
 =?utf-8?B?NCtuVFJPK1VvbnkvZGdxWXFjYUp1VmhJbnZ2cCtQcEo1WmlBbEpaTEdwcVdu?=
 =?utf-8?B?MU5INHp5RXpRMXgzQy91UTYrWGt3Vm1FMHBnZ1NPcWpLYW1MQlBrVzhUQk5u?=
 =?utf-8?B?R3p2SkRJZ1A4QWQ5bVh1Q2xhQ0JLOG5Cc2NlQWhYMUw3TkVSYzFqQkI5ZFp4?=
 =?utf-8?B?VENhb2krQ2dxVjFJbi9ZaDNpZ29HcHRHS3JjZ3U2WGZ2Y1VwTGRIMk1LYU40?=
 =?utf-8?B?Zy9TTEk0dVlRL3FISllXczhuaFZac3I1YnVMTm51UTZjQ2UyeHUyKy9JYVBY?=
 =?utf-8?B?ZzhxU0lnRmhya0xYdmFmejlNZ3RGdy8wQkZ3a1lTVXJnSmpwdWhKSXZVdUc5?=
 =?utf-8?B?eCtSeGkraEtBY0xyMWlTaUVHNmFqZDZjSXJ5UHVHRHBkdk9ZNnBoaDBJTnpq?=
 =?utf-8?B?bWpieWdlZkQwRWYvbG9UaktLQmt3bVh1NmxJcXJhc1dmRzltSWdLQjB2MTRE?=
 =?utf-8?B?M3owRllNa0JnVWpsRVlOcFhaY3l6a3RDcG1nbXlObmttNmdSQmxLODJkellE?=
 =?utf-8?B?UkxDbXV5S1BlZGx4K2Rwdmt4UlF5MXFRb2x5OWxzR3ROaElnRTg1RThwY285?=
 =?utf-8?B?R0FNWE1YRFNFWVpDb3hNSENrblQ1SnNEK01sOVZ3VjZYYy9YZURRanpRMFJS?=
 =?utf-8?B?cHNlSUVnZENic0tJbmRYcTVvNk85WXJaYk43K09lR1dLYTdqWlU1T3ZtdHFZ?=
 =?utf-8?B?WGNSODBTeENic0tjay9FcXhDbVFBeGxRRGxUNm9lM2tNS1JFRk5PWTlOS2pp?=
 =?utf-8?B?dEFjbTF4YjVyWk9QcjVUMTVLNzR5V3RuYVhqMlRzQkRKUlZRblNLQ3c5ZktY?=
 =?utf-8?B?b1YrcFBpeDdGQ1FFRFpuRjdpRFRZcFBFeUtuRHhtM3cxZVA1VVNnSUZxSVc2?=
 =?utf-8?B?dFZ5MHVyLzU4MS95NHo1QjIxYmJTQ3kwL25DSlg3dHMweVB4Vk9SMWxTM3k1?=
 =?utf-8?B?OTNwWnF3YTVnU1pobzBzVEJ6akJnZnJNbUNWTWx5YVlGQWRlZVVzWTlKSXNV?=
 =?utf-8?B?UjIxWTZla2lwSUw1UFZZdTlRcEVocVgyL0JvNVFic25RR2I4bDVOdXV6V1Zv?=
 =?utf-8?B?TlpSYllxRjRMM0dwb0FpRFJZZk1kcktWdE02enBQOWJVaUhXT3Fic1RNdFpx?=
 =?utf-8?B?Z1Z0YjA0MVV4blRVUU5GbDUycG5YOERBQVhXa3VhTWZoSmdOeU5IZHg1TEFs?=
 =?utf-8?B?dWJwQm5KVWVHbW41L1FtWkdXbEtJQVdHMjNSTFNpWkJxWm1oVklXdUZTcFZo?=
 =?utf-8?B?b0VFS0NmK1hwWUt2ZytsbHY4elM1QlFvcldBYUU5S1VJVlhBWFFiRERYL3Fz?=
 =?utf-8?B?RFhQWTNpQmlRU3NYYWs1UDc0YW96cjFCc0hkNHdyUmdBYkY5Y2s1a3Uvc0p1?=
 =?utf-8?B?S3ozeXpVOTJ6VUlDMHJaLzNUR01raXY3cXNQN1dsUXdZY05pcW9ZODBocG0x?=
 =?utf-8?B?WEVMWUN3a1BmT3NNREpUTmovZTlzRDRvTVRDYldIVjlMWTVsWUpFK0w4cXB0?=
 =?utf-8?Q?UaYLVF6LZffMd9av0+ujPW7+N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3cee10f-4cb9-4590-c96b-08dd14464e61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 09:30:35.5307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxhORAIPfHAokvJaBliQf7JUbU2bgAO10KQOydbD1GNi/4K7LPMffMdpk8gMqLhlVrxPxjxuXSPhMu4zxBXQpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5850



On 12/3/2024 7:49 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:33PM +0530, Nikunj A Dadhania wrote:
>> @@ -458,6 +456,20 @@ void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot);
>>  void snp_kexec_finish(void);
>>  void snp_kexec_begin(void);
>>  
>> +static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc)
>> +{
>> +	static const char zero_key[VMPCK_KEY_LEN] = {0};
>> +
>> +	if (mdesc->vmpck)
>> +		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
>> +
>> +	return true;
>> +}
> 
> This function looks silly in a header with that array allocation.
> 
> I think you should simply do:
> 
> 	if (memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN))

Just a minor nit, it will need a negation:

 	if (!memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN))
 
> at the call sites and not have this helper at all.
> 
> But please do verify whether what I'm saying actually makes sense and if it
> does, this can be a cleanup pre-patch.

Yes, it makes sense. I have verified the code and below is the cleanup pre-patch.

From 4d249f393aeba7bed7fb99778b8ee8a24a33b5b7 Mon Sep 17 00:00:00 2001
From: Nikunj A Dadhania <nikunj@amd.com>
Date: Tue, 3 Dec 2024 20:48:28 +0530
Subject: [PATCH] virt: sev-guest: Remove is_vmpck_empty() helper

Remove the is_vmpck_empty() helper function, which uses a local array
allocation to check if the VMPCK is empty. Replace it with memchr_inv() to
directly determine if the VMPCK is empty without additional memory
allocation.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index b699771be029..62328d0b2cb6 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -63,16 +63,6 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
-{
-	char zero_key[VMPCK_KEY_LEN] = {0};
-
-	if (mdesc->vmpck)
-		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
-
-	return true;
-}
-
 /*
  * If an error is received from the host or AMD Secure Processor (ASP) there
  * are two options. Either retry the exact same encrypted request or discontinue
@@ -335,7 +325,7 @@ static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_r
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(mdesc)) {
+	if (!mdesc->vmpck || !memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
 		pr_err_ratelimited("VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -1024,7 +1014,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	}
 
 	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(mdesc)) {
+	if (!memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
 		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
-- 
2.34.1


