Return-Path: <kvm+bounces-34717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F62DA04E91
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 997661887365
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 01:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7977618EB0;
	Wed,  8 Jan 2025 01:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CQjoTq+9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF54478F24;
	Wed,  8 Jan 2025 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736298852; cv=fail; b=JOFm0b0OBAJwVWJ0Qv+11alWdYjzQ5UaYYlMh/rQPsY2EiSX7JOXD3rqGnAsUU67fbqFPB9gWOiJKcB/qcZtDXkvpME6fNFixD90NIcOpE6HGS85LMseqsILS2XS9hjuOXmCnWcUpcxF16N8mGlRhBQdmKMe/mbdgP2/L5NHr5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736298852; c=relaxed/simple;
	bh=9mj8nD7Fyr/6PzHurGZBjKW64y5PoD5ulYsanv908BI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=peyDV0jOGBAsHTrlKqk+6ZqjNMegeTY+6MrJ2D2G1TXmLOL6BtUfkB/YcYB7b0g6AEwB7zSGFv/GuV57xkOYSiWRAIP7mSjX3+jXj0N15gaP2Mqn2+DZWtRknMYMUAd1acE17BBGJSS+fyyHT5yjO4a1z3JU4w4+FxFWazgqPIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CQjoTq+9; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736298851; x=1767834851;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9mj8nD7Fyr/6PzHurGZBjKW64y5PoD5ulYsanv908BI=;
  b=CQjoTq+9WDbh4g0J3lFeUyBu3hkxoyq9clWQOPQgAPvL6nHw6F+yoEPR
   BKMCRQEkov+kUS1Zw/MEtL3XkoxtQdmezxwZzdxDdWZpwoSqeCioB+9VX
   zsEDRhlHJZyQ78kPhdzf6ZKs6IRfc+wp3xhN+/zQHegEGfJeHzlNHYeS4
   cx1uAkIgQbMns/aBViMP2+FbFGGeC6FcCX1pIO0oejI6P5CwPzMxC3xys
   s4z0kCEa3b/J+cCrATBNpHy+0NvdGOWI90fyGJXHKZXMQ89xry2TP+ubm
   RT8eRXNoSsPOLpg0AhKzHXi5EyZFDjzINwJPAqbSt3+/yDjRXMCyKrrxK
   w==;
X-CSE-ConnectionGUID: WHhrhW2IRX+qAKdY2UjVGg==
X-CSE-MsgGUID: ryZWNHmKS6GQZMMACMOLyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36723428"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="36723428"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 17:14:08 -0800
X-CSE-ConnectionGUID: TXf3rPfsSq+aT1Y2bJuU5A==
X-CSE-MsgGUID: VAZb2eUhQ7ux+W9BdHPGmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="103001114"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 17:14:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 17:14:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 17:14:07 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 17:14:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdT3Iv12uclwKQtaEXo7a8rDrPaOOx2c30EkLC/mPYGNdtGiw356fFPBXj7rwKWnJcoYOszYunnYPyJwOmJIZsppLmuxul971b9tA0+B9PtbQZgbV7ikwH+XgQ4Ck5cItzklo02xVkFYKAwz+lKFd2R8epkg7G5FpSk/ZlyX78bNQnCNKX/hwYdSlrwjVwLw54qokJ7sz4UUpLCZJyRfHweGviRV0u+ZWEV6kgkTviz+OjS1J0UML5ezTuyx75c7sBV4UKI5e/06HeBARmph46O9ThLUfbwsj1L44nwNTeodShBEqPj840BCOWBKRD7Ih4YZPYBCiB0ULsP3DQa9SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJwOcDBREV2GwDA+KqI9F0wvjRtTxEtWPDveiuVRS94=;
 b=WMl+fVo+X3MI9NNawZEo1mnm/0zzFYYtP7SS0uv1+9tnymmSiOk1vNcJBMCWN2J2HyYtI5vzdkHrdGSPC1IvSkCS0UXDMsbG0WJMAoHxTFva2p5FuVO5yznc1t+B9+wrljD9bxIFNCOY7vn2c92GIZkAgwD+tokN+q9mh87V3UKjhL/lO/v+jClJSFqI9oKtrnqz1pCClnuVQHEAyQYkHir4odqloVcGZxZ1XqdxreQ635R/3wJ2IEZgf7qgT5JXUdIWgxfRKJaNOk003ZLG6OMG3oXswB6qiwW5lnmeR4mYwydUzxq8zBanR9jqezhYr1ym4ytwFUAjgJQDQcehOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 01:13:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 01:13:27 +0000
