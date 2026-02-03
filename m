Return-Path: <kvm+bounces-69978-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIoXKyq3gWkrJAMAu9opvQ
	(envelope-from <kvm+bounces-69978-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 09:51:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F2AD6684
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 09:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D27D5301DE2C
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 08:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C415F396B6F;
	Tue,  3 Feb 2026 08:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSJbHjnl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6334C2F28E5;
	Tue,  3 Feb 2026 08:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770108698; cv=fail; b=BjVXIkdwsCUrNNHFbeJKy97auCQCAu4YgQdKOPstdnw3YKayrbtNLcaWDDtductrMAh9AVugRKEJDYVAI9xLlbuu/N7JP3vRnap7oeCi44Gmh/CaJCkQQqqbL6XinGVl9BlljGQ6mj6tgjqaG76hUJwt8Cg5iOA1Jk/ENHid+u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770108698; c=relaxed/simple;
	bh=vY+hcIfbxQSodySYQeaBtiIAwBYg9ESdrFESwUYF2EM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D8bM3b7iNnNLQ5t2Ursnq3Nam7aUG8rTkWmkAaqOm4urX8puGdB4En1/dwa4xj6GHliT2/lnv9ZXpy9dmX3mUmFnlwntJwV/3ntVrdVddRdVTg1ug2pul2wqd3O9diTVFKKsxQEMCa2aNyxGE9G8rlVkgMQ88JL54IGTsGmObsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TSJbHjnl; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770108697; x=1801644697;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vY+hcIfbxQSodySYQeaBtiIAwBYg9ESdrFESwUYF2EM=;
  b=TSJbHjnlbrN1Qt2/36fvZYYt0rwJGKr3aacqn9CSIt2y9YHTj+ZVg3oJ
   YAKxP0ojGUHftEyNSM2/VhS+Tqmo7YHoyehq3WN2JmaLIyXc8CINNNNVR
   3HB9wrbEZNQGC1pjbmTY2zS8LwzgzpiEO7YugxcEmc8NErkU7/FqJUp4D
   WO7V7EmquNNzTNXtH57HLNg8JKiZYKXPfTOqJfxQUNXYqF8bTT/v1oXVM
   9BhqPGfeDSK0UIY3vvVgqWTYGClG5qikkjX7UK2+BXPBS7+PoPYkqmK/C
   C0eVvzb7O49Awj3jtyBljlE5Zo+3zlHIi7Gd4ttv0/u3I/VCMK2o2dtfV
   g==;
X-CSE-ConnectionGUID: 5uSj17A9SJeYYXsMC0HiLQ==
X-CSE-MsgGUID: xI/cyI8kQxesO6blt+YTtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="88850167"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="88850167"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 00:51:37 -0800
X-CSE-ConnectionGUID: GRIjAEeqTTuFlLEQGSMYJQ==
X-CSE-MsgGUID: OGQRtd0EREK4QXldesWL3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209525814"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 00:51:37 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 00:51:36 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 00:51:36 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 00:51:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkCs64nV1jCcmOgDhF/meWtjN62mSt1veO5Ola6AIoTE5DqW9HLKs266E7ywwCTa7/lYdJfav0TYOqXTEBNzftTmYUPiefyv0oq77XwL8Mi/YUfAMtr+I318IOzMHmg83sJkmj4Gm5KIargwbRq1JKhQa5yDs4CNb8Wm76XdAsi5bfJ4aVkYpcMfKoK6MZ4znPruDsFRDNWOK9++4dAL9VXY7+lDx0kiHv7+cLS2yw/GzuJYDFzsaWdmJdvcDv4+UZPRvAwCxZiZzosN2xQVSFVrmIM1d0cVkywAnfEWIcyy3ciuXt2qbNKqiuQLtufqAl27ka6R4UPSgfWQ3UgXTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5IExqeZpS2Btwx7ba/8COWzJnfKUl5cIEoeY60tsEU=;
 b=i/IZeKD1+iylFOjdX3D6TeAiw2asqNWrZr6YQVHd3ZAwTYYSGWmXcK551jDGHPxvLZIemHHeF3Jalx3x1DJqrxVcP2JCVjzBIgo9W7l3trYnDOu1JRNozCcmRRxwEtlRlbUdbEn4cy8MVFqYWgOHCuTpRJOoryXreCJAm+Z9masTVOhzKSm1mbFNjmqDqqd0sBeoSc8w0WGt2TinNBpFOQiUdF12md2Lb49YGRdx2rsPz5VTj6nkPOOXBtOcS4AHfLAgVRcZwRWm141uDwQoiCeInj2nNIaN4u8AHbNlmyuqtuRdPauXXpbcgziH2nqYE9ekpZW33YubdVq/zOvwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4518.namprd11.prod.outlook.com (2603:10b6:208:24f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 08:51:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 08:51:27 +0000
Date: Tue, 3 Feb 2026 16:48:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Message-ID: <aYG2XxIylgaL+MJ9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-3-seanjc@google.com>
X-ClientProxiedBy: KUZPR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:d10:33::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa9fe5f-47a0-41ec-1584-08de63016ab8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TDlwCU/m5eick7E3JCwcv7AFhg9lwvS4TSAZVX57ZLza6bQX3HnLJzJLoJM2?=
 =?us-ascii?Q?VwzMJV/ABKHEU9jkgjgmDKRFFmQdtmGs2f6eZz/mg3CilIVQqrQuN9rahJJN?=
 =?us-ascii?Q?y463BaMWbr3JeoSph1CXUqaQBBmlAJEyOjOm6THWv6zF7fCGqMutTcKQ1zeX?=
 =?us-ascii?Q?Fq5IKimSEgD5NKV6MVs0vQQXt3sdvLSyR0ATYyGttGc8AayOlNtHGehvjupP?=
 =?us-ascii?Q?zOJwUnNqk04ftVpQ/I4vubTewLpv5+cIkVKvhj7ssNOFoKr/76sM+IA1mocE?=
 =?us-ascii?Q?cmHuzBl/GTcq/L/YtvT0hFpL8yL4Ndbvk1bjWc5MUwLL7u1yH4DuTINPaKm0?=
 =?us-ascii?Q?yxMUKdoK0H53Dt+MuSTdeSV+VwBWl0qJVVi5RmtpnGPizdUsyPk+XO63IoiY?=
 =?us-ascii?Q?e0AhQcOpbTPlVx3OJ82MrRANABzRBC1TJr2bwT7wm6bq2inLrZBr+NLkHZIG?=
 =?us-ascii?Q?vodkzkbI+ewN82dyWAZJW8RmQuT8jS8iRCozyPqzxTmuNarWJ1HU4fr8dZb2?=
 =?us-ascii?Q?dX7AhKM4hFu6KSUB7Qv2bWe7IhGZ8fq2MMzctqJp2V1NiF3uWtlr5/0RP5mp?=
 =?us-ascii?Q?kvUSsmVimopVaJlebFvp4+Awr2/wjY7rCmVNEtz29eMYhx2NbidikxpvgM1Y?=
 =?us-ascii?Q?lgjhJc2865l7/RmsEp2lEPmXqYyCIwwgF23xiVOfhAVyuZ5aLPDMuXfPUikM?=
 =?us-ascii?Q?vJ9fopzZJIHdbeQSRbdf/kAjiDgxjwaBDiZL56tQ4HB3bUdYcISAWzR+OoBU?=
 =?us-ascii?Q?M3IlTIM5QeBuU4Ss3EJWL0oLA2Un1MvUV6zM8aP4meT8SFit8Ua0zAjihUhr?=
 =?us-ascii?Q?/mwEPuF5+hjOlB+bCyAm2AKsbfIQXAga2K5hXPhhEG3NcDsLdKdXMGc8ydBn?=
 =?us-ascii?Q?A7lzND9Wjuggdmi5D8FjOz7JrI01esOdWxCsbB0h8zsPHLMkf8dtx+/Ums49?=
 =?us-ascii?Q?43aotVX3hRsNSEY2JZCX6TcfHsLl9qNZacvtqTSc0YeBqlb+Mbpoyv+Pkaoe?=
 =?us-ascii?Q?U4cocQSPjzm1Jfuxd34OFRX1gmFRFu4xel/24c5KmcIi/cFoVXanjwQLBiet?=
 =?us-ascii?Q?zYGn7BiKV8UQ5u7Sq3taqGkXXjbkl7vGqY2KeSD2IBdNJh0vFjXNKANihyG6?=
 =?us-ascii?Q?f1lJ51HXFhsqMJ4TJ3kce95apdJtOjp5vngY9FtXUGozUyqCiz0bBGMByHxs?=
 =?us-ascii?Q?8N6RpdluCaMY/DFDeyHZG7mFgrTfWp0Xzs1GJFs9pB8Tfc5CIN5fz5zCGV9X?=
 =?us-ascii?Q?8aJ6Qpht+bSOLe/9AjGM8/UzDQ2yVQLIEhUOBEx2/HP7vTfVSJB7UKgYvJLA?=
 =?us-ascii?Q?L+4wbuPtQH2GhA6MtT9hx+9HL9tfgZVzwdm9ZS6HeOJVYKGQsxrq9PT/JYrR?=
 =?us-ascii?Q?bbB4ivVkszEA8s3r3bDFvcmL8Zqr6Hyn456h9j9FcI97wRNA/LQ2L3f5/jTZ?=
 =?us-ascii?Q?pxvbxxz8EAVoLRKgFHfM+UWurfE8PMyJQTdCPSbugdhdEjimrcaJdvkLoTKx?=
 =?us-ascii?Q?alTDLeU5yLzrGIO/vrutMifLsEdQ5P6HhUuKxsM4nreAoyMnYXJp2LSlEBZ3?=
 =?us-ascii?Q?BER3tiscdAxQgcJDC/E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pu0OxUUdPUuQ/g2AIJcpeH7gLyfCxuyxFqXvwmEDzd5oi7+dlQoSczQ0oB21?=
 =?us-ascii?Q?WaVhbgLmC3Iq8SgEXHJWZUwyGane3XhhgxAYNM2V12GvsEQsbmCO3NZtk9aQ?=
 =?us-ascii?Q?c46UKwWIBqWbOTS5T1I8smu5fuJKQC4ZqbJNQbpCSh47EKi8XwSs8RaErG3k?=
 =?us-ascii?Q?ILGWlDeUUdBj8JYQwIZ8gnCT/RhCImAjHEtpBMz4KqU/qbqG8ilW05EKUf8+?=
 =?us-ascii?Q?i7oDP86w6DpF7ByW4WKKGxw0SkOi1LHTHDkp2ZYG9abHSqccKvRAgkhhZ62s?=
 =?us-ascii?Q?uY2PsHEAiGyqosYqZhPqZy6pu5LSH2Lz4bM+ZoiDY8q7epdDd74pwA85U2JE?=
 =?us-ascii?Q?tRR04YROIT/90vPMoq5HHfQhZWvoS287Qzpm6nG2hQ/YMcpEbBJwY7/sQFrr?=
 =?us-ascii?Q?JzXubkhwQsOKONB7M9VfJfZldqPablnJmyDJqRH+8zaRlBc848jauvp3nwXk?=
 =?us-ascii?Q?QS9aUsmQyZ3z4ML3uHaB4/s6BQD8DLwrxR/BmFdu6202ACtVk1WDxhlBltXa?=
 =?us-ascii?Q?RgRMVumPUVX/OxmJVN+19DJBcw9ToNjgbpqCapwn2fS0CfwdwnzVuUjwCYda?=
 =?us-ascii?Q?yn4GM4v+GwTLTP3O6gQ7cgG7d6GMRNuk1DkMgmk7K6h7adzETJIxAaCKfaC+?=
 =?us-ascii?Q?GjFDJP0FEGGXyiIsIel2OFs8bBUk5zD2WhA92dl8cVIDt2S+wvDlF2087MYX?=
 =?us-ascii?Q?zVCO2cjTKJdD/070SKz0hcgUPArVjK1WSaA9ovKfbpZNnX7AV5EbpYO8+oa4?=
 =?us-ascii?Q?r5HAEh39vJVAHWYGE7MTm1SiH26QAXPqgin0f8EVxHfHas8iaHZAoEaUVGie?=
 =?us-ascii?Q?LB+tHUMrYNAEMGxIP1gbLdy31VqlasZ+19wwdP0GZocIpkm88IA/osBcmXd/?=
 =?us-ascii?Q?j8cC0BzxXJovUA1k2mq3O/YP0n7VsIYPXh5oEBTuPLe/Gky/h8a2ckhWSpr+?=
 =?us-ascii?Q?RK036paqKroJxz2QhmTPA2qmNCQDXrhypV8GOxXtoVk3WaC9YRao1rHiEbVT?=
 =?us-ascii?Q?3wU36ZaGboRpUObCmwR2xM3W/cMR2SCwOOh1QYXUrgXoylXtwUMk+UVeaEE7?=
 =?us-ascii?Q?qes0vIQZaqAfWD98mHKGVkn+jPrfu2ZWdPSzy8qx0KkdBTFaUryfrE3EIj3T?=
 =?us-ascii?Q?WkqewzzwVymicjpAATaPZSVOsGeo99UYSqg+0SA4FwDIfnoHIzklR/kR0oon?=
 =?us-ascii?Q?LBEja4sQURTIK3xYhxksbKH8pnRXumxP76vb0izPL1/vXqpQHYhcTOBdKxCw?=
 =?us-ascii?Q?QAXEsKe2AFxfnOscvEJJjGmiAKO/0tiwS4wY0J6ERjZgm7GbpFrgaJJoL1Dp?=
 =?us-ascii?Q?aDnCWsOou1g15kG7TST8YYj0lAaN92WgFt/z3BhEcdE/9lAtPf7Y+eiHVSYu?=
 =?us-ascii?Q?DsZ4D1Gu+Lol1lzknMsjnkA0I9phg5lB2L4W1FiNCgsZQrT1eN7KssBL3EQc?=
 =?us-ascii?Q?969tgcsiBrWyvvVAEodOni+bNqMDlrPRosls2njOMJ1p/okJUavelfhwpNi0?=
 =?us-ascii?Q?1tl53TqWknxV6gg5+bqSaiAS7xMNhFRAJ3YNpHAdxEeyaIDeHMWsuwoa6cCL?=
 =?us-ascii?Q?MRisUdX7mCxJ5UIt6gnBF93U8Gqcm3L1Rq+F7LBe8H9JEKM4cithMMN6cI3v?=
 =?us-ascii?Q?t/XKXJd4bfyucu3frHjd4tDWijZUZ4DvHxwOlkKQcIy7rV4q5cx2yf3TxTg7?=
 =?us-ascii?Q?mCmWn+frUsmDXrEGvSbmwh73FL7/Cd9Up21SXjPMloKD8Y2KZdcAQvfHdFwx?=
 =?us-ascii?Q?aTJLTWA00Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa9fe5f-47a0-41ec-1584-08de63016ab8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 08:51:27.1774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9rsWM32h2ptYjnt4irZ2yBJCTH5BxIdiH/96yxa/LEFpAwTuDdXsJgBgHH5QaZsRykiXKyiAuASL1BmoC7oGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4518
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69978-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 14F2AD6684
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:34PM -0800, Sean Christopherson wrote:
> Pass a pointer to iter->old_spte, not simply its value, when setting an
> external SPTE in __tdp_mmu_set_spte_atomic(), so that the iterator's value
> will be updated if the cmpxchg64 to freeze the mirror SPTE fails.  The bug
> is currently benign as TDX is mutualy exclusive with all paths that do
> "local" retry", e.g. clear_dirty_gfn_range() and wrprot_gfn_range().
>
> Fixes: 77ac7079e66d ("KVM: x86/tdp_mmu: Propagate building mirror page tables")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9c26038f6b77..0feda295859a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -509,10 +509,10 @@ static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
>  }
>  
>  static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
> -						 gfn_t gfn, u64 old_spte,
> +						 gfn_t gfn, u64 *old_spte,
>  						 u64 new_spte, int level)
>  {
> -	bool was_present = is_shadow_present_pte(old_spte);
> +	bool was_present = is_shadow_present_pte(*old_spte);
>  	bool is_present = is_shadow_present_pte(new_spte);
>  	bool is_leaf = is_present && is_last_spte(new_spte, level);
>  	int ret = 0;
> @@ -525,7 +525,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
>  	 * page table has been modified. Use FROZEN_SPTE similar to
>  	 * the zapping case.
>  	 */
> -	if (!try_cmpxchg64(rcu_dereference(sptep), &old_spte, FROZEN_SPTE))
> +	if (!try_cmpxchg64(rcu_dereference(sptep), old_spte, FROZEN_SPTE))
>  		return -EBUSY;
>  
>  	/*
> @@ -541,7 +541,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
>  		ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
>  	}
>  	if (ret)
> -		__kvm_tdp_mmu_write_spte(sptep, old_spte);
> +		__kvm_tdp_mmu_write_spte(sptep, *old_spte);
Do we need to add a comment explaining that when the above try_cmpxchg64()
succeeds, the value of *old_spte is unmodified?

>  	else
>  		__kvm_tdp_mmu_write_spte(sptep, new_spte);
>  	return ret;
> @@ -670,7 +670,7 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  			return -EBUSY;
>  
>  		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
> -						iter->old_spte, new_spte, iter->level);
> +						&iter->old_spte, new_spte, iter->level);
>  		if (ret)
>  			return ret;
>  	} else {
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 

