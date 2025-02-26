Return-Path: <kvm+bounces-39222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C27A453CE
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 04:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35FA67A3A0D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D1C226885;
	Wed, 26 Feb 2025 03:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KqnW7RoL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DEE155C83;
	Wed, 26 Feb 2025 03:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740539454; cv=fail; b=Bp4HZFzwZDcyeIILXpICO2aBV0wJ8bAlHkh6wbnjg8E/+90BNSbCAnQSRg+iWj6kAOn0D1cLTxl09RW2Vsb5t/Zdu4jU0dA4jg/45S5I+LdGCDtr9t3JCWUhMzgOcnnOHlO7s6pV4NmjhqsoJrdj9zWKCDXGvBlAcfXei3Mg3pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740539454; c=relaxed/simple;
	bh=fkabHcydRnhK6T+8u88Y2CuceUd1c+UhbnONnO4natA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VJhHgG1+4nWWQULJ0oAot/kFr4WE5mJohq28WHXgoBy0++Ly/IuSRch5Qqat10eGNSU+Ya3gzWVZJvgwL87beAMuSf07lW31DMVOkBrEbFwlgCbRGyLJhm8mnJSt9snH1wB4lZYR4U0mSC/jlwI5QTyefa6ei56+GChRn4aaqKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KqnW7RoL; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740539453; x=1772075453;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fkabHcydRnhK6T+8u88Y2CuceUd1c+UhbnONnO4natA=;
  b=KqnW7RoLsNeNSTG/oPb1+g1h7JKnknahV9im9cClwVd9TYTvUG8LXzGR
   /E3vFz2l6EdDQiwe4GuKRjUfycv7cwoUuvW7EtvVZBaUA/9lXJ+X7dbKy
   sPbPy9/uIVHQJw2IQ7X/DJ/FTANXZnTwdLOySExdZMKX76yVysuSQWH4a
   grlKeucRXfiaw1Q9iUYzJ1398lh2rqjSNS8HIA9sFP8DASEj1B4gvE+pu
   WTsWUp8s2a7GZgrW+ax4OrcwQE1IlSfpRz1ytGH54GKHKdRCWx0t7Tk3X
   ZzEMLJ5uGsuAfxzKFoKTLyfrpXXWw3oIeKsxqAB7tJnrk8iIZIKG12clV
   g==;
