Return-Path: <kvm+bounces-32281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DFB9D51B0
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:24:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2291F21D94
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 17:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBA31AB534;
	Thu, 21 Nov 2024 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2fReSfaM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2050.outbound.protection.outlook.com [40.107.212.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC5C10A3E;
	Thu, 21 Nov 2024 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732209882; cv=fail; b=lQa2tMNCZjrDRLQVo7LItjn7o+COmlYhKoVH2UlzVloNCgJzNMsWSjJEoWtiKCqWQF/mmuCaPyysiCsgOM2t+Mq9ync48et1xbqQPwy4DxWRo5it0Z1fVoNP1pyvTfkxpirBzhyg5a3dje2tKJKeEqcYMhMPnmQjGHvLsHNVi8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732209882; c=relaxed/simple;
	bh=ieJRvJlcnBInjWyU+VPG4n8aY7jGgXBUEzXFOMaxfb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XZRH8bcczM7Ryt0/iUr+5bQt3RvL7OMbjhmrZZPWxwpNcowgjcrglPCaLIzXIH8lLhUW9B58l5D/Mv/DV1iiI7keL9ahrCR8T71kRCO/qO0w48XCufarNeR4IXyMsEOlEM1edCuuldJq08AUGbQRAzf5Vbe3/K/as8RamHnQLYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2fReSfaM; arc=fail smtp.client-ip=40.107.212.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G8OKMZ0MRtqp7sYaYUmXydJlWcDrHxR+WGKa83GPqofFvANpqiptRzMDq0hemf08hsJExhWqZwOmV8+Lg4D5pE8xLSkAYrMzmnLeiFy8veNTvPbdeil1ww7KOzpendd7eMry662GCSjGxrbVB2NyYhERMA5Pr+fyt2ud7CgtfxXsxmq1DUwXhHgb2y+GCS9RdhTNnWIGuOnnzYML49vCSG7WPYgHZdUHvMVgIJ+uNvxDoGgC34ITB6CxT4EPHP1xXUnjD59o5Gji/DkxtW+nDIhq/JAvvgtntFsPdxQsGwDmBcb92DtQnhUidExivuGX7AKvnGbmGbipAvftvEm9MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHidBKhmMOV6VGvsCe9KhYdnfC7+XUXGl8MZkVVOjB8=;
 b=DlGG42dfBUazidb2sejTR09cVSAXHp/lwZxiMG8xDcLztNen9a4jRn+vjrhxOoRZAQ+bhfhHYblqQjXYwmcM7E/jH/ZRfBZ0ACZiS+n+1nLeXXCPPz5PbofnjZ0RKjze9ctsiVciKmu7ab3vzUAGGaUWBqWGOga6/HsSWBJRH0uaKQN1/HFGrHnVKVw/SDr/PLhWUEPb8+ty1X8mEm19/bg/1ueXBnoLK3N4Jd9UjNvImmnEewHqlAcZ6i3z5Az/IlKM11l2L5gKLBXgu70iqIlTNJ8GpCFMUDozatYTImvgoP8Qxy7Qt6U73+onYA4F1R514ydwMByHGaNCOfq5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHidBKhmMOV6VGvsCe9KhYdnfC7+XUXGl8MZkVVOjB8=;
 b=2fReSfaMkYRe/XLwJoUFHqtfnkkStrKD1Q0VUuUk83xnRAiXq/afkwHS9Us8uFH8O5iFvfd8XywSkhhsH7BZAvXHV0o7l7DTq70WZJIUGZBuvIfu3VkICLYqBRmsf4XtruQpWTeyBZLx6Uw8aJHC1X08k51V4vbodBWgMdNY0QQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Thu, 21 Nov
 2024 17:24:37 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%7]) with mapi id 15.20.8182.016; Thu, 21 Nov 2024
 17:24:37 +0000
Message-ID: <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com>
Date: Thu, 21 Nov 2024 11:24:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com,
 davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
 <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
 <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
 <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com> <Zz9mIBdNpJUFpkXv@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Zz9mIBdNpJUFpkXv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0187.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::14) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DM6PR12MB4202:EE_
