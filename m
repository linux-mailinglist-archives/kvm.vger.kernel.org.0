Return-Path: <kvm+bounces-39900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D97CDA4C919
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B64B91762A5
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971CA22E400;
	Mon,  3 Mar 2025 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rv0k3Rt4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB2B22B5B7;
	Mon,  3 Mar 2025 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741020847; cv=fail; b=eWwRh0lUmJuDC9lXphFA1z5Lh+WV6KeY3wkIuhcccm53cU9mz/GatsX6BLN5RLve//WYC3UBQxnMZ3JDPNVYq7pN5FsF4m3AblczuTQwMCqLM8b+zXkbWAYFsal+m7NgEGsYZdJOM2uQ5dvIfSnBHDsvlCiOTEc7+Jbm+AIz4ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741020847; c=relaxed/simple;
	bh=TH8MLH6AJ890HKcy3Hj04gPloOqiIe3/pZR9W0nX/6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rsj4LwNocHvIW98Nc/Q5Btbq7fX7hgaBp2zpI/VDab8YNAG7b56ltmvHvYxxdVHf60+xMdTrvG6aeXDGbX0CdwTfMwrJAVZz0Yfupk4fpq1fTVGGMj6WzibpdfYaVbmWPj7f9mVEoVQF6/YhKEOv7+PORJvv1Zv8QLRH1RWv234=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rv0k3Rt4; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzLBRCT0SwLKWqE8t9TSUgFwYB4vb1Ck0Perp3MpRB6NErHjWyVR/W38MY/7kZPpDfSGoD8t8PXEQoR7XDC4ilVfDEda6JB5ZFvBHRjX40alnr3oGbsURHdW0WZoeyf0XxIpLxjBCvN74ZpDOdBYxrogcUYRp9p8O+nHNIRoZssysRNVA+obXb6m+mwQCoJLazOAdLCpp0tziI0FmcBT312Ws+slGP6I0r2tJyzPYQZSZ+gfHl36sHLtvQav2ArHa9GbX7VmIn5YglcZij5xI6fIuaq3hZdrWfro0mtzvyVtO2dYfAvP2T54iD0iIDOuT+rybn0OjOcCPtdEQdcXWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHzgzfwFFl4DHSpxVIZqsGqZuff3GF9ewNyUCorE7DU=;
 b=OLEA9HQvOBj68hMXzEZzNKVDBXyszQ7CFiGmSYzlHmiRZgJblH5sv2EjKw3Fp+BIsAJT4ASWYnmkMEgI92v6Vcb32czUwbJ7JF/uezAK1pyLxsk+LWIroC1G6mi6/tm8pc+rW5vGp8SicbhXq2sSuWwn4cC/kivrMqPnY1iznQoOsxt6DmNiMvGBeutlbz9fpxIveVCbqcfmjT2pOMchL0jSqZHZoKT8xkEZxxWgdzMT6aUK4MLHKJNCpaoBTrpFkxu1cHMRLwSOsW/1lTGajrn/Sf1r1Q5rKslVehO2LDGE7L1ZjMjYWaxhzA74Gra6Fgl7kG2XCb0A2CutBiMFfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHzgzfwFFl4DHSpxVIZqsGqZuff3GF9ewNyUCorE7DU=;
 b=rv0k3Rt4z5jkg5ju3Lcl1YwECiIv5V9e6G1z/ajNut+WYbloXiOCURvrEqlJIkJtFHdsl5UTFIF/yJtm56LmXUA+5N8siIChwdY69fDRUWrTiA1v7/8Hita4oTQye1Ijm/X7L8speOY4G43Eb0wr/B5UmAd0Fa6H+xUfvgqmJHA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB8155.namprd12.prod.outlook.com (2603:10b6:510:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 16:53:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 16:53:59 +0000
Message-ID: <424fc510-0f80-afa0-4f13-d4d133e81c98@amd.com>
Date: Mon, 3 Mar 2025 10:53:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 7/7] KVM: SVM: Flush cache only on CPUs running SEV guest
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Zheyun Shen <szy0127@sjtu.edu.cn>, Kevin Loughlin
 <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
