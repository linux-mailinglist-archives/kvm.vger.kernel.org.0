Return-Path: <kvm+bounces-58149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 817E9B89B81
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 15:40:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C54193B6ECB
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 13:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE2230E0FA;
	Fri, 19 Sep 2025 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Yf7Bo6h+"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012001.outbound.protection.outlook.com [40.93.195.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AD02C028E;
	Fri, 19 Sep 2025 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758289222; cv=fail; b=WS8kYNkGim64Bq+YHk3GJdWADqhrt9mU2T6LmppeI5LHcjlnVu/HO8b+wXhF+gpoQtSNPLO4zh+Ieb0PoyIOwWOpJRj2pxq/lW/I0Idu+jCWpeEfB2SUepfA0WaV+05Gls69Kx2TsNkiDTaILIHnWzUzosGL/0TKW3j0AxaXXwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758289222; c=relaxed/simple;
	bh=P4KahiCluOPsRuUcO1jYo6OVpESwwjXDzUx+79ZuJD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CDANeodzcTeP5rz4hzrbGMNW48qkAHVpnbhjImf0bX9IGbq7HTNV5yIUWqYpUM1XhIhuZZi01lMNS6f+gjPrftQaFYm0MnvWabr1Lm81PS6EaRuUu9phPVV+Ct9TlzdyAKukfvn6Ouiqq3DwQr5cw6HdTHhE0/bSuxCsMp99m8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Yf7Bo6h+; arc=fail smtp.client-ip=40.93.195.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GpWyBOEW5QhA0ivNu5dUP3TYjpqKPSEVuG4wJojTXhjB3xRJR5nXhRUn4e6SvYF9j5sIOM6jEBvc7W0RLcbOOq/ajE81kFQ1zNl2uPCLKarvzWvxXAUS1Wr7God1O3y9zcczNvFKuwDGePPUi6DzurtqVKwU1i4rkMdp2m2eAqcL/G33Yig+dE3HsSWe4iM9i4VMSzb4R7CQ3JYU41FTnpXGYLs17nBNq5+tT2XgTzDc4V5IZoeKDZjgGFdCmXLqID5GXxhgBEsw7S1crAt/JdPmBlLSNXDGtUgFOqiSAaOFfa5s6QKrLnvLFIIjWslNNYNwfOcL+gjJ05EHBZag9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkLMCuuuSZ1l294YAsgYjgcKSAVkkoY3AiX1CTaXiUg=;
 b=hDi3OVDc5OknTwZQcvlwzFTbvaRkitlE7p4JjikztDca4LaMLOOfv7n7oba1QOb9EW+PBIKVTD3sy28jxpHw5/7PCZsUOmi5xPNPQJLW6GxUeuNWR9RVdHwAxPERdLsWdMJE35vgE9zwCLxpszoggcbFnR5WG7XTpY2OwJz7ng5wk8FjOcw/nni/JLLRFvbuX4HJtmbx26X/A0JnzpGh0t0Gtk+tMek516SxVgu7pCFikxUlA29SF5jP/jePefWe79hVzHGLkImqU95tJ3+Onrzohzc0CPSpPMMrTggbng0cFpWG/sbpNC/14Zixi6up+ozAgeqzByj8jrPd4+IN4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkLMCuuuSZ1l294YAsgYjgcKSAVkkoY3AiX1CTaXiUg=;
 b=Yf7Bo6h+4bkApH9JIA64xJQq4xNtQgXe6mghVhyVXYuhxV7Nt7D4zCTI5ny8KnsP0N10utCYFXLjU4bGIrfJhYQPxu1MWFTAYWG0rD05O+vazmMCifmu5QHmbfvjXG8X8epQN4ZzwpbWTApLFBgz8PYV4icNhuQkAl9pTHr4nLs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9235.namprd12.prod.outlook.com (2603:10b6:408:1a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Fri, 19 Sep
 2025 13:40:18 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 13:40:17 +0000
Message-ID: <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
Date: Fri, 19 Sep 2025 08:40:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
To: John Allen <john.allen@amd.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "minipli@grsecurity.net" <minipli@grsecurity.net>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
 <aMnAVtWhxQipw9Er@google.com> <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
 <aMnY7NqhhnMYqu7m@google.com> <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com> <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com> <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:806:27::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9235:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b2fa16-d420-4006-9eec-08ddf78211df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3pta21TZCtyL3dNMTdRcjhjekJPVVBLcS84am5aZjZtUkxwR1hRczRFMnY5?=
 =?utf-8?B?dEs1N1ZnRlJ6NzhmU1NLOUYxQlpSU2p4RnJIR1FRUXF3dHk0Z0pJVndvRWJD?=
 =?utf-8?B?LzFGakZaL3U3Y3NxMGJBOC9EaFJiTnB4NTBhYlpENWRBeURVMHhCLzdUck1Y?=
 =?utf-8?B?WkgvREtiTXpVSnVmRHBVYUNJMVA0VzNWNTdNVWJkaElBbEJNVWdRZjV1czE4?=
 =?utf-8?B?bXBBNW1FYllKcG1jUFlJZ2RVMUdoRll2SmhyZ25yWCtlNkY1NmtVTGx2YWxM?=
 =?utf-8?B?UG5Tbnd1Wm5GMHFFelRtbVZzdWxRSFVCdUJVOWR2bG05RGhaeG1JT2RCOWhB?=
 =?utf-8?B?S3BHYTlLTE1NUUJQbHEvb0E4YVdNNzdER0R0Q25MQkVBMmM0SCtjMkFjTDBJ?=
 =?utf-8?B?djFieDZFemdiL3Q2UUVVaFppR2dnNXBzUEJ1MEZtZytsQjdWcGt0UWtyOXI4?=
 =?utf-8?B?NUNScS93T0xWQzRDaUwyOUpqbW1WdEN2TWpJOHhhb0FVbUlha0JBVUo5NEo1?=
 =?utf-8?B?RUptOUFaRTFLZEhrSXFNaHd3YUxNY056a3U2VkYzbk4xMUMyZktYc1ZMeTFT?=
 =?utf-8?B?WURWV0dQZXpSclRGOWNaU0czMDRCZzdXZ2NWYjVFTFgwRFVxbEdVK2lGcnR5?=
 =?utf-8?B?NXhQbWIwZUFIOUtuNUxnSEh4VVBrRFNqOCtXeFlMVlQvemluVzRtOUlGZlh6?=
 =?utf-8?B?NG1rTWNMajVGbEFjdkFPUVAzWFE1ZnkxbzhZQ2NKY01xUDJpNGxid1RZQUs3?=
 =?utf-8?B?b2FVYXA4TlhRSlFKVlR5dERvWnAvWHNjS0NPVGJMUUpiVFFkOUlHNVp2eWhw?=
 =?utf-8?B?SStHN2x2ZW42U25UWUVMNDlHYUx2MitsKzBIZG40YTIySUdqbHZWdGRYaUZI?=
 =?utf-8?B?UzQycCtDWDN5TnJCWWZOMEl2Z0hCUDNSTldIOE1NNEtodk9aMUlWTjJrTHVl?=
 =?utf-8?B?cnRxUnBxS1VzRWIyRlpqYkw0SGtDN2RjZmQzeXFuajJQc21BV2Y0NjMxMk52?=
 =?utf-8?B?QklJd0pIbDlWVXFIRDdjck5uV2c0QzRxZ1p2MjNNN0QrT1c1VTJZR0ZqY1N3?=
 =?utf-8?B?VXozZGFwekMwK01kV0Z1a0xhU0MrNlNrRnNRWUZUL3FSZnRHN09iWVNmZDYw?=
 =?utf-8?B?MVRGS1lURFB3aUVicCsyZUVjemgyOURlZEpzNU41TE0rR1lMTEpRcjhQekdm?=
 =?utf-8?B?MDJNcG5kbEM5YnVFb1dlb1RPRHJlTVF3bnFWTEI2YzhicHRKd251RUdMczZs?=
 =?utf-8?B?Uk9CRFcvYVRNblJvS2RZNkUwUDdldXdWNmVPbGcwNVRpMGk4bjhIQmZoTmdK?=
 =?utf-8?B?TFltSVNNQ0x0U2lWTlNuVEphbXRXRTNibTRJSmtuTUtRY0xvVjBERU9UUW9R?=
 =?utf-8?B?bGhkSEpoUFQxVEp1YzhBTFdGUVpCTjJUc2pURGh1VEgwSU5IRnRnaTk0N0dX?=
 =?utf-8?B?T3NUTklWZzV1bGdEalRHa3VONHcyd1l4YytHWHZlUEw3Z09GaWk2dE53dTgy?=
 =?utf-8?B?NE1OWFNoNVJiOHFiQktFay9MRzJ6Y1U4V2ZRWGdqZzF0b2crdWZOMFhZV0Yz?=
 =?utf-8?B?dlh5ZS9Jd3FkZk5TOGc1S2JpTEhhQzF3SFpYVisyV2NhV2ROVER3VzVSVFZT?=
 =?utf-8?B?SjIwM0JMSFpsSnc2bEt6Yno3MlJRZGJ3SUJMRXhuaWlsM3h3N0pBbWxGSS9i?=
 =?utf-8?B?czltRGRBNGlsSHlLR2NFWlhKcUtEdGZPNlRBY3lRbTFrcUg3aU5rNXBoOUwz?=
 =?utf-8?B?NElkTHRwbGlEd3RqbU5lNldueDZBY3VXZ25IcHlNLzAvNnptRmVGZWpnS3o5?=
 =?utf-8?B?dFVpOGtpZlNmMUJnL3ZZL2hBL0d5RGgyL1F4YzEzcnlJN1RiQVExODJYN25F?=
 =?utf-8?B?ZHoxb0k4UVVpTEFuVUFySXcydzloNlpUeTk5Rk1KdktJNzY4ck90S2FtVEtQ?=
 =?utf-8?Q?0d32AbnGg48=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NG9pM3JhOSs3ZEVKK200R0twdWVkNGZzTDZlU0I4UlRoSXI3RVRiS0kvdHBp?=
 =?utf-8?B?QXZ0alhMVFRPUTJzRkxOV3JvSjRmRHhPNnBkV3JMWHJtNGhCcUJtcXRrR2Y1?=
 =?utf-8?B?bDNjWDl5OFczZ21pMDI0MmUzT3VUN2FsNTNGLzBVYjI1dHBEZitXS25hSFlI?=
 =?utf-8?B?ajFnZXFuQ0pRemc4U1IrWUNwS0pqQ2VadGZER2R4N2w1Tk9pQm1qaTFuaWhz?=
 =?utf-8?B?MnpuczNWNjM4VGtpc3dRM281bVh3UlprbkhURkZyY3VzdnhwOFRSY3ZjV3kz?=
 =?utf-8?B?U04vaUY1akM3R0Q1UzNVTnZuY0hCWXl0WjlVVlJ1MVVDMFkvMjd2VXNUdExF?=
 =?utf-8?B?ZWdWOWVjVVN2TFdVSVpCRWErUVhwWGllUnhHY3p4T2QvSGpmeXk4NUdxdGc0?=
 =?utf-8?B?M1puSE1rcVRQcGxwWXo5YWFhbmtKb3VHbUNvamhmd2JpdzhZVy9PUWw1ckIv?=
 =?utf-8?B?K21oSTAraEFDSEpQSGcyRzIrSndNdWVJak1uK3d4T1B1dk5XOEZ2R1BkbFQx?=
 =?utf-8?B?akhyb3ZOYldPdXc1YUs3S1JJcWNUSDBrTS9GZlBNL1JTcFdGUHpyQVBBNndz?=
 =?utf-8?B?QkpPbHhqVEhZWHJ3bUc4M28zcTREQXRtSUhCVVlMU0ZmdlU5emZxV3lZRzFt?=
 =?utf-8?B?K2Y0MVZFZG54SFl4RllKSVYva01LWFhOWXZuOTBDdTN5OS8yRXVGQ0ZRTml1?=
 =?utf-8?B?VC9ja0ZIbmpLZFFBb2tDRHlSWklNeFFMM2pHeERhM2EydEE4WFF6YW1MR0NX?=
 =?utf-8?B?andmemh2U0ZZblByT3hBVDdxd2U0bDFHajRqRm9WdDkxZkRvQ1dOY1FtYldi?=
 =?utf-8?B?aEs1U2R5TVBkelI4Si9JMkhXRktCTHFKM204WUpHMjAyYjBGZlkwMGhrODNj?=
 =?utf-8?B?QlZPbjBYR0dRU3B2aWlCUzY1clhZQ2NHQjZ5WCtoWkhFeHI2TEVYalcvM3BE?=
 =?utf-8?B?STAxN05IbGZXNmF2WEpRZlhDYVkybTVoQVZhcXB0eWpRK081VlFwNm9vRGYx?=
 =?utf-8?B?dDNoTHNUOCtveTVzYWNRVWlqS0JTM3kxWHdzblIzbmEycmhBa21uSlJRU3Ro?=
 =?utf-8?B?Y00zN09QR3BYVkVVNTBySlN2K1VOcmxkSUpCNENKWS9VVDNFUkJHTGdRdElr?=
 =?utf-8?B?R0NJc0RxWC9NdHZ5U0JQMUFHbFNrOEhHellWVVF4SUpDZVJwRGlMbzdLRHll?=
 =?utf-8?B?d3hnQTYwbWdRWGJGMEk3TVBycnQ1K3BJa1pDWitCRTQ1WkEraGVhVGpscitz?=
 =?utf-8?B?elRyNzJxcHZXUkpJdVFtMy96bjJYcncxR1pUcHVOVUxneXF3OWZ0SkxmR1Zz?=
 =?utf-8?B?ZUtaOS9JcFU5aXRFRmlucFM0N2NhTWl1S2cwRW53V0VLaHNuSjhrUmJOcCtT?=
 =?utf-8?B?VUxrbmJFSGhRa0tOYVR5OGdjQkRxaE1scTdkclBBak02OHp0ZTFWeFpPK2lu?=
 =?utf-8?B?Ui9XV1ZjQmJ2WTliU040aXRtcWc3QndTcE14OWNxbDIwVytoVlRaWEh5ZU9X?=
 =?utf-8?B?VVNyRVdubHE4Z1kzZXR6dmVSSSsvRWFtWlovOG0xRXZCZnRZVjQvM2hVSHg5?=
 =?utf-8?B?YzRCUFJ6T2FZSGN3c1p5RUpIU1RIcTNIRDZydTdnNVl1elQvVVNVaUpGckht?=
 =?utf-8?B?Rm1ydTNDZlBSUDlKSUhqSjI2dDVPNnNOYytVSVQ2am5PK093VzVQUmRFa2N5?=
 =?utf-8?B?dTJFcHVPTUMrVG9qRGNsNUlJT1h0cE5yQ2NXc2RyWnp2YVlqd1Z1c1RVTEhh?=
 =?utf-8?B?VnBoL0RJVWtxQnBNd1drQ2o5U1FFOWpQbGgrNTJiaVpLYmI3RE1WODdkY1Jz?=
 =?utf-8?B?USswcDVUM3VvQzlPemlNb085ZzlrMy8zbERvd0dLdUVicWhUMnp1VFpOeG1D?=
 =?utf-8?B?eE5HODdqTGhMbjJQUnFGRjEzc3djSlZWckYyOGhodVQvYncwd3RObmJYQkU0?=
 =?utf-8?B?a2lkSWhuajVWVytxamlza1NoR2xFclZVOTlFUlovYjlBQVhBTnpGNjQxc3VP?=
 =?utf-8?B?NjdhMDdrT1lSZEVwa01nS1doY1RXeFh3QUh6di9aZUx3V2c5bE9haVE3MFVm?=
 =?utf-8?B?cmsvam9Od0NVYTdUZ25aZTFjekppU2d3eUhXdTB1RlNsTkhZODdqTkZ3eDg0?=
 =?utf-8?Q?tysgM3jqBrJPsZxaBREED6iYC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b2fa16-d420-4006-9eec-08ddf78211df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 13:40:17.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFwRePM6uy2vdO3e2k+6d8uHa3xYZl3XYfUATLHV/t7vhokecfiG+o53HYUoImpVCYCyF3MNpjPGDl+Abzew/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9235

On 9/18/25 17:18, John Allen wrote:
> On Thu, Sep 18, 2025 at 09:42:21PM +0000, Edgecombe, Rick P wrote:
>> On Thu, 2025-09-18 at 16:23 -0500, John Allen wrote:
>>> The 32bit selftest still doesn't work properly with sev-es, but that was
>>> a problem with the previous version too. I suspect there's some
>>> incompatibility between sev-es and the test, but I haven't been able to
>>> get a good answer on why that might be.
>>
>> You are talking about test_32bit() in test_shadow_stack.c?
> 
> Yes, that's right.
> 
>>
>> That test relies on a specific CET arch behavior. If you try to transition to a
>> 32 bit compatibility mode segment with an SSP with high bits set (outside the 32
>> bit address space), a #GP will be triggered by the HW. The test verifies that
>> this happens and the kernel handles it appropriately. Could it be platform/mode
>> difference and not KVM issue?
> 
> I'm fairly certain that this is an issue with any sev-es guest. The
> unexpected seg fault happens when we isolate the sigaction32 call used
> in the test regardless of shadow stack support. So I wonder if it's
> something similar to the case that the test is checking for. Maybe
> something to do with the C bit.

Likely something to do with the encryption bit since, if set, will
generate an invalid address in 32-bit, right?

For SEV-ES, we transition to 64-bit very quickly because of the use of the
encryption bit, which is why, for example, we don't support SEV-ES /
SEV-SNP in the OvmfIa32X64.dsc package.

Thanks,
Tom

> 
> Thanks,
> John


