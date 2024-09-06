Return-Path: <kvm+bounces-26036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B5496FD71
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5581FB2751C
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 21:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6EE15958A;
	Fri,  6 Sep 2024 21:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxenLJ67"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07A13E03E;
	Fri,  6 Sep 2024 21:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725658450; cv=fail; b=lkGezKM55G95dOHAR8bamTcPBiPA/OP1yQDby/pnmzyfTaY7TMMsWbK6xQD/SNhQx2roNZQjhd9sUKugnxW+TYKtxtH5L4n8mHNYIVBXVOEfq1lm6xv9HVCllhIeY39R10h5TubugXmEza63Rb/UVS+Kk5NSI2eIxur28cG6syE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725658450; c=relaxed/simple;
	bh=ov/RcJPWRx7XtFGqNXpBMwQYdpOItV7BodMtWhAowMc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=skY2mweKFS0AuekBVk5RzntdC0oPDyc2efZrTmi4r9kSj8sPS/3X8Wl1tW8r3AuqaF53OdxBJTf6D+aDgVoMlJtL+6pKMoB1A+4Q/MATFjlPfh7FEn4tL1oKpx+1d7nDJ7dYBHwGm3bUh2DI4QlQ3X9WnXcCmlmkMxsN74KVXOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxenLJ67; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725658450; x=1757194450;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ov/RcJPWRx7XtFGqNXpBMwQYdpOItV7BodMtWhAowMc=;
  b=WxenLJ67ZGhfOPakOhTBJHoXchS08vS9YOVYREGrGB0jtA0lifPNUxpN
   tzxcd5Ewtfa/TbmqjFcU5n5QgGcO+bU20C8S1+KgyJiynqGu1zijw8o0x
   3y88akYUbXvMtyrXdviWI/yIBYvmMgG8F7ZWGOTPAjyu9evzAvNrWMnaM
   9/NN7TEryna0cU0+s7H0+r45nPFqaxcSjAR52I1b4kWHsAm3PQS5dFyBf
   hG6K4r98CoZtiOtxta5hshf5ipdaohhEi+3FwggjtfF50BIcEK3+KbaHq
   9nJQzJJinf+0PunbTxjrLMK/rQWjvmrUV5QDa6GS63OeHPKhFG013MVte
   g==;
