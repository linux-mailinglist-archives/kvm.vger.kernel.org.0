Return-Path: <kvm+bounces-50291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4108AE3ACE
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94AC73B1770
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 09:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E4823C507;
	Mon, 23 Jun 2025 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxGU806J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D01E2BB13;
	Mon, 23 Jun 2025 09:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671310; cv=fail; b=QGBZgDoCBN7rH2M6EZ2aeLGHdmTtozXpN/wascVjeM6nic6uQ+AI1A5sGwr8SsbLnwtZdtIEtM4jSdecPDN2Lhu0Sfup6F0zI2F9VpAsjX/eF7EnGw8HYyfyH54HQ5jPKLSi81XX+f0GoqmvRdU4rGe9lJtuoOsazcJfMAHrgo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671310; c=relaxed/simple;
	bh=jl4mTb5NpLaiNljg6YK/l5nqATB9nG9QUPnAr/k9OXE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EnBK78XRpAOc7Jg6cBYs/SRjaO/mbvar8e6K/nA9a+Lx+mGirCcual3Zm/k1t6xpFBXrhZtbQ4f7dYT3g080ZaVmdJpUTXqi4BOFcFhsKWf5UQd84ADyqoer1X9KSGslqTmMTFDURGLuxOU5m0hI4BEWo0XyBgKixMPLmRtZMzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxGU806J; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750671310; x=1782207310;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jl4mTb5NpLaiNljg6YK/l5nqATB9nG9QUPnAr/k9OXE=;
  b=bxGU806Jzc4ehe4Epjx+ax7dq4zYO36943NoRktElmgviWi4Xj5Kij6Q
   K8IGJOocGMOqYKFEyafDD5OkOCm2jvDkmBWGGzli6Oazbw/95tey9pqXV
   Vy0/o0owtNnbCDuu0/zYkb+AsII/v/czdr/HFWiDD5jcGeq8kvAwaAqf9
   nDgeWBq0reohKACs7W4T71RsnhWXPKdsyN5i2/W2EQz4XeFK2Yc9YzYfQ
   rNIvgyMlbn9EJAcZOxhHZnKjRO4Pje1MmxAWGXtYE7KrE+qlGWJZQWT/i
   bA7rK6V4mphmDOnrQxDY89PbQs8El6F+rA/hvCehaJ83oo9Y44bVODckv
   Q==;
X-CSE-ConnectionGUID: ubxZZ89XTj22keksSYlqYQ==
X-CSE-MsgGUID: UDJe0GYySs23PKogHBsPbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="52093789"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="52093789"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 02:35:09 -0700
X-CSE-ConnectionGUID: X7qS3xjdRuG2QnB3dGjmeg==
X-CSE-MsgGUID: UHd6DUbDRNWk7PEL7/0y0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="156093301"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 02:35:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 02:35:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 02:35:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.52)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 02:35:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5AKhhSDUqZ8IcTIyHuMuo4UlyrAYUwv1R9cMKWgsmnmu4DY5TgxZsf5ceLvhPzWVWpBSP8uzcz7W3c/zRKIW2SpHze1Q3HGkwUBlNFh/VehljuO9P0y6/ruoygtl5j6mqfo07XKwRqaF1tpvnFn4su1HZ1GDn2V0aJf+IVNSmduMOSaau1S+/Nc9qryJZe8+qyV1vCZIDzeVf4DLWV2G0qdc8gpd91GvjvlpLfcV9O7oV0S+smXZG9gU6UQxxyhgTpsoxxImmn0N00mTWJo6/EEi97X5mckfMo7+B5i3BGJ0dXKguXK1UCq+OBuBYHQJIrAGOFIBBQ+Iyp4DZkrmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyrXQupcrNaFjfGO3lVwhvJpVSP5G1fYyjNaRXmg6HU=;
 b=ofyklEGnb1ozLy3HAdWcRFlDnXb0Th8FClcohLDEm1svI6jfLovuPgYHgUwsjkmkenkYrx5q1grlH2elPDDm7cnxsQ4seAUi4QEsUUcBOpsBhC1uHzNVIfk5/ZS2lVq1OBCYPcrLTxs6WZtOC/DhQVH2emjuyrsFnmeZ7wMWJrWaLHU/9GcINZplw3rNEFCOpLfQacaANfkI7H1LJ6SZcMVLZkLHFkhJsrpZafKeZ6AYQFyOMCodCFnhNpe03GhcpkhIeAt6iuraA17UafClNyo5yxDVw/YXR3Amb+LkzciMQCL4ubqDvvyPwenY10//0ee4gDM5WdSRy5mzuIsPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6956.namprd11.prod.outlook.com (2603:10b6:510:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Mon, 23 Jun
 2025 09:35:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Mon, 23 Jun 2025
 09:35:04 +0000
