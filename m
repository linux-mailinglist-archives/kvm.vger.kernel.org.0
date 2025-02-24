Return-Path: <kvm+bounces-39051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C85A2A42F6A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4AA31757C2
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28E51DE2C1;
	Mon, 24 Feb 2025 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pEE0djpm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F931917D0;
	Mon, 24 Feb 2025 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740433569; cv=fail; b=pWQooba8jOFnjYOLIXQLcGeAjRNSbvEgzOrHn3jd0oKFWFhhMFl8OUpCXfqZ2Dms+0MNpc28L6xv0IjvcxPZaf6jWy/Q5ISq5+4LAG4uRL17zKKzpNXp88TmfH0pIccgnC/FpOUBFJAFNeujl+CJQL2SOOEb8htC3kzSy2C/YNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740433569; c=relaxed/simple;
	bh=NXnW5RDnJmzU/i36xDnUX7/S53i9R29aGS15s/3uy8Y=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=UlmrOsSZiTqUswxYLpmOnumJBOdVvNgv+QWE4ESyovlzI1s1uOq3RTX8vpqv57EARSce5+D5ZDGhuKqbGciAmd5nXGkoLEMMZyf+hWV5US2GKd71wllmZCvAoKEEMSMGg5QxwYmfDkxswwYcOSBjEARJv+a/Z/FnDynqtJ1dYBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pEE0djpm; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RiTeVtX74S0kv3YzL73dgZ/jxVnL1+NxCVj75HXg6VpjFrT0tms7acrrJ5lcLd3OBmbanAj4HGgXXILwJnQzIH2QXoyDlrXFSnT85mUz0ZLDazBRuZmdwoXyj6xfGgbY8j+FoH1QmN0UlBFR3N1JkAs50ulAxwiBgeE2Gk7qPCGx6EGi8kCihgL46Sx5uilBhbAWPdiOI2tprlXFpM1NuKzzwlBBJENFb+RBZhgSBMdQHnVxX5HoZ3vAWlZjaGls5oSgEU5u/D0Vxgbxq50U3rQ0Gan6yfBPaZEeOizI260TbXP50W2X3PL8AIZokV6nnt79iqxUXXJ66PiOTKrqHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SN+NQ55S0tezVQxfC3eeHMiJYmV9vZZKjqj/jEHcREU=;
 b=dzK9ev4kaqCBYHRN2DS9zpcUr1+z+UfBSjkrvVH+Bw5WJc9o32SNHDeilXGzJvGxxZ6Vk7qs/1N3KPZikR4imcIvTDE73dbVdLl3eKgeBpujfS730KDiMs//2ArBY7/xBqZ9rRyuZ8glG9S15l1gQ8NRnCyaIdXodjQdf/IzeVisQHAH8kq1rE+2YoWRvjSSflICOVaWSu0jmak9QCxANMvJlliJKqJIj/Ni1CSPUSuWmYc0ww7BDRi569yeQpYMTHkrOi/6yfv+VyaZ7WIgMQecFtXU71V2u/wDgp8EVzbK+wlMOG5lE9hNTa+6f/yOFSt+o+rBv80QWGJjtdqaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SN+NQ55S0tezVQxfC3eeHMiJYmV9vZZKjqj/jEHcREU=;
 b=pEE0djpmLVyf1yHt6Qm4B0EL5CS7Yl5MuG6fjKnwBUw3WqcnHDMHZo0omEcDkbfgAcw7UvQdkn9Ud4ACz3e9g7kbgvVPyiuvt24v3W+cgb0iiJTzC+n8yARr4ICQWu2oWGif8MpUpB08xsrqSYA5adsk4uhLTtJsQQqbjUlml/U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7204.namprd12.prod.outlook.com (2603:10b6:806:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Mon, 24 Feb
 2025 21:46:02 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 21:46:02 +0000
Message-ID: <7f7f15e2-7ed0-b5fd-eb19-4423b4dabc46@amd.com>
Date: Mon, 24 Feb 2025 15:46:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-6-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 05/10] KVM: SVM: Require AP's "requested" SEV_FEATURES to
 match KVM's view
