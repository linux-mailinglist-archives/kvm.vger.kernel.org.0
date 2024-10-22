Return-Path: <kvm+bounces-29345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F709A9D5E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A81D81C21136
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 08:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE7E188918;
	Tue, 22 Oct 2024 08:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HvPXfty1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEC315574A;
	Tue, 22 Oct 2024 08:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729586905; cv=fail; b=IR/lFzxI0Ec0VmO2B987O4HPrzet8IPbFa5UqUxF/rk2juT7gG9Wj6A2WCSpTGG02EQey1F1xVBgqIW247CkZVcYRJz4SKBWu3EDPX03caG/66Y3Ix+4AmJpIu9SCLuSCaEkczT2Fswc9mILtWrNmXx9mNwMoWFxd4+BxM23gnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729586905; c=relaxed/simple;
	bh=jZO+o6Q5WdGxOdfuPyNfolXjpKr86ntleGoliEpG83A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HC/jUAE+77xZBGUSCk3cnN20XE0AOQ+tca2dbPRPMJmf5AIdxpOQ4LrSCHWV2MOZFRDqgrBDO7/6JybsM++TqCuHsYlYzEEuOkDXYRuVIxgny63x3yD4JHQjjLeNQHNFGlaI/rE5vbNHeQ1emW48CXWQOLb3EBSMXe/PSTeLrN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HvPXfty1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729586904; x=1761122904;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jZO+o6Q5WdGxOdfuPyNfolXjpKr86ntleGoliEpG83A=;
  b=HvPXfty1OtnOM6RILeQ+ZKVQNYj3Vl95zHkEQsQH2cRyoxn70FYWiZx1
   hnoUJiglanLjkf+dKJ0tSQZelhQXONumreWWrpHOS7OmWPpWEF6gSuHxF
   oos2Iqo/eW6qe0zto4B3St3m/QoCW09ySXStaobZ42AsuT9QYyFwPZ7ii
   fyykcJlAZx093G6oS6egdTq87zZEI544rIvZPW3X6T7p9/urrSA42St4j
   7C8fvsTTczTsRjZWHzc3vLJRP8ZhjnxggnXfSe9Ar8Ty0MFu1q2p01XRK
   wg/Dp1axCmVKQjAhYJ8hD/KQztYDKKFGrpSCAcRo7LmC2aXqUulAmEQHn
   A==;
X-CSE-ConnectionGUID: N9Wd4Ad4Ra+1JFhcQvEVpQ==
X-CSE-MsgGUID: dA+tI9ZNRveqMFICRiJr1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40229013"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40229013"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 01:48:22 -0700
X-CSE-ConnectionGUID: yX7TGVkhSBqdHHE/HIYZ/A==
X-CSE-MsgGUID: vsnK1ehwTKeWrW652RKoyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79966573"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Oct 2024 01:48:20 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 22 Oct 2024 01:48:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 22 Oct 2024 01:48:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 01:48:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnECvOsrtOHjlT85LHVj2RxBOCty0ENOtI0SHqbWlJHu0k/p3J2zOq9VEkQ4PCZF0IoGWs72Z5E72pcWMc5NyvW43eDodBr5fDKTrRaTKovsl38CHHSCCeqgEnAALGglxES8e0BnJQi0hD43JDs0uJgUMSFRidchaR59D+AKjFOVUjxgUqIMDkTZwtCKjgqaoA1Rm8/urDt7lGLZ613EfhVNbIfNAJUhLl4e6ZQT4wNglq4Eg6ex9NvJ3VvW5TBXpCSFqHi0mvIHkp9I3cKTGYI05eTeqW5/49MqbtoLHSaYBSPv2XjoP1Sz1nM6Z7dTALRzXEo1zw61+rYPZrdlGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRdt/qDMPkpq4Gi/J4xF3yXc/hvRrWO3xhuhtYRx4hQ=;
 b=UoVXRL0OWCtbCW+K/yIXXzlqwq0S8DhRaazSxYg5BW20SxqoFTmcRpRhFvNkzA4+n2hjgQntoM8tMiEnmrZwjIoZKhxi4XDAgiB4NBH3XtqqlV2/PSzJfqevEOoRa9zOt5dqdQNSTJmnR5GzezqVU3nXKziXsRrfzvNLFz8z4Z5e7OjuzPWjMRvuLf2BiLAy9gmLJY+9P2yADvjELOzOZw6n2aCRvnFFHrkr/WNaSK0fvmPYjtFvRAEYVSOTdG4+vCkSoM+yTj2PICcmZcMwMvR076uBc0JrrGcHiDLk51mnewsJ+mx4yCcFRrRtugPmm+gtD7iX8+6P54LgqWvAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7313.namprd11.prod.outlook.com (2603:10b6:930:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 08:48:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Tue, 22 Oct 2024
 08:48:17 +0000
Date: Tue, 22 Oct 2024 16:48:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 05/27] KVM: VMX: Disable FRED if FRED consistency
 checks fail
