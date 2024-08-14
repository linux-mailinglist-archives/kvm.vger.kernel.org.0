Return-Path: <kvm+bounces-24127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 621E5951A04
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86DD11C2113F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A1B1AED4E;
	Wed, 14 Aug 2024 11:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ErZYkgSX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232C213D881;
	Wed, 14 Aug 2024 11:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723635408; cv=fail; b=QiTYd9icAdVbhNRyCcLAnqNoSzf4CsjL5SNUlbqfbvIBqUXdi0v9Zspu117p0f6RNk9kx89LWgKWScdMDipF4vQMsM5pqWWKilEgONM8O16q9UGdhXliSJB4CYJ1Q0Of5jH72iS51BZI5bYCUWlF8dHRQB7l/H/3+Ebwi1KMWmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723635408; c=relaxed/simple;
	bh=d+2nJ4vtqryZocHtDcjMOV8aJFJ0Uqwl4KcDaSQCDxc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OdY1UxS1T1lzm7rmBKh6c9WOGG40i7mjjtQ4N9kurmdUl7wsQIwQLHJ+Ai8/rK/M6aByDdqn1gONdctoJCi/YNT8o1FehNVUyv77vHT3+f/b+0n1klZBWJGgGFH1iUzAE0oIXlJB/hD/P5pVv6rBaL6HDue0pXsRC+z6ywDcoF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ErZYkgSX; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723635406; x=1755171406;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=d+2nJ4vtqryZocHtDcjMOV8aJFJ0Uqwl4KcDaSQCDxc=;
  b=ErZYkgSX2ec5Re7QET6EaGMPSxhUnAjCSU+tj+pj+la2mSHg6Ziok1h8
   3Ke3edkJArrs3I5sqNjO+tyMYrKdcIXYGZcJkMjjIETKvVtYaIIQMYqNt
   hfXKFHBrZYzafhJNnoeWn035xj1VFoTBAlbowkp3q+iZLO444uPN65fHp
   IOsWZG38Lcj7rkihf4dzCj1b76XyTM68XuFGY+X9xxfnFme6RVUnVOzdG
   A007whX9PtHcrIFfevuO/8LEf3c0ebl51jYNu4geTKEFEDLidW6bxRB7C
   L6bFe7U3xmOTJl37fUHq5bc2JEOpp0hCV3E2tal5cGYE5nEbVfLrveaAn
   A==;
X-CSE-ConnectionGUID: GAHBjS1SSiaz9mrmgdKQsA==
X-CSE-MsgGUID: 3EBFwdAGTKmoK3VioebhcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25605045"
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="25605045"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 04:36:45 -0700
X-CSE-ConnectionGUID: SW6hWBraS5WZGnrHZxMiBA==
X-CSE-MsgGUID: L4/CW50EQG69aAoh8WYaJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="63384712"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 04:36:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 04:36:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 04:36:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 04:36:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 04:36:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AmkJ/e1CqTQa5vgg/rwL3taOloZoG1hhcXT0gIvLV/rNh0yscVQnPl6efetucMruM+ircsditqXT1mNvf342XK4ypGP4ZiuDJJCYKtVz/uLM6F2gasoPuqYqkRPWrWOBBlOHIfnNe0mp1eNtOTum4yyiQwhVfDvg9xXfCGjMOVLqs+8pYpYp6t97GsErtd1gkJ6YuunUtdWhNpPpUUITmoNPhBA00a8p/h33uMMIuGdIO33BAKhQtCQUNZFcdkofiBhNJrtjWn/O343mwNumCpyCG+Wwd5ofcoLFw0F9tbU7waXiQ273r0XmScfUeUmxwTJisAhATm19GgM90GDvIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YU5wsRGt6Odmv52S2gDpgjNdRRz6OEYKihxZS0eAVHM=;
 b=qTCJlpZIleHrTL1WmLWNbdMfHygrfLT/RaxbU+NjnS4EaxL6kYXd5SOjfP0L/s5Ae3JlrbEKIgm1FohYu92K5oEFxec1ZCGQJ2LovywhoWJAW5sdk//4DnnzonFiNk8Fo88YegzcMGIhyxICTyFXZUnZmucmD/fIimyk0qacK4IJyGZ8qh4J1GnR7IPFEnJFLRJD7JffF6jRDaEPI+PmnbnnXmyhprwRByvo6MSjRb7AyGQqwtMczVCbRlk/zQP7DVApu0iMdsCuZ0bkFRdCxxdjVrQ3I8GdX4ONXweNqmZoRI0f9Gjyf7RV8tTl2vvQl9HJKSAHvGw9IzWQvf8HMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8579.namprd11.prod.outlook.com (2603:10b6:408:1b6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Wed, 14 Aug
 2024 11:36:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.7875.016; Wed, 14 Aug 2024
 11:36:41 +0000
