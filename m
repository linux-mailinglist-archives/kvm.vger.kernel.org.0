Return-Path: <kvm+bounces-48588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A3CACF7C2
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2F777A520D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A022B27C842;
	Thu,  5 Jun 2025 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XVOVbwIl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667704315A;
	Thu,  5 Jun 2025 19:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151314; cv=fail; b=Ozx9Q5qPEUG0oN14lFpmu+KfSW2D0ZtPbcbGbHGVx/52Z6LolnOzFvVj5YH034MYKSpMaBjAUE3c7Dq/Ea9qKdRsjYz6sPYyUSNuDRiNIiYWehfDNErBEAvmb+o+KugRnVQo16bMG7IsqaoWRwRxOQrXHFhefSBzlnTgJ65dgWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151314; c=relaxed/simple;
	bh=OiG2BguezSp9mpyRYIoNCLydgliEjj8Btn7ES6LAnrY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D3WjTVf8WS3PjhAObXyytBdeE8orL70i5fh327C2mHbTyyTUTnSf8zsr76IoBVTVkhSRb3DMK433fEetI7XzrTKV24YLeE3btPKU6568YBO3ZeLM9GFuTjZGJVsvvqxGKbt5BWvBCTsfegGdmFHfBa5c9zMQzrXJysj6LWrUwRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XVOVbwIl; arc=fail smtp.client-ip=40.107.95.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUdm5cxTlrXE7z8dZ8I+XGheicSdiVPxpiFLPntA2lfN8A8COSpq7G5XpvzGZE/BFK3UeLyE8Re17iGiSRVeki+ELfHYUSdisi650ZUi52fzpqjbPlYzRDJMaavF2JtIUcmFD44biMFeboOU0NGW+vtXHvxcQ9wfjYhlky5aXH56b7bGzKuoyjga82X2zMAaRUqLDrWaQbYHz5ksBp3hGv4tjEcmI4wxWp9zAwdl/rZPrGJVubNMEfhPY7gbQeR29BkBn6JeelnXR2XhMgVrhFN+v6uMfQ0oFEVyrdEDFBAXLuHgruSX01CcaA8c4/PcLeEhjp1O+9DvybywzQC/cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKUdydZL+eYMYYUvhtwrL5fiqosGpceefeLb4xQlLWc=;
 b=ZFI3sJX5wGHji0ZohRjgAYSEYJFOHPtDbBT5wdgw2Z6gft0RD/cyXW6SE1/fJHvZBGNzl4HHQHSGKXh5yGgr3TM4GkWs76irF0KZ5tOxHZHo8AiNWTKQ7G/2P821llb91WcMtS1zaZhQ1hZHbBy5YXk+iYp8I2jObXgXbuuHzdoZwR6Jvj9jKI5PJ6B7FgC/eL4EyIrQ2N8abIYaXmpfAS2i5zRxq0y/HvnYtONlejeQIiIPhXAbEexPLpuEh+T2EC721q7br6GxsWLcoplRUYZn+MeKbahnEFJUqA3C137Ddm0eHRWav147JoQSO00DE1EGqSHCjKMrENzGZkU4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKUdydZL+eYMYYUvhtwrL5fiqosGpceefeLb4xQlLWc=;
 b=XVOVbwIlQCNWZYgLCyTeuzaVw3MTmqbsJ5HgIx/B7Pq7OyR7oBUA8WgULO30GPBdRdUw1s0B0ojo/ZewHl32RbgELrI89wIPRVkPEAorgLkeRroTxCGTSCaCutNrirXpwhInWGTOSeTk4hfkspYzW+7jjvjSRPh4M5tlg88nBLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Thu, 5 Jun
 2025 19:21:51 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 19:21:51 +0000
Message-ID: <28de19a2-57fc-46d9-9ef3-3790e2a51188@amd.com>
Date: Thu, 5 Jun 2025 14:21:46 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Tom Lendacky <thomas.lendacky@amd.com>, corbet@lwn.net,
 seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, akpm@linux-foundation.org, paulmck@kernel.org,
 rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
 <a6b39023-447d-67bf-9502-4340f9d41c81@amd.com>
 <11700688-98a4-439e-bcd3-44ca51fcaa14@amd.com>
 <087c429a-7d1a-a65a-f254-155cd6b2aa49@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <087c429a-7d1a-a65a-f254-155cd6b2aa49@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:5:334::20) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH2PR12MB4038:EE_
