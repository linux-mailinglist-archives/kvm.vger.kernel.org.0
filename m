Return-Path: <kvm+bounces-19288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC059902E31
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 04:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ADF3284E5D
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D19BA45;
	Tue, 11 Jun 2024 02:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mqvnjKrG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055EAD21;
	Tue, 11 Jun 2024 02:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718071568; cv=fail; b=r+sVXSZBuxiWjHNb9o3vldb2+PSk0P86afBIzTFxmE7FuC/+WL3Fwgh5lI9ipDjqkePKJSyDQtJN/wWWc15tQgOtUNeB9qCdCIX2JmCIMNK0hiizG0GaFemCTPFC0WtEC0lTAyRa+2ldT9fEENgYQDRPy02QK77SXyiMF4yhhmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718071568; c=relaxed/simple;
	bh=vwAw/JDkeroc5Xf2NNRHz+G46PtWj9RhtAGgVeKa8pw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aLcK71gHXzro+/v0Edlt0oxPJbKzSNJiqhW2MZ8hdQWg5So+SKfnfKjZQYgE5OqhL26YHaKt5rI3N2rD2oVnBSPSW17sBy7h7mW7RseFugpjGxvIe801tYsb3IlRj8xnAPHAkEWNTh+zK+zsLBE+DlxWymYSLGMsXjIm7Xsldl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mqvnjKrG; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718071567; x=1749607567;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vwAw/JDkeroc5Xf2NNRHz+G46PtWj9RhtAGgVeKa8pw=;
  b=mqvnjKrGxzmPyPD0LF1LU0LXQsXolZFe5YzR5q7O2tn/EoYk2nK9vKbV
   9smDJAGaid0RcqlFnrr14iwxS/dPPrydBm2wXPYl05aF8ZrdeSyPb0djm
   jpUwwo7F2eUhMQzv0lg0w67zLFfwH1zGuPmzkfzuiRsshQQ6OTuiIwrOx
   ZEDeU7el2Eff43XpqQL/Gf7xQXLeGRYEcYVtBkL8+cfZtTDWR2kD4QKGz
   jKBQYJiOlqShKjwrz7X/W2n8mHvsReuUcPA2pCGgFZGHipe2o7XdI1mDu
   GzgrQj5LJ4U/CT6Voq1SiwM5tMtWy4lTNpOY7W6b0u1HgVs5kmlNvVjyD
   A==;
X-CSE-ConnectionGUID: LsPURc5bS3+Ke3Gy/RLzxA==
X-CSE-MsgGUID: n9fkHV7pRK+2aCnnA37seg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="32244767"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="32244767"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 19:06:07 -0700
X-CSE-ConnectionGUID: oZKZkmHwSDaY7bTFT5kwiQ==
X-CSE-MsgGUID: Phx9oLifTdeZzcVt5rTtrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="44394288"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 19:06:06 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 19:06:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 19:06:05 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 19:06:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpxW2gOh8KSplwxNTZ9hTtPN7LTmhSNFa+vojxqu0EPXShmy41UtDKxfDHA3sJHLWIuCS/RJ1Ih9vBNR5o7oGyr7O5OFM9DeyHfiHrkqjb5IA4vulWwL3pPf7Ch4z19hBsCWIexmC9OaTJd3qQ4nge8ieA6KpQRxP66XGPTYucgrwJeCN2/L8+TnyQ939YGhxHIpeiLy5nDZPW5GT52hcmqCEwVCpIdDFiSESthGe58PFqtiRzzAgPB52vHtBC7F173B8R93ZODll2N4oaW/yLDdBe1s6NsFcYfwE2wGGWL1rciPn1QAt77pbMeF68Wlt0gc6veDdbVL7fkR7Lxntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaYPCrcI5sKk1qkmNp0UCD1iMkwHuKIwkYwxvMypfPo=;
 b=f+8xKnm1JG4UmIEGOZFAtINFZoeoPypF3J209P528lmLqwPogqiEHeFI7Xp0gpOz1eRgqZRpXxcXn/5mZoxeu/AN/jm2buBfWEIlmCfNuOF4tV7Cuxb3YX1KM8Ym7iItz62IcDTp9fyfMoxDkuCzUPX7DzivRwzubV22qHxtKEkDJaSr8c3EfOGRrCPZayvcg/iwwEySyMrwPdG+hkwFX/kRkuqrdIudk+htPRDx7oVnSaUI3w/lUHVeuRGkalsooZDOJXz6MHf+w4F0XXkjwDQEDYIhwLAvVN2uoujh7tyh2j1IyqJEAZEmTwC/uU61B1FPy/xVjIy4XeUB4ggQGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA0PR11MB8377.namprd11.prod.outlook.com (2603:10b6:208:487::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:05:59 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 02:05:58 +0000
Message-ID: <32b8a82f-d65f-4c4a-8cfd-e69eea5e1efe@intel.com>
Date: Tue, 11 Jun 2024 10:05:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20240509075423.156858-1-weijiang.yang@intel.com>
 <ZmeijsBo4UluT-7M@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZmeijsBo4UluT-7M@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::35)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA0PR11MB8377:EE_
