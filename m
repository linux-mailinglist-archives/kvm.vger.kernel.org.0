Return-Path: <kvm+bounces-15633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B29A98AE27F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A80F28214F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FA464CEC;
	Tue, 23 Apr 2024 10:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OxJnI5Bo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D23F17BAB;
	Tue, 23 Apr 2024 10:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713868935; cv=fail; b=JO73AzDplrApBAzMvh1vCT22FA8JLhCPRE/+6vk+jMIGTAFuBEdjREV+K6dHh0svyLxpU1VGRweym+czZ/by+Sg5w2MflRezTfQVgyy20pzIKCk2A5vsorvHb0TPuGD4Olf7kIbk0E2LGUU1tPM6zAxLHT/72envJ/ypebOC0Os=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713868935; c=relaxed/simple;
	bh=OU1ydtH57f9249ng5L9cDTrhpegFGbV9E+v+I2JWxGc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E1H/B7IkOPa7cMMc9JG98roU+P1QxgFHSN0lWoPK0dkVot1CuImTn8J6h516Ve1uoXFavohwbELWJz7/Uj5qLTQlaWFDKaiajNahDzIRDHEriZ5rB8a1k6R7SyL1FcvFfo0dtWcyDSMFgbOchgXTOnALYHtkusjjP7Wyay8vSWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OxJnI5Bo; arc=fail smtp.client-ip=40.107.95.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Atd5vM/moKXWH+TrN35V9GTq0Ovptwbm7WEvHVEWB6IktrAZWuMxEjXTJlqIDOYvVxRmfquRc738f2G/Vzagc8iKT3INKs9royyvJomrZtILmGEeU5A5GepwEmlEJfXqBZXUWSm3eg+acKX70/QDRS0RbJ79Q/H8qStUrWNGrjAuT96Dv+XLqRqWQNrhA3rRzLFQu8zWjziuDcyRWUdcAu6DabHqy++gYqtmjpcw6uXGOqr+OsPgf7Dv729Wa/x8Sq36+F01z7pygvlmWhTqmAQW9+tOOaHnmLKz5ZCLFttlEu9ON8+nUdouApMXTv0gFZjorwHGdcfnOoriGW7bwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WnWy0QR370vlWqgzSUxHtQqJIgOoCwX7ZCG8XIvHhU=;
 b=YJ/n+KPSLamvGaU8exPWJKKYZVL9ZBQ6xw0Klo92UUyfn8ljfpEp5M19+xhDsDcoMsNr+gPXm5CB1GwaOS4sRsiOImSdZ+YFRM4OsUB2gtjwAliLe/I58tJmD0Es4lhcuBbwbFA9RhBFacFzrsNqmxsDQcQfG4xv+jPa2Wi0Fl8kf7fLaAOyJbrBobefsuhcO+gN6LieyGoZfnhCC1KU8oqyfUTRgkwQaD4+fQS7JBk6wM7OLBt5QKzy0DbOuxRjL3PQCq4pKvZOv56n9dA5yo/aWXOvFsZjHS25XiSkjNHdTkDkX2aH0xt5u1erMQOYnvhTTgsnxCS195Qpv156Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WnWy0QR370vlWqgzSUxHtQqJIgOoCwX7ZCG8XIvHhU=;
 b=OxJnI5BoySZl1+tCbfEt2K0KHWj6XdsNJNGoIFuaO0bbQj4NHVDG0Q0m/gVUSFRdmd073bLXkyq3LF88eFXokMtsmq243KSXRRyBRuGZJ4CD5g4HTNoKIMZGWz98mxQMoXw0vkMxUD85QVsh8Ebx7Alfmmn4xSlPiOocj4L+R7o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB8538.namprd12.prod.outlook.com (2603:10b6:208:455::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 10:42:11 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 10:42:11 +0000
Message-ID: <f8dbd58c-78da-4b3f-a79b-6693c04fb104@amd.com>
Date: Tue, 23 Apr 2024 16:12:00 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 06/16] virt: sev-guest: Move SNP Guest command mutex
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-7-nikunj@amd.com>
 <20240422130012.GAZiZfXM5Z2yRvw7Cx@fat_crate.local>
 <6a7a8892-bb8d-4f03-a802-d7eee48045b5@amd.com>
 <20240423102829.GCZieNTcHyuAYMcRf5@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240423102829.GCZieNTcHyuAYMcRf5@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0157.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: 87856ec6-6089-49aa-dbfa-08dc638207c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2pDM3QvZjJnUTlScjBhc1RLYVNVRE1ieGJUZ0UyV0xsaWpJOWtqRHNseEFH?=
 =?utf-8?B?akRoMHRPTlU3Rnp6Q0VFVkt5a054djFNMkdOeVoxc2gxYzFiWHhHcTh3b3Fi?=
 =?utf-8?B?L3NBTGg3VGt3WTRyc0t0a21xR0hUU2M0VTNnUDJZajNoek9YNHQ5ZFN1UzUv?=
 =?utf-8?B?ZEpXd0xjcHZEL0IvRWE4OEdIdjgwR1ptT3I0TEhhWUVTcGtqS0lPdmpyMmVH?=
 =?utf-8?B?VlJYZlRtVlAwMzRMZGYzM09pb05SOVp1VE00REwxWTB4ZWZROVRxVTZ1SG1u?=
 =?utf-8?B?TlhQTGgvaE5qWjJDcTZFbE5QcU14QzZtU2NRdUdtTVUvWTRJM1hsMktqSnM4?=
 =?utf-8?B?bDF6ekIxNHB0QUlSQ2xvUXQ0UldFVllFQi9KbDBPcDBsOTBHRDI3RGhuaWdQ?=
 =?utf-8?B?VGtJV0k4UGZZNHo5REpEM01jUUhhbTFMVXdSZ2ZBOEc3eEcrUXBzbDlEU0dB?=
 =?utf-8?B?aEpNMjR0ek5nUVlIVGhwWlhsSk5qZUFyRnJjWlN0NFFIRGd4andsN25LWVUw?=
 =?utf-8?B?UWJSZElZRVV4bFhITDFINnpabHJRYUhZVTdGTlJsODJkU1pCMjBnZU5rUk82?=
 =?utf-8?B?VGdHMnp4MGpmRTFyakZENVpYUmJxWnhYa29sdmN1bG9LYkhFT0FjTHF4Z0No?=
 =?utf-8?B?Mm1XK2NsUEhrbS93dVNZUE1MSzd4OExyK2JNK0RwWXJMdy95YThKbXMrY1Fu?=
 =?utf-8?B?TCt0aHFGelFrVTczQ1BCR2ZrcGtzYVZITUdFYUZHYW5laEYycXMyYTlZNGJV?=
 =?utf-8?B?MHJmN2R5L2xyQitwUmp3YmtXSkc2RU5mT1lqN2FEMnhnSTVGT3JrMEtNS1Ex?=
 =?utf-8?B?YjNNeVZEalhHMmRIZlhITWhXV0xDRUh5QXV0aWFxUmQvb1loOTB3RXd4UUlr?=
 =?utf-8?B?MS9leCtlSFBYeTd2NmNWVllGZzBFOG9qeHVUKzFhRzdCaHZCN1RMdFF2eUNG?=
 =?utf-8?B?UzBTZlIyNHFoUTVXMnE1aWR0Rkx4eGl4QUY1YmFyMTQva3o5eW04ell1Y2g0?=
 =?utf-8?B?OXZBRWlkQ1pyNm9rNW5yS0JmQ3RUbTMxRUNVdkJQZUpYL0RQRFkrL1dCUDBC?=
 =?utf-8?B?QmZBU09Hcm42NWRRYkRLK2l0SVFiZWc4OGR2TG1NcXdZVWZqYVFnVEpKQmE1?=
 =?utf-8?B?TGZpcEc2WmlXdHdXakRQbmFmME9xK0pBUXdiMmcwdUl6UVBPYmNzbEhBWTM4?=
 =?utf-8?B?UnJWSWNxTkVyWFpleVhyK1NpQUhqMXlEdDE4VUMwazVZUi9lQlIwSkdhRUJa?=
 =?utf-8?B?Z3B1QnBqVTd4YUxDdnJ0NjNsSW9XeXJnNW9CdnA5V3hSdW5icDA3TEY3aUZG?=
 =?utf-8?B?QjQrbHVkYlNGbExPTEY0V21WbFVWM0hxSTVDZE1kOWJJaHJaYXF3Z0wxeWF3?=
 =?utf-8?B?bFR5bUs1Y1Bsc1U2V0poaEY4Nlo1WFl4TmJFOTVnZEx0WkozWUZpN2hBd090?=
 =?utf-8?B?QWdLNjV5OS9LdXRxTUpOUmczV29JSElvclQwN0FQR2l1QVJNdElMMlQwYU9U?=
 =?utf-8?B?b3FZNUk1WnRBWnVMZXVMcnNpQ1Q5eCtTNlVYS1ZMMGZNenRHSy9OT2ExREdy?=
 =?utf-8?B?dEN4UXorRUUwTVNlUDQxWDIxVXVPMHQxTW1tb2hnWHh0ekVxSkRLcHlzcDU2?=
 =?utf-8?B?UlJueHdzYk55RnUxa3dWUTIyK0ltODdySjkycmdCak43ZXJqVzNVVEJlaUw2?=
 =?utf-8?B?MHI1VjBVRVNVci84dnA1V0dPaDZSSW1BK1ZZcmtWRjZSM0hCdnR0MHpRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlNSRTc5blRkVXpLcTBUTXU2QW9PclJBZ0NMSmNHelJPU3BuenBmcHovU1VI?=
 =?utf-8?B?dlhmRjFuWWt3WkNTN0hCL2pPdk9ubHJRU05qc0hZRkVveEtFVzRJSmk0SzJL?=
 =?utf-8?B?ZHVrTzFwS2cycGRydlhMdENiczRGdTMzZnBsY0JzTXJ1d25yK0tWcVZBbWJO?=
 =?utf-8?B?emRkWEtpYzFFYi9NTVpFUXp4dC9FREVqV25kVysxMEpaaklPZW16OUdCOFlj?=
 =?utf-8?B?V2d3SitMUjk4VmMyckF1K2VLc2hCc1kwM2h1SFQzMjFjWUUwVVhmSmtyaVlt?=
 =?utf-8?B?QWR5Z29zQTY1QVI5V3huS2lKRytvRDE1WFJlQkRMYjJvL21FM2JhbXloRWlM?=
 =?utf-8?B?dG1ITEcwd3ErdDhZMVBNQ2pSM0V0cXUvc1NaK3RQcUJnQWlEQUhpV2FWdDNp?=
 =?utf-8?B?M2JCQUlMbzJOVW5oajFSU0ljMDNsb3FnSVZaRGZWZUVZRVNFMVBnOGdhbjVP?=
 =?utf-8?B?NzdESnhac1d3SzlnRjB4R3R2U0FNT0dmaFBITlcrM291eEZ6bmNyMmlHSFo1?=
 =?utf-8?B?Rm5UVnVRa2xabC94Q2Q1c24yUy9qNXN0ZnFsMmFaRjZkYldMMVZwa2ZaejB3?=
 =?utf-8?B?ZmtiRnBtQVZsN1ppbTR1L09GMzNpclVGZk9tNStQei95UHBxYkhDL1hJVmRW?=
 =?utf-8?B?YVkyY1dqdWlmMlM4Q3k3dmdHNndlbDJmU0JYMmFjSTM4aXhkWk9zN0tHUXdH?=
 =?utf-8?B?ckdWSXM1V09SeG1sMjJYcWxvSE5qdGV6ZDlNQUZoWVJwWHFtaFBOS2VTWTBV?=
 =?utf-8?B?dlVsdTBwZ3VhTExZMi9sS1NacWoxNHlPUGp1ZXJIN3R4V3lCL3lxTkV4V1py?=
 =?utf-8?B?SURCQ3M1blcyU0lZVnU1aW1PdmdvbjZRTURIamhtbTdrUVRkUGtGS1VqMzgv?=
 =?utf-8?B?Z3grNm91QWlaakU1S0gvMlIyY1I5bHkyQWpwUmNMaGFSdmF5ZlZSL2ZaOUN4?=
 =?utf-8?B?VVRIZDB5TmRmQWdCNVZURmtjVzhqSjRnRGEvQTBLTE50ZXIvSnFBL2VuZ1hE?=
 =?utf-8?B?UFF6Qm4yZjNFWUZwRFAveGY3bk9lSkM3VzVGdWh3YjdPb3gwUit3aUozNXJ1?=
 =?utf-8?B?QUkyOEY2aGpCYzFLTHl0THkyQ2M1Y3kvK2QzQytiamVleWRvWFZQVG9iU3Nr?=
 =?utf-8?B?VlJKdFIxeHg1V1FwRW9YREo2QUtuYmFIL1RCcm5hSGNXYlFiU0wzTzhmd0lK?=
 =?utf-8?B?WVVtd2dsZ3IvUFdudjRsamRocDIxTC9Wc01xOVNpeGJJQXJwd1Jac0ZkWVhs?=
 =?utf-8?B?Tk5KaUwvVzlNQ0hkdFRSM3ZCazhnM0lvcHhwSnEyR2pJMnlXeTM4YkIvc0xw?=
 =?utf-8?B?eVRPSXZndUpYMWdqL1MrSnBLVUdQVlBPNVBTZUplaEtSZThHRElrMEpXa2pp?=
 =?utf-8?B?LzFsNHNCelEwdGpVMmZwSVBFdUQ4eEVsdEZUQk02QUQ0T0pUSHlsM0R1bXUy?=
 =?utf-8?B?T1ZQaEh0MktZZFFtTU9TN1dnQU9HMWVCazNMTXVpYmo1ODV0YjFDTVpqUENR?=
 =?utf-8?B?ZWg5bWRyTjE4MmFObmV4VXpnN05MZGpOMFRvOVhoeXZ3ajFmbFNvcTBOamJG?=
 =?utf-8?B?TDB6S0NCdmlMYktvaU5qNEYxRDJ5OXJIb2J6UXNJQXhwaVlvclhUbHlvNk5L?=
 =?utf-8?B?V0pUNVpkaDVxdzcycE5OU09vckFqZ1BraC95dnZ5enlkWW9ZRldFcHhNZ1d3?=
 =?utf-8?B?U1NHNUQ4MlJ1QzBEVnNGRUdjTTNLTUlNYWZtbE1peFNmTW41NUVXa0JUaHZs?=
 =?utf-8?B?YVdFeWJSU0xpV1NYcGI5RFp5RHdFdS8yeTgvTXBnY0VRSStjMm5tbUJLWW05?=
 =?utf-8?B?RnFnTVRJL3pjRUYwRUVMOGlBeFFXNDc1YlcvV1RjVUtKZnZzSUhLbE85aXNm?=
 =?utf-8?B?ZE1MT1M1UGRVREh4WXpnSEVTOEt3UXpqK1BUbmpQbU80NGljZklUYkNWWWwz?=
 =?utf-8?B?ZjJhWkpjQ1poOWVjTWZwd0N0aS9zb2pORGw3dXFxZ3ZweldvRUVpRlppVHN5?=
 =?utf-8?B?RWtoQWxjendlTmt1bjZYSFdua3k3UXdXdGN2TlNWRzd4d041Y3pJRVl3a3Ar?=
 =?utf-8?B?dnJjTW1TUU92alIxN0lhN3BrQ1FkMnd3Nk13b0Q5VmNXdCtFc3JZSHJGNEJT?=
 =?utf-8?Q?qCn6AshGkHnd8D4HSFSc1OBgm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87856ec6-6089-49aa-dbfa-08dc638207c4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 10:42:11.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIWBWlqPVminnC0IAJY826QAIMISPy1XhOr/ey+dBoYDOQENIn4COwotgpx7txPA8l0NPWjQCldc5Ml7/WjJfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538

