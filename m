Return-Path: <kvm+bounces-21325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 654B392D74A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88DB01C20E52
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392CC195B33;
	Wed, 10 Jul 2024 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmVtH6Kg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B850B19581F;
	Wed, 10 Jul 2024 17:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631700; cv=fail; b=b7xgpgft2AwKHvMcnjEI2IVu0JVy7gpKcK6lpd9slKluPLQoOB94mqfqLXjqgDCmTjYl78zBpJPQKJSr5Esvt0SVTajyIKaoybg7zrVCIsGW8QGQimUifz74sEyMpxBN4hnMbSt+Auf+AdghhnYgZQ+wMVuKKgWOzpfIAcx3DQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631700; c=relaxed/simple;
	bh=nuQHPwSJ8czNwzcvIepro5Nw2F8PdFeIFJlT+HroZh4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aplLf6gxgOxlu6Q4cTAv4uaTLFz93c+Xwzm+fWiHz+y1MgoirciHeSUOyMDYdpmz6qBFgcgnpXblrrJs2Q+L8zfuxCMCctbXJnC5izxgsCVNsKDQorCtfuE5q28u7axAdcMNYBwF1SC5gNisU+djxIDPuuT43WtAW/XOPy02OkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmVtH6Kg; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720631699; x=1752167699;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nuQHPwSJ8czNwzcvIepro5Nw2F8PdFeIFJlT+HroZh4=;
  b=XmVtH6KgmDCfkmHZDmSsrwXlnmG9xQmXUAB4XArFNLraSthNneLQEByr
   vfDQ1MPJehgCNvhg4sCECwkhjfNzsxBe5rzcOzPMHRbFPx1t6EciZkhoN
   d+/I1i7N4vbAchIC1bFly4boSFbvLg2SbI2js7/jAb6X46gofK0JCrb66
   gVjBpj5wnunuWnrodwS2FL4+l0dxWiVw6p326RAMYW5PeeyOjRh14Jey7
   SbLdLRXibxy8ah9jaFMPnqOL6qhiUAehkWQYhmwnqAAzgtSXJJ1aXf3CL
   9t9aoV0dX2+Dbtklt3wI0wxvBjpi3RhfCL7H8m3TXcxHdbK18o8wxNuRs
   g==;
