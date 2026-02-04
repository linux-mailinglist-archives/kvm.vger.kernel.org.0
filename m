Return-Path: <kvm+bounces-70142-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCwoOM7qgmnqewMAu9opvQ
	(envelope-from <kvm+bounces-70142-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 07:44:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3198CE263F
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 07:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D0A76300B46B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 06:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DE3385537;
	Wed,  4 Feb 2026 06:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjvqCdL4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D43806D7;
	Wed,  4 Feb 2026 06:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770187466; cv=fail; b=HMJ/g3OQVP+Uiy6KtRThSwcC474MgVUQCZ/yQZo+RMwB8wnl5d56qM9WXHIULXm6RiJDZ+NY7sbhsiFHDSe/OF5F0XFa9BSCJD3I6jWZvY0W73O5N4TCeOel8rSZXDCeelffPqluFMj0PoD3LMVTXQYENCibPYP/W3Hn6mijAu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770187466; c=relaxed/simple;
	bh=xLgaafjrnjn/VIERIyLqz1KB79mup/bBps/efSQpVQY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lZZ2mHRXz/8Si4L3H7lslu8ZZ3L6sY1mOdlgPtFBz9ZRGg1eIBzzt4ITljhnqsM8Qd2QuGUlLwzbHii0UUSN/+O4iMQtvjH5eOK91xG46VmtLioY/H09HYx7VmiYur92coOeQTvvlL6UAcFEdQBRpFihYSoCW1f8qTbbZGpdF1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjvqCdL4; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770187465; x=1801723465;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xLgaafjrnjn/VIERIyLqz1KB79mup/bBps/efSQpVQY=;
  b=gjvqCdL4i0L6po1NUsf54eoTfyQib8tFzdbCBi93QykzPQ/jvNtU6RQC
   a4hTQ+2Od04EY+4np/QWzA5mcK6uz8+X6gPVYZ6Xjl8Lp9jkYtc2A0dDf
   KAsAiDpjaQDDp5boWV4b9jP1vnrK0K9wrk1eZFLuiWwM2hSS5hU1lEHck
   UofuC+Vxow0e1bTUGSUL0yJe0pLLMeqo68SuIndTBZOerzbnDVtwf+qPd
   +DAMz8DNzXuCkoKXY72kVBf1gY3645AfZoTqEXV/e4Oa4SsTD2ILqb19+
   DCe9EePoynwypHoG7NP+sx6GzfgLzH8BrQYF+va9ltn9pjFr5l4qlZ3lt
   g==;
X-CSE-ConnectionGUID: TlGS4++sTBmfB31JiSjPeQ==
X-CSE-MsgGUID: Ad6pLnXyR1+g3FsWsA1zDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="81683044"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="81683044"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 22:44:22 -0800
X-CSE-ConnectionGUID: WcrJ+0/XTpuKp3eZ09xuHg==
X-CSE-MsgGUID: uhYAgstLQ3aw6YmFzsGbmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="240757483"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 22:44:22 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 22:44:22 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 22:44:22 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 22:44:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kaIhv0favmrNKes0OmD7GnSOavwF/Lm5mWvKDGuSmiUYrvfTCOUNrQLFtdQ/dR4GNK/Xl1eW3gOZlG+vINdEJPAVFdLKiM98g0i8LKFf6/hmRQE8ymgd7c8NEr7gQ3PL971UohcDrRQL+TZAHnbp9jKXQLV4Tojl4N+M70hC/G0HIvqBp1dTF6MKQkSbWjQZ9ousUrPpZyWVdVShgQHOx9eUQjtvVuOtnnL+ozoBiwQnI9Z3avYPkOwpG5/cBxjhETAPU0gBTSCa+4rW/jvU5kDEVPuanSlTt/fdn/USs78PKErPTWoBAe2SIkBoemTLhPc+FurSk3aKPB18UYsaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ManxyH4UA94eFIT5NunNhQYLCHcdnme1ZrpEBPj9xOc=;
 b=NXnpCR9TnyVlS10V+Kxk0T9h6LCpTHgwXRsh102vyB96xkacYMWYwgmWwIn7wBLN0XogneZ2zYCRGqHWK7/iiE8cQawlYzV/SddE1EG9t7U3vdUzpAVMbdOJ0oYxhDqjYd3hKhOMjkwbVWc8qHS7sTk08N6M5Fr64zkDrDIY/aa9NaqoWfSmAni/3Q0MYVgKyAzMsV2mvkOD0P4CIZ8QYLMdyrjk7HFKXpfer0YC5DY6XbHuuvJa9bYRr2t1c4K5Pcq68UNnciVRQKl9fuEyw0YHBySG0TEw/RJIJby7X0x8XnjPkUlqm8vI5dj/HT/+IQ7Jj4iw1+wxwtFpjmaHMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9039.namprd11.prod.outlook.com (2603:10b6:208:570::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Wed, 4 Feb 2026 06:44:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 06:44:13 +0000
Date: Wed, 4 Feb 2026 14:41:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Message-ID: <aYLqESiqkADxMGf9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-6-seanjc@google.com>
 <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com>
 <aYJU8Som706YkIEO@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYJU8Som706YkIEO@google.com>
X-ClientProxiedBy: SG2PR02CA0124.apcprd02.prod.outlook.com
 (2603:1096:4:188::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: 758d7e7b-c20e-442c-75b8-08de63b8cee7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UN2JdPjrOQK/HPIhml5Ppd+jEHSCaiU7J/up5Jo44oWFDtWRVubY9hVAmAq+?=
 =?us-ascii?Q?qaDByJFX7mWWUAmD7UGQqzhOTDnEcyRHc9cug3jaKsUgta8ao7Iqaoo6cLI9?=
 =?us-ascii?Q?rMFfIbtI1eXmR2WMXbx+Aks+Fxq9gy+Z48fM0EWUcxklWRqaTHjY8XPGPFvj?=
 =?us-ascii?Q?htRh74HSPe98ZhXcwJqMyZBRAPheaFcn4lgklDZyhS6Mp6tSvq775j7K2fE7?=
 =?us-ascii?Q?N5QryOA8GozAb/02bNrchHRkvhNmBFL6eEiLWvOBNhxr2C9a70aPWz4qqQ05?=
 =?us-ascii?Q?QmthvTX4Vp8Tr9WlMru0uMPEnZceSqgj2K7F4khIaRIItD1jVlfNBPxXa3wL?=
 =?us-ascii?Q?rqDHN9m8MGfjE5rp54IOVqOquzIZ9tYiUMvtWuomv/J6mF1WLDBuMHds0o38?=
 =?us-ascii?Q?MFFU40iPitwUaX7WJnrQIJeX/Fuwmcvk1DeY8SOXoOtp3/GkCJuKYhnxWLMu?=
 =?us-ascii?Q?7H+wmUO1ur3ukkIpx5XeQ0ZhBdtpeTteOEbtVui0fRjuYLMQMcpwMRLBHSbb?=
 =?us-ascii?Q?+zBEoQnDDF4k55rKJkeMA3Ii7Mx2qa5HSjlb/bGASZaLtYs1S12mX6h3MbMs?=
 =?us-ascii?Q?s6jvWS66nrdlxX2AE1Mmsmuy+mdIBz25vTWTugjnBbQfi5hQ6snn3gt0j5iD?=
 =?us-ascii?Q?8ACmMMCsNpjQtYeOXH7Jk+U8K0o2x7QZmbmDapucyBQJJq6m5bnj01BIztUl?=
 =?us-ascii?Q?BpALQfkTxVGBHP2SMIdxr3RoqFLGiwoJHtYUlzJgvE57miEW8lZgqv5Kl6N6?=
 =?us-ascii?Q?+FUKEzSE2u3K/I0hbXxWS5DjAv6GyfJUzyHkfFUKeWZzZ2WN2AQrezZxqd49?=
 =?us-ascii?Q?5A/wUw30OdU7hQwn0set0t65Ix4Km8iu7HBGfUeAimlzD+JcLGhc0AiZB+cA?=
 =?us-ascii?Q?UkQaeDEpUWLyL8ae1lxkv8QgHdAPDLeE1u5phVJicr8r80nSsXEv910yJ4zo?=
 =?us-ascii?Q?qIkIf2pAA1wTjnmcG/8mLiRfvu7PP4Cxcdea5tDZ14DIfwLIcneFP/sGxSOg?=
 =?us-ascii?Q?+XsVoqa506gAZxhmbQ/rfih/2A/BptAAaGPeXYMEWZk5/Zb4LPd+TZAPmHvB?=
 =?us-ascii?Q?3UKQoSnQWzzkd5djLdpcF9BjkpelnAa/tUzaiNxcWlrIfjxP6sqwtJn/dVAP?=
 =?us-ascii?Q?GHgkU3kZyKYhI6w295VfV6DYJ8ACt2VxE4JZYsxCwhJ0C8rgxLwF9cetPmlv?=
 =?us-ascii?Q?zWu9WCHO5pfPdHDJp832cx+v97Lbms+xtap/5mufIY+CN+fQNm99owwOFEGC?=
 =?us-ascii?Q?RC4SGzjNtUcPzw7dpBE00NfJmHSaPTtH7vgsLwr0Di3dRCWFF/knQDbIT68T?=
 =?us-ascii?Q?prQ6IcaS1jxGxd1KzY3TW+zggRZc60bjiFEvuJJLyb8DyHcalrtZewZMVzUL?=
 =?us-ascii?Q?R+NB5BQoXte84f9WVorqA0PXRmvvUbzkb9EMN1GQHRHNS5dGMFIZRp0oMhck?=
 =?us-ascii?Q?Ja3i2G/TBPYdVcgmh4s2hDTXHD2xAu+U2cJfHaAesg7sJ7g/aCuR6rT9TuZy?=
 =?us-ascii?Q?spPa0FMqIIJV/prw/jwT8J+GcXaPXnRzzMsPcj7IMYdJx2PtGr4CYLYE38MV?=
 =?us-ascii?Q?zVDFqnq1sYGw/S8n+BI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5VnkWBhWoP09fS3notix6FL+m2AFOJ5y5556vpc2KF+h5+C7llJbPrEGyNo7?=
 =?us-ascii?Q?ZMwbSiNtkHCXJNxtNOZGyQoBoTdCS8DvD/EdMzzsDwasUQZHSoaazmmFvL1u?=
 =?us-ascii?Q?dZ6iw4aoveO4zWUMJUds6rFFH1va6+FaGF7kLT5NMyMA+Dd33SdiRRve4IWa?=
 =?us-ascii?Q?wViasViPBf9UYVwRXVlSZ7jIM0Emj4s0xdhwDUaE/hyV8ZMhvSwT+ClKiPU2?=
 =?us-ascii?Q?TgTOgkBozFD5OrRHSgC2mJ6ttbcxIAZ1bgZ9oMJtu7E8+akZvuIT3kkaaqN1?=
 =?us-ascii?Q?9FmsR64zmu4b4QSQ/asrjqDszenQUengo6pTKy1QgMWfP7yXV7yRjuUkzBbp?=
 =?us-ascii?Q?ympWnQgFonsdMK9WlFd6hoZen5Z4kibqmsZf02UH3uPuwxjTFr623khPYdrD?=
 =?us-ascii?Q?Son1NOlPzvohlDhcivxtCLbdfF5rgIwcKqEFEjnJ46Tr0idx4Ygix7piJP5R?=
 =?us-ascii?Q?sAebpon00G2LcBS04S/zksVoXzdWKOYL78uX+SknmkxjRUUDrs8B2IRbTft5?=
 =?us-ascii?Q?ehRCMTatDhzrHk44BZ4mlT3IZDfpBbRSZh/6/zbvWaIBK3I6V2sE2D+85frx?=
 =?us-ascii?Q?yUC/6/4dH18QLufJLjjMtnIBjqyYzddrXVn7SpMm+rDdFmU1w3TlzH+VP1eK?=
 =?us-ascii?Q?xduaITNZ/ulYCVcw6729IGfCqPNfqh+84oGgIcgBVV/QTi8rBUQDuF3/zO3L?=
 =?us-ascii?Q?B3QlsaCU/ye1zm2yAEKSwRGdEdamuBtT4I3MhSahxFACamKLt9JdO+T4yb2j?=
 =?us-ascii?Q?hXkkk4Eg0BjrRSIHYgy7O7RHb2Ujpvg29YOBXsQgM8arw3SAUF/fPqwviEvT?=
 =?us-ascii?Q?j4vnOwgBA0BLetJu1fD2MSUpTYES5HJSYyPHPRxi3OvjBkHa+Vzvg+MFxKA8?=
 =?us-ascii?Q?PW8Pq19/4G4KeCyKFGqpGCK2Muo3G1EUpc6pEbr1vY8x3nTn23CstP29XUYH?=
 =?us-ascii?Q?kx20KHGsq3EvcUfSTRwXr6ULwmG95A4mpGiw56A8AhVYt2DI1MyYIAzhhIik?=
 =?us-ascii?Q?4RStY5+p62saQ81KKNFMSx67uXa2e50yuJoJAK8WvUbgdmi6UjVXIfos3q+w?=
 =?us-ascii?Q?pv9hbzt/T/mFlmQECpWDdpl7tMNtWpJQK5+ss4g3vZQq4/Zuth6hQLQB1fNA?=
 =?us-ascii?Q?3Yuh5PRuDCZwlyRwwDUmtJwRa4goAK2+lvjaCQEKbL4ZCcpi8QAUhp/jtkYp?=
 =?us-ascii?Q?H1AxMeGwEwqrWD//jLTLNw0yBSnxqilpQpfgjy8XemQ6acNDpLnmakwhBGoY?=
 =?us-ascii?Q?rEK3s9mEpN5Rqdp0Xz6z8QKeQUc63UsSK+B3zeC7uTHeWrHKO7w+3LVXkpuS?=
 =?us-ascii?Q?w7K4QJePlVrouVEbEd++nqj/Abacpnp/X4fBHkP4o8YgZMhHUXAZoGN8Nefj?=
 =?us-ascii?Q?KivQPgcYvzhSSik8nqcqrqammIj61wCwIMH51DfNGJEIGUfyHzZCGjCGLXqu?=
 =?us-ascii?Q?aC7VYojfE4cxBlpIYvbYUIl/uSo+JlqEavVCNYRGQOZypEIbLO/sYkvTKVgk?=
 =?us-ascii?Q?gJhWmFw3hnZPV3hqH4VP+VSzIEkbbX9yHUJZtWMzHdgZB79ieVXs2n9v+nFL?=
 =?us-ascii?Q?WWiJzaCT0neGkbQbDhlAroVG1KrSCRv3bXsxykL8iu05BAp/w2vIctTVKncn?=
 =?us-ascii?Q?9MhxKvBOdG+HFBRtbsH4VYWio2lmG5Y3ILEALUFTsr/rFJFA6ZqmG7Hg83vt?=
 =?us-ascii?Q?fcSqodMb0k2xAvqTTgPuWwBwxqXlcw5krl7nbOEmGqKWbJFSY22912W9HtQc?=
 =?us-ascii?Q?WoRgE5k4JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 758d7e7b-c20e-442c-75b8-08de63b8cee7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 06:44:13.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9/ApamSUVio83zoR45g3ghnLpY5n5VZijH6J4uU7rhIXGwd1Qv3EE5i6A6OVWa+GXZjuB+Z9OHwh0naOpjciQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9039
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70142-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3198CE263F
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 08:05:05PM +0000, Sean Christopherson wrote:
> On Tue, Feb 03, 2026, Yan Zhao wrote:
> > On Wed, Jan 28, 2026 at 05:14:37PM -0800, Sean Christopherson wrote:
> > >  static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
> > >  						 gfn_t gfn, u64 *old_spte,
> > >  						 u64 new_spte, int level)
> > >  {
> > > -	bool was_present = is_shadow_present_pte(*old_spte);
> > > -	bool is_present = is_shadow_present_pte(new_spte);
> > > -	bool is_leaf = is_present && is_last_spte(new_spte, level);
> > > -	int ret = 0;
> > > -
> > > -	KVM_BUG_ON(was_present, kvm);
> > > +	int ret;
> > >  
> > >  	lockdep_assert_held(&kvm->mmu_lock);
> > > +
> > > +	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
> > > +		return -EIO;
> > Why not move this check of is_shadow_present_pte() to tdx_sept_set_private_spte()
> > as well? 
> 
> The series gets there eventually, but as of this commit, @old_spte isn't plumbed
> into tdx_sept_set_private_spte().
> 
> > Or also check !is_shadow_present_pte(new_spte) in TDP MMU?
> 
> Not sure I understand this suggestion.
Sorry. The accurate expression should be 
"what about moving !is_shadow_present_pte(new_spte) to TDP MMU as well?".

>    	
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 5688c77616e3..30494f9ceb31 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -1664,18 +1664,58 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > >  	return 0;
> > >  }
> > >  
> > > +static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
> > > +					     u64 new_spte, enum pg_level level)
> > > +{
> > > +	struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
> > > +
> > > +	if (KVM_BUG_ON(!sp->external_spt, kvm) ||
> > > +	    KVM_BUG_ON(sp->role.level + 1 != level, kvm) ||
> > > +	    KVM_BUG_ON(sp->gfn != gfn, kvm))
> > > +		return NULL;
> > Could we remove the KVM_BUG_ON()s, and ...
> > 
> > > +	return virt_to_page(sp->external_spt);
> > > +}
> > > +
> > > +static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> > > +				     enum pg_level level, u64 mirror_spte)
> > > +{
> > > +	gpa_t gpa = gfn_to_gpa(gfn);
> > > +	u64 err, entry, level_state;
> > > +	struct page *external_spt;
> > > +
> > > +	external_spt = tdx_spte_to_external_spt(kvm, gfn, mirror_spte, level);
> > > +	if (!external_spt)
> > add a KVM_BUG_ON() here?
> > It could save KVM_BUG_ON()s and have KVM_BUG_ON() match -EIO :)
> 
> We could, but I don't want to, because if we're going to bother with sanity checks,
> I want the resulting WARNs to be precise.  I.e. I want the WARN to capture *why*
> tdx_spte_to_external_spt() failed, to make debug/triage easier.
Ok.
 
> > And as Rick also mentioned, better to remove external in external_spt, e.g.
> > something like pt_page.
> 
> Yeah, maybe sept_spt?
Hmm, here sept_spt is of type struct page, while sp->spt and sp->external_spt
represents VA. Not sure if it will cause confusion.

But I don't have strong opinion :)

> > And mirror_spte --> new_spte?
> 
> Hmm, ya, I made that change later, but it can probably be shifted here.
> 
> > > -	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
> > > -		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
> > > +	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
> > Also check this for tdx_sept_link_private_spt()?
> 
> Eh, we could, but I don't think it's necessary.  make_nonleaf_spte() is hardcoded
> to set full permissions (and I don't see that changing any time soon), whereas
> leaf SPTE protections are much more dynamic.
Makes sense.

