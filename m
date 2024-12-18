Return-Path: <kvm+bounces-34032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D04EE9F5E3E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 06:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FA36188F9F3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 05:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAFA153BEE;
	Wed, 18 Dec 2024 05:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="43pHg3a7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5F513E3F5;
	Wed, 18 Dec 2024 05:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734499317; cv=fail; b=nK4xJQlSpW6PrHW99mGzyjOIUaD2EzObF9kDK6V6gFw4obvuikZX1NzpFi9wJcLap3RqgHKEmY/b+J4KGug23VikeWmDLtk46JtXVQPWm2BzmKxrFVxODcNNCUgbK6PaD8CKfsRktWjeAL1dMkfKkiAIJDNXsw5OkC2tOscUYW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734499317; c=relaxed/simple;
	bh=cQDEx7s7oO0gNY04SoKSbUa5AHQtXHTDtd7IeVfD6/w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=krdTPjHOM1O2ipjbgWYrqRFDKxafpzlAVhrsI3qUpiuwG+vFdCqITYlWeH0+XMpC2QesvrOd6kfSG4uBcgL3VPC86q6U9w/8NEibamTTtKTfySZ09UT4BMeQcpAPp9OZRVKNFvrh0gmFOxoUC3W7YiAOJjmy59GLW2+Hj5YDdcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=43pHg3a7; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/bz7pYzoq6o76m1PaL//GkOoPzUynOlADe3hRdiSKQJTmlnwhDhH2wiEhh8n5xNDaetHh09+lYFBgG34yZpiJzpbKJ4RkUvwE8E1Q4WxqvUcWbD9bSmvwSmLeJ+1eL4S52iHocjU9wFWIWI+jku4xMr67ZDpubyZvSKxA4+LDlZQtA5wp5Jm3CT2Z+7fcoc0f7Ht/WZQ+4mqp8nty6dCBoA4URshR6+tRQZpCup2Zvih5G9+g3bH9OHV0FM1zu/jPRmfzMtM59O/ABOhf6IEq9qCUYxaLwyqF/SF0Y+0Vhxur4LE977/dP2ZsfiDNZ+3ZVAgXWra/0zEa21//CAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtfYSaskepZ3JpHmg40a7Od8mYLM7SIvKx/8ADAT9zM=;
 b=vvETssjSQGcb1kJFk80VAvxTNRTgKB4QoDG+TZPFT4qKCzQ+nJ7OEoRQYcAeFusPLJklZ2GODW9ZhR7RoUK46YY15XN5KWdQD8mMjV0UybHssx2VQGbMbLseIZbf8VPeBjLxRtPjqJb0yXc5H9Q1ZYbTWtdyarbkXPRSXjaoFWjXjcdgJPrfBYc/SIj6UWsLbM40kH1PyNycQYCJBdZ33G2t12mRUn1bRm7Bnl/7VKs2B1G+wfSaH2tL2wCV8WzchQ2u4JMyXYuIQA2KZm2ZKfSEOq34uDk1coH282YYqmjXPNixHvNQyR1QNjbWMeALRfuga1WGVoCDkC0uL330Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtfYSaskepZ3JpHmg40a7Od8mYLM7SIvKx/8ADAT9zM=;
 b=43pHg3a7gT9efWH0Rdw6nwF29n0r4At8tWAx0ndIGZwh+gi6WXawcj890KzqmUOtRk9GQRXhisYj6qf5ecZ7iAVmka8Xym3oqXZ6yXhwAPLZCz1GOJeWlscVPJwNtDmwgz3/HeBUiP804nRMztgAKEIUbssbachCdDZox+nGz74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 05:21:53 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 05:21:53 +0000
