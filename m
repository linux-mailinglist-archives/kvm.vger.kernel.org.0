Return-Path: <kvm+bounces-48140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A115AC9C85
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 148EE189CFEC
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17ED91A238A;
	Sat, 31 May 2025 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wr6xi0x1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70EA14F70;
	Sat, 31 May 2025 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748719217; cv=fail; b=E0wzYTNQRPp9NUOltLaqxJ4qnDc/dV/svQTP0A5jx4KedH4j8LhwH32J6XlbrCDe0NWZU+6ukOrT12YpVyx6xlXJgjF43qlfftzlUTgm0yr0gQ36RRiLVe/bybLKwPvgTd0Vul8UtF8/S0hOCiMfNG6bEYL5un6q9nQVV8TbuUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748719217; c=relaxed/simple;
	bh=eBBTIBk6R0I4LIiTmLypxi6lyVJK6FtnwTrIAsiKJO4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LJGPsCdcNfUljX8qQ2oBuzYtMhddXjpO+APwA51dstN8OtZVZbXnAVI6qKyaXy79JWM0ouJLUOIOw/Qo1VDHdZ3dswJgoB1fhrC+chr64Oz+JC2N4GytwsttHzRW7H9i6QdX3DnX32kyXCo8KEmIN0KOPfc2f8Am976jTB+9pQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wr6xi0x1; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oF+uJF9AdWNlJH8g9F63NNGcv+c9pBo/qbqtwtEPFbEA7BM/mqzAsP09NCJN3/QrdjnIi0ScnFr/40mA1OaofaRxoTs8P9MSZxQyKZkWNs2OBVV5Rgr3uiK79Uwx/zGJFNJhIgvRxn7oNWwShgeyI1XhlgFqE+Y+po8u0zJy2bjTDBv5rakeKyCDP58hpPegLzouIyjdSpVBuNCm4BXyxRRHe5lIVRtcfmOkg7wN3zkv3ONVBaEBI83LgeWSpVsShdTnupRAZeSDDF38QZUbNzZbtJ7PyShqufWtEpPRiK0OWhiIyJIqFko2L6Usc2R/Wz+rRnBJ5aolEILCSliavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4GJYLpngqyTEqsShOf/xUd4J3ESuxFXSCVDReUYcFc=;
 b=ErlRm6qXWcsW659UK1YmJC3JAbUKUYD+LWIJunE2uIv8jIP+rFsI021XaKjtvTtq1txGg0yQb2wxQFLkRRbTsDJUG5Y6QnPl66TmCkCLQDVz1fwdRRjculxlqdpckWvwMXp23KEcR6+s9frvISKD8IZg8ul2KOEu0kSRzdPTa7YTZVRyO8Vxok/NOe5zbDfoqQTHIZxgsLt4wyP7GGFeGlwdizP9JBnkUXPlg4Bp2EU/L5d/f39Dms/WZdUeTvgTeknvu6tEDlzpH/L/RZg2TulO6dYz6ykM6/RY9SEddSOQ0FZ/h+6/WM0JxD3MaGXNb1d67YoPwHdcBQV2ZTq9TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4GJYLpngqyTEqsShOf/xUd4J3ESuxFXSCVDReUYcFc=;
 b=wr6xi0x1kYwIWkbXRxGqNSxeGqrfJOnDDgZ6V7LpxChGbwQe9MovjJvuOzi1kCEfR+Ra8onh5In6q8aS8CSrGU77N3gtYzPTVvQ4KpGbW6Tvv2YslQ1V7jOs46AuEchnOL/K7vC8TyDX0SCTfgmEyP1hgV9AXtwgxsPT0JfWq58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by MW6PR12MB8760.namprd12.prod.outlook.com (2603:10b6:303:23a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Sat, 31 May
 2025 19:20:12 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:20:12 +0000
Message-ID: <a78fcd95-b960-4cf2-aa66-37f01e8d57ae@amd.com>
Date: Sun, 1 Jun 2025 00:49:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/16] KVM: Fix comment that refers to kvm uapi header
 path
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-8-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::20) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|MW6PR12MB8760:EE_
X-MS-Office365-Filtering-Correlation-Id: d460e46a-8aa0-4991-d248-08dda07829f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFZvSkQyWC9ld0Z4WCsrajdPYzRrWnkzMi9tVzQ1SkVBZVI0YjdSQTg3UVJD?=
 =?utf-8?B?OEFPWjRGanM3dGNsSFJOeEVxam1rQXpUT2lNVU81QUQ2MU9SQ0RyUHNIcElp?=
 =?utf-8?B?QjYySHVMVnM1VVFVUHRxbDc4L2Z1N013QXVWU3FGRlVYMEtRU2UydmJsaTdk?=
 =?utf-8?B?anI5cHc0VkNRMmJOcnREUEVjeXI1UDhLT2wyS25UaU1PMURnd0dkNkNqbmtY?=
 =?utf-8?B?Ymx2bFV5ZCsreXRGQ3MxR0pRL1FNbDMyOTYydStSc01JY2h6VVo3MVlaaG13?=
 =?utf-8?B?V3cwSXdTaUcvbzlEb0V1cWE4MVBlbXBBTmgvb3BITk01TENLbHdzUFk0MFM0?=
 =?utf-8?B?a1hqZXVMM0FJc2plL0gxZGJ4cm9kM0o4UXVoOHc0YW03Ylo0T1B4eFRUbFJD?=
 =?utf-8?B?TEdVM3pSZk9WdGIvdmhnc2M4M25SYlJYRzNBR29kRTJZUTF2TlI3WFpWczk3?=
 =?utf-8?B?czdzYzV2R1BXQW9JR1dxanp4c2crN00zdEh0TkMyQmdMZjNHbEpPOUNqaWJ0?=
 =?utf-8?B?dzF1SXQ2ZmROUmVQbFMvRHh2UUl5SDlndU45ZFdFTXlsR2dBWktJa29Rc05R?=
 =?utf-8?B?SzZFZ3lzSDRLbGRqOUFPOFJ6Ri9YeEYrVVI3aWpoY1kvdElxbWNMNmlZeUx5?=
 =?utf-8?B?YU1kWjFHc29TRVBvUXZ5cmhGUEltYy85QXdtZ2NnU3hieFl3Q0xvdDV2SFFZ?=
 =?utf-8?B?ZWQyMk5oSVhzTHE2bnNQeVd3ZTZtSTcrM3JiRFNURjAwNUF1YXEyNEczWTU0?=
 =?utf-8?B?OUJVY0FoQ245K2JBZVFKZG9yZTYvSFhuTk5HbEhTUERkSlVvcTdHZlNzV0la?=
 =?utf-8?B?R1FWdHpON0MvQS9CaGg5UnFCZm9jNU15VFJtOGw1eDM4ODI2VEQ1TXBhdlFh?=
 =?utf-8?B?SkhEamZzMDFvYVBrMVAwV3QzS3dvMkZXcElFdVFoUlRZUmdHSGNEaU9NN1lD?=
 =?utf-8?B?VVRmalRxYUNuenVLbUsreUIyUTJJREh3clJNR0FDZXVyYXFJajJXRTB5OU1h?=
 =?utf-8?B?czc4NUU2VW1hU1p1bERoSUhDSk4zTmRCUVRHUHh1YkdFWC85VEs0Y0g4VEVr?=
 =?utf-8?B?Wm5oWjVPdzh3enI1Q1hGMXc4RUxxYS9JclV4UFpvWjFSNUNGYVFUT2hUY2pq?=
 =?utf-8?B?QTFjc09rZzJ2RXNzd004Y3NNaHNTZFI2L1dXQnF5MXJ4cW53aVRBS1ViRGpH?=
 =?utf-8?B?TDVadzJTa3VVOE1tZFQ2bTVaM1ZaaFFBOSsrTkRMMzRoUC84ZkduNTNJaWh5?=
 =?utf-8?B?bXEzdnFYS0Z3dHdQRS9seVhFMXB5UiswY0dDV0NTRVFXY3cyUHJOVWpMUGZs?=
 =?utf-8?B?b1dSQUllVDJ3RVdYUlZnSEFjV2lEaE5SSDJ4RVprakx6RXBUZ1BScDVJUHlX?=
 =?utf-8?B?THBrdVZXcXNHMU1GQUpOaUErejdWbm1zZkQvWnhuNjhna2pmbkdtTVhFWXRV?=
 =?utf-8?B?TytNTjVLNEYyVHlRcWVRc3BreGptV0ROSEtEcWVXcWkvY3cvakE1UmFHY2pj?=
 =?utf-8?B?eTJ1NlUwZVlBb2tRN21RWWxvbHo5ZHBMVHBFOU5KQTVHMmIvQ3hRSmV0bHFv?=
 =?utf-8?B?eUE4ZnZjU2tlRFBUa2txQUZXZG1tQzUrc2dpbmNtK1BpN3gzR0s5VXJmS0Fi?=
 =?utf-8?B?eTRTYlQvdkozTGlqMEhubzdjVW5LL1h1VzN4aGM3OGZwaHlUVjdIMTdoZHU1?=
 =?utf-8?B?U29CVGxVUzdOTEFNZUJNWUxoL2U1azdsaXZMVHNIV05DMk5ab1pKRVlYMk05?=
 =?utf-8?B?L0hnR1ExeVM4U05vek9ZTGF6amJHU1c2WjJ5cU45SFB4OEJyMGZsRFR6NnBZ?=
 =?utf-8?B?d1Y4S0ZkZnI1TlBsMk9WdjMvYWVnWlR4QjF5b0MvcVdGd3ZNUWV2ZnlkTmFM?=
 =?utf-8?B?QjlGVkM2aG1rYUJFOWlXbDZGNnRVeHlnYkJNdGF6N05oV3J0OU1tK0VxckM2?=
 =?utf-8?Q?giENoO0ZkEk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0JxUll6bU9uZk5JeHQ3SENqeFlGSTArY1JOMlI2NVMzOWFHMTkzdzJHenc1?=
 =?utf-8?B?ZXBhKzVjVXJvcEw3YUY3OWptV2RZWDBTYTU1cFZveVBMRk9UeDJuZTYrU3pE?=
 =?utf-8?B?Zmk4aU5tMnpzWE8zNGowdmlEVkJtR1Y5UEMySzJJVEtEMm5CcG1oWnFLZSt6?=
 =?utf-8?B?MW5raUI2WTRCbnpaYUQrUlZkbHZiOHA5RnZoWmJUNTVVT2JXS2NxNjluTUZ3?=
 =?utf-8?B?SW9tVDh0eTN6bDlTVU5yTHpUM0txeDMwLyt5L0J2ZlhQUzdIT3R2Z04rRXRj?=
 =?utf-8?B?ZWdoclpLRmdnVHBIbzJEc1lTd2ZWOUs5T2dQY2ZJRS9jWWNIckpZT1B6Mi9F?=
 =?utf-8?B?RUVsbnFXbUlqL0h6dzBRQmRLb0Zma09rNDRZQmJ1Z0I3aW94TnlOZ2wvK3ly?=
 =?utf-8?B?L0syYWY2M3VXU2h6T0lwaTNzWUhDZEp4ODMrNzlQN1YyTjVhS1V1bnp0c2xr?=
 =?utf-8?B?Vk0wWHRjUk5JL2E4Sk9qZnQzQ1FYcG9yWHJabmxRVEsxZnVIMG5zYkYzMmxy?=
 =?utf-8?B?Y0hTSFkzeVRaUENMaEtlNGIvL2FsVCtHVjdvMGl0SjBjRExYaTBuM2hEdjV5?=
 =?utf-8?B?SkVzc1l6cG1QTWVUdnNzM2pOVGc5ZW9qVnhhZWcwTVhSa1YzWlprSTIzZks3?=
 =?utf-8?B?dENFMEN1MXZtVDZQcmQzZU1EeXNwaVA0SGU5REhkc1FzWHNUbUZ1K01XRDN1?=
 =?utf-8?B?MlFId1dkN2Vvek9pVUQvSzJiZmhtUmRvS2diYjlhMXBPMFBSYnNCcTl6azFE?=
 =?utf-8?B?czFtWFJUVDhZOFltSFJtdktPNjNqUHpaVlJuSnJ4a0Voc3hMMlJyMVdxL2Fk?=
 =?utf-8?B?enBTS0RzL1g1OFN1ZVlVeTlNWGp3NUZpR2FzeTVveXA2czRWMjhGNFA3akJ5?=
 =?utf-8?B?dWZma1dFOHlSWGYrK0RsNUR4UUFqTUhQaUlrSVFyM1VzTlIvYURudG96SVZs?=
 =?utf-8?B?UEJDV2QwSGIrelFYOC9tWEJrSXpnYUp1Z09IMTYvQ2JPdy9yODBSUXF0czBX?=
 =?utf-8?B?SFd3NDJ0djdoanY2OVdjQ1B1RmlHOER6VDlsOTJwRE5zSUlwN1BmRDUrOFcy?=
 =?utf-8?B?Z1BRMVo2U1BreGwrWStlV3Y3UlMxU3lpTTlTT25DWkJBNjIyUk81NGtZdXpw?=
 =?utf-8?B?MnErWGwvemdqZHRDdDIyYzdiWUM5d1BRZTA3UGVrN2JaS1ZiWVJidTRyNkJB?=
 =?utf-8?B?MnR3a3VBZUpWclRReS9Ta3dwdGJmWXFnakJ2VFc1d2tvVEtSVFE5d0NQdnpt?=
 =?utf-8?B?dVoxaHR5VUN6QkhUTVE3dzZ4dzlJUG9VVmMvKzkxb3dvM0MyaElFVXYxVjZh?=
 =?utf-8?B?ZkhjOHNzbEtCYWtsdVJWSVdrQUl3ZTBKRWZlT3B2UXlpTjFaSzRHaFBKYVZw?=
 =?utf-8?B?MEFVSWpBeWIrdUFTOWJWejFKaDVPUzRhZ0taekw2dDBTdm92TXAvakpZY0l0?=
 =?utf-8?B?eHVPNm90YndkTGMvZUhsOUpwVUg1R1pyQktycmZhOUZzYUpqOGRZejhGQzRV?=
 =?utf-8?B?bzUvTmFIYXhwVjhnU0JvOTNWUkc4c0s4TG9idzBDQ3BzZThJK3J0Mnkza0xD?=
 =?utf-8?B?Y0NjSElLU0VEbWJFa1lOSjZtY3hIcmNNTHQ2amlUcmxCQnZxQVk0YlNUb20w?=
 =?utf-8?B?eDlyR1BmWEtxaFdjeHBoY09zcDY0V2lvdTdUUDI1QmtTUHJCd3h1czh5cENU?=
 =?utf-8?B?b2p0VVd5QVBmbnpyTnpUY3dEYmtsY3RsQUM1VmN1K1BIY1NMRnhoM1RwSktj?=
 =?utf-8?B?UXFVc2dMeXBsblBGcC9hTEI2UzNiOWtodUFJN0ZaUDJoNEV4SzRvOTE3MjB5?=
 =?utf-8?B?b3EzSG8vbWZDckMvUlFPcUUxTmdPNWpMdE5Cam1XRHZCNW9kWnJKSHp2Q3BD?=
 =?utf-8?B?OE9qT1hIMHpabHdXMHU1cHdYMjR1YnV0ZW84OTByZ3kzT2daZXFnL25tbFMr?=
 =?utf-8?B?RTM1Smx3dFYrOEJiN3JJdXZ0bmtKV0dBTG5PYkR0ZTl1MHREL01sdmdlWC82?=
 =?utf-8?B?ZTRiQlJmVTU4blUzY2dHSXM5YXEvaFlIcjlWeDdGenRkcnJTZTY2NTZGeG1V?=
 =?utf-8?B?QmdJWWczeWM4Q29rYi9PckdKQmNoem9FbXVTbThDSmdnVG1vcElIbzdEVXNK?=
 =?utf-8?Q?T4bv8Q9Tl8UTHm5wT9jrLc0mz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d460e46a-8aa0-4991-d248-08dda07829f8
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:20:12.2101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJ9INRk6df0qQc2G2ZMDsQfsYhqRJ8tRoGDD9/HJpMIRXMZMIQP5VxFvkMXdlqrpDM8NeH9aY+kSiJf0cBgVLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8760



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> The comment that refers to the path where the user-visible memslot flags
> are refers to an outdated path and has a typo. Make it refer to the
> correct path.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae70e4e19700..80371475818f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -52,7 +52,7 @@
>  /*
>   * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
>   * used in kvm, other bits are visible for userspace which are defined in
> - * include/linux/kvm_h.
> + * include/uapi/linux/kvm.h.

Reviewed-by: Shivank Garg <shivankg@amd.com>

>   */
>  #define KVM_MEMSLOT_INVALID	(1UL << 16)
>  



