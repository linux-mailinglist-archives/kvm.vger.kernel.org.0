Return-Path: <kvm+bounces-52697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA76B0848B
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCCA51A66105
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DDC2066CF;
	Thu, 17 Jul 2025 06:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IZI75Dc8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A37928E7;
	Thu, 17 Jul 2025 06:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732357; cv=fail; b=sbnN6x0bFXbswONBKa4nwLL0Zj/0lWiFoc8rwf+UyeH5a+/MoeLaWQgzPHRoJ+JBD8D0/6gDvX4pUsSoFOMmMa7m6itOeqamYDHFMmHyryervDocEWv57s3qU2irnuWThsDTVicS2gGTqJhA/QLiJ9BY3Q2G1AkRqYeWOSs5XtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732357; c=relaxed/simple;
	bh=77wbYnVtF52eLEZREAlemSjl0ts5KAHqZJsNZq+Ct1g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=awPJEpP2vfSK3EWEDbeCFZUfLDb8G/5oyVPFnW/zkjLp6Q6wd5P7svzTIFGDnIc+1aWR0M0Sge5GqjEoMsJRQsAnvRxBZek4yCIJp7REMdGxKkR8SuyxF8A4+R7kzQOB0wSU85ZfN7bG+DsnGXvyaEDBNj2UcoatRmqP2hcajJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IZI75Dc8; arc=fail smtp.client-ip=40.107.102.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cycrxA+wVAkFsjK7Y3CJmZboG70xMCtL+DTcHcZx4SOdaYKTdc4Lfb0KWtpQB1Py2mcAqQaBEaI3imQwqTWnWDI9XU/4wy6NGjVRtqSP1V/kpsgMeAfk+V1bemXe7CdS0fsqm0/2txtD0ammuUAd0P0IaEhw4dpitsCGnjTp8jqcRwiL643JFOc62xJ9SEG/SybItlP4U6zLWdTcNzuDW2JtFtMgaCSBzwyWmKyr5cFpzUEC33oN/j0xyJDvNj+0Ie5r4/nw9YxCLniM0cjFhtLN9lAX8eGjQCir/uHCxiA1Si3G+/ANJuwwxSMi3QiUfYvNmxygfH1ylu0Zj5Zl/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8x/ksyf0XLOyKhCnPJJQ9zNJvMafv2htDSxhpg3lmo=;
 b=B2ftfIkTKgV18S4CLvI1ZHQ/Hkcpcq4dMzIoOuxjwCfr1Clvho4MhZHo+Eyx3XpMpAioTqbT43Hdw1K7LSkudFsIhc65MrSsS6gzMQSXbmn0fqtDTdzw2+YHN8gXHG8n2ls7H02zd2DDnEXCDdlDT3xWxpPGSxEX2YOCt4sUuE9pGKx0cFgKBbWD53pFd+TMcVaCbo2HxJJmN/IRWogeJvr6P3SshkEq4udogCA1WhSqryrwWJQK58AI2HWnwi6iJAAg9FmtEwjTMGlEe7HJuLlyAITAKVxDO1legzb8MIY+cjtrgMxb0b+pnobIxhdBbiMM3lEP+OhelQU27SSkLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8x/ksyf0XLOyKhCnPJJQ9zNJvMafv2htDSxhpg3lmo=;
 b=IZI75Dc8pQkykb4hB6eUX3H/2QVb+KjEeh9xvDv7FlIHaqDLO1h9FkQLIjk+oFKjCF30crB+mGN//TZx1xqTHIQ3UctNv+c+TU8ErgjAYTlHsmkWmKjGZzRKEmBddqu5NOw3RMEfKCeDUnEG5R9FYmyid3Em0zVaICT7sYvssnw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM4PR12MB5964.namprd12.prod.outlook.com (2603:10b6:8:6b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.26; Thu, 17 Jul 2025 06:05:53 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 06:05:53 +0000