X-MS-Office365-Filtering-Correlation-Id: ed046633-774b-4229-e4b4-08dd0a515f32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk0xOW41ZjVqdTJFUkRHS1FFamtJYm00SVdOdE85dUFlMGhDcmRzTW5uSWQ5?=
 =?utf-8?B?cGpBNTlmY1lWRHAxV0pEWGtlMHM3QXVySndSNnNuTUp6eW5PM2gyc1gxbWd1?=
 =?utf-8?B?SEpXc2dKb25uTG82anBuTS8yU092ZXd6MHA3cEs2cEQ0aGI5cUVMWUJ6VGl4?=
 =?utf-8?B?c094Q2tDbHJSeC9WcXViUXlMY1VtQ21EU01oNFU0R1RmZjZyMkFOY2xCcWl5?=
 =?utf-8?B?SGk1Zm93aGFJS1FoRVNhdVE4ekIxZG9seG1aRDdrdDZmdC8waVBqaDlYN3I4?=
 =?utf-8?B?bksydXJCaVI5b09ZbGsrMnRzcElTdXZRMUtMQWNLbXN5bzAvbUhBNU9JNjJP?=
 =?utf-8?B?WmlEOUdGZ1kyWm9EQXRBWHh3MmY4VVM0NStoVkU4TFltbXdHb0plRGFrUlFy?=
 =?utf-8?B?cXgvdS9waTNRMERhd0x5MlREN3BHa1p6NXQ0UFpCeWJRVkdQY1lQZFFUK1RU?=
 =?utf-8?B?R1lBdWRnYzlZV2wzdHcrTmpGMUhiSjNBc1JldjArMXFKd08rb1BsZTVIblhw?=
 =?utf-8?B?U0ovbHJBaTYvRkQyTXBLdHBsTkRQRXQydWp3eGVDbVBkejZKQWVWSy9WUzB2?=
 =?utf-8?B?Vk5JMFVWTktKQ3NIMm9BQm16M0t6dUcrUUlEcllWNlI1V3FNMnBUYlJyZjVY?=
 =?utf-8?B?T0ozeUhPeU9jd0NMSmFCRytxeVZCenVvSUYza2ZjWENBNlg3SGhlV2RzWWU4?=
 =?utf-8?B?TmtlUVcyNy9OQkp3dXoyNjVhK0N0LzNDTEp1RXJIUEo5M0xRcnIvWDZNLzBk?=
 =?utf-8?B?MThobjVkTXdqckVTT1ZXRTVtVndPQ1lKanl3WVVpYmxWZk1IVzBHb1lmdllX?=
 =?utf-8?B?bjNER1U0WXhNejJoUzJ5Qi84Qi9YK010L0hSVVlEc3h4bzNOdk9JUHhOblZy?=
 =?utf-8?B?eDlheHBoOVBxTWo3QjBqbEI5bk03SHNucVorSGR4dk5KeTVEU0g4cC9idEFV?=
 =?utf-8?B?Qkp4aGRVemVCRnZ3ODhPdXIxbENJQlB4UFVrSjRlSVpFekJIcDNJbVpTQVlw?=
 =?utf-8?B?ZVlGQk9VdFRCSjV1ZU12d0hvT3Y4TUNSR000WmM1V3NjT0ZkVXBMa2x0UTNF?=
 =?utf-8?B?WXZHcGNrRWk0dmNDUjV1RUNmSnl1T0dUd1YwR1AzNjNxRWpWbTFsRE9POGVs?=
 =?utf-8?B?VnlONk00cVBNNnJTbzRYZjE2UWdoTjI0YnpwRkFVVWM5U1FqMHNOcUVMaXZ1?=
 =?utf-8?B?MVNTc1ZGUm44bDk1cjNVOFN0SHROVFdVdmlBb2ZqNFJqUVVpSTE4dXFoSGlU?=
 =?utf-8?B?M0VwNnA2KzFLcG9oTWxMTmd6aTdxd0NUOUpaalFMa0FPMFdoaWsyY2hMRS9Y?=
 =?utf-8?B?dmYweGJ6MDltVG9uSTFPa09pOVZQaERacGlwWHhob0U5bDVSTkpvM2dHOTFq?=
 =?utf-8?B?SWd5ZkZ1ajA3SjRWNE84eDc1bzZyRmVmNk41bW9vZEZ6UFQwK2tBUHZ1Njli?=
 =?utf-8?B?V0hXbS8xUWQvdmIvTUVtTHRNOWhkZUZtOXd1cDFIMXJrc0FyY3Uyd3F6UXVv?=
 =?utf-8?B?Uzdkc0hRUVJUMDZIamVaQStyRUpPdk16UnJmR1JsZFBxd09mYktBaDRWU1E2?=
 =?utf-8?B?UXF0ZDYwQUorYkI1Q3R3c0haQUhzNmNxQmdSNFVIYzlkQS9KZGNxUTRTcWxR?=
 =?utf-8?B?WDZBNkZiTjVjUGl3aG1GaEhacUs3WXJzcFhqYUR5RHpyZ0dtTWNmNHN0dkNU?=
 =?utf-8?B?ckszVEtIUGRrc09aSGptNnh6TmFGWlVaZ0pzdjJTd2toTEgybGZrRENZUE9r?=
 =?utf-8?Q?KIfUplb3WXhLK5cdM2vsjYOtzCSev1pgsVDk1v6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YksxcVVzTEcvMFNGTnl4UTduWEdLMlFleXVTV2hhY3g5bHVDUU5RRlB0UHRM?=
 =?utf-8?B?TEpIaUFqS1QyVy9hc0VQL1cvVkh2N0F2RC9INGFydEw4blpWbWlPWi8rQ2Iv?=
 =?utf-8?B?ZGY3MWNVcFNQcDFCRVY2bEx2Q2dSQkZ1dTRoNXhoRnkxZ3VIRUdwMHEzSGo1?=
 =?utf-8?B?aitSbysrV1JFdzJXY1BQNzk2bllGejdyL041MjZ0M0Z1Snc5MFBRVDh2WEZE?=
 =?utf-8?B?RlFicUQ5UnpFRXM4a1FsYnRiU0xLUWNBL1hRMzlaM1lyNC9mOCtua3lCdUo5?=
 =?utf-8?B?OTBsYm91Q2Y2bTFyQUFGYkxIVVJTWEFrNlBJdW41SGVFTTFRcHV4VFMxVkM0?=
 =?utf-8?B?dDZGamxZT1NER1ZrSnQ1c0czcmpLTWcvd1B2ZXJsY2RmQXhpeXZtcHlYWGRn?=
 =?utf-8?B?ZVFJTFB2WFlJRXlYOWFJZGk0NkZmQW14ZndPck1RZVMxemNucmVaanNlRVc0?=
 =?utf-8?B?b1JHWkFucXlnSGFzSktvNUczZkNRZ01Oa0wwVytaU01pSmhiT0czZTNNVWRj?=
 =?utf-8?B?ZmVaelpvdFRsVk15KzN0SGg0bm55T1VPZUFyOVlSWFpzYlliYkoyNXZWMmFq?=
 =?utf-8?B?TnJwdkh0ODF1dUdNSzZLc1Z2MXpQMFhpaEk1WGNKWVFrcWE0RzFmRTJZMks2?=
 =?utf-8?B?cUVmOTVwcWJZNGRUV09GRG9kaVN3NXNYRTQ5SFNFazZIZy9PekVBbTVpOVQ3?=
 =?utf-8?B?ZW1wV1ZxMWFHa0NPSGl3MjhiT1YwMi9LdGV1S0FoaEVWY1ViS2FybnhGZkxI?=
 =?utf-8?B?dUF5V21lNXRNVFNPTFBNOWlhMGRHbW5KTHUyQmxYVTg2S1M5YjhLOVVybk9D?=
 =?utf-8?B?N0F6bXlHUGZ3dDZJNUhjUEROditPRklJeDhrNFhGRHcvUTJRQk93SWdvRVpl?=
 =?utf-8?B?WXhVZG4rNDNLSWJoaWRORlhpNmlOTTNucDlsZUp5dXExUktKM1lqSjBiNnp6?=
 =?utf-8?B?blZQTG1uUDFDUEZaRmZ5Tzl1Wk5pa1VCT0ZVblIyak45cGh1cGEwSE5MOWVW?=
 =?utf-8?B?b3FneHA2b0NSWFBBaklNbmVHaU9OY0s3aFNna3hVUXBYeVRBOHgzUDhIOXMx?=
 =?utf-8?B?V05ITkgrOTBPbkorbGNJL2pGYUVTZExQMjRweXZ5MytvUHh2bC80Y09RWVMr?=
 =?utf-8?B?QkRZZlZ1c1BaSkNBUS9RbEQwUDFaemJvNHBJZERXcnNncExmb0ozeEZMT21U?=
 =?utf-8?B?VFpFTEl5c3B6ZXlIZnJwWlRyM0I5SmNwb3g0ZGRiMCsxY294dnBTM0syVFZY?=
 =?utf-8?B?V2J5c1BSaGkyZ0ZCakFpUzllbjlCa2RDY3dVL2dvdjcwMnZ4VEw2NVBhOXpQ?=
 =?utf-8?B?dTROSmNIdXBVOVRCWXlOT1lFdVpIV1MwYkdxWXZaVFE5d0VtOHdzaERwZkJs?=
 =?utf-8?B?L1lCa3lzc3JkK2J6T0F4emIzcGlYZW5oNGZLYTJXUk9hbDJxL2NaZG1vd2pH?=
 =?utf-8?B?anc1MThHaUJMam1tUU9vS0NCZTY4RnlFcjltU2p6M0ZvL1ArUEl0UlFRbDRu?=
 =?utf-8?B?czBjbHVNUVdIMGoxVVkyRThEMVArTTFRMzZ0NGdkNzVqNVR1dDBGcHRPdGZj?=
 =?utf-8?B?YUlIYUZjRmZ1MW8xQ1dEN1Z2R214RGg0RWxKcXRmdTc2V1RHNmk2aFRTVnFR?=
 =?utf-8?B?aldUdUFOOUMrSkcrYjVuM0pUdHdoUm45Tm1ObkxJeFR1SjRPNlF0YXJuNVdF?=
 =?utf-8?B?bFYvS3RrVE5FZm1ZbEVkTTB4clJINFVpaWZVaUtoMzl6d2ZSdXNtMDZwdm1w?=
 =?utf-8?B?NjJseW1QVjVFZTNTYWYxZ0xmUFhIbThZVXI4QkRkZ0lxbEJIVUliMFNqSXJG?=
 =?utf-8?B?bTRVanBYejlTNitCN3ZZTlNYazhzRGYySm9RUG5ETTAxaTFZMGcvRmpJanYz?=
 =?utf-8?B?WmRRVmFtL0s5eHhYZ1J5Mk9YR1NqZGc2a3RHUFBrR3JFYUFUd1BaZnBIUjBX?=
 =?utf-8?B?bldVanVGem5EQjB2elVJZ0JNcXVxcnJhTEhyWXBpaGgzRm1KS05kUWN3N3Vq?=
 =?utf-8?B?a2NUdlVXdW51SFpCKzFETlcwTjduejdUalg2Tk1XdFFRVVJNMzQ1RXgveDFv?=
 =?utf-8?B?WTcvU1RDQ0ZVOWlnekRWTUIxalZpaWZ3cWNQc3VremRLNWtPVnRPdVFkOEV5?=
 =?utf-8?Q?S/LygAc+/tARmeblMuIFdgVmY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed046633-774b-4229-e4b4-08dd0a515f32
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 17:24:36.9147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ixg6Mb/zYjr3vrKuO1BZ9HM37OPLliAtS5nEXnBOgXE1+qxCWs8v1jsgBX/RpgewXR/OFYZIbS0qUbmiNbw1Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4202

