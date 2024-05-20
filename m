Return-Path: <kvm+bounces-17808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E5F8CA4EB
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:16:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC7441C214FC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68D75029D;
	Mon, 20 May 2024 23:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X7YSSshs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1DF18C1A;
	Mon, 20 May 2024 23:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716247005; cv=fail; b=ThbE08CdWGICSDDEq7bSg49lbIfx6bqCBPgYd+NfJtvfMh3vkEh5ICY/GZVhzRTkiY9f+gFZp7gqIT+5jhWFHBGSHeijYoW1is6j3Hf0XPsKxgp1yDbzqpm5yYwQ8B3mPlYAp7PMgE3//bE3Ev3PsK9lPZVpidQ3z5BNI1EKitI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716247005; c=relaxed/simple;
	bh=tCJn7sV7CXTye5OJcqibj//37hFNn4eiBMEMta3fn8E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V7/9UJ86LPXxrBlAWV355meQEcvhfMgqw+Gjk9jf+/zaG+6YuRnz0s2Efb+o823Fm1hmOjqClg7Bu569xSSO0HpEv7nhL7HP0aC/f1LnPqV8IMNKZbm6EPj1rC90Ox6Vb00F997GoFYYZoG04NoZvcRU727BgvSSESXWCdHmufU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X7YSSshs; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716247004; x=1747783004;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tCJn7sV7CXTye5OJcqibj//37hFNn4eiBMEMta3fn8E=;
  b=X7YSSshsgPRAhK1S8Bfy5BgBs6Ipzybw4QHIpfZTR5/rCN9/TK6i9Kbu
   YN/jZdhievG0w59ifPnq/4YUkBO4JknnVOaVsKuSjZwM+AH7hYtsg6bpF
   R6b1Wi3/hmKxkifDivzbEBjebJACPRYE4nQrY0KHkmBAbWyshtZL5u736
   fM8srV7zGBPrzpLNDoBbclHfxWvvsVI4mD8325mWTJAH9gPNlMKrPhlCa
   XH9snVeBn2Y5g/HFBFNaJ2iV2uQIQAjnG5weV8+pS5g14d/lrfZP45eMb
   /dZLmj0oaZaP0eOn6zdeWzpp18ZIYFYBeWmPStMryJQQB7NQz64o+0AC+
   A==;
X-CSE-ConnectionGUID: lYgxUYvmQ+qStc6LISjp3Q==
X-CSE-MsgGUID: dfpMLnABTii0sLrHjzDIhg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12251312"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12251312"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:16:43 -0700
X-CSE-ConnectionGUID: 4BIuhVjpQxG+wmMeJXEsJg==
X-CSE-MsgGUID: Wx0zwxaySnqDd+/r0iE0Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="63927059"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 16:16:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:16:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 16:16:42 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 16:16:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZudUKFnXmrg/3ULka19rkh/tH+32kfBJFMQszDXquVdaCBywhstn7gteqHpr79kFUB2TxXGBZsQBuDvL1LB0eaDW5OlUqg9y9HqjnpqS9knF6vZCqMK2W91LkzaCHMZQFsX6Nhur/Eou4FkoklU7pP/R7EYJH4gg0UYAyrQ0eoioqnZ4lUHrAN3ZYtWXJPnreDKJMdWaVkteKVTLXKMOncs2kTZTMIHlegdtmBrvwdV9zOgJn4M4fH2VadyL6l+GU4Hu69T9BkUHu8kIn3pM0eImR/xLYBIDUVE72XwTC2wqSvs8z7+yYmy3slCMLS4utgoTx79ZH7mnW21F+O62g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LubG8iBjRyxesNVsLQU2E/WjZY+xKj26oDI0GLV41sU=;
 b=FW+6M81TAEd+X2/xo9JCojO8ES/ANhNKFefB16gOgumuKHJiv7R+hxZJSBgQfdtog5oO7WsriB0XLMV4W+v6nBmWhNHVvdt7HncOZedOcLtJlYWVEiGx3Ju1mZF+CK0DvZqHeQGWLdrfOk7V0TA3AI/HcIsBYeyqo1Fk+0zTKUuGzVhPUKhJPkMNzYeURAqDZsolY5rL0RdZXU9zpcXC7kP5+6uv4RoBLa/dwaXeNJRjr7qtYaXsPPiyJ2Nv4D7EQHz9Hbi5McML65TPtPQnhUR37DCbcfuanRqL/ahkE/0WH2PfuXNy6yQ/4SwiseEs6Dc/YD8p3RzkcCoxDDP5/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6454.namprd11.prod.outlook.com (2603:10b6:8:b8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Mon, 20 May 2024 23:16:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 23:16:39 +0000
Message-ID: <f1af881d-5672-4f6f-a298-a26ff8c5959f@intel.com>
Date: Tue, 21 May 2024 11:16:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/10] KVM: nVMX: Add a helper to encode VMCS info in
 MSR_IA32_VMX_BASIC
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Shan Kang <shan.kang@intel.com>, Xin Li
	<xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240520175925.1217334-1-seanjc@google.com>
 <20240520175925.1217334-8-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240520175925.1217334-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::17) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB6454:EE_
