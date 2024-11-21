Return-Path: <kvm+bounces-32324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC6D39D5468
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 22:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0772CB2189B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B6E1DA63F;
	Thu, 21 Nov 2024 21:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kzFaD5Ds"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACAC1D959E;
	Thu, 21 Nov 2024 21:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732222813; cv=fail; b=XpcCyJr7hrvusrghLgzGknmY+O8E7g+6KLjqIw3HeD98+77xsPoIGCIqaqyU5QPW1r39L7uEChfeZnyCjuTtV5BPyxNvFfcMetDgY8psqCa8d07j02ml3ZQdbuLFIGnrTjHG1jLwQ9Hw2dxc3UqwcFj2OgEqaF41QF7ZgRzLIPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732222813; c=relaxed/simple;
	bh=1xoHgaUHxgkEWX7eMQj3/p7tMeAXDC9OKOh7P4Ro1Z0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XK8vmtNR3zCgkScFMHzd6heu1t9rS695Ng2bxsQDAPpA1WWY2inJdCCysCPCHUd/UxWVIdDiVcRftUQXyU7vny5N4RhuAM+mqsmIcFkAIKq18/Rt3hH+j1P9r4MlGRGCAGzI+vbxp/qVcXz6pMKESig7jgdgWDrCt1JgkCT/Gf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kzFaD5Ds; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgffPCfVcVLxkXch5UZAZ9Z/NuYXQlIjn2UIe4qK7Q6exbBM6Pxy8MZEr5MRlw0jGlQp0liDMRwspmDy84r+Lh9rTsj8lLo4cptRjx5dBeaOPjBsyLNmUuCd/5l5YihWBpWbPOZ94HYRuG7S37HzrhRUSiTyL1ZnP4XSE03TSwupO4OTjRDHQRzkOd0mKLaL0L/UWxlOtJ2UClH5ZVBnfdvnOCjhEeOq7m28Chj3Rs9OHf0hIdzkxQzMuuFpGDbcEnRcQeDp8LplftLyQ6418jBDdpYWzNuEEEkthrBRABDroX/1If+c9wnl9fuQ6yNIJPz0ExandTrMbayXkNTVgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Of0WQX2msXgqnJxSk6df52gIBND7/6tOm/He3/W48NQ=;
 b=voxlo2VS/ZN7SUKv9yTS4OAO82kC3QiamkhWOyZegoHULaae89LDzcPVXrbCK+zVIRQsQKcyR3kXLpGo03D7MGgS0m192nhYUyo7+V9mLyF4Wkcy6lQBennoQ96hFCHC33JT1LXME8OAxLwvlTLuYjzV/fce8JYDWJIyEPXkC2D8w4t8Jqd5N0C8H3+80MiBeDcuJe0IVpsKmYWlQBEWPvkRE8m4kJVjOXGdycMwWvFeTtKGu0JvRyxhFJH1yiY617OoEMdGuX+jP9fafZK6P7Y+FxRnRnOcfi5XSOJyd8QRxtIun3YuUzcODFw1yMOfXdR8V/QFtm0fM/l+DewwKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Of0WQX2msXgqnJxSk6df52gIBND7/6tOm/He3/W48NQ=;
 b=kzFaD5DsAVav9e/Iu0gPAarn2ust3lkL9qI0yPbh20hjmEQDiABhFQOw6W3I64ivBxKZtDTbhJ6GlpaGYl3nPsDZXV/QujaKvhJUGwNvCZihuyh3G2+XzKEr48+9IUzYe0DNdkihOC/38rruBFt6ut3Jh9+Tci8i71lrtc2q+Fc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15; Thu, 21 Nov
 2024 21:00:08 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%4]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 21:00:08 +0000
