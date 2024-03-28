Return-Path: <kvm+bounces-13016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9777F890164
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:12:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DCB6296488
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 14:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BBA823CD;
	Thu, 28 Mar 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3SFJjew"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2F038DD3;
	Thu, 28 Mar 2024 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711635157; cv=fail; b=jxy5WmrPp1xPUtyJNyxfmWBIEFpT9xSPQIfedMJPZt9tkIQxrE/R1/gQumPDqzwhjprfpXPkMQ3mCs5vJ7mKPotwK8+Kz3PhKt+Wz0FlseVOq45T3HgeskyEbzuLQpj45+JU35OadhpE/oZPJJLev6X+Oz4duGfFozu/EDNY7SM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711635157; c=relaxed/simple;
	bh=4NderZtueThSDtY3+4WDJMco/mCudGpQen/AehOWRM0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sNMn2ajuoXv6mFRDEIX09Iu7Jrwgx6Eg/0HOIxY1KjMrRK4CuhSgO0U1LxJeP5aKebv6F9GHbZNHQd7Ks+vNX2dAPIWhBIGGsUFrvTdUZXsz3eo2qwxIE31ipoN9kGPtptrWXXxqXD0aJaUPPo/28p7BjfXne5Ly39VaG68y/BI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q3SFJjew; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711635156; x=1743171156;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4NderZtueThSDtY3+4WDJMco/mCudGpQen/AehOWRM0=;
  b=Q3SFJjewIbRGBNGStYykr+wXgZBQd/vzUTEAksdR12Lpl7klY92g/f4o
   I1366sqT0PzNm7zc4kb5QZr8p0FLNC/PSf2kfzoha728Vl+p2BU6bciBO
   lf1S89DwMtiefMCP7StOV9imIn50cUjtXg3iuXWNe7eAT6Rd40F5S1DiK
   jQvJdp2PN2I7tvxDf+M4pKWTqdl9kzCks7VNGM65ugtF7U8LEIBQfP/s1
   Y32/ov6Hk1pszKZgx76yrkTtjW0cHWMPrTuWfLQ4K/R2+2mjgQCkc9lqu
   kFec5rsJ3V1xPQxmlAdXDf/WiT8ElvFqGGAJvbydbR7n7kQb1nvsZBPOb
   w==;
X-CSE-ConnectionGUID: i7robAidRpG0IdANXI6/qQ==
X-CSE-MsgGUID: iRhuYhiOT6GfU+D9I/Yy5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10598029"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="10598029"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 07:12:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16544317"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 07:12:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 07:12:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 07:12:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 07:12:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvV0/h5vXMv1tgtNaIAU+LhuWD8qzI8+lu0ZKvVDC65Ws4Ryw6HOo2TDnpB5vATOnl95gNn7+NCFSn/9IdBXVWFRZwDqYMsj++DXMuOfkACC6EkWHRvsfJTTSbCeTA046WoeeFDhGAw3VjijTA/cum4yfM+2zbPm8+eO1mTYuhJ984f1Z3zNJYDwCAVuYzQqpvPa4o1sEqL//LlXpyCHYBrFPJZDsCUGqZJ4DEFJWNBcWWTkjLfEE4MEwDnCD1Y8LCaok+mQWwRVPntMXsS5JBGwRXzxup0iv/MtjzMdiPWv+CGo4MvaWyJOxH31pESB8qM5FP+5sNKj4S8RaIoiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unicYTGKIM9TCQ8AEmcZDG78HU3SwQGyrovKvC07yjI=;
 b=aV+uutOc8wRlfcbWaYcsLLSy+7/4frmv0ViCXWy0Z16KslaVw02LLq//DYhHLWHeEYy40c6LJSz1QTsg/7lMzDU74juwxWZeY0wGSx/cd2O03GZqeWPD6k/eLqR6h0g7baTYkznBLGR3KNDefT6mpFcF/JhhDq+M0g7CJpcWjZc31xwcMB8PBnpqB5rRjC4lqpGG7FGroTdOeVyDw6G/hYKsagkMEevCsNpbdr19DgfEUXeNzPmMICQMWLYx222wb/wechjPZ/H+7E6cKcd4kot1codID36UNww76/qmtbRnHQhEcEvzAC/mKm5D0uSUVmBxgSIpgJmSfTWbQOIVtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 14:12:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 14:12:28 +0000
