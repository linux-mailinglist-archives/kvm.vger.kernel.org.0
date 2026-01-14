Return-Path: <kvm+bounces-68007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8137D1D846
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EC5B3047974
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA3928314C;
	Wed, 14 Jan 2026 09:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IccoWZlS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F86713D51E;
	Wed, 14 Jan 2026 09:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768382758; cv=fail; b=hs/cDaIkgmC3VcYTrHZAqa7abAagHTlo3C8YtX8VhG7rtvc638negvqFCU5KeqGAf/fLmaKUXo4KGWM50LyPOhu5Tpj5mcrkLiqSwZr1AWHQayRgSfjHVP5amTb9LliLUU3g7KUH9dzmZC0FLmqqwO/mlocCuAsbLV+32jOqWCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768382758; c=relaxed/simple;
	bh=Rz8hPKB86O6HuWfjrKiiiC40YdYheAsyyXziZJCRs88=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qjJMUg7mAJg41IZWGaZqPNBQLHCywmsDCZ8JyjdJINnDLGMWJtO8/zIEZ5y6fgAUrFAS7RxqaQM9ZvMpi8vXRQeVD5bi8EgOq0iHC2yAMVEQOiUQZAfI/44DtJWxg0sseiChHw67FIQToeshComcy9tgPfq2/CINuCcsGZMdVcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IccoWZlS; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768382756; x=1799918756;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Rz8hPKB86O6HuWfjrKiiiC40YdYheAsyyXziZJCRs88=;
  b=IccoWZlSkdXdZWPoLI/HoECGRa1BZqpd3067OhExxpB8Jfv5ULwl2Vrp
   T2e5+VJdCEPOm+y8kV2UCgeAHdeq5KCTOLjW1Fu4f6dYhekBab4wOhMYL
   R6N4mGQSSYS0DitHKqiSFt8FyyRGM2Ntxx5ju1FMpf+qq2i0d3oY/4Fwp
   nbl0tYFqhsU6zCma/sEDW0NzqHUADSBWjAQ3XsK94YsubWSp9A+X1jnnd
   Fvavh0llu7/ZlIYMqHZxuaBgOQTPeE8l4ctxXg2hR4M2ExA3hepCNCmaZ
   IoMwNGyXjMmP4ihxcPK51adhSXxgT534gocV/aIQlBU7XAumYkU9P3XGt
   A==;