In-Reply-To: <20250219012705.1495231-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:805:de::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: c0fab38a-63fc-4d43-e0a5-08dd551ca1ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek1hL2UzOU5NRnRsK3VuNTg4NmNjVU9uM2dCYmJXUUYxSVg4SEVENnhTOGx0?=
 =?utf-8?B?endsYjE5VEJ1ODlQT25YVXY5aWcxMU1SOXg4M1hoVmFhZmEyOCtUYy96N1VG?=
 =?utf-8?B?RDY0QW5DcG9oTExaRnhzNEZNRkl1TUJ5OXptVXhodDZZbmNVY21id25NaStu?=
 =?utf-8?B?UGVjaFJzcDMrSGwzZ3U3VUF6eGpqcTI3c1Fua2dHa2dEWTZkR2d1dEUrbTFD?=
 =?utf-8?B?eVdTbHRUV1ExeDJTRyt5ZjFuL0VVbHh3TlVkVWkvbk9ScXhrU1dxcmpGWGxo?=
 =?utf-8?B?VVkwZ1FReDZXRVR2a1l0OGhZOE9TaGRHR3VSSmpuTERCMUN4QXdobWo3TUFj?=
 =?utf-8?B?Mml4a3lvazhhNkdSMmtySVlTU1BWajBGYm16Q1lGeHQ4NDl1QytPbTd6a0ll?=
 =?utf-8?B?V3FuN3Iyd0FyQUdTVnVEd1ViaXFiamtYMHBVZ25DdWYzeWIxdkZBRnJPK1lk?=
 =?utf-8?B?THEwQ1BxSzNwZXo4aUhHRUtpREZzTnkxeWxQNVY5d1JJL0ZLTFZuWmF1R0FU?=
 =?utf-8?B?NG1ZclhUNHdzRlFNVzRDSlF0aUhTaStIakV0ZDdacnVNdXNsdzhscVBkK2sw?=
 =?utf-8?B?Sko4QmVheDlESGZvb1NOakRONUV0WGNBUlF1bUFpaEk0aVdjenRoWURpcGpR?=
 =?utf-8?B?aUZXZlZiMTFZMnArTzFVN1g3ZlV1Q0xhQjJxNEZjSTR6L2RZamxFdHlMalho?=
 =?utf-8?B?dlFiRzYvOCtZaXFQMUplTmY4QkRYTGNxZDZERmdwSUdvVXA0U1pJL0VQTHM5?=
 =?utf-8?B?ZUdudUZwUlU1SnVKcVJNR1lWMkRkd0pvdE9KNlllYzFlWVZER3p2dXVCVlp1?=
 =?utf-8?B?RkRlY215bjhwd2lqODN4TEx2QXJGRC9VSFRiMG84RVNKWnB0VmRiaUlmR1ZG?=
 =?utf-8?B?VWFnWkpzK001S0hGdHVUS051R2lxZjZnelgza0Z1TEU4Z1BwZjFLeERmVG84?=
 =?utf-8?B?Y3JtWFlWcjBBSlhSWkRkL0diRXUwWDdXdWhyd1M1ZCs4ajZqb3pGZEhpOUhO?=
 =?utf-8?B?NFk5VXBsdHB1YkxIVjloL2lMbmFJRXdBMDE2SS9QeGdqdVVTZk5YbUlSRStP?=
 =?utf-8?B?c0FwNTR6VGtqZUplNHJhbVB4a0ZJNUdiTDFNR3g4NHM3NVR2dUpyOG9xRXBF?=
 =?utf-8?B?ZmJaNDJJMVRaa2tobEYyUmFZdnJSc2lremlQTVE4R2I4dmhQZXB0TVMxYVV5?=
 =?utf-8?B?NzZUOVZhRmI1cHRZWnJmK09pdVQxTkUza056dUpTVDRERzE0cVVBYWVjaWNX?=
 =?utf-8?B?aWxORjFkcnhGK1RWZG1MdW1xK05nTFRvNFpjRlFIL25xcTd1eHZadFpTVEEw?=
 =?utf-8?B?Z2NXWGxRNDBzWkF1K01CWVRvTVhuTnQ1amtqT0hKTGd0elA2SUw2SWVIMnB4?=
 =?utf-8?B?WGtPZ0hQR2gwSzJ0Q2FrNXdtcnpPUVBTc2JZbVgyUno1S0dLVmVjTFpNYTIx?=
 =?utf-8?B?Mmt6RGI0aThHUmZRbWVyd0xMZGJBOFVBcTlsbVJKeG53aWpnU05yUzIvZlNa?=
 =?utf-8?B?em5zMlN4bEoxN2Rmd0tzSkpjR1dVOUVQV2xKajNOS1lPanJwbjBETE10WXB1?=
 =?utf-8?B?VjNEL0YxSHhEUU1aeW41WlF0OEk0ZFdIZm5ZTDY1d3dJd1B1ZW9mdGNnVTA2?=
 =?utf-8?B?MkhFNVNOZTkwdzZnckpuS3ZJd1ZVeFp0VitYU0UzektnZGJ2QkR5VE1tWW5n?=
 =?utf-8?B?VllyREF3UytqbGh5a3lVSW90YTI3cHpXYVZNTEhWYkJkNDdaYUtWdzNUT3lX?=
 =?utf-8?B?SUJmNVVBOG9xcEhYSy9wK1dwRkZ5K2N0QXBLdFRSd3hDdVdKYjNOQzV0eUZq?=
 =?utf-8?B?bmNIdmFrWG4yVzN0d1JDait2T0J4UUxRYVhySVJQY3FKa1dOcDVZRUlubUdo?=
 =?utf-8?Q?8RJPwdcv+mInN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUJFM0k2eEFuQU0zSDlDeis5RGRxM0E0Qk4vQUE0dUc2SWkwQTZjeEQ1OHE3?=
 =?utf-8?B?N1NpNC93NmVINFg3c2FUYnFzbmlJNi9vMHM3VWxoTjAyMFR5anBPb21ieGls?=
 =?utf-8?B?RVJ1MGRaL0hvVjVpOG9IOUFmNUFWVjQ3RTlwV1Q3MGcrakI5ZW4yem9COE13?=
 =?utf-8?B?WnJ1Y3ZSM0JuSFZwMkZlWVZUM1N5S2NCNW8vVXBSWjNDV2M0QkVjblBpeWhQ?=
 =?utf-8?B?alRJK0RaSDJSS2ttUVNnbGpNSzVaWVB4VnJjVEJBMnExNVphS3hqTE85aFBO?=
 =?utf-8?B?WTJkWDB2c0s2VjlXMHAwR2txOTB4NTZxYVg4Vk13WGRLQ3pGd1UxZXhIai9X?=
 =?utf-8?B?TW9HaEtRUXNvUkxlai8wZElmdGI5amU0Wk9RSWFoWk1sWGFWelVKMnNRcmkv?=
 =?utf-8?B?U3YzVVRzZVNxZVdMeGhSMTczekJiUDF2amRUc0pTb204eVdQbFpqcUs2WGkz?=
 =?utf-8?B?ZzFiNFRpSk5PaW9DQmVBN2xFODhoME5oTlBIUTFQR0RJTHVWeVV5STVxTnhk?=
 =?utf-8?B?dE9iSnhYS0p4UHgvOGdiaU1KZ1UwcnNwdC9QNlNENzd4UlpNNDN3NjJDcWk5?=
 =?utf-8?B?VkNNSWFiYkp2RDNIeUJaWTkveGJITEptUS9XWkNaZHFlWjBvVTdGaFUzcW0w?=
 =?utf-8?B?bUM1eXplMnE3dDQ0bE5wU05lcmFXaWFyUGxjaUdXK0RLZktTL0J3N2xSMG9Q?=
 =?utf-8?B?M0s2K3Jtam5QV1lmRTBwT1F4eWpFeEZEOEtaeHRJSVg0VzZ3NEhZVXVBdlU0?=
 =?utf-8?B?azNqcExubGRNWG92bFhBWGFaZ3JhOVhwMW9MbnpVbXhpTzZaUHZTSnpsZi9O?=
 =?utf-8?B?Uk15SmFoclNNUFQ1dTVxQXZGK3N4em5GS2MyUXg3Zy91M2V1R0VNVzVGa1lz?=
 =?utf-8?B?akkzbUdycnd4OExDWWVZVzJNTDM2cDdHS05qeGczRHZaZHoxQW4rcEF5UlJV?=
 =?utf-8?B?T2lldnc2eDEzTGl5VmdhN0dGYjg2Q2txNTNiMGdmM3ByZ2tTY1RZSWcxVkJv?=
 =?utf-8?B?clVwc0VJam5ON3lhVlpKenJMK2dMZis3SERYckFoeExXQWViMVUzc29nTUpr?=
 =?utf-8?B?RjFTUFU3Y29Wd1UwR3JXM2dmb3pydXJSMzFWeU9vM25hR0FNMGp3TjhPMUx0?=
 =?utf-8?B?aU9DZCs0Ui85ckNGVG5RWW90ZmJxNG56Yk9ySGpHbTJKaFVRbXB1d3NDOTVx?=
 =?utf-8?B?RXFEZEppL0FBMUdGWU5Vb3NLSGQ2eEI2T3U5OWpXYWtaNFdhTDNhYlRkRzNs?=
 =?utf-8?B?dDBFbHJmaEg1YWdsOXJodXN0a2d1Z1ZYSis0bVFTUnJ3RVNBM0RDemNLcW1x?=
 =?utf-8?B?eWRVa2VTalRlM1lpemttRXNuMFE1R3lzM3VOQWllTDdlTTd0RXpzNGd6TlVK?=
 =?utf-8?B?TU51bFcrTVhGZDI5NUJUdFY1VmY1OWYzZVhHclRaQmJPUHFTNHdjNEpsTTlm?=
 =?utf-8?B?RUpEeFUvRWs3Q3NLVnpxdjE2Ym9LbWhOcmhzaDA5cjExN1Y3K3N2eE1iTW9r?=
 =?utf-8?B?U2VlYmx1QVhYczBidjE2VVp5UytlYlc1NnFRN01SWS8yd3FlY2dQcGl4NEFr?=
 =?utf-8?B?MFBoeStiaUQ5NU5kY1pFZDZTZnNRTkxlZXFLc0ZheVczOE9rVFFZcFZHeFNI?=
 =?utf-8?B?RFEwRFIweHFaZ3ZodkZVMVVsU2U1Q0JJZ3ljUzdka2pwRXdnWHNhMU81azBh?=
 =?utf-8?B?dGtXeUd2WW01SU9RQS9JMmd0UUdmcVhVdjUwbldKYTFIL2swa1JTdUJ5M3d3?=
 =?utf-8?B?R2FXZjRmaFVreDlPdDRsU1hKbHA4akZRVzVsRndBQW5od0VNdW9tcjJsbSt5?=
 =?utf-8?B?dXRzZVdOWjErc3NkNUpCQittMEliM0lPeWlXbzJZOFg5a0FQd3VtMEdFeDZJ?=
 =?utf-8?B?VDdWbktMSi9WdXp2Q0hGRi9Zck80aEoxOVhTU2x2Z0Y4MnBZbkpkZVJTS1VQ?=
 =?utf-8?B?NG9sa0hSb3JXazA3aW5xUStMY1NXUmh6SjY4QjhmdmRid0VqQjlzTDRrSjdF?=
 =?utf-8?B?T2x1eHQ0VFZoMHVlS1pXVWE4d2tGanB0dHM4WUJCaGxhdnJ0YWVVYkZQdS8z?=
 =?utf-8?B?UTJkWklTTTZkT1p6eXhuOCtCV1dBNExzdDdHcWxGckVKUmNtOW80b0UzcDMw?=
 =?utf-8?Q?V+3iOEjzdYGsGtYxs60sKGvvT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fab38a-63fc-4d43-e0a5-08dd551ca1ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 21:46:02.1953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ib4L1dEzsElSztF9heGmpzQY+9nQNTR3ofHGwVGpgbNwS/mWvRi2qTZ3Hzql/S44MCp04wXr96gteKJ3UVJBmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7204

