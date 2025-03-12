Return-Path: <kvm+bounces-40829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E6AA5DD66
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 14:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F2583AD968
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 13:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2C1245031;
	Wed, 12 Mar 2025 13:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ldLbvTLg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2043.outbound.protection.outlook.com [40.107.101.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6941DB124;
	Wed, 12 Mar 2025 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741784886; cv=fail; b=t5+/ibESz3wpb8u951h0v6Ca6EZHktCqBRRb/u/ASMuCDysS8qDfeRExcmttAKXv9YKdHWTjSapg+pM7MmuNXiAyQFsynvwVN6lfazTOQraOe6ycmU1HG4H86IOV19zfnaSlLESI/PbvU2FRcrVqBb0Lfs2dZJ2rvfrZNZL07i0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741784886; c=relaxed/simple;
	bh=SaFxvnvp0y2/2+3MWuf18EqsCBxfUAMLEbIrIVJ8gxE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PaVQ4BAzlcl20g6t6Bos8BZH+SZ/ggdrBD7kqWbpDdDDVc5NUpYpULYJzca/eh2qyfNLj+LnF8pCNOAgMmbJnisxKQACtutZvh/SmsRU1dQNIR4YSohORuuMQFgQg4Tj7CAMbDnx08+iFllCDdwste/NdxsrFaRl1KdrjFs6Jws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ldLbvTLg; arc=fail smtp.client-ip=40.107.101.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubIb0wlOdfj+Yf6wELOEuMGfI06PuTCLTpuUF2S33g96KHn5wlZic0q3PUbLJoBQP/Q8SAzVE64IaQK6MsjaZGdH0UWssyfdHj8Y2D5HiuNMuFyX0QtvqIzAaDTL6JxbWvbnZKoQlUmNMu28TkZqsNlLY0A//oX5oPz5gLGldFBUZimkasE8BRg21NKLFr2GPHFEQLLCJN18++i26xD/+rB8z0L7YfqplC2jlcJLpMG6cbRsm0UEVVwkEtT/fh2pT2Z49SNlu35El8a3iwZc5esSASlxf81Ym5FNgQiDSYg+sdE4HkVadWrmsAriOfTFz2LuU+IvGdEmpWb4stD7pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOWhFLIYhDh7Kd8ccJxYno+3c38cBlq2cgyupPSK4Qw=;
 b=RY3syWFO2uVJNk0cTtt/I0aG9/fytWqNLM3bWVKCWrMksxcxo95v5N2PWUZb3bhZGnrP9qQY8DoZgF3BCAQ2CtfwCpnxBQRVVcM5xfYJMzZkURjaAnhoLW6TKk3n05aqODbdWMfi7H5+bqkV0O0ykFwpaELaQMNMs2koqAr5XWymeQ/IOusxEhz9MvI8MUmjpYsXh1KNwztDAM/gAuKMR2Wu/hdCW6kd+crvuIZXFH4v5IBrrAZ2quua0XOJ4hVLRJ8FanS6zl5+EMJcOdpQmvK4d4miDRibQH6pAYPUFfpophaK1XP4R11tDfiDavIMbuPsPgj9HLPnhxGm+1qn+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOWhFLIYhDh7Kd8ccJxYno+3c38cBlq2cgyupPSK4Qw=;
 b=ldLbvTLglOgpZR/VYgraz5+7+U8DGM9Fb3UzZjM1/thSLMTO9kYo8lggIIzq5jfERwZdiE6BPS2C1hp35/t7qU9n65QwHudgmUdjuVT0pDEHJjUJF11T7lJtZjxS/MYP5wUU2fz0ccUd9Lmif/cA6sfulSzNNJJ5l+hko/9kWmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by CY5PR12MB6058.namprd12.prod.outlook.com (2603:10b6:930:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 13:08:02 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 13:08:01 +0000
Message-ID: <9f857e72-7992-4c37-af51-bea059092c2a@amd.com>
Date: Wed, 12 Mar 2025 18:37:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
To: Paolo Bonzini <pbonzini@redhat.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, chao.gao@intel.com,
 rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c6cea2d0-80b5-4d05-84a7-0dc25c219d1d@redhat.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <c6cea2d0-80b5-4d05-84a7-0dc25c219d1d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0042.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::11)
 To MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|CY5PR12MB6058:EE_
X-MS-Office365-Filtering-Correlation-Id: 695d6e66-52fc-4f54-cd5f-08dd6166eaa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3hZaEVkeTBKMGI1OFkxRE4vbGZhc3dQYmVmRFl6aDlTL2EzQnR0R01iVmpQ?=
 =?utf-8?B?MG9GdEpVTy8yYUxKSzYyY0Jhbzk2REI0RUVvNXlxQnRQK0ZJSEUzWUx5TWVy?=
 =?utf-8?B?aWZqdmI0dXZFbnhWSWtzVzNsS3UwYWpLeHhjajFPUzJqNU9DbVFzd2hDbU9W?=
 =?utf-8?B?b0pDL245ZFFqZGduanFNOE1jSEJVVnd3TzY5WWdiWlR4bS9mbUpwTFlTQkVO?=
 =?utf-8?B?V0k4d2pUakJCTU1iQndyOC95M2JuTXNTY01GWGxTTGtSclpzNHovTUgySG5O?=
 =?utf-8?B?TTU5N29mNGk3YUJ1cVhQWlNwNEhhWnJBUHdUOWZRSTljSVovbSt1ZkYweml1?=
 =?utf-8?B?eENMRW9JUGUvclIvV0owRTZGZWJuSHdXdUJPUy9IWGdSZTBBa1EyYUVlNlYz?=
 =?utf-8?B?SUxnQUFnWWJISHZFZUhTczFSNUpHNWoySW9ZZC90S1hFeDRHcGMzNVpqTlMw?=
 =?utf-8?B?QUNTd3UrRTNuL3A0YVVvN2dZMm41RU05ejZHR0svM01ZK0JGeWFoMFFad3li?=
 =?utf-8?B?QVQyRjRmaDkxWERub2VvSVZPTGVaOWVLTzRYY010UDJMdW1MN0N5WjV3ZXI5?=
 =?utf-8?B?YmNNR01EK2NGb05Yb283ZjlHUlpKaXMySWt6SFNmRStFZlpiVWZ2alVJcnVR?=
 =?utf-8?B?dW1XSVdnbXRRcjhUZHpXMVVJekFJUXUvYVNNZzRNWThxSGFyQVJQVkVmMVRF?=
 =?utf-8?B?dzRwYkNVQy8vTW5GakRMWmR3clowL0phcFltMXVZM21vOGFDeEhPM096UmlN?=
 =?utf-8?B?citlZllUSDc3OERwWDRyNEl3L1Uwb291TXRaS2syank3MXlLWWwxbFMzSTlx?=
 =?utf-8?B?aDFVM0ZBZ1d2d1AxdVA5WlJObGpQNUxma21CL2c3dDF2V3RKUHdZUE9HT1RC?=
 =?utf-8?B?TStpdWxlbDZTaVh0S1VTSkl1MzJJTGhZOStnam9GQk5pTDMxS2RUeW1FTDBK?=
 =?utf-8?B?OWFVckM3N21uY0dvTjNiVXlLMFVpeUpYVmUrZ0w2MzlOTW1IaVI3Q3hDdmlt?=
 =?utf-8?B?aWJ0S2pzL1JpaVh6VTlCS2dIcVRMaGV3NVRQLzhjTmhnZ28wQTlMOHRwbm1W?=
 =?utf-8?B?bGsvNi9iRDZYT2xsMFY3UkViS01VNUV0K0pYbVdXZ1h3aXlET3g2YXIwMUZZ?=
 =?utf-8?B?QzdpTzBiNXFSUFVHMnlJcytRSWRlRXl2bFNZQjIxd0E4ODFxOXMxclhDWkFa?=
 =?utf-8?B?ZVdzSm1FQVlCSVRKVlVTTGVmYVBmSnMrbUlDeUpMRVgwWjNKRVF3RUVOVEtn?=
 =?utf-8?B?V2VNaUlrcmlCNkVNUFlKQXI0alRBMlFiZVpYVkVsRFNTazN0ZDBXTXUwbEEz?=
 =?utf-8?B?VC8xL3UyVmlLMThkbzlUVjNIVnNjY2ZjdGFONThsNEJqQkhpWUkxWTFuMmNV?=
 =?utf-8?B?aW9MdXhuczdQUkpYTVNuZWYwRFhSMmZpMG9iOWlNbVJOcndYZGo0TFI3Yk5l?=
 =?utf-8?B?Y3Z2ajFNNVpUUi8zMTZ0MTExV0syQXBSdDZtMFlRdWNrVHh3d3AraE5IU1JR?=
 =?utf-8?B?NGpqMERBWjR5RERuTUROVThpTWtjOVRDTjJIRHhnYUJUMmZuU09IcUZ6aG4w?=
 =?utf-8?B?YkZIN1JIOTM2VjdIU2pkUEhwV1FIL2FoWXRiUUpIblg1Z0VnSnN3Nk9obVFr?=
 =?utf-8?B?M1V4YzZ2NEZaYnFURHVpMjQrM3NlaTgvWk91QWVFRk1QcDFaR2hRdFErYUVz?=
 =?utf-8?B?bldWY3hlOW1aTGd0dlFMTzlsTTBCVk4xaVFFOE5IWTFVcnNpTXhISzRVQjFk?=
 =?utf-8?B?ZUNhdWZsUGlmOHd6V1Noa0xEcUdjWk5tMEY2MFlqcklnWXBoYlQ0aHdWZWpi?=
 =?utf-8?B?cnpnRk9lSW1lSGVoQUNZdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEZnSEVlaWo3U0RqSzBINXpXY3BqU2FqYng5aU9nZFdjcDVxS1VLcExTWmtx?=
 =?utf-8?B?Y0plcVoyQlpkNUQ5MEc0SWlkQ3hsYzdGcVZLNFA0ZEhtT1Z1MmtkTEhESitz?=
 =?utf-8?B?emdKSnZhL3BXYnBsNWRraThrUmpSUkZQdkw5bUxIYTE2Y0FXUGVxTVExYkMr?=
 =?utf-8?B?WFhyOEUrNElMTmtMc0dHOWJqV0J3WG9Zbm5UTXFYYUY5TGNDbitITlJZeDQ5?=
 =?utf-8?B?ZDl0Q0tjYjN5dUVaNDF6aWt2NjFhY0VtZnVvcWJrdDJJTXR5ZHpZOXVpWkVV?=
 =?utf-8?B?cERDQVZTczc4NEsyRkljVGVUSVF3VFFVQUpqZUdTT09mblRmS2VhL2FMNEt6?=
 =?utf-8?B?MktkOFYzT2NVVGFJaWFGU1ZWa1pnWFhpUTZCTVpCTG1HakJtTFdKbHVNWlNx?=
 =?utf-8?B?b1ZzZFRKSC9LNURmTzlxRVRzZjZ4WEFXSkh6ZUVlUElWT2xHS1JUdFpRUXV4?=
 =?utf-8?B?V0ZjUGVsaHE3MGw0dHJPVlRHdzdoV1MvcDZsOWUxdDN0K2w4cHl1TGpBVXN6?=
 =?utf-8?B?NUhDVGJhM3Ftd2tjb2lLQnB4RlJZVTN0cUt6MXU3OVZ2SGtxdXZKbGRCOUoy?=
 =?utf-8?B?Qm51U09Balk1V2VKV1UxQ0EvK01CNHFUd2Y1cnpEMWJlK1ZrRW5tY3ZKNi9k?=
 =?utf-8?B?azcrcEdKcVlBSnZhQTMzUTRpOHI3T0ZCeHFBS2trcHpvVHFuejV5MnozTzZt?=
 =?utf-8?B?RllVVzd0RGc5aVJFZkx5dW9xRVAyeXdKR082bzB0cVU1SFJXMW05bDZlMTNX?=
 =?utf-8?B?ZUp2SEdDdk5TcXRPUSs3bVZnM3kwZGVTS0tEdnBhaVJZb1V5cnVPZWw5MkFl?=
 =?utf-8?B?bzcrY1J0VnZFVEpIa2FtcWYwT1R6MzZHRmIyWVZCenVCTE1vRllJUTdsalBz?=
 =?utf-8?B?ZFg5Qms2N0tBY0tpTEdicHd3TDh6ODlVY2d0MDh6VTN5N3Y2N3lBOGxrdzd3?=
 =?utf-8?B?OEdGb2xIZHU2cUc5aXoxbjNVTml2MmU4M1BHVVpXWmVwdkZMelVrc0V2MTlT?=
 =?utf-8?B?bWw0TUdMbWhXT0pWdjJ6L1ZaN3BhRHQ0d1lvZWFDYXl4VHJMU1RUckMzTjV4?=
 =?utf-8?B?Mk9uaEViaXZMb1pyU2tjZnAwWTVmVWRhRWY0dkRhYWQvZnZsT2g5QnFVQWhi?=
 =?utf-8?B?bUIwdDdVZzdUTnB2WVZ0SjF4M2lkUitTUno3NHpQZWxvTEtaN01FQ05KN0xR?=
 =?utf-8?B?NWhtaG1iQ2V5UVUvV0pIVHUrTDhVYUhMaStKQW1Ub1VrZjFodnovc0RLc1hM?=
 =?utf-8?B?RUR3czIxTUJLZEhFSmh5cXUvbE5FM3VXV3poMWRXbS9Qa0lGenJsWlBSSjNn?=
 =?utf-8?B?OURtK2ZYOTZnZWtvalhmN29iQWs2dHU0a01JeklwK1NjMmpvMGJIcXNpUU1s?=
 =?utf-8?B?L3Jjb0RIUEZacXFycG95WWNGVXdxNWlkTDRQL2U2YnNUeTJ2WXdxd3BkekZS?=
 =?utf-8?B?cWxpTCtvU1BiR2dWT0Y3dXZrb01zSE9ybThMM2M1em1YWkRqMEtMQkhoRmQ5?=
 =?utf-8?B?TVVydElmczhGbXhCZEVXeGpJZWJLWEQ5clNYMXFqZUduM09CSWRjbGtBS0Vj?=
 =?utf-8?B?cmNIZXcwYmhBMThTb01ocmhuTk1HWnhXMXY2NHVrMlU4bStjU2JNeVh6UkRI?=
 =?utf-8?B?S09Cbm5mV3JQWTN2aGdhWHo5RVR1enF0SjdoV3BtZjY5RElKYk42QjY5ZEZ6?=
 =?utf-8?B?SEdJWlhhcUcvREwyT0xQNmZmZE5lOWsyVk52WE54K0JXUDFiejZRa0pPU2dw?=
 =?utf-8?B?QkhjUXhBTVl5M0g1UXR4NTFtWFF2R2JjQklLR1FpcVlwdURpaHpCaDlBV1hF?=
 =?utf-8?B?Y0JpNXdSdE5YQmlSb1MwV2J1cjNWT1djbU15L0V6U2J5S0k2RVRYR2NBVTg1?=
 =?utf-8?B?YlUyNFFScU9iQUFSK1VWWmkvNGFwNlFGeTNPSEJXZmViOGxqVkhjTUliSlR3?=
 =?utf-8?B?bE1EM3NGblZ6dzlvSDRkMzRoWFJZaHpXT05ySU5rNHJYR3RFUW1hMk9EMkIx?=
 =?utf-8?B?b2t3SGR3K28wR2hGYm4zUDFqeWRmRllvTHZaSzArdVEvWlI3dXRrQ1A2Z3VV?=
 =?utf-8?B?dmF4MTROUlhRME1BT1pOZWxST0dFaUUwOFZmZjNOM24ySFJiSmEyWStlREY3?=
 =?utf-8?Q?Fw75/WlgyfE5AAjm6clu85F9Z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 695d6e66-52fc-4f54-cd5f-08dd6166eaa9
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 13:08:01.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8RKXrrBqwolHJu6ZvzCGCpJ0pez1FrtVwgGUSj7Xo2PAdfXc/PUVEscUBQ2bJW3yi0mhEVD34HZOiaohNEBpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6058



On 3/12/2025 5:52 PM, Paolo Bonzini wrote:
> On 10/12/24 09:55, Isaku Yamahata wrote:
>> The current x86 KVM implementation conflicts with protected TSC because the
>> VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
>> logic to change/adjust the TSC offset/multiplier somehow.
>>
>> Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
>> offset/multiplier, the TSC timer interrupts are injected to the guest at the
>> wrong time if the KVM TSC offset is different from what the TDX module
>> determined.
>>
>> Originally the issue was found by cyclic test of rt-test [1] as the latency in
>> TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
>> the KVM TSC offset is different from what the TDX module determines.
>>
>> The solution is to keep the KVM TSC offset/multiplier the same as the value of
>> the TDX module somehow. [...] Ignore (or don't call related functions) the
>> request to change the TSC offset/multiplier.
>>
>> [...]  With this patch series, SEV-SNP secure TSC can be supported.
> 
> Thanks, I've squashed these changes (apart from setting
> vcpu->arch.guest_tsc_protected) into the corresponding patches in
> kvm-coco-queue.  Just one small change is needed in patch 2, to
> which I will reply.
> 
> For SEV-SNP, all that's necessary on top should be
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d92e97baea0f..beddeed90ff0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2481,6 +2481,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>          }
>  
>          svm->vcpu.arch.guest_state_protected = true;
> +        if (snp_secure_tsc_enabled(kvm))
> +            svm->vcpu.arch.guest_tsc_protected = true;
> +
>          /*
>           * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
>           * be _always_ ON. Enable it only after setting
> 
> For the sake of testing, I applied the latest SEV-SNP host patches
> from https://github.com/AMDESE/linux-kvm/commits/sectsc-host-latest
> to kvm-coco-queue as well, plus the above hunk; Nikunj can integrate
> it in the next revision of
> https://lore.kernel.org/kvm/20250310064347.13986-1-nikunj@amd.com/T/.

Sure Paolo, I will add the above changes in my next revision. 
Should I rebase the Secure TSC host patches on top of kvm-coco-queue ?

Regards
Nikunj

