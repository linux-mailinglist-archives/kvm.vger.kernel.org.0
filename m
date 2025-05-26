Return-Path: <kvm+bounces-47708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4770AAC3E69
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 13:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ECF53AE9C9
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930B81FBE80;
	Mon, 26 May 2025 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vOa2k6Ow"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3891F8937
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748258215; cv=fail; b=VWrbghX7J2AwFBKVYFf6ts1ocg3h3idCrAisVGZNdUccTb41d9EIyPBDvK0eMesLRblry66ufNSITPI3/XxpyZvN8Hs5E3B8nCas6sJ1BSGOVJKAjRrJzS/+AnloITz6RQ+LvBcLoyhJBUpUHt9t4B53eLCTDfOarrTevNJD8Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748258215; c=relaxed/simple;
	bh=szu1VZx51rFMVdZc4PfLM5KhbTDw8iMDeN/E/FjAUWM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fgB/Ac2JwmHbiB4ph9iaSJfPm88ZI6MUpMahS5V0lh2GlFFgPR6CMR2wTzCvB0Dq+9P97QrAEI9w0ShgpLsnezDLJ63IwZlM0ABvRtnWav+/OeMUh5NpvvqyPCvqros6wogDUe8cyoU9rNXplzxxiFKInpUNL9Vqu4PbvB69h1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vOa2k6Ow; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCngjpwrsZgNPkIg9GRLxX06cDEuvTVvvHBBOjsBEWVZAmyUX/dYiMMMmLZVlRM/wNZpkEWZ9jzEuGW7aRCnid2r87jL4683YUG8pU+cq+FAOMpzdvv9CS0vQVmriLnShyGkTLddTMKWxtGKb6DCZMK1UeczIMKdrxXH2Bs1v0UIcJdwLZH9qDxrdVIFubLqNoFKND+jZ0Q3knOFoGPzxh/QJ/yjNCQKv6ohDNGatNFhxsJ1f+SMG3cmtjxl4T7u/0V4eA/oGEKEM/EADFiogq1b3L90J0RBzGjIU6zzT7LxAtVZNdPtNh8Kc+0rXrDlOAIyJL/lvqDGvYqlqe8d8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59d6PXNq2RXOi/SR6/L7wpojWj0jPlYQbOrm7mNEYiQ=;
 b=yFnmnsfSK1tJWLRnsOfVzzV3nEC6qu0Tudipkb7ogKRZJrG96/pisQ+nUko7zUZuyyZkaRvVEb4A/xTZQp1OJuphdv2LdVJaUq40mtEbouool8r/j6KOMWOwKnqonsh0PBv/nkDxgUusTp/kT1mLI4kiiniJGGY06plmtrnikmI/dPyshcWStcn6gYrUWxZcL3pcnZGzJJnVaSkJC5ESTJYgfGyXzVuXKkulxxesrpeoQQLdNkaJZ81Uuw1cU9dIUC8uQna4VxsGAqj44AmdQ1Vv52rncTpBt2KMqrJrwaEGhlEqrEMtIYC/N7JIluv1wbVhfjwjTwaD/Bd39zPsDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59d6PXNq2RXOi/SR6/L7wpojWj0jPlYQbOrm7mNEYiQ=;
 b=vOa2k6OwAHXm+ozpfhdNsdMqKSXh3ygbfxhPfZ2MmcUiiHB1qY0UMaEUFGboIGmblFmBk5PUGBsL7ibf9G8EvsgRcTrxL+TBRoE3M1P84EL6/edyIjmBcNevSjuRnlKe2KGC04IeY/bHsewGRelNZ/v0vEIGeReP7fhIwOfbAEA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CY1PR12MB9602.namprd12.prod.outlook.com (2603:10b6:930:107::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Mon, 26 May
 2025 11:16:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Mon, 26 May 2025
 11:16:50 +0000
Message-ID: <f28a7a55-be6e-409f-bc06-b9a9b4b3a878@amd.com>
Date: Mon, 26 May 2025 21:16:42 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 04/10] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-5-chenyi.qiang@intel.com>
 <e2e5c4ef-6647-49b2-a044-0634abd6a74e@redhat.com>
 <0bc65b4f-f28c-4198-8693-1810c9d11c9b@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <0bc65b4f-f28c-4198-8693-1810c9d11c9b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0144.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:205::14) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CY1PR12MB9602:EE_
