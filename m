Return-Path: <kvm+bounces-54777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08CABB27DC8
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA99DB6340A
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 10:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996523002B5;
	Fri, 15 Aug 2025 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CdTPg2S1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B92FE077;
	Fri, 15 Aug 2025 10:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755252162; cv=fail; b=ZOqdd1/AJGPEIxCyqh958zDOy89RGwldySb9p0ol4MErmG/i7RCA0NUsCUar6fTuWHli8FrjUCN1y8SZr380Ws88UDkgbPat7WVW2cjnx6j0bLEBeNk2o5oWS+dBnJCl/GIq4XVqEmdyX6djmVDqsqhQ6er1l+L4LGf8Jw//YAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755252162; c=relaxed/simple;
	bh=Hv9iqukHY6tzHtneokz4Xig9YXZNwdQdg41AiitT38U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dbRObYtDqJ2B/V4PhqNhcrVx15C9tk+MyS7XOKBarB2vIpxox1mx3i0BauD9ywZhnvVM2kWrqarcRCj/zzhnprh+GYTyZmaJ/gCMVxp2rRjgA0ZnxYsTVvuHawRkgtBcox/y0NCW0I1RjtBbSaWsZqUJL0MHE8dpFQzp7fdTChE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CdTPg2S1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755252161; x=1786788161;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hv9iqukHY6tzHtneokz4Xig9YXZNwdQdg41AiitT38U=;
  b=CdTPg2S11UG0k8XhXRgPiGMS0hHFfbWgEsBQrmoIdKw+aTUX/Bbz5a7Z
   dBmbKGgiZ1vZQepLSJLYThzqgeg5hS9faOWgO/bhA1ZK2zS+bg2RXf05j
   5tKPHk5cs+WQ5fmP6cCfMCCrAfpTFSNMNoHHUo8PzOXt46pTRTJjfYyAB
   ENUrzVaOzSBn4m0t8a3A07KN3zJYzmS06brbQnmsUbVCe9NmfIRBD4t1C
   b8xgWch9zTgbcDIjkgUgasy+UdrTVMutISABCfYvVI0oec75AiAOLi2sD
   AipVV2qhhJtiQ5k2d52YQCDJaqePNbEMXyq7uQVpcil3vhgWmCjBv7FYc
   w==;
