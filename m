Return-Path: <kvm+bounces-61145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 974B1C0CA65
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 10:28:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 03C2834C0EB
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 09:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FAC2F12B6;
	Mon, 27 Oct 2025 09:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GIXdlItU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD872E5418;
	Mon, 27 Oct 2025 09:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761557309; cv=fail; b=e9AYIvfQ2B3Vv5YZOwevXE1h8S+J4JpMbzt0hmRUwhLLq68yU9HHJPI+wEDkO2S12lYvoltvTQ+a7mk+WORdcQESnQknbvJurHQpPmGW8s4oucPHzV4+JKmd0wyST2t74Y5/wpDa9kxl8hJiMZA7bkNbBnzr1x5nF1+5t+RaY90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761557309; c=relaxed/simple;
	bh=DEUF6WAg77zuPjvlQ73axiOdcVSSkMRAGxbd7of9zIc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SH8COUj7irliwi/BGZ4/q/4NHTbXh+AkofXag/c84JLiZdBLFxtZDY52RpL3zduoeel93wnZD+zxa4/164prmXWCCIho4gsQlyuI2KGcuNdsa8X1s/pHpri7n9KOPwjwMtZsVWcS+c48OVO7Mea2LWLehtLdBYft+HlvcYaZ2gQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GIXdlItU; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761557308; x=1793093308;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DEUF6WAg77zuPjvlQ73axiOdcVSSkMRAGxbd7of9zIc=;
  b=GIXdlItUgThIaRhjkRNJkdni7l+a6xbxQJN+dgOdBmp0JemrPnMk/wMe
   YAJuB8K3c89eskKVYfPGb7q5IM0/4XniByBtVY+Ir0FWYmfn4BuLiIumk
   3nvPPbJt2aNkrzPi1Lcxf0/H9yqT54nqZGX/vcYdx5xgdT471+fnioAZ1
   p1Qu0B6xKvzdketZsXFUMobHXNif3herjml8vsyQg2q84po74zdckknzP
   s2lbLHLt8KCOgdDLvmqEgxqyJUuYcg0kI4BkuwCp/wVCqIKL+JSLG6OxW
   1dR+AC7i0cXLED6kpj8UngTFuvPoHl5rWk9HI9PwrtxKHzI9aI2CqCYLf
   g==;