X-CSE-ConnectionGUID: dcxbi27XRq+tMo/6CFRD+g==
X-CSE-MsgGUID: cenBZ2STReWO/X4Q4nfPOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="52370463"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="52370463"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 19:10:52 -0800
X-CSE-ConnectionGUID: J3277kq5QFC/lhTdBDsBWA==
X-CSE-MsgGUID: lwcZbuvATw2l9riMNTBYiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="121573621"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 19:10:52 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 25 Feb 2025 19:10:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 25 Feb 2025 19:10:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Feb 2025 19:10:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KRzVTtsqotwA/qniN42nNW0TEGxdq+QQIs7wAt9lCM075U0VhlRfVejCCgHkLlhizLnDbr/mPAQN9Wl/+ILq1Bjcjw2cGnkctI8J/HdQB0HJeLRCLAQCj1lSrGY94K8Y8PsibHxq/RAZQJbr0TsuYoGNzEAbPBupUPpYEwfdB5M+vEB298z7KVkGCBQycX9T+ToyhR4qWXeBvfMlEO2HhlrvZlyPBsoFanz0yBc6Fv0j4b5UBYdtOnqcqczATrjkdOLFfpCEt8uXl/8n3xz5qhwzwayUlfIhF2xygbdLw1uZzfeWzEnVikGKyTENU5HgKhW+ibf4Gzu9oXBvaGzbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBqjACxBhHMGI95U/v0MjHilm40cs8cWWPzEyvoxxM0=;
 b=v3vv12DBsWE1biomRXqzWaS8YF/wQYDdCDZ4XN9DXoCviSL1yiMe1zv9vpVqnyfksP2aCRgYksJLLacciix1AQ3gQg+cHsTFzxwPLqgYKGKwrGJGZ9gkxYkRzlYoCi+dtxEIupqynFBN9uk23tv5MucHx0cjs8025JcJaomvERvh0mqDoBDYnZWL4eJ/swIUWeN7ijPmBwcW7et45zO1z/FoISAU/+Se/ZyRM5/LnZdySehFhwbziaYHrl7sfk/cFESzRYabd1nxu+Hx3Pd1oTFfONUOlVdhNG0LGwjqPyZoLdSpDkOIQrBDh+5xZAxvmaCDPKYENn1eoPGFUFYx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PR11MB8758.namprd11.prod.outlook.com (2603:10b6:0:47::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.18; Wed, 26 Feb 2025 03:10:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 03:10:49 +0000
Date: Wed, 26 Feb 2025 11:09:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z76F7M7o3mVrQyX/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
 <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com>
 <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
 <Z750LaPTDS6z6DAK@google.com>
 <Z753eenv5NKkw2j/@yzhao56-desk.sh.intel.com>
 <Z756Usy6JNkf43PP@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z756Usy6JNkf43PP@google.com>
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PR11MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: e6c2b7fc-a5b7-4375-ba97-08dd56132b71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3WNFbXb1vId0CCJ53xF7XLgStiPFX0A2PiPcqYu7/TUR6hMpr50o3lx4K7Ri?=
 =?us-ascii?Q?IGNSMQm6pVi9ZuDMxuOBLt5k9lDxQ2PN1tZH+oc+lt99pqmKT9H8dAMH1I/W?=
 =?us-ascii?Q?SKuD8rmv5ddJbmxFySOCyUpi4D5MTsKLDvh2OM5a4iL7UsGx4nG67KRWruwO?=
 =?us-ascii?Q?7gxquzCMKZ4TMD+hkheewDQxdpHvtPIKX3SutcOemu+gEL6upV5jZgcCC808?=
 =?us-ascii?Q?b5ZMcPrO5rPoPpyyNq7IOWJUbuXerbWBA53NZHCtHca+le93KFb618s96zIo?=
 =?us-ascii?Q?uDQCqVTUqHMk6u865j75P+sOK82heanCfRqWCiaG6J/KmoRANIFNmxbXosa1?=
 =?us-ascii?Q?9knc4WdFofcjOjbXlTKsqo82Asa9y+UHh+dRi/RZ0DH7krBwuFurxaSXu7Ni?=
 =?us-ascii?Q?GK250mnvKBBamTk+naDdqc+975ShMF14xrFvGgryfwT2NsvQOn6bYKNJ4oxi?=
 =?us-ascii?Q?bNXCksnfGsSpH3yDZ0HV0S4d2OOTkepwmvpA6gYC6uI5Kv0QeAj6/La6gL6l?=
 =?us-ascii?Q?32hrQaoWpDyz+F6qmShPP9THH6+1ysMbBS981QZRCd3REsTwLZPXOkG2u6SH?=
 =?us-ascii?Q?REp48ASemlqcHU9n9pCKo/XIxss/y2FIAwVcCpv6M6//sdfVxi4Xo/e8ddhM?=
 =?us-ascii?Q?jsJo74A9NhnI9dSXpKpiIjls5Y5ups5BbLKoBNo2SoMeaAMl1GANMWhsk4PP?=
 =?us-ascii?Q?KR3RS1+qvTbOlKlcrWYB4Q5QX4HDlcA2ptfvWuPpWu1fgGviVjKUijNgci39?=
 =?us-ascii?Q?VwmF/PD/AEhL0HGnVrIbNtwF0Dpywwo016onzxV8jqLw5l7bgpOK4fOrcOni?=
 =?us-ascii?Q?34FMnam1B3BC2VJxkd80/oj1IqaXetCHqJWqgvYJ8p/n3+GbMGPLvunZ2QuL?=
 =?us-ascii?Q?gDqC/4H5QqgvfNWoLF8oLf5f3zXzGrJyB/Rz/RppVzmLSua1oQugsMoytcN6?=
 =?us-ascii?Q?oDssidAsJyxg83bE5Y2ndEDiutu9kjwXksTf5m5rufQIf+Tw9MMG9u5mqyNr?=
 =?us-ascii?Q?/btGTYis0ssFaOTHcVGW2wg4S/6mhA2snJowySQD98uuI/MkxEj4TfWUFLaC?=
 =?us-ascii?Q?e/9yeJepXk5wjkXYRyojF33HyOwGJtbPBQtD6BgEqtG4ROeWnKzzSXSkia4V?=
 =?us-ascii?Q?Gde4PnPqBZGQsWtQnyRkp6T7iMzHk89TKldAm3RHP3oXSR/e73Z2/R8lY8di?=
 =?us-ascii?Q?8NQCdD1Wcij1ADuaJ+FAbjiag59SF/5vWbq58KuSgydg3bOizZNWvAa2rRm6?=
 =?us-ascii?Q?sdUm63y0iaNHLlq/TPE0yFxZqm5cSEY6Ghzd16Zxvc8rFgt6DsjVQC6L6yeo?=
 =?us-ascii?Q?5s1CNfdPLi4e+YcKVnBLCVaFVK5htBY2f0hLHmG4kcDT8x17w2Fy4nyWfy4t?=
 =?us-ascii?Q?scq6emoK5K+n97ImxlTz4BfppWyu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aKfRkeW6zORKPYJXao8Kjj9vWTlErvsT5lGZaGmOO6XwDRrhOWwsJsie/Vb3?=
 =?us-ascii?Q?BaDxGeUvlGICAlrLipXm9CeA/Xvq5MRl9f0UzqQKSSywvAKurl+WreUlnG10?=
 =?us-ascii?Q?E0FdmBT7815s7VpB+m5WIJDCNq82TnspMhpu8oiJDolIhJqhbS6xbkMUhZRX?=
 =?us-ascii?Q?RM9fC/DKDpv7iNs3FrrSDT0Zz22XTF0Sz/G45pxH8Tz9/p+hxJWVPpyDcz4z?=
 =?us-ascii?Q?1KcGsGBOwocDgOAm6RDb56XOuUy8Om/E6c+/OnVlSF3PQbT3vkwKySE6NbF3?=
 =?us-ascii?Q?dM+22a2JN4oUwfjz2FUd+8JV3fTqnOKfoZ/Cqn0//y66dlHyaiv1GIdgMZN3?=
 =?us-ascii?Q?kr/YiuyLepeaBYKrnqHFqWFEh40tufN+bhSP7+UErki8O1/FeF6mDArl8wwX?=
 =?us-ascii?Q?6msoHrbTbxuktD3pJCZ1A5ZZb3pD/TtzDVcK9+IBEROCNgOzn31+ia3UYvA4?=
 =?us-ascii?Q?mPBcNS5XKjhR4bp5WFevmdvbr6egIL4Y07ZUEKGyJ4vmv1doDHY1QrtAmbud?=
 =?us-ascii?Q?3J3AcVt8Qu2xo3gITLAUJIRMynyBrqCNT2Ad7PpCOxeuTLJ+4BnQG5B0WqtU?=
 =?us-ascii?Q?I8xaW/VaOaO8cnoDtQ6Bz7MfFeK2yOIaZlf4UNrOysyc6t0NckcUON4iuRi4?=
 =?us-ascii?Q?GZYO6tQIRbb0gpJzI5FpVhgSEInz9XjpD61iX89m+hjjyfr4uEM7nzhT/dos?=
 =?us-ascii?Q?Ueb3MHi9bRo1yjs6pcHl6mQEgrLbXnEMpnGYmPFCpWJn8yiHv4EePqO/qOrs?=
 =?us-ascii?Q?o2aUd6UikMc6YP2DxeSFEYZk4pCIjP1XiGgYXJAPYdhttFLs9Cp34EcEQN1p?=
 =?us-ascii?Q?bybIYsGNvynPWqrdwG15n9KIJ6i4oLeLOVqrvl3l9h15hgcpSPcIJO1jZW2c?=
 =?us-ascii?Q?xdPIKjII+8gZv0ZvkocUsbCc+oNorQUDJW7ATc/+9IbfIUTdsy3+B/2vsdAq?=
 =?us-ascii?Q?BYD7Ijz0LENpO72Kzl8SPO6JLffnpKGL8URBMNuNxzhEfWqBefBS2exTzo23?=
 =?us-ascii?Q?qTuF1KDMlVTGtNm9YGlMuuOr6m3Wq4b/e5hu83TX+5u312PdC6VZc9uubeqI?=
 =?us-ascii?Q?ReO50vQNUi70BQcV1kNLv2pQz/5WrCmQzO97GeQ5Ks/kXaxVR5/2OuD1J5Tp?=
 =?us-ascii?Q?u78uQS9FUcNkxSEEJqzGEoX+S03n0wihFI+DIpRH2SW3jSCLUlfDCzX0rwJF?=
 =?us-ascii?Q?zSYBi/UdpiHC5IaeYJ/KkC3VlTuvuL72BD6CjBcz9jaSh+agZTTPBj4IKqHE?=
 =?us-ascii?Q?nuefX37vQN++GZ9kOFsT/4vcYEY8zToW4niBKYAVUXjmZvgeB6soMfihNiOV?=
 =?us-ascii?Q?2p879Z1wiu8eJa6V0qpOb2B2SKJPZRRboWbLpUUKRW45fiTO/Ow6aC6IfrxW?=
 =?us-ascii?Q?6MhBNFfYgFgYBVqTkwokmNhMQwnHweikBJhOGxUAEp6ATXGRUnQsCvbPowV6?=
 =?us-ascii?Q?Rabw+GKjm21XU34Wel5ibXM3y7wn6McKI/DkxD/6YKPIBtm7DiY4r4uLkG8A?=
 =?us-ascii?Q?7Xpiu6fNgqrSnI5AKvom42AKPV1H3Y0RzJ/fq0IgIcCy98iewd6QUAq6pj/B?=
 =?us-ascii?Q?4jMwEOMoo4WzITIjC9ysP2h1Qzm0vrVl5yARHaj1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c2b7fc-a5b7-4375-ba97-08dd56132b71
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 03:10:49.0569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FVRCx9Oh5QyFcyBpiUMCuwR7r5sDAzYTLem94I9yp8QV+VmGnS0hOtFN3xRUP9fMoC8GL4WOBK0AbVTHliPcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8758
X-OriginatorOrg: intel.com

On Tue, Feb 25, 2025 at 06:20:02PM -0800, Sean Christopherson wrote:
> On Wed, Feb 26, 2025, Yan Zhao wrote:
> > On Tue, Feb 25, 2025 at 05:53:49PM -0800, Sean Christopherson wrote:
> > > On Tue, Feb 11, 2025, Rick P Edgecombe wrote:
> > > > On Tue, 2025-02-11 at 09:42 +0800, Yan Zhao wrote:
> > > > > > On the fix though, doesn't this remove the coverage of writing to a
> > > > > > region that is in the process of being made RO? I'm thinking about
> > > > > > warnings, etc that may trigger intermittently based on bugs with a race
> > > > > > component. I don't know if we could fix the test and still leave the
> > > > > > write while the "mprotect(PROT_READ) is underway". It seems to be
> > > > > > deliberate.
> > > > > Write before "mprotect(PROT_READ)" has been tested in stage 0.
> > > > > Not sure it's deliberate to test write in the process of being made RO.
> > > 
> > > Writing while VMAs are being made RO is 100% intended.  The goal is to stress
> > > KVM's interactions with the mmu_notifier, and to verify KVM delivers -EFAULT to
> > > userspace.
> > > 
> > > Something isn't quite right in the original analysis.  We need to drill down on
> > > that before change anything.
> > > 
> > > FWIW, I run this test frequently on large systems and have never observed failures.
> > Could you try adding CONFIG_LOCK_STAT=y?
> 
> Will do, though it'll probably be a few days before I can take a look.
No problem.

> > With this config, the failure rate is more than 90% in my SPR non-TDX machine,
> > and 20%~80% in my TDX machine.

