Return-Path: <kvm+bounces-28773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 204A999CF19
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 894D7B24CC5
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B4D1CCED9;
	Mon, 14 Oct 2024 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fLQmVS6n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2ED4087C;
	Mon, 14 Oct 2024 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917252; cv=fail; b=nU3sp8IrfGFlEpArTIyPGaAe8T4eul19pk3nwAnWMkBLVsagyt/5tGaM3ffYyZ0iYyijdIPnMfnpBQT05fXqKbXmiPAluwhRSEPo0BL7+d0ys6Xpjqwd3OlowPVoKaRTM+reScTOzjeIMbV2cXcEewdjrXZCIp0cSpyW1LLexMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917252; c=relaxed/simple;
	bh=2OTDNaEkiwbu83tWEh4QWFJENnY/AuPA4m0kDdqonz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dzt3hpbILLDauAgZA+ZKGRP5nEWO8+V2jAjap9JutGgWjcRNXqpSyyeMghmDaBb1MRAI6QboJJ66vkqZwG0FbDHyTpDbcZTnOjRbm2hFqPSwNxI+mINnzcpbn4EEXBg2p0Qa0O4pxjF7izco2Bii2vnbJzOSKLp4XN0MtQSFJ2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fLQmVS6n; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IKXFspXG1sffu046mGKQQlnA07ojk6DItadYvcZ0IxoiaSICrpWgTHaDgXN0jOB+xMTP7P1zVwOKbrxLoHFBumasQMYS9vk3meEmvvjZCKTN5oNaX41fnUnKmFP5k6R8vGlZy7LovlyQyt3x+6n6FE09HqcCDGkNoqIKqRxBDLpI6ZMSKb0u2XVWi4txRiw+7us8BKDCD1p8ycKBcRksnW8/trycsdAQWcbQPuyC0NOkJCLq+v9z5SmWHjjUPKlzi/D7ZT/lYfmqzf+72OsOJqNqnib+LqMP8ZQXJ714gzRDOoOGYc3auNl0BhhddaAwHhyb7K6KYX54ppK+sSZBqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onQMzbEvTlBx+mpgypQcMIM4cojaxvWcIdx4foePZko=;
 b=qiMgKEtr2YXOSDlfQHErGVKxBAMLHlxvkDZNTCtJXShygwmWjE/75YJKzINPhOgVVwo+2Ov7VqVl36689kdaVcdNFCmTVhuxXBeq6AIWLPBDQZkKEpneJvBpF0xfeuTAMugyeZd3hovLuBcmZYVyOAQxz2SllUzA9dLSoAHV7m7ELPbNZgxR4cUrEWwyyycfdcEUuoe3mgHy041KEqMJ2kkojkBpVBHgwB32HK+8tTkQjpy4CM53mnfGrlrIwLXSQUTb9LCT/eMGmC6+YvsjLH32sEbjAX6MoiMGpu9kVcsw7GiN7cXxqL9oHizoDbNgsLFXDU9d2vfLDK4YQ+lQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onQMzbEvTlBx+mpgypQcMIM4cojaxvWcIdx4foePZko=;
 b=fLQmVS6nM2XpJHHDt6Aoedn9q1fZvX5e7oEwfi9GqTFTz1UPSvcx1IBD2Yf52k1KoH0FBhXUytNJH/pDVz5HJ0NXh4pHvQ6MwytGNhzo3pNntSH+oIu5L2zwLqRIdCFISk9dzMPgKkXCkh6maYC7V4kbMVDtkgXMv4IcR18Kd0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.26; Mon, 14 Oct 2024 14:47:28 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 14:47:27 +0000
