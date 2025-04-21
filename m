Return-Path: <kvm+bounces-43724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56138A95655
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 20:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 445537A3F4D
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 18:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3401DF27D;
	Mon, 21 Apr 2025 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x/aAtVwp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA904690;
	Mon, 21 Apr 2025 18:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261845; cv=fail; b=YXE1mqrchvR2OxEDVAzu0eEPsH5cAJ1fo12uHU4mxjHZuF1ydm9WSPm3fm0so3i+pmm75eRjEyHu3wdPkr4TXjpsRZXc4xSE1Ytjm63WVuLOkqo2B5JUUV9i6vgkX5/za9Qz4gQ9oAOuUUSgJmiylc4P9EylqlD1uM0QJ8DUlkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261845; c=relaxed/simple;
	bh=VMoEXmaO7OMCOYuCE09SvfqPEgzMS6ShPNtAQ/vprKE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P5tTnB0fN8KoHUq4UBR/Wj2JCizXTpQLENQ4t5NpNeQfFu9TZkoms8T5snogtuOKIxtNSfPTcEL4sEPuc4sqrDryrfFmIhSFkiY2/sn4tnwJ9ShlL0ooEft14dfXueotw74iZhJVGBP7wKFfJExJvYnKPxTiaMT4cwm1l19eDrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x/aAtVwp; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ClZlLm9B8yZnByHmZu/mR1u7a2u4e0aohLVhJcOMHPuZPsZvPRZfL9WojaLMI19+x6XXlO/a4RQT/TWtmpqqXORDEPQkI9De0nUu64giDAWOP85l+E88z7t4UYtGcpabPpxgF3a4CPAFUWzl1VmAAdlktO6/n2cArvr7dfzfSRixx/zXtE9X2XgA5bYeAFSov1gP9B2lk4uJGatA2UL62z+7JGVmRVaB5a+1VjhTqZQWCyeZqWZew5cNcNc3aKWuJTz149k5ssXtNoxF8RQ/5rdQjePD7Zq65ue4Meu7kH9wqCoy5clMcX3MFP4FMtgRjFI1hOxBGp7A1h9QiLCEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rkdUB19pk1N96F5PJRDD1iJfPk44bWQ5oLPBfp5xL8=;
 b=IXx0W8ZbKpZEmDAN75sJ0gfTO1cUnRXaPzn85AQ/SUXq7MP8cpl3+5Bvy62yzyEToo7uzl1Opr2XiUL4tyoIrJd+WZSvpT5Bs7wEODY1pGimOMtLDTqzkfGU8z0wDIuk7Yt2yh819rv5+l8MxWkv37hn8kfp3ElACuCIiDaVxRNG2lOa5mbkxw+4tereamohuwdWflTLe47pin/Wzyzh0nstlOHG7XJcgLYbQNVViFtkp9ILzvwaFKhqPzVyHHiqUCzEHszfMQKkD59KCWCu4ti7/JmsVnb4EZAlCaAKHpwW+1V0VhkB5b5XNFyf1q7+/mOMuSJqf/SPItntnEUJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rkdUB19pk1N96F5PJRDD1iJfPk44bWQ5oLPBfp5xL8=;
 b=x/aAtVwpUAq0K/YKgD+ECtLRL9uFV7Bnn3LkoMNeEz/pejCVXzO0yQ7iY0exNvx8AfsRp/qwoda6khE16MenGx+ImzSzaAo0yzvKdAJLzPnxxsM70DNUKurDoVUwx0oCMjanUSGMwBRkoQt7xB2KB20UCeV6nQXphmep/MW5t00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Mon, 21 Apr
 2025 18:57:21 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 18:57:20 +0000
