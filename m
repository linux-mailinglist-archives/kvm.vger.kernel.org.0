Return-Path: <kvm+bounces-10023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5844B8688DC
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 07:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D94A81F233E8
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 06:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711305339D;
	Tue, 27 Feb 2024 06:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIhP6UIh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0A4CDE5;
	Tue, 27 Feb 2024 06:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709014118; cv=fail; b=HnaN+WxLgrWB5xzM3KpE5Pd9AzsPo0vyGUA+D3g6IYbnjdxr+UXOqkQUOy9y1qM1v0mey3IXrouf/juMIcl32rHESN9tlhrNOIlcBXTvlGlGRKtkloBdYnytS0cxxe+GY7TYA5cUeCcCNolcj3vMmdcSICz7CcUBI6zQZ2g8PVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709014118; c=relaxed/simple;
	bh=oqO3NofS+pBfY9wfOf9wVNX5hwH7udqTSa6S3xTcTXw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WYouK1/AwgtteXDcnjuB1TzcAis/G0t5o0q2Z4Ure/EL8D0s+y7Fbmr5aXpwohIHUOsuAT38dQRzP4SMxJeeCC1xNPc+EcqtC60qo1u/ux3nIM2OC8oubVpkOK2e40VefsreZGIP/rvKW0BZH7eL8hYnBFYJlbuoXN/3p94b+zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIhP6UIh; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709014117; x=1740550117;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oqO3NofS+pBfY9wfOf9wVNX5hwH7udqTSa6S3xTcTXw=;
  b=bIhP6UIhQbH4gU4Svp4+YPwvQQJ+kBx5W47TSRPYNemnUXtrRoV4QTA6
   mfBkwfnSxEidBXFWiLZE9/W1V1Z7sz7s/BAPrTjKp49S6UHFlM7Cg6+Ip
   8EIJWi6F4CeJD4nmo/HcmqGgL9zDRZXodEMBpNq6fjAMPUigGnaS8qxy3
   S0S/66EzgDOa2vTLZ5I4d6lv5/fxPinpBS0bSEPKZGsyXMigURKqry5gD
   4AysCkSmRW5GOgGqnT7JIGuUoYOV6zV/KKx3d/MRCEqU6mRylpAnnOjAG
   DOi6mR5oXWY6s4oawtn0qxAanaGzEuE5OSUXJOtZQj38gjwoTLpM2lQzZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6288190"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6288190"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 22:08:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="37956321"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Feb 2024 22:08:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 22:08:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 26 Feb 2024 22:08:34 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 26 Feb 2024 22:08:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJw8lP14Q21ukyiwjk+NbNDJ5YnR8SgG7gAZYvlaJ2uWlZKcpbZ124oiTSlByrsQEEO+/V74cYbNIDkS1ZRUb0u2m7zcANWbznjAXxdpRdwdvQMjrw7n2iClQo2cCtJUVa7jcjRyP+vAzo2gw69dHJsorAIF/ZiJQ8JvKaO1uC7kF21KkEP6ScLo4iXaS29AZdg9YNWnM8lsusRXRypAlsQK/y4Iax5q07uFfzm3mEyznixxOc0I+H4iV0r1z0Os69RbGlWN11BfIA5xrnL5iQSFH5UppR8DLOtHOJNRN+WtCzGphf3Y6hO8carMEbWNh6PgKYkqzLYsbv3FWLqJnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HXVBZVo8K/36nfgCLJNT1XeLSm1EPEB+XUR9NSZABSo=;
 b=arWrQtMgMOKrZqleTPO4FhIYVbiu4Ne2W6iLFoN3Zm7tEzaiQtkloPRdYTj+NQSsYs2ZYRS75J5BdthjAqfUwKJ+iKFt4pq/9rDqYoM7wNW3icuN3LJnVSVQWtBwZDiUFcuJCEpSxWzG2oAzejdY2qNH7Js0F3U50JWrlypxthIWbl56OOE0wHjU+da20Tdr/5ftFGi9hgEHRimeOxxywIb8Il8v5QSCviOnpLMIhafT7dVrcIgh2yyi5FDaNs0EPeUnu3Q/RbxByP7yzsGXiWX+gjcJvp4zvM/0SqHNeA7gBp+9iadzEG7bAU28kSckIWYuXtZUtuzIDvXkWEMd8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by SJ2PR11MB8450.namprd11.prod.outlook.com (2603:10b6:a03:578::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.24; Tue, 27 Feb
 2024 06:08:31 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7339.022; Tue, 27 Feb 2024
 06:08:31 +0000
Message-ID: <eff34df2-fdc1-4ee0-bb8d-90da386b7cb6@intel.com>
Date: Tue, 27 Feb 2024 14:08:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or
 TME
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Zixi Chen
	<zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, "Kirill A .
 Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@kernel.org>, <x86@kernel.org>, <stable@vger.kernel.org>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
 <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
 <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
 <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
 <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
 <7e118d89-3b7a-4e13-b3de-2acfbf712ad5@intel.com>
 <3807c397-2eef-4f1d-ae85-4259f061f08e@intel.com>
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <3807c397-2eef-4f1d-ae85-4259f061f08e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::30)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|SJ2PR11MB8450:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b84fa9d-e098-4c22-ecc0-08dc375a85c8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m1QOkBFIz1eWFAQrSZCPL6g5fVEC5kZDa/Il4oKZYgoQckEgUCRlDk8OyObv7Ew438DcMvxo3whx7EPvgi28befcgBEK3zxRc7T4+bc6O2zWjrI1Yd7HzZ9Rh9AyYGPegx+AXXW2AmmIIsFk3T+Sv+PeF1W0sO5qDRkju0M1aJB75RTUew6iNLlfMxdGSxIhxCwa1tK+CM8E+6u3syTpA/xhKWD+QS2zTiCQBF62WryZFkISoM3ei4Zmrr+b/OjcjFgFm98Tgeo1vQv0q+U2RvmiSLEKG6q5qIhTXPdREpoK2SDvQPeOEJl+ea70oqHoehWIZ0LnP0FfkbfdXWqLbwBC/7MPh7fUqdjvoYs2THcKlaVSCkpPPDMB13jBwt06D5HLRQAW16efc1iYNNVIDpP8aDjjqY9RxmYoMFPYbXceToMw3ovqHTnfNxpYbEHqGY5N83X4rtbnE9h188bqpDu1EhHN9P4zn4c1BQC0NYImASC8YVALkWVa+tlI5eiakw+/dlJ8VeZCb4ynmBVp3bQtz+n665JarxHZJpl5jWBikARxBA+1Zi1+6A8pjHv8XuyBtmXmW0vtTjtkJD3KmQluZacwWWpfXpYRezvFg+BjMRDTR3CCm6zvY6aKsZwy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2taT1llTW1UZ2VUazBIVExNaWZnYzdyL3p3VXB3Rk1naCtydDdWSGFVbjJs?=
 =?utf-8?B?V0xMeFFnaUxpQ3AvVk10MjRySnNBNTNUY2xTMDc5bmxCcldBRHNVTU5EYlNM?=
 =?utf-8?B?Vk9iWmI3bklsZkRkbXIrSU1udTdSWmg1OUN1VXJNMFBpK005WVZhMFlaUUYz?=
 =?utf-8?B?Yy9ndnpVSjFQaHE3N1pXSkdVUjFrdjRXRFduL1J1ekhvWmxoUkxkZmFja0Ez?=
 =?utf-8?B?Nzc4WWlob2JwT2FWbXhpelpQSlVQbUduV3cza2lvMnBxRDFHT2NpdFV5Um9T?=
 =?utf-8?B?d1crTlhyTnIzdjhPZDBPbndVUDV3Wm5XWmo0a1d0OHVkVG5oVXVsSW5OSFBq?=
 =?utf-8?B?blc2MSs1T3JPNk1qZ3VRaTBHZkxicWZNOWVNLytmWitpaXNrVVNXREgwbGJ6?=
 =?utf-8?B?MUpUQUt1YVJ3aUI1TXNVNGxVNDBwcFRWS2ZKL21VeXJ5SksrdnZFRWZhTzJw?=
 =?utf-8?B?U2NKdTJ0UVdWclVHT1hXdnVWNE1Hcjl5V3h4Wk5pMGNiSHFpdmUwWVFDNTFm?=
 =?utf-8?B?OTBXWUlSb3Jidm9sb2ZzZi83VHBUMEtBYU9OaWpUOElabWUzRW9UWWs2WE1o?=
 =?utf-8?B?VWlFcXJGSEVpN0FTUElZTk1vT09iNXhEZFZJRGs1cFlFVmh4Ulo2cWxGQnZa?=
 =?utf-8?B?akdxTGxDekdodG5CZVByN0RzVGVLYjZpcE9UbTdNbXpXZGhxMmUxVVpKYmpY?=
 =?utf-8?B?SUVJNW9jQ1FLUHZtRzVOZ1pvMHBueHdaVG8xeXgrcVhmakF2blZINnpWakFL?=
 =?utf-8?B?Y1JvR2plTWd1WUZXMGV1dGw3WXhWNFZINTErMVJ1cG1wRURlMDFGMzl5L3Er?=
 =?utf-8?B?dVBNTGhwcG5LOFlKYkY5RDBrcm9zNXYwWTBwT05ONXdGb2pnWGtVWHRxenhP?=
 =?utf-8?B?S3cxd2NTVHFWUmZoa2FTVUM0dDMyRGZtYTlzVmo0ZTdKVksvYUhVTlBXZm9V?=
 =?utf-8?B?b2x5clhmS0VHNUI3cDA5OXpHeXJ6TzJYekJDeEpWbE5jVnRPYzYreDJKMmxY?=
 =?utf-8?B?TFozRWZJK2FETE9wek9DSGhCUGFUQjZaenJaMFRjZ2lGaEprbW5QV1NkVFBF?=
 =?utf-8?B?azNYRk9KNWh1N2ZGVGJZRnlERWloNkFDU0ZJVXM5aEZtVnVsYVFqZ2dTVGV5?=
 =?utf-8?B?UlNJcldOVEhMSll2eFNaQ2JnV3M1anZWU0VPYzlXMHhnUXNkdTZLYVJXcGhn?=
 =?utf-8?B?V1MxWkNZTlVqa1pINVZnNkhGdHZOSzdoN21ZaGNHeTFHVUJGcHg3VkQwNXBO?=
 =?utf-8?B?QXo0Q2hnY09TWmNUQkM4U3BzbkJHRWdyTmJRbllkNXpJd0VCRmIzWG5FVmNY?=
 =?utf-8?B?NkVvUXVHRUQrZCt0TmVGZi94V001TlREa3JJMGtkdlhyRnZlN3NqRkZ3SVlu?=
 =?utf-8?B?N1BYbjZSTWJMMWhwOEtPdmVMS3pkaDl5V3o1MjVwSU9GNUlsVFBHSHJCVHlZ?=
 =?utf-8?B?UWIyUnNUdFNxZTg5TjFDWTNDWkpSV0U4a3pwZU4xcEVWQ25RYytUYXprb3JW?=
 =?utf-8?B?YVdMdlpFZWhacDNhMWZyb3V0aTl4OE9tSUtEbCsxYklQZHlZNU5aK0ZPdjBB?=
 =?utf-8?B?OHY3azhZdWplSmVyL1o1OTZpTUZHZUk0TUtPRWNoZHJQeHVrU1dBWklRMkhw?=
 =?utf-8?B?aktka09MYXJVaXRtOG5sbzZiNkpOYlJZaGpTTXBGaTFwaXN5RDg4MHZkWGZ2?=
 =?utf-8?B?QllsRTlOVjY5RVpXc0JHbVlObVhnbnJWVzE1TytFRVRTNVpwb05iSERPK1A0?=
 =?utf-8?B?TE1PZkJIMUdLRi8rNkZ6M3MwbVdaempSaW1BblVIR1dZc0FwbEZSSjVXVHYx?=
 =?utf-8?B?RFBsYWZwd09xNHNvSE5FV25Da2hRMTR4TDY5Rld3aDRKL3FSZllBSkhSM1Jr?=
 =?utf-8?B?bStlSHpnSU96M3FtenI0ajFGNHoyYm05OWpRa242Q0JrVFFQYW1Xdktwd0Zt?=
 =?utf-8?B?ZjU3ZVh5TzBYYVAzcVpBZGRTZFZnT2xEUnFpVTVGZjdtZWRlNVRZSEVpWXh3?=
 =?utf-8?B?YldHNndjcWZmMEtyQVBDYmJxS3hMWjF3WGdPa0t6N2g4UldhUFBJRjQ3MGtE?=
 =?utf-8?B?MTZJcldDTTNtNERvUml5V0N6ZXNzcnRXSVlWTmgrR1M1OURDY2Z1L01sUnZs?=
 =?utf-8?Q?21+Uyrcr502wbD38q1CtgLd5J?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b84fa9d-e098-4c22-ecc0-08dc375a85c8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 06:08:31.2345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4lXiIG//GrQ2Nlne1piXgcGzeT6ZGcFrYYb+4qtFFujQJftkpOxYHGqfO7v4NoVYKfKbPrRME02WVaeltD5+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8450
