Return-Path: <kvm+bounces-20518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09FF8917626
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 04:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C8081C222C8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 02:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B7C24B28;
	Wed, 26 Jun 2024 02:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QoKCvDLO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F83E487;
	Wed, 26 Jun 2024 02:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719368827; cv=fail; b=SDhgLxPYO6+3D+6rKE+5v34XHrNu9V7RN3nvVJmHtBIlNEu8uliVcZPe+4s8JrRYApTC7Cu6reVeFJbFc//73MrpWrYLKZdMimMeRvrRDr1jq7cXx3edna7yS39fqL64C7HtyAjSRKOSlrd/XpnqOLiE277oMC5tHYhU6Tx4FKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719368827; c=relaxed/simple;
	bh=yrMStbyx4wJJHDPAmItZ8sTIphmS+ozrfr9RChoxS+U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N2Le9dLnWWKT8XYBYPw0JLow67ZNfWTwtX91oQQpgSHneeukDya/QJN1sGH1bH2d6Pc34ymmow55bCh4WhjAshob+LLQLfU1JqUpcEi9fn3AbM0AFm4hxmWXFNv/t6tUQeLkedmfL9YXXcaLPc2jBtslQtSeA7Lcx9CwmYelrSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QoKCvDLO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719368826; x=1750904826;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=yrMStbyx4wJJHDPAmItZ8sTIphmS+ozrfr9RChoxS+U=;
  b=QoKCvDLO5uUblo/rqcK2H+1fYFjuaDcKaDMFeqS1zIS2ylEzIyMFRs4B
   ptEs4voBMOPwNOrTEiKIOtJGI+L1/Kf3o7aiPnm+NERAS7EOHR06tUWCR
   266/pfidb11K+0UicD2xKU66G2cQl8IzHGDU+Zn2bdK32cwQPZXfj7GuT
   aLHX92KbwH9/JIToji3fglZtIrU4R5qq086PPbJiODgvbaLUTXCSFEXCB
   RCKiInFlIjoJOuwkBntcc5pwGrFr5I9OLhB2DTi5B+f9BHZcQIMzouZBE
   z8IkAzXxsZvDxA5RgKmAEdmrV4bC7ZE/IPbqvuGBwLyQtZFlo/TRQupem
   g==;
