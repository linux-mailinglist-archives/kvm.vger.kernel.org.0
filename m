Return-Path: <kvm+bounces-49821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3676EADE41E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 09:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A5BA189D793
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 07:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B5E25D1EF;
	Wed, 18 Jun 2025 07:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UstcQFi1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5804E25C831;
	Wed, 18 Jun 2025 07:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750230023; cv=fail; b=JuSP0CXkMd9Glxgd+tH7zoO3HTxYJ+D95WSNONDBa+RXBKcl3dVOJk3ZU/idzzf9VFEtnX66rtvjCQ3H+I7X8+DkeuWENxKC/krTA7nHbbA6S0Jb2SSHbkLhjioH2uGqqKoQx8fR1IXf23MVSKOE/yW0PJOTt65zjOP42hu26N0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750230023; c=relaxed/simple;
	bh=q1kd6SF6PFhaJkvW8p0scHZ0w7JcTNbO36ngeXwDU0o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G1sKM9w9RRsSWzXRkD0JAExSzY9Y7636W7v+fgcOeVG88d13fgwDsZMdeP8CY68nzSIqGl9uxqKr/uaInRTMz+BKZ7ZbVJNl4H3kM/rD+qEiK3l9y60zcpzwNoqpvbERuZrXEOCI+VkY2+XinMTzdkYzd8dOWlzv3JFuOUY66zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UstcQFi1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750230021; x=1781766021;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=q1kd6SF6PFhaJkvW8p0scHZ0w7JcTNbO36ngeXwDU0o=;
  b=UstcQFi1dVQYRvF4AwMNODux+HpJJwQR5Mr8Fb4ueShY10lVl6gm7gnL
   CoGMCiDq2CZ+p7g0yCrW0ExQCPmJPCAUtmMxJ5IiB184458ybfTlE0Tza
   mSwTjFB68oxj89lQ3AAG9jRyI5m8XSvhCgdwiA/fFUVgfQGmbHW32jTgu
   R/F7bJWXCid/O8N4RtCAi+PUaIwrsLRPWfxGc2QaiE5cU6PNs+L48yEf0
   +NRPlOESNqSi3eM2dCEhb9crx0tT1cRAsRI4VHChqPhiGSIUEq+s9jzvc
   azU6Hr4OqGsZRZpNrVXPRtMV9pW9qEywL4EXXq3s4oT61jcRz/JvXdow6
   g==;
