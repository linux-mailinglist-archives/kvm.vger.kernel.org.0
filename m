Return-Path: <kvm+bounces-20731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 926FC91D03C
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 09:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250B81C20A8C
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 07:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6E73B7AC;
	Sun, 30 Jun 2024 07:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="noERcjYU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B804B27456;
	Sun, 30 Jun 2024 07:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719730941; cv=fail; b=lZGMTjDPVQN+AV5ukVdL9pgHEYZbsmJuUGGGL6y21zzTWHiVFwWV4XrQGTjYXbALIre+tZa544fIfR0FT+NVo1YEgarBOJjvBjQc9jZETp7ilhEFM3K1w7yDigmqYG5FOafyHnWwRlOnNavouPXOET41Q+e+uXYaeTNVN7xpfyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719730941; c=relaxed/simple;
	bh=YzWZjZxLEOOyLajuf7w3m6Bz2OqsrFJBb9pp3C5GVp8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oA5AYv94cnfF7uClw+kH++9Z6+aFb2QH/72J2hrjU+yLrOF6Wrh65Frz6DH6QhwAV/3vTir8wvaoeymZY8xUhEHmGmhpglD8XlKzDO9mYqCZPHYKeYbrZ0M3pcA+tupjs3qmbhs4K1xIZ+AF4nfn633sF8Z4Hl7Siy0dnNaV1SM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=noERcjYU; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719730940; x=1751266940;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YzWZjZxLEOOyLajuf7w3m6Bz2OqsrFJBb9pp3C5GVp8=;
  b=noERcjYUgR8okAb1cuAGEtU88TMRKDzIqttarBTp7JTXXrnPxsCryFf/
   Fvi31+J9m8CFNcZUhPCBD7b7JxcbQ/IFJEV0HZsaGdMqENh2o9e85jmha
   jNemBm7hMG9b4GVpJViN9vDpw/9+/mFdwtlyBHgjNLDYCKR91Qc8+PKy9
   yjsh8by0/tM9BdOY29x6YP02T7K6s87g4zH39X3nGBpf+y1G0gkPHAdGE
   K1FDQ+NVlv5zzUiayH9mstTCmPyiXT3ISeZr2o1e9vG1TSyCoal1Gx8V1
   yAynWt9gqBnk46DgKHCEnVYQZ4PFvacMFl8UFo538H+eGpUWy3/oVOfhf
   Q==;
X-CSE-ConnectionGUID: M0/bRcBFS/OjNoNrwbZm2A==
X-CSE-MsgGUID: WuXLJmrGQkmcWwFWCilIhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11118"; a="27454208"
X-IronPort-AV: E=Sophos;i="6.09,173,1716274800"; 
   d="scan'208";a="27454208"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 00:02:19 -0700
