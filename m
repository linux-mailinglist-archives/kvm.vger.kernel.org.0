Return-Path: <kvm+bounces-34535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30501A00C7E
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 18:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 579377A1564
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 17:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9A01FA851;
	Fri,  3 Jan 2025 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0yElGZ8w"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A91FBC83;
	Fri,  3 Jan 2025 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735923636; cv=fail; b=MD+aBrt4YkN8pTEEuJ6HZgAP+W9vIY5r02XXyURB7F99GpCkAoyYctCwiL+KnjSvO/keoFg8MInO4k0tSLu8em2ihzovdxaK+vZKqteYe9w1cVg03a5/zvbgcaOynD2H5trByfy4JXQ3omAQJ7TJXrEhOPI9fEqSF4Y4Epyapxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735923636; c=relaxed/simple;
	bh=0OeI2BbXilicI8fYgEdHFDKduMWtgUUCpHNO954oG3s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XnUSXjAZgwB3qxrG+xPzYWhex5tHiULqL0MaIEb5aTNhn+RhcIrRvT1W08ZxBKQBkwI4G3Dh9mTSDJkKEPNTSa7S8uSAdVygSZGaCqTY+cOmNgc+UPK9cctJBAMPgslGp1SqBiHvZyN4sVwvKmpxX1DeRQjfO3F9LTDOhJxGewo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0yElGZ8w; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVr5eSItx4hZwLq2fMIUe6F7wpSn9EMVjnVdg2/L2gL8IpaSZx1smG3lcpdT9dkLzNRCDgdhJyngTzIEmJ2XRRSZg2swJBuGebFY/W3L8Ols/enXrl3arYt8fen/0tNmxVy+dcZ8OMA83KhsfWg/Ph0UGM4tmbe1aF/2OaX0JBTuLU/MO1HFQNVSd54hjJXXLDQGu9cfBPFOeH3r6UklmAVIW61eNiDhce1+rA2rHEtLD/Bg6H47kdzv1AbmCHQmM1CC+qZRPd6h6xbY+mEEWxuRSo2SbpdOp2LjdlEc9f/wJ78l39Ubu5kTfh+E+HuCpfeU+POILQtftYxgy6cFaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWuoIRpBZpU5IIaDn6FdV/3TS75MBK8RlX8V+hNAsj0=;
 b=k9d/gcaX6Jkw+muPXp1apKtV6SLZMymwG1EqrgNa593bPwmmTbg/AHqEyZfytU57O8l4PXNo2KYXYUAvFHtMt8miGccEsTvPotO3awUd3I+xFAwHgpu+gmMsDUDfdohN/Fd4t0/eWDiJq853A5dDKy9Ukne3knXLM//vXantBq3chbdlAqISvyHIOaRmXa42KuKZvko/LZsu4r3N7GuBZV8hb0qBsl1OFIQZr521PtULahM6fpOxsw3PwWyyAWnzEUK1kygGGRZ9Cw2MNgFbEvlIRsMeiF07+ZsHp5BqBlKudKhgzu4rebnd7Wq+Sv3nPfdvKcXJFJv6ezVZTsFrgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWuoIRpBZpU5IIaDn6FdV/3TS75MBK8RlX8V+hNAsj0=;
 b=0yElGZ8wPtjHRIQFvZTev8sMuMP83qh/aYHTjCQtO0kD7c82S2LHSV1lVQZvQartW4FBqTRCVkwOkZVj1KzXn1B+nH4MRAm3+kklnDiT7n/Um52KZKQvKYV8sGnjSoOO3r1tOy7xV3+HiPbnv+N0qIhBHbJKo6Kgj8zmXWhQSBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9429.namprd12.prod.outlook.com (2603:10b6:610:1c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 17:00:26 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 17:00:26 +0000
Message-ID: <63af2db5-9787-5165-ee5e-9bb825752f6a@amd.com>
Date: Fri, 3 Jan 2025 11:00:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/9] crypto: ccp: Reset TMR size at SNP Shutdown
Content-Language: en-US
To: Alexey Kardashevskiy <aik@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>,
 seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <3169b517645a1dea2926f71bcd1ad6ad447531af.1734392473.git.ashish.kalra@amd.com>
 <433dc629-a84b-470a-8c2f-9bb531a23185@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <433dc629-a84b-470a-8c2f-9bb531a23185@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9429:EE_
