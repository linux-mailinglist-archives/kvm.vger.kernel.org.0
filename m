Return-Path: <kvm+bounces-30890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 849379BE29E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44A3D282D16
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5B41D9A63;
	Wed,  6 Nov 2024 09:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tt5t0nIl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84401D9330
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885653; cv=fail; b=VwZ8L3t0g335OZz9+sGsLBYAJNv1AfrNxCtcZbPSCF0Lq8Xn7fJU30ameEFhVK0oKrz9HRQAtJAjo4GfF2W2NGPhYC28+dWlKA05cWibbo7D6Ze4Z7ajxum3CCZeOUFqIoPEqKPfsYt2cHEvXIbTimegYjzrR5WcjKpGUdsUsHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885653; c=relaxed/simple;
	bh=znRxhf6gNmvRANJPDOMB9LWwNCyZUFc5k2Cx7N3Wl68=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oogUGi1Rb2j2LZLynYhfFRK/fzS6vQ+IJVdJooByjV6VbHGyjr0jwob3Saz8wJhnIO2X3OcrVrjcip0RC9O13u0Ln3iQJr1kE7hUUVNzdJ0Ll7N1BYLVdEiXRObCQ3p1kmc46fo3nQnOLRvdXJ9cSfEkx89ujW51+lIMw2SbDPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tt5t0nIl; arc=fail smtp.client-ip=40.107.101.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTbXQiw/oVkcWiRQRbrHO5gxbOdZfqHLuzNhEMxTv4hyCCRYtidkim0dlOTj2TwH3aAfN8iqRwBYiKC/2xgOjOvOH3uVRxHLv5IMKuILbuw4bJ/mXZF8oiLn0lc1NfCw+enJzQR70tJxKAk8ZJZtgFL35/zouWdBy4Jxzfw0tSpQ+62dsFdb48C1QS0B5G+fnQu/XEpQJ/YgM3cQMJZ2GOcMtt6v+7nYK3YC9tqsZsIGEMFHn/u6EzlsmCFVYj2S9x9WmEpvBOPrgUT425uISlMTWkwUZN79lCQp17gghPAPIyvx4ixuIcPLfYj/WgcQP3KOztOoNGuPuXzPkrRPgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72h+z9gOQoPt3DOPqH/ciiGQYAboQyaywZLt+XFoJ9E=;
 b=xF+1Y/G/IM5TC5R8M0omo/pqo0oO/7s9N/pHYvQxvK//PzXUbnviIcsC1dATcgBTKlxksUA3fRqmbsSqDv0xrxl65OaUEEFAJqBisiScueA13t2icS2xrlZe2KwJg8YytiQPHNavSEAr1oZGBQEMReJ2+cToD9kqVkOqb5aMAbKi68uiWAV1wa08UBPr9bChhObgudgsjA0Ma0Rzi4LTJfs8n6l00Urd/XVPGYVaNrcaiZbJlVO3oFMknK/anRcXfflZxBRDuUiCfsRXlEkwHuxHuN032dlo7Ubq7x8IqzDxq5JxWlWQbHWmp6wwAJvrgJ9ix+L/npmEVG6sfF3d3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72h+z9gOQoPt3DOPqH/ciiGQYAboQyaywZLt+XFoJ9E=;
 b=tt5t0nIlMcaA3VJLOZJ2iQEmq+hyGQwKkTJsUtZ1l8wBm5poLKAMESJkUb9ysLcM11EwngkGJ9Pe+v0i2JYy577rJnbO8Xh/3yrftCSQcIheBDj5lbRCHh2qhCd76Syn8TfeWPxdFgxpIofE9YC333BxY35MvlPj44C2WzpjDF0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH8PR12MB7109.namprd12.prod.outlook.com (2603:10b6:510:22f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 09:34:07 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:34:07 +0000
Message-ID: <56ff3976-ae80-41b2-b3d1-589499e463d7@amd.com>
Date: Wed, 6 Nov 2024 15:03:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] iommu: Consolidate the ops->remove_dev_pasid usage
 into a helper
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, will@kernel.org
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-3-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241104132033.14027-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::12) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH8PR12MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: 8977f7f2-6868-4dfd-c39e-08dcfe4628e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlhpMXdBdXAxeENaYlpodEJlYUVaanlxMW9wZDRla2pQYnRvMC9vc3JlRWxV?=
 =?utf-8?B?czVhbDFZNHZwenR2OGczRytqNGU5cVpVVTNUTjdvcW5IRE1qVmxNUE9GeVY5?=
 =?utf-8?B?cDhqZWErMXdXQnEwdnFWUXEvVXI4Um5iNVBjSW5xeTdqMkNmODhnY052UW5X?=
 =?utf-8?B?TWZHWDJmZ3UxdVU1enphWHFTdDVoSk1PMG9oWWJQOTBaaHlMZ3VUZUZFdXlD?=
 =?utf-8?B?eTVwTXlzV05jVUh3YVBuSk5WdHdDL1NnMUx4K2ZJR0Q4eUlwRDdveXNNSU1G?=
 =?utf-8?B?cE5oMVkrU1k0SnNsbHJoVDlIQU9pQXp0dkI3QmhOdGNMTTQ1T0wydVNvck9v?=
 =?utf-8?B?SmIyamlETmorVy90R3BUOHFFVlZLMmtyeVB1cllDTDVaaTJ2VTN3TVNjRmtC?=
 =?utf-8?B?anBpVGFMWGV2TkJVd09JWWxJQzRhemNqUS9VV3dPbHplZFpkc1l1OEFCRUlH?=
 =?utf-8?B?VFp3dTE2cE5jWEtDcnpydkxhNTFiQ1RqeWE3Z1lYYTArR2IxQ3hHMnBnSkta?=
 =?utf-8?B?YnRFZnhwQUg0enNwNmNJQ0xNTWh6a3Urck9ZeHBrdHdBMnhrRERNdFdoUWtE?=
 =?utf-8?B?Qlo2V3ZabGdLWUZ0a1FndGU5djdYdk9lRk5CN1JLdE16c3RISDkwWlcyV0JI?=
 =?utf-8?B?QVg5ZGtRWWJQQjNtZ0RmR0Y2UUFVYmh0aU43VTdYVUYxeGRtSUtGdTNQb2NG?=
 =?utf-8?B?R1BSQmd0Qzk0eUdzSDNDNjRvQTlyYnQ0SlQ2QnhqT1lZbWdvNFhKbDJoUlk3?=
 =?utf-8?B?UGIvNzVyanFDUlBEa01SdCtXVEg0SXZ3bjBVZTNNbE5qWVVkY0xqL0JiOUR4?=
 =?utf-8?B?YWt1T2d0U0ZqaWVuSUNxSUxvZnRBSWV3YU1hK2F6dTJPNEVhU0orbjQ1VFha?=
 =?utf-8?B?TU0wWGgvS1lyd3BkSm93azhFdEYvZzVLSTlQRUFTMXVTVXJrVC9yWklnbE9I?=
 =?utf-8?B?OXpHOC90OHhiY3hTZjFOSE5kcVpGMUdvSUhPNjFGL2Y2Q09aSXJKcENrSWxJ?=
 =?utf-8?B?cTVsRlhnM0NCV1JSbDBMVlo3QVdicE41NDY1Szd1RVBoU1NDc3g3M3A1OEZC?=
 =?utf-8?B?U2U5MEJLZUIzQVBpd3g4SGpJVnF4MXZlZDNWUnFNREhSL0NGN1o5ZGdMMncx?=
 =?utf-8?B?bm9wVzEwNnI4KzR4d0JPM1RhNVJ6aVBMc0ZmQ2hiUlBMNnVpUm5CMHZMREpz?=
 =?utf-8?B?VUxZd2U3NG9QdmllK3BQL1Q2R2xCekg4NGRyVjFub2cyMGZORXBKVkxURE9Z?=
 =?utf-8?B?K3pYK25wd0xPL0JMaUJnK1NSNGxLS0JDcTlOazc2YXo4ZXZabU9tTGJ4bHRm?=
 =?utf-8?B?eUxSN3hWcXBzWFlMaXZrVXR3cGJ2K00xN1VXZ0xxcUo3dldLVTZRMEQ0U2wx?=
 =?utf-8?B?anZVZGt1bW43ZHhYa245Vkh3cjFNelNmSkp2NndEY3pRZVN2aGd1eWd2NS9D?=
 =?utf-8?B?UHRVZnBIWkdWYU50SE9GZVc5alFpNkZMeG5QbXZUdjJSeWxVbCtIaDV3dndD?=
 =?utf-8?B?YStBMXhLazBTek5TN0pCVVMwNUxwM3ZnWXVERWVzYTgyVnBrcm96ODFsSzMw?=
 =?utf-8?B?aC9oZjhpUFEvYmorUUhEbVF6dTNyYnl6YkVvZ0tFRXJIQTBNbDJiWEZ3YUhN?=
 =?utf-8?B?QjEyK3Q5Z0h6UjM3ODJuSndSYVQyR2NFZ1cxUk9rVkRpVzBiL2NvVmpSTlZS?=
 =?utf-8?B?SGI4QWdibTZtQlRidUovbnN6dXpiQ0NoN1RBcjZ6Nk9qYkdIVmczS0kyMmp2?=
 =?utf-8?Q?YFiFmfzBIUxJ19vuGE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUgrdExvankzU2dqdGQ4TXZwVisvdStRRkRDczF4VkcwSUxSSDNSZ3AwUDlh?=
 =?utf-8?B?cnY4UEcxdU92dWhETlROMG5Kc0h3YzJPSGp4V1B3R3ZXUHdjejFsdVI5Qys5?=
 =?utf-8?B?ekpMRnlqaWwydjBvNmVYeWkyTEFOaGFQMlc3ZElBNEtJd2JveWdBOENPcDVD?=
 =?utf-8?B?NVFTV3RjWHNTV3hIL3ZUbFMydWxONG9lSm80eWNzcHVrR1JqZ2xaK0s1cFVG?=
 =?utf-8?B?TlRzRHBuQmZWb3ZEYkNvOEwrakw4NlV6TFdIc2lKRWJCbzJDWGdXYzQxZWRu?=
 =?utf-8?B?WVJjVGppV0w0UGVla3ZBVXArSVAvYlUzTmNQTDZLSElaT3RjdlZMZEd5ZUFl?=
 =?utf-8?B?OUdmQVZLcWtWOEt5V3A0bnVJV2hrVktIRW5ZQTFMcndmdWF0czBKWDVSeUdN?=
 =?utf-8?B?NzVuSnM1d2JQUm1ubTBuWm9ac2FMVU5WWmpiSHVpOWxsTUtWVkRQeHZaOHg5?=
 =?utf-8?B?WGl2MDZvNXlZNjNqLzNSaDFyK0tvSzZsaHhuTS9JbUZ6M0Y4S2kwUEhRcDB3?=
 =?utf-8?B?VDB3cHNNRXlyaFlpNHFkSVhGSVU1Z1Nla3Y1VWsvZGFrU05NTDN0YUpWOUU4?=
 =?utf-8?B?WEc1SmhCSVViTGVzSUpEY1hld2xzdXYvTjhKVU1JZVZJSnJXejJMQUIxaG15?=
 =?utf-8?B?dEtTMDRJSTYxSHprMjNzK2puY2h6UmNtQ3IydW1nOEhaRGVxeU1WY1NZM2ps?=
 =?utf-8?B?TTVFK0N2dENVMWZoL3FZZ1l3TXRsazVZQnFuZ045bmdRV0FQOUxhb2MxUXJK?=
 =?utf-8?B?Y0ZVb21WSWtJSklvUjkxc2oyZDRiY2xjeUVKQ3NycDJic1RWQW16eVhFSXBh?=
 =?utf-8?B?R0w4MkRQZFExNDFzeUJjcWFzR0xHNndMMDMzR2RlK0JNM0laWW5DZm5aT3Rs?=
 =?utf-8?B?NVUrUWtsRWpqN0o0N2ljMzNFaDJBU0Q3dU1JOWVRYlY2bG13UzhhRnhJLzlD?=
 =?utf-8?B?RUZvdU42eWFjVkpJYlhuZVVML0p2VllIWnNobktwajAxUXFldWl3OUI5eHpL?=
 =?utf-8?B?SGl2NytreXhObklsd1F0eWRVY29XYkVvQWU3RG1RcFpDZ1h0MGpyWnRoOVBU?=
 =?utf-8?B?WERscDlFOVhMNHhtclFSNklNOGNFUjUyNE5ZcEVvRGFIZSthcURCT2VWdlUx?=
 =?utf-8?B?L081dnpSYzZUeitoTmlzMStXWm83b2ZjWXB5RGZ1VXFqRDZJVGFTVVd4TjBX?=
 =?utf-8?B?elBybGRXeFpKMXZqY25zVXlCL2thWlJSdkpmNXBPSXlNQWhva2RUZ2VLV3h0?=
 =?utf-8?B?UjFKRDh5Mm1BM2FkdW1LRklaQW9TSml4LzUyL0lHZk94OFQwbGhrM1ZmaWkv?=
 =?utf-8?B?bnV2SVZJN1lrYk5rNWlKSjRIWmlnMWd4eTVhemwrdEJIdFdOVDZEV04vaUdm?=
 =?utf-8?B?N3R6WDY2MGZmZG1PV1FXUUZGR2xhekhRaFp2YW0yQVJhV3RSMlBwNDgybVdW?=
 =?utf-8?B?U3VkcldFaUtpK0NzRkJReDJKcGZZQ1J4K3IzY053SnZ3RUkxMGFaRExSOEJL?=
 =?utf-8?B?bS9pSGpsRTgrRmZDMTNBQmNmMXhaMkpHNlF5anF4OVYwSi9HdTl6enEwcFMw?=
 =?utf-8?B?TENSbkFaQTRjSFhKRGprRG5QelZMTVpEZ3l2MmtNNE9OdzZMbGdsQzdwWDBO?=
 =?utf-8?B?SjFqbXVrVnZ4ay90WDhDVUIwYTBUWnNzZUQ1azNUZCszRzByczRxMGlvUGo5?=
 =?utf-8?B?S0FrKy91b1BBMFM3bmlqL2tVWFI0MWRaU1VWNVpJc21kODBxRk16N2tHSTAw?=
 =?utf-8?B?Y2w5OTZrUjJxZjMrdEtPL3N1N0tSK3FvMFc1cC8yODlsOG52b21INmIweHVR?=
 =?utf-8?B?OUVhNU90azZjS1BOM2Jrbm1YY2ZyclVYeVhmaWpMVmxabkEwUnFDOGFOclli?=
 =?utf-8?B?cG9abjdTOFVIbldmUkZJR0RUdnJ0bTg0R09wWjJaaVc3WWl3VjF1VUN1N0g1?=
 =?utf-8?B?TzUyQmNzUWZrMFdZQXJiU09RZEtyOFk1K2lJa1hQUWMvc1YzdklITGZZb1E2?=
 =?utf-8?B?MGRpK3JyRHJheHMyMFRkOUprODdHWVdjTzEwTWRndTJiZSt6SlhXeTgxRks5?=
 =?utf-8?B?eSswR05kQjltYTNCcFFFL3huZElNRDUwdHlVbGkxaEMzQkVudU1mR2xmSzc4?=
 =?utf-8?Q?ofjbyLpAyQmZfioz9Jb12s+sO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8977f7f2-6868-4dfd-c39e-08dcfe4628e0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:34:06.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cl298rdnvivCuIEBnhnnZ8lcA5e3+OPkoRtaGiAyNM50jtqLJBqd3cVLq4ngt9jVP33mrfe10a+hc8eVda8gIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7109