References: <20250227014858.3244505-1-seanjc@google.com>
 <20250227014858.3244505-8-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250227014858.3244505-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:806:28::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: 35f6ebe0-4adc-42da-eb1c-08dd5a73fea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NktJQ0h2a2YrMXI1bXRjY2huQWZLc2VlZDZoOEJwQ1RGRklEZnA1a3dwRE5F?=
 =?utf-8?B?SERWOEg0MlFDVmphMDVFbkpQQTlnQ0VUTG5teDZEOCswdWhIRFh2dEJNL0xO?=
 =?utf-8?B?ZDZvUWo1VWZJWVFiTUNrdzB4aENkSWQybmFpNVo4WG5UUHhDZHYwUHAzakpa?=
 =?utf-8?B?Q3hBN2p3RUpwQXZPT0NLY0NqNWg0c3NRYnY5dDFQWDNYK1VPUUtaNHhlU0JD?=
 =?utf-8?B?NHVmWG5mNHFnYTNaSFVSQ3lUNExFZWJNTkM0aWY3ZTN4Ky9WNTFHbzFvWG1h?=
 =?utf-8?B?RkJSZFBtNHZ2b2xJZTk0TkRJeHhFQ2NCRFQwVmxBbmFuT3Y1MlVQTFIrdlNY?=
 =?utf-8?B?Y0FaWTVkajJ0NFpXR2R5M3NpWTY0UnkybTM5WTFvNWZIczZtVnRxczlJUWFX?=
 =?utf-8?B?SFI4c0p1Yis0TUwvY2szTUJ5ZWxNdnJpQzR0cUdsN2pDTzlPT3dNRFVVUHE5?=
 =?utf-8?B?TG03OVg2QTdkZUFFYzVFNVkwWStKWHgrVUg2NTZlcGM3dzJEUHU2cHhOTHkx?=
 =?utf-8?B?TkcvdzNkTWZSWnhOUUdnYXM0MWFzUy8xUTlZL29OQWZtWkZ3bGlmSW44UDVF?=
 =?utf-8?B?TFVBRTk5WkZ2VWF5Z3lkWnFpa1NNRnhrN3pEaG5IWmxjUExMNnE1MWVCbFFX?=
 =?utf-8?B?K3lWRCt0OWc3MzJPZVpTYWIwSnlXTjhmUC9CRzV5cUxVb3dUYnJRN2VaaHZ4?=
 =?utf-8?B?djErMXRzUDJza2Npbk9NeTJIMHprdjBSbjFGNmFCU093N25QZTNWc2ZUQnpw?=
 =?utf-8?B?OG5sQzltTnJ0RW5GOW81MEpVWk5rTXJLQTB6SHY4V2ZRTy96YWdpSVpTNjNk?=
 =?utf-8?B?Q2F6OWFPZS84QzFGWTFxMlA3VG5ET1ZZbGErYW81S1NCL3prcEF5cS90b0xN?=
 =?utf-8?B?bzRySklMOEJwVWRmd2E4dFpOc0ppZjVjMzluT2dwREJVZ3dOMHhHanN1NWRV?=
 =?utf-8?B?T1FoZzd4d1hlM0FqT0I0Zkh3NzF1VmVYUUdUTHhBZHUrYnBrbXZJVmNoYm9v?=
 =?utf-8?B?bGdLdnJsOS9iUUNmWHdRb05LQkcrQTgyTk1wS3Mzc2hPSDF2bDFLdWQ3RjNz?=
 =?utf-8?B?RVNtMHN1bitnMGNnNE1RS1lvWUhhVnk2S0FvWGdzMUZ5Q1lIa0V3V3pHVElC?=
 =?utf-8?B?aG5sTnV0RUN2S0ZjNk9yb2trbmIrdXVsVTNicnJOZ3hmVlYyZndabGhNeGd1?=
 =?utf-8?B?VFYxTDZyUkdpazluV3E3OEVCbDQzQldFV05GbkxESEl1OVBFdEdHY3hoT2xy?=
 =?utf-8?B?b3ZsRFVZMzI1L0VhS3M2cGdGYjE0TFFyalNPVFZod3hUL2pXVk9IcjhFYnVN?=
 =?utf-8?B?Y3hqeVJ5eE9aTjR4YkRja3RldUhMcUpPZ0sxTWdpNmVlT0lmcEIyUnBJQVJi?=
 =?utf-8?B?b01CbmxuM0dndS9IWTFKbEJyaUppUGZkdXFWRFZCRzNIQjR5ZVhBREJtVTJU?=
 =?utf-8?B?WGpERmxsK3VoNlNKL0RKVm0xS2YrWFY0N25oL09zTzJ2R1BZb1ptMVk3QW14?=
 =?utf-8?B?YjJqdVVvREdpWEVwU0ZOaFVnQnZudmZTVDhlcGJnc1ozMmh1cUUyc09PbDZQ?=
 =?utf-8?B?T0t1V25vYmxPSk1ORTFjTzMzeTVLVEJrTWQ4QVB0dmErdm5HME1mK0pscnJJ?=
 =?utf-8?B?OUV5UjJGV1FkK3NhdW5XU0E4V1lKbVhDbEFLNWJKVnR4L2hpMUN3RENuNGQ4?=
 =?utf-8?B?SkVDSnNxNFQ5Tk9NWnZDQmFCWWI1NDViL0t6R0RSQ1IvVmRzWjMwVEpScDcz?=
 =?utf-8?B?QTJnVGJIMS96anZYZENYNnVEcUtLeWh2MDE4Z2tRbWt1Qnk4N01udm0xWldk?=
 =?utf-8?B?Q2t4QzRmenJ1MkFMems3ckhEc21OVk1QTk1KS0dRd1QwTFNyWnFOc0JINERL?=
 =?utf-8?Q?UsNzVJGcQ9TTU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blgzczJFdHpRVkkva2dUYmRleUNiWVlSbkllbUdlTGR4VHpsREw5V0hPYTh1?=
 =?utf-8?B?QkZINjBCU0VGTEdUZUVaUmVCVmdMMnlTdFBna3VoblF6S2EwdzBFOUVWbWlw?=
 =?utf-8?B?QmVQSVVvemR1N1lDdlVzOEZ6MlJlYWx5TGpCY2J0bDFReU0zd0dhZFlISUJi?=
 =?utf-8?B?dGJoaXNCeFNIMnRRNFY4cWEyNTZMNHhhYmNXTCtmZHBLcjc4MmF4bnU2eHY3?=
 =?utf-8?B?RklJSnllNGhrcFFwTEJlUXkzd1dmTXovMHNWQWJRQ3Y0S3lUS3N2R1czRHhk?=
 =?utf-8?B?VlA0OHNOb3Y2Kzl0MG9mSEVrVGwyUm5tZVVyYXcraFRzMnVzSjEyV2NCeG9k?=
 =?utf-8?B?cWoyeG45YWc0Q0pzSjZKdWJ2WDFtUkdmb1BreU9SWE9rVml2Qzh4MFN3c3Fq?=
 =?utf-8?B?dUJnVWpzbk1ZcjU1dE5EOU1wT2U2cHo5YldLcm1GUGxUTTFQY1FxWWlPZVFj?=
 =?utf-8?B?VnlLMXBHbE1HelBSeCsyeU1qdU1wZ09sNWJDVW91b2hkbElZdzZ4RzhkNFBq?=
 =?utf-8?B?YmNOQVFuWnR1VWlJYml6NmpNeHJEdWM1MGZvWkpWYlFMMEdzSWF3VjJpd0hH?=
 =?utf-8?B?K3NWbDcvNXdDL21tTDFJWGZralJrTFhMSFR0UWNzSXNQZEdwVHpNUldOM2E1?=
 =?utf-8?B?M0FHcUp0U0xLUG1sbExXMU13MHl1VVZJOTVLbC9RNUMxNkg2TnZiN0szY3I5?=
 =?utf-8?B?Um5jN1BpVldmQ2MvL2w3VmFRYVo0bWpjRHNhL0YrbGhVZC9xZjlhOC90YS82?=
 =?utf-8?B?VTYyYy9VOVM4dlRjQkVLbC81UWpDNjJ4NFBRemRsVUpMMExXa2NvY2IvUXg5?=
 =?utf-8?B?YlNZaFVxYmhDTS9SWWpYTW5uRG5wbVlHK1V1QUV1WEpZYTNaaUhXeHVvNmxt?=
 =?utf-8?B?RHlLRDcxcU8yQW1LdStZbGxlbGRJWVg3RmZhZ1ZPZ3I3VW83d3l4TU9iK1g0?=
 =?utf-8?B?LzR5UFEvYU9iQVVTeUM0dFdML1pkTER3eWdlYldadnNuTytLYWJVa3NwcTYy?=
 =?utf-8?B?RlBvMWQ2Njh6aytaM1VEb21aYXM3ekp2S0p1TnNiQ1pHTWNFeXhsUSt3REJ4?=
 =?utf-8?B?QlV1UTJlQ29NQ2FyRml2VHFSdmpUWGFtcW44VEVnSFZ0aW4rT3FQUWhkbzhF?=
 =?utf-8?B?S1AxeG9RU2krWkc1ODRmcmMvOE04aEJIdVRQaUNVMGRrbE5zWWhFMnlXSHpK?=
 =?utf-8?B?cUlRQytFVEVKVlhySDNLV2ZTZ1RDTlFXVkZwS0RTTUdieXlzVFBDMll2djRV?=
 =?utf-8?B?SHlKL1FzTW91OUI4SWZ5d0hSZUl1eUl4N25OMEhaNGVpeHB4MmY3b0xMbzFy?=
 =?utf-8?B?YkRrM1pOVWhxWmd5YmlCQTJrQm5aRjA2cWU4OTFETkFoaGh6RVJHc29qdFdx?=
 =?utf-8?B?c2k5S2s2SVZnL2xvTGIxeHpScEpTeFpIQUxFRVY4YktZOVVXYXF1MDZPbGE0?=
 =?utf-8?B?S0hsTEFRYkgzbm1nUmE4T0FvMytOZDd0K0xTbDluK01yR0ZmN1RCMVk5a3or?=
 =?utf-8?B?TXNiMjZPOXVkZEJRVXNCdmdPc2RiNFR2QlJyOGJ6OGozamtLN2Z3dm1lY0Mr?=
 =?utf-8?B?czVUeWQ2SWZNQ0d4VCtub1VBYkE5LzNHK0gvcEV4WkNocklaN1NKdHNZNDF2?=
 =?utf-8?B?NnFhbHVCYjJXOWI4WGJHNHk4RGg3bnJrL0ErZ2txUkFoUGgvZHVrK1NkTjVY?=
 =?utf-8?B?bGs4WFdJUEFVcnNtNUhNS3JaZlFQWCtyS1VlbzBGcEdNalJpNFZlenVWRGJn?=
 =?utf-8?B?ejNOMjJES3ZrNWZKRVQ3WURBY2xvVTNTamQ4VXR2bjdTMlN0aC84SlJYdFI0?=
 =?utf-8?B?Y0JKU3ErWmtOYWNpd3JZZEpZUGt3UXh6aEd2WGFZZnhHUVpVRXRvTnNMZ1FZ?=
 =?utf-8?B?QUg2eTVGbC8xQnIvb3JjYmRaVmJSWGtPRmg0Rzg2T1RJdzBzVVFNTUU1QVdr?=
 =?utf-8?B?djd6aHl0SWRSZzh3NzdUTmRtd3hqUW9Jd256VmdMWEM1RXVYN1FVKzdlV2R4?=
 =?utf-8?B?cERQN1NYSjRGM3pxTmxURFJ5UU5LOTQ4cWhlcWhZTThIVEdlQjhOZVdTUWt6?=
 =?utf-8?B?cUJmZmFCbmxvYm9vM2NCcjVNTGFlRjVnUGJrMlZhNXlWeDlnMTRqNzF3ZkJR?=
 =?utf-8?Q?FZx4Ce/G9AdffF5TgNbMLQ+ls?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f6ebe0-4adc-42da-eb1c-08dd5a73fea8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 16:53:59.8220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWHIOkH81jcDNbj03UIqqjHI6kVgozHBQ22zT974PmJRYaJsB0slZEOXWYFb6RKkaFDpNi+Rtq7RKboPP3/AaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8155

