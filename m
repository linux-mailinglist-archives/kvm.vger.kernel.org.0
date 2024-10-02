Return-Path: <kvm+bounces-27820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6010098E333
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 20:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFC1AB242FE
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 18:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1418215F51;
	Wed,  2 Oct 2024 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LAZEOizG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAEE1D07B0;
	Wed,  2 Oct 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727895142; cv=fail; b=cIP1ra9pq6LO99hfR2XIRPoJRfwEBc/hhuaUJUoqVaD+vHdzlJzNthqWDFfJGHDp4+Bygs+V0IcBWjJxCos6JXIu8DNSVFglx3+pYLnvNd30p+oE1k6JsTi1OScyJ0oLcFyBTFWduo33GL+14Dbv9SR4/dT2E3FyixRz45xbvD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727895142; c=relaxed/simple;
	bh=yNWBw3iDn2HGagSK0PhTqSKo+liuyeiokjahbSrmTQ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qd8LZgUC0WqNozID1eBcx0kQQrm9K/AQutQ8AaL2dBZhvjSS5RBNVH3dVDW//SGxsx2o4wV5RvtJ36d6N1P8dwVQ/VqsiVyKHOZS/KZm1GoF6FElS8kYEgAzRHbjJikDHjOicAaxQfHfTLUiFTscAi7OpMNKqsdiHHoksNXqjyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LAZEOizG; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xE5hJz4ik91RbaeGqXFmsyPqveMF0i94VSfOE1HJUASOoCEifmw8PgJuHtjtGDsCLtCjQRX8cJCdUSK38JDsNwNDKoOkSZSU2woXqLUo/kJLGUpGp8ikUdcfihUvgMP7BXMIgz0Za4ey9I4kR3KNEP3KC6duOcVD/N+MAtnwixV9RFqyKzNRm4/4Q+HDXAA63LJ0VGzcd12zlPu/LfJA6DzWvoIUmeKtMnD0UE2DnO7a4vjD7fcBzC2G5WNRPAFf02aAfZvTf2+oBgQeSM3qUNlRHmgR0YOh5llj8/Yxiq1e2vcy0sjvZZHIghAfGR1HhmAR6QZhWKpXnAb4VHf9Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sSxoQu8vijwyoyT/0XDR5Q2BQIjiLOohKwgtDDwqA0=;
 b=wgY3VYQKy0QuC8LRgnIBer+27JbpHH/Kp/SnzU/wRATuO1EsFsCn7D8zAkoM6FY1ilwjux35gYpDHoRmaoPuoFZsFkjJO8T/5+SoSjFSVRFj5fdSGgZNTtrJRcOQhMlNy7O2+cqxkmDW7J27R+9c1vc8wkkhZMccsc4uSMCTg+B18w4gCXeGOWkekZK4Cd5qCEiDezxR7+GooCO8LWtWqVBnvVlSfXqQoLJmOTR2fPK558EEGyqFYnmcnkh38IDExqJtarxLf6AA/Om+g9V6pyEN/EWicpFCq+2hCZXUjQEK1LRIlJSwblIfL43Ectb7wTKbiQgIkFvV4lzZwzXqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sSxoQu8vijwyoyT/0XDR5Q2BQIjiLOohKwgtDDwqA0=;
 b=LAZEOizGg7n112SQ43DM1aS2+0r9w/ASUWEarXW9hcEgz0DW8xAHjDXLIemTqYUsk3P2FoS2RQ36x4B589dghZOZpnraRMDJqFy8BRPWhSEnkA4xKqWNaj0eE7yX4RSSzUIwrJuMc0FTeBUFlLyUDQ1/my84caGfFsBl5o6jNvE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8376.namprd12.prod.outlook.com (2603:10b6:208:40b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 18:52:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 18:52:17 +0000
Message-ID: <0ba6b536-3936-9a49-ccd2-58af08640985@amd.com>
Date: Wed, 2 Oct 2024 13:52:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/3] crypto: ccp: New bit-field definitions for
 SNP_PLATFORM_STATUS command
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <afd7d4c5192109519ada49885e9585a1699820bc.1726602374.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <afd7d4c5192109519ada49885e9585a1699820bc.1726602374.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0033.namprd05.prod.outlook.com
 (2603:10b6:803:40::46) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8376:EE_
