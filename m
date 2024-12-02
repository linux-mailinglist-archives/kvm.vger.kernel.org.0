Return-Path: <kvm+bounces-32853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A3E9E0D0A
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 21:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED67C282697
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67051DEFC0;
	Mon,  2 Dec 2024 20:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OJuv6X/o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663C91DED67;
	Mon,  2 Dec 2024 20:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733171614; cv=fail; b=tumRIoBQfXaaOSxyASoe1f6C5bM+j8QXkSxQBHCugcXlP2qtNl7ggqBDC3HWoBxInln0fzr0l6/0J3j5ixRF4/WqelwSHtQSRqmRoEREYhuhAq2rOJQhjA2+BN5KiYmUsmvGdsYOObXj1tPmNyPj+eSoctiAcjlkD8zNMakCeXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733171614; c=relaxed/simple;
	bh=NGu9kPZyt/idMyfQvqWms1b8E6srHLRNQjMZ0ihP1+s=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XcrSWux/KZA0rwNZ/ntKwiqI70MCrfLtSFYD5Ds9m4H11YCZybuSImc9mvhOAiFkfP2sBcWgGqSCsmufrICNlX9621aokWlX/bKP6JM2X1X/6kKlNppRPmkhFjUuGCTXrfLjiYR/sH16U85qxIatqpfrjNcpVLlVNdF+sDdidb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OJuv6X/o; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cksTO/FjM+S55pUqutWBak2tsX8PGnAYSoWaxidA/KZM5oo5SIujkZfXVOBGEyTVJFX+2qZKDb2dq7a7fPSz2Oh/s6o8pKUlf79W43vz71Jo9mOqQyFzdQPPKqgfc0mQdl3DUX/5HeZ1JfguQupKuJq3JlWyoHGpykPRmNeYnzFHHkCoHLbDoV3sUGTfXa9R8+x4mEwRvtDquS/J0AaJym+y4U47KK8/e2lvqc9p2Wz0uUt/3rlJ2I25gsgJTvu2uFzD/zx9vq7YEQ3R44wFPmyyDCsTqWm6pwNOI5K+GCZFQE0yknpKfiRAsX+UYuSBkkgsIhu7QSC6bbk02bKj4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BtwvjzA/ewb1RvVVeypUNi4drx7gyhMBScDEsFhNjM=;
 b=h3+TVC9H4hllIwwQxEXLa73Hrf9BKNqQBFRo+uFeFbEDbq9i3ts2/CkBl8+r65GP1VL30DNv/tHrXGhu87uJuiW9xT+H+LcwAnePQ/YU0/YvTaLKThVM/cya+ASd1nTYXbqOEaEmZz4mgGt3X1bXgJ0XSxkdvIY2ydZEnYVhXbqN49Cyd4Rnd28N/oGACAQsLhHWjkCMWBa7dHP+xMOyuMpCnIDDn7ebxFZqihPL+XUyrk20CMwzcYuksqiEYERnitCERRu1w9YMGuYMM2cANzAU/uRtLAMEChNZcEzhegzYlb4vn4Mp1i3QyR1TwlYgdT2DAzl/hktqExtRYtnx+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BtwvjzA/ewb1RvVVeypUNi4drx7gyhMBScDEsFhNjM=;
 b=OJuv6X/okNxuYBhvw94KT+YR9rvfyUdo2BhvlshMKfWqueHmVN4rwy8M5QUxgEsUbJRZx9m6PznQdJjPs+DW4qDIC0I318pEliuaD9xdrxCeKG0aMa0V4YbcbkGWfv/bV3ZWhDzoFQOudiyDUmbNxwaZl2JNgo0D4tELXTRcUoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN6PR12MB8543.namprd12.prod.outlook.com (2603:10b6:208:47b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 20:33:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 20:33:29 +0000
Message-ID: <b5d7cb70-a373-22aa-3e1b-1018799f9293@amd.com>
Date: Mon, 2 Dec 2024 14:33:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 4/6] KVM: x86: Bump hypercall stat prior to fully
 completing hypercall
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-5-seanjc@google.com>
 <30aa4461-b5bb-a5e2-4a1d-c02d88a2c916@amd.com>
