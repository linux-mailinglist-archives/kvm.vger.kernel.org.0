Return-Path: <kvm+bounces-37410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ECF3A29CF2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:54:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 542DD188645A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 22:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8B821C178;
	Wed,  5 Feb 2025 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aJA7LjKI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F58121772B;
	Wed,  5 Feb 2025 22:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738796081; cv=fail; b=Rd4OVzUk6/+PfwkSxB+6BnCWMYgyE4nQTJ78MGlxopm2RHBLxpgQNKy1EoyoeNPXMLc8U1bgdvGYExnpMuhZyK9lO5MH5vyzcv6GtNOf5QI0LUBiRylwRoYfLU9ImMc7nZggJB5cAN2EFzmeWqr41+ACqjZWjO4saBgq/eOhx1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738796081; c=relaxed/simple;
	bh=Uoh6dqWC4KqU3ht+y2pxq0Mw0E/6ShQE+P78tnFhFPE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hOCUydsF3FoJuQElG0zb4S5Q6/2uGwSIyJwvVFKofD345aQ0sJ4lupGsp0q0IYPpjH5hukULtKaX5mBtqTx2g+JDzDLooYlmaG15kwj9YIv+dgj8NVPRomIbBKA59y1nedEbNm9dyDG7wka1xtC0kqd6yL6azzj3/109xUIPqUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aJA7LjKI; arc=fail smtp.client-ip=40.107.212.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nOjUbsbnoqM06dRV3I7D77A7vda9RghOmS6uiyDj//wiWZqY60j/VaNslTxDmtEHaAr77uWvpeisGgO4A80GNPtFDJabqtxtho9eOxql1A7QEamSKo+Vlv0/4kw4ybEr25+3DFkPUk6dQKYoKDZrCeEUockuHMhgpHbbc+MkUiER4mlW9rD5dySnYA1E5x2x8jYFe7by4rIIMkWYxwn+wkdiy49hnbeQBzmSPUw0pyzLzG78uZRkXIVvlHS9KkXhK67cU02HG+5cW+/8RevSI+VDMiK57XHBIpECHuUlj9TyKpvnmf6P+0jTnzV/uYu4QkimE5tUQI8ytDqmjeo/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IwrnMvTJHe1g9t02mRP+uQxVh7Rxj9I5GvF5EPgqAOQ=;
 b=pNFDYY14zWDJpXXXBKKlpiOGQn80lTpJPGTMi3P/IKCkmYRvg8oLqudD7hu9Q2cVMsTWqqNzmb/OPqwuk4qAdehPPuwyElOkTkZ7g10dS+ugU75dbQlteG1w0wyeFqWcU9VFee3dG2t0Mm8m55k8h/bHsHoVDa0sWzlJwhTUEtlS7TJtYziU6TKFEEWRnb8/GYj1/gjrPblSW/aQSE6mVNQLx9ebToq0mMMu21Afqr2glPYd0HpMywP+4kBZTNh1zFMN/yjH6ZcjwyBmdEurxS7cIqW7nZXWtEa2PB0LO8Q2uqyklbpUI9UjBhFrxD1dlk3nn3Me1rhYKeuX2sJALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwrnMvTJHe1g9t02mRP+uQxVh7Rxj9I5GvF5EPgqAOQ=;
 b=aJA7LjKIJKJAOdBSoDJw2JHNKUIp4IKzNX78lOgRGevaZCOtoU3a1RrKEwfzoVpLsMH1poW16H9sbWpK6yB0PlLSwsG4kqFc0poREu0+H4R6ZTy2McBRCRPfYRgFhaJrE5D5lZ3NpAfpaOzMReXykru7ekoCg1VPNBELgkkZ7b8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB5853.namprd12.prod.outlook.com (2603:10b6:510:1d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Wed, 5 Feb
 2025 22:54:33 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8422.009; Wed, 5 Feb 2025
 22:54:33 +0000
Message-ID: <d27f91a9-0dff-4445-8d2f-9db862acd1d0@amd.com>
Date: Wed, 5 Feb 2025 16:54:29 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module
 built-in
To: Sean Christopherson <seanjc@google.com>,
 Vasant Hegde <vasant.hegde@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com> <Z6OA9OhxBgsTY2ni@google.com>
 <8f7822df-466d-497c-9c41-77524b2870b6@amd.com> <Z6O8p96ExhWFEn_9@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z6O8p96ExhWFEn_9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:806:a7::22) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB5853:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c4ed16c-5961-40a8-fb62-08dd46380e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blVxZTM2NEdqblRDQmxGcGp3MGVxOFEzZk0xRjNaeDVTbFc3Q2p4Q1pQRFdK?=
 =?utf-8?B?Vkl2UVNDVDhFb2VXRktuQ05QTnZ0RDFvNlRtbWJHdTRsUWxCcTlJRUlxWDlI?=
 =?utf-8?B?VmZiUmVpNzVKY1ovN3VieUFDenR3U2dCWkhWNG1RZDExR1lFYXJiMjFWUEIx?=
 =?utf-8?B?TWdOWTRUZnl5YnR3OE4zVGYzUFA5aDFXc3AzRmZSQnJHOW9DTmZXR1JrUGhq?=
 =?utf-8?B?ZGNKemg3WG9Mc1JHTzQzUkMzUldIcFJTamU1NnE3TGc0cmRqaUxHeStpM2N6?=
 =?utf-8?B?UURsVnlqMDA4SHRDbGtKV1ZwRU9zRENhV1FNU2ZKb0Q3S1F1UU5Yek5yUGov?=
 =?utf-8?B?N0hMZHhqL0R6UVZUZ0d3M0JJRkJ0SjNlZTd6RFdmeHNaOUxCZHdaZjdheUFG?=
 =?utf-8?B?elU0LzRGMy9YUXpibGZISGd3dEpheTR2MFBtRnorUEtoYkxBT214Qy8rYStX?=
 =?utf-8?B?K3hBVnpRTzZod2ZUTnN1czNDTnRocHZTWnJHSlVkMjcxTmlOUWRhdG4xZzlj?=
 =?utf-8?B?WGhTcDJmanhvcGZPbEJCODcyUERNanhsOVpnemlkZGdzdTRuVXFXZWxVOVIx?=
 =?utf-8?B?SitPdi9rV21pYUxBUzZ1ODhQSGlpbk5pV0FxczRkaVR0QUNscHkxTmtoVG1u?=
 =?utf-8?B?M2VreVRNTHQ2Yi9SUkxCand6ZjBMY0dqdEl2eVRZb2NUcDArNlRuREpDTlRI?=
 =?utf-8?B?M3NaeTdpZm1QeGlETy9LQTMyTGlRcUNmMDA5bUpFa25VSjFScml0NEdQWllL?=
 =?utf-8?B?enJBWnFMak5NTzF5M3NBUEVwRnhvbHczd3E1dXY4K0wvWUUzRmNnanhxQzF4?=
 =?utf-8?B?QXBXVG5HOW1Ca2Z3eFduN0o1Rk51Z0FWNGNNZmxtTThIbFdtMVNYelpEWkUz?=
 =?utf-8?B?a21aeERDUkV4ajNlNHg4MHJrOFMxaHNtV2o4NTNvTkJndGdNQjdFd0s3aXYw?=
 =?utf-8?B?QTdSc3ZkMDJsODg5anQrdWhUOUZoN09vbXd2WmlrZEdQZzdJazNOTTBhcXR5?=
 =?utf-8?B?WG1QYUxBZm1FT2xPNndvOUJVVzBIK21BRlYvK3JCdDJiT25aVGRUaHlJaVZ3?=
 =?utf-8?B?aTRxSUgxS29XN3lQMFQwU2NWOGxXMmFpYURLV05wZ2t0OVJwamcwVG53Sk9T?=
 =?utf-8?B?N210b2dVdW5KMXkraUhEN3VVVDA3UTl1b2V2NlNTeG1EbWkzaUQxM3ZUaGV5?=
 =?utf-8?B?UHJ1SkVGV29TVk8vZG9kWitsTHYvdlZOUzg3MjNSa2t4dTgrVit2dnhyalpk?=
 =?utf-8?B?aW5lN01iZlN1enludFJ6YjJseDVMSCtycG1RVzFFK3BreFYrcS9sMGZud3Nq?=
 =?utf-8?B?WC83eCtsT2k3UmFEcGNPc2c2YTFXMlZVVG03U3VTS21iRlpJMzFnRXN1ZTJI?=
 =?utf-8?B?S2Nsd2VYakNySFlCNkxoNGc4eTB5aTM0UTZRT2F4Y1dNL1QzK3BXVlZ3ZnpJ?=
 =?utf-8?B?MjQvSHBiZjExcTIzdnJaM0l5bms5blFadjNNQklmNWJsYVRVQ2FnRFl0MXM2?=
 =?utf-8?B?SFprZC9XM1FiSHdBeHZJNUF2VWtKNVVZNGJzL1Y2THQ3cGNRUHErSzZFNmZY?=
 =?utf-8?B?M2gxbW0xRzVNL3h1QUZLbmg5N3lPZlN1TXpqMWZUMHZnSGErd3ZyOE5xRy9j?=
 =?utf-8?B?aHk2WXd3dG5IOTBVUTFBYmNNNkxiYWZyY0huS0QraUdZY0hxU2p2UjhuMXF6?=
 =?utf-8?B?V1Fhckx2STAySmRiRTdRamZWZlQzWElzTmFWVjg1clBKeFducjU5WC8rd2J3?=
 =?utf-8?B?WHlXbitaZnJzb3FuU0VqSVpWclR4cHVhdG5HM1JoMDRxZWtONXNyWHdmRTZr?=
 =?utf-8?B?MXlQS3IzRjlOSmdjZnBoRkdUVy9NQWRNenZUUDdBSlozZ2FrbVRUUWM4a0FM?=
 =?utf-8?Q?KCUxZQxBeRrjV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXRYcnhEYUU3UmszVEZjSjl2RENWTHNUVzRtSGkyUUJPQm9Ub1RqWVBpajgx?=
 =?utf-8?B?YkpHOUVRaHhZZDl1NG1TWDJFYVNrc3F4Z2RCdG1yazFFeDFMUDhvSlpoTWJi?=
 =?utf-8?B?M3NudEUzLytPSzZBVWovMExIK3BEaUZCSmVaK0w2N3pTd2Uwalk4OHpuMGM5?=
 =?utf-8?B?cWkyT1pxQUQ1em1TMWlPZzkrOXB0dlJXWTFiTy9VL0NuNG5WTjNTN2liS0k5?=
 =?utf-8?B?aFpsR1F4aGhhYVRUVkM0dFNxWmdCK3dPdFpMakRrZHcvWjVObit2aXc2SXoy?=
 =?utf-8?B?VVB0czg0eWxwU3QxK1gzanlDeWpuTFB6eTRMdWNQSE5jZnY4bDJpV0RTM1Ix?=
 =?utf-8?B?RWg1bmk5bWJXRERDWVlnV2QwMkFxQkJWYm1CSmRFeUdoTm5hcE4yZHZ6S2h5?=
 =?utf-8?B?SU41WUZEQk1NMktFcE51eElNeGczODJWYWVUeDFWQmxya1ExM2FoNWhTUUsz?=
 =?utf-8?B?N3BEVkZyNDNJU1RuK3QzMU5xN0ZHMkNmNkJuYmtQa0dHQWJ3K295Wjk4b2E5?=
 =?utf-8?B?RHZQWFRrN0RWdkVLa1hDSFJwM3h1MTdPRnlHQXhUUE5UVjRUcHhoNmxXeFJR?=
 =?utf-8?B?YWFwUkFsVW1lUlE2dlF6K0xnYVphdGVPSlo0Um9IWCt1U3dHUHJ0dUJlUWM3?=
 =?utf-8?B?WlRzdncxdDZJdk13UXphcVU1S2g0b3QzZDVLREF3bERPeW0ySkIxUnZDR2hh?=
 =?utf-8?B?Vy9PZHNPVnE1bXlEZ3ZRMDFOTDFDaUpZSWJRNDR6N1FTaFhCQzg3TmVzRTFC?=
 =?utf-8?B?VUpHMUtZUW8vQXYxdTJEV3RqT005MVJpL2xiVWp2UWhpcXJsWjQ0Y1F6TDZJ?=
 =?utf-8?B?Nzl5eVorMlhxbjFXOSswbDQ1aVdLYUE4b0V3Umx0YnNXVE1UT1FQS215SkFR?=
 =?utf-8?B?MzFTQkx3SmRvZTFSZldwcnAybEkydkgyTGt4TTRkQVlzZ2ZHMmRlZUNEVDdz?=
 =?utf-8?B?Vml4SWVDa3cvRVU5NnJncVBaZnJnY2c3bGR4c2g3ZWhxOExsTnJ2bFBpdjIw?=
 =?utf-8?B?a3p6OUlldmRnM2ZJTFA5NThraEp3dy9VUnc5VXM1aUZGS1o5M1hhNDcrandt?=
 =?utf-8?B?SlBBMGlTUWhaT1Z0elYrbWNDOURWOUpJVVNRT3FycW5vUkdkWWdRc3djcDdZ?=
 =?utf-8?B?aGJ2TVhlWGd5NWlRUU8vSjVaWCtuRE9ORk5PWkM2T29LZnZ4TVVLTFNYSFBs?=
 =?utf-8?B?LzFxc0hCN2RLUXBScUQ3SG5oZCt0MHhGdHV1L0RJK1RMUzU4V0E3YnExOTBW?=
 =?utf-8?B?YS9TcWhuL1RLL0MxV0JBM0ZSbUYxV3o1SUFSTmVwekZrUVdCTUdRWkovRkRX?=
 =?utf-8?B?amhOWU94clVtdEZlWTYwZXlaV1FXZEYxODA1OHp4S1JYRUFYVHl4d0pDRmFL?=
 =?utf-8?B?eFZDbWdvVHhGSGllWjh5YTdFVW5rQnlLNHd3Ylp3WmlJZFYrQVF6Q29zMzNY?=
 =?utf-8?B?azByN0pDakxjNDhMSllBb2RHa0ZCV1pCZi9JR2hSZHBUTFg0QmdzbnprM3VK?=
 =?utf-8?B?cHpQWm9hVHQ0ZGJTR3UzOFQ4elUrQkQ1M2o1NmRTNkY4Q09mRmN6eHRmMEsw?=
 =?utf-8?B?SWFCRzludHQ1V1dodVhOOGo1Z2pXcWhFdzYzSms0VmJjSy9KckJ6WEJGM3FQ?=
 =?utf-8?B?VXNhMnF3cENLTGdlbFRDd013WTdSZ1JvQmRxakUvMWlIWnY2alFBVWlBcVMx?=
 =?utf-8?B?UFd6ZDNyTzJjQW53bUVmNXlTb0RBSXZmMXkwUEZqaktBWFVreE1XYTdMeEF2?=
 =?utf-8?B?M083WHJ1TjUvU1J1MHM4aDRkRWliWWprSHJPVHNqcGxEU0cwa0lIQ0JsN1I0?=
 =?utf-8?B?SW9sNVlBWEJyUWJ6eVZaYkZDUHZkYko4NUdiQVlCZHpiUUlmdEJLSlFDZHNs?=
 =?utf-8?B?M2sybXVHdW01TTlrZTZIRW5NT2l0MEtOalJDcXIxeTdUaFh1UE42YnoydXI3?=
 =?utf-8?B?L1pVMk1LYVBvWjlUZlVab3U5bUdITkEzRCtvOEEzNHREZ0REc1Y2Sk1lMXEv?=
 =?utf-8?B?RWdXTjhDSW9PMjlHTmxTRW52YVhydUNFK1RGOVlWaGwxLzhVWmhNN2lVSVRY?=
 =?utf-8?B?cXNOUzQ0Q0wwRytiMFdxRTIxVG9vYXBTYk4xbFJwcGFiend1Q29GeTNtdFBu?=
 =?utf-8?Q?82V3lhK4ZLSwIkF6B90ZC9psW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c4ed16c-5961-40a8-fb62-08dd46380e6a
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 22:54:33.2297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEDzj8T7g5m46ntr5hdDhFFiQPSSghEFrJWrU9bh5s+UgRnGdlGdbrAmwr2U54yLhNMUOPQbz7HammW+xLiRHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5853



