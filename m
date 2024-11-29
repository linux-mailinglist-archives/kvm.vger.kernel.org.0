Return-Path: <kvm+bounces-32767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA5A9DC0F9
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 10:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D089B22C9B
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 09:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77E91714CA;
	Fri, 29 Nov 2024 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o4c8nOWq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082CE1547C6;
	Fri, 29 Nov 2024 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732870877; cv=fail; b=o7S+Q/rDoRBddwewFFUgBEZkLFj8d7aprUGQ9zWMUWjREuBvlXE3FGxHqel2ja3JERTjPmM5Pw1ck4WDUm3VtZ71CcMMpjffwpcp4Wy9BICpC2hJRf3n3B9dXD4gBIWUxjC68yHhaVitSa8GdgnJMuAmFxskAxHk2ibx2V6j7i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732870877; c=relaxed/simple;
	bh=xTeDxebHv8fWG9YSTpeLIY/0HphDy10PLskq/kbRjbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S8m0JY1lfrTmxCOLYBdzeAV6ofSO75AW/HhCiRAtS5qatLUSVDrC/KMqC5ETsyEBz7QAESl2c6sWsXMAVX80B2vC92OyND3gKSyXlx/32JIUXybYr7wPWCpXiuypq88B/jF9ZTzDDohVIvrE1CHwbbsvqHKapvrU3vLaWoVHigg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o4c8nOWq; arc=fail smtp.client-ip=40.107.96.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/QBQLTuJ76gS/FON+LXaNS6foHD6Ld5/zfn0u8hIbK6qhus4LFHBZTb+KipIdgjyBFK0G5r9brzr0lFBk5CDADGOmqCA+bxfuhzMcy0ZHIa2xPl4eh9zP8h42JqBYrjt+3KXd7CxxrITRYkgZmxKzU/1EN5zc4XtIMNJJocioF8Hi0N3xPkgJy+CkgpE7o7H2RkjNCmUwj2RKqB3LqHgFSCsLN9+DsBsgPEJWnelmMuCnCtfaiQInZ08O/VxRwAdKgF5xglj69K4V+iqiy9AT/2WiIEvLl7SMXUxwRWA1eoQ173BSdjunD0kjnXL7u0RTKV/O9225lDvBduIIUABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loz+qmvkIlfcbvQ6Yr+c21YNpKRJ0+dcQFZcFMbpmZ0=;
 b=pzF0/70RKzgzps0WspukDlcXk/dr89gwl4CYelOJYreSOf3ajQ+krUT0WgpJSupDrociXrr8mi2Y/6A3dtFPGedOD80kwTsvxHHWSP1gQN6y6NN8rXywciPvKMbJU4VKhilic/9ILTR1QfG72Nnayjq84rhCnsNB/t+IHSqcylsr7HLMmww0iHAvwlypquCA9Wt5w8ehA3PzXV5YF0Higs18WqKLtqMrKZYiFbu/xg51Q5jgyjTQ1lX4OhjZG7b1K2yXX9SovvItkxFJkQ1Dz/3OhzAVoCk9QOa1KjAKN+cTx3wQObPri2WlYudNPUEmIl+e1aj9vQgSGk8+T969sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loz+qmvkIlfcbvQ6Yr+c21YNpKRJ0+dcQFZcFMbpmZ0=;
 b=o4c8nOWqnVvyk4d382De9AQs4R+sC+XzZHhQIy839PN7cbfIAI9w7H3s01fOET99q7x+5hBAp1dG2O1fVrw901UmHlX3g2DY8pJDIcet02tdI8TIZiYiP/cvJHSWvgH+U+DMXeMFkznH0QQokV2n84lDJKFeLS+Xd6SJ9hqHBrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB7854.namprd12.prod.outlook.com (2603:10b6:806:32b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Fri, 29 Nov
 2024 09:01:13 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8207.014; Fri, 29 Nov 2024
 09:01:13 +0000
Message-ID: <e263259c-065e-43f6-8d5b-626e978cc6ab@amd.com>
Date: Fri, 29 Nov 2024 14:31:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] KVM: x86: Play nice with protected guests in
 complete_hypercall_exit()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-2-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241128004344.4072099-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0162.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: 30edffe3-c2b6-4ee1-06c1-08dd10545fe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXIrTmNsbjNNYU5MUlNPSDZ3ejRhTUhMUWxYQlRZSWJsL1pMSUo0bnNNUFRN?=
 =?utf-8?B?ei9VODlqdGI0eDJySXkzbSt6a3ZkaHNyUkVUbVkwRkRUVFE1ZTUyQzI0Ukh3?=
 =?utf-8?B?UUVwWGcvbGIxQTRqL3JsbDNSQ1JKQUhMWHhtNWhldFVPSEFFOWxFbnFTNE10?=
 =?utf-8?B?YzlZNGRZeHVIUlFkSllYRGpFWnVWZllSQTFpVTNPVE4rOXJiREs5NU1aazZu?=
 =?utf-8?B?Q05VVTZrejkzL0RxWHZyeHB4UmsxV0wwUEN4OUdMczNGRlpFMk5peUJUWklp?=
 =?utf-8?B?ZWw0dGdIZ1c3VG9tNUVkbFJlQ3VaMXhUbEJzU09vZzBTLy9xRFBKUFgxQkFG?=
 =?utf-8?B?bTMvTm5lRjMxUDgxSGFNOU84cTZRbjFDUTUyWVlSWEJwYzBYS0FQcTVaTU9m?=
 =?utf-8?B?QjMxTDg3RmY3eXFwdEY3d3NVSkc4c0VoQWVjSmJtWE1XZ3BaYmQ2ZU83bzEy?=
 =?utf-8?B?MDRtcVBKL2hOSzQ3Unl1a3FjS3A1ZnJQQUREaHRJQ1lKV3NHWThuQ3ZkNUNQ?=
 =?utf-8?B?U2tEelQ5QVRJN09zOTFSZ2I2Q1REdWtZWGd2RnZKdDZBQ1M0bGs3dFVEME9I?=
 =?utf-8?B?Nldzb1dUYUhqYzRRSXMvV2JCM1hyR251UFd2ZnhjaFV6TEVldVZ4QVhvYlkv?=
 =?utf-8?B?d1dGY3lWa1A5TmsxWmloV1FqUGszenZDRE0yWDZwc3VWTlpQeTdYZ3FUcVJ3?=
 =?utf-8?B?Q3FxTXRxZkN4U3h3Vm50OHAyazVpMXBxZnNsdm5Gc25DNFZLUjdiY0JZQytB?=
 =?utf-8?B?bmozT2FtV3psSHlaN3k1ZkhCQVV1MU5rSUFaWkxEV3FUbEZUOHFGblhGY0pp?=
 =?utf-8?B?bU1lTWFuWmZlZHNuU3BLZ2twZ2R2N2VSQ0o0c1lrY1VnOGlISlpuVUVFL3hI?=
 =?utf-8?B?MVhBM3ZodG9XNVVFYVNyaHRpL09GTmw3QUdram9GSDdHZFc3aGJKS3R4MmRx?=
 =?utf-8?B?RXJIMm5JTzVNcDZ3N0h2cTBJS3hzNHZCcS85Z29VMW9XR3FCYk5YYXRTZTZ5?=
 =?utf-8?B?dmVIQTAvZG1iRVFBRm9MUnhPS0F5bXhOc3JNSHNNa1U2NkhxV21wTlpMbVZM?=
 =?utf-8?B?K2t6Sjczdno3RGlwTFdCbkVhNHdWdnAzY3BMdTdGWGR2elNhVGlTVmQyTW50?=
 =?utf-8?B?QlVDdmt5bm9la0dKZERQbUhhZWZ3S2huN3RRS1htaDluU0F3eElXWVgrZEVl?=
 =?utf-8?B?N25FMlIxZkpGVTBJT0FwSzZXc2lNQVJ0Rm13dE5na2ZVcVZwNjA5S09vZGhU?=
 =?utf-8?B?ZU9HZDN3QnVtbmlRcEl0bURGaGNZU1htY1ptUmd3L1ZNL25WRlFSbnh0TFlF?=
 =?utf-8?B?b2duWjdDMEVoYnlvVTJEREhRM0Erc0dOejZnSDZKS1E0SVBqbjJSaDN5RElw?=
 =?utf-8?B?L24yV0JySjMzVjc2U2tZU3dwZGo0RU5NVnV0UXA0MVhMTUxwVlN2Y2hsaUp3?=
 =?utf-8?B?aWdkMWRnYTNzMmxuaEtyeHErQktab0VRQUFDTmhVc2NwdzlwMk5iWDRwamZC?=
 =?utf-8?B?cllDMmtoWEl2MXpnQy90cllyT3EvZ25jc0YwWm9YSXZ1Y0pERGZTVnZ0ZEpj?=
 =?utf-8?B?TUFBeUhrYnJRd045bVlqZUdPM3NWc3B6MkhwRFlJVWFTb1VYbTBRenNmRDVx?=
 =?utf-8?B?SUhuY0RGaUU3cFdabkxON0piYnJqUjVxdU15c1Z6UkJ2L3lHMnVqT1ZiM0Js?=
 =?utf-8?B?OStZclBOSks5ZGg0c3VKWEZVRkpBeUZSWEY2Q3d3eFRnT0hMRzRqRzMzYk0w?=
 =?utf-8?B?MDZEQ2ZOVFZJdkc2dk5ETDNyZCtjSDVjTjFQemx0d0FXd3RwTWVOWXNqTjA5?=
 =?utf-8?B?cS8xaDRvSDNGd0ZqOWVPZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3hodjlTMTdsUzE3SWNHRUU2SXNrblRwZC9zUVo1UjBtL2RkREdOWVZqRGZx?=
 =?utf-8?B?ckt0QlRxdXpzZWlvclljcmtJMUV0aWRlWTRiMVo4c1hrc1BCMkwyeWd4Qm4r?=
 =?utf-8?B?REVhQm8wek56YlFlZ2t0SitWZjBCWkRNeitMeFVCODhhNmNmc1pLb3F4M3Fh?=
 =?utf-8?B?NGdJb1JRQUFub3JhL2p2N0FXUTNWcFFLU2NYNVhhTnAyVEdsL0I5SHRYYlZB?=
 =?utf-8?B?bElQTFdoVVpmWlB3Uk1Jem5TYmxSTjNkNm5oVUEzVWxzdUJFc3lhUkZaOGhw?=
 =?utf-8?B?dWs3QUhUWFNhRS80T0RENlk3cHpjMFhocmU4OVNpd1JWaitsVDNKYnkxSTA3?=
 =?utf-8?B?R0dKMzhkZlYybFluZzhuRVJOT3hSYVJjSGdmV0k1bHR5cWRmaUVXbnl3blNV?=
 =?utf-8?B?dEFpMEsxejdpN25UdTljdGJtQWJOY0M0b2dKaWcrYlhURkR0NHRYTllwa2Ny?=
 =?utf-8?B?SFhDMUlVL0d1c2hPbWRSV0daWk9tUlZCVzlnTFJLalJwMVBEbTZmV01GbHpm?=
 =?utf-8?B?bnFvMEJ6T2lISjdxdmRpdWFoOHpjRDluTXRyaU83bGFGRGxFTHh1U0lxMDdO?=
 =?utf-8?B?ZVk4aytxRW9HK0lSUjZoRVVuUjErREpHK01RRmkwMVVvL0ppd2JiVkZFeHBK?=
 =?utf-8?B?YnE4Rk9mYnlSOHBPYW5zcVFiUlhXWHlEdndlcWMzVzZMbks0ZXlmci9mQ1dM?=
 =?utf-8?B?Nmd1ejY1ODdCMEpaMnNlV3lmUHJGTXdBbXkrZjlmcDRxaS9TZzE5QTNMRllr?=
 =?utf-8?B?aDFzUFFxY0pzNmE2SC9yRHgxOXBma3dUUFBibGxmS0lxaVB0M20ycG5Ed3BU?=
 =?utf-8?B?N01pUmw0dm5YU0RUbjZvcVBrb200dlgrWnNYblM4dTJhTFhJWTNxZmRKT2dp?=
 =?utf-8?B?cGJySy9kNDFqWVJHS1FVbXdodXM2UndXQkJNaUpBUy9hNWdnajYwakNkaFdH?=
 =?utf-8?B?dVBYS0RSYzVSOE9tQ0EwMWd3a0pNcGl1LzR6QUpHRi85VlVYZ2VYcHE1VVV3?=
 =?utf-8?B?OUtqdmJnSXVmT3dnRmU5Tk4wREd5ZnNLL0NxVVpzcitOWlBQaFM4VDRNU1Jn?=
 =?utf-8?B?Q2daN3ZKQlM4WkR5eEN4WE95aVMrdHpldDNiM2JlTlBlUFNYbW54U2VUMVF6?=
 =?utf-8?B?QnRBTHFUS1NDZHVlVkVQdFF2UW9pQlg5Vi92Rzd2clJUaFJ2YzVTKzdtRGlO?=
 =?utf-8?B?eG9oWUs0b1BOUkNxSW1nOFg2aGhvQmJmSExUU1NkV3NGSk41UVBXOUxReDR0?=
 =?utf-8?B?dXBVN21MVlYrSkJKUG5BcDFwWjFOOU9zSnk1QzdzVktKWTFNYTN5ZFJ5UXN4?=
 =?utf-8?B?QVIyWDNkY09xYVFpN0Z6SzFvRmx0bXU4bGZmM25MR0ttd2R3QjFGKzFGZDVK?=
 =?utf-8?B?Sk1pUEh1cHhvcHU1ZEFXUC9vTERNMUZKOXF5RGJhRDZzRTJGNGRSdUYwUlNV?=
 =?utf-8?B?VHFsQ3d5TG1CeFhEKzBCak1XVzVIQ3k1UkdOcG9OMExzMUk2cXFOd2prdHBF?=
 =?utf-8?B?aUo3TnRpUzJRNFltdW9sTU5jTFE2WHRmamNQZ3ZaQ3ZJUkxMcEs0aHpVMnhw?=
 =?utf-8?B?REdnNytLdUFORit1NGtUSDRKUWZXZHV3ejdJdzBhaUF5SHE1c2FyYkdJMzYr?=
 =?utf-8?B?UUZPbnZ5S0drQi9uUmRYajRENWIzREpSUTFCcnRpVEtOdmtyalU2RmxLWjJ5?=
 =?utf-8?B?NGhtTG15WEtVQzhtc0RSZ0lMa1lvSWJtaXJEZm1QSW9ab2Rwd1hOMk51QjdS?=
 =?utf-8?B?NFBEV1FpalUzZllvMVc1Q2tqaHVYWVhNMloySExnR0hWRGw5ZTBJY21mZFY0?=
 =?utf-8?B?elU1VlV5LzMvMjE4MWVXTzNWcFJrVFJuMDVFZW9kZitoeXBhNjM4cGtkbHNR?=
 =?utf-8?B?SnptMnFhL3Z5WUdtaDJYVzVTdStKL015WXJuSUpzb3BtenV2YWw2ZUNuME5I?=
 =?utf-8?B?NEd0UWRqOWtYUHJXeEpwREVnaW5rMFVYZUFyWGpEbHc5SlZVUWRmWHdjUDFI?=
 =?utf-8?B?UUxHVTBPNlgrS3k5bFhlY1pOa1FYd3VqZDRGNTVlTW9VdXNyWXVDKzZUcWNL?=
 =?utf-8?B?Ylo0SEJoNHE4SEh5blY5dVc5VXJ3Ynl0Ym5Ycmh4U3lJNFJSVTZBWG9DUzZX?=
 =?utf-8?Q?oseUCYDDNHqkAf3VQYdKP+Som?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30edffe3-c2b6-4ee1-06c1-08dd10545fe8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2024 09:01:13.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUwUTkTC+flu0FiV5wSam32qIc1zSpnwmh7OzhyZDsaaZguB7yExXG2s4LsmmKyRqAKKf7n76X2Nxloo2Y0h5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7854