On 2/26/25 19:48, Sean Christopherson wrote:
> From: Zheyun Shen <szy0127@sjtu.edu.cn>
> 
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to do WBNOINVD/WBINVD on all
> CPUs, thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 42 +++++++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.h |  1 +
>  2 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4238af23ab1b..b7a4cb728fba 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -447,6 +447,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;
> +	if (!zalloc_cpumask_var(&sev->have_run_cpus, GFP_KERNEL_ACCOUNT))
> +		goto e_free;

Looks like there should be a "ret = -ENOMEM" before the goto.

Thanks,
Tom

>  
>  	/* This needs to happen after SEV/SNP firmware initialization. */
>  	if (vm_type == KVM_X86_SNP_VM) {
> @@ -706,16 +708,31 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  	}
>  }
>  
> -static void sev_writeback_caches(void)
> +static void sev_writeback_caches(struct kvm *kvm)
>  {
> +	/*
> +	 * Note, the caller is responsible for ensuring correctness if the mask
> +	 * can be modified, e.g. if a CPU could be doing VMRUN.
> +	 */
> +	if (cpumask_empty(to_kvm_sev_info(kvm)->have_run_cpus))
> +		return;
> +
>  	/*
>  	 * Ensure that all dirty guest tagged cache entries are written back
>  	 * before releasing the pages back to the system for use.  CLFLUSH will
>  	 * not do this without SME_COHERENT, and flushing many cache lines
>  	 * individually is slower than blasting WBINVD for large VMs, so issue
> -	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported).
> +	 * WBNOINVD (or WBINVD if the "no invalidate" variant is unsupported)
> +	 * on CPUs that have done VMRUN, i.e. may have dirtied data using the
> +	 * VM's ASID.
> +	 *
> +	 * For simplicity, never remove CPUs from the bitmap.  Ideally, KVM
> +	 * would clear the mask when flushing caches, but doing so requires
> +	 * serializing multiple calls and having responding CPUs (to the IPI)
> +	 * mark themselves as still running if they are running (or about to
> +	 * run) a vCPU for the VM.
>  	 */
> -	wbnoinvd_on_all_cpus();
> +	wbnoinvd_on_many_cpus(to_kvm_sev_info(kvm)->have_run_cpus);
>  }
>  
>  static unsigned long get_num_contig_pages(unsigned long idx,
> @@ -2766,7 +2783,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>  		goto failed;
>  	}
>  
> -	sev_writeback_caches();
> +	sev_writeback_caches(kvm);
>  
>  	__unregister_enc_region_locked(kvm, region);
>  
> @@ -2914,6 +2931,7 @@ void sev_vm_destroy(struct kvm *kvm)
>  	}
>  
>  	sev_asid_free(sev);
> +	free_cpumask_var(sev->have_run_cpus);
>  }
>  
>  void __init sev_set_cpu_caps(void)
> @@ -3127,7 +3145,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>  	return;
>  
>  do_sev_writeback_caches:
> -	sev_writeback_caches();
> +	sev_writeback_caches(vcpu->kvm);
>  }
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -3140,7 +3158,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>  	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>  		return;
>  
> -	sev_writeback_caches();
> +	sev_writeback_caches(kvm);
>  }
>  
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
> @@ -3456,7 +3474,17 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  {
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> +	struct kvm *kvm = svm->vcpu.kvm;
> +	unsigned int asid = sev_get_asid(kvm);
> +
> +	/*
> +	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
> +	 * track physical CPUs that enter the guest for SEV VMs and thus can
> +	 * have encrypted, dirty data in the cache, and flush caches only for
> +	 * CPUs that have entered the guest.
> +	 */
> +	if (!cpumask_test_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus))
> +		cpumask_set_cpu(cpu, to_kvm_sev_info(kvm)->have_run_cpus);
>  
>  	/* Assign the asid allocated with this SEV guest */
>  	svm->asid = asid;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5b159f017055..6ad18ce5a754 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -112,6 +112,7 @@ struct kvm_sev_info {
>  	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
>  	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
> +	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
>  };
>  
>  struct kvm_svm {