X-MS-Office365-Filtering-Correlation-Id: 3082da71-254a-4c11-c287-08dc89bb092a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnV2RHNGQnRlcUNGRklOb2N4czVnMkVPYkdkZ0lVZ0pnSmN5dHFtOEhHdzU3?=
 =?utf-8?B?VlNITVZSQTd2bUlkOUNSVDNlTCtTWVkrczFwWXZBeko1Z2JycDNYdFFGV0U1?=
 =?utf-8?B?SXhYSTVDbUpYUmtNTWNEdGYrVStMRHBYd0VRMDVXMkRod3dwY0xDdm9RTENS?=
 =?utf-8?B?QmVoeThZK1RlN2tXUmNZVHRVZC9NcEluK2E4b1JiQys3UDd3Y3ZiT3RRT0tM?=
 =?utf-8?B?ek1UL0RRVGtiQjVOcDV6Y3VsUXhGejYwWnZPOEtTYjZnWUQySmpGejd1eUhw?=
 =?utf-8?B?aVBFN3ZnOHVaOXgxOURmWG80VXl4VnNPcWxpdnNNVzY3bEQwNFVtV251ek5l?=
 =?utf-8?B?dk5lOVNGbHVGbktZcFY5VUc1U2lMSWc3K2k0OEVCa3lvTXB3Zi9sSUFVYmVT?=
 =?utf-8?B?eU1UODlpZW1icC9LdGxxSHVVN2h3NEhwOEsrRytPRkRpODV4dFl4RjRXRVNn?=
 =?utf-8?B?b29QVDlrN0FHbDBCQlludlRIM1ZkNmZTQXdBZ1ZrVXZzdWY0c2dYV0ZiMmYy?=
 =?utf-8?B?VUtDcXdwRFhGRHExUzlWa1VJK3hCSFNHY0MwS1pQM3U5TlF4UGF0UHhSeHcz?=
 =?utf-8?B?MmJvbVViaTJ6V1JNSE1PREVLNmlnempKTktDOHVwRjIxeE1YVloxaVVUV0Jo?=
 =?utf-8?B?bHgzNlJuaVVSeXNnR1o1dTE5TTk3aklkQUE0OVhkTEJwajA1TGZFbnVoMnph?=
 =?utf-8?B?eW5ORWE5WW4wdzc5TFFqWURYeXl6MjgzSXZxQ0M0MkFhRHlLMDJDT0tNRHFt?=
 =?utf-8?B?bTR4YVZBNTE0Z0JqT3NWa2YvQS94Ty9DQlg3bm5FdE9na3Q1UXB0TUEwL0tu?=
 =?utf-8?B?T2JDK2JTQTZFSlo5WEcxTXhaVnhjZG5xbWVzcEppd1htWjhtM0xMaHNENzVC?=
 =?utf-8?B?OEw1SFRtTkhiT3dLRzVSTXdCMHkwN3l1RlFWRmlBSTMyREhLVTErUndESTky?=
 =?utf-8?B?NGprZThaZEEvcnBrdm8xVDhwaEdZbnVJV05xVGdKSmdsLzVGMWE4YjN6d2gw?=
 =?utf-8?B?NFd5OFdVSlRSYm53NmhUSGo2QjVvemtsZXdkOG9Rbjl1a0ZvT0lxR2tIclpY?=
 =?utf-8?B?aFBKNXdZMU5UdEpSQW1BZ21ZU2lCNDZuSUErb3hwN1JaWDRBUE9GU1VTRm0y?=
 =?utf-8?B?Snp5c0NIcnJUZzhERU9uK1FkU1cydDdNYXp3QVNPVTQ0OW51d1pLNStTb1Rl?=
 =?utf-8?B?NWZjd0xmYU1wTThYOHhtTGxkbnVYRXIwelBNOHFlNlRwYXhRVnFiNlQreVBi?=
 =?utf-8?B?OUtnNHNsKzlNcDllRkNISmVSOFQvTFc1MzBZeXpOazhBWUxkQmFWUlFkb0da?=
 =?utf-8?B?cjFpM004RkhHZzJqd3JTako1Wm9tUElYZm1ZMG8zaGRlQktIZy9IclUyQ0FU?=
 =?utf-8?B?UGI4NFM4Z28zV0RhL0xSaE5QaHNVVVJUblUyNWFLZkZnQjNyajlXNFlSNU9y?=
 =?utf-8?B?V1JIOW9kMTROcU40aW8weCtnUy9qNTY2TGRSUjZJS0lDV2V3M3FCSFVpNHBZ?=
 =?utf-8?B?NGJnL0JOTnVBWXMwenc2RXdBaUJBMUxtTFhDeFVDL3M4VWNITXUwYjhZb2hm?=
 =?utf-8?B?Q3U0MVpINmkrQ3VGTy8wK25XcE9DUERoNmE3NUJ4dkpOT1VxUklIb3oya1RL?=
 =?utf-8?B?d0xyaldQcS81MUVJUEp3Y0E0ckY3Rno1NjBSMzNSaUhtRUhxeUlicnRBZzgr?=
 =?utf-8?B?RjVUU2VCVGIyOGJZa1FvWExQNFdEcWUwUnU5MnVzTCthRmFNeFMvc1ZNQ3hL?=
 =?utf-8?Q?F3xfBtRmqRQ5odYqWnDsTAcEepQaKppAF1/tzdd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V25kMkY4VDhIVzBlRWpOZjlKYkY2QVl1dFoxUkY2bjVQVTM5UyttaVM3NEZw?=
 =?utf-8?B?SkZweEhTTXJQaGVZL3VnY2tFOVpEamVMQkQwYTFTRkVMUHZXUjZHUElOeGxV?=
 =?utf-8?B?Nit0VmdFSzVvWHh5bEFMWG1KMzQ2dmhmMXZ6enluK3R1OUN4bWwrUnFUT1M4?=
 =?utf-8?B?WjhmQ1BUQ1VRRjVXMVJCQ1VDRWJ2NSt4aENvQ3hVS1JpdEZoeGd6ckp0bVBV?=
 =?utf-8?B?V2VvMWcrU2E0aFhYL3ZMdld3THNoUkpKcVBBRGN0RmsvTjRzMnJ0blQ2cW9s?=
 =?utf-8?B?b3p6MUwyNnlwL25PM2NCamwvTkNIakVSQ28vTTVNRFBvWWJ4cWZqYytiWGE2?=
 =?utf-8?B?Q1ZVUzRFbXhlMXpwejRuN0xTZWZZOEtwaFBjeW0wN1ZpM0tUbC82UVBOT2pv?=
 =?utf-8?B?a3FpTDNFZjl5YXVaY1pQd01rRTVrVGZFS2ExSU44Zm5ZZUpQelBZZ1A2WTFv?=
 =?utf-8?B?ZEVlVkFMMC9id1E5eDgwTGxyL3FKbW1vVzU4ZHJ1MHFEUmF5ZS81NG1DZlZJ?=
 =?utf-8?B?UGxRT3BCajJqT0I4R3p1cyswcEJDMWIyU3FzSXl0TGVhM2EwWXo5R1VQaEJD?=
 =?utf-8?B?MzIyN2Y3UXlWMGl2SXVuWVFkajloOUZ4L1FrTEhuSTcwbDVNc2pSdkZLV0oz?=
 =?utf-8?B?SGZ0UEp1dVRmVlM3N3h5V2o2Sk5MYkFKVHk4SzJrVFRBNnpKNTNGTm1wYU5u?=
 =?utf-8?B?citiTkJuYTBrMk8vQzQvS3NOTFFRQ2NZT1lUdWdaRVFndjVDUkQ0dzNFdU5y?=
 =?utf-8?B?WWhhTWN3YW0wS2lzSVdSMFFBckFnTk0yd2tua2JiSnNpc1hhT25kZE9TY2NB?=
 =?utf-8?B?ZHlvL0l1MGs2WFRHRjRGNGhkNHpvVW13YkY1RHVHVERITWxEWjdyWEhocjNY?=
 =?utf-8?B?WWp3bTFuaE03eWNzbTlpaUgzckdaeG4ydHY5NDNvdmU3QVFUWHpWQTZNTU1J?=
 =?utf-8?B?aTBWNko5enhUMWtWWHo1b3QwN1QrT2hmRjBwc0ZpV3pWVW9JMnA3ZGd3VGxr?=
 =?utf-8?B?N21IM3dQc1cvaFNYV3dxT2pUTXdjckZLTXkwQTM1V0NXOTMyWHBwWVpIcG9Q?=
 =?utf-8?B?Q09XM2dzaUJJV1hVYUlGRXhVNzdCZkFET0dSUzRpeS9IUzdrVGdtSnQzenhv?=
 =?utf-8?B?M2FDTHAxcGh6ZVBtSlRZQ0NpU1gzU0FEWGRNRTBKSWFYRVdLYzR5R0V5dEZE?=
 =?utf-8?B?bTY2L0pSRU1iYW9FQkNybUlVSERVVit5Y3I3WFBYdDlJVnJJbEFRR0lhd3pM?=
 =?utf-8?B?NHg1bkJ1OEozVGxLVGdJRS9tbGlCSkZUQ2xqd3N4cnUzMDVnbUlLWEt1aDh5?=
 =?utf-8?B?K2FVVWFZdnNiNkVhSndkNlQ3RE9UZTVFaUlPUkFBcGxDNEtZSjZYRkQrQ1Ex?=
 =?utf-8?B?RjN6eHN1V2RMTE4rNG43ZS8rbXhWcVE2b0U0NVFOTkxQUjA4dzVxOFFoQnV3?=
 =?utf-8?B?M2dPQWo5NnBTdDdQdGc1YTNueHNkQkxMdktTUjJDR2pGRG4wUEFhSStXdFRX?=
 =?utf-8?B?U2hjWmwvYjlHRVFBN0ZZblZsYkRlMXRFdkRldEVhR0FTTWNmR1FhazE4bDFP?=
 =?utf-8?B?U2JaUCtKQllNUGlOY2E1NThoZXVOcGJFNWpXU0NuUlFMVTNySit3RFBNOGZO?=
 =?utf-8?B?TWNaendDL2FnVGdwUnk3YWpvYTU5SEp3RFpja3BIYWV6dUdrR1FBQWdhYnJ4?=
 =?utf-8?B?c0Q0dUtqendHeU0vVnYyTitXRHVQalgyb2w0ZjQ4VDBWZHhXUzMrT2Y0cjlj?=
 =?utf-8?B?SThzZjZpOGhudDAyY2p1U0RlZHJtNjVNUlh6TENjWTVMbStGc0RxNWViYWsx?=
 =?utf-8?B?bkdtcGRoclFjdTJPOXQwbE1ibHRHVko2cXNqeTBaTXZ5TGgxRjFteVN0VXNM?=
 =?utf-8?B?Zyt4OGZoWmVNSS9XMUN6MHdTOFpZaTFPRXd1ZlpHYVJrRWY1R2lFK0dNOCtk?=
 =?utf-8?B?d2owM0pZS2JZdE1tSmR1NnlrWjd1VXNjZisrMHRDZDNtcVJDbFhwYnczQ01H?=
 =?utf-8?B?em8yN0JNZnVCVm1zVmtCaDF4SHNnNTY4aTY4TkFIRjQwTWt1U0lNbmF0M1NN?=
 =?utf-8?B?b0drVUNnWFZBVmRXVTNyUGxzYzYyODFhSG9RMmRvT0ZWY0tuMlJXUGtSaStq?=
 =?utf-8?B?by9aM2lSazBwbkoySVZUaVVSbGNXcXZDVmw0eWtBOG1XbWZ0dmxyemYvd2Yz?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3082da71-254a-4c11-c287-08dc89bb092a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:05:58.8883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+QK8MD/5KRbdrqnxF+WDjSrOVxQLlVu0Lv3WQacyvFqcB7yJnncFx4yObppuvgJnVEkxlPSCKcfdb39HJ9LTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8377
X-OriginatorOrg: intel.com

On 6/11/2024 9:04 AM, Sean Christopherson wrote:
> On Thu, May 09, 2024, Yang Weijiang wrote:
>> @@ -5859,6 +5884,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>>   	}
>>   }
>>   
>> +static int kvm_translate_synthetic_msr(u32 *index)
>> +{
>> +	return 0;
> This needs to be -EINVAL.

OK, I'll change it, thanks!

