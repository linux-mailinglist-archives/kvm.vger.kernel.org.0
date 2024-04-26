Return-Path: <kvm+bounces-16028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 748738B3195
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B12328954C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 07:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C8D13C3FB;
	Fri, 26 Apr 2024 07:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wl/bShBW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF7B13AD25;
	Fri, 26 Apr 2024 07:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714117407; cv=fail; b=XWticll+xeCndA+H83zLPKnpz8cjoeGQzxx4ZzBHyJgSjkvecTQK7XXpOyER/vPzxGo8ARBrUA/mmT4LXi32QRWuXPOcZrMuP9w4/2H7cY6xIlu3NIqXvnhct1k5LGXya3pDd4L8eC9ETvGYwSoxwfE8f4Hc1zW2/d8xy/mc0KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714117407; c=relaxed/simple;
	bh=tbnfDzS5CsLhZ31HfEvryKcELZ/ujULkAIk1d5iKstc=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VxmKqHp1UQDONZJQDgUz7gpLhZGBZkrqK9YK4eSqn1toieuYqXhSHtcxqJOpc05gdDdtaglYm1kFZZH2hki3UQocymBOs0655GUnT6h4bR80kAOm/fo2JrOyPY0IUO7DpE4gjO+P2QbdKTRr4rVi0rIrqKcQfMpfcmeIQUZjTgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wl/bShBW; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714117406; x=1745653406;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tbnfDzS5CsLhZ31HfEvryKcELZ/ujULkAIk1d5iKstc=;
  b=Wl/bShBW5t5W17h1cu8mUet4jT++f2po60WHGEKSyyraCVFfKrr33uJU
   0qobQy3YoN9WwfTOMHjInsS6UNN/gEgWv57jf0+Ga1zA4qLmlnv2q671w
   BNke9PV0lQ8ueywVEZAN1ErXTfyRHKFJnN+9RYpa+lVSg/xWx3+2cq9Zx
   kJaiPN7MzAchuXsrvkLzLBwg94pyFMZzgFEXlsCd04gxJXkIz4rRNj7YR
   uuV3p0TyeE1vNHDYglRJ8gMjq0P5dudQzORFbA8wuHO9bFtApyZU4IUzK
   laQrLgAD7cEt30QCSzxKaVC1cl49nwtpLoZNEkR77U1prKHsrVUMgAXyV
   g==;