On 4/23/2024 3:58 PM, Borislav Petkov wrote:
> On Tue, Apr 23, 2024 at 09:52:41AM +0530, Nikunj A. Dadhania wrote:
>> SNP guest messaging will be moving as part of sev.c, and Secure TSC code
>> will use this mutex.
> 
> No, this is all backwards.
> 
> You have a *static* function in sev-guest - snp_guest_ioctl- which takes
> an exported lock - snp_guest_cmd_lock - in order to synchronize with
> other callers which are only in that same sev-guest driver.
> 
> Why do you even need the guest messaging in sev.c?
> 
> I guess this: "Many of the required functions are implemented in the
> sev-guest driver and therefore not available at early boot."

Yes.

> 
> But then your API is misdesigned: the lock should be private to sev.c
> and none of the callers should pay attention to grabbing it - the
> callers simply call the functions and underneath the locking works
> automatically for them - they don't care. Just like any other shared
> resource, users see only the API they call and the actual
> synchronization is done behind the scenes.
>
> Sounds like you need to go back to the drawing board and think how this
> thing should look like.

Something like below ?

snp_guest_ioctl()
-> get_report()/get_derived_key()/get_ext_report()
  -> snp_send_guest_request()
       snp_guest_cmd_lock();
       ...
       snp_guest_cmd_lock();

With this the cmd_lock will be private to sev.c and lock/unlock function
doesn't need to be exported.

Regards
Nikunj