X-MS-Office365-Filtering-Correlation-Id: 7253c2f6-93f2-4837-5daf-08dd9c46cf78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SERkTThyeFdOQTBjVG5uVFQ0VUJGRytySEY1VUtkZDBEekpUVlcrSzV6ajNW?=
 =?utf-8?B?YVFPcVg3OEEya1Qzc1BuUUZuQklLMndtWCt1LzZPVzdSSzRBQ2ZsV2JtVlY5?=
 =?utf-8?B?RGt1aVBBVlJIZlh0OWNJSklpQWdrMHIrU2ZtNFJaaksvb0ZTNEtmd3g2T1N6?=
 =?utf-8?B?VDhpQ3h3NUxCNzFwUHgvVDkvT2hJYnlyZXFMN1Z4QTZnYTM5bThycXN1T2JD?=
 =?utf-8?B?amp1ZjIwSGNjYmRVVDVRVGM2UjNWRU0yOUM0MVdybHBwRDhZRUVobEFKdzdq?=
 =?utf-8?B?VnpDa3lVTVFFZFdrWVRreFcvQ1FNWTk5Z3hOeUhnRzlxamJnRTVvaFNLRzFu?=
 =?utf-8?B?bEdxUm5lWS9xNHZabk8xZWxDNEZOajlPTURGQlF5dlQ1aWVuaU11NGhFVUIw?=
 =?utf-8?B?U2ZVOUFYSnJYQThHSWxsZnF3aWZmaXdTSTZaMGxVM3BlSHZjYXM5czNwN2FH?=
 =?utf-8?B?SXlPSzYvNkw2aTNJYTE4b09MeTZ4MUNuOGViaW9OVW00SHVyQkNLRWgvMjZq?=
 =?utf-8?B?WlVmK2tkVXM1VDVxd09vUkc3QnhMYVFyR0xsRmdnMUVyTjRxVTdQenRZZFk5?=
 =?utf-8?B?RXEyRmQxejNRUTRKN0Nnc1FpTzZsWEIweXE5amIwYlo1QTN1U1p3NDNSWVc5?=
 =?utf-8?B?ME1aRGMzR05ZaWcxYWpiakk4TlQ2MXZvVjNmU3pWeU9jbld6Uzd1ZXVxWUh0?=
 =?utf-8?B?bVVoNUlsQVlQUms5MmpmWnFwTnR4NjYrZmhKWUIzMGJLamZGNUUwQU1nYktZ?=
 =?utf-8?B?ZUQvNFNuT0d5bnBMdDByZkEyb1g3ZWpaT0s5aGwvbFRyWVcwTDBIbjFEamNB?=
 =?utf-8?B?a0luNjZ1Y3lQaXpRcERYQkZkbzI3dU5uU3JZVUNEdnJJV3pHbDJ2ckNoNWg2?=
 =?utf-8?B?Z25WT05wTlpQUGdKN2g0VEpmd2JzWURpMUd5SGFhLzVOcFJXbk50bnF6ZEJP?=
 =?utf-8?B?S3BZd1pTSnFWRnhCSXU5V2E0VVo5c0ZZcHlEaHdyK3FYNTJySjZzWmduSmxq?=
 =?utf-8?B?bU1TbXRoMEpYOWpPbUdLYjhRTVUwV2ZUWUt0a1h0cXdJWEN4S1o3UWMxcE5Z?=
 =?utf-8?B?NDRpZ3pFLzNyVDBZbkZpN2lLdVBJMUJsVjlqYXFGVnhjaVdDc0xRVVVWcUQy?=
 =?utf-8?B?TzR5NmsxTFF6SXJXcGtNbEY3cXMrcC83UEhiRk85S1FtTGYva1N3eENHYjg2?=
 =?utf-8?B?QnpYQ1Q4QWNBRVVtMXhVTlB6bnVGa3JaRFM2Z0dzVjFUYXBYQ0NDbDNhVE1Y?=
 =?utf-8?B?VFpFOERYYjMydVRjTk5QWjF6SDBINTU5eUtHeERZbTlOWUJQNnM1eGpBejEr?=
 =?utf-8?B?WEdGUU5UVmhhdHdRMy9RbnozZndReUlvdktNTkxHak1xMERGZWxUNnpUamI1?=
 =?utf-8?B?bDhiTDJZRVUxb3U0UjBBbnh3QUMyb2VRUnVRMVp2VDkvNUF4c1NtcXZkMllG?=
 =?utf-8?B?MDJlN1NTMjRSOE5xdXVpVVJ1RkRFdUcwVFE2bnMrL0dZTEJKbW4xakppdGdH?=
 =?utf-8?B?eU9ZZzQ3akNDYUZuaUF6RGZycFVVRkRCRUZ5WitXczY0SzJxamdmSHhOMVho?=
 =?utf-8?B?L0oxQyt3V29VaGl4ZGUwaWdPcUVHRUpIdUVxQ0hoaVdrbndLSTdPV05tWVUx?=
 =?utf-8?B?OEV3WThMd3Rlbmowd2VYWHowdTZJM1FvRmFqV0tjWUNTaTZSWGlzeDFnamdH?=
 =?utf-8?B?VTRSbENLQURpUzB3UUJpVkZ6RGF0bjMyLzF1dkZLMjBaRFFMcThxbWhjVzRK?=
 =?utf-8?B?NkpvT2R6bVZmZWNKb3VzL2NrdmluTGhFQkFuWDRKQjM0UTN1TUR5b3NkUmky?=
 =?utf-8?B?NEZZWG43Y2g2MmY2QVEyRFM2T0FRejV0SWJXT3p1L2NkMmJRSXJCNS9QcGYv?=
 =?utf-8?B?RVRWNDlIZ3YvYnUyN0hIc1FxREFheUgvc2Q5QWpqR1hQNE1YTXpYU2h2L2Nn?=
 =?utf-8?Q?dsOP9pXVlQo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yy9lNCtxMitzWjkzUklQdDY0bFkwZmJhSUVlWGY3dVF3VnBuRGtVWklnNHdv?=
 =?utf-8?B?TEMxRmdUai9yWUtPVitZNmRld0trZUpQNUpyQ25ka3lBbWMxcnFuSTZiWWVC?=
 =?utf-8?B?NjA2V3RQblNHK213WFkrSysyZVRFRVpXTnl2NllMRjl6cTc5YTNDZ010ZUEr?=
 =?utf-8?B?aktQbm1HbVpqRFM4Vk5VNStjSVNmdnI2bXE1c3l6TktucGZ2L3pzN0xYeDJ0?=
 =?utf-8?B?ZVpESmNwZGFQclM5MEkxTG9uSDJteTVtK0kwOUkzVkQwZW1NamhsVjRUbytU?=
 =?utf-8?B?K29iblUrVmxuRHFnaXpUai9HZ2dueGZOV0g4ZUx5Z1dxS1dYb1pIRGF0eXhv?=
 =?utf-8?B?RWFOOTJqUUtPZ1ByUysyTTV6TFB2cm9LWDJOSWZHWXl2QkRtNGJTQ291RkZI?=
 =?utf-8?B?dGxqWUJHSkkyOFl5VGRUM0RtQVA5ZHBJSjdTM0dYbEJnMVA1UEg1d1dMbUla?=
 =?utf-8?B?Y2dJczA1YXJDbElaZXhlY2V3d2RQYkkvUnNySkxtQWpvdGxwZlczQktmRFUy?=
 =?utf-8?B?VFhYS3lLQTdveVBwRURvRm9rU1BuVEFMenl6RjRUbDhVWE8yYWh1OE9wR2gv?=
 =?utf-8?B?aUgrR3FKMVhFd1F1aEoyb28xZTd3VzZKNGJoaGJDWUw3UHk1dE9DbXgvQmZY?=
 =?utf-8?B?KzRlcVpNNU9KUkR2alFqY3pMVUpSYnFaQjVOd2E1MEhVTDRUN0ppaTZjV2lB?=
 =?utf-8?B?NnRjTkFhSDBXTG05SGRBcXZUUHJlbXpHYlBRRXFTdVZOTjNjWUROUVl0NjJi?=
 =?utf-8?B?ajRiNkZ3WllNTmRUcW00MUZwSXJ5Zzhid245OElnTjJPWlJGWEQxRzB4bFR6?=
 =?utf-8?B?M2pWaCtCS1ZEd0FuSTMrUjRVVlpyclFSK3JsUXhyK290aURlelAwRk14MWVI?=
 =?utf-8?B?VmZldXNxUkZNMmdheHBYS3J0VHFnKzAzMEdyTXppR2R5d2ZGaFVHc3RhMDlK?=
 =?utf-8?B?Y2hxRzRzb1NTYzhXOG1YTGtUenNwdXk1MXFIZHpJaEMzZVY5bTFneHE5ZVI3?=
 =?utf-8?B?dnIyV25LVnZ6Tys5SGl4cHVVRjViV0xpOUU1WGY0alBpT2NvUndSOE9TWlhK?=
 =?utf-8?B?aDl0K09TNTlxYjJCOWt2Y2o3UkNlR1l4YUFoVEg0VWVQV2Joa0tBQ1YySWJt?=
 =?utf-8?B?eFlvR1l4RmRKUWlzeFJ1NzRlR3U4ZFBqWkZoUUpmY3hMWVZhOGdhZTRIOXRX?=
 =?utf-8?B?aHJ4Y2NSa2ZndzZwd2NDa1Nqb2lVSTR6dUY4NjN3US9ORmRPMWZveXNRL3Iw?=
 =?utf-8?B?MGdCUW8vTVFwTjYzQXdrWjlrTlNmMkJzRVd5Y1h0QWg2U0ZkZEdnbXdCOFpo?=
 =?utf-8?B?UTRGczBqVnpXay8vYVB0cXNLa3VaZ1JGYmhQRCtuYmg1NFFKWVpaTjFOSnRn?=
 =?utf-8?B?MElDRm5QYmdwcFIxdFdtS3ZFY3k4b1BKT3BkSVI4UlF5aDZvNUIwZ0Jhbngy?=
 =?utf-8?B?cW9QZGs5S2xhU0plUldEWGVMYXEyYlA4ZFh6cGtkWjhtaEM3a1NXQXkweWE0?=
 =?utf-8?B?aUdLbHBrZFNZUE0yOEhFdk1LU2pRcldJenYwbWRaamNnQVFHa3R1LzZyT2ZF?=
 =?utf-8?B?N0o4dFdrL1c2OUJWditHL2hFSGVkS2RSNXI0M3FpcVZYU1hnRDZaNDlydFlL?=
 =?utf-8?B?dlNWRVJ5cEZRUHZYSHMxQWo4RzV1WHJGYnFHamR5cDlLeVNJTkQ5N1BnZ3hM?=
 =?utf-8?B?RmpkRFBBWkF2S2NUVEV5MDhlTWZadTlvZXEyM0NmL0NibHZ3cXZLZHhzT2tl?=
 =?utf-8?B?dWJIRXd5eU5neWR4YU1zbEdZZGtUM1hycDZBSmVMTFhOeG9EY01vd3JDOVRS?=
 =?utf-8?B?Nk9Ta2lna3lsNmMyUUFlejN4cXYySDNML2tLdVRLdVZHSmp4Q3QyRVBVL2NY?=
 =?utf-8?B?c0I4TzRtNGgzUFdERG9lTlE2Yi9kTHVMVzRrMnNPSlQwQWt4K3hoeDZvZlBh?=
 =?utf-8?B?V3ozQ2dEY2RWVGlFWjNaY3pLVDNxU1gwa01WSFA2aSt1K2lNUmZTdkpmL0Nh?=
 =?utf-8?B?SEhRN05GS1NtR0lXczNQelVzbFlBU00yQVlNSE9JSkxIckJsM0dncWtyOE1p?=
 =?utf-8?B?NlBSL1o5M2tHOWRyd0hPRm9HZ2Iwb3dYYSthV2p5bjM3K2FyeFpXZlFINUQr?=
 =?utf-8?Q?aOEWGVvdEg0QLXlB7jYqv9+47?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7253c2f6-93f2-4837-5daf-08dd9c46cf78
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 11:16:50.1333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Qaj6jVv3tTzAB4rYNHOgioBsQOsozKZ21DrUw0/HUayS4lKjnMRGJkPmcCq5no+3njlFXkHUp+Kfx97bWpw+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9602



