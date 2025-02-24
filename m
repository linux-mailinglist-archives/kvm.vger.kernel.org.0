Return-Path: <kvm+bounces-39045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FCAA42DE0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DCAA7A739F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 20:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15A62566C5;
	Mon, 24 Feb 2025 20:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U1UpeBpQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4C245017;
	Mon, 24 Feb 2025 20:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740429137; cv=fail; b=loQ+y6JyQdhS0o8gM1/env58vWpgwDkEtWVW0CzGYniWzhKpVbVZOrBofSh5inTwMywQZvzHTBK0yBvl7Oq8RHOQJZ2yjXQT1Lsice0W0odpL6eqKtZkBDTXNpw6UIAh+Uo3Wua+LNbBsV58mcSTUBGnk8lV968+WAzqi2PQPxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740429137; c=relaxed/simple;
	bh=1OeMeoivuyFwcaqBdW218XCw+RGkoyZs4o9Cwr3pqHU=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=X5SrDGmg10pZMnS3+3FFMvLV/RYLMKzQTSlIAjtD6uOEOOPf+KNmBZhs4GDsGiwGC5StK3XLHCPfLqF9WpJuT9QHGQpcmtXDc1vrqd3K5rvyaJTgJVMXJI7h5jEEzIDscKLXNH7p0Raxa97eDOL4EG7K+XIJrk1hEwPQzmslnMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U1UpeBpQ; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlYd8k2afx8pR11xFc9ZlFDJrEepO5HHt9auyEsy0hISmi3WQqs2fBohERw2Y4w1HJ4zp+qx56MHh89Q2UNbfvgiCdo1w5VQ5eVBv7bHbg5ocskl0Mp3X04XWSBErF/sqQbVDt+v7JyDANPdlnAwfXxvuG8YpLBicPWBKCfgIHkGBGXd07iL9p9PUPzb9glCln3PkxVIGL5WyBSZkiv0iMytSyV3d0Vubw8REDa/NhXDJ+XVEL4Zb+AN4wPWVLiY2gdeT25CIlWTWMAEbCG1jNb9zGQT/QWBaU2M83Ffhgs2i3pwHmjPI2Lyd9u8CJHcUdVjluWUGicl51q7ZzX5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiuMbF+qSNutWGwU4DY0voONaVV1ENPrEKuEf5cw920=;
 b=FpGgU1eLG//ED2z8rrGHxMZuWY/28bNSQXs40OJk8taZxLm/93d4+m+hAa2S8iN7zqesWgp3n36AX64yheOgxUhUhEVu+4BERqIgh34n4TqVcr7mOhRIIa6ZZjSTwm4Sx8tqo/dLtgdVLXoR2V7EwpbomZsrPVtkTAEG3S2U8uQS0JqWWoi2PbTetL93+P7M0R94DoYBnL8Fb27YYWtuH2niS1W08FEDXcSZ76NrzEN6NHR3bm/Ad2CMEEZSdIR3kmQvpcA73iVLCGo80HZXRy2DbbDa3rXmEtRysg6J4KTyum1bxyEd+h2lbO+MnjIQVwMsavSq9nKGlXYyryY9yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiuMbF+qSNutWGwU4DY0voONaVV1ENPrEKuEf5cw920=;
 b=U1UpeBpQMOTieY/jz57s3X1XbK8EipexgFfhgRPG4WNLdsv+4wAxAu3TMyz83Tg7EJAf/x64vKfWGGgbYPfBOrRFzVNdyoRbrdMRNonch7rKGE9yEoNVIf12I4UB/tgsa1mnAMBpo/RhO5EGzZhcvkbPOgBxdd4EobAKzCvDadA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7292.namprd12.prod.outlook.com (2603:10b6:930:53::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Mon, 24 Feb
 2025 20:32:09 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 20:32:08 +0000
Message-ID: <7794af2d-b3c2-e1f2-6a55-ecd58a1fcc77@amd.com>
Date: Mon, 24 Feb 2025 14:32:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-3-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 02/10] KVM: SVM: Don't rely on DebugSwap to restore host
 DR0..DR3