On 2/18/25 19:27, Sean Christopherson wrote:
> When handling an "AP Create" event, return an error if the "requested" SEV
> features for the vCPU don't exactly match KVM's view of the VM-scoped
> features.  There is no known use case for heterogeneous SEV features across
> vCPUs, and while KVM can't actually enforce an exact match since the value
> in RAX isn't guaranteed to match what the guest shoved into the VMSA, KVM
> can at least avoid knowingly letting the guest run in an unsupported state.
> 
> E.g. if a VM is created with DebugSwap disabled, KVM will intercept #DBs
> and DRs for all vCPUs, even if an AP is "created" with DebugSwap enabled in
> its VMSA.
> 
> Note, the GHCB spec only "requires" that "AP use the same interrupt
> injection mechanism as the BSP", but given the disaster that is DebugSwap
> and SEV_FEATURES in general, it's safe to say that AMD didn't consider all
> possible complications with mismatching features between the BSP and APs.
> 
> Oppurtunistically fold the check into the relevant request flavors; the
> "request < AP_DESTROY" check is just a bizarre way of implementing the
> AP_CREATE_ON_INIT => AP_CREATE fallthrough.

s/Oppurtunistically/Opportunistically/

Yes, with the change in patch #4 to not kick vCPUs on AP creation
failure, that check can now be moved to the switch statement.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 07125b2cf0a6..8425198c5204 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3934,6 +3934,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>  
>  static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  {
> +	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	struct kvm_vcpu *target_vcpu;
>  	struct vcpu_svm *target_svm;
> @@ -3965,26 +3966,18 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  
>  	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>  
> -	/* Interrupt injection mode shouldn't change for AP creation */
> -	if (request < SVM_VMGEXIT_AP_DESTROY) {
> -		u64 sev_features;
> -
> -		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> -		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
> -
> -		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
> -			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
> -				    vcpu->arch.regs[VCPU_REGS_RAX]);
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -	}
> -
>  	switch (request) {
>  	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
>  		kick = false;
>  		fallthrough;
>  	case SVM_VMGEXIT_AP_CREATE:
> +		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
> +			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
> +				    vcpu->arch.regs[VCPU_REGS_RAX], sev->vmsa_features);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
>  		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
>  			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
>  				    svm->vmcb->control.exit_info_2);