In-Reply-To: <30aa4461-b5bb-a5e2-4a1d-c02d88a2c916@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:806:a7::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN6PR12MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 564ee94a-20e3-4185-a417-08dd131094dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUprU2FDalZqN1JQc2ZJTWh3anZiaTZpUWMxeWtpRU1VTSt2SllzQWtZN2pn?=
 =?utf-8?B?ODh5K056TEE2SnBlSUhRSzdUdXdINzBUVW9BNTRJR3IzUjRDN2k0ajlwVWJH?=
 =?utf-8?B?N0xISzE5V2NWTUp2ditEcG90ZjVwbjQyWk1iVEFTRnhHMEVKaTBNNDVMWWhW?=
 =?utf-8?B?eEZGQk1MbkZlSmIwMDVCYVY0dldlais3c3pabXcrWHdIM2pjQmZKWU96d05G?=
 =?utf-8?B?VmhWblYyeUw1NmVoSjN2NmRuWXEwa2JqbldwSFg3U3hiOVVOT1lENXpaV1pB?=
 =?utf-8?B?bHZ6bFFUeDYvZGJKM1FhMm9Qa3daNlhyQUQ4c1M2RC91cFUyR29jcTJIMGpQ?=
 =?utf-8?B?b2RTeS9PeTJ3ckJkUHFFL3F4TGF5UlBOcWVXeTBJUWFCZ1dZWGd4K21RUkFL?=
 =?utf-8?B?RFI4bHB3bXNmMmNNY2haWWl1RHJ3TmxOSkxJUmFDK3ZUbUVMMkxBZUpJSTlV?=
 =?utf-8?B?L3JzSkJDem4rNVZOdE9KMDVaRmNGRStkeEh4SFBNSGRxSW5GVHZJQnJ5K08y?=
 =?utf-8?B?YnBFYmg4OUtZNE1vRnA1bC8wR2hRSzBXeTdQMTc3MTdJRmZIWU4zVWJKSWp2?=
 =?utf-8?B?ZldTRmtCTDlLc2NiVHpETGhyRGhJbTBmT3pOdXRJR1BScmMvZnYwMDliV203?=
 =?utf-8?B?ejB1ZDhMckxzcThycGJYM3g0anl5dG96QTU5NnFlTTM4NmQ3byswZEt4NWJk?=
 =?utf-8?B?LzQzQndBaC9qbFMrRmtkTTNJWU1ic2tlZElxTFdRdzFzRHVQVktON0FFMkVW?=
 =?utf-8?B?QUFvc3QzbGFveVRKdDVjQS9DaTFDUU9VbVNpRkFUTG9IclZQQkRxUkROcWlG?=
 =?utf-8?B?YXgvYVBRWmJxRHovU0JWMXRlaWc2N1ZxODRRU1VVUS91UHYyME5Mb3k4aUtp?=
 =?utf-8?B?dWRSR0I3aVlWVjcwRXVybnQ2angwTVVVRFdzRU55ZHNkR1JGT2RNSENjemVx?=
 =?utf-8?B?VFRCZXRpdmUxZVE5YlJPTGVESEtaUUxEUVdIRVRWNWZMa2xoTTdnTU8waGla?=
 =?utf-8?B?S3FsbXZPR3B3SDZmUmduN05DM0xqdDBqSFM3bStXSkF2QStMM01ibWlJWnJ5?=
 =?utf-8?B?ajU2SVMwd2J4N1hLRm5wN3IydzVlZXhSVGsxNk9kMzZWSW9oU3pKY2V4Nlh1?=
 =?utf-8?B?QVpBcm1qUDl3clJpMUpOQkh3NGc4dWNsMXFaaHVoc3VKRVZXbXRkRmRzVEZa?=
 =?utf-8?B?ZG1sZFR1V0R4end5dXV2Z1dLcDNqY0FoUzNrMHh5NjBDb2Nwa3piWTA2NG1k?=
 =?utf-8?B?Z0QyWm9GQlhCY2JZNUpLVm90cUJzcnYyYlJjOFRQR3hmZ0Q0VXgzdTg5RzZm?=
 =?utf-8?B?WE9nYnM1YW9NK05YTk5GQjBucDJFZHRnQ3BodHhOUmNOSW4zdDltZFJmUW1y?=
 =?utf-8?B?cXhYVlNUU2xzZ25UZGh2aGE3Vi8rMEN2ZFVkLysxUkZPaXdyMkkyMlVzUGhx?=
 =?utf-8?B?QmZKcGUwbUNpQy84a1puR05LMW9pSUs2VlZCQy8valZzL0FoZm40Vm52NGo2?=
 =?utf-8?B?SGtSVEJPL0FBSCtEdEM4bllUcG9QOVhFSlYvR01maXMwSXE2V3Nud1lLMWI0?=
 =?utf-8?B?WmtzM0g1cFJMbDcvMFhUUXBhelEwK3JmTjN0TGY2eTlyaW5oVkE5TnpkUllq?=
 =?utf-8?B?eHVSZHBaVGhYOGRDNXYzRnFEZTFnOVlJOU5ZdytDbXdKY1d0OWFUUVdFb1Mz?=
 =?utf-8?B?cGFVYVJaUFRCZUF6NTdneXJ0QmR4dUgzd05aRm9kSE53OXlVR2hGT0syTlRR?=
 =?utf-8?B?ZFpKL2dOdVZoOE5hZFByZFUzb09sNkVaelVFNE1BV3BtRTQwbDVxTzJYUllz?=
 =?utf-8?B?QzlyZ0RKZk9TN216SWFWdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWV4aEYzajFXUGRORGtCUTdwSENlN0xJdi9BM1VRc1dzeG0yVFZ5L2JCc3ZG?=
 =?utf-8?B?ZDJYT3UrOFZSM0xMU1NMQXdoLzlFN2ZxM0dQNk5mV1A5dDVCdWRvWjAySTJq?=
 =?utf-8?B?U0VMMEtYRWNSc256cDVzWGhsYTcrOWtDak04TXE3aXFwTElSUkZIWTdOMXdE?=
 =?utf-8?B?TnhZU2VtcnpyYVZXWEt4R0EvaytjYjI2SEJ2c2piODlpQUc2Z3dkeVFKYStj?=
 =?utf-8?B?Q25uN2FnTWNLZnFoQ0ZYaG9TcTRaT3YvS042d2J3dzFWbzZzaWRvYk8raEp4?=
 =?utf-8?B?d2lHcVZXa0lrQVIrbWRCOFhaOHl3TEFGT2dCMFA4SWJ3U2JZZE9CakplV0xh?=
 =?utf-8?B?dHNUKzkxTTNoMzRaa1hIZWozamtZdldkWGJBVzduR0tyY0Fib1BaN2xwKzRJ?=
 =?utf-8?B?T3kvelBpZDJOSGRxSDExdm1MeHpoeVRod0F0NFQ5TlVYd3R5bjA1K3N3QS8w?=
 =?utf-8?B?R25lR01nRjhHblFrZ09OWG5IdHdGSDFZbE1mOUlkVWtEekVBVVFwWGF6a0FG?=
 =?utf-8?B?bmk5MGpqeVpLcll5czBHL3E5cHFudEVuS05jd2F1eXFlMTVkTXUrc21xWkdN?=
 =?utf-8?B?d2doQnVZaTRDS2ExckhJelZwcTNkMFBPYzdHeHNnQ1RuUnBPZ05nMlZnNEty?=
 =?utf-8?B?eTR3TzdSaDU0c2l2Wm4zaXR5cjBEbktqN056VVlzL0ZMbitEUnV4d0Fjdk85?=
 =?utf-8?B?Y3QxVHdvWGFDRDNsWkNWU2pEclljWldSYUFpT0cvK3dYdFBlOXhtWXJkZ3lv?=
 =?utf-8?B?Y0NoV1lacWVodVJrQ2YrQVNUVHRpbDErc0NRZzIzT0p0SEQ2NXI3V2RQYXRE?=
 =?utf-8?B?ZHN0SjgreldBRTFlNEpVUDVKUlhac2VWMFYwc1Z1cjVaWXJIK0dMZUVOYm04?=
 =?utf-8?B?ZDR1UTZrVkdSM285bmc3NEtMZWNBOStPeW1Xb2xpeEhYL0lLcE1BTnAzWmc0?=
 =?utf-8?B?YnU2cmlhOVJZV0tTTnRzeFZKbTcwaTJFMEYxTzdxQThpM2NkckNoU2tkbkta?=
 =?utf-8?B?SlU0bVVnNUtrbFN4MDh0elNIZzBDNHBTYnZ4TnBWN3doejJnVlVueW5UTDJz?=
 =?utf-8?B?UTM3R21PYWNkOGxTWldjSXoyMUhCekVNU2RYeklNM2EvYU9BSzBBSnc1NGh6?=
 =?utf-8?B?RGhLL3RxeFZiazRMMjI2bjVjVUVlNUZrY21HdFUwNEJSSFZzc1RoMEk0OGhW?=
 =?utf-8?B?ZlFXMW1jcTRUZTBrOFllZXFTVFRnMDRGYlpQRFZqM3FoTU8wd0ZFSXJZY01C?=
 =?utf-8?B?S3RGZ2k4SGU5emRjMUo4OFJCMVI2S1JLa25jOHhxSmUrcXZubUtONU9BaVl6?=
 =?utf-8?B?ZjI5U1oyVTd6a2dnQ0NKbTFqQ3VjZW80cWVrSTlrZmJSaS9VeGdPQ2lydXVx?=
 =?utf-8?B?YkZ5aXl2NklBbVdNNjJadStURUNlTVpjL0ttZnlOa1lHTTQ4TGhwWCtadTFI?=
 =?utf-8?B?Y1hMNWRtMUJlVUhIY2NVWjIrTXhuYjdXaGJQVTdXSDdReWhxcFkwbC9ScC9O?=
 =?utf-8?B?S3RnWmtBc1dPRzlVT1VZbFU4Ri9XNU1GbUMvL1ZuQ21FV0tUcWs3R0FQaWVq?=
 =?utf-8?B?cUhnWkxoRE1OaWJTWkhiY0JMdEZYb216Y2Y5bmxaei9CQjk3Rms4dVRzKytI?=
 =?utf-8?B?dnNVdjRXK1RPQXRScC9JQXNrR2Yva2VIampFVlVXMnhtSW1TYjdiWDdtOVhS?=
 =?utf-8?B?SnowcHY3MTFNdm5Xd1doU1lUOC80RmlVMjF3NGhWLzN5THNVTDFoTE9NWXA0?=
 =?utf-8?B?K0oxSFVVbE1pdXpTbXVQOTcxb0F4NlFzQVpJU29lVlpPT0MwZC8zSWw2K3Bi?=
 =?utf-8?B?V3JnT2Z4T3I3bExHbk5UK3RwQlZDNk95SEcxYjdlclduVzBkT25YamIwWXBU?=
 =?utf-8?B?a0R4bG5sZ0J6SDVEN0ZBcGJsellvWks1NU52S1hLMTRPeFFsSjNBdkZTSWVm?=
 =?utf-8?B?Q3BiZk90UzkvTlNOaHovd3dEb2lCdzlsbGdLbU5QdzRKa3N3TE1GRFMrNDRV?=
 =?utf-8?B?RDhFd0hXWm1tTU5zaUJHVHdHY3Z1UnJwSkFsNm4zQ1phWGVUd1Jwak5PeWdo?=
 =?utf-8?B?blJFZGxYQThQM2lpdjh0RGlodnhlTlNpb0RmdVhVNVdRMW5UNG5MdkwrcU1s?=
 =?utf-8?Q?tfnid2JnE9KghagSKbyC3SNiy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564ee94a-20e3-4185-a417-08dd131094dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 20:33:29.8432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+griThCWa5316dTZPALdnbqJSSMpjY01YNrxRfGbKysIcrPFAnmWjSJkMvf5c7+Tjhr0xGn+1Sqfq3A9F70eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8543

