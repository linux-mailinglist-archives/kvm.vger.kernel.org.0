Return-Path: <kvm+bounces-37830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A6DA3068D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 10:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B8DC18850F4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A861F0E4E;
	Tue, 11 Feb 2025 09:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RvI0SmGy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42F26BDA6;
	Tue, 11 Feb 2025 09:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739264428; cv=fail; b=uznqIDUD41tOWkWwn2Rm5P3dyZxmBr+HiNZQEo4tM4THkOJZfGqH6DOzjY04AjKkvqv3N2od2L7LPPnr4v0Q9crbneKsPNBeC0lwtSH1872S+m7C7E/kQ+zFh6yqRgK/8CUYguWGrMcTO7L1OjoVbxMKMNb34wr2Pn6SFXema1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739264428; c=relaxed/simple;
	bh=+xQIrUJ43gT4VaAhBMEAuTybQ2C/pieHqfDBEQXj5wc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OdYKlh+c7yPl0tiyWzzaWmGebwwDoASZnZZKydDkuVooPDNs9VmIguUEipMIsNnjkHYJs5kP7+z4fU/IImV184TdsYOguya5DtADgnz2Fb+HYtbLcTvBF+Qb+ABFet8MqUANP6nC+p+e7V3H+zy+FHZ3bRHx4pfMR+fHJC0GFUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RvI0SmGy; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739264427; x=1770800427;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+xQIrUJ43gT4VaAhBMEAuTybQ2C/pieHqfDBEQXj5wc=;
  b=RvI0SmGyuOhs+SgjbDprS9gMZRgO2HWSydMjydBRguHfhHpvyW9+626j
   Qw2tHBciocL+bjB9BWacZcQqlV2zKa3JoekcAqJRPrNb6nO/bxjMnqdPy
   obzhd8syxg+2ftO2ZBgF9b/mS0mF+7HKBFt8Ch2EB4itcercfBTvVM1LL
   D9Uql6OuoBMnHokbVCB6Gzpp1OKQebp+HRSLeAwI+O6HshReTNmQGJKv2
   c1YGdWkh5n6B0vpCDxytvx/EImxkhKZ924DSUWPhCXDbo6JD/L8MZ0gux
   UNgdA2MkBe5sPRS//XEmSIgPEG1GA/D/nQh+WrtRXguUd37sdkYMc4JEy
   Q==;