X-OriginatorOrg: intel.com

Hi Dave,

On 2/27/24 00:21, Dave Hansen wrote:
> On 2/25/24 17:57, Yin Fengwei wrote:
>> On 2/23/24 02:08, Paolo Bonzini wrote:
>>> On Thu, Feb 22, 2024 at 7:07 PM Dave Hansen <dave.hansen@intel.com> wrote:
>>>>> Ping, in the end are we applying these patches for either 6.8 or 6.9?
>>>> Let me poke at them and see if we can stick them in x86/urgent early
>>>> next week.  They do fix an actual bug that's biting people, right?
>>> Yes, I have gotten reports of {Sapphire,Emerald} Rapids machines that
>>> don't boot at all without either these patches or
>>> "disable_mtrr_cleanup".
>> We tried platform other than Sapphire and Emerald. This patchset can fix
>> boot issues on that platform also.
> 
> Fengwei, could you also test this series on the troublesome hardware,
> please?
> 
>> https://lore.kernel.org/all/20240222183926.517AFCD2@davehans-spike.ostc.intel.com/
> 
> If it _also_ fixes the problem, it'll be a strong indication that it's
> the right long-term approach.
I tried your patchset on a Sapphire machine which is the only one broken machine
I can access today. The base commit is 45ec2f5f6ed3 from the latest linus tree.

Without your patchset, the system boot hang.
With your patchset, the system boot successfully.


Regards
Yin, Fengwei