Message-ID: <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com>
Date: Thu, 21 Nov 2024 15:00:04 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: Sean Christopherson <seanjc@google.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com,
 davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
 <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
 <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
 <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com> <Zz9mIBdNpJUFpkXv@google.com>
 <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com> <Zz9w67Ajxb-KQFZZ@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Zz9w67Ajxb-KQFZZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:806:120::25) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: f9df896f-7ffa-4158-996c-08dd0a6f7af0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TE1NM0FsekNPYVlHaXJWNXU0dHAxcStsRzNtNUk2bk5Mc0VrbCtxZFdmaExa?=
 =?utf-8?B?V3NjdkpMQW5Ndkh1Lzd5dXQzZGFNL0gwL1NBZENpbjlFRlNjYnB3c2l2Z0E0?=
 =?utf-8?B?WHJsZ25CR0YwNHF1c3lFV1Z6UXBzYzE5YkEzSGV2ZURWOXZqWHpJa3BYMjg2?=
 =?utf-8?B?cEJuNGVRbzJUWU44bURyeExxTUU0QjRZVFdGZW9RUHJSdDFmWUY2aGlIdGRM?=
 =?utf-8?B?cVNGamdwOHV6a2JjWDBKdlhXRlh1MURQdS9aSnd2MExyU09oc09QUWxrYzZo?=
 =?utf-8?B?VnZjVTRXNWFnUVdDUVliTVE5TkxHS0M1R3RMeWE4Ukt5Y29wTWVSVnhmcVRU?=
 =?utf-8?B?SzNqVjMyTXQ4U1Z0NXVlaDMxQ25GWlZrZTJjZ3JlUE1qZmtVUXdTTjNuWWRE?=
 =?utf-8?B?dVlRcy9jckh6L2djalVXN1dwSGVmSVlQNGZ4MDE0cEJCTGlDN2R4WCswd0Zs?=
 =?utf-8?B?UXVsZ25Fd0lDWFhPMEFwcHVETHNjUXc0SVNGOXFVem0zd0gwNE92S0s5ZitP?=
 =?utf-8?B?NmNaMDNjN05kWGJkdmYwL1hHMXZnZGpLeW1jdUNXUGVXamZQMFR6cndNMFV0?=
 =?utf-8?B?c0MyMHhWMXI2aTc4RHlMWEpRRzVsVTdMY1hXQVY4MkhYQ2RVSGk0ZWJ0eWFt?=
 =?utf-8?B?U3hoSVpSVFVZK0hTR3E3eXVmSGdSRjN3LzR1WFVUbG5HNmxIdEErT0pqaW9V?=
 =?utf-8?B?OGVhc2dpdG92N0xPcWJQYkVmYWZjVGcrODNRaGdrUUpPOUxUWmtROEhUeXRH?=
 =?utf-8?B?U3R3bzVoRTZaNDBVVVRsQWgyd0lKc2JUTmFaemsxUi8xVHV2SkRCYUFaUnFl?=
 =?utf-8?B?M2hud2VXMUd1S1VINmwrREJnU0NFQ2VpN2Yzam8raXk3NUFaRm1FQVd3c0lz?=
 =?utf-8?B?MjFSdjJvWjF1TlF0NFNtNzNpNWJWRWVVTG96ckNsbEQzL0VGb2doVFN3ZVds?=
 =?utf-8?B?eWJOWVQ4SkxEUUFVcWpCeWFyKzAxT1hBYi9GTFJYQVdUcklRZVc5Q2ZHMnVv?=
 =?utf-8?B?bkhjemlrMUhabVRWcFVwWHF3N3lTaHd4V1lBN2hjUHZ1Y0ZDa1NzQXY1c3Vy?=
 =?utf-8?B?Y3pnbUVBclJqaWphRWFCMHhvVVlSMHlFdGRaSnEwUUNxZVA3Z0JsNkw1eWxu?=
 =?utf-8?B?Umh1UjY0YlRBK0pnOVk0bzhuZTd1dXZEL1RzRDRCbEI2L1JZSVNML2lRSndz?=
 =?utf-8?B?akVtMWxnc2YvZnBJODlwenkwNDRTQlVwbDFTeFNNSmRjdDNhUGkwcnN6T3R5?=
 =?utf-8?B?Ukh2VVIra2NwUkh5MllHT0djbDVJZGFZL0FrOFhDUTcvN1dGL25GVStjRlZS?=
 =?utf-8?B?NVZ3emZZblJmNU1CbFlmalc3N3hia2l0ZWEyc0VYM1QzM3NFK3k1S25DTGp1?=
 =?utf-8?B?ZVJEODF4V2ZMc3FpVjRheFdSd3VndHNjNHNpU1o4bU1RcU9uZ0JrdElkWDVq?=
 =?utf-8?B?ZzJPVDlwL3ZoNnI3NDdUNVBzbFhUMG42aDhGcUZVaUg5MU52a0c0Z0w5elk0?=
 =?utf-8?B?Nkdlb2Y0TDRSaEx0MEl4UlB3QUNmdWJaVHZ5alRmREVtYlNoL1JKZGYxY29Y?=
 =?utf-8?B?NjZ6cFcremozckR4MjU2b2FMN2tRNllFUFBHUkhYSW1UcGZKMkFRWERaVm5W?=
 =?utf-8?B?aUt6MEpwV051V3hXd1NvdlF6cWNhaWE1S20zTEEyWWFWN1RrNXlLUjRHY0xK?=
 =?utf-8?B?OFJnRGY3UWRPN1FBRUxnejdjNVZ5Ym1yYjlocjJnMXpOcmZKUVpZY0Z1RGpa?=
 =?utf-8?Q?Dxsiw0cm/soxMbPNCyK0awnQj2ILOtXVombSNnJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1I4U3p1Nk90WGt6ZWkwUUdLeDRTdnBEb1VCUzc4cFNOZEVvTWJKenNLSTJj?=
 =?utf-8?B?ZEhZOHhub09vUVU0Tm9pNWVpL2pzcnkrRUI3Z2pOTlhycHdpclQxcG14Sk1T?=
 =?utf-8?B?N01KOGNJWFlJNzF2ZGpzSzlKM2RGQnVIMWJ3bUV1eGdNT2ZqSExqWlhrZEtZ?=
 =?utf-8?B?VGVCUG5yVDBqMUhHTDBUUm5VWGZRNEk2ZG50clNsbXFla3liZDN5OUFZT0ow?=
 =?utf-8?B?OURrMGMyNDQ1bVBiZFQremlmd0xnQVdDZ3lsZmF6UUJPOTBpTjNZdzV4cUxB?=
 =?utf-8?B?VVlUZkhYRDNEMEpQNWJDS0pGRVBWSVl5MHN3eFpRNFZzVWkxZFFCOXpxdkdz?=
 =?utf-8?B?bndTU1l2ZHFMNEZLNkpzSW96eFFFcEMwb055WmhHV3d1WCtlMW0vUEY4NThE?=
 =?utf-8?B?QXpicnV0RU5Pakhhcm93MTdpNjQ4QlQ2ckI2MkpBOXpuWHpnKzNQR09yTVA1?=
 =?utf-8?B?cG9PS2FsZkVMZUZhZXRubXFrZk44dXVYL2Q0YXRkWWVkUGhndGR2ZlJUTmZ4?=
 =?utf-8?B?cDQ0UTdSTHZ2Z1RxK1FpOHd1SVJDSkFCWnFDb1J0cGV4cjVDTTRSWFNqY1lO?=
 =?utf-8?B?RFZnZ1FQeHNlVVJxRmhVMkErVFRpK2ZMQUxVY2dWbmpJT2FuSys0aEJBYUtF?=
 =?utf-8?B?Q0d4ZEdPZk01YVR4RXZvNmxkeUlHSG9MSXFTUytJeUY4dUZrejJCckkxZlR5?=
 =?utf-8?B?OFkyeTBNUWhHOTlJQWl1Mm1pMmxvbCtRek5BUS90UVFETjZDVVhHOGkxSS95?=
 =?utf-8?B?U2dvQmo3dHBpeDlXSWo3UzJjRVgwdittMUxZU1o0TTFYOHpldmJMRFpXWUh6?=
 =?utf-8?B?TnJ3Y3BqNzlEZXpJM1RNRFBGbzBsYUdMbkMwUXhqR21ZbGFCd2RodzBJRzRp?=
 =?utf-8?B?d1ZlQStSdlMvVlVrbTFpOFhWN0M5ZUtXdXNwdjVZUm5LS3FkL05PTXRKZU1E?=
 =?utf-8?B?am1UWnNxN2Y5a0pYUnMwRjV1REJ4Z1Y1QlR4L0Q5K0Ewc0M1SVdpbFlReVNq?=
 =?utf-8?B?YytSSDJKMTdXNitqZkRlTVNueVd0ZFVRWjNFeWFuWkY3eGJObkxlWEQ5NzBU?=
 =?utf-8?B?b0tVcjBJUUZkam0rKzl5MmpSSlVEU1Q1Mmc0SnJGR0h1YjVuODdZWDYvdVJu?=
 =?utf-8?B?Tkt1czFCTngwQXVaeURPRjRRdXh5VThyNTFvV0hxbUhzVmFuVVVBRkxRNmFD?=
 =?utf-8?B?WkxMQVZKTmNtc1BHZWx6SW96L2s2YXV4VGJ4RXNzSmlYeWhiTmZha044b25j?=
 =?utf-8?B?djI5eTRtSGYxa2pFeHRES1VUaS9hTjNlOTZFMHFhRHhIaDFXSzdTNjUxc2hT?=
 =?utf-8?B?SUcxMmNlZG5Vc3Y4UGVJblhoa21WbkVGS01Udlh5eld4TkJzSWFEbDZuZjRO?=
 =?utf-8?B?WmFwQ0FSNGIvaEsrNEtZY2RySWo1RlA5NjEyOEtjNDIxdjkwOS9Jek9HalNX?=
 =?utf-8?B?a3U1d1VIeEs0b2VJajVaRWlkMGx1NUVYemh3NlVEYjRVb3U0V3RLK0g1cUt0?=
 =?utf-8?B?S21MaDBLNzJTd2VTdE1HQXYvb3NEN0tKaUdWM2NNUlk0SXU2WTNQZU9YVmla?=
 =?utf-8?B?bUsrVDFLZkNZMlNZN3NFdlJYQVo4SzRiSWdvVWhFOG5JR0h0YVQ0Y1ExdHJm?=
 =?utf-8?B?aS9TM0RsL2ExMmt4ZndDdmhDYkpoN0Z5cWlKeVVudW9UNkZUQVFIaU9reVZ6?=
 =?utf-8?B?aFZ0UU8wZ3VTY3prdnBFTFU3YVZ5cW9sNW1ERjBRTnVjRGFFTnA2enhEalVy?=
 =?utf-8?B?N1NucmxCSTFoMXF6MEJUMHhqWWtHS1I5cFdaOE9kN3V6aFZaOGNVMlVsTDBi?=
 =?utf-8?B?UDBuRVRxQXo2VzRuTkpsZGltV2U2UWpHdWlLYmUwcU5JU3F3OEIvMTU5clM2?=
 =?utf-8?B?MnROK3JhVW1XT3FWSGJGUUc5bDBtUFpZaDF1d3djT1I5alpJMjVzb1dJcWVB?=
 =?utf-8?B?RXZlRmd2NDkrS0N5UExLN2RaR0VVb1pLZW95Q2hnZGs2bGd5bEdLUjZOanI0?=
 =?utf-8?B?dWxLalhTblc3bjJ0cWV5Uy9oQ0RDVjQ3R2ZvMTBCWnU0ZUtwOUtyNWU0NUtZ?=
 =?utf-8?B?UkM3SU95U0hRak1MTGhhSkVvVThFSWZIRXNpazViQ25BSkxrc1gyV2doc1V3?=
 =?utf-8?Q?KQXhblGwmA7qex2otrSqjBDSB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9df896f-7ffa-4158-996c-08dd0a6f7af0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 21:00:07.9936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PwK43Zhj4LjSpiPrSm2J2/jBzDQiVV+lvhIPWqpwjGwy1wy1waufKSgJyFGkDf/Cdu2jWEvn16HIlTzU6xzVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136



