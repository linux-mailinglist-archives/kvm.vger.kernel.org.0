Return-Path: <kvm+bounces-17513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3BAA8C70C3
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 05:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8973B22540
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B007F4A2C;
	Thu, 16 May 2024 03:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ecGbQZ5b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0B9259C;
	Thu, 16 May 2024 03:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715831817; cv=fail; b=KUYR6SIU8uDyh/sRrtSpWppBj8fij++4Q8fiafQMl6tscA+U8oKg7CURP+QkQq7KNkV1gQsN/O36nEZWBsMyaTvcDxMtPJ7me+D11NOXqp3kA25CC9aY7krLkS5rrj6disKHdlxXsjht2iVru3tCDiEXHjFcxIP20XZnzJN5QIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715831817; c=relaxed/simple;
	bh=SADL+LapyV2l7JUZVXObYibuxNdr4H0d7VNStbbrEFc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q04co+fVfIlFVMwN/ioE03gc9ACGiPvJbFnxwMmgMDCkfCxwZjtApq++mqjwncKc6/mbzf/J2d1ZSKWS3v1RxjgMIJ2EQmUoVCWmqKz29UU44N7ppDph8VVTjfk7zcHoQlThZhm6jUqHmj4mHdsEsEkPOa80fHX0WItOXNgY7gI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ecGbQZ5b; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715831816; x=1747367816;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=SADL+LapyV2l7JUZVXObYibuxNdr4H0d7VNStbbrEFc=;
  b=ecGbQZ5bDH8tRZi79pzscVlftGHjHHWRBjTzxjwuNhy+eHjDfDYxNsjj
   hjFI5SWjY3+608sgs0CnFxH1nUdCFEzAS65TK2ZJ+hj7Fif/6Bw1T0lwI
   tGcZ5MK7ZnVfLGEAzmnIyvwzU0dLzqugzQInkJlQszyW81m5o/+zFw/dh
   dpZmADFyCXHOo3F+aqzaj9UlpNh2dKj3BZmesGQOXYd0Hm8W2SZd7iIfQ
   GsdkaCVhS53BO9b6GntWfN2Rrkg3gtF2A6WLOysvGdQ2v02h/BfI9yNqu
   HhwFniw5Fzf51Rc4jeFRnogrFazQ8mYuBtECH9jnL73lE5rxO7aRFd0Kw
   g==;
