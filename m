Return-Path: <kvm+bounces-34351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 768CD9FB92F
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 05:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E736D18851B7
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 04:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7491487E1;
	Tue, 24 Dec 2024 04:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SE9ofQqf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9951392
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 04:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735014128; cv=fail; b=PQCH1lJx24PSw3L0gi26wammmnrf+g2nSMoOWiNz1Mn9zrJ7bGrUvOPyNGLsQ3eE8phDeobMxewNaFdBNySWq9+fUhQXO0F/0kkQyhNYxIRQ1jjgrk34djA6WQJTSMNL7eAy8TbDk8ad7Vp2kK8iR+4PdWUg8cj42TT9C61ezT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735014128; c=relaxed/simple;
	bh=y8bdq+hgCzllMV7zsyFnU7qgGE8PZxtwGXJXrmDc/9I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e6Ewro5+mlww9aRkWDhoQ38Nk22x7gsDA36qct9od2RfOAf0pvSwyAt9WlPWlvC9Vh4wzry0mDWYq6swYEK8si8K14ck34uGeB5PFKV2CkoZz+iSsKuEQ9Tj/L8Bah3X5mx2WWRHmnfMI431CNlamNhLJWqJis+MzgJV3B6B/u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SE9ofQqf; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iAqFSLZTJJEYkur5JV3VmYUwJNxrQq0Wi8I2oovmPuGSZmPgvGdsMUBnEvFnOn42cCCtGtCrV8wAAwYiIRPXQbSK6UfgHHuDUqU5YvUoQSVN0hYdaoreupcueTgwn+ZXdaheFOZZnZWWN+IGKPoOVkBiWHkYNus/7Tt71O+KVzrpQjMnPaK43VLHfgs93nuYEXdbdTgft9HX4GFPcocAW3dEZkVxPE6Xo+M+Wz1OXpos0MoxbOFBaqWy4OZ+H6sTS813hPOHzz/iScKoTE6WpZVvtn1QDjzZzO2JRbN5H6NBtwcvUhXGfohFloyW+Q96Qk1PuyKqRz+/A5lYQny7AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfpD86FvXIqOLny6mnGQ6CVkJBU7Vtk2SsF9mGMTF0E=;
 b=jbIhvd6IT1gpl6b40Jo81dILTxcpd9y6wuKSsmT0qbb2n8UvGBLOMW4zuXBwhDyRld2EdktI4xqJJrl/mOFqGgk0sZ4Taaj9TKUOqe3t9bJLLPMa0m8jSoE5R+9w46xQGK1eJoUnMjwR8tPXDgDHgWxCNl9ukascYgHGctu9Fz2ZbTtq8kCW3F/vEsVzpC3xezPXDqe/1B6MdISTqt6iY/UEN7hawvaeBTIScuFgh0qJnLaX7iIKxOXgynbjUlp53dDvPRMf2StRN9/6M7VWeGt8CBtFhRIOrLpzj6kuXmpooCFV9hlWIVOD7wKp54DGhJ1RUuoK3DVR/9sX2ABfhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfpD86FvXIqOLny6mnGQ6CVkJBU7Vtk2SsF9mGMTF0E=;
 b=SE9ofQqfwfdB5H6i8ljlEggp5w1I6LBbeWFeFXOCSomFg4rsZtG6vY7dBJYtQ7EZjcIcyXQIta7WD6lGsE6nYWdOVI+DfhGaQ9TpuHJdKS93mQZuW1YA0KhAwv0aZTfspeb2rx/6CknAtMr2ur+4yq95RJ7NZYheG8E1b/strUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6723.namprd12.prod.outlook.com (2603:10b6:510:1ce::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Tue, 24 Dec
 2024 04:22:00 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%7]) with mapi id 15.20.8272.013; Tue, 24 Dec 2024
 04:22:00 +0000