Date: Wed, 8 Jan 2025 09:12:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/13] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_sept_add() to add SEPT pages
Message-ID: <Z33Q/4piC/QMdPFQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-8-pbonzini@redhat.com>
 <b27448f5fc3bc96ae4c166e6eb4886e2ff8b4f90.camel@intel.com>
 <753cd9f1-5eb7-480f-ae4f-d263aaecdd6c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <753cd9f1-5eb7-480f-ae4f-d263aaecdd6c@intel.com>
X-ClientProxiedBy: SG2PR01CA0188.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7648:EE_
X-MS-Office365-Filtering-Correlation-Id: 96071f8d-4200-454b-8790-08dd2f81a842
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Hc+eSLiqqKKCs+6Fdd4Qudl/gZAytqTJEsqTA8y6fF5wlcEPRT9k4nfp8cBW?=
 =?us-ascii?Q?VGwAaJJV45MzShVo1lsZhFMzncFwYi7PqFT9xAAtmapBvvGzPrXu3b8T/xLC?=
 =?us-ascii?Q?UsdpigJDk7ng7ixEv0jYubBVnIv3NpmVhtkoN3elZdvOFGFQR3iYU2fUganc?=
 =?us-ascii?Q?tFGioTB9h7zH6Mr7CmsXIhroBb4n7Zmagks+XO6ypv/j/h0H9PasdRs348a5?=
 =?us-ascii?Q?rGbofZNN7GJGHYrA6lVbTBnojLYDdRWOyllKiNwR4T520HL6W5as5hBfgpNR?=
 =?us-ascii?Q?tQT5Cww0eJ/GX1CKZhV4t2CJ+16IAlG1I9wuPjCguaCcRPqTDWg9hkN2HMU+?=
 =?us-ascii?Q?ulu45MfXrfEwZJr69mirNIE2gigoxDzCkdbDmYR1VWlhTHn0QucVhnNbvuV3?=
 =?us-ascii?Q?J/m/T8If3XfR3s6mHZf8qam7Ff8LdqIgOeeaaQj4BDcmNRtGksD+tX/y4lLN?=
 =?us-ascii?Q?/oRibm5ofrv83+acNELB8v9JWEB9yhfL3O3WIMIR699/SXi7BCo95P/uDxp7?=
 =?us-ascii?Q?Nv8qOsIPIMxwDCi0FMPimHfv8guxrSH5OPxMDIpn+6bug8k/Cbfg9AyCNhmD?=
 =?us-ascii?Q?7coAVTdEr1wFxrDaKZh//i1eyXZvpvw+1P2tcfIHrV+EXzUu/SQw11R+txxY?=
 =?us-ascii?Q?t44OJn3MgSXCi2fOTuC5wGeUr2YlaVyQMxgyQwWh3HwsK/dvc8bJxuZLbLyM?=
 =?us-ascii?Q?oCh19kLUflaXCNVHiiFNuyuURp8vjz8SC8T1jCCmontz68b3itTXTdBLtKZF?=
 =?us-ascii?Q?aynub1KfYRu1CRcl5hAs00MLy+4mTj3DJBPnwxqZGKURD4+Goa2ZAzQydghJ?=
 =?us-ascii?Q?bbLz2oOwVS63rOyPmQJz+O31VPLQUv7KDBg++Y8wsuDOGkyQmHLsn1pLizfH?=
 =?us-ascii?Q?fgjHKGIp6tnj4ITZydqnbIO8wnco7euWYu2JoExk6mG0NGfDqpeYdAVo777V?=
 =?us-ascii?Q?SWxqB3Omylvkd4iPdmtnXbcyudBa6bZvmXPPp6FsdwBnPxihGYOR1y8b1t4J?=
 =?us-ascii?Q?2OJChi2yRoX+fNE7lIENw2m6oPm3GQYy0gzmE50CqglbMRH2CmxVgk53zA4K?=
 =?us-ascii?Q?H5dYp6pLfV1n63y62WtXfBcQG+6ytmN0GgaFfQm7FMNxPJRwnw8bq04CnM5E?=
 =?us-ascii?Q?QDkEhaDuScM81kjwFhkGqqjRD9PfwyIYxUe30KvZmScbkdWeELij677W6HJC?=
 =?us-ascii?Q?msI0xQFKD5BaEMYRCg7V1oIDLEKA6018fxt2jnpiIzXCK1lauYE9j2zquPB0?=
 =?us-ascii?Q?YW8IrIGascx0nOYDA9quFsDGKAy7ElnXLsLJ2ca9+nbghHWa0QO1nPSSXDSb?=
 =?us-ascii?Q?kc+vt1xIKaj5pZ0BUOHl2bUqKJQUrL6ZEo5ikMBs0GFPkCZv203FnevuMR/Y?=
 =?us-ascii?Q?dP6xH+zS61N9LYRlk/UPvoGXdrO9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s913oVWDRQx17soYXj8kMxyYQ59HGw5FQ9dO2pA4/b/yZRz2Qchyl1jtzHDe?=
 =?us-ascii?Q?62uELEJtCJJ96itW8EoManq2VujJu21CvVET7aMFM8IIBcVKepXv6yYr5tpl?=
 =?us-ascii?Q?yynJVkeBaXg78xkxtek+60RGuO1t5xBnX/F5UxgvqRqvt9oUmzg9FTuYs53A?=
 =?us-ascii?Q?fPuQFtdrAiD0i5FOG1dff3I0X8Fz+l3lFqMTP42HA3EhpeLejwan/Iyc+H/u?=
 =?us-ascii?Q?r/aUJCm7oko2WP/ZpOwPbkv7LfBAqfWsZ59TP0rQZbGq/O2k+M7jIodhvlEA?=
 =?us-ascii?Q?F627zXezq4FAKKt4xCESehQuabrL0/VhASw1Zc5lUNVP537/qm3lwjzko7rI?=
 =?us-ascii?Q?Pcfu11FWaDkyV3eaI95UB3E2iGLiecUBOqW/PBXeAb2qWYSjgSgo5p6ZWv4H?=
 =?us-ascii?Q?waIkkW+W5fiu/AkCJURy7KBHkEuIwN8iWIrHEuDcOoVisILcC1Eqbnz3xi5j?=
 =?us-ascii?Q?UwGQsxWbRvqu2Bu8qh+y1nSNUdy2OA8A9kn27iil4rc8Xvk3xRq75sNUYOAA?=
 =?us-ascii?Q?+uDrcfGDe6e8aEEdYkxsPH3/Q6QEDpY/xoqXGpYx19Fin05mZlKG20BvA+tC?=
 =?us-ascii?Q?ALwI+myN96MW4NT6EF8Ts/wy7JwOEFixS0T498kbU9NR5whw3rAl34uFeaYv?=
 =?us-ascii?Q?cBovXSaavBwf9AGQKulufRFIVISxtVhzbpQJWdTZHHa79qucHjzZeAP+d+gm?=
 =?us-ascii?Q?d3Vck4Jw/7sraVxuR2qriDSjUnI96D3AgClppBSiyO2ZK26RvLkTczfHxSwk?=
 =?us-ascii?Q?ZLbOZs4avsH80sru5PUg912YLrFGvERtRoTeURL786sPAzdIh8gZf3xk+D9a?=
 =?us-ascii?Q?4wmMR4h9MFeDTHrRiL3Sw+YN4p9ZOj/rqzK9pnQQNHCsifT18JXBxYbe9pgq?=
 =?us-ascii?Q?n7/pzPGBGPyo6qvVwNrFNqUenVnfisgDV9d/MrkDjORAHHxaNVQWJcW/1qjy?=
 =?us-ascii?Q?aNPKxhAw0FjlqU59Jft/cmMbsC8lMV9khdfxBrzoBY7FypAqVftk/Od+Rmiq?=
 =?us-ascii?Q?OfdCKHF6ZkJReqRCFl4dTK30kb9OT8s5mZASwtOeCIRhFAqR0H/nzxy1AJZd?=
 =?us-ascii?Q?BW0q33JIgEX2eJsvfJQamT69pRvpU1KHB/n2KEqF7u/aeKzW3jR7foHrPqQi?=
 =?us-ascii?Q?k6Nf5J2xLfGxXs0RVAwmF99R5D+JkO14sQWti0DIxTlxyFYURztFIDMwm5oj?=
 =?us-ascii?Q?ti7sja8Oss/YvFB4mnhdOxCuF+re+LNVLj/LX3xKHSPosCwacOA18KFB+qtK?=
 =?us-ascii?Q?4o69X9eJu77OQbuSckbdMaIMTRKgx4ZHNi4eKVJIMMSXRpnakdQvi4VOCZK5?=
 =?us-ascii?Q?wbAAeNHwsXjb5W6GMI34rP679S4c4yhoUGuyVBnOvl/7zBjQaLPlQPlA1mrx?=
 =?us-ascii?Q?zSivWOcoz21SlggKc8Nq/r7C80TlriN3ZI3KnExr0Uy0huc/FGXytBPR9kwx?=
 =?us-ascii?Q?/pqCS0/Fi80gXKExqAGFQH48Jaqwfw3T86Jxg4GVAtEcTl+u1WPWoTkdtZ/6?=
 =?us-ascii?Q?vPJjmsX83QsDJY8SXwP9BEVedXtVDHgqMgGhKTamLFA8oMaZQtBzoY62uAlI?=
 =?us-ascii?Q?YzHH9vlSCzc1TP8EqEzvDlFC2NTmtfokFuP8wM0LAtVz1Rv0Dlyd9LMY6c4Y?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96071f8d-4200-454b-8790-08dd2f81a842
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 01:13:27.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lWMqsQPOQCod25MNvslL1q6UNdYBzAfN85XsebtVlH1K3YoyZaHjrmWEt1kNN1AZpIR9brnYWEvT/Dld6nE1SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7648
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 11:48:12AM -0800, Dave Hansen wrote:
> On 1/2/25 13:59, Edgecombe, Rick P wrote:
> > union tdx_sept_gpa_mapping_info {
> > 	struct {
> > 		u64 level	: 3;
> > 		u64 reserved1	: 9;
> > 		u64 gfn		: 40;
> > 		u64 reserved2	: 12;
> > 	};
> > 	u64 full;
> > };
> 
> This is functionally OK, but seeing bitfields on a value that's probably
> going to get shifted around makes me nervous because of:
This is defined according to the TDX spec.
e.g. in TDH.MEM.SEPT.ADD:

