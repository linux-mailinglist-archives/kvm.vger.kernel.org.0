Return-Path: <kvm+bounces-32887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C8C9E12E9
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 06:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD51F162477
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 05:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D1A175D39;
	Tue,  3 Dec 2024 05:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bU28J3G9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA2A13D8A0;
	Tue,  3 Dec 2024 05:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733203921; cv=fail; b=BBETlkbSFoCIM4sRC/uuGkuZJ+f6plbjftwJt5Y2887uj31c6LdtPvgQ0k+elFdUYEbDmI9G4v5aY8RBH/P3EAh3MK/w9mOWiQY8bQEyTIcrHtgIAklJIVKfL/IwgS/aPGWZWN2r7H/DTXIh1RQwBIwIGrNIjzcOq/L39P/VEx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733203921; c=relaxed/simple;
	bh=Jfb+AAa//puqz3A38OUfgH3jxP1HsAfQMsc8gUo3ysg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g/bObWQN7DTPTNQsct7C+jK1mtuNqSXUau2cHaQhwefdcKIF4FI69Qejhl+xW1Sh8Qk8cZh2M29kqc2FC9GqLy19HJRNja1OqskT00GNBPK7VRTh6qCZ5WlJexxVqaB4VKqiqWKH+J5U7rNI5qbkTgeT2IsRw3jIfPub0ZbsE0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bU28J3G9; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733203919; x=1764739919;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jfb+AAa//puqz3A38OUfgH3jxP1HsAfQMsc8gUo3ysg=;
  b=bU28J3G9nQEhCkCVcjNwWQ5AOQeYqY2Z4zbHBIOCVOdGgOyBdZUcFJDI
   QXLoQnwSPpyF6AQ5RF2eg2PZZ9oFXQHnGegnYWIZ2aIRE+5rYduzsuxLS
   NGqMy5aFigNp+Ns5Vctc3wde/OJGmwN/B3SdG9jT53MVCCXyOpBEfhc3R
   lxIMLTIB50l03rB4gguHM+rHR6iGdZO1cixsAXwRhVZDEawbXjEf9R05A
   kRJLn2y9Vx+Vh6X7ie0SvEuTk6pB4QFrJShLo1xj6KzPBIxDmNNmLGLnd
   XToHkcauo3jhbj0W0Oti3MOW1dg5TVZ7NfBqjuisye7p+b7OEHcqdwsGV
   Q==;
