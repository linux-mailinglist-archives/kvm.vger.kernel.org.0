Return-Path: <kvm+bounces-26449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D476F97482F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 04:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C1071F26F21
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA0039FD9;
	Wed, 11 Sep 2024 02:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ClmGuP09"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D0E38382;
	Wed, 11 Sep 2024 02:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726021143; cv=fail; b=acAZLqckTHls1eqG3/wK1OFPzmeuTrTrni0TQzWwg5AZtm5Ce4ySCI9sOzs/ciJAwrzg45+OV8Ga9xnppKNMQMuz9j8kalI5bpXMrYuRmlzeA0JJXXioHHaDXa9xLcKRzkE1yPlWl4qWqTkBnD+l6jV9MkDVXdlpe17GwNpr4OQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726021143; c=relaxed/simple;
	bh=SVFxmfYvXyAAuk6BL7fhPghBGuaIvDU+TLrRVnEwrCI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T5bMZUwBdgA1OTKtBYPYxmxOm/9EVOgLAYJNYEFxeUeyjyY3l+ZOE0QHba4l8xAcKAT+T5DLbJYBLvtr9u/qxCEh3PRJ1+YDbQXJqODISzFyZO5Xx50QhIzwxiuh35TeWpCpDsgw/RLaMuVsdrfOKa0sGf2zfNGJuJbJB+dEsuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ClmGuP09; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726021142; x=1757557142;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=SVFxmfYvXyAAuk6BL7fhPghBGuaIvDU+TLrRVnEwrCI=;
  b=ClmGuP09IND5JTNrb6ee8tsI572K+jvLj0MCedUrOviejB4iWqDyy++C
   wmUpg8/hcTe2l7T2y70NNuo4HqpAZa0i1PWpWyU82+sH++U3ce2owXBZk
   H/jnGVuWUZvUpTRhQUULvpJ8dVtmVgupCMfh1mCnIi1xp4aCul/lv/V+l
   Dm2iT9oOE1pGmtyt7cJZDPjfUxvnsPSpjvgznUeeuo11fh5cRwkxj8DtF
   kO6vck7JbdZJxI0gTzDNLTThml9Ft+Ffg+gg5Mx69VEWXt9ooHXcZP/Jj
   sKHjCDuW6QAS/oi+KnfVx7VFzbDSa9sNUoxggjfyfJEG+CNHd5jEuBwXV
   w==;