X-MS-Office365-Filtering-Correlation-Id: 009f61f2-4113-413f-3dca-08dda4663917
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkZCNnJkODI2ZHhTZEE0dFNlZEN1NVpqRUw3d2tnTWJsdmFGU29nU2tFeEhE?=
 =?utf-8?B?TFphc1ZvYU9wbTRFOWNWbTBUbkhSZk5iWVJqNWd6enh3Zzh1MEJ1U043OXFw?=
 =?utf-8?B?dUNPVXZrTERiYllaT0hOTE5CTDBXNnVNelNCdWNQcEs2Nk96ajJIS2o3ZHZZ?=
 =?utf-8?B?bUI0dHl2TWpXMFY1am1hSXRmUlMzdkZYdWdkTDBzL3RWRmJOa2RVRmJBOFRl?=
 =?utf-8?B?YVJlcTAvcS9TWDFQRDIyUHUxTVJIZlRrSTZ1cCtKU2gzelhjRDE4RmE0bzVa?=
 =?utf-8?B?Qld6ejJ1aVlXOFVRRXB4cWNqOW9MREF6bnRDbjVMTFg2T1lrQno0bjhUdmJJ?=
 =?utf-8?B?LzUzdUw2Y01McTlmUjFEazZBUW9zYjh4N0xDS1dhWGlNMnl2aUFrMmIrWnl5?=
 =?utf-8?B?SXE5dVl2bURjWGdBOGlpRExtaE14N3VlbEZWekN6VDNWT0QzVnBlNXV4SUdP?=
 =?utf-8?B?b0YwSVJyTi9GeU9YV3JpcUdocHR1TEFwa0ZJRlM3VzVHZmhMRkxEVkkvOUJU?=
 =?utf-8?B?Myt6cXVtQ252em1jN1I4TnFNeWtGUTVodkZ4amZySmxkUXQ2WThKYzM3OHNI?=
 =?utf-8?B?cW1KdDVvTFdoZHBUWnJzU2VxVzRCamw4eTF3VWUvSnZDM0JKUi96UXVTdVRo?=
 =?utf-8?B?dm9rbVJOclprNGE2TUQvdmtCT0RjM1Buek1oUHpvTzZIWW1CMmJvY0pTSzZM?=
 =?utf-8?B?elZFK1AydThrN0Z1dTV6OGJZczE4cm1sRFFsM2V0WWpwR1VUbmxsLytzcjdW?=
 =?utf-8?B?VkUrUk9FSFg3NHFXNTJESjdiRThSMithREJoRFhpOEV3VmRyalVHWGo3MTJJ?=
 =?utf-8?B?TStPcE5WR2FNeFFWalRoaHdIWVg4Y2ZzbXZSV016SldZSGhxL1ZLaWxXWlFC?=
 =?utf-8?B?aUlTUkRqVWJPZU9pcTc0Q1dNdGlPNkNQSWM4S1IxTHFEbml6a0cvVVpST2Zp?=
 =?utf-8?B?bW9XcEk2TURCVHBXZ3M5NVNXa3RhaFQzVEJ6TzJCcm9nVSt6RlhHajRnRFlr?=
 =?utf-8?B?WGFpcEtaOVpMMFVZb1J4eFVwdFl1NGF2aEVvcm5HYkx5ZWpzTjdYV2lNUFBa?=
 =?utf-8?B?cGoycWlzNFU3WWd5MTQ4bkdNYUxWcUJNUmtZaERSZEQ1OC9sK1pJZ04vRzlv?=
 =?utf-8?B?TjFYMUEvc0lES285L2xpaU9PMnpaTzlXN3RRaHEwYWR5bWd1WUdhU1FQSnZu?=
 =?utf-8?B?T3ZVMnRvT1g5MTk0Y0pXaDlKbnFoNTJJdHR3WXhHam9haEJwbGYrVGhJZzNj?=
 =?utf-8?B?dnpaeE9FRGFMd1cvZGhlcm1GVU1SOFlMT1R6RkxXWjhsY251b1B2VzVNMXZU?=
 =?utf-8?B?N1N3dVFkRjFPNWx6VUQxY1dNMkJiSnlHSStabDFsWE1CZlRjZWREdDNrMHVR?=
 =?utf-8?B?djRyRnNKMEIwTE82QWxoQ1lQK2NxNm52OTQ0dHp1VWtXNmhzcis5RDJ6SkdB?=
 =?utf-8?B?TXdDYmNCdU9ERS9iaW10aG8wcVJuT21yZDJZSFdnYVljbWlIWnVNdE9kMUYx?=
 =?utf-8?B?Nzd2VG9PRUZRTC9BdW96bUt3VW15RFZYSVR3TVBQUDNYUkRhb1NQWkpZQ0Rr?=
 =?utf-8?B?T3IrWUZ2ZXR2SUJseXFQVUhqUnR3dURuaEVvSzVlbGg4eDcydEtUQnRZUVpa?=
 =?utf-8?B?SnF5ZDRKdmVwaVRmUU5LVjlvc2xQQU83YWJmNkw2ZThtWTY5UWFRMnA4Lzd5?=
 =?utf-8?B?R0tKRmZvYVB1TTdpNStIbkU5UmJwRS8wR2N1SGdaZy9rWUdNWUtzOUlrK0lt?=
 =?utf-8?B?STJVaFp6ZGJXMjFzdHNJMmFSV0p4VkRLWDZCQTVWZXE2REFhbEJQUFZUVFZj?=
 =?utf-8?B?OWRHYWxBaVAwSkJhSEZmL1RyMEJDSndtR1pEL3J5ODRFc28rZEFQZEVtVnpy?=
 =?utf-8?B?MWF1WjZpeUhmbVNpMXFpYUFjNU1kU0FkeG5lVTNZOTlyUkNWRUlBRVhCcFlJ?=
 =?utf-8?B?anFMMTA1V2xLL0ErMEpDRHVGcXRGQThFcVZiY2VDaS9wRXVSVEtqaFNhTmJV?=
 =?utf-8?B?TXVBM2gwcXlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXlXQ2hMdDFLUHg0S0JoSklieVJ0azhKTU5PYWlOMEpqK2paMGh3aG9GQnZY?=
 =?utf-8?B?cCtIOWIvTXJHN3d1ZmlHK1FVaUtTa0R4aVlTUDdXTU5Idzd4WkxXdWdKNVJE?=
 =?utf-8?B?K1pqdWE1bEVZQjBZaTl5TC82VTlldlFkOWxVUlhETGN5RnhWL0tldUJ5cXhh?=
 =?utf-8?B?aEs0cDRyTEsvaHNEUzVJTEJ0eDdtOFJRYUpYazVlTkwydElMYVF1dGF0aTJu?=
 =?utf-8?B?YzhoY2tUT3hwZjZBQkd5cmpubXpQU2VzWG9CWC9hei9SWkxwREpubnR3Sk5D?=
 =?utf-8?B?QUdMVzBvWEp1bHhZUnRoZWhPNnJieFRVa09DeC9KRDIrRUhaeEg3WVpmUG1w?=
 =?utf-8?B?bnBGcDVtaEhwd1cwbEFXckZlQ3RObDBNU2VTeFIwTGxNNnM0a2hUZ2RxUmc0?=
 =?utf-8?B?MkhmRE5hMHdMSWxjZkVzNTdrSXlLMkE4OGFKV1pSY3dQRXJMZmVXdnJXbEtW?=
 =?utf-8?B?czU2VElOZ2tsZEtVK0lCUnZoeWxyaEduNTdUd2xueGdreS9EbTFFbmhLVEJj?=
 =?utf-8?B?R2NGR1NnQWdBZ0x1Y0xuNTFVT2w5UFV1L0FiQ1drMndKMWd1cXJ2UHFmVFhI?=
 =?utf-8?B?amtjOFpkUGM0cWFMNjd0VHFoQVJ0MnlreVVvZnJaR2U4M1lNUm9OdGR4YTlL?=
 =?utf-8?B?RmVtSXdCcWRFRmpDbkVUUHU4d2Robm52a0d4ak12c1FSSmh3Z1dObFVsaHdK?=
 =?utf-8?B?QnR4dnNhT3NVTVpjT1dtNlVrc0F5UWVRaWxlV2pxLzZhbUV1K0VEMXA0TkFS?=
 =?utf-8?B?SmJXYkhjWStRTjJOS3BqcVBjM28vUlBNMU5FVGVuOEZrMVlPdVNROUxzY0ZD?=
 =?utf-8?B?NUlHbkNma1U5MVVTU3BIZFJ2ZlFrWWJWRXhYL0NKQWN2NlFLaHkrWGdPQTFr?=
 =?utf-8?B?SlRZUWJKcFNzQTYveWxhaEpWVlRETFU1bzk2ZUc1ZkhtTUJ1aWIyV1RQQzNh?=
 =?utf-8?B?bDVFamthT1A0L3Zpbzd3c1hKVk5Fay9yVGE1cXl3ODBNYWh0MHVobnBJWFhG?=
 =?utf-8?B?bFdpWFptNkJ3REFGYXZrQ1NhYmdXWkxOMDcvMEQyMkF3TGxHdXN0Zm9malVp?=
 =?utf-8?B?UWtoMVVkbDRlaVRwSVZUS0pEbHoxN0lmZFJyZG5tSmc2WWhKdlQrVFlRbGZT?=
 =?utf-8?B?a2I5cDllbDRoUTdFUGxybzZXL0drK0hKSVcrTFUxc2lQQnZrLytZYXVlNVo1?=
 =?utf-8?B?czlwbzJDV3BHak12NG5SNElKRVJCLytGb1cxRW84UkpMektRcmlkbnE3UFZL?=
 =?utf-8?B?alVFclJrN1lkNklnZmpRNTMxK0dsOEZDcWJtTElSL2xZeEIveXkzUWNycXJT?=
 =?utf-8?B?UmR6dlR3bldpTFR5aTBPVHR3WGtNNStGZ1lod0JDajBpSUs1bUJNRDFiR3Iv?=
 =?utf-8?B?enprVXI0ZTRXRDJpQU1HUmZOcFJqNklDd0VVZ0gzQ0RmVW54RjdxYjlPRXJH?=
 =?utf-8?B?Q3lPK2tiTFFPcTFGMlVqUGlWYXl0S1h6S0ZuemgrKy9EY1pDaHB0RGFDY002?=
 =?utf-8?B?K0NQYW5BaDZOYTRjbUlqUmxsNFcvcUNaSUpYcTdGU0JhdmV1WWcxa2JsdlZQ?=
 =?utf-8?B?c01iYkxCTm1qeDZ5MUh0MnpocCtzZW9aOUs4WngwWmpaTE5KUXpUY21lN1Zy?=
 =?utf-8?B?UW5tVmR6VXYyUTZSS0M5b0JLNjFVNktHRVVFNStFaVNPK3RCdnhzNHR0WXdB?=
 =?utf-8?B?WVZNaGJwRnliQ2R4TTh3SUE5TFl6elFxR2hhMDZyckI2TTZ6NmV2T205TDFQ?=
 =?utf-8?B?bHluRk9VVnBYUHpvakZSaFFxZnZSUEFFYUdmK216OVJLWHpjTStmNHkxREtB?=
 =?utf-8?B?NjJhNG0zTXRZQWdCOU5LL2V0anZUbWRFYng1RHNVNlNjbXI4SE52dCtVSHlo?=
 =?utf-8?B?MW1EZlJCdjRndDNnZGtVcTJYR3k3UHVhdGJQZStwazR3QzNDSE9PSUlkNkh0?=
 =?utf-8?B?ajdibWRxdEpadjIyRDdYc1JGT282TzRkL2NzNXVDOStMTjFRT0F1bE8vMDZl?=
 =?utf-8?B?Y2VXaDVBQ2NoWTNad1VCczVvOFZtMHNyNDZoeW95WnFsMElLem1nT016ZHd3?=
 =?utf-8?B?NUh2a3VPYWl6M2hPVHA4c3liRkNSY3BWOXBxbElnSnNGcDFlNTIxN2h0Vy9w?=
 =?utf-8?Q?j8+uhSfQ5d2g/engTDEiLLDZI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009f61f2-4113-413f-3dca-08dda4663917
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 19:21:50.9464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RciIKT/PmFKbup2SI4B/zO/pRUPQ3ixNRZ7sBv4g9wLSNbxCsE5vagwCeFNlYxF/lJsw5w5is/Xjf1EnLv41A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038


