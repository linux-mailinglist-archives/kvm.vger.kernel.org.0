Return-Path: <kvm+bounces-62993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8BAC568EC
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:22:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A6EF4ED090
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7578026E706;
	Thu, 13 Nov 2025 09:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lV2HOVxm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF09286A4;
	Thu, 13 Nov 2025 09:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763024712; cv=fail; b=KWDD2Z+kNAKFFMoYFr+UfoaxE16XkhEtmDr2Ix98AEu7qG1Pd9FeeP/0nwG9MZVnP412Mcts/mx2KJ5CBa6I+2an0GQiJiptybikbiL0yXHv/3tpgj4F4s71STos5Opf4HpiZMYKDu7Qx2/7Q8x13eJ3iINMt4jzdRD+sQ2KOQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763024712; c=relaxed/simple;
	bh=s3Ho7gxWjulvbsdxE+k2S/kqgcZsxD6yQ7RbnWAeBQU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=taYyh6st0BWSRlF5VT96APEE4qXaPARZkm+rAHAvUcvzzCrDNZn7PUDhXlJwNk6O79aC/LR86GPYJWOdBitCmeM+Y99HxoJRRPYUoSR3YH/EQk17Q8U63RnSEhHfeRBQNtJYJzqYaRYjTn97V5amdiYv7rvIKDdbHBNLhhyhLak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lV2HOVxm; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763024711; x=1794560711;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=s3Ho7gxWjulvbsdxE+k2S/kqgcZsxD6yQ7RbnWAeBQU=;
  b=lV2HOVxmBCy2ivZJynx2gdEnbK/NtJGLYE7xfcC0QTFS38Xl8b0gLwxJ
   3RrAq0qO34F0x6OsrfFwBFn2PffxBSSLDq28G5k1WHzURRBMJlUcI3eU6
   lQ8Zn44etsN/IpUrmtyANE/RZByHOPwk9TCI3ZQM9q/t2aW5QY+4iqJXg
   R6R/Z4KUxvEHuADgFxsBSWEpTeFDFrmJkGVjDzogeZpw8CM/IuNR9MBin
   bDKoCBRb4p6UzuDnutdfyWOxlRUPR0zQdBBvkFTnmSJKFZE62szgXWjjt
   CRp4YqRt5ZKSsuLQb3wa78W510hvjsZP112ciPg61enHQWHKSBTf2jjuc
   A==;