X-CSE-ConnectionGUID: esnZ18iQT2ih3NZv6RkwSg==
X-CSE-MsgGUID: Xoy3ci1lSq6Dr24K9VrMSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="35370364"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="35370364"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 19:19:01 -0700
X-CSE-ConnectionGUID: GUCgN+DxQV66g350vyp1Pw==
X-CSE-MsgGUID: /bkbicRuRZiDzxIKePUP/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="66848559"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 19:19:00 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 19:18:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 19:18:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 19:18:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2r6TOBe629x76p/IOOuhXBza4Rq/K0GKxO+cadJ+Jthwho7KbFUwHyJYkKS847cNNmcM5BDaLUlATLQ2tzo0PAaFdyFZvwViAU9T61/fHkpYypAqFY8PaZGSyqC10w1BROwk6RZrPV07HFa+IHV7J9Lxb8UjAqHBjltMtpKPjobJZrjR2dQi+PJ/mR2bdvcOy6OGKKsgcPtmylX8H6/yJ6SLT+QxTTXysWGjbgWy1FMCghOl4RA3xzXwZWBgNrzVyJb8WxypC3XrkjASMGdcZirYEoFccvnrKVobgLNBcrrOAM0SV94h7UqOLUlbYwRaHjgWVS0FpmIsliGON0PDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z19pP2QEHTmpr+yeJAT1txkoi0PiQ2ZNWfkQ+EMfcYM=;
 b=gtbZ3gpfNzmgDuPjnKwu703a0aF0CT3J13fGraf9P6NqWWafY8wf3Zkdf1kr3vSWcBrCM1XcwIpAx5nOKiByMZNfONEKh6/wFlq9RBl0uQPvNG8gBrl8d1k8fdLiClJRG6Ym2Q+cLOO/sTu8pnOOyAz/sIRyd0EMljmxFm35mnuD9/m+lFWrBysBY7bGnAVQckWevFtAq+j1uAYhlwawdVuyEwaVqDd1XURVt26vWlaOq+fw6jc+EKpOo+K1iVdenl95pqtq4A8dkAg9AZMHRFpAkday6m8VoFOJcve7jvsMrskRr/yHUJdu+VuQuyAPKDe94o/Mal9EAc3wDW5kew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6714.namprd11.prod.outlook.com (2603:10b6:303:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Wed, 11 Sep
 2024 02:18:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 02:18:57 +0000
Date: Wed, 11 Sep 2024 10:16:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Peter Xu <peterx@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Gavin Shan <gshan@redhat.com>, Catalin Marinas
	<catalin.marinas@arm.com>, <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	"Alistair Popple" <apopple@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Sean Christopherson
	<seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe
	<jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand
	<david@redhat.com>, Will Deacon <will@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <ZuD9l6D6XuAUb4tP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
 <Ztd-WkEoFJGZ34xj@x1n>
 <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
 <Zt96CoGoMsq7icy7@x1n>
 <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>
 <Zt-N8MB93XSqFZO_@x1n>
 <Zt+0UTTEkkRQQza0@yzhao56-desk.sh.intel.com>
 <ZuA4ivNcz0NwOAh5@x1n>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuA4ivNcz0NwOAh5@x1n>
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6714:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f3d237f-0a49-42e5-dd8f-08dcd208170f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UIACUbAs9lmqX94DWb/iU+Zw0yhzDrvMUjompm++Rv7324Da0ZoXi48fAeTT?=
 =?us-ascii?Q?sHWotfUZjB3YNYtq0PXEGQD2Ljib8bp4zjSIMUnqh+US6mCreOcCgB0JGvvO?=
 =?us-ascii?Q?PWjiumU/ETzWxee+BFoBOCnZueagw33W02dONI6/WFhNHOgklREO06qLc+wx?=
 =?us-ascii?Q?ISL0eWuRnByznvoyQ3DCFnPC1qf44EiPotU7/eIAGmIaq1BqjuiYHhgqAG7Z?=
 =?us-ascii?Q?7JVi51w6ON9QW17bIX1UcUnHw3VES03MBpWqd3QWTlRRuxr6zRFR2MWDVgqK?=
 =?us-ascii?Q?tTAA7Yk4k0qXmWfkf+gOj3n97I2H9Ax/awGzC3TcTlyhWdSAuZ6e7qMI6DQI?=
 =?us-ascii?Q?Rq0MM0dnVIUgniPlXtsre7bbZG9DaRfBBVrLFAvt8Z5Bu3IYyFpj/0UUxzUt?=
 =?us-ascii?Q?QIV5+4vURa066/MXsTWkXKVFUn9boFSsJoR1QwMULockJnbpQPRlhn1ihuKg?=
 =?us-ascii?Q?L6Bo1LN47cGOxQ8g1jFZOWUiwi7AdcB1DWb+gHHhmKbC4XJQV5MKg1NCniud?=
 =?us-ascii?Q?jt4l64m828v1vUtzbYd8PVx+PEFhVdH6Ty1Fp68sX4LEIhl//gT9prB+2srY?=
 =?us-ascii?Q?X8fXIxtAIlD6q0BPw4yAOF6cJXtquN/hoJ4JjyQ4i9jFY51vha6//Wv4ZgwT?=
 =?us-ascii?Q?t2fg92h/USiCKYBb3KDbJ94x00CtqVLqVDxy7INgkatTXaYSlQjIPSjTuWM1?=
 =?us-ascii?Q?v0r0pQet7Cz8cqD+ZZ4M9rg/myRsOVbDQFW2rOXjmU4E3LBMsgl3F5NqEN1H?=
 =?us-ascii?Q?f7snoGmvm2ToUL9i7dseg5wnzGCfmHE8IAGhAw62R0Mu1VAg5ufMhyVaxeVe?=
 =?us-ascii?Q?TwSdDcxxCF6pRoxNSO3xduwxWwU6LLtcLKgg0rTIG2c5GEZtXjJL7Lu9qO17?=
 =?us-ascii?Q?7K1eEM6AM/1EkKt6FfnK8zN+WGTgwPObCCaT6HFc7U7E0XBpZPWWjDuzJW38?=
 =?us-ascii?Q?y3CSkHpRvox790IZ0cjq3b5mJEOKAjWep46Paf/oh3ZtczMeV0ixZKT/m07J?=
 =?us-ascii?Q?mJXAGr4RBCc0tGKfbabgsEzo0J7gRJVtoUQexFJoaLbkxdPJvGchqIJ37/a3?=
 =?us-ascii?Q?2GP5PMm5rRxiSfnyhVvRv35CKK8tj3phk672lTskV3N2sERaGN4qHUg2/PnK?=
 =?us-ascii?Q?uLIJg683wF8uf9BG6WEPImqeOfis4Yp25ReFpHZ8ewwpn2ewRxyWf15I0qHp?=
 =?us-ascii?Q?grzK52erTnAoZtqacPt4HQ5O9QSteZ3SaltaMHjAUAlYYTfCkcHpjDXneEzI?=
 =?us-ascii?Q?wK/gURsy0dhjFir/5oz+hVAsemT91ogAuDLg6nNex1clWRUmiepds2+nQDyh?=
 =?us-ascii?Q?mpsqrtFlwuHcThMfRlpROJrwY73+RUse8yp/7IIqmgDy7A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NbS7hSBtl7UE8+EYyxh/zuPVmX81kuYLt28MOQ+eOhfbFwH1Chx5/60KFCu8?=
 =?us-ascii?Q?KUys+O3hbAwvBicRRrXTVmOyB8j14ZNeFxdgWmiN5el2MD9PqSLWm/EVtWOo?=
 =?us-ascii?Q?fGPtGKqDG8AEokseIyLTt9sdQ1RJ2aXp/plQfnXfmAFgq5HSIteoEu54oXkq?=
 =?us-ascii?Q?H3HE6uUmEEKHm3CVTBnBTEuvHYZtJPUXMkKQBzyuqcH+jNoLtAIr1wWZumVD?=
 =?us-ascii?Q?MJRF76TFwQNiNxyLCFtmeyb7luMuTdTfGBS0k/urd2PVy2upQ1eJb/f3gf2M?=
 =?us-ascii?Q?B8YuekJgn+VmJ805Lc9hTN3D9FUSdZFY7/K6/VCneMn8/UL9fCRTOIUg4D+e?=
 =?us-ascii?Q?AGs9eIVawg7vQL9oWjCTjvi07dWSzD9QlMl7f5fOc3E6RU8di+6YndYg5p32?=
 =?us-ascii?Q?uDDHt6wx2r07z3Non0DI4BCH9xLgnGO37bztoAZq5pPQYKIhxUnMiSa3LArp?=
 =?us-ascii?Q?ojtPVy5uy47GXFUQbJKvyl+YpQCvioTvCaMbsCzv2LIBs0Hm8aKCb4TyUNXL?=
 =?us-ascii?Q?vB3D64jXdfUdwIB8pKX7zY2vk2QdJOmqdPXtrtpOnrYlcuQN7t9dnc1ckVRb?=
 =?us-ascii?Q?k893RP2JQwXPBMwypNuw1IGGcExYmOR8eqf2shHkOnXJ2C2HfTS5V2aSS2lM?=
 =?us-ascii?Q?SZX4fcADDHxtJ7nnIdwQtF6eqMYvHcTBvBt/0Smsj9pN40dTN4Mqlahua2lI?=
 =?us-ascii?Q?Mco+tvcEzy1+7MUHJwHw9tVAHTLPlaZv4gVGfB+LEwhTfrn54md7wCvVDs4o?=
 =?us-ascii?Q?yEQpyejbRPowNgOXHdd3qex5bxhBZWnUc5PohABc5HolF1EVPOZOVsaOkJB7?=
 =?us-ascii?Q?J5JjH9o7591Gs7+kNab7Q44NDwtCqj9be0pM99f7/zepnMq37lPaRZLfiBGC?=
 =?us-ascii?Q?6wk+3UCYiw7+VjEZnDheKy7qeg1cU9t88qUkPwmfB7f/4rKEoCn3BBFJs3p8?=
 =?us-ascii?Q?u92x9PVoMdRLMf7RgsBgo9YGlbT/2JKiRbZO33glYRWrnTe2A6lNSYs4zTF8?=
 =?us-ascii?Q?6hJZJDBvmBprVNvRdmez13SkYybvalX6QsuK9p4CMApIMrCtM4aBlisuNHtm?=
 =?us-ascii?Q?FnkslOJmlRUkkamUntYrKb0U+nLSOphw8Kjj7MF1Og12PqFUzqO8iI/l4k59?=
 =?us-ascii?Q?vsWitekQsZpCsN7qOct3gBM9OZXcI2+b0b0QAPml13PSM69VMQS+KFYIUnpS?=
 =?us-ascii?Q?vOFT8B6yIARD1Q14DdyO9lZWslzbhkxVqqpuVItc4GenHzMOZ99vn8jjM2ws?=
 =?us-ascii?Q?0NafoyZ1mzB6RYoQa+mb4ljozA3sMyzZe4FQjwsuMSDxZqWbdFLYZBqd88/i?=
 =?us-ascii?Q?CbxL51vXMmv/beF/HuMUBILnvNVLV6TPGs6jHgbYeZe4LVqx18/dLR5YKH2t?=
 =?us-ascii?Q?9ID5RtYlMW2aB82AbKWAsas7MgMDX1H+c/hU5zzRvwRL+d1uRiFkSpucgVus?=
 =?us-ascii?Q?8kb9sFiPlyQniQaETD4serPrHydNdBBNcS/CeZjLRiLkhC+3xf7dxC+NHXgs?=
 =?us-ascii?Q?geFjWZmJ0Olj7Yu9d74zAdaw7PN7ri5Yg6uk60OHnsBlR7z/eMlsQ137TElB?=
 =?us-ascii?Q?OThA07MvHZoY6ruplcGfwMx5rOwocf1fAgZ+gmaZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3d237f-0a49-42e5-dd8f-08dcd208170f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 02:18:56.9601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ng2VbhNjemTFfcLOVsc0+YRiGH5UhBkqN0wGUCfMglbApUiBhzAARUgVajySws+L2Sc63pYVcYtvMHsXWF5n8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6714
X-OriginatorOrg: intel.com

On Tue, Sep 10, 2024 at 08:16:10AM -0400, Peter Xu wrote:
> On Tue, Sep 10, 2024 at 10:52:01AM +0800, Yan Zhao wrote:
> > Hi Peter,
> 
> Hi, Yan,
> 
> > 
> > Not sure if I missed anything.
> > 
> > It looks that before this patch, pmd/pud are alawys write protected without
> > checking "is_cow_mapping(vma->vm_flags) && pud_write(pud)". pud_wrprotect()
> > clears dirty bit by moving the dirty value to the software bit.
> > 
> > And I have a question that why previously pmd/pud are always write protected.
> 
> IIUC this is a separate question - the move of dirty bit in pud_wrprotect()
> is to avoid wrongly creating shadow stack mappings.  In our discussion I
> think that's an extra complexity and can be put aside; the dirty bit will
> get recovered in pud_clear_saveddirty() later, so it's not the same as
> pud_mkclean().
But pud_clear_saveddirty() will only set dirty bit when write bit is 1.

> 
> AFAIU pmd/pud paths don't consider is_cow_mapping() because normally we
> will not duplicate pgtables in fork() for most of shared file mappings
> (!CoW).  Please refer to vma_needs_copy(), and the comment before returning
> false at last.  I think it's not strictly is_cow_mapping(), as we're
> checking anon_vma there, however it's mostly it, just to also cover
> MAP_PRIVATE on file mappings too when there's no CoW happened (as if CoW
> happened then anon_vma will appear already).
> 
> There're some outliers, e.g. userfault protected, or pfnmaps/mixedmaps.
> Userfault & mixedmap are not involved in this series at all, so let's
> discuss pfnmaps.
> 
> It means, fork() can still copy pgtable for pfnmap vmas, and it's relevant
> to this series, because before this series pfnmap only exists in pte level,
> hence IMO the is_cow_mapping() must exist for pte level as you described,
> because it needs to properly take care of those.  Note that in the pte
> processing it also checks pte_write() to make sure it's a COWed page, not a
> RO page cache / pfnmap / ..., for example.
> 
> Meanwhile, since pfnmap won't appear in pmd/pud, I think it's fair that
> pmd/pud assumes when seeing a huge mapping it must be MAP_PRIVATE otherwise
> the whole copy_page_range() could be already skipped.  IOW I think they
> only need to process COWed pages here, and those pages require write bit
> removed in both parent and child when fork().
Is it also based on that there's no MAP_SHARED huge DEVMAP pages up to now?

> 
> After this series, pfnmaps can appear in the form of pmd/pud, then the
> previous assumption will stop holding true, as we'll still copy pfnmaps
> during fork() always. My guessing of the reason is because most of the
> drivers map pfnmap vmas only during mmap(), it means there can normally
> have no fault() handler at all for those pfns.
> 
> In this case, we'll need to also identify whether the page is COWed, using
> the newly added "is_cow_mapping() && pxx_write()" in this series (added
> to pud path, while for pmd path I used a WARN_ON_ONCE instead).
> 
> If we don't do that, it means e.g. for a VM_SHARED pfnmap vma, after fork()
> we'll wrongly observe write protected entries.  Here the change will make
> sure VM_SHARED can properly persist the write bits on pmds/puds.
> 
> Hope that explains.
> 
Thanks a lot for such detailed explanation!
> 