Message-ID: <46ee441c-7105-4305-b919-304e30af768c@amd.com>
Date: Wed, 18 Dec 2024 10:51:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 08/13] x86/cpu/amd: Do not print FW_BUG for Secure TSC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-9-nikunj@amd.com>
 <20241217111032.GCZ2FcKI9ANjz3Xb4h@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241217111032.GCZ2FcKI9ANjz3Xb4h@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0004.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 86abee17-db6f-4fc4-a948-08dd1f23e213
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXd1dUR2dWRRbVlMSGtmNHdRQVhXaFp1d2FNREd4MmdlM1lrMnlQQk9nVzVT?=
 =?utf-8?B?SjdCQUhBdVB6YW5HajdmdFBHak91TUZESEk0N1graDhlK3lnK3FmbEpvS3Av?=
 =?utf-8?B?RGN6cTJGYi83dkNYWXlMVnFrQkV1VzRxbS92ejRDUjlUdXluWkQ0WlFGSGtT?=
 =?utf-8?B?NlJJMUJQbDZjMXphc2ovNFpRcy9jNDdLSmdYZ1plUUswbmUrYmRjdWdGRkJ5?=
 =?utf-8?B?WE93cS9yZEE3MEYwM3hJYk9lT05yUWtWSzJ4R3BxcURUVC9SRmErUnFGalRh?=
 =?utf-8?B?YUt6cXhHT091TFlINVFUSXRFVUx3Tk56NTN4RGVzaExrbWFsZEl2RG8vWjV1?=
 =?utf-8?B?YlYrMS9BcWtZeGhDUHVnQjhUdWIzOHl5cUcvSmNoSUtQUjRJZys5M3JXcU1J?=
 =?utf-8?B?dW5NTkFnSUZjNnVTSE9WNDg1YWNBYTFWbDZUZWxQbXM2dTV5Y3VzSk9JeWFQ?=
 =?utf-8?B?eWlxeVhkYkFtY24zd2RubDZlVU9Tb1JOYkp6akN0Vy9VUFA1Uy9xYTRsVktN?=
 =?utf-8?B?V2JsVlBRREljVmlKanpFcllMV0JwZHQ2cThDdnpDZ1hqWHA4OVlaczEySGV3?=
 =?utf-8?B?cjNjckEvWEU0VnltUVRYSDFYdUhhSVRtRENZKzNGdGNVT3BSTUtqVTFWYlNl?=
 =?utf-8?B?b0h5UXNUdVhDMVB1TWplVUxCT1M2ckwzdi9Xc1FBdTJDdXlUNVVhdGJuNXJr?=
 =?utf-8?B?V2dKSWVFbFRvbjYzYWNXSFdIL1JJMDIxbjhJcFJzSlJYUkpQZW5uZGN4RERy?=
 =?utf-8?B?Y3JiQ0g5TUMvVTNMYjRta1dmbWZWaWdwR2VhOUNsVzdKUHFxZzRZV3lFR2kz?=
 =?utf-8?B?TXF4eVlzVGl2NGZ4WkpsWTU2cXVXd1BaTVJ5YTBWaDg0NlVNdjFISVg5d0Ro?=
 =?utf-8?B?aVZrekwycWhvN0ErSmRhT0lpRnlIcGJVbnZtdlRXTUpURmczNlJsS09SZWwy?=
 =?utf-8?B?Z3ZUd0MvNFpOK20wMkN5WTlqSjBkMEE2ZHkxdzArU2Y3em9jMlFCYk1DU3cx?=
 =?utf-8?B?dmQ2c2xGcUJ4T1NHeHg0aUFmZkZvTWdnNzZBWmNaQTdqdFh1S3VNQWxNemZO?=
 =?utf-8?B?ck9nQWF6S3NDU0VzUHlzTDVVVkl1QnhVSFV4VUdVaVhKYnYwQjkybHFHZmNR?=
 =?utf-8?B?d29uV1NHOG1SZHN1RHRrcktaRnQzMFIreGdSaDNQY2pmTEcvOHFpR01WcFpW?=
 =?utf-8?B?RmlsUnd4NEo1T0g1bXhqbFFQTTRaeXFDbzRxVzd1L2JzU3ZvQ0VwL2xXYVBS?=
 =?utf-8?B?bTdSVkVrU0xjbHBUNUR2cFJxSUYwSHBLL3lWbWxMenNLaTFBWkJhNzRtcWYr?=
 =?utf-8?B?cUdrVUV1cHpGMDNLNjNvdEdEbkliQ1ZJdURHUm01ODNlZVZ2bmtCWEwyc3VM?=
 =?utf-8?B?N0VnWGFuYUh0aDhHU3NTc2NKckZFVmZXU1JFOEJUNEorUnViWFF1MVg3MS9s?=
 =?utf-8?B?TFBVUEhtVVBZZ3FjbzdMUmdBc0JDWkFWNW04TzMwVCtRUXVpSG9iQWxkREhh?=
 =?utf-8?B?UzBtazdwYWRpWTNDTU4xdExyalBEb3h5ck95NlJnb3RKTVBSOHhOYnZrb0p0?=
 =?utf-8?B?cjFNTnhSZTVrd25wQXVjUFhZRy9Td3NzbVZlblF0TUFPY2lnN1ZIRjRZTVlj?=
 =?utf-8?B?MFJhVXRjVmlsTUIrYXZ5L0JxV3ovSWNDYStSL2hXY2pObmtFZTNKeDlIV0Ju?=
 =?utf-8?B?Yk5LdENpNDZDQ2N5M1BZcFZMcy8vanR4VjByaXN3YWJnVFFXZ0YwUTJqK0Qx?=
 =?utf-8?B?cFhwa1BBS1Rkc29kbDAwVERkMWxRM0JHWldJUTJUUGpTMU1qdGlyYkpWL3RE?=
 =?utf-8?B?ZUlGT1BxV0xKT2J3OWJiUE9IS0ZyWnN6bGpJKzRXS1h0aDFhd0dHRXFFNlJB?=
 =?utf-8?Q?EtRRtoGK/foKl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFZidlB0eHVJdXBDbkNxY3RBZTVCY2N0Q1Exa09jMkxlVFFnV2dXQnF4M3pB?=
 =?utf-8?B?ZVVhN09Pb29HZ2s2eGtZamJhNUtjNG1QK01hWGQ5ZGRTVVcwQ28vbTgzbEpY?=
 =?utf-8?B?VVYzbCtTN3g3QXh1T1NMelNDTW14M09uM1MyK0JlNG5DVElIbXJhRTNWdjBN?=
 =?utf-8?B?RDJ0eFAvWHAxbUpsQThlL2cybWxIdUJ0WU5PNHI3UlhTZHB0QXArTTNMZHRt?=
 =?utf-8?B?bkFRT1BEZVovK3NvY2dzZjlZcEtrTGVpWmpzY0hCaHc5ajlLTW9jaFJkYzFS?=
 =?utf-8?B?Nk52V2JVZVpZYkJzWW1WUW1uWTl4M05td3o3VWtoa2lyd2dkaUFRVU01MmJv?=
 =?utf-8?B?WlAyUmJvUjR2UVVLekc5Sk5uOTdnclFLU3FudVNrY1FmNjRyR3pJT1NJZUs4?=
 =?utf-8?B?Y3RDdU9Sd3B1WHRkQ05BVEpNOWp2NUdpRU16VFp5ZWZ3RHMxeGZRZEsxcndD?=
 =?utf-8?B?bXJnSlFFQzdkS0VLUEx3NkRRNTZWVXNxNEpWZkphTzNRZTVZeU5Wa09DcUda?=
 =?utf-8?B?Q3R3aEkzdXZPem1BMXd3eDhoTmRUVjRJdmJtWEZhZGsyR0xDK0ZpOFh4WlFq?=
 =?utf-8?B?cCs5S2s2a09pY0JwUVJuTnc2UjNxUGdrb2tMUUxidVdGSFJPUHRQb25VcThu?=
 =?utf-8?B?eFhUTEtsYXBQanFyMU8wcG54N3laSzUwbSsxTGVjbWh5b3o2QU5uVFJCeG9X?=
 =?utf-8?B?T3NFTWNTMjYrQTZhSHlzVzdtMHJGZHNXeFljZUx2YnA1TzhGSHBDU3N6SFQz?=
 =?utf-8?B?YW1sWU56TEVndmR3QXllQjNOSERNdmhZMkp4SEc1djgzelBBdUdQSlVvR0xi?=
 =?utf-8?B?ODNRWXo3TjZncVRqUDJDeVFGUW0vdEFyVWtwZEJYakd2NzY2bW1CT0pzNG5E?=
 =?utf-8?B?U2huZmc0cjNENDhrMGhnd1drZTk5OHZFTG5ldlVidi9oKzk3NG1ydXRXM2cw?=
 =?utf-8?B?c0kxdWhnYzBmdE5ja3FONFkxMlp2QUI5LzN0TTdtekZzbU1hQTNhYzQzNHBp?=
 =?utf-8?B?OVdCUHB2T0kvaDV5SURGQkpMZ1czSzlad2NXNHdEbTBFSmFXcHpvb3hVQXk0?=
 =?utf-8?B?N2NYOGVnNG1MejZXRWNHMGM1UjF0TWtsWEFRWllyYnc1M1RpU2tzM0lqYm5P?=
 =?utf-8?B?TTkyaGxsVjA0bi9FMDh3Z2c2TVJzd3FoZXA0VUpyN2pOV3dkaHZVZlcrOHN6?=
 =?utf-8?B?ZHZmb3RmRVlVVE9sQnByTjl4TmFWZFVmWnZYYm5nNDVIWWZ3eGtKOXBmczlV?=
 =?utf-8?B?S3lmSUt0N3dzMXJPNndXcVhGQjRnaDVnTnpDenQ1NjR1d0dLWGNOMDdnRjFQ?=
 =?utf-8?B?RmFoQ1dvK3plSWNVNUFIU1R3ZVpKTW5CaWFGdUJDcEZSV1ZteXhkYm5INE5L?=
 =?utf-8?B?eHV1K3l0OEhIVVJNRlZrT2tPSG5iV0lwU1lKQWdQeHdKNi9WSncxZXRSQVpB?=
 =?utf-8?B?VHhsWTJIaVNqTFRDcFFuWFB0SWFQTzgrUHdhb0Q3Lzk3MDBmOWswWGtaOXB3?=
 =?utf-8?B?bFlCMWNsZXl1bkE5c1BuUWkzSU92SEtiM0JlS2E4RWZTZi9oemVoQ2NHQ0NS?=
 =?utf-8?B?d2dUYUpoMmkySFhZL08wMzFTTWxJZHFPL0o2elZKVDc2blp6SndCODVVNEpo?=
 =?utf-8?B?enVDbW5WWmlTQ1NYcWo4VEtQMXkrQ2JQQktNMlkrMG1kV2lXYUtEdXo5dm53?=
 =?utf-8?B?R2JlY0hINm12SnkzUGJRYlYxR2RWNTl2RkhvVndNTEJheHJ4N215ZmZtQXVQ?=
 =?utf-8?B?RjlycGdkN1pvaWFzOXFjeGJ2eDJ4NUxSQlNnQU5xUGlwVkEzcmo2bTk0QVdD?=
 =?utf-8?B?b254UTE3dGxqTG5zM2ZwQ3RkZFI4MzFoQnBZZk0xTlFWeWtFYWFybUxuY1la?=
 =?utf-8?B?STVtOWkzWDBFVHplckdxYlViVHpwZUJpcUtkazhNSUgxbCtreTFkT21UaFJ2?=
 =?utf-8?B?TW9TVnNPVnpzcjR1NlhwWEEwcE9hUWhQQnkrL1pSMGd0bEFSS09ZS1A3dlFV?=
 =?utf-8?B?ejY4UEl6K1MxR3Zzbm15WHpOaWhlUnZvL092NFJzN3JxU0wwdE5zbVY2eTl1?=
 =?utf-8?B?R2xkT2hBTWp2Q0Nqa1JzaU9scGZzaERWZSswL0pxVFB2bmR0NWEvUkhHYmMr?=
 =?utf-8?Q?UArG9Y6FuySEOFDs1uWoQCnXS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86abee17-db6f-4fc4-a948-08dd1f23e213
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 05:21:53.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pghLGfp/iMSA3W7lcVZSgj6f9fVlP4MkuVT1HwyfGugMrwfN4d1OO3due8EUFfMxPmM1qrdk8njoo/jButjafQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956



On 12/17/2024 4:40 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:40PM +0530, Nikunj A Dadhania wrote:
>> When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
>> is set, the kernel complains with the below firmware bug:
>>
>> [Firmware Bug]: TSC doesn't count with P0 frequency!
> 
> This happens in a normal guest too:
> 
> [    0.000000] [Firmware Bug]: TSC doesn't count with P0 frequency!
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
> ...
> [    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 2023.11-8 02/21/2024
> ...
> 
> If anything, this should check X86_FEATURE_HYPERVISOR but this is just a silly
> warning so you don't really need to do anything about it.

In that case, let me drop this patch.

Regards,
Nikunj
 


