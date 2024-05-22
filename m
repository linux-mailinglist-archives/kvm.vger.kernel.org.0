Return-Path: <kvm+bounces-17922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D478CBB02
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4861B282DA8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0654777F1B;
	Wed, 22 May 2024 06:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jFs8qmNe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBE81C6B4;
	Wed, 22 May 2024 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716358286; cv=fail; b=fanJ9QA3ATloSYEK01CInyxQwtFuCcmPFq4vxu2vnBYuYhBU4i345AaSPA/1Qsyo2tm5WHmQluKSs0wpralgsHRZBb9eWnEgxVaVvroms0pIGqqCqGjcnGQAEyB6CQi25O4i13zCzaMMYAXp/U0cl/mQKYaI0aHyckX12p5T6hE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716358286; c=relaxed/simple;
	bh=sKXDPCRFHyE4KwSzCMrMHn+DFbsK5LuENMeXCogwErU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LcLh9qwyvf3mi+mpXpS2yrboCjjil9BzMfZus47coT/VhBnX2mpXURYA0Jl7Y6DOBMl7KY4m/9wLssfJjsll3P2axP+kQpSZ9ejrRDWnyqaRfTWYgcMgA4DDT+2aArs0rgVY7MXYS98VSKN7u0b3REKF6CMIrr+Im7u+yNV5pS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jFs8qmNe; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gv8Lnq+qwhPxmVUys4WwD0VHCKBkj7iG6J1/BX0P0+Z6DLoOO3XOoW8pHMeFqES85ioVGNIF/lXvOeh/iLmLh2Xmx7krxnKdVWE+iHmUJhwVQ325Tjo6V/NmZBR443595FqUksyIArgS+nRtb0v7ZFxaWXyWbNXNfuP1Ax60LhUsM1O8Mgpth/Gnk46FXC+WMesVAf/Kliox939KwFBeRmstOUWAenP/2fXZXFDtSDBQMYoJ78yi4ZBtKG/LlQbTmSAs7o9t8Pbc/+VhY1cY/wr1BSYaHZl+kxSvY6q/8B8AclfWOfF80bBjqqVAWlwlVMKN9lSVISCDZTIAMoRZ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8TKIKgn73iaIOnoTredVOKJZDDSxlMSznVOcwfETws=;
 b=Pd95TlYrcHXYmQ/frgfaeNpFYzw9D9i9r2UP1s1wwx5ylf28Q9IBBYSNLJ0BxjivohaHKc0Vjzj/8/FEdXR/rOi3pQepdaJcpagphfKJfd1rGH/VaAdk+LWe0ME4m88MTFa5a/AB2hZ6R+Hyv40mfaSpoWZA7IVB3T8gzOMTmo6AJ9kJ50E6NvSMewGqs6hiBlPb3MzgxUeLho+ixIoH70SCCEhJcs9PtyU36Gf1p3apZt+oKCiNZDpr33HU9OyJYhy1Ow94oZCzYXZCvFNyI+0hbmN7LR21XE/JznxlCWpIwww37UpheZwV99L70EdEq5QRWz9YjWfyJEHXSJqVRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8TKIKgn73iaIOnoTredVOKJZDDSxlMSznVOcwfETws=;
 b=jFs8qmNedYOn3JsnSOZ/LKZnVfo9y2oyQ+dlBL4XHs6Sk+ROwtI8K5cVZhbP0wT9Bt1Cd8ZXbT/gMcgXeebCKmZcdINwQ4/xOojBKyMR3pixBoRFZImKDwRsGBcUret48n/NDpv6oULxc1++7ZFkyM/ivHLwzte/5XpzUUF4DW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 06:11:21 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 06:11:21 +0000
