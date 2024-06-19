Return-Path: <kvm+bounces-19922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBD790E309
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29C201C217C1
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 06:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7BF6A332;
	Wed, 19 Jun 2024 06:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IWvE+5a/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB7E57CB0;
	Wed, 19 Jun 2024 06:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777192; cv=fail; b=D4RVwdrXosbyZFiiKbM1G9FB/obZvKdfOs/3p5g5++yG4HZDW12Yw8TOW8jEPHLlCs9MlRq3zqxRha0PaDavlD7XB1+PVL0QmDqItPP0K1KpcuN9eMzTgNYaR35gTdouZBxnh2SrNUnz7OM/A7QefJTrILcevY7VO/fxH97qOw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777192; c=relaxed/simple;
	bh=IlywmxBxBYZVotTJfm+VWHOUo4mHC+9AGrHu1bd8rxA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jg8j4/XC+rKx6Mb89td9I1o/386Q0lJVLTLM5sj+SZGHkPB8fGjr3TizmUIcr81IkTpaFyaIH+OphTMTLM1Uex2AVwxjd1+MVXqUDztMp+rJWrmX0Dbx5xu2deMA22vNRcrcxWUSvHkCFpnTh1TZwwJ3wE66nRAaW+FZLd0EEHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IWvE+5a/; arc=fail smtp.client-ip=40.107.237.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvliwGwrI684HaTrbjYWeudWAnhOR7xTk4NDmws42FM8sTUKzak3hqfakZX0qE/D6fEbPGgNodtbnyw5vv0X/wFj1U92VbTsAcb4w+zOoeMImmkEFpd6Qzc5hikNzaMWzn6MV3f5j6oINdZmZqgSuPnzmtu9GfwgHecmOgpIu2UutC0qWcbju1ru2SxNa3mtGcs6DIvuWgEK0s/xnsBF96L8awZjleHByryKjcbtcCxfPeg6fEqrJNgBr91ER4h171sbqpVepQaV5n0v5a7JoUkbSMtCgk4tk2CTJ/JKnHTI75jirkLRUMqQOUgwE5ME9YkkJLbadZxfw7gKgIZ3Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg52k/hfDsmwJ1JtdyMckYVqVkr1wBtgn/yibjrlFyg=;
 b=XBPZ3+4Z7zRKq91jnvnpNIAP6P11eFgQrHOgk4QY3vBuefzfBT5yNFGiVJBIdnVajaAyJ9JfmjMjLcW7XLUf0BQDFpv36N/jJ0lGJLtZqs5upy/TaPlEJY8HKB9EU4T8JLrQqNtzs+UbYCADAvIN+PvJRhjq2ywH4QUH+bXLp19I1N43P0DYVZkXxrMyj4UVkxnIJ5fKsxZK8KIPiPXDnRT9q1PYqjHnqadT54BE7bw0s5OfkeG3o3ZbJrcSR2wLbOOgJey5WdKTwAiN5iG6S1YUt7G3QbYHNusuUcVwB2Jnc90Oi9qm3ddkm6OWMKl4zbddnffcpeGPAotLNGj+fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg52k/hfDsmwJ1JtdyMckYVqVkr1wBtgn/yibjrlFyg=;
 b=IWvE+5a/cMGlplOaNaZ+l3z8GQLL2sYoZBQdBxxscyt+KujgxC9ttBLrl5WMuaYoSQPPsF3ESsVTrjktE1RkEcFHTwTHnqOYLh5ghn5ZPgSZyTD7rwIqmBPLkYobS6YW+WIDwfvvQPwHqHdkua+IZs5BNn/6Bh3rthDRv32FZ8U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ1PR12MB6289.namprd12.prod.outlook.com (2603:10b6:a03:458::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 06:06:27 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7698.017; Wed, 19 Jun 2024
 06:06:27 +0000
Message-ID: <9b8c57e7-a871-6771-dcc0-99847bbbcbc0@amd.com>
Date: Wed, 19 Jun 2024 11:36:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v9 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-7-nikunj@amd.com>
 <64164798-3055-c745-0bc1-bbecc1dd0421@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <64164798-3055-c745-0bc1-bbecc1dd0421@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0190.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ1PR12MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: 416dfa40-2766-4d70-5041-08dc9025f475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|7416011|1800799021|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OERBbjFybUV3Y2gzQW8zbjdwZzZKU1pSbjFFSTlVVlpkeEtZZUh4SjNZblRy?=
 =?utf-8?B?NnlRUHVYcWg5aXRwMFczMXpVbGxXUnY2Ni9mZnZ6UTJCK05MT1NBR0VtZ09o?=
 =?utf-8?B?V1B3V3NoUkxHUGJYdkQ5V0gyQW5lY3ROYTRNUTRyVGVEZGhwYVV2QkZTSmhL?=
 =?utf-8?B?Mmg3S1piUm44ejhTQ1hpNGdXRmx0eXdUb1YrVGU4ZzgxZ0NUbVIwWWRBUnI2?=
 =?utf-8?B?S1dGQXBhTDUzc1NWRmRkaVJGNGZaeTJYc2ZVS0dXZzJLd1F2OGJRU3dDVFl0?=
 =?utf-8?B?N2xTc05PdDZBaHluTCsxTXRBVzd0TGhlNnZIVGpKcnEvdGVUVnAxOUtTVWlk?=
 =?utf-8?B?OWJNZkNwR2JRRC92Q0thTEN2MW5BZXpzN0FqK3Q5QlNtV0tJdjBMWU4wMjIv?=
 =?utf-8?B?WUVvYzRDcmNTdjJFZldCcDl6Ky82N2VWelA1eURzT0hFcHN2Mm5vYUJGRFJP?=
 =?utf-8?B?LzhhdnE2Vkx3ZDNDTVlMTnB6SGUrdjF5Q2hLWG96UERXaDFST2t6UGhGa0RJ?=
 =?utf-8?B?QUY3MFBQaFZ0UW4zb3dtTjdWeFdFdmErNDF0czdQcy96aGxUdDRFWU1kOFBQ?=
 =?utf-8?B?OFRPOERmKzI4L1gxQmN3ZVZOOWJlL1RtTnhwczU5bzBtVElZRERkMExVbVBC?=
 =?utf-8?B?UVRnVGllRlREbGlpRGhrZzZBMFhYUVhCbm1KUFpnVnRhaUdrdng5eXdCWE1s?=
 =?utf-8?B?aVV6d3pIMHQ2SnRROU9KUGIyMDk5SjNYODBrYnhqVnlid09kSSt4L083MFZU?=
 =?utf-8?B?dFVPbFppcWJ6dHMrZ0hBNDk1dzNpWmpFeWpRN3Q5RWVKNG5kNityWEVKTHZs?=
 =?utf-8?B?WmhjOHd4eUFkY0ZlZTh0QzgrZGhuMG5hKzBxQzBSZXlaSi9MR1N5aXEzZnNp?=
 =?utf-8?B?M2R3SkRGa1JHZzg0eGVSNFdLL1FjZTFqaXprYm42MDhUUk1WL3g5QzlCOElj?=
 =?utf-8?B?aDNxUm92TmhBTHlKUVIyemUzZHU5UW5oaEhNdTJ6a1MwbklyOHVLTktXUWV3?=
 =?utf-8?B?bWNTK3ZQL3R4UXdqYWJNdmczUjZIcit0YTZlUVNkZkM5cVpaa2N0RFY0azNl?=
 =?utf-8?B?T3QvN3M4T1EzZnN4TXlXMDVWRWIxN01IVDJ6ay84bi85WlI0b3Bxcm5XUVdR?=
 =?utf-8?B?dCs2QnRtejk3Z29YWDlaSzg5dDdqcHJ6ZTE0NkwrR2lVOWl3TC8xTDg3Zlo3?=
 =?utf-8?B?UGpHU2lVbWFJZE9lenJ3b1h6ekQybXJsUDIxelNMcHFHRmtHYm90WEgyOHF3?=
 =?utf-8?B?WXNQaHJaTzNYK01lVjVVVitYZ0orNlovTW9mWUhjcHJYTmZ1cEV4bForK1Rs?=
 =?utf-8?B?ZDBObDQrMTFKZ1h6MmhVMExoZXc0SjgvUGtVbnhYTzVFYUJHWmt0V3lKOVZB?=
 =?utf-8?B?Y0o0WGhWVFNsY0MwQmxMSFZPMFRVRUJGcDl4a3V6MXpBMENwZHVmdlY4c0Ez?=
 =?utf-8?B?NlA2Q3p6UTVzQ1RXWkwvMmJpeWRybFA2Y2I5OU90N2VoK1E2ajRVeVhpcHdy?=
 =?utf-8?B?aGJOb29CSzRySkt1WHpvcFUrNnREL082L0NIdU9tSjNBT0wvZmNLVnpFN2Fz?=
 =?utf-8?B?WXhFQjZzMU9NS1Q5clhlQnV0UEw4OGw1c0RhNnI4eFN3Y3NtYlc0KzhPemxu?=
 =?utf-8?B?SzZGbnRLeTFBZ3dnc3M2Ni9rcG8zR2dQaTdrVlA0WFNJRGxkMzJycm5PQ3ow?=
 =?utf-8?B?WVp0Ky9qdC9PR1h1WnJ1US9OOUVQaldsQ0tVWGZudmVQK3VmdFF3T2pDK0Zw?=
 =?utf-8?Q?zV8bjO8PrjD7H8m1C8u9WwVIkNA7i/adrvfmhES?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2h3SjVsaG5VTGEybThwcm0vMkozenAwbFEva2QycitoQkR6RWNmTXZ0ZmRQ?=
 =?utf-8?B?Nk9VWDFtUjZESDh6Qytzb3RNdEtGRTVhMjFZTU02bWM1YTgrc1RCL3drOWdT?=
 =?utf-8?B?bGdXbFc2QUQyNk11S1RDUnc0ajlOOGw2SlhRbVRHME92ZVRsTjhiUW9YMVR4?=
 =?utf-8?B?Q214OHRJczlhYTNnR01KOHJub3F3Zk96cittTi95aExnd2dHOUk5VFAwdGZn?=
 =?utf-8?B?QzlmZjNjOEpIS1ZZNEJUKy9XYzhiaC9GUWZTeU8ybjdNdDFOWkpuT3Q4K3l1?=
 =?utf-8?B?emlWZVE3eWFHQUd0TXQvMFVDYWtWK1B0ME1uMkt1eE9IQnNvMXY3VW0zSlJE?=
 =?utf-8?B?VWZyOENueTNEVnkzZFhpWWZqZ3pqSXdzdVNyRFZVejZjRWo3aGNaYTJhN3dw?=
 =?utf-8?B?U0xHVHBBSTNaL1NoVURkdTVRWDcvSVdOMUxUOXFSMm5GcG14M1RkYkczUzhE?=
 =?utf-8?B?eHpjM2VSV1FFQ3dkY1kyV2lMYis0dWxKR0RmdEk1clRra3pma0Z4d3RFNlFs?=
 =?utf-8?B?Q0h0S0JmSm85SVQ5QVhmaXZCdEw1cjJjVEt5c2JZQmNsbFZ5cU5aeWVkSVFH?=
 =?utf-8?B?OW53dlhmMVR4VTBjYTZsVUFFSHMrNFEyUTRKSG1jTlMzaWY0S1FZWlJBNWZW?=
 =?utf-8?B?Q3NTT2tLMWRwdHdyWGRFOFBub1dIL1NkaVViRnlNUFVZNzFjcVJyTzVqaEI1?=
 =?utf-8?B?VmVRalhxWURxZkJoaGJzNkhzVnNyUU9tNFhpRHQ1ZDhuYlA4TGVycW5iWll5?=
 =?utf-8?B?eEhYdGd5VkV1elRvZDMyM2l6c25jWlpJUDdPU24va1Nud0RlYWt0YnZSaGh1?=
 =?utf-8?B?UjM3dDJMRHhMcmw4VXF6bVhRb1hCM2pPbEFmaTZtSmR4eDRSWVV2WjhUclpI?=
 =?utf-8?B?YVdFWXJvWjh2TVM2QnBVNklKSldhVnREeitFTkkyK2hpdWhCY2YrYzJSMldS?=
 =?utf-8?B?bS84TWk1U0FMVk12dUJIYlV0WVdIZ29DcTRHNlZtTitYZ2FvRHB6R21KVGN2?=
 =?utf-8?B?d0E4WndWSFYvWGEvOGxvMUlOdi9TZ3g4WlhYeE52S1g3NERZQTR1cWlLRU9i?=
 =?utf-8?B?UE9YbktzaGxabTRUVldzQ04yV2FHdVMrb1FOUFJCYmpaNVg1U2ovOHduRTFn?=
 =?utf-8?B?N2JSd21OWW1DTlRrQ1FUN3pGUjQxTitxUTdmdll3Und5VmJ0eUc2elJadVJz?=
 =?utf-8?B?WTdVYlRGMklRZTJSUmVLakRaTnVLd280SjZoUTUzUC9hNVQzNTFUeXpWSDU4?=
 =?utf-8?B?THVZcmNUbzU5RE9pWHYyZmI3TU1PZVk4MWloSkR0bmVjRVVOTEV6OGFxQUpo?=
 =?utf-8?B?NVFwaFNMLzVkeWVZWElxeFM2L1hHTVBGR3l6UE1uSDBMbFQ5Z0l4M0FPZHNy?=
 =?utf-8?B?MVl6eWZadUI2aUw4YkJqcFdrMDdEdHNTSjB3QkcrNi9kNXZ0VFk3b2JwN2di?=
 =?utf-8?B?cWZ3b2VkUE1rdEdyQ2dOSyt4VDQvbkYybEhHU1FaTWg1VG9JNDlHS3g2Y2to?=
 =?utf-8?B?VFhaUS81Zld6SlBmaGJDN1FZK2hEVkpsQnBISWVTVVhtMWF3cHdEVXVKYURx?=
 =?utf-8?B?dWhsa2crL1ljc3lPemtBSlMwaGliQ05wbDFiWVFEeFJrVTZRcExWekRBYmV6?=
 =?utf-8?B?dzFDc1VveDNONGVvUExUKzQyajA5UWt1TlcwREhOSkZPQThxc0pIODZsWXo4?=
 =?utf-8?B?QVVOUUpYQjM5WlV4TXMwZjhjZ2d2OHRHVlNhdjU4YTdlMFB0RFlOdVNSMlZ0?=
 =?utf-8?B?anB4Sk5qYktzYmlIa1F6MnpBODhlNTRkYnlqSkNlSFhBTEpyWEJHRThiTmJj?=
 =?utf-8?B?UmFVNXNocHVNUTN3dm1FVHRkUFpoaEVrZ0hBMERRY1VPNCttMzc2cWx6RlZu?=
 =?utf-8?B?b2tXcHBiaFVoU1FyczgxTE84RlVFMjNsdEhKMm1kejJwSkZGd25zZGZvbDBq?=
 =?utf-8?B?SG1ENE9GY1J1UXhCbGZ5QzZ5SGJ3dGVsMFZwdkxSekhtRCtVcjVNcXpDRG0x?=
 =?utf-8?B?SGVpYUc1dVJEYkRkeUhTRzJHU2paY3RrRXJiYlA0YTNjYzZ4a2RUMUxicVhP?=
 =?utf-8?B?OURPaG56ZG56dU41ZzhyeUlEcjY5V0xtN0U2QUFQWjFTT1R3bHltNVFFTEZF?=
 =?utf-8?Q?7BptC6FYhufVmicoUqBpsJp1a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416dfa40-2766-4d70-5041-08dc9025f475
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 06:06:27.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HE2tb0ASY797dMRm2dx4etHgAOD0e4bbJ6uk7VFUdTyhZFxGJauBqnRs6CTg3uVrWhnm1+VxH8bPEpQxeRDrrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6289



On 6/19/2024 2:57 AM, Tom Lendacky wrote:
> On 5/30/24 23:30, Nikunj A Dadhania wrote:
>> Preparatory patch to remove direct usage of VMPCK and message sequence
>> number in the SEV guest driver. Use arrays for the VM platform
>> communication key and message sequence number to simplify the function and
>> usage.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> One minor comment below, otherwise, for the general logic of using an array:
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
>> ---
>>  arch/x86/include/asm/sev.h              | 12 ++++-------
>>  drivers/virt/coco/sev-guest/sev-guest.c | 27 ++++---------------------
>>  2 files changed, 8 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index dbf17e66d52a..d06b08f7043c 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -118,6 +118,8 @@ struct sev_guest_platform_data {
>>  	u64 secrets_gpa;
>>  };
>>  
>> +#define VMPCK_MAX_NUM		4
>> +
>>  /*
>>   * The secrets page contains 96-bytes of reserved field that can be used by
>>   * the guest OS. The guest OS uses the area to save the message sequence
>> @@ -126,10 +128,7 @@ struct sev_guest_platform_data {
>>   * See the GHCB spec section Secret page layout for the format for this area.
>>   */
>>  struct secrets_os_area {
>> -	u32 msg_seqno_0;
>> -	u32 msg_seqno_1;
>> -	u32 msg_seqno_2;
>> -	u32 msg_seqno_3;
>> +	u32 msg_seqno[VMPCK_MAX_NUM];
>>  	u64 ap_jump_table_pa;
>>  	u8 rsvd[40];
>>  	u8 guest_usage[32];
>> @@ -145,10 +144,7 @@ struct snp_secrets_page {
>>  	u32 fms;
>>  	u32 rsvd2;
>>  	u8 gosvw[16];
>> -	u8 vmpck0[VMPCK_KEY_LEN];
>> -	u8 vmpck1[VMPCK_KEY_LEN];
>> -	u8 vmpck2[VMPCK_KEY_LEN];
>> -	u8 vmpck3[VMPCK_KEY_LEN];
>> +	u8 vmpck[VMPCK_MAX_NUM][VMPCK_KEY_LEN];
>>  	struct secrets_os_area os_area;
>>  	u8 rsvd3[3840];
>>  } __packed;
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index 5c0cbdad9fa2..a3c0b22d2e14 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -668,30 +668,11 @@ static const struct file_operations snp_guest_fops = {
>>  
>>  static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
>>  {
>> -	u8 *key = NULL;
>> -
>> -	switch (id) {
>> -	case 0:
>> -		*seqno = &secrets->os_area.msg_seqno_0;
>> -		key = secrets->vmpck0;
>> -		break;
>> -	case 1:
>> -		*seqno = &secrets->os_area.msg_seqno_1;
>> -		key = secrets->vmpck1;
>> -		break;
>> -	case 2:
>> -		*seqno = &secrets->os_area.msg_seqno_2;
>> -		key = secrets->vmpck2;
>> -		break;
>> -	case 3:
>> -		*seqno = &secrets->os_area.msg_seqno_3;
>> -		key = secrets->vmpck3;
>> -		break;
>> -	default:
>> -		break;
>> -	}
>> +	if ((id + 1) > VMPCK_MAX_NUM)
>> +		return NULL;
> 
> This looks a bit confusing to me, because of the way it has to be
> written with the "+ 1". I wonder if something like the following would
> read better:
> 
> 	switch (id) {
> 	case 0 ... 3:
> 		*seqno = &secrets->os_area.msg_seqno[id];
> 		return secrets->vmpck[id];
> 	default:
> 		return NULL;
> 	}
>
> Just my opinion, if others are fine with it, then that's fine.

I have separated patch 6 and 7 for better code review and modular changes.

The next patch simplifes this further to:

static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
{
	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
}

static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
{
	if ((vmpck_id + 1) > VMPCK_MAX_NUM)
		return false;

	dev->vmpck_id = vmpck_id;

	return true;
}


Regards
Nikunj