X-CSE-ConnectionGUID: RqvU6gCwSRGRI+ELzmtCMA==
X-CSE-MsgGUID: Z8UKpRQAQSqwHeGzxxV1vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="80788181"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="80788181"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 01:25:56 -0800
X-CSE-ConnectionGUID: zqMZpIGQTVG76fu5kep5Ng==
X-CSE-MsgGUID: 8AF0io57QN2u/LtBhZRmbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="203772056"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 01:25:56 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 01:25:55 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 01:25:55 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 01:25:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jYUTDw6QAvcQdIVvtu0W3fHA5bUOexq1BlbjUlZY1Htx9tK+C/U0lJl8fhhfPRAHJU+YJXCqOo2DojrOtCb3qk1ijAzS4gcA9wiIIDzjNjr7TM1zh/BBDxfJSS55fCdfLFwANadsH963PbV+SsflyHdt/iyqeqUJanNKVKvdFxiB+v9B3NIPvRG6+vonlDUak0xBlVHllfZX9vFiRuIS2AA0SWShxKQQgD+l8J2LJkLlJP3EXdkp8btzcDWSHp2LTmydz+NXGXDWCiAGI7QEaSyYqiNVNh0rJmAMLJXYTFAHG9vlnYPh3BabyliC+KppyAw+sgj70c+CKIsQMPGRcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyeiHy9w+K5z1GfVSNGsvW/pYs/UFeHT0y7mbix57Q0=;
 b=WVdCoaL7YKgWBO24LVz0xUsgZSmS0s3xtxzDoQ9pd5WjZuTjf/N9uxyRaTSp5y+xGm43tSN4QP4HYR5t8PAF24BoWzF9wTpXIjh4lmpHoFOWFPFaOpqJ0c155U6AIWIMUwdZpjdyDUqlGEPfTpXJAC8bIgt2lPzl/KxRG09EH+7/31O5XV2CZmyJaWwF/JvTrfydnJ+OMe0NEBY2H+YWQrpMQTo2uv1il758wLRx95pvnbTrn/qLMuxd0bE5bseQMJBwI5iWrPpmMOaVlS5oYKMZun2Lkh+17k5aLqz45g5CegUbdaRs2c65GOpcAOskvUeZzxGN2YFxMwAWZAEAAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6273.namprd11.prod.outlook.com (2603:10b6:a03:458::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.5; Wed, 14 Jan 2026 09:25:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 09:25:50 +0000
Date: Wed, 14 Jan 2026 17:23:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, Vishal Annapurve
	<vannapurve@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<sagis@google.com>, <vbabka@suse.cz>, <thomas.lendacky@amd.com>,
	<nik.borisov@suse.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <francescolavra.fl@gmail.com>, <jgross@suse.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<kai.huang@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>,
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
 <aWbwVG8aZupbHBh4@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWbwVG8aZupbHBh4@google.com>
X-ClientProxiedBy: TP0P295CA0059.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6273:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc75e41-227f-4642-7d73-08de534ee87b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X4nVqaiWi9VIK0EOtmwcqaBRZhjx08AYNmpHM7ktNfpcXQeOkL8+D3GkRamA?=
 =?us-ascii?Q?Mbm8jx9ZpyMtGLipeSwbWHd7mlzMy+hzp3H38Q0p7CjqBdC2gBGimT9f0ybI?=
 =?us-ascii?Q?s+JCZeUxKw9J4yHdzQLmsHne+3KQ+tPDZEyuY/HDqJUwsNzE8Hv92UFsEiK7?=
 =?us-ascii?Q?Tug84THiLDqGVHrp6+u0tUbC5xM6wb9TKtxkWdLzoZKasExt2lxQey46eOGD?=
 =?us-ascii?Q?khId/AXHTweEqWJz+8XtVZMEg0ECkW87PtZfBNdquCRpi8uPRtOfHfA8gxwx?=
 =?us-ascii?Q?WlqtsVf0WREOqy6II8ex/cifOWZ04bzl82PDjScxnb2GqlVcRJwdyVLPnh0E?=
 =?us-ascii?Q?7YZX01wS3BfmGO2/B7nwkZ/Ikm6ucZwhGJCqf5o64kiaTtiX+SlBqCwyqOCP?=
 =?us-ascii?Q?LvavSqLElGy6M3ib4JB4kjvJ1HOn+tQWGessriH6vMDmnqeqnn7he2NTLHN8?=
 =?us-ascii?Q?lWIIFI2kaggw/XUx23zOhikLGz6oQV/k7tGk6YKqI5auielbU6WV+D4i/zUn?=
 =?us-ascii?Q?rzMjg2j7Dbhpbxq3lkQ2vjTJkgVHfzG7Dk31v+zvawjRkecStbFggyUxrfsf?=
 =?us-ascii?Q?b2FovUI5GU2WUBJRGjXnD5rwBC7Vfx2SLkoIY49vsFwapbk7+ZTv6Ssvt3bT?=
 =?us-ascii?Q?2alqjMRl8Ri/8E+O4ZSrTbGH1t6R47CkBKGbWBB3NHMJopFQOxortAoYyg/f?=
 =?us-ascii?Q?oVJ/KMIT35IrFHTm9EHrpWzBuY55ZnkCV7wptH/gRMlknaV4zTCiNviDnLH+?=
 =?us-ascii?Q?ujJ2Q2l+LWBEhRF1Ny44y81AZLDyaS4egG2E5U2OTMLe4/GfKebgporJ++2+?=
 =?us-ascii?Q?gZKh16cAKLA/QYDWThsvle+hOdfVCG/7UqXRIATU9TGlxMa5ChvKEWoKL04g?=
 =?us-ascii?Q?FyZ877Hh1MthHQdjj026xPA7Lz/oJMKgeTNu/wC/uvFDAF6UoRv5O1X3+46L?=
 =?us-ascii?Q?M9Lu3VcqEbqm/BV797NnNi0hQndH2o7wiNE7zmYBFqosbrPRn3Iee1AeUXbn?=
 =?us-ascii?Q?mQdlW2NtuvQcSE7XHoC0Xz7TMzO3A8qiQShq6LME+SJ+s4S/Vx+oTgyMX4zq?=
 =?us-ascii?Q?ug89/egsKg/jQPQT3EfMzl8lbQlbbfIOcYDtSt/KQarIhjnDllTNIeEN6O6j?=
 =?us-ascii?Q?ApfbSlEp1oHeZqSOMwk4XAvpEWE0meDnwu78/ILH4s6A+U1jJO4lgLiyBVXF?=
 =?us-ascii?Q?dOOdoB/FeLT3z91cgBhtWFJnMTGGWcJZZ0slCrp7iPnMCZDuIeRukot1GewE?=
 =?us-ascii?Q?EgD1KYtBA9w+m+PhvMPw5F+2pNKPZ5tPL1B4fGKyAQIK4JeFvcyu2PjZKh5n?=
 =?us-ascii?Q?9R9Mpd5GFDTaIxFcwaxJL+qrXLLg3gzHbNAe+dHQtk/uo5NN8eh6qMYWirP3?=
 =?us-ascii?Q?j/PVn2ctxF9nOOO6+LGsN7l+AzeIX4Nju4czphyTwG0TnJOX4EjXieFh+1pM?=
 =?us-ascii?Q?fUx3MGUB0g37cg2e6ldqzDW6z7H2Nh/KEI8kakw8p9hvKuf4hA/oOQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vusXQfSXCkc4atbyNLcxJJOqnKayoV4pbszGlPQyNDEv1B0/IXvb6WUD311y?=
 =?us-ascii?Q?7gLCx/Qwxl0d5IcQg5gW+OwLytHXuu3C6X7BUiA6YliqU3p636T3CDj7PtfS?=
 =?us-ascii?Q?IW24nd/cMLskoYxHzXzodeZ4zQJoyJNuszWkPC2onlqfD7iZ+YqtIn1hhHc4?=
 =?us-ascii?Q?gqVZfPxZ7CjUVwmbAND5E0kof1ihEiYTYFwX75QdV0mQXn84u5BHOA+W7T+6?=
 =?us-ascii?Q?ikNq4VHPtAAEJaMoIkLWvBRTrJN6OSOtWeClGvEDxqoY0Cooe0Vh/YRRPyYr?=
 =?us-ascii?Q?0rpE4TfdIr1CaoWbpDl2OpPCy4KaezuCyVw8TGogzYnpVtJyg8NlACVY0Lho?=
 =?us-ascii?Q?CVf+R25jXRnQJlJzwNRMx9qcwPwvze4+QuVgC5ONvp5TbneNJl8qfsS6O8gb?=
 =?us-ascii?Q?4tl3EjvEIb5gJXRsaHl06c1JwowH4ueiEyp79e+gttYJByfw5X1vqL7/1tke?=
 =?us-ascii?Q?YrdGVZTD4QTp9Upx2ya78b3jiOezQKtdLxx5MPIbQKfCieBeJl6ZQDbZsl28?=
 =?us-ascii?Q?qOfPwOO5vAz8jPV0/8IY/qZyxAQ9EhfRojlyZ8PhiT0ipOnMmqa+GcSClgfq?=
 =?us-ascii?Q?sPwhoT52lO03sgl0IaMowFz5wMZZAOWfs95Pkakx5U+1hFpj10PDW6F7Wkjc?=
 =?us-ascii?Q?xdC/gp0PM+6y+ulhoYnSbtrQOp6Ngz9RpAbQS9ghIY5iI/uWk+AJqlYffCVi?=
 =?us-ascii?Q?FhARQ0gq50rRAYw1tjfPVryGM/zFU2CjxRyyWjjdZ+HW5LRYfbQ1LcKlKhux?=
 =?us-ascii?Q?euPhbmUh1TJ0gH9TaCELVcGivhqVZTjrHKRtXlcsj8/jSgolaMuJ6rNEMeUk?=
 =?us-ascii?Q?v1GL3nify+C6TpQk7zJWM2objfkowD5F0ojnnAf4402Wni/5Kmjz3ZcYI2KO?=
 =?us-ascii?Q?JaAUPWfNvGwjTpH3DZk7JFHHpA1DyTrGfECidOC+WZXWlDUtvzeQVKMk1gtZ?=
 =?us-ascii?Q?vAwcSEV9Kf9e1lg24c6l0yt+cqrdHBldGA7jjmQCHZzxvooF+qxE/uOwR4hr?=
 =?us-ascii?Q?+XkrvCzMREI2URmPJTzHxB1LOCbA2d6w/GKtUvJc9M/RSr147GjPvw3U3Q6q?=
 =?us-ascii?Q?5Kjn2iGZGs5zNi25imA2jBH1FRAPsuE3aUUtQznOdGGjqYlBxoLlXg2bI+kW?=
 =?us-ascii?Q?fz8hbqZ8L+yCgM/92bSrB+JeMIhR0PpCsKvUfNxRsFtz5UFKYyWPVCRAmTDd?=
 =?us-ascii?Q?adqpH5UMlKziR2sq9SWm2n/Dyq8zHPz1RumnvckKTOAtGpEDMS66e8p0zCIV?=
 =?us-ascii?Q?GZJuzPdmOdjBbxMKWtC8yvDd9RsgE/PI/4pm56H6MgPlSTpXCETProbvniZm?=
 =?us-ascii?Q?XBYsZcOE21tFgzhR/gjQLVYTw3g6OLphCaky08CUNDrz5eV+p2N4FlrsLn3s?=
 =?us-ascii?Q?0jjMoG8cxOKUCTx048YfHBmymn1Phghs7x2clRpcJyHmHfCss3jEdCCw3Ja0?=
 =?us-ascii?Q?a8C6HigUgmzZLtrC5DZ81w5bQ0d+T9YWjssTNhV4Zu48tuf3OAvBX7IqwXev?=
 =?us-ascii?Q?7n7oTCTKnp22f+AZskBZu2suLiN/Pre/1SmoyZN/j75DVc3kfphyKwk5cDhk?=
 =?us-ascii?Q?gGErrK5ct1pa+3YYpCpHmZ2ryMXRrlOyYMSzHFm/CPXnG7BZq5lgRXOh2daN?=
 =?us-ascii?Q?EiOQOXzfsnlWpUO7uvPbcjYZ+8O8lpqHx6+ZHTgUQBO8hQWC8WgEvoF35XEE?=
 =?us-ascii?Q?I1mTfysgnH50dFB7kgnnE7H8KIVGD1yHP/ZSoGLek1w2BBcsbX/Y0pkZmVtc?=
 =?us-ascii?Q?38jCvsDuiQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc75e41-227f-4642-7d73-08de534ee87b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 09:25:50.7704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lbtrzx3SUfY6Y0wpyiYEaexELbRAsRhgFRovsS8kzSwzLljS7mlcsPGV4ncxsz8WjWtMwHv72argoGty2ALLMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6273
X-OriginatorOrg: intel.com

On Tue, Jan 13, 2026 at 05:24:36PM -0800, Sean Christopherson wrote:
> On Wed, Jan 14, 2026, Yan Zhao wrote:
> > On Mon, Jan 12, 2026 at 12:15:17PM -0800, Ackerley Tng wrote:
> > > Sean Christopherson <seanjc@google.com> writes:
> > > 
> > > > Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> > > > conceptually totally fine, i.e. I'm not totally opposed to adding support for
> > > > mapping multiple guest_memfd folios with a single hugepage. As to whether we
> > > 
> > > Sean, I'd like to clarify this.
> > > 
> > > > do (a) nothing,
> > > 
> > > What does do nothing mean here?
> 
> Don't support hugepage's for shared mappings, at least for now (as Rick pointed
> out, doing nothing now doesn't mean we can't do something in the future).
> 
> > > In this patch series the TDX functions do sanity checks ensuring that
> > > mapping size <= folio size. IIUC the checks at mapping time, like in
> > > tdh_mem_page_aug() would be fine since at the time of mapping, the
> > > mapping size <= folio size, but we'd be in trouble at the time of
> > > zapping, since that's when mapping sizes > folio sizes get discovered.
> > > 
> > > The sanity checks are in principle in direct conflict with allowing
> > > mapping of multiple guest_memfd folios at hugepage level.
> > > 
> > > > (b) change the refcounting, or
> > > 
> > > I think this is pretty hard unless something changes in core MM that
> > > allows refcounting to be customizable by the FS. guest_memfd would love
> > > to have that, but customizable refcounting is going to hurt refcounting
> > > performance throughout the kernel.
> > > 
> > > > (c) add support for mapping multiple folios in one page,
> > > 
> > > Where would the changes need to be made, IIUC there aren't any checks
> > > currently elsewhere in KVM to ensure that mapping size <= folio size,
> > > other than the sanity checks in the TDX code proposed in this series.
> > > 
> > > Does any support need to be added, or is it about amending the
> > > unenforced/unwritten rule from "mapping size <= folio size" to "mapping
> > > size <= contiguous memory size"?
> >
> > The rule is not "unenforced/unwritten". In fact, it's the de facto standard in
> > KVM.
> 
> Ya, more or less.
> 
> The rules aren't formally documented because the overarching rule is very
> simple: KVM must not map memory into the guest that the guest shouldn't have
> access to.  That falls firmly into the "well, duh" category, and so it's not
> written down anywhere :-)
> 
> How exactly KVM has honored that rule has varied over the years, and still varies
> between architectures.  In the past KVM x86 special cased HugeTLB and THP, but
> that proved to be a pain to maintain and wasn't extensible, e.g. didn't play nice
> with DAX, and so KVM x86 pivoted to pulling the mapping size from the primary MMU
> page tables.
> 
> But arm64 still special cases THP and HugeTLB, *and* VM_PFNMAP memory (eww).
> 
> > For non-gmem cases, KVM uses the mapping size in the primary MMU as the max
> > mapping size in the secondary MMU, while the primary MMU does not create a
> > mapping larger than the backend folio size.
> 
> Super strictly speaking, this might not hold true for VM_PFNMAP memory.  E.g. a
> driver _could_ split a folio (no idea why it would) but map the entire thing into
> userspace, and then userspace could have off that memory to KVM.
> 
> So I wouldn't say _KVM's_ rule isn't so much "mapping size <= folio size", it's
> that "KVM mapping size <= primary MMU mapping size", at least for x86.  Arm's
> VM_PFNMAP code sketches me out a bit, but on the other hand, a driver mapping
> discontiguous pages into a single VM_PFNMAP VMA would be even more sketch.
> 
> But yes, ignoring VM_PFNMAP, AFAIK the primary MMU and thus KVM doesn't map larger
> than the folio size.

