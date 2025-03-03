Return-Path: <kvm+bounces-39898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEEFA4C8F4
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF7E13B4F4B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F1025179A;
	Mon,  3 Mar 2025 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HAsACQSp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC0229B07;
	Mon,  3 Mar 2025 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741020412; cv=fail; b=AIw0OoUWB/JjGpkEMjNU9LcV9486LQRnuisIfAT9WNpdmw72D8G+HjAUqkOQkCZNCplcqSRZpGtcP0XEipw9CheUsg1sbqEVCH7lT29J1LETMPIgQUDPO4tKHIC1TCNiFXdlbfptzuikPFzC6JTIvvyfxhT468xO+iy1j15Ir2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741020412; c=relaxed/simple;
	bh=HBP+bxSQNUVXAyjHaxCdL5qBJ1OgkNNDRzB6Lif00ns=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=X76osy+YGovU5aPmeuVX5EPknsdH/M3IBT+nAAdSiSR1QnJO2d2SYxmLpphqQJE9iH5KMeQWg7pyyzlVTsLHGLal74gbkLXkSw83Yx7nQTzSobgiCtWKot1RQdi0lqUKn2FeGgkBLsyQEsJctD5l4w2oI95IWmLpwDvar0gJq+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HAsACQSp; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJGeW2tsVJ19lMzuV6x4RKHopEbjcx7TD5EuwX1WQNcjh9EcL2XK1RQmQfE6ndRTdILHo9IkGef8rhcMuPUNVD4S2vPcdao3zC8iZ+jnzj4p2NcFYWwcXjv+42dK1YY/RyWmSQOZEIqxjfIR/EDhR9j1hBToMUAGyRdF4oQQu2tBnvJ/cnc+UuNQtkM5rqiTjua5g9UxSD4/HtsA1pNB9bEugf77ZFv/uepX9b/zuWIV0i3dDCcBhAWt5wiTDIyRMOw5heRuZec9Go1lmv4/EPX1C+RYo6I+rsw+DDS9mGp9mSvY9IuvlF6UZzDhyX1EVwGWzewQqEAKVjNeC9Z2dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVg/eUkobGFyTOYbqkWcNLybV+YN8xWTbwzE3JQGrfo=;
 b=BYmD5sgp8vnZRhKjI1cJ3LFLYqWxYIq263blpIZ9tmZkTW8mjHAPsoQd9J/AKP1rh7UkYCPE6lqf7oX3pMsLxQuSsOncvAXywtZ32Mc6qRZmTgYRp0XUjkq20Dl2OTn82Og6aMXIF6lABaEHMcP46tJ3JV1oAtGMDl3vF2rFlwURpnX92OMDoTka3DPWWMuYvOerZ1xmrFybdti/f/k0dZaV7HLzwONltiF5nrYXnZgH9sH6DI9bX5/uHnfonKE1yuc8XmPV5AYYosj1lZZ32X2gl+3kKO114/KP6fqUD+R0rIFV4YSum+NHlX69TafT8fdw0tDFlSAlZvmWcFLKJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVg/eUkobGFyTOYbqkWcNLybV+YN8xWTbwzE3JQGrfo=;
 b=HAsACQSpki4/xn/XsespugxFVQfUxMEsJaowGIgRnXkOOrHI7iVDC7yaR8vqMPghhzRniiuFsjT4w7BmGyvG/lEoKnkKMWmTBh8AtJ+pVensDweA6h3hUsnusREz89g1fehcVlCtbo5FVMH19a/6Q8ubA6tMqajBZVGf+lV5iCc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB8067.namprd12.prod.outlook.com (2603:10b6:930:74::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 16:46:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 16:46:47 +0000
Message-ID: <53ef3325-61b5-7fdc-0d03-a2c9212c0f6e@amd.com>
Date: Mon, 3 Mar 2025 10:46:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Zheyun Shen <szy0127@sjtu.edu.cn>, Kevin Loughlin
 <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
References: <20250227014858.3244505-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 0/7] x86, KVM: Optimize SEV cache flushing
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0028.namprd05.prod.outlook.com
 (2603:10b6:803:40::41) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB8067:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c383fa3-f18e-431c-87bd-08dd5a72fd2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVRtVXRaSVJPeWdJRXlBUXYzMkQ2Y3dXRStMSHZJTjBGd1dXcTRVWmpvOFNo?=
 =?utf-8?B?Yi9ESEZ5WDdDMHRteTg1bmNSVXY4Nm1kWXBwSGJYN3FqdmoxU2tkM1Q3ZTNL?=
 =?utf-8?B?Q1BobkRoVitEUldBY3lneEFrbDh6eUtsSGNTR1FpTDZJb2NvVnR6UFJQb2Ry?=
 =?utf-8?B?cnVNVDlOU1FyQm9CS0xrdGNPaFp6VHlSZUFkWnNYK2hKMi9acUZRN01DanVz?=
 =?utf-8?B?NDRqcWFGc2o5anpZKzdJSURHRFM0ajU2N09aM1AvU0FGZFR6a2ZQZm5pVGQ2?=
 =?utf-8?B?ejdLcGNVWkNrUWJQWmpaYm42RVZCbEtrMmNpYU9YbGpJMFJ0eExHenNOeTYv?=
 =?utf-8?B?S1BuOU5nM1VMOTFKdlRsSFgwcmFhb2g2dHRmOXR6a3dWS2FqdUt2aStlS3Zy?=
 =?utf-8?B?elcrVnBRdVZzbFJma0xhNzFGUXZwSDBydWhCcUFYTGNkeEhiQ3kxV21Bd2Nw?=
 =?utf-8?B?djJKUlNlVEJHMG5pWkgwbE1XUlFheThlVGV0R2w1aHQ4L1JmZWxReG9NMERF?=
 =?utf-8?B?OHZBSmsxUFc3RFloT0dDRmttR1JXUDlMYzRQNDJKcHVEOTBDUENGU25XWjdp?=
 =?utf-8?B?d3RHUG1GY2hVNWt4OXhYQ3gvQitlMnNQVXBoSStkc0VnWlU4Vk1Dc2s3LzRx?=
 =?utf-8?B?L2NPNFg4WUh1UHlYU2poeGQvT1pjU3RuQ1pIN3hhQlNERUVOZTJ2TG43Ykxy?=
 =?utf-8?B?d21IdzcxVG1HT2RHaXRXcTh3c2w5M09FSE9Dc2E5Rk41ZnV4dENKUWUwRk5j?=
 =?utf-8?B?cFVlaFZNL0dJYUFIL3M2NEExQlpmWlBhOTFhOE00OVdTSE54SWppblUrN0w0?=
 =?utf-8?B?c2ZIWFQvR0FJWm5sUVVKV0tGOWxQYjRkdHBITW5kMDNjS0hOQXBpeHlwcmNk?=
 =?utf-8?B?Um1mVzJhWENOaGlROExwSWhFenF3U2o2aFFRNEZIdjhQQzdJem0ybE5XdXBZ?=
 =?utf-8?B?WERxaGdKMnBNdjhEaExQMGNwcEFFWUFPaDYxbit3SW5jWnR5amhjSmNwUWJ0?=
 =?utf-8?B?U1VySUdHOHhtQUxRY0hsWlZsWnpoZTgzZ0RFRGd2bTUyd2RXditrTFV2bk0v?=
 =?utf-8?B?N2tTRFlUejgwSXY3Nm1mM0tEZHlsdXdrMzZYUVZTT1l5Qnk5cnhSQ1lyazZE?=
 =?utf-8?B?cmx1U0xTeWlDWjlUVlRpOTJjdTdzQWFHVjRLSzg2Q3RmT1FieU9nNWxjTi9W?=
 =?utf-8?B?Qlk3Q2ZjNkpIZS9DM1g0WTgzYkJpdnZtdXpTWXhhNkpKQnRjcUh2T2I4dWZT?=
 =?utf-8?B?WEZvYlZkWnplQW1ySmd4WWNOeTN0VWtuWVZkdFUzazlnM0RRekhrZ0FVenJa?=
 =?utf-8?B?N09Ed1FHc2ZLVi9kUGo1RDA2U28vaFd2T0dCdmpoSU1GMSsySklnb3M3Ukpj?=
 =?utf-8?B?dXF4clQ5YjhDcEVIdVVBcFJIM0Z3aVhOZGJBcFZKaG1wd3NqT2VZUGpRYWNU?=
 =?utf-8?B?Um5NS0hHTWx1R1BXSHpzMHY1TjNHd2VFdGp0OENPZEFwTG1iRkN2aGkyaFBC?=
 =?utf-8?B?S2F5WGNCU09NL3RML2tweXQwdVBBNzhlZk1kYmlKN2wxRWtXdnFyajJ1YWNm?=
 =?utf-8?B?M0pvRFFmVENOTTZyMGNjYnpxeXB0SVFJb1lIVXZVV3ZmcnhDR3pOdDM3ZlND?=
 =?utf-8?B?dnRMTCt2dTk5U2tCQTdkakRHSDdDM251dlUwM2Y4QmZ3K2FYNWFCc1dmeGl5?=
 =?utf-8?B?Z3VvYzRFcjEzSUVNYzczMlRnTkJBZjAxdHpFRkFwY1NNS1hHVFNYd1FwMGVI?=
 =?utf-8?B?UDF4M1ovcURvOE9yZUJtbG50YW5hRy8rRmUwQnBNaUN5ZTdlbjdrWm5mOVA3?=
 =?utf-8?B?R3c0N25WREpEMy9FQzE3UnU4Nk9kVEpOZ2xmdGt0cXJDckNrWTh1Qk1Xd2No?=
 =?utf-8?B?MUkzdWR6MWdVNC9DMmVjaytXRGliMFNsemJoOEhrbTJWN3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHVLMmFhWCtVWmJTS2Uzb1diNmlqdERLRVZpaTF0MlhteGd2N2pnK2cwNkJ2?=
 =?utf-8?B?dnd4NzAzdFBSSXB6UnM1bTR4bGRMMnViV3NRVmJoWFRVQzdhVFpPa1JHUzBp?=
 =?utf-8?B?VUYxSzJTR0psZjNXeTBTRlZ6bDIxTUdTdHQzY1RTU1dXd0hBY3dKVUpvbnNV?=
 =?utf-8?B?V09FdDRhTEtCYzZuMWdVMFA4MHFyMkd0ZFNPdHh4ckd2MGxqeDQ4V04zSkpy?=
 =?utf-8?B?aE1vYVRoRVNIalFzeWtWQi9TM25ST1kxazJ0aDN5RDBKS2V3aXZUckMwNWJr?=
 =?utf-8?B?NDE4MUd2OEFRa3pSRHFvRlRXL1NNa2ZFaWptdFJPS1BsaWNLTElPaEVBK2Nh?=
 =?utf-8?B?eU5teEhOelpUQnBxbUtYa3NLL0t3Yk5JZzBWQkNmRGpGVWt2VWY4Rkl2WkNi?=
 =?utf-8?B?NHNXdEc1emJBUW1MdFBIcjB1WEQvQnF1U0lxSnY5VXVweVVCdlRDVVdKa1ZR?=
 =?utf-8?B?VlM1ZGlodlR3MDQ3WHk0S25DWGtUZklkWmRkZVlNbE5kUHkwZy9rVXB5ZVA1?=
 =?utf-8?B?R3kvSHBNN0lDK25hRlhobVhPbmtDd1RaZHQvUlU0elBiZWNRbDdGdHFJQlBS?=
 =?utf-8?B?OW5FSFZNb2w2MUNqVWRBeTE3SU1zY05SUjg1TDBxQkxGR1hzVEtzbXBKUTJI?=
 =?utf-8?B?RTFPQmc0Ly9LZHczZVNqZlBCV2d6am12d2daQ0hkWWN4VHV3TmEyVkRKNit6?=
 =?utf-8?B?V2I1dG1ha3haYnZUdFJ6dHlDNmtrMWd0U1g5WkRBRC80blBOS1c4R1QxWjNy?=
 =?utf-8?B?MmRGSWtJRkxkVUpCSGpKMWZOZDhyaHZCNUVTVHk1QTAyMVpaOURDL3pmVjFJ?=
 =?utf-8?B?Z0ZMUVJQOGIyaWpjdVRrTVEwd2tQM3lhWEtJamU2UExrazVobUJUbGdNUkNF?=
 =?utf-8?B?TGIraWxMeFVZNUFlZkpUWEpVVXRtZXU4cFJoekdBblBXTlo0TWUrRG5LZGVG?=
 =?utf-8?B?M0dEYnRkM1hxV094UkNIbFVoUXNkU1pLb3BNbDlMVFhUcGY3SSt1clA3SUhl?=
 =?utf-8?B?aVlPbk5oUHF1Rko3QnpXVVhTMlVqTWNjaGtUM3k1bjJBdTMyeHdGc3NPNnpJ?=
 =?utf-8?B?ZVhvRWlVcTY1Rnh2SFEwdk12SExkRG9uZ2JrY3dnVjN5bWh1WGIzWUMzb1RF?=
 =?utf-8?B?L0FxTHJ0M2pWQm14ZDBra2VhSDkzNWtLZEEwMW5kUlU2bVFDNERkQURvWWp0?=
 =?utf-8?B?eWM4U0p0WEFTNldiL211ZHh3UUVqWTRRM2l5dWpOeW42RVo4MnNIZHVUdFpN?=
 =?utf-8?B?OTRMem1CNk03dkNndlZYaVZvYkthb1FZK0hINHdPczlFY0k5NDA5dmw1S21y?=
 =?utf-8?B?eDBZQW5SaDJXamQvNnUxa0djV0kvemFKMi9maVVOdUJqWlZuUG51b053STVP?=
 =?utf-8?B?Q0JsZXNSVXE3MnJJZWFDSUt6RzErTVd0ZlNnTmVxbkN0Q3YyemNKL1F5QkZQ?=
 =?utf-8?B?cEFUdm9CZldzVnlIZUZjVGFlRG5WWWo3d2JIbG1xZVhGS1FxU01WcXFiQytj?=
 =?utf-8?B?Nm9HbkF2L2d5eWVaOHRQSGpqWTZZN1FTVXBwems2d2ZhMXJzcXhLUU1McE1R?=
 =?utf-8?B?OFFmRTh2NkVWbk9BKzByRW5KRW5ZTmJUN3JKM1dWek1CUHYzOS8rMHlhU3E5?=
 =?utf-8?B?M3Bka3lJaDdqcytXaEpyK0QwSGgzZHVrREVrT3JLVFJLbUZWVkFnU1NpWHFn?=
 =?utf-8?B?QWp6ZUM0alF4MXJteFJFdEJyOWtRbnJvcnVBamJDQmh5ZEVvaEFNTy9KYlRZ?=
 =?utf-8?B?QzdZN1lyZzZHZnYzTmZIeFJnSnVVZ2hpSGk3Y2Nvb3dpaGVyOEFKc2xiY1d3?=
 =?utf-8?B?VmN1WmVWamlpR1BPcnBQRFdsSmVRUWZZYWNXK3RNRzZZTkpvWVhjN2V3eHM3?=
 =?utf-8?B?aXhScXE2azY3RFNhRWxUK0xLM0RsYW5leS92MlRhbXBlUVFEVkVSSlVNVlNk?=
 =?utf-8?B?MWxBSVpZYW5Ed0hCSnBKMmhkdmFuQzlDY1ZrdmsraHBDbW9VeUk0R3RUZjBK?=
 =?utf-8?B?eXFaS0RmTmQxS1l0NFp1b0NKOEIyUUVLNWZBUE96c2FEVTY0alJITEZ6aTBQ?=
 =?utf-8?B?SnNFVTY0ZXNvOFRaS0piSDF5M2RYOTBScjF6MFE3WkxGSEpvTTNsQmVycFRP?=
 =?utf-8?Q?zqnoKjWvM1/GNvtoqpSBbnmju?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c383fa3-f18e-431c-87bd-08dd5a72fd2c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 16:46:47.8327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++ScXLIMUZiXXJlUlK3xodQmJC3xAkVkA6NMlsVmWm6mMecyxZ9Xc88STHbcR0gHVYYzT4QKjwTN8evJQCojYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8067

