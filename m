Return-Path: <kvm+bounces-43423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDC2A90443
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 15:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EEF3177CF8
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 13:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7CE190678;
	Wed, 16 Apr 2025 13:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RmW1V7kU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A9D12C544
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744809644; cv=fail; b=MkIcz1nOxXRNMETvKEWmP/s88geMY5zyEraOIAUQF1NaT2j8wgIk/pI9Btd2bwpaS3yMlBdUvLhJ03qbCORyQjh/ASCAceVNFVe1h90B96CslQhyTo/uvTfQ9QMsqgOIxg+nwDGk975i/UlgWeNq9qm+N0AAhcg8cx8DqY4o/Ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744809644; c=relaxed/simple;
	bh=LMSIICC6snt1yVM4wNGcHHAvo2W0rM3pZd3U5Mj1Dko=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UJmJdqqSywZgqB3axMf2Sl0unG8B7DPupwY3hHfCqCypnRXYfs087c50qIBXwtjTmQF4LuPDnjSxJaG0WU3Sv2F4LDrcmVOk1T77pJUw6sOecG5MNeH6dLEa9LkoTwq04nts1CEaLzVRKV7Ogxf4GPanFy31juJ6v7B/JLstezs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RmW1V7kU; arc=fail smtp.client-ip=40.107.96.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=en2h0b4Ggu+NStltUQFNPccdfgEMMKq8LAZ/5X7QWrq74Rg6EHCLQNg1EvRuYEayi49stFPo74WSPtKHDtD3wmHlBHLUM8KC8YtYrkHiVg2+5zN5IebR+yw5v0vjaIH9p8D5oBi1GF3enSKuVxlv5YLiRnBrwdvMYej6+P5iBJLfgS7d4HpyKfojLZxOubAclSZkOhX5CHSP1YgLDe6sdk4lP/rFwhq6mYIBXA7+tYfFYQ2tFaXnlv0wLvsSDSOi5RECmfRwF+ZhS3vr0fB5ZWiYRqAThNWNSZGHuk5M0/q2IejnvT7LuoQg5c4IO5Pv544InNJfRqGBCyVAvfKMwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyhdAbf6yOTDoBeczR4dQk2hQBvi9ovgd20PUw2XwBg=;
 b=AVPKdXcGfBaHLQ8XwkJFv5wJ0R8jJApw76GOw/U5Csn6KAey6+h22baig2A/7jCSMPOF5XNsPNc03YdRNSIiDvzksUIFlosikogjH3/L97Mrcg0oGzdJIvNLZdgX8r0pbMDweSoLGaMlmBzEUkDEFNvJ2xHn5WteTIvZw1QIG6p7fecryONbOfJtDF41mqot+PW6hPsf7QlJZjiCv2bUz5vo2thZM+xPNRf+3Bwos/PWoOMf2SSejIXJsfHTCdYN9lD0n46H4Pv6BZ7yAJNFp/l5FD3RiEvUZp/dZMS/mYdAx5shw3q/OTb9bOdJ/s4mBPjjcNTcA43A/VZVd3uUbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyhdAbf6yOTDoBeczR4dQk2hQBvi9ovgd20PUw2XwBg=;
 b=RmW1V7kUcrM0+MnOAPqyFFLfv4IQQtcG2on85QwSXbcOJuBWTwuE7mpIMTbS1qSWAKbk3meWl054vZ/SziyRnZ0UdsfDINHpJeqm066T4c94EE/JbZnQCNnnctqGBtHi2dOI0s9F4WXTRXcmZADXvqFg52Nhjt77YaR2PfKiwZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Wed, 16 Apr
 2025 13:20:39 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%6]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 13:20:38 +0000
