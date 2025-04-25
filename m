Return-Path: <kvm+bounces-44253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 589CDA9BFA2
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EF2D9A452B
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04E622F169;
	Fri, 25 Apr 2025 07:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kikGPpAG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AD51F4CAC;
	Fri, 25 Apr 2025 07:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745565599; cv=fail; b=Z8ZtwFWyiQi3YayiWZIitAZgFnYUbl9RuawA0ltW0Pm1dRdx+yrd4aAZn83H3c1zYn8/RW9DCBidRyq7iJar/ZE+lUVvXRHGH6+nJplzep1qP0G9/Qd9MOm+oclsb2DbwydRzxFB5HegywSBa6VbDlR5xdnp6mOj8Q6CRQiM5lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745565599; c=relaxed/simple;
	bh=QjaZLyVOKOYFY2px2j9TElAPoR2oah8FF8VcAwYAF/o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UrjMTnfX7MvdqxDfwTYzdJau2ys6DeqpoYJR2n5IDcqqk2N8nnXnOSzit3mbdF8nDhilqATn5mUwYeXhtJ04DZk38Ri+rE+paeKSwwe/XH951V6oQZWp0/hLNWXDPj8a6P2AeoIR65xzv/P4N1pSRE/ndiFB7v2wwO2Ihdpzc1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kikGPpAG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745565598; x=1777101598;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=QjaZLyVOKOYFY2px2j9TElAPoR2oah8FF8VcAwYAF/o=;
  b=kikGPpAG4qCzREgRB+TeQaRaZNcl57hQqP5KW4WOZcFd7TBiy2g4exsY
   ujyVD9HWP9yMcrkCQmGm4vEZuHytpgy2H6Alnh0bR9/1HKohABJqO34xJ
   CtUdw+9mwokucNIR+WULrXnmrFfAzQcVqdM6g9Kf15tuutXNwlt8rfySH
   bGUdjW/MGQVDeiL3d7/6A8YrCz4HZRZSlMRux0J7VQ+4Lr3yt8tBei9bi
   Bn2RRCdg34sDztvs3OrGrYs8jpTRoRrhuAUMbTorPlnD0t4Sa99ietr8d
   lCv53+YcondQsvLCb+6K3JcQRrO4r9ZCyuDuVkea7udCpWT8rWoCtqQoU
   A==;