In-Reply-To: <20250219012705.1495231-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:806:d2::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7292:EE_
X-MS-Office365-Filtering-Correlation-Id: a204b907-5b31-47e3-bc94-08dd55124f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTVLMDlvWG9xcnhEWUNwQnlxcVFDZlZEdVZUbFViUjFOdHRNYmtpTDdKYzAy?=
 =?utf-8?B?VWdacnRKb1YwVk4wS2RkNWEvZEQvZEcxa1E3N0N1Nk5LcGcrc2w5a2NvUUZs?=
 =?utf-8?B?OE05dGRFZkJ1TXlycTBtUXFlTEZkNFh1eXlyNXZ0Q3IzWU8yYU1oQ0RkNlhR?=
 =?utf-8?B?bTJYK05lY0lKUmhGanQ5dXdvR29OcmdxeUV0REVHQ1RXcmpCOUhTeDVXaUN5?=
 =?utf-8?B?Z1hOT3QrNUJ0Y2RTTjNtZGZrR2FJTVhZei85NHBJQ2hmZkYwTGRjeDZ2Wllj?=
 =?utf-8?B?dlpXdjdDRUZudlZNRlF2WHI2MjNJcXdDeUlOdTlobDArbTBxcUQvbERZa3A2?=
 =?utf-8?B?OTdVc2R6VVZ4UldFcG03eVpzUXlVeDN5NWhFNlMrV3JnSi9WRDdIV2hTMGps?=
 =?utf-8?B?UzFMSDBTSEdTZHFFZ05nT2krb2lWZlcwV09YTTYzSk12V2txT0JSNnJrNUNL?=
 =?utf-8?B?TTArQ3J2UDlxN1QvY2ZCYnVDU3BWamJaL1ltVUNkRFRNM3lBU0czRWVNL2l4?=
 =?utf-8?B?eG9xU3A2MWN1ZjJiYTFWOEVsVmFMbGoxM0l0N2cxUTJqakVIVDVkd29pS2h1?=
 =?utf-8?B?RVNXQjRYSlN4L1Q2cDdJZVdEcS9yUWROOFBGTThUR0tuQkRJOW9NMWlHWWRj?=
 =?utf-8?B?OEw1VE1NMmQ5U09leU9vc2xsZmdIQTN6cFIyQVIydFJZS01pMHlHU21wTnov?=
 =?utf-8?B?RDhIZVpNS2hZTUlyTWs5OHBwN2JrT3UvbE9QU2RNMlBFVDJMdy9sS3pYNXhW?=
 =?utf-8?B?WklsaG9jdFQvd3hqR2xXVEcrL0VIVkQxaTUvUUswV2NWelBtTERhMkRQTklD?=
 =?utf-8?B?VzIzeUJjamVQYlNYb0JYOEVONXNlTnI4MTN0eENKbDFtV0kySHc2dVd5NnNk?=
 =?utf-8?B?ak9xWVlqSzNmb2VETGg0dzU4WHNqY2NaV2d1dUUrTGoxUTM3VmFia1VkbEN6?=
 =?utf-8?B?ZldRaWpvNllmNUd2aEt1VTFtdmJicld4VDNaZDVSZ1BwL3k2NEE3aW9YaUpz?=
 =?utf-8?B?KzNuYUVWMmV3ZkJPTVFmUExScEt1Vk9wWGgxUWhFNXc4Mm5MR29sb0NjVFp5?=
 =?utf-8?B?V2d2VU8vWnVTRmJDbVpWVnRnR0VSaEJUYjExRENJbWtGQTFRMUZERWFEWmxs?=
 =?utf-8?B?ckQ5WTV6Z1J3VGpnR1pIS2N4aStyWXNyajBpMDROdWVpaUcxbVZkTTUxdlF3?=
 =?utf-8?B?MGdoVU9PTFk1NmZOdXpiOE1jeVQ0dHBsMGh1WHFjRE0vUC90M0JNT0ZqU0dW?=
 =?utf-8?B?UG84d3JJWDF6SzR4ejlCOHd6cS9oM3JScU5GSGx1ZzZEVTNsbFdseUl1aVBM?=
 =?utf-8?B?b20zOENWd1pGZWFOUzhtcktCOFc5Z29wTXNiUThBTkFqQWhsQWM5ZE9XdUhR?=
 =?utf-8?B?czl0ZXZieGV5c0NtOXRyS2FaWWJ1NW1vTWlhVUtObHRBRCthTFV3OUUxUHI5?=
 =?utf-8?B?MlhyZmRGTDNXY2xtVU5ENUhaR3c3TTRDendlMnZwbE1ManB0Ti9WTi9rNldz?=
 =?utf-8?B?Y05CMDhFWlhyajNlQWtnMVB6VkRCUGVzSC9ZS1Bad2E1VC9sYWcreXk5ZGRE?=
 =?utf-8?B?eERsOTBOMHFnZGRRcVNFVG5FRWQ2VUtWaHd0ZjVxME9aZmRweUwzZ1J0OEFD?=
 =?utf-8?B?SmZNMSsvWXA1MmxOZXRqd1RhMy9jYnFRNmcvWkhQMi9JL0dKU2EvY0JvZVM4?=
 =?utf-8?B?cUdMek56WW92RWxGSHFxM2tJYk1KSHIwZWwxRDFSVTlhY1BQM29XV3BtVUdw?=
 =?utf-8?B?a2xsbmpCaWNPSlBkRlJHdXEyb3ZqaVdiRkNGd2k5Zml4aVRobGthbmZKNFhi?=
 =?utf-8?B?dDhYejJzYVBXUFR2cUo4dTExMzlvSXQxdVE1bWJZS1BYYnlOYXZqYyszZzF2?=
 =?utf-8?Q?DxBOG35t8/KZy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEt4bjJmY3dBY0ZmNXBJUnJBZUozQ29xcTRPb3h2NzJaTi9TNHRQZWRySW0x?=
 =?utf-8?B?dUcyOFdIcVdLZU02ajNhSmV2aWFBd1lzUmp4RlhXTzhGMFNDcm01TnBxcnR4?=
 =?utf-8?B?L3M0aFFaREZGdnVrNGFYTnhuRkNuTERkN1BMR3VBK0hnQTFFMUtIaTBuSDBs?=
 =?utf-8?B?SHVGWGg5RW8rb1A3MmJRNEhSbkYzall1TjcrSzdlY3ZqTmlkd2pNbC9vaHdT?=
 =?utf-8?B?T1pGejNDK0xyVmttelBPTjNTS0V4MjlQOUZJU0Q3NTR4alhVOUZndEFzb1hP?=
 =?utf-8?B?dFNaSll4ZFRxUmg0VzZGMEhzVDZBcEluL3YvN2REYzE3UjlLc2lydDh4aDBR?=
 =?utf-8?B?NlgwQ0pvZE5nMEJQOWxodHJXcU51QTFCUWR0Mzh2a0dIbXFobXcvOTE0VEF5?=
 =?utf-8?B?U2ZyVmk0QjVEQm1xUkpiRlpHZitoWThnWmt6WFRqdVUrR1dLeWR0QUM2aUxE?=
 =?utf-8?B?MFhDZnBHdFl5eHhYbE5pZ3BCRGlBZmFSbnFhSm1QNWFzam5rYVhiSjVMUEpa?=
 =?utf-8?B?Wm41alZKVng1NW8xZm1hbmd0YytFUjlFeGhvdkhpOTNBNlVSVEhZWU9IS1ZI?=
 =?utf-8?B?dk5aWEJXSFNaSWQxekU3OHNRNDZXcHpnTTY3YldBeEFmMWI5ZS9rUXh2Y2lT?=
 =?utf-8?B?c0pyenRGOWpYN0p0RU1lbzR3QVZoVlRvTGpISmRjOHhiTjV3eDZsMm8vUHhh?=
 =?utf-8?B?OEltb0Z2ZGpnbHAzODAvSE8wRFY3cGNJUXppZDB6RkJ4RGpBVW5MdW1UTWtx?=
 =?utf-8?B?dEd1ckdsUkMwYjFyZmdNOHhjR2l3ZFNiRlBKeHdsRG5xZmpJT1Q1Q0d2OW96?=
 =?utf-8?B?M3cxRUNkalZTMlZQWmJMMW10RG5ZTkUvTDdNQmJkQlNBdzFLSzJiaWRLdGJH?=
 =?utf-8?B?eEpVSUs2bC9YUlltV0NyNEcyTW5XNkFxSGdKOEdjdkQ4MHltRWc3dG9tSFpC?=
 =?utf-8?B?UTdFZUZKYXFkd3VVditLMXNzZE5Ga1J0cURNMS82c2VFVXgveW5LajNGVnNE?=
 =?utf-8?B?ZVcrQXZaZ1ZVRm5VQ0MxSWtVaDdkUzRjdThOTnJhS2s4UmYzaGtzRkFCK2dS?=
 =?utf-8?B?TFBLYVRzVXFXY2lUUzBqdmc1OVJVWnc2THVHRlhhajNIcjVuY0RSNSttS0Nx?=
 =?utf-8?B?b0s4TFlhbCs0M01HcUV1WUdOTDczQzBFRTl5T0R3d3JwSUVZRFFSc0tMK0Rs?=
 =?utf-8?B?RlVTc0libmM0NW1HNWlqNmgwQ0dSUzUyWDlBUVllRlZlNW56ZzFlejNkc3Ru?=
 =?utf-8?B?d0ZsREpCU3ZmanV6cXQ0YXlLa3JzNVZsVFFFZTAzVzJaUFNocDY3dU41L1Nx?=
 =?utf-8?B?WU5lc3NhT0tPNDNmWG5nNWlRNzlQWlVrOVVXS2xrclJOV05rK1VaOXFCNXFh?=
 =?utf-8?B?TlA5OFpLNjJXclJOeUtVbTlCMWZNWmVKdHRVaUpIQ1RBY0NpVFdNUk5ROU1L?=
 =?utf-8?B?ZXNSTUxiRHJaZTJxWmRkRWNUL29rM1pBWU5udXdXcHc1bWhEYnA4alZJVlJy?=
 =?utf-8?B?YnlVMklydzNjUWlQemM5MHVlVmxDQW9CaUdRTUZwZTJyL3RMMVdITXRSM2lI?=
 =?utf-8?B?SjFXYmtCMkdid3ljUHY0V3JDcUtnTGZqU1ltZFpRWVordVBHU1FRSEp5TzM2?=
 =?utf-8?B?d3JTamY5WWRqd2JYN3hKVW9ZNDJ2MUhDWFE3UVE4Q2tvamhqb3l3WlBqS1Ur?=
 =?utf-8?B?ck1MTmxIb3gzV090RE5aaThvZWZJUXBDZWloLzMyaWR3T0RvQjdXQzAyRFpM?=
 =?utf-8?B?bDZLZHBpVVEzaUJqc1pjaXRhZWhwRyt6cGEwMUduUm54TGx1NU5MQUtya2Rx?=
 =?utf-8?B?ajBsV1cwTVVVNkM1OVE5REVkY0YxaS9hd1hFQk1BcnJSWXNXdkFoTHI0dXda?=
 =?utf-8?B?ZnlGQURVZDhiK3RvcU03QitKcHpxVk1YdW8wc0FMVUV6ODhxeU9YZXhTbm1o?=
 =?utf-8?B?OVVCRzZ4S0U5NHo2YnovL00zMXpxZHhjLzFVK2pWSG01ZFpXUERHalNIdnM5?=
 =?utf-8?B?dUl3Rk5PcTJaSHVlUm8rODlGWk9XdmhST0w0VTQvNHJQWCtMSFh4Ui9CZXAr?=
 =?utf-8?B?NFdUTGxWSTFXekVBRzlFZEJnZ1hjdjd2OWdPSGJpam9zZDZmUnRBcml3VTg3?=
 =?utf-8?Q?7BDTjUtQv2y2n9ZW5kAzxYHo3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a204b907-5b31-47e3-bc94-08dd55124f70
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 20:32:08.8759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uAucNMR9RDCEqeXqRHzemCySuz5jaIsafi3XV9+eWN2NJLWGqE2nG0FlIavW2VzrwqPmE4qsaBcS/sg9CD4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7292