X-CSE-ConnectionGUID: e0hKNMOfTsCLozh1W3TAtg==
X-CSE-MsgGUID: 875dlWVoRrKGNWSnO47Idw==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="32747381"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="32747381"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 21:31:58 -0800
X-CSE-ConnectionGUID: wY197Li0QPWohidTl+mLfw==
X-CSE-MsgGUID: naUR+AABRfmOO6zkXQez1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="94155963"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Dec 2024 21:31:58 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Dec 2024 21:31:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Dec 2024 21:31:57 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Dec 2024 21:31:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=klLM5odGosDlo4fQCNi9E41RxUtH/nW5LBJQw+kSEHQQ6tRmxK67w0Gb+NO7hZFhWGeCGpieIvdI9U0dcj6ONWgoMmZ3Kueu/GYdCAoB9biPiCNjBpOWtBLTiUs5q9wej6Z32Y/wDtpW0nu/ohU2Oy2JHjFAh8u7dmo46XdSY/fp3HXspYti3y86Xfb8ns87R254eustJ1SqD10dEgJwP9EuZT1c+zu0UvwozEj/EeNu87eTrdsdJ0+re/XpzqBmbAjIQLOfwRP3QOfh7mzjCOgdLEWr8Wucc+JV53E9fhBOtcjSurETXd/Tt0CqF9yCaSTt/QT+x23rSd8xLgY09g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8HRtdSzUP/IJgRt6wVLeKaq4qswIX2LJV7E8kp/6kY=;
 b=LH7vzqToHCXBOh752vLWVbKobcsF5yf7IzqvbF2De0bq5Xf93krne8ZD82UtEszoR4eabAT7ypf7kUB5EndHmi8W35jA8QeH92qkBCc5RWRiB9QN8PkBZup3KC6IaDAAqyOQ6+NDJe13a8N8eY8Uk6zXkXSYHmdQbjq4pf7sl6SEL6zJpd6ZUlQlumHIMYwpw6TcoQc7aS+lTP/1SfDW+ciR1MUG8J9KEiwElLWLghcnJoqzcqbwwn+6U16NnIqIteVknR8ts9WFnRA9dwKsNzE66P1ei89/9AIVDZtgfZ0Kr8aH0vMHMareOlHGsAfY4ytIOiCFaHOLaeo3Y/EdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6080.namprd11.prod.outlook.com (2603:10b6:8:84::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.19; Tue, 3 Dec 2024 05:31:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 05:31:47 +0000
Message-ID: <6e49b1cb-08ab-4fb0-a89e-c78164309ef9@intel.com>
Date: Tue, 3 Dec 2024 13:36:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: Deadlock during PCIe hot remove and SPDK exit
To: fengnan chang <fengnanchang@gmail.com>
CC: <linux-pci@vger.kernel.org>, <lukas@wunner.de>, <kvm@vger.kernel.org>,
	<alex.williamson@redhat.com>, <bhelgaas@google.com>
References: <D0B37524-9444-423B-9E48-406CF9A29A6A@gmail.com>
 <A8CD6F73-CDBC-45D1-A8DF-CB583962DB8C@gmail.com>
 <5b2b0211-81d9-4ec9-98d5-b39a84581ac0@intel.com>
 <CALWNXx9gwDZASU6Hm68hz05P2EcB0BgqPnWKkUaAK_BNAqj8mg@mail.gmail.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CALWNXx9gwDZASU6Hm68hz05P2EcB0BgqPnWKkUaAK_BNAqj8mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:194::22) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c2b5aab-7177-4f27-b1b9-08dd135bc7b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a05WOXlDZ3B6ZGtmNXR6L1lOdUFwWU1rak02ZllGL1g3NlJIV3gwTVV0ZVFz?=
 =?utf-8?B?SGJteDd6TTRJd2hzNVYzMnBlcjl3UllqVnJ3endYYXlVOEVQaHNvY0lzbzMx?=
 =?utf-8?B?eWMyNkhHRytFbzV1R2VGM2RFWmUrTnVhMVVsVGpVRzVOVnFYbjVOZG1HbzBt?=
 =?utf-8?B?eEdMUE5sT1hqREJObSszMktqbFZBbXdzaDdXTnFXZ0xsMGVibE10QTVSWldH?=
 =?utf-8?B?WFhUd1h4TktaNmZXQlFJTC9JY0FuYW5ONGNNK3k5Wnd6TURiNUZNbFBybmRU?=
 =?utf-8?B?MlRCSUt5RjhFRXkzZzRDdFNuK0dPUXg4QjNDZDlDamZWd2ZjUWxoSy8rVG01?=
 =?utf-8?B?ajlCTHZYc3lFT2NaWkE1VEVQdVVyK2VkdjVzOTdjNVJEck5CazZ4L3lyNG1M?=
 =?utf-8?B?czJYR3pvU3RIeHRtWVlmZWtCRE5ZREl4dUNQU056RjRSMEJibjhmQ1I1amVs?=
 =?utf-8?B?RnFwWlJnbUpteUh1WHFzQXFuZjBhTm1SMHBUYm41MEJUeFovUGF0NUJPQ1dq?=
 =?utf-8?B?bSsvZ1diUjcyWGlyVjkwRlpuVkxCeXFrM2lkbXEvZmMwL3VVRmRPRGl6bG9p?=
 =?utf-8?B?MHJaWng0UU5TaXhuRENSbDBoaVdRbnJlK0Y3aXdJbW8vT093ZTFqZ3pKbk8x?=
 =?utf-8?B?R09HenRQNnFUVGNVWTczRGxPTVpiQkNOOXhBazVzNzI1RHQ2RDBtd0RvWWd5?=
 =?utf-8?B?ZGxVeDZEcDRuY2s5TktlN2YyYThIK3p4SndpdDFIYUpweGZESVU2R2xpZjhk?=
 =?utf-8?B?ZVpkZldqUDNOMU1zWnVlV0lTVnNSK2lMWFBVWVNyelIrYTRQVk85VjNNeEZJ?=
 =?utf-8?B?cWdYZFQvQThwNnJpN1V1eG0xUWo0TlczRDE4U0VnL01lMkJMYnR4bmN2cHFn?=
 =?utf-8?B?eXpncFgvSWhCTXd1KzR5UkZwY1FKTkFNN3ZwZ3kzdDl6bDlUYVowT1BxVFFO?=
 =?utf-8?B?OEFoanFkMDJEUmc1blZNQ1dmRzhET053bWpMT0p5VGk0ZDJnQUM4blV6Rlpr?=
 =?utf-8?B?d2kybEdxSFJMUm9SZkcxVlhRaDRXdXVqa2tweE1vV3RQbHllOVlWYklzSjlK?=
 =?utf-8?B?Vmh6ME8zYUZDb2hwM2xrVzRmeTVkVmxJRjBCNTFuTGlXTVprc2ZOSWMvK2pI?=
 =?utf-8?B?SjZOQzZtNHBEd1dkS08wYzhqMnpIekRobjNJa0Q5WkVIK2N6by9Wa1V1RURr?=
 =?utf-8?B?b1ptKzViOXh2SUNEUGZaTFp0NCt5bElhc3cvSm56RGhKVlpuM2s0WnRWcDJY?=
 =?utf-8?B?NkFSb3ZwZDlqTlIzendmYmZ6bjByd01iT0s2TTlmaVZnOTlONzhFazlNQjRH?=
 =?utf-8?B?N0xuZ0JqOUYzNVpDQ3c1My8xZzFFc01BaTZzOTR4UnoybjFxbFpaY0RZNisz?=
 =?utf-8?B?NDNSVFNjMFRJbmFRRzkvL1JsTXVXQitYaldlSVB2SUk3MCtVR2djSHExNjBZ?=
 =?utf-8?B?elA4Y2w2MEd1di9QMEFsZmhDWUZDRVlaQ2FQcUVwMWdleW5xVlhWb2YwbldS?=
 =?utf-8?B?UEttT01NLysxbExCcDBackkyaTNYc3F6cCtmTjZNMWg3TE5BdHljbU5iVU5I?=
 =?utf-8?B?QS9RSDQ0T25uN0VqQmNrUi9VWW5tVzhOM1hTM01UZW5KN0FXN1h5N3hBOWxK?=
 =?utf-8?B?WE4vdWwxb3pXRWx6Vm1yVEJiZmthb2JMd0I2VHkvTW1kTE00cC9BN2hLR1lK?=
 =?utf-8?B?RzhlSSttZ1YwZVJZUU9TbUlyZVBNellYSjdtcHgzNVJrSy9VdHllUVZGSTRK?=
 =?utf-8?B?Mmk0djZBeVJCQlo4S3VkNE1wL1BINm5RU3R6cVhJS29CZTBNOVhtU1haa3BL?=
 =?utf-8?Q?q84aZYX2+dGaKfhy1wuBe6X5Me3OSDJt+VJdU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkxaajA3RWJ1WCsxZFdwbjNOMGlsYXI3eDZNVFNla3JnWVFQbUVGMjlGTkl5?=
 =?utf-8?B?Uk9hMWFhM1Q0cHhacmdFL0hZVHJSNGlFOWdrWC9kTWRoUEhDN3ZqM0Q3clht?=
 =?utf-8?B?Wm5TK0Joa0t5L01JSWlORHZOcFZsV24xZE1wZ3dxY2tYU3NaRGJkMVlGckxF?=
 =?utf-8?B?SVhHN1loNWZ0N1dSVnFzZW1wR0hkYmQvdWR5YUhYZDAySXZBdEVwVmYxbkEw?=
 =?utf-8?B?STAyK1VtMC9uZWlXV0JjQ3NKL1RLektJaUFmeUp5bkRuOXR4UWtsMWdadGQr?=
 =?utf-8?B?WmxxTHNoN0FiaUNsb3Z3TGtQT2UzWmkxbE12L3hRVUhRNzdrd1F5UnQxN0FR?=
 =?utf-8?B?QnhPdndkSG9QTGVFWFRoV3c5UWZHa0ZWRTNZcTRmeGZHYW9qQUJvTTAvaDV1?=
 =?utf-8?B?KzR0VkJVNWZEb1RHMzZSaVNMcjY1QThOR08zc2dlOS9MVjBBMDd2anRtaXVS?=
 =?utf-8?B?NUE0aG5Ubi95YkJiVERBc2dyOXUzbmJ3MnJuRFVDNDlIcEdMckE0dVBsWHVH?=
 =?utf-8?B?RGpad0d2Q1J5MTM4bS9VZEtxNEh1a3ZEaDl4Tm4rSzQ5WldwZDZTWlRsZEpU?=
 =?utf-8?B?eTVMTFp3S0lOTUJFbjNsWWIxSmw5T1k0UlFkUnJxVGRjWkFWejh5eWlXL2h0?=
 =?utf-8?B?WVJrc3h5MlllQ003SjcrN1crb0RMS044cWxmK1RpRExyQkI2bG84c1B5QkxX?=
 =?utf-8?B?bWNlVGVVWDJZYysrV3l1YzFQYzd0Skdmd2JuYzBqTFVPcVJnTFdkTEVzWEFt?=
 =?utf-8?B?akdMYkttTy9oT1pkOXZUdmJVS0ROMnRNTUtFbUxIWFZoS2kxUTBTaFJ2Nk14?=
 =?utf-8?B?ZVdTcnBvWDRaZ25oZXk0aXQwdnpVUVA3bWFTN3lVQmtjWTJtUnB6YjhOQURB?=
 =?utf-8?B?SEZQakVaTFYwUEhCMy92WEpEemo2dWtEREVIY3d0UFVtZ0NoZ3E5dG9oSzNK?=
 =?utf-8?B?UDZmNHVmTmZNVzMrYWNQN1hCd0lKR1pvZFpCL1F5VS9oRVFVSU9LSFRzMHJ4?=
 =?utf-8?B?bDlQSlh5bS9INlJ4amxqZHlPaVlvL1RjaTNRZVhVc0hZMlM2dUxGNVNjV2ha?=
 =?utf-8?B?OGI3ZW9MTGJVT0VtOXoyZEg2cXFhaUY0MUNseDFKVk9kL284V2tnRU1VV21i?=
 =?utf-8?B?Y2ZwSGxzVE5uTjJTL2k1bmhwb0dzc3EzT3dIYVhCajM5NkNzaTVWTkJCVDZw?=
 =?utf-8?B?RXRQWVVuQTEvbFpWcGpVeGxrU3d0ZHJWbzU2cFFRQkViMHZLTmN4TVVGakNB?=
 =?utf-8?B?eWpyUEdpNjNROFo3MlNvQURRdzR1b1N0Y2hXYmxJUlhyRHdXTEFXOWFVd3Zz?=
 =?utf-8?B?RnF3WmErd0t5bE1sVklaM1dmeHRBeGNqbWp4Y2V5TzdtQjE2ajFxT00raDVl?=
 =?utf-8?B?ZFY3aURDVFZnaXNMRHlzR2dSaHRtUTNsZmJHczVSK2tUWlJRRVk4U3JYRlpm?=
 =?utf-8?B?WmpiYnNHZXpxM25XRXhDZ1NEYnhQR3pqUWdsQUF2YW5RRm5rcVpMc2lLVUg2?=
 =?utf-8?B?Q1Bnb09VRVcySCtrT2M2bEs2ZW52VU1aa1A4NEJ4M2lRaGdqdFNRbEVWVjNU?=
 =?utf-8?B?blN3KzhsT3ZvZjdsRWZtS0RpRkxWdkZzVnBqYlJBZlFGN3dTVHZMTHRFOFlk?=
 =?utf-8?B?MVI5UlFla3czdFJnU3hqcVBEdGRnc25YQ0NnN1hUNjlORTdNNVhHcWFBNm5F?=
 =?utf-8?B?QzNDUVdkazRrYzBuc1NZUy9OVEtwUExCcXRjV3A0NElrNGtrSlprMlVuczNC?=
 =?utf-8?B?VlRNZzE2M1UzVW52Y0U5OGVTWGlGdmc1bE9VNDNXV0Vkb2ppK2t4VFdET3cr?=
 =?utf-8?B?UUExQ25IYm4rTTdLdFNKZnBUWFFOTVc0WTZxbEJhaU1OVTVUV2Z0eGsxb24w?=
 =?utf-8?B?MlJoSHpId2lFdmJmL0ovREQ2R0ZUazVNN2NOZVJZdHExeUFCcHZjWjN1QzFk?=
 =?utf-8?B?MUIyYXpnenkvSVpraVIyQjA5Zit0a0pzUUIrMkUycDFsclZpdzcyeSszeW1n?=
 =?utf-8?B?SFJsRXJ3TlFHdHhrZWFCdDJ1ZThuYTZETHA0MHNHdVJZWTQzMEo5VEFaYVlU?=
 =?utf-8?B?SDRaYkNXWkJiTWFtVCtwOXBLVHFiZ3hPRWlyYXlWNUVMMkRROE5UWlRCemFk?=
 =?utf-8?Q?R8kbRA9vupAmSfTY1sa6Qs7he?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2b5aab-7177-4f27-b1b9-08dd135bc7b4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 05:31:47.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIdV8xcJqhbRPUfFjmT88hKd1SKlW5apk3VFyLIPtM9nUfAFwCbYjCFlI68U0WolZx8+YnTj/iXJidQB+z7c9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6080
