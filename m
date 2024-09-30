Return-Path: <kvm+bounces-27667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB04989B61
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 09:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B639B20FB9
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 07:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336C516EB4C;
	Mon, 30 Sep 2024 07:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AIJtguJL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C331F16A956;
	Mon, 30 Sep 2024 07:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727681107; cv=fail; b=IKNQ8l7J3SnqnwYUtyyfRmCKM8OZxh08BR4GR3aQ53JRgjobR2Ts/F61111yU1XFw57hAIXCP3kSuDOeBAqR7RsAjrJqdUbYr6JJr0Gs7LvHvbA6v0kun9sSNT5kYvhjuoIoq4zXaQjYBcR3gKRLfo40EuRVvcSXowS0QmbuIrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727681107; c=relaxed/simple;
	bh=eLMpqzIQGpVrmg47I4cMuK0mbd5U3fKSg7EEkilWRmc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ly3y/dSsU2TFLqO05qFMvVGqkIDxTICcZ2jQ4P1Ns+0qj0/qur8V3IWdO9WWWwuP280dtdnnmPDhSnHaJbkA5x0WhbrqVcwqEuBZT4vSUPdahIRWTx7V1kZIO0To9IxHKPjiGqy5HZpiccqv65CJ6x7x4u7ym4Af0G4JhU7nF1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AIJtguJL; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727681106; x=1759217106;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eLMpqzIQGpVrmg47I4cMuK0mbd5U3fKSg7EEkilWRmc=;
  b=AIJtguJLOdtr3EyeSsB/unU+qtfGjWi5JUE1Be5RdFOzAHbSpfEsNzMa
   Pdf9IRGFa9Eeih8afvuruG+dL8KWvuTQA+n1xhI6106qPBDMgrlLykezJ
   D3dzmKDm3RXmL3urzsZ/DUFrH6QPVUYLdI4yQZONvMspcp74+TVqKrqba
   tOyfQQHeaN84q0ymzemL6UKS1mphYL/eyg/KXW7O4TVtmsb4Th8eFQpeD
   0h2KgY86axDU1tBtrjUeWKYQepV4JuKHhEwgtwsA/kclZGuQ8bu2JJIWB
   o34TUWgPOtgfcKQQvLFg0dA8zscJNO08HH5e19GlsZ/myvKtN9Ru5g/e/
   w==;
X-CSE-ConnectionGUID: uYuRuWfYT6e2Mjeh+kohKA==
X-CSE-MsgGUID: Tj/4awenSVa6FBdKgvz8sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11210"; a="30549905"
X-IronPort-AV: E=Sophos;i="6.11,165,1725346800"; 
   d="scan'208";a="30549905"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2024 00:25:05 -0700
