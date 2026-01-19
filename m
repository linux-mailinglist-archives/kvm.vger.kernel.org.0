Return-Path: <kvm+bounces-68535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C38D3B705
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 20:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09F9830A2109
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAE83904E8;
	Mon, 19 Jan 2026 19:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="pn25cHRY"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022094.outbound.protection.outlook.com [40.107.209.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB131197E;
	Mon, 19 Jan 2026 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768849938; cv=fail; b=XhPy1IT1rCcM4zI306/x9kuJGv/9ZoHQYRqmXGIYsjqBHKjiH6vfnIVUtacMYHot1hFpoMkglDLYIeIcE/C0FyuECShZU7RLPdMTnasGQrqxB+CnKgmZk8kJlkfwcNl7j08SPyvbe2unJzu60x/JhC7QXFISzvPDz+dNfM/4Y9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768849938; c=relaxed/simple;
	bh=WMtigM6vXxWgNbCiFmTPTTVpjGS8oWkwpkhAlvVJf2k=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BTmJrXzbcZDkfRfNgiliI3Bj3eid9DjM9/9J1qwqhrKQB2DAFpdazMOlYalvNDoiXBZplU9vYXKsGiOBMpyqQIahhQN3bbykgaVu9ad8oK2tmk/U4zQfHbBndcPJTsF0nJfMD22ES6A9CaC7TKxHgZysQTJE6pqfNP+zWrmIza4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=pn25cHRY; arc=fail smtp.client-ip=40.107.209.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7sbo5gUeZ3XNtP73X9BvKkPjbsX76lff39YP1Ek70ls/KkwY7rYv6ttJaPjl4j75KZxAjmxe0M9yVsO7Gvyx0LTUkUYv/c9UmRYO4HTLRc8zIKO3x4jb2B1l/SSTXiLAefgdq3J1G+t78kqHH7BHknBM3xvpIHc+bsfCqaGjAxY6myLTk9fb9bWBHlB7ZgOuh2vcTKySFEnCsVYXvclwFzFX/2JlKcd/VMia74aIR9pnmCgAiHZ8LlxeXC8iXTT+uk2AHblQvrWRkC0tXXQCyjZm657zEm5+g7yBFykbSdHiWDKBHFOJMNVfkVbXjXpkkau1WTu/wI5mXbCNWZi7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/f05MYHYL/H8jDN3ZLVLSsNpcxNWXc3hs81jJyWmqeU=;
 b=E79gaAyp/MT9ZzM9/anxrkm+otUZSajrDh7ylUYgrttiwZijV5QUjUGSj+ztYntxF8qpvaKLdQG6HWoClV4Y/zGw/hRFyaIkJmBH5eiAHqM3M4CHfDkn2cb/Dx67E/fok0NcKNyY8KGb3vvTCagok6g63yKqAKh6AeOF3J23UWNKEJRKSqNUGf3TYSEOrdxOuxuX2NCoRqz0kuB5VtkvUSRdxvOjFelYHR45Mrrk0ZVEMqHeE35xoUki7OPZqCyt2P9FB/UcqpT9et6Klt+kavAqfGECOXY0DsF4TH8luOC6lKCB1QsaOGk0WzS63ofMDfHw8PJljV+QbkRhDJfH5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/f05MYHYL/H8jDN3ZLVLSsNpcxNWXc3hs81jJyWmqeU=;
 b=pn25cHRYhge5E93ObtSRzdqWuSAh3VauNuD26r6N0tdvOsS4Krftbi03BhWbNE26h6leG8By8Wx9FBTzUhJZnbPHisRZXLq4rr4cBo2v5mYz5M7zd5QOkcp4n6vfvO3BSc8eVVcyR4n0IDINlfHSXh+kMuJsjt+BPxtK6IvSRr0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from CO6PR11MB5619.namprd11.prod.outlook.com (2603:10b6:5:358::12)
 by IA0PR11MB8333.namprd11.prod.outlook.com (2603:10b6:208:491::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 19:12:13 +0000
Received: from CO6PR11MB5619.namprd11.prod.outlook.com
 ([fe80::729c:2dc:b1a5:ff6]) by CO6PR11MB5619.namprd11.prod.outlook.com
 ([fe80::729c:2dc:b1a5:ff6%7]) with mapi id 15.20.9520.006; Mon, 19 Jan 2026
 19:12:07 +0000
Message-ID: <b31f7c6e-2807-4662-bcdd-eea2c1e132fa@fortanix.com>
Date: Mon, 19 Jan 2026 20:12:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
From: Jethro Beekman <jethro@fortanix.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
Content-Language: en-US
In-Reply-To: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000701060202080606030008"
X-ClientProxiedBy: AM8P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::11) To CO6PR11MB5619.namprd11.prod.outlook.com
 (2603:10b6:5:358::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5619:EE_|IA0PR11MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e7b9557-6cd5-4518-6b6f-08de578ea2c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rk5rcDZHUVBPOE9NT0lrT0VLTFZscWhBSUxrVWp0eDNtQmRzWnBsNkJjNHdn?=
 =?utf-8?B?ZkVRR1ZjdGxhbmlUZUFMSDlVNjRpOXUvTU13QzNXRFdzaHJiYm1uSnlIUWEw?=
 =?utf-8?B?YndrV0VKcHFZY1NjdlJCSFQ2NW9HUm1iQjZEVFhyUDluT01meC80WUJxdCsr?=
 =?utf-8?B?RlJnRGVlR0tvazVGWVdQV3hxUEpFZ0VCTjJrUVEzb1E2aVd1OWE4NTF6ZlY5?=
 =?utf-8?B?VXZtQVVqS1RBRFR2N2owYVpEcDFqT0k4ZHJnRCt1bUVuUHhKdDhUQ2tBNjE0?=
 =?utf-8?B?U1k0ai9rQy9aUE4zenRnRzdkZm1vL2V6YitGbkMxQTY1djI0TmhFY2JJajBU?=
 =?utf-8?B?RmJDblM2bHZVTVJCeXBBMVR0SFFjNk5tYXpaMnJQS1ZMeGR0THRBSGN1ZC93?=
 =?utf-8?B?NFFYdHJxK3hhdkQzY0xZa0V3YXpqSXYvSm50eWhmQ2o1bnJsT2cvNlp2bVZC?=
 =?utf-8?B?Qk9JbUxjakJ1TDZ3R0pZVEd4OUFja1p3NTYzOGJPMXVXLzVEVjcwM1FKZGIw?=
 =?utf-8?B?ZDA5ZWNlOTlkakxXL2FKSmdHT3A0aXg5ZWxjSzVZRlBmbUQ4VThXR0Z4V2Vy?=
 =?utf-8?B?KzNxMmYvREtNdFhNZ2lEVGhtOWdBR3BuYlg2UGV3WDA5UlRVTGFWNDJ3WXYz?=
 =?utf-8?B?QWE1cUR5RU9xaURXNEZHcnpicXN1TzJwalFmSjczcnRFM3BFWFN4eDNLdnpN?=
 =?utf-8?B?SldLUEt1UGwwRTFFazNiNlVhckg3SSs2WXZVRVZ0ZytrS3duSVpYWDRFNEtX?=
 =?utf-8?B?MmF5TjRoclA0ZWoxU1pjT08xVWVLS1BPREluajhiR0xOdldkM09tRUdrMlpV?=
 =?utf-8?B?T3FITG5xMmhiUVprY2FPS1JUSHZCMFpPL0E4RmJvdm8rWFl6L1lvbWhlR3Uz?=
 =?utf-8?B?MTlNcWlqZWhKMWFHYi94Zm1xU2NQUGowMFB4OFZZTUU0TGlnS0k4cHV5RFEx?=
 =?utf-8?B?TnJhT3B4TWo1dkM3THpxS2h4b3FXbFNoY1BEb2hZRnZNVW1IeTl1TkhXN3Ny?=
 =?utf-8?B?VlkrM01iYVdKd1RRa2luTXU0emtCS1dPNUxTNW9VcFhDQ1hET1A2eXh6blBT?=
 =?utf-8?B?OU0vL1gvTDRJeVFXUjhncG5CUk1OeHRWUVRjS1pjUFNETHBZSXJTMWdLVlIx?=
 =?utf-8?B?T2VRQldxSXVMZ2FIRDRUWFFwa0dHRnEzZDFoVjRQd1ZsRkFWSDl5Q09WanJq?=
 =?utf-8?B?R0lVOCtpbnJMOGxUekFGblJQZml6M29BR0hySHkyNDhLSWU5UFFBT3VWRVM5?=
 =?utf-8?B?WEE3TkloSjBnNlpLbWdFV3E4MDZlaFlaeDdzNEgycHBCcEtLVk5mbU5TWnNs?=
 =?utf-8?B?d0pPajNwYVBsZFlrWnU4aE9raTFDbWpnRm9iY2RIV0xNT3krYVRCNXRmZC9E?=
 =?utf-8?B?ZWg4RGM5b0FrYklqdmk0QWtuOE9Ucmt1WkFMeWx0N2FKdy9sYXAyTU40UnVi?=
 =?utf-8?B?UW5aRkcyOEJpQnJDL2FMeWtZTiswalNpRlhnZVc4TVgxQmxseFlpcUltMWlj?=
 =?utf-8?B?dHhCWDZkZE9KSWFNd0tOQlREWlBsc3Y2amZWR25YOThLME1NcHMyditjRkFl?=
 =?utf-8?B?TzZJcTIwS3A5cG10UnQ3UXI1cFh0ZFdYWTBOcHdyanIxa2ZXRWg4bXZURmFP?=
 =?utf-8?B?UVdQZ3E1NUR0ck9uZjJMaHNxQkZJaVJxVG83MkxsRk84ZUFwYVd4ZHpHby9s?=
 =?utf-8?B?Yll2ZTNBZjE5NHY3RUdHTCtBSWlZZzg5VHhMT0F6ek4vWWd1Qzg1L1BsdWpr?=
 =?utf-8?B?QXBGd1V3QjlpbE1BSDdRZXNHYVJDNGtoVW1JY2JkSTBIelVobHcxZXVhK200?=
 =?utf-8?B?Z0pvUkpMS2hBUUZlWFR1cW11OXNOTENseUUvOCtVMExVd2VVSUJPS3ZPckV0?=
 =?utf-8?B?VjJSMFloQml4Tm1Ed2pEUFlsNWdZbTg4dm8wYWtpakhwVEdGbFhLdTlrOEI0?=
 =?utf-8?B?czhJTkJNd3h4YlRMbHFHR3lhVXZTS201VDJIeUFlYyt0b25mWVZwdzZPcUY1?=
 =?utf-8?B?MjE0VDBGN1hlSVQwbUZ1TThYMXY3TmIwdjhHOTJDeE1sdy83YXdXZzYvMUYx?=
 =?utf-8?B?UmVJclJSdkZOQzdGRGpvTSs1a0lqVzFlR0MwOGVIWVR3ZWhnM2RSeFJtM2F6?=
 =?utf-8?B?QXl5eXNpaGpPMTBDQmdaWU5sOC9MY0kyZXFDd094dmlzcjcvSXIxUzI3RUJT?=
 =?utf-8?B?a2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5619.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZE1UOUo0QVh4RXdkSXVjV3poYXRzbGVvbm9sb0tpWGhiQ0tMN2RnWk1td1Rv?=
 =?utf-8?B?YU82UmhWNGlhVTFyWDRhcmNUSXB1VG5VVUFTekt5blZsL3BqcVJUQjgyYWlL?=
 =?utf-8?B?S1FBL3l3TXJicGlmNW1KWmFhc3JxQmU1SlkrSlRmM3prRmdjTmU5RXlqeHlL?=
 =?utf-8?B?RWVDN3ZTc1ovYTdsVDVqc3F2SDcyaWNQU2w5TjZEb0lna0VQdHBZalhITU50?=
 =?utf-8?B?WmFlZEZLLzRLQkVnRjBkVC9wL1pTU3RMM2FIN1hTVE5Fc1BXaStyNWxiVjlw?=
 =?utf-8?B?bG9YL1pMRmswVUVGSTk4VW42QU1QTTVNaW9tVW05MG9TNkdEOUhEYVZpNWV0?=
 =?utf-8?B?SDlrSllBMjgwMFVjajBidnMwdmdLMjljOGxxT2lZald4M3l4aEFOcktwcFp4?=
 =?utf-8?B?ZUdwWlNIU3dTOXU0ZUxEajJqWDFMQmxDZVdRSUQ1Mmp3KzBjekdJSFNja0Fv?=
 =?utf-8?B?QUNnVXZqN2lONmxIVHRETGFVSnQ5OE56T0FieWREejVNL0NyQmdjWmV4TzNT?=
 =?utf-8?B?UkczQzFrQkFUNDZFQ2liQW9ra1dUbHJ0NU9KRy9hM0lKNWNId1ZSdm9ZOUdx?=
 =?utf-8?B?YTZ5MXN2eGFEajgxU2ZNWWZYRDNpenk1L2JNODc2QlNDL1RwdFJBR21YQmd5?=
 =?utf-8?B?c2l2MUx2cGF4R1cvOTRhWk8xTDloUERtYXlvdElJcXI0UHlmT01oZmcyYUg5?=
 =?utf-8?B?bUJrVmlaY2VDRkxXYnNUSzVWVE5FUEw2MmpvVzdaYTJZeXlIYk9yaWtUUjJT?=
 =?utf-8?B?Q3RPR1JIWkJ3YXVNQWdYYzZENk8rVWF6VUY1NDNaY0tDS0VGT04wYnFwbVg1?=
 =?utf-8?B?WDBrN3VDc29WbEhWWXJtUXdYRVlhT1VWeUxRUkp3bkhmT2JOVlNwN0c5eFQ2?=
 =?utf-8?B?VUdlRXFnMytCQU5JT1BsSmRCTHdEVmJMSjlLcGhKd2UwSm4rcGJlYUVhKys5?=
 =?utf-8?B?Mmw5YVdnM3lzdk1icnVLR2dJdFhaVkdPSEhNSm5iZVpxZWUxMjJZNWd3NGJv?=
 =?utf-8?B?YktsYnREdXFmS1k5Ujd4YnVVeU5UNXdTVythWFdXaVYzVThhNkU4UFlDOUVz?=
 =?utf-8?B?T05nT3BTT0w4TWlROE04dUpQbTBPSE8ybFpYcjAzQmpPYUV2UUc0QkJKMElM?=
 =?utf-8?B?V3ZRRjBldWtiSk5NSDFaSDYvRUhRbVJ4SVNsWkkrT2dpbEo2WGV1K21BdlEz?=
 =?utf-8?B?YXF1MGlzLzZrTzFVMWd5TmVsMVhwem5kdUhNQTBKRWhwcWVvZGxEVWtmM1JM?=
 =?utf-8?B?SjVMZGtYNDNhenpvem4rSGJUL3NPUjNXNzQrVXc0Qzl1UlhudHNONFRSNFht?=
 =?utf-8?B?d2EzcmJiS3BtOS85WUlQT3Vxdjc1Z2NhNXlnYllGdzRmZ0N2SFlETlhOeUVY?=
 =?utf-8?B?ZVdraVRIVnNtSGgwZFFoSnlLbG1jU1llU3NZYUFnM0g2b3FsRWNQNmtzU1Ry?=
 =?utf-8?B?UG54YmlLMk5FV0M0OWcrek1ZMVhjdFB4bktmUFBjOWFhbHA1QjhJV0J0U0d3?=
 =?utf-8?B?Mkx5eHJOejQwVjRQMW5ubGhaY01lYkhMVFNZZTkwZVdpUnBpdC9CbU1zV25j?=
 =?utf-8?B?WEp4S2N3cUV1Yk93blROOURDVVZuVzByOGdDQ2dlU3ZaVjVBWDNROHhGVTdm?=
 =?utf-8?B?NWN1Yk5sRTJReWVVVkJFTXlSZWE5WE1CYXFHYU56VTNSY0lQeE1XcUZzVjdB?=
 =?utf-8?B?bUxmcTRFK2VFN3ZybjZkbG9MWHBTbHNQK3V5N1FESWM0U3AwNWVOOGtXeWpa?=
 =?utf-8?B?NWgwVjIyQUJPZ2xmWkN3RTBqVy81N2c3TTJaUVRWQ2E3Y056VjczS1hmWDFm?=
 =?utf-8?B?bmhKVldDWmVidHZmSVl1RVFocC95bk5uN09lb2RJT1hNa3RpQTZoQ0U2Zm5m?=
 =?utf-8?B?WGZxRk1nVjFtVTJaVmZzSW9JS1JKYy9OZFdaRHFENkNOMEcxNTNwVmF3cXZr?=
 =?utf-8?B?UTZhRjBsZXRPMWxkM0JPTkM0VVQra2JjSWVLNllUbVRENmVmeENNYU9rY1RN?=
 =?utf-8?B?L01qWmVtSmExdzdJTmRsb1JDOXpadzdPdTFHbXAwTmZucFAwdjNBb3lIMHJO?=
 =?utf-8?B?YXdyb3YzWXhlZXdRYnpmUTlzMzM1d2oxTVA3Q2pUTTZBMmZnWitkUVFycVB5?=
 =?utf-8?B?akR6Y0RZUGFvaUJOZDJ1dFJaTFRlbVN5akwxS3ZLQWp0cE03YlRJcHpzUUd0?=
 =?utf-8?B?eUZ5a0lMbHZhU3RyYTAyZUtYcE5ycGYySFU1a3crLzl6cXJUSkYwaGo3SWtR?=
 =?utf-8?B?djA4c3UwMGVIOUxCV3NJcWp2aVZ3WDJnbUxpVWcyWXVpaVdReENjVUdCNisw?=
 =?utf-8?B?ajk2U0U1UDRLdGY3cFd1YkF1a1luMFBPRUtwZHFBN2pyTGFOamhxZz09?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e7b9557-6cd5-4518-6b6f-08de578ea2c0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5619.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 19:12:07.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1jF70nkgAqDzevNRo07GUFsoHSywW5BLlR6XhWnW5KBgMXHIkXbiNd/rxseE2jbVCv3sntDvZOZk56DJboziUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8333

--------------ms000701060202080606030008
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2026-01-19 20:06, Jethro Beekman wrote:
> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results i=
n a
> kernel page fault due to RMP violation. Track SNP launch state and exit=
 early.
>=20
> vCPUs created after SNP_LAUNCH_FINISH won't have a guest VMSA automatic=
ally
> created during SNP_LAUNCH_FINISH by converting the kernel-allocated VMS=
A. Don't
> allocate a VMSA page, so that the vCPU is in a state similar to what it=
 would
> be after SNP AP destroy. This ensures pre_sev_run() prevents the vCPU f=
rom
> running even if userspace makes the vCPU runnable.
>=20
> Signed-off-by: Jethro Beekman <jethro@fortanix.com>
> ---
>  arch/x86/kvm/svm/sev.c | 43 ++++++++++++++++++++++++++----------------=

>  arch/x86/kvm/svm/svm.h |  1 +
>  2 files changed, 28 insertions(+), 16 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..cdaca10b8773 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2205,6 +2205,9 @@ static int snp_launch_start(struct kvm *kvm, stru=
ct kvm_sev_cmd *argp)
>  	if (!sev_snp_guest(kvm))
>  		return -ENOTTY;
> =20
> +	if (sev->snp_finished)
> +		return -EINVAL;
> +
>  	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(param=
s)))
>  		return -EFAULT;
> =20
> @@ -2369,7 +2372,7 @@ static int snp_launch_update(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
>  	void __user *src;
>  	int ret =3D 0;
> =20
> -	if (!sev_snp_guest(kvm) || !sev->snp_context)
> +	if (!sev_snp_guest(kvm) || !sev->snp_context || sev->snp_finished)
>  		return -EINVAL;
> =20
>  	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(param=
s)))
> @@ -2502,7 +2505,7 @@ static int snp_launch_finish(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
>  	if (!sev_snp_guest(kvm))
>  		return -ENOTTY;
> =20
> -	if (!sev->snp_context)
> +	if (!sev->snp_context || sev->snp_finished)
>  		return -EINVAL;
> =20
>  	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(param=
s)))
> @@ -2548,13 +2551,15 @@ static int snp_launch_finish(struct kvm *kvm, s=
truct kvm_sev_cmd *argp)
>  	data->gctx_paddr =3D __psp_pa(sev->snp_context);
>  	ret =3D sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->er=
ror);
> =20
> -	/*
> -	 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private p=
ages
> -	 * can be given to the guest simply by marking the RMP entry as priva=
te.
> -	 * This can happen on first access and also with KVM_PRE_FAULT_MEMORY=
=2E
> -	 */
> -	if (!ret)
> +	if (!ret) {
> +		sev->snp_finished =3D true;
> +		/*
> +		 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private =
pages
> +		 * can be given to the guest simply by marking the RMP entry as priv=
ate.
> +		 * This can happen on first access and also with KVM_PRE_FAULT_MEMOR=
Y.
> +		 */
>  		kvm->arch.pre_fault_allowed =3D true;
> +	}
> =20
>  	kfree(id_auth);
> =20
> @@ -3253,6 +3258,9 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
> =20
>  	svm =3D to_svm(vcpu);
> =20
> +	if (!svm->sev_es.vmsa)
> +		goto skip_vmsa_free;
> +
>  	/*
>  	 * If it's an SNP guest, then the VMSA was marked in the RMP table as=

>  	 * a guest-owned page. Transition the page to hypervisor state before=

> @@ -4653,6 +4661,7 @@ void sev_init_vmcb(struct vcpu_svm *svm, bool ini=
t_event)
> =20
>  int sev_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_sev_info *sev =3D to_kvm_sev_info(vcpu->kvm);
>  	struct vcpu_svm *svm =3D to_svm(vcpu);
>  	struct page *vmsa_page;
> =20
> @@ -4661,15 +4670,17 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (!sev_es_guest(vcpu->kvm))
>  		return 0;
> =20
> -	/*
> -	 * SEV-ES guests require a separate (from the VMCB) VMSA page used to=

> -	 * contain the encrypted register state of the guest.
> -	 */
> -	vmsa_page =3D snp_safe_alloc_page();
> -	if (!vmsa_page)
> -		return -ENOMEM;
> +	if (!sev->snp_finished) {
> +		/*
> +		 * SEV-ES guests require a separate (from the VMCB) VMSA page used t=
o
> +		 * contain the encrypted register state of the guest.
> +		 */
> +		vmsa_page =3D snp_safe_alloc_page();
> +		if (!vmsa_page)
> +			return -ENOMEM;
> =20
> -	svm->sev_es.vmsa =3D page_address(vmsa_page);
> +		svm->sev_es.vmsa =3D page_address(vmsa_page);
> +	}