Message-ID: <9316ce80-b9c5-44ce-ab66-e7cdb6893c1f@amd.com>
Date: Wed, 22 May 2024 11:41:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 ravi.bangoria@amd.com
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com> <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
 <Zjp8AIorXJ-TEZP0@google.com> <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com>
 <ZkdqW8JGCrUUO3RA@google.com> <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com>
 <Zk0ErRQt3XH7xK6O@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <Zk0ErRQt3XH7xK6O@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::22) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 929df9f2-9257-465b-ee01-08dc7a260030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2FrUWtYN0Y3NFBuVGVxa2h0U0hzdnJnUGxQOHkvZmhwMW00NUpZZCtOenc0?=
 =?utf-8?B?Ry9STnhkS3ZJbWNyenFrdnBNWnB1eklVQ3FnSjh1ZHc2Y1ZKOWJPOVNSZ0xy?=
 =?utf-8?B?eGg2TjRuWDBCeVd0dHRYMHRpTGk0a3o5ZHlmbnZ3dVAyTU9TNUZVSGh2Wmw5?=
 =?utf-8?B?UGVPK3V5d0l2VUJJZkhMTmhlbUlHaUZNdXY0VDNaQnJsRlpJOWg5c3BDN1pV?=
 =?utf-8?B?YkhHYUhkeXNNYmh6RkdjSXJxTGVKcnpPVjZCdUJpVmV3NTYwMkdZcWFvd0Vr?=
 =?utf-8?B?RWJZS2FPbkIyZEFuT2Yyb0ZCMmN4c2FHTWZWYXg4bEQvSVQwT3dndmpzWVNa?=
 =?utf-8?B?bm4yem0rcSs0MUJBSHZ6NTJIZVgweWpvVkVub0NXL2dUSmpFM0psKzQ0ZTk5?=
 =?utf-8?B?MWc5czJQTlRGY0QrS1pIT1llNmhoSmtyc2FNdi9hcWxjZW5UU3U3RDJEeGo4?=
 =?utf-8?B?dU5yL2xlSjlRbUpyV1gvK0s3UGdOOEQvZCtPUnFMMThuNHNxMUxOQjZ5M2d0?=
 =?utf-8?B?bnh1ZlFvWFZvcmNZTWU3dFJtMVNMWFRPcWhFc1BGbkplQjlxNzFUNTNmTVln?=
 =?utf-8?B?Rlp0WUJNbi9yOHpQUlZSdXNoRlBINm02b1JISVFqelh4WFhsYVBvanZ4V2hZ?=
 =?utf-8?B?NlRlYkswNjRWMS9DTkE2V0hqVmVqaFhmQnRlVHlML3pHTUo0NnVVM3B6NnE4?=
 =?utf-8?B?SXRtWGpicmtiZTJacncwMEcxN0JKWXdjeVBaQmlhbjgyVmYvaUxHbUE4bUM4?=
 =?utf-8?B?VzBjcmIzQ0lKekhnV0g0R3R4a2dCMzlJa2tGaE9sN2FpY2EzWEFRYjVFRndP?=
 =?utf-8?B?WVg0a2hUNWtMakttRjJvWTJTRDNLa2twMkl1b3FHeVppVVdvYzlvRjNXQmdY?=
 =?utf-8?B?dUVEV244ekJNUXJEZytycW1LYmpJN3J0UE14K2JyaHhoNmlhdHBORTcrMURR?=
 =?utf-8?B?cVkzbWZsaDhYQ1ZHc1dRM3lKZWxzMENiTDZoUnlpbnN5cEFtUFJwNEJGUHVU?=
 =?utf-8?B?eHRMT3NHSDdFVG9ZT3oxUmZSSGtCOEdsTmZBVGVPZVREblVxTkdicVc0UXJH?=
 =?utf-8?B?RnppTXM3UWtoLzFxb21ML2pNZUM1OEFjbzdtNmNvbVVidDVFQVNVNnhtRXYx?=
 =?utf-8?B?dzVCakdiNllFZnZHTDNhWCtNcm9vV1VidjVCUHkvNmNJUXFuNjJ0aytOZzVm?=
 =?utf-8?B?dmJqRWczQy9HQlBXZUNlOTVMQUxkMTYvK2FCeEtjUHpvRzBFOTF5NVY5Wk1k?=
 =?utf-8?B?ZTFsMVRFenhTOVdycUJ3d0ZEeXF4eGVYWmE5bW5mb3psbEFxeUZOajZHWHhU?=
 =?utf-8?B?ZjQ0YUNWNWIzWFdwVmh6c2tOREZhc1N3T0ZoL0orR1hscTBrTTNtUWtSdUtO?=
 =?utf-8?B?dDFRUUxGT3ZmeUFscy9BeTJiK3ZSWExkNTFRNEtLN3RjVW9pODBRSXlLNmFY?=
 =?utf-8?B?TGhnNWpVanA0a3duc3YvRzdKOG95clpJK2dGM0lpUmRLR0RxYkdUSnhyRzIv?=
 =?utf-8?B?VVl3OGJFZ3FjdnRuNHlndkhpYnd4OGw5MnF0UVduTGhPOHdQNER1cndRMDBP?=
 =?utf-8?B?QzZ4c0pBMER2Vmw5bHVJNTZXT0hVVTFLOE9pMkxodkE4WUFMcWd1UURTZllD?=
 =?utf-8?B?Q3FNWGZSWkNBdXdBUUtLYkJLcU5Eck1KUStRUzBuTTF3WnM3a1JzQnFic0tF?=
 =?utf-8?B?SFlnaXR3Vk51WEdHZnVPaEVoYkFhQVhlSGZUd05xZjdQU2NReGMzL2V3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTliR3dpQno0bVhlMzlnT25GU24yTUI1TjJTUTF3ankwUEZ5WiszcnBSb2Ja?=
 =?utf-8?B?UU1Uc29HMUZBKzhUMzRwbnY5QmtKcE1Qa2d4b2Y1WW9KTm1jNENFcWlOVjk3?=
 =?utf-8?B?NmdlZXltRWtMREJhUkVEcnpRVEZzSmFLM0MwMU50bHhMbGR5SVdyVk4yWEEr?=
 =?utf-8?B?ZHlETmlXbVZIMExndWRydkNWeUc4ZXVaVWFDaFdMT09GR1FLTXc4UzFvQllU?=
 =?utf-8?B?U3ZycER4UDdYMVgwem9id0xNalpSTmZXaGtXS2dSS0I1UVdyQnVUems2RGVM?=
 =?utf-8?B?KzJuVmZYd3FSYXNUdU1CK0ZwaDE3cnhNV09lR2gyWGxhSVp5RE0vWllSbHEz?=
 =?utf-8?B?dWNXWmNSOW5sZCtvQzNMZlpnVi9WRWg0NzNVd1hBTWFqdkhvbjhhcHV2T0lX?=
 =?utf-8?B?RzRYa0VHdDNaUEZKQWxjcE9zOEs3dFlTdG04ZWJ4aXRGU05XTjJ0bkN2blV4?=
 =?utf-8?B?dFg1NkRta1ZEK2o1N0J4SFd3cjFBOTV4S2cyNFhtYnA2a2dUa2hFRmxjY2hD?=
 =?utf-8?B?TlhYR1VMMUZsQXpiMDZyMlQ3OGxYNzJQUXloT2Ftd0l2eXJ5R0F5Y1NlSzRB?=
 =?utf-8?B?a1JrVmxpbmNEcHNpQkk2K1h6Qk9SbE4yNzhkS29iNW9OV1N4ek85M1Z4Qk05?=
 =?utf-8?B?bi8zUlp4QXUvTVZWcjg2MUN0a1NQMWg4eTY0V0xxb0l1b251TkFSTkFhS2VJ?=
 =?utf-8?B?bDBHcy9JekVid25zUk5WNUY3M1NkZE53NlZUeG5UU3ZoQzk1RHU4SlFMWU1y?=
 =?utf-8?B?L2g3V0hNZUhJL3VuU3ZxM2ZmU1F4SkhSKzlyMmZCUnRpS09JZlJvcVE0QVBO?=
 =?utf-8?B?VmdDNHUxMGNtRzN5bXRDcDNzeDIyaEcwdExwM3BUTks5MzJjdlN5T2NDZkxt?=
 =?utf-8?B?OTgzU0lQcEtXcmdOT1J6RGV4ZlRFaTNuL25yRlNLWnVFRjdaamlsQlhPNVpm?=
 =?utf-8?B?WjhZMXQzRlQzZEp1Y1I1YzBzTWd6dDQ0MEIzUE5Wckk5VEZDeDdvTXMwWDdj?=
 =?utf-8?B?aU9Qa3QzM0J2UFJJOEZpSlgyclA2VVdiZnlEdWZnWis5SlZkRms4UFdUczRW?=
 =?utf-8?B?S05TcDNSVm1oZitGOEo2UHRsZURVR2ROYjFIUjJudVkzVzB6bnpBT3dOclIw?=
 =?utf-8?B?MnA5Vk5zMC9ybm0yVC9pT2RvZjJBTklaZUJ1cVJxeWRVUEZ2cUZOd0VYVVMw?=
 =?utf-8?B?djA1OFMyb3RWZERSOHdjWnJJY0dEdzZrVVFuUEJ6dStzbmtlM0dPLy80b1JM?=
 =?utf-8?B?Um94RTB2QkFPazh0NDNZWlNHLytrM0ZWUGtEcFZYQlNibTEvejBzK1NlcGIx?=
 =?utf-8?B?M3hLRWF2TUZFVlkyVmNIcW0vMkEramszYWNrNnRFVkdoUmI1NUxBaGpMeHp0?=
 =?utf-8?B?SUNPb3d4N1VobXhUVnpHTUZ3ZjRldm1CcUZWUko1VXNjSEtJQ2VIcEJDQk5m?=
 =?utf-8?B?OHdKdG00TzFmbzRJUDRjamVrcGRjYzMvQ0pDRktLekFIczNWR2xURE1CM1E2?=
 =?utf-8?B?U09DaDhpb2owZHlTRy9aSThwRDJqdGc2dERLUWg4dzl1OEhvc1BGNkpDaUQy?=
 =?utf-8?B?anB5ZU1iN1ZuNTNaRk9RemcrWWUwZnZsNEFDc3BFNlBTTnFGTDV5b0tWVTlU?=
 =?utf-8?B?TEMxa1BuUStxZS9KbnIvUmxZY0xabzVrWG41TzRiYWhPYnZlVGJiRmVjM1FM?=
 =?utf-8?B?eEIxQXZsZklsMnZxUGc1bnR1QjNvZmduRmtiU1lraENHTzNJOGlxTjMrazEy?=
 =?utf-8?B?OTh2eTZ6anpEN1NxeXhDdmNnRm1HbTdoTUJyckw3djJJK3YwVEVoMStjd051?=
 =?utf-8?B?RVI0RjY1bWhCTDdIdERndEpLYTAyME1ZN1NMQjgzWkkvMEtISnRneFRrbitE?=
 =?utf-8?B?T0VEUU1nOUlSVURiWkJiWUVaZURhcTkvTEhXc2R4NnpnMUt4bTdKVHdtSmN2?=
 =?utf-8?B?cmJ0Nlp0eml0UUFMdzVyYkx1aUpxcVlOeHhsL3E4YUpaRG1MdE1LTWVqeWc3?=
 =?utf-8?B?N3hoS0V4bkFQcWsvbmh1dGRId0M3R0JuY1EvaTltSUVQby9XanlGNE9ycmxP?=
 =?utf-8?B?V3JJNHZiTHovREhzZnFIdm5KTmM3bEUzeHdGY0U5VmRYSmtlMEI5MDRqbzRI?=
 =?utf-8?Q?mwiGNd29Jpt98FHRvabdEppJx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929df9f2-9257-465b-ee01-08dc7a260030
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 06:11:21.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g56GXAOHD7FdKizcto2ongp9JN/3W5Rv0GuO6M1id3Lav2PUQTIX0F2B3ZdYeLPUyJUmyMzI/qQk8nBCm9HcSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177