X-CSE-ConnectionGUID: O+OoHDeXQheZq/WxJRlVXA==
X-CSE-MsgGUID: KLGBtlF2SyCmnl6TIhlmZQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9678071"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="9678071"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 00:43:26 -0700
X-CSE-ConnectionGUID: eQKM+EYKTZagegOviF2HKg==
X-CSE-MsgGUID: 5dRQuTM3SrajiT7BgxMtwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="56278803"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 00:43:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 00:43:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 00:43:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 00:43:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ojo4q6i5MLI2PwNxL9qsegdWnW/y3cgE77B+p29Zmv9O171wexOvYYl01KnWlApJfbiu3x48WjD4eKhmtkMr2Wb00x6NvGS7ZsL0gBvG/j/A0gxwPqC6yfiP3vXxf7kbhBoqSk5EDSRivl/R/1Dxf9ypsYV4iBEQXp5wv1TR42efKqYJE+UIpEufvF6eYBeB1tKdW5z+GHrQywPdURLN15nDiFogTBCLnYtvORUQz7nhnWSBVh2ug1UJkp8HLso6s6L3ZJ2gm4mMtlRk83uIWj6XR4Eud8hQrCtbErLzF20m5GlTQAvCeKIu6MrWRwJ4W/bUxeO81C2L5xXVOLuKyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nc2N+PVQ4aI04Ze7+N/vHqwCc180LPeAqSRPzowJdOI=;
 b=VyWcVYaYHg4kSomg/rv7RrDWjGycrYhiMISsWD8P3cLpCgqBZrkyPVFhKr3oPWcvky/gw+2OotMw6yzo3dyc1zNx8N0Nv1Jsk1cYC19ctDA6kekxuQF6/x4QuLr/tOWsJvbMbnuXKZhPseqZArCm5z6d5VhSEz85Fkws5dNy6piZTTsBnJp2SAqrNiVRN4yIW+T7cgcp/zyyfRjDxmAhu+EYvVKC6uuPRrqN18mRxoOzmI0y7WPjXm0eEYjtJUNUFqsoRmaKRxnIT7C2xVAyh7Mzk9GrNMqy+NvjhJrTCG22HfEypDmJUBGfFlewXNGEfcPG5gavT9jIdB7esdta3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV8PR11MB8605.namprd11.prod.outlook.com (2603:10b6:408:1e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Fri, 26 Apr
 2024 07:43:23 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 07:43:22 +0000
Message-ID: <672782e6-b143-42d0-9ed6-8c343d02e49d@intel.com>
Date: Fri, 26 Apr 2024 15:43:16 +0800
User-Agent: Mozilla Thunderbird
From: "Yang, Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH 10/10] KVM: x86: Suppress userspace access failures on
 unsupported, "emulated" MSRs
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240425181422.3250947-1-seanjc@google.com>
 <20240425181422.3250947-11-seanjc@google.com>
Content-Language: en-US
In-Reply-To: <20240425181422.3250947-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV8PR11MB8605:EE_
X-MS-Office365-Filtering-Correlation-Id: 17444bab-624c-46a0-9f2c-08dc65c48c75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MEdhdk5pMlorc1RvWXd4eFpVaDlqNU4zbjVkVGpSWWZKK0VBdTRzcDJMMGxy?=
 =?utf-8?B?bHVBVUZVd0VjQk5veG93ZHpyWmVLTWt5eHRCY3lLQWdkckJSbU5FUUlnTHoz?=
 =?utf-8?B?Rlgzc1FPUVVKeVFOWnlab1V6VllReDNCWmpVSGlub2xkd09TcU5kWEJwdmJD?=
 =?utf-8?B?TUg1UjN4LzNtQ0hpb0JicEE0MGcxU2d5R3Z2MDllbjE3TWJIWmpETnhsTFM2?=
 =?utf-8?B?dGdXcnJEZitDam0wc3ZCMTRXSDlaU0puMGdqQmM0UkIzai9jTGxJVzVhZE1r?=
 =?utf-8?B?bTNjeENGdmk0dmQ1YlEybzY2TUVNS0VBSTd6a0ZLd0gwNUhicjF6R3Z4a0pk?=
 =?utf-8?B?UzlDQ3d3aWYvbHRrTXVmWVd4aHR2dFo0cGRXdnRkMVpuQWtuSDNCemg1YmxQ?=
 =?utf-8?B?M1VualVXT3ZKelZUbW1kdm5sMTdPblJWT1VQU2xyVVJUUmJBMHFEZXBnZnRC?=
 =?utf-8?B?clp2ZzZjdjJhdDNvb0NKSythOWxtaWh1dU0zUktRR05iZTlFcVUyV0kyZHFN?=
 =?utf-8?B?a3VyQVRsVldEbWxUQllXZngxM1lIbWQ1akd5cVpLYmJvOUk1NFRXTjR2WWND?=
 =?utf-8?B?N0ZKakhBWHNURGROT1JUUHZnaTFLQm9KZGIzaDd4L3czNUVBMDNGbnRaYUs4?=
 =?utf-8?B?bDZtWDVxcHpPQ2p1QXE3elpqb05wWGRaM3U1ZENCanhRcFNFMFBwaEVNWGVT?=
 =?utf-8?B?R1ZLdUVBV0pPQXdESkhoTVVRYU1RMGFIMnRGQUlsaVB6UDZNRVE1S2FjclpQ?=
 =?utf-8?B?VjdvOUpnVGNqWmxrbnN2NkxlL1JYektkVWlYellnVXBVR3QyNXhIVjJ2d00w?=
 =?utf-8?B?aUZweUc5MlpIRS9iL1NMZzRaVEhuVkthcms3dldkNFlGb2ZzTWdMcEhxQmhN?=
 =?utf-8?B?dEI5R0tKYWJrOXpnNFc0b3NLdlhWNXB2L2pBVmVXb1pzMHNiQUpNUmoxcVVJ?=
 =?utf-8?B?OGZaN2NnQWxhbFNZZFVVMjUrVFNGakRCajUyRnFielpxSFJHRlI2dkNzdUdp?=
 =?utf-8?B?REFPbWJGQ29XMSs5aDFFQTF6N0wzRVQ5OUJIeVpxNllrdWsrZnhHSVVLVE85?=
 =?utf-8?B?YWt3ZXZQRHVLcmdVMjUzSW5Kd0RmTm1XVlFPOVdRQUZ5akp5enkyMnh2cEx1?=
 =?utf-8?B?R1JHamx3dkdxNlo3UDBXT2hDUjVlamUyMFozTEZ4YlZmbEZ0RW9hNzRxVFM1?=
 =?utf-8?B?WlBiRnJKVmwxVGltdUl5Z3hZa2tEZXFTemZnZklFU1dxR01mVm5NSitPRU1X?=
 =?utf-8?B?V09QTmVKR0FwY08rT0ZNSm1PUTJhN2FDbU5hU3BoK2NqVE9rRVR4dUdhNW9U?=
 =?utf-8?B?dkYvMEY3bWwrZlQ2eStTbVByUWNPcUQ4ODMzeXFpWXVaMXQwREdQSjRaWWRT?=
 =?utf-8?B?Z2lhWS91c0NDaDhMOTZXMWVZWVczVEg2dnV3M0d4V0NuVWsxWTB0c2pRQ0hL?=
 =?utf-8?B?OGJaZGtLNGNKRk5zQmMycmVXcmp0NTJwQlVYc0lRaDMxZ2l5R0VldzNtREVx?=
 =?utf-8?B?aEVLVjFNc1Q4ZWNxRTl6V2RWcjhmS1dPUHFXUkx6ZHMyeGlCS2RxbE5TSkQw?=
 =?utf-8?B?MGRwVHNubFNHdVAzcGMvS3hTMXpnYitjTUFmd2JvV0Nmb3lwZmc4aHg2bHhw?=
 =?utf-8?B?TyswZDRNWVBTbVBibFJqdnNDTk4zSTYySUxoakJTSlBxNG1kQU5ud0dZMjR3?=
 =?utf-8?B?eS9GTjJaQjlCUzN1cHZPZFROTERJSEJLYVRtbGU4NDJ5TzdKaStiQ3h3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alRneHhGb0FBcWZIeUo5THFvTUljeGRWUGJncGFnTTNkWjl0QjFBZlAwV0x6?=
 =?utf-8?B?eGlEQzkxa1dLNUZzQmdabUJ6Tmc1OGJ4ZG1vVnZtc1MzUGlIU2IzRGpPdFYv?=
 =?utf-8?B?OGZzamJxSmptZEJkQmcveFphYnQ0Qkxzd1RLUEQxUE5EOGNVb3ZzYnhodDh4?=
 =?utf-8?B?V0UwZ0hlNVFBZzlKMGhNYnp5R1FZdzFXOEd6Unk3MGZ5UCtiU2cwWXczVjFJ?=
 =?utf-8?B?ei8zMEVrTUFLTzJ6N01VTmVtd1pKSG9sU0JXTzN1SWtudkwvOW9EK2w5cDdy?=
 =?utf-8?B?S0hKT3pSa0VRQzVzZUR3emV2aW1iOGJKd1hYdVFVOHJRbkFkOEZaUGk2dG9u?=
 =?utf-8?B?S0N3aEI3d3hua3BwbGI1b0N5MC91YmR4UzdXcE9tYytaZmFNbERtOVRtYzhG?=
 =?utf-8?B?MFNrUkFqY082MGkwZm9lT016ZVYvcjBVTHhMNzR5Z1lBVTN6ZXhYWHo0SkZl?=
 =?utf-8?B?Rm9UZS9WVzhDSUFIMjdlMWVmTENlSXlGR0ljanBpSjIyeDg5SHRIUTA5U1Mx?=
 =?utf-8?B?ZnhzaVhnb0hDN05nM3FkU1Njc0U0d2c4YnlnTHg4eEJydWsyRTNwNWZmRFdU?=
 =?utf-8?B?ZWI0ZXcxeldCcU5hZnF0NzFybUZHcWN2b1kvNWRZTlI5QWM4MFkyQTQ4NFMz?=
 =?utf-8?B?a3Fha29YQTlYY0JWVHZQNFdEaXRRbko2dEZKOUNKUGtGY1RTN2UremNkTCt4?=
 =?utf-8?B?UW1OdmFUYk1IdWFHZWJ4WjFFT3VNZ2YrQXhKYjhKRjNiYzJQeEVITkV2MDRV?=
 =?utf-8?B?d3hmZWdnQ3hGOVhvdkRPMDZTck5rd29JdGJIeG52WmZKZjV0ZmMwbHRTMnl4?=
 =?utf-8?B?Ni9IYWErM1VHSWU3L2ZsR1JQd0VXeDlIMlZ6b2JTSXNmUjJGTzA2Y3NtUFlh?=
 =?utf-8?B?OVZhVmlaMUFjd3BablJxbFpRRGxRSnVLc1lTcU5rZXQ3MDlDZEtnK1ppMXU2?=
 =?utf-8?B?YlFxTXBtTFZZbnBQa3dVV1RzN0k4L2E0dzJ2TVZqNzhQVzhNbnIzNFBkUE1I?=
 =?utf-8?B?Ukc1QXFZWVZmZGVmczJlS3gzdE1yeEhYYmpaNHRGQkxDS0c1ZGkxZ0FyR1JT?=
 =?utf-8?B?QTlmUzdhWWJGeWpTMVA1S25TM2hTd3M5TXZRUkRvTUgxVTBvYXkvWC9VVGtK?=
 =?utf-8?B?OXBQbDF1RXFacUl4bExCMTV2N3hBSGlvaG9RTTVGRENrRlN1WnZxYmcxNVA1?=
 =?utf-8?B?RU1uOW5JOUZaWGdUVnlUZTlxanMrNmNJenVnb25hcGpxQ09jVlMwalpiQ0l2?=
 =?utf-8?B?bkwzNzNyb0VsZkwxNWVDQmxFZ1ZkUXFZTnJ1R1ljRFQwYndZc1krY29ZQ3Bi?=
 =?utf-8?B?K1crWjgrL2NKVlFkMGlUV25IUzZPcjNTODZ5d0RiMG0rVm5vMVprcXBKV2Ew?=
 =?utf-8?B?dmlFZ2o2cUJpZkVldHRJTnY1OTZQNUU4VGdxd1YzZlNJcGI1OHYwS3l1bGVk?=
 =?utf-8?B?VHNXazZtQ2VUdk5iWCtTQ0lRVFErcFh4TFVSTkdEZzRZQkNHSWR0MzJLYUl4?=
 =?utf-8?B?S2hBMUpWbmdscSthZWFmZ2d6djAyL2FvZzMwdVdDckxNRDRSZkJ1TFdLb1VF?=
 =?utf-8?B?ZStHK2o5TVFHVG1WR0F6OVFkUHN1N1V1dnRocDBhNHJaMFdtUDR1UEwyeUw4?=
 =?utf-8?B?cy84SGMxcDBySVBKNzJoRHcwemRDRU04OEliejJHUjZrTVJVNHJTVWhFOXd1?=
 =?utf-8?B?TUo1cGg1VnZwN0cyZUkxM1NIZDUvQXZVd21OZm1PSzFlbk42ckg2a0pGeGEw?=
 =?utf-8?B?M051ODVZcHNTSERkU05oa2ovbFRkV0JmUlhGaWUvVWZoM0I1K2p4S3hVTkJ5?=
 =?utf-8?B?L1ZEM0NGbG96ZWtpWVFyMXcxSzVvWWhMWVlnUWgwdmxyZXRzTzE5dng1dVRC?=
 =?utf-8?B?V1ZNOHNrWEhRa09RQ3BOYk9rY2FJWWpENUhrR2VVbmNmZ3Y5cFFwaitWOTBy?=
 =?utf-8?B?RnJxRzhqQ0xIN3M5anNOdk50eG5nclJnYUVGZXZ4WTh6RGNRUk1RTmhMM3dk?=
 =?utf-8?B?Rjc3YkpZYjdRT1VQaDI0V3ROOUNOTmpMb2ZsNGZiTDl0bmhyRXRwSHAwaWxW?=
 =?utf-8?B?Y1Q3UTNjamRSTHZIaGtPYlBNSGJycWxXd2t6TDFpVmduc3cvenlQTm1heVRw?=
 =?utf-8?B?ZjZ5ekRtYVgrVFVVSk4vKzREMlhLNkpmYzhzVUppdmZTaDRzZWRIMDJ4MHJZ?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17444bab-624c-46a0-9f2c-08dc65c48c75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 07:43:22.6979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4G917FDAHVPmxIgUE7iCeONqRkv2PSZ7VV53rd2JxVbzQDIhVQx/uZ8RygtKjjO3RzdJKGA1HGDa0MavEJG1eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8605
X-OriginatorOrg: intel.com

On 4/26/2024 2:14 AM, Sean Christopherson wrote:
> Extend KVM's suppression of userspace MSR access failures to MSRs that KVM
> reports as emulated, but are ultimately unsupported, e.g. if the VMX MSRs
> are emulated by KVM, but are unsupported given the vCPU model.
>
> Suggested-by: Weijiang Yang<weijiang.yang@intel.com>
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4c91189342ff..14cfa25ef0e7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -491,7 +491,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
>   	return false;
>   }
>   
> -static bool kvm_is_msr_to_save(u32 msr_index)
> +static bool kvm_is_advertised_msr(u32 msr_index)
>   {
>   	unsigned int i;
>   
> @@ -500,6 +500,11 @@ static bool kvm_is_msr_to_save(u32 msr_index)
>   			return true;
>   	}
>   
> +	for (i = 0; i < num_emulated_msrs; i++) {
> +		if (emulated_msrs[i] == msr_index)
> +			return true;
> +	}
> +
>   	return false;
>   }
>   
> @@ -529,11 +534,11 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
>   
>   	/*
>   	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
> -	 * reports as to-be-saved, even if an MSR isn't fully supported.
> +	 * advertises to userspace, even if an MSR isn't fully supported.
>   	 * Simply check that @data is '0', which covers both the write '0' case
>   	 * and all reads (in which case @data is zeroed on failure; see above).
>   	 */
> -	if (host_initiated && !*data && kvm_is_msr_to_save(msr))
> +	if (host_initiated && !*data && kvm_is_advertised_msr(msr))
>   		return 0;
>   
>   	if (!ignore_msrs) {

Reviewed-by: Weijiang Yang <weijiang.yang@intel.com>