Date: Thu, 28 Mar 2024 22:12:18 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <ZgV6wnQcU37Jbp7W@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
 <20240327225337.GF2444378@ls.amr.corp.intel.com>
 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
 <20240328053432.GO2444378@ls.amr.corp.intel.com>
 <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <65a1a35e0a3b9a6f0a123e50ec9ddb755f70da52.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5376fd-6ab5-4461-7a61-08dc4f3119af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jm1aToxL2TmMzy8vAEfKaJPyKVVADJBUXoSWPZN8I/vZRvC9UXpwQ/1jo78q28DnLOpnAwsI18sexcCPjHyCA7O2zOhhu4xZZ9Mb2lCCOtgW98OKuMv5/R7Wn3Oo20IuI9KrJ9gHBITzIs40H2RHqd4Oy8UfdaFgTBS2z04kyliFG3+kYKwkCM69+T1RnysfxXK9F9LkOlsib2/s8XYlpnVhl2Loz72NybwKaTShU0lrvzhhf31epJw5QkZ4AbeMKNB4oaTCkrLGX4nt+XDd787XZXdutO85bgxd43OdFrHQh86ZEEeuQ/3scgRU4BYu57MNodFNcObehqNwyCxL0OVurKaggaY9YQj2FhycAW8DilCFhNrliyRGsbHYVdY7NoImhY34sWe6yYQOdft9j2GDXz6LRYXWPwD8U1KHaEHgA3Hi90EP/yerqN5JNUpBo9WaER9ZX5OLh9tiMLIn2q9Tocn+4n4Fufv9orBXeyl7392Ig7cnplXJ8eLZwYH1r3Q0+rncG6650MYW21qyXVBtT3lRpWKsxmPz4y0Ak80EWBBkOY6L0NIWfX0hB4JgbrYy/M7sAKmqFH6z0gMTh8hSlwC5kzjHn/LNqEXtADZNCDgXRaq8Q0k3M39rAtD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vct1llWLKX/vXdB65c0/jZkXcMQ6tqDF/UdMzmuAgzIrJzmS43Qelb97Vief?=
 =?us-ascii?Q?6zvznYJwcxAr+qrKyYl2S5vowix4w+lIwwusVCBp6XwxX9R5kDvjNGOZhre1?=
 =?us-ascii?Q?drzZePrF4n+9Xy1ch2C9iuZNpA5xKU8jHZXS4lXG812LxaNmqG0X5zxsKsYv?=
 =?us-ascii?Q?fECU+VkkGBc1HAt1tKf/5rvQD2MTM3HDnYTwSwKsnReDfGmZeq7qd58KfA5+?=
 =?us-ascii?Q?NWV4jLsvBW2FCEqEZg1121enPYyauZZUgQWBZ5lx0I4AIx/sRYSyRbo32bFn?=
 =?us-ascii?Q?/Y8+ik+0ObW7VhSXJRKr7buTtMuGKGRSX5FW5vVrTHfgUaZHkXNH94gqeHJl?=
 =?us-ascii?Q?F9EebJyqxfIIjcahZ+/OasB0eLk2rInhnk6SUIGZ4/R1/cRJN6pziY2bf6x3?=
 =?us-ascii?Q?03lCSFUx3+1oaREkUq1EUDgsQe1St/UhN2VkTeZC+UKMA4AkglWJgzRSouCM?=
 =?us-ascii?Q?gMolFSXyybBoN9AguUGTL7/8jHhzuESWuAt6rXQL5/joQy4B0ZWkaB2NzFNL?=
 =?us-ascii?Q?egRdop0T0IDUkALSSXWWmgffwDnkBNc4VU63kIE5Yf/9Sh/S4sz3Twwc4Dri?=
 =?us-ascii?Q?TrX2b8B7VS5YpeeZ/HvBhkHIyWW5zRIJE+QIcHsb7JdlL8FkKXvTC+ticAcc?=
 =?us-ascii?Q?SdUrLDF1yqqGUlCvaitLKG52zMzz8iW3RpmIFoiQ+s7GdIzKQizVUFTSIeRX?=
 =?us-ascii?Q?f8yaTuNV1/QYNjN00BJwphKiu05aUwFTzbd8TJFbBAtkZrCK9Z3bjCUWXCcX?=
 =?us-ascii?Q?uhvKIRXozRC9vcSH0NJsM5rMG6ceHDfsO1DULTny2YJu11f0IxRY5TClw7nA?=
 =?us-ascii?Q?YTzXBfEAhIItzmi6jU5bQr7ko1ecRnGH5mIeR6NPr4Ndibct8lCBl0svvDqR?=
 =?us-ascii?Q?3fdaP9PdV2MH++pemmGkPmYhlW5iQ/LfUKOuE450oCSSJeP+wzF5PvEnPDy1?=
 =?us-ascii?Q?59KfMMIxXzBghIgsyhqlqJwiLNLLPCjKmMWj4doTWWff69U1QtEbTg61xqnj?=
 =?us-ascii?Q?EZHdeQ3Ir8Rx/yjAi1s+qNU9E/5j7Ho6Z2FyWTTHECQkCSIixGRp3NyD6M9I?=
 =?us-ascii?Q?dKd6q+4jAR+Kdfx7hQ0126Xx2YUX9ZrgYDzf5/jw7aEZKuhOVyCol2j5RNlE?=
 =?us-ascii?Q?bjOf5xFbTMyWmh/axz581ErXurmFuUYBVYLRRpDhLt0le9eHD4GWvMKJZjWc?=
 =?us-ascii?Q?rKnzrJDDkIB6f+nEieVru3h7OyL7EBXfYPROq2iF+iKhfcl3H3pOHBL/Fx7k?=
 =?us-ascii?Q?9n7X/vWCbwXy1RT45pHhcakSJ2vIYr9wPu04Bg6lsGkVmuvx0X0KsEnf0jdS?=
 =?us-ascii?Q?ZhUEhIewhHJyayvJwyZE8klP94ePr6K69RgGaB/AjxBCa+M1qBWFLMJm8dWK?=
 =?us-ascii?Q?dgdlw67Hwiacc32h3HK2TUBTIQmZOlv6jZmvNlALp4D4C74JVdsiWxRYQtkP?=
 =?us-ascii?Q?BkUlPil7DEPBwCcZ7vbarfTdO1JejxzBlxpsZe3ul12VmcGTNG4TTgZOuhq3?=
 =?us-ascii?Q?TcmjLntmzjvwNMKkaADX8Kk1ZYbkE7OvGVB9v/ZVl7G1XLVziffS9l31yuI8?=
 =?us-ascii?Q?laV8msdv7QaIKa+6CNbtiGVJCpQ7prit11k9x51I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5376fd-6ab5-4461-7a61-08dc4f3119af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 14:12:28.4265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWwE1yjqPQB85lA2LD1spltLIYCIySMgey3FYKhtd1oIa4mJ/xx0IJj7t83mX7cZe1pp59ovZ+duOfM1I3siuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4545
