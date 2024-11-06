Return-Path: <kvm+bounces-30877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0BED9BE14D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99CC71F22D44
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10981D54EE;
	Wed,  6 Nov 2024 08:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wJko13nE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE761D4333
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882928; cv=fail; b=W/ihv77NMPpwKW5yC4g60Cqy3NIVQuEnPf1+/ndnJdsZwW3t6pM9vHEcrUBfDX3aWwxi4cTf15gxtrBmmn7XEUl+24N5uoG0fT/VlBQ4OHfgfJapLcbo3rpytFhqs1osyHLMBf86vUAIYGTu/iKJiXD3zen/9vSFL96o1kebd4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882928; c=relaxed/simple;
	bh=5kTxxP6rXgvYJkeCyl4TA9/Eul+pMAmwKf6rv5dT5g4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EphLYTZY0PKNV8xnlGsmNOSJ6X4rsWd40B8aBKo3tcZCLrl7V46WZBIOXxDo1wWvpoorPD4eGUKuajhYvGILfS03iMMVHHUDXiQoePI3VX8d8YpDil5NtMNwMbVAp3pKrKxSQqodTPlfEieiKppCFLOg9tTK757bEm8cj6yDNns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wJko13nE; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVlwSvMNKtaAvO4UFuLWIEX65ACMciFwnh46JgmXku7qI0XV6NGm3Tb78HrAXTxYuk/GY3EK/hPHGywJBUTJDCJo6ZtWVE8GMBBOeQlDBNbZvgE3vUCq2Zorc0iwNDnKfMSqSRzJxAPtlVDTGF+Yc893TFDlXOeHmTCayLjkJbXhuLTAVag4WFdYcoyTbiQrV66+5dZeOMNkEukYpRZL79l24UIqFfmmodjvTwXgBRC2HHtEyc7fdn+P87rbHshe9lrfTMGyOFLvIKwL8ZN2Ydi2MW60W48zaPcqNa69+qfOPoclPIrvVmSXmpWJm4WMveGczDiVr4ZjuHRuB7ov0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAXrpRBgUsCgWv5ttmRdY0Z17GAXAZC4SDxZ4GytmNQ=;
 b=OXO4OvsYYhsnHOLjw3kLG6oeNfUNa0LpjACw7fKgTy7KiHgqntoUEj1hHEI05cpmUq7lbtGisZC6Z0A7lekMXjtqelrlygai1gfDVZ3NaywLFMfN0oW7ncfCHsfFhXN7Dkl0Z0/a0hKajszWICz3a3V/lnB+x5M/f0TSEBDCxWtVctJFwzL7h3ygTyBu8XPFUF//O+Lho4nzT8hqVd4eXnvu7uPkfPDmeVamRWij2gCd5n25iiZJGYmonm3vOMZ1LPNTf8/Y9teTZLawLVQbr6EAndjYHIQZePVOLX+RAJyAbiFRMkLk3s23vRHFSHuelagwCONexrvIb9CBjI3R9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAXrpRBgUsCgWv5ttmRdY0Z17GAXAZC4SDxZ4GytmNQ=;
 b=wJko13nEzaPZz/byV0aMa2MGrvX9pa6wfJR20FiM7DxH8GdPyV41VB7+nESUaTh3ELhPMWH0A32dRi1Ui/i2n+Hfr2g6rytwHjFDYiE6ZdgDjS9iqLwvHMCUE9wXwrxH1U02MIOxKkmaw1CZGx7V1mutcXnMzUcEEEvyNwXE+A8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB5904.namprd12.prod.outlook.com (2603:10b6:510:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 08:48:43 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 08:48:43 +0000
Message-ID: <2dfe9546-2676-4708-ac49-a1cb06edad4d@amd.com>
Date: Wed, 6 Nov 2024 14:18:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/13] iommu: Pass old domain to set_dev_pasid op
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-2-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241104131842.13303-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::13) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: a936ec3f-0866-4c1d-e458-08dcfe3fd143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0tuKzhtckVYa21PcTZHekpUdTNqYmxnWmxkc2dHRi9jODZYb1B4di9naEd0?=
 =?utf-8?B?YTI4Y2Rhanh0ZUpHc1RYS1pTaXhNK0k5ODBIRXh2dWtGdTVQZGkvYzlnZzlF?=
 =?utf-8?B?b28zU1pKWnZxN0QybFpYMG0yaXUvKzBDZy9hNWcyWC9vV1pSZ1FrTnhMYUxK?=
 =?utf-8?B?MUhpbXRGN3N5TldheEFKdGp0WnJrZkpWdTN4K20vZ2c2TnI0RzAxblNDcnNK?=
 =?utf-8?B?NUlONkpYNzVLSXFpbDBrL3ppRkN2TC96YnltcWQ0RTV1YTR4cGtGNDVSZVI4?=
 =?utf-8?B?bTBCRlgrWlYyQjBFMWsxTUZiNmFQVUZsUDNEK1J6OXp5SmNvQ2NBcUpmV3VP?=
 =?utf-8?B?RGxCNFArc3BHMVlhMXVzUlVTQkw3YnZ2My83RDZPVHN1eVA0cVhYSU1SZW56?=
 =?utf-8?B?NXRaeFdqZXhUczczb0dsWXNYVSt1R3E5NWlwNXRkbm1zLzBUTTh5M3RFenA3?=
 =?utf-8?B?aGgyZU11MzV0UmNieGMxYWpEcHFZWTJHNEVWN2pES0ozVTJNMmkvSEEvdDBs?=
 =?utf-8?B?VWRwNVFUWUpnQ3NpTGxGRGNFTWcxU0JGaXk0Vk11VURRMDdpTm5peFVsR3BB?=
 =?utf-8?B?cXVoRXdyS2NNQzZsVFV4bWNlQ2wrSjU1Q2gzLzg0SmtibTlKeXFLcTNJNUNw?=
 =?utf-8?B?VUx3WDlldUpyWms3TVd2RkxGcEVqTDhiVlVESjNGQWpyaUR3aDVZcGFIK0Fk?=
 =?utf-8?B?cGR4clc1bXZLMXB3ZlBDSHdrUXlzd2pvVU8xbnZlN29iQXNMbGhjMTdMYXlF?=
 =?utf-8?B?b3pkV2s0KzNHTFE5Vi9BM01oT3l0S0JaaktQc3BEZjlwWWgvMnhySnd1MVd4?=
 =?utf-8?B?M1FIc2RqNHQwUUpaWjhpOEhLTWhxdWQvMEo0ZUdTMnFpaHoyN2VMdVdVcUVI?=
 =?utf-8?B?Ni80Z1dZa2NVTm9DeWpQQTRtS0NKU21NTlAxb3BHbFBiTXRZOUpnODN2bE53?=
 =?utf-8?B?d2ZDTzljODFiMUc0WkxvS2dFeHpyMTJjUGhTalAwZktXc3lWT2V3M01rdk1w?=
 =?utf-8?B?dGYxVE9na01MdFY3d0VCU211ZzM5UkdUd0Q2NU5JL2Z1Q0U1TGZLZ3hINFBB?=
 =?utf-8?B?dXNablpjWFBpZ3JybVJ1bkpoekxRT3hjVXprQ2Vsa004NWJ2VXF5NVRRVHFB?=
 =?utf-8?B?RXN0MVE2UUVseVJ3b0ZrU1ZMNGJoVm5TSE0vK2t4THpZNEpYMHRvcUR2N2M5?=
 =?utf-8?B?QXVubmRLTlZIRHc2NmxKQ294QUZMc29XTDdMUi9TNm4wMjRiZnhxV3czR0F0?=
 =?utf-8?B?dHArVGc4a25MdGtsNDJaWWVjejFjdHZYRm9OV0ZSb3lsbHUrNnFIMHhicHRj?=
 =?utf-8?B?bUZhNk9QSEdHMmZSbExWbWZ3M2JBY3pqZzYxdXB4NzdVSWRNd2hVdHdFd2Jx?=
 =?utf-8?B?UEl6YzZrWjlwQXE0cjhER3B3b0pJOWEzdlI1ejBLWjNybzl1TXQwbWpmTHor?=
 =?utf-8?B?N3ZxRzJ2NE44RkR3b3g5MVNvd3dPU252VUY0clNBRHp4N244VHA1TExVK2tB?=
 =?utf-8?B?TnBNUUFCaUNMZ0pSSlhJbnVLQ0ppZDN2T0hoN0JDNmtxTXJFWkFNbWtZWDg4?=
 =?utf-8?B?V3ZZcjZrRTZWY05HeEcvUFRxU21oT05Ja3hOaTFWK2gwM051WlZueFhTdk8v?=
 =?utf-8?B?N2tCYU80RjV5d3BuNUdtSmp3Q2pMN0FXb3hKeW9jUzM1c0lqOGFVb0VFWFZ6?=
 =?utf-8?B?VFkwQmk1ZkloeFdkZkF0UnEwWFlyNGlvZDdmTjk3aUdnMGZETkdoSUhmOEVI?=
 =?utf-8?Q?mdRbYhe5ZOu4V4RwqnQdB16m86tj7XhSTt2VzZk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDIyd21xeDNTcE9pZEw1MVAyQjJETDNiZWE0QTV1eWJDbjI0Q2k4TmtqZVJt?=
 =?utf-8?B?MEpwem5Qai9oRFVnUnovTjNKYkgrNGxmdDVGbklhVDNwVVUvK1NkR0NZS3d5?=
 =?utf-8?B?bzdISk14Y0tXbXlHVVFkUE5aeURCNUtEblFrTk5tRWRCTkIwMDZuK0ZFVDhD?=
 =?utf-8?B?QU8wMVovTS9Gd1RVeE9QcGpXK0J4aElhZjVIQkJrckZDQlZKeVI3SHBkU3h1?=
 =?utf-8?B?VnNzeEJac25XQ0tUdnVGbnZ6YTNqWUhFeTEzYTZkZ2oyZmRQb0tHZ2RUYkVm?=
 =?utf-8?B?bTZKZG14VXZ3Tk1qOTJydFhLZTlVRXc2Mkh1VjNUVWxwOFZKZTBGLy8zL1FY?=
 =?utf-8?B?dSs0aW0yR2lYWFp4WjFLdHRDbngxN09lZWpLdTRmVVRtUEZSZGozOHp5VnJJ?=
 =?utf-8?B?OUNYMEZoYzBVaDBGRGVkSm9zYmZULzdzdHByTlYvNlJBNGZ2eHV4YWptYUNs?=
 =?utf-8?B?SDNBR256WkNVeGRNdzlxMGFkbXN5WXJ2UFdpQnRZeTNud2pXdXczRDVEV0RP?=
 =?utf-8?B?ZWJsOUVLZEpKZ1RNTHp4T0pOL3h4Y2JNVXBBUGxTZ1NRNEFtZExQbktYayt6?=
 =?utf-8?B?ZXc2VktabVUrRlFrb3RWd2JSL3p1bDB1NmlDS25QdXByZkhraXhxT2hhL2VG?=
 =?utf-8?B?cldhb0gvZ0U1VjIrRFFBODNHSFd3Z0hmWjFwQjVSaVl6dUpqOHJDdGtNVmJS?=
 =?utf-8?B?SUZ2Ynh3U3BzYmora0RxbU52SlZXV0pFQ3N4dUJmMzJWK3IwYWQ4RzFyMW5T?=
 =?utf-8?B?YXUyTnJlQ2RUNDI4R1N0OGFpMzJBemdDZCt4R3YzYjBCV3Yrd2wybVRYYWp5?=
 =?utf-8?B?cFVKRjRaY0F6NEFOUXpUd0Q1YyszM3ZLdWcxdUQxbzBnRDJhU3k3Mk5NeDhy?=
 =?utf-8?B?SnpvQXVIeHc5YXdDOTJZQVRnS3dMWVdXNFFDV0FzY1VPQVl4NXpkd2JxYVhM?=
 =?utf-8?B?TmJQNXZGcDZ0WW4wK2Z1RldoNHpmWGYreWlweTZSbFp0M3AzN05jLzEwNXow?=
 =?utf-8?B?bWVhYWt1WlZycWl0QjFIVlFsYmtjMUhmOUswek9SR1NYWFFNSkV6N2dXbUlR?=
 =?utf-8?B?Y2xQQ1crK3IydWF1SlROdWliMVlKekc0VDYrYXFvTmk5S0Y0SkFPMlp3cUR3?=
 =?utf-8?B?ejBRMmt2TFhBUUhVSS9wcjJCY0ZXdG5FOHdKbW9jZkU3a1pDVXdZWTJvRHVz?=
 =?utf-8?B?MjJJdVZ0UVlxaEhqUC9mOFp6L21vVm40bFlWYSs5TERaemdTOXlJeWI1NEpC?=
 =?utf-8?B?bVBEVnM4eHVwZTcwQnZ3endUSVkrZkdjWmlsSHRha0xrNFhFbW1PZ3QreGdq?=
 =?utf-8?B?NGZuQUhlNW51dGhuKzFEc3lCUzBEM1orWFBZQ2tXVG1FV0RGb2thblRCS29U?=
 =?utf-8?B?SXFEMHpQTGhRZUl2OFFsOWw0YnE3YmRxaVFDL2RMbGh5emhZakhxZWdqeXll?=
 =?utf-8?B?RFFJazJWc2ZVNmpwNnZyZ3ozU0JqNXRVWVkzbFhKbkQ1YXZHUzV5OTl3eHB2?=
 =?utf-8?B?aFh6UkpaRGlleitUcUVINnhrL3l6SVQ2NGRKQVhFNXBZRTJlUjM3VUVjaHZj?=
 =?utf-8?B?WlJRSHNNSFFIOFQwVHNqeGpmQ243L0d1RTN5L0grNkJTbDNwV2lqVHBSd24z?=
 =?utf-8?B?dmVjVEcyQzVJZURhUWxIVmtQdk91ZGYzWHJ1WmVXeXl4WjU3bGtZUFN0UFJM?=
 =?utf-8?B?UE44bzMxYXQyVVd4YWJlVlNCcmtyOCtVSkdxZi9FTDdueDVORDNDUGRnZzkv?=
 =?utf-8?B?N3Y2RU13MXFEU2t2NnJFQ1JnVmRPUzBQVWt2UTVQSnpRd2xYTER6d0l1RXNG?=
 =?utf-8?B?Q2VhVURyY2RCT0pwME13cWRuWlRoNlZ0ZXVqUDAzYlp1cEVrOTJ1TzJQMkpr?=
 =?utf-8?B?Uk1qTGRUQ2hQKzBSTHpqbk1KTzlhOGk0VGZEMWVUZW5hWEhxZGdsZUdCTkpy?=
 =?utf-8?B?RnBLTExQc3ZLVk1vZFVMTm1FWGgvWXc4ZnprQmk1dnRtT1htK0NDNUsrRkNH?=
 =?utf-8?B?T0RnT2tQSm5WZXdPQzkxM2pVQUVxUzZOR0xMRytzcW1HNDVITVp0ZkJWdHNs?=
 =?utf-8?B?dzdBTTQ1WnZOSFpFK2JrL012N3pQc3JiTDg4TVJPVUoyZ3M1ZEdOazNMWWV1?=
 =?utf-8?Q?UQvRF6nkxeu44KbL3THPL5VSB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a936ec3f-0866-4c1d-e458-08dcfe3fd143
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 08:48:43.0116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/fD+Ex4pQ+CJ/L26NQU7XcH1MWUfBxuGe1sl2StfvjIiEhaZf58aJRnzkuLaRJqvbX0XXdEckFw7JIiuYnRxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5904



On 11/4/2024 6:48 PM, Yi Liu wrote:
> To support domain replacement for pasid, the underlying iommu driver needs
> to know the old domain hence be able to clean up the existing attachment.
> It would be much convenient for iommu layer to pass down the old domain.
> Otherwise, iommu drivers would need to track domain for pasids by themselves,
> this would duplicate code among the iommu drivers. Or iommu drivers would
> rely group->pasid_array to get domain, which may not always the correct
> one.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

