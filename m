Return-Path: <kvm+bounces-37316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6FE2A286FC
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53FDF3A8195
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 09:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7283B22B8BF;
	Wed,  5 Feb 2025 09:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AqpxC1lu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2066.outbound.protection.outlook.com [40.107.96.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B28622B5AD;
	Wed,  5 Feb 2025 09:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738749079; cv=fail; b=GUoosFrDziqNiFOHhOxO3opGhjU5zDLv8UKehuCpy5dmkvziCKSawKyTzAlJ/SXQQvM/QWAM+wiS+ngwQSDRN709B//y08Q7bWdo0XojusycMPO+yK5WX2oeCo0o0FR/Nl56nt3LCzzOfche23LZKdfzO6XGmH3Rb5Fs0+AI548=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738749079; c=relaxed/simple;
	bh=xvWBQwFLKkMO0mL/fm4/s7Zt8pH5+wgZfE0A2M5Qdl4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AEX1wQF5em8VJGGZnsgoOdv/dJZ2GKqninfr4rOWTzwycdO/0TI1/yOVngdKVxDtHEJnj+uBKMNVJ21ipd5oigMCcZOP5eRf/GzsFs/VVF5WWdThHkTiQZNt6Db06Sr6PNWCs8bjcKC7NFejvKcGkvqaBnVkdWT0Di8hroklkYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AqpxC1lu; arc=fail smtp.client-ip=40.107.96.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCTJAfRsXLhE+KnT0xRo5H7QjocRStq239JAHx4rSppaGLXqPs6RGuIAMuWw+W4UIltL4ON9fiJc96dh41FU0bCSFxbvlBdJW9aVu2s9x2g4QPNBxdS/qbXUTcIoJFR/nn8iXK9wxZefRTu34LZolTRc10TA1pfEcB60VGVlgKwkylJ6n0WzHJ7Ltzcste+WBkfLAMpDoz6rQeAz24A3BopXHzlcWrF2Y/sI7FjyOFMn0X6pxtiIOij6VxS5wZhdbX5meeMR8PkFje/yymmFD6EWWuMI3uduhiOVd2MTtDQygX67LGhOJczE83ppG32z1MLYWnQPLNXGJdPa9aeDSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jlqRJEmW8dAwxvzWxuh7bIWHzDiFRIwe7jqsFoKxBU=;
 b=F5n+r0C7xe4t8THd0/ieT0LBGt2jdzvd26NvPaEaafuXlyv55XBrHCjUt0hIqW3a9tBTibXhhY/8x9gjODwVs+iWs1s3do3NgdDMLXnEVZvOl4RPcy4/GkZvhyqohJ2zm8GEeoA+EgjK9fUO+CJvGdr9+UCa0Z8eELuVVA97PJuicd7IICra7SctaNjn3EAdi4Sv+NkTkY+m8Qy7mtph50UTxVhHnIcdPaDE49UH7ipzkR3y8c/69anhua0mT7vjgD+Ui++sZq7PoLrKNOV9X5ll2B612iP3rHn+98enTE6u716SFnPOoT9ouNU8shE9B3b4NlMAo1gj0WQnH0lpSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jlqRJEmW8dAwxvzWxuh7bIWHzDiFRIwe7jqsFoKxBU=;
 b=AqpxC1luP9alnxoZmiEfZI2SuaC9+WXirLBvP1vqRGUrUHmBn8265uOCVILmZDfYLF0F93UGiqrL+Kiqx8oJGTB5GiWyEuFYumTosxrb+4hS3xfqh16VdmrdYqyYQWH21nzgLayQ4xFd1OXTXcsRCidETZy9WG3UBoUu/CPgPy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH3PR12MB8727.namprd12.prod.outlook.com (2603:10b6:610:173::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 09:51:15 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 09:51:15 +0000
Message-ID: <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com>
Date: Wed, 5 Feb 2025 15:21:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module
 built-in
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::19) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH3PR12MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: e3a60366-369c-4cde-2453-08dd45caa13d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b01WUEZZZUtXNVhCMjRHdW1yVFkxQVd2Mk1qUlJKSjBUL2Z1MXduN3dmWWRY?=
 =?utf-8?B?QnNkcjVxdnV3YUw5L1FKTnhjSTQ4UkRibGtoQy9aWHFiTnBHaEprLzk2VG1V?=
 =?utf-8?B?bDAyYmpsdXIybGY5TTVJVjgzQ2pYaHh2di8rMTBjcHArS0NZMGk1UklrQmRN?=
 =?utf-8?B?RTRIRTZKN2hubHZLdnkvQVUzYkYrWUtkSW5PL1FreVA0MkJINUViWHJ3cm5W?=
 =?utf-8?B?NEdXaTJ4T1JvdGF4OE5XamFLTXNaYTNGUG9KZm5pT1NxVnlGWlpnRXVqT2RP?=
 =?utf-8?B?WGhqeFhaSW1TbldrL3BBN2dPMVpmeWErL3lIdzFTdTQyRUxYQ1VRZmg1cHpz?=
 =?utf-8?B?RFhoT1BHUjJLTyt6cnNNaVBZaXMxUlJPYW9hbzF6SXYvRmJ0QXpKbENVVDZj?=
 =?utf-8?B?ZFM0bU13a0t3akVtV0Rod2xrVm1JWEhuUkMyQmpZMExkNzN0UFRBNmhSZkQ3?=
 =?utf-8?B?aXVHdU9ZQS9zWGVRUGhOaFJUaHlZallzbUVmOVNURWNGQ0xUcjFNNVlHVUJh?=
 =?utf-8?B?Vjh4dWc1RTFwbHBVclhLaFpEcWM5cnd5cmtRY0F0NnlJZUFXSlY0U2pJRUNn?=
 =?utf-8?B?bThrU25TQjVEYms2SGVxM1JFM0xZcEYwYWFnOENCL1p1Ulk4QUl2RDA5Zkhu?=
 =?utf-8?B?bUNucnB5ekhlUFRaZjVxSU9lTm1GLzlvRzlVUlBOVWRpYWIvaENLbmhQTjA0?=
 =?utf-8?B?RUlveThvMStVcU5jbXpNS3RKNXd4cS9sWjNBSFBWenQzMEZvbHlWbnZIUUdp?=
 =?utf-8?B?Y2M3ZjBQNWNiY2dzS3k0T0pDWUprR0JKZlRWK2NyTElmdUF2R0g3eFFIRVdj?=
 =?utf-8?B?NGNKQmpqRHI5SUp3V1JmaWF3ZWVIdEU4SzVzZW9zM0Zxam9QYzVtclVPa09X?=
 =?utf-8?B?eUZUY2oyVjE5Sm5pbWQxZ2FNWmVlaXJ2NllEVXZQWTBBSUllUzkxY2RCVkl5?=
 =?utf-8?B?d3I5NWpCTUQwaVpNN0RDUEdTN29jRUMzdUZZUlFmQ2IxNmFFWDhLYTBMT21W?=
 =?utf-8?B?dzY1d2dnUU1YcXJkWEN5WHZPSkJoeW5neTQwbTVIWVRzenRvT1dLWldKS0RM?=
 =?utf-8?B?QjhweldQWFlrcjN4ei9KbzRtTlFnYzFad3A2MmtvUkpJeWc0Z0RSOWpKVDJh?=
 =?utf-8?B?QURBTFBsUzE3T01FcHd2dmdjWWNSOXZGT0FyangxUW80QWZuZDlubzJjTDZJ?=
 =?utf-8?B?WkRRWUk2WDF5bkxaM1EvN2ZncFFzZ25hTXNHSENReFRQMjUxWXI2aS9CTmdZ?=
 =?utf-8?B?OHdrTWJvK3BNSUdPU3RvNzQ1cU9GWUd3akZZZ29ES09jL2pRTGVDd25TYUox?=
 =?utf-8?B?RGNhTFY4R29YUll5eGxyYko1SUErN3ZKSmNrSnFncENvUXZabmRqcnVUdjN6?=
 =?utf-8?B?ZTE2bWVoUUlMVUhZWXBDcU5JR3JESDN1UjZ2c29MK3Z6VTJkZDNwcXBadUVV?=
 =?utf-8?B?cEFrUTJrVW5zS3BXKy9vc1dFWXIxUGxKbTBzdGN5RmFiY1lEaVo1TUdzV2hF?=
 =?utf-8?B?TUVFaDhobHM1TFp4T0k2NkVoVnBEemcvbEtvYWNjSXBWbWF4bllNZjlvZ00r?=
 =?utf-8?B?bVREWHErNFpHcGhOZmVnL3VuckhoWEt1em1FQXdtYUROQ0ZlRi9ubHBJYTdG?=
 =?utf-8?B?Z0l0aFFRREFjOE9Vb1FtMFBuUDlWeTFYTHY3dm4zekhBYzM2UzkrSjY4OG0x?=
 =?utf-8?B?UkVuWnMxZVgrcDZ5Y0lpTjZaRGkwQi9adlZQZ3Bzc1pFYjN6cG1mUVE4N0dw?=
 =?utf-8?B?ZFpzQ3dJM1hQYXZ6UERGSnR5VzlRY0NQVWpOYkZhT3NXVmVwR3JZcVNWK1hT?=
 =?utf-8?B?QVdGcFNOUUErUFRkVzFhWEhoS2dFS2FZTzUycmlSbjl3Wkg2VTNFRElXYS81?=
 =?utf-8?B?WGpBNDhVckhSdFVPU2dMcXFZenlsUnhRaTZ3aTZhc0xqV3RvT1gxWUpnL1Bo?=
 =?utf-8?Q?bAqS7GJDOHM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VmhPZW1DZHA4bC9saW1HNmlOelBNdWJGc3pqakg3KzhldGY1VjRhaVhnam8r?=
 =?utf-8?B?cm9sR3ZtKzlwYlpEUDNJTk1hSlZrUWwrU0IxdjFNMXljb3VBcjRVYUl2bTQx?=
 =?utf-8?B?ckM4b2dFc2V1d2RCT095azJpdDh4dWVDeTRTQzNHRXZFRUY1aEdYL2M0OURx?=
 =?utf-8?B?VFZzVC8vMkVQVk5INFNNUE03UEx6QW1kQTNoSVZNcjk2M3ZSQUZXeFlScnk1?=
 =?utf-8?B?alZtemR4SlBRV1RPZS90NHlJSGZBNjdqOFhvRmFialNzeHNBKzk4c0FLdUt5?=
 =?utf-8?B?OW5wUjVBRFdneGF3UWpXdW4zU1c2dVhYUXR5QUR1Mzd4K3ArVzRuMXB1SUFC?=
 =?utf-8?B?OXl2TkNtc1ZCbWsrQzZ6Ris3SHR0L21FaWZrSG1nV1pOdHpHMkxidFgxSkVL?=
 =?utf-8?B?VHJrRGhZVTFBTHpSRUhFd3R3MVF3RDI1RUlRZnFtRG9iYk80MEgzU2xoWjdy?=
 =?utf-8?B?dG5HNUxMaERCanJkeVIvYm5YN0xqWkZxTnQzSGEveFE3ZlMxeEFiTW9JL3g5?=
 =?utf-8?B?S3B3MjA5Mkt2T003dG44U2l2VHFDb01tSGMyUlV2clo0cFViVC9RQ0lOK0Qx?=
 =?utf-8?B?V1hqU1gyNG5LMWozTHgvWjFzMFFWU0VUUVZ0L0F5YWkxSVIrbGVnSHM0KzY4?=
 =?utf-8?B?akpyTkpYK2ZTSlB6UUd1TytUTU9NVXZ5NkZhcjBZNnhtektxQ25SS0d2WFph?=
 =?utf-8?B?MTlZc2ZQajNXYXFLOGlpeWlzY2dEdGFBYjQvMVd0QllUeDFGejJhK0hWbEtV?=
 =?utf-8?B?MXFBQVZFTVBuOUQvOXFDQnRGcXFLQmZLRnJ4cWtXOTI5cWFQaVJxZXdQaS9a?=
 =?utf-8?B?OHpSQ1Z6WUNJcmowc21qQU9QdWZmd3JuU2pJWi91d1JkN3QwZnV4MTVJTVlF?=
 =?utf-8?B?WUgrVjBLVktHQzdBMVY2MmtBU2lSejhPWTJHdGgxRUtXNnBwUEMrN0VTUTNT?=
 =?utf-8?B?enFJeW1hRGVUTDQrd0FqWUFaYkFwbVVCUkpuMjd6NmRZeWpYY2s4L041Vyth?=
 =?utf-8?B?cnFabHFkZG1WVGtSbWpWSHd4bmtVaVJBeUx6S3NMMDNKbFN5dC9QME5sb2dM?=
 =?utf-8?B?RUEwVFZ5Q0VpMHo4RzJ6U3BLYkZDdW9XRkJuQnl3aDR4ZXZWWnB5MDArSDA5?=
 =?utf-8?B?SCsxYW5QcmFTZDFVRFdzQ1dEVHByKzlvVWhPU0ovbVBMcUdKbHQ5KzExUWV2?=
 =?utf-8?B?TjZVZUZ2WWU2V0dYY3VLcnU0ekpzb1ZjY0FaMU5ZREpBWmRCT2UvcHpSYjhV?=
 =?utf-8?B?V2M5RGZSMTZGTWJVRW5GS09JUXdmRTl0SGNtSWN0OEJsYjZCbGtSWjNCdTNx?=
 =?utf-8?B?QVAvSDhmTGZNbXRwOGxiMUgxT0tJM3dpUGFqQlV0eWpoOEJkcXVWSDZ0aEdq?=
 =?utf-8?B?Nk8xNWxkUlhHR09FR0w5cjU3clhBengvL3B5V3RaWWhvNjVST0NZNnhRTS9D?=
 =?utf-8?B?UHhnemZLeDhyOXRtcjFvYXNSRkxYQ1BiVzBjcjVjSDhNaEVwejJMbDhFeUlu?=
 =?utf-8?B?cnF6OFhtQlUvQXJNbjBYT3oydEZjN2tscHg3T0p5NktpZHNSbXpZUnp6ZnJs?=
 =?utf-8?B?b3A4UmhmNzlzVkhzQ3UrT0x5MUIwRUVwTy8renlGYUh3TnVLTXF4NEwxY3J5?=
 =?utf-8?B?cGhwaXVSNGowbFZ5Z0FyMFlXRjZ5Ti9hNlZFdm1VOGFhcDI0a01rZkRWTWMz?=
 =?utf-8?B?U3hmYm9hZXpGVHRiMmp2LzE3OEVTdk1VczNVbjQvZXpNanFTQi9Id0pkYmtQ?=
 =?utf-8?B?U3VzWi96bXpqVTJOQTYrVGwwcGRWM1Y3eXcvUEtlSDhhWWVnMU9FSUh5MWl4?=
 =?utf-8?B?ZlFjSnFMLy9PbXdXbUM4VGg2TDJ5TzZ2dDgwR2dyeXNMaUdmblloTGN0RDEw?=
 =?utf-8?B?RW5oRHVDUUN1cEx3N3YvNU01Uk9zbzBIRjlZQVlIdUREK0pBN3lVU0tOSTZo?=
 =?utf-8?B?OFZaVWMwOE5SWVBldkMwdjhpbFI1NHVmUGdzbHB3WXQ1QkE0YjExdjZrM2t4?=
 =?utf-8?B?YnM5RTFPbjNjYmdYT0N1UGpJcUFKWUdCUG9ZYWUwVmk1aHlLZC9TYkJhM2Nh?=
 =?utf-8?B?aCtsR1J0SFhyS0hPNFZwUnFxTFlHM3NRMlkxNTV3QWltQ0MvN2tuQUtXNFNE?=
 =?utf-8?Q?rGpJtHNvnA9+6agpPjaB37B8Z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a60366-369c-4cde-2453-08dd45caa13d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 09:51:15.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPkH38WbglogWBAZlSy3DMlgnh4OTvVwqWAcVTpeTN+CXk39zh9WSjD4I9rRnHy8v/5Rvu8pnB++sSQGRMFPZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8727

Hi Ashish,

[Sorry. I didn't see this series and responded to v2].

On 2/4/2025 3:26 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix issues with enabling SNP host support and effectively SNP support
> which is broken with respect to the KVM module being built-in.
> 
> SNP host support is enabled in snp_rmptable_init() which is invoked as
> device_initcall(). SNP check on IOMMU is done during IOMMU PCI init
> (IOMMU_PCI_INIT stage). And for that reason snp_rmptable_init() is
> currently invoked via device_initcall() and cannot be invoked via
> subsys_initcall() as core IOMMU subsystem gets initialized via
> subsys_initcall().
> 
> Now, if kvm_amd module is built-in, it gets initialized before SNP host
> support is enabled in snp_rmptable_init() :
> 
> [   10.131811] kvm_amd: TSC scaling supported
> [   10.136384] kvm_amd: Nested Virtualization enabled
> [   10.141734] kvm_amd: Nested Paging enabled
> [   10.146304] kvm_amd: LBR virtualization supported
> [   10.151557] kvm_amd: SEV enabled (ASIDs 100 - 509)
> [   10.156905] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> [   10.162256] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> [   10.171508] kvm_amd: Virtual VMLOAD VMSAVE supported
> [   10.177052] kvm_amd: Virtual GIF supported
> ...
> ...

.../...

> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index c5cd92edada0..4bcb474e2252 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
>  	return true;
>  }
>  
> -static void iommu_snp_enable(void)
> +static __init void iommu_snp_enable(void)
>  {
>  #ifdef CONFIG_KVM_AMD_SEV
>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> @@ -3219,6 +3219,14 @@ static void iommu_snp_enable(void)
>  		goto disable_snp;
>  	}
>  
> +	/*
> +	 * Enable host SNP support once SNP support is checked on IOMMU.
> +	 */
> +	if (snp_rmptable_init()) {
> +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
> +		goto disable_snp;
> +	}
> +
>  	pr_info("IOMMU SNP support enabled.\n");
>  	return;
>  
> @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>  		ret = state_next();
>  	}
>  
> +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))


I think we should clear when `amd_iommu_snp_en` is true. May be below check is
enough?

	if (ret && amd_iommu_snp_en)


-Vasant