X-MS-Office365-Filtering-Correlation-Id: 05fa139a-8ba1-413f-dd42-08dce313569b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0h0Q3locUluczcvNGxjOW9mTkw1d01vbUZ4c2t4VmJ2c1dHeFQ5Y3g4a0pu?=
 =?utf-8?B?bDdEZmQ5c3JVaTR2SlQ1R2s2U0o1RWxXYkFWbVduRWV3MjdZM05mdDRmSEox?=
 =?utf-8?B?YTBwQmk3SXlYT01qa2ZoOXNTaFdDUVg4dnRTdmZ2M1MyOFJBeDVFL0NBNFVP?=
 =?utf-8?B?bGVsMUpSSkh6dkNVdEp2Y0JNbEM3WFQyNGlPNVo5bXBOcjdxTXhnQSsvckE0?=
 =?utf-8?B?RDRaOVNxM1FXaExMdVFFU3kwbExleTR6T211RzlEZTBFSUNuMXU1OUtQU3F2?=
 =?utf-8?B?QXBoM1pieXBFR3VJUHVoUkFrV0d6bjR2KzNpVnlPQzJhdHp6UjA1TEQ4MWd4?=
 =?utf-8?B?ZDBFUGVMRm5XSG9wYUZvUS9JaFpRUFRDUFU3bmp5WjlRdzJSMTZXOTNJdzRp?=
 =?utf-8?B?bU83eDJHcWFNWldRRUN5bk5kTEUxUkFWTXY2bEk4dU1oc09NOHVLVS9iODRm?=
 =?utf-8?B?Zy8rQmlaOUV3amNsN3Y2TlFTUkpRMGcreVlqZktYQlN4NWlFUmxKdngxYzJW?=
 =?utf-8?B?NG1lc1lqaWlySHZ5dWNlSXFVcUU0NGdyV2NHWGZmc2swS2Rtbmp4Q2VmdmZv?=
 =?utf-8?B?dFcxbXJKYkt6ZkE1RHFzTk9iM2dsWXo5WmVSOWR4QkRpMjgwUjJnbW5LZ0JN?=
 =?utf-8?B?NlhmN1JuK2hkM1VSWnkwVXJrNXA4YzhZeEJVd2NuYzZyOWNpajZ6RWFIR1Nl?=
 =?utf-8?B?MHRURi9jdnhjREFVb0FMenV5enphbGRhT2Y5MU1nWFVydG9YM3pzSmJuNzY0?=
 =?utf-8?B?N3VwZXptVFllR1lTRk9Pb3N4ZzArdERrMUdMcjBCVnIvRU1HaHV4UVYzaUVU?=
 =?utf-8?B?OUcwMjVMaVhQOEZDdXRlYy8zSTV3Z1Z5ZnpQK3pxeTk5aHRWRUtreVBJcEFi?=
 =?utf-8?B?ZUFEZHlxMFRxZUNXVnZ3VkJVd3J1alpiQjdFYUhpdktWRlg4eTh1UXl2V3hU?=
 =?utf-8?B?bUsyRkJiT1M3U0RlZVhvRi9PN25MbmZJQXpvK2NIRzZ5WWlQNVp1U3NDci9m?=
 =?utf-8?B?SHVQWUpQZ01YMEczMERqb0EyeHN6cFh1R00ra1lkSWRuUDB3RW9sZVZ2Z1pQ?=
 =?utf-8?B?K1gvdDlWZ2lSamVKTzVwZ055YTZweGcvd1o3MUpQSmI1M1A0T1hMdGlQWFVX?=
 =?utf-8?B?RzhiQlZuNEt3eXU3K01JTDM0M1Nxc0sreGw3c2hzQUNCdG5HRFBKTXBIUFdT?=
 =?utf-8?B?TGdxU3JmeURNZlZUeE91RnE4bC9VUlV4MTBIWkFkZHhwM28yTjlpMnZYczds?=
 =?utf-8?B?b3ZQV29OY3dTdEhNRU5LK1JaMy83c0NmNXNYMzN3TFJpcGFDQnF2RkcvZmlx?=
 =?utf-8?B?QW5EejcvQzhnQnlQYzE0UEUrM0ZWZm8yelk3elI4ZWkzN1UvaDE4akh2MDJ0?=
 =?utf-8?B?RkRTeXpaS0NNZkEvNFdUTUNkU3VZa1JHWkRFSVpKNFByY3lzeCs0NWpqZXFi?=
 =?utf-8?B?ay9XQkxuYUFpaTRieTZzRExyeHBYb0o0TmZmYjgzQW1HRkNPQXNGcjRVUHQw?=
 =?utf-8?B?WC9TNUg4elA0RDRXcHJOY2VKL3MrNjNtSmt6YWM1T1ZKTGZlSzA1VHJpbGlH?=
 =?utf-8?B?Qm80Q3l0SGdsMzBrM3NsS2dxQVR1QWpoTDRlVHdLYnNlYzBPaDdMK3Q1dU1u?=
 =?utf-8?B?UnZFUEdpSlFrYjB3WTBQNGpXVy81OE9qZWxXZ3Ftdktpc2NWMlVya010UGll?=
 =?utf-8?B?SnJMZy9rNkdWajBCMzVlQ3N5elFGRkpZTEhvelJLRVNDNHllcys4N0RBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGN3RUJLT2RlblU2RGlFRWdTNjRtR3d6OWw4akpaemRHWUpLZ0p6WXhaa2lV?=
 =?utf-8?B?V0kvWTVUZ1BTank0V0pCc2VxK1FGZWpYcFJWQ0ZVUmE4ZHlRYk9hTGJrOUlT?=
 =?utf-8?B?Mkc4b0w3OHNxdnhnazhHUS9UQ2JFb3dEVHI0VmxFWXNUQXNsa1U5QUpxa3Jz?=
 =?utf-8?B?VERKY2pGd3JZM1E4aERiVU1yd3ExdmNGdE8zRXV0VkdoZDdXem5TeTdhRFVE?=
 =?utf-8?B?NUN3ZGF3aFRBMjArSk1Ub3lkdGlpVFBScDBwYldKRDNrQ1hmaVRSRUhqdndF?=
 =?utf-8?B?YWlMc1kzU0h3cWUvM2ZWTC9BK1B2VWlURHdnbHo2alNSYjFPWHdiZnEvSTNj?=
 =?utf-8?B?RCt0U3d4ZU9BS0wxTkhKVnBCQ2c3aFQ1cnVsNnp6cmFJSzNhMnBOOGhNb3FR?=
 =?utf-8?B?Y0ovZUk3UHMwMjdlejRKYmZsemZrMk55ZHFsU2VHS3hYWE0wUVlDL0g3a2NM?=
 =?utf-8?B?cjNNdk82UlllSEdXaEFHYlY5aW5PR0E0Q0dTSEZ4dEo2WTJWUHlNTk0wS2hG?=
 =?utf-8?B?U0hjYW1Gdzg3VnZrRG9uTVR1T2dmTGI5TGhhR2hTUk1DY0hnMkZXdmY4YXVE?=
 =?utf-8?B?ZlZheVJoaEtGMlhycEVka0YrVXRjZjdiK0NqRDJycUhpUDRWMnpDR0o5cEZx?=
 =?utf-8?B?Y0Y2VUxRakNDbUpGWjZTbnJVcFpNdVNhWVZ4Vks1M3M4NUIvdEhUeTRaZ1cw?=
 =?utf-8?B?OTNhOW5adTQ0Ui9sNHVwRUJiYzJnUmd0MnZHeXJodnY2OE9oRGhTUnQ1K0VW?=
 =?utf-8?B?QnR5eW5ZcjlUNURqNUo2d0lsZmpSZlJFS1FCTkVEQUhXdkZXTmdteFRtenhF?=
 =?utf-8?B?M29tOVdEQ0lvR2Vja0plTWpYZlZNazRRMkhvL1N3QWhnZko2QmdScTJpVGEz?=
 =?utf-8?B?bDZBb0ZiMWVkRUJ6eUQ2SGFGbWt1WlQyQnVrNzMzYUNya2ZpTC9obVNMcllV?=
 =?utf-8?B?ZC9aYkdienhmYWlLcStvT2hWQ2YzQUJKbmtqK1J1dktkczF4WHJvNkdHSUJr?=
 =?utf-8?B?cTVzUTZQVmM4QnhWWXIwMExvNk9jZjVJVnBrTmI2NjlxeEI0QmF4aDhTUTVH?=
 =?utf-8?B?MU9sNGJZSG12dFducHUwaVhiVFBNemVHdTJnMmMxSmp2WFF0MDJZZ3NNUWlY?=
 =?utf-8?B?dEI1VWxHYUJURHFVMS9qbUpwRlhYMlVsVmg2eDl3djBseTJOSEpJNXVobmM5?=
 =?utf-8?B?VFBib3p0SEhwOXdnNHk4VW5QYVhuTVo5Qm4xbmZnRmdPcVlrT0hxc0lPd3kr?=
 =?utf-8?B?MGxMckx6ZHc1cnVJRXlsVGpWUXlyS2NKdzI5Y1RRZ1F3Yjkrc2pSVWhaOTRE?=
 =?utf-8?B?ZjlxN0RNYi9lWXFGcTNuOStDZHAzS1BRSjN1TjdDZFZ0T2h4N1VHMnpyM3NK?=
 =?utf-8?B?ZWtoK0p6VVlkV0JYNmtKeEtBWjBlRWlhUHVlaHkyTDczaUl2UExsT2pYTTdr?=
 =?utf-8?B?SmRtTUxRcnJJOWtNbURTemtTVTlqbC9pRHNtbE1HdWxxUXlncDFaRENFSkJj?=
 =?utf-8?B?eGZwb2FCd2IwcnAwS3l6ZmNwdUtXT2h1NG4yY1NQQllUWnVyMmszc2R5d2Vm?=
 =?utf-8?B?YkNpTGZkcHdKcEE4N2pjb2t5aCtLUk5GUGhEaXdwYVBOM2pvdm16RU1UZDZJ?=
 =?utf-8?B?UldZNnpyc0RuZHhlTWcxakZGUWZRRVl5RjJ0Kzh3d3JGcHBLSG5QdmcxRUQ1?=
 =?utf-8?B?RHk5c3BaTnlteGlqTm5XdkJiZXE5YkoxQ0NMd3JvTnFWZDRUN0VNS2JHcktt?=
 =?utf-8?B?RGhlOGRVRmNTMFBSQWYySzNMMzhuVXVibkVmNGlRZ3hMaUZOOEdPdzFwUmIz?=
 =?utf-8?B?OU9IYjJuMXBkOUxxclZOa2lTVkNBYzhIaUNRTWw2ekk5bDJEd2JYdFJad0Zt?=
 =?utf-8?B?a1BNSXBoUVdHOHZPUWxZS2ZWL0I1U1NMT2Q0TXJBS1hIRHNhaTVjc3JaOXJr?=
 =?utf-8?B?VXZxcy9kbWJUa0FZT3R3T21XU3hDZFRzV052aURuMzF1RDNFTG5VZUJoSTV3?=
 =?utf-8?B?bmJzdEpKL2VLSFZUUjNvV1M0azB0djZYNDhKOUJmeGtFWStTRlVNWWhLVlQz?=
 =?utf-8?B?V0dXaERqS2ZCSVNxc0hQdjIzWWQrNTZPQk55amdiMnNEKzg0S1FVRzJUcHhh?=
 =?utf-8?Q?UYagBCA7f34p9NwuXYK7dN+8x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05fa139a-8ba1-413f-dd42-08dce313569b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 18:52:17.8271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rERwfqMeOsFQRP1KDFCWxEJN1GzaKlVyCYeDbrxTsapVyUELFgpv9XNdc8mAqccjRditrqDszqLQdv3H09VmXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8376