Date: Wed, 14 Aug 2024 19:36:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Message-ID: <ZryWwC7qxWUGyLnp@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <ZrtEvEh4UJ6ZbPq5@chao-email>
 <a24f20625203465b54f20d1fc1456a779eee06a1.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a24f20625203465b54f20d1fc1456a779eee06a1.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0113.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8579:EE_
X-MS-Office365-Filtering-Correlation-Id: 0491d36d-d073-470d-6a4f-08dcbc555df2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: 2WnmFtAeDa+u0sVROkXFDT9LXfN3NG0WHD8o7p+XO9qQPk7xwiZA1TNPgtH768h5+qz59VZU0ei5nD5D+/MEthIvUJSUtwDQtHGQJ7SNK6R7gixKe3Pe3qK0HQx4BR7HlTAH0OJokIrzScZoF8NTC4XVMqLiMLIgPyR0YljW+NT4FZiOrO3Kwnk3JWvNZj3j02wKfMq0wchm+8sjcDDXhwfMcy3/p/CFLBZPveEv6hHecLQxnoh+kWxe3LY3bSlsodzQqfDC8CS+jy9eC9kBTBk/9JpgdY1HemrAAebITVt//KJSoyr3QqSIwy61Tqo3wWKo9Uk68teAkci4NpUSACS5GCr9SSKkoH3fnDK/nQpjpvvRFO/Rf0p8i6N+coZP/LwH5Lbavg2ppqoyQjDVx4wSOiJIbWxLkiQS4pypTUsrvfJMOMU48iFscMFuPeof1SAEV7lqDyLWGg5YHfU0/tkdvq0Ty0YNEgHxbjRXomW0V+bBHmc7SK4k7QWpzDH4yNmlXRXYO8DI5pmoB1qq6lk6tVu9qBTR9tqRc0Qvfs/ia7XBizezkT7HniCu4eUcYI9YO9EIatwSPRzj+RnuPHgUjEFKBTiMrjnxs5Evl2pfG8g9MQyTq1gV5UPUfUr/17nj6ZR9Ez1HksqMoOs5qfuX3IfCXHOQhA6HTCCsMXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HKHPZ9mTF6KKqNotE10C5xD0G3VfnN016Vdv/c6vpBigVspvwraDA3MPFX?=
 =?iso-8859-1?Q?qmQB2KBpVfeG7WGCRJxNpec0vJd43Omb4RBO8gtqz0LFZ4WdmSL+1L/2zf?=
 =?iso-8859-1?Q?6VvhK00VQDs6N6alKj4NJlxOT2ou/W+UmreJ6pT/hpguS+lJA6mC3AZlqp?=
 =?iso-8859-1?Q?VIF6h9B5f7q0T0lXy6WGBJgnzIgBE52iQ7z5S9u/pLrR7fSs/QbcvzLvho?=
 =?iso-8859-1?Q?lFZ2FtUNFBY9cgCGir9x8yedCScFHTNP2FYLa+keV2l1hlRfVwBRFu3+bu?=
 =?iso-8859-1?Q?twqNY1y4yA7mGYieHfa9r1VTXkXg6IsEzMumXPM9i9GMOK7tOwYMPIU/lK?=
 =?iso-8859-1?Q?KWq5gPAKOnB4Pkh46lSIVwFJJE6sEw5oakSQG/NaEWkI0ad1WzB5JReF7U?=
 =?iso-8859-1?Q?U6kukSsDZp1KG1814cxRyOR4NEJZZmzYJ2e+DxJZIougajoQJISiO7OCU6?=
 =?iso-8859-1?Q?RmeEQ8kaMAFqNKoq56IZ8qqhnUTU/3gJIlULIM570/zxQ8tvCxNevaXq5Y?=
 =?iso-8859-1?Q?aIbw1kvNQ4GAU5WgGCwxsu/w0EcKHQFo1jwBCnTaOQ4BLo2GtIP6dlwtal?=
 =?iso-8859-1?Q?SgeFzAndPYdGbTGZwWbqRXZ5qH1OTUE9Bhz/rmPd94kEYCxd2DdFtSSZR8?=
 =?iso-8859-1?Q?lnkIUM1ipS7szjpbSEOUnNJ5NE/el2y9jEsE/x8eQGwXpsbVrkNoBoklrc?=
 =?iso-8859-1?Q?kpZ6VbZ7iFoWB7XumakG7o/QVevSiB/54nL8gxsSn+80NGczVFlbVI0Nd5?=
 =?iso-8859-1?Q?n5gJVV3umR5v+/iu/YSxrB0cnwTefD1Q72z+XuSnNyO0mAc3tdyLujBMbf?=
 =?iso-8859-1?Q?sNTOrWT5FIkgskFqbspYk4zj6KkV/efz4QKp9NxXR2Hp119A5IQrOCHMrn?=
 =?iso-8859-1?Q?16KUVJuP0hFhdShXGPaytv3qPZQkP4ehvY0GIKiLPOrMvKuq7CwJwgGZ3G?=
 =?iso-8859-1?Q?1vQLP62p1x4CJL3robxrTHvwDQM59I5y8RrrD4tjD06kUPQmcu9kzqo0G4?=
 =?iso-8859-1?Q?PjZdg/VpLYckWYsf7qr3I+IFjjb17KNxHeY+8WRUlL9ZbQ404PWfcqU6+i?=
 =?iso-8859-1?Q?r/uQybOPJuI9j6krxtItm8alK0X+WO+CM3dbSROfl7dmYdUbOKD70EWTzk?=
 =?iso-8859-1?Q?Vo8WuFNmN22u4KbYTVQeWWJv2AgJ8RK/vrXs6AgHanYxS8IWg5UD1XiZtR?=
 =?iso-8859-1?Q?lZTodtAXtGZxCJUtwWZXdCoRUejo5VdQ/uLluN7cf6ql8VYgkFKbfRW0jQ?=
 =?iso-8859-1?Q?9bVPiE8Ra9OBI8iBACmuro9Qyo2REAeg1v0hUbyztkNIB7ypSYin8is7uD?=
 =?iso-8859-1?Q?KYRsNBIwDjlkdu27U9U6An7vY60BUNmchs2kxo7xxTUck+vzZiYQegGyFL?=
 =?iso-8859-1?Q?Bm31HrrzNxUew2I07oyiZ3c8zXUu1Yi34yO/QMlvbA1VIZF1ktBJ1QU+8p?=
 =?iso-8859-1?Q?0+Ic8XgqaQQxHiWJfvjsTtZ9zpLkQiitPPO5ovVMwNFxDhHo7+qNW3G4T6?=
 =?iso-8859-1?Q?WOvXkIOEUekaukqCvyDhfQk1/tbO3g/jShcWmi1KWitMStmJjD7TcMYo4l?=
 =?iso-8859-1?Q?srIu/LZ9vskkgNwnvypB9qYXWWsbiAeAm0etm+b42FAsaDfrjMSqOHWzDY?=
 =?iso-8859-1?Q?dlXT7JEpJslgHwd422/L8ZFQcB9NJfy5Lw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0491d36d-d073-470d-6a4f-08dcbc555df2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 11:36:41.7421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osbhkgxeeuAN+nUfhxDsGc1oJws2D10fU9J8BXcs1yqEil/VuUkaQD9kgwoA4f+rmkI+bwDSHblgNCTiLgYUNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8579
