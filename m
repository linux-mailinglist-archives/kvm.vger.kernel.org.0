Return-Path: <kvm+bounces-34212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1679F8FD3
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 11:08:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4106A7A2C42
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 10:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85A71C5486;
	Fri, 20 Dec 2024 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RF1xPt/K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A91C463F;
	Fri, 20 Dec 2024 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734689225; cv=fail; b=hMMo3OANquU4qcIRc0WPn931P4lhZsFnLByF/kd9bsZZjp+YEGOq38cO3NfpO5mvFu/w4VB+nlveVHhdIum1UhWpV/z0h3gE7aTtzsizwIwx11+Hqf8GSHS1SNSsf2d02nO4Im6sBwHXj3gvigZZnBqGmc1/qZPRSdWzgejI6mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734689225; c=relaxed/simple;
	bh=akt3I8GrW5nVcAl0vOcCtRJCyEEV9ZInakHvKWbMnAU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dXxEMV83rV/0euG4Q2OPrL+mR8NygSH3aYeSHJvwm6w7ugkWPn7SkLFMNVzMEZPEVz2QSb+Wac4CGIwo6xLGb5var298V8+gvR+vAnxpYvT3Awe0aZXxulKHtni/WxNEBAro1k0bI9LMqO6w44MaMeWfk9kGP7b6TRchswX+OLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RF1xPt/K; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734689223; x=1766225223;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=akt3I8GrW5nVcAl0vOcCtRJCyEEV9ZInakHvKWbMnAU=;
  b=RF1xPt/KwRAe1gi4VW/ks2HHHD2ksTjg8eg96GnJsG+KA2Gn65J1CJHe
   TDwfB1tDkMH/7AjHCjkuJmQQwLZvtfJhHelTcexm3LEYyDHgDRYdh/YeM
   fCn7G+tKl6N6y1DrdkimHl2kh1poK/9eci6rCspxgjAX8nqwEiMRGc4xD
   yYE3kBi0XL6XhK8keB3LedzB10jZoXw9eXB3UwZu09dITYOXGUfvXYBCX
   5CKG5nMjOYHXnIjxWnCx16YiI8VzDwOFLhVll/uoPE3f7929a5GAFPmZ8
   YVxRaoFlmGpeGUsWo8capjwTWZSEi/8sSAz/vZeLdnXlynM5VSi9O/zoa
   A==;
X-CSE-ConnectionGUID: kfZ6evEHQLSYbUgYk6aeIg==
X-CSE-MsgGUID: 8qB0OC6dT3S6S8tkekJIGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="39017442"
X-IronPort-AV: E=Sophos;i="6.12,250,1728975600"; 
   d="scan'208";a="39017442"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 02:07:02 -0800