X-CSE-ConnectionGUID: Ki9Ap1zFQLOUikE6hbahJw==
X-CSE-MsgGUID: /01yvM15QVW2kvmaDbRsyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,165,1725346800"; 
   d="scan'208";a="110691297"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Sep 2024 00:25:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 00:25:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 00:14:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 30 Sep 2024 00:14:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 30 Sep 2024 00:14:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 30 Sep 2024 00:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGDeZOZC+E2SwV0yVIW3vAgnGxQ1fzTHPEDd0tql+HqQndtPnqskCSvYCIqPosi3Jq/L9TJ8pj5IQwvePt/VIQUdv379CpERqbd7fenIdr+cOF8Uf4ywUyM2NvkObkJ2imMEJjfyXq5/X8SwHkth5+eQmeNpGCCb2ap5MOYRazbrdPVbIzQbQLFSUxY4j9XZab0pCT25dZMDe6wRPuhF5EGmC3QqBQivNHbratWAybMlsL0/asytuXRcv0f2pJQYbJqzr2AmEq6h88xE2WuRpv1ibQuawwM5I1Bhx9Ricu9qcD7AzU8IzFOnzBS8jvIXtPotAAZeaI9ggnU35GIyAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywHAGu5547x2hNo0j0zKDfPOTddLyQTOpVCovjAmuyI=;
 b=yR9Qr74YmSpkBkxdKVSI1y3hrAttDoOl9uBl0MUfngdH/7eaX88sDP355hXBFPheDsbRCsE4MbH/FbjWBvZ23JTSzc7eBeqg1n8SBg4ysLy5RMLP/u8iD52IAWQe7ru4plnAGQMYreixS5IvVjtAKNj/Lv/Oru/1F6CDixr6bFfPSJ7VA3sQhHCxLPEjerMlVdAOdzlK9ekCubvnikHGDavjGXRFfjANWNnTj+ItLdGRLge3fiBorNe8c6hLZVEsLkHH+hUagXAjBcv3lt9W0BkqPGP2lqWI29HglX/9uTiSkaO/bK+D9lCrbZACn67TOrfz+H7ga0ZtQYhP4jwGZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM3PR11MB8669.namprd11.prod.outlook.com (2603:10b6:0:14::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.26; Mon, 30 Sep 2024 07:14:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8005.024; Mon, 30 Sep 2024
 07:14:30 +0000
Message-ID: <27b1055b-aee3-4d00-a4f8-d7d026cfbdd6@intel.com>
Date: Mon, 30 Sep 2024 15:19:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Simple device assignment with VFIO platform
To: Mostafa Saleh <smostafa@google.com>, <kvm@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Alex Williamson
	<alex.williamson@redhat.com>, <kwankhede@nvidia.com>, Marc Zyngier
	<maz@kernel.org>, Will Deacon <will@kernel.org>, Quentin Perret
	<qperret@google.com>
References: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM3PR11MB8669:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ca714e-82c7-410e-369c-08dce11f86aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TERhTnJaVk5vRDJPRFhFaW0wN2hFZXFsV0N2SjhGVnZqMHZCNk5Bc29Cc0ZH?=
 =?utf-8?B?M0x1Mk1oNGhXRXhoS1BHejlXU2NQQXVWc3M0ZjBadzgzKzhQaVhIdzltSEp3?=
 =?utf-8?B?Rm92aUlyN1hoUHNxMjhmTGhVM1lsYUcwcmJKYnJTWVVPd0pnY3RDREZ4ckl2?=
 =?utf-8?B?YTdJYkhwNExrOGVWZmtBZktoY2IzSkdLem14eTlpa0V4cGJpMmdidlJXQUJV?=
 =?utf-8?B?M1lkRHBUWXFXV2srUURzSnJpTk11c1NzK1h1Y1NNTVpnWmt1NmVQcVBSTlFM?=
 =?utf-8?B?K3k0Rjc0enp6RCtOWkRBMmVZKytrRUZjY2JtWHQrUXo0dFBnVEFobGFMeXJs?=
 =?utf-8?B?RU1OcmN0Z1ZMUHhPZXRGWGNvWEMwK2JwaDZuRjcra0Rna0pvcFhqM3UrYnp0?=
 =?utf-8?B?ZzNUdVY0TytGYkhrN1U5aU9oQ0t5cWJhQmlhMlFzNEFNb0thODlxa0FzNUs2?=
 =?utf-8?B?ZDJJN3RqdWNKV21Xc1BtKzB1MGFUVmRoZVA3L0Vvb0VFb2tuSEZCWXB4TFBZ?=
 =?utf-8?B?UW40bXVSakM5RHhCdGtoOWVkSEN4NWp4b3Q0ZmRoQzd5WVFKUkFrQ2l0b1I4?=
 =?utf-8?B?QytsOFcwQjBJeTY2U2JYUmJPYXh2NitTbDZRK1lsRzh2STBuV0ZWTU5WNzNO?=
 =?utf-8?B?QnRwM2hjMUdPNVNtaEtBUjZvcTgwU2FSc3dWcGoydnROOTZXRXF0dm90RGlY?=
 =?utf-8?B?WnNneURMYktIMEZyVWFISU1SV3FoYnJEZnQzNnVLT1BlVDdkdlhlbTB2bEVX?=
 =?utf-8?B?Skdpb09vVHdHcDlUcHpPbERVc2xWYmlYb1NpSk5RU25KTUdQTGdpZVUvK1ZG?=
 =?utf-8?B?ZGRmcHZjRVhHUVliQ1Jrdlo1Ri9wTjBZOGlmS0JhNHRYdG9yUjUzUTgzWEww?=
 =?utf-8?B?cmNBQzhJUFNYSXhMZmpSWkdMNnRtUkVGR3IyMUpMS1ErU2NXZzR1RHo5RFBP?=
 =?utf-8?B?N3kwbnhNR003a2VpZ1ZwR3BKa3NHNElXUHZJbkplYjFVa3dvcXEwbDVLd0tm?=
 =?utf-8?B?Tm5xcyt4eHJKZ2NsdVkzRndGeU5wRTBJalJQNWRCZ0c2Nkg0ZmlEN3JwWWRB?=
 =?utf-8?B?bHQrSDRLeExaK0tyMVJkczBPMUV0QThtc3I4b05VaGtrRlhZZElHUVBGWHll?=
 =?utf-8?B?MFpwQVBUcVdTYUFRekQ1alVna2xpWjlSOWlmMXAvOWRTYndtdXlhT21hdTI4?=
 =?utf-8?B?amovdUlneTVzWmFwb1VBbGhxL1hWbmo4d3hTakEvQ3Z1djgyS1NpRktMczdE?=
 =?utf-8?B?ZktzRHcvaEIzOGNBbTN3OVpWbC9HK1JaNmNhM2Z2L2w4aVdRT21JUytNQmIy?=
 =?utf-8?B?ZjY2QndMQVZZNUZCTUFvcnVyTDc1cm91VFh2SVBVK3Ryd25PSVlrZFFVWlNy?=
 =?utf-8?B?aVl1WngzSjlZQk14cDZrejRPNHRuaDYvZHh2djRlQy9zSFlGa3BMVUxZcnMw?=
 =?utf-8?B?Q3BHblcvMDVGYWNiUGJsTWppNkkyUGJYckxjcDl2bEk0VUdoM1ZhMFF3UEMz?=
 =?utf-8?B?SnY1RG4xZTRDWXBEV1R1WVFwZFJzSkpWdnBmUzhCdCtjOUZPYjRCaWNOZ25M?=
 =?utf-8?B?TWREM3ROUDVpL3VIaTJFL1lxcG04b3FvSFljMmJJL2RkQlJhS2JsUGRqaW5p?=
 =?utf-8?B?Q1lLVzZPc1U1a1hmVFo2akxrV1V6MjRYT3JzVGdTQ05za0RkbWt2WkFjd1Jt?=
 =?utf-8?B?RzBaYVk1RWNxd3pMeDVCZW5ELzdjTnJ2NXpNNTR6d3dqcmIyQlVadEZzVVZT?=
 =?utf-8?B?UkE5WVZSaDFjc0tXWUVsVjduYVdyTE9YUDhGdnpSTWJTeWJWd0VuNEM5TlZq?=
 =?utf-8?Q?kglkvJTgr/Appldq3QiVqNVXINj+dtA0zqBvA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjNqMUdhcitLQ2htcHgydjVITWtlWC9LbHJhZGsrNjB4cXdoVFdFd3FzbW1a?=
 =?utf-8?B?YWtuZ05RVW5CZ0gxSmc1WGNDaUpoa0U0M2xjVVF4TEhSZUdJK0JGTjQzN25u?=
 =?utf-8?B?NkVCSUJ0YlR6M2RISU14MlpHSXM2RHZHRVUxL0VsalNTWUV2cU9uOFFFZi9U?=
 =?utf-8?B?WjlhM3o2cnEwZVRvdlpDeS9BMWltYnBYVzFpUHA0MmFvK1ZKTldJRnhzNDVK?=
 =?utf-8?B?bkVNck16c1FyQldOcFRXV1lVV0RnWXFQZVdteU45czZPOVJBa2hHRGFGOUx3?=
 =?utf-8?B?b0xBUjZEcWRjZW80R1RsSk0xRGNuMGovNnZwa2ZKRW5KK0NvcVFVV1NUczNF?=
 =?utf-8?B?MmZWZTFwUnNRUUZZY09GdjB6OHZmRytwZk1PME4vMlZQKzdEQkZ4QlIrUjB6?=
 =?utf-8?B?TlFMNUp1QXVLWlhibk5wZlp6SkxwN3dqRGJYYW5EdFVHNnhMUUVkVnNuRUMz?=
 =?utf-8?B?Myt5WWZaUWJiVjBVK3VFUXgrRVFUZm5NVGxqNElVVTRqbVU2bEdIVmNQQ09X?=
 =?utf-8?B?VnlraGtIVmFWdU1Eb0ZXTFRsMWZURWFUZitKRnhVYmJJTkx5N3BjR2VvZHll?=
 =?utf-8?B?TmVuY0xmTkZ3emdOY1haUlVoSitFMjlzc0c3cVFqVG9SS0NibTNDOE44UWwz?=
 =?utf-8?B?QmtncFlybm1ISEsxbzRSL3huWWFxSlNhLzJGdEk5WEtLWXdRWDRkWmUxU2Zy?=
 =?utf-8?B?dmhnakg2bWNRdjFsVlVCbzVRUktLOWh5TzJnUEFySGYrSW12bkFxMitLMzVC?=
 =?utf-8?B?dFk5WWZ6OE4yd0N2SGRGT2VQR0o5OVQ1aWNERWZVUTZTSzVzWUVod1JxZWJv?=
 =?utf-8?B?eGxYbTNoZVlYajQ3eDYwa281cEo5YXhnK1FLUjcwSGk0R0l5dWppRGVoM3BL?=
 =?utf-8?B?SjgrME5hc0Q2MXRLeDFsVHI5OGVGWVRRbGZWZ0wzUk85Z1d0c1VTNTA3bmZl?=
 =?utf-8?B?NVN6Q1lmY3dHRHhaNkJ3dG9DQ05kZUUvckdLN2hudlFMT3g2VCtUUThUaCtE?=
 =?utf-8?B?UzB3RkY5NnpJZUQ3UzE0UXdsbkhwSXo1SG92N2tPYnBJUTNnNHRmcUpBamJx?=
 =?utf-8?B?ckJRM0dXakFacEtVQk5PanBKZ0NtNitCdVQ5ZkRlODNlaklJeXl4dSt1QlJR?=
 =?utf-8?B?VTZMYXEvY1FLMitZd1dqeWFCZzZza3NLMWd0S1JPYmxhZkNJS2VYRVBmR2hS?=
 =?utf-8?B?S3doV2NiZmpWcVdxYlRwcmVuR3JNWVFVQXRQNzNPOXJ6L1JUR2s2MnFqOG9L?=
 =?utf-8?B?MzMxVzdGYndxUGZHTUxHY0dDVVQwY1RMWDhKeXFmZkNXR3h1YXdtblI2dEhZ?=
 =?utf-8?B?MFR6akxaWmlhNVN4bExySDJDd1pJaUFlWXQyZXM5RXJFNzBtSlVXNWJnMTlY?=
 =?utf-8?B?dEsvMm1GYWNqVW5BVWUrc2FpU0pLZTV6aUx4ZGg5TXZldm9DdzR2MDNISE5P?=
 =?utf-8?B?Y041aUxSUTE0Z1dIUkIwdHlvNXFpK0NpL3ZlQXdkVEtGSk1ZL3ZOczhBbmFB?=
 =?utf-8?B?K1dKb2srUDBtSFRyMzR6OXpSNXNsWlNEZVluVGx2MXpHb3p3dTlHeGN4T0pZ?=
 =?utf-8?B?ZTV6VnY5SFhSYUdpVnFVZGFJY0p2VlpNcFpuazV6bERCWm1zRUFnS3dacjF2?=
 =?utf-8?B?YVdHUHJJaHVZWEwzQTZlQmpXZWoxVjUrYnpPZXVmUHZUUmU2c2JFdHAzemxt?=
 =?utf-8?B?djhId0NZUnMreklXWGdTbzk5d0tWQmx6cklWR3UvZ3FJYjE3ckMxUHNSWGlO?=
 =?utf-8?B?Y25makVaWmVhL0ZFTWJMcVdScVFWZ0VRTkxROWJneTkyOG5VaXhYMnk0b3gr?=
 =?utf-8?B?WnZuaVpCblc5U1JSdW9IR0YxMUZtdEd1bGExR1hBbkVIcDNyOXg0c01oUVdi?=
 =?utf-8?B?b3FINEpzbG1yKzF5SDFJRUFkV1E1bjB1VVFTU1d1VzRQVjFxb2VNMVFTMjA0?=
 =?utf-8?B?VU5neUN1czNpTGs0aEhBSVlwUWpQMWZyanlIS1VkVzIvWXhkSHhEVEowQVhE?=
 =?utf-8?B?a1dyRElxNHpiWE56a05Bd1I0N1U2Njgvd3R0OGYwOEIvZk5kSlNsUUd1TzNP?=
 =?utf-8?B?NHh5ZEVlQnptenFGdWpyTGpzLy9mS0QyZVlpbEVFU2F3UURtMEVwRnFUZDI3?=
 =?utf-8?Q?xqXn6IPf+splhxgfpRLQZU08d?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ca714e-82c7-410e-369c-08dce11f86aa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 07:14:30.2067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNRXSCMWWIlK+cSI8tbrQFabGfbIgzgaOtLoCo2kxR8zNsCVprH+I7ywEFLyQuEQ/RPrO0UXxMx6jSMnor9oyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8669
X-OriginatorOrg: intel.com

On 2024/9/28 00:17, Mostafa Saleh wrote:
> Hi All,
> 
> Background
> ==========
> I have been looking into assigning simple devices which are not DMA
> capable to VMs on Android using VFIO platform.
> 
> I have been mainly looking with respect to Protected KVM (pKVM), which
> would need some extra modifications mostly to KVM-VFIO, that is quite
> early under prototyping at the moment, which have core pending pKVM
> dependencies upstream as guest memfd[1] and IOMMUs support[2].
> 
> However, this problem is not pKVM(or KVM) specific, and about the
> design of VFIO.
> 
> [1] https://lore.kernel.org/kvm/20240801090117.3841080-1-tabba@google.com/
> [2] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linaro.org/
> 
> Problem
> =======
> At the moment, VFIO platform will deny a device from probing (through
> vfio_group_find_or_alloc()), if it’s not part of an IOMMU group,
> unless (CONFIG_VFIO_NOIOMMU is configured)

so your device does not have an IOMMU and also it does not do DMA at all?

> As far as I understand the current solutions to pass through platform
> devices that are not DMA capable are:
> - Use VFIO platform + (CONFIG_VFIO_NOIOMMU): The problem with that, it
> taints the kernel and this doesn’t actually fit the device description
> as the device doesn’t only have an IOMMU, but it’s not DMA capable at
> all, so the kernel should be safe with assigning the device without
> DMA isolation.

you need to set the vfio_noiommu parameter as well. yes, this would give
your device a fake iommu group. But the kernel would say this taints it.

> 
> - Use VFIO mdev with an emulated IOMMU, this seems it could work. But
> many of the code would be duplicate with the VFIO platform code as the
> device is a platform device.
> 
> - Use UIO: Can map MMIO to userspace which seems to be focused for
> userspace drivers rather than VM passthrough and I can’t find its
> support in Qemu.

QEMU is for device passthrough, it makes sense it needs to use the VFIO
without noiommu instead of UIO. The below link has more explanations.

https://wiki.qemu.org/Features/VT-d

As the introduction of vfio cdev, you may compile the vfio group out
by CONFIG_VFIO_GROUP==n. Supposedly, you will not be blocked by the
vfio_group_find_or_alloc(). But you might be blocked due to no present
iommu. You may have a try though.

> One other benefit from supporting this in VFIO platform, that we can
> use the existing UAPI for platform devices (and support in VMMs)
> 
> Proposal
> ========
> Extend VFIO platform to allow assigning devices without an IOMMU, this
> can be possibly done by
> - Checking device capability from the platform bus (would be something
> ACPI/OF specific similar to how it configures DMA from
> platform_dma_configure(), we can add a new function something like
> platfrom_dma_capable())
> 
> - Using emulated IOMMU for such devices
> (vfio_register_emulated_iommu_dev()), instead of having intrusive
> changes about IOMMUs existence.

is it the mdev approach listed in the above?

-- 
Regards,
Yi Liu

