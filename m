Return-Path: <kvm+bounces-46777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 422A9AB9776
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 10:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F92D4E7937
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0893C22B595;
	Fri, 16 May 2025 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5gL/Q4R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5B282E1;
	Fri, 16 May 2025 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747383714; cv=fail; b=ano6lcweBlPlS6vKeN3N2vtE+ZqeDXA+CMcYd0YnD/S4XcttOu0Xea9AzDkOYZ1sZKWzBNRIZ6aPFfFwZL9s/nDBoCCslfdFduXuRQgb6dUC6S3Y8iyWOGnqGvygz91PlukzoMEn2qvVu4eUQpo5UCvLL78SUZ/eHFX8iMxmPMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747383714; c=relaxed/simple;
	bh=1cnvxvz97ZriIGqhCaStyUgXS4mEBBdHYljf0GO5+lE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kkAK4iB85SriECe5LenRFS2npm3Q7SnniVpGLUf6qMJ/lFu6WaJ/+E1xoyBbBMaoEI8Cm2/gtI5o1eXzfSVpECEyKBfOLHZQQ1vDXawYBTeW/euUscylW1cyUTv2DM1xs9chSFydP3XETitYmDO3K9RnK8gaE2nzSvdvcRFKdDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5gL/Q4R; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747383713; x=1778919713;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1cnvxvz97ZriIGqhCaStyUgXS4mEBBdHYljf0GO5+lE=;
  b=G5gL/Q4RVHS1BNs03gQUoYfmFxJY8X3rzEZxCACpxdVEk08MqfjM1xtP
   N6VPG9mnCQIoAR6klmVgVQqOD5hjqwkw+18hbS2P96yeytPk9A0A4V1ia
   eXAvaxz977VWMYCW+vBVF+zXMW6XWE044L4NzUsbzXhaBko/i3+PyK1EY
   jPFYzlxUm8TFSWFNm+e8mTgsph1lJAwhi/5KsH42n7vCPlF/SUYhBmHpo
   Y5ZjxjrOk40xnQlh2/AEFSllL/uyDXQu6M/TWo01p2henKgDHtZ/Cy4zW
   mEyzPZ5GSRQEEaWJXexCb6okCF8w73GmohRg9AGaN9xuZV1iXl7anUyVe
   A==;