X-CSE-ConnectionGUID: KiYZNi6VQlyP4ncEX8QsQQ==
X-CSE-MsgGUID: 3i82OewGQmyGySVoTwDCjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="28216492"
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="28216492"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 14:34:09 -0700
X-CSE-ConnectionGUID: wYZMBosTRwG4HbqpcMFkQQ==
X-CSE-MsgGUID: iBlXhQyFTa2E6ikuJPUzug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="66057427"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 14:34:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 14:34:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 14:34:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 14:34:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fceg56LOpK0AtO+QC24F0wtNHFYkE6EUgmlAfFcJeSEJ+htYDgSzM5j04PbhKP9AYOYrRvnKlo3mRBeIAuQiEUcaVMXobYZ70Rupkc5/kCINoeRnNj6+VixcujtQ9ymwdiVTc/d2+1kws25umyTbuTyUE+SexGG/gqSfl9FSw0qKpZiMhshVXZ3hfA9xBZytqjB0iDaUP8urp4vQjeyNWOaSenYioAv0AXAqGd702UhZWJpX5MRMRaHnojnbeJoiTDg6AIAy5qT83JC3QggHskJVTP7SPoPmMTsJRYoluA444x61wiqtfNRDcxuFUqwyOV2JkATtEmZxezSGuYOkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fikIZMYdK3fljyv+FNn55AecKjM6/I4NlQuFxwaZB0=;
 b=WV7cIXPPKE+KyNpqbQGo7yz5ij8kAlSBE6rJ3lRGHITTly2BKbnAZm1/CUA4cG+7w5BBp6ZsrZU2AV0ei3fUtejBHhsW+2M1FBdTj5jpR2Y0Cev8T9ysK0IokRPzIP57Xp4jlT/LWeXMF/HUTcWuKto2zqYFnU7BoIzYw0dvxijz+xTlTas58gtHaYhTCDVdQmxFYO5HI+xtm8YhZwBKO8U91zj3vs9iTx6UxFy1389rZXYUSWJuVWTGFbp0+w95Agt3YK7qfhYamaC/f/JWsDIaKxvziNi0rwifXlvdZ6rETI6/MhGkbaOrKPmJqToGBphlB2RV6+TL15/Sfx8qIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB8335.namprd11.prod.outlook.com (2603:10b6:208:493::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Fri, 6 Sep
 2024 21:34:04 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 21:34:04 +0000
Date: Fri, 6 Sep 2024 14:34:01 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <adrian.hunter@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Message-ID: <66db75497a213_22a2294b@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB8335:EE_
X-MS-Office365-Filtering-Correlation-Id: 623d7a22-38ef-412e-7e16-08dccebba19e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+ox8Nqi6sCiEZUnd1HMimx4WuGf8fYoHlF9nPBs4qRU6bcpQpGyNWmX+hoF8?=
 =?us-ascii?Q?JRHN9vbPdod6FqDtmotynm7OkL793JAf0j+zABWhDrrd9i9MBImjLsHze2JB?=
 =?us-ascii?Q?ZnTJWuRj4gw1ZF+U+wtYSW3RBn3CHnRHdEXAWkbl07x/l864n4pYE1LtCbgD?=
 =?us-ascii?Q?ED1dVUY9pwkb7P/4olo2B8XzLlg3B8jpAci/L14g96ciS8o+7k9IQvSE2f0C?=
 =?us-ascii?Q?IfbCctWotFxXl/rxGsD4z636fF/ZoCc+WE2T+R4/8cyPskJx12aFjPHRxDnC?=
 =?us-ascii?Q?K9L2/lxuiCNNDmmZ6zr22Jx1dgpbkT5fW3TsVGVcesCjD9/xvcj6VMDgV6ba?=
 =?us-ascii?Q?jkjt7ftJZJAogyyk1cSLYdj0NmD2QnPP6ivJLHPpuL+ohdDM1ySaFBFpxtpk?=
 =?us-ascii?Q?Xu3UMUqAQrWA1T/dfMygVRlVlc2UrZPHkyw6sWBTsY+gk9QNIImMZgrMzk5d?=
 =?us-ascii?Q?upSH1N6yw3dwg1B7l4jt9mgGOKRIS3+JdVQc6NpKgAcT+X9x7ooslURLc63d?=
 =?us-ascii?Q?gxMhE+na4tUYrc3zv+MTxQzrPx6sYnrQGRVIH77HpAtT/18zgmggWNsklagk?=
 =?us-ascii?Q?3mSWMYV8H46tMtg+5W9IkqxXte5ZReF99CbBLkXT47/Db1cFOFWF3sIyMrrt?=
 =?us-ascii?Q?69EBlUs8FqumuKXNomdJXWfje2QcqI2mpFV6fpQhipNV6Ps8NjZmajUx2LW9?=
 =?us-ascii?Q?+7hEIaqhK/cmiPHkl9dmQcMqDdD7pdGW9SU+tqO/b4gWdB3h+XkYSZ9sRw7d?=
 =?us-ascii?Q?r4NzOGHPWWzF95E9QwhrbpeQBrz/elQ2CqjdCfJ6dWfz6pKA5UFJWicTc1C1?=
 =?us-ascii?Q?GkToo3yX7ZLv1ikzG3QFGpWOMaylH6IgmFDYw40ODRiRsZoL0ZH7hFRgYwio?=
 =?us-ascii?Q?Brt4CZh4N7Dc0v5m0KLiudQox7YPv/rHvXrE9oAYoSKkqGmAwSvhj8x5X/dm?=
 =?us-ascii?Q?ZcT/ym9dV+CPQUzGXTl2+6F03iVgGi3Z+yOqMPHzfriIbS+5vJAh+8YNj2Bj?=
 =?us-ascii?Q?oGOpVZRZh+pbwVWODVgjVZHyhgQaYsAYc8i0fx/7H+eiP9/BNq6YlEVVsTNW?=
 =?us-ascii?Q?WoKTJEuOiq6b8zsp9OVmmpjmKadUHFuibs9J+QE4DOZqPB05xQlBmMmI5OlE?=
 =?us-ascii?Q?aKYhMWGjGosUL95DqGDWTNGctIFVUY5+4vM0kl5nbYIQh15Afk38CwEj+Br2?=
 =?us-ascii?Q?imt7PEPseKnpg13qXkO9IHyaVd/POSAp0BbH2hmEbDEpAwGyzxgm7PyHBsWn?=
 =?us-ascii?Q?QDdS7Dten3zUrDj1T/ciI/7682UZk1YiCstULwPAGi2FPEnlv7s3X+Tr7y1c?=
 =?us-ascii?Q?gx2O+Gq1ZxGfomovC0uCXJlgmgw1QWvVLcbrkKIW8n5RI+jtla4LVwk3Mp/W?=
 =?us-ascii?Q?nTmkmv/1QdnSLY1Jbkf/a3mVKd6o?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qR8ldzQeqyCvpBaBqdf5TRQS6kWYXCNejB3WvSwsXoKspzsiynn729FMWBLQ?=
 =?us-ascii?Q?SARcae9VASCMWiCY1L52/ciFkei5fsAml28pB/CLmGrCizGqhYhQBxC5fg2x?=
 =?us-ascii?Q?sCYpJayi2YRlmjts230ssXD8FbUHw0zpii5Byr3amB5k/kJu9gYh5fHPKlh8?=
 =?us-ascii?Q?gLdUVHgqcFLjHfFbua/hX229IwcxtczrzgjnWIcX18IgIEYGpmmw6fti0ZbL?=
 =?us-ascii?Q?mRwVH0ebFzF9nOg7M6O8//HMA5OrfSZQxYU3rozdJ1QZI+y9pUV4uHRpbuZp?=
 =?us-ascii?Q?fKYhxRkIKeWhTYE+zYe0LGgaR6vp9eK+RCpv+CCJb249+CnztOTxF0e9evmV?=
 =?us-ascii?Q?S63TIfPYoUiRPhp2/4RMa2XXG9Uh6dFx1UqaOaGkI+2tL93oBSv4MTYiatuQ?=
 =?us-ascii?Q?H8iB/oUwO1pfEsi8SRJLG5a6IPB7egRv0xxoqKfftSSfu3khEa1JpwQ3Ke1A?=
 =?us-ascii?Q?JUPVnxFxomXx3yZywj7SrQ28t6iIaYINk22eSSbnhEATn3WzNPRbLYclN0G7?=
 =?us-ascii?Q?LMjCCiztljueTcdMLNPwcD+dAAWDUmYE8O5YX4G2Yc8eTJoRmvRDBZjv48EB?=
 =?us-ascii?Q?y7BUOoqz9xnZUYhQ7ne9fiZN9BB2y0e8/AEHsDHFGL+M+IsCjkQWnfyGtIz3?=
 =?us-ascii?Q?zytgSV+tJLoFYCBgzuEx+SBOVUXugRMar2eBWNGabWuc5eA9vnd33pz4J32D?=
 =?us-ascii?Q?AL7zoqlgVdjRglyIVsQViNVGua+H6ZuTell+OvCX+oiJc35qITQl5fLLgF7y?=
 =?us-ascii?Q?Drog5532ouUavq7ei/8g5V1IzRFCPFY3n2J9zKcSLt4GAHygsyri16pgGNrX?=
 =?us-ascii?Q?HAx8w3YPR/Vn8VWVhNa+d4Vn12MbfQflkiWMlY78coqHz7JeUxoHQL6pG+4r?=
 =?us-ascii?Q?hMXXYY4weUg3R8XiI4VLPmbYbrBPq/OK4wUmD/jy4C4wdOyS3xj+Y/3jt47a?=
 =?us-ascii?Q?h0g8Tg78Amyr02tNvcaQW78voJbTKkMAgaX5WvGjxpncCziTWW2T/HPL7VWq?=
 =?us-ascii?Q?WQul61hms29gV97fmHPHLcTlzvZcL7wZuVYc+oKoobYT5yfsSznPImRbybUQ?=
 =?us-ascii?Q?VK8b+kEMYAbVwRY7UB6zJJVgeSpXx/IALEYRjFjoTt4XBcVkU3X4t3XgKtaX?=
 =?us-ascii?Q?fDd4I6EXNH4tKDpj9jto47Zy05TcIEP388KhvfNQNPeuOKUnSoqxyl+cgKgC?=
 =?us-ascii?Q?h8IS319fvKI+pW2iZ+EQZEaSJrBygcdSLJHYXy11BXv+l+v3xwM7f67xsHsL?=
 =?us-ascii?Q?4ON1ZPp0RkhLJCD3qY8ayNW/xviAgSdyXJw1/iBftNBsw7wkrk7KQB2yDy9a?=
 =?us-ascii?Q?os9eKs2WG+9fnVVhFv8anELCgEARh6RSeQsVZTdvyP/W0J1hMlEtBjQ9we8z?=
 =?us-ascii?Q?cWVqs4xg3vc0f++AYnqURypHoE2uBg38XH0V+2IYusvbHztapWCcSkKFsovo?=
 =?us-ascii?Q?oRuzFtPa1OtXDq/8IbUI2WJA7mEF0cp7/cDHQ/Huuc2kWjMkHmaPXJuYocFw?=
 =?us-ascii?Q?+603U1x88vXVM1qGl0V+WWnLWXiLWtMJz8uQQfaULfTxn6c1O6T1uiuF6zVg?=
 =?us-ascii?Q?i5rQ67V3o3wnTYUU4b+J0Ng8Jgt2IBDEVtmCH8meoZkKhk7R7kXzU11kA34K?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 623d7a22-38ef-412e-7e16-08dccebba19e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:34:04.6832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qnutseysMEhtgHp3oPB/mPAnLClT3lpaJI7j+T7pm631ifH2zYpxGfUygDrfL8w2pbdkc6xeiyI9wFcWObS1QV2eRfQ7Kw8BQKNdb0P0NL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8335
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Future changes will need to read more metadata fields with different
> element sizes.  To make the code short, extend the helper to take a
> 'void *' buffer and the buffer size so it can work with all element
> sizes.

The whole point was to have compile time type safety for global struct
member and the read routine. So, no, using 'void *' is a step backwards.

Take some inspiration from build_mmio_read() and just have a macro that
takes the size as an argument to the macro, not the runtime routine. The
macro statically selects the right routine to call and does not need to
grow a size parameter itself.

