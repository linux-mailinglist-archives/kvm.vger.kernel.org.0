Return-Path: <kvm+bounces-62968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B04F1C558AC
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 04:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2FF6734E91D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 03:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417942C0307;
	Thu, 13 Nov 2025 03:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJQH9tgg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83270311969;
	Thu, 13 Nov 2025 03:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763004105; cv=fail; b=VoeqPJZEsvujBKPzv/Y4IjQ4EUvdNDMp+/ZBrhrDTTj0DE9jZAU4hFt/8/V9PKo3cQgc1kMAH+bzTFHnZQxaxft7NBgB6GxPGeVn7jcinDXk3K8jvm626UYeUsjVwThXXfSoyO9nokTM0iqSOjb7eq1ibphZfKYm4i0cLsqhK0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763004105; c=relaxed/simple;
	bh=VqAXHukPx/U/0LBIgnc7YUT47MFG+zetDZISYcqdZ/w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rlwLZGuyk2f2if2PINhwhqHPr0U4gjo6SguFEY2K5WS5fuLDsJccl9xcyhVUcJ4FtT2MxO7zSFB+h2eng13xsE5pI/+7ictUXBGSSFqUYMv9ADWIEcf4O5lEoUmW/11TlaVZgqNhGb2mV0sBe5R9QqHoWDr5XzVp+prSWVGZmFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJQH9tgg; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763004103; x=1794540103;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VqAXHukPx/U/0LBIgnc7YUT47MFG+zetDZISYcqdZ/w=;
  b=aJQH9tggmHO3E5Ev9fQ8Ms9ZMDzc+r9f2/VvZx6miOlPNnqO+79bZcHK
   KT7eKBX7TPn0W8OS6qeiEs1OwfuMf7dkxF73hR72rCqLjp6cQIJ9JOtDG
   UTpaUW0vkvzFOMKknNYPGnfonsXsBNl2qtMv80XIAMmbpOYO+vJvNejXW
   c+DGwEll8gSA1WdQ9t2d/JuSaremWjxkxL70thhatbCIwOc1jyUKusFix
   Oeo+H7FRyyN6N0WnpJo+b5MrCP04rv66bP4AxVk7yYibkevPK9+HNnPKE
   YZ68w6C/UGdKhpIMhKYOjS1qvJdU90RV5yFHEghcd1+2jBp4Z+MecA5xL
   w==;