X-CSE-ConnectionGUID: PGa/ZBn5ROCA01bJSrPu4Q==
X-CSE-MsgGUID: wqPH0wSYScCl24Qe6XT23w==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57650655"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57650655"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 03:02:40 -0700
X-CSE-ConnectionGUID: PYH0gkPfReqJqeBOW16kwQ==
X-CSE-MsgGUID: UEyMbDLBSTKmSvkL2uQ8oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171228684"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 03:02:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 03:02:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 03:02:39 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.59)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 03:02:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJkZSCwu6NlOG/Z7pcW5dCqQVOXaNU7IDrwxPOUB80z+SG0Z+zmDny7Layq0U2V+kpmqaYk1+zMYOC3BtvunZG6btRpIHF3y108fzc/hOPJYL1K8n2wLiss51aVMH2cBiSOOalTWz+/ZOpqz7oGVaLiGgGpbyz9T/zXe4xqRBdOxmE0Pi8YGUjCI1OwGn2vJTsv6MnJ9oKLuo4oMPyDOev+EL7QlfZY2iOQzombPjJ9DNeUW2mS7tDiIyruEq2gX/3WWUom4OxgkQpqv/U/OJZCR9feMhXE4T8CF3DZVGmwWspqjwyMYA1uNkk4mgFpbbkP28IKyunt9lB0EX5SH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hv9iqukHY6tzHtneokz4Xig9YXZNwdQdg41AiitT38U=;
 b=Uy1tipqyrNG3AAUHaD8R9n1cvdq1ktWKoXb22T9aR6Jc0OQFk5ctaAVlBr43tpaHyzUwtnha171cgRD2KXisvHcRdScDRxxS/gSI8j2mefLrs/ib0/w+jr0bpwB7Wjr46DdFYrYauChgqbMrxzoiO9764ohZK2veEB7MdxCNWQb0V9ilyETFwiHsbP6gVTfTC14c6u1qWSYHQhz+2zcXjwegI76/72nEclYcc5CntuopfQzJpY+a+5WZZGN8KcSsuR7JBlMJdm8u6atcc703lZ6ttgF66okRBuO+58HRTYeMRprl+Z9bt3YA5BjtNbmwCeuqSXgRRistO8h1IWossA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB6741.namprd11.prod.outlook.com (2603:10b6:a03:47a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 10:02:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 10:02:36 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "clg@redhat.com"
	<clg@redhat.com>
Subject: RE: [PATCH 1/2] vfio/fsl-mc: Mark for removal
Thread-Topic: [PATCH 1/2] vfio/fsl-mc: Mark for removal
Thread-Index: AQHcBvQm63fpzc7YcUSc0W7K1eRUrbRjiXQw
Date: Fri, 15 Aug 2025 10:02:36 +0000
Message-ID: <BN9PR11MB5276782AE431EEA712387BA98C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-2-alex.williamson@redhat.com>
In-Reply-To: <20250806170314.3768750-2-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB6741:EE_
x-ms-office365-filtering-correlation-id: 03857ca4-06bf-4865-68e1-08dddbe2dc70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?dw/4AAhDkq94rGu06UPT0/C1DRmTHCf1zE0hdRCO4pbALMFC1sKHpfVnAFAJ?=
 =?us-ascii?Q?hmyiZyVkpS05hD1QSsdyNdqvLZojB6PqwWiP2ohhP56F0WL1dN4kVdPwv8eg?=
 =?us-ascii?Q?CLDBv0J0VQQr7mZF07NuItNEUssjF9olXEtaGG1SGmjdRa8v3XexuyVpx0vy?=
 =?us-ascii?Q?/hM/eWSLJY2NFnGUerU4a2OZf3U6fPsro7eLkPD5E17EbiKDbqcxRQh8VkQB?=
 =?us-ascii?Q?lUA7fESEg2DCXuYHxIXj0Zf19npsOTChFKivdk38KUPLJTBzRG9IAWFTFU79?=
 =?us-ascii?Q?6Zisp1LM8Zx/Rdo2pm74pNpagk9vFg3Q3/8H3ihQyOupNEex5TEwb+VPFoxp?=
 =?us-ascii?Q?bH4HmpA8xDk2Q7iHBEWe+XcZ//FoY45pfmk2opJ7z3dsDyDQG/ZCz7a6heKC?=
 =?us-ascii?Q?xGxf9b41I1helxeEZOfpZbx8sMyr7WZQVRoBjvinONk1dZpLGEHXpH2mcQ0Y?=
 =?us-ascii?Q?MXoWZnehQZn1wZTGtxc4FIb2apod62l9369JaZxIQ4jbcZE+2YNxffQwmMJd?=
 =?us-ascii?Q?rlqBySuLM9P+3Xl7pzk1PkYoSfIcKVAIglL7P4JfHT+UBoq2cBoHoEqJKM+G?=
 =?us-ascii?Q?+k0c83lvXKSYe8cAcXScy1On8kwLWOsya4vcXxsfRMg+2XHd1+D/LWgRPCPg?=
 =?us-ascii?Q?u0UHFSQQkD7iRvrrkC57J+JFYyNt0LGHc0kWEVuNFS3cjkY3FEb0Re6yhvVo?=
 =?us-ascii?Q?+T1ippcBrBBeN1RVVxfFOWKOaRnAyqYB6DOfg9y5ZdPnXutFPfKJ9hdMCxkf?=
 =?us-ascii?Q?AS2bXGliSqROHsdT5za91X3DODFbi5aifBzPRv9G4Qo7hJrQiReT+Z/VczVT?=
 =?us-ascii?Q?cp4JkWIQk4MyVKW/Fr81bNUqlCGzF2M5mNq8Qj29oP8JJmQH8Z9zfIMYRFj8?=
 =?us-ascii?Q?zhb0C7ZA4eESuoMCefDQivo7mbmcs1l3Rsutxc7GKKjE83TPrxcM9Akxda+3?=
 =?us-ascii?Q?eD7hXQPpnfD9zb0stJnHlFVnIfBOtWJ+zMtH8n5YIZgHAHHX8QsJztZpenMB?=
 =?us-ascii?Q?6VwF8qAOs7YqWJeTg+WBv/rec9LWnHwUuxJJ6B9nlnLoXp4DTNJtmynpF6FC?=
 =?us-ascii?Q?pi9J8gDJ32eH0FaWBYq9AlW34Ir4ZuE4z7kb75sPRCLkG24HotrOeIWRK6sX?=
 =?us-ascii?Q?2FqtBTni+EHvoByEl2g0Cu9ctsV91E2H9ZAIDOWI9ED0Tab/nr2BmaYjs6bk?=
 =?us-ascii?Q?udxMrnijjnoH8h++uN8TZdRBU91wlAtiF/0ELCtzksU7UpQEiQ4luJnTdvGV?=
 =?us-ascii?Q?aywxvhBBaRkb7Z1PTR7l/bzi6XT8+/SVShvcmEiGZ+58Ts5rDREzaC9w9YF6?=
 =?us-ascii?Q?P4fchEqTHbPe3qo8ucnpkDwcUzkd2dgDbO9NclVY+8JhpQXjMpZWZpoUljjC?=
 =?us-ascii?Q?jUd1sqlgTsOJkVu9FgLZ9HV/e7uTvIHhZn3FRPtwi6aw6lh01BgRM8sdx4pt?=
 =?us-ascii?Q?l/RiNNlv0drxuCbwYBvj3xIuLU6KR6Dax1ZmQi2ZCck5ZsbA1X3xOMhEq/Ps?=
 =?us-ascii?Q?TLYMDiylkQPs2Ho=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EI4ZkwtzykRLnFMBqCOmk0AryEerZbv+71dKZJJ8OpsvJHVDimlYo6fX1/wD?=
 =?us-ascii?Q?tOd/JoRxY5k/OIdQO8ct5cun/5F5YbNS8SHP39uwCL/5H0hayE3MHo5liMDS?=
 =?us-ascii?Q?dgDbG9hFzPmmcN7jF+7zxBV8anMp40NbG1GXxK4Hyk+wnL7bObin4m9RmuUw?=
 =?us-ascii?Q?/1S2ujLO8/g+fE2x0dmqy3wgX7pnAKxJiVFbIZoKoS0T5NKlmt4NX2EFL+mJ?=
 =?us-ascii?Q?pR0hedaepp68JMZtoNK6bTCZlRgT4aaGCxlWztIVDn8X2w+cFFrMIWKoNBty?=
 =?us-ascii?Q?NdPZQmmtZlRqggPebpfop6s1+oh3aWvVk7lxKlE8xnMLjt2RbAgIMJzwWlp5?=
 =?us-ascii?Q?50xBqczPJAXT63zwY94QaGV7NBrrsOnUkTxiSHaKAe+aSimHBH2hsah1GMTy?=
 =?us-ascii?Q?c3nmd1FkfsBmEyWFrZ0VJtFdP0Gsw8hr81MHhaLO0I5Yofp4Pk8sD9tH4elC?=
 =?us-ascii?Q?ZYP9vbpSQ9A2i3JqNMyEPURY/KeWbkWCr+6Gc9AaaMCCMiQIsLMlUcI/LqrI?=
 =?us-ascii?Q?h+9MplHfU5Vs1oJsD/JhlOPeuSUpOMlLSRROcbHPj5ATJI1EcuMdnu9UDVSY?=
 =?us-ascii?Q?ub3MK/6wzsuk7eG3u24+UtQUEMnT7JyYHOY4Rx7ZFFnNPegZ1oVfhAdnENZj?=
 =?us-ascii?Q?21c7HNH3kLzPJr/+YIXPqBPL3gpEUJG4hOwLQkAvLoXutlaN45OaY6+wVQE1?=
 =?us-ascii?Q?8tiN5iVgIbdYTcj0cJVvmPGNCqL4nE7v1FOqQv79pEnGNblFRg8n8tZGT1T8?=
 =?us-ascii?Q?lBmI8qnl0RTCpxI5+eKkRaqZNd9Rq+oDGxw8wKQmeYP3+Fvl1thveh/ov4Ns?=
 =?us-ascii?Q?tZqmLJB5oe98/oiLjCQuo8sFQLUJL/8N/DQW2oR8fXvayB3+K+nxlzOC1XDk?=
 =?us-ascii?Q?DPnL9ea55VjZAqS6ASt/n++VgrO/EBdCyhCyt74Fesr9uQ1AD9cL3+dmjJ3A?=
 =?us-ascii?Q?bEq0TDJYCq1S0fNHADO91Q5XwIOYtbAYnQMjU32WrEfAaTZL1bEfMzV/CrW9?=
 =?us-ascii?Q?HCqP9JFyqNlzNsanSCoT9t3iG8+rDT8W/8fFwaaG2aIJs2RJoxAw+fj//YQC?=
 =?us-ascii?Q?e9nQtRbKwpL/xKSOf7Lqr+hQf2EErOzq8D+SZjf5DwWsX+xJZHQgHTdjRJfI?=
 =?us-ascii?Q?qQ+iOvHkSpN5cpXRmxd9y9HQ2wJnmME677lvvhMeMLApyjv3w3KT9T+6BWv4?=
 =?us-ascii?Q?8JcGmnp8ai1n0G3po+5/nSrrAW3tlYKh7jmY/6YjxI0bYitIHD35qnSfrnSR?=
 =?us-ascii?Q?RzUCGCh6JdZ9vLyCMQ3LUm/OFL1y9f4SZa3GGvqcmfBmEO9ro/SvrKFLNFIq?=
 =?us-ascii?Q?okP4A6nc0MCXfLXQqsmdeil/Mwlwb8O8InNF5eZFQutuf+U7ul7tnMHM+ZJF?=
 =?us-ascii?Q?aVKRvtNthERk4K/tGScBza0TSjTgY3UPSnhyqaFmlWDN3wcWV6yt8v19km0l?=
 =?us-ascii?Q?xtGwrFiahxoiOxyG/lr8bkF6mjTFIc3XOZaJ/s4B1IGUCYbi33NiyZ8RkANs?=
 =?us-ascii?Q?WofnF+kMsfHgkOQMHGzckisnrRL3CjWemQfFTtbx9fN8Eo2bJweLYUAI+oBJ?=
 =?us-ascii?Q?6AY0JgmX2a0mtOiVkaAq0Ou0pP8bLXhKNjrN00ZQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03857ca4-06bf-4865-68e1-08dddbe2dc70
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 10:02:36.3770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UQ8nuN272hgdHn0NqUX8lhST6XxImTySBDzriEFtFerKVdFbx8E/ZY9KadqMtOVDBBHVJr9w2fJSkxdheYTtQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6741
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, August 7, 2025 1:03 AM
>=20
> The driver has been orphaned for more than a year, mark it for removal.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