X-CSE-ConnectionGUID: 1omMRRsvTmqyY1Sx7dfJmw==
X-CSE-MsgGUID: qkPQT090R72xDDYtSEBHWg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11727471"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="11727471"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 20:56:55 -0700
X-CSE-ConnectionGUID: ZNsQBe4lQL+8z7UfkNzqqg==
X-CSE-MsgGUID: dcjGvp9fSmiOb5az0qUbvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="36160635"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 20:56:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 20:56:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 20:56:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 20:56:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmQWBWzhUX81mtmboxf62Kv9NCNT83wPvi3qdbgCDxBZgmlMvs/vDT7YD1LVal90es8q6/TpYiTSQX5ncmV+J8CPqKhkjReDI0xvKaX3CAYV6tGpLDkIYK3ow2D80xTv7oHt0DXALfncrCnRX4vmxpH69IeqpuUnk3y8UB+dDCpaA7hfauH/NT3wphtYsmn4Ysz3rJn8lgz2y5hRqT5gAYx2XcV55muYoaWoHVFUdcQLVj6iCbXh08u94abvUtQ7LMECSMmXpvRoBRKexMPwKN33vD0UOU59q6WBnSRmPryXHhgFMo82ektVkIjDYbGXpN3CHwS2oDZ00LU573Xa3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrWjwFKrlLOqNCvAwei7r2j7TzcN6XAZTnd2WKGa1tc=;
 b=ilVE3JPOAS9UrgCAW0EnhfjizUEQy5WyPC7Czpe54I+6EjfVO6hQSdJEQlKQmUTwcJNHEL5+dd/33h3OZXtv2pQ5eKprzbUCBlaobU0uZ7+RAXYp8g1bYMAMQZ3umH8XuqFFvo8MRKA7gO6pqjZG/CFZYjZUG1J4h6mA/l+epUBc3yQ3/nzYRdcmOXk6Z/26vTeWq9EGO9aoKFcGREp6w9TKuBRjIaJcxnvCrhPHfaARtBOqEX1ZTQAOchPd1xLTjP6v3Xvf1VXZ2NS+Wn0gHvImw5cJ8TSvGuCKWRjfASwyDNLRnVGdzSifgs9nR3PCm5JMWg8al2wIWju2QUWA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7463.namprd11.prod.outlook.com (2603:10b6:806:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 03:56:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 03:56:50 +0000
Date: Thu, 16 May 2024 11:56:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Message-ID: <ZkWD1ZrUbK90+3cM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com>
 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
 <ec40aed73b79f0099ec14293f2d87d0f72e7d67b.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ec40aed73b79f0099ec14293f2d87d0f72e7d67b.camel@intel.com>
X-ClientProxiedBy: SGXP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::16)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cf46d2b-c4a8-402e-94c5-08dc755c374a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?I9iMHxVgkAiRx06o/S5reJ3Ssr2/6nKb6HtkZvdrPfY17ONkDl8HdMZWSk?=
 =?iso-8859-1?Q?TJxTMlxwMW9cgpoF0yrW99QBK9vSAhwWN5tr6RyGnvsGmiIL6ckikRe0Ht?=
 =?iso-8859-1?Q?WVfDaBGYC8ABbDT0oBibCj8ghYJ5bYRVtpi4+3H+d9AOsXR4g/TM/PUgGk?=
 =?iso-8859-1?Q?y9+M5IllzBLLFeqx0LCLtujWdusaGn1O3gANKiB/l3d7THtFGNye/iv39w?=
 =?iso-8859-1?Q?SpbK6Sqo9OKTpeXIYLqqtEsTyQ6TA60re/WKQbN+ApvarMBrCqltjzju6U?=
 =?iso-8859-1?Q?gfsCsBHf9g25nU+9YeKO0wqX29EcsO5YfYkhYO9cTi/5omHYFpBbjGU7o0?=
 =?iso-8859-1?Q?1+jXHMgaLjHbTrBKG0nD7LPOxuqJeu0xQENPZTq7OPNyLt/DP1zv4VBhuQ?=
 =?iso-8859-1?Q?6eaqONXeN7xUDf4OWIL5a17QS2WuO3/nK8PgzQuPBigLJCAAKiea8LaU5U?=
 =?iso-8859-1?Q?l4sDjGsY66xSqJSByI86QAPAfXqPZJlGYUUiFGxzNylLztTbiSa+f/L9Om?=
 =?iso-8859-1?Q?aHhvl/eBKVNQdgp3LDXf82RoojlMoWxOsb66DZX2g3EA62ZXyHCofNZeGi?=
 =?iso-8859-1?Q?bRlRzsvRqFbc6jXjCx4ClV+AJKjwxhH2WYUiCzOncogNdjUbcO4RCsst2w?=
 =?iso-8859-1?Q?nT4dUppkbWzBJrIH8fJ4OntiTjGYBCiEq4WsnmbyV1xdmjKzY59MuLNzxX?=
 =?iso-8859-1?Q?VNJXbDsBpuO5snVZHUlW2wq/uc+br94K0wQiTgH2q+ItEZ1jtLMJKDZS4/?=
 =?iso-8859-1?Q?hPxdkpcr3oXeg6SQPOlSR2d5s0arAwPA4jMrntRCWEmqnOLq513BULzjNB?=
 =?iso-8859-1?Q?7VlP8KFfsuFGAmfsKfSQdKdtASKr+ilRtX2e++UAY7RNbY6TAQB6nUBfFO?=
 =?iso-8859-1?Q?HlouXegrSwp/2e5ZjOLO6fSQTsxqLtkXrWCA8w05C4Oh0LjN3OTS/vtSVb?=
 =?iso-8859-1?Q?nqYO+9imStX8j542GxdTHU6Z5CzJcChW2sjXVffTVCZn3pgYFbqao+bw6x?=
 =?iso-8859-1?Q?9SL4mwN/2aMxwGZWRZ38pFhSqMYE3iHxv38pxpqORIfaAOBI1oS8mZWZoX?=
 =?iso-8859-1?Q?Vo7QGQS3m9xjPxVEsRyXX4NbZfjSmHNiPRTWk1nEbE3eSjZuQXyCv0xFSt?=
 =?iso-8859-1?Q?HfFzaH42B55I/6JVe11uwWpX7M/8FNEzIgfABQPdp1rHFRXp8CQWMN5epn?=
 =?iso-8859-1?Q?Rrk/Ly1UW1UOKGjdB8cgPa2e9ZNSDyrY4Gzp0YwCNlcZPpAuUH1EHSIAVs?=
 =?iso-8859-1?Q?1kH99Xz6Yuxab1mynNFv0GrZRkOkOS7ocZ7gp2nLobPF2y1yIwZ3PX09BD?=
 =?iso-8859-1?Q?gCPeSjXwxS8UfRphKvVUOy6rrg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Pf+WvqbXW5NCY9Z1myoOqVzK3V96MmI2mhhCJnpaH8D5SSIYBhZCF2Ohb+?=
 =?iso-8859-1?Q?L72ywTxprFlghLDz8JTDGu1Cduoy+81UMP3V61+wLBgXx2uojM3fHcqp6f?=
 =?iso-8859-1?Q?ly3vPyTCFjoEsMOkJB7DV0ll+37R7C711kg5IyxMzSsBkcH0jKAMH1gcWH?=
 =?iso-8859-1?Q?ufDw6h0OwjS2wVxuTrOqKOWbZsL9Xkjv7tRVr+RqgIfQEhKr37X+Q86Xpp?=
 =?iso-8859-1?Q?lmUcW3o1/ikwVyNMDsWQIEEDFVpGObsdZ8EkQNUqAy9T8BT3gpmRLsmgXq?=
 =?iso-8859-1?Q?3zGHzLXf4QQt3MHDa8sUqRsU+XgcilJlvRROARlkmWb6QrbxD9RSHnB5mT?=
 =?iso-8859-1?Q?/7Gmn8OGrMUQKBUeVRidrLEeSnQvYrLbgSzD9jCx8eWaqYQzyc2kn8tGXn?=
 =?iso-8859-1?Q?m0Fe8aH1Qf9rQk4elM0DYOQkH+2MFa0C5jd6YCUkBKvxLjEUQ1YWrcWsCf?=
 =?iso-8859-1?Q?KqV1q6rBcRCtzKliGU+7grmUxA+xc4VILEyd+1cyiXfT6cnKhJZM5M5uWo?=
 =?iso-8859-1?Q?Sk0qzNSBehSBwM/I1CT5iFFwswk/HxREFswENl0KNcxZVyp7ZPszoD/p5B?=
 =?iso-8859-1?Q?PFK4sdG9jusOzM+SH+2VG1YFMTf0LM9wuFivn0FNWmSYS2jtsV7fVphJ0o?=
 =?iso-8859-1?Q?z3/mUTyXAa8/II0552YcoMxLDMBCa85oDcbmoanIOOdiM8n8aBA4pjvaAT?=
 =?iso-8859-1?Q?c6dsgA3+T/hcHA6TL4tyT7ZSijv7Y16O9o8xMWHnFJ6LMqo5ZBqCP2u93f?=
 =?iso-8859-1?Q?33GqSKC1JcVe6P6XTqbyuECF8dzwm1BtE3wsGU/jQxGUsn3YQT/shJYtGJ?=
 =?iso-8859-1?Q?jSOhuylgCAulJZhf32oCllPcoiOgOO6tCsJ6h4DaILp31C+JmE5InrLhhe?=
 =?iso-8859-1?Q?BTCJaFlwFez6XeByZLvR238+USKgs3kmAicY35Mpfi6loZcXEszPRgRMrM?=
 =?iso-8859-1?Q?rL3hoKIYaKb6BGTKXmN2sshxClnkey98/IQBPqBPrtE1RdV0T+EhxdKFYo?=
 =?iso-8859-1?Q?PY1wIX2f3XJu9tWgzjT7jcmbDTuDPv5PWzw6zDH6coyz7OsFx0XeA6DMUh?=
 =?iso-8859-1?Q?if7frgtuEoqGHH+3yFfed4oIPrzRRkUI3fW70+SpT4DE36MVGVBGWOZ+OD?=
 =?iso-8859-1?Q?2PN2N1cr+8QKHZnnNCpM214OhLUSMeZwPG44LPTA7IcIPAXJDxzpWta/wF?=
 =?iso-8859-1?Q?CBApkVLrOrX2efWW//6ljR1SWjBEdWOK35zzzV7upySNCQ3m5GlwyfMpLq?=
 =?iso-8859-1?Q?PdamvNjw2l9IwP/ea+0xpzUNWOjaohKcDkXUKl9r0YGf2ijQKESgGPkHII?=
 =?iso-8859-1?Q?DXO1RF9A8x3DjWJchBGueijFBPWEVXQHd1NiDO5x1lwo2VxQ1qngc+0HSG?=
 =?iso-8859-1?Q?12lvlPAH/ou8rWmSR9dOWWLGK3iJAG8ZHrD80wKfamtHrUpNRKALnmYLbU?=
 =?iso-8859-1?Q?vKjcrAndQg+uEIlWHv0P5RUaTO8Zv7ip8w+Ljr3FFvouRmhYDo87JWtyAQ?=
 =?iso-8859-1?Q?36XsHyX2CPWTjAtKcJ5uhAmuZjhLRBdaYfsfLcj7BBrH4dzX12s3MFpTLz?=
 =?iso-8859-1?Q?CvsIu3DEzjzhnEBfaTnQIqyvED88L7mzOJ/Pfmedy1vGf24FTAbUV8chk9?=
 =?iso-8859-1?Q?I0sO8izbln70o2I1xZHCfv3d9SDXyefD8y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf46d2b-c4a8-402e-94c5-08dc755c374a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 03:56:50.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8UKQKJCVWw3RKTWXW68i1vAH26S99M4czGBuwq3h3dsUNJrrsucL1OHJIe6Ugic4eIRmSscbtTvNzB95/JuuDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7463
