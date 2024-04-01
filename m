Return-Path: <kvm+bounces-13273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C818939DB
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 12:00:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 583F4B21C7C
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 10:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB43511713;
	Mon,  1 Apr 2024 09:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXiu1d+/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333EA10A09;
	Mon,  1 Apr 2024 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711965590; cv=fail; b=FNWXQ0nVg0qPxGlEUHlfxhL4jei7qJ5EZRXRYrpSCp7EVdSxCpfp6YmgGhNqgNhRIbYNe2eoJeoRZSeOjy6Aw1s5Jd6G+GIJ+QPE4eue4CUn7UnF8tDSHxh0KnuKJWFKL0aZWbGWk0tDJrDWviMngkaDFz1YexKHcMht2w2RLN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711965590; c=relaxed/simple;
	bh=J6OO4HfpIIoM1lLI4gj9stxWRsvFA+YGO6ASybCsAQk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sdXw0/13RNw3Y82dBlD7c5ZY4+WXJ6X+1+ahozHsdiVON+oWPwvyUz0KoXkuwrMLAaWPmziaIxI3pgkgcld0Uv03xAYrYaRn0T1gaauIvMpjGXDJwF6jyOZXcmdg3GXQzsYVy4ajXN9NClLf9Dx3/SdKD5IJxyn3oHXpj031IFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXiu1d+/; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711965589; x=1743501589;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J6OO4HfpIIoM1lLI4gj9stxWRsvFA+YGO6ASybCsAQk=;
  b=TXiu1d+/VbEz8TALg/pRvQmICg/Hb0bFHF3jB8TpB10hqlRURh6juBd+
   xXZ3VFNB+VKdfE5xWdNfMEKQH1uvun/ULC5sBWd/CV1+/t7ATfwNQlczL
   0dLM0o2YxR1JfKxKpBfILvtJ6WQBuTvVmgKFOkEFd24vtnYsFsD2cuE7l
   9cSCWl79v7hOkxnVAhkFrkFWxju/AoHpJMvAsjsrePatAALlTZNOYODgZ
   TTfs6dZNf3yMV3VlpWIm3mKppbgobS/I1FzaBVUe8MKNzpWmkx/w8iGvQ
   kshi9193Q25VTdQ+cLkImAQs6ZRqYFfOtLojRD2HocpBnh0lIVhrJaBs8
   Q==;
X-CSE-ConnectionGUID: f8wmu7aXRYSYZiNNZ9JD4g==
X-CSE-MsgGUID: eU3UTP15TuGYw3X+AJQShA==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="18528369"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="18528369"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 02:59:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="17541479"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 02:59:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 02:59:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 02:59:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 02:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1yzS4DPs+zIjr9NjsCb0pdqcQpYVGHHDmoadfgJ5dvU4FX8Di+SVzeg5XDeYreikzNNLjW+a8TVHWfJM97g+5kIdgxBaC1qvqn9sBP4M0bDIAXPq45qqAGavFFFMhOxRKxInI4o+urziK+LrbpZgMxGM5tsRqpqzb3Ka/1EgVcmeVCJkepmFRISY0SA2QUlrU3gxUhVSh7Roq3TV/sMLbMDG8B/18sWcLHW6lOiHMnPAMAQ1AUXD3sRIIEWGYG5lwjjW96HaAN8UKi783ewJnu3bU8dFVmaPCRawGr7518zCHZD5ip+mMXhwdO6zTSrJvABL7+xgHjHb9eIX4yz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goXNH+1snNsiS09yh9NXqmSP5Tshvq3HFzgL4+3dhOg=;
 b=oVa/6VprnuW1zQJne061YpVk1PUSMJXuHsAe/eL/ZAyE7giv6X5Zbv2WKO+G8VCDED8PWBv15A4opug197Z7GNvjXPfPtMVIjxzIdkCW+tqEtH+I9xSaVirZqRK9c3gNiqm6kSqDhrJ1dUNmiEidv+uAUrJllG9cSMweulmIBjvsLtaf2nnstroqw6clvzqq5V15JXq/lSMCjwLdwbN95VkX0Z57NGQ6MGmCpdIAgBu8azdz7YQbVFF7csV42FYyXOBzhikwVNrHGCrQEs1tJvOYzxq3FKMEO+o9U+mzcKK5LfxuAUMm3qE/NChtM6yoSaYqoU1Iy8PkMKcFB1+jpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6264.namprd11.prod.outlook.com (2603:10b6:8:a5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.23; Mon, 1 Apr 2024 09:59:45 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Mon, 1 Apr 2024
 09:59:45 +0000
Date: Mon, 1 Apr 2024 17:59:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 104/130] KVM: TDX: Add a place holder for handler of
 TDX hypercalls (TDG.VP.VMCALL)
