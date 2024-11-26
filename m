Return-Path: <kvm+bounces-32517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD789D9590
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0F9F282396
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E3E1C5799;
	Tue, 26 Nov 2024 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HwE1RTMr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A11865E3;
	Tue, 26 Nov 2024 10:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616902; cv=fail; b=PGwhvQ67zoRblLrVq/vfGeKMzD17tL5SkchMhpcBgYq+b1GNnZmo2LplnAjM4IfLOJprSYKVpb1quHndbTHFROFeu3RL0dhvbybQFlcRvIuphPknrr3cruZyjJZghuRDa09PbvcmSb4EF39TC9CE9OcqUc3kBkED/I9QTgpHuNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616902; c=relaxed/simple;
	bh=9MOIhncNbXPS25usC42skBK1C2YxM4ENn6BIn22I7R8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FqEzA3fQBlqCMWPx64pDBzTWokBuvI+atceq++aDRrEsHP4L5xzoI8FQabtuhZl9WNFhJNCzOAG0o7SmDSCYzGsiAiVLFRb1zp5xYP6D0D/S2iOPn3y5frI7sobjqkEgEnNCZwa/Ug1J+i74509k8BvjbYmIcBcSL1stgGJ3p7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HwE1RTMr; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616901; x=1764152901;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9MOIhncNbXPS25usC42skBK1C2YxM4ENn6BIn22I7R8=;
  b=HwE1RTMrJOzgmDdkTrQutla3RWwoV8TuD8JPeVIsF6lEwGsYOLeMnNQY
   YdqEWJOz7qeFX+xYEMYrL8wAsIzLpHe8kBKRNaWD1z/jjyAEAKHMZb2AW
   XKJsx303HW9bd8nXL9NHq3lPCwGFAryLlrnQWgfAlg1eqSsZM4G+p4WaH
   gycslY5Nnghd7bka9ZS69CRnobajnDvW1Y5tlmqJA3fFf97PCPbaFdg7A
   IHu4p9rIzsXCoUt+A4e9w5Pq9mAuzY6IWLKziiByvZgfaPVdm2h7qDcg3
   94ooIWKYjrSD0WeZz+HhyPQSTQwc0G8igX68R1X8mJLLHpM8ofWI/x5BS
   w==;