On 11/28/2024 6:13 AM, Sean Christopherson wrote:
> Use is_64_bit_hypercall() instead of is_64_bit_mode() to detect a 64-bit
> hypercall when completing said hypercall.  For guests with protected state,
> e.g. SEV-ES and SEV-SNP, KVM must assume the hypercall was made in 64-bit
> mode as the vCPU state needed to detect 64-bit mode is unavailable.
> 
> Hacking the sev_smoke_test selftest to generate a KVM_HC_MAP_GPA_RANGE
> hypercall via VMGEXIT trips the WARN:
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 273 PID: 326626 at arch/x86/kvm/x86.h:180 complete_hypercall_exit+0x44/0xe0 [kvm]
>   Modules linked in: kvm_amd kvm ... [last unloaded: kvm]
>   CPU: 273 UID: 0 PID: 326626 Comm: sev_smoke_test Not tainted 6.12.0-smp--392e932fa0f3-feat #470
>   Hardware name: Google Astoria/astoria, BIOS 0.20240617.0-0 06/17/2024
>   RIP: 0010:complete_hypercall_exit+0x44/0xe0 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_arch_vcpu_ioctl_run+0x2400/0x2720 [kvm]
>    kvm_vcpu_ioctl+0x54f/0x630 [kvm]
>    __se_sys_ioctl+0x6b/0xc0
>    do_syscall_64+0x83/0x160
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> Fixes: b5aead0064f3 ("KVM: x86: Assume a 64-bit hypercall for guests with protected state")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e713480933a..0b2fe4aa04a2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9976,7 +9976,7 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  {
>  	u64 ret = vcpu->run->hypercall.ret;
>  
> -	if (!is_64_bit_mode(vcpu))
> +	if (!is_64_bit_hypercall(vcpu))
>  		ret = (u32)ret;
>  	kvm_rax_write(vcpu, ret);
>  	++vcpu->stat.hypercalls;