Message-ID: <d6b74ccd-47d3-4fd6-96e7-3027dd13faa0@amd.com>
Date: Tue, 24 Dec 2024 15:21:54 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>, David Hildenbrand <david@redhat.com>
Cc: linux-coco@lists.linux.dev, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 KVM <kvm@vger.kernel.org>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
 <ZzRBzGJJJoezCge8@intel.com>
 <08602ef7-6d28-471d-89c0-be3d29eb92a9@redhat.com>
 <ZzVgFGBEUO7sU3E4@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZzVgFGBEUO7sU3E4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0010.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::19) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a2ecea-eddb-4463-107d-08dd23d282b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1dCYWhXclJ3MmNTSFEzaEY4Rjg4VFpmN3VpdGVISmNrNUpzUVJmVmRJUTBM?=
 =?utf-8?B?MjZ5VzZ0eUJjanNCR3Q2VjNwTllYWmZNbEJOeUtTcEhtNnByV1VZZ2RMVk5o?=
 =?utf-8?B?dXVFb2RQOTJuT0I0OFNGWUVaV1Z3V0xwZXFuU2F2dWlZRGk5a3d4M00ydWlJ?=
 =?utf-8?B?QjNHbVFRU1RRL3c0Si8xNVp6V0k2SE1Ga3RKVytnM0hlS2dzaDhhU3hVODVz?=
 =?utf-8?B?RGgvVVBjclBlMEZrL01ETCtobWtzMzZkUGlZSS92dWtUTzFROEVGdiszb28x?=
 =?utf-8?B?SFBmeG1lRFlta1pzY0dGeWFySXAwWFlZMHdJTS9RR2c2Q083TTlVRFR6RG8v?=
 =?utf-8?B?U1FDbXBsd0VLRmhLRHJPcllWQkw5NmhmZ1duaEY3WmVHQ2cyVmNIanYwMW9K?=
 =?utf-8?B?MDZsMjFhN2FoNlhtNjdCY1hZckJRbVd6NWRzcHlLQ29ocHh3RHl6QzR4MHBk?=
 =?utf-8?B?ZlgrR25OaEl2MWhIOFJiRGxteFl6SjZIdkRoM0dOTDFJSHpZQ2xRY0dHZytr?=
 =?utf-8?B?M1BYbkY3UGxTN1IvS3VvVk5BQU9mZGNaS2tHcHZIVzNsVWtUakRGdDUzR1lV?=
 =?utf-8?B?ZUFtR204TUZiYU9zOWNSSVFhV0tkVkxSWGtpQWRobkZraWdMZmwxY1FJeU56?=
 =?utf-8?B?dnJjek8xWUVYc1I4elNBRURLeTFyU01MeGlIaWM1blJTUDRWZkdxUG9jN2dW?=
 =?utf-8?B?eDVyNjBZTDRtQlVZQXNyUEVCWnAvUTNSQ0VVUlQ0RDh5eUJPUjBPWnVuZ3NG?=
 =?utf-8?B?SmVhdy9zQkUrbHMvZzhNK1dnemNocHNHa3F3SVVqdlVQVFVJQXBrVE5XVG9G?=
 =?utf-8?B?S2tkRlV4bWxPM2FYRTh0UWM2VVk0ajBXU3N5MlNxVVRWVEZRL1NkcFBITlla?=
 =?utf-8?B?RGdPRlcvdlhBakhGdEFPQXh6RzVtdzRMcTk0ZlI3Kzd4aTdWYXEwL3JpbWg0?=
 =?utf-8?B?VVRsbW1HL2FGKzNYYUErMFZyWXA2UVRZU3BzM1p0NlJrWGFxcERqbytGeWZT?=
 =?utf-8?B?STB3eFRCM2kzMkY1NVUrU0JySDUyenNZNC9CZFJzQ1psSVFFL01kVm1YTWM2?=
 =?utf-8?B?RVpHVjJOa29VdkphZzBHclF1N3NkT202bFBQWVRmS2plelViQ2lmNW9KeVds?=
 =?utf-8?B?T1krNUxyZkdGc0V2UENFZytlUk5aWkp5RkZFK0J6ZGRFak5uUUVGRkNxdWl6?=
 =?utf-8?B?MExSM1MxdnY1Mm1lNFdiMnFKRGR6c0QxOGV2NFNxYm8wUnBkdFVVSVBtUVZ5?=
 =?utf-8?B?SFJDSWtkRCtFUE5TN1hWVWRXblgzWllVN2FjdmVRb2hhWkVCNlRiOElpTnoz?=
 =?utf-8?B?My9kQnY4cGVyZmp3TW1yK3BUUU50RDhib1AvbS9VS25TcTYvRVNWci95OWN4?=
 =?utf-8?B?RStEcHo0Q0RCQ21VaFI1VlJKMUh6bjVYQmFEZ0ZQQ0pzK2ZCZ0ZEeUNsZjJu?=
 =?utf-8?B?R29uVTV1am53MlhlbVhxM1BRUjBVdXBSdW42T1Jia0FaY3I4WlRKdjBpZ0k5?=
 =?utf-8?B?MGEwVitPVzJQOURJQU5xaG03ODdxYWRPQTJlSDdtbENwanhkaHBmTjNOYTVS?=
 =?utf-8?B?MjhYVEhTM1JTWGpsTmdLdlpSd2IwbC9GdFV5T0wyZDJBV0JoYzM0ZytYVlhK?=
 =?utf-8?B?S1Y1YzFORXhvNURLNU5Kam0vWHhWV2RqRFk1T0FsS1ljbUpKa3dPVXk5M3JK?=
 =?utf-8?B?YTd3T3Y4b0hNMlRCVkczSytyOG8rdnlMTGNMSitHUHcxYmJYNDhPYllDYmow?=
 =?utf-8?B?NWRCMlBRUzB3ZS8za29YRmhUNU5pWldVMER2K3FlVGthOStMbGpvazJJNG94?=
 =?utf-8?B?bU1meUJ1U2V3dkZhN2RDc2lMYXdwazhvb1Y1eXhMcVZoWXh0ZlpmdUU0RXZU?=
 =?utf-8?Q?RdMk1qD+juLDt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGNCZXVrbmN3SzlZMVpERWZYM3RCcHNUUU1sSXNhVFNtMXkvU1BvN3g1SVJL?=
 =?utf-8?B?NlRwZUd2QnRENE1SS1lOdmg3czNJSHJLbW5qRU8yYlordE5hTGx5aTNGN0xk?=
 =?utf-8?B?enhiQXdoUmpyRFQwdHQ2dU5LMTVMUHZhcXJzL2gvMGsxZ3JvRnhGK2s1bnBR?=
 =?utf-8?B?b0dReDZoWlpPeVdmaWczS3Nvb2NzcllMeWU1aXJzOTRsRmg3NkRJUFJMeDli?=
 =?utf-8?B?QWdaUlluTi9vbHlmZSsxVWUzNG42ckdhT1FKZlpVanNtcTBtWmlVcm16bEpS?=
 =?utf-8?B?N2xwczhodHZGYUV6dXp2eHh3SnBoRHBFSG9tVkJSVkhZZ2ZPOFVDVE84UHJp?=
 =?utf-8?B?OXVHdzlmM3dqTG9yT2lTV1VzVzd3RlZ3Nm44dkVhWUdFU1hoK05pdURaTlZQ?=
 =?utf-8?B?MHBicWpQaVRWMXBvRjl0dTdZaW1IazZrM0VIZVhYb051N2NsMnhoUWU0Mis2?=
 =?utf-8?B?eUQvejJGcHVIZXhLQlRxWkhwUktKYzlUUysyN3ZNdGFzTFk4Z3pkWlRQRFVx?=
 =?utf-8?B?R0QrejhtRlJOZ1IvSmo3K0N5dDJjK2hpQysxMDBJRnovdWRZT1N0VGFtTGlu?=
 =?utf-8?B?SnJ3elowTnF1Uzl4bnpBdGlXZG1VWlVYUlZldUEzZ0k1amc2eHhNRlpuc2Zz?=
 =?utf-8?B?b1JXcHIrUkFyZTNYNjR6TEdvdm9FUlRlTDdYeVRNMkI1enUvNmxIbm1oK2hl?=
 =?utf-8?B?UXl2dEpBQ1h6eDBwajM2NkdQQ0FoVGNLTEd0SUF2eGlXaHZoOUZCeXphR2c1?=
 =?utf-8?B?cjdHZEk3SExRM0J2dEt4Uld0ekFpMG1mOXA2MFhib2FaU2wyc2tHc1lSRXBU?=
 =?utf-8?B?c095NFM3Um5JRjFvTU1KaXFJaG9JZmJKckt5UUhlY0hkS2V6SXFQcnB5VUIx?=
 =?utf-8?B?LzdxU3V0VGYwckR2T2tJQTBJK09WV1Eva1lLTmxWNTRHQjJYdkl1My83dWR4?=
 =?utf-8?B?ODNLUjEvckFUTk83MGhuWTd0QWdmc3F2a1VCVjQrTGZQNkxrRGpmV3g5aThj?=
 =?utf-8?B?eWJUWGJqMDl6UkJwRHdYL0k4TjhIUjI2YWUveFhwMkppemFPUjhUM3JVRjh1?=
 =?utf-8?B?bFZCOUxNaEFMdCsyS29aVHMzTnhoNEM2dGRTMUhxTnZWQndKeVA5dm9Vc3g2?=
 =?utf-8?B?T240bmxXQ1Y5SHRzVG5IQ1FlMnhSUjR3bGxhVkk1RjEzbGZLS0VDeEJ0cWFn?=
 =?utf-8?B?UTRwZllucTlMSHYrS0lTaGtWZHRod21IQUllT1lGZTFSWVJoUTFRRTBndmg1?=
 =?utf-8?B?NzFwaWkrK084Ti9kRCtVWmxQNHNSSVpURWJwWS8yc0V3UzltVjlxUnlZREZt?=
 =?utf-8?B?NlY3RFN4RUpZS2dXU2Q4NWFXRnl2d0xNaE1PaTZZSUgzV0dtanV1bTd5N08v?=
 =?utf-8?B?OEk4SVFxMGFvKzY5b3piNU1mZFJsMVBoRXdnYzd0Vk9nQU9FcXliU1NDRlRz?=
 =?utf-8?B?OFBTdTBwL2xqNnBwdXBJaWZqYXE5R0FJS3kwQ1NPTDZQWURRaXpzQlJSWVNR?=
 =?utf-8?B?RzlNMlhZK0I0NStIZExVZ2JKV2VEZ1B4cEp2ZTR5RzBvR1lWTENnRXdZY2lk?=
 =?utf-8?B?b2xCL01YM3JZdWExZmFoRWZJWWttUjEvRmVmZENKRm9CWk5sa1I2d1djVWtO?=
 =?utf-8?B?aXE4eENzUFRjQkxzdWhTT0hBRWJWeGRRVk5YVm9nK3B2SW1VVTF1dFZHQm9Y?=
 =?utf-8?B?RTNDeVJ3V2xSTHNxNlBTNmhNSXpwV3VVRGlzNmgzb0JkYktVUlZzSTZVTUhG?=
 =?utf-8?B?OVdyWTAwWFMzU3pVb1BqZFU4d1EwRVZ6OURtZ0lZRzNTMFI5ODgxSkJOUHlR?=
 =?utf-8?B?UlkwMEhLVy92MHgzbmkvTjhCNjVKVnA0SkFjV1cwSEYydHhaNy9iYS9PT3NV?=
 =?utf-8?B?U1U2NXFnZVRKQjBOU0tuamZFTXdjckVMUUFFUHIzMzVoMDJZVlBkbGFpRXpX?=
 =?utf-8?B?MVI0OHl3ODh4M3U1VzFWdy9TeHB5TVhFTG16Rk93NDVCbFdNL3JFWXVEeU5Z?=
 =?utf-8?B?T0gzVDFYMnUxNHFaZXRsYmVkMGZ0aWlpZTNtRnNNNUVBc0Vjb2FkUmlGT055?=
 =?utf-8?B?dTNFN3dDeTIrcW9YSTQ3ZmVmclVrYlRpQkhSdjdFQlhlSjhETklMYVJmOGFQ?=
 =?utf-8?Q?9b5YBW4v+tFrIe9wZFfIKtWEh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a2ecea-eddb-4463-107d-08dd23d282b6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2024 04:22:00.5148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0+MqXVGdo5oMk02TQvZ0Y7/bE0m7WohqUkVy1vlg7US5GE3b/HHxO55uWuY8/awHp03r7uAxs718AAos/rP3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6723