X-CSE-ConnectionGUID: rG2Y+RTNRPqBl1izPYIRrw==
X-CSE-MsgGUID: 22pxqCVNRw+WddZBjMXW3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67466545"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67466545"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:28:27 -0700
X-CSE-ConnectionGUID: xizAC1e5TYuVvhOzUF6o3A==
X-CSE-MsgGUID: j3afkVfBRNqK2W9rLjca8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184898482"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:28:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 02:28:27 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 02:28:27 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.26)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 02:28:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUIDdMyDUVlzcls0x0VOqZMIOPhmpSQjN4jKzHOASggTHiPE7z+bJRxNGVtCxpQfoX9r2pekVBW8pUE8P+ao0VTOzC9g26Vu9IkvQS2G0aZHOHV8rAUwQpbKWjGDuX0s0xi+qnMQ6zA0bwM5a0Yz3O6PLxBuZ4cVc8VZv1x72NT/3xvFmcHmDX1aqIwUp+IVGA2SqrLtV6utvtQRwPtYz2TVbwHgRJoeqcyUVfOVUWhEDeNxzPpM+zdCwNefN9ogAnwgmaSfr2F5W1f1A8H6qtk+D3tDvkA4IbhreUi6XRacmSwdkEAtrXirXqCINEOUh3st3sELSgIt7jbULZV9DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5OQr+MFzlMGc6I9Y782X9OVD2TBTVEwb8PmsNrrg0s=;
 b=D357bLmB9LizJ4woVAn+yI2VemeAmqOfav0nimSRynOerFxLCY4lnDd9PveAr6Ja08FwxLD9sKBZVm/WakuPMWEIZEBNPW25wNwlyenzT73zkHBsu8gVu1yTCl8F7BycW9tiSABHppbtGMk0ligKbhWaqbfB7ugsTa5Otr6YcFiEehqm3jt4MmZRiTkMtY7YEdN810BW9X6Hh21Ih/yYoOL10GYcOGWmnydRq7BfX8PEM21QI0AFNFO1pZZ7DEeYVg7Og+XEJTCcpk8bLHH96wwdlPaD65hpEj4O0vL3FE6L5Ptm0bzkLbJlFYySeJJ7VeH2KoBKnL8IHdmi2777nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7459.namprd11.prod.outlook.com (2603:10b6:8:144::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.18; Mon, 27 Oct 2025 09:28:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 09:28:23 +0000
Date: Mon, 27 Oct 2025 17:26:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A.
 Shutemov" <kas@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ackerley Tng <ackerleytng@google.com>, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Message-ID: <aP86sdBZxXm5I17f@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
 <20251017003244.186495-25-seanjc@google.com>
 <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com>
 <aPuv8F8iDp3SLb9q@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aPuv8F8iDp3SLb9q@google.com>
X-ClientProxiedBy: KUZPR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:d10:32::15) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea2a0aa-f334-42b5-f2e5-08de153b2bbb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jf2TD4vgrkud3/LPADiR80oelqkc+cRMBmRsd2TRNcwaKNYcW00L6IRaRmAd?=
 =?us-ascii?Q?6h+W9kBssAC/9ct3fje7b2YFAwcMrtChT/YhkcphkJhABFxyyXLvLvVj+f+4?=
 =?us-ascii?Q?by3p/GyliYnC5mLLfSU2LjriNJoDuwIY3w+v/HgPS6svYzvBVAnj/qs65pNL?=
 =?us-ascii?Q?jN0ipVwTcqfSOt8uVF23i+SseVN0TAV86kinFmxteAsgPY1/jzLjOvvgd0Cn?=
 =?us-ascii?Q?+ikMPN5jNIt6vwKFN/LfMObrgxAy7JbRplDXYwKgFTYW9Jg6AZL25fQoMt/O?=
 =?us-ascii?Q?ZYwZhrX87qk9dnj2lO98soD0FeOhMSOQYv/YhTcKRSPSiqYv73sQMBkTRRV9?=
 =?us-ascii?Q?NldP8kdBSl/9z6Allv83rBQILIIcosnT7+JLuPj0w9BGw/ySvCtD+z1WPURG?=
 =?us-ascii?Q?PV8iQADsGyHs3bKUI3K9KbxXI8uA7xxsQ4WLW/Bz42ahD5s6RsmcncGST8oZ?=
 =?us-ascii?Q?qiioxTKnq2yNTYsugOnikYTCqW2G58WP42yhncoxog7O/nmvCXmCIHuC8L2V?=
 =?us-ascii?Q?0vhIHakEykz1A7xApP+J9oJ8KOaYZII23vjdRgXtwEggrfEtKS3M2hj5WJDz?=
 =?us-ascii?Q?7k2uXIoWexTzZa2U6YsG4clVAIvw+6azQC1rFkHiGBR9BQuUIXrpqjyGyzme?=
 =?us-ascii?Q?zvmBfVRAlez+fSyZRk9iUi+RkcwnITA/8sa50THzVR/f80BVRlLkJKaM0MQl?=
 =?us-ascii?Q?lb3rPrzVM13Sc700sagbnmDuEDonpK6a+2x6CxMMPfFYEM8PjEAuca+UtQX2?=
 =?us-ascii?Q?U5KFcQ59QaTJoDMxmKZpwypFow2+Qh2W/0dMBtzR8omdVzBKviptM62OWjp9?=
 =?us-ascii?Q?yKJEtcouk8r9Te7dvgz8ECHpPbP2RfOyw69P/kedaGd3PW0Ijkhhf/FYPFjM?=
 =?us-ascii?Q?Ig3TmCaX8QqoU0k+FYfCKTtgZdpzcCjhggRMo2AlLnI2ip9yfKhLpkNSwoxC?=
 =?us-ascii?Q?lmPtAFVNp7X01xR8QMJ64Hv+uUTOwnfxRwkEJEWghRTXBnFHSbLh7BugbcrG?=
 =?us-ascii?Q?X6BcUwXfQ9Am7814utc3+InyzzuKw2NU+9wE0eYdyk04HUwpEu0OLu/sacZo?=
 =?us-ascii?Q?qWzsToj9+7QEYMV4bJdL0b/jcS6MhO5fUDTrzeV/wZyO3SDY3zdhIIMeQlq0?=
 =?us-ascii?Q?9FRUu7bwZN+Dn+uxvYWc7s8bSrpDEkBqb6qZwv/6XBe1Qtkj0XIJi2RCRzim?=
 =?us-ascii?Q?Z0KwkF7NwOjpFYOqjaYSoBHLJtAPWAnDub5PD7ceWTYKDbyNbkUOaOf4Jq0L?=
 =?us-ascii?Q?dWmS3st2jjCI9SK42MYQto53Ypdszeuxwpjc3YPX2mB7hrXQ/7eF6IemyvHf?=
 =?us-ascii?Q?WNwgdFIrF+BPl4lsWnN0+4kiyIO9D+kczGeApMHbkNnh8xeIQlKYVOwQ9NrF?=
 =?us-ascii?Q?WgxIqXI0sG4gKd7Q3cEPGFyZeg9v3WsW1V2b1DwuVV5qAtMxBqyLj4f51noK?=
 =?us-ascii?Q?dkPiJJlRMEnDRlg2Wpt3qXFX2z81q0HWJrVql9WTsOIjK3/Ephuc6w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rsa7QifGsaLFajjtYnrPCBrIxY7iTdozE4brShSobXnEy90UkIcwflCr7IY4?=
 =?us-ascii?Q?03vGQszLgJIqO575tVMDCVtIRGlnLwyhu6MIVIsE4vl6Hak19sBMRjMokVl7?=
 =?us-ascii?Q?0gYKGqMLwNzDRbSafJxmlK6hEnoU54YJgoHl0SHPCY5IfDQ75ND5jFlHM2yS?=
 =?us-ascii?Q?T1wN5JxlC8ChfCgC6SYE5luMn9CsDTt6g82XtYIVpgklKqqM3Z5DeCkRIa5B?=
 =?us-ascii?Q?jd3LUCopAGt7cw8wT5oHfJnASlAxHugtboFTNVXmOvOjRsJJ+7Cq4xYIUyEp?=
 =?us-ascii?Q?sAvUYjEFTq28ZnunKfiWpI1U9duWgT0BIw+g+WmFI1gsphtIeIu93U5FWqP2?=
 =?us-ascii?Q?h+XdwfMI/y+Nq3PdA9FgwAeEs6qTvYcLh1WXE7nsPw5hP/W7jvpjHLCecYqO?=
 =?us-ascii?Q?wwwLdgW0NYXqC2sCvYIDEOSiKyV6kur68XtmDuSu1kHzmFNeJzT+EQ/u6ags?=
 =?us-ascii?Q?tWDY+opeOCxIeINOpW5sDho1ql+kYDK7Kt0LxxWdo3E/oStobTSj3KgnQDaE?=
 =?us-ascii?Q?S7s0b6yJi7gmigwXbIgxCZp9YqbSs9sIG1fWiuLyNAlRr8TZswI2kr5MyUTL?=
 =?us-ascii?Q?/t4zO9GuqNyP0tWYjPBsgCtxw51jdeLALwyIqzh07uT3rZKh3kNODnNEtVuz?=
 =?us-ascii?Q?oepUYq/Cnv8neNZFOUCaHWAEqeC86QU6iTPSf2Dtj79b2yKt3enTblkDBIrP?=
 =?us-ascii?Q?y8CfoSXsjmMah5/+kgEegbGT75HkU3orUbAG1ZchsTEIOmrIdha9wn+8IpSc?=
 =?us-ascii?Q?qHuU7L5BqijWx0raitDKkItgZHGG+ot2Tu0rYhelbkUY/z8QYP1b3Y6CChb6?=
 =?us-ascii?Q?pxLwIWleyEZjLlen3nRPwvSmXW4SzuPHV8Jh+QVRyFAh1b+S/cGRb0fJY8jF?=
 =?us-ascii?Q?YS5Wal0vItbtGDkHaKN078/NngYYLnNpDTBgK1mGQ0Ew9K8mqXqR7HLANCjz?=
 =?us-ascii?Q?/0whyDr0LJIw2DkyI5vH1ml+0lpljR7vEgYbzvCnjZ2XWUd6XEcTQJpz0bFe?=
 =?us-ascii?Q?FZMwXo+3fEb+g8/KRU+24h0Ps2y5VeIzXwQfQpGegFzTrGJUg0IL8tDuXMzO?=
 =?us-ascii?Q?jYntYQUzmWmka8lwOFXyn95xK9q3A5DRTvBvJPTXFWezZ4zgQQKvbqAmXfTe?=
 =?us-ascii?Q?vAw+CtcGbF1hQAcM3e+tGtLRRc7Ia19BYXt2eRNox92AmJgi0zArGy4U+EL2?=
 =?us-ascii?Q?1kx+V1ksf0IM+GmoCCb7mwMoYI21df0kroTsb1YCVSfxF9YzzOunjw/HSWDh?=
 =?us-ascii?Q?IIhBxeEtWXUiUWDsk5wROe1Wy88X0HLJWx3IKBc023nwhep9EGj3K02KUi7g?=
 =?us-ascii?Q?QFOXaVtrP1coSRhkVR4l9anBks+/qD8MQsoyLEDVp4EIP61PkL572AQtirI8?=
 =?us-ascii?Q?bCfCfR5DacEjMj+vUqIVRooUu9lum2p+nWyF2IPSg15uRuRBVRr/Yi3eE9gp?=
 =?us-ascii?Q?oCzidz59173a6DpQS5pQvBHVz8K5j5ogES84IH5iIfaClu56czXXmRsljjKB?=
 =?us-ascii?Q?wy2OyzvHhHxrZL5GcjQlHTkmLx+2ubrZuxzf77roUXo4DSYUxosfFBmNfBng?=
 =?us-ascii?Q?2WrccTiNJkNAB9Xw3lPBkV0wlzTA6tRQNFYFaRkJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea2a0aa-f334-42b5-f2e5-08de153b2bbb
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 09:28:23.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hj30LUqvHef2dGBQX4wm72dt3peybIJGOYOYiMhoRemUBW40W5YFAUuW6WN2VYuSbEd2b7tDiMcJ8bfgPNXP6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7459
X-OriginatorOrg: intel.com

