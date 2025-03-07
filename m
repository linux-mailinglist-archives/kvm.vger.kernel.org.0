Return-Path: <kvm+bounces-40465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C241A57519
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:47:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CB793A1214
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE5723FC68;
	Fri,  7 Mar 2025 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cPyF8gg1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1254A18BC36
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387631; cv=fail; b=KvuUwpjp0G8AUqK+sMhuaxIl9eQLKuyLu8+nPBC7R4cwl7zo9kKrx+qTET+SImycjvHzdpq/pgTKtSP8zN/4dwEWYgCUTid7BJO1CM9BBNx30orIsizfp4M9jeHL6HK855iziyeSNWf5TO/F7ls4dmgJ9W0lD3xuLhHo99uq9VU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387631; c=relaxed/simple;
	bh=5IMohWlF9o6JPuhcsDwPOLdWYwUMP/iT38nvwZzsiAc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JsYDz+bahrCCrOdQV2aJW80jpR/XkYSN6lu4yjR9J1BwnuyTdO6aqqTyGXZ9D/8dogRiRzMsYTd0617A2/FpfFgVf8Su0MZdCCj6GcGwAzGhxZgJabSxwxWj6oTGItEOZOkT77iAbXL+KmWqi2JZkkQdlpuquV/lTgSpbWt4VZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cPyF8gg1; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ECXuF5I99WHxka51G1BxAamlrgyhenxcS3rwyGqaA2D5Ij33GmXwK5+FKyhkX8syroyme+KRdU9MvMzKFdeM0XBGjFMfSUV2XAgz3dn+EP3ghVWgRpz1ilm6nbKrOswCuXpz+bXa00uewgKFj874Fa7d+Qc8+PbMnH+Q4Fg4ljNcQVh6tlHg5raXRycWfDrPWqWY1DxDiJrSeQYsfYsndo/RpHlBgJYzcnvw4S+JcvOcVJ+msnvhOgf/nE8sCJUtqRO252wc0+NBrw4oVDT7tajtF1jG743lDX6H47hTi2NIOFOY8aU+zM5lrY50qb5gaBJUXJIEGbdk/0SJV7/REA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCcvbk00RgarQgh67aNK4IkM5wTWjs5PuYUTZzoVnr8=;
 b=yhyQ/08UBuBdpmT1tJAwjImYTPmc2LLkhJp8OFM1alYm1Oh5oLQf729r6gi6vI1TlqUE6g0UOG1N66IFsvWei/GxWPVqMDtwomZ/j600DADfFcxNg3qWN3OKdf7FVWcb7Au44wIEFlgW5dU7N9QVP0Zb9xmkME64R/ykzYzLB3YKZ3ChCWpWlZ16yojZKubsSQYMgaFazzzLbIJ3Y3UW0Kqt/Sfa4F9MW/GAJM7ZmXcftMaTreEQceOwMOKnplW/6YlW0CmZIoPFPtgfsE7pq0BzUJRZPRCQcK9ihQrTn/spnbgUU0xJQcUanI+g7VhDl0L69FRjR9DLrrI8hKGwYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCcvbk00RgarQgh67aNK4IkM5wTWjs5PuYUTZzoVnr8=;
 b=cPyF8gg11MX1FDonfMn/eHrK/h4DudpNxZ44R2O7FJIjXoARxLTE7QdO1hBNLm4gLOjlr5yjabiaSpo+KCmKyC4coJchLNDHfh3ijAkV3g2ds6fuXBqpk87TxrJkvpXra6sMSKVevoDDwPOTUiNxzoYcsQepp9R0iL7rrZvTPu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH8PR12MB7254.namprd12.prod.outlook.com (2603:10b6:510:225::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 22:47:05 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 22:47:05 +0000
Message-ID: <58341c9c-d618-40d3-92ac-ee5a7f1e3255@amd.com>
Date: Fri, 7 Mar 2025 16:47:02 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] target/i386: Update EPYC CPU models for Cache
 property, RAS, SVM feature and add EPYC-Turin CPU model