X-OriginatorOrg: intel.com

On Thu, Mar 28, 2024 at 11:14:42AM +0000, Huang, Kai wrote:
>> > 
>> > [...]
>> > 
>> > > > > +
>> > > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
>> > > > > +{
>> > > > > +	bool packages_allocated, targets_allocated;
>> > > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>> > > > > +	cpumask_var_t packages, targets;
>> > > > > +	u64 err;
>> > > > > +	int i;
>> > > > > +
>> > > > > +	if (!is_hkid_assigned(kvm_tdx))
>> > > > > +		return;
>> > > > > +
>> > > > > +	if (!is_td_created(kvm_tdx)) {
>> > > > > +		tdx_hkid_free(kvm_tdx);
>> > > > > +		return;
>> > > > > +	}
>> > > > 
>> > > > I lost tracking what does "td_created()" mean.
>> > > > 
>> > > > I guess it means: KeyID has been allocated to the TDX guest, but not yet
>> > > > programmed/configured.
>> > > > 
>> > > > Perhaps add a comment to remind the reviewer?
>> > > 
>> > > As Chao suggested, will introduce state machine for vm and vcpu.
>> > > 
>> > > https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/
>> > 
>> > Could you elaborate what will the state machine look like?
>> > 
>> > I need to understand it.
>> 
>> Not yet. Chao only propose to introduce state machine. Right now it's just an
>> idea.
>
>Then why state machine is better?  I guess we need some concrete example to tell
>which is better?

Something like the TD Life Cycle State Machine (Section 9.1 of TDX module spec[1])

[1]: https://cdrdv2.intel.com/v1/dl/getContent/733568

I don't have the code. But using a few boolean variables to track the state of
TD and VCPU looks bad and hard to maintain and extend. At least, the state machine
is well-documented.