On 11/21/24 10:56, Sean Christopherson wrote:
> On Thu, Nov 21, 2024, Ashish Kalra wrote:
>> On 11/20/2024 5:43 PM, Kalra, Ashish wrote:
>>>
>>> On 11/20/2024 3:53 PM, Sean Christopherson wrote:
>>>> On Tue, Nov 19, 2024, Ashish Kalra wrote:
>>>>> On 10/11/2024 11:04 AM, Sean Christopherson wrote:
>>>>>> On Wed, Oct 02, 2024, Ashish Kalra wrote:
>>>>>>> Yes, but there is going to be a separate set of patches to move all ASID
>>>>>>> handling code to CCP module.
>>>>>>>
>>>>>>> This refactoring won't be part of the SNP ciphertext hiding support patches.
>>>>>>
>>>>>> It should, because that's not a "refactoring", that's a change of roles and
>>>>>> responsibilities.  And this series does the same; even worse, this series leaves
>>>>>> things in a half-baked state, where the CCP and KVM have a weird shared ownership
>>>>>> of ASID management.
>>>>>
>>>>> Sorry for the delayed reply to your response, the SNP DOWNLOAD_FIRMWARE_EX
>>>>> patches got posted in the meanwhile and that had additional considerations of
>>>>> moving SNP GCTX pages stuff into the PSP driver from KVM and that again got
>>>>> into this discussion about splitting ASID management across KVM and PSP
>>>>> driver and as you pointed out on those patches that there is zero reason that
>>>>> the PSP driver needs to care about ASIDs. 
>>>>>
>>>>> Well, CipherText Hiding (CTH) support is one reason where the PSP driver gets
>>>>> involved with ASIDs as CTH feature has to be enabled as part of SNP_INIT_EX
>>>>> and once CTH feature is enabled, the SEV-ES ASID space is split across
>>>>> SEV-SNP and SEV-ES VMs. 
>>>>
>>>> Right, but that's just a case where KVM needs to react to the setup done by the
>>>> PSP, correct?  E.g. it's similar to SEV-ES being enabled/disabled in firmware,
>>>> only that "firmware" happens to be a kernel driver.
>>>
>>> Yes that is true.
>>>
>>>>
>>>>> With reference to SNP GCTX pages, we are looking at some possibilities to
>>>>> push the requirement to update SNP GCTX pages to SNP firmware and remove that
>>>>> requirement from the kernel/KVM side.
>>>>
>>>> Heh, that'd work too.
>>>>
>>>>> Considering that, I will still like to keep ASID management in KVM, there are
>>>>> issues with locking, for example, sev_deactivate_lock is used to protect SNP
>>>>> ASID allocations (or actually for protecting ASID reuse/lazy-allocation
>>>>> requiring WBINVD/DF_FLUSH) and guarding this DF_FLUSH from VM destruction
>>>>> (DEACTIVATE). Moving ASID management stuff into PSP driver will then add
>>>>> complexity of adding this synchronization between different kernel modules or
>>>>> handling locking in two different kernel modules, to guard ASID allocation in
>>>>> PSP driver with VM destruction in KVM module.
>>>>>
>>>>> There is also this sev_vmcbs[] array indexed by ASID (part of svm_cpu_data)
>>>>> which gets referenced during the ASID free code path in KVM. It just makes it
>>>>> simpler to keep ASID management stuff in KVM. 
>>>>>
>>>>> So probably we can add an API interface exported by the PSP driver something
>>>>> like is_sev_ciphertext_hiding_enabled() or sev_override_max_snp_asid()
>>>>
>>>> What about adding a cc_attr_flags entry?
>>>
>>> Yes, that is a possibility i will look into. 
>>>
>>> But, along with an additional cc_attr_flags entry, max_snp_asid (which is a
>>> PSP driver module parameter) also needs to be propagated to KVM, that's
>>> what i was considering passing as parameter to the above API interface.
> 
> Doh, right, I managed to forget about those module params.
> 
>> Adding a new cc_attr_flags entry indicating CTH support is enabled.
>>
>> And as discussed with Boris, using the cc_platform_set() to add a new attr
>> like max_asid and adding a getter interface on top to return the
>> max_snp_asid.
> 
> Actually, IMO, the behavior of _sev_platform_init_locked() and pretty much all of
> the APIs that invoke it are flawed, and make all of this way more confusing and
> convoluted than it needs to be.
> 
> IIUC, SNP initialization is forced during probe purely because SNP can't be
> initialized if VMs are running.  But the only in-tree user of SEV-XXX functionality
> is KVM, and KVM depends on whatever this driver is called.  So forcing SNP
> initialization because a hypervisor could be running legacy VMs make no sense.
> Just require KVM to initialize SEV functionality if KVM wants to use SEV+.