X-CSE-ConnectionGUID: No1z8QVASCO0Iavh1V142g==
X-CSE-MsgGUID: t4k3DZtYSbWLHCbFALc2Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52571913"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="52571913"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 00:00:20 -0700
X-CSE-ConnectionGUID: mwtWc/mTTLSzMRC6eEaPtw==
X-CSE-MsgGUID: m1FQKQVhRX6E4nRJuNygIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="149254053"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 00:00:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 00:00:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 00:00:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.45) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 00:00:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cr04GKGbpcCDqIxPJVMpHxsR0N6o+J7LAa3dvJ3WXfKb8BVx0OnrdfVUm2Fum//vnpAwYKAAloraQ7cxa2aNpN6mOaP6fJSfNRq8GNFDCol4pHrtQKkyuOaKE1UrG+4TCH73uT1A0rzKwlXNbkUjlarYN5vvV1+WlVoQjPul1q9zOumiStZDJ+HwknhVOnifF1ov7qGytGwa5e7ICsgBEPkotD6psnqZL+oho7XQ8SLtQ1HdRM3bibmTbI3wq8smXFS5Hz3WlX1gEWebN9X4WfsdByxgUuCbPk/WH4R1QqJ5qra8QY4XaxzEqCa2Gn6hjGjAtIqeGHw1x2EmTN1jNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGxaaVWuSncgexq5AK6tMn6SxNJEYDdJLmUgIVEkBAI=;
 b=LJFdcnW9W8x4SbHEV3nfPjdUP7xreL8MAmCfmXYhzQ55GKgN6wdxFUkvO7Z0Q/wDVkJk7R4amGeJceMa9vXZRIJjaQOyQrbW/p9SH2W7lOkiMi+lQvniLB5zs0M88LdC1hgJRZ79IccQHXObipQ6pR6vIbMv5G3WZ1mDfaJGAtBGFIOuZ1AO/jHdy1ozHLOvlW3gsWo7bGdlXBU7QK73bKugZIv3r+2PL9Igp7/J3GCAyXAjGLdgF4Xc51dvBMoc1xGIQEkEMTQ3+lOcLucDT308WlXFv68VaZi+fK8Qo8ocGayrvVqu2qK3Gsvi77JZdk8pYKaWkjK2y9ZiGHI2vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB5803.namprd11.prod.outlook.com (2603:10b6:806:23e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.26; Wed, 18 Jun 2025 07:00:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 07:00:14 +0000
Date: Wed, 18 Jun 2025 14:57:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
 <aFIMbt7ZwrJmPs4y@yzhao56-desk.sh.intel.com>
 <CAGtprH9Wj7YW-_sfGQfwKHRXL-7fFStXiHn2O32ptXAFbFB8Tw@mail.gmail.com>
 <aFJY/b0QijjzC10a@yzhao56-desk.sh.intel.com>
 <CAGtprH9WLRNcXWr1tK6MmatoSun9fdSg5QUj1q=gETPmRX_rsQ@mail.gmail.com>
 <aFJdYqN3QHQzMrVM@yzhao56-desk.sh.intel.com>
 <CAGtprH8_vR7ozfbmsTryJLRAKy06rc61zip2uw7cg_ptY01+zg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8_vR7ozfbmsTryJLRAKy06rc61zip2uw7cg_ptY01+zg@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::6)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: 943f88c4-5e72-47a0-c686-08ddae35c640
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y2hSanpZWXR3WUxPSFBnRFE5NmNCdVpnSEhZNzg3TGtpb2h2UWVUUEJWbEJV?=
 =?utf-8?B?ZlVRZG0zdEllY3hrSStjZ0M2Z0llZWViUUhMdGdsVXNma0tpbHFWYThVUkZU?=
 =?utf-8?B?MlBna1dRZzNTY09Xb2plT2doWkJaTXpRd3F4bzA5aGVIM05VSGVtSjBrT05i?=
 =?utf-8?B?Q01ZYlU4ZzlaTTFpNXAxZkFKTDduSjYwRDIrTUthVVFYN1dxRkY4MEdTbjZk?=
 =?utf-8?B?a0pVTGpGdW1OSWV6SE1IMXN2ZG45czFNQnQzT3hTUm5jcXhOTlBNVzN4WFdk?=
 =?utf-8?B?NVhCbnlsWGhCdGNHRGM5cWhveHBNVC9aTWZveEczZUpEaUgrRlQwZG9nS2l6?=
 =?utf-8?B?NnExaXpYZWZxK1RCdmVFRG0vV3p2YVo0QXcxSFJkcXdsbG1iNnlJLzRuVXho?=
 =?utf-8?B?Vkxncm40VGphYnpXU3AvVGZadFdZQ3hNaFFuWUlzVGZFZVpPMXZlQW5RaFlL?=
 =?utf-8?B?aGMzYTJVeWFxMnhLbE1tNDVid2MxUC9FTk5GYzVNZXJVWVA2eFUwVWxHZVZQ?=
 =?utf-8?B?b1BYdnVJWWFHci9xbnY3VVY4SVJEN2ZZbFBYOXh1SldiZE40UUNDOFJWd2Fw?=
 =?utf-8?B?bDBsV3dvaHV2L3REU3VJQ2h5Sk8yalZIYkJGSTVPY2lGaURKbWtnSTdrZFc1?=
 =?utf-8?B?NDJtOXZmMjhRQ0h1Z0dKODEvbFRUeXpkTWYrbFlwcGR2YVN1dFRacmd0eklj?=
 =?utf-8?B?dmdDRitWaWlIODhpWFBMRHJhMDVJNkNxajFzQkVOWnZDVWtuQ0xvL0FIUUkz?=
 =?utf-8?B?V2NqcGMvVDJ1RTdxSFQwQnFhQ0kwcEZjbkUzQ1luQlNxMko1VmhsK3JJZUFC?=
 =?utf-8?B?ZGNValpXMzJuK29raXM2Q3g5K2I4blJqMXNjcVJoeTFVUVljNThNMDREdGJ3?=
 =?utf-8?B?ZFAwWUlPWG9FdEo1bEFoR1ZDb0I4T1ZOYUpjQjBIdnE1TjFNUDlLT01hVFFz?=
 =?utf-8?B?UEExRFZVZW1LZjMwK1ViUFlvMGt5ZmlrVlVRbVp2MDZTd2o2TGZ2Tjk5UldQ?=
 =?utf-8?B?TGcvWTA4TTU5UkVHd29hMU9DcEdmNjM0RlVDeFBteTJHZWRicjIvZ014L0tl?=
 =?utf-8?B?eXdPbHUrR0VMbFVwcS9iWlpZbTFvL21jbFlSNWtjYm8rOTR5T25Kc2w1R2dG?=
 =?utf-8?B?b0syNkZzSkZqT3FuT2ZCVXlKamk1ZUgxNnBJWE9qT2NkM3N3TVdrY1c3dGVs?=
 =?utf-8?B?UU9pRWlWVjBwYTM2UG5sdnZNc0YyRlROSXRNTTEyOTRKeXhCMkdRVXhEdHpx?=
 =?utf-8?B?K3MrMGd3R3B2YmlaWTRXeHhFOE9PY0x5L0FVTXR2L1l0NHQ2cVFGNnc1ZHhr?=
 =?utf-8?B?MXBpN1dnb0cwc0xLQzFNRE1kcUgrdXpiRk5udWw3OCs2dk9obnNyWFZoMmt6?=
 =?utf-8?B?RGtMamYyV2psVDhMOUQ0YkhxWVpIMFJlaHJHdzFRcEg1Q2VLL3JwSjRVbE5n?=
 =?utf-8?B?clo1VlVLNHE5TUxBN2VId0FWWk9KOTVnSjBtWFE2bEllWGpDMDk3SlBjTlRN?=
 =?utf-8?B?RjlON29ENXArTnlCL29Mb1ZmeWlSWHZiZmJrWE5uQTZmKzBsMWRBc2ZlTTdZ?=
 =?utf-8?B?NkR6dUZzS1k5U3luUy9xOFU2dzFXN2ZqZE5nZmxweTBCSmhKT0t5TWJzVlB1?=
 =?utf-8?B?MEJVVENzSlFBSlRtRVNOQTBxRGxZdUU2RXlLUGZMSUY0eXlsUkZDdXB1NEVs?=
 =?utf-8?B?YTY4OGRFVDFGVUlMdVVRUUtWZ0FPVU1XL2YvZmpOb0VKUDR4a3dOcWhxWExK?=
 =?utf-8?B?RStncnJJaHpjM3p0SkRpLzV5cDBQZ0wzcEpUM0J6aHV1emdha2ViUm5jMWFZ?=
 =?utf-8?B?Nk4xVWZPOWZlSUJiSG02K2xtbkNWbm1XZnQxbXQ1UWIrZlJQcWlENUxmallH?=
 =?utf-8?B?ZzBrMzYzRjZ4UkM1ak4yQVduRnpkWndOYzc2TXhJRW1oYmc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0RpSlJzMWNvc05VQnJ3RHVPK1ZkY1JFMy9aaDQ0ZUZBU3BZUFVkQ29DYjAy?=
 =?utf-8?B?c2ZxcHE1UjNxWSszcDU3TmdZMTlkdXJlUlIrY0FGcWVESGpaZjNkdDJVTVJQ?=
 =?utf-8?B?T3NTcXRDSG9hdGd4ZWI0RGhoWmxaampGa3FXMm1uNWUzalpaVWlMUUNxZDJa?=
 =?utf-8?B?NGpQZ0t4enNjZ3VsL3Q2OXMxcyt4NzltajJUdWF1Zkc4ckJ1eGpOVzV3Um9Y?=
 =?utf-8?B?STRBbHdHaVFITUFvTTRBQ2h6Y2liaXl0R3d0NWtBbmpEblJFSSt0cHFhMjhE?=
 =?utf-8?B?bkIxVUdzUXl4V3RmVEJpNFVIT2crcnlLYklnWXM2ei9wVmJaVDVOTmorTXhL?=
 =?utf-8?B?Z0YxODhLSTRJUWZyTktUOHppT1pQdjNyV1J4eFJWMURDNTcvTzZkMk9YNWRY?=
 =?utf-8?B?V203MmczOWpWM1JaL0tCQ1JiMmMyZlV3U2VtcUtFWk1PUTZLWmdxQ1N1U2c5?=
 =?utf-8?B?SGp5SXkzOTliZFB2UFVlQkZNTXpRejh1d1paQlRnUHpKUjZELzBsUWFtMEtp?=
 =?utf-8?B?dWlmOTZ2a08rQytUZEtqZC9hQ1ViL002aW1rbEFmalN3MW9iSlIwQlhiTTVR?=
 =?utf-8?B?allMT3BBb2lBNXBReExVYksrVnB2RmhkSnpBYVplSFZrWDk1RzdSNHdEN2FC?=
 =?utf-8?B?N3VBbTYxVmhXNnNKcjhjM2FMNmlUdWpXSXNVU3VzUXNrZEhGSmlkWlBkU1NQ?=
 =?utf-8?B?K053QUE3NGhHRkYzOG5FUWFpSmg5cUdEMEgvcTFHWkZJZ2VZU2wzeDViYit3?=
 =?utf-8?B?Kzc1V2poekdNb3JkYUdMdEVLdW1vTlFrUnRZdDlObWJQcDVVN1ZjUFFkZDVJ?=
 =?utf-8?B?NzJuTVBNYzRrSW4wd013eVY1LzhxUHBucjN1OEhBclhKNFZuL3JQSnMwZ1hU?=
 =?utf-8?B?b0JYbGdKZDN1VEd2OUo2bkpUaUVRZkZFT2ZIWU9NUmJDWXNicnJyVkMrVmE0?=
 =?utf-8?B?THRLeFNMclVtUGY3L0l5RkV1d2U3WDBCUkdlNnFsMXVlazlZdm9DSFRhWEdp?=
 =?utf-8?B?OXhROTBualRXS0M5bmpUWXE4MEl3OVVmbWplbm5DVnlaZk9nTDE0UmtRdWVB?=
 =?utf-8?B?RnJ3a2NKanNWd3dnbUw5YzJEcEhEVXZrLzE4OW94M3ZkYVliTUM2d1d5Rkti?=
 =?utf-8?B?QlRQSTE5RTJvZ2gzWmFKTWZPdUNKWTR3VW1iQjJ2bmxnamJYck9abklBaHcr?=
 =?utf-8?B?bGI5OHJZbk5VR2VWYjl0VjgzaDFyWk9mV0V2Yk9tMmtGYkNURllsRmlaVmVZ?=
 =?utf-8?B?VFI1T3BnTnFDaEJrenR5dTIydVpzU0VYOU1zcWlmRWJ5L0dwZjVPUUdxQU8z?=
 =?utf-8?B?RldPMWFZalFldXU0OWY1SmpTQWc1MCsrdWhybG03MytYL2xqMHR5Z2hrc3k4?=
 =?utf-8?B?UTRUZzkyWGUyWjlvVkhwN3N6WExhTC9IN1RiVTJHMW9rV2w2Nm1DMjRJb0VM?=
 =?utf-8?B?bW9IdUk5Z1E5cXJDU2ppNXg2SXJyY0ZZeWk5VHpzZDlURnpGVmIzdzF2VnlL?=
 =?utf-8?B?dnBTMHFJVW8zVENLcDVvK3g4ZXRqU01Ca3hMUWNoRm1NY0diM1ZETUFPaVhV?=
 =?utf-8?B?ZkNUVFNPYTVYak9USU9MbE5tOXM1VXBPTUg1UGUvWVk0MUx5UGZUSzZiSGdC?=
 =?utf-8?B?ZTQxcWRUTjlVWDFTb2Jyb2JWMHc3eVNPRVpnOVhYd0hpVEl2bHc5OXJ3TzA0?=
 =?utf-8?B?RTE5cnZqaGcwRmp1WVlMSC9pRThaTXhGeHByemZGZS9OamFCbTVYL3FCNUtB?=
 =?utf-8?B?djY3Z1VMd2Q1M011a001Mm5iOWFpdEphM3ZuNis4VWxkZnJIY2VIQXlhNEtr?=
 =?utf-8?B?Tkt2aFZ2ZEhTdmRkR1lRaTlmZnVGMTU3S0l2Z2dEREdsVGNkY3k2Y3dJMW5x?=
 =?utf-8?B?eG12a1F2UG9hZ3FhSThUSnlxZkhibnBhbTZkeVNsMUlmeUM1YXYwNmlGRjND?=
 =?utf-8?B?TjRETUU0dmp4cHV5WDQxaVgwNUpWRlVZNDFicjB5SXVoUS94cTBYbHJ0bEZ1?=
 =?utf-8?B?SGNjQUFqa2gyWGU0VEFyTDRjdURJWDZUam0yc2tkVzk3Nmx4c1Y1Yk1hTU8y?=
 =?utf-8?B?R04wUzhTSTlrK1RxRTA4bFdZM1RjWTRod1lpV0o5NnJISWU1WUxqK2c2RHo3?=
 =?utf-8?Q?a7cj59mWbMeSZ3qZxLbUOrTdI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 943f88c4-5e72-47a0-c686-08ddae35c640
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 07:00:14.0216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYO3VdFf+Hd8t0M/TAxZlYfiA5sLwvooa2yrrgY8BUU6y8wpB6LuB9TyRt66dmWAuCEBXRg023+e1UgCoqbkYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5803
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 11:44:34PM -0700, Vishal Annapurve wrote:
> On Tue, Jun 17, 2025 at 11:34 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jun 17, 2025 at 11:21:41PM -0700, Vishal Annapurve wrote:
> > > On Tue, Jun 17, 2025 at 11:15 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Tue, Jun 17, 2025 at 09:33:02PM -0700, Vishal Annapurve wrote:
> > > > > On Tue, Jun 17, 2025 at 5:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > On Wed, Jun 18, 2025 at 08:34:24AM +0800, Edgecombe, Rick P wrote:
> > > > > > > On Tue, 2025-06-17 at 01:09 -0700, Vishal Annapurve wrote:
> > > > > > > > Sorry I quoted Ackerley's response wrongly. Here is the correct reference [1].
> > > > > > >
> > > > > > > I'm confused...
> > > > > > >
> > > > > > > >
> > > > > > > > Speculative/transient refcounts came up a few times In the context of
> > > > > > > > guest_memfd discussions, some examples include: pagetable walkers,
> > > > > > > > page migration, speculative pagecache lookups, GUP-fast etc. David H
> > > > > > > > can provide more context here as needed.
> > > > > > > >
> > > > > > > > Effectively some core-mm features that are present today or might land
> > > > > > > > in the future can cause folio refcounts to be grabbed for short
> > > > > > > > durations without actual access to underlying physical memory. These
> > > > > > > > scenarios are unlikely to happen for private memory but can't be
> > > > > > > > discounted completely.
> > > > > > >
> > > > > > > This means the refcount could be increased for other reasons, and so guestmemfd
> > > > > > > shouldn't rely on refcounts for it's purposes? So, it is not a problem for other
> > > > > > > components handling the page elevate the refcount?
> > > > > > Besides that, in [3], when kvm_gmem_convert_should_proceed() determines whether
> > > > > > to convert to private, why is it allowed to just invoke
> > > > > > kvm_gmem_has_safe_refcount() without taking speculative/transient refcounts into
> > > > > > account? Isn't it more easier for shared pages to have speculative/transient
> > > > > > refcounts?
> > > > >
> > > > > These speculative refcounts are taken into account, in case of unsafe
> > > > > refcounts, conversion operation immediately exits to userspace with
> > > > > EAGAIN and userspace is supposed to retry conversion.
> > > > Hmm, so why can't private-to-shared conversion also exit to userspace with
> > > > EAGAIN?
> > >
> > > How would userspace/guest_memfd differentiate between
> > > speculative/transient refcounts and extra refcounts due to TDX unmap
> > > failures?
> > Hmm, it also can't differentiate between speculative/transient refcounts and
> > extra refcounts on shared folios due to other reasons.
> >
> 
> In case of shared memory ranges, userspace is effectively responsible
> for extra refcounts and can act towards removing them if not done
> already. If "extra" refcounts are taken care of then the only
> remaining scenario is speculative/transient refcounts.
> 
> But for private memory ranges, userspace is not responsible for any
> refcounts landing on them.
Ok. The similarities between the two are:
- userspace can't help on speculative/transient refcounts.
- userspace can't make conversion success with "extra" refcounts, whether held
  by user or by TDX.

But I think I get your point that EAGAIN is not the right code in case of
"extra" refcounts held by TDX.

