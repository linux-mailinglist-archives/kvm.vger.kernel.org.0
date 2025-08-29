Return-Path: <kvm+bounces-56244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D73B5B3B2FE
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 978764685A8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D23224B0D;
	Fri, 29 Aug 2025 06:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lAbj9Vrr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840C48BEC;
	Fri, 29 Aug 2025 06:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756447774; cv=fail; b=XiRe78m83gfJeO2AMb51pWfKBVzMnDdaL+qCpXrmfLRJx0V7/qH0N9kx5YcVdR2XMTK0VYLdH4pYDNq/iAgQHVbMGkYkzeXmkNbHl4WvAniHD1+O0jFsEDVlPhWg0O0vglEpacLKkOvw3NJyC3lImaEwT0xpDweW6QOoTLN3u4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756447774; c=relaxed/simple;
	bh=YRnJRDAmH1Q4T975S1W1hiwmMLSmyQlrDsDAnyvqNC0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qyW4t8KoZUAYHzFqexs1O/Yz0ArxBucerWO+oIuPi8E1sMTR3zodMxqShORRYm1v5iBUjokyizMHy/BP3aZQWL85LjqX+KfNk9k/Kjz8E/SeiccCcOM3Jd+E1GtFRAhauNRBDzDYXzs6jEKVM0wFRfVWS8BQM/Yd6JQhSZTSdJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lAbj9Vrr; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756447772; x=1787983772;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=YRnJRDAmH1Q4T975S1W1hiwmMLSmyQlrDsDAnyvqNC0=;
  b=lAbj9Vrrl9WCCkxQ5iA1HmzWTXUtQxDfqypVQLimPeB32snm1Ma6BzNR
   Hk3Y+evGR7L98jc5vbTB5t7Dy+PvZjfmS7xFc7f2S6qfEcEBxb2Oyrhwh
   UhhK+YrKS5RVvZdMcTPonhI4w7CRnrEkanQXRir+gOvsT9uzw8i/120bb
   +xmkRB1kDzeb0hQzxzXG5hulvgCSZNqaXFy1JkaXY7rjhCY53AtEmt8Xu
   LEyE+Do6bZjK+8NmURHmOqppqyeYLVLFAKuAOp9eHSBl/RhDooJhxsLCJ
   xw3ZoWbxINoYpCQ2ZzY1B8pKa/A+rEb+Qxp2cJc19Y3jEc+r+RA1MSgv+
   A==;
