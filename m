Return-Path: <kvm+bounces-19583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0AF9074D0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CB6B1F215D7
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259452AEFE;
	Thu, 13 Jun 2024 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BPmDFSbI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E63F143C75
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718287960; cv=fail; b=eXx/x4Srtb7kqfuCSmiyj7nbRwS74U/JNQJ+wQUzFHI451jRKsdwz+VJjR5duuUma9g9doMUNJ7NT3ABXP2NwfXHjwxehb0fL16NLgMHrT3owhbhjSwhTDdQ3FoaFgyUdg5eUQb8ZYdCpSgIk4sBFgx33W1f6JEZBz5dXJ/38sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718287960; c=relaxed/simple;
	bh=UwDcpZOBpl7NwuFc44dD2b3+L0wdZ6T4ue+UAW6og8Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XghyKJ9XpcfptBro3TbcouvJj5tu/T27BXOGPAxqvvBLFSlRuYJw8S4RgcPoKfhj8F4UvXfsW7iCITxn/7sIeDBUK95OrjCLQxTjziiQ/rNMZ9aq3oVhSCFk0x+gtkSTmkCAZG9JKjJx8AU0RDIJXHBRfokkzg8w/rCj5iN5bm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BPmDFSbI; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3fy3Q/iNbj5RSTRlp7MaDJcPPC9htMgHCX4msq/k6TKkG9XNHVqDtTcVxIzD/SuXKxnqqClGum7TlPAr/fGtg3jJ40LPI6lbdf2RlXIZ8wJuKAjQel8Ozr5u3DOtPfWlJDhibG6SPY0J4wZ6TOFTBv9W2NLzRpIL5j4+MQ11/twa0gHLZiiAkCbe8qDVtkuUGTZ8TgDADUsHo6C6dJ9MPAjXngcyfeSQ50NWw7/yp6l+DhX9XIH2l69KYliZnpOoPtFKYKSZby1oOPBk/Ai5h68ggHfWrp7tJ/eH5terrFm9rFA0a+F9EObexZ0IRF06B8QNmR8/qsm0eP95KWjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5fVKnoY+Ji1Z+wp3ZFMl7JAGvf9mxXQQSqvejy0lkc=;
 b=AxXjvDXjJORFDd53FBD8bhiYyPk/IdlEARCkv9C3sYGe3D23e2s66utbLlLd8ehj6wIdLAKHH97Jk18NGjc3J9R9ph1FMrLF4E+dKIRSLtM7k2hSnoDPjfivKAqISQitGQ+QdhGHtDHlvrqH938gvGDshEnjlT6Yn/yg4anjXRbvUqYLJcRbEXBrI1cyboaiQHkVRTo4nWkFoRF7DFvvafpq1g42uaABQbrS+vIpDJl8xEoqcZr+N/fYkyz9XvfMGwv6K6Cfm8KzQUKXV3fEmIR20OhnDctEDI0APl5TYr4PglNeQEmtiRJGXvH2F5tYxJ996Rc5ogXxu81UIZiv4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5fVKnoY+Ji1Z+wp3ZFMl7JAGvf9mxXQQSqvejy0lkc=;
 b=BPmDFSbIwaDWWSOuNRt94mB4oi6pHcHh3xBDxOVLizjTsr9cJFLT1xJz0iCT3rnTb/DNXo426/lJIYkI0EeMsjnEc8u9kyLFBUA548swgj4rBLgIdhh0w4JjgBEY+MCDZnZ2cM3SCT9taFZLzFfhKRexyhRl+DzK2yi+Icb9cBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MN0PR12MB6029.namprd12.prod.outlook.com (2603:10b6:208:3cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Thu, 13 Jun
 2024 14:12:35 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7633.037; Thu, 13 Jun 2024
 14:12:35 +0000
Message-ID: <07923673-5f99-4895-907d-a84a0db98fa2@amd.com>
Date: Thu, 13 Jun 2024 09:12:33 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH 2/4] i386/cpu: Add PerfMonV2 feature bit
To: Zhao Liu <zhao1.liu@intel.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <cover.1718218999.git.babu.moger@amd.com>
 <6f83528b78d31eb2543aa09966e1d9bcfd7ec8a2.1718218999.git.babu.moger@amd.com>
 <Zmqace8eCFHPq8ZK@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <Zmqace8eCFHPq8ZK@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::21) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MN0PR12MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: 20c3b433-9219-465f-114c-08dc8bb2dfd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTM2cE9LUTg0N2ErSlFGMlNTTmRVQnRqdldMQklhcjFKM3dkK3lZdTgzeEpY?=
 =?utf-8?B?VDVId3VPSVBTdFlYOEtCR21yTWdBQ2UwZXdiV2tHN0RoMmY3Z1d5anBUdXIy?=
 =?utf-8?B?Z2RwZUZKWmEvb2Y4ZmVIdkxueSs1bDB3di8rZGF0bnVrM2xVVWR0Qkg1WWRx?=
 =?utf-8?B?TFdNelg0QzBWM1p5YjVCSXh2bkY3cVhjbFFuRWlqN2xnejB6c045eElSNGw0?=
 =?utf-8?B?OU9rWTRKUWtHNUI1dEswUGRScEdZM09qZS9uZ3BkWDNNcXFyN1YyZkw3OXRy?=
 =?utf-8?B?cnZXZDhMYkI1MUhKMlRjeDJFRzlZWFdmZHY4VmJKU1d1eU42Z0cxNGxMSUdo?=
 =?utf-8?B?ZlNVQVVOYnc4d3ZtTkVWQnNWRmlZZEhpWGl2SFVVNXFzV0dackpnSE5SdDNB?=
 =?utf-8?B?SWw3RDEzZkt1SDFIK2h0SENPNFk1ZWNxcFYrVVI4cVh3SEw5ZWFBcDQ4b3dk?=
 =?utf-8?B?SVRQSVp5eGdUczJnaERDVFJzaEREZ2Y1bkR2U3UzU3JacmU0MXVOelJKdmkv?=
 =?utf-8?B?N3FLNlo2MkU0NEwvVUpUVXhDN2EzU1pZa3pUMGcvVkJlYzc3SkY4aUhZWHhQ?=
 =?utf-8?B?N0IxekxneXpEMmhSM0NPMncyd2h1SjB6RGhweXBqMGdYdm8ycU8vVnlzNFVr?=
 =?utf-8?B?dHk3MlZhUnJlZzdXc3ZFcXlyQjR6MnlLbURialE3d2pPT2ZjU2p3aU83c0ND?=
 =?utf-8?B?cENVUXpFK1IzVFQzOUVIa0ptS0NvYkM0RXJwUWN0SnZtM1ZWaUkwbjBXNUJx?=
 =?utf-8?B?MGFpZmlOYmJrTVNUMVJ6TFdUOHVjalNGOEZyL0Fyb1NkcTNpYUFzYXVRTTJY?=
 =?utf-8?B?cEFZM25xSlVTdFdHMWx5VEE1NnAvbHJQL2hRRDBqS1E0VlVySlVSKy83ZXhM?=
 =?utf-8?B?WStvbFZSd3B5SFFBRXRycXpXekEzclNqazlpbEY5S0NNdVZjR1YxcHo3cHpV?=
 =?utf-8?B?RXkzQTRVT2VlcXNZWHUyV1FPSmR0aW1DdjllcUZnRVpyWCtUcUt4SGhkbmdN?=
 =?utf-8?B?VU5TNG1xQTUrVExGR1czdC9jSWIvdU95Uks0a3JlL2FHVHVlQ0RvSzdnNXB0?=
 =?utf-8?B?eDZjZUxVeWg0Nm5ZSWJWcXArWG9VaWE3K2FiQmpCUlF3OFpSU0lIYWRsRjF5?=
 =?utf-8?B?Q0RlYisrTGtuL2hmSld0QXNPYzM4ZndNWlVLcjhWR3V0UCttN0hQWFViU01Q?=
 =?utf-8?B?K2g4ZnVPTllwVVA2ZnoxUWRjYVhSTFJGQ2ErZDR2UWsrek1oazYyY0VBZ0Ey?=
 =?utf-8?B?U1lDc01RanVpRDZUTXZDL0IxaVlnSHdqc1pMaTZ0d09VRGlUM2pSQ0dIRGZi?=
 =?utf-8?B?emxHaHlsdEdpbU1FMkgybnRRalhWT2JnM3kzUlJiSFNzSk1oMUt2T2hPaW9h?=
 =?utf-8?B?aDJIcDVGbjlUQjRMV2JnWXRNd29LbEI3WkxXSWsyaTd3ZUc5bjlNWHhpbzNT?=
 =?utf-8?B?TU1LbWZUZGw3VjhYbGFRS0lEUWJKMmFuSHVOanpNTEthSjUzb1Q3NHRmSStl?=
 =?utf-8?B?T3VaUXdHR1FGeW5Dbm9Wc0E5WE8xSXVYN3R3NU5YUnV1bUs2VGorQnQySVBk?=
 =?utf-8?B?ZHdHUlJvUmk2eGFZWjhMUVV3UE9JTGJoVjN4WVF6L1FqQmptRWhQa0I3QVl3?=
 =?utf-8?B?dEtlN2FJNkYxRldvb0JLN1RtNUZ1eHdRRzJVRGJZZlRHV3BHc280Zjh2WVRQ?=
 =?utf-8?B?YVNzM2N3NkxPTkx4ZlpPMU5FOWpDWTdoaWhEVE5aSW1jMndkdWRySWFNNXNo?=
 =?utf-8?Q?3F89XpBTcYeQwLu3cuXwt3e2vN/Sfd135S/ROZJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE5BQ1ZFQzFCZHozb3p6Slc4cFFVM3E1QkpPTHNLQS9YSlhpS3k0a0dsT0di?=
 =?utf-8?B?V3BRcE40dGNTTWM2cTIrMThCb2wzRzhRNDJ6VFI0Q2dkVHZRdGhpQngxTHk1?=
 =?utf-8?B?dFNCME0xVHJmMHNHbHEyN005Y2pTSXpaUU1PWjVRSjVMeHFZTnczQUdnRmFt?=
 =?utf-8?B?dnBXM21Mb3dBSCtXclY1Rjc2Y3B6MmZMaVA3bnFTYjQrOUhKWVora0dXdkM1?=
 =?utf-8?B?MWJQR09JZzBSbkxPa0NsZmxNUEUzSE03L3FjVmRiOFhCWGVsOE0rbkpYZ1B3?=
 =?utf-8?B?UXQvU1pxWHpaaC9NQjZzSnRFT3l3Y2ZkbnJRYS9iVlZKTkxFa1VOUUpXaTNl?=
 =?utf-8?B?RVR3N2E5cHFwMXFvSEpDRG1RMHBUejBRL2svN0pSWHU1NnBXTVg1enAwTWpq?=
 =?utf-8?B?Tm8zbXptK0Eyb3J5TTdwVERqUXZvSEZiVVJhZVJ1aEM1QmhEcW9VbjRJbEZt?=
 =?utf-8?B?Sm1NaEI2cVp2dmpxWlo0QlJGckVuRVJmQjllZ05oelR5QmcwK0NMM0d4cGNz?=
 =?utf-8?B?cVhnNExwK0kwQ2MxUzJuQUI1YUpDZW9BNTBhclg1QlNjUDJiOGxvQ2M1bGdZ?=
 =?utf-8?B?aVVZbmNKYWN0ek42dGZ4RlRBcUR3UXVpdUJRR1Nid1p6THhnNmNLZTFDbUxw?=
 =?utf-8?B?b3BlSTNteFRvWlo0M1E4bE0xSkNLYURydHZoWVhYZVZlS0F6alpoU1hNSVpt?=
 =?utf-8?B?VWl2a2JXOUFZTkRKakY4ZGhCZVRhN2FDTm5FUlArbmIwQldmTW5iZU5pa1ZC?=
 =?utf-8?B?RzdUd2s3bXBGSFBJajNvTUlJSWlHOW5MT3c2ZEp6VHR0eW9wNW0rOFQ3ZGF6?=
 =?utf-8?B?TWUyR2ZFSXVKdXY2K2hxMk9ENkRQV1V1a0ZLNUtNdEJOOGZTeEVjQVYrU3Rj?=
 =?utf-8?B?dkZubUV6UCtKakRIYjF0SHVTcDBWWnRydnBFVlBkbXNJSHZxM2Y3M0l3eHMr?=
 =?utf-8?B?OGpvWGlMd2h1NFRqSjhZUCtxQjRKbWtjWHRkd0RheEJXRXdYckdxdDFPdXV3?=
 =?utf-8?B?RHQ3SStwSFFhbC8yTHZDRWVnSC9NQmxZdEgvWk5ocGpoL1J5eHlCR2VFejNs?=
 =?utf-8?B?T2t5TFE0QjBwOTNmUnNjTXNGWnR3WXFFVVIrZkRscHdNTytYQjV2VXJEWTBp?=
 =?utf-8?B?L3pUVm4ralRwM2tka3RJc2luM2pwb2xDQkFEUHVuZStCR04rUnpKNWFTM0h0?=
 =?utf-8?B?VzNUbis4eFZRR2xsWmxBajA4RFM4bzFBaUEwZEtsWUUxSUUwZjJsNkVMOTJC?=
 =?utf-8?B?ZG5TQkRDNVRNNDk3UG1mb3ZwWWYwSFVyY20vbTVjaXdWY1dpUzJUSGttT05s?=
 =?utf-8?B?NnY5ME1HS01YK2JicWlVQUowMTJMcVY5NXROTExjVWVWd0J1ckhVc1hoTlIz?=
 =?utf-8?B?eE5BSUhjSklyTlJEWFlkSFM1T294U0M0NDdvUEwxaGkrejFTbld1OExHOWd4?=
 =?utf-8?B?Q3A0MHVXRkcrc3hIUjNFMnJ4VkRMckVlZGU1Y1IxOXVMM0E5V3dFR2ZCYmJ0?=
 =?utf-8?B?aENFMy9OMUw2R2FKems4em1FbWtKLzBDUTZXelhXS0lrdytudkVsckIrVHlh?=
 =?utf-8?B?UzdBdW9saUZhN2owS01kdkpqeGVaOHlIZ2I0WEt3dk9QajZyM3NLeld6SWUw?=
 =?utf-8?B?R3RBZFIrYm9aRUdQMUJxcUV4aFQ0L2c4OTZER1lvN2J6RC9PTk4wcEFGSGRL?=
 =?utf-8?B?a3hiYnQ0NGpoZFl6aFlTNlR1dzhyY1ZEaEVSeHZPWlJuZGdjc2pnRVRuQzdL?=
 =?utf-8?B?ZDM1M2VDMTBTMmc5WlMwa3VoUXJ4ZDY3THp0MlltSnBjU2ZPa1lzNlh0VGht?=
 =?utf-8?B?bEVYZWJWYWVaK0JxcHdyNFI5eWl3RmxBNlV5Umlwc1RYMWRRSDI0bUpVNytY?=
 =?utf-8?B?MUZzdVNuam9BRkltaHpTZ2hqY0tsNzBOMXc0Tnk1TkNSUTN0VTloQ2w5UGIz?=
 =?utf-8?B?UDM5ZE9QemZkQ2xwRloxRXhnVFcxM0ZuWGYyUTFiZUZQOS9HdlNZMmpvTDBw?=
 =?utf-8?B?RVc2UEpIZ2tnRnAyVExkaWFOWDBQdXZvY2F3V2xxQ2sySk94dlFiNVdDQmFk?=
 =?utf-8?B?NERSaTlCNGk4YmpHYXNnUWlWdkFSK3g0cDR2TmtGUVYzVE0rU1JaSjJ0Z3Bp?=
 =?utf-8?Q?nsPA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c3b433-9219-465f-114c-08dc8bb2dfd7
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 14:12:35.7177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWe/utw/1paD8mZcFYUXeUrNOlv9kXYBtUBXkb+c3NPqAaI7ORbL+hbtzXecyYYt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6029