X-OriginatorOrg: intel.com

On Wed, Aug 14, 2024 at 02:45:50AM +0800, Edgecombe, Rick P wrote:
>On Tue, 2024-08-13 at 19:34 +0800, Chao Gao wrote:
>> Mandating that all fixed-1 bits be supported by KVM would be a burden for both
>> KVM and the TDX module: the TDX module couldn't add any fixed-1 bits until KVM
>> supports them, and 
>
>> KVM shouldn't drop any feature that was ever a fixed-1 bit
>> in any TDX module.
>
>Honest question...can/does this happen for normal VMs? KVM dropping support for
>features? I think I recall even MPX getting limped along for backward
>compatibility reasons.
>
>>  I don't think this is a good idea. TDX module support for a
>> feature will likely be ready earlier than KVM's, as TDX module is smaller and
>> is developed inside Intel. Requiring the TDX module to avoid adding fixed-1
>> bits doesn't make much sense, as making all features configurable would
>> increase its complexity.
>> 
>> I think adding new fixed-1 bits is fine as long as they don't break KVM, i.e.,
>> KVM shouldn't need to take any action for the new fixed-1 bits, like
>> saving/restoring more host CPU states across TD-enter/exit or emulating
>> CPUID/MSR accesses from guests
>
>If these would only be simple features, then I'd wonder how much complexity
>making them configurable would really add to the TDX module.
>
>I think there are more concerns than just TDX module breaking KVM. (my 2 cents
>would be that it should just be considered a TDX module bug) But KVM should also
>want to avoid getting boxed into some ABI. For example a a new userspace
>developed against a new TDX module, but old KVM could start using some new
>feature that KVM would want to handle differently. As you point out KVM
>implementation could happen later, at which point userspace could already expect
>a certain behavior. Then KVM would have to have some other opt in for it's
>preferred behavior.

I don't fully understand "getting boxed into some ABI". But filtering out
unsupported bits could also cause ABI breakage if those bits later become
supported and are no longer filtered, but userspace may still expect them to be
cleared.

It seems that KVM would have to refuse to work with the TDX module if it
detects some fixed-1/native bits are unsupported/unknown.

But if we do that, IIUC, disabling certain features using the "clearcpuid="
kernel cmdline on the host may cause KVM to be incompatible with the TDX
module. Anyway, this is probably a minor issue.

>
>Now, that is comparing *sometimes* KVM needing to have an opt-in, with TDX
>module *always* needing an opt-in. But I don't see how never having fixed bits
>is more complex for KVM.