X-CSE-ConnectionGUID: V2IQzDJfRYqiFrRoxC4WTQ==
X-CSE-MsgGUID: U2xhhovARvyn4dgIez2J5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58581137"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58581137"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:09:31 -0700
X-CSE-ConnectionGUID: MUhhAXh5SQyRZQkOiUPZKQ==
X-CSE-MsgGUID: tn6ppGB6Tia6A6bBeg+pUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174684906"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:09:31 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 23:09:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 23:09:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.74)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 23:09:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDgTRw9swc8x2QyNVrgQkO8Z5s9T7aC0pin4hoM4JSZvN5RZYtAeHJBraCdKCHonsq7zNtVdB8AZTvj9J29c3ZLImgpX31H0HXuNewpQSwwBjYlaXTDX7tk1w6t/NSwEg4EWTqUsjup0qd+/QM9e/oJbCGwLdCRKd+5oLgtWpF4YgkByPcyM7oiuWosUOWXs4G8CSSwDC33U94SaaWMsvEDkAzFILJCzZMZSplPxR673a/I6rrVl+q7slKdnj3Hg/i9JNlgYembpiszdzPondzA0BLPSd8H7MYpS+CJ7wHYRJooSWhKtBmXAzaufOzWhVDz3eLGJuIYiISNRKcZTYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xB3POCNjlaJxy+wqWx/6qRf4Bt7/N/7sMwEJYJVlu5o=;
 b=c64us5LMLmI1OcaWx/MxDb8l9gb1hoi5aMsGvEvGFbtWCha/pwafo70mqjBFjyU4Hp604jetOTPJXw5BI981oQVztnqDZZfCfjae+aeC1LyfkeujQC7yC/VBNCp0vA8vYjuwGYOznF8iXMCtL6eWJjkwQwfeezR+bj6YvJ6c4O9LawEeBkCloORBPT3lFrFh4EPHeunCf2Pcw2irK9lnVCP10xF1sYcuwz82IdCG7JForsgxFoZ7j3q3XvRgLWvG6Lir6aBzhFQl5juNlVDwETf/BZY+bjdR44G8ULXSzYZvAucTXr3CGz6ulavvsIlUkzfETR5/7YSAKyRv0z+nmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9133.namprd11.prod.outlook.com (2603:10b6:208:572::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 06:09:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 06:09:23 +0000
Date: Fri, 29 Aug 2025 14:08:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aLFD4io/Esm3hO9R@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
 <aLCJ0UfuuvedxCcU@google.com>
 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
 <aLC7k65GpIL-2Hk5@google.com>
 <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
 <aLDQ09FP0uX3eJvC@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLDQ09FP0uX3eJvC@google.com>
X-ClientProxiedBy: SGBP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::35)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 54f5e44c-11d2-4306-34a1-08dde6c299d0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Hc/mMFwbnpnA1guHq3avUsa7Qs/o427hAguZUFXHCjZOMr+MXZcIeRDGbl?=
 =?iso-8859-1?Q?ypfCXzSL4z5RH+ew+UC/Nm6FIJ5eb/XNYpW5HPaOvRnZmzD7qUhcQd9Y2b?=
 =?iso-8859-1?Q?EiyYnX6/3r2lRAbzANVw5WdMfe/sjBVEdnnkZFkOrIZp9YuT8SIgEl/zE5?=
 =?iso-8859-1?Q?GR1kwPTOcU+U8g6SqK/d3GBu6PypLd8/Q3YD7ZjWdXnTnYx+w9w98XQ3fD?=
 =?iso-8859-1?Q?kJOLw/PdWP+BvrxCZ2V46CTR6JgocL3HlfnHAiYkBjZLrK8TV72LE3+M1n?=
 =?iso-8859-1?Q?5NfGGp7ZgQ9aWnC9N8+NjWPpGIqLYhwotRMq7MtKX3n3vXm5folmf5qDk2?=
 =?iso-8859-1?Q?ITtzsowj1ZplwVRs88sZKJGzVqum/B9LfQuh1Q/9xY+4zmr2uaylpUoy2z?=
 =?iso-8859-1?Q?ItslUqjWHcyN1B2Z6D0FFyUirryZ289LuBQZGjUo4juEeLGh7onLDTo1Ax?=
 =?iso-8859-1?Q?6kBPwErks5Msmz1Qov1F5dNfqkA8t8neP33vDNhlCbhSiU3PpsmmpymDGp?=
 =?iso-8859-1?Q?w/7w/JH69EsyCuCtbQ8xJ2mcpr0f33Vy9TRELp4fS/ik1gTR2PW24TkCjS?=
 =?iso-8859-1?Q?dBp0WGOGYzvl/CVqG89RgUjOYbTzVZLhu0ebqm7LB5lLHyFhrHzProiqm3?=
 =?iso-8859-1?Q?tlJ8gHtAzds1ch60wWxDClyReCSZbNtbGNZ4FnFKYWZK5rKW9e4Y+hr5nV?=
 =?iso-8859-1?Q?+4EKsUfBm4rSlSCpxhHXUk1za3AIvGskrTXbJleRroKbDm+LPWJGhzIult?=
 =?iso-8859-1?Q?pRfKjkQbXmuffKh/tb9oIJE+i1/aRCq5ypYy5SlwgF3nhA3nsbxIPygxyK?=
 =?iso-8859-1?Q?X67ZfespGwVhaleQdmQMcoNP1YL+eA4mbiiazOVb1jDVX5j9ITIy8TKwlp?=
 =?iso-8859-1?Q?NS4AxojWOkgiDNLYjs9qcSFq8kbXa2gTzb9p+Fqn2m80emtyk+Q7zWM5fD?=
 =?iso-8859-1?Q?rtQh0VykEQeyLnWhT5WnYWG0EYoCi/tCksSymMk9Qw8oC4ZcdrX0Kr0s1s?=
 =?iso-8859-1?Q?Deomz/kkAQ6Dnj4qUYXamLVeuoDROOggqeEcQO7svdrHOaoBiVD8w9gZQ6?=
 =?iso-8859-1?Q?0gwxsZXpjRGvQbqTip1k1o8kA7hGEjkdCyuOZXtOfC+qRabwu2b2g1n4hY?=
 =?iso-8859-1?Q?hm3O6CAF+SPHPC/2KDh36x6rO4xVs8t2/Mm9Inu+3ntA7Ru6YvgqfppvdB?=
 =?iso-8859-1?Q?UdxXwTqoVHw8nImGQunkYc5XZWVtWnfbQdtBSKh44VodIUVDXdZSaSw+X6?=
 =?iso-8859-1?Q?gGmnuDD6dMC1RkVJC6zKnW3LoYo+xDUvNy/ecP39N7nIgWpxY/8r4lzfUq?=
 =?iso-8859-1?Q?+ZvrGwIh6mVURspAXaly6jpDa5x2Rbj4ViWVwrYj3fDfFgacuViCBMYtPQ?=
 =?iso-8859-1?Q?hjrY/9mOvojIefzlAMgFuO3CCygOPXFH2eNpLvloYA8Zr3Tj594D0009wU?=
 =?iso-8859-1?Q?yYVav6XGts8ptYykncs8fYxOxH7COACPg8kb5vLS/3oZvvL7dVyDu0lRHH?=
 =?iso-8859-1?Q?8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LwJkqku0Dg2xSdTRpJFWSsl6zVWC1+5uHWW+8CPYOa1St0hR2g7/6YIuCj?=
 =?iso-8859-1?Q?SeQ3eUbXahwz9GkDSL2xl2/Uhm82fQYwzr/6iFY32T7AgtdlbJiHtr15g7?=
 =?iso-8859-1?Q?/MxWmLbSt9625bN9KrPyPg47uhltBBenngsrMJTJIST2xgJYFu4g6JyAS/?=
 =?iso-8859-1?Q?rJj4iOUumgumUbJB+AHHLDHKD4EDnCx6P8lQLnQQGp/JkD0O+HUUm2iG/M?=
 =?iso-8859-1?Q?GnKvPdby+TkVXSvo/6sduNmSQ4ED67kCUBOf5OGQKjJB6LZ7nMpclJdtjD?=
 =?iso-8859-1?Q?L+/F4X43sXMT8mqGNwRpyL8Rt9GzeyW0ZOin1+weAPoxHxgnMLBR3I0/4h?=
 =?iso-8859-1?Q?fd9iZ57RnMscUe+IIqMUCp/6Nk6X7KtLr06VF1JSW2qzcD346pql9DgDcP?=
 =?iso-8859-1?Q?nJ3hq6OWJf8nfYYTnw79ZRM5ROPbwGr5tEOMdaIWcc91KqvFpM/fq80u2O?=
 =?iso-8859-1?Q?/7YLY6XpVSciUBabahFNhq5lHQLa+/LSCmyau41OmQRvu9SfS6waWWT6v6?=
 =?iso-8859-1?Q?s95V5tGLTNWJw1fcuo/ziyWARlXnVcd/JWFOyq3ndUs3/rMbhDAF3KIorX?=
 =?iso-8859-1?Q?veltEP6ZaR+XeD1K88ricohLuoXiFLBxXM6xg2XIcwlc/ea8LB3gAldD8j?=
 =?iso-8859-1?Q?I4P3n9T19ks7JvMUlPgWytLCPQGMnKMy/7aP3DSxKprs8WJaZ2vgYS7ZDp?=
 =?iso-8859-1?Q?ZiBrFkOGQEqeeFcCCkvQLpnvdk/0e9/SXx/DeWPUNsOQB1A1+7VjlKtQHJ?=
 =?iso-8859-1?Q?A6RzOH56ox1mQBKnNCGCM2ISldd/6Vm5Dal18udzjctEpEbCieVklEvFd8?=
 =?iso-8859-1?Q?mSAPnAhrTUKDCvemqV0UVu+PO3fXBSIpH4HPHqF0roXADPa5of7z5eeJG2?=
 =?iso-8859-1?Q?mTpV6cLA3iewP2hyOX1l8feU/3Kp6ME2yiZKF+YMCJaOVNCU/7Qy2vkFr8?=
 =?iso-8859-1?Q?POn2qfIo/ucwVIuI7VtqVG9RWpsZRNlentARZzQcxcDwOk/WbQ4wQfIf2x?=
 =?iso-8859-1?Q?Wta/2o060Cjt19oiukWISZeEeF+tihisZjHkLI7y9Bp1v3KSK7KXZgYMEv?=
 =?iso-8859-1?Q?Dokqt5GYUCfV+QVvESyLKsw6MqTNgokdahRckELJxYM//oE69AgMDALmQl?=
 =?iso-8859-1?Q?9P6wB9FObS1o/EyN3Vc8/4Zd5jXeXSuM8TtpjjDWSIyutf9jIXckMeZrbM?=
 =?iso-8859-1?Q?uiKl0e0i5KkCt4VLMFgzvZpIu1zYv0WrQjyOyuO9swuobPeWyoiAlxempS?=
 =?iso-8859-1?Q?fdl1N+o0MbmhQ5Fk1DJSVCAUSdnOWl5gikO+/Zg5vmZmbfOiCRxUlgDMCB?=
 =?iso-8859-1?Q?ggzuik55JVEwgnu2NxHvEOdcFdt4o7Ww9bqClZ2LBhP/Xmij0YyeqJFeE/?=
 =?iso-8859-1?Q?CzSvGj9C2vC59x1r9K9w3DOgvgichDkBw2CQLDDOicXyqAVPrZiTfaeYc/?=
 =?iso-8859-1?Q?4JmVcCck2ZlDtzJ3lOazZKSvvXMymxGDYUG4ExojKU8S2b3WCgn7QrLyv+?=
 =?iso-8859-1?Q?WKw43NHcQfT01AxxDakKoP0HN9nIWr8yoBJ5c0QC1StPb08D0BTAF0i1M8?=
 =?iso-8859-1?Q?doAiv3pLFDFRLjORHVw36Nlhsk1LKGcve6rMg7PlB8Gh4w0QtCKA/9XdWo?=
 =?iso-8859-1?Q?ZAl8o3mgU4dLwdWneqERsFpJlkJexmUeLu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f5e44c-11d2-4306-34a1-08dde6c299d0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 06:09:23.6332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jZDKOOSsiHrqANJz+6poYhWMFJY4/R95bjfsS/NWtlmU5+qs6ATeNLW2YCVl4/mxmDwHWDYbIzpSmqK8OVchQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9133
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 02:57:39PM -0700, Sean Christopherson wrote:
> On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> > On Thu, 2025-08-28 at 13:26 -0700, Sean Christopherson wrote:
> > > Me confused.  This is pre-boot, not the normal fault path, i.e. blocking other
> > > operations is not a concern.
> > 
> > Just was my recollection of the discussion. I found it:
> > https://lore.kernel.org/lkml/Zbrj5WKVgMsUFDtb@google.com/
> 
> Ugh, another case where an honest question gets interpreted as "do it this way". :-(
> 
> > > If tdh_mr_extend() is too heavy for a non-preemptible section, then the current
> > > code is also broken in the sense that there are no cond_resched() calls.  The
> > > vast majority of TDX hosts will be using non-preemptible kernels, so without an
> > > explicit cond_resched(), there's no practical difference between extending the
> > > measurement under mmu_lock versus outside of mmu_lock.
> > > 
> > > _If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can and should
> > > still do tdh_mem_page_add() under mmu_lock.
> > 
> > I just did a quick test and we should be on the order of <1 ms per page for the
> > full loop. I can try to get some more formal test data if it matters. But that
> > doesn't sound too horrible?
> 
> 1ms is totally reasonable.  I wouldn't bother with any more testing.
> 
> > tdh_mr_extend() outside MMU lock is tempting because it doesn't *need* to be
> > inside it.
> 
> Agreed, and it would eliminate the need for a "flags" argument.  But keeping it
> in the mmu_lock critical section means KVM can WARN on failures.  If it's moved
> out, then zapping S-EPT entries could induce failure, and I don't think it's
> worth going through the effort to ensure it's impossible to trigger S-EPT removal.
> 
> Note, temoving S-EPT entries during initialization of the image isn't something
> I want to official support, rather it's an endless stream of whack-a-mole due to
> obsurce edge cases
> 
> Hmm, actually, maybe I take that back.  slots_lock prevents memslot updates,
> filemap_invalidate_lock() prevents guest_memfd updates, and mmu_notifier events
> shouldn't ever hit S-EPT.  I was worried about kvm_zap_gfn_range(), but the call
> from sev.c is obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT
> so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and while I'm 99%
> certain there's a way to trip __kvm_set_or_clear_apicv_inhibit(), the APIC page
> has its own non-guest_memfd memslot and so can't be used for the initial image,
> which means that too is mutually exclusive.
> 
> So yeah, let's give it a shot.  Worst case scenario we're wrong and TDH_MR_EXTEND
> errors can be triggered by userspace.
> 
> > But maybe a better reason is that we could better handle errors
> > outside the fault. (i.e. no 5 line comment about why not to return an error in
> > tdx_mem_page_add() due to code in another file).
> > 
> > I wonder if Yan can give an analysis of any zapping races if we do that.
> 
> As above, I think we're good?
I think so.