On 11/4/2024 6:50 PM, Yi Liu wrote:
> Add a wrapper for the ops->remove_dev_pasid, this consolidates the iommu_ops
> fetching and callback invoking. It is also a preparation for starting the
> transition from using remove_dev_pasid op to detach pasid to the way using
> blocked_domain to detach pasid.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>



> ---
>  drivers/iommu/iommu.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 866559bbc4e4..21320578d801 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3400,6 +3400,14 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>  }
>  EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
>  
> +static void iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
> +				   struct iommu_domain *domain)
> +{
> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
> +
> +	ops->remove_dev_pasid(dev, pasid, domain);
> +}
> +
>  static int __iommu_set_group_pasid(struct iommu_domain *domain,
>  				   struct iommu_group *group, ioasid_t pasid)
>  {
> @@ -3418,11 +3426,9 @@ static int __iommu_set_group_pasid(struct iommu_domain *domain,
>  err_revert:
>  	last_gdev = device;
>  	for_each_group_device(group, device) {
> -		const struct iommu_ops *ops = dev_iommu_ops(device->dev);
> -
>  		if (device == last_gdev)
>  			break;
> -		ops->remove_dev_pasid(device->dev, pasid, domain);
> +		iommu_remove_dev_pasid(device->dev, pasid, domain);
>  	}
>  	return ret;
>  }
> @@ -3432,11 +3438,9 @@ static void __iommu_remove_group_pasid(struct iommu_group *group,
>  				       struct iommu_domain *domain)
>  {
>  	struct group_device *device;
> -	const struct iommu_ops *ops;
>  
>  	for_each_group_device(group, device) {
> -		ops = dev_iommu_ops(device->dev);
> -		ops->remove_dev_pasid(device->dev, pasid, domain);
> +		iommu_remove_dev_pasid(device->dev, pasid, domain);
>  	}

Now its single statement inside loop. We don't need braces.

-Vasant