X-OriginatorOrg: intel.com

On Thu, May 16, 2024 at 07:56:18AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2024-05-15 at 15:47 -0700, Sean Christopherson wrote:
> > > I didn't gather there was any proof of this. Did you have any hunch either
> > > way?
> > 
> > I doubt the guest was able to access memory it shouldn't have been able to
> > access.
> > But that's a moot point, as the bigger problem is that, because we have no
> > idea
> > what's at fault, KVM can't make any guarantees about the safety of such a
> > flag.
> > 
> > TDX is a special case where we don't have a better option (we do have other
> > options,
> > they're just horrible).  In other words, the choice is essentially to either:
> > 
> >  (a) cross our fingers and hope that the problem is limited to shared memory
> >      with QEMU+VFIO, i.e. and doesn't affect TDX private memory.
> > 
> > or 
> > 
> >  (b) don't merge TDX until the original regression is fully resolved.
> > 
> > FWIW, I would love to root cause and fix the failure, but I don't know how
> > feasible
> > that is at this point.
Me too. So curious about what's exactly broken.

> 
> If we think it is not a security issue, and we don't even know if it can be hit
> for TDX, then I'd be included to go with (a). Especially since we are just
> aiming for the most basic support, and don't have to worry about regressions in
> the classical sense.
> 
> I'm not sure how easy it will be to root cause it at this point. Hopefully Yan
> will be coming online soon. She mentioned some previous Intel effort to
> investigate it. Presumably we would have to start with the old kernel that
> exhibited the issue. If it can still be found...
I tried to reproduce it under the direction from Weijiang, though my NVIDIA card
was of a little difference as the one used by Weijiang.
However, I failed. I'm not sure whether it was because I did it remotely or
whether it was because I didn't spend enough time (since it's not an official
tasks assigned to me and I just did it out of curiosity).

If you think it's worthwhile, I would like to try again locally to see if I will
be lucky enough to reproduce and root-cause it.

But is it possible not to have TDX be pending on this bug/regression?

 