Message-ID: <5258d788-88a7-4dc4-98f4-3cf97189bab6@amd.com>
Date: Wed, 16 Apr 2025 18:50:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-04-17
To: David Hildenbrand <david@redhat.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <971a3797-5fc4-4c7f-a856-dca05f9a874e@redhat.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <971a3797-5fc4-4c7f-a856-dca05f9a874e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0110.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2ad::11) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|SA0PR12MB4447:EE_
X-MS-Office365-Filtering-Correlation-Id: 7457a74b-44c3-4c13-97df-08dd7ce97a7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmQ0WnlhSnQ5RWJ0K2pnTmcyd1ZSR21MYWNFNngwNW5TZzAvZ0Y2azZ1UCt5?=
 =?utf-8?B?dUZ4dGRocC9Ua3VJb1N1anNFOGx6VTY4Q2d4VnlqajducWxVVXhraXZwcVpI?=
 =?utf-8?B?dkdxQkkyQWVoT0dDSlg1NVlsZVE0d3ZnS0JqVWZCNC9ZYU41Nk5zWllOWGNP?=
 =?utf-8?B?a25CQlRyN3ZIc3YxYWJPRHF2NUdqMFdobUpLclJYZHhIcXBralFaQ2xBbS94?=
 =?utf-8?B?WFova0lYMm9OeTN5QXZESWc2OFBUN1o3Z2NjNmFLTVgyV1FVRmd3NGcxRmlS?=
 =?utf-8?B?TjNDU2w5Q1NhamlYTkI5UVV1ampvcE5KT3NySDhlOHp1ZnlVak8rTTZWUFFY?=
 =?utf-8?B?RnlNTjFES1dPWjM5R2d4dXFUUTQyUzJhakZoSjB2bm1KUEljT3NEQ1FJZVVs?=
 =?utf-8?B?WGl2MUlsRGMyUGhmbm81VHFmWTZpOUszQm4rTGVvODh5MkxJMW1jK256d2Fi?=
 =?utf-8?B?UlF2TEozVUFTdGpiMTg2d0Q1eTJGZ1ltSFBUeHBneEx4ZWRWd3BaTTkvZ05D?=
 =?utf-8?B?NmVhUmFzVUUzQjI4bzZob1J1QlNNL04vUVArTHIrNXY5SzlQRG9nRldrTlBw?=
 =?utf-8?B?Mnp5c1diWkJyYkdheDdGdFovMm4zSldTazhKZ3REYlA3dnN5SHZBNGVGN0Vz?=
 =?utf-8?B?WVY5QW9VQ1d0UGRMelBtM3BhMWgyL3lldEZ2WVdqRDE3d2gvc2x1SVU3K3dM?=
 =?utf-8?B?WURpeS9jWlF2eWZLRXhjWk5TaDdNZ2JiM2kxajdJTTM4TjZYaWFPbHJNR0hv?=
 =?utf-8?B?eXZZSVl6MVlZckdFTEg1SlZESVV6dk9wUk9GKzhsV1ozUTV4VGNDMnVvWkkr?=
 =?utf-8?B?cHdCWHV3NkZRZWxkQ2dFbysvM043MEdwQ1poNWN1YU95bG5BNHlkQ1V6NThq?=
 =?utf-8?B?cmxTTkNEbHp0SXM3blRaL2c1VThXaDZtWkhkd29lekdwQ1dwWmtxb1J3MWxx?=
 =?utf-8?B?MExZekl3Rm82ZU1mbTUwTzhCN2ZVWHdyN3I1a1p5RUx0T2d0aE5ENUxNL0h1?=
 =?utf-8?B?M1NXYk9lZkN4cUN2OHFLbUJZL001VWw5d3BYaEo5dFFObS9FTVhERGRJTXZF?=
 =?utf-8?B?QjZGOGJJL1A5c25xSEFkU1FOb01MeHA3RlBoSXd2ejRVV2RIYUpuVDI5ZUU5?=
 =?utf-8?B?b3hYc1A2SEtQTE82WXhRK010VFplZjBEaC9DTGZqYjNqTk14UG5Ma1lPY1Vk?=
 =?utf-8?B?VmlhTitwY1hOc3VpUlA4SG14c3o0ajBlVmkzMXVGbW9YTkNRdlNiUzR0OU9H?=
 =?utf-8?B?eFVBcUEzdmlRNkdoUUtjM2FmdWp5T2t0TGJPbE84WUcyMmhNV1VPb3I4c0c4?=
 =?utf-8?B?UEFMSWJValM2QktESDhyQkdOUU5RUENuWGlGZms4YzJISUJGZm15b3N2YS9N?=
 =?utf-8?B?SW92YW01M3NJdzNvdSs2THVPUXZQTERYVHMydkhGSHdZdFdIdktVeFl3TU5T?=
 =?utf-8?B?aVgwdkk0TG1pSUZRR3FWRUpvalJrelBiUjVjTk9na0k0VTlxSHdDWC8vSXhQ?=
 =?utf-8?B?L2g3dUh2YkVkUFJwQmdSNm14Tk9BbTJMY01mQ2RxMzdWWUJnRkkzY1plVzZu?=
 =?utf-8?B?dUhsQkFNVnNDMmZndXB1cXNDZEJlaDR1a0IvVmFLU3RETjJuVUZZeC9OUk1H?=
 =?utf-8?B?TWxjM2RpbEZSN0F4bml0bTZ3amkxREZoSWRxcWhLckFKN3hFcWNxZmRwamRO?=
 =?utf-8?B?UWdjZnpJMWxRTUVmVk10eXhJdmVWa3JyUDJZQnd3RjlucktoUjltZkZQQkxa?=
 =?utf-8?B?cmJZWlllV0FNaDd5T1Q4L2tPNkUzY1Z6TlRGcFNxZFZUY2p4aGloZjhrWWEw?=
 =?utf-8?B?MGg3RXdjSjZkSUtTWTYyZjBpVWtGVk1oTXhFdjV6TFdrR25iQWtwaERkcUxO?=
 =?utf-8?Q?70v3ZHmoRccAO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm5ITEhOSCtTcERkb1ZRTWczVysyS1AvRFYvRzNwSCtpV2hqdlNLQURvR0Js?=
 =?utf-8?B?aS8wcFhnbGVYbi9wVWw4UWdxbDRDZWxzWlo3ZW16d1lDZEF1TnJBMmt3NVdG?=
 =?utf-8?B?bS84RG1GK0VQS2JqU0NCY1M4SExWbTBqTFJiTjlFU2NMaFdJbythV3FkeVBh?=
 =?utf-8?B?WWlvOUVzNnhTWWVUaitubExENS9xaVIxMjk1WW12ekdwcG9HcHFFWnJ5azZu?=
 =?utf-8?B?ZjBVdFNYRytYRkF4b3B2S1BGejNKZTdoY1c1R2IrUGszbTkwVlJzYjdrRyto?=
 =?utf-8?B?d3RFTTAzRW14d1NZRmFiQVd5UkU1NDcxdXBWS2Y1UHA3S3Z0aEVsZk83WHhx?=
 =?utf-8?B?SGkrYnUwY1dUTDVOb0xZS0plSHFrY1hDZm9pMVNXdDEzT0tCZWkyTCtmWVRx?=
 =?utf-8?B?Wk5NYjNzTndjaG42RVoxZktySW1xeFhTSk5SNWIvOHhha2o0UWtZeUdIWkQr?=
 =?utf-8?B?U01pWUk3cllxSzUzMzZ0RVlLLzdlRFhQdEcxeWNOMFJJanJjL3VMVURNY2Np?=
 =?utf-8?B?SWs0ZlVDZWphNE40bXZqcjYvSTExQWtwUkNFWW4wNHZ5UXBobDZEZGdMRWt5?=
 =?utf-8?B?ZTZOaHN2bW5Ub0lYaHUxbjR0U3dza3IwTUY5T0RqWWlmbUk5WGtob0lqMmdX?=
 =?utf-8?B?Rkl0VCs0UkprSEkrcVlGaGtrSFdMWjY4VVQ5aS91UTlPNkxKVUlNS0lFa21W?=
 =?utf-8?B?YStMWHhIWFQyNFlPMkEzQUorMmNwckpPa2Zndm1rUkFwMTEyUU1GclBzbExi?=
 =?utf-8?B?ZnpIQWVCRkpnT2hzV2doTFdUdlAwNjBkUk9wM2RmcUplYWNnOWRWMklpVGxD?=
 =?utf-8?B?b3pDc04xT1RablV4SGJoUDFzdGNMNWorcmJaYzNZVUZ5dGFQczFtN2ZVRE1Z?=
 =?utf-8?B?SlF5cVhwRnNMdm9LelhJbnFWZk5kb2JobTdzQW01NkYzdjlXdFA2WVNhWjBk?=
 =?utf-8?B?R09wYmNjT0RtekZJcE1PNDVMcnBYMUVya2c1NVl6SXkweEw3L1dZOGVCR3N0?=
 =?utf-8?B?SUY4VzFrMVVBUm96ZVE2Nm5sYTRPVTIvZDJDeWQ3dHZPZmJNZG1pSlhsS2h0?=
 =?utf-8?B?Qk84N2RGTjVQNFhJK3piTlZMWU51MWFhQXBNa0JldnlyczVIbWlvTUVaaHRN?=
 =?utf-8?B?cFJQU3RPaXphTnVMVG9BbjlvbmRTMVhmZVpkSHBCTFQ1TU53ZHBzT2s3bkJQ?=
 =?utf-8?B?NHpnTXUyYmtFeElKS3ZSUkRsZExIN1JRd0hMSjlSbjFQRmFaT3Y3WUdEMzZ0?=
 =?utf-8?B?amw5c1hWYjFjVE9tSkZ1djh6dXVBK2JIUHppOEZXNGlNeXo4ODBtWDJnbGtp?=
 =?utf-8?B?cHB2dENob2pEWmlFVnZwbDVaMzF4UHd5WkMydTRHdTcxcnpUVDlVSjlDMi9v?=
 =?utf-8?B?ZkJQL2s4TG5sVlZDZHpXd1FqZUg3NjQ1SXg0KzZsYW50Z056TE5mcnJhK3Mz?=
 =?utf-8?B?c251TS9VNjdWSWdCczJFM3kwWmhDcmtpWFdmNlFEd3BQM1VHNTJXKzR2YVJK?=
 =?utf-8?B?RTNwczVLSWltNzhxTFpsLzBIclBtZ0FmZW5uSXFUdVY5YWUyVDZsSGdsYWRS?=
 =?utf-8?B?Y3hGU2QwS1FmZXA4SzRKcGNramdmd1hkVGVWQjdRK3grVkZXWVhNem0vMlov?=
 =?utf-8?B?U2NtMGllcFlvSG8zVjRQblkwTS94RHFoSW9ySlJLM1c1V29PVWYwSXAxVG1u?=
 =?utf-8?B?ZXBCWlJCR1ZZTDJFZGZiaHJaSjh1c2hmamZkcHI3b1hGMnNKY1lOazR4WmRx?=
 =?utf-8?B?MXRWR2xrRHVJQnVsVmJ5Q1lyT1F1VUdQM0dZc0l2MjZzejVkSXRMc0wxTkdX?=
 =?utf-8?B?RmdMMEh0SmVqTFVMN1I4UjVQZzdPbS9sZDNiemdUdXRRaVdSNEdKb0NJblZY?=
 =?utf-8?B?V1BtQngxTm1EakFiRGk1ZlM5ZXc0UDhwYUdyOWkwK3NwT2k0dGRNZlZ0em54?=
 =?utf-8?B?S0dmcHVXdjA4Sk4wbHB4Zi9YMTJBUmhqbG9KcjFmNGdYL0x3S3djL1Jxdjdw?=
 =?utf-8?B?QkVEbzk5eUNJeHZGN1EwREgrdC9xSFRHVnRhZENDZWlhSEtlNEVsY0ppcElU?=
 =?utf-8?B?N053Rm9EbVUxYlo5MThZT2xTaEQrYWZHMi9iRG1yYjZaQ0xUUjhZS1hVZGVw?=
 =?utf-8?Q?fziNOk/4DDhRub1UhdOxHkOa2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7457a74b-44c3-4c13-97df-08dd7ce97a7f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 13:20:38.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ddyEZx424k93epc+mkwL56lir1bqCb6ZItKUc6MGMZydqCuhBZy6pCbBBsvMJCs/UEkl5xqH+9i9tCDAvXWdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4447