X-CSE-ConnectionGUID: 877wNGDRRnOdtvbR/CB4Bw==
X-CSE-MsgGUID: vBGOM5N/T+KPyRO4XMkYqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="68964700"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="68964700"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 01:05:10 -0800
X-CSE-ConnectionGUID: h3qH4zQDSS6bO7Nz1AgCPQ==
X-CSE-MsgGUID: sHbAFrq+QXiKi2Sg9ZjGVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="188724027"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 01:05:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 01:05:09 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 01:05:09 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 01:05:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYAo6/OEAAIekF1KYr+lZjNlDqJrvhqQj2iscX8SD4770PvgQzMIIKTbCk+NnJIbkyA4J/+HJnRvqGqu/kq4j1m1fDR9xWnoGFVzurVobjBas/ADdTbgEgRUf9FAlWPH6mGu4Ek50bN6/qwXXEHMGRNG6FunzHipogAO4DsbfdzRuSMaU1VTmIbGgk0s43boW+oZCuCMe0cxbTzTEaFDQmCCIJdD9TR7igU5LijAqk31Tt6gmtTnd+g1szm25hz0vYacjCA4PLDxWW14nedZ4m1Sk28BjXUJSvVkKiYll8tUVjYjQGiOnLDoorBOmAwJm9AYqKXjSfIOci4Kre/9GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg7fUIPdGMDJSqMP0ViSjH3LyLiK5o92oqcBklt/uzg=;
 b=UJxLSn/bSPvqXmpRX9cVVkU1vdZEKX+f7XdbCBZUjqmyGDuo1wxUdLebaQp6yAVgUnw+h3wUJwQflqyXZUcLlYz39oHuQ81FCIqoIFhLZlZfZQz9HJaNYmXkhmzMtA8FLbSomKUo1ifBfeq60p8yMiXJIMV4K8spLl+D7cOBBjz6tfV2AFQJSjGgCYzaGbHrd/H9MRAoihpzJsduNkj7Bn16EIIH3BB+tJmwzzWbZrScQZwaCr/J1QRjatVsMSrqzr9Ulg5fIrxO0Ly/2LETr3e1d2X00eauWTvZpoAwzBnL6bIh4sM2dcaLROSHCQCuB71JTtPu9sL9iaaK+qJE2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5938.namprd11.prod.outlook.com (2603:10b6:a03:42d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 09:05:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Thu, 13 Nov 2025
 09:05:06 +0000
Date: Thu, 13 Nov 2025 17:03:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org"
	<kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aRWe4VGgJdocYbHw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
 <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
 <858777470674b2ddd594997e94116167dee81705.camel@intel.com>
 <aRVD4fAB7NISgY+8@yzhao56-desk.sh.intel.com>
 <01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5938:EE_
X-MS-Office365-Filtering-Correlation-Id: 304733f1-7d96-4c0f-10d1-08de2293bd6b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4TMV5+m7Z6uKurDo+Wh3+8rO00s7ZvSH9P0JG/d1qEG3bpKUipyiPkSfdkEM?=
 =?us-ascii?Q?SMOnp6gLwuRQ6V9fbQsrFquOpDgtk9fVduSQ+G90Ys5dD3N3+2EdXoCgTAUU?=
 =?us-ascii?Q?Yar7cHR3d1m75tblgxF6Hc7/I4yg4PjPRbQHOnaZg1oaHcRVkzyOrc/ojOyv?=
 =?us-ascii?Q?SP0BLNUXqBrM1yyQDtwkTdiDiQ+1qlCeCw8uQN8vSt/KiY4kh2WauE7SdX0M?=
 =?us-ascii?Q?b3pQ4ayNyqC1qjrlEQd4XbmzBjw/S2658gCuPVKU4kegKsSuED/fVsKM2ic6?=
 =?us-ascii?Q?JoOGSMlTX8r0IyNjwnSczwb+oFQIGL6emSMU5FpTMd6T/+YfPIif0N65K0XV?=
 =?us-ascii?Q?GteBm+GJ+vIksmyDH69K/NdPuuEhG8Eyew4ZBhK9YGhq/cEh2uLA2nnCkq0U?=
 =?us-ascii?Q?+zX4VjUdErdAK7K7coXK1h9FmgBpWm29qwc8VXTBCiCYu9yIiQr/ahK7ikZT?=
 =?us-ascii?Q?miYddHdKw/+CcSmW+kyr6lJPsNuQRjpPDMHrlZIBNqQW8treUyOmeavA7i19?=
 =?us-ascii?Q?S34PESAn4ta9838tq081o0a+6hjPKScH7dHmMuu1XiQF/sV3QEFwsf9qNrdI?=
 =?us-ascii?Q?Yqb/2Sm+9obLrl0X1cwdiOR2IArR0OwnTjSALEOLbOF4Ud8t3AIP3jhA9W3Y?=
 =?us-ascii?Q?95A1Fqjoi0/q9b2bQqSyY1aoH752QpS11kBx4DU3ZDpvkmZARx/h5Y0crMSN?=
 =?us-ascii?Q?uqx2AnqSeTkZZC1WzicDDAOMrHhKxDugJ/M5A9D8dQfstMObt7AGu82xft6f?=
 =?us-ascii?Q?kF0ZM741ugWBw+d7k6gr7iPF33gPGZtudfwkbEU1EGi0IuV6IAaHGK0V7lNM?=
 =?us-ascii?Q?jbafaMv52h1nEskuDxm0hzBjaqNEM2l1Nzfk24gY+z5Q62NTn8XJXgs8Zaiq?=
 =?us-ascii?Q?CXYiequxmpPjYYBCaT4XX3WUsAOKXHoUMFCWoIy3pcUK6mTRsJkZ/DwoFeIy?=
 =?us-ascii?Q?iCRFu3OGweUDWWQqz1AikII128cun2BEJ/u/Zxc8R8kwbm1ketdvEPCfg7fq?=
 =?us-ascii?Q?Z1+GaZk17soKAfOb38hdqZkgdSYgIOBG3DnzIAuTV+EqPNGAjHFyOPjVKAla?=
 =?us-ascii?Q?n3WNDVA29T17itVXNpS8pn8hC3ino88P03PUxWmRShXn8TyjZCDLYP2KLgRy?=
 =?us-ascii?Q?7Okg5UHBdU1TvhZVOYt/TJ/LZBCabtjNhPNHBOLD4qxX8leFYCva+LZaW+9f?=
 =?us-ascii?Q?A3Q3NEhPe8aYuo6lBR5SSvpi6PVz39Vs//uuU9N17QRbfq5bT+0kjcI3vpTR?=
 =?us-ascii?Q?KkUQX7dnEfpgn2BFk/vY2AUAZOvcKNdqF0S1FJxbmp44Hantnfm4jJ7mAWAP?=
 =?us-ascii?Q?N4Ce7HhGlEgmXdfUOuBzf1rZcgMPBR9/6WKa19FKsMF6UaLo1Rt6Vf7d7ftd?=
 =?us-ascii?Q?qtMpxy5vxcnacurFhqNkpStvddEHVxZ8txPMjfIXwkF/ucApjBerX7m9jQx0?=
 =?us-ascii?Q?U7drfixlrTE04UUAdK3Cmr7gbd/i4fsj95hLsU7wAHzsMmweclU6UQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KBilY3bDI1cdWSLG6kfzLst6sDUJsfPJzS8zrwoAUInKWBoM8UpBbJAT6faz?=
 =?us-ascii?Q?H2PieWJfSH0MaXXvYIDaZGHS3ZdE/934gdwADZgU19m9sMLYYiO/8sPJNlra?=
 =?us-ascii?Q?TfchC4/lERRXDfFTBZbkSU/NexM5L2JG+uFDhl5FNAtI+7O8dPcl68PWDzMT?=
 =?us-ascii?Q?oh25B/wkuLsWpjh3diq0EqgJX3f6PE5FowksA5cPFlWrKP0mthIW+sVv7zsz?=
 =?us-ascii?Q?sUvDGDUBbsphrvtyIpoOQmn/bVFutwC7DBwN4lnKshUsznwtKA6zJ3Gd9S4I?=
 =?us-ascii?Q?bJDhubbuZ5EQr/ebavUO8DVnsGh2A9U372hukHQhwvuUiOByQOB9PToiElHv?=
 =?us-ascii?Q?XRJ2KiGET/e4EVaHiFvPSumMLP2aNIM93WBzAXYITHRTqC23Ujz29vdDDNfb?=
 =?us-ascii?Q?Uh+VRlefgbwQvfNfY7U2Cnl5hVMA4BHgLa8uY8gbFeg/Sy8CRD7E8HwN7jW5?=
 =?us-ascii?Q?A3VnZy+4q6qKmfEo2AVnhVVxzSvQrBWI6uS1kqMQTz/gaPm0WWN4uROgtRIn?=
 =?us-ascii?Q?Cxws/MMrFFH7a6tAnlcSTuZm+vAmAPxA39RTJm41gTF/8q4Ps3dwQorfaV+l?=
 =?us-ascii?Q?EZeDYrfS/UEMBp/BwRPG77D+vdIyweaoPMaTf2hvKo8SQAGFeX+QWLDdPWEI?=
 =?us-ascii?Q?65IhcJAVWQOqtUrrXLiA4QKLKsT99HeZa09kS1Aq7WJN3+qJ8pg04d4dc9X6?=
 =?us-ascii?Q?piy+XOB6qE4TUz6lSxsPDwtAsC/YTJNBVgTRkx7ftAeRKw8cdCaO8PLAKUVv?=
 =?us-ascii?Q?zp6Qv+kPo2eluPzalRSB2u+fqt1IwC5jjH6ISS66jbumLN406+JRgfrpJGRN?=
 =?us-ascii?Q?qAnufx3+4nHb8hVC/y2Uf5TLoLuYJpPCXFXRL4SapKewZvsCHyhj8EJE4WwR?=
 =?us-ascii?Q?J6XBt2oRzki1gq+ji9oAZ4mmW/lQg1fQVQCXHVAhKHU0lot95ZQvSwQiTEMj?=
 =?us-ascii?Q?C+CjuuDFYdjpZqJI5XEOtSlXmnoQCmZXfA/fosCX4ShQcrqOIebTiWugMMH4?=
 =?us-ascii?Q?KjEBoqEsCeJntptpq91BlK13DI8Mcoe6PqxseG0hIM016Mg0Q9dVXaTrj31W?=
 =?us-ascii?Q?IOHBvNpfGYr3MSd8cdCskmTl639uIc4U7Hm/5xE2GsJQfm6JN+7fb1jZm8+f?=
 =?us-ascii?Q?IIdZD4lkTz23j3c64ElLvk2dPVDlTCnGtRWWnsjrjOAeFB6V7ihe3oVgjOps?=
 =?us-ascii?Q?ZK+ZQckoKsmQ59LgQC1hdXZVe0x1oe8kgSCPQPShm3yys/lMs0gkXzGf485z?=
 =?us-ascii?Q?EG+oCEj6p55fJ+qjQU5O4faZejCEiblHhJye0IMlZrheM7CnFd7oHWS5BSQb?=
 =?us-ascii?Q?gpBryU7JJEIh+geK+M8dx9ZDT3Lpq1t6+6iDT3g9iiHT/7JOheIyqeUvoLIe?=
 =?us-ascii?Q?eLSh3bVt/ip5TAxsBp44O+A034fDMJH0zHNRMGXzcQPbFmvCCo76oGWblc/1?=
 =?us-ascii?Q?c2oap3D++UU60v8z5Iv6VqgPfKmQN5nK1YI86DUh/ad4a8yNjaeV929sH+c1?=
 =?us-ascii?Q?WfFTsKjW8NNo407SKLEFGAY6l6REPL7RO9zzYI7+mCYBRnZYQext6xldIAuP?=
 =?us-ascii?Q?EQeojk3JxadnAeA9/LHpT2DzIgkCYLC+BWYrFeoH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 304733f1-7d96-4c0f-10d1-08de2293bd6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 09:05:06.7528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lJTGT58jaZqpsL1P5pmh7L/SeLVT7YlA5LG3C3pzcDIp65DTXclQtQvZjNhTUPWLiHoUZR46GIO3Z0OsStIFBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5938
X-OriginatorOrg: intel.com

On Thu, Nov 13, 2025 at 03:37:29PM +0800, Huang, Kai wrote:
> 
> Thanks for all the explanation.
> 
> [...]
> 
> 
> > In [6], the new folio_page() implementation is
> > 
> > static inline struct page *folio_page(struct folio *folio, unsigned long n)
> > {
> > 	return &folio->page + n;
> > }
> > 
> > So, invoking folio_page() should be equal to page++ in our case.
> > 
> > [6] https://lore.kernel.org/kvm/20250901150359.867252-13-david@redhat.com
> 
> Sure.  But it seems you will need to wait all patches that you mentioned to
> be merged to safely use 'page++' for pages in a folio?
Correct.

> And if you do:
> 
> 	for (i = 0; i < npages; i++)
> 	{
> 		struct page *p = folio_page(folio, start_idx + i);
> 		struct tdx_module_args args = {};
> 
> 		args.rcx = mk_keyed_paddr(hkid, p);
> 		...
> 	}
> 
> It should work w/o any dependency?
> 
> Anyway, I don't have any strong opinion, as long as it works.  You may
> choose what you want. :-)
I don't have a strong opinion either. However, based on previous reviews, it
seems people prefer while (npages--) over introducing an additional variable.
I guess I'll choose a version depending on whether these patches are merged when
I post the next version. :)