On 2/26/25 19:48, Sean Christopherson wrote:
> This is the combination of Kevin's WBNOINVD series[1] with Zheyun's targeted
> flushing series[2].  This is very, very lightly tested (emphasis on "very").

We ran this series through our SEV validation tests over the weekend on
Rome, Milan and Genoa systems and didn't observe any issues.

Thanks,
Tom

> 
> Note, I dropped Reviewed-by tags for patches to which I made non-trivial
> modifications.
> 
> [1] https://lore.kernel.org/all/20250201000259.3289143-1-kevinloughlin@google.com
> [2] https://lore.kernel.org/all/20250128015345.7929-1-szy0127@sjtu.edu.cn
> 
> Relative to those series:
> 
>  - Name the WBNOINVD opcode macro ASM_WBNOINVD to avoid a conflict with
>    KVM's CPUID stuff.
>  - Fix issues with SMP=n.
>  - Define all helpers in x86/lib.
>  - Don't return 0 from the helpers.
>  - Rename the CPU bitmap to avoid a naming collisions with KVM's existing
>    pCPU bitmap for WBINVD, and to not have WBINVD (versus WBNOINVD) in the
>    name.
>  - Fix builds where CPU bitmaps are off-stack.
>  - Massage comments.
>  - Mark a CPU as having done VMRUN in pre_sev_run(), but test to see if
>    the CPU already ran to avoid the locked RMW, i.e. to (hopefully) avoid
>    bouncing the cache line.
> 
> Kevin Loughlin (2):
>   x86, lib: Add WBNOINVD helper functions
>   KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency
> 
> Sean Christopherson (2):
>   x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
>   KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
> 
> Zheyun Shen (3):
>   KVM: SVM: Remove wbinvd in sev_vm_destroy()
>   x86, lib: Add wbinvd and wbnoinvd helpers to target multiple CPUs
>   KVM: SVM: Flush cache only on CPUs running SEV guest
> 
>  arch/x86/include/asm/smp.h           | 23 ++++++--
>  arch/x86/include/asm/special_insns.h | 19 ++++++-
>  arch/x86/kvm/svm/sev.c               | 79 +++++++++++++++++++---------
>  arch/x86/kvm/svm/svm.h               |  1 +
>  arch/x86/kvm/x86.c                   | 11 +---
>  arch/x86/lib/cache-smp.c             | 26 ++++++++-
>  6 files changed, 119 insertions(+), 40 deletions(-)
> 
> 
> base-commit: fed48e2967f402f561d80075a20c5c9e16866e53

