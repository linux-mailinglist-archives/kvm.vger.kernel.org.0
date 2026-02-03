Return-Path: <kvm+bounces-69981-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IA3oKyW+gWm7JAMAu9opvQ
	(envelope-from <kvm+bounces-69981-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:21:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6EFD6BB4
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 10:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99C3E3031AD0
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 09:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AB2396D21;
	Tue,  3 Feb 2026 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3/92A+H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F79393DCA;
	Tue,  3 Feb 2026 09:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770110497; cv=fail; b=dh5z+PxgaAxUxZE+24nzACr6/j7dm68hmjuientGAwfkq46yPM+9u+6cl47gQQAuIyXsVwQSRTX6OTTHjiPrSH/dJr66CpEl6WFOWzb5CvI25MLSPXOB9nzwkENk1NBfWfD2DHUPCfYAuxZOHy/TBP8c2QaiMJ0KbMIp7ILTMoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770110497; c=relaxed/simple;
	bh=Q26YA+XDiO0YkYj+4oCms0m3lQzJ1sNfp8ENGMedv7U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DvwF7RUV3HjTH/ZnXS5c7hvxv2RaWET4yuNocWcxCSWRR46QSWv2ddIDqoldhaTnnfLMMT8t0pS+DiZG870TqtspIPGETajrwDsIEiCmN7WY6Tu7x9xMdq81cPmJgsJw1fYSYP0W80L3UsYRBQCjo3rY1o5JwyXCMHpV59aoJFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3/92A+H; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770110497; x=1801646497;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Q26YA+XDiO0YkYj+4oCms0m3lQzJ1sNfp8ENGMedv7U=;
  b=h3/92A+HINUfr2ErN+x9OrHOOePruRqmh5rAWZ79+oX052QsJHqMtyAI
   re1+3u4Rft2tCdPMl3VPjc3fQFsJGT+XmGX972c6J0YMQ4PLM8QVER9NR
   ORESHedRy6rb6AylqOGJMJIq1zoZPRJRxrd3ypX2m4ecT3cyEQa/BcsK4
   18F30AVsOLt8VP3GXIBioyMUabtvAqYC75amZvVyQ49YjH7baZFNDq5yV
   CzrGKc/iZwFddP5khWEXUz5y+lS0bycPiVAwb56ReV3dvrfYZEPxUP+Pf
   do6VRkDBrH6yuSR0zdiIdajWDl6ikDiTlo4rw8jHxAW2wyujAxU+53WHn
   A==;
X-CSE-ConnectionGUID: wdu3J5/6TdScEcTFvOwjYA==
X-CSE-MsgGUID: Kjma7fq1TRiuGNptPLPZ7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71439749"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="71439749"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 01:21:32 -0800
X-CSE-ConnectionGUID: 5+YlqLFrREaEGk7dHNFwqA==
X-CSE-MsgGUID: S6HpFnvNS0+8acB5nTekeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="232716373"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 01:21:32 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 01:21:31 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 01:21:31 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 01:21:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9MdMEWibiizXg5v6ZVvc9rbt02YLeBSExz/YhT7SOoRcF05mKjwQyO0fBi52qyInRtAlPmCoo/hemhcgKVuOaSzwK/5/9iVlYbieDABAGs54R7/uBk6RPxMVRnjXpmqVnVq6IRpxeFlJnsdbMXHJiEllnrwO/Srx5VMUrqJ5VwFagJ5PfWMXOI38KdRINgXa1x1/uxVy7/CuAVQJh5VYSc6kRF+sPOSZC4biJCT6JuQe641XByPO3oShTVZsQeTVUf5Pd0jfUOKGn/qR+hZgfhyREnoGTwKRq350XVIIlSSeKNyUpzbZ9w8k0sMvBsSzRZjPY9p2/Z+tyrN3Elhog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHDImUD1XTTbzzIfLR4or46SA6XFGPVHTTTMvD1dgSI=;
 b=Q45oJ0oHDww1/RC3x6OXu8rqVmZxYKt7nKBC/b/r3pnDH3WPxMh/3hO9rtttbtHGBinyKZ9f/c4B4zk28m7K0ZF0DCa8p+XeiJ60/k75SAwfIYlk19QPrl35BuKwHokeFwfvVdXlBPmTer2IaXI/fJFyvg5+PR7tstSQnbJ3r2mYT3I8+EIyzp4Ma8MGPHfd20n++fpQQrUpY8Go3VEPKqqos6u2uKbirqFALPIDwKwOcOpx1xcp/Zx5y1C8p7TE18XA+ogwvo6mBPmFOS14qWwLWRo/ELqW0zeX5tUXMcrEICukyS6V8PVrsIb81+1KYfZ4GmKiDNh+vHo0T9ijBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPF179F31853.namprd11.prod.outlook.com (2603:10b6:518:1::d0b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 09:21:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 09:21:26 +0000
Date: Tue, 3 Feb 2026 17:18:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Fan Du <fan.du@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"david@kernel.org" <david@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny
	<ira.weiny@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Chao
 P Peng" <chao.p.peng@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, Chao Gao <chao.gao@intel.com>, "Jun
 Miao" <jun.miao@intel.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aYG9ZyvpS6AZiRAl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aWbwVG8aZupbHBh4@google.com>
 <aWdgfXNdBuzpVE2Z@yzhao56-desk.sh.intel.com>
 <aWe1tKpFw-As6VKg@google.com>
 <f4240495-120b-4124-b91a-b365e45bf50a@intel.com>
 <aWgyhmTJphGQqO0Y@google.com>
 <ac46c07e421fa682ef9f404f2ec9f2f2ba893703.camel@intel.com>
 <aWpn8pZrPVyTcnYv@google.com>
 <6184812b4449947395417b07ae3bad2f191d178f.camel@intel.com>
 <aW3G6yZuvclYABzP@yzhao56-desk.sh.intel.com>
 <aXzPIO2qZwuwaeLi@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aXzPIO2qZwuwaeLi@google.com>
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPF179F31853:EE_
X-MS-Office365-Filtering-Correlation-Id: 10a5f302-00e6-49d3-dad9-08de63059ae1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?peIVyYwNqVpKeVGO3rALGC2pY2KH/y1TL9DC7IzqUE8eeY1LnhBco6YHBKMG?=
 =?us-ascii?Q?PmxDmOn/cO312MfSY8eqcQuCdLQ+pDqMDLD3VvZwYYGZuj5cSPBfjG6OpSa3?=
 =?us-ascii?Q?isMcFGm7H/WlRmBTSl9vionUc3/ULMNylRBB6lRRIZNS6ZGKZqfeSz/EBUH0?=
 =?us-ascii?Q?XSsTsx9/n2kokc7ny3bvEb4idT07N3PC4G18+L2hZlRtw1X0wuXteQ/a3bEC?=
 =?us-ascii?Q?LE/0ewe7t7cRZ08JsdawJRs+J8SHwQFH1heb1PZocqo+wFOpq418ZyEqwcvk?=
 =?us-ascii?Q?ju1uR+lUvhYKCCJejZG3JquO/LPjiIwniSgj48YdtWwfD8eKHwZhFpot6v1m?=
 =?us-ascii?Q?SJsOcqEmpTUiFjIGRtS9MHhX7knu82Zk8iZmht490PTq4z2CZxnUOSMapU+9?=
 =?us-ascii?Q?Xo6VYzAdM/I7bQAgo3L9wqaIpiJ/NMeSm62KDuvvyPBySn4ZmbB5m4xqh8hb?=
 =?us-ascii?Q?Gt6Fk2iXrs9DU9KAV1Ur3rvuAm9xFVkSAaS/nBTKG6FhpddzgnijFVB6L7r/?=
 =?us-ascii?Q?64pk2rySFS+kT95oi8v0+d9EpYc6j+e8KbmkKXVBQcMYjSOqfhmqB0sQMOME?=
 =?us-ascii?Q?1zaCaLmd/cQa2sx5aOcMK5wdioUWfgd/wHBEY3VIB3GmWpVjUtGgs0odt8YX?=
 =?us-ascii?Q?5dqw2ohJE8e2BnGBmHKH/tOxWdFRIumXtZqKuvpUnPP5cfXo7IFo6wxFQz+c?=
 =?us-ascii?Q?A3RteG0VGor5P4a3S+XVnXzKDEqDNeXvOGbubCGLq+E8JGEzGqsS4lFkZXER?=
 =?us-ascii?Q?QtXfnP6qROFSmfgKa3XlJz5b/okPV0vKdyeVXU/cG2rlquzlk557T6WJ/zzd?=
 =?us-ascii?Q?Ly+LLDA6A1S+4ZqcPjZF22bJRdItNAUfndXD/SEy9+g3VGAiGg0WhyEctNV4?=
 =?us-ascii?Q?v3JO6OIuRCMTL0OibEWpJ/xTn+xE7GxR9DzSOYltRaD2d97OB/rDIagQ6sZj?=
 =?us-ascii?Q?P/LpB+bFAxtq9F/Z7k0ETS42/NcUVrdKI2BlVHtutk9UKuNbL7iv72qHyCyF?=
 =?us-ascii?Q?9CuM8qdBVeFWPnRuY85QweGUwdb+dP8Tegg2mAUqTnnVdqCvCsOqIAVbMxTK?=
 =?us-ascii?Q?UxlpegyAXhUrUi9NtrP9i/a2g2oSLAtizpk7k666vUr8V/HG2CzEzfvMglcB?=
 =?us-ascii?Q?OQohgP5lrKMMrIwEnISKa9qTFSmXXbATAobV0QXlB994WHtOuF61Jj2pVgHt?=
 =?us-ascii?Q?QbED9QyK9O7YvY+YPGlgYahbeIQYX4N+OAj7i9fFsXFKREHYBwmAtIQXInpP?=
 =?us-ascii?Q?BzTimpbVUZrZw0Ej/QOWk48Ld6eYTz6tHdFb7jsnBX8FL1vFZQTirq6HW7wf?=
 =?us-ascii?Q?O9S6rEZcqfwhHTBmLSu7zi8Jq51cjRNO8JMwGDA32ajuIj7qlSl9ITSj0w/c?=
 =?us-ascii?Q?vqU6Bb8XN2KyZi9NiIZc8EA7agWZ6k4ldEYKfSG4ebbiLVSAGFWf87wzK31o?=
 =?us-ascii?Q?S4saoSa3XFMiDXsgOgVqbEjtmCVbrMeejdknt4G2TqvhbT5DSrrcNGSkys42?=
 =?us-ascii?Q?DVqFkBiSd+fefu1C4sMTpsOPJRRkvrBDPbvt5/jxchGvkbAwK9YwODhXHLxd?=
 =?us-ascii?Q?xgvM+Gns6FMOvZzUdKC8IA2X11AtfwGuDS91RVgs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jeKneE+gN+RwL4t2LJGl2jKyxtu3VYWREq9MwgTxIEXESubuc3odrt11hePP?=
 =?us-ascii?Q?GyMnSEX+t2NifpyOxGbSL14a+FFfj7uEYj1Gb/BwwaOmLG1h7Vo1eK/C8+Z7?=
 =?us-ascii?Q?kjxefQ1CLFsNXPUztOCdAdLd7JPuxJhCQVEH57RtUC3oTR5NGsPHR0INyvA0?=
 =?us-ascii?Q?OM+UTfPHtjZ/ovzEGTDR5q/6FrLnNSwAp1pSsRJAZ74gquYhCYihXyxudr+t?=
 =?us-ascii?Q?tXd2EdmI+VYuuEpFbdHgaFzlXhsts1vFtaB6fPZ9JTxPmesfR9TX2pwIEMEn?=
 =?us-ascii?Q?Ib60VKBJ1Ww91YM1I0MxmsWJIY0MESgb2K4pSA0DAgYogZMAvWm+55IPAjqX?=
 =?us-ascii?Q?V5A2I6vexv1ZV/FAIJ6OR/qRBMzze4FDwxXtFXNHig87RFZO1v+nTq1OM+vl?=
 =?us-ascii?Q?OPRcYYjTTj/p/j1crA4USaBXrfalzfBOaAwX+8CnzCF45m+wFlL3bAAuR2Gm?=
 =?us-ascii?Q?6Y1Ed+iajyHqazYJhaI1pwzTz1PaQCM3fR4pxNHRMhP4RhTMeMdslG5uoiCr?=
 =?us-ascii?Q?7GpM5S/fxQj8YnwcRpLumJpNEjQIv8GeG8cKvzX1aIrEEks64rRlUdH5V0T9?=
 =?us-ascii?Q?hl4UYOEMm93w4CdeSHUlmafI61NbVh4EQ+hIakulucgNODMMvmTHs7vezFS0?=
 =?us-ascii?Q?g+RFdLWZj6MJcZlJpa0cBQ06RjqsQcJRf2ODQuCkpVd35YAp8E3bOY/ihxRI?=
 =?us-ascii?Q?zi/9Drxa8kxdAzsaIKU68RDB6BIrX74XLiziwXTB6HDChjQB9hyzYr68HTKl?=
 =?us-ascii?Q?AmscrucUp4JmlrL1Sec+1Jelgeg2/j0moD7oOthJarcv/WP5l53Uf/CLu+cX?=
 =?us-ascii?Q?er3i3DE0knagYmImXMURpaavoWQpO7jMgR74ixsNAaZF3ZTxQ2XV0MHzijo9?=
 =?us-ascii?Q?SbrTp8eSCmK4BBcjaBfOe2/icrgH+SQM30dcxh+NNxgC2/PTslFshDrI0m4i?=
 =?us-ascii?Q?mWN2HmXJXQZzp0gtXzev5AqZ8/1YmvA9Jg4n7LnFx/4X4ErfehwTafpZOc8M?=
 =?us-ascii?Q?oJSZ3hXDP/byX0cH3sXXFZxguEHajCmeVfTMRUJbJF7k6BADzYxDZjNE2XFj?=
 =?us-ascii?Q?zDmN97TOCZEAvza8K39bEECrMKh7YQb/4Q+HffNPhsGbhLJQ2/lT2PQ1Ehl5?=
 =?us-ascii?Q?RUo3yOpa+8CHOdfjLb0bb8NezvbrA9rCiK0qeGxQneGKY5/wq3j8BlZpuiht?=
 =?us-ascii?Q?C4fZ96626BsP6jYSom/3FOgmLq/bBw7Ne7XActxhPy+D9mTjgfgY23uQemba?=
 =?us-ascii?Q?5gdLCuFJr1xyLaYRWPZlzFctu+4uRFnCh02S8nHMEWGAzu6RwgBk6pUzv+Bj?=
 =?us-ascii?Q?W1qV1nYjvSk9vmjOKUlz/4UWjLcPpK4pGkFtCiDKJKgieHTaab4rRCQXYDhQ?=
 =?us-ascii?Q?YYU3S1dBLi1csSArIOrxY+0uJsyjgneQdUyD2FeXiOdYjChkMOrFhK1p0gHn?=
 =?us-ascii?Q?SLkXXXWSQoiGuhVK0BvVJBTEDXQVxjST3BKRx2qMCrJpb3bWe6VEis8Pwc2D?=
 =?us-ascii?Q?zbj8SWRi8iGcrsnWRU/l27RPStuW0DtFuZzJkmLUoFRtG9AcgOwmqwyiq358?=
 =?us-ascii?Q?rf6Bz91kV6pkQRWYY5Cgn7mrMFgk1SCmTZzbisD+lBhJYcGNfRX1b3gf4ZRi?=
 =?us-ascii?Q?RqpJDIyYJ9ZOzgGLNRlg5ysV6vRz++ZdPCptUNOBVMOcsLW6Q/8O71vtHgmU?=
 =?us-ascii?Q?BAAlpECtjni5PgaiDPSOYwwijhnMoYDV6p6KU2okqXnVgjOW0w+MeOK6HDae?=
 =?us-ascii?Q?eUlQ7KsgqA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a5f302-00e6-49d3-dad9-08de63059ae1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 09:21:26.0009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ss0L3cQYWtXNwDGxoAVtcTM2qyOqyivNC0LEtm2YZDglhthWllZutyCuW7iwjSzXnJwgKzPOMU+VXlX+lDWRhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF179F31853
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,gmail.com,redhat.com,suse.com,linux.intel.com];
	TAGGED_FROM(0.00)[bounces-69981-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[10];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3F6EFD6BB4
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 07:32:48AM -0800, Sean Christopherson wrote:
> On Mon, Jan 19, 2026, Yan Zhao wrote:
> > On Sat, Jan 17, 2026 at 12:58:02AM +0800, Edgecombe, Rick P wrote:
> > > On Fri, 2026-01-16 at 08:31 -0800, Sean Christopherson wrote:
> > IIUC, this concern should be gone as Dave has agreed to use "pfn" as the
> > SEAMCALL parameter [1]?
> > Then should we invoke "KVM_MMU_WARN_ON(!tdx_is_convertible_pfn(pfn));" in KVM
> > for every pfn of a huge mapping? Or should we keep the sanity check inside the
> > SEAMCALL wrappers?
> 
> I don't have a strong preference.  But if it goes in KVM, definitely guard it with
> KVM_MMU_WARN_ON().
Thank you for your insights, Sean!

> > BTW, I have another question about the SEAMCALL wrapper implementation, as Kai
> > also pointed out in [2]: since the SEAMCALL wrappers now serve as APIs available
> > to callers besides KVM, should the SEAMCALL wrappers return TDX_OPERAND_INVALID
> > or WARN_ON() (or WARN_ON_ONCE()) on sanity check failure?
> 
> Why not both?  But maybe TDX_SW_ERROR instead of TDX_OPERAND_INVALID?
Hmm, I previously returned TDX_OPERAND_INVALID for non-aligned base PFN.
TDX_SW_ERROR is also ok if we want to indicate that passing an invalid PFN is a
software error.
(I had tdh_mem_page_demote() return TDX_SW_ERROR when an incompatible TDX module
is used, i.e., when !tdx_supports_demote_nointerrupt()).

> If an API has a defined contract and/or set of expectations, and those expectations
> aren't met by the caller, then a WARN is justified.  But the failure still needs
> to be communicated to the caller.
Ok.

The reason for 'not both' is that there's already TDX_BUG_ON_2() in KVM after
the SEAMCALL wrapper returns a non-BUSY error. I'm not sure if having double
WARN_ON_ONCE() calls is good, so I intended to let the caller decide whether to
warn.

> > By returning TDX_OPERAND_INVALID, the caller can check the return code, adjust
> > the input or trigger WARN_ON() by itself;
> > By triggering WARN_ON() directly in the SEAMCALL wrapper, we need to document
> > this requirement for the SEAMCALL wrappers and have the caller invoke the API
> > correctly.
> 
> Document what exactly?  Most of this should be common sense.  E.g. we don't generally
> document that pointers must be non-NULL, because that goes without saying 99.9%
> of the time.
Document the SEAMCALL wrapper's expectations. e.g., for demote, a PFN must be
2MB-aligned, or the caller must not invoke tdh_mem_page_demote() if a TDX module
does not support feature ENHANCED_DEMOTE_INTERRUPTIBILITY...

> IMO, that holds true here as well.  E.g. trying to map memory into a TDX guest
> that isn't convertible is obviously a bug, I don't see any value in formally
> documenting that requirement.
Do we need a comment for documentation above the tdh_mem_page_demote() API?

> > So, it looks that "WARN_ON() directly in the SEAMCALL wrapper" is the preferred
> > approach, right?
> 
> > 
> > [1] https://lore.kernel.org/all/d119c824-4770-41d2-a926-4ab5268ea3a6@intel.com/
> > [2] https://lore.kernel.org/all/baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com
> 