Date: Mon, 23 Jun 2025 17:32:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aFkfL00NTlI9IBC6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <a36db21a224a2314723f7681ad585cbbcfdc2e40.camel@intel.com>
 <aCb/zC9dphPOuHgB@yzhao56-desk.sh.intel.com>
 <9376b309-8561-4fcc-9e71-3bd03fd8f9d0@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9376b309-8561-4fcc-9e71-3bd03fd8f9d0@suse.com>
X-ClientProxiedBy: SI2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:4:186::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: 385bf19a-274f-4545-67e8-08ddb2393bbf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X3nSZvVtLR4DmGxXyr5NhuQNH012Yyf/frKmwgHXlYnw+vJ15kVKA/+vSOZm?=
 =?us-ascii?Q?NTkmf0C2wlWQeyCQklVSZMApqGsdN2oQ0NGy6AAjPSRTAODJ/TM9EfzjWo1l?=
 =?us-ascii?Q?HxUJ//Vol4Qfd4W3Dp5+jMlLsCjMRkJnurGsnHZTTjTIeshmWdUwLioycTLn?=
 =?us-ascii?Q?KSsxzByBxfQ2KmDhVWuzJQtm6y5K7cCMeKS8f2DPCFFqxoaXNuYUiBOurMmu?=
 =?us-ascii?Q?uaT/wRqdpPSnVfZRT1E1qtdteTNr4T+1zVE5vX2p9Ux2U0bubSCYBoexa5Hb?=
 =?us-ascii?Q?z7Qb9UHVyErDxWYqdDFIUPUsIZVRnSQwCH1jIY0ubvNu+4gvCZj+MwKM+k4f?=
 =?us-ascii?Q?2orCUemlj17ukbaGlnWFo3uEqDN+hxC/aMkU37s7KV8ENTQT65rudW0/hDvW?=
 =?us-ascii?Q?M7LjgcxvdsdV7cA1M5zNibt0GFbl1jMwg74TXIT5lAhNxOBc9IlLoPzL7bCn?=
 =?us-ascii?Q?BQbk8Go4W2boVykyvxFAgRcf9MFb2aOALx5vf1oDuEVKVDpCQ/pw7EWTVw0S?=
 =?us-ascii?Q?jVsvWWDHAVwa/TBQyzbwTj8W8lXXW6DbApjwx0m40sEMWTHAYz/xozgObUfM?=
 =?us-ascii?Q?7GSXKLzFVGn2KnkL9LhRuKeHKOHQHLIY1fspGVrUaNz7CrZ/l5DkXrz5rf/1?=
 =?us-ascii?Q?JcuUdJ0Is2lg2m2CaaixG6yPqC0P5ADtGjqspCGrGEcDNhpkkO2GWBe4ohv8?=
 =?us-ascii?Q?WEXsV0UYjICJUWduFgtDfeoTwe+zBPRYfShz4lH3TofPwZtt9AOfSOt5cM+A?=
 =?us-ascii?Q?RrBc6G3x9cx2ZSDrRUPdBO4+ZX0qodm+ilhLQM8e24MmBnQtiaPYkPDEEkXV?=
 =?us-ascii?Q?+ACvsYaDQKgwwFrdqhEOpHu7wAXh0c/NkXu1coL0TBRi2eWeb2N/Ja53gU4e?=
 =?us-ascii?Q?UsAxXx+Hi+nM/nNpdvXsGBDndtb2r8wSEP4UDYI+b0TFDgofZnzWvDUbRwzx?=
 =?us-ascii?Q?xK3S0TLwC3yhE8jOkq7+s4EGfHKE1DaxwTeQcxJWwFnXUhfucubyS8yLnIsR?=
 =?us-ascii?Q?sCbqM4LQApSnfLhnbRkHQjnp0GBiPy6qpd+kStnbeXK0FIN9kUs+kfaqwCJ2?=
 =?us-ascii?Q?0KSAZrOJJDzsew95Xu6pWsCZhSaTt+CHb4tP7rznpQgjgxAai+qz1l21vOxG?=
 =?us-ascii?Q?f0qBqWOygRedk8+zB9tx1yxQxyUXPvkvOtTtxQ6Vv+AB/4DzkxqjKFPv3glu?=
 =?us-ascii?Q?lYJ9DuIYw3fsv8e8MCpBuBgtFzxaehR1iHHvEn0S0Hsl0W0oyT4sBPD4r1bt?=
 =?us-ascii?Q?9jHJCjf3Wvpy/N/VpmoaPpWjC+mL1TKXtuL6TkpFBZv8Ls02oz2ou68NsHJg?=
 =?us-ascii?Q?xrosNFpr1g9w2MvemVeUCZMSQ/0sW9iZ2pt3H0w/FZDgYyhLNS+aEFlLS1U6?=
 =?us-ascii?Q?I/p1SMS4twP7kgsfr5gCoPfcNzPBvKkQtR9cgoRmVotG8AyjgrbzedUkh62t?=
 =?us-ascii?Q?EhYBUQyQBXU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1SCeJ+3OcjRvJUJpFywEdYtKtu3bfYaABB/k3qP+vbBCAxa/FkSYCThC/FZ2?=
 =?us-ascii?Q?Iwa4wCb78vYKSnyV/jPFQNhum138QDjCor0XtHsvbYJOnbjo2j8IBhtUvwzg?=
 =?us-ascii?Q?ZR6t3P8qu+PSVgyaY5++bYRRb9f/WJqo6EskQYPDa0LBjADI6g3MxL5w467q?=
 =?us-ascii?Q?KSA529yV6Gmf0l153ZTu6fLIg4+T4jP2dHdnMa6+ujyVYm8EPHFySjNB4I4O?=
 =?us-ascii?Q?J+W3vn7t4UGmYVL1x/xoCOwR7bM7Ax+SBITk25YOI2aAD3cQf22oTNbhwBbK?=
 =?us-ascii?Q?kn3FNo3u/1nCrwm+mXmm81ADULus7cyP0kjoWj5V+LBJpB4KgBWPx/EL6q98?=
 =?us-ascii?Q?t9XMlsIPl594A+W9VxKbpBtm5caFoSSoTEoRaxqGTKym4zqUeMYtXq+hS+Ly?=
 =?us-ascii?Q?WBAxdLXHsy+WdkkAul2ddFAIOqLM0GjRfE2LqbGQ7Ht3AUobByt62D9giGhM?=
 =?us-ascii?Q?4e99NUywTfBhCpsGJziGl4ir1KbCgAM29nJHSeGljgJ8Z0LMLRrxJ6I1O2ZV?=
 =?us-ascii?Q?pkgBhaOIUAhJQgGnstOZx3z5xE2+Kj/3602lubGzcHeVpZrZo+kEmzcjtGVU?=
 =?us-ascii?Q?VEDJ5fpgmalGVvkA96HYR5GLdfbAWr0xBb2I0dJVfA/hP6F2xdSdAnyhgmzN?=
 =?us-ascii?Q?ivySrmCbvu3qJsjFpvMu0hrNmsgaDEzuWsnNJ43TT2nU1sXM+fTbC5QJN3ff?=
 =?us-ascii?Q?GcABCdvweoUBVQeNUpVBrf6CfBTavNRKglo31waO2eRWTGmKJ1b0juIGs+tS?=
 =?us-ascii?Q?KoBRTUFxe5uaRFiqU/+BI3xbj4Gf7nYknFq6t6tQZPgntrpKDd79NnwaFu4D?=
 =?us-ascii?Q?P2B7oO6ckuWI/McWw7GQvKUailTHPWyU54foUFWFiV9fB0njiUW98CNkRJxe?=
 =?us-ascii?Q?9nFef3p2InhOxinj2shN5QZzLW3dznrMND42tdZlq5OULLmIFC/e+DzovCKa?=
 =?us-ascii?Q?v+0e/2s0U1OErGgDamXe1K5pb48mNfL1Lc0L0lb6XcHGVXOFJoQy3pYC+Hv7?=
 =?us-ascii?Q?RIqstYHaHME9JBam3FBmUyqfil8Qf6ASj+3YvnyjEHzM0rP+U2nCp9G3ILvS?=
 =?us-ascii?Q?LFZcGpohs1nZg26WRsfuRxGonfFiEbvm/bXoZxNk/Bse8OirbhL/WdwHvFeh?=
 =?us-ascii?Q?7ewREhg/3jbfPdrtZ6vZIGmeUTedzSFyMczBWg9miLf6GZ6zQxD4sIehFiIT?=
 =?us-ascii?Q?aSmwxDxAzZky7Fw8u5z/ggOsZJ0E/68z7ozPUlGT+xbUZbMucGXsP+CTsPQD?=
 =?us-ascii?Q?XvdeszWKVw+B3xnJQJfQR6pnigwaYDUictVtmTm4lX56ITzrZWO7POzLS6Vy?=
 =?us-ascii?Q?f7MsdfVUpeTrj7t9NmMgzsPk5yYGHqs7ld0kcOzbg//mVty4eD412CGg3edf?=
 =?us-ascii?Q?i+vd1ZejT57YFuAzw5bM+7oj4GdBWqRhOR/Ix7qqJ/nN5MBm6rlCxXuy+ks2?=
 =?us-ascii?Q?qGUrvltTqLWMOFYPzJp/bdaHPMuLNHAdEL59KTuVLOLNgbJzlME2w86H6ugk?=
 =?us-ascii?Q?BiC99NucXbtF0Rtwkgy9G9Z3BF9hSJ3y176FMgrkqO1gdimlrSxNPdJP9eyO?=
 =?us-ascii?Q?t8oK3VOVQfiHHhqcc2gdOkGguEmjEjfS/cPJSzvt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 385bf19a-274f-4545-67e8-08ddb2393bbf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 09:35:04.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLLYtWJQD8YNpqM8hvXqMflTjTKBqInxZmg2xJSD3vdvh/ffTb3eFpvBwmJWVp6H9qi2N8Z/Xb+AIjR2k+eYCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6956
X-OriginatorOrg: intel.com

On Thu, Jun 19, 2025 at 12:26:07PM +0300, Nikolay Borisov wrote:
> > What about Binbin's proposal [1]? i.e.,
> > 
> > while (nr_pages)
> >       tdx_clflush_page(nth_page(page, --nr_pages));
> 
> What's the problem with using:
> 
> +       for (int i = 0; nr_pages; nr_pages--)
> +               tdx_clflush_page(nth_page(page, i++))
Thanks! It looks good to me.

> The kernel now allows C99-style definition of variables inside a loop + it's
> clear how many times the loop has to be executed.
 

