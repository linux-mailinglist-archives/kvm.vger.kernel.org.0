Return-Path: <kvm+bounces-66923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B14A8CEE652
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 12:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F76A301A19D
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 11:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A9230CDBF;
	Fri,  2 Jan 2026 11:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0QFW+fOO"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098E32F0689;
	Fri,  2 Jan 2026 11:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354075; cv=fail; b=fRO0TkaSM1z3MKoff4B0cNDZFrFA2rVVwbqeTEWXGjbYz/8N3dzVd7yCFGrcizrl9xvNg4Q+QB7ORKUSTL/Z8tJhj/RDcWd6TbArHr3FelIo/11eAMuqiP79qUjpLYE5NR+lYoUdcZcdpKQn/N8PrMhFmFE0ItW8xXuJvx6s7kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354075; c=relaxed/simple;
	bh=fLSNqFM8BKwwWBbj+Bqy1CLrlSy1pi0yfjCjPN7ISOM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QcrrxcpEvB/XssTWRToDTcaf/rmjikaIY6LhRmuvkDL2vQJHjf+SJiJj6nvI2UWf6dmUiFBFkUqTVYuFCH6p1HohxgqowZiP0MOeyHmRVr4MVuXfOWuyEJgg+AIPTsvlo8Rj/L2qXaBn01jjCBg8X8Hti8EOzqFna09P8dGk6OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0QFW+fOO; arc=fail smtp.client-ip=52.101.53.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAafuzgvskkF9ExmZPT3AlJt6aBFgWKQl3s8weX21+3aDYJpZQRO7b0V7L6hjgKBsUlYcyd5xAH0+JziRDWppEgfjjTmJWtszq969n7hvuUmu/bc9dWJR0pechPcCuLuVoroM+BvId9zaSSSM6mTc8pHLhvDFWaYqb7OuiGDy+3ymZh7jgov2aN7e/FR/sHvfsfpzod0OMw9WuWiSm7EFruCb+kvr20JOx4uR1Npl5Q8u2mrcS1NdQME8sdpWCLCwuCowTlJ6UR4KhjlrOQP5VbGBDX4+ygq0ILXAveTeKuoB0L/IbB2wkVhRdH8b6G/IllLy/u0dQuMvC/+z/kKBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rV3lI5nTSDE6mDoAR1jQ49AHMC51iKU+48gij5BgOh4=;
 b=Ryoy4v0SVDKGoeCs37TyxcYtoKVog1quUePRAA/V2mBQhvu27I1HTQiXBv5TdKWVHWZGLaB6up6YrCitkdeZRGLSh+KZXKhnAQqdAZU4DckjPwZ0c3NOzulBCfE1ZHK+FQcYSalcZ/HOd30r2YIU9f14YDGAcaxXiXpap/pa/dD4ORv+vn2DWlMwxeVo0f+azaI6fu1YtZeLJooMcBtzc1e4HQaR7/2kZerXRh6GrHiLlhZuIQNUc+e3fnnZdQ5RFKVr7JqlCmkxosYI6kjkIatmgLnkbTvVchKReObKZxi9K/4fa1VuNgcCJEUQHMeT0S23V28wFVmUDGtb3ub4eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV3lI5nTSDE6mDoAR1jQ49AHMC51iKU+48gij5BgOh4=;
 b=0QFW+fOORNf6qO3sIVPqQxC0McbT6mZ7lpYLeY31tpi+YSi/KpXgmTk4onhvcrrDhlDibm6cwBA/gEAVavLDQ71TT8gcC1LNhMkMjvDsQPQ4Y8GwQM33uRElL9HiazPtpw+SyKD9erK2S/5gLA1CdVZ2T1uVNVvOkoXEMPZcElQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by DS0PR12MB8815.namprd12.prod.outlook.com (2603:10b6:8:14f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 11:41:11 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 11:41:11 +0000
Message-ID: <da6851da-979d-4c7a-9e19-08885f3ae042@amd.com>
Date: Fri, 2 Jan 2026 12:41:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] KVM: SVM: Open code handling of unexpected exits
 in svm_invoke_exit_handler()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20251230211347.4099600-1-seanjc@google.com>
 <20251230211347.4099600-3-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251230211347.4099600-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0040.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::7) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb26cec-1323-44ce-dfc7-08de49f3d387
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QzBkVi9BbU9sLzBxVzhqdFpSSEVvNWpXQ2NwS3IwNXhxcW84YytxeGlNT2kx?=
 =?utf-8?B?M1NyTEd0V3RGeE9HZ3Bsd1NITVRMUFZRdFlwdVVuaStkMFJCT1dOSlJzakxU?=
 =?utf-8?B?bmphcVNtZUVvNmdRNEdIWmJCdUtnVi9Eb0Rwc2FIZ3ZNVXdKb2p5S1NtNHp0?=
 =?utf-8?B?VDVMVThZOTlBVXVQV2tKVjdiMHBGdlBNd0hrdnp5c3ErZEpsOCtyWHd6Y0Vq?=
 =?utf-8?B?aXZoNlB2TmlOakdDZlpZSXYydk1NenhYUUI4U2c5L21LQjV6VEV4YWhjZnV4?=
 =?utf-8?B?SElwWTBYaGZxQUdpZlJFTjZONGdQbDNkeU1UVGd5eTd5WXltNWgzU29OR1hT?=
 =?utf-8?B?U0FKOW5Td2FpU3ZuemhIT0puYy81YkhnaW40T2VSZmlLVzhqRC9rT25PWVNO?=
 =?utf-8?B?N09QN2FyYWJwQllPL1JYdVZPc3o3aGNVVEpaN2l5aDhLMHhCN3ZSUnFnaHpC?=
 =?utf-8?B?Sng4T3FGNDRzOTVhaVArZXAyUVA0b3F2Qm1TbDV6M3htbmU3aWtnKzdKaHdo?=
 =?utf-8?B?MCtHNU5BbDR3VmE5TlFoWUdGQnBoYWo3NktZbHh1Nlo2TENmeDBoWXZBVjJD?=
 =?utf-8?B?OGJUZlJkbmFacUFTL2kzSkx2aW1HcHJuclR3Y09ZM3RSZGlyOHJlK0x3eFF0?=
 =?utf-8?B?SXV4d2o5cXM1cm05M2hDNkdCVElPNm44cHU0MHZQVzFNVm4vYk5NcFo4blBr?=
 =?utf-8?B?M3ROUVl6c3BCMkVKY3lkU0xlTDJlNkk2L2F3aytmMlRQMU1hSk1QVjd3VWtN?=
 =?utf-8?B?WGdaVFdmczhucTFPU2NNZVFlY0owdXZXY1kwUVhheGVCdlk0Z3RydUdCclZ4?=
 =?utf-8?B?ZGt4OUNYZXhNNTRnUEYwMElnejgxSDBCUUthN1dIMEtxNnV4S0wrNmlHSWJ5?=
 =?utf-8?B?MVNucTNCc0g3NFV0R1Vjbm5jR0NqZmo1dmhqc1dIRDVEbVZxcjNNWUovZVA3?=
 =?utf-8?B?NWVVd3ZYYU1oRWJnM0ZOU0JDY2ZjUnozR24vMzZYM0FzRkhNUG9BYWdQV3M2?=
 =?utf-8?B?WkFpVWlhU2Q3MVZCSnFUOXBhK2x1WDJsbzRqQUJyRkZPMzZDYlQydHJjakMv?=
 =?utf-8?B?Q3hjQTZnNmRkUUNDWitHVnAyQ1l0dXB0UnFFSGF5NFFxUkEyeEdvMG0yQm9M?=
 =?utf-8?B?RVM3b1NmWEh1d3llU1VxY01tcVhkVTBzV1Nma1pMWTEwRUVxcDFreFZwMWtu?=
 =?utf-8?B?MTBTeGE3ck16WTJuaUt0Tyt2RU9wc05yNytORzR2SjI4cnRGdjYwSUZZUita?=
 =?utf-8?B?K3MrR3VKYXFYM3RoWkJYSFdjeWVnNnJ2SWxUdmhGQWI1UDRNZ3ZuS0s0ZFlF?=
 =?utf-8?B?ZDdBbnZUTDlPdkRxS1hSVWVVYnZsY1FJcXVaK05lMUJVYXBjQzgvbVZuMjFu?=
 =?utf-8?B?V0ZGVm9ITityK3RLTlZyMlFmdnlvclVZZjUzN0xkb05oZVRlU0xzN1Rodnk2?=
 =?utf-8?B?ekN2THMwSnNKN01CN25pdWNuSW12dlhBcCtCODhJWEloMTc3c0FDeTZYTFJp?=
 =?utf-8?B?eSs5czBZdlFzcXlPK1NlaG93Y2hpRExzTk1Wdkd3OTZFazFWVC9Td251ZXox?=
 =?utf-8?B?Q1crejY5dU5OQkUzamVqMkQxdktTUGhCdWhxN0duMDNSZVZ3aDA4S1ZOY0VI?=
 =?utf-8?B?N003b2dqSzZCcTRFRElPSnFUK0tTaFpJMmxNbW1tQXkzZXZoWXhsek1TcEQz?=
 =?utf-8?B?L1JwMVcwUUR2OXhjRk5qVGk2SkxKbFFOcFM5OWRjWjB2UjFMUWxRekFxcnlY?=
 =?utf-8?B?NE5TV2tGNWF3TDdCRGxIZDBTQ1NZR2xRN0U2L2hDM2VXaVpESmd2YmtCcHEr?=
 =?utf-8?B?L214cVk3VmV4ditXaWZwT0xkTUZrZXVFREhBT3RJVXlkcWZ0QU43dkJGcFNr?=
 =?utf-8?B?WU9TNTFWTjVQZWZyOVlYU2hNUUFaQTkrNGsyQ2JPWk9Hb0hiYVNWWG84amRG?=
 =?utf-8?Q?YlqqJTu3zhFavb1x204K5GuyRqZvX5Lq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUFNWUFFYUpFQ3RTRXgvOCtuRnZlVXErN2dHMG5IQnhXbTUvTHE1bUl3MFA4?=
 =?utf-8?B?c05CS2VjTEZBcFhXWnFlSDFQNURhUWp4OFpKOXZEbGVab3ZwcXR3SVAxSVFy?=
 =?utf-8?B?T3loVk1YdWJsZHFlVVlSU1BlTitwcFVydWFhSmxMQ2lyZERzOXBDUCt1K3hi?=
 =?utf-8?B?cWV4Q1FCTVZYYk9YYU1Va3ozUXpvUE9HbU8yQWNzcnBhcjJrRzh3VGRIWDFz?=
 =?utf-8?B?aTE3bjhSWEZnOEM0WlBCUDhRRFJFdEsyU1pXaHdhS01MbDNIaVdUbGUvOXZx?=
 =?utf-8?B?UDBENlpyNFYwR3M4SCtiQVVQU29Vd1p0NVMwczRUM3hKSFhMQmQrSVZ1ekNw?=
 =?utf-8?B?ZWxNcm9YN0RxYTdQN2VZMTFtQ04xa1ExOGh1enkyblNIajdkVnppenpzMlVP?=
 =?utf-8?B?eDZhMUg0K1Fsam56eHI2SktXQWRQZUwxQXpaMGQrRmRKN09DK25FNWkvNHI4?=
 =?utf-8?B?Y2xYSU5VOHJUOE9MRkNqRDM5ZDRsTkpXejhwbWZJc2ZhUXlUMkhjazZlL1JZ?=
 =?utf-8?B?aFRkUWtCWnRYZGxSTVV2MW5XV3I0T3NJeURxR1dmd2VWU0hNYXB6cU94OXZv?=
 =?utf-8?B?RWtORWlTaEV6Q3pyblZIMk1RMDZIVGI1eUl5QlJYdldhbTZoRFA3SzNjb1Fh?=
 =?utf-8?B?TVArT1VjMUwzS0dPU3MxdXVHYkMwbzdvQUFGckhiNFdrWVlLeGxEaVovVlFU?=
 =?utf-8?B?ektZU1NIbkpSUGRxQ0g4VmxycnU2QStmbFA1MGhTbjEreXU3NWJPbldBZmYx?=
 =?utf-8?B?U01GRjZJeDFSZDBvamQ2YU5MWVJ6K0VsWERMcFYycVF1cUh2YUlLc29INytM?=
 =?utf-8?B?TW4xMDVJem4xWkt1YVRDRzdTa2h0K3BsZHFqc2pvRUFSOWRjU0VYamVyNVgr?=
 =?utf-8?B?a2UvK0p2WG9JOWdHR2NWaHc1ZXhmQUpOUzRKbmRkdWNQUEsrOXBoWlZvR1py?=
 =?utf-8?B?RlNOM2liRnV5Z2hKN1g1dE0wVWVXNVVjaDFBT1FoVnlvV09FUVVINkE4L0U1?=
 =?utf-8?B?N2pra1hFN3dtb09QWmNnbWhvSTRIWnNXV0hwL3BFNHF5UWhPbGlqMHZMQmhF?=
 =?utf-8?B?cWljZ2docXZQcUkxazdFRFAzaXlCU3BXWFdwdGJ3cVdkWkZxTG5MWkRLczRa?=
 =?utf-8?B?QlpXUVJwMkkrR2E3NDlkOHlBM1Z6bnVHaTVLYis0a2lmNWJBQ1Jrek56Vnox?=
 =?utf-8?B?U0VyTDg4eWZQbjVvZ21DMHFXaE5VendJeVdLQTBVUmhLQkppZ3J3MXZBY3JR?=
 =?utf-8?B?VDlpZ056eHpRV29nT2lna1oxUStaOGM3WW1hZGsxaHJ4UDVqOWN4MVRiQTU4?=
 =?utf-8?B?blovS1VsdjUvSS9tWHVHeXVnbUpVSVJaREFZNjJKNEFtTnB2ZlowbkhtVUpV?=
 =?utf-8?B?a084bnpEUUtZb0ZFR3ZUd3BBaHhtUUhrV05IdzFjUnJBbWpibi9iUWFkWVBF?=
 =?utf-8?B?SW9HWCsxdTVra1FnVUF2NHVUaTBMcVRWd00wenVEem9kMGY3OG0wbjFRSVpB?=
 =?utf-8?B?Z3hXYndPSFNPYlNBcDM3ZEZJYmhWUG94bWdpM01LUTlkR2JSbXZhYm1aSHZD?=
 =?utf-8?B?SXVkNmNNQkxGSEYrNGZpN2F5aXAzdSs4S0wxM2hmZml4RkJWNnJSdFIvcElM?=
 =?utf-8?B?ZWhlK2h3WjJVaEN4bDgxdzI2a1F6YXNvejBpUmlxL3habGJZaU5RRTgyZmJt?=
 =?utf-8?B?eVBGVHBpOTdjQ1RydkxObXhJSjVrMktwbkhsbS9PcnZmNys1MGxjM0dxVkhL?=
 =?utf-8?B?ekdMbFBFQ2tVNUdVRUNaNjI4RldhQU1rdnNwZG5PaFhGRVAwRExsc1JnN1ll?=
 =?utf-8?B?WDlrckpuODUzTGk4QUl1Zm9hYjF3aEdZV0pzaVV5cG5pRWt5L2I3QnJTaG1p?=
 =?utf-8?B?NWNZVjFuYmpvN1RNSUl5Z0tuTlRHRE4yTU5EVXFRZ25qSjJ4TklybE4yM0t6?=
 =?utf-8?B?czJtTGtYRmJ3d0tUdnFsYU9iQXIyckRRR0kvUTBDckdkbjFSY1VhOERXeDZq?=
 =?utf-8?B?VnlvNTdjWjVaMVJkQkR1Mld2RUUxL0ZCeUUzcFhvaCtjdjg3TktvSUluSlJ6?=
 =?utf-8?B?eUtoVkZWVDRyejljR1Q0YlFHNUVpRWE4QzBEbHBiQURwUDE3N2l1N1orbzNs?=
 =?utf-8?B?anlLa2pXRTlBWTNmM3FjRVdRMGl5Mms0c0FYcEdxNUN0QUV3aytMTkExNm5K?=
 =?utf-8?B?U3pwakRsZWJIdXo0S2J0NnZhYTNXaENJUXRicmpjOU9SWkVSMnF4M1V6Rk1j?=
 =?utf-8?B?ZStUelNHZnAyai92TnNsUGxLZGxwR1BmYTJvS29kcWcrUXNqVGdKaXdOWGlh?=
 =?utf-8?Q?9rbOvF7cKapQbdk1UP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb26cec-1323-44ce-dfc7-08de49f3d387
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 11:41:11.0756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKM1bVXXFuG70DSgDoyh4//3HUsyaHnRIzvQOE87ZGn/Q4SO9zKorlEqUTJGXZ6JDwIakGIhCxZnvthJolatuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815