X-CSE-ConnectionGUID: IPycqGdCQuO8A67lEIfExg==
X-CSE-MsgGUID: Eq9z8BPyQ3G/l1aW+qYJJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76424105"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76424105"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 19:21:06 -0800
X-CSE-ConnectionGUID: 4e/D2gj7Qk2+8OeiI7Enng==
X-CSE-MsgGUID: 005ZEOtXRIGLhWbS4tTcmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="189050696"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 19:21:05 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 19:21:01 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 19:21:01 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 19:21:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TyI5L3N5fK75qFmGIAF6yvWjSM/G4DjkX9Zv6ZXgwv+Sh4lnyEdq+JrPhRHIpRBRbmqbVVaGW/KmLCNVcmLoTH/XpLIsUYcuV81UCIqqJeEhV/bCzXYpDe2Wbio2y/cDDqJHVmuQN0rgnSN2lTWUrBjqi1CGcSYGAkgsxujkH0LG8KvdGrC3BiGvfSqJAJ5VAJmjb7QyOdvz47BVQ89a3+sGQHjNwDnyc3f0HpCM7s5M3Kg7oxDBM/fQ4H3BUrzvp9dgUnLxBwMXtXmw79mUOjuBjVnIj0xXDKev0kiOLDUZg5HaID0P9Ixv9ZL7iX/Oz1s7HiCyhxaJrFIBBllnGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ya+siV3s4B54/OC4P5Yn4Tgc4FyUqjgJoOueazMRpJc=;
 b=SIkEnM1L9Kn2R57cAjfNyeW5dDvGkeKGIgZZAr44ZjiaHC6NjaoXdXLbsNWVEPw2BWmrguRHM9YoB2/qmlkIVAuR55iAD3hCPUonuqcO0wuVCdwyT9mmpFmbdfSSLVYxrtuDEg/qNPaPMc5Bdj8UUwTs8PLdg9ibd+kVcknUs+1vK2fkvwedMDEjBYIkDIqWmm5UIuiK4tjAI26Iz2nDOlsCRHrjsfJ0oEgoj/SSPz5uSFKSvuBh11VWQhJwE+/9y0Eqah8jJoNDTALEoaMFVvjszg4IQ8fD7ftbpldpv8Rt/r0/FhFJqS0NZJiOpGaU2qPxCEo8zebzaKgE7CLRiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV8PR11MB8748.namprd11.prod.outlook.com (2603:10b6:408:200::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 03:20:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 03:20:59 +0000
Date: Thu, 13 Nov 2025 11:20:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 22/22] KVM: nVMX: Enable VMX FRED controls
Message-ID: <aRVOjoRNNmI8/wa4@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-23-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-23-xin@zytor.com>
X-ClientProxiedBy: KL1PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:820:d::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV8PR11MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf4c24d-fd1f-4750-630d-08de2263aa87
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tCHtaiimeaAb+T4KQpGsRe/rtljMSesoLK1jaY8qH9fVCToXRXR3v/E0pgrC?=
 =?us-ascii?Q?tAjLAalf/Vrbrz/fb2Aq4zwfPMiR8oBne1YzgaNkacxm0dEdqHkdmNUdw5Vv?=
 =?us-ascii?Q?Tjn0CdJRumrZ6+314y3zjb38DRSQOj166pSZJnIomS6Zxwy+FE8/Mjlu5P5t?=
 =?us-ascii?Q?Y0wEMJM+c3GEYpsVnSoUU9aFkZK6oCEbvao4e/nQdlz/GBdp5an/XO0U4Pjk?=
 =?us-ascii?Q?0RB8YnhF0ZP+VZVI56tYKxa9P0IXwMM0AEndilHGRBvD5PTB8AUEgJFlGHfp?=
 =?us-ascii?Q?93HAJDeOdMXW53+DFDB2yu10E8f8KP3uy9RDqA+Sw9KFbaR69yFekhKT4GRi?=
 =?us-ascii?Q?IeVnEMcSfOUmivJ3Eir76FPSN0F5i2yeegz7jpFcH6Ufde+BJ7ThJSZ6uBGA?=
 =?us-ascii?Q?9LMtxKeBVBQi8zoVjq5EMGiyqTAiMF66Mq74ZuA9KrDLTTpzG9RUMEYmyQfL?=
 =?us-ascii?Q?M0TuYP6fsEHuEksA67EBqxFsU4jHikzUF+JX/JnQxUsaIH9UCcw7PghUo7BA?=
 =?us-ascii?Q?tvlUlcb7UDIp4ZUn71nx+Dq+f/ytgoUGkDa0MTp3QCdsSSSvZqtwsnjMHQlH?=
 =?us-ascii?Q?LnlAMcpLFQdJ7ksVe9i3Xf2Z1Dbze7igU9koxBu/hu+dVxbg4iTkyDkG07sk?=
 =?us-ascii?Q?myDV84Qs/O0ssx9aYmSBuwqU6cMs1xO75X9dHHX03IuUCu/ENYVZnpIM+tOn?=
 =?us-ascii?Q?A4YkSDyhBDaeA4a6dzcJRZRo0v/3ZXKKXJnagkXjlsrkyx5bwKYPV6mNZIxR?=
 =?us-ascii?Q?Fm/tnhgRf3z0yjZMVs624RnDCBvNa8vgYyuYXx0qEHdLl0UKhx/LbGDRGvXP?=
 =?us-ascii?Q?ksDzAn7VKCinoy9oz+ALX5eJ2D7/qCFh8KNEgkao1utjNo8P0pksdgFKYF2o?=
 =?us-ascii?Q?QwbJ8VMcTA1r9tMFci4WfvKfTB7xt0UUqifSBCEW+FkhUX/Cie8d26hZ4ltl?=
 =?us-ascii?Q?iv5e4eS5+73n0UPTKLKdmtcwVhN/Yb0UGpM1sX8yonXGhKFYOAYuvewFfDMN?=
 =?us-ascii?Q?ylelCO8zRALxTsuaczvGdWaeNnmwTSbJ76p97GsH5TkrYzr37FG7nOzNEmpX?=
 =?us-ascii?Q?O/09gUXuvetdS2OnLQgoYgbd7oAi2zhMYxoxwYAtXYjs7+d//j5igwUjGOyG?=
 =?us-ascii?Q?SZ2xPXaXEhyav8aTp6tydOcuNHJp8v2FYY4o3jqbHaSyLIS8mcLI8Q5xVZEF?=
 =?us-ascii?Q?qEnk9h05WSUmwubP/iDTbCU+wtWIHDyLDF6tY1yoM+2sbzcDWS6HUj+bes89?=
 =?us-ascii?Q?cqt4ALKoYvK88KfHOX1G81P771qbpZiiTQY+6EON10EeSZK0ghnqXZJuWxGD?=
 =?us-ascii?Q?iQptj++wvhMeOOXGAmwiyu8PXCta7Mbe+V6y0flGo7tC4fZL1Ou6zb4RWwWS?=
 =?us-ascii?Q?g2peTcy17KQDx4TxREuf+SaDzMA2HFh32RCbltdTTEoHDpVwwqRim7XHKRnv?=
 =?us-ascii?Q?jaySzqpnE7OEtMQhyLiYF/7kPFAIg655?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xNnBNqKL/ZfWKljIwNq/IEc/zn04wd+SJu7G7MVkjPbZuonLp9xQQx2ygxFE?=
 =?us-ascii?Q?PFO28VuhYJfd3oRF5lynzjGhpAnyz2R0gpB+iw1Oqx2rlkDaahMfhnGfsYxy?=
 =?us-ascii?Q?qv9MVq/pUOIDHBpHvdcDx8LaThfRXred/Eq9E89Tpmo55MeFgbVW9UI8bjKY?=
 =?us-ascii?Q?D7zVsexFIRfDQeDI2+Pr8McwX26etZukKRMj8srW0YIUCNrc/hQDWYzrf6hd?=
 =?us-ascii?Q?M7UaNkMkCAEt00RiuyAwyWkEnb68cG1Eb1mHmXggV0SCexucNCrA4BNC2xoO?=
 =?us-ascii?Q?QqajrVXjN6TP1nL9QY170eTIkiKL7foGfQKzthTZfNyfNLLDIPeY0Ov/mn4r?=
 =?us-ascii?Q?MJ7cFEXXP2JU7zApo+b9L1SlqDrVGk8LPjd/d2jqGg9v30lP9tv7QRYkd19P?=
 =?us-ascii?Q?+znY0LxD+T3KII3d90u7JrBWFM9W6XCzUOx3qGjXKAMjP9mq93phtCm4emxb?=
 =?us-ascii?Q?Rff39EC3nkCF673Xc+JtUwxEmPFFkdHLMPFbTonIR4rOFE4jabmphUTTYIRz?=
 =?us-ascii?Q?kIkCyz2dOpFLB0iu9FZY4KNvqD1jd3ESHaHM93eP364EA8jANzZ8UUZFh4wC?=
 =?us-ascii?Q?TA7tZsHSKi2Ai8enR1GS4TOGnssNTNejNMlNBbbfR4YVM0/KY4nlfF4Fi0MX?=
 =?us-ascii?Q?v5vR8BETsUtoi/W+zfHbTCW8fIx39opPiOG0gHrwjjgmWinizjYe3zpGZtfK?=
 =?us-ascii?Q?sOP8DrNIzrjuZEBZ+NnK8mXuSMv/9hAHyeuH+BYGC5iU+A6sKZ36nCJAJWW5?=
 =?us-ascii?Q?dxF1MjAhT1aZY/ljYSAKA/yNB6lU/6x7ORyqa+9Lny1pnS6xRGDGQ5qoIU4p?=
 =?us-ascii?Q?5qbvgHkHskz2TlqW9ZXwTYv4H6H+/NIEUgfeFZ1gNV2zdcgz3kYbQjzVIaTF?=
 =?us-ascii?Q?dPYbtxZblzqR4fGMCffCld/87Yxa5GlJK7FMKGOuVw8Kz3SiUnWFv0Qc+152?=
 =?us-ascii?Q?eJRI9S/U+EK4nx0Z5plgPXJ6/M2knzpyOj3KtSf9WCdLB0xs3puHseMXA2RL?=
 =?us-ascii?Q?W9qI6hWsceF3Zhb0KzUUTdbOGF3ZNYGAznJ3cJxjXiN0jTWOhfk2JAelVRFF?=
 =?us-ascii?Q?j2VE7ZA3AtSoGRT0lMfJLCl8oXxUcSUMnM8gic06cYODuibapLvElHSyyGJm?=
 =?us-ascii?Q?XY10p1cy5CLE/T3TUZY3ylNH/hsKsmYNbwhfX7C2JFVSQz60CvHXhxPck3wM?=
 =?us-ascii?Q?yBySCEj7YSytBi8yBa1syJHwvVQpke3SNldQkxTqk9vtr8AP45M1bgSddYHU?=
 =?us-ascii?Q?+wNx0Ip3k0cx85xgeKM5tIJE5jUeb53Cy64W9TpMnLyTftAnNVbrQe48zF/Y?=
 =?us-ascii?Q?JOVFBWQstz/7JXsupBH3V3nYd/NrojxEGd0lCSnj3QbPi6KnYhbW9csZCy55?=
 =?us-ascii?Q?7cRmECV3Ba6cpkmSv271E0bKvdE4kZqTmKLdUrPTorx79qwohyhu4P6fBEOd?=
 =?us-ascii?Q?i/V6C8ppsFmmW6huDc0rSrHucidw8xZaXyxXDP0pWqpt8o5hem0Mw3WnmXX4?=
 =?us-ascii?Q?SsFMsJTX/fd7B5h/R7ti0cbcnAfCSKRFQbmgdQ6fo+5UMoB77LiPn16q6wgn?=
 =?us-ascii?Q?+aaLc5DyJpOa+3K3vaEDBByFURNBJ0Oo1/TWZ8xR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf4c24d-fd1f-4750-630d-08de2263aa87
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 03:20:59.2546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dH/CXGTuBC1JQV725K20v6RhSmS2GqQPKaDkpy1cTg0mjb49zq9imgudbuNI2VaM36BzHeXy6CswrCBAEkF8EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8748
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:10PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Permit use of VMX FRED controls in nested VMX now that support for nested
>FRED is implemented.
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
>
>Change in v5:
>* Add TB from Xuelian Guo.
>---
> arch/x86/kvm/vmx/nested.c | 5 +++--
> arch/x86/kvm/vmx/vmx.c    | 1 +
> 2 files changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 37ab8250dd31..655257b34d15 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -7397,7 +7397,8 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
> 		 * advertise any feature in it to nVMX until its nVMX support
> 		 * is ready.
> 		 */

Shouldn't this comment be removed? I suppose it was a note to reviewers
explaining why it's hard-coded to 0. Since some features have been added, the
comment can be dropped.

>-		msrs->secondary_exit_ctls &= 0;
>+		msrs->secondary_exit_ctls &= SECONDARY_VM_EXIT_SAVE_IA32_FRED |
>+					     SECONDARY_VM_EXIT_LOAD_IA32_FRED;
> 	}
> }
> 
>@@ -7413,7 +7414,7 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
> 		VM_ENTRY_IA32E_MODE |
> #endif
> 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>-		VM_ENTRY_LOAD_CET_STATE;
>+		VM_ENTRY_LOAD_CET_STATE | VM_ENTRY_LOAD_IA32_FRED;
> 	msrs->entry_ctls_high |=
> 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 04442f869abb..8f3805a71a97 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -7994,6 +7994,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
> 
> 	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
> 	cr4_fixed1_update(X86_CR4_LAM_SUP,    eax, feature_bit(LAM));
>+	cr4_fixed1_update(X86_CR4_FRED,       eax, feature_bit(FRED));
> 
> #undef cr4_fixed1_update
> }
>-- 
>2.51.0
>