On 5/22/2024 2:01 AM, Sean Christopherson wrote:
> On Mon, May 20, 2024, Ravi Bangoria wrote:
>> On 17-May-24 8:01 PM, Sean Christopherson wrote:
>>> On Fri, May 17, 2024, Ravi Bangoria wrote:
>>>> On 08-May-24 12:37 AM, Sean Christopherson wrote:
>>>>> So unless I'm missing something, the only reason to ever disable LBRV would be
>>>>> for performance reasons.  Indeed the original commits more or less says as much:
>>>>>
>>>>>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
>>>>>   Author:     Joerg Roedel <joerg.roedel@amd.com>
>>>>>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
>>>>>
>>>>>     KVM: SVM: enable LBR virtualization
>>>>>     
>>>>>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
>>>>>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
>>>>>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
>>>>>     there is no increased world switch overhead when the guest doesn't use these
>>>>>     MSRs.
>>>>>
>>>>> but what it _doesn't_ say is what the world switch overhead is when LBRV is
>>>>> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
>>>>> keep the dynamically toggling.
>>>>>
>>>>> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
>>>>> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
>>>>> a wildly different changelog and justification.
>>>>
>>>> The overhead might be less for legacy LBR. But upcoming hw also supports
>>>> LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
>>>> 16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
>>>> through the same VMCB bit. So I think I still need to keep the dynamic
>>>> toggling for LBR Stack virtualization.
>>>
>>> Please get performance number so that we can make an informed decision.  I don't
>>> want to carry complexity because we _think_ the overhead would be too high.
>>
>> LBR Virtualization overhead for guest entry + exit roundtrip is ~450 cycles* on
> 
> Ouch.  Just to clearify, that's for LBR Stack Virtualization, correct?

Includes both, since there is a single enable bit shared by them.

> Ugh, I was going to say that we could always enable "legacy" LBR virtualization,
> and do the dynamic toggling iff DebugExtnCtl.LBRS=1, but they share an enabling
> flag.  What a mess.

Agreed. can't help :(

>> a Genoa machine. Also, LBR MSRs (except MSR_AMD_DBG_EXTN_CFG) are of swap type
>> C so this overhead is only for guest MSR save/restore.
> 
> Lovely.
> 
> Have I mentioned that the SEV-ES behavior of force-enabling every feature under
> the sun is really, really annoying?
> 
> Anyways, I agree that we need to keep the dynamic toggling.

Sure. Will prepare v3 accordingly.

Thanks,
Ravi