X-CSE-ConnectionGUID: LaJYbaOlTdi0EHg4JildNA==
X-CSE-MsgGUID: Cq85M3+rQquXlCQu/XiKEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,173,1716274800"; 
   d="scan'208";a="45233551"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 00:02:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 00:02:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 00:02:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 00:02:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzezmVyQqz6JZE8tYKtV9MebokhbJMfpzs/p+0eUNysKETWx3QydS5VcgichEm8S9hMFWhRVvuX3sk/5VCNqPbu3bXT01oOpSGyjSD2ushoMuAQMe3+0Yu2mzFpvrqg5w4k2TiS6DNH76db7ZehidkD6ZhrYRV8VuptBoad2ZwHNNITiYVWWdIN9mZtLQ+zCYTyydEKNjoODGnOmnapRHc3yuD/A61QJBv0gWuQMaZu+e1Z9A+IM0MPbSjDZRTrevVSOPpcoZzmNjs3ZDMH3cccTqfLoWnV1X586q5ROnytPWhmdEr+y+xKd47HN485kntjYDuwCiKnDunQXex0nwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiGewsBT+fEHXb0Rb6sTaGXpZI+PEOlpXnP0SEbYrsk=;
 b=oQ/iQm83Enni8XHtjKUjvESmdHeEt167DuiO6lTzQ0oUgWIH4BufReSef36xmkhHGJCRkDvwsFCeaX6pc1a70a0RpJ6uKO1WU201Wqm4hQMVXIn4f+jn9yeDg7AAW3K/+u5k1EudHEHf0nRIdeZLRa6AxT/Xi/LPuBG1jPmoQZtyQajKO9Xh8iHp/0Z76RXf9dxwYPQ4Rdl5tvnIGyelg/Ki3YNMSbc9W25mLUmOJ/0Jsyi766cqDRIwz95vpFYzziI/V31CxgxClnUa5XhzzdHSsBn4xeU9UXkTGEhzEGgHqaa1PiBqIKbk2yF/9R3Adtf+DqNzVXUXQxljPUtkEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5162.namprd11.prod.outlook.com (2603:10b6:806:114::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Sun, 30 Jun
 2024 07:02:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Sun, 30 Jun 2024
 07:02:10 +0000
Message-ID: <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
Date: Sun, 30 Jun 2024 15:06:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
To: Yan Zhao <yan.y.zhao@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0158.apcprd04.prod.outlook.com (2603:1096:4::20)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB5162:EE_
X-MS-Office365-Filtering-Correlation-Id: 07964cf1-ff21-423d-516f-08dc98d28fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Tm1JU1QzZ2Y0WlFNMDZzK2hTUFZKdFplYXhLK2RTQlAybmNIS3lKSHZxUTRz?=
 =?utf-8?B?WGxDZmZaVTBoZGE5bVM2WitORkNLeGtpb1VSZFhnUHkzcFU3RzU4T3JBMURq?=
 =?utf-8?B?TE14d242OHFSSlkvUjlXNGRDaWpoOVpyK2ZaYjdTeXVkWGh0V0QwVm5mekpD?=
 =?utf-8?B?VHRUSDRnVjI1amJDemljbWZMUkhzSnNETmwrYnBkTGlFR3psNE1MQkI1WW9q?=
 =?utf-8?B?cUcxRmdlcm9GSURqMy9kaGVrM0s2cW9ReW93THNRWmphT05qMGoxdW1ybEdS?=
 =?utf-8?B?NmJ0enhIcG9abE1DT3BUOUVGbmhrT2RzWExiekFmWCs1dEFmbUx2YnpIVlh6?=
 =?utf-8?B?dEZ2c2ZySlNOVnNnZlBOMStFR3FFejhlZFN4MDUxQzdoaVdSNGM3VS9YMzFT?=
 =?utf-8?B?WU9SMHNkUHRuS1BGb1lRVGhjL3RnOHUyT1gvRldyRnRUdlhmZWVPNXhBRUI4?=
 =?utf-8?B?N21EUU5tTGY4N0pLQVVWWkFOZmtzMlIxRVFTNkxYaDdzT3FEMGZTeW5GZEFm?=
 =?utf-8?B?WmdNcjhBUTIrcXp4NjBla1BjZ2NzOGJLL2ZtZndQcTQxcUZrYnJaMlU3N3hh?=
 =?utf-8?B?bVBnTEdSZ3k1SUJnWVlhL2VVL2VhWS9CdjNpQUVLZDlSK285L2VOcWJ1MVhy?=
 =?utf-8?B?NzljQ1crZXJ1Tzl3Qkt4MWx3bXVrY01oYWZRK2liZ1E5STliZkkwQjBrTXpE?=
 =?utf-8?B?UDB1cDliK09QeGZiakZFekxoOCtvNmVoZTJ5VCtCUktBL2RDeWY1N29mN3Ax?=
 =?utf-8?B?alBvKzBSZ2x0NGJJZVFPbk5Ed2VwWGI4a09MbVcvNm9QVlBnYUZTc2tLZWd4?=
 =?utf-8?B?SlA5Rm1zcFpadlJkMGpMWFJlSHZjakxpR20rSlZTN0lWcnRESGROcHQwZUpx?=
 =?utf-8?B?VHhHTS9JdGYyVlJMdjBuRkM5VU1iN3pSY002c094cW1rZkJxZnV1QjdOWjNL?=
 =?utf-8?B?dTc0S29JclBTY3dnOXJsTmhnNGZUc3hJaFRTVERzU01ObVoyTHk4Vng1UkhJ?=
 =?utf-8?B?YjRvOVBwRjdBclhFdW0yYmliUm5TTnl1VkJ2eExTR3FaWEtXYlZacnI4TEhL?=
 =?utf-8?B?eXdZNXlhZkdLNlp5TzduVXpxM0pwSTR0UUJVdlljRHJ0T0VmUTR1Y1FvVUhD?=
 =?utf-8?B?YmxtYW9Fb3Z6elRvcWVieUQyeG5KeFAvNERIL1loNklyeGUwelZOc3ZyN1RU?=
 =?utf-8?B?WUY2Y1owZ2VrcGRLaWhrY1AyTFBuUjltQ1BRcVdhT0lPa09ZcUNRWGNvWUNV?=
 =?utf-8?B?V1pXQmtnSjVFNU0xWU9YZ1dyZCtROTk0RldPOEk5MzRqblFFN09UQmlER3ov?=
 =?utf-8?B?R2NVWnQ5dnhjOTgvWkg2cXlWdjYwYzRhQ0dCRTJHL25xRVVOSFo2bWxIY1NN?=
 =?utf-8?B?ZXpWR05IUXJFWUV2OS9nVTdGd3B2c3Y3TGZGdThGYlFoRkVMTkltYW8yckhL?=
 =?utf-8?B?WmVQMWkyQnhwNTVQeUc5RWVBWjMwaE9yWndRdEVVenlWTWkwUUpYVnF1QlFN?=
 =?utf-8?B?Z285MUtSZ0NHb0ZZK2tqTDl6ZGVtd01CNTY1ajFTVGlCR3Z1aC84QzdRV3Qw?=
 =?utf-8?B?SnFFNmZBanZqbEtJdXorVm0yMUlNVnVzb2JYbjJNUjlqVjZZejZFeGZFRTk4?=
 =?utf-8?B?NENFUUNmMWp0VitvYTZuRkJRam5HWDVaT0U1NjZMUDl0SHNOMmtDSFBUQ1Rw?=
 =?utf-8?B?QmpRdkFHeHN5UDJTN0U1eTRBYXB0WFE0eGg1VmM3RnF4UWd2bkh4RTVUTEZF?=
 =?utf-8?B?NTJWeklhSUZ0ZE14b2hmV0huT3lTbmkwY0ZiUUxXYVRISUt0ODdEdmZpYjl3?=
 =?utf-8?B?Vy94SExNOGxWazloLzJTdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDNrZCt3MlRrcHBNeHpTVHFVcklDSkUzckdLMVgwMGlUWnpyKzlENU8rWU5y?=
 =?utf-8?B?NlVGWnhmbmJiYllTL0JWTXM0UWxvVlRENWtBRHRrZ1NhUkM5eS9jUTc3VFNS?=
 =?utf-8?B?Y2xMaDRETGYzUHBqMkE5VXNZNXZsUWdiUjBuMktSVHBmVjcrMkxuUlRoQ2li?=
 =?utf-8?B?L1E4L2JjTHJVY3FJQzdiTlpOOUtkeXZaQk1Oc2NhaFBhSVBFZ0pJWG9rMEIx?=
 =?utf-8?B?YjJSVDEyY1Z5bkMvbitQV3FIc2hsTUVNNE13RnhuSmQxeWNwR1RmaEZNRE82?=
 =?utf-8?B?ZFovK09TZmU3Wmh4MjdoSjJSckI2NTREM0RVN2podHV0QmVxRlBkNnA1OFJx?=
 =?utf-8?B?Y3pNWW5aMnJ5OFRNaFFUV3VmQXduRkxDcER3N3VrYjUySnYvMW5XRC9UN2dw?=
 =?utf-8?B?UnRSUUwrZkEzZWZpaEpOSklsL3BreThFVEVLUlRqNFpFcEt2cG10UTh5N3NP?=
 =?utf-8?B?b0RicTFIR24zb3JWeGRRNGF6UGY3RE9tM1NsM3A4dUVCSG5ob3NWSU9vYmsx?=
 =?utf-8?B?VnVrazZIem5DeWtEcmJERU1JVTVQRlFIc0xwVTJLU29nNEc3WWxjMEg2N3l2?=
 =?utf-8?B?cjIzRkhCUEJPZld5NjdyTXNSd3M2SWtLNElRVE9TbDVibHhvSUNpcHBpYjZM?=
 =?utf-8?B?dmo1dGZDWU5hR2h4R1prVHB5YlQrMllxR0pZRXZWMWdZOGtlMEk2THpDaWJC?=
 =?utf-8?B?azdTM2RjNEY3WU03S1IrWG00TW9LUkRURHJ5K2hKeVpUNWtUdnVPNXQxOVdX?=
 =?utf-8?B?TWJTK3BHQkZqaHhxbmFJUTkxRE41QjBFSE5iaU1vS2NtVDRad3lpdjlvNWRL?=
 =?utf-8?B?eEhSa3ExUWRRUlJJMkk5Y3FlRUp4Y3JFT0NYdi9mWkcrRVpOYXFHUUxsZmZG?=
 =?utf-8?B?dFJMWjMwbkw0STF5Kzlmemo5WXJwd1RCUUFaSmVxMVhaRE5zQzNFU1AvNmFQ?=
 =?utf-8?B?VDhxcTdJMHl4Ty81MlR3SVhoa0NHVmFiUUt4SUh5MENsVUlNOE1ma05nQitE?=
 =?utf-8?B?YWNoTU14SEE1TXY2d0xVYTZrSi9qNHFmbEdiemNLbTdqTktLWWkvOWlQVEkx?=
 =?utf-8?B?RWdEQ3NNRzlhcXlvNk4vTlpYWjJJWlB3bW1vK2ptczlWMHFjWk01MzVmbUJU?=
 =?utf-8?B?MFFqekltU2VoVVZXZVNLZE9XZ1A4UzhTUnhKckc1bUhRL21WLytmeWRWb3pk?=
 =?utf-8?B?UXkrNTRmSmErNnNZNlJkc3huVm16c1htVk9hZ0RySmMwb0UySlZla3FqNE1E?=
 =?utf-8?B?V1ZZbWJBam51ZllQS0txVC96emJiSDF5VkwxM2t2SGFvelZsaW9NKzRCMGNW?=
 =?utf-8?B?WWtBRGt0WkxHSTM3NUpTeXlWd05pUGdYLzJxc2NCRmVDenNhUGM3UmhiV2lM?=
 =?utf-8?B?Ny9GMmJ3UFBvWlpaTmhrUWFWL0gxVjhqVzVDdDJPS3Q5c1FCUnNPVGpiR2N5?=
 =?utf-8?B?Q1pYTXVqQmhGRUtHSnJwaXFjdVNHeDBDbVVzSlROc1d1M1BORFVkd0V3MmRS?=
 =?utf-8?B?YVBTR3BkSk5EU2dLYmJlOHNvYmx4K1RmSWM1R2pPUmJZR1NaNU5ESlBYeW5E?=
 =?utf-8?B?ejBVSTJoSGN2WFVNcEZrVFJFaFRvK0ZYdVFWZUFDUk9keHdOM0FFSlA2RTJF?=
 =?utf-8?B?UDcyRW14NHZLcWJFcDhuNnNvWFRySUhsc21HcnFQdGtQSUZmd1BtNHRPUXcx?=
 =?utf-8?B?YnJUbm9JYmErRkU4UDlJOUFsbkdYdFFVZ2orMDN1VG5sVmRTd1AwR25hOTla?=
 =?utf-8?B?TzUxUzdQb3ZjS1hxQVNMOTdhczFseFBUWnBNWVM3cXZ1Nmx1WTdxZUlxcWxh?=
 =?utf-8?B?d0c4Y1pkUXluOFA3aXJ5alRRY2F4by9Fa3BHV2JGT09RRGsvakRyNHMwMjBY?=
 =?utf-8?B?aGsrRlRxV1ppR0tyMjFERlF0azhPenlxQ21DOW1raVZmZC9QMSs0RGlETEZi?=
 =?utf-8?B?VEtINk0yY1pCNU1LdjR3ZEFsbHAwdWZ1OFhpaGpUdEVXR3VwcEcrMndydGo3?=
 =?utf-8?B?citBRzM4ME9ZVXZPTDRXR1RxSWhpeFFscXY3bGVzZnJlYmJuUTkwdkVEOUpw?=
 =?utf-8?B?L0ZwVjRvR0FsWjJTc3FhTVlNSmdvek9KVXpZOVppWk1ubWhJREJZaERHa2tK?=
 =?utf-8?Q?h/soKjhIuUuHGPUrr6OtiFqkD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07964cf1-ff21-423d-516f-08dc98d28fb0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2024 07:02:10.4053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsNKJzrXpPliaZuKTY7Le+sg498RXgGNEGrBQqi6SD6Oz0H2bQ///tKOSnFsrlrj643aqjhxOvgxjob3erNrXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5162
X-OriginatorOrg: intel.com

On 2024/6/28 23:28, Yan Zhao wrote:
> On Fri, Jun 28, 2024 at 05:48:11PM +0800, Yi Liu wrote:
>> On 2024/6/28 13:21, Yan Zhao wrote:
>>> On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
>>>> On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
>>>>
>>>>>>>> This doesn't seem right.. There is only one device but multiple file
>>>>>>>> can be opened on that device.
>>>>> Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
>>>>> vfio_df_open() makes sure device->open_count is 1.
>>>>
>>>> Yeah, that seems better.
>>>>
>>>> Logically it would be best if all places set the inode once the
>>>> inode/FD has been made to be the one and only way to access it.
>>> For group path, I'm afraid there's no such a place ensuring only one active fd
>>> in kernel.
>>> I tried modifying QEMU to allow two openings and two assignments of the same
>>> device. It works and appears to guest that there were 2 devices, though this
>>> ultimately leads to device malfunctions in guest.
>>>
>>>>> BTW, in group path, what's the benefit of allowing multiple open of device?
>>>>
>>>> I don't know, the thing that opened the first FD can just dup it, no
>>>> idea why two different FDs would be useful. It is something we removed
>>>> in the cdev flow
>>>>
>>> Thanks. However, from the code, it reads like a drawback of the cdev flow :)
>>> I don't understand why the group path is secure though.
>>>
>>>           /*
>>>            * Only the group path allows the device to be opened multiple
>>>            * times.  The device cdev path doesn't have a secure way for it.
>>>            */
>>>           if (device->open_count != 0 && !df->group)
>>>                   return -EINVAL;
>>>
>>>
>>
>> The group path only allow single group open, so the device FDs retrieved
>> via the group is just within the opener of the group. This secure is built
>> on top of single open of group.
> What if the group is opened for only once but VFIO_GROUP_GET_DEVICE_FD
> ioctl is called for multiple times?

this should happen within the process context that has opened the group. it
should be safe, and that would be tracked by the open_count.

-- 
Regards,
Yi Liu