> Fold svm_check_exit_valid() and svm_handle_invalid_exit() into their sole
> caller, svm_invoke_exit_handler(), as having tiny single-use helpers makes
> the code unncessarily difficult to follow.  This will also allow for
> additional cleanups in svm_invoke_exit_handler().
>
> No functional change intended.
>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/svm.c | 25 ++++++++++---------------
>   1 file changed, 10 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c2ddf2e0aa1a..a523011f0923 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3443,23 +3443,13 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>   		sev_free_decrypted_vmsa(vcpu, save);
>   }
>   
> -static bool svm_check_exit_valid(u64 exit_code)
> -{
> -	return (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
> -		svm_exit_handlers[exit_code]);
> -}
> -
> -static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
> -{
> -	dump_vmcb(vcpu);
> -	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
> -	return 0;
> -}
> -
>   int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
>   {
> -	if (!svm_check_exit_valid(exit_code))
> -		return svm_handle_invalid_exit(vcpu, exit_code);
> +	if (exit_code >= ARRAY_SIZE(svm_exit_handlers))
> +		goto unexpected_vmexit;
> +
> +	if (!svm_exit_handlers[exit_code])
> +		goto unexpected_vmexit;
>   
>   #ifdef CONFIG_MITIGATION_RETPOLINE
>   	if (exit_code == SVM_EXIT_MSR)
> @@ -3478,6 +3468,11 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
>   #endif
>   #endif
>   	return svm_exit_handlers[exit_code](vcpu);
> +
> +unexpected_vmexit:
> +	dump_vmcb(vcpu);
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
> +	return 0;
>   }
>   
>   static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,