Message-ID: <2cb7bee4-bf24-dc3c-2ccc-675472dd667a@amd.com>
Date: Mon, 21 Apr 2025 13:57:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/29] KVM: add plane info to structs
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-4-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250401161106.790710-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c181caa-9f81-48bf-c77c-08dd81065847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2hsanlINXdMWlhqZi83Mk9hSTFLK1RxNjQ3RWRuTnZQemNHL3VTTHF4OVNX?=
 =?utf-8?B?TU5ybzdQVzJ6OUZwNm1iNmVmSjY4K1p0cmkrK0h5dDRmakpsVko0TndyT2ZP?=
 =?utf-8?B?VmI4Z3grMkh5dUxOUXZQYUJMWXRRaVlCQ0kzbHVPUWJZNjBiZDNRL0pVZm1S?=
 =?utf-8?B?S3AwTXB1aFZJNk03RXV0d0pHWm1vZEhpNlJLZGZHWGJYeHBVcUM2U1ZJMVFt?=
 =?utf-8?B?bUJxRDE0a2kzVS81SXErWUl4TjAxN29GVXFYbVV1UkhyRTIzdDVTdFdVRVJ2?=
 =?utf-8?B?TWdGRjJ4eFVQVU4zOXVhaVo0YUs5ZzlVZEZ1RTh3dnJ5K1U0THcxV3RNMWQ5?=
 =?utf-8?B?WGJmcGZaTFdPVDgzSW5LUC84ejJzSitoU3NIeWR2cTFIcjZSbldsYUpmbVVX?=
 =?utf-8?B?RlVOajZFT1BBVXFTNGtOcWxzOVlza0lxSlh0a2ZQenBrdFU4bTNGc2lHOWxs?=
 =?utf-8?B?QURXc3FtSFZEcmY1Zm1raU9sOVdMMHI2NHYrYmhjei83c2lVSjRnL1JqSmJO?=
 =?utf-8?B?d2xMdVFhaVk4bXNKZGVVM05NdVF3MWFGODc3S2haU2pkQ29UM3VYM2FHQS9p?=
 =?utf-8?B?dnpnZXZyOVNPM3ZwaUFLU3pLeHhVL1FRK2ZGNmcrbExMTFNmYWk5cTFWVXFM?=
 =?utf-8?B?em0wMGd5SmlvdHdhUCsxRmRETTJyK3l5WUwwMDArejZqNlU3UGRGOFVzOHdQ?=
 =?utf-8?B?WHUzRDhCUUdsakRPZ3phVmtDOVVVck5HY2hyTVZpTDJuNlNjOUF0Z3l0Z212?=
 =?utf-8?B?SVh0eXlpR3JSeHJwN2FPTG5aK0p5c3VwU0FFNmFNQUVLL29YYXQvSDVkc040?=
 =?utf-8?B?Ykd6aDhuRFlDTXM4QmdmT2hZSlM2QS9hZm1NQm1CZ3hIcjdGRkVSMlAvUzY2?=
 =?utf-8?B?ZHRScDJjOWM2Sll0QUZlOW5DNjUrd2wzamNpMHNBaWlab25FTHphSGQrczNU?=
 =?utf-8?B?bDVTOFRHNjZhRERuR0RNZ1Nad0tQTWw0M3E2RjFZZHJaT3MrS3RHenEzSXMx?=
 =?utf-8?B?Y0tOOUlnTWcyUHlRQmFXM0xRMHZ6L1NyK0Z2VjZ3Zmg1YkU1ZzNhMG9YYW5z?=
 =?utf-8?B?VHMyeXBmY3ZQaU5zVlFaNGxFQ2dPMVhjYVhQK2JmQXBSL2pCOWI3c04rdDA4?=
 =?utf-8?B?UHdOSDdEczJSbFgrU2x0SzZkY2cvZE1YdXFxMk83L1hLamRpTGhBdko4WGJu?=
 =?utf-8?B?bE5KYjk1SlI4UGNJbnFJYzR4U1MweGxBRnNoaklMYk54K3hpblVCTmkwMDY3?=
 =?utf-8?B?RENYM0haMjl5YldYbmJNYkh1MDFNbU90OEYxRXRJQ050OTFzcnZZRDJzNU1r?=
 =?utf-8?B?VFBnMGhPd3hQYVlQckpWN3Zob29NZGhyd29vTW9YMkpEUVE4WFJtMVZaZTlq?=
 =?utf-8?B?WTVicFladk1iSnBwYjZJZUJ0eHZiWlphK3ZDeVBzbU5UM2F2bFE1NkNCTGxr?=
 =?utf-8?B?QllCWVlsOHFDTWtnb1o4cGRyTDdYdU1RTGlQL1NJNXNrdGY3RG94MnBWeENM?=
 =?utf-8?B?Wk5sNnVqOVVyTHZrR0szMVRHbkQwQ3hpMFlUNHNGSUFqSTBreW45dkJHM2Z0?=
 =?utf-8?B?Q3dEZ1FuMDFYWTFXNDg5OUUrKzZ0SDhoVzhscGtRa3N0MWtBVy95NVhWMW1x?=
 =?utf-8?B?elQyK3JybVRpekUwRVJjRkVyMDVWRGhQVlc0eEwzVllJd1puZGliNkZnSnNY?=
 =?utf-8?B?KzRZazQ0N25EZW1nMi9TNVlzbjQySGJ6NGpXQ3l4bDR0RStpVC81ZXpYZkZZ?=
 =?utf-8?B?N0h6VGlLb1VBVlE4N2JtcXYyQ2pCbXJhczNveVEzVlNndkVlWDRmcTNmaEFj?=
 =?utf-8?B?UW01a3czVWtiOFVNSzA2K1d6MVRodHFhc2UveTNrQzZKeEd6bHZUQWgybUIv?=
 =?utf-8?B?K3hLazR2ZlE5V2JUbkp3VWt5NzJ1bVY4NXhsS0o5akl3M0I2dGRnREw5MDNh?=
 =?utf-8?Q?c0eTMsubzUc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzQ3YjZLMnBJOTBwZ0RBVjFzUkFHTnNBL2FaSU9UbnErUG5CYnFsQzg0RzU1?=
 =?utf-8?B?U2RvL20vSzBHejJNSmtDOTA5djd2K252cVlvSlppYWtlaWFOdlVBUm0wMDNm?=
 =?utf-8?B?TWdjRHNZZm9SL2d4VUNJS0ZodlZ5TCtkYjJNZHU1eEl4QnA0SXp4RlF0M0NP?=
 =?utf-8?B?dnQzcS84a1NXV0diblVLMUdWS3FnbXdiNVo0OXpNTGJLOUxsVHBqcTJlRlJy?=
 =?utf-8?B?dVA1b0JOemR5S2daRkkvdXVQQ2xWMTRmd3RaYnFxT3ZBOHNWMmJjQkpaamRt?=
 =?utf-8?B?VkpudmJmdVA2a25MS3VvNnppN3IvSUNIcGJHSEtrSjgxTnJFbnVpYzJ2UVVj?=
 =?utf-8?B?dVZlcW9Pem1iOGRaTVNaQ2dJRW9IUW81UEZieENWc2paK2pLb3grQmhwUUNq?=
 =?utf-8?B?QUhObEEvWEpNV0NGeGE0dWkwSjR5dXRIaCtnWm5YaFArOU9WdkRSQUVIcUhU?=
 =?utf-8?B?OHJObmJZeDR3SjZOZDVzVTFpUm1hL0ZEWHlWKzNvaUhpNCt1VDNOdXZjb0l5?=
 =?utf-8?B?V1RSTERqL2tydm93alRPdXZGYk02Tk55N25ZWmRqYzZWelZJd2l0ci9lam5U?=
 =?utf-8?B?SXJ4VWhKVEtPVDFDZ2ZYdElwTC9pSVFySkRpdWJzd3R0VG81azVvMkJLTUlG?=
 =?utf-8?B?OXZ1RkJHQS9DUCtoRTFTdW5XZnpWcWI4Wis0SWhjdUhxYi9sNDUzYXIzR3dC?=
 =?utf-8?B?WlJtYnd6aVlwOUpxZ1gyaVV0ZFJIUjl1S1B0clZxcE8zNVY1WTIxb2tqOWls?=
 =?utf-8?B?SHRKdDFoemJiek1aOEc1dHNZektXSDhtMFc4Z3NmRGpFcS91VkxMVWN0dDlP?=
 =?utf-8?B?MEM4OUxlb1VJQlJ6VzBtaXBEazM2eTNWZHI5NHRBK2pDL2U4V2VjODlNS2VO?=
 =?utf-8?B?UUNGQkJhTzdKRmVNUGFWZmo3TlE0alFMbkpIOExCNitsZlFqMWZlMVlGMmhU?=
 =?utf-8?B?MEdNY0Y2OWIyR2tSN0VCUGZ3VnVNY2dwSmZrTUVWbTVRVVpHS2l5TjkvalRr?=
 =?utf-8?B?T3VhVkRiL29VZHdQQ2ZSZ2FtcVFXaitqUk5uaFVSVmJkbVphOWw2RytSQ0hn?=
 =?utf-8?B?TjFzNlVzOWgvRVFucjREdTFDR0I2anZDU0ZoditRTU80T3NGRlBicElOamw4?=
 =?utf-8?B?Y3luS2Nqb2lSUUhRSFJ1SnFFWFJmMzdjNlV5TVpGelNSeWttdnExb1BxS01v?=
 =?utf-8?B?aTM1bGdTSGVRczNpQzd0eW9MaDJDeUZRTFFvSXhMdlpCaUxWejZ0RSt1Uk54?=
 =?utf-8?B?czk2elNOczZZSWVKN2tYdC9LOFNOQzJKbnRFNGszYUY3WEZoWDEzRndrSkZu?=
 =?utf-8?B?SmhrcW1RY1hGS0dlbnd3aFUvTjE3anQ3QWplMDNKMVE5bWd3Wm9ZWkZRVmxx?=
 =?utf-8?B?NUt1Sy9GRzNFYXJENFUrRFloNGhzdmQ2VDBIVUk1Z1RDVHg1aFRKVlJaWDE1?=
 =?utf-8?B?NTh6WGhqbzFabkprcEl3aWcyamM4SWtlSEdJOVlwVVdldGh3cGhjcE5xWHJM?=
 =?utf-8?B?SVdKd1RuOWZ0V2FyOHAvTE5DbTRnR29YaWFjeW93bG1EejRMc1Y2L3NaSE1C?=
 =?utf-8?B?Wmc5aWc3K1RTQXlwbFo3eldhMU5uZXFRRmN1RytSRHR6cnZWVFkxSnREYS9G?=
 =?utf-8?B?QWcveHR5cFVEamV4dWdoZU1jSzlCN3JTRU1wWEhkRTY4YWlNY1cxVFVRS0NJ?=
 =?utf-8?B?bjM3YXpCOE1yMWU4Vm9LV2pEc0VTb0dxNFVBbzIzWWtOY3FDdTcySTQrYVBq?=
 =?utf-8?B?VUhhNjBwODIwZ1pTOFJReG1RL1Ntdm5HRU94Y3dFMDgvcVZTYzZ2a1Y5MUlK?=
 =?utf-8?B?SjUvcHdNZXorOElCS0krMkRObVBicDh3N3BPbG5nT0l6OVRFYWZCNHRvSmNs?=
 =?utf-8?B?NStmajNHWEo3aVpydnRXVUoxL2dBTXd2bWhEczljWitRL2o0UVdlZktHOU03?=
 =?utf-8?B?Vys0VS9FdVRBYlVzNFc0TnU2SHFxUTg3STNRaXk5UjhSWmE5ZHlHNTAwNVJq?=
 =?utf-8?B?QUpFMmZlUHN2MW9tWDV2cmp2SXdaVmo2OVZWeEU3WFlTcmFjbDRFR1dCTXd2?=
 =?utf-8?B?UXFpZ1BYSnhoRmxndTJVbWoybktXZ0V0b29OYVhKSTVnSC82dGllbGF6YzJQ?=
 =?utf-8?Q?YLuRimOdH1QaCgdK00C7y5VOb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c181caa-9f81-48bf-c77c-08dd81065847
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 18:57:20.9022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fFE33o5N3NEPSneMcE+U4KivmS6/hM7iDZYv/CmXBohkw/MLSaPkAITlfAZPLAl3MDP0BzsaKza/HLPZ4tuShA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775

On 4/1/25 11:10, Paolo Bonzini wrote:
> Add some of the data to move from one plane to the other within a VM,
> typically from plane N to plane 0.
> 
> There is quite some difference here because while separate planes provide
> very little of the vm file descriptor functionality, they are almost fully
> functional vCPUs except that non-zero planes(*) can only be ran indirectly
> through the initial plane.
> 
> Therefore, vCPUs use struct kvm_vcpu for all planes, with just a couple
> fields that will be added later and will only be valid for plane 0.  At
> the VM level instead plane info is stored in a completely different struct.
> For now struct kvm_plane has no architecture-specific counterpart, but this
> may change in the future if needed.  It's possible for example that some MMU
> info becomes per-plane in order to support per-plane RWX permissions.
> 
> (*) I will restrain from calling them astral planes.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h  | 17 ++++++++++++++++-
>  include/linux/kvm_types.h |  1 +
>  virt/kvm/kvm_main.c       | 32 ++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 1 deletion(-)
> 

>  
> +static void kvm_destroy_plane(struct kvm_plane *plane)
> +{
> +}

Should this be doing a kfree() of the plane?

Thanks,
Tom

> +
>  static void kvm_destroy_vm(struct kvm *kvm)
>  {
>  	int i;