On 26/5/25 19:28, Chenyi Qiang wrote:
> 
> 
> On 5/26/2025 5:01 PM, David Hildenbrand wrote:
>> On 20.05.25 12:28, Chenyi Qiang wrote:
>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>> discard") highlighted that subsystems like VFIO may disable RAM block
>>> discard. However, guest_memfd relies on discard operations for page
>>> conversion between private and shared memory, potentially leading to
>>> stale IOMMU mapping issue when assigning hardware devices to
>>> confidential VMs via shared memory. To address this and allow shared
>>> device assignement, it is crucial to ensure VFIO system refresh its
>>> IOMMU mappings.
>>>
>>> RamDiscardManager is an existing interface (used by virtio-mem) to
>>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>>> conversion is similar to hot-removing a page in one mode and adding it
>>> back in the other. Therefore, similar actions are required for page
>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>> facilitate this process.
>>>
>>> Since guest_memfd is not an object, it cannot directly implement the
>>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>>> have a memory backend while others do not. Notably, virtual BIOS
>>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>>> backend.
>>>
>>> To manage RAMBlocks with guest_memfd, define a new object named
>>> RamBlockAttribute to implement the RamDiscardManager interface. This
>>> object can store the guest_memfd information such as bitmap for shared
>>> memory, and handles page conversion notification. In the context of
>>> RamDiscardManager, shared state is analogous to populated and private
>>> state is treated as discard. The memory state is tracked at the host
>>> page size granularity, as minimum memory conversion size can be one page
>>> per request. Additionally, VFIO expects the DMA mapping for a specific
>>> iova to be mapped and unmapped with the same granularity. Confidential
>>> VMs may perform partial conversions, such as conversions on small
>>> regions within larger regions. To prevent such invalid cases and until
>>> cut_mapping operation support is available, all operations are performed
>>> with 4K granularity.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Changes in v5:
>>>       - Revert to use RamDiscardManager interface instead of introducing
>>>         new hierarchy of class to manage private/shared state, and keep
>>>         using the new name of RamBlockAttribute compared with the
>>>         MemoryAttributeManager in v3.
>>>       - Use *simple* version of object_define and object_declare since the
>>>         state_change() function is changed as an exported function instead
>>>         of a virtual function in later patch.
>>>       - Move the introduction of RamBlockAttribute field to this patch and
>>>         rename it to ram_shared. (Alexey)
>>>       - call the exit() when register/unregister failed. (Zhao)
>>>       - Add the ram-block-attribute.c to Memory API related part in
>>>         MAINTAINERS.
>>>
>>> Changes in v4:
>>>       - Change the name from memory-attribute-manager to
>>>         ram-block-attribute.
>>>       - Implement the newly-introduced PrivateSharedManager instead of
>>>         RamDiscardManager and change related commit message.
>>>       - Define the new object in ramblock.h instead of adding a new file.
>>>
>>> Changes in v3:
>>>       - Some rename (bitmap_size->shared_bitmap_size,
>>>         first_one/zero_bit->first_bit, etc.)
>>>       - Change shared_bitmap_size from uint32_t to unsigned
>>>       - Return mgr->mr->ram_block->page_size in get_block_size()
>>>       - Move set_ram_discard_manager() up to avoid a g_free() in failure
>>>         case.
>>>       - Add const for the memory_attribute_manager_get_block_size()
>>>       - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>>>         callback.
>>>
>>> Changes in v2:
>>>       - Rename the object name to MemoryAttributeManager
>>>       - Rename the bitmap to shared_bitmap to make it more clear.
>>>       - Remove block_size field and get it from a helper. In future, we
>>>         can get the page_size from RAMBlock if necessary.
>>>       - Remove the unncessary "struct" before GuestMemfdReplayData
>>>       - Remove the unncessary g_free() for the bitmap
>>>       - Add some error report when the callback failure for
>>>         populated/discarded section.
>>>       - Move the realize()/unrealize() definition to this patch.
>>> ---
>>>    MAINTAINERS                  |   1 +
>>>    include/system/ramblock.h    |  20 +++
>>>    system/meson.build           |   1 +
>>>    system/ram-block-attribute.c | 311 +++++++++++++++++++++++++++++++++++
>>>    4 files changed, 333 insertions(+)
>>>    create mode 100644 system/ram-block-attribute.c
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 6dacd6d004..3b4947dc74 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>>    F: system/memory_mapping.c
>>>    F: system/physmem.c
>>>    F: system/memory-internal.h
>>> +F: system/ram-block-attribute.c
>>>    F: scripts/coccinelle/memory-region-housekeeping.cocci
>>>      Memory devices
>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>> index d8a116ba99..09255e8495 100644
>>> --- a/include/system/ramblock.h
>>> +++ b/include/system/ramblock.h
>>> @@ -22,6 +22,10 @@
>>>    #include "exec/cpu-common.h"
>>>    #include "qemu/rcu.h"
>>>    #include "exec/ramlist.h"
>>> +#include "system/hostmem.h"
>>> +
>>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttribute, RAM_BLOCK_ATTRIBUTE)
>>>      struct RAMBlock {
>>>        struct rcu_head rcu;
>>> @@ -42,6 +46,8 @@ struct RAMBlock {
>>>        int fd;
>>>        uint64_t fd_offset;
>>>        int guest_memfd;
>>> +    /* 1-setting of the bitmap in ram_shared represents ram is shared */
>>
>> That comment looks misplaced, and the variable misnamed.
>>
>> The commet should go into RamBlockAttribute and the variable should
>> likely be named "attributes".
>>
>> Also, "ram_shared" is not used at all in this patch, it should be moved
>> into the corresponding patch.
> 
> I thought we only manage the private and shared attribute, so name it as
> ram_shared. And in the future if managing other attributes, then rename
> it to attributes. It seems I overcomplicated things.


We manage populated vs discarded. Right now populated==shared but the very next thing I will try doing is flipping this to populated==private. Thanks,

> 
>>
>>> +    RamBlockAttribute *ram_shared;
>>>        size_t page_size;
>>>        /* dirty bitmap used during migration */
>>>        unsigned long *bmap;
>>> @@ -91,4 +97,18 @@ struct RAMBlock {
>>>        ram_addr_t postcopy_length;
>>>    };
>>>    +struct RamBlockAttribute {
>>
>> Should this actually be "RamBlockAttributes" ?
> 
> Yes. To match with variable name "attributes", it can be renamed as
> RamBlockAttributes.
> 
>>
>>> +    Object parent;
>>> +
>>> +    MemoryRegion *mr;
>>
>>
>> Should we link to the parent RAMBlock instead, and lookup the MR from
>> there?
> 
> Good suggestion! It can also help to reduce the long arrow operation in
> ram_block_attribute_get_block_size().
> 
>>
>>
> 

-- 
Alexey