On 12/2/24 14:13, Tom Lendacky wrote:
> On 11/27/24 18:43, Sean Christopherson wrote:
>> Increment the "hypercalls" stat for KVM hypercalls as soon as KVM knows
>> it will skip the guest instruction, i.e. once KVM is committed to emulating
>> the hypercall.  Waiting until completion adds no known value, and creates a
>> discrepancy where the stat will be bumped if KVM exits to userspace as a
>> result of trying to skip the instruction, but not if the hypercall itself
>> exits.
>>
>> Handling the stat in common code will also avoid the need for another
>> helper to dedup code when TDX comes along (TDX needs a separate completion
>> path due to GPR usage differences).
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> There's a comment in the KVM_HC_MAP_GPA_RANGE case that reads:
> 
> 	/* stat is incremented on completion. */
> 
> that should probably be deleted, but otherwise:
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Also, if you want, you could get rid of the 'out' label, too, by doing:
> 
> 	if (cpl)
> 		return -KVM_EPERM;

Until I saw the next patch...  nevermind.

Thanks,
Tom

> 
>> ---
>>  arch/x86/kvm/x86.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 13fe5d6eb8f3..11434752b467 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9979,7 +9979,6 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>>  	if (!is_64_bit_hypercall(vcpu))
>>  		ret = (u32)ret;
>>  	kvm_rax_write(vcpu, ret);
>> -	++vcpu->stat.hypercalls;
>>  	return kvm_skip_emulated_instruction(vcpu);
>>  }
>>  
>> @@ -9990,6 +9989,8 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>  {
>>  	unsigned long ret;
>>  
>> +	++vcpu->stat.hypercalls;
>> +
>>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>>  
>>  	if (!op_64_bit) {
>> @@ -10070,7 +10071,6 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>  	}
>>  
>>  out:
>> -	++vcpu->stat.hypercalls;
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);