On 4/16/2025 5:28 PM, David Hildenbrand wrote:
> Hi everybody,
> 
> our next guest_memfd upstream call is scheduled for Thursday,
> 2025-04-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
> 
> We'll be using the following Google meet:
> http://meet.google.com/wxp-wtju-jzw
> 
> The meeting notes can be found at [1], where we also link recordings and
> collect current guest_memfd upstream proposals. If you want an google
> calendar invitation that also covers all future meetings, just write me
> a mail.
> 
> 
> If nothing else comes up, let's talk about the next steps to get basic mmap support [2] ready for upstream, to prepare for actual in-place conversion, direct-map removal and much more.
> 
> In particular, let's talk about what "basic mmap support" is, and what we can use it for without actual in-place conversion: IIUC "only shared memory in guest_memfd" use cases and some cases of software-protected VMs can use it.
> 
> Also, let's talk about the relationship/expectations between guest_memfd and the user (mmap) address when it comes to KVM memory slots that have a guest_memfd that supports "shared" memory.
> 
> 
> To put something to discuss onto the agenda, reply to this mail or add
> them to the "Topics/questions for next meeting(s)" section in the
> meeting notes as a comment.
> 
> [1]
> https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
> [2] https://lore.kernel.org/all/20250318161823.4005529-1-tabba@google.com/T/#u
> 

Hi David,

I would like to discuss my V7 posting for Add NUMA mempolicy support
for KVM guest-memfd (https://lore.kernel.org/linux-mm/20250408112402.181574-1-shivankg@amd.com)
which incorporates feedback (using inodes for storing mempolicy) from my V6 posting.
I believe they're in better shape now.

Thanks,
Shivank