On 2/18/25 19:26, Sean Christopherson wrote:
> Never rely on the CPU to restore/load host DR0..DR3 values, even if the
> CPU supports DebugSwap, as there are no guarantees that SNP guests will
> actually enable DebugSwap on APs.  E.g. if KVM were to rely on the CPU to
> load DR0..DR3 and skipped them during hw_breakpoint_restore(), KVM would
> run with clobbered-to-zero DRs if an SNP guest created APs without
> DebugSwap enabled.
> 
> Update the comment to explain the dangers, and hopefully prevent breaking
> KVM in the future.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

See comment below about the Type-A vs Type-B thing, but functionally:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e3606d072735..6c6d45e13858 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4594,18 +4594,21 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
>  	/*
>  	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
>  	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
> -	 * saves and loads debug registers (Type-A).  Sadly, on CPUs without
> -	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
> -	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create",
> -	 * and so KVM must save DRs if DebugSwap is supported to prevent DRs
> -	 * from being clobbered by a misbehaving guest.
> +	 * saves and loads debug registers (Type-A).  Sadly, KVM can't prevent

This mention of Type-A was bothering me, so I did some investigation on
this. If DebugSwap (DebugVirtualization in the latest APM) is
disabled/unsupported, DR0-3 and DR0-3 Mask registers are left alone and
the guest sees the host values, they are not fully restored and fully
saved. When DebugVirtualization is enabled, at that point the registers
become Type-B.

I'm not sure whether it is best to update the comment here or in the
first patch.

Thanks,
Tom

> +	 * SNP guests from lying about DebugSwap on secondary vCPUs, i.e. the
> +	 * SEV_FEATURES provided at "AP Create" isn't guaranteed to match what
> +	 * the guest has actually enabled (or not!) in the VMSA.
> +	 *
> +	 * If DebugSwap is *possible*, save the masks so that they're restored
> +	 * if the guest enables DebugSwap.  But for the DRs themselves, do NOT
> +	 * rely on the CPU to restore the host values; KVM will restore them as
> +	 * needed in common code, via hw_breakpoint_restore().  Note, KVM does
> +	 * NOT support virtualizing Breakpoint Extensions, i.e. the mask MSRs
> +	 * don't need to be restored per se, KVM just needs to ensure they are
> +	 * loaded with the correct values *if* the CPU writes the MSRs.
>  	 */
>  	if (sev_vcpu_has_debug_swap(svm) ||
>  	    (sev_snp_guest(kvm) && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {
> -		hostsa->dr0 = native_get_debugreg(0);
> -		hostsa->dr1 = native_get_debugreg(1);
> -		hostsa->dr2 = native_get_debugreg(2);
> -		hostsa->dr3 = native_get_debugreg(3);
>  		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
>  		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
>  		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);

