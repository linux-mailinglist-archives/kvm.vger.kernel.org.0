Return-Path: <kvm+bounces-10315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6323186BAF6
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 23:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C35FA1F226FA
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 22:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F2F72902;
	Wed, 28 Feb 2024 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/OzBoj2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25FD71EA5;
	Wed, 28 Feb 2024 22:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709160573; cv=fail; b=f6oFHOWhvvEgde8CrAxGz3vSK1H2w3Adb+nv2VHQ2Y43vy/7LWilbaVcwk0Iwl1Q6hah4SuHS6AP+5BIEFKnB66rZUwBKh5Zi6+nFggWjJYKfajJx1L2iufFcpdeSfUllCK/2ooYFfOxvpcRomtC9XZeb8sN8J+Uhn1zMMTTpeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709160573; c=relaxed/simple;
	bh=IiXqCI8npsmLYB5g8L1D57ThZr+Xp4T/5RYnrTjLYTU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GkzrRB8Sk5JebghIezH6Y+bqgYEsmWSWsvoys/b4W88trK4RJsGIvmg22REsm4CiSrmGVlx3jz1SIzj0hjQye9qrXMLznR8CTu6gOjLjpp+Pl/9rJVoz8TTt3lJH8KYwPocC1mUZhgx1qGkUW/sYG+qu9BVrHpNmdOoS/hx9KM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/OzBoj2; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709160572; x=1740696572;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IiXqCI8npsmLYB5g8L1D57ThZr+Xp4T/5RYnrTjLYTU=;
  b=D/OzBoj2kNFYQtjuwJ6h+f4VEUZ4UX+o43Cf5Tm+5wSb7UtXiQL3zI5x
   yTyhXZwtST2uIm7FT+elzLDZNinjrj6bKc/Cl2lrZ4YHQoSulXcDMMyUW
   wm7FJ2V13KDWa/VnCgBs6Ob4BvOsocXzvy/g1eg41+aWuHazwckhGKCB7
   W+g0TtHYggb3CIz5P820Qd6cCsvxGiBJF1HiPUiic+r7ypu+EJCHIJpwx
   JJXBOs1kKr4RGl0/BCoWR1FijEfmsUoLWTW3U4YwTOo/fMEhy5D7YuYzz
   YUxHc/f4tOP287Qr8zbx92U0HATwgpSbFADtcnsvPkbC77F8jD3TSJPoz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7378904"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7378904"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 14:49:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7538835"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Feb 2024 14:49:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 28 Feb 2024 14:49:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 28 Feb 2024 14:49:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 28 Feb 2024 14:49:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLpMIp2ukNsh7chhOG8cwZVutXboP24d1vQczCbVtOXp+4ehKkUK7XAlu7ir4iJdQmNxMA8gJjK8nVbtp1HGNo5UYhb3OJK3YW8r5Mkyi/nWOd0/Sbr0MC+U0xG65Og4iGWvpWphOgMtd/BI9p8VxXLE1HadSAhwDDBBkpx0R5skl+UxjmyNQF956PZdJd7vnr87NgMFWM3/6W9NnCzCuNxF2TcXAEqatC5jZuXGPjJbg4PxEftMqte/eAbEUgOFtd+qA2nnMklLgA/HnMYjokiP2tCUYyxXFkPhsiFICmYQ6viF90QU5rdOKkEeERLYS+sJhP8Bn84ix53zy8nwlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m37qmcIRCq328ItxtWuPZkD1kZXPGdKQzQ7pqgrT9hQ=;
 b=M2yMgSHuycxNt67M9hwNy3H+7/fYMI/SjB1vXAznUaEjbzMsEOMyCtqczF1s/KlmwiD4+vCBff9zDfGGPFi2hGs/WahR1yZTZEMhSKcEFjdVjqQDe13yUl8uejZxnBfEW7iGlS9rn113x4BZymOOppaz1+jzTIq7CJ55RlHixv6WDeq7lwB0P/CRE1BBP88xpjxmbW/NS7OSKfR+GjLKmGA6v/rWX93XGWCgGYROzlnclu6edFl80cLmjssTCGYZ5UqEGCgY54apT2KJMhAw1OsVhKpVTsyJdQIWXRF+0g9Hnz4rO6U6XHO0CZ+fydVJBxWEJKhVdbn2S67Hvlubyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB8235.namprd11.prod.outlook.com (2603:10b6:610:187::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.25; Wed, 28 Feb
 2024 22:49:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Wed, 28 Feb 2024
 22:49:22 +0000
Message-ID: <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>
Date: Thu, 29 Feb 2024 11:49:13 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 008/130] x86/tdx: Warning with 32bit build
 shift-count-overflow
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::30) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH0PR11MB8235:EE_
X-MS-Office365-Filtering-Correlation-Id: a6b1a5ab-9a2e-47e2-fa47-08dc38af8185
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhiu5RIyuPzFaKXTUjB1t8RJqBHU7465AG0BLG8ecMiU8Y1Bkt9rWaWZIxhym9d29XHwOQDisUneFaJ43unWEnJ6uK73A3mKXUeLHoaHDYYLwaC1zBuUZqsT9dUNdUFvzCG6vTWLITpxWLc4l1iWu7zYms77OAb97FhYqy2Z0FT4ChkM+Bf0TB2UnFsRJ8lUuKr/m7YeIustdwHmDiGFD9Q1+v5WH21IwxTVLe7HTtsRVYRlP9oHKb+f6k6guf1NsGoNolv9cvKeGxc9Etzmv8WZmQl80VFRr3B/24vw66eE2WuoDvv6ECg9+MMjjrg0FF+U/ZoD+Um67s6fwnQUTEirgrb49E5QfbzMwahgtGxVY1TuQ52IiZn96ayljxWh1GRYnwcbkC5CcCfzUT6L0nqJ0b4ouF2CtfPFphe3hqECgH6CKKs4yBh/ZeMwkdjK6ho8WSmCi4wAOIp3NWYn5S6zZyI2mpI5Ev2cTGmoaW3mTTt2foOojryJX2kkufPSVSgXAoc+ZJ9DCDsYqdW1+otOWnty6maxpzeI1fQc/0We7tXLRWlQDy4XmZR2ech3pRKkqZqTkZmegtb9PWXWhXdinPcxZ/ZM1zVdUPHaviHJS/LmDSK1S19sl/BtG1oBKgjqx4eL7joOjb+nqujvBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amU0U2tUaGJQcDZ1YXpmeVF4K0N4VWd1c2FSZkt6QnpRZHFtc2NNRGUrT0Y0?=
 =?utf-8?B?Q3VxTkVNUnI2RjRoMWplbExOU2kwTmN2REZ3WjhNS2Z5bUtJNjg1YkJ0SERX?=
 =?utf-8?B?b1F1WkpuRDJ1Skx2RDk1WGZzS1pTL254N245Ui9qdVRQMlBVSTFNY3lNZWxV?=
 =?utf-8?B?b3pUczNJL3hxYURDNG5DOG1kcVRZOGZGUzFlWUJXT1EvQnRNcWdLS1JWWElF?=
 =?utf-8?B?NDZNa2orQk15c1VER2FOeDJmL0lOYS9xdDY4UWpRaFdPTGhOc0Mwc3BMT2cx?=
 =?utf-8?B?ZWplSjJ5OU1Za1RBcHpweHhnY1p1U1BuVTNsQmdJY1dueFRGOWFrMjdyY0pT?=
 =?utf-8?B?SVI5RFhiMXViQy9kRERHSlQyMDJnb0RlNVVnNG5uTXZhSWxLbzlnd25iWHVE?=
 =?utf-8?B?bUtxeHoyclZpVmppV3pDUUFUaE01dUwrazVBZDJtMzQ2aWI4MXhsL0RTYzYz?=
 =?utf-8?B?WDZBQUpNdnlKMFB2UEM2QmFmcnBhck5LSkkxVWF2S3VwVG1hdC95Q1VqOUFL?=
 =?utf-8?B?akRlM3prUm5JWHJ5ZnpRd1BBMnhxZVJ3SlQ1bjczeTFQYU5JZ0xMS01URGMr?=
 =?utf-8?B?eTkzSFpJQ2VFQTd2aDUwVXNlNFdPWCtVTmdYMXZlekQxU00zR1NkVmJ6MUtt?=
 =?utf-8?B?NTdONWVQcVp3MWxEeG1XemlabFlOOU9PTERvUlFWTzU1cldlcnFIeFpiL0lK?=
 =?utf-8?B?N1EyR2pFQzNyc2V2cUJ3Z0RmVDdycXNGWkEydjZIVnFIYVAzbm1hNFk3VStn?=
 =?utf-8?B?RS95ZytOeklRbWM5MnFsQktONFE0UUI3M1l3Mnp5Y2UvUmk0U0VnWmI4alB0?=
 =?utf-8?B?SFBJbmFKbXhwSHpmaXpLUHY1M3pLV3NjaDE3aTl0bW40UzdybmpVN0NEeXdj?=
 =?utf-8?B?UzdwNVRSN2ZiTE16OGM3TnhjZC9JMnhQaHhFTjRYc2NNYnhZWmtmVlZDWjJZ?=
 =?utf-8?B?anhmR2tnNk9tMmUxTkpFQy9Na1Q3bWRZNkdBd1NJdEJJNUcvVVJ3eW9TMGVn?=
 =?utf-8?B?dW5kUWtuZlc2VmtiZmFvYWszaUdjSHlleUF6bEFKZmNaZXFOR2UrY1hIdFV1?=
 =?utf-8?B?NGphTXpxQnBLVVhyWjhWY1BBNWdJUjdlcEZtVnc2YTlTeVZrMGNUUVF6TEgy?=
 =?utf-8?B?M2p4U3RKOXBTZjdVbk9LU0tzN3ROdzA0Y0NZNnYvb3BBTU9wcVRuOHJwSXRF?=
 =?utf-8?B?ZFdkcm9hOC82RWVLdEo2dmhpdHRUelp3TWlKYWRwUGt1UjVtM2EwdEZiby9O?=
 =?utf-8?B?cTRqRElnTFNZQzRTYUEzaCs5aTE0dFpYVjdpbGlTYVdZZEMyUlNQUGFVck5W?=
 =?utf-8?B?RkNxVnp2VEYzS2U3VEp3K1llb0QvdG43QUdvREhwTlRXVkhpRVVLaHpGYWx4?=
 =?utf-8?B?dk5EVGN4bGNKUHByU2RkTzBRT25lYXp0MmtFQmN4bnQwV3lQYW9sVitWQWNx?=
 =?utf-8?B?V09pSnZaMXQyaHRTVkdkalNJQWUxZzFueEkvMzBFaGxmNi9hNGNIbys0YWR1?=
 =?utf-8?B?WkhtYnF3N2l5bEE3RHFZUmJtdW9udXQ1ZnJjamF1bjZway9QQ1ZrRXYxeEVl?=
 =?utf-8?B?M2c0RVp2VHY1QVZaeXFXdFdrRmM4WVlxUG5RYnpzd0Q3R080V1crWHdKNFNx?=
 =?utf-8?B?YzlIUExBOUFHYloyTzBPbHovd1ZNNFdvcGhVOWIvN1p2RkhzWVhYYU5NUllo?=
 =?utf-8?B?RE12TUdpVnhyNUh1OGNOMUtFVnJmT2E0K3hzc201NGE5bGd3WmxJeTFPRzBj?=
 =?utf-8?B?emRmd21oeklxTGloa2prOEdGSzl0Y3NsTjdCTVpoRXlQeFBSaFU0U0hjUThL?=
 =?utf-8?B?NkNtcUM4c0VvRGtmeHF2Q0FQQTByay9yWWpMMGFoUDI3aFpFTVVCMklQRk4y?=
 =?utf-8?B?M3Zoa0F2WGdRY204TVFCWEs0Sk1MRm1VSjdYNmNwa0N1eE9pNUpOZGF5Y21F?=
 =?utf-8?B?b1VOaXVpN3JyWkJlV0xGdE1MQTE5TlBUd3dqaEZycEJYK3djVHVDVHl0cFcw?=
 =?utf-8?B?d1pxOVpRZHN4Und3ZGcxN0U4RVZ6a0JIYjI2R3BkMStndlRNd3V4bWp0Y3dM?=
 =?utf-8?B?M0E5NU5JZENJTmZsZUNXYUp1M3FuSU1qSUJrdXdXYm94dkJJb1RxWGd1WURn?=
 =?utf-8?Q?rTBFC1lvvnNlh/fO5ODyx2n9b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b1a5ab-9a2e-47e2-fa47-08dc38af8185
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 22:49:22.4815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ozqLC87r0Xpr397db3i+ymD3K25qbZQajYId93LhVpgBKgQB8auxk1RhZu9CZNC7p0qK3MqVRuzuTCzLhLHew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8235
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch fixes the following warnings.
> 
>     In file included from arch/x86/kernel/asm-offsets.c:22:
>     arch/x86/include/asm/tdx.h:92:87: warning: shift count >= width of type [-Wshift-count-overflow]
>     arch/x86/include/asm/tdx.h:20:21: note: expanded from macro 'TDX_ERROR'
>     #define TDX_ERROR                       _BITUL(63)
> 
>                                             ^~~~~~~~~~
> 
> Also consistently use ULL for TDX_SEAMCALL_VMFAILINVALID.
> 
> Fixes: 527a534c7326 ("x86/tdx: Provide common base for SEAMCALL and TDCALL C wrappers")

+Kirill.

This kinda fix should be sent out as a separate patch.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/tdx.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 16be3a1e4916..1e9dcdf9912b 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -17,9 +17,9 @@
>    * Bits 47:40 == 0xFF indicate Reserved status code class that never used by
>    * TDX module.
>    */
> -#define TDX_ERROR			_BITUL(63)
> +#define TDX_ERROR			_BITULL(63)
>   #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
> -#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
> +#define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _ULL(0xFFFF0000))
>   
>   #define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
>   #define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)

Both TDX guest and TDX host code depends on X86_64 in the Kconfig.  This 
issue seems due to asm-offsets.c includes <asm/tdx.h> unconditionally.

It doesn't make sense to generate any TDX related code in asm-offsets.h 
so I am wondering whether it is better to just make the inclusion of 
<asm/tdx.h> conditionally or move it the asm-offsets_64.c?


Kirill what's your opinion?

Btw after quick try seems I cannot reproduce this (w/o this KVM TDX 
patchset).  Isaku, could you share your .config?

