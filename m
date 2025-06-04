Return-Path: <kvm+bounces-48454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B286FACE6D6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 00:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CB953A9454
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 22:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817C71F3D54;
	Wed,  4 Jun 2025 22:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uCxKOeQQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2078.outbound.protection.outlook.com [40.107.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EAC16F8E9;
	Wed,  4 Jun 2025 22:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749077540; cv=fail; b=HDlXaidOMIBpJ/U1sS2xiYOZjVP0g36+nWaY1qJaE68XR6e2NlHTc4mfk+YB3oYr95/V0RNI0O1aVl7cnyq9/ReBGpCW7BF3CKXLlTu88nL6EPGkg3+gUgH8IO2pCrsWRBQAz/yJbguDbDcVFP8Y6jizDs6pCOirE00EEOrQbyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749077540; c=relaxed/simple;
	bh=HvWsJWNLe6T+yx1XCxO6wDyU5Y/mpz22IttelTVpgBU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JUs9MijqoQ+wtJY+2nFnUUebudQ3nKOVvXJkbTrlkgLdzfqT6me0zIokzU7lDlr1LtZ0cUW4it7rYyodp/yUBrj1EZpjAtj727OPuK939su4GkmBrqD88y6ykpG2eG04sI1UztSNZ1wBxckvmZL9pnyTU0LaVxT/4WLPaV1UXSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uCxKOeQQ; arc=fail smtp.client-ip=40.107.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qq+0op1durp9OqOQ+sY2b6oWH4DKxtpl7VzKtsl9Z3hkN4eh9orEfuscl7g0nORy+NddyIy1smZGJ88+8LmRHTAyChGePJ4bcLS7g0ns1U966KoMR47DlclJRSKh9dIot9GtdWoqwcP4QlujNiiKC7+q2VKe0KTnRq27wxLuzshagSA5scDNnBWWn9G8Qhk/bkh5Au6i+OQNzMevZPbjsQ0s/ZhV9hOt0lEQ1DMlKTsCeDUIu7wGFAVcXDOFqnJcRL4DAQR9iTlaTQEUJWYWKuMFV6sOpu+hO4QjiRn0u6OnohI79GQ7eq3d/+hf9TWwYUQvZ5vLF4ql8WWkqNBWtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jB1M24go/uFZITp6mgEy7JJ2wgqE7b73QuVKrc7puSU=;
 b=YFsck2mZiwB4l6F+EaLeabDwF3/me3WMLIfeL0w3x1/8J+PY6bXdPS5wpV6BWrB3Be9c0DjldASDpvNvh5QRl6M50nL2BB8FFwCS83Mx4hBTcP63y+JCFiTMFsk5/ao3iocbgO0T+W4USQgu22bx69Lyp7SOo8CusZlBDTc42c8+NHUYR1/NBjaRUWoK3Pd92XcooENeZvKaTSxgYlmj8vKs3+8uHyKN9smsemVOAbNne+u0YW+JRliuoWijjWc+udk77xasNsETHypP0fWw7kaXwpfVatDIUL/U/xs4mEWD9MN8CeKFAGKimbOKmawb2dXQEbnB91+Oe2nzhfMGGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jB1M24go/uFZITp6mgEy7JJ2wgqE7b73QuVKrc7puSU=;
 b=uCxKOeQQGI2yA/DSEFuUY1/UcTFbP3hUaY5VQxTzA/attWrqPT13FQG5hQk9yr2UjcfToIVtEzaWXBPkTnPC/g8c5WeTsW0u8iHlFrXcjfMM72+z1bRbp4/QNumcBLJsoFAfkQ1nVJ8EDVni/TLhj0UFKKbt8qbcOyPMUowPtVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL1PR12MB5876.namprd12.prod.outlook.com (2603:10b6:208:398::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.34; Wed, 4 Jun
 2025 22:52:15 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 22:52:15 +0000
Message-ID: <9af40b3b-91d5-4758-abee-070fbf3ff52f@amd.com>
Date: Wed, 4 Jun 2025 17:52:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
 <295dd551-522e-1990-4313-03543d22635e@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <295dd551-522e-1990-4313-03543d22635e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0172.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL1PR12MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ae81e8-8845-42ef-3a0b-08dda3ba7371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWl2cUVtU3hWNGdvall4cEQ2aG5vdkRBNFhQQUpxblhXOXNnbFNOdWR1VEI5?=
 =?utf-8?B?UzVncytUUGd3UW5zUjFadVY3b3l2anlzamVZcUw3SWdteGdNUG5RWmRKc0pE?=
 =?utf-8?B?RXVyc1ljWS9mdXFDdW4wQUQ1OENJU1dQeW1FbUF0NTk1akw1WU9IdEk5SUs4?=
 =?utf-8?B?N3dSUGVQd1Bna3BnNDdwUmJrYVB2Q2pENHo3QkdiQUljdzdlYTlFYlU3b3NB?=
 =?utf-8?B?WDVaMlpTSXB3UFJFR3lSVU5ZU3ZvbE1aNHA5NWxyZUJoNEtuUXl4eURIeEJP?=
 =?utf-8?B?bUlJUU1zaksrT1U4RW1LWGlCVEVDd3ZZNm11MVhDelFnTFh6VDFxNGFBYkY2?=
 =?utf-8?B?ZFhXR1RWRy9weWt4L2FSa1hzY29uQnVXd1FkeGViWGtmVmhBWHQ1aWVtenlC?=
 =?utf-8?B?aEdjbTZWUGM1Qkh1eFZldStRM1BXYm9XNVBDV3ovSVdJOUlLOSs4R3lsQ1Ay?=
 =?utf-8?B?QTl2L3VKUXhsS1lWV3JhTVZmQzR3YmVESTRpbWVtL0lmZm8yQk5zWElaSWZP?=
 =?utf-8?B?cm5aNXdiZGpwK3BSRnREV3IwNm1ZeTVhVlBDMXdxQmdCY2tpT1ZpTmpRNm42?=
 =?utf-8?B?ampQNVNiQXpMamFkMVVqK1AwamV1dnUvRkNpMnhrSTJFQjV5NHBmUFBpS0Zx?=
 =?utf-8?B?UEkyRVVWeTNqSklWcXRJVHkrLzRvYnpJZExRT3BLZ1pORjF1TU53My9VcHJJ?=
 =?utf-8?B?T1N3SlVoZjdGSDVHbmZ6bXVJZFFhVVkxTUtOUldMQkRZekJMY0o3SG0xZFZG?=
 =?utf-8?B?bUNQbCs4Z0xhTy9XSlprUnRBMzdWMXJmejVlMTV6YzliS3JIcXF1YTVEbXNN?=
 =?utf-8?B?NnhYVHpZWGRzZHd1cHpJYjArdTlublRWeFN4Rys1VjlVdGpQblRBV3NrdXB3?=
 =?utf-8?B?bXh0NVB3NDFqN1BId1pJenQ2L0xCWFJaYkZuTFhPOUxuM2ZvTlVNVkduUzl4?=
 =?utf-8?B?NmwyTER5bUpHMktXcURNdTcyMGlYTE9TMklzU1hLZ3RhL0h1MFNPR0VhaERK?=
 =?utf-8?B?ZnRtb0w4NE5mdjNJQS9hd0xFbHF5RGFvdjJzTGZUdUlyd0FCK1M4Ym4vUGxK?=
 =?utf-8?B?L2lQVy84WVdqbGFvWEcwMnp3eFVhUUtyVGp4V20rZHlpWjRoMzJQSDRjUzFT?=
 =?utf-8?B?blcwNEdJU285dlpLZVVpeWNHVlVCa3plbW1QNDNwb3BRNmdFVldCRjh1czFG?=
 =?utf-8?B?OTFoVkxWS1NBdWd3NC90ZkN5T3FwejFVTGFlbTV2RWZ5ZWFSdVpXUnV6L3VH?=
 =?utf-8?B?L3dqc3lGbG5WcTNCUGhmU0J4UzVEZ2N0OFVpRUlrcmlQWDVXdGQ1ZXIvVTNI?=
 =?utf-8?B?L2pNcUp6cU0xZDl6ZHZscnBkODFjaWJ4Si9abVkycnhlRnFBU3JZTWp6SFRx?=
 =?utf-8?B?c25Sd0NsRWs2a08xWDhJNXFoK1dzZDRkQWRaZ3llVkJWa1NXYys0Yk1odDN4?=
 =?utf-8?B?MUVOUVMwTE5nb29kYlRyVng5MGs2d2JXb1lGSVdDZ0NWL0d4ZUxnM3RMdDNM?=
 =?utf-8?B?OUxIZGpKVW9VYXNVN1BLSXBXeWRPQ1l3YWdCNFpxZUVFeDU4cWhua2xNTzVl?=
 =?utf-8?B?YzlPdnRtcTlEYTgzRnFjZXdqbko5K281U2x2OWFnYzh3RWw0MHFiYnRqN0c5?=
 =?utf-8?B?dnVQMGYycXpaaG9zNEFPeFA1ZXc5N2I2QkxSYmlyZ015ZEgramVONitKc1ZU?=
 =?utf-8?B?MGtDQ2JrMW1TSW1IZW9KbFB5TFRCQW5FLzdMYWxEQ1dCSjBFa005akhiK0Vr?=
 =?utf-8?B?a1kzVlhQYWtuN1hVZ0NiUFR4NVYzZFduMDJsUlRRR21kcXRBblB1NDkxN2pF?=
 =?utf-8?B?RS9ZblU4Z1hjL2d4UGRRSEZQOGJSVUczMTA4K01DcEh2Slc0dHNMSUt0RUUv?=
 =?utf-8?B?VVZLeXZUU2FFTXVxN2U0eGFqNjRIdEphQzB6RURnWjJMWENkRmE4MVdHMzAv?=
 =?utf-8?Q?Zt6c7KXu0Yw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amg2cVo2UGZhK3J4bnlOSFFIbzJ2ZTA1K0I3TXVTeWhKSElWVW9IbGl3bERQ?=
 =?utf-8?B?UC9DTHNKQitlcFVlamtiRnpTdTJBa1VhazhGanE1ZkltNlFRcDZ4OHJmblNp?=
 =?utf-8?B?ZFM1UzlMajhEZGVuaGtkQlVlc1dmZ0V0ejd3KytOUk05MHN1ekJFMkxJY05i?=
 =?utf-8?B?WkI5bUltK0M4b3p5bmwwenMvdDd1TllIdVpYZE5lNXVPV05NSDNFL0JYOWUz?=
 =?utf-8?B?aUNOaFcyUjNtYnRTaW5kMmNiTjRJTVZ1dGxJYzhJKzB1azQrcERVS2VqaDZB?=
 =?utf-8?B?VERTazdjSjMxOVhtVm9mY055YmFUMjYvZ0V2M3pmV3grNFJiTWhOWTVMRVZz?=
 =?utf-8?B?ZTN6RW40UURzYjJURDY3NmZGTHJ6aHUyalZpbzBad0NzYWkxdHJpT09ERXBm?=
 =?utf-8?B?VTNnSlVrejRXVGNUZnM2VDY1aXBRNXBzMEZGL3RQQi81ZGpscXVFVWxtbklz?=
 =?utf-8?B?NGt1cFEyUUJ5VEdrYkpjV0R6SXRlRmUreUNVbW1GU2FiVkVwYWZzaythcVJx?=
 =?utf-8?B?L3dTM3JKM1NJRVhLQithY1JCMWwvRFM3TjVMVmxrbTkvK3RFcUQ4Y0hZMjZ4?=
 =?utf-8?B?SzVhSTJ0ekIwRXFGRHh1aTEwNW9jM3lmbkI0T1F0alYyck55bE9TbXQ0eVU1?=
 =?utf-8?B?YWV2QnNtd2haMGx4ZE1wMndMUFJ6S0srWndva2JJUnJQZUorRHFuM3FCOUlz?=
 =?utf-8?B?azZveW1UVjF5UXMxVXFDd2RlTDdURWl6d2F6ZWZYWnFPMmZQSnlCOXRtWFpu?=
 =?utf-8?B?M1NYaXFOdSsvNk1INlZYZzdEZlprMUpZQXY0clhBb2tuVkRrS3NubjlGTWc3?=
 =?utf-8?B?d21raGRZNXI1QzJQL0FKSTZVSk1pQ1l3WGdCMC9CU3M0V21sUXhOeUZKRjls?=
 =?utf-8?B?aFEwL3RNTG5td2ZmYkJkNllGQUdibEtjT1VlOFdnQUhtTnFqZXNUUEVVQnlw?=
 =?utf-8?B?TzVGQUF6TjlNV0krdlA1eTRXZjlZeEwxK1N5UGNHRGhBczJ1SCtEbnhyYklw?=
 =?utf-8?B?LzBsNmpEK090Q3ZpTWFNMzVUSUU3ZWJBVGEvVktzRnh6YWRhbVhaVGpGMUNE?=
 =?utf-8?B?OVRyT3RrK2JaTnkrWWIvRUVVMGFyUjkyN2R5b1l6L3NyKzVzOW4rTmRvdDNv?=
 =?utf-8?B?dXJyWnNrNENGNXNFY05DNG9Gdkt3OEdpTG5kTUVCRzZVdW92eEREbnA4MDVz?=
 =?utf-8?B?dmxkT2trMkp3STZxQy94Wjk3YzFzR1dUQkVmS2tUcFJRVURtTWduYlBpN2lV?=
 =?utf-8?B?T0JEdC9KcFJkcGsxdHE5M2pKeStnZjEwRmxNenBOUHZOYjZHMWZEbVl3cXN3?=
 =?utf-8?B?UloxV3lyRUZ5MFVUMlFUa0RzMGN1c1FFVUwyYVQrYmNueUFnSXk1Q3VkMjZ1?=
 =?utf-8?B?RWgwcEV4aWk0OURPL2w1VDNCQUpkOTFweThOejMrc2ljTGc2OE80RnZtc0ds?=
 =?utf-8?B?a3BYdlE5ZGRZQ3BvOU5yUXROUkRXVkZKcjNFVUtuYzB0NnNlWUhMUm1hRHd0?=
 =?utf-8?B?WnBGQkVmN2ZwR0lOK0EvSkxwTC9GOHVKWHhlZXNRVUQrdGdGeVZuZUVUdnRq?=
 =?utf-8?B?TnZDeHJDQll4cnQ4bXJHb1h6TU9MWkowKzFNOVFCNEllNWd2MTY5RFhSTXZC?=
 =?utf-8?B?YjZKVWdsMnEvNlErUXE2OWRMdTVWUWF6MmFrN00vZDZVL2RIYXdjWTJCKzY4?=
 =?utf-8?B?Ym0wekFYOHNkRUpBTkwwQU81SThuV1FaQVVidE8yOEpINjhwMDlwYU05bEtI?=
 =?utf-8?B?ditDTVVaNmtxS3NGWE5yUmU0ZVpPVTZ6VGhXT3Zzdmd4V2dKK05BaVRxZ1Ra?=
 =?utf-8?B?Z1pFTWZTdGMxMTNKbnBObW1PRVp2TTIvbThpU1JVdE5ISmhyaG8zbDhnYi9q?=
 =?utf-8?B?NUc2TVorcEJ2aEZVdVdVOXRRSXpUSzMvWERmbjdzQXkyT2dJbzVhWkpzdmpP?=
 =?utf-8?B?ZmdqMlNjaWRQZWxkYmNlRktNRHhyaSsvcTZoWFVOUVNldFZTb3hvMVdYVFh0?=
 =?utf-8?B?TEdiYkYyRTZHV2o4Ry9PYVMzMHBYaVdvVmYxZHRaOXg4L2N4ZlJpOTNrRWRN?=
 =?utf-8?B?UDdFZ2NtVDFmTjJYbWZoVURGWFlFZ3lLSnptS3dWVXp4N1h5bmwwejQ0aS9R?=
 =?utf-8?Q?ZNBTAXikFUyQW+dm24DXZ0ipW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ae81e8-8845-42ef-3a0b-08dda3ba7371
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 22:52:15.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCAqXXjvbTgWNaFr4bVmFttQtLr9dVNLf8XT5Kj+G7HgWM8INr7E4UYjM+pZqGAy4iERbKw5+uVBgVRdT6X4Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5876

Hello Tom,

On 6/3/2025 10:21 AM, Tom Lendacky wrote:
> On 5/19/25 18:56, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The FEATURE_INFO command provides host and guests a programmatic means
> 
> s/provides host and guests/provides hypervisors/
> 
>> to learn about the supported features of the currently loaded firmware.
>> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
>> Instead of using the CPUID instruction to retrieve Fn8000_0024,
>> software can use FEATURE_INFO.
>>
>> The hypervisor may provide Fn8000_0024 values to the guest via the CPUID
>> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
>> the hypervisor can filter Fn8000_0024. The firmware will examine
>> Fn8000_0024 and apply its CPUID policy.
> 
> This paragraph has nothing to do with this patch, please remove it.

Ok.

> 
>>
>> Switch to using SNP platform status instead of SEV platform status if
>> SNP is enabled and cache SNP platform status and feature information
>> from CPUID 0x8000_0024, sub-function 0, in the sev_device structure.
> 
> Since the SEV platform status and SNP platform status differ, I think this
> patch should be split into two separate patches.
> 
> The first first patch would cache the current SEV platform status return
> structure and eliminate the separate state field (as state is unique
> between SEV and SNP).

Eliminate the state field ? 

But isn't the sev_device->state field used also as driver's internal state information
and not directly mapped to platform status, except the initial state is the platform state 
on module load, so why to remove the field altogether ?

> The api_major/api_minor/build can probably remain,
> since the same value *should* be reported for both SNP and SEV platform
> status command.
> 

Ok. 

> The second patch would cache the SNP platform status and feature info
> data, with this status data being used for the api_major/api_minor/build.
> 

Ok. 

>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 81 ++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.h |  3 ++
>>  include/linux/psp-sev.h      | 29 +++++++++++++
>>  3 files changed, 113 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 3451bada884e..b642f1183b8b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>>  	default:				return 0;
>>  	}
>>  
>> @@ -1073,6 +1074,69 @@ static void snp_set_hsave_pa(void *arg)
>>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>>  }
>>  
>> +static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
>> +{
>> +	struct sev_data_snp_feature_info snp_feat_info;
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	struct snp_feature_info *feat_info;
>> +	struct sev_data_snp_addr buf;
>> +	struct page *page;
>> +	int rc;
>> +
>> +	/*
>> +	 * The output buffer must be firmware page if SEV-SNP is
>> +	 * initialized.
>> +	 */
> 
> This comment should be expanded and say that this function is intended to
> be called when SNP is not initialized or you make this work for both
> situations.
>

Ok, i believe i will simply make it work for the case when SNP is not initialized, as that
is the way it is being called. 
 
>> +	if (sev->snp_initialized)
>> +		return -EINVAL;
>> +
>> +	buf.address = __psp_pa(&sev->snp_plat_status);
>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
>> +
> 
> Remove blank line.
> 
>> +	if (rc) {
>> +		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
>> +			rc, *error);
>> +		return rc;
>> +	}
>> +
>> +	status->api_major = sev->snp_plat_status.api_major;
>> +	status->api_minor = sev->snp_plat_status.api_minor;
>> +	status->build = sev->snp_plat_status.build_id;
>> +	status->state = sev->snp_plat_status.state;
> 
> This may need to be moved based on how the patches lay out.
> 
>> +
>> +	/*
>> +	 * Do feature discovery of the currently loaded firmware,
>> +	 * and cache feature information from CPUID 0x8000_0024,
>> +	 * sub-function 0.
>> +	 */
>> +	if (sev->snp_plat_status.feature_info) {
>> +		/*
>> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
>> +		 * command to handle any alignment and page boundary check
>> +		 * requirements.
>> +		 */
>> +		page = alloc_page(GFP_KERNEL);
>> +		if (!page)
>> +			return -ENOMEM;
> 
> Add a blank line.
> 
>> +		feat_info = page_address(page);
>> +		snp_feat_info.length = sizeof(snp_feat_info);
>> +		snp_feat_info.ecx_in = 0;
>> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>> +
>> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
>> +
> 
> Remove blank line.
> 
>> +		if (!rc)
>> +			sev->feat_info = *feat_info;
>> +		else
>> +			dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
>> +				rc, *error);
>> +
>> +		__free_page(page);
>> +	}
>> +
>> +	return rc;
>> +}
>> +
>>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>  {
>>  	struct sev_data_range_list *range_list = arg;
>> @@ -1597,6 +1661,23 @@ static int sev_get_api_version(void)
>>  	struct sev_user_data_status status;
>>  	int error = 0, ret;
>>  
>> +	/*
>> +	 * Use SNP platform status if SNP is enabled and cache
>> +	 * SNP platform status and SNP feature information.
>> +	 */
>> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
>> +		ret = snp_get_platform_data(&status, &error);
>> +		if (ret) {
>> +			dev_err(sev->dev,
>> +				"SEV-SNP: failed to get status. Error: %#x\n", error);
>> +			return 1;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Fallback to SEV platform status if SNP is not enabled
>> +	 * or SNP platform status fails.
>> +	 */
> 
> I think this comment is incorrect, aren't you calling this on success of
> snp_get_platform_data() and returning on error?

Yes. 

> 
> You want both platform status outputs cached. So the above behavior is
> correct, I believe, that we error out on SNP platform status failure.
> 

Why do we want to cache *both* SEV and SNP platform status, as of now only api_major & minor, build and state
fields are used from SEV platform status --- is this just for future use cases ?

Thanks,
Ashish

> Thanks,
> Tom
> 
>>  	ret = sev_platform_status(&status, &error);
>>  	if (ret) {
>>  		dev_err(sev->dev,
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 3e4e5574e88a..1c1a51e52d2b 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -57,6 +57,9 @@ struct sev_device {
>>  	bool cmd_buf_backup_active;
>>  
>>  	bool snp_initialized;
>> +
>> +	struct sev_user_data_snp_status snp_plat_status;
>> +	struct snp_feature_info feat_info;
>>  };
>>  
>>  int sev_dev_init(struct psp_device *psp);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 0b3a36bdaa90..0149d4a6aceb 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -107,6 +107,7 @@ enum sev_cmd {
>>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>>  
>>  	SEV_CMD_MAX,
>>  };
>> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>>  	u32 len;
>>  } __packed;
>>  
>> +/**
>> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
>> + *
>> + * @length: len of the command buffer read by the PSP
>> + * @ecx_in: subfunction index
>> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
>> + */
>> +struct sev_data_snp_feature_info {
>> +	u32 length;
>> +	u32 ecx_in;
>> +	u64 feature_info_paddr;
>> +} __packed;
>> +
>> +/**
>> + * struct feature_info - FEATURE_INFO structure
>> + *
>> + * @eax: output of SNP_FEATURE_INFO command
>> + * @ebx: output of SNP_FEATURE_INFO command
>> + * @ecx: output of SNP_FEATURE_INFO command
>> + * #edx: output of SNP_FEATURE_INFO command
>> + */
>> +struct snp_feature_info {
>> +	u32 eax;
>> +	u32 ebx;
>> +	u32 ecx;
>> +	u32 edx;
>> +} __packed;
>> +
>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>  
>>  /**