X-CSE-ConnectionGUID: MjMmghB/QziuTtpFOpbR1w==
X-CSE-MsgGUID: UlqnECEVRQSZksPGpmIioQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="50175696"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="50175696"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:28:21 -0800
X-CSE-ConnectionGUID: goC+EYPLQd+J8rc8iATSxw==
X-CSE-MsgGUID: nfLVjBGAQRivrSzXWJ35aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="96337155"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 02:28:19 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 02:28:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 02:28:19 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 02:28:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Shgzi04j/CsbccZbBMuxiSgboN9c/odk640bzUMaSoZBCoZa5sJcnQpCZzHnk9gKvwjkhYHSW+m/q4p9ItoT9o45Db3ti3XAbJvnsvDZhEtoBUJNajR0uSun5FUVXf9H/BhZNz6tXEjiwr05jwa8IsclhW9wxvVshJ98+hDaZ04bftmA3t2kw/mhwTaelR1P1pDfk1WadJ2rAa5NaxoLwzerrFDrsCc5gXXrZq9D4MhwgjIg7xw9u6t+8iYxrFwA5So1/N8kcQ/kS3tSH2qTQp7s0WY/xyNOPdWPruJmUEYgNGTNYMXrPLI6Mbi1sOaBZqIlt3nNDCL3vwB7OKvCvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MOIhncNbXPS25usC42skBK1C2YxM4ENn6BIn22I7R8=;
 b=KPm5XIK1xBvBh7vaXIJVGLIW7S+661zXIHUf5LWDVMI8DMh6/+Za7pyV8k7L2hqqiu3MpLrHvuTsxYL7UlipC4bVI8Ja0G6DyJQiofC6DG5HzYjDzOfnU3M1GhAaTy0wOxlAA/0waaj3jzsPYYu3RS4qfR78o8DXXKaKnbXRWaarrhGyVukH/i7+Und3V2MJA1m9w0HDvlZoQGjW/LHauz7mLgKhPupfdZt2w0+dcgUwdyBtIcbu7utQjabkGG2SE+UiK760hJ1vaKIvjpFXupTlAjpPLi2XMQPVXbXqpFgXbuZUsdGbh4TjVzWHpbmDBo+zRlPm6mxubeh/SmINhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5009.namprd11.prod.outlook.com (2603:10b6:303:9e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Tue, 26 Nov
 2024 10:28:17 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 10:28:17 +0000
Date: Tue, 26 Nov 2024 18:28:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 0/6] Introduce CET supervisor state support
Message-ID: <Z0WitW5iFdu6L5IV@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241126101710.62492-1-chao.gao@intel.com>
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5009:EE_
X-MS-Office365-Filtering-Correlation-Id: 16778ca8-ff38-43db-90fd-08dd0e050a60
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C9D5lUsEc+5BWhl0uju3laBc9Pkg2hWGnHA1fk8o+eeRofYwXbLC8g6jZLJb?=
 =?us-ascii?Q?R//1cD2tuItd7wMwsTsz2DnYhKjZwyZ0wfZ/V3lc25j1i1Uw3WPEg+kq46BS?=
 =?us-ascii?Q?my7oH5xAX66FEUlT3+Sli+Tf8oS7H5x66V8oZH17rBVdEqMiBVzLCFdXRi0I?=
 =?us-ascii?Q?iHK9IjMP8mf6cDsRCSgpzZebtFaP5Z8Bub2bFHRFWVyU67xBrKizozp/7LXE?=
 =?us-ascii?Q?g1em3cd1w7D0m/8W8DCQ371d/ai96lIknxdV04ME2MOjGrItb6yTllj/iXt5?=
 =?us-ascii?Q?q73sptVJjRvVHwzvdhQDQH8uK6NcUIBS3vZqclWgAAqlaLujMsJwB9nyAREW?=
 =?us-ascii?Q?RSceUyaJFiNZoKzz0iaj/w4J/CC2gS2HBYDbQ8audrEJPTPSyD76YRLAf3Q9?=
 =?us-ascii?Q?LX9jW5LTnpjwepZaEw1v+DNUdF9AgjceI0tQkLRHKytNEDKtJDgczOMzuJ+d?=
 =?us-ascii?Q?f3gS9qMKDtqpCYi06hPmh9t7iSBkqpRYMnj2WHaa+cRuTgtnHrtmgoAHHvbx?=
 =?us-ascii?Q?HX8VCBdxSFUvF67HEI0kbeoClMRJWbuPA50SH4v0Ps6D9yN5bKKCexf9Wax7?=
 =?us-ascii?Q?uYtErp4DGIuWPSwca0WHyAoki1zkitd0AmW/aDfC3T6ZqD0rwwDjAz9mT48l?=
 =?us-ascii?Q?xsGd+ke49teG5C+iB5mjkYT0p38GYkF7eKh2dZOOMcvZ5KSgxhLslDGICSnw?=
 =?us-ascii?Q?6uUJxGA7sNqzDhwAxdRXzrH5bUPMrsZAllAwzlvFryAsKmedN0if8sC2aAtD?=
 =?us-ascii?Q?5/xwskX27E4f9mgC4FPkzS51iAOrRoEZ/Y0at8gdBP48SjOM72nciWJU+Cnn?=
 =?us-ascii?Q?+PC8sb77d5J/aK41DEWkNKs+DQH+/hc9W3NMU/1hw9juFxHW1OItI6gSWvvW?=
 =?us-ascii?Q?VBXwzAZFlxp/N9PNOrHCUzziKVMhH7K4AP9/umPe207CSbsMjUt6zFB4Z1V8?=
 =?us-ascii?Q?Kk5U5d61SC6fBeHnqeLczacFx1LtKhzfDYqQgxHRao9yuT2WCzhcYjtUqlQf?=
 =?us-ascii?Q?0f/zMU6WtClqHLBevqbArftBlz6yoSeO+B1mJv661XpmgVIB+sljofOORlYn?=
 =?us-ascii?Q?NqJ5QmpCupNPp2grpdllUlYBToDEfSbSPsla60QjrI53HKg49CHm7fcyClkd?=
 =?us-ascii?Q?lsC+3yHPMh2y5yT6Vh1upoQaN+sq/A+J46FcWMOx9O880xGoUiDpvNBIBy6r?=
 =?us-ascii?Q?rjdIy1MrKN0FzWV8Gtlc9/Zpk8L5IPqYUNju0R2+iQ/FBR2MJxdiX/fyqCRe?=
 =?us-ascii?Q?BWxQ8XZVcnOsKwJ2nLPGt8d11HftxFeKmLrgtCbcrulOHfLOZpw09NRYrZ51?=
 =?us-ascii?Q?APFah9g1GptJmP86gx7nmnFUBG1UjjKk5O66sn3GJ+urSQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wNC+6BiUywFpNt79b+uX0p6ZGOHopcZLkBE+Zv/EyVta67XSzZNlGCsv+MSl?=
 =?us-ascii?Q?4uR1pf9xjPl4YVPYcV+HhxlA2i8Qh4CUEP4KzEhEoVZ+sBteiK6p1LqfqFqm?=
 =?us-ascii?Q?XFJTdeVsQBp3b9N9PqZQuMHjcPY6bpbhmdpbHPUJusir/LS5TIpFGHoA7X4V?=
 =?us-ascii?Q?/Oxha1CP3W8tiw2rmgn5jW+5PPKRKBv/y8PNiJchwJ4D3FqoBsPLnN+GjFER?=
 =?us-ascii?Q?Wv8+Dy0GE8HltNKjKTHAWKBMTv+CAV536FKvnWnQZMPVC+YwoM8Bnm8pYcxb?=
 =?us-ascii?Q?g9GO8/zkzjpQ8+ywnnPiXo84ze94JpgG6eLTIaKzMxlo1fCAlf6ac3aHlMrM?=
 =?us-ascii?Q?beKBbuswI/midOLlksk4KVjAlB+PAKuq5ESl+ypdpRNwvu/CF0biympsCnYf?=
 =?us-ascii?Q?9pg1jP9p6UUP/vUqmfAII7c5XbJj/XPjpqVXvVf0d8dJS7WtiY3mb4dHsO74?=
 =?us-ascii?Q?K3BCzIYYggtgrLGLu3R4PuwhsbYCxyX6J+PhrUicKG6lEpe2XW3yyJ1mGSWn?=
 =?us-ascii?Q?PyqkXLUBluIxPCSUH+OF2cwBCetzPzybB48CQEqxcxDr0W4eLq4vs7Z/o89B?=
 =?us-ascii?Q?3Vw2CHDAlFj+c2B/v7yO0tu8ezrIP8sf/LGDxGjv6Ukt113WOlKJwFlqM1Vo?=
 =?us-ascii?Q?ia0zIDs8G6sU2QvlZMuyUhVr4jLOxGpgDNy4sCFiuAktiFAX97sg+mcuXYzE?=
 =?us-ascii?Q?PZifkK/k/LSTUYuzSZ2cp5hfeXhdo42mVZlFIEKw3PFK+MKHJ8lZk5c8s+TF?=
 =?us-ascii?Q?IBuy9i5S6h/NnajKngb+LwOINRsTnsTjdXhN1wU7Wp5GND+YXOrsUzZpgpkG?=
 =?us-ascii?Q?as7Oh+1DDXd9cYcTa/wgYyKewEQJ+3EOznkK4pz/D3wmiEDL111v7DBGy0uk?=
 =?us-ascii?Q?nZoQGFxS5Ksa+c95IosdpCxqLmpVsCB9z1eml35afilbhdaHVFiTJJeWj/sJ?=
 =?us-ascii?Q?XlkjuiPm1w6i/8ZGuPVo9E4MEU8KiY8pP+EtpX4Fiuy0/ByU2GRPUN4dxv9W?=
 =?us-ascii?Q?xu88X7vT//lqvTQEEqMPsd+Uu02LsrGmn29ROQLKrYXwd26WiVRQkJRxiWAG?=
 =?us-ascii?Q?LGHxHV9d+FdjLq+p8rc/vVYxcBcZZeH2wEMBI01sjOtnflE1nYjG/jgA8dqQ?=
 =?us-ascii?Q?S2mTCxle24pM9UnDACVxjAO8oPqx9llKZ5yXyfsaueRVaiNYHehYcivVdDhD?=
 =?us-ascii?Q?J8AsZ3OTdHfQMTnRwkfT2ATKYzdguDTjeIp77Lu6SepGI1ilgUrzFiPbKq+X?=
 =?us-ascii?Q?h4vd92IWrZZN/xBrqvw6fR2k67qD9asSD/OqNCb36iC+32uTqclcKhAYlE+f?=
 =?us-ascii?Q?WlhyqeCs399pUkD5QPEpbqn2mJPix26hrFNNUxi+8pm9umzSge/uVVHXgkc+?=
 =?us-ascii?Q?wWLR4fJ8XUh1q+7lS/ifiuI5K+vV4p9NeqhXFFHAzFqWFKbI6sORcISBNIYU?=
 =?us-ascii?Q?RyK54gTmMZ2Lz7Zin6Z1wqRoBqYhBx4Kk71WGNuQJtILtY1+lhkzn0F24nx3?=
 =?us-ascii?Q?R7L/Jf4w+HX+CwJFUS5PHTZ9MtIzMsTEMqglVApk5PuNU+oDCETUKuSxQ7LM?=
 =?us-ascii?Q?p6ZYlGymCFl9tqUeDuLRSsuiOmoQkOE5DCYsnOjp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16778ca8-ff38-43db-90fd-08dd0e050a60
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 10:28:16.9908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WK3agvFuzQm5oKQQ/KPhiYsGrQp17VhkPkyazAath7MwfyR4wzevf/hUvqli+McslYI/ctmZxnf+pvJ/KcxFrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5009
X-OriginatorOrg: intel.com

On Tue, Nov 26, 2024 at 06:17:04PM +0800, Chao Gao wrote:
>This v2 is essentially a resend of the v1 series. I took over this work
>from Weijiang, so I added my Signed-off-by and incremented the version
>number. This repost is to seek more feedback on this work, which is a
>dependency for CET KVM support. In turn, CET KVM support is a dependency
>for both FRED KVM support and CET AMD support.

This series is primarily for the CET KVM series. Merging it through the tip
tree means this code will not have an actual user until the CET KVM series
is merged. A good proposal from Rick is that x86 maintainers can ack this
series, and then it can be picked up by the KVM maintainers along with the
CET KVM series. Dave, Paolo and Sean, are you okay with this approach?