X-OriginatorOrg: intel.com

On 2024/12/2 11:25, fengnan chang wrote:
> On Fri, Nov 29, 2024 at 4:00 PM Yi Liu <yi.l.liu@intel.com> wrote:
>>
>> On 2024/11/28 11:50, fengnan chang wrote:
>>>
>>>
>>>> 2024年11月27日 14:56，fengnan chang <fengnanchang@gmail.com> 写道：
>>>>
>>>> Dear PCI maintainers:
>>>>     I'm having a deadlock issue, somewhat similar to a previous one https://lore.kernel.org/linux-pci/CS1PR8401MB0728FC6FDAB8A35C22BD90EC95F10@CS1PR8401MB0728.NAMPRD84.PROD.OUTLOOK.COM/#t， but my kernel (6.6.40) already included the fix f5eff55.
>>
>> The previous bug was solved by the below commit.
>>
>> commit f5eff5591b8f9c5effd25c92c758a127765f74c1
>> Author: Lukas Wunner <lukas@wunner.de>
>> Date:   Tue Apr 11 08:21:02 2023 +0200
>>
>>       PCI: pciehp: Fix AB-BA deadlock between reset_lock and device_lock
>>
> 
> Yes, my kernel version included this fix.
> 
>>       In 2013, commits
>>
>>         2e35afaefe64 ("PCI: pciehp: Add reset_slot() method")
>>         608c388122c7 ("PCI: Add slot reset option to pci_dev_reset()")
>>
>>       amended PCIe hotplug to mask Presence Detect Changed events during a
>>       Secondary Bus Reset.  The reset thus no longer causes gratuitous slot
>>       bringdown and bringup.
>>
>>       However the commits neglected to serialize reset with code paths reading
>>       slot registers.  For instance, a slot bringup due to an earlier hotplug
>>       event may see the Presence Detect State bit cleared during a concurrent
>>       Secondary Bus Reset.
>>
>>       In 2018, commit
>>
>>         5b3f7b7d062b ("PCI: pciehp: Avoid slot access during reset")
>>
>>       retrofitted the missing locking.  It introduced a reset_lock which
>>       serializes a Secondary Bus Reset with other parts of pciehp.
>>
>>       Unfortunately the locking turns out to be overzealous:  reset_lock is
>>       held for the entire enumeration and de-enumeration of hotplugged devices,
>>       including driver binding and unbinding.
>>
>>       Driver binding and unbinding acquires device_lock while the reset_lock
>>       of the ancestral hotplug port is held.  A concurrent Secondary Bus Reset
>>       acquires the ancestral reset_lock while already holding the device_lock.
>>       The asymmetric locking order in the two code paths can lead to AB-BA
>>       deadlocks.
>>
>>       Michael Haeuptle reports such deadlocks on simultaneous hot-removal and
>>       vfio release (the latter implies a Secondary Bus Reset):
>>
>>         pciehp_ist()                                    # down_read(reset_lock)
>>           pciehp_handle_presence_or_link_change()
>>             pciehp_disable_slot()
>>               __pciehp_disable_slot()
>>                 remove_board()
>>                   pciehp_unconfigure_device()
>>                     pci_stop_and_remove_bus_device()
>>                       pci_stop_bus_device()
>>                         pci_stop_dev()
>>                           device_release_driver()
>>                             device_release_driver_internal()
>>                               __device_driver_lock()    # device_lock()
>>
>>         SYS_munmap()
>>           vfio_device_fops_release()
>>             vfio_device_group_close()
>>               vfio_device_close()
>>                 vfio_device_last_close()
>>
>>
>>>>     Here is my test process, I’m running kernel with 6.6.40 and SPDK v22.05:
>>>>     1. SPDK use vfio driver to takeover two nvme disks, running some io in nvme.
>>>>     2. pull out two nvme disks
>>>>     3. Try to kill -9 SPDK process.
>>>>     Then deadlock issue happened. For now I can 100% reproduce this problem. I’m not an export in PCI, but I did a brief analysis:
>>>>     irq 149 thread take pci_rescan_remove_lock mutex lock, and wait for SPDK to release vfio.
>>>>     irq 148 thread take reset_lock of ctrl A, and wait for psi_rescan_remove_lock
>>>>     SPDK process try to release vfio driver, but wait for reset_lock of ctrl A.
>>>>
>>>>
>>>> irq/149-pciehp stack, cat /proc/514/stack,
>>>> [<0>] pciehp_unconfigure_device+0x48/0x160 // wait for pci_rescan_remove_lock
>>>> [<0>] pciehp_disable_slot+0x6b/0x130       // hold reset_lock of ctrl A
>>>> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
>>>> [<0>] pciehp_ist+0x236/0x260
>>>> [<0>] irq_thread_fn+0x1b/0x60
>>>> [<0>] irq_thread+0xed/0x190
>>>> [<0>] kthread+0xe4/0x110
>>>> [<0>] ret_from_fork+0x2d/0x50
>>>> [<0>] ret_from_fork_asm+0x11/0x20
>>>>
>>>>
>>>> irq/148-pciehp stack, cat /proc/513/stack
>>>> [<0>] vfio_unregister_group_dev+0x97/0xe0 [vfio]     //wait for
>>>
>>> My mistake, this is wait for SPDK to release vfio device. This problem can reproduce in 6.12.
>>> Besides, My college give me an idea, we can make vfio_device_fops_release be async, so when we close fd, it
>>> won’t block, and when we close another fd, it will release  vfio device, this stack will not block too, then the deadlock disappears.
>>>
>>
>> In the hotplug path, vfio needs to notify userspace to stop the usage of
>> this device and release reference on the vfio_device. When the last
>> refcount is released, the wait in the vfio_unregister_group_dev() will be
>> unblocked. It is the vfio_device_fops_release() either userspace exits or
>> userspace explicitly close the vfio device fd. Your below test patch moves
>> the majority of the vfio_device_fops_release() out of the existing path.
>> I don't see a reason why it can work so far.
> 
> Forgive my poor English. Let me explain in more detail.
> irq 149 thread take pci_rescan_remove_lock mutex lock, take reset_lock
> of ctrl B and release reset_lock of ctrl B. Then wait for SPDK to
> release vfio refcount connected to ctrl B.
> irq 148 thread take reset_lock of ctrl A, and wait for psi_rescan_remove_lock.