Message-ID: <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com>
Date: Mon, 14 Oct 2024 20:17:19 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: Sean Christopherson <seanjc@google.com>, chao.gao@intel.com,
 rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Marcelo Tosatti <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <cover.1728719037.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0208.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: 57149a68-ae80-49bd-58d3-08dcec5f1f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUtGVUpZZTl3RXA3QlFWUEkraWc1SHA1SHFxYU1FM2VJdEpITlFra3hQR0k2?=
 =?utf-8?B?WlM2NTB4OFVPL3lpYktOU0dVSEFFS0JCRVBQekFjVHNCQjlzcjJSclJzUVNS?=
 =?utf-8?B?dEdlcHZaVVlYTHFFTFV1dUhELytKL3Y3ajMwM0JhdzU4TVkrYkFyRm9PLzRW?=
 =?utf-8?B?THpOYmNNQW5UdE04YlA1b0NzOVR6WTR4akRvellYQkQ4M284SGp2MWg1RGZF?=
 =?utf-8?B?K2ZXZElpT2lJRlVJVzR4Mk55NFltYnFPZ3lmY3BYblhOWlZ0Y09yazVsT3Fa?=
 =?utf-8?B?eU4vNHhQR1JGd0R5a3NMbFBScTJmOWZNekhTdFJZVnMzYko2eVVvV0pFR2FU?=
 =?utf-8?B?blF4SWFoTE4zUUNsT29heUhmSW1lUVZkekU4c1BtTHVrd2pnTDBNVHE3a0k3?=
 =?utf-8?B?bDFSL0Zwd1crL0RjVW1uT0EyOFhBVFc5UlJQRGdLU2twMi8vQ2dzRDhpemZm?=
 =?utf-8?B?NDBVeHhCcFo5WUVSUFhyeUNqdlBjc2xlaFJHblJvbUhJY2hHeW1QeitUcGwz?=
 =?utf-8?B?KzE4TlNGVVVWRWc2RUd1T1I4N2liUFpGSkl4UmZRVmlQN0Q5d3FkRkduM2RG?=
 =?utf-8?B?c3pmajN2MDlRQlJ2Z2NiakwrTzVyZ0Qrc01aSzJuRFNsQ1BJYlhaSTBZYUhG?=
 =?utf-8?B?U2tIVmxhWVNreVloRW1uWDBzNEpNT2tRc0ROU2liNGRDSUhVMFdZQ2xqb1NK?=
 =?utf-8?B?YW9CekFxSVRpNUVVMmRUcUFXeGgzTHRUbDRieWw0bWhzU3BscGhUK0hicUJn?=
 =?utf-8?B?aFdYdkxRY1JoWmR4MVA4eWtYU2tLdmxBYUlHM3R6ZEdkR1ppWElENWs1STNp?=
 =?utf-8?B?aHNqeUJEeWFRci9nMmJrWEtMTGJkU0hwOXVkQXl0L1ZjeDV5VTNCRTBGbnFI?=
 =?utf-8?B?aHNBVjNrMFZ1amQvWHdUT0dLNFFKcnB0S05hQllZK1lab3dvdmtmUkp2Um1S?=
 =?utf-8?B?YXRHMmVWcU1QYkYvRndDc1QzTHpQUVloYVc5MFNJbnBDTWQ2anBuK0duVTNR?=
 =?utf-8?B?K1JmL3VPSHNBcVZPS05sdFpER2NWc1FpM2dWRjJQVURGU1Zxc1dCc09KVlRG?=
 =?utf-8?B?QzVxcXUvOEhudnNGQ1FZQ3JZY0JWSWZCN1FSVGNwUEFtUW1SOG1Jb1R5SDk3?=
 =?utf-8?B?NE5sVjd0Zis0MkhNYVl4c1dxajhBdkRWSUFqU3JtZWhBenVSUUxhNXNxbGQ3?=
 =?utf-8?B?YWh6TFVzdDRESWd6L1hXQ1R6a2szQ0ZvUlRuYU15M0gxbjd0UENaem1JRmRQ?=
 =?utf-8?B?Z1Q0cjY5bFNkZVc2VW5hZjZuOFdxeDhjOWhDb1pCcHg4OEZ5YWFxWXo5UEVI?=
 =?utf-8?B?bnBWdVlRanpIY0twaTcxZWlEaWE4eHpDNTdpYVl3akhRaGU1WXB4cUxYdlZ5?=
 =?utf-8?B?MGFwWndRM1ZkcWxWSjNUWnFubFRjeHFTZEg4Z2V3TFU3TC9GOWM1OHExalpw?=
 =?utf-8?B?MDB4RjRPbEYwcUlKVklsVUVHc3Z5RlVNWVBrc1F6bVJUMlBRdkV4OEZya0lR?=
 =?utf-8?B?TURySVUvWHZ0U0N2YjByYm5KSUhFbW5veGx0REhkOUR0dVllalU4R2NIVlhw?=
 =?utf-8?B?UzQ2S05KZzlMa1VBQlJNWEd0cldHS0NUOUZZMXAwV3NMc1g5OVFmTkhSTWh4?=
 =?utf-8?B?NXpyeDZSOUxqalczQVBEbVFJV1hkRWVxQWZyaXdscVpreDZMZURXM3BYZGNh?=
 =?utf-8?B?dVhzSUhCVFJuVGRweWR6blF6OWtMRFF2YlhhNGhKTEpQMjZNd01PUDBnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d09TWldIMU80b3ZQbkhXTkFuVTkwVFBaTlpyOEtFRjRQSFdBbFRLcmplZWxm?=
 =?utf-8?B?cDlLZjBNU3ZEWHh4ZE5aWUpKMmFDT21xa0psbmF1TmYyYkRrbjdiTkJKVHlv?=
 =?utf-8?B?eFdKS25QU2Q4YkF1NDczaUNjZUg5RTFjbFRmWVhTa3lHRjh5Rlh0SjlycEpW?=
 =?utf-8?B?UnluN1F1K1JQYkM1dDJoMlpLem5vczA0Vm9jTW9semNrR3RTUGhhdzhZVUhZ?=
 =?utf-8?B?Wnh3MDlWN2U5S2FkTWxTVjVpaUlRT0NmVlVtM3FiRGhyczgrUURMeUJkaHZX?=
 =?utf-8?B?SURkc09BSE1kc3NCRm1KVG5Va0tCTGVPWEdEUkZOdDJSelFWQzZpbzd0dkFK?=
 =?utf-8?B?akR4MlRRUXB2UXFrYlJVeDVJNUJ0Z1ZYNXk3RHpnUEU2UDRyaWNVeXNyTjRV?=
 =?utf-8?B?U040VnNBeG1udGlpdnRMOUZDdW9wTWg3Q1VyS056MTNLbFcvckhUZkU5RTNP?=
 =?utf-8?B?a2s5L1FzMXdTQzRyTm92eVdmSFhVYVpma3BDOWRyYVJmZjhUY094bEx0RWdE?=
 =?utf-8?B?dC9DMHlHaDNzZzZaODJ4Rmp2SGdHS2hnSnFCQ3NEd2JId3g2eXVCSXg1QjFQ?=
 =?utf-8?B?ekhkTVZjYy9kcmtaSmVyT0NmbUoxRmkyckpQVmNnc0ZGTnoyWGExdGxTWFJS?=
 =?utf-8?B?VHVpWS9ETVZxamxId3R3TlZsR0FCbFdtUVBlS1Z2V090UHFjQkdrM0VldytZ?=
 =?utf-8?B?NjdqQTR0QUlrcUMvVy9GbEtlYklhRWhjaGYvUWNCVElqUnZLN2pablhlU1Ay?=
 =?utf-8?B?R0xuUFpBNHdRSGhOblI1SEVNRWdNUjdUVm4vaWpYdGVDK0dJNGFrNGNTdzRo?=
 =?utf-8?B?NG5SbXpNM3hGVEg4RzlNYXJjU0owcjNuZmJGQjkvalFaRkdkUjlJN21oTkNI?=
 =?utf-8?B?bEZkZmFaeW8wN1hKcnVZbCtydVBUNVlrenFweHRJUi9qUEcwZGdWZG1mV3FX?=
 =?utf-8?B?WUxiOHlidU9SSDN6dW9mSUJ5NGoyeWc3aVNHaGtOczRnTXFpcDl1ZXFTQXFO?=
 =?utf-8?B?YVkxbjA3SThveUJmZVE4MjhlbEJVamEvbnpTVnk2cFVoMXdXaUYzZUgvMkI3?=
 =?utf-8?B?eGlwaXFXUExsUHZTQU4vRUNORFpKek5aYXRObWU4dUpaUW02dU9GSXQyMFVv?=
 =?utf-8?B?Mm1XcERsNFZKcHJCSjU5NUdpaC9WMWJrOENKQWJHa3dNVjlZUWtXa3NBL3U3?=
 =?utf-8?B?MEkwRGY5c3NzcUdYZWR0RkU5amNDVnlHbThPbURkMUxvMWxITHJvM01KTXp5?=
 =?utf-8?B?bk9xMGtaY1FsREpTWXZKK3ZpTWx5N0FMN3B3MXpVODdLNkl0RU4zTlpKRnAx?=
 =?utf-8?B?M1lVVUxzanlULzhRVExFWUVKd2hBSE1VVmJ4WHcrMmxaYmtTSDUxa0g3S0Zu?=
 =?utf-8?B?LzRFWUZtOVZKWk5HT0ZzdnFkZVB6K0RkOEVDTTIvMTJOSVBOdCsyeUY3Uk05?=
 =?utf-8?B?NFRab1llNnZwYnhrR1QzNFZkbEtuZTVDa0IxQlhxNDMyZHBSMURXdVF0YjBI?=
 =?utf-8?B?S3JRQnhUYlFhbThxZlR2d0VtYVo3NjVwdWVvbWc5ckFMVFAwUFJLWGhPbE5s?=
 =?utf-8?B?bUtlVjN6ZmZXK2ZUZ2hnN3B4NFZqanVGeTR1emd0dlpNUHhyS0oxL1Rhc0w4?=
 =?utf-8?B?TmxHSEhseERVTGl3VUtsN0FTNTFTUXdEamphT2x2MGFWSG8zNXN0Zk45ZU1l?=
 =?utf-8?B?QkJPQWxUbUFZandoWVhvVXhKMEtmU1VQbVI4d21UbkhhOERoZFNVclpwY0RL?=
 =?utf-8?B?V3grVCtYVUYvT2FqUmx1THR0VWVlUXFPNHdZKzVjZWoxcENLcHNlbjQ4SnR0?=
 =?utf-8?B?UVZBaXg2YVppV3RHcHplaFpjVVQ0bDZmWm9XQkwybHNrV3lqSHdRcXdHOFU2?=
 =?utf-8?B?UEY0UTIrVmF3MTJ6ZklqV1JMNWtBSlhHZmRiaUpPb2hvZ1pGdFZmTG9Bekp3?=
 =?utf-8?B?dUFFQWNYYnkycU9VL1dEMWNKRlo4bEJURUhrcEZhMDIwWHZxN2k3b0Y5a2ds?=
 =?utf-8?B?R0huQUhHTnpSeHFHNlYxaVRBNXNCbUVrYmZabnI4dnNiRHdMbWpPOWFtT1Iy?=
 =?utf-8?B?MHp0dkNxN3pIOHBOZi9RaC9vR3g0QWp5bDBaOVJrNWlIUmozVkQwQjVvRHZq?=
 =?utf-8?Q?9xV8ERF6/t8ef7lvESt0wI/7I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57149a68-ae80-49bd-58d3-08dcec5f1f91
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 14:47:27.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1W+YYGTaf4+rQe8UopU4bnY0BE7x2g7v3aDMZw5OMPFCBKsW6pViXkQW/I3LERt0DPuFTFStj+6tCewJzMzTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452