On Fri, Oct 24, 2025 at 09:57:20AM -0700, Sean Christopherson wrote:
> On Fri, Oct 24, 2025, Yan Zhao wrote:
> > On Thu, Oct 16, 2025 at 05:32:42PM -0700, Sean Christopherson wrote:
> > We may have missed a zap in the guest_memfd punch hole path:
> > 
> > The SEAMCALLs tdh_mem_range_block(), tdh_mem_track() tdh_mem_page_remove()
> > in the guest_memfd punch hole path are only protected by the filemap invaliate
> > lock and mmu_lock, so they could contend with v1 version of tdh_vp_init().
> >
> > (I'm writing a selftest to verify this, haven't been able to reproduce
> > tdh_vp_init(v1) returning BUSY yet. However, this race condition should be
> > theoretically possible.)
> > 
> > Resources              SHARED  users              EXCLUSIVE users
> > ------------------------------------------------------------------------
> > (1) TDR                tdh_mng_rdwr               tdh_mng_create
> >                        tdh_vp_create              tdh_mng_add_cx
> >                        tdh_vp_addcx               tdh_mng_init
> >                        tdh_vp_init(v0)            tdh_mng_vpflushdone
> >                        tdh_vp_enter               tdh_mng_key_config
> >                        tdh_vp_flush               tdh_mng_key_freeid
> >                        tdh_vp_rd_wr               tdh_mr_extend
> >                        tdh_mem_sept_add           tdh_mr_finalize
> >                        tdh_mem_sept_remove        tdh_vp_init(v1)
> >                        tdh_mem_page_aug           tdh_mem_page_add
> >                        tdh_mem_page_remove
> >                        tdh_mem_range_block
> >                        tdh_mem_track
> >                        tdh_mem_range_unblock
> >                        tdh_phymem_page_reclaim
> > 
> > Do you think we can acquire the mmu_lock for cmd KVM_TDX_INIT_VCPU?
> 
> Ugh, I'd rather not?  Refresh me, what's the story with "v1"?  Are we now on v2?
No... We are now on v1.
As in [1], I found that TDX module changed SEAMCALL TDH_VP_INIT behavior to
require exclusive lock on resource TDR when leaf_opcode.version > 0.

Therefore, we moved KVM_TDX_INIT_VCPU to tdx_vcpu_unlocked_ioctl() in patch 22.

[1] https://lore.kernel.org/all/aLa34QCJCXGLk%2Ffl@yzhao56-desk.sh.intel.com/

> If this is effectively limited to deprecated TDX modules, my vote would be to
> ignore the flaw and avoid even more complexity in KVM.
Conversely, the new TDX module has this flaw...

> > > @@ -3155,12 +3198,13 @@ int tdx_vcpu_unlocked_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > >  	if (r)
> > >  		return r;
> > >  
> > > +	CLASS(tdx_vm_state_guard, guard)(kvm);
> > Should we move the guard to inside each cmd? Then there's no need to acquire the
> > locks in the default cases. 
> 
> No, I don't think it's a good tradeoff.  We'd also need to move vcpu_{load,put}()
> into the cmd helpers, and theoretically slowing down a bad ioctl invocation due
> to taking extra locks is a complete non-issue.
Fair enough.