X-CSE-ConnectionGUID: JqWRDiYNQO25h/J1RwG6zQ==
X-CSE-MsgGUID: Zasr/cgMQuG00b+l9DTklg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103457930"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Dec 2024 02:07:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 20 Dec 2024 02:07:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 20 Dec 2024 02:07:02 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 20 Dec 2024 02:07:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=suhZQ4K+F3Tqo07r8bOc17MDvybJwx3O3XN6hCTKpGRTk55jJ/bg8XQ/TKZcJPa9vbIb6ofwr60WoRF1hHk0tczM3gJql8+rktVKwZpWSqbte3gziGYgSv7wA/FfYAZ8QlV3L/f8oKibxKFg9qeQScA+4rmCGt2ZR2lcaCjmdR7t6TyAaVOsqyWqcwwlK/99BYRIn3V8JFk1nbcBVlQZ6yUNvzhhEdeRuJN1vTVrvDTtOi/KFPUVNvkor/c3jA4Ooxe90yC6jRpNK4MKMB95ZnnR4tOT3X8vkI5QK8vtqR4b/5LoBoz8B4GyFY2ydFs4NTJUPXJq6k10Gv+fUkf9WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mclQDGzDkAusJl/espMVRC+PjL5bENDJyjBluNrmtVk=;
 b=HHuWy54NavrYvD3xRN3WLkJsCN/nEiYNqmtH8e8e0qrNul9qg8hd7DYVT00SbJ5JaJ/X3SVUEyyamOEB8mHzOdKRe+k3r4nywn/9SpRmEaGbdcbMlnJK+J7lg4xRID2dixymDOYy330U+1B3aR8u1tbr5rL5hX86ymbBgSuK7JFEv5DoRoGV0SWcbKwgZpf1QqC2JxwUntVFyfOniQEgzdZgRW42TcmG4fUzsKCS3BOQ3QWSiP6YmGFlemYN3H3088TliNiopx/Gxci87cn1PuBihIWvaw79Vppk3K5sCiG0jEdU2dR2/kctDp33FpYBGuvXBPAOMHYGaT8+wdqqlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6948.namprd11.prod.outlook.com (2603:10b6:806:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Fri, 20 Dec
 2024 10:06:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.005; Fri, 20 Dec 2024
 10:06:32 +0000
Date: Fri, 20 Dec 2024 17:32:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 00/18] TDX MMU prep series part 1
Message-ID: <Z2U5nR9/w7baSAKp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
 <2db0db045563378d224ac9af9c8211b8da15ec2b.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2db0db045563378d224ac9af9c8211b8da15ec2b.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0173.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: 32f5c53a-f32d-49be-edd5-08dd20ddfb06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AtQL88IxDzSr7MaQ51S+koNNxiWLAULCnnnnIBjnnBuLReEdKC0VtPCNW/fb?=
 =?us-ascii?Q?BmxvaZwflZv+QL+I/JrtzEwsHzeKiF+tgtTOGXLCMd/pBv517gy1JiAjywNw?=
 =?us-ascii?Q?b7tmqwKUYF96TFxxVMY1iCxhioJOIMWZE84TEXl9dDFZikPXyTn8mtNXVu77?=
 =?us-ascii?Q?lgZ3xMgHpCSuhHWEGsRbMuWj51qGAfVJ01mVedid5flHJp/JsoIFOoz13lNQ?=
 =?us-ascii?Q?H4lHQZwy1j0qMAtFzKfeFpSQd6Ei08hY82tPDFCBhFY1DIHuqS7Q5ccZDLDN?=
 =?us-ascii?Q?AgyKf/cjt1UCIraum1fF+WDcIuTYMNAhhc6bmipwLUkS6fblPX426ugZpsmb?=
 =?us-ascii?Q?wA+p4CW8F0Lqvd6gH1g/OWjGc2HmQsQJDxgDnr85+HS4jEsDgLhYhQmp/prG?=
 =?us-ascii?Q?3g9eBprwmmDrts2VH4xO2dkx/fGlkPx2/RftxwZs1wdM9+p5nZMUGwUQiuQf?=
 =?us-ascii?Q?6QfLzdakckpQLTr8Lzv7fFDN6UPEU8iTfo0EtVwZZ+K/nebO2sH1AiSW0ZKJ?=
 =?us-ascii?Q?Et5dp199FcV41zyWgfbUOfZBOhPFT/iaULcTNBqvLtSk/nsrKLxpum9llniI?=
 =?us-ascii?Q?KLalEbCfIZRxeNGKz5Gue8k2Mv3IlNgUWfA00XFw+mPt7Vuk3H+x2hf0vaer?=
 =?us-ascii?Q?7ufu6UggPfYZGmAG1nVCOaHFUln+jP1s4Xj5IAj1NIi8is0IbveiHHkHj3ID?=
 =?us-ascii?Q?b4hMvovnIhC2NrlQ8xLaQhRHpi9jNAtxmAZtReQWraYDfZum/qRPFsU9ftU7?=
 =?us-ascii?Q?rwaU8o+4ZeJvFpcVd7ghjxCB+Go4xYNZsihtzioxHVjpvxUwQpIQJq6xW06j?=
 =?us-ascii?Q?gBQ6v+WvlaJa46tv0hbz4D0ecihWVolyAJ0psOgrtQQ39gMF8xSkXVpvDcKA?=
 =?us-ascii?Q?0blngFSdxGlyp8Dbvqgel2SVDKzkfX8tcrop/Fv7QpsQOIDwpn6aLjBW0EHY?=
 =?us-ascii?Q?qK2OheoHx/86v9t6uJIpkXUJDD/Vr1rM200V0K6gBMNiOVvOA6vUGB7ioson?=
 =?us-ascii?Q?lDJDoT9b0GkSP9RX6bd6RGXIznIw7qnoNT+ItWMOyITXoxFw2VBF5MxOq/Kr?=
 =?us-ascii?Q?oc8d1FQxhPdYYWko6aG+LiPzzsvkMGOKrWc4glzA18mq4d97Gq8bo0HIQsGD?=
 =?us-ascii?Q?At+5+ubEhEXnipKKXr7i8FcfMSoHxNdwDqAqvxWVjaZWj0aOkcZt0BgvafUG?=
 =?us-ascii?Q?sc1RwQ8O7ipQIalyYnb9juLXwt3dsAO6SI0jkuZh0BFzCfkJNSkr+Hw9eGql?=
 =?us-ascii?Q?0WXZzQvcHISBwet8gEWqYTMHlHOk3jHY44F47EEj3xBLJ9oihxUyWCEH2KWx?=
 =?us-ascii?Q?krV6E5YlT9ZF2rnlltK2dpJJqmZ1CkvFJzrceBVMOsLCbA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xn/rsoXoCt56ieFQdTCLc7ypOjyx2p/LK4KHP4SChPivsU+CuGJq3efhAv0Q?=
 =?us-ascii?Q?ENgnH0XBadJYre/8fj6BW5l2Wq8otjsWUYar3CPbXzInqOk5CzGwIS/thK84?=
 =?us-ascii?Q?jC5NJcWlxZf7NVBFs7cmw0DesyR0Vusoc2K2YCpSlAhdIOuHto1+3xSvFXiU?=
 =?us-ascii?Q?6ZylGiBXXhkWWVGQZ7juwb8MZYUYDXHfVnI/QmC32+eSz+IlxybrFBls7GPQ?=
 =?us-ascii?Q?HJhSp5NOaAAESiDyQaRb5wRKhdtPB68AjRLBRKpBPU9aWvazMKdEEpZM0E7O?=
 =?us-ascii?Q?BP+fcfkhGIHfwfBgOPcvCvUStAzhWc8/lKjKQTJB7e1GwGr+WbF51ln45IYh?=
 =?us-ascii?Q?OqhfqjKvEjz0WExTROJttG7zcdNmPBYfkVeS+X5Pm+wX+8hZ+70yopsep1VS?=
 =?us-ascii?Q?b9anlo7A7LqUx5xE8RSN0op3E2nQZ1U0G1nz9w5P88VOWPUnA0PcrXpLZ42I?=
 =?us-ascii?Q?NqCdJknxXLXj2hy/1K7zQOBUftsFP12oGQK/YUJS4JeAJadyDArTCcWWGRFZ?=
 =?us-ascii?Q?gJKQKihFzU9c3+6fvB1E1wH42h60ChrNrKYrIld2TequQi7R7RFk/+m0gTkM?=
 =?us-ascii?Q?A4605az8lC5MFJcyyJHIajpRO+02l0dzT+Vgn/vQwxjuNLxv6w/7SlbQAryC?=
 =?us-ascii?Q?vnlp/RGyCuiGiv0XqI7XScAG3ahloZE5D9N4pt8UF2tySHlJ0OACUTgOcXCd?=
 =?us-ascii?Q?UQU6vvtP27kS/jTir5OZLNRCor5PymBqjNZAn/t8o6ytxZHstOZvjjb1yFya?=
 =?us-ascii?Q?OZCr2y8Tw7h0gG7B0ugjzd9+KAL4VbFv7pUYTmYqNf+Ywq80cg6hJNIQoo8K?=
 =?us-ascii?Q?e8cVxibEpdqX7Xl6OJbWJBIn/ZY5uQeYX7PJNPkbJc2b+jkkk06q4VeQLcVB?=
 =?us-ascii?Q?1U5qa6PefK1/nOtIBqh/Gsys07OJRGP2z3eNltzQUElJHVZVb9iTEw/3n/8H?=
 =?us-ascii?Q?e3gzMY9oOGok9xhSQlZvQwJ+HaZNKN9+IfpoUi63Vy/VgsHfQwQ/ug8aMZxg?=
 =?us-ascii?Q?9EqfDl5vEcxH6xLWLs9QeUlxPnGiDsbw5EbsYaPDeYqHPXdJvfuKEtcD5kc6?=
 =?us-ascii?Q?8hxq3EnhAUVxkuWK5t4pfzfmGbVcfFpw7Ykqz+bSW6jGY2EQZtlfZRQW9ZN/?=
 =?us-ascii?Q?ybRjIQUD/jDIOZp5YoVYpm7GzUKWJyV4LjCPu/qxlYNg6CsTExU9LIYgFHbs?=
 =?us-ascii?Q?l3AUWN/dVWKBhBm7G6TLBj3Ad0CRoyAjhPT0hIA6Q6YBfpjH6dNKSFX8oUbO?=
 =?us-ascii?Q?bb1TiAL+cUpYjRv4m43SCUFJrJPrfhNfa4jGcdZlbNaSuYJsN0AG9Pmpbnrq?=
 =?us-ascii?Q?OhYALB0XvvV9rip9ClLbVAWTm5XT/JJBt6N5Dvofskgt27sqb6HPmEh9c7v/?=
 =?us-ascii?Q?dAXy4f7ihrguhBAbdswuSLk0x5pRE6a2WA/PvwXnnqUPcr8M7iwa0uHuk0tW?=
 =?us-ascii?Q?scaiKcTE+pcskgTVBnma7soHbULAaZtqjDa5O2lzVAat7ac4mAyOF0Z6bcwb?=
 =?us-ascii?Q?0D7GNcT2xbZ28jIy3tjthfCds3U7epwUGSJcmLRlsMztpjhf4+DEQy8TOFCB?=
 =?us-ascii?Q?RjVzILB2uG/cReXBxv2R/99Y0Pfu+5XfVtE98sja?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f5c53a-f32d-49be-edd5-08dd20ddfb06
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2024 10:06:32.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmbc+Au66G2MFbkd8kdD34zaofgXjiKJEJylLUEHi85uwpz/5NO4e367i2hH3BEOKAQEAHuy8MlZGC8YPBxjog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6948
X-OriginatorOrg: intel.com

On Wed, Dec 18, 2024 at 08:34:41AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2024-12-13 at 14:56 -0500, Paolo Bonzini wrote:
> > Hi,
> > 
> > this is the essentially final version of the TDX MMU prep series, focusing
Except the nits, other patches look good to me.

> > on supporting TDX's separation of EPT into a direct part (for shared pages)
> > and a part that is managed by the TDX module and cached (into a "mirror"
> > EPT) by KVM.
> > 
> > The changes from v4 (https://patchew.org/linux/20240718211230.1492011-1-rick.p.edgecombe@intel.com/)
> > are minor:
> 
> Do we want to include these?
> https://lore.kernel.org/kvm/20241115084600.12174-1-yan.y.zhao@intel.com/
This is to have kvm_zap_gfn_range() only zap direct roots, a counterpart of the
kvm_tdp_mmu_unmap_gfn_range() in patch 13.

> https://lore.kernel.org/kvm/20241104084137.29855-1-yan.y.zhao@intel.com/
This is the RCU related fixes to MMU part 1.

> 
> They still apply cleanly.