X-CSE-ConnectionGUID: Ca7cAWv2Sw6goay08503LQ==
X-CSE-MsgGUID: g9XKWtycRNG/727SKnczMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="69713447"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="69713447"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:19:57 -0700
X-CSE-ConnectionGUID: gGakESNaR16W58ou65ZDQw==
X-CSE-MsgGUID: mbi45zBeR6aSzeRda/fnqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="137638437"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:19:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 25 Apr 2025 00:19:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 25 Apr 2025 00:19:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 25 Apr 2025 00:19:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQp38HDRLrEFn9sShIRhbfbuouHGywm5Y+4XJ7ONi4g/ihr5NhCYoJKWurH8ygxMPXQWZ2omdFI7Yy0P9QqCgiiNjy9IHmm72amxyv4oX6c2HgbIzwx5uwX2Q2dQgla+sqQz4AcV/FQu+HBCOVuF74qriuzhGjsTlKBnS8lyLOAv1fk0HxEBrizQAVcD6Uaij65xP20l84GeKCHs/LFS7/kTpAV6fVqPNRP8iGHREckiJ95M+wO2cJU/jb9llvLvzQMMPsj2inThBByWitYuA9kR6MEM7exPoX0Bm/JH95turRicHcCJ1KK+aTMpo10DU6Bx68HF9+lU+EOMhhaNTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAIXXhNYupggpM38tPuVQnEJFaIz20mk8Sz1IvGP12Y=;
 b=vapYF05jVLnpjzaTEYloZy11ISVVOu3zLP7/csLaw+5VVPBdKXCeSPlt8gyNV8jlnrGK3jcxAYdWN9eJUsfHSuKenH7vAH3LGhLH8dX9/9cA07SZdDoXa06Ks4IZFOMVoF0Gm1nZV8stMhOoV59hfSIroZ4CJx9mW5QfNMQZnDG6Y2bVTaOqu8Ulc5rlnlIO39LjUcIh8u04LvFyfWcSv8T+0KmKcyMa7h/b6mil3hFPj1WZWACSzLAV5UV5U5RwVz5O00zZIVGyWxqyKtDlFTw5rIqDBk4AAJeVoFPEAnRV2CGRh76nejfpfA5yR4L5uFSu+sCilJUlTOqFdRVWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7202.namprd11.prod.outlook.com (2603:10b6:610:142::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 07:19:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 07:19:52 +0000
Date: Fri, 25 Apr 2025 15:17:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aAs3I2GW8hBR0G5N@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030445.32704-1-yan.y.zhao@intel.com>
 <8e15c41e-730f-493e-9628-99046af50c1e@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e15c41e-730f-493e-9628-99046af50c1e@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0047.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: a0bbe5df-5d66-4b98-5a07-08dd83c9924d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JZ3myn3u1O5EKgvytrBjuI4Ou8DzTKGNMu/MXHXnIMB6Gd7yaxL8G1P7Bb2U?=
 =?us-ascii?Q?3OAoFTjeTgDQ6Nx7nNU4DllBhN/VbDK2EeXiZn+EPXPRRObyH5DJrQJ1xN5y?=
 =?us-ascii?Q?Y5iAXl3cZmRlqG26wyUl/J3AeU7GPsmt1QclgeOdqmnkHPQWN5OdoQFjbrCB?=
 =?us-ascii?Q?OgupZI0tgveiUFCx4fKwJ7jVwBWzp8yPGq2/qVmQaavvDz30vm3ivd4sVT4e?=
 =?us-ascii?Q?RlMoiurTn32RlIXL/+Mn7kYVmZbCwcpCshtyUDPIuoaHzpbaLdi7klCq2mkT?=
 =?us-ascii?Q?ITmbARKdOT0EsvThcEF1/rmWfq29ZlK6QX+QVYDz2Z34yW/vIRo2zR4R4FKM?=
 =?us-ascii?Q?uawLtBycPN0kLhIZ3AM71uJ5vkApF0HHfuth5bBy/6cH5vOLnEsue3hBfKVo?=
 =?us-ascii?Q?XF1HlxgZsZn0Jlb9KCFworj52/xyRmlD0lqSoNgJ9zcw55ymXCgY1tcu7dDd?=
 =?us-ascii?Q?orbPXsUV5/zUxLHKgrMvR2uFYoLJh+4EZ1Q1eSiHFrqcunA3bvFcD2IvVpFH?=
 =?us-ascii?Q?8YxjZ8yh/G8B+EohPe4s0JDPAnG5AIEd5way+gJOV98I6/M159Upyf+V/hRU?=
 =?us-ascii?Q?rl/2Ydzz2NpkVCwLWXJ2DQT4uEntor6NnpUCuRbjXfvgw7XpXHNTnEgCuR0K?=
 =?us-ascii?Q?v73oj94I1xLyTvaRGMO3MHusrok6ToXHiqObbgAvA9otfqAsoQ1wS1KJsQOw?=
 =?us-ascii?Q?B0vSuISLpQLaQ94JFcap+GBuB38c377LDh8k6V6t5Q5ltIq0glnhgxbENhBq?=
 =?us-ascii?Q?KDRRebcY3eE4g7kvYl7zw5NapxxamDLGvrm4IyfgNZJ7h0JNS86c1qYQOMiN?=
 =?us-ascii?Q?BRAeYsp7jeBcCYsZCuNU+IAjub6zzj3OCPTTuUP6wwNJ8aTHYBJmL68gu2mM?=
 =?us-ascii?Q?ULMoIA8esuFCwm4GEgD3g4EXDNW8yW9fpzH4bqMZTCtRflYsPmCWxdpSruyB?=
 =?us-ascii?Q?uvIK/D01eYGb738qdsYUclS5LV/eCDSbymfacw/DipApBCtO0y/dOchULz0e?=
 =?us-ascii?Q?F5Unq1HsryecrGimIU4ybno3rJHy7Lr3v9Nrl8ttgQtt/d73/whZEYvOrU7J?=
 =?us-ascii?Q?utKso9hdrtHjARvquTbJyBXQVmF5Gk0neie4ESRta+/b6SyxkdMQPLUIFFXQ?=
 =?us-ascii?Q?7Oj0KGUVAtdMH5/gWeiZTeWt7Q62S4WLPwUVpDEd2D2xYVsvBbsS+x7+U05L?=
 =?us-ascii?Q?oZrL+N5DI0Hxff3HgSYOf5cp52Uu3d+4bHMNpOVnqd0v1R+Rl6XnR5VqSrQP?=
 =?us-ascii?Q?LuUmb1B+MMchwAAWwM+k5SdZmfhSJvspHBvpMZXS4o85Vvz8Bv4tB/yMmbzB?=
 =?us-ascii?Q?9h3zUhGUcj7YyQE7xnBeJtwgHCF0mJ8+HXZQWk2XYEAt8yXxvJevZS5GmpBK?=
 =?us-ascii?Q?IepexBZDWG2/X9w0Bj9RdWzSJMOJJPv6N87qEiVZSXWG1JX1TXj5Y9BQIYc0?=
 =?us-ascii?Q?UiLIm3PaUwE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iDso+IauB+UkGmOU3ihMqTkkfIWsNimywu50yxNYRdB3nrNqtHf2xM5FGZn7?=
 =?us-ascii?Q?sYBP1P8TR5MkN81j8APT4lDKFoIVzpworLsrDs/VfPQ9D/afwnDHftgtIBbZ?=
 =?us-ascii?Q?glm7+zIVhLS4Gpe+7DooN6k/9cemNFwsyKMmGDNCU9T1iJC/TOOQsZ7pBjie?=
 =?us-ascii?Q?bHzrdiUh9i2xKfnCVviFPdxlAMEvdRXEuG3aO4HpZ/Jdbn3ELrm+xgPpK4KP?=
 =?us-ascii?Q?IA3xTNYTcbu/hCsf1tYBONDl6P5fmlhlx7NvhQROVh2tagndZ/f6orUzHvlp?=
 =?us-ascii?Q?11E3bqxfZ3dyK9jExb99/eauNN3EQJ90a+nx6riIPEvZ3Vlf55KIaJbYERzu?=
 =?us-ascii?Q?pRAjF1J8hk4RyIwTykV/VV2sgQeRfeOML2suXzFpxCJDRDgThzzZuS1lY2o5?=
 =?us-ascii?Q?xaJ16ijDVtV2kKFSsGfv/31Y7uTLZ3jqNp7FfxRNq1dU/lFfEswVWkerWNgH?=
 =?us-ascii?Q?hGqj6/Bl4K1FicorBjvyZBJn/ETEK620VGqg3ZxcJxW+hAYWEPKSPIycvMIG?=
 =?us-ascii?Q?8rEM/GSirlND7E7U4glJ2fcrLk3znlwLRc82U+Rjvna1Jy/omPSsZeTo90K+?=
 =?us-ascii?Q?d0H4il8Z9myHtNkghYpeJUtlnMD3F95VVY7Q/b/hQbKee+lKC01M5bwwhatp?=
 =?us-ascii?Q?iNCggNZGqfvxOtuwVww40snAp59mUjL9U+Nn726Cjd+kqQH9zaUv5nPVJLJO?=
 =?us-ascii?Q?DymDO9+9dSWAwea0dgy+FmKIYo7HcYt/7u/rUo8WxVTgbBh2RXlcy3kk3kNE?=
 =?us-ascii?Q?QHX2d8RI5nv1oRMSXJP3+WeqYR0NWgWSPtKDNtKzR1PQawVYzMrr2xR1bB1B?=
 =?us-ascii?Q?FQCEcCEbD/p75VbDgtsMcwVIwJAkULGooku3hc/EEhuO//FIbEsUrWi2auwu?=
 =?us-ascii?Q?449v99vT+QOWoMm7erEd3zHVpijrjlQpRH3OHIdCWrANWSMznzj/90Jdqopv?=
 =?us-ascii?Q?TxPUpDtsasUA8HCJJo1krXDPVGqqvLBgA4dtX9z/wBOJHXYtC08455ewHRn+?=
 =?us-ascii?Q?si6qNqgBohEwKiLcd5i8kwGXJBl+yME5BZr0lYzJIvcBchWiQ3EzzydqASTt?=
 =?us-ascii?Q?WSHm1SDlV346XNo6T7SFUos78hTXLwcTrDxE0kyhMQNTQsNDQtys8Gigx7z6?=
 =?us-ascii?Q?ABNvuKJ8ytQvkhDwJ+la7EXfvd+IXYYFSqc7Ix+pjpsNIxd27Vv+c7qJdjw/?=
 =?us-ascii?Q?Wm5EUhHm1vxfrz89oM5qB3ipiTx/O256bb51FGB2sZCrQtSHKff790IEu/ch?=
 =?us-ascii?Q?EooXpu5JMzMbVspKoS7kUuMzY18ouN5uxeqNTL6PJ/aPUYc9E4dKDGQrtNQD?=
 =?us-ascii?Q?oIG7UV1jqfMff+nKbYPPNFzhpXpy6edV68lZbhbiymE34RWeGnebTZSawHHO?=
 =?us-ascii?Q?6Al1WMdBG3nkvB3W4EBnfamlUwPffSbdeHVbH1HgyoAtwH9+KB7f+FtLgrwg?=
 =?us-ascii?Q?pZU/94AB1dR0jok/xH+rbi+vyYhR5KA7n347SIXWGv0H2IB5Khmqx6b05D5E?=
 =?us-ascii?Q?Tk9rjYdFmykkw3hHTig5Ajw1ewc77PfuqJdUZn2MsfTxz6eIuMfbBHLTw8XG?=
 =?us-ascii?Q?Ta6L28gztrwIQwGRRF6JD0KH4r4vJ6aLxkufoNqj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bbe5df-5d66-4b98-5a07-08dd83c9924d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 07:19:52.4284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLqlAgfs42sWI2jwtQKzbf1BFBysx44KkHn7mbnI/lanLUOgpcbyhJ0VkQhYVTkxCRRF8/9hxTGxXjJTGgixug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7202
X-OriginatorOrg: intel.com

On Fri, Apr 25, 2025 at 03:12:32PM +0800, Binbin Wu wrote:
> 
> 
> On 4/24/2025 11:04 AM, Yan Zhao wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
> > to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
> > TDX module only supports demotion of a 2M huge leaf entry. After a
> > successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
> > non-leaf entry, linking to the newly-added page table page. The newly
> > linked page table page then contains 512 leaf entries, pointing to the 2M
> 
> 2M or 4K?
The 512 leaf entries point to 2M guest private pages together, each pointing to
4K.

> > guest private pages.