Message-ID: <ZxdmxC92KmMQVYNU@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-6-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-6-xin@zytor.com>
X-ClientProxiedBy: SG2PR04CA0199.apcprd04.prod.outlook.com
 (2603:1096:4:187::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7313:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fa7139e-c034-4259-bad5-08dcf27645c9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ShDmp5FSYt+Zfp6Vbp7Dbro05Zhnjk+HoL0vKsoBtZapMUwwjP7+seVmF8NS?=
 =?us-ascii?Q?9CqoqdDtBaoSqzTBPHHMihmtiUvmykTt05bJmsohb+O1mLvsRUu1+XfH9I8S?=
 =?us-ascii?Q?JqiXkEV5x+r8CsWVPSLp02mI6GfIHYOb2dIPwaK2o/XlUEJcFhyfq7VaWkzQ?=
 =?us-ascii?Q?+JwF3ihTGnNEabOd8Foi8auJ7XqsBKw4RDetCcUmUFMeICVKI6nYd8UCRcjl?=
 =?us-ascii?Q?fZdGK9roRSP+TmT1nolYuJE4uLUvmzI8KUobIbb+6+10etEpP6e1nce5J7cy?=
 =?us-ascii?Q?dXbSdkGJFtCp3Zu/zwWKE3ctLLUe4JAgSXaARiZwszkYCW+5mI8QKYAv1SBS?=
 =?us-ascii?Q?w/IP9ZicZQlb7oFEQ9hwdW9uqw6pz0j+dbPlXBXFx3SVA2pmkpUk1S7asl3c?=
 =?us-ascii?Q?+pAqULXbl83SLiZIToGUTEhkeAKW2MCg38t1Jz0tVlrCL1j2ODQJoGVOncm5?=
 =?us-ascii?Q?z4o2urau+Y4IZLmo8OQA4tfPLrvQ3xNGVl/fJyuXBNAUIg2mhiDvvd5xPaYn?=
 =?us-ascii?Q?S6J/kQgqZmf0YY3/uXC0nv4OcjNqz8JUwROAcxsbQth2/LaM5iRJI0hkT1bh?=
 =?us-ascii?Q?jk5M+JKlVyoUPQUfa88A0ZlrZNj0czwhoRlKgoaRpDSX4I3gu3DW7ESxdlik?=
 =?us-ascii?Q?NiZsZAeQGm7yE1IR0rINwGs/rM77Klwj7r7j6wgXiEuDRLZ7C5CYxORF0DNi?=
 =?us-ascii?Q?9VlGhUNXczm5Wgx8izz2kSooUUSnBPFLfi1PLbmkCyeK+yCwSms0cIURE+0g?=
 =?us-ascii?Q?4T3lTQsBnsCecqfGMHq7hYj9BaEZONo3RfOc3RZOnGTIo/pHrXE6O7dOOrhx?=
 =?us-ascii?Q?BNFwh1jLz+W/BZUTlwOWzj4mzIiYllA7Z2RSjpva37QeM8pHDuh2BYL3wxwu?=
 =?us-ascii?Q?8OsxHxCNpDNysuA6D4AD7LDRO9tByxCEfd2h0fSS0uPlwJhOM6Mzb2ZFAmKF?=
 =?us-ascii?Q?8BePaA/9/tkZKPOWrnKPPjxb8ZQGfiviPMsrwDVimcWfrrbHTw8XdlRw/VhZ?=
 =?us-ascii?Q?wCmfByZKW6wRb+9UUeVGadGNoK5zfR/bU12Yg4Rghqm2YJtmGtbeacWUpgen?=
 =?us-ascii?Q?K7RAV872PDg8xvMiPt2kYDmO8SnddWknkqLk9M4/o2u7jnZz2ZpI13clgp7J?=
 =?us-ascii?Q?XoUOaJHGIBE4mRiUM4HDL7L2BiNoNSZDkCPyyzvTTfb7j0n18F8+icG97oh7?=
 =?us-ascii?Q?L/67FmZHquExXWq3YN3GyI/aw7ZQ09vYQzV5tDmGzUOiCOS1aEboqEhLgooM?=
 =?us-ascii?Q?2GaQWIGlNml7PEjCFW9PAs8jty40UlxEzxHIYdoyf0Mz742i1CFE2wulWo+v?=
 =?us-ascii?Q?2InVlwNL6E5nzomSuFVsCruQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/RUI2qobLSiGaInj4burpk54l8swopowZCR+ei+ZCSTQznDaPUPhD18J3xbm?=
 =?us-ascii?Q?kHNBvNoUWP4odvYtiYOm0UStOLBifHfV1WFfUNvKOLYsf28tcFKeMggTyFHi?=
 =?us-ascii?Q?W4MjDNozRhMiY79g8hjEM6u+x3fgy27qWUq5L0Zjqe831NbHBVLs6eUbPX9B?=
 =?us-ascii?Q?S5wFVvK5jDPMbEwOKjTcS1R01Fvf5BOiwGPDzgMnJMJSmXYb0988IU9MX2l6?=
 =?us-ascii?Q?SGSRtMbrmZ0RDzrTuvy/vmXufBDfabsZC/Wu+YJQZxz6orTVRGaRrRUs0x4w?=
 =?us-ascii?Q?O/dKu9XyGnyPBi2y2NeBMFfQiHmoccCn22w1/Y3KhzhmIkWO6y5Ys41Qe111?=
 =?us-ascii?Q?331hT6/tArpWzROearjLSl1ki8A9lX/zbMlD/ezm5/Qbmj4tyWBQbCib24ED?=
 =?us-ascii?Q?qGyikSPhzixLuYWeebIf77xFGXVkRihuoMP3W2lhLtdsXo9zmmgHK6n+dPc3?=
 =?us-ascii?Q?ylsbccU3uShkfAnt8QxcTOixhsJK3VBH+qYEVm6wsiU1ED8BtYmifEmZpLzE?=
 =?us-ascii?Q?/42YzAo0+NhvbtUfM63OtHCRCqSdb7TKXlvd0gjOP9rgdBrhDEA9Nbfx7emF?=
 =?us-ascii?Q?jMZcqSK+ea4fJUh2QZWjLanGyHvuA6ZCVIRFy8S9CcD+Y5nOZ7l+6qi30++d?=
 =?us-ascii?Q?7MnKGzfkskV4whHC8GewnCtygn/YLbyUaMQlp/aPnZ1vNlkJUHJIMvbDC7zH?=
 =?us-ascii?Q?6pGL72QZU0u/UHn5y/FYRhb9pEfVOfZ81d5RRurr+M36ZRF2/PYeTWcTWBb2?=
 =?us-ascii?Q?2T4gsmG969FkLU61BE3E8Ol9I3n6UQzIE7T2QK+whyrlnrp24nl8pAtawt7X?=
 =?us-ascii?Q?5fOjTUtn71fOqp6mqsBRB0k8tRjuicAIyE8plc8DXax0yWLkxNvZrR37lg5y?=
 =?us-ascii?Q?Z/J6/SQNr7MvzhDKi1xYC1Oz9HOeQRYUIHXM1M87Vbzdz1p3qb7cCtLDcyks?=
 =?us-ascii?Q?2lKJxm1l3hypkO4a53ICyyZgwryzxn1Wo5Cnpltm2xkg14e3aWlFcjnKLg7M?=
 =?us-ascii?Q?HDwvGvFJZxshEtHivTNIRrKawHWfQfpcaBCETqDJ3VFF4TrcXWvJcA1mIjV8?=
 =?us-ascii?Q?5Ew9fyN8UV+0p4C0SycZ0vcmKkrm5OMkad6CtTgmsFfWz15iXZdeE7zQW0r/?=
 =?us-ascii?Q?cH+U3l6MXEIy4Qj3yAOwPwOvW1LKggl2KbsfIu9Q2v8nqAgTcXAckuSf2XWC?=
 =?us-ascii?Q?7u1MQHNpeKj0SzFxB/XuQefYTHDLG3fcSeU7Wda+RmwvrLC+XFjK90Zpebsq?=
 =?us-ascii?Q?QjtaX2dqNQyIpEgVTJBU9wULoP5XVh4uxTLxhe7uZiDzXrpl2ZomWx/eiOff?=
 =?us-ascii?Q?OTNbFcBVQOxuSH4bRXxMf5a2IWG+b1WkSNqNiHeudrVJPs+l+q2UfW/org58?=
 =?us-ascii?Q?wBS1dgos0yjRTxVrI6r8IOhHqPVq+6B7R4/webfvNOXiB2HoTkMrANjeCuy1?=
 =?us-ascii?Q?7FH1YPsAetwRY6DU6Wd/33EjISDL64MQvZxU9QSFPCOTGSUV223gLIdgsQz7?=
 =?us-ascii?Q?Z50UKiR+xQL3WK6Yc+8s8dFqMTJEm2Zv2klcM1E9/hdpMxrqfv/Wqhg5wK35?=
 =?us-ascii?Q?ZgF0YrUnIUQ29yL1tGeiUg4Z/mzotBCG3ehofxpP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa7139e-c034-4259-bad5-08dcf27645c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 08:48:17.3741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lnKgXUlm86DhDr1/fazpW5B5AOmFq2Ih8HmN7VsGmtSwTB6xOXCHxtSNGvFLWDaPEmfQcyHa/mDkcINMG8Scg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7313
X-OriginatorOrg: intel.com

On Mon, Sep 30, 2024 at 10:00:48PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Do not virtualize FRED if FRED consistency checks fail.
>
>Either on broken hardware, or when run KVM on top of another hypervisor
>before the underlying hypervisor implements nested FRED correctly.
>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below,

>---
> arch/x86/kvm/vmx/capabilities.h | 7 +++++++
> arch/x86/kvm/vmx/vmx.c          | 3 +++
> 2 files changed, 10 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>index e8f3ad0f79ee..2962a3bb9747 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -400,6 +400,13 @@ static inline bool vmx_pebs_supported(void)
> 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> }
> 
>+static inline bool cpu_has_vmx_fred(void)
>+{
>+	/* No need to check FRED VM exit controls. */

how about:

	/*
	 * setup_vmcs_config() guarantees FRED VM-entry/exit controls are
	 * either all set or none. So, no need to check FRED VM-exit controls.
	 */

It is better to call out the reason.

>+	return boot_cpu_has(X86_FEATURE_FRED) &&
>+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED);
>+}
>+