On 11/21/2024 11:42 AM, Sean Christopherson wrote:
> On Thu, Nov 21, 2024, Tom Lendacky wrote:
>> On 11/21/24 10:56, Sean Christopherson wrote:
>>> On Thu, Nov 21, 2024, Ashish Kalra wrote:
>>> Actually, IMO, the behavior of _sev_platform_init_locked() and pretty much all of
>>> the APIs that invoke it are flawed, and make all of this way more confusing and
>>> convoluted than it needs to be.
>>>
>>> IIUC, SNP initialization is forced during probe purely because SNP can't be
>>> initialized if VMs are running.  But the only in-tree user of SEV-XXX functionality
>>> is KVM, and KVM depends on whatever this driver is called.  So forcing SNP
>>> initialization because a hypervisor could be running legacy VMs make no sense.
>>> Just require KVM to initialize SEV functionality if KVM wants to use SEV+.
>>
>> When we say legacy VMs, that also means non-SEV VMs. So you can't have any
>> VM running within a VMRUN instruction.
> 
> Yeah, I know.  But if KVM initializes the PSP SEV stuff when KVM is loaded, then
> KVM can't possibly be running VMs of any kind.
> 
>> Or...
>>
>>>
>>> 	/*
>>> 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>>> 	 * so perform SEV-SNP initialization at probe time.
>>> 	 */
>>> 	rc = __sev_snp_init_locked(&args->error); 
>>>
>>> Rather than automatically init SEV+ functionality, can we instead do something
>>> like the (half-baked pseudo-patch) below?  I.e. delete all paths that implicitly
>>> init the PSP, and force KVM to explicitly initialize the PSP if KVM wants to use
>>> SEV+.  Then we can put the CipherText and SNP ASID params in KVM.
>>
>> ... do you mean at module load time (based on the module parameters)? Or
>> when the first SEV VM is run? I would think the latter, as the parameters
>> are all true by default. If the latter, that would present a problem of
>> having to ensure no VMs are active while performing the SNP_INIT.
> 
> kvm-amd.ko load time.