When we say legacy VMs, that also means non-SEV VMs. So you can't have any
VM running within a VMRUN instruction.

Or...

> 
> 	/*
> 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> 	 * so perform SEV-SNP initialization at probe time.
> 	 */
> 	rc = __sev_snp_init_locked(&args->error); 
> 
> Rather than automatically init SEV+ functionality, can we instead do something
> like the (half-baked pseudo-patch) below?  I.e. delete all paths that implicitly
> init the PSP, and force KVM to explicitly initialize the PSP if KVM wants to use
> SEV+.  Then we can put the CipherText and SNP ASID params in KVM.

... do you mean at module load time (based on the module parameters)? Or
when the first SEV VM is run? I would think the latter, as the parameters
are all true by default. If the latter, that would present a problem of
having to ensure no VMs are active while performing the SNP_INIT.

> 
> That would also allow (a) registering the SNP panic notifier if and only if SNP
> is actually initailized and (b) shutting down SEV+ in the PSP when KVM is unloaded.
> Arguably, the PSP should be shutdown when KVM is unloaded, irrespective of the
> CipherText and SNP ASID knobs.  But with those knobs, it becomes even more desirable,
> because it would allow userspace to reload *KVM* in order to change the CipherText
> and SNP ASID module params.  I.e. doesn't require unloading the entire CCP driver.
> 
> If dropping the implicit initialization in some of the ioctls would break existing
> userspace, then maybe we could add a module param (or Kconfig?) to preserve that
> behavior?  I'm not familiar with what actually uses /dev/sev.
> 
> Side topic #1, sev_pci_init() is buggy.  It should destroy SEV if getting the
> API version fails after a firmware update.