Oh. I forgot about the VM_PFNMAP case, which allows to provide folios as the
backend. Indeed, a driver can create a huge mapping in primary MMU for the
VM_PFNMAP range with multiple discontiguous pages, if it wants.

But this occurs before KVM creates the mapping. Per my understanding, pages
under VM_PFNMAP are pinned, so it looks like there're no splits after they are
mapped into the primary MMU.

So, out of curiosity, do you know why linux kernel needs to unmap mappings from
both primary and secondary MMUs, and check folio refcount before performing
folio splitting?

> > When splitting the backend folio, the Linux kernel unmaps the folio from both
> > the primary MMU and the KVM-managed secondary MMU (through the MMU notifier).
> > 
> > On the non-KVM side, though IOMMU stage-2 mappings are allowed to be larger
> > than folio sizes, splitting folios while they are still mapped in the IOMMU
> > stage-2 page table is not permitted due to the extra folio refcount held by the
> > IOMMU.
> > 
> > For gmem cases, KVM also does not create mappings larger than the folio size
> > allocated from gmem. This is why the TDX huge page series relies on gmem's
> > ability to allocate huge folios.
> > 
> > We really need to be careful if we hope to break this long-established rule.
> 
> +100 to being careful, but at the same time I don't think we should get _too_
> fixated on the guest_memfd folio size.  E.g. similar to VM_PFNMAP, where there
> might not be a folio, if guest_memfd stopped using folios, then the entire
> discussion becomes moot.
> 
> And as above, the long-standing rule isn't about the implementation details so
> much as it is about KVM's behavior.  If the simplest solution to support huge
> guest_memfd pages is to decouple the max order from the folio, then so be it.
> 
> That said, I'd very much like to get a sense of the alternatives, because at the
> end of the day, guest_memfd needs to track the max mapping sizes _somewhere_,
> and naively, tying that to the folio seems like an easy solution.
Thanks for the explanation.

Alternatively, how do you feel about the approach of splitting S-EPT first
before splitting folios?
If guest_memfd always splits 1GB folios to 2MB first and only splits the
converted range to 4KB, splitting S-EPT before splitting folios should not
introduce too much overhead. Then, we can defer the folio size problem until
guest_memfd stops using folios.

If the decision is to stop relying on folios for unmapping now, do you think
the following changes are reasonable for the TDX huge page series?

- Add WARN_ON_ONCE() to assert that pages are in a single folio in
  tdh_mem_page_aug().
- Do not assert that pages are in a single folio in
  tdh_phymem_page_wbinvd_hkid(). (or just assert of pfn_valid() for each page?)
  Could you please give me guidance on
  https://lore.kernel.org/kvm/aWb16XJuSVuyRu7l@yzhao56-desk.sh.intel.com.
- Add S-EPT splitting in kvm_gmem_error_folio() and fail on splitting error.