X-MS-Office365-Filtering-Correlation-Id: bc93bf87-c869-42d5-4a5e-08dd2c181ecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0VnT0ozZERjSWdGOFFoYU45dzZaUnhHS1ArUUo0WEQrcW1hdHJGMTBxcTlI?=
 =?utf-8?B?VG50ZDFMbXlpR0JFa1ByVWxsOWFYcmFnR1BNNHlGVUpYaVhMUHBydnNtMUxW?=
 =?utf-8?B?bk56dDd6aW1Tb1pJVVBVbU9NNUZvR2FEbUNia2M2aXQ2c01BQlA0a0svd2pk?=
 =?utf-8?B?RDZhZ24yRko1NGRHWjVMa0NhdUd0Ulp0SnFUK2EyMkloZWUvNHdUN0g0c3lN?=
 =?utf-8?B?RjVJeGZmN3BLWCtCQm5zTUxyaTJsd1c5bFdoVXc5dEhRK2NUOFlpS1A4Nm9h?=
 =?utf-8?B?YUVScmVISlA5UjZuNGVNd1E5VHNENEV4NDVLeXVJdTJ4U3BJOFh3enRVdjhU?=
 =?utf-8?B?WUI3cnFpZ3RrL05nUDRxVlMxOFcxMStOS21ZU0MwK2VOTlNDdFJlam1xZ1A0?=
 =?utf-8?B?YkhtZ0QyQXlxQ0RFaFA1K25PMFdCbGJ6Y0pUckY0ZlZzZVNQWnJVU1RxNjRX?=
 =?utf-8?B?THU5T3RrQjJ2bEZnazViTkpZSzhPQU1qdDFiemt2OXJKQWNPNUFzbnlkKytG?=
 =?utf-8?B?d3poY2VDOW9yQ3VDOGtnaUJHdWVScjNPUyt0R0s5aERrdnNCL05rcyt2ZThK?=
 =?utf-8?B?a0c1Q3RnTXBqYU8zdGJaSy9mWndIQ05yY1dXNnp0Y1JaWm1hNkV6NWdxZDMv?=
 =?utf-8?B?b0JZVHdFb0FLRGc1aTErdVhGME4yTG5CTk1HNU9yNVczWUczUXBHbklXNVVw?=
 =?utf-8?B?VkJqdnZ5NE9NKzB3YjN6Q0ZNeC9uL2F1UVBCRmkrOXhRaHExOHdZWENaUmFY?=
 =?utf-8?B?V3VzTVZpWEs4NGlXekhQbWdPbjhSZm5VRkVyUGZlYzd1WjdMSkZBYWFFQlFq?=
 =?utf-8?B?dFZZdUp6K1BuNWZVcHlCNFU5S0tyTW5QeDVwNUo1S09NUWhTTTJIOGdBZ2pI?=
 =?utf-8?B?c2xhbjZ0Q0dHajBrazZQNzJqeUMyQU8zZHNiN3Q1T1dwUllFbExYOVpCUlpt?=
 =?utf-8?B?MmxhaEpLUVJ0T1pFSCthWkFhRUhzQVMrZmRDQXNKQ1FSaEFlaFJ5dmdyVGdD?=
 =?utf-8?B?YmJBcVNIYWFtYVVhYjRtcU5TZjlXd29meGhIS0xpcGFSTGp4Rzk5MDNBUEox?=
 =?utf-8?B?YmlmOUo3aW55cTNONjJ2L2xXaS80VXpVWnE2bXpFSEw1ZGhLUVJGNGZWVTMy?=
 =?utf-8?B?YTFiZkFxVDJDaktwT3ZiWkdweE9WNVdLUldFR1Y1K09FWnlTRmxhNmp1RlEx?=
 =?utf-8?B?VW1zSmVhVzYvU015MEsxbzJwRzd4TVV1VDE3dWROWEhaUFZEK2JQRVpRWlFD?=
 =?utf-8?B?RGcrVXliSWxtREhzdk5TODZSRTdrRUxpamhIbmk1Sk9JRk9BUEJwNk4yc3Q1?=
 =?utf-8?B?UXh1VVlKK0tLVVN6cktoaUpsSzd0bjFQejFYT2VXY2hlanZhdDJFUlpnZkR3?=
 =?utf-8?B?dWRqc1pLbzZKbDk2dDE3NjRCSWRLRzZiS1dyM000SmZKclpSZmVIbTdYSWhs?=
 =?utf-8?B?QW5HRE1RdGxMbEk5MFlLWGhvK2JFM2ZKa1dsQlljZHFOTjYvMzFIc1pjSDNm?=
 =?utf-8?B?S0lmQkxnNmx2R0JqNWF6b3UxS1k0RkpiaWdxdUJUM1ZnWDBqMDVNM0ZCeTZl?=
 =?utf-8?B?VkZtMUdJVkhKVGk5c1AyZHBEVEVpM0tLSWc4TXlLU0JlWkh0bnBtV0Jpb3dh?=
 =?utf-8?B?eGpVQ1JNRUkrNjhVY1pMUUtHazNnSVIrbFdPR242WEpPNDhUWjlkMEwzT0lW?=
 =?utf-8?B?Tkc5MmlUWEFRbDlLc0dGRExscDEzeGNuekRTY1RkNTY1a1NYd3ArTVl3Uklo?=
 =?utf-8?B?V2VDS01ENDZsdzVDZXE2OVJSdjZlcUg4K0w2dWx4VXV3UHhHM2dtWjllNG90?=
 =?utf-8?B?NTFFZ1NqOHZncStML0dEQXZ3QUp3VUdZanZUQmU0aVA3ekZVZmF0TzFjY3pm?=
 =?utf-8?B?YWVNNDU2Q0hmUFNmL1pLR1U4amo3WHlVb3liZUMwRnIyUmhsOFYvSVJ6dWRQ?=
 =?utf-8?Q?6xdmhFRdzok=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVRRSlFaK1JKd1BsY0gvbFRIVFF4YjZpeXNWMTUxUXpWQmU1eHdHRnJ5Szgx?=
 =?utf-8?B?YkMrSXUwTmxxeE5UamtDY1ByQ3NEazd4ODVrL3pieG15eTczcWFWTDJQM29x?=
 =?utf-8?B?Z05YdnFoMUVBTEt0T1J2d2N0UE9lNEQxZjRsQlA0ZnU1V0JRcTN3VVAzYWph?=
 =?utf-8?B?dHRFTDBhUCs4RTlCTmYvWSt0MURqQjN0M3BQSGRmMG5YY1l6L25DN3hWdzYv?=
 =?utf-8?B?TEhrVm5rLzR6MnU1L2hqYU01SjhmUk0xdWNtYkUyTEJyVGVXZjkxUmVTb001?=
 =?utf-8?B?clM2Wk5KYytwYWpmQlJvMC9HUmZmV2J4NlJpVk02bFJLZjlicHlVNXhXWlFo?=
 =?utf-8?B?Rmw4TXFjTXV5cGkxVE1rMHcwZDVSMDlnanRNaXZHd0lmT0lkcVhvMjZQc29l?=
 =?utf-8?B?dkJJRnQ1RVZKeTRFMzdpQXdtQWVTZFpCTUlwbEFuWWlqN0JHTUFKQUpkZUZT?=
 =?utf-8?B?OGFGcmppd1QyUGJxdE56TytpSWUrSGdvd21DWmNEcXJhTHFVa1ZPdlpRNDBT?=
 =?utf-8?B?M2pGeCs3QU5KSVVZT3hYeGw4ODZSSncrRkJSUkZnUnBwNkIvOExVUm84WEZj?=
 =?utf-8?B?R2xYemRrSjNOMHRUejVpWGEwT1A0Q0YvckRRTTZON2lMNFdUb01RYVZ2R1Jn?=
 =?utf-8?B?UzdHcGhyVmxXLzRxTG1OQzljaEd2L1VJak81b1VydElZTjZ6cGhHN2UvazZq?=
 =?utf-8?B?YnlkL2VCVWJyRzVQaHhKT2RVRUVWaUE5bmxDNEQya252WDdZRE04SkR0dHZR?=
 =?utf-8?B?OWxZVHp4ZWRnNFUwNGdFUzZPb3N6SnhJdzNWQjZWOXJ4ZDRkR2ZOOTNtREph?=
 =?utf-8?B?aEdFMmQzUGlPS2RmdndSdVpQdUJ4YTRqOFZFNldSUHJiRUVmSDByRkpFK2Z2?=
 =?utf-8?B?eC9OUno0OVZqSlFyWDhHZVVGWlhiTkxrYnlqa2k3bk9HcnJBYTF0dUxQUVIx?=
 =?utf-8?B?dmFrcC9yMU1YU29sSWZWd3UyK1FlWFVrREFvRzl6Z0lLY3hoV1dWTkxUQ2p6?=
 =?utf-8?B?ODFCbmRreFVMMnBneGtFUVlQU3ZZQkVmR3NCSllVY3htRkNJcEVmbXJER1Ev?=
 =?utf-8?B?cDMzaWNwTWsvcVEzMEZjWktiVDVVbUpmUHFHMEgyVW9Rbm9XYW5wZ1VXK1B6?=
 =?utf-8?B?ZStYUTRkYkNIWng2RFBPMHptRW5WdU1MWUdvQ2tyRXErdTN2R0Zoc2Zkb0dG?=
 =?utf-8?B?cmg1NjNVc3lyYStSbW9LNE15U0N2UXpqQXVPMG01V29uN09PV1lVc3R5cmxL?=
 =?utf-8?B?TXlsRU5ROWVndnVteW5iNTJXaGhSblM0dFF4VGdHYWRJMlJSaERhaEE2UCtV?=
 =?utf-8?B?b2Z3MHhlSWJhN2VXdUs4ejZTYXNXS09YSWdjQmpOSTRLQVJBZURIdzFEUzVT?=
 =?utf-8?B?R2lYcytJQ0JqN2w2TkNVRWpsak4yOHBMUHdudHU1UEJWRFA1dGpvMVVvVDhT?=
 =?utf-8?B?ampKU0MvR2ticXhoM0hkUFJWcy9ORFpielF2MU8wSEZDNnYyUnNHSWVsUDN6?=
 =?utf-8?B?WlZKNE1adXlSTkwxcjNSYlNSUFd4eEtuQzBLZVFwQjZGT1VFM3BJajRsY0ZN?=
 =?utf-8?B?ZlJnNnM4Mlordm5xYnVmRmVqVzBmTDhrUi91NzV3STB2M3FaOEpFY0Z5Q2x4?=
 =?utf-8?B?c1RGTjA5UTArM3ZvQ0pKYi9JYVZhdEtrcWVCVlBwUW1FRkJIQWl1WTloNXNK?=
 =?utf-8?B?TXRWcUFuR0pWZ0JzalBOalJva2RneFBaVUYwc2QycWpFQW9lbUVvMmUrTVoz?=
 =?utf-8?B?OGI1M20wSFoxRm1SQVltdmhpZExOS3NkY256U1NGRVF2SHAzck04SUxFOWNL?=
 =?utf-8?B?V21uVjhlUUFvakkxcUhKT25xd2pWVFZyNGlDSGRuZGdFbTB2VkVJYnVheGEy?=
 =?utf-8?B?bHRnZU5uZlcyL3JiNE9OeWpMTnpPZExBYmNxbUQ2ZklsUTExTWJuKzRzcVl1?=
 =?utf-8?B?OHludlBjUU56RSsxK1RYSGE3U00wRUFlMWxiMjJqYU1TN3pvMXcrNS9kQnpD?=
 =?utf-8?B?SndJaUpTNHRvbS9hellHT0FRaFFlNzVaaVEwWE9iS3QvZUpIWlIvT2RiaGVr?=
 =?utf-8?B?SUJjQWwwWXpDK0tpSkE4U1pVZGpZUTN6OGhpdTRqcnIzdXgwSTRkUkVPNFR0?=
 =?utf-8?Q?HWd0yCsLgHPRe795NVVXDhlHk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc93bf87-c869-42d5-4a5e-08dd2c181ecb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 17:00:26.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fYvxfn46EL7T7wofiihwFMX2g9vbtiHwYCbhlawKng0NdcCIGleh9K2Ks9CD4nPhw2FwchQSHINV5pfyTPl0zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9429

