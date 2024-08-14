Return-Path: <kvm+bounces-24124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8A09518A1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4E7F1F23946
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0B91AD9F6;
	Wed, 14 Aug 2024 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TGIYMSIb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7491E13D8AC;
	Wed, 14 Aug 2024 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723631112; cv=fail; b=giUa4+C/Tuflcta78o6y9juU018/5IxE8fzwY0juUKA4OlFbQNAF2HLDdN0Lv9ZaUB5Fr0qItZr02m6GzVQbQXxetEuYDGM0OuQbdK4ZFbDkMc+6PSr3ADg61fOANSvDRx8+ZAddGtA4gTEdw5pG/mCsVRKmzdG7SIxujnyX+5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723631112; c=relaxed/simple;
	bh=MURkFSYYYTyY+UjdJY8RYAkKEbcYKQ24GiGJnKtzFLo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q1yNZHAO9E+epzcC7MNivx1a3zUMccecki6ikUHDx5Nu3H/VVovQKXNiKHj5SRtl6K2ywxdi0tiIHAkjb3/0Ax5e+Q9YON7/CkhOHsyf0JDt9NL4RwpGVn/O82Hu0L2GdvN3INKkli+L0uRHPMvjLXgy0IF4cuJW7PFHBkgCDcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TGIYMSIb; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNwrnD1auseCRke7QL/a5PsIuxV5McGmdhHR0TiQFVpSvgxoGEiaPl9nSZ1YldnGKEh7V8AoPeC3xpGEnZMCHEPhW3CVCz09e8FZ8lbcvQ2YkzCmGmTuF6Mog2I83aBMrDtwPXmvP86vGLOyIQLeERX7s0uS7ap4rkP8CkXzHziqqln8KDOBhmcYaSuYHF3xq+52ABgnA8vUMdo/xO8zzoPh/AQONnI5VFu0ebU9f4PB3Ou7i0COsIrJ58gXrsWURCBaE12ErsW0WI8D11/Ncv3qRa142JLIys/nUF53Fv5LXsZUkgutvlBPgwrLvy3GYLmbQ/GPH5kMz2IMTkHNxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dP2+sEn6Nxl1pDj4oii1QR4v3N896hnCqaVJaSGSZc0=;
 b=xATNP56IDOdtTcNNVlprA66gGWtytROMq92UaBHX7n6RKa9mLp+2LH7zZ9Wx11+Vsyu0I8ylK06s5IisBweTsMGzoz30wpOIZWgS0hvZ614p8nMTTOEPWHp/aX7kaqd8v1ipNRNYIKLBYBluDajaJRVzv1dt660kMREtV2d9K+c78EOzjEgWSij7I73XHp9SurwBeEYQlwu0ZLk2oXUDq/12piVFV3S+zGHuDD7imzx0v/jGQvLRJo2lSsCeVqUNCqj9Qq0BOX42FMrTuo3iSBIFzwLr2ONFD6GZT8eYsrzcuvK77kIBtGwVw1Q+8ZEv+iBawqf2YHWffhRpLmiOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dP2+sEn6Nxl1pDj4oii1QR4v3N896hnCqaVJaSGSZc0=;
 b=TGIYMSIbTsUytOREm0NSeNyUa9vS2qMKT+otefS814LwS4wju5XBEIbRBrPX2J5jDUliMtD1KKwT3g28pO02FPu3rJ/6OqoODe0oZvWo9+Pm91Laebm07xFTX0SwBh84lQOtJFKjm+B4660dIO0L+zCbjA26Iyn0ai+l+IYRf4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MW4PR12MB7141.namprd12.prod.outlook.com (2603:10b6:303:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Wed, 14 Aug
 2024 10:25:05 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.7849.023; Wed, 14 Aug 2024
 10:25:05 +0000
Message-ID: <a3c1b0b5-dc42-b2bd-16ff-90ffcba2ec6b@amd.com>
Date: Wed, 14 Aug 2024 12:24:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG
Content-Language: en-US
To: Amit Shah <amit@kernel.org>, seanjc@google.com, pbonzini@redhat.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Cc: amit.shah@amd.com, bp@alien8.de, ashish.kalra@amd.com,
 thomas.lendacky@amd.com, maz@kernel.org
References: <20240814083113.21622-1-amit@kernel.org>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240814083113.21622-1-amit@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0351.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::14) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MW4PR12MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db02038-7f75-4bdb-b668-08dcbc4b5d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTkyZUxVZlJYbmdyS1Q1S2JoY3JLR0wyeWYzdTdMb2RTQXBxcENCbkFWWEdj?=
 =?utf-8?B?T1JTQTViOVBHYy8xZm05VGptTk9xZTg4U2pkcFJRUGljOWhtN2FBazM2N2ZZ?=
 =?utf-8?B?dG5Mc2ZELzNNcXZHb1lOTEtUY09sblFNZ0VPWVZ4RDRPT01GK2x5MkM5VU5t?=
 =?utf-8?B?NE5wVnZES3NKMGNmdDAzRmNFamt1T05HWWUzWDFOMFFrYzRraytGOVRPazho?=
 =?utf-8?B?NnZOYzVlM1NSR24zYXp6THdDeDFycCsyWXIya2I0bk1aNXdVbUU2YXZpMytm?=
 =?utf-8?B?SzdEOTlnU2YzLzdyRmlFSGFhc3AxK05ZL2ZQbG8xUG5UTUFXV1hSWmhucXg4?=
 =?utf-8?B?b2hBRFMxOEhVQjBEbVQwZStKbHR0Y2FSMWkzRkI0cmlzOWRCMitiYlVFang3?=
 =?utf-8?B?dFlJaEIzTHlxSDRDUzlzVGcreDRuWXJvV1p4YTRpV2tJRUlrVXgrNEVtNWJj?=
 =?utf-8?B?b1d2Qis5K0N2VnZ1QSt4ZnZ5aVVPdnRJS3d6V1JBVEJaZG1Oa3kvZjMySjFL?=
 =?utf-8?B?aUY4UjJmZEp3WW5JMWp0em1vSzN2aGNMY1p2cFNJUEJWaXZnL0pmNjlkZU0z?=
 =?utf-8?B?WUFvSXBmZCtiVVIwSE90dWlESkZDWnp3R21KazkveUZtbWdpY08xMlRCckNO?=
 =?utf-8?B?N2N0WjhJZjlwT1lLeE95bXZuNWcrVHg5NFVPQUdlUjU2MGltMUlsa3dad1JL?=
 =?utf-8?B?R3ZuczZleEQxV0dUVDg1QUdmeVE0eDZ5MzdTTnlYOWFBR0YxRXlaMDlEOVBT?=
 =?utf-8?B?ZGdxSmtoRWdLNHRrb3llSW9CN2NQa2xYWkhkb2lHYzFWNmZWOG1kajJtWWgv?=
 =?utf-8?B?ZFNLMUpTTW5WNDZoZ21aUCtQOGg2VXk0NEgyb0JCUnV2R014M0FVbEpxYjJz?=
 =?utf-8?B?eEdvQ2pOdlB6eUpnUGJKZ0NhYTgrU3pycXZxT0lkVzY3UStPQnJJSE9yU3Jq?=
 =?utf-8?B?VFdQRkhPUTNDOWlES0hwSzV1dFQvVWtWNFhkd3BJVzZPb2NRcUVIenEzaXNt?=
 =?utf-8?B?WkpiRUcrK2NqcXhTZlZ6MmpSOXM5VVp1b3hqS2VERmpld3NkOGdUZjVON0Ro?=
 =?utf-8?B?LzV3V3lyWTNYYlcrUTNyeUNDdmJkUlJPc3ZhT3VPUVY2NW5tc1ZwcjlZSjNS?=
 =?utf-8?B?ZXVkaVZ1c0MzdWI1endGUUtVYkVDMVM3SUZLNFdjUnlUZktBQnA1K3pscXY5?=
 =?utf-8?B?MXpVQVRpY0xySXRTZFAwczQrcEk4ZVg4eDluN21kb0VtVzdFTDNHSy9JQU8x?=
 =?utf-8?B?cnlDM3hOUytpRFNLcVQ3Yjc3SkZsN2s0OFkvT3FydGVLN1dSZU5LRDNmWGpK?=
 =?utf-8?B?S2dJVGpZWVNJWlMxNTcwdUNlc1R3Z3lmeFFpRjJ5OGtYYklQOUhQbURzY1F0?=
 =?utf-8?B?SDhUNUVFT3R0QWd1RWZRaE1mdHlIMEZoNk44bEhvKytCSzBndU9Hd3Z2UFE0?=
 =?utf-8?B?VXQ3V2czMklDd0MwVDNJRExURnBhV1M3aWplSngySEhFbTZXOEhhTG1WRDJw?=
 =?utf-8?B?OWxpY2FOVnVIYlE5REM3aStWTU45LzZrM2JFd2VTQTZzcU1kTVpRNi9WMUUr?=
 =?utf-8?B?RG9lUUhpQjJVa2l5OXBoOWR2RU1LYkQ0SE9sODdzdkR0c1EvdU95LytTY0xX?=
 =?utf-8?B?NDNaaW1aY05qeGxiR2dRRHZYNTZNWTdPRVlPcmJCNDZmcU1xbHlOanE1b3Fp?=
 =?utf-8?B?bENkRUJmRWhEejNUVUpXNlRWTXY0OWNIWDlJYjBjV2ZTbVJ5dmkwSmRMRjRN?=
 =?utf-8?B?OUozblFLU0VNaUZmUUZWVnB3ajFtc1pLOWNmNHUzNzVpTFBRdFZLcXlLNUIw?=
 =?utf-8?B?bXk0UjE4KzRhb0pxamwvUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUcvaTdHKzd1dkxUOGJ2d3BLZnY2d1V5NjhlY2JsamEzWGNsaXl0NnhZVDc1?=
 =?utf-8?B?N21rOGFDajZRbGxvSlY3QU1yQzZYT1dxRE5aajhQN1Bic0ZwK2NzT3p2THNt?=
 =?utf-8?B?V2NlWWRMY0M5RUlkcmtkV1VqMmZvdWxwUkZSN1lUQ01nTkJQWnVWcEt1bGRw?=
 =?utf-8?B?YXJWWWhNV2IxTG9odExNbkQ4N2hQVEsybnAyUHhHaXJ2YmphNTlPYTVJSjNT?=
 =?utf-8?B?UGJBWXRrODVYYmhic3NoQ0pVYTlqN2JiUVQzKy9jeWRPWmdhSWg4a1dTdUln?=
 =?utf-8?B?eC9IVFhnTUh6ODlIclIraVZJeWJMc243UVFQT0xsTERsSzFCbmFaMTJ1TDRa?=
 =?utf-8?B?M3doTUJoUWpBSVl4ckNRVmZ1OStnOXZsU2o4SGJWcDhnOXhNZmZKZHpDSlR1?=
 =?utf-8?B?emk2SDFGdlNQVm5zdGt1Q1lDRGU4ZWtBYVhLUVFUWTNBUis1L1VRSjAwblJ2?=
 =?utf-8?B?Vm5td25USlM3Sk8rR2VaUmlpZ2tjc2hVU1ZDb1N0RlZMMWpqaTRtREZrZEtM?=
 =?utf-8?B?WlpSRkR1MStzdnpuNXB4dGcxcUdjNjN3ejdLL0xVb1NlZ2QzR0d3MElnZGc3?=
 =?utf-8?B?QzM3MjM0RStKT1g3alNQODhyVVlWaUtad3ZiYjNCeEgxaGNrSit5TTRYRW9Q?=
 =?utf-8?B?MjhiU3lkZXAxZEQ1R1BWYU1XQ3lVQTdJUlZiSFoxYm82V3hEOE1XVk50VW1l?=
 =?utf-8?B?RGl0aHNha0owbHhRZlJad2JkL2lwV2orWEcvZnVPRHp3RG8raEtwVVVIZEdn?=
 =?utf-8?B?akFVcTJJU080c2l4cndZTWhvWmlWNUJoUk9RTGdIUVhMNDMwQytKdncvKzZX?=
 =?utf-8?B?VWN4WnRDY0JQZG1wRS81WWszNFlXb1FGNmpZWHFnbkJIaE1vYzJ6MlNRNDRS?=
 =?utf-8?B?aVBwOWMzTDZBV3RVVUs4eU5Na0NYRURNcXFnM0dxL0NPOUovWW9MVFVrck9I?=
 =?utf-8?B?dzJXdUcwVGY4SzZ3NzdINDhaWWFFSEdqT3RjREhieU56NW1rMEhKU29PTHJz?=
 =?utf-8?B?N2EvdGRJN1VwQTIwelFTalB2ZzMxUEptdEE4bVE2WmFsMDNtQU5vankxL2hy?=
 =?utf-8?B?bkQ2bjRwUmNMeU9wS1hiTVNqQW5jU3RhcFZISTJJSUNKMXIvWEwzODZEL2RF?=
 =?utf-8?B?YXQ2NTRaTjBkQlludXhMUFVBT1lYeGxnai9WS1Y3c3lpWDl0TUpnbHJaUG1j?=
 =?utf-8?B?ZjJhSG0xZUNkZUI5WENiRVNEYVg3UHRBZmlGZmVMcU9md1c5UXI0eEFrYkdU?=
 =?utf-8?B?cnVLOFFtcXBwQVQvWG9DWFo4aHZYMU5ickFUYjVEdTFMRmNvWkxIU0ZmM0xQ?=
 =?utf-8?B?NzlJNlp6clYwdlVCdEI0VUJiNlZpeEhMaVJoaEp0QUR5S1RIZ0dGWkN4Mzdo?=
 =?utf-8?B?M3hnZWozYWVnSmhBWDRCaFh5bnNKVVRYRnF3UmRtd1hIUGx2ajcweGp1bGor?=
 =?utf-8?B?Z2JyZEtkTTZLekxWRW9mYXBrSmw2eVFDckxCUUhTUWRQVUMzcGg1K1dUbnFt?=
 =?utf-8?B?diszc2Nqb3VGSUt6NklPTmlSNjVaa0MycXFrdDhkWW9mRFpaOUlMdENJWGNs?=
 =?utf-8?B?bC9QRENETXZ5OTh3ODlwUlFIQVNybGRRbzRQVkhtc2ZTcXdZRldjSzhtbVNZ?=
 =?utf-8?B?OWFOS001NVY1dFVISEsvQ2o3VlFPK3BBVTVGbWdjVVZUVWxTRDM0OWlaSk14?=
 =?utf-8?B?ZFJIbjJSVXpRNjFqS25UT2tVckdtVThHVXBHcUgxODR3ZjZ3Ulc4QU9FNTA4?=
 =?utf-8?B?aHhqZXc2Tk9kVXFQNklZZXdnWjlaYVNTTllLd0QwYlgvd3ZuNHh5YkJZNXVI?=
 =?utf-8?B?L2ZlZWM4SExWZWFoaEI3cHNtU2R1UzI3WVJwV0JWYVFvQWdGdmZKK1YxQ3E1?=
 =?utf-8?B?aTFHNUxHRUF1VGQyemVxKzFGVzBtMFRyQ1ZCb210MUdiZU85L2l4dnVCL2hH?=
 =?utf-8?B?c2hFSjA5enNJaGEvbkhsWmZFOFNnV3QwTWZhaWtIUGNJWU16NFVrbVEvcGtW?=
 =?utf-8?B?L3pxKzJJVkJxcWFTUlMxUTV6dXJUbWJ6ZFdaNU9TYTN3a3dXb3U1QWFmWTdq?=
 =?utf-8?B?eTFOdVlkZThHUG1kL1lTZzhIenlBTzRQQ3BRUU9DVFkyUi9jcXJyQVJ4cFB1?=
 =?utf-8?Q?1quhFQQdGxbVShAn+8oW3mmVb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db02038-7f75-4bdb-b668-08dcbc4b5d21
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 10:25:05.2639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UerQHkOCqgbELNpsJxwKg0RHLutT4AhohuHJI/Uiw/9A9Wr8uqf59aDAPKxQ7uCKbYX2KDXQQqzTE9tYXLC4ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7141

> From: Amit Shah <amit.shah@amd.com>
> 
> "INVALID" is misspelt in "SEV_RET_INAVLID_CONFIG". Since this is part of
> the UAPI, keep the current definition and add a new one with the fix.
> 
> Fix-suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Amit Shah <amit.shah@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   include/uapi/linux/psp-sev.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 2289b7c76c59..832c15d9155b 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -51,6 +51,7 @@ typedef enum {
>   	SEV_RET_INVALID_PLATFORM_STATE,
>   	SEV_RET_INVALID_GUEST_STATE,
>   	SEV_RET_INAVLID_CONFIG,
> +	SEV_RET_INVALID_CONFIG = SEV_RET_INAVLID_CONFIG,
>   	SEV_RET_INVALID_LEN,
>   	SEV_RET_ALREADY_OWNED,
>   	SEV_RET_INVALID_CERTIFICATE,