Hi Zhao,

On 6/13/24 02:06, Zhao Liu wrote:
> On Wed, Jun 12, 2024 at 02:12:18PM -0500, Babu Moger wrote:
>> Date: Wed, 12 Jun 2024 14:12:18 -0500
>> From: Babu Moger <babu.moger@amd.com>
>> Subject: [PATCH 2/4] i386/cpu: Add PerfMonV2 feature bit
>> X-Mailer: git-send-email 2.34.1
>>
>> From: Sandipan Das <sandipan.das@amd.com>
>>
>> CPUID leaf 0x80000022, i.e. ExtPerfMonAndDbg, advertises new performance
>> monitoring features for AMD processors. Bit 0 of EAX indicates support
>> for Performance Monitoring Version 2 (PerfMonV2) features. If found to
>> be set during PMU initialization, the EBX bits can be used to determine
>> the number of available counters for different PMUs. It also denotes the
>> availability of global control and status registers.
>>
>> Add the required CPUID feature word and feature bit to allow guests to
>> make use of the PerfMonV2 features.
>>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  target/i386/cpu.c | 26 ++++++++++++++++++++++++++
>>  target/i386/cpu.h |  4 ++++
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 86a90b1405..7f1837cdc9 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1228,6 +1228,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>>          .tcg_features = 0,
>>          .unmigratable_flags = 0,
>>      },
>> +    [FEAT_8000_0022_EAX] = {
>> +        .type = CPUID_FEATURE_WORD,
>> +        .feat_names = {
>> +            "perfmon-v2", NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +            NULL, NULL, NULL, NULL,
>> +        },
>> +        .cpuid = { .eax = 0x80000022, .reg = R_EAX, },
>> +        .tcg_features = 0,
>> +        .unmigratable_flags = 0,
>> +    },
>>      [FEAT_XSAVE] = {
>>          .type = CPUID_FEATURE_WORD,
>>          .feat_names = {
>> @@ -6998,6 +7014,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>              *edx = 0;
>>          }
>>          break;
>> +    case 0x80000022:
>> +        *eax = *ebx = *ecx = *edx = 0;
>> +        /* AMD Extended Performance Monitoring and Debug */
>> +        if (kvm_enabled() && cpu->enable_pmu &&
>> +            (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
>> +            *eax = CPUID_8000_0022_EAX_PERFMON_V2;
>> +            *ebx = kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
>> +                                                R_EBX) & 0xf;
> 
> Although only EAX[bit 0] and EBX[bits 0-3] are supported right now, I
> think it's better to use “|=” rather than just override the
> original *eax and *ebx, which will prevent future mistakes or omissions.

Sure. Will do.  Thanks for the review.

> 
> Otherwise,
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 

-- 
Thanks
Babu Moger