On 14/11/24 13:27, Chao Gao wrote:
>>> With in-place conversion, QEMU can map shared memory and supply the virtual
>>> address to VFIO to set up DMA mappings. From this perspective, in-place
>>> conversion doesn't change or require any changes to the way QEMU interacts
>>> with VFIO. So, the key for device assignment remains updating DMA mappings
>>> accordingly during shared/private conversions. It seems that whether in-place
>>> conversion is in use (i.e., whether shared memory is managed by guest_memfd or
>>> not) doesn't require big changes to that proposal. Not sure if anyone thinks
>>> otherwise. We want to align with you on the direction for device assignment
>>> support for guest_memfd.
>>> (I set aside the idea of letting KVM manage the IOMMU page table in the above
>>>    analysis because we probably won't get that support in the near future)
>>
>> Right. So devices would also only be to access "shared" memory.
> 
> Yes, this is the situation without TDX-Connect support. Even when TDX-Connect
> comes into play, devices will initially be attached in shared mode and later
> converted to private mode. From this perspective, TDX-Connect will be built on
> this shared device assignment proposal.
> 
>>
>>>
>>> Could you please add this topic to the agenda?
>>
>> Will do. But I'm afraid the agenda for tomorrow is pretty packed, so we might
>> not get to talk about it in more detail before the meeting in 2 weeks.
> 
> Understood. is there any QEMU patch available for in-place conversion? we would
> like to play with it and also do some experiments w/ assigned devices. This
> might help us identify more potential issues for discussion.


Have you found out if there are patches, somewhere? I am interested too. 
Thanks,
-- 
Alexey