Hi Isaku,

On 10/12/2024 1:25 PM, Isaku Yamahata wrote:
> This patch series is for the kvm-coco-queue branch.  The change for TDX KVM is
> included at the last.  The test is done by create TDX vCPU and run, get TSC
> offset via vCPU device attributes and compare it with the TDX TSC OFFSET
> metadata.  Because the test requires the TDX KVM and TDX KVM kselftests, don't
> include it in this patch series.
> 
> 
> Background
> ----------
> X86 confidential computing technology defines protected guest TSC so that the
> VMM can't change the TSC offset/multiplier once vCPU is initialized and the
> guest can trust TSC.  The SEV-SNP defines Secure TSC as optional.  TDX mandates
> it.  The TDX module determines the TSC offset/multiplier.  The VMM has to
> retrieve them.
> 
> On the other hand, the x86 KVM common logic tries to guess or adjust the TSC
> offset/multiplier for better guest TSC and TSC interrupt latency at KVM vCPU
> creation (kvm_arch_vcpu_postcreate()), vCPU migration over pCPU
> (kvm_arch_vcpu_load()), vCPU TSC device attributes (kvm_arch_tsc_set_attr()) and
> guest/host writing to TSC or TSC adjust MSR (kvm_set_msr_common()).
> 
> 
> Problem
> -------
> The current x86 KVM implementation conflicts with protected TSC because the
> VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
> logic to change/adjust the TSC offset/multiplier somehow.
> 
> Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
> offset/multiplier, the TSC timer interrupts are injected to the guest at the
> wrong time if the KVM TSC offset is different from what the TDX module
> determined.
> 
> Originally the issue was found by cyclic test of rt-test [1] as the latency in
> TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
> the KVM TSC offset is different from what the TDX module determines.

Can you provide what is the exact command line to reproduce this problem ? 
Any links to this reported issue ?

> 
> 
> Solution
> --------
> The solution is to keep the KVM TSC offset/multiplier the same as the value of
> the TDX module somehow.  Possible solutions are as follows.
> - Skip the logic
>   Ignore (or don't call related functions) the request to change the TSC
>   offset/multiplier.
>   Pros
>   - Logically clean.  This is similar to the guest_protected case.
>   Cons
>   - Needs to identify the call sites.
> 
> - Revert the change at the hooks after TSC adjustment
>   x86 KVM defines the vendor hooks when the TSC offset/multiplier are
>   changed.  The callback can revert the change.
>   Pros
>   - We don't need to care about the logic to change the TSC offset/multiplier.
>   Cons:
>   - Hacky to revert the KVM x86 common code logic.
> 
> Choose the first one.  With this patch series, SEV-SNP secure TSC can be
> supported.

I am not sure how will this help SNP Secure TSC, as the GUEST_TSC_OFFSET and 
GUEST_TSC_SCALE are only available to the guest.

Regards,
Nikunj