Ok, so kvm module load will init SEV+ if indicated by it's module parameters.

But, there are additional concerns here. 

SNP will still have to be initialized first, because SNP_INIT will fail if SEV INIT has been done.

Additionally, to support SEV firmware hotloading (DLFW_EX), SEV can't be initialized. 

So probably, we will have to retain some PSP style SEV+ initialization here, SNP_INIT is always
done first and then SEV INIT is skipped if explicitly specified by a module param. This allows
SEV firmware hotloading to be supported.

But, then with SEV firmware hotload support how do we do SEV INIT without unloading and reloading KVM module ?

This can reuse the current support (in KVM) to do SEV INIT implicitly when the first SEV VM is run:
sev_guest_init() -> sev_platform_init() 

> 
>>> That would also allow (a) registering the SNP panic notifier if and only if SNP
>>> is actually initailized and (b) shutting down SEV+ in the PSP when KVM is unloaded.
>>> Arguably, the PSP should be shutdown when KVM is unloaded, irrespective of the
>>> CipherText and SNP ASID knobs.  But with those knobs, it becomes even more desirable,
>>> because it would allow userspace to reload *KVM* in order to change the CipherText
>>> and SNP ASID module params.  I.e. doesn't require unloading the entire CCP driver.
>>>
>>> If dropping the implicit initialization in some of the ioctls would break existing
>>> userspace, then maybe we could add a module param (or Kconfig?) to preserve that
>>> behavior?  I'm not familiar with what actually uses /dev/sev.
>>>

Yes, i do think this can be an issue as those ioctl's may be in use by userspace tools like
sevtool, etc., and require SEV implicit initialization and we will have to preserve this 
behavior if indicated by a PSP module param.

Thanks,
Ashish

>>> Side topic #1, sev_pci_init() is buggy.  It should destroy SEV if getting the
>>> API version fails after a firmware update.
>>
>> True, we'll look at doing a fix for that.
>>
>>>
>>> Side topic #2, the version check is broken, as it returns "success" when
>>> initialization quite obviously failed.
>>
>> That is ok because you can still initialize SEV / SEV-ES support.
> 
> Right, but as I've complained elsewhere, KVM shouldn't think SNP is supported
> when in reality firmware is effectively too old.


