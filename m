Return-Path: <kvm+bounces-71575-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKnCNuwGnWk7MgQAu9opvQ
	(envelope-from <kvm+bounces-71575-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:03:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E41180CD8
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5396F30BE2FB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3E8221FD4;
	Tue, 24 Feb 2026 02:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HZP8eNPj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F18C57C9F;
	Tue, 24 Feb 2026 02:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771898550; cv=fail; b=sXDNhjfGukz9+0K//9DYyvqRu7HsdxciV9LwY4ONqzBgimBS+0CvtCRa0lu5I6C24pG8Hz7yM0V+TZiORfgJQa2FMFYNjYgRGS92egtP/XtJAwhnClE8rVVEGUnSjSY7qOdRFqsZyXK8q+dDSFE7BjpSskm4LcoYNi7AXOgb8sI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771898550; c=relaxed/simple;
	bh=8eoooxcwmHaF+dJyEVFYX0FT8lokP4tdZ6LW85jXUL0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X4yYbq+O9p+B/scpt8LfjxyYE7WhiThlSloiVWjdFM8oZ1V+9HN4lqyPOvK6DxPLhvGDy/un9NcGyFGk1LwvdVdqaB+CqZOITIi2pn3KMQrH0z0pgCAbl6m2MZyAOFVwmuDOrazRwShQNlvhxiBSueqCy5vYwJemkcYyCYXAcL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HZP8eNPj; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771898549; x=1803434549;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8eoooxcwmHaF+dJyEVFYX0FT8lokP4tdZ6LW85jXUL0=;
  b=HZP8eNPjWgCzUdRp3l8yXrMEJLBC5/yTo4a7743ELfLBtp3wIw3ALSk9
   ru8O/Ie2LBrFJHQ+bdF0NzJJUn3WcXLNk3y1l7Zm2Qm/xCjPKJB6+v15h
   XgkNDFCPxVsAnVLatNVa4kbuvfkS2SfwK9kKrvO6pmMCmdAcrg9ytWQVe
   dZcHQ+Td6unlyyD6VWlIfTT84QtmGOKR87iQ3XG1w9PVJH0CY04Sx0G7E
   UaFmujr+eghQ4IC7A5sACGM7G0U8Mg4STUvOMmPBuqAjlnXLFv/NFjNFy
   Qpf+JVdPRm7e5WxrKWDP9m32NG5R2lkIwjmZVKgLWpZXhjKQVFF3ugrBF
   w==;
X-CSE-ConnectionGUID: F7EiqVU2Rn6DENyD2RUUJg==
X-CSE-MsgGUID: sY031RFnRbCn0sZasO8cvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76736562"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="76736562"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 18:02:24 -0800
X-CSE-ConnectionGUID: pgfdJZVQSaeJw6gfrT/QsA==
X-CSE-MsgGUID: XZ3QbE5HQweZ0Shc95N3jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="215603542"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 18:02:25 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 18:02:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 18:02:24 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 18:02:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x09vNVXM5QpcUER5at39mjXqI1sjq4Berui3y987Yrcid7TX3+DPilPIImU7E9ZgB3qX5a44+FoGyIW15SbiWDiokJQ+fPCVGBPY8EWOt5lTwxQYB5BB7Z38AUj3M6dyuK5NJGdryPrqcf43WtYd4CfTP6f5w/sK45E72Tl2JBaLSg4a2bMaWAm5qUmEIgsHN5GKRRz3Eaanu1sr924C4WNZdlgBJ5yqvHgFTSkmhuiZ8fmv9FEPRD7vzlYK+m9OmR14KKXiESjgL8bXYuNwHatPbwekbeVSceHUud9IiTKJR58r4Nn0aWB6EzFpuzpJ+ocehCvxbnQSiDOaCKFyiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaH/Ncz2mwriUfoRQumss5pfS9ObPwGhzD1+TLPIzgw=;
 b=YHKCKMtxPbJHqt3h1YknmXHhmz31E2xINlAKaPthYTIDXK1a9MbRj4CaRVYWeQzjeZZrkamwTKZIDhC1nxP0udLgCV6mmAGzkhJEOCErBEkDeEI26QEitTbCizhd2YjHhsZJxZNqCvZW9VBzPr3OwmhxMqv0DEGqGm8RuXJvZjPKpDGOdPcfthY6O+FwKWcs/qAj9dntBzCyPfmLlbDrC4v3wVgqRf1tzEPYVg6nUPbvl3I5I6Cf29t0r7yUyGHMTGthHV/7bxrZBoa3deHpH1UkVGafuSLvcaJytF3xgBdd8wohi1/XHUPlS1e1wpOrACPEKGmkLg+BrIHHcv9Dpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM3PPF027BB0053.namprd11.prod.outlook.com (2603:10b6:f:fc00::f05) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 02:02:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 02:02:16 +0000
Date: Tue, 24 Feb 2026 10:02:03 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 03/24] coco/tdx-host: Expose TDX Module version
Message-ID: <aZ0Gm5/xpBnhOeod@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-4-chao.gao@intel.com>
 <3a8feb5470bd964e421969918b5553259abdd493.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3a8feb5470bd964e421969918b5553259abdd493.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0087.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::27) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM3PPF027BB0053:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c12bd65-29ef-495a-350a-08de7348bc04
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xqrTz7P8hpel/rWYScdDG8eQvd99GP5hgIN4dYrJgZ1HAXdSskAd7bBEbud0?=
 =?us-ascii?Q?sDQrzjuHeD8KIK8STRMrviVtq3juRlK6m2yqNmJHbNrPg01rGw4vCFNgFLbj?=
 =?us-ascii?Q?dtC4aas7rjp8JPzW8eKfNEYYH0BD5WqBhL+l9lNazgWZo5jJucRZsYOvYRe3?=
 =?us-ascii?Q?vla+FTPGC1d2dK33L4oKIb7Oc+ZQwYJdVA9cARAj83GtPI4Tk8nhXMyCMkL9?=
 =?us-ascii?Q?kDbjJRJKCKaOzndRZfAJsE1YyzED4dcvu5JtC/uTtQbaqFY+Co2bQYtM6MMM?=
 =?us-ascii?Q?17AB/ICpF6uDyxj6vqmaRVNW/z6FuhvQ4n255YnNkbz2/wv2NOEHqVKZSNpV?=
 =?us-ascii?Q?841UXcN9w1pHg8KVzrYfqjhf6gRSosVTxEjNvbDJ3f6aNvd/SaCWqs2dTp/h?=
 =?us-ascii?Q?qjPcb7nuP666kOqOUCo16vP/XM3aDNKjHfHrMD2RLZo6p6fVYagMiF+c6+q0?=
 =?us-ascii?Q?HOftsjxMoqvUxlhqoOcAM1dawOXoxTqtgWyulVfyZ0zJxqtB9RE1jvzYcYjA?=
 =?us-ascii?Q?WpS0j2TR0smEymNKTH65x67IY1nLCEPNuPKULNu7Y0BGmiK0b0p4+CF5JWLZ?=
 =?us-ascii?Q?aPfC04CryB/37kt/4hKHdVqMKD0lReUCZnrFre/7tbk21enEuZAbu9I4mXX6?=
 =?us-ascii?Q?YB4YoMxEhJ/OUJVUDOcHFWp2xKtRS+LJdZb69grPxa8BsjlWaTC3CHDjfK1L?=
 =?us-ascii?Q?SnxQeEjiQqk+T72gZt5N6FNFDpKjIiWPUrZSn62x40kE6GZ5lEcYoJ6DLcAy?=
 =?us-ascii?Q?6Dokn04rE8NO9OE6WyZPOzenXwYV4J2OZ0N2IbMSJL/VOw65ot/mUutrEhAJ?=
 =?us-ascii?Q?lN+3Z1HYi7qL16hw8/9I34WRCqHCscwz9EQTChncNtaOIG7f9+MtkyGqgPcN?=
 =?us-ascii?Q?H3Akck62vidkJPWXCrP76muHGJF90QxQQY7ecUbf9NgA+RP9KNL0sckhkmDB?=
 =?us-ascii?Q?WGs4QgXtcT3BV5iKlnHyPXz38ZKnBpNHVY9uJuqYawxEsoIcLDb1Hq5Vih6m?=
 =?us-ascii?Q?HJlfCNfINYYoaqo7Xic1gYEPsS1XGY0+FxKMwGCn+6SphN0mWiFS/y2j0BRV?=
 =?us-ascii?Q?U9m7ZOLCLQfOl+GdUENS+6b6ANsDD8LTbuCoGRsd84wz4v56hpJBOVibk3Fe?=
 =?us-ascii?Q?36/EMufE2MJKlgLVmG8Ll/bgsUze89aItixf2lCvUNj7oCuRuipuqTHTPsI0?=
 =?us-ascii?Q?JY0mj0dmHR5w8VAn9X8+3zE6I9AJ3+HyYG7jMWR59mUVj8KUavbzRBL5BqnV?=
 =?us-ascii?Q?DTykER4m/H930dR+IN6Kk0g9AdJP69q6E1virJ/8lP10V1oZjoB9LciWuJO+?=
 =?us-ascii?Q?7DOk00yIqT/7BWrAgzicAf2/kuV2s7QqsYunfvf4KpWBtrFvqofHDRD44Nrk?=
 =?us-ascii?Q?8n3FZrLeFeCe96Z+6vsjj/8LF2UtWLVUf8jwyD1huOoPeBM60IK3U0wMF0vz?=
 =?us-ascii?Q?O7l9hYm9Er9I2bD+K5JWshxxrDgCLOCMHXT21Vc/d7AiCJWUJlsyrUMpRlPC?=
 =?us-ascii?Q?2ni/kUmAk10VzLK7JIL0u8SmFXyAv13LuQAmFk/2JSjRxehnvnscCB+CmS9S?=
 =?us-ascii?Q?SSez5yIxkM9Bf5hoH4+YZwWmevoJKQqdgVndkbVT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mv//tASzAxSrNPXxJT1oGXaHYldVxC+/iHKGRqky9XIBWRr7NR8cZAhXB9Xm?=
 =?us-ascii?Q?SQoHPGV4Gi4+eaL8ClXdL6BneHHEOZkVlRnzVqBsgM37Jo6yzmCdh/b6/uIF?=
 =?us-ascii?Q?ZztC6GDfa+frQOh289GrG+hxgNjFrG02om8hbiIpVivsHhFa+kIMf1aZQDuJ?=
 =?us-ascii?Q?oOTf92LoKWRgggO+OsN1Q2RzTDsy1zRSijuavlUoyUoVvSUW/CxuGRmiDfeF?=
 =?us-ascii?Q?dM15wyN1Lx02RI+esxkO8AjXSobuFCTJaO0VULpY2r0bxTZ8btkLzZ5sr1pu?=
 =?us-ascii?Q?duSD6OzS8Z4HrV3iClFnCMiuIs2JiQf68meRqpKAMrQ+atWvHhePOcUYCcIy?=
 =?us-ascii?Q?UcmZfvQ24ktuEP8tWLhTcg1ip84dCqNFvgbbGOlDRXA0GWN73kNuznKVRbzj?=
 =?us-ascii?Q?xgOYUS3Rf9G6fqptNzONt6DneKqy3VfoJuFdu0a1T9LQqj9uq5wiA1eShrKV?=
 =?us-ascii?Q?S6k7xwmX3M791JY05dHxVC4ZlgAB++Dw0jJ8t88rr2Fqr4t4GsZLowCs4MVO?=
 =?us-ascii?Q?HSEEtsnkJi7WNcpEVMYtFcaXfQ6Vi1yaMbsjBOaMrUo1tgtgfqXvrwc9UzZF?=
 =?us-ascii?Q?GGTiKIG0tSr9/9c1N75d+Nn6GEJG2fGkeStNTWiMtHKmpwl6XafdKZFchIH2?=
 =?us-ascii?Q?SqcsrmHwCcmsw2dPsKRZbVJDQUp/jB+Tak573RUuo4K04puRpkuDTm3F+f2L?=
 =?us-ascii?Q?31FeC9o2Fbm6bPFBCRkwm2Lf2D+NXDJekIjtVUjlBlMaCAOfJu6hMKvKtGhJ?=
 =?us-ascii?Q?BaoFxTB9vb8LFR9AuzKW/awqOG2IUp+f2YwfAht1q9tnz5mk699SQ2qAkZuq?=
 =?us-ascii?Q?b1T6TkdHeCGkAktgMixMbk2GEII+ZQbRAQ0TpqTLcRDueXkDdk7IsIq5ITW+?=
 =?us-ascii?Q?V6GN6DsRYytSy5COj1xg8gWVxMMChcCNmTxlmL4z4Qk9jQewffP1sNevrHsO?=
 =?us-ascii?Q?e/VdBASXDzNhpS8SAODzkEgqlXejSj1TODcHOkRYDFzY2zmoDnYSj/1CDxEF?=
 =?us-ascii?Q?0cQCC/u6ALlUZiTQpIv5llunSot3iVwgCOBMsko9ugohUnHEUKJ9EZ5NQZIC?=
 =?us-ascii?Q?v5foCGOzySFI4bJyjIeAVhn8jzTuDJYNPg3bsPEOuzLY0KGsz3C8nLXjCWFD?=
 =?us-ascii?Q?mMdkxijg5XNqDWz8DMyuwE5cm2lvKZh3CnoQfZalW0DQ5i8Hn09EZGhwlpFY?=
 =?us-ascii?Q?hgx8ArJe84GnVK67lC1O81nIH5kOg8rwRaN/DUm+uYtH32ZKFded6WUSgCpp?=
 =?us-ascii?Q?VX7XEebh2mrD5PCX/VXLMEHIRnALO0p1jZZPdyzR1uXfJzmeUPyGWVJjIlEK?=
 =?us-ascii?Q?GYWZilu8OfkRhm/89gvlr/B8AJVm0G7UzG91bCV2jnyKWkNKCNhrBwGqnLqz?=
 =?us-ascii?Q?kCW6/asin8A//6TGyMFahtRDN5lPw+J+LVjnVAIvaQdDoLagPGEpooQBOjr5?=
 =?us-ascii?Q?/03yT++wyjKXHVKcWSn7xVM9b+usvpgu7qaj/xgXsrEOPI8LR0dW/sq+9HEC?=
 =?us-ascii?Q?fas+/1fhjBmT1Sok8dhftfe/3qN0FNusBGthNhlAErP+Z2amf4/g/CWejf0S?=
 =?us-ascii?Q?S5Zo1CKBEZi8TusFHtlz5nP6wUVui/3O3ccsKduQioxXFVmFnlOOTvBXnt/k?=
 =?us-ascii?Q?/L26gvNof/bLvLJ14Y7KoVjPyz3Xm/m9PuMZhiskuIIoioqL4z00HJAe9INY?=
 =?us-ascii?Q?GTSbSUnJf5YmLqFfsByW0rC8VdqE2aYoG2DqeDYLtzCvRjx8GeQCR30ZiHYV?=
 =?us-ascii?Q?H5KHT5qujA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c12bd65-29ef-495a-350a-08de7348bc04
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 02:02:16.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+OxurnaxUlfN4joCNCMv4wLvr8JnQ7aGoTHzS69h9hNJLeTilNp4qiLG2/sjc7o2LEpGttBRdHPcYa8kbSi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF027BB0053
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71575-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 70E41180CD8
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 08:40:13AM +0800, Huang, Kai wrote:
>On Thu, 2026-02-12 at 06:35 -0800, Chao Gao wrote:
>> For TDX Module updates, userspace needs to select compatible update
>> versions based on the current module version. This design delegates
>> module selection complexity to userspace because TDX Module update
>> policies are complex and version series are platform-specific.
>> 
>> For example, the 1.5.x series is for certain platform generations, while
>> the 2.0.x series is intended for others. And TDX Module 1.5.x may be
>> updated to 1.5.y but not to 1.5.y+1.
>> 
>> Expose the TDX Module version to userspace via sysfs to aid module
>> selection. Since the TDX faux device will drive module updates, expose
>> the version as its attribute.
>> 
>> One bonus of exposing TDX Module version via sysfs is: TDX Module
>> version information remains available even after dmesg logs are cleared.
>> 
>> == Background ==
>> 
>> The "faux device + device attribute" approach compares to other update
>> mechanisms as follows:
>
>This "faux device + device attribute" approach seems to be a wider design
>choice instead of how to expose module version (which is the scope of this
>patch).  Overall, shouldn't this be in the changelog of the previous patch
>which actually introduces "faux device" (albeit no attribute is introduced
>in that patch)?