To: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com
Cc: zhao1.liu@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1740766026.git.babu.moger@amd.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <cover.1740766026.git.babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0116.namprd05.prod.outlook.com
 (2603:10b6:803:42::33) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH8PR12MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: bb7b36e4-0a0e-414c-35c4-08dd5dc9fba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDR4ZzlnN0RTMW42bEZVdnR0UzM3b0plMUptb2EvSS95OGYvRkQrWmRvSWcx?=
 =?utf-8?B?ZVNzYS9PVmkvY3M1RGhrMlVHQTk3MWlJcmpzbTJvL2p6NnZ3ckJnbkJQazRU?=
 =?utf-8?B?MnVTb2FoZy9WaW1PbzVkN1hyVFZ1aWpJTnZkcGY4U3BIYXd4MmRIdi9hU3VJ?=
 =?utf-8?B?U1oxbVNtQ1VXZlQ4ckZhRzlDRnNCRVZMRnY1elZCWGxmVUFqSGFzNi9DY1Ur?=
 =?utf-8?B?OFZiaDEzeVlFcE9LK0lnVmozL29IUWl4YmZKekROT1NtVS90bFNob0s2ZjJs?=
 =?utf-8?B?OW44RzdDMWIwTTNRdTkrNDZSNXNoMzV2NitWdUl6VDY3L3ArUGRaN1dwbHNU?=
 =?utf-8?B?eGVETGl5a09wdnNPNThXNkFaZU40UHNhRlVlK3JRejYvUDJrZ2FPSWNESHRR?=
 =?utf-8?B?MTM2ckFmMy8wMmg4R2N5cWdiNTRSQmJNSktEN1o5dlNuVWJVYzY5N2J5NUFt?=
 =?utf-8?B?WEpweU9DdVJISnlhem1MS0Y0TDVWOVpyalZ1TytBMmdtZHloaXhFTXZOQzJq?=
 =?utf-8?B?YnFYTk5KUGw1dUp2clBERExidmhYVEh0VUVicGU0eHA4VTVZMlVtK0hCNnVy?=
 =?utf-8?B?ZVdaVVUweHVGeTBFSjZibjZaSFlMTllzc3g5NFhmenRJQU4zc0lheGY4YWw1?=
 =?utf-8?B?SXpqdS80K1JSaUQ2aG03UmorLzJVVEQ5aE5DRDZWcXhQM2FReTJ1Vmd5ZE93?=
 =?utf-8?B?TWVsWTNKdSt6MFpIczZMMjJxWS9JMU43SGRGTWVzNkpja2dySzBxK2MvaHNu?=
 =?utf-8?B?OXhpZjh0SFBGT1l1cmkxZWlkdU94dDQ0ZUt6bzZSaVNRQWZtUU5uT2RkbUNT?=
 =?utf-8?B?QmJ3SGNoRXlDRjNiVEd5d3o2Q0VpUklRbHJzWVF6SU4xRXdxZU9pS0NsYktZ?=
 =?utf-8?B?VTlUOUtydWhzcGY0QVVMRkZvWk4yUVFRMi8yMmhFWEIxZ1F3V1cyUjE3UXJR?=
 =?utf-8?B?QjdLcUZPcmtDSzNJRmxsVHRraEFldjY0SHRtbE1IWklrOUJkY1g2SndoSGFo?=
 =?utf-8?B?T255OGg3emZLb0h6c2x6dW1lZUp2SGZPbmZmS0JQOTlyQlJhRllCUjZ2dDFG?=
 =?utf-8?B?R2dNb0EycGpmbXhNQ0lvWG5iem1HRTNtZ1BXcUVvMnI3eTBNMXlZcVo4NHNr?=
 =?utf-8?B?UzViN1h2L1JocythbS83RVp2czJCaVZsVllaS2lXRVpRVHhuK2Q2M3V2MWRZ?=
 =?utf-8?B?Q3FCVTBsUE1UckJJZmRIS3F4UEVZUTZ4QVZFSG9Md3ZYUE5iU2pibFJlZ2du?=
 =?utf-8?B?Ny9BNEdseU8xUW85NFdkMWVwNjJndVBXa2FKYnhma09PWFhzQ3ZReUZFT3px?=
 =?utf-8?B?eGtXeWZBZmNZY1BNa2xCeWRmeVBUL292b2xVYnY3OHMyVHlyTVVUOVUwd0lo?=
 =?utf-8?B?YlhVU0tiRVJyZGt1amF2eXBrNFltMGpWcldHMDV0WTNzOW0xbjdoazR0bE5B?=
 =?utf-8?B?NUNVaEhNMlg4YkdtTlU5SVdReW43RmYvUG5TSHVSdDVqQytuYUU4SWVPcnVQ?=
 =?utf-8?B?SzJtNjk4MDFPb1k5SHhMdHhnV3ZzTnZiYkpiWmUzVGdDS29SczRtTVp4UHZK?=
 =?utf-8?B?TzhXRG5TVnNjYllNODB4OFQwVHlrZHR3QmtJdnNYWEpzek5Xd3ZVL29wWnk0?=
 =?utf-8?B?QkpRUmhIVmpzWGdwbUxhWHVoK3h2NDNHY204NFJVMDd3djRxWGRQUWxxQlJ5?=
 =?utf-8?B?R0hRaXFxVER1bGZBdDBNcCtoN1ZDTGp1YTNiUTViL1FybXNpcnh3cytkQVFK?=
 =?utf-8?B?dGlkTzZBZmFhY1VhNHQzd282UytjN3VXV3hFeFZ4VGI0WGtmVkF4cW91L3g0?=
 =?utf-8?B?VmYwenNEODhTYzdVaTdDdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekJHYm5DZkt5OC80Q3kzYnl0ZGVDc0xocEI4dSsyVlJJMG5JaHcwVlowOEFq?=
 =?utf-8?B?OGhLUHdkNjd5ZFZRNXR3MW1JUmhhVStsRmVzQ1h3MkZwSnpuQ0lYN1IrRitP?=
 =?utf-8?B?SGpRRHRHMEhVQmVLb0QzQkVyUDUwK1lySHZJcGVZN1g4ZE1TQ3UzcVhUNFly?=
 =?utf-8?B?WDhJTlhWQ3NlOExhTmRMMjZ6aGg5UjFRVXBWMGEzTmNKUDlCamM5cHBTYXll?=
 =?utf-8?B?bXc2dTJKQ21vQVRFaTJFdmM3VzhURVJrUC9MK1ZDRGxrZWZiK3JYdHY4ZGNV?=
 =?utf-8?B?UHRIYm0xTzJleHVxYWpJWnRqSU5kZzRMcWFwUlkyM3N1TTB2UlFLM055cjVZ?=
 =?utf-8?B?REs0RUR3dWhpSkZyQTd4WENTcU1PYVltc2RmT1RvaDhJcTJqZDhiVXV6WW9Y?=
 =?utf-8?B?WE5ZK1MvYWh0UlAxeUlyYm15OU9XMWlzWEFhVkVCdzYvUEdVdWJ5bEdpbkJI?=
 =?utf-8?B?bEF0L3BacmRwUVRGVktxeXVJM0luVDQ2cXVRL2dUdUdiSE1VVnlyUGVUeSs3?=
 =?utf-8?B?WXBVMzBVWHRELzdZNk9MSjloMjh5SUZNTS9vZ2owWmlLNys2eDc2SE9zWSsz?=
 =?utf-8?B?UnVjWnlvUWxJNmtyN21Jd1RGYmU1dkxnaGVCU0g0RkNWdWJZSHFoY3I3RUtu?=
 =?utf-8?B?cVlQQ25LMFdMNUZsUGlGQkFlbGp0YTZ6WUM1UG5QQVliMGpZWER6QVpqZTRn?=
 =?utf-8?B?VGREemVjdDJQSzBCQnJ3ZnZSdHFjRk9QVkJKSFM3YTdkdUZVVE9nOU1iUzJ3?=
 =?utf-8?B?UG1UNmRhYkx3NVZxZHlRSDBrRkpGOS8wY0M1OUF4SnVvV2p0ZXhlZDVvSzNy?=
 =?utf-8?B?d0NlUGpLQ25KVWRURElseXpkNGJwYndPa2ViSWlVYXFBNDFhZEYrVi9rZVVT?=
 =?utf-8?B?REtLYlZxd1dOK0FuVDdmc1kzS1ZXMXczYnNXNFBzQVZuL211aXdOT21acHE2?=
 =?utf-8?B?WXpXeUNiNm5FTUhjZWprQ0F5MkFMa3hQU1pMVlBndFNpZjB1SHV6NTdLa1dn?=
 =?utf-8?B?Nld6RUYxWlhkMkVmODRrMXJ6VDdVREM4LzQvN1hRNUN4QnNZS3RtaW1hNm5O?=
 =?utf-8?B?RDdjRWV5bFBCMysrSStWQ0hLcWM3UGdjdnh0ODBwYzBzNnhOQUdCODIwOU9O?=
 =?utf-8?B?NVNjbUhPbzhJNEtBL3g5STRRQmUyZ1doWTYyZDBXcituOU56VnNGWVpmS3p1?=
 =?utf-8?B?L0R4Q0tKZjZLbXd0TlZoL3hUcWpNRHFod29GZDVac2NyYzc4azE3ZllHWUt4?=
 =?utf-8?B?N1BIQ0NEWnJnNXBTVWZuRnVWUm1YaFdmNmZJSk5MMVBGNGxtOHRjdkJPMGJY?=
 =?utf-8?B?Sk5JRzhSb0JkRWdROWQ1eXpOQ1RwY0xFUnFSVEVwMzdrYXJaRnA0Mk9zb29G?=
 =?utf-8?B?b25HTnpBL1plQXRFblBtTzRIQXhxQWkrblNXanhvWk16MmYxU043d2RIRDRh?=
 =?utf-8?B?bUkwWDhVQlkrRFBjNHVVdGlXN2x2ZjhJOEpmNWg4RVVwbHl1NjRXbWRsZ2s5?=
 =?utf-8?B?d0d2MkdxVnh6MmdJaURPOFFNWnMvelFEbHlIbUErcHNENkg0MTdzMi9kMnZ0?=
 =?utf-8?B?WlZsWWVQNWo1NDdkQ1VGaGNMaTB0UjM5ZHhMOWNVZDBZdklJMm8vN0JER3Zs?=
 =?utf-8?B?TCtHNUJBTUNWMy9PQWJBTGwwTXJMSHhXOTVmUGNWVFJ4V2F6YmJLWlRUNDdK?=
 =?utf-8?B?cWxhaDBZTHlTQkZwMzEvTUF3TVc4dVZlejY1bS9Icit3VWZ2Z05vVUV3aEFh?=
 =?utf-8?B?Yi84UDlNNWJJYndMRDYwaWs2OEp4NWVQdVpmNFhURGxvOVRiOEt6Y0VsMlJi?=
 =?utf-8?B?TCszUEdDK2loTFBNdjZ3TVg2L2hwTklSU0gzZzZhajE5RmxaT0VhMHk3VEN5?=
 =?utf-8?B?cDhqemN1T0p3TnVZMjJtMHBFOC9BTWw5di94Z1ZnZVR0WmtnM0FxcVhNd0VJ?=
 =?utf-8?B?WTNoY2NMQlY3SytKNzNPcHFLcnNWaVpPOVc5TXNHdjREaFYwNmFwTTUwMi9Y?=
 =?utf-8?B?VWloTDFrMGpiQnRTckRiRmJ3S1I1YmdzZ29pSXpOdHlzeXVKdzZsbTR3RjVy?=
 =?utf-8?B?T2RBQm8yeXh0Y21zUFBPTTljdzVOOUhsMzFUZGhzckpoUXEvK1JGdFJWRHgx?=
 =?utf-8?Q?7obyCG7L3H4SzY6QPDqjNvwCY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7b36e4-0a0e-414c-35c4-08dd5dc9fba2
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 22:47:04.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zAPGAVVv7wPbX798QLwY4fpWucmHr9tYomiMtBlEZN6kIAsSpRJ1o/ehY8oBp6z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7254