Message-ID: <ZgqFhx7JjhzKXjqb@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1c66bfde36f08eacbe2f5c50f88adf80e3d87ea7.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1c66bfde36f08eacbe2f5c50f88adf80e3d87ea7.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6264:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtFp9Wcn2oStEOkhrxDK2xWPTOtcBMAU+YMs4K1YZk7y1KO1pqIZGfC442JDR0RBbNWdGMp6SgmmfKXVOwo4xJ2fLUZtc4d8KBq5adSQrVb8bGU/t9KuG9pg6M9JeNrrIAtjjkZ0HgyxFEPhwUxbKH/nDuV1XJCGJuoDmp9tQ2pM+b1RSmKrx9+JkLCpavTjW5NJ4pkmGS4ERfoSNtk3hZ2jAUdzB1W5dB+3g7T7iPGm5NIpY9XHtyhbi8lvIwS203rNCB7QPMgJcIIjBKe6SSrmXTBTBVWR9e0Ovp3zb47exdEEfehE4VO6WKqqs0C53LGJr8xqaOE2ol+L+cIDMmbsyqTnZ/BvSNwQWcdmPn+nAAB5XdQTAtKMzTGFTGhAKL030mDNxlP4OaAXQLObXdFnc9xv9Jvdtgm8BPtCiVGkDwPTndb7KVZdfPd8cpzGdPwmq3OMuszzDRLczIaRrqKs3sfF51WoUgdv6r0/aNRmfiPQCb4r4/hjbn6ef/G8Q+3jgDNCQt5XayFncDaea4pSkMFAhrvvQtbVHmuQ4h8HSwvbDxU2cIwHke6oY3cvF/GbbaBHLax1IPpQ4f199zW62459dGSUJriplnIDl861IIeVN0P8zlnpOzjAjx97qul+YWWJp8G51u55vWhH6NvLhw2JRZyE5lBRMUp55vs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g9xdsYYQUaYqmCUjdEE2ukQNd+oOlL1SuL3PLUUI3xZa4NzY/7/bugWF+rYb?=
 =?us-ascii?Q?uV4CVPBa2tIn2UYqJbrH6uc/w1cwh8vxFacN4b2CeylpX1bYVgLIq1qPWviK?=
 =?us-ascii?Q?6U36Azajz+nXX9AwSQLdjyQCE9HaEYTK6EbPqABvKKvkXa8eWZ1vn66TWfdk?=
 =?us-ascii?Q?xb4nHkOIsQwjepcpW2ln9B7zEXaHJriSY2xaqv34fiqYB5RFWPKsUoS7v8II?=
 =?us-ascii?Q?XNAkpYi3HgwP7oLIB7dTFIdNDXLApNWauVSoIz0VKI+1jmkt3huOtegTKZ/n?=
 =?us-ascii?Q?mc+ov/yD7Y+H08KZ47fodykWY8bVo5d3NCvg6xVmJoAXmbt3M8lS+2q17z79?=
 =?us-ascii?Q?zMkfGoDLhrEjY+Q2I0G5ShbSYiVDE7+z8WZD5fnGhFEEu0X3jFiFV1d4ViSn?=
 =?us-ascii?Q?rh+Wpp0LD9ZIH+776gbjMnUuVM/UCco75GzTUltosNraIy3w+yJQJCoDQb9J?=
 =?us-ascii?Q?Bf39nLuiXBR8HjguErYhK2cXlsTT+hODsmMRgtxjP5CopgyrytYpb1epVK2W?=
 =?us-ascii?Q?fF0zYnXjlWtshTj/hX8z4tCrvAt6GeLbBUjZlOtSNmwcf051P105N5NBpjiM?=
 =?us-ascii?Q?815JjRbl/nhZRwOymbfCBaCs3KjUfml2CNyJ2bwpPSdfDnjb2QaBdAO3LBbi?=
 =?us-ascii?Q?CuIw1ew5+BZu46fk2YLnlg4rFTO/b9lTO8Fp1HrJxMsaVt6yrWhycL/InJ5K?=
 =?us-ascii?Q?dFDC7abfbmDMgauriaIo/sI86/f0oDQ2CwOuK4I0MeNsp93hop1hsBpihlPX?=
 =?us-ascii?Q?fpMtuE+Am9RF1orX+kcjwnsKlqWIRBqWveDH+Grdvj2ckh74UARey9w3G/b7?=
 =?us-ascii?Q?gPnhk45aIBc/EHS6pDbnhJnyNxK3hCtIcNUZDz0+94A5N3B4z9jj6XohxQS+?=
 =?us-ascii?Q?dxwJQw3fGbqsruVz9WjE6hwdT4G0A38sYyFxJT/D8tkToZ33C1Vf4QJAecr5?=
 =?us-ascii?Q?HJ6Y6VEndpyCd2g17BRjqaU10NlnjRSvXGCQ9+KpB+yXN2MBw3g3apciZEOL?=
 =?us-ascii?Q?9RpxWMr2wQaQSQ4Py0HQVD10d3hwaDhpP5jT1oKlO1reA8RFz3WpVTggSwlO?=
 =?us-ascii?Q?UdLlPaptNJ3+USV+Zhx/vF6XVaTBNw6VAEFOSgKZd75S0MGVmMJzxGU6MgJ0?=
 =?us-ascii?Q?ci+Wak23lww05SWYO6e4Em2zeY97OGcGjenqNS/XPAaOELsKRfyOThV2SKkE?=
 =?us-ascii?Q?Wqr3J/kwUlC4/TAydvd9osLJIpCF803FQ4H+6rwH3qHLAasyT4STokBzpKaD?=
 =?us-ascii?Q?MKtfGhpaofKeWnco4bKcixHQZyoa1rQdPfltZza+u/b8fZk+aVf4gv6BLfAE?=
 =?us-ascii?Q?DJDQ0qBZ0xRMS1AN0e2JRS5+BB+gqi24rqxSh3RCe6XZ+P8kE/M5ThVWQgIu?=
 =?us-ascii?Q?+9ttUUmB4XtFVr7uVtDfqjd0EvXwEGojpz2ZnbJK6mFCpMerIaaY2Q4DMR93?=
 =?us-ascii?Q?8VHp4eQ4d9R9j8DBHrCokhFCW+Unep7UAVIMZLcHzj3ZbE2Ggh4Fd4XZ1pPD?=
 =?us-ascii?Q?rcQ0IxkHcUI3uj7nEUBJj1fI4Jm/UuP5o2bAROKMxn78LlQfMlkcO/uKIaUz?=
 =?us-ascii?Q?jou3Mc5O3/WwqSS4aeWiwy1CzJRLOSvgBfYZMA8M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5644d129-3cb8-4729-a86f-08dc5232758d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2024 09:59:45.5077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6u9SAL2235bJwHIZTKknfI1EghPHyVap6gdLbv1iIt2YPg24B+7PMgvHG7+qzOkYseO/XdSv2hLsBo9G937rug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6264
X-OriginatorOrg: intel.com

> static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> {
> 	return tdx->td_vcpu_created;
>@@ -897,6 +932,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> 
> 	tdx_complete_interrupts(vcpu);
> 
>+	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
>+		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];

kvm_rcx_read()?

		
>+	else
>+		tdx->tdvmcall.rcx = 0;

RCX on TDVMCALL exit is supposed to be consumed by TDX module. I don't get why
caching it is necessary. Can tdx->tdvmcall be simply dropped?