True, we'll look at doing a fix for that.

> 
> Side topic #2, the version check is broken, as it returns "success" when
> initialization quite obviously failed.

That is ok because you can still initialize SEV / SEV-ES support.

Thanks,
Tom

> 
> 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
> 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
> 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> 		return 0;
> 	}
> 
> ---
>  drivers/crypto/ccp/sev-dev.c | 102 +++++++++--------------------------
>  include/linux/psp-sev.h      |  19 ++-----
>  2 files changed, 28 insertions(+), 93 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index af018afd9cd7..563cc235b095 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -69,10 +69,6 @@ static char *init_ex_path;
>  module_param(init_ex_path, charp, 0444);
>  MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
>  
> -static bool psp_init_on_probe = true;
> -module_param(psp_init_on_probe, bool, 0444);
> -MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
> -
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -1306,11 +1302,13 @@ static int __sev_platform_init_locked(int *error)
>  	return 0;
>  }
>  
> -static int _sev_platform_init_locked(struct sev_platform_init_args *args)
> +int sev_platform_init(int *error)
>  {
>  	struct sev_device *sev;
>  	int rc;
>  
> +	guard(mutex)(&sev_cmd_mutex)
> +
>  	if (!psp_master || !psp_master->sev_data)
>  		return -ENODEV;
>  
> @@ -1319,36 +1317,17 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> -	/*
> -	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> -	 * so perform SEV-SNP initialization at probe time.
> -	 */
> -	rc = __sev_snp_init_locked(&args->error);
> +	rc = __sev_snp_init_locked(error);
>  	if (rc && rc != -ENODEV) {
>  		/*
>  		 * Don't abort the probe if SNP INIT failed,
>  		 * continue to initialize the legacy SEV firmware.
>  		 */
>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> -			rc, args->error);
> +			rc, *error);
>  	}
>  
> -	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
> -	if (args->probe && !psp_init_on_probe)
> -		return 0;
> -
> -	return __sev_platform_init_locked(&args->error);
> -}
> -
> -int sev_platform_init(struct sev_platform_init_args *args)
> -{
> -	int rc;
> -
> -	mutex_lock(&sev_cmd_mutex);
> -	rc = _sev_platform_init_locked(args);
> -	mutex_unlock(&sev_cmd_mutex);
> -
> -	return rc;
> +	return __sev_platform_init_locked(error);
>  }
>  EXPORT_SYMBOL_GPL(sev_platform_init);
>  
> @@ -1441,16 +1420,12 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> -	int rc;
>  
>  	if (!writable)
>  		return -EPERM;
>  
> -	if (sev->state == SEV_STATE_UNINIT) {
> -		rc = __sev_platform_init_locked(&argp->error);
> -		if (rc)
> -			return rc;
> -	}
> +	if (sev->state == SEV_STATE_UNINIT)
> +		return -ENOTTY;
>  
>  	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>  }
> @@ -1467,6 +1442,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	if (!writable)
>  		return -EPERM;
>  
> +	if (sev->state == SEV_STATE_UNINIT)
> +		return -ENOTTY;
> +
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>  		return -EFAULT;
>  
> @@ -1489,12 +1467,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	data.len = input.length;
>  
>  cmd:
> -	if (sev->state == SEV_STATE_UNINIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			goto e_free_blob;
> -	}
> -
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>  
>  	 /* If we query the CSR length, FW responded with expected data. */
> @@ -1584,7 +1556,6 @@ static int sev_get_firmware(struct device *dev,
>  	return -ENOENT;
>  }
>  
> -/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW */
>  static int sev_update_firmware(struct device *dev)
>  {
>  	struct sev_data_download_firmware *data;
> @@ -1732,6 +1703,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	if (!writable)
>  		return -EPERM;
>  
> +	if (sev->state == SEV_STATE_UNINIT)
> +		return -ENOTTY;
> +
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>  		return -EFAULT;
>  
> @@ -1754,16 +1728,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	data.oca_cert_address = __psp_pa(oca_blob);
>  	data.oca_cert_len = input.oca_cert_len;
>  
> -	/* If platform is not in INIT state then transition it to INIT */
> -	if (sev->state != SEV_STATE_INIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			goto e_free_oca;
> -	}
> -
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>  
> -e_free_oca:
>  	kfree(oca_blob);
>  e_free_pek:
>  	kfree(pek_blob);
> @@ -1882,15 +1848,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	void __user *input_pdh_cert_address;
>  	int ret;
>  
> -	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->state != SEV_STATE_INIT) {
> -		if (!writable)
> -			return -EPERM;
> -
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			return ret;
> -	}
> +	if (sev->state != SEV_STATE_INIT)
> +		return -ENOTTY;
>  
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>  		return -EFAULT;
> @@ -2296,6 +2255,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  {
>  	int error;
>  
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +					 &snp_panic_notifier);
> +
>  	__sev_platform_shutdown_locked(NULL);
>  
>  	if (sev_es_tmr) {
> @@ -2390,9 +2352,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>  void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> -	struct sev_platform_init_args args = {0};
>  	u8 api_major, api_minor, build;
> -	int rc;
>  
>  	if (!sev)
>  		return;
> @@ -2406,27 +2366,18 @@ void sev_pci_init(void)
>  	api_minor = sev->api_minor;
>  	build     = sev->build;
>  
> -	if (sev_update_firmware(sev->dev) == 0)
> -		sev_get_api_version();
> +	/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW. */
> +	if (sev_update_firmware(sev->dev))
> +		return;
> +
> +	if (sev_get_api_version())
> +		goto err;
>  
>  	if (api_major != sev->api_major || api_minor != sev->api_minor ||
>  	    build != sev->build)
>  		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
>  			 api_major, api_minor, build,
>  			 sev->api_major, sev->api_minor, sev->build);
> -
> -	/* Initialize the platform */
> -	args.probe = true;
> -	rc = sev_platform_init(&args);
> -	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			args.error, rc);
> -
> -	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
> -		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
> -
> -	atomic_notifier_chain_register(&panic_notifier_list,
> -				       &snp_panic_notifier);
>  	return;
>  
>  err:
> @@ -2443,7 +2394,4 @@ void sev_pci_exit(void)
>  		return;
>  
>  	sev_firmware_shutdown(sev);
> -
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
>  }
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea8585..def40f7ea01d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -790,19 +790,6 @@ struct sev_data_snp_shutdown_ex {
>  	u32 rsvd1:31;
>  } __packed;
>  
> -/**
> - * struct sev_platform_init_args
> - *
> - * @error: SEV firmware error code
> - * @probe: True if this is being called as part of CCP module probe, which
> - *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
> - *  unless psp_init_on_probe module param is set
> - */
> -struct sev_platform_init_args {
> -	int error;
> -	bool probe;
> -};
> -
>  /**
>   * struct sev_data_snp_commit - SNP_COMMIT structure
>   *
> @@ -817,7 +804,7 @@ struct sev_data_snp_commit {
>  /**
>   * sev_platform_init - perform SEV INIT command
>   *
> - * @args: struct sev_platform_init_args to pass in arguments
> + * @error: SEV firmware error code
>   *
>   * Returns:
>   * 0 if the SEV successfully processed the command
> @@ -826,7 +813,7 @@ struct sev_data_snp_commit {
>   * -%ETIMEDOUT if the SEV command timed out
>   * -%EIO       if the SEV returned a non-zero return code
>   */
> -int sev_platform_init(struct sev_platform_init_args *args);
> +int sev_platform_init(int *error);
>  
>  /**
>   * sev_platform_status - perform SEV PLATFORM_STATUS command
> @@ -951,7 +938,7 @@ void snp_free_firmware_page(void *addr);
>  static inline int
>  sev_platform_status(struct sev_user_data_status *status, int *error) { return -ENODEV; }
>  
> -static inline int sev_platform_init(struct sev_platform_init_args *args) { return -ENODEV; }
> +static inline int sev_platform_init(int *error) { return -ENODEV; }
>  
>  static inline int
>  sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
> 
> base-commit: 43fb83c17ba2d63dfb798f0be7453ed55ca3f9c2