Hi Paolo,

Can you please pull these series if you don't have any concerns.

Thanks
Babu

On 2/28/2025 12:07 PM, Babu Moger wrote:
> 
> Following changes are implemented in this series.
> 
> 1. Fixed the cache(L2,L3) property details in all the EPYC models.
> 2. Add RAS feature bits (SUCCOR, McaOverflowRecov) on all EPYC models
> 3. Add missing SVM feature bits required for nested guests on all EPYC models
> 4. Add the missing feature bit fs-gs-base-ns(WRMSR to {FS,GS,KERNEL_G}S_BASE is
>     non-serializing). This bit is added in EPYC-Genoa and EPYC-Turin models.
> 5. Add RAS, SVM, fs-gs-base-ns and perfmon-v2 on EPYC-Genoa and EPYC-Turin models.
> 6. Add support for EPYC-Turin.
>     (Add all the above feature bits and few additional bits movdiri, movdir64b,
>      avx512-vp2intersect, avx-vnni, sbpb, ibpb-brtype, srso-user-kernel-no).
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
> ---
> v6: Initialized the boolean feature bits to true where applicable.
>      Added Reviewed-by tag from Zhao.
> 
> v5: Add EPYC-Turin CPU model
>      Dropped ERAPS and RAPSIZE bits from EPYC-Turin models as kernel support for
>      these bits are not done yet. Users can still use the options +eraps,+rapsize
>      to test these featers.
>      Add Reviewed-by tag from Maksim for the patches already reviewed.
> 
> v4: Some of the patches in v3 are already merged. Posting the rest of the patches.
>      Dropped EPYC-Turin model for now. Will post them later.
>      Added SVM feature bit as discussed in
>      https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com/
>      Fixed the cache property details as discussed in
>      https://lore.kernel.org/kvm/20230504205313.225073-8-babu.moger@amd.com/
>      Thanks to Maksim and Paolo for their feedback.
> 
> v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
>      to EPYC-Turin.
>      Added new patch(1) to fix a minor typo.
> 
> v2: Fixed couple of typos.
>      Added Reviewed-by tag from Zhao.
>      Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")
> 
> Previous revisions:
> v5: https://lore.kernel.org/kvm/cover.1738869208.git.babu.moger@amd.com/
> v4: https://lore.kernel.org/kvm/cover.1731616198.git.babu.moger@amd.com/
> v3: https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
> v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
> v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/
> 
> Babu Moger (6):
>    target/i386: Update EPYC CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
>      feature bits
>    target/i386: Add feature that indicates WRMSR to BASE reg is
>      non-serializing
>    target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and
>      SVM feature bits
>    target/i386: Add support for EPYC-Turin model
> 
>   target/i386/cpu.c | 437 +++++++++++++++++++++++++++++++++++++++++++++-
>   target/i386/cpu.h |   2 +
>   2 files changed, 438 insertions(+), 1 deletion(-)
> 