X-CSE-ConnectionGUID: 7sf7sr7PT+aY4CtQ+RGziA==
X-CSE-MsgGUID: mtd2P4qpQCGYWBF8tQGDlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="40141669"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="40141669"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 01:00:26 -0800
X-CSE-ConnectionGUID: LIr85QZJThmk6YU4l5BEjA==
X-CSE-MsgGUID: y3l9VWrsRG67mY8USDcn4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112914497"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Feb 2025 01:00:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Feb 2025 01:00:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Feb 2025 01:00:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Feb 2025 01:00:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wY1rOnQbN3gVSkyjhMbqsHf6QCbJVfxLs7bLLF8YgHY2/Oxs2JCmFSY2jerXEMvNx6f8N24ZjP+pIebP/7c9LlgtQYYdHajKVQ5c5hDa6G1DsoAQtddzWar8Uq/nBWBOqUP/+HKK0FiQYXGPP1qtuh/f+bRnp0Z8KIXoyll5XUWBmU7rQUqjnst27U70LhRYzbXCHGbAqeeC6OkLEnOe13oUE+Tac3vshsILTE/BjnAy21eAWullKQVPlq0nFxaxkj0sTp14rkVIJNrMzT59B1fNU1tQjOMW/qYGjwx0xMqzjmWhTfX0nuxsVd+/+1TMPTxuqVaXyekDCjpJGUWpbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbvOi9cz0sp6pfm//sOG0KdeDxdEyqDSIzLf2D9M588=;
 b=EpZu6ujPXheIUiHyTxAyX5kV4tSxtjFKOEq8tKJM1SerEmxUSrJvRR9fVstijJDWbBPobbJW1bSwzeyoQD34jJWfVedYNPi58PJJP+rrd3/2Sd0hc+Ar3/d7DYt6ZjM1fmhGP+Lnho2KKtgF5x9OL04+zuCx1ti+2U7m/lagOFGtcGdivJF+pNRZ837OtBvCJfW6jr/uFdjAoPdYLIfhn5xPwDAczZNy1BzwuFtYxdej8vl7WXS0l1G+nxuOqayJpKuYC5V4NZucamLP+PsWn6hibGRHmG7X1zfDnG+GlAxYfclwkhrpwI/icPT/KMty5jQl2uGa5Uy5mH9UsEX9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB7446.namprd11.prod.outlook.com (2603:10b6:510:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Tue, 11 Feb
 2025 08:59:48 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 08:59:48 +0000
Date: Tue, 11 Feb 2025 16:59:38 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <isaku.yamahata@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Message-ID: <Z6sReszzi8jL97TP@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com>
 <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
 <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com>
X-ClientProxiedBy: SI2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:4:186::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB7446:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e7389d-44a2-45e0-4574-08dd4a7a6fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?sflVtwh5vdR36iBFCG29lHMt08irLluvVYMdGu8EPRPFmelwRVfXuqe+DS?=
 =?iso-8859-1?Q?E3lquI9ZGMZ2B/xTopDCqucG5Z5p7+mKy+h3W81Ig3pgpyYaE5Bzj1h6Ir?=
 =?iso-8859-1?Q?IgwWodaCEzm2x5WQk1qK6sJ7IhlAAVU9/gAyfvV7FhEBvZROXwge8NGzPr?=
 =?iso-8859-1?Q?TiStUKDgp7ESog6SGnGmgNm0EezSuUCQqs7UFw3skuGC+NUOZ39jHkKf2q?=
 =?iso-8859-1?Q?zFDDdoBa6DQENSjc0Cd2ZPgoa1T34TQol6hpmZP22ZWvAgLl+qq9+KbT4m?=
 =?iso-8859-1?Q?HTjdqwhodSnislMdEO9oSyNXry7OJq0BGfTFcWDotx20leWXUx3pS9Et4n?=
 =?iso-8859-1?Q?Ciac3wrypW8nAWRw1cMs7g3JHaVm9C9/MwRYR/8iHeIgWJv6awXKQpww8a?=
 =?iso-8859-1?Q?1RVxbal6o7/m9KSVZyUeDdpJoCo5XDRKOG0hiE9WDVRBt5V9X60x6JSujT?=
 =?iso-8859-1?Q?w262qTGoS7iPz+aIMV2v8qvLoADBbNOv7rVULQQLNYeQSXqzmtpxdXiX+h?=
 =?iso-8859-1?Q?2RpAXtahJ3WZweYJ//MgAILtKG926ZZCDxQOm7iZftXtaTlqfZXE10b4ok?=
 =?iso-8859-1?Q?MRz3y3Cv+1GQRikDAG/lQRvE9vC8REWdPvIaWnALhCGyUUazzdghEkRDDw?=
 =?iso-8859-1?Q?HgQWzFUc5CBv1wj6O8sM9bV+KnF3fm+mOpp1uJfXh2M0kV3Cf6AHQeVymw?=
 =?iso-8859-1?Q?hLcoC1/yJ6ODTd1AELfUlJJYPglQ0WJinbj9Xw/fOVpRWbX+4toYsWJ3Wx?=
 =?iso-8859-1?Q?ak6Pyd2KF9TU13IhmDxge+ckgUSZViNoYPXrs+JMEFRzevCgcfOVGzlj8g?=
 =?iso-8859-1?Q?Qh7nEOihNsYcRXlW/9siRFYIixsBcwh75Dnzx2xtGPz4Yf5N7bllFmpc7C?=
 =?iso-8859-1?Q?f2UU4rOAnZHzadGIcBlnmB3IRqP3qFREphA6d9TVvPk1HF17wU/X4pcO3l?=
 =?iso-8859-1?Q?AFOxy4zyth5NCcfXFoIC5dkkg4Q1MxFBR0v38XmDMrY/sbmqtwLSLDHe52?=
 =?iso-8859-1?Q?Kb8z4Z1GHyd+A/yU+GYg1BUsgAKSzVAICTkDXimA/5k2YGFpkf/znenKAi?=
 =?iso-8859-1?Q?ayxjmJW1B/7qiUqHyMxOvxVH+H7nM0o0C8lV60H5D3nAS5jCz7zgEkeEFp?=
 =?iso-8859-1?Q?+1OS8J2fsJ1XF/YYSmiG/IUNV5f5R022pTxEx/+v4GO9IZKXSnHvxcJKat?=
 =?iso-8859-1?Q?OPCBwm69UulAZhSfDZcou0bImH+fd0LSsIG7rsln6JkaFATI+nFTcV27OD?=
 =?iso-8859-1?Q?nJxOt5a5jMjPf/iiXHgSUxvfiRB5Frjdyrus5jpqnPgTl3skSEVhPZEMni?=
 =?iso-8859-1?Q?xB+LHFsI1I1wXMWHgo6GAqcYs0CMdFpFP+QZ+fi42UFjbkiVGalb65JAUv?=
 =?iso-8859-1?Q?In8dtGd0+16C/vlN/CkT14ZCE3Gopq8t2j4aR8L4vWug/5wMPL5Cp6hC0+?=
 =?iso-8859-1?Q?x6vcuQ6gMWYsbC/l?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?5QRDRDN0N3cno7pu+KgNqQaGRmEDb/r4XgvCdfL2Y4EHvKi5JRNQBZf4PQ?=
 =?iso-8859-1?Q?vSeicKbKNZNLIpJF+lRJZAJTFrx5ajMK8XwxuAmw9s84vTfYR8QN0uZiOA?=
 =?iso-8859-1?Q?uuUOUmgX7fu5hJALj9YW318QX31OtngTy/UfWgvmlytXPB6x9xrWp4zyhf?=
 =?iso-8859-1?Q?TIZwcpId8SzuuUtcclFKTRNVL06j9C8OXFmyVifmOXYSNh7RWOSrpjjxDW?=
 =?iso-8859-1?Q?leociDVlhXpMydePfH6fzZpW/fACWkSYBIGYjxA6ukAeWHkDOq41gfHHIB?=
 =?iso-8859-1?Q?2pwo1QNF2Z8vcWwNv2SG15RgD/MQORntyR9EIUkh0BADIsYLw/v7ez19Ku?=
 =?iso-8859-1?Q?1jV4SBPe2+/btlMoxHUqX+XjfCpunDwc2oKwMHeR3rEJgOF8A4YTpb/5Ky?=
 =?iso-8859-1?Q?sUVwqzsc6U/VNhABv1qoSDtKXvfYFshLBcvGpL1HrIxw3Gz7OyP8bFT2A4?=
 =?iso-8859-1?Q?5n1V9ZTUgC8CWrYDC1lICAXCTN00wvn/NijQ1zCRNDyr8EotC46xRpiJTI?=
 =?iso-8859-1?Q?2CMkqE5HSjY+BMVfjSi0lbxvDQCHHizWm/cWb/0EDx2f3lD6GepKmy9gy1?=
 =?iso-8859-1?Q?HtjiaDHLdFtmssklp/dNIYlLYG+pdrhfCp9Uo6aranGF4oIMgvATNyGONI?=
 =?iso-8859-1?Q?CikJEhtoZaFJv9hoeD6S9at7NdNEOFrj53EoJsY/gLBzbzmc+gRrGLKQ1c?=
 =?iso-8859-1?Q?cH+k2fpIruKzmwWQz0FDaxcSZnKy/CSSU7Y/Bur+/tU/8DIXieaKfBGh1l?=
 =?iso-8859-1?Q?LREfqJYE2HxDQ6Mk+lYvjwoGDwUoEbO5/d134rO+E7D3yak0yKN9smR8I3?=
 =?iso-8859-1?Q?5LuZQ2IIKTy8Es19ZAKrdkdkFpZkxsBreC3urGDSvd9BQM6qhW2m95MQ2X?=
 =?iso-8859-1?Q?sGJqov2/kd+DY7ahqbPg3YJP/jtnY6ogguYiN6cVpRAQVeKLndq9bfLxVx?=
 =?iso-8859-1?Q?Fd1EUMSm/CNZYxvNewvi31Ad7DAm6u1oAn1UtrhBVT/SHgfg3Oq6iGVf+0?=
 =?iso-8859-1?Q?XgeS8PdOa+/lSjV355YbGGcv3E/+9esHL0I5/boRMshnssDlHxinwSu36P?=
 =?iso-8859-1?Q?lYOPMy865dtEMqUUxuZ/t4eWtcPNd9fPdZ6S/dUKfmKjhCGha2iIa0Gqbi?=
 =?iso-8859-1?Q?KdTrMdZgWiL3bUDMVHxAVOsdPr2yFh4lfI8/0DpED5Uf8NHsze1zv2MLsz?=
 =?iso-8859-1?Q?8KD+ZxEYqL1Zh6XJyDGEuChyv62C16ksix8ozXGI/wiWBXBKP9V/VMfeAk?=
 =?iso-8859-1?Q?OgPyDxjH8cUSjFv+XVl67alB/YZyXIKTvxv0+bmXjktvepV49ATqCrRkoV?=
 =?iso-8859-1?Q?OuQ2QuZTCkmFCBmH6GWaT98rBWPEIpZEpPmSxKsHZHiaINEpbjTyd4/BE2?=
 =?iso-8859-1?Q?cWjXRyFrLiXAxjdQcIpa5/PGb69SkgPupxt+vgNcAUQmClbljaZhVvhHus?=
 =?iso-8859-1?Q?3KqvBudWeHVJeLyP4GS1JCo/Id/Z4Lkx4mo1aaiQdRfDFeoyLimJtbFMFU?=
 =?iso-8859-1?Q?4FgRYx+yUIT0tmlywTk4NEJHdMABBi/ImaePZPAng5cQ/ryDRVJCAcarNm?=
 =?iso-8859-1?Q?d6fazthBlgspzdoA9f3Ux9VYQyHn75uLYfbvxYqTyR2p/rlK8S25r7wK6P?=
 =?iso-8859-1?Q?DKaBC2YNsfrEu4vZvRpqw9nkvR3SikD2pN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e7389d-44a2-45e0-4574-08dd4a7a6fd7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 08:59:48.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sMk3kxF81WnZuZ86S8jAvlzHyP6wlmtFc9E/8+L0uViuZE4uEdHoYA4SArV/DGMjYBvXcBYP+tG3Ct2orqHFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7446
X-OriginatorOrg: intel.com

On Tue, Feb 11, 2025 at 04:11:19PM +0800, Binbin Wu wrote:
>
>
>On 2/11/2025 2:54 PM, Yan Zhao wrote:
>> On Tue, Feb 11, 2025 at 10:54:39AM +0800, Binbin Wu wrote:
>> > +static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>> > +{
>> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> > +
>> > +	if (vcpu->run->hypercall.ret) {
>> > +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
>> > +		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>> > +		return 1;
>> > +	}
>> > +
>> > +	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
>> > +	if (tdx->map_gpa_next >= tdx->map_gpa_end)
>> > +		return 1;
>> > +
>> > +	/*
>> > +	 * Stop processing the remaining part if there is pending interrupt.
>> > +	 * Skip checking pending virtual interrupt (reflected by
>> > +	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall because
>> > +	 * if guest disabled interrupt, it's OK not returning back to guest
>> > +	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
>> > +	 * immediately after STI or MOV/POP SS.
>> > +	 */
>> > +	if (pi_has_pending_interrupt(vcpu) ||
>> > +	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
>> Should here also use "kvm_vcpu_has_events()" to replace
>> "pi_has_pending_interrupt(vcpu) ||
>>   kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending" as Sean
>> suggested at [1]?
>> 
>> [1] https://lore.kernel.org/all/Z4rIGv4E7Jdmhl8P@google.com
>
>For TDX guests, kvm_vcpu_has_events() will check pending virtual interrupt
>via a SEAM call.  As noted in the comments, the check for pending virtual
>interrupt is intentionally skipped to save the SEAM call. Additionally,
>unnecessarily returning back to guest will has performance impact.
>
>But according to the discussion thread above, it seems that Sean prioritized
>code readability (i.e. reuse the common helper to make TDX code less special)
>over performance considerations?

To mitigate the performance impact, we can cache the "pending interrupt" status
on the first read, similar to how guest RSP/RBP are cached to avoid VMREADs for
normal VMs. This optimization can be done in a separate patch or series.

And, future TDX modules will report the status via registers.