X-CSE-ConnectionGUID: Ow65Sc51RpSCvuX0/deVvg==
X-CSE-MsgGUID: IzrYEaZXRGOsKnnk+f124g==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16296476"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16296476"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 19:27:04 -0700
X-CSE-ConnectionGUID: TwAynuMtR5i6tfb9d31SYw==
X-CSE-MsgGUID: NKQdka/vSCaa/yv6LA9f9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="48425498"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 19:27:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 19:27:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 19:27:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 19:27:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgT1xgmffFJtEzW2gpGlK6TTjh/0Ptx6XWPZJPpYQ8TqKjhKnxj+tn+1b0V0FFQhDpwR/4+Sbbvei4m4MIBgsvZTB/jf4zGSAYAXj/kKwtKP3XuBvRMzjpgLYNzzi0hYIaWMT8zUscylm3UUHQllqKvOnSZgmU/WwTYQwCwlqiV3ETDD5Vw+HuSszS6BHQ7MbdhVt9JQEeJeNlKfO+e2GIjayWctQ8bUFkT/aG+woU08EMy7uPe0DL8NUziHq9Cm6rZWMQZXRYWbBkPppjBUA26VlJ6mUWJQcIfc2KogTuhR9UWIWrmhdTOdYYTbh/nzKEncwobgonP1d0lXnwZFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=achGQ1vIa/hHi8jFNtn4uUWG2cs95GTKi0k8qv6kKMY=;
 b=g0NzDSpdN8vhgRtPXKOWF6+0zOwh0VsThich3JHq9B051c6Mom6OoP/21fdWByXaRij/5lrNXi5QiowL45pSipv4KJqfXnxb8eIXgDvY8O/wiQnu7DWkiwPiD+ry6V6PVZk/aVoUNERdlOYnZ4Ic2A1fwKsza2S5w4v2pedFzSJQ0h1SaRZz5Qwuz5/VhSyUtBM9JIxn9LHxAH6cDiDWifVNshGmUbEn9DcW3hzBrLycIOuNz5eQXA1qeKRzyw+9kaNLtn/uvrLL36G8nCookIn3FwXCn6kSGX7xSd6a6Sl+7EdnXIPHbX4CwdmRvWRO9vAXT3Rqqgm4ccRmyoBNMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8495.namprd11.prod.outlook.com (2603:10b6:610:1bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Wed, 26 Jun
 2024 02:27:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 02:27:00 +0000
Date: Wed, 26 Jun 2024 10:25:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Message-ID: <Znt8K7o0gCwjuES+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
 <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
 <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
 <2f867acb7972d312c046ae3170670931a57377a8.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2f867acb7972d312c046ae3170670931a57377a8.camel@intel.com>
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8495:EE_
X-MS-Office365-Filtering-Correlation-Id: 5350d933-ff0a-4153-e586-08dc95877519
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sw0iaUmYDnSEvzn1nJcOa7YlgwptX8JOLq6QJP5orYHdSj5khBhKWhMPCwl6?=
 =?us-ascii?Q?dLSptCyGUDcLSGpwHtrzaFv9xVV6uSlhb3fIRArNoZBbT2PWdABBZ1Hk/5jf?=
 =?us-ascii?Q?z4jVsKipla06mwQ1Qk8Tf6EfKn5e9wcLz8+8gHbEcUZ7KZH0kSen53dCYmPc?=
 =?us-ascii?Q?ScLRHrjxaF+K8OTo5j/DkFpeaf5ZS3NSCNjkqNxk+KwKy1N5J4FcOFaNVcv6?=
 =?us-ascii?Q?q6oe53FchUcYPLYoX4JGjaP+dp0YdjltAbNsT4s4rcj+nYroDwl7uzhupM2G?=
 =?us-ascii?Q?lwKIfIrRzRySZ+oHpRW9PGQ8mBjDPoQ0/e7mtc68daB7oUyVB6++0dbeq8zi?=
 =?us-ascii?Q?/M8fX5kbEkELYYUi0CrwBYJgl+fypAiyxZ43sS+V5iTvS4H7vyfpsYvMtN+F?=
 =?us-ascii?Q?3YFzgJOecPzFv2cMDjIc7Lhp7QoUEtxWaMBNGHQnx/i9USjN2uZvo/SRJLIC?=
 =?us-ascii?Q?In2l/OkIPtwDnfg7HJDJmd6IpHuNmqKAJ92914BOtDJXiWENcQ9EbQuLCymg?=
 =?us-ascii?Q?zurT+kUuS2G4jveO6O7JPnKOri81jbdG7lNB7OtBiTkdSqRxQ6/qttMBaa30?=
 =?us-ascii?Q?D9uyCDHyndZjq11nv6T5eNGY9hQ+V37XxlEIgtKhscJsMqDXBt/TncjvTExS?=
 =?us-ascii?Q?ARGKGPvucb3o2GsY4biEPXv1gLrWr1XSQgnh/ihXoriHNIcvsfS/OrgE7fnl?=
 =?us-ascii?Q?YjbaawQ9MOdg4p6zMf18eQ15lJX4EWtFZdYcFOJfl3eQVTB2c8IOjGPgAyQO?=
 =?us-ascii?Q?nofCYLN1Afdn7LI4E0j+z79wo+3LagfC+tKKGpGsCVFrKVtQrZlQki0DFuqO?=
 =?us-ascii?Q?NQGCGWY8bvqXNTxVLyimJsoELc9jBvOa/BB/SVZOYrJ5p17WyKGVfSAcXgdx?=
 =?us-ascii?Q?zDZyFjziHkm9/qNjx0rY3DJQdeyN619870gDEPWKWlLUkdt7R/arGsDbA/Mv?=
 =?us-ascii?Q?pA6+9GTrQUsl6n3aDlhgeVQG6YVZVBUlWJyFkujy+SgG2azBgjbOnUpjVJad?=
 =?us-ascii?Q?Zv8TVCu2fpg/lz32Incg69Si6mMSH8kfSckcAThLawF9VhG5TWjhW7Kw6Fli?=
 =?us-ascii?Q?0dnGqzewjone2YWyudUe6wly5vcz7+YgiARjZMN/rWG8vPE64wZlun4u1dVT?=
 =?us-ascii?Q?4bK+hQ8i3/zsoAreVimIbZU4MR/yzEReSY62K1zJTlO0cehVvTRp1VjoThKH?=
 =?us-ascii?Q?T/rfptbqmTu5RVnW2GTFbBAuqwoR4ywm/yXn/s4MlogymSo13QKc24OTq+r3?=
 =?us-ascii?Q?UrBBRhyw/g0905jQYm2mBh+rWvOOyqawOHy9z0EYG4ov9+HOmlaUVLPhET1O?=
 =?us-ascii?Q?Og9Afyj9MqbwPd/KhpYLoWlg5+97EKnJ/OVgaaj+zmfRkA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WaiiD0A1+72qTMv+1E0t5ElB8b4p5fcGAGjIHX90Joi0O+UfHeAPen2FyfVB?=
 =?us-ascii?Q?M+XzZVbaPD0hNkvuFDOseFwLCM8Eik4LxGQbvIImPIczb3h3X9JFkMAVTQV3?=
 =?us-ascii?Q?I8gMNaxv6Ifk1reHlSNIa6lLl2XLMaVFKG8QW+JNpdhfvqborrElbAVwmwqV?=
 =?us-ascii?Q?VA3gS4KjlMDh+ggkSVgS8wDjC6/VR6KOvQMQVUkhFTT8VWJ88gRXW1i6M1KQ?=
 =?us-ascii?Q?/d4iOnbtDVU4yzHTl8lF+uhUl5Qz8SK3N/TLr/7IOshJinrMpcKEm5udjmVk?=
 =?us-ascii?Q?GVKc2d0YZPGilv77tkDHPm0SVEdgIZQihwB7kDDZ7f+TnW1ShgxvSH1fr/Vw?=
 =?us-ascii?Q?EKDVl73vwFKv5a889rVYBWYsK+V5Ekch/jcrai11pYaDxv+CALWYfMN6Y4CR?=
 =?us-ascii?Q?o+6/kCuJCG9xa1cujLmC6Dyo54N0hNJiCd3b85TQtyTpaPlg1lwy5veoPeS3?=
 =?us-ascii?Q?0Ww8JwafOv5jpo35eCpsl/hzd1JqUEOAJ37YM/JmgX/SxJHcsLBNm+I/aMrA?=
 =?us-ascii?Q?PP8h3tXYsUtqVfocx3qL1T2VraiS1GQjgGnoILWCakTsYf7TE68pclL0IdH3?=
 =?us-ascii?Q?/d+x7zPn+eRUy9bkNKy0s98bXpsoEzhNyq/f4twhTI12ioigY/xI9mbTEZbl?=
 =?us-ascii?Q?mPvq8HBl4yntWR5mad0K6chvZygaSmyyitUN3Hxm7k/YI7chyrdYzOwzY+z8?=
 =?us-ascii?Q?esefEd5KC0b1WunVfj7SojX8G0XCfxo5p/CmVHw2RZ3lWMs24/wdFa2G/wkK?=
 =?us-ascii?Q?j8si65/BxdOxaC0DyEpMVDEoJxwZOLSRsrjDKUUql6O5n4dcVFha/G+pQekp?=
 =?us-ascii?Q?GcXtfT+CihFwuJVX5wGJoM498ggZoHeMCeVmS47ILnXCecEz+vpVEvgAJuEA?=
 =?us-ascii?Q?KyfOWosvPmNgpNzBa60Tq8QTYdDRtLdChSqgiBapQcca7EEwIT+R4Oe8vMn7?=
 =?us-ascii?Q?kn/qIvl7A3M4JSmjWTkP+e21SzoPnguAFBoL3fsjnDRaAa3nVlhq9/Ej//dT?=
 =?us-ascii?Q?axeXUtObw0OC0T4xuRb4rkcVsHRa0XtIys3vzOVZ81vD/Jjvxn5WglYRihPX?=
 =?us-ascii?Q?3xta/h0POUVIqowXZzmq2wiF0I9bfW4Eh3xkwDJibsueWVaM6L0YN79iuvmg?=
 =?us-ascii?Q?e5gU/wUS7v0ZDhFy/K0qEksmJIn/SztTD5vY30Fyk6EywDxhWeWbK02XPRDO?=
 =?us-ascii?Q?SKAgaXcyLcN2oye5+Uvbc5of9w8rCuwcn5y/XTPwmQR7DrJye6Se4EId+Dke?=
 =?us-ascii?Q?A+tHpKeNqgrlSHdDC77x7KmnLE5VtoI6yWAxVFgbaWZp5c5ud1vtYiztnywV?=
 =?us-ascii?Q?XlOqlnp4iOn+nvxFEDCQbRHn+52oLUziE+bvEDq9bqV1qOIt8qlJxFwiANNG?=
 =?us-ascii?Q?J1jVAqwBPQDR/qNlwO6WNoH4OF6ZQXgjYubRn4Oydcr5KQ9oggFTiknOacks?=
 =?us-ascii?Q?MXOZHQBpuE0G8b92UHGp/6p1KvVu/cEmbqfSZnDY/uHlRvIVo2VTgmVy3yoW?=
 =?us-ascii?Q?zonkOAhcv0pA3CuNqV8TzRu02TLaac2lPkl2okXrMu1LMbfInDWzc4zbKJNj?=
 =?us-ascii?Q?5Ztk2j4g8eDoD9BCpg2nYYPA8Nj3GZFcUv6oPY5r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5350d933-ff0a-4153-e586-08dc95877519
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 02:26:59.8711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DqwjfI5sg4ZpwpGeJnTEu2ARqjuFpoqfO/vcPH0lbBLDHuqZ+NxD6y4eLM0QqoBsRZ/QZmjCI0+wgykHnsNHow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8495
X-OriginatorOrg: intel.com

On Wed, Jun 26, 2024 at 04:56:33AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2024-06-25 at 14:14 +0800, Yan Zhao wrote:
> > > Explain why not to zap invalid mirrored roots?
> > No. Explain why not to zap invalid direct roots.
> > Just passing KVM_DIRECT_ROOTS will zap only valid direct roots, right?
> > The original kvm_tdp_mmu_zap_all() "Zap all roots, including invalid roots".
> > It might be better to explain why not to zap invalid direct roots here.
> 
> Hmm, right. We don't actually have enum value to iterate all direct roots (valid
> and invalid). We could change tdp_mmu_root_match() to:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8320b093fef9..bcd771a8835f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -98,8 +98,8 @@ static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
>         if (WARN_ON_ONCE(!(types & KVM_VALID_ROOTS)))
>                 return false;
>  
> -       if (root->role.invalid)
> -               return types & KVM_INVALID_ROOTS;
> +       if (root->role.invalid && !(types & KVM_INVALID_ROOTS))
> +               return false;
>         if (likely(!is_mirror_sp(root)))
>                 return types & KVM_DIRECT_ROOTS;
>  
> Maybe better than a comment...? Need to put the whole thing together and test it
> still.
Hmm, I think passing KVM_DIRECT_ROOTS only in kvm_tdp_mmu_zap_all() is ok,
because kvm_mmu_uninit_tdp_mmu() will zap all invalidated roots eventually,
though KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS matches more to the function name
zap_all.

I'm not convinced that the change in tdp_mmu_root_match() above is needed.
Once a root is marked invalid, it won't be restored later. Distinguishing
between invalid direct roots and invalid mirror roots will only result in more
unused roots lingering unnecessarily.