On 2/5/2025 1:31 PM, Sean Christopherson wrote:
> On Wed, Feb 05, 2025, Vasant Hegde wrote:
>> On 2/5/2025 8:47 PM, Sean Christopherson wrote:
>>> On Wed, Feb 05, 2025, Vasant Hegde wrote:
>>>>> @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>>>>>  		ret = state_next();
>>>>>  	}
>>>>>  
>>>>> +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>>>
>>>>
>>>> I think we should clear when `amd_iommu_snp_en` is true.
>>>
>>> That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
>>> will be %false (its init value) and the RMP will be uninitialized, i.e.
>>> CC_ATTR_HOST_SEV_SNP will be incorrectly left set.
>>
>> You are right. I missed early failure scenarios :-(
>>
>>>
>>> And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
>>> and RMP is wrong as well.  Such a host is probably hosed regardless, but from
>>> the CPU's perspective, SNP is supported and enabled.
>>
>> So we don't want to clear  CC_ATTR_HOST_SEV_SNP after RMP initialization -OR-
>> clear for all failures?
> 
> I honestly don't know, because the answer largely depends on what happens with
> hardware.  I asked in an earlier version of this series if IOMMU initialization
> failure after the RMP is configured is even survivable.
> 

As i mentioned earlier and as part of this series and summarizing this again here:

- snp_rmptable_init() enables SNP support system-wide and that means the HW starts
doing RMP checks for memory accesses, but as RMP table is zeroed out initially, 
all memory is configured to be host/HV owned. 

It is only after SNP_INIT(_EX) that RMP table is configured and initialized with
HV_Fixed, firmware pages and stuff like IOMMU RMP enforcement is enabled. 

If the IOMMU initialization fails after IOMMU support on SNP check is completed
and host SNP is enabled, then SNP_INIT(_EX) will fail as IOMMUs need to be enabled
for SNP_INIT to succeed.

> For this series, I think it makes sense to match the existing behavior, unless
> someone from AMD can definitively state that we should do something different.
> And the existing behavior is that amd_iommu_snp_en and CC_ATTR_HOST_SEV_SNP will
> be left set if the IOMMU completes iommu_snp_enable(), and the kernel completes
> RMP setup.

Yes, that is true and this behavior is still consistent with this series.

Again to reiterate, if iommu_snp_enable() and host SNP enablement is successful,
any late IOMMU initialization failures should cause SNP_INIT to fail and that means
IOMMU RMP enforcement will never get enabled and RMP table will remain configured
for all memory marked as HV/host owned. 

Thanks,
Ashish