Message-ID: <40cc4c41-c16a-40b1-a2c2-591f29216b94@amd.com>
Date: Thu, 17 Jul 2025 11:35:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] iommu/amd: Reuse device table for kdump
To: "Kalra, Ashish" <ashish.kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
 <7db3a4b2-dff6-4391-a642-b4c374646ca7@amd.com>
 <7f08c03f-a618-4ea4-ab57-f7078afe49c9@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <7f08c03f-a618-4ea4-ab57-f7078afe49c9@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::6) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM4PR12MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec7e82c-d93d-48a4-1403-08ddc4f7fc9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVFjcVRLQXBmOUZ4WFZ2dm5QL0pabnFuOS9aM2l5YUx1dDlNWmpQR0VkOWRG?=
 =?utf-8?B?dU5pVXZ2d2hVNFpHbWV4YTlmU2R1QVlwWnhZd0hUc2c0ZVgrQW1VL3FJOTA2?=
 =?utf-8?B?SW0rUVJSeFJBbFNHMEJvTmdlRVVGbTk5alhHSEY1ZFRDUE9hWStuTkJzV3hE?=
 =?utf-8?B?SThXRDU2TDVpQW1mYnFDZHl4VWE0a1JmKzA5V29GR0hlYUJQUldVZTlqaHF6?=
 =?utf-8?B?VDZ4ZnJSNi8zTldiTVFhS3JiNmRvdUlzTmJzOXJmWDlpa0pEaStvUWM1NUI1?=
 =?utf-8?B?Ti90L2JCS05aalhiNTRRTUM2R1YzTGdYSS82SzRId0dZY0I0N1JocmRWemc3?=
 =?utf-8?B?bHViT1Q3Q3RxWTY5b3ZTY3psVXZDWUF4K1k3OVJXYnc2eFlyeUFCVDViSUJk?=
 =?utf-8?B?b0hFYkRyMzRCV213TEQ2dndhNysxWHFFWDA1d0l5dk01ZWExVWRYWHRuUkNs?=
 =?utf-8?B?UWZXeGNlOXlUaUc3QW9sSEg0Q2ZFQUNHSEJSOGVxUjEzd0RicldiTVlyalJE?=
 =?utf-8?B?UHlHSitLaXRXM3lvY2toWW5xTDdVemlRZmF0c1FNWnFZNUlPTXdaTU9na0Ja?=
 =?utf-8?B?MDl2Zm9IYjJRbVI2UEUxUlNBTUZJUUhjQzlHVVZoYmlJZFpNTHhVU0FhL3FT?=
 =?utf-8?B?VkZqU0xhd2VmbmtjWW84RG5OMjdmbm1wbXd1ZGgyTktNR1l1c2pVOWlxc3Js?=
 =?utf-8?B?YklKQ2UrWEhiYmNBMlVoZzh5TzZwNEh4YVVpZys3U2NpWThtN0VybzQydzBk?=
 =?utf-8?B?dVUzWTFja2dJbjY2YWk4Z1NtWGdlYmprendNNmJBVzlSK3RWVW82TkdNeEFF?=
 =?utf-8?B?Z1R3elUyZzB2T3VaYlMraXpCQ2lmMGJwTzkxdjlValluWlFTVnlFbHNiaUdO?=
 =?utf-8?B?WG5HYzFZdGJtRTdnWktPanNZOWpaRmo1M1hKVnJNVWRCZ3h5WUZHWXV5Y010?=
 =?utf-8?B?SVFXVWJVK0tQQ1NSS2FXeDlzYVB4NXhFalB1YTVlY2VXcThZWHNWTi9HeDd2?=
 =?utf-8?B?aFN4dVllUTVHRHpTcEs4blhwbHRCakp3YjNtU3FNcTkya1JOVTQ0NUJjQ2gw?=
 =?utf-8?B?VUFzM253ZW83RUMvOStNN0w0N1ZIblRNV2lBa1dLL0w4anJEQ0I4MVhhUCtt?=
 =?utf-8?B?MTlnYUZxSkoxbXJ5NjZwazh2Tm5zUlhIWVFlVG9abXBBQk9nSkxiMGxiaUVt?=
 =?utf-8?B?WkYycHN2WDNZS0ZhWUdUbHFabnFBQjNFenYrQjRSUzNiN2djWmNld0lqTXhw?=
 =?utf-8?B?Ukl0Zng1SEtra081aWFTeXB1SnBSUEZYbW5mM3ZaVWJwSVFneElORUpZMmRF?=
 =?utf-8?B?NVhITThpdWpac0wrcWJUUEhJZVFZcW1HVWNQMVBiVFM1bzl2T1o4MnpJaWhD?=
 =?utf-8?B?VG5vK0dLWE1lV2M2RVlPdGlQZEFYdXY1WngxRGFjMzlBOXRBZHVNMVFSakRC?=
 =?utf-8?B?eWwvS0pzYlljY3E2NmROWWUzNUpsRlgzSlBibzd0RXBheEd4MnBGdjRwOXBF?=
 =?utf-8?B?d0NNN0tkbGZEcTJ1aGZkR0xRb0tTZEJQdjNaK01NcFpQK2Y2WnFHWElTbnYx?=
 =?utf-8?B?TExEWkRGVFd5Y0tWc2d0Y3p6MFhtSUJtVWFxWFdXbVhiZlJiTm12MEVWbmF3?=
 =?utf-8?B?dmM2Y09mK3FvZ2EyN1F3SUl2cTVrV3JRTm91N01TeHhlOC9USEwySk5CMjkz?=
 =?utf-8?B?WDlUQ1RnSC9pOTZPV3p6aC9UZ1FrM1doQlh0T0ZIckROWXQ4QndlL0hRVHpx?=
 =?utf-8?B?ZjczVUN6VkpaeTA2N0xXbnZhUHdtNXV0cG9yRnMvbzRWNVRYd29jTXRhSkNv?=
 =?utf-8?B?R0NURS81ODMrQk9ybDcwVytLcXZGSndJTGQyNTIwYmY5aHhMZHQwSERmU2VU?=
 =?utf-8?B?WFBKSE1XMXVFUjRLZTA3RW01VjhyYkhVZVVRbEp3Y0hVY2tCbkUrbThvWmRC?=
 =?utf-8?Q?26Vae6sLWNA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjlMMUFjMjhnOHgzK0ltd1FUVlFqTGE2TlVHbDBya3BQZkV4SDZ6QXFkd2hH?=
 =?utf-8?B?UmdIbTQxY0F2b05RUTYzS0IvSUhnQnpZby9VaE5saUxnR29sL2xYNW1DMmVJ?=
 =?utf-8?B?ZXpYRngxbXBqQm1qL3UxMTFXMk8vVWc3akFkVmU3ZkRxZE1FZUdPaUl6UHFy?=
 =?utf-8?B?Wnd1c0JtQXltb1kwWTVMQzJDU091V1NjdWVJR1JyVnkyZXdwNnlkSmNOdURl?=
 =?utf-8?B?bHd1SEhMWEM4UktZdFFTZHFhTXlKdUlQTG14L2Z2T0M0U3pqWVFjYitGek5t?=
 =?utf-8?B?dFdrS3czYmlMREc2dXNoMkVmV3pWRG45YXBtQ0NrdjlUK3ZSYjEyQTJtZ2VF?=
 =?utf-8?B?MXFud04rbS9yRmgyaFZiSzlSeW5kZUNyR3RjZW1BYU5ydXdmNHZTKzhJcXlr?=
 =?utf-8?B?MHJ0MWpISEhYdzFuS1NjZm43azhlV2hOUEFVZk52SkpTSUpXVkVMMCs2WmJr?=
 =?utf-8?B?MzJRWmExOVlDSG5WOXpLUEZkT2I0akNISmphcDFwWWgza0VMSGFYRy93bVBr?=
 =?utf-8?B?dUlOcStoK2hiYkhUNDAwbDArWjNrWFdHa3BGSVVnKzZhdW50VVdKdktaMk82?=
 =?utf-8?B?NndYK3A3MEI0TXpFYTBtWmJQYzVvdlZERFNkZHR4UFVnNFl3U2dUenA1Tk05?=
 =?utf-8?B?SERtWWVEKzB3TlpVTHVCQ1FpcEluc0RSbEl5L2JBUkdUcTVoOHJ6REN3ODJU?=
 =?utf-8?B?RHJsb1dDdEo5NGJadXo1clMvY0FqZ0hJcDV2YXIrTnR4c0J5d3N5UW5DendH?=
 =?utf-8?B?S2JwY2xTaXdnQndmOWJoUWdoQmxGQWRpRFd3dkpFSVJYb3RtWmpNQ3ZneG55?=
 =?utf-8?B?YWVPajltNXoyT1NHM1l2cDhHUi9tTTZkVnByRW5ZTkxhWDBtSUFIdVYwTWlP?=
 =?utf-8?B?M2ZyaUF3V1ZGTFN1dUJiWFJXWEg0c3BtNFN3UGplRWhnUVFyTGdOQmQ0TUI1?=
 =?utf-8?B?aUtHckZMV0VraC9XMUxnVi84M3NyRUYxNVBRcTFqeTBpMDJnQTNNNENmN0dS?=
 =?utf-8?B?aWtQbTgyZk9nbStHeS9lR0FXVWNjVEF4RG1lcXEwNlF4bFYvWVdpVHV5cjNS?=
 =?utf-8?B?MHdWOTh4dVR5b1lwbzNXRUh0ck5McDdGcjNNZEVLMzB4UmlWU1hxbkRyVkxL?=
 =?utf-8?B?a1UxREZUU1oxbGlzbVVWY0lDWjJ4cmtPOU1BTU5Fckp5eE94Wi9meTBmbG1p?=
 =?utf-8?B?R3BvU0FKWWFUWW90Ry8xdVJqOXJYblBFMjNGdTRIL25peVBUKzNmNUxZM2Jn?=
 =?utf-8?B?UXpLcURhbGIvejV3ckhjanJ5VjFCWjVSYlNSaHdJUklSTGdOUDdRVTVFMFV2?=
 =?utf-8?B?bnk2SXN0eUNMYW1KVXNQbEVsVTVUUWx4YWtNNWgzeDhyQzN2V1IweDVWdXhS?=
 =?utf-8?B?LzlYS28yYjM4TW5hTE5CMzIrSC9SWjFDVlN3QVVGQUUyckVtV1E2NjVyUEVt?=
 =?utf-8?B?TDVHSXgwbWF1YlpKS1J2YkozQm9LeW5ndC9aOE1DZEtnbnFpTnA3b1lpRmcv?=
 =?utf-8?B?STJnMXRoSFJVdUQ5VHFlUy9reHRBV2pJS0ZkOUx4Ynd4bkE5M1NDQUt2OHdj?=
 =?utf-8?B?Q2tlZmFuNXpYVk5vaVZXNFpYK3gxbzd5RDFhZDduZWZOS1JGcEx0WXl5NWtT?=
 =?utf-8?B?YncycUk1V3lnWXVySDFtczVCdEtLa1V4cW9GelBzVHN1eHpvWk1PemR5WCts?=
 =?utf-8?B?V3VBYWxYdjFoSDZmUG9EY0hGbEZBVGJIdnRyTHVHaTFTMTFjeEJYVy9uWDZJ?=
 =?utf-8?B?NXVlOHVzV054aE9uTi9iU25VUWo1eGpXbGd4NnJRNytpRTJTcGdRa296aE8w?=
 =?utf-8?B?ajJMcm5UbDgxbUdQcEg5dU11R3YvOXZFa2ZiY2toSlRHTlZ6MzNpVmRCMmlH?=
 =?utf-8?B?QXZ2ZFgwWUhSc2R0RU1sNythR0lJTXB6V0w5YjdGSUtEOHFGcXJuMm5WeE9N?=
 =?utf-8?B?ZnpaN2NYZCtzUGM4YXFrVG95TSthY1pKd0EyTy9vaFc1Q2llTGJjbUo5RUNR?=
 =?utf-8?B?ZjArL01MOXBrS2FYSS9rVWphL0F3TmJha1A0YVVPYlpwOE9Edmdkd0dDUkhu?=
 =?utf-8?B?bFNzWVEvSWROSFNCUkFZTzU5REFOekE1MFpkK2syZ1J6R3NoMWFKN1gyOCs5?=
 =?utf-8?Q?LM2n4zu8F3ODeeVxQsDn3YHOb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec7e82c-d93d-48a4-1403-08ddc4f7fc9f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 06:05:53.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AuJJHei0nQrpmEgYZT47gM/tJ96xcwvJuydR0sDYVJNmDkaitsLMjV0WX0FgQKYoX2bvqarLd1MwdeuX4cs05g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5964