Yes, it's mentioned briefly in the previous patch:

"""
Create a virtual device not only to align with other implementations but
also to make it easier to

 - expose metadata (e.g., TDX module version, seamldr version etc) to
   the userspace as device attributes

 ...
"""

The previous patch doesn't provide details for version information
exposure, as version attributes are just one of several purposes for the
virtual device.

> 
>> 
>> 1. AMD SEV leverages an existing PCI device for the PSP to expose
>>    metadata. TDX uses a faux device as it doesn't have PCI device
>>    in its architecture.
>
>E.g., this sounds to justify "why to use faux device for TDX", but not "to
>expose module version via faux device attributes".

This provides additional context as suggested by Dave:

https://lore.kernel.org/kvm/aa3f026b-ad69-4070-8433-8950e5250edb@intel.com/

Dave asked:

"""
What are other CPU vendors doing for this? SEV? CCA? S390? How are their
firmware versions exposed? What about other things in the Intel world
like CPU microcode or the billion other chunks of firmware? ...
"""

>
>> 
>> 2. Microcode uses per-CPU virtual devices to report microcode revisions
>>    because CPUs can have different revisions. But, there is only a
>>    single TDX Module, so exposing the TDX Module version through a global
>>    TDX faux device is appropriate
>
>This is related to exposing module version, but to me "there's only a single
>TDX module" is also more like a justification to use "one faux device",
>which should belong to changelog of previous patch too.