On 9/17/24 15:16, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Define new bit-field definitions returned by SNP_PLATFORM_STATUS command
> such as new capabilities like SNP_FEATURE_INFO command availability,
> ciphertext hiding enabled and capability.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  include/uapi/linux/psp-sev.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 832c15d9155b..dd7298b67b37 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -178,6 +178,10 @@ struct sev_user_data_get_id2 {
>   * @mask_chip_id: whether chip id is present in attestation reports or not
>   * @mask_chip_key: whether attestation reports are signed or not
>   * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
> + * @feature_info: whether SNP_FEATURE_INFO command is available
> + * @rapl_dis: whether RAPL is disabled
> + * @ciphertext_hiding_cap: whether platform has ciphertext hiding capability
> + * @ciphertext_hiding_en: whether ciphertext hiding is enabled
>   * @rsvd1: reserved
>   * @guest_count: the number of guest currently managed by the firmware
>   * @current_tcb_version: current TCB version
> @@ -193,7 +197,11 @@ struct sev_user_data_snp_status {
>  	__u32 mask_chip_id:1;		/* Out */
>  	__u32 mask_chip_key:1;		/* Out */
>  	__u32 vlek_en:1;		/* Out */
> -	__u32 rsvd1:29;
> +	__u32 feature_info:1;		/* Out */
> +	__u32 rapl_dis:1;		/* Out */
> +	__u32 ciphertext_hiding_cap:1;	/* Out */
> +	__u32 ciphertext_hiding_en:1;	/* Out */
> +	__u32 rsvd1:25;
>  	__u32 guest_count;		/* Out */
>  	__u64 current_tcb_version;	/* Out */
>  	__u64 reported_tcb_version;	/* Out */

