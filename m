Return-Path: <kvm+bounces-33440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DEA9EB828
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 18:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56CD162F31
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 17:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9FA23ED5B;
	Tue, 10 Dec 2024 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4nKdUgx+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2934886320;
	Tue, 10 Dec 2024 17:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733851339; cv=fail; b=LPy9WiCKcMb6Y2Acke6SMSS+CGvdXqrdWqi9Z4cQKGnYyJa/d6Qbnabmzm19FUhZkRQswwU7N52eMUktaoFGtfIjyfLBW/FfyaCBVoqW70/yTOGfJxTmA4swztYDGA1Pjw0LCelE+pIUd/FpmMxTj03ebsMzd5XbRWh4x8PuJaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733851339; c=relaxed/simple;
	bh=Zyx8+o6OEcVXify+vo1MH/b7J7F1b+mCretpHdUR23I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=joeAIbynUMyBkZ/uxVYfm8sTkEOxyYviFjOCUumrqkbMwfvQvdowBH7XCpVLnnbO5sxvFE/tlfJkJ6rCpjXdYyJH37V/5D7SmPXPloIhG/WL8tMky1WJCZ0gzcvI9ExA79mNto5babhv1fNoEgBm6XcSdWr0j2eNSull7qiJKxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4nKdUgx+; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wH5zHH6ckNi1DICID0ujszltTGOHB0n02gJPIPHB4Ki2qBnNNPbtTjPTHQQRUX8lay8JV35Iq6Aw6+QSHiPbiv8OivjmTuXE4IeYkb50gR2A/yPjBHv6yKmz9cFDZqVgHxgxEoJLi2udwMvbx+DXZ86W8Wes0HygZJ640nSHj/fXj3FX55FvCuoIr2gPHKEiwMKUZE5kOpNDPLGxTsePp9Z8eqLQe/DZoiHTWTLCoP5U2ee1hVk77KAFWacQQg7S/z57b7z/IeP1F1qIQkoReRwin+zJFkPXh2plMUqQ3RDPAW14OJze+bDqHLDqO3VhG8VmiMCgZRClGaGp1NxhFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9r5JRnbJVjGRwuOWbhLKN/ih0w4UsbjnKGzw+eibmU=;
 b=Hj9WZbZvL5DiMzbaiy5lPc/ecIu4o833SP56etyMpAwd9VePv8DnUQOwjeNvdbUxP5sOOyvySzPdLJAb0GErIcie4lGQjG0ySVe3lp59ue/WMYAOVHL1t4mfqp8FtnEDnD1GgebjPhIbGvpDzWvp3feZuKyR9w+S9M1mAgb4n/0uuptbpuPlzhl8gXpRecR/dRCRjWZ9hm45dvgSvU5Sm1G1ASe9j6dOsFYC8xgAtp5kf8RYsltGUYXa9j3ArwQpjbDXOPQjyRzrr/C+EP8A/5QjavbAEvtGKifMtMDvRinQncMLFg+1Oa7VkjroRhH37SeG0rgJHS/uT39D7sUIBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9r5JRnbJVjGRwuOWbhLKN/ih0w4UsbjnKGzw+eibmU=;
 b=4nKdUgx+ZYDXIZHXxtrZMo00DaD7dB4+SSEm2pmGndvxJ5iecV3O2t6AaxhGPQWY9rxNIKFQOETVL80cFD/gbkeLD9wEDTBkNGGPO/d0DrVguiSBWs2oAbmnSKfnyFzpMPM/LNS01hAWqhyQsFrETdjt6rSsoLfUZK0Lxu57tFE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CYYPR12MB8939.namprd12.prod.outlook.com (2603:10b6:930:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 17:22:15 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 17:22:15 +0000
Message-ID: <1510fe7f-1c10-aea7-75be-37c5c58d6a05@amd.com>
Date: Tue, 10 Dec 2024 11:22:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:806:20::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CYYPR12MB8939:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d68f086-e0f5-491f-f352-08dd193f30c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QndMTko5VXV5MkhuUEZscjE4ODV6VHRCakd0d09rOEhxbVlxUVF2S2pqUE9U?=
 =?utf-8?B?YUpvUzl0dkhWa2NoZUVPSGFrbURxY2dCVmFwVGtOYjJoemg3SnNYcFlqNVcr?=
 =?utf-8?B?S3IwK3FxdWlvQ3pXM3JjZmFtSk00SkRmVzBTV3FDdmlWTFB2OXNXKytoNm5F?=
 =?utf-8?B?aWpzbStZU2hUSjd2UTBHZzdjYllqdXV1M21PU21DRGF2RkwyZmJCNHRRQmJ5?=
 =?utf-8?B?Vk82VElYTEFncGlZWjhDL3FZMzUyZUt4SVVFMG11dFk5TG5EOE1yeW94SStY?=
 =?utf-8?B?cHFKbmdzUjBjbisrV1pCWTBpczIzWjkrcW5VSlc4c2RaK2MvUC9qYzFpRk82?=
 =?utf-8?B?eE1hUnJMUWQwZ1hXRTE0Q1pFZ00zdFNTdUJWT3RKaWppZGpqTCtlWUdvTGVy?=
 =?utf-8?B?ajdEYy9Pb0pHV2FwQ1JWUUFaZXdja0kzU1Y1MmlQVklFa1p4alBMUWJ6dGgv?=
 =?utf-8?B?K2hLc1BrbFNHSFdLYXlzUTdOZ0lBaENPWE4zMnZ5ZTFUMVk0VWFPbENnaU55?=
 =?utf-8?B?NTkzM2ZMcml3U2MwZ0ZCZkFvZ3M0dlJpcXNWWVBVSHVUbWg5eGNUTStHU0Rw?=
 =?utf-8?B?TFJzSStOSVVEUjVxVVhjQiswMmdWR050VGdkNWR5OHVsMnVHT1NzVVR6RXZZ?=
 =?utf-8?B?Zmp6eEk5M3kvaThDRTRBdFVZSThKZC9YL0FEKzZYR2dNTXdkWms1TDEwZXB4?=
 =?utf-8?B?THlNTlBzZGRYMyttaXdUT1RvMEtNVHJReUxwZjBpOTJaL0IyRHJKWXozNm4z?=
 =?utf-8?B?MDJwMnlkdFcrOGFDaTQ5cGdPOUU1aG9YTnlpKzh5WldvdWJBUmd4SFZjR3du?=
 =?utf-8?B?UmNDQ01IRUJ6TWl1MGM0UGROWkJEbVNON2Q4aUI5RmF3cWt1NDc1bThUenZZ?=
 =?utf-8?B?MC9OSVRmYXhoUDdyRjhXcmN6KzYwc0NrOXdZZE5yeVY0a3dGaHZOb2FzdGxL?=
 =?utf-8?B?ZnV2V2xoaXdVQlYvSGkvSW5lS2EyUzBodXdzemJLV0w5NHluR0V1cW84c1RJ?=
 =?utf-8?B?cnpBRjJPc3ZXU25yaDN0b1NEUGxMbnF4b3JGYUc2NXNFa0NnUWRPOEhLeUpl?=
 =?utf-8?B?aEsyUit4WXIrWXVjTDRPZDdyRnFVdEQ2eUJaWVp0WUl3MG5WT29JQkxHME8z?=
 =?utf-8?B?d3lwdzNBZStCQVpLekZIZTg4cHdpMGkvYVVlT3d5Y2RLSU1idWVFZEhVWFFQ?=
 =?utf-8?B?TSs4WkpWbmdYc3h6UDdOMzZmSy9MVWFySk04UFNGaXZZYU5uMkVKaUloRHNn?=
 =?utf-8?B?KzUyZ3puaG9XMnJWbUFDR2hGY0VSMU5wcW9XSVRaUzBxb3U5YTVHMFAyUUJ1?=
 =?utf-8?B?NllhYzB6aGJjY0V0WndUcjgrbzUwUWFlRFBNUTBkMjF1UklaZDVwZzM5UnNt?=
 =?utf-8?B?WFMxOEJqNGh6WmpPUzM0a0tZZSs4OUVvTUlVUGZ2dnpwZjIrUm1XcnhUZ2tH?=
 =?utf-8?B?RXFnQWZzT2tZVmRsNzdiNVgyMys2ZXBUdWJlMVdTcVVBcCtZbktHWWhTTDRW?=
 =?utf-8?B?dUVSbDFIcUFqL2ZVQnJtWlhDbFA0Y1VvNklhaUc5RzRHbjB3YWhZbkFlTWdH?=
 =?utf-8?B?MGJsMDZ0UXFWZ2dkOG51dkpqS1FHck94M0pmalZ2OVU2YzNLKzNQbDQ4bTNt?=
 =?utf-8?B?VUQyZHh6K3BjbmcvbStBc3BhR2ttU25JMElNTlM0MUt5MUNFL1ZkeFNmSjQr?=
 =?utf-8?B?YWpCRnMxL3pOVVlLZUFXZ2NYejFkUXIxSGIrcUNqOGR2ZDczc0loNWdaZ2p5?=
 =?utf-8?B?YWZWc2VGOUpuSFl6WFRzYnY0cm5iN0xrQVZOUHErS1Nkc2FtZHhsaEcvZExM?=
 =?utf-8?B?aW5rUEx3TmwvUnlTc2VOZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vm5ucmFPT2NsV1RUUW1DUmtISjJaRUllN256TDRpczRoWGUxQTJkM2JGakJa?=
 =?utf-8?B?WTY2WDZyTThrcmwveXU4SlAwR0NWZzA2L205SnI0dVl6dFlGWXp1U1JNVnp2?=
 =?utf-8?B?QmpMRWhSUEVFbUNIdUF2Q04xZktIMkhldC85WWRLam16VGhxZElYRXJzSkxx?=
 =?utf-8?B?N0V0akVRZnNKMi9KZGpYd0F5bURIQnl6Y1ZOejFMTWpFd1NBUGwxQ29CK3dy?=
 =?utf-8?B?amNWQlNlZmwrWEp3eW0xWUlWK3pRcVc5Z3R6N204SWlMdU1LK1lHMWhPNHVF?=
 =?utf-8?B?bm5ES3IvWjFQUjFycW5qdUJVd2o2T0FxclFlRU54OVQ0WlZ3OUxuSmMyVUo2?=
 =?utf-8?B?T1kvOEw4R1J5cFBGckFNS2tGL1ZGbkJCQ2JVZldVYUNNdE5xN0RGWW9MMUM1?=
 =?utf-8?B?Z3ZrTmZHVXYxeldnVkpYUWtabk5pY3Zrc245ZnphOE91NXJRdUd1WWtLOVA3?=
 =?utf-8?B?REM0aTA0alBReXM1Q2szbkh1Lzg4SU1wb2o2a2NzUGw0dVZNSlU4d0crU3Vp?=
 =?utf-8?B?K0xsTmI3dzZ1L0I0Y0I4MHFRZC83ZEFkeHdKQ3cvZ1FHK0pldWNrL0svK0lw?=
 =?utf-8?B?bE5GYmxWQ1crNS8xZ1VhSEVNRzBqOW5lSCs5SXZSVUErS0FjdVd2Um5Kb1hz?=
 =?utf-8?B?TitvdTF2ZG5kTFNia2JQS0VPbGdwU1NiQnIrZW5VWi9KTkYraUFEaTZJRDF1?=
 =?utf-8?B?RlJXMGo2WENONUp2eHhQZm5TWFNpZGwva28yK0tJS0UwY3J5b01XamZYZXFw?=
 =?utf-8?B?VVZ2WDhNRlFMd2JwVHlkVVdITWMxb1RYTG5ieHlXZzFYMGJUZzloYXZNZVRT?=
 =?utf-8?B?T21WTHhONDJJQjJvRjBvZE9keXBEY25GaXh5bE9hQzUrT0l1L1prSTloWXB3?=
 =?utf-8?B?N2VnSUpOelUycXVLVk4vWkppWnllMjJ2d0xPUTZXMVJSbzdCTjNFNzVONXJR?=
 =?utf-8?B?RE1ZWEFZSzc4UkZuM1Qrc0Y0SGlPZU9RM0xDanV1Ymo2WlRyM0hoRHN4czRD?=
 =?utf-8?B?RFROeUY3WDZjSWQzOU5YTGZWeERzNFdqdkRwbGtMbFIyb3gva09paVJvUGJI?=
 =?utf-8?B?cUxsdkNZSlFpNlVzQlNTNGtKOTdZQ3IzaDFIM2ZnTVNDSGhBVFc3YTFlL0ht?=
 =?utf-8?B?YXNyQ3JXaTNIbjh1c25hMGk0Z1lNeHMrendvc1RTN2ZzamthQmFKWUZTVnJZ?=
 =?utf-8?B?Tkx4VGNTaEtybG5TbGxzK2V5NFhQSlQ3TlBVRHdFUlJFdUU2K3NpMkVMLzdu?=
 =?utf-8?B?TDBEVno5cys4U0VBb2RPNDdubXJnd2hYTDRwL1cyMGt0SHBLRjRVcjVyTjJp?=
 =?utf-8?B?WEJFSjZlZ1hMSWZDUDUrNGlNS1ZDSHBYYmhIRGo0aCs4RzlRT2tSaUFQYVgr?=
 =?utf-8?B?K3JhTTY2WFRjakp2bmRzYmtLUXBuMjVxVEZuY3VicXVRU08yU2NpRU81NVJG?=
 =?utf-8?B?MWpVYzdVWCtqSk9MSDZHV0hiT3RvV3RFS1kwWkt1K1BDUWhta3c4OU5jNmN3?=
 =?utf-8?B?S213YmdEVjVOZ3hlY1QrTGlodkFOMFRlMFZMeEpIR25FVDhyS0c0MU9GdGha?=
 =?utf-8?B?ZFFjbXRuQ1dDeTJWSSt4bStRZEluTW53NW95b3Nkck1ZdTJwaWo5L2V1WVRM?=
 =?utf-8?B?azcvdzZqYXAwVE9CV1ZNK2VvOVYrUHJtWFRya0VOT2lDbUJRM3RNR0dwNmxF?=
 =?utf-8?B?dXZ0VDdKWURTcUVXRGZvUFNJQi92ZXpmclN6Q3V2cWVYYUdjYWp1TUJjVVZk?=
 =?utf-8?B?RzFKanZ6SDJ4VVk2NmJFWFBNbFJpWURYZWhLVXQyR2lPYk1BL3RYT09Faitw?=
 =?utf-8?B?eUFscEhGUUZaZWJTdHhqNkpJLzB1UEluSUErOU9VZkRja2g2NjB3QVNaZ3VE?=
 =?utf-8?B?ODExR3lBaFZjVmNuMndKM1kwQ3JXOFErc3F2VC9XMitmOE5FL3d5R2ZLY3NZ?=
 =?utf-8?B?ZWxEcFp0aS9sNFg1RUhmb3RJNy95QWFyNFRPajNXOXFibmI3LzlmOVJhOTNS?=
 =?utf-8?B?TmRDZXhFNyttOU4vb2RjMURoaytwMmUvVUZiVW45ZHVsTktSN2ZMUUp1cDM1?=
 =?utf-8?B?dTlSYXlSYzhzMWhRTDV5ZHcyRGMrd3FGWGZ3S3VTbjJaQVFDbjBhaHovWjl6?=
 =?utf-8?Q?PMBLJGZ0Cgev4NHg3Crri1lTw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d68f086-e0f5-491f-f352-08dd193f30c4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 17:22:15.0513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91Dj706h2e6YSKLKZ8Oloh3JXmjI1/xSEt6/R29giiE8sstiOiS3NHhEb5Q19fESG8g7ylu3/3BQe7oAVr6w9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8939

On 12/10/24 11:13, Nikunj A Dadhania wrote:
> On 12/10/2024 5:41 PM, Borislav Petkov wrote:
>> On Tue, Dec 03, 2024 at 02:30:38PM +0530, Nikunj A Dadhania wrote:
>>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>>> index af28fb962309..59c5e716fdd1 100644
>>> --- a/arch/x86/coco/sev/core.c
>>> +++ b/arch/x86/coco/sev/core.c
>>> @@ -1473,6 +1473,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>>  	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
>>>  		return __vc_handle_msr_tsc(regs, write);
>>>  
>>> +	/*
>>> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
>>> +	 * enabled. Terminate the SNP guest when the interception is enabled.
>>> +	 */
>>> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
>>> +		return ES_VMM_ERROR;
>>> +
>>> +
>>
>> If you merge this logic into the switch-case, the patch becomes even easier
>> and the code cleaner:
> 
> This is incorrect, for a non-Secure TSC guest, a read of intercepted 
> MSR_AMD64_GUEST_TSC_FREQ will return value of rdtsc_ordered(). This is an invalid 
> MSR when SecureTSC is not enabled.

For the non-Secure TSC guest, I still think that we should continue to
use the GHCB MSR NAE event instead of switching to using rdtsc_ordered().

Thanks,
Tom

> 
>>
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 050170eb28e6..35d9a3bb4b06 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1446,6 +1446,13 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
>>  	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
>>  		goto read_tsc;
>>  
>> +	/*
>> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
>> +	 * enabled. Terminate the SNP guest when the interception is enabled.
>> +	 */
>> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
>> +		return ES_VMM_ERROR;
>> +
>>  	if (write) {
>>  		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
>>  		return ES_UNSUPPORTED;
>> @@ -1472,6 +1479,7 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	case MSR_SVSM_CAA:
>>  		return __vc_handle_msr_caa(regs, write);
>>  	case MSR_IA32_TSC:
>> +	case MSR_AMD64_GUEST_TSC_FREQ:
>>  		return __vc_handle_msr_tsc(regs, write);
>>  	default:
>>  		break;
>>
> 
> Regards
> Nikunj