I think there may be a race between this creation of a vCPU and the kvm_f=
or_each_vcpu() loop in snp_launch_update_vmsa(). What should happen is th=
at every vCPU that wasn't considered in snp_launch_update_vmsa() must not=
 have a VMSA allocated here. If there is a race, I'm not sure what the be=
st way is to prevent it.

> =20
>  	vcpu->arch.guest_tsc_protected =3D snp_is_secure_tsc_enabled(vcpu->kv=
m);
> =20
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 01be93a53d07..59c328c13b2a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -96,6 +96,7 @@ struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
>  	bool need_init;		/* waiting for SEV_INIT2 */
> +	bool snp_finished;	/* SNP guest measurement has been finalized */
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */


--------------ms000701060202080606030008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ZmljYXRpb24gQXV0aG9yaXR5IFJTQTAeFw0xOTAzMjYxNzQxMDZaFw0zNDAzMjIxNzQxMDZa
MH4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVUZXhhczEQMA4GA1UEBwwHSG91c3RvbjERMA8G
A1UECgwIU1NMIENvcnAxOjA4BgNVBAMMMVNTTC5jb20gQ2xpZW50IENlcnRpZmljYXRlIElu
dGVybWVkaWF0ZSBDQSBSU0EgUjIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDm
Q+3UxwVE9dAx75DUrLZwgASWLLr/ID8bbGCfpcrSHIRsrR4ut5n49JGViu5DYE6addkpajbi
MA2Jaw1Ap4RncDjZ+0fzSWbqGKEE+vNPVLoKy7OVIrxf/9HzGUT6YaELSNrGTR0cYNcR+W5b
E3JTxTMQiLMAwBbMXH4qKXQUT+oyIXD11CIMUtM8ECoo2o7qdpw1zaZWwVvhXy9mkAaRgrkw
2NpddZUVbJKF/spsJa3lNVdSi3wcJpDDQAl6jxtBF/3ctkY1OjBQz32yRlArFymsPc+we9ff
HAgvfqbHVfXvgWG8urVith8/6MjmojHMCKqFoJueLbtTPoN8QhvVh49uoRYYAUUH0HOAYCOz
GBGrdJvMIYZqQsX90XlU7Qxp1En7vMkQswkQTvGmBPWrK/EwSAJc15BZm+i8QBxPqVKFORfL
ETLEC4ZrwomtW/oPxBP8zXPvQ0K1dQzAkw+JXxKv/KiwDryFFhU5xMMB3yKxO5NRYXlnqW9n
wfhdBTJScthzAtGO9KZQ2GPmq0NMVMuXe1XdCOmnPxOptKkMldBItkaYgrkTzqP1nzIAhVfU
4sNnHIxKPftwrZ9VMSc5Wkz88bOtAJyz3KQRY0qcAtR4LaeRkiZaEmprQA8EOpdJxtv03pBZ
taUnnTY6DsEwGQ0+P2mmB5IHB74SknyNswIDAQABo4IBaTCCAWUwEgYDVR0TAQH/BAgwBgEB
/wIBADAfBgNVHSMEGDAWgBTdBAkHovV6fVJTEpKV7jiAJQ2mWTCBgwYIKwYBBQUHAQEEdzB1
MFEGCCsGAQUFBzAChkVodHRwOi8vd3d3LnNzbC5jb20vcmVwb3NpdG9yeS9TU0xjb21Sb290
Q2VydGlmaWNhdGlvbkF1dGhvcml0eVJTQS5jcnQwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3Nw
cy5zc2wuY29tMBEGA1UdIAQKMAgwBgYEVR0gADApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcKAwwwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybHMuc3NsLmNv
bS9zc2wuY29tLXJzYS1Sb290Q0EuY3JsMB0GA1UdDgQWBBRmj6a8t5Msnfm6SeVP3OqQUBFq
nTAOBgNVHQ8BAf8EBAMCAYYwDQYJKoZIhvcNAQELBQADggIBAMJr11ncGIPKbaZxuuU2P1TG
yXF+gy+xH2TBNWNliJVL613nH1J7L2WcJQzqXYl77rKTzGeQexnKeYZ13MFwuE80vISif/gw
K569WLoyCvNVvGEZ2bZ+JL5K49mVhrv1gqO+MgMvc8iEENl1xoWRpJGD4EClk8t4u7NUCgBv
hYORiyzHCZcILHcEMvfEwmmFshMN6TqcAJdRjFT0Ru0hJcs5d7EFdM9dCa5ckXWrKK49cSNq
4qOaxqpG99EfDw6U2c70YcJ1/IhC1wL6z8qlGvhYQ0vJvqGJqW/DdeuWcMmrB+qZL9WbORQ1
nvlNggB6smEk0pXXYBr8HYjxT67XwtBBmkBXFpa7G6y4P0BO3kxWGBfvRBJHfyaiwREgVWa3
6V/WjXtPmV8VHcv04Rqgk64E4OlSUxgi9k9VC6kivTXJN+Gg2uJJBQdf+ptVhJqkkrtB0gAB
F+kQP0xsagKkrS3NVrVKo6peWMx0h7l52bGqT8ucu4Qe200KQi2xp/r8jpP60EE9U4M8D1gr
H3Kh9OxVOL4wykdoC/yGJNLKIl0BfsCVWB/GeSq5hxe/84K51OEJqpjDnOMrkRevfVzqGBFF
Aeg7Kg7uSysVR05wR+ltp3ytaIbjGJtKad8raIbM1qiNFErG7YB7v4baI3BP1s/rTDtPLoto
tahwHP7IqOHOMYIFVDCCBVACAQEwgZIwfjELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFz
MRAwDgYDVQQHDAdIb3VzdG9uMREwDwYDVQQKDAhTU0wgQ29ycDE6MDgGA1UEAwwxU1NMLmNv
bSBDbGllbnQgQ2VydGlmaWNhdGUgSW50ZXJtZWRpYXRlIENBIFJTQSBSMgIQNfphqrZnvSlG
TcM/9wjbxjANBglghkgBZQMEAgEFAKCCAxIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMjYwMTE5MTkxMjAxWjAvBgkqhkiG9w0BCQQxIgQgIsGbDc/gKFnJ
v6SQWmPfMpkEU/IIeWlunpSN1Evf1O4wgaMGCSsGAQQBgjcQBDGBlTCBkjB+MQswCQYDVQQG
EwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoMCFNTTCBD
b3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1lZGlhdGUg
Q0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIGlBgsqhkiG9w0BCRACCzGBlaCBkjB+MQsw
CQYDVQQGEwJVUzEOMAwGA1UECAwFVGV4YXMxEDAOBgNVBAcMB0hvdXN0b24xETAPBgNVBAoM
CFNTTCBDb3JwMTowOAYDVQQDDDFTU0wuY29tIENsaWVudCBDZXJ0aWZpY2F0ZSBJbnRlcm1l
ZGlhdGUgQ0EgUlNBIFIyAhA1+mGqtme9KUZNwz/3CNvGMIIBVwYJKoZIhvcNAQkPMYIBSDCC
AUQwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBggqhkiG9w0DAgIB
BTANBggqhkiG9w0DAgIBBTAHBgUrDgMCBzANBggqhkiG9w0DAgIBBTAHBgUrDgMCGjALBglg
hkgBZQMEAgEwCwYJYIZIAWUDBAICMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgQwCwYJYIZI
AWUDBAIHMAsGCWCGSAFlAwQCCDALBglghkgBZQMEAgkwCwYJYIZIAWUDBAIKMAsGCSqGSIb3
DQEBATALBgkrgQUQhkg/AAIwCAYGK4EEAQsAMAgGBiuBBAELATAIBgYrgQQBCwIwCAYGK4EE
AQsDMAsGCSuBBRCGSD8AAzAIBgYrgQQBDgAwCAYGK4EEAQ4BMAgGBiuBBAEOAjAIBgYrgQQB
DgMwDQYJKoZIhvcNAQEBBQAEggGADyvE8ySvRWhjfHb9DmxSRW4E4hvrt9If2AVEdPoTRp8/
m3QgDyxDEnqLGSn8Zrpv+6jfckH0KmZ4SPk+Xo4dn3kY1ORlGzm3WcloTu2nIFIdcgEH1HPl
RdtJiK/FH0ON4fxJam+34eNh0s53YpYo7Y06yKc1tGg0d9AXbdQySL7JNGYdn6aOyOTzdolm
cyVWOV4hPOr4ck0AIueJfjaS8HvL6GgFoqKhcREvoF9KtdK6c5w9APmIDxlVWrkvO7XjHQ6+
mIsk9bjB6WhbHzDgGvCJ+b11N6TB8jY4CfjegbEIOGbu/GLiPaCLNgBnz/p2Mj8w5d+mwdAy
WeQV1/xht1qvCXmNtEunzLDR20MivG9TyaMVP2XY2L7uUrnuLt4XBg4RL4Gui5kJv+9hLvEi
M6Oc4H8UE3DQd1sFW387lEkbTwH6E+FUd6q4JoqO+AX5LDniCNTVuTszIPrc9FuGrtDV8hRS
UrcrMgjh1WszpYQnRsOHOeYVVu/LkR6iglRVAAAAAAAA

--------------ms000701060202080606030008--