X-CSE-ConnectionGUID: ZR0hzQl8SPuj4eSOwa1TVQ==
X-CSE-MsgGUID: qnQ2rWUqRA+kfJep/yw9BQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49246330"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49246330"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 01:21:52 -0700
X-CSE-ConnectionGUID: Elj0mNTnRoeymli7EvR1Kg==
X-CSE-MsgGUID: VtXP/TxHRrqXJqMAqv9yag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="139629252"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 01:21:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 01:21:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 01:21:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 01:21:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TuPr6Q5fzPQn7bp1V8FQP4rVyEpzZVAPA40VIgYbi3kGUQhCFh7fCC+FCluwAAFuIeZJWp9GnOG5MeqjBUZChdHZySeuSV6rehswEwAc00853FQU3r/DZ+ac/XaAiO6TwbJQJ94oN3ntvxCSHA5sAFTD/JIW30EoM7bbyyUds+K9+xQHVnXENGA7H3Sl6znJWAcbwjVsq8H72/2d9EF1oZqIL6OvjE5ZeGpDWn9m8zBt/je5utDC8+hgzrMPmWUHbOuV0SUWuFgwSfw/WsGyrecEgMfLnk8dwFQRmk/wVGHgjQG0LE/h2cRff2Z0YppQ+5AAK4R5PkafFLPVzjwF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tv8MQor+S8hKR2zXrQ3Fodw80RoRrcvRh9ZezOVpJME=;
 b=rlO3nMXbM57PWwlP4z4nbyVvuCH6AQTogzl7xlpRWOvJ3b4AXy5T9CdKOyzDYgELwDsvLo36TtLuLNhnn5u01Whb5Sgwe7bJVh0IiaG3hpodiPjSjG4+CRzFfhaZW7wlYiL0XNx/mcHLIez5Dv69kSKywYjKJ7e+tE4bHItFzUpcJsGACF/3uvvJKvuwEYqMTfohd1iv2McDisjMODZhyjl+Y1wkknpZVtFDb8jjxoxITbgOoZCdZ0TwesFVMTgIgR2ZjDqabG+JLcWYfYZF9dxyNNc2hnwXtS5aMlL1KwgNh6E0ZOl/pbArQp0Ne+TERyEtkyKKwKi1klNW2UK1lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5865.namprd11.prod.outlook.com (2603:10b6:a03:428::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Fri, 16 May
 2025 08:21:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 08:21:45 +0000
Date: Fri, 16 May 2025 16:19:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
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
Subject: Re: [RFC PATCH 19/21] KVM: gmem: Split huge boundary leafs for punch
 hole of private memory
Message-ID: <aCb1F4D6nIFVokNm@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030858.519-1-yan.y.zhao@intel.com>
 <5749b89695679d21542efea03035dc5a682fbbeb.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5749b89695679d21542efea03035dc5a682fbbeb.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5865:EE_
X-MS-Office365-Filtering-Correlation-Id: d8213d25-f075-4b15-2425-08dd9452b1d1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?MsmDKwaLVpdAsC9TudNu/1i5vQIR6arvHjA4mcSx9HgdxxemOQMr6Is7ci?=
 =?iso-8859-1?Q?cMLIuB9EXMPNJasXzcU4FiJd/nqwpEmbfCG/2ZB7zcMA2Qe3hl1WjpZ3am?=
 =?iso-8859-1?Q?M8eJoe4m73tJ9saQG7tEM5UCiqP3qwZewnRPHYBKGpNXLcvMRC8vw7eIIo?=
 =?iso-8859-1?Q?/PmvLgNc9ayUsU6vkCiPtUfmsimUXD8JpPs3ODlvWji3ov96wdR5nP4FIl?=
 =?iso-8859-1?Q?nBoMs4oH5qSuhT/mkWDyVKnvBqbisiatFD7/11mt5sDgKEMr0l7qVtQ63n?=
 =?iso-8859-1?Q?K1XAytDgLZd5vsiebK6JSh/VvWdNc+5QNWQccqYURCy16bZOq2aNP9vWrS?=
 =?iso-8859-1?Q?QYbxoxkT6iAzg9zsJjbTEbzdm3A7c3S/SFkvgKdq+4RrWbreVgoguqQ768?=
 =?iso-8859-1?Q?1PvRF9OkGoeuL1ez9i9YNmtW8oVxUPdFrujU6cpnVEM0/rHnF91Cx+UNqI?=
 =?iso-8859-1?Q?OLaIy7WzXsGP9YFeY4OBgrb+fiLNQiuuevv1Rp+CJeVnRDEkuUa4z7htHa?=
 =?iso-8859-1?Q?2pgwGmn72mL7CY5eKxEKP/+ibUwWMrPQtRiUcEK8h5FPFDOl9UcmQpj+f4?=
 =?iso-8859-1?Q?p2EUA7PVBaw2ySEp+c8K5CPRaQuYutHkqrQd1+LOGNKJjDojdfBzG723CL?=
 =?iso-8859-1?Q?HeFQfP63mFjvTF8qb3k3qM0/cupf4DgHuqFm4vdVZO7DxdQAYpOi49KGAu?=
 =?iso-8859-1?Q?AFbLqVJ5+tR+/b8HUailIytm/74AudmnlLERqilBAZo50VkIAV0K6olGDQ?=
 =?iso-8859-1?Q?VvN+yKG33mMYz4lqQ43hrch+8v+1GAo75Gy6F9dFlMy7oIxFh6mBYJHIsM?=
 =?iso-8859-1?Q?VKI/F05SeKGH/hnnoBg/hDyKemEvgLJd1oons0b9HXZ/1FGtM8GmMjZ8Hv?=
 =?iso-8859-1?Q?IdZDLUKNIJiBcEgPOoTgrzZHEOj7vwGFcBrGOG+i6H34qW3ubgbdCkWea+?=
 =?iso-8859-1?Q?7gELGods5440ElrAtqnNTxQbFNVn0oEqHmYVi5yVVivXm+4W8PTI8HO+YN?=
 =?iso-8859-1?Q?wCpUIALdAibRrE4vDBEE8nZkrLfC8/3RICIGFnBMSqP9fv5mDUsCZWtElR?=
 =?iso-8859-1?Q?V5aOghP56mfiQtiDl57FgZlf0gV6vIcH60plWEJcU/+EJNGyICb3BELaF/?=
 =?iso-8859-1?Q?U7wceI/jAk506ezUHWXznfAuAzJZx3v7wbmNOTBOrUee4isM7zvm+O3zXE?=
 =?iso-8859-1?Q?Vt4FnIKP3/SUCy3cbrSlSfbaVUC1I+0RDsPsajYNK3M1RvX0lFoWKFzUJQ?=
 =?iso-8859-1?Q?h6cJztrTeVFqVu85/baU1DS903W6HujhRAZP5KyUzGR0+KmgJ4YKIoHCoT?=
 =?iso-8859-1?Q?BjNShNloujmI2l5dpCdfw2QXknK2LVO5LFUVZzN27Ra9TrUJ1Zo09eNSLn?=
 =?iso-8859-1?Q?vc/+g/uJQjIe1KcMCyaCg6hEf6fiV1y5iycF1PgOFQCormFrI+PFWqARi0?=
 =?iso-8859-1?Q?3umf5KxNSSa8yQ+me5o0Q24k7adcvZCFzOz9iO9CNvGhmeDVsFaiFDv+et?=
 =?iso-8859-1?Q?s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?IAFLsE4+L/p1KzDzZCVSCSwlVR7ee5M6XAZILkWU5wugADKN6P/8gurzbR?=
 =?iso-8859-1?Q?/I0FEgWfUsdTTvjq3Cxb8ZCC1W6JF+NcSfaybMpc5+UisMWrs27/uMvT2Y?=
 =?iso-8859-1?Q?MxXU6l/PMHo6ViyGUkoFR5baEcU94CeVwe3Bf22iHecq01wyep2QCRkr/I?=
 =?iso-8859-1?Q?mafxa1O1sxqRbyAaAKBKF4LBun8T32HJUfjuzQzZHBgAuqgc2p8zVQoSMW?=
 =?iso-8859-1?Q?UQKux2Sm7/N7VB7HtKW/Ko95PeZgKEtmFQCftGzZg/xWT8dRAEQD3v7l2L?=
 =?iso-8859-1?Q?J3S1AgWlhknMMgQ3pVWPXSEgbUcsdBohw4WCDkM69oGezxTGIuxIn0FWtH?=
 =?iso-8859-1?Q?4ctJsh3jD0a6vwMSU0Fcq7oPBf1HoIBGBx9A9TnEAdPL7cQqdLHPfBvGoF?=
 =?iso-8859-1?Q?o16AsJTSvX1jLVHS5D524wkRROq+YyOV5A3ewxI5GGbNOFxP+AFd3+fl2O?=
 =?iso-8859-1?Q?2VA+akvjaWzx2RND1KiE+z2fXAYynRH8PVwKEJeTL/ZjFF4rYhAs75C8Vh?=
 =?iso-8859-1?Q?++hDdDPeOfmJcgwXV/8zWxoYy22aij8zNaS6IQMPga4KPTZxSkSUxt454H?=
 =?iso-8859-1?Q?94kEjTx6vBtB+3lSeVAuOJS2aJmkuQvsV092g4M+AwWo8rSAnw9L3puiQd?=
 =?iso-8859-1?Q?C/uFsB9jpuRq+dHmKCnEQAvtdykXU7c4WxH+8+J5tf1jtNQSIKBr2LNfGd?=
 =?iso-8859-1?Q?DfVVLcPJedS/CgxZf4PaJTJ136eAa+e5XwaYwUyb/cz8KgibYA4rg+cFYd?=
 =?iso-8859-1?Q?YW1tPxc4glYI/VzrMFVwZo2JrjRhk6ztXneVyvvpbaINb4Hmaa2OcS4rpw?=
 =?iso-8859-1?Q?zeBJsIYmHRzxw5T81/tay9ahJf1GOzFs/os8mn2InOzbfrV/6ioDDWRyk2?=
 =?iso-8859-1?Q?/aBcRJ12d9daOPJV6MhBuO8X+T6ohmhOqVPttmCYMNxtzZSKq4g+n+HDmT?=
 =?iso-8859-1?Q?PmO2Ylz13uzBo6AKhoHoT4AX4Z4E+2YTMc5jRTx1p8JjAYVWDQwxh7vdtV?=
 =?iso-8859-1?Q?8AC9sLLoTXPBwqKbemeIh77kTR7sAuu+Haxakp5eBW+9Sfba1JAEz+++pj?=
 =?iso-8859-1?Q?L3VCe/GUfmUKtRrubS9R4dKbHV7sp+2g+uFT0Qgh8AFQ+c0hOZEMLdtc4N?=
 =?iso-8859-1?Q?D2bJqWVpyalqdE3ajxjjcgrnTnGGGtZYlqJd0YSHwm43crQOCBjnzxWIwr?=
 =?iso-8859-1?Q?NpdhKsi/S1dfYJ2eZ2wFwvDkKXalQQj+6XRD3ijeUmUqrOEfbdvAujCxMN?=
 =?iso-8859-1?Q?hnnjT+IJr6CHOclWchkW+3ZyNht0F1tcJvo3afY1WQ4cVxtS5gS/LeLpdt?=
 =?iso-8859-1?Q?G/dPALp+8WgpSUY3FbBASeZOw9Vlyaw909ZDfPLVmvEfTLAaku4fg6lT/S?=
 =?iso-8859-1?Q?ZiIGg1lS24eZr26+hHSZEB8D6pqfeNmgeB7Pg6QFRqGxPzn61pYnK5i1np?=
 =?iso-8859-1?Q?9HzvckXz2TnipVkH6JiKPKw2w1Joa2qriKne6ulYEIIDDJgqTKmzUe9FkL?=
 =?iso-8859-1?Q?JbcB/voB0yPW9sfI5jODFMYHpWtrdCDLX5YXaOKOY29BO4dz6F0Nyzb/DW?=
 =?iso-8859-1?Q?vIU8Bp15F1H4tq5QoomoDvZ8RGmRw9KWdH03XjmUxVbZIGhs/pEh2Ap4ir?=
 =?iso-8859-1?Q?DEevq+2JXSfe8jrVw2IM3ppz21jaH+34nQHTjipAuFWr/vhbyunld5BA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8213d25-f075-4b15-2425-08dd9452b1d1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 08:21:45.0073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qof6kDOZL/Cr9gJp57w4M9DBcTsJqAu1myO1rsmbMWnFNzSa4xYe8HrOS+uWylTRcLz/TD+ctjyOrWUMrtG8mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5865
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 06:59:01AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:08 +0800, Yan Zhao wrote:
> > +static int kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> > +				     pgoff_t end, bool need_split)
> >  {
> >  	bool flush = false, found_memslot = false;
> >  	struct kvm_memory_slot *slot;
> >  	struct kvm *kvm = gmem->kvm;
> >  	unsigned long index;
> > +	int ret = 0;
> >  
> >  	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
> >  		pgoff_t pgoff = slot->gmem.pgoff;
> > @@ -319,14 +320,23 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> >  			kvm_mmu_invalidate_begin(kvm);
> >  		}
> >  
> > +		if (need_split) {
> > +			ret = kvm_split_boundary_leafs(kvm, &gfn_range);
> 
> What is the effect for other guestmemfd users? SEV doesn't need this, right? Oh
> I see, down in tdp_mmu_split_boundary_leafs() it bails on non-mirror roots. I
> don't like the naming then. It sounds deterministic, but it's really only
> necessary splits for certain VM types.
Right, kvm_split_boundary_leafs() only takes effect on the mirror root.

> I guess it all depends on how well teaching kvm_mmu_unmap_gfn_range() to fail
> goes. But otherwise, we should call it like kvm_prepare_zap_range() or
Hmm, if we call it kvm_prepare_zap_range(), we have to invoke it for all zaps.
However, except kvm_gmem_punch_hole(), the other two callers
kvm_gmem_error_folio(), kvm_gmem_release() have no need to perfrom splitting
before zapping.
Passing in the invalidation reason to kvm_gmem_invalidate_begin() also makes
things complicated.

> something. And have it make it clearly do nothing for non-TDX high up where it's
> easy to see.
Would a name like kvm_split_boundary_leafs_for_mirror() be too TDX specific?

If we name it kvm_split_boundary_leafs(), SEV can simply remove the bailing out
if they want in future.

> 
> > +			if (ret < 0)
> > +				goto out;
> > +
> > +			flush |= ret;
> > +		}
> >  		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
> >  	}
> >  
> > +out:
> >  	if (flush)
> >  		kvm_flush_remote_tlbs(kvm);
> >  
> >  	if (found_memslot)
> >  		KVM_MMU_UNLOCK(kvm);
> > +	
> 