X-MS-Office365-Filtering-Correlation-Id: b7987a10-b7fe-4ec4-8ea4-08dc7922e755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WW4xdEZwMTFubit0RVh0TGRrTzRrNWFGQnR6NUpaSDVaZTRwaHRPMnBmS0h0?=
 =?utf-8?B?Z1BZVGM2WmtZQUw1Q2EwZWdLTVdhR0dEZ3hMZlBpTzQ0OUxhelBxYlk5b1A2?=
 =?utf-8?B?Z2xnRVlIR3p4ZXYwZk16WWo0em83S0ErOXNVbzBlcDVlVFZ5V0dXdGpEajF0?=
 =?utf-8?B?ZG5UTVJZdVVKRVAwVW1neEpsbXpIVXNOMytNRFN6NkUxUkY1KzJ0YVNDY1A2?=
 =?utf-8?B?bHQ5NEtjZWV4bWtTa1VWdzJ4R3B6T2RvWit2TW9oV1RPdm1TWTdKbkFyV25T?=
 =?utf-8?B?UmZFS1RVeWJ6VDgvelhOZ1UzMnpxM2xaSDFRcC9jRVhjeUFKdjIzaHZPTVBn?=
 =?utf-8?B?TkhEY2VyaTd6b0tDWEw5M0tLVndUcGZkd3pHMnk4UFVzMWxqd043cGErRnMz?=
 =?utf-8?B?bFlNOWRack0vMEhJNjFEdzJZTWNacEp1V1dQU2pBbElYTVVvVWF3cXY5NEQ0?=
 =?utf-8?B?bE14N0x5MDVSSUZML2RQZ3QveHJlbThNbUl1SG5DeEpvNllzWGdSRTBWQ3ls?=
 =?utf-8?B?RTA0SDVDQ0JURzlNM1FUMk1vM0xFN0FRRENQOTkwOFJtOUhMSkc4N25ZWkhC?=
 =?utf-8?B?QXJ6TnNWQmwyNlRMSjNqNkxZT01uWDMybEdtK25palE4WkxDdnAvNzc0WGxj?=
 =?utf-8?B?K3c2a253YUxWeGU3YTFPeU9oVzQ4ZzZxZlFaaHFUTHVFNGQ1WEdIK3dnaUZW?=
 =?utf-8?B?aEpGMkJoaHZxeUEyU0dBMU0vN1lrb1B4WUZNOG9UWFFDN1RneldzQU9uNHJ4?=
 =?utf-8?B?dG9DbnNFTm5iNk16aFJRV3hwWnRjVy9pNjdzOVhwU0hjZmxSSHdhYjlDaDJK?=
 =?utf-8?B?R0NnckpVcFlTQld4Y28zdmsxZFlnK2s4ZGpaUjJoM1RpUUdsTnBCVlB4NWpn?=
 =?utf-8?B?cTRFWUdFejdtVXV0ay9LdDVYS0JaMDU2dklXdE9uYXlZbzVkaTJhRDJySUYw?=
 =?utf-8?B?K25HbXFZd1lHZFA3Z0h0MXpxeHRYUlJUaUoxZWQwb0QyNnBpQS82MWY1N3Fu?=
 =?utf-8?B?d3pjN0xDNWI2aTlFNTQ4VmFaUHJ3RVdjQ1FUTTZVR3VNUU5ucEhha2c1WkxK?=
 =?utf-8?B?cGdkaCt2UEtZNUk2eEt4ZnI3TzUyTXBZSDBuS2YydzY4VHhRSnhkcVhLcDhV?=
 =?utf-8?B?azB6ZVV4OVVLci9wSWNaQ0dRdTRveTdEb0FwNURaWlJoUEVyR2RKWS9rWXVt?=
 =?utf-8?B?VzlqNEFJS1dPTmdncEtUdDdJbEd0S1c4bXVrK3lQTmNTdXNvN09Ba3ZEQ2h3?=
 =?utf-8?B?Kzd6b0tuZFJvK0RFWUhjdTN4RlY4UlNGRDFNRHo2OFV2QjJOTHhDckZ1ZjZD?=
 =?utf-8?B?b0I5MmpzL0FzeFY0ZS82dHZzSmRmQlptNFBhTThKQ2tUcmRHcWlqYmNCZDU0?=
 =?utf-8?B?cW44ZHVSWTlhb0NKd09vN0ZsWVJoRk1md094S0o0cnhVNHAwK0RYTHJYd0dX?=
 =?utf-8?B?NFFkZlVaVFEvaWRtQjlMNWsrYTdwekR1MlZ3VlVyWVZvb01PbmxjdHNLeVl2?=
 =?utf-8?B?NDlJWDRjNHdUUU9KVmhFOFVPVUlBaG9PamU0MUd4M3ZvMUZsbk51cHlqZWlI?=
 =?utf-8?B?Y0M5MEt2L09GWTdVa2FveDFPM2p4cVVzSHJ2UlowRTVRWGxVOENmVm1DSzR0?=
 =?utf-8?B?U09YSEVSNzNHQzhWcmxFYnBneVNQLzgvSEh3TUYxd1dpalRzNzZNK0UzRVJO?=
 =?utf-8?B?R20yZXpQaFJ4aXNIeHlabDBRNmk2dy9yTmFLbXUxa0pYQjdneHFQakJBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnptZkhleDdmTlUzL01tSTU1aXE5NlVXR1pLdmxWR01CN1lBQTQwZ2w2emU5?=
 =?utf-8?B?YVlhN3dKMnZOYk16UmFYYTBJTlVlQlpCOVZNSi9LeWVDZ25YeEFDSlUxaEJR?=
 =?utf-8?B?TUc2NUFKTUFFd0VvNS9nVU1pTThxbnBWU2JUZUk4MkRIbnM0aGt3Sk1FT0l1?=
 =?utf-8?B?RlFRSkxRYjZoNkJrcDlFUlRENVZaRkJLdlkrNlcvOTA5Ti9RY2ZCdklZZlZR?=
 =?utf-8?B?bUVjZ3JxSmZUY1J4NTF3QXhoMFhTNWlsdmh0ZjREMnJuWXdpNTNtNEZMWm5x?=
 =?utf-8?B?MlZSZFN2VktCYmNnVTRHWFlVaG9hbHFURGhyWGFkSWlEanZEWlg4bnQzY3N2?=
 =?utf-8?B?NFduSkMyM3ZCQnVvckNEemdhdFpxaEVhN0RJQkJ6aGd2am5kbGVlRE5mOHkv?=
 =?utf-8?B?b3hJWmVCSURESEQzUE1FbUlROFdQbkRRSjY5TytBenlpY1FJWGV5cTVyWGFE?=
 =?utf-8?B?SmFVVmtLa1VQUTRwSVQ3WVIzTWpoNWtXa0lVcGQ5SVFnckZxZWJTRHBTN0NW?=
 =?utf-8?B?UVEreXAyUHhMMmtOcnZnUXEvS3p0ODkySHNlTGIwdEplOWFMUmU3NE81eEZG?=
 =?utf-8?B?Umo5dGhrRmwzUzJodkhKTFlhZDRkOTBoOHRtY2xIbElRQ054TjJKc0dBZThO?=
 =?utf-8?B?aElqZFV3Smx0QTUwaGYvUGhFbWgzd3VFLy8vVGZ4Q1c0Mm5ON2NheGh5TzNa?=
 =?utf-8?B?SitaNVl5Y2E2bzVwRDdlWE1Bd0Fld3gwSi9Id1NGL3FmeE0rRXRGRHNvTW1F?=
 =?utf-8?B?RlJVQXpJVjJXOW5ZdU03ajRJZ2djUURZSlIrTzBHTWxqOGlyTjdKUmNhSkVC?=
 =?utf-8?B?WnZKQUxINUMrVnJDTFc3NEhGTWtoazlPb214WndZNC8zdUhrQXFHWFBvb090?=
 =?utf-8?B?QUt6dUttNWVsUGxFTnBGV2gxVU93MXp3U2lSN2w1NGJQbTBpMWR2c3FQU3o0?=
 =?utf-8?B?V3RUTUhWaXhGWVk2WkR2TkNvSTZDU1VOa1prdERHZkE0bUFBaTY0b0FGbVUw?=
 =?utf-8?B?WkcxcnpXQVdOMGhNQnI0VnBpTi9nOFc1SUxGQWZQYyt4Qkp5U0JBSHd1ak9F?=
 =?utf-8?B?dytteHN2S0xMb1FPU3lST2o3ZXZNOEt0Rk1iYVVpbkpNTmVvZWE2aStlZEdv?=
 =?utf-8?B?SWN6TzlKT01qQ0dMa3Q5V2pORktsU1BSOFlvZmVjYWJad2hUZVEzdTZwamsy?=
 =?utf-8?B?UnFwd2xndHljWEJ4dXFraUlOOXp2ZGptOUJPa2dVaEJsb1hiYm5vMlV5aFFN?=
 =?utf-8?B?WnRwbVV6NjZLY2RWdDJubStEaHRZS0cyUkJXNktiblcrL001elBtNnZQSzNU?=
 =?utf-8?B?S2pCeFhheVNKZ3RBRlBZUUk1a1FKT3IvWG9oaE9ldnB2TWJEUTNwZi9wTThI?=
 =?utf-8?B?YzQ3aldTWmRLanNHS0pqTjF3ZHZza1BxNkUwVktDcmV2Y3VVamF1Q1YvT0pl?=
 =?utf-8?B?cGo0V2VSZWMvT0tWeitEZDNnSEJVbzlVY2lFdzUzZEs4RGpHdmlPdXJoY0dF?=
 =?utf-8?B?bkQvMk9OeGpLT3N1SjhDdkR1YjM2a0ppb3pSaUhvemtMQnorV1Rkc2cxT3Nq?=
 =?utf-8?B?dnhvZEwzSVh3T3hNQ2RZV2hQci9nUkY1bWc2R1dHN3NVOW1FTDI3Q214V0hR?=
 =?utf-8?B?VGsxbXdmbndMQXVPcytFTisvMXRzSllHeE1JbWVSZXN4a0dpMGNHK3lmWlhD?=
 =?utf-8?B?WHJzMytGSWNyUG1rQ3BEU3NYQ2pNUFU1ajJSM3VYVEFySE0yaC9ESHQwZXJK?=
 =?utf-8?B?cG9taXZmNGJYYnJYSFd5UEkwU21MdGR2M3BFWnh2WmZiWU1meS84amlEZWc4?=
 =?utf-8?B?SVhZZ0hOSG0ra3N2bWh0YThmOTJtdElwaEFZeXVVcWhuZzdhYVVabGpSVkZw?=
 =?utf-8?B?aW5rbUR4TjlqTnlmbTNpSW5oVHlkazFRWUgyMjA1bzczOUFRSitYUUdoZlUv?=
 =?utf-8?B?eGw3UHpodlUreDc0ZmRkazZ0bVI3ZDVaaHhhYnJNODAwS1dHNGg1ZG9kM1RT?=
 =?utf-8?B?Z1JZSy85VmVDZXJpU3dxWVRzTXBzMXR4QnFiZTB1aFBvL0RYVlBNL3FGTzV4?=
 =?utf-8?B?NytoT3htNnJIa29rdW14Q2w0cWcyV0RRemNxakVSL0pQc2xxY0JGZHBkakhB?=
 =?utf-8?Q?zKAsYMZEchzVVa22Mlca/iHaN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7987a10-b7fe-4ec4-8ea4-08dc7922e755
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 23:16:39.8469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQuVeTrEIZizMT4+/s9aA8s/zhjTz4Nm0opSa2V8giP4qj3nPk5oEKZelc9DOVLKo2WHiQAIpACTYNEPZaV31w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6454
X-OriginatorOrg: intel.com



On 21/05/2024 5:59 am, Sean Christopherson wrote:
> Add a helper to encode the VMCS revision, size, and supported memory types
> in MSR_IA32_VMX_BASIC, i.e. when synthesizing KVM's supported BASIC MSR
> value, and delete the now unused VMCS size and memtype shift macros.
> 
> For a variety of reasons, KVM has shifted (pun intended) to using helpers
> to *get* information from the VMX MSRs, as opposed to defined MASK and
> SHIFT macros for direct use.  Provide a similar helper for the nested VMX
> code, which needs to *set* information, so that KVM isn't left with a mix
> of SHIFT macros and dedicated helpers.
> 
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Kai Huang <kai.huang@intel.com>