X-CSE-ConnectionGUID: jOivjmWXQS2IlgAF/OMNyQ==
X-CSE-MsgGUID: s9bl7475SBmNYzrPflVMvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11129"; a="18114450"
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="18114450"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 10:14:57 -0700
X-CSE-ConnectionGUID: e7fzTqcPRKSs8OG+lOFOxA==
X-CSE-MsgGUID: m5YQ1FKsTfShm+6U0u/wZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="52882964"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jul 2024 10:14:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 10 Jul 2024 10:14:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 10 Jul 2024 10:14:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 10 Jul 2024 10:14:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 10 Jul 2024 10:14:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NalysR6VfQzVXc36tzwxUPp/n1C9TjSLzCDPshcycOdyVcNXbsObM8xV66QZOAxPQU+bd7CHtCo6oSkCaWtcmNbARcxpFaq0mxtkdaKQIpCqXP4TjfJ2OwYmh84o7nVLNJ3pXEAAnvZh0ERBYjrHkDwpdDU2GSUCp59865HYczEJBwFPZsy0mB+P+LaFcq0xmEEh4Dcx+n9f5l60+DtYIQATsWvVk9yV7Wd/tDQGiFgewKQIk8Qj8mxFAvWM9Du8EX2qRKjbfIz4VtDeN1jXxuKb2P1q/+SvnKsFiHL2s1QmDepcA8mv97LjA6g0YaPI/3SvKN3D8sQCYtIsvZV93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aX865n3Gjh7dbt2tgsueFlKfkpmPOPXp2lA7toTk8X8=;
 b=nocgeP5rMN+WUmXlUIcUr1Yg5cAVk5WNSjiPSeSNz5Wa40NZV9wSTZ81RPttd3LNpMxoyroKXSqB7+MvlPqaKjTz1QHWttvm4Ls1PvcNJPzFoaXoFBYAdRVRTzJIiSca3yv8FBiZGLyFDEj60KmRNKwfm078HeZ00+stodkR3/BnfHaksGawJpKi40BNpJktiZnvU2CJDFF096XkxOxE1wNLRsysqdI+W8sH03DOMWqpmicFA8WEyIJLWZ47zaZ4zqReLJNNJfMjD5RcfS09kHkaLD4n2sn2OeOLetjW86LTtzNPfsWEcfMq8n6Wnr8bqh2O498uj6i3SVTk9FbEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6551.namprd11.prod.outlook.com (2603:10b6:8:b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 17:14:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 17:14:46 +0000
Message-ID: <c622488e-78e4-4f50-b487-52cdd6490e35@intel.com>
Date: Wed, 10 Jul 2024 10:14:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 0/2] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1718214999.git.reinette.chatre@intel.com>
 <171961507216.241377.3829798983563243860.b4-ty@google.com>
 <5354a7ae-ca32-42fe-9231-a0d955bc8675@intel.com>
 <Zo6r3if6rTERxnwl@google.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <Zo6r3if6rTERxnwl@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0211.namprd04.prod.outlook.com
 (2603:10b6:303:87::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c504f8a-826d-47d0-f3f3-08dca103cc47
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bzNlWmx0ZDhmb0h6ZXA4djQwTHVoWjYzLzVzQnFHVUxzYXpBK0V3QjdxQVNs?=
 =?utf-8?B?dUtPaWlHVW9Ic0w3ejk1ZGlVdkhLUWw4TmQxa05oQmdaY0pMSld6QzBVVEsy?=
 =?utf-8?B?bDUwNXhGN296YytkY09FQ2FyaTB0by9NQjN6eEQram41MW9sbzd1dEZuL2pP?=
 =?utf-8?B?cmc5azFDekpwUC9WVVYydkJRSEsycHpLZE1NVU1uSnhicnF2MllnU0owZVB5?=
 =?utf-8?B?clBFSmM1WE14RkxsUUloeFNZYzF2Y2s1Q1FZWjN2czY1bTlmcVpEcisrdGxh?=
 =?utf-8?B?OS9xNHJVZzNzWHArKzg4NTdWL2tBZDFnV0xJT0dXSFFQaUgyOEJ1VHQvM3d1?=
 =?utf-8?B?SkRncUlCNEF5WXhtNHpSYkQxTTN4N2ZBMjJkamd1bWVEbVlYdmcyWFFTYjhr?=
 =?utf-8?B?YisrTzhuanlCeVdpVzk4VlJMaHNNcGV3L1I0Z08rK0FSRUp2V2pkQlhqcHBF?=
 =?utf-8?B?eGFtVGo4R0RBcTJEV1NjUWR0UWlENE5zdkdMZHF6MXdueDlKd3JMbVlGekwx?=
 =?utf-8?B?NnY0RTZ1ZEhDTmx3a0Q0KzJIWDhsVC9JakV2R1dBTXFSYzVmSDRXU0syNTgy?=
 =?utf-8?B?TUdSRDJGd2VadXovR1NGVno0T1B0V1pBREtNVnVuSUF4eEUrenlnUnkzaDBG?=
 =?utf-8?B?U0x0Z2sxR29LTmtadUh0aWk1WU5kSUdlTWJRZ0xIMnRhdUdoVUtWR2NtSGtD?=
 =?utf-8?B?U1J6U3hGaWd0SHJ3c2QyVWpqOSttaHYyOW41NGtRZno1SjYvTVBWZVdGQkcy?=
 =?utf-8?B?eFZTVnJyUGNhT3FDNTh5WXpKc0ZhNXdQUnByZm85aEpadzFERGxYMzN2bEc1?=
 =?utf-8?B?TkVEM1l1RXBOMGpxWDBmUEd2aStpSVdCTEJVQXpaOXBaVDdyd1NxdDBnRnV3?=
 =?utf-8?B?QlBWRHpESHpNZVNZSnZsMDY5ZlhodFhzNndCZ1JtQkxkQXVxTFdGMHZEVU9I?=
 =?utf-8?B?MEJRbDZnaEE0V0NpRllYTEx4WWxaeFUrblVReWxqVmEwUjBNTmM2eU8yY29X?=
 =?utf-8?B?VHR1VFhGTXRNWDlHcDYvU1MvUzdRbTc4blhwVFhIcmMybXZwUDVOd2NIN0Z2?=
 =?utf-8?B?RC84eGxXNG1JUXZLWkNGS1lUTlQ4SDkwR0lkem01OVdhdzFJSXRCNk1RZlRp?=
 =?utf-8?B?VmhuTWdFQWtkQ0gxTGNFcE5BdWl1MzIvdzNmU0VFWE13LzlnQnA4RDBndFpD?=
 =?utf-8?B?dm1qOEIyVm8vWDAxWTlUcGtuWVlCNDRvNHpTcUlEMUQ3bG8xT28zTEZvZWVl?=
 =?utf-8?B?R3hHbHp3dTArWFBzcHN5dElYNXFmVTBzQjRVWWpUVXdWeEVJNnRIdjRVRmJT?=
 =?utf-8?B?RHVuSUc3RDRpNHRla01jNXpmbUJWQzRUQXdXVjFERk9iSkt6WWRLdnN2L3ZY?=
 =?utf-8?B?Y0tHdWtEMXBmS2E3STNrdUlDWnRPZTliNjJZOWhVZTBvZFc3bm9QUWszSG1G?=
 =?utf-8?B?MG9Mc2xlY0JNM0hMV3M2OFN2UDl0V0NuMlFKTyt1YWs2ZmVzTTNnemdkZHhz?=
 =?utf-8?B?KytMajgyVldEdUIvSTgydlplenJpSkVjcVordDNRb3Btc3ZQRTQ2RU5TNlVP?=
 =?utf-8?B?YW9OMXdXa3A0U0V3RE85YWJoTG5GbEVwY3JXNWxOampWakk4aGsyNk1BUG93?=
 =?utf-8?B?SXl1N21DeHN1b0hNSi9RQ3FWcjhpeDJPRUFIS1huNHp2aHJpek1Kd2dNNkl1?=
 =?utf-8?B?TzRrVmZGbjBwbzJqS3RJYlMzYStDRkJmTHdvcDJxL3RuZjB6YmI5TERmVGhz?=
 =?utf-8?B?alhjU0RsaWt5VVdhSlNpWVdDNDR2TnZQR0xFMTZLeG5SZkFoeEMrWk5wRDla?=
 =?utf-8?B?aEMvbGdCcU02WHAxeG9GZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1hjRFZQazFPa2phVzkvTVNGY2x5TGRKcW1uRTBhMnQwQTM0eVdiNXRxWUto?=
 =?utf-8?B?NmZ5aFdaU1RrYVAyRzNsRmRQVER2OWQyNUNBM2RSbHROSWV6blpyM0pyazVL?=
 =?utf-8?B?MTZWcG93Rm9iOGdRTkJMUElLcUQ1MzNvR2hESURPSys4RU82Q2N6NkNxSndR?=
 =?utf-8?B?RzRkd3NnN1FINCtJWVJqWFlVNlpRU3NMdG5IdEx4WUs5T2Z6WEl0YjMydW5D?=
 =?utf-8?B?aUNuUkFRbFJiYUIyeW91MTJ3eThBaElyR3RsamJlL2E2aDBxcVcvTDNZSzRy?=
 =?utf-8?B?L3RLcGlSSlc3YUNrTmJGMFZjNkJuRUdDVlJUeTkwM3U3Y0JsdzVXczU4WmVQ?=
 =?utf-8?B?WUVZLzBqOUhveTdmWUorRWdVbEs4Rys0dGlIQnpuWjJMVVBpTEtHUThkakw0?=
 =?utf-8?B?QzhoNEw5RWt4d3BKMG8xODBZVXJnYm81VUhBeXRUUTlpa1crWnRDRlExaGZN?=
 =?utf-8?B?bVpaL09hSEIxdnd6RkFzSHhpeE95NmUzdm1oc0FTRENzTU9aM0JWTUh5d0JH?=
 =?utf-8?B?Znd5enhqSy8rS1AwWDYwVThLZFFneDJ3YUtHMitnWUtFa0l4R1B4d1kvd3pF?=
 =?utf-8?B?Q3BzYTU4alhUdVVhVGdtYTdpQ2VIRHRtNGY1M0o0L0U5V0loaGlUT0syVGVk?=
 =?utf-8?B?YVI0V2hVVHZmc2xtV3FaL2JIbEpqVE5RaHNyMkVvaHB2U0hwQ2Y0dFFmTjhx?=
 =?utf-8?B?dGdaVmN3YktOUUZiUFBGVWdQODluR0p6MEJZR3VjcDJpQUJ2TUFsNlE0dEVa?=
 =?utf-8?B?SnlNUXVkMFVaVEpzVC9oRXZSbElvcXM1UThudVI3SGdWNzFxNHIzVmlDTHF5?=
 =?utf-8?B?TkZKWWpGbXh3ZktXRHB6ck1zMUs5M2ZIMWs4SnpVL1ZxaW9aVzdYWXRaaGpz?=
 =?utf-8?B?ZkJPNndYUjgwOUpKK1A2d1htcGhSVEt2QkhUOGZYZ3FMdnFXcEo2SWIraEVF?=
 =?utf-8?B?YmpLaW43ZjhqTitiSFJ6K29TaDBwTUVJaUxYRjllWTkyejJaMjdBOUNBWHRV?=
 =?utf-8?B?OEF4NDM0MjJOb3VMd2FsVnNDL3NaM0NiazRETXdmL0dCRWtJUDJmVE5mL3dB?=
 =?utf-8?B?NlI5c094MlNEWlZ4V0xlSnZINVVyQkwwdDUvYSttTjcwTlhxWUhQbkdvQjZo?=
 =?utf-8?B?bjZQYnVrOFdrZlFtWUsvSExPNEdQRVlrZEhmZXcxSnhpbEp5WXltc09SVS9Z?=
 =?utf-8?B?Qi9nTE9raWhkbGN4dGRzcmVudU1vREZjbnpiRm1tbGIrSFlrcjZTUnFtbUpZ?=
 =?utf-8?B?Y2xiSG41M2xKOVBzL1ZESXJpTXVDWTBwc2o4SmswQmJQcXY4WENmV3lsMC9q?=
 =?utf-8?B?Y3o4Ly9ialBSeXZpTEFsYjEvYlY5Umh2NVFaS2NrbXZyS0xaNFpxOFNTMHNw?=
 =?utf-8?B?K3psWTl6ZEEveDNGUlFqOFFxV2srQWMwZ0dDVzkxdkgzL1RjRnlSMVNRbTFP?=
 =?utf-8?B?TkZrM3V0L0IydHRwWWVrREpVa25oUGlHL2xmanZqbEJKK0FxL0hXR0ZxZmFS?=
 =?utf-8?B?L2tIUFV0U1ErejI3Z3JIblVQQmZraStLU2EzMFBIU2tyMzhDQlRtUG9lUkE2?=
 =?utf-8?B?Qzl3a2RzSGlEaWtLOW5maDFkQjdPbHpPdmRaU1BhODRxa0JHVXFpZFZhbVlF?=
 =?utf-8?B?ZXJ5cEF0MzA4Z3EzVU9idmtobzVFZWtPYVZ0YkovOGJ3TW95OE5IMFMrcTRM?=
 =?utf-8?B?WTJXMGJ1TzExWGJ1QUREU1RCYm1RNi9uMWNGRVRDeFY1NzRURXBHU2lIWG9Z?=
 =?utf-8?B?RWhZczVGMFdZZ2xPSXhPUE5CWlMxL21BWHJ6QnEvcW1wMURBNHpoc1Y4MjJD?=
 =?utf-8?B?clZWYnVsc29kSEFybHp3cjhjU1dEcndKWGFnUzQ4RjJiSkRXOFN5cy9KYVRP?=
 =?utf-8?B?b2V2M3pvQ2JhMHBCQldNUzNvaFNYUTZqYWNWS3lRaVgxeHdCbFFEQTlVK09N?=
 =?utf-8?B?VExjMnNzNlBIcFBHMm1GMTJoazBud214RkYrOVIxY0tXZThQWDJrNXZDdDRY?=
 =?utf-8?B?ZC9EeFQ0WGd5dkQwWjJNQ0JkMjROUXIwMExQSWdqQW11UVBVVXJRZWpSSnpF?=
 =?utf-8?B?NVdHa0VxZzlSdi8rcWZETGFRSXh2RVRYMXBrQTNMYWdRKzA4Umdialg1T245?=
 =?utf-8?B?M0ZoQVBacjhVU2lMdktvTWI1VjNqVWR4NUtTVDBxOXdwUzJKL3F3Tkh5NmZa?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c504f8a-826d-47d0-f3f3-08dca103cc47
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 17:14:46.6283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oveMRJTSvm0tL5sOlJm3cXa/iZcNH4MrXPundzeNZAI1ifg70lY8YsBAeWvk+6TkLi+8JUzOK/F096/DCLMQA4b/5+aYp65VXqKUgOSuT1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6551
X-OriginatorOrg: intel.com



On 7/10/24 8:42 AM, Sean Christopherson wrote:
> On Fri, Jun 28, 2024, Reinette Chatre wrote:

>> Now that the x86 udelay() utility no longer use cpu_relax(), should ARM
>> and RISC-V's udelay() be modified to match in this regard? I can prepare
>> (unable to test) changes for you to consider on your return.
> 
> I don't think so?  IIUC, arm64's "yield", used by cpu_relax() doesn't trigger the
> "on spin" exists.  Such exist are only triggered by "wfet" and friends.

ah, I see, thank you very much Sean.

Reinette