it's 148 which holds pci_rescan_remove_lock and wait for the last refcount
of vfio_device.

> SPDK process exit, and try to release vfio refcount connected to ctrl
> A, but need to wait for reset_lock of ctrl A.  Since SPDK is blocked
> here, it won’t release vfio refcount connected to ctrl B. So the
> deadlock is happening.

but I got you now. So the SPDK process exit thread closes the vfio_device
A and B sequentially. The vfio_device A file release is blocked by the 149
while 149 is blocked by the pci_rescan_remove_lock which is held by 148.
148 is waiting for the vfio_device B's refcount which is done in
vfio_device B's file release.  The vfio_device B file release is not done
because of the exit thread is dealing with vfio_device A. So this should be
related to timing. Did you see any difference w.r.t. the order of plugging
out the devices? Maybe you can try something different to double confirm
it. e.g. plugging out the devices as the order of how they are listed in
the QEMU cmdline.

> After my patch. When SPDK exit it’s async to release vfio refcount
> connected to ctrl A, it still will block, but SPDK can still can
> release vfio refcount connected to ctrl B. Since irq 149 release
> reset_lock of ctrl B, it won’t Block. After release vfio refcount
> connected to ctrl B, irq 149 can finish it’s work, and will release
> pci_rescan_remove_lock mutex lock, and then irq 148 can take
> pci_rescan_remove_lock, then all is same as ctrl A.
> 
> 
>>
>> As the locking issue has been solved in the above commit, seems there is
>> no deadlock with the reset_lock and device_lock. Can you confirm if the
>> scenario can be reproduced with one device? Also, even with two devices,
>> does killing the process matters or not?
> 
> This problem is not  a deadlock with the reset_lock and device_lock.
> The scenario can’t be reproduced with one
> device, only two devices can reproduce this problem. Kill the process
> may not be important, but
> the interrupt thread is blocked too, and all lspci commands will
> block, this affects some monitoring
> programs.

yes, this issue is not related to no response from userspace.


-- 
Regards,
Yi Liu