Ashish,

On 7/17/2025 3:37 AM, Kalra, Ashish wrote:
> Hello Vasant,
> 
> On 7/16/2025 4:42 AM, Vasant Hegde wrote:
>>
>>
>> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> After a panic if SNP is enabled in the previous kernel then the kdump
>>> kernel boots with IOMMU SNP enforcement still enabled.
>>>
>>> IOMMU device table register is locked and exclusive to the previous
>>> kernel. Attempts to copy old device table from the previous kernel
>>> fails in kdump kernel as hardware ignores writes to the locked device
>>> table base address register as per AMD IOMMU spec Section 2.12.2.1.
>>>
>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>> through Interrupt-remapped IO-APIC".
>>>
>>> Reuse device table instead of copying device table in case of kdump
>>> boot and remove all copying device table code.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  drivers/iommu/amd/init.c | 97 ++++++++++++----------------------------
>>>  1 file changed, 28 insertions(+), 69 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>> index 32295f26be1b..18bd869a82d9 100644
>>> --- a/drivers/iommu/amd/init.c
>>> +++ b/drivers/iommu/amd/init.c
>>> @@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
>>>  
>>>  	BUG_ON(iommu->mmio_base == NULL);
>>>  
>>> +	if (is_kdump_kernel())
>>
>> This is fine.. but its becoming too many places with kdump check! I don't know
>> what is the better way here.
>> Is it worth to keep it like this -OR- add say iommu ops that way during init we
>> check is_kdump_kernel() and adjust the ops ?
>>
>> @Joerg, any preference?
>>
>>