The previous patch already includes this justification:

"""
A faux device is used as for TDX because the TDX module is singular within
the system ...
"""

>
>With "there's only a single TDX module" being said in previous patch
>changelog, I think we can safely deduce that there's only "one module
>version" but not per-cpu (thus I don't think we even need to call this out
>in _this_ patch).
>
>> 
>> 3. ARM's CCA implementation isn't in-tree yet, but will likely follow a
>>    similar faux device approach [1], though it's unclear whether they need
>>    to expose firmware version information
>
>Again, I don't feel "follow a similar faux device approach" for ARM CCA
>should be a justification of "exposing module version via faux attributes".
>It should be a justification of "using faux device for TDX".

Agreed. I repeated this information here under "== Background ==" to give
broader context for the overall approach.

>
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
>> Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
>> Link: https://lore.kernel.org/all/2025073035-bulginess-rematch-b92e@gregkh/ # [1]
>> 
>
>[...]
>
>> +Description:	(RO) Report the version of the loaded TDX Module. The TDX Module
>> +		version is formatted as x.y.z, where "x" is the major version,
>> +		"y" is the minor version and "z" is the update version. Versions
>> +		are used for bug reporting, TDX Module updates and etc.
>							       ^
>
>Nit: No need to use "and" before "etc".

Thanks. Will fix this.