RCX | EPT mapping information:
----|---------------------------------------------------------------------------
    | Bits |  Name    | Description
    |------|----------|---------------------------------------------------------
    | 2:0  |  Level   | Level of the non-leaf Secure EPT entry that will map the
    |      |          | new Secure EPT page - see 3.6.1
    |      |          | Level must between 1 and 3 for a 4-level EPT or between
    |      |          | 1 and 4 for a 5-level EPT.
    |------|----------|---------------------------------------------------------
    | 11:3 | Reserved | Reserved: must be 0
    |------|----------|---------------------------------------------------------
    | 51:12|   GPA    | Bits 51:12 of the guest physical address of to be mapped
    |      |          | for the new Secure EPT page Depending on the level, the
    |      |          | following least significant bits must be 0:
    |      |          | Level 1 (EPT): Bits 20:12
    |      |          | Level 2 (EPD): Bits 29:12
    |      |          | Level 3 (EPDPT): Bits 38:12
    |      |          | Level 4 (EPML4): Bits 47:12
    |------|----------|---------------------------------------------------------
    | 63:52| Reserved | Reserved: must be 0


So, why does this bitfields definition make things worse?

> > https://lore.kernel.org/lkml/20231111020019.553664-1-michael.roth@amd.com/
> I wouldn't NAK it just for this, but it's also not how I would code it up.