.../...

>>>  			break;
>>>  		}
>>> @@ -2917,8 +2876,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
>>>   * This function finally enables all IOMMUs found in the system after
>>>   * they have been initialized.
>>>   *
>>> - * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
>>> - * the old content of device table entries. Not this case or copy failed,
>>> + * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
>>> + * the old content of device table entries. Not this case or reuse failed,
>>>   * just continue as normal kernel does.
>>>   */
>>>  static void early_enable_iommus(void)
>>> @@ -2926,18 +2885,18 @@ static void early_enable_iommus(void)
>>>  	struct amd_iommu *iommu;
>>>  	struct amd_iommu_pci_seg *pci_seg;
>>>  
>>> -	if (!copy_device_table()) {
>>> +	if (!reuse_device_table()) {
>>
>> Hmmm. What happens if SNP enabled and reuse_device_table() couldn't setup
>> previous DTE?
>> In non-SNP case it works fine as we can rebuild new DTE. But in SNP case we
>> should fail the kdump right?
>>
> 
> Which will happen automatically, if we can't setup previous DTE for SNP case
> then IOMMU commands will time-out and subsequenly cause a panic as IRQ remapping
> won't be setup.

But what is the point is proceeding when we know its going to fail? I think its
better to fail here so that at least we know where/why it failed.

-Vasant