On 6/5/2025 11:23 AM, Tom Lendacky wrote:
> On 6/4/25 19:17, Kalra, Ashish wrote:
>> Hello Tom,
>>
>> On 6/3/2025 11:26 AM, Tom Lendacky wrote:
>>> On 5/19/25 19:02, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
> 
>>>
>>> The ciphertext hiding feature partions the joint SEV-ES/SEV-SNP ASID range
>>> into separate SEV-ES and SEV-SNP ASID ranges with teh SEV-SNP ASID range
>>> starting at 1.
>>>
>>
>> Yes that sounds better.
> 
> Just fix my spelling errors :)
>

Sure.
 
>>
>>>> +	 */
>>>> +	if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
>>>> +		/* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
>>>> +		if (ciphertext_hiding_nr_asids != -1 &&
>>>> +		    ciphertext_hiding_nr_asids >= min_sev_asid) {
>>>> +			pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
>>>> +				 min_sev_asid);
>>>> +			ciphertext_hiding_nr_asids = min_sev_asid - 1;
>>>
>>> So specifying a number greater than min_sev_asid will result in enabling
>>> ciphertext hiding and no SEV-ES guests allowed even though you report that
>>> the number is invalid?
>>>
>>
>> Well, the user specified a non-zero ciphertext_hiding_nr_asids, so the intent is to enable ciphertext hiding and therefore 
>> sanitize the user specified parameter and enable ciphertext hiding.
> 
> Should you support something like ciphertext_hiding_asids=max (similar to
> the 'auto' comment that Dave had) and report an error if a value is
> specified that exceeds min_sev_asid and not enable ciphertext hiding?
>

Ok, that makes sense.

Thanks,
Ashish
 
> Thanks,
> Tom
> 
>>  
> 