On 12/27/24 03:07, Alexey Kardashevskiy wrote:
> On 17/12/24 10:58, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
>> ensure that TMR size is reset back to default when SNP is shutdown as
>> SNP initialization and shutdown as part of some SNP ioctls may leave
>> TMR size modified and cause subsequent SEV only initialization to fail.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 0ec2e8191583..9632a9a5c92e 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error,
>> bool panic)
>>       sev->snp_initialized = false;
>>       dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>>   +    /* Reset TMR size back to default */
>> +    sev_es_tmr_size = SEV_TMR_SIZE;
> 
> 
> It is declared as:
> 
> static size_t sev_es_tmr_size = SEV_TMR_SIZE;
> 
> and then re-assigned again in __sev_snp_init_locked() to the same value of
> SNP_TMR_SIZE. When can sev_es_tmr_size become something else than
> SEV_TMR_SIZE? I did grep 10b2c8a67c4b (kvm/next) and 85ef1ac03941
> (AMDESE/snp-host-latest) but could not find it. Stale code may be? Thanks,

When SNP has not been initialized using SNP_INIT(_EX), the TMR size must
be 1MB in size (SEV_TMR_SIZE), but when SNP_INIT_(EX) has been executed,
the TMR must be 2MB (SNP_TMR_SIZE) in size. This series is working towards
removing the initialization of SNP and/or SEV from the CCP initialization
and moving it to KVM, which means that we can have SNP init'd, then
shutdown and then SEV init'd. In this case, the TMR size must be the
SEV_TMR_SIZE value, so it is being reset after an SNP shutdown.

Thanks,
Tom

> 
> 
>> +
>>       return ret;
>>   }
>>   
> 

