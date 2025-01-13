Return-Path: <kvm+bounces-35278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4035AA0B398
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AE6A162FC3
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 09:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764A31FDA6C;
	Mon, 13 Jan 2025 09:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPMAMGEQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC3235BF6;
	Mon, 13 Jan 2025 09:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736761940; cv=fail; b=DscW6PvukOQLz2l1ifIE5EGdb7i+HeWOC3XPE82K1vSG4UjsuunVdveidiLM86eilpwktGfUhvPxGKHpUpEkhkMSjfB4VyDV58GBdJcgsPN86OyGckQiKxgk20YfnC9V48jB+CktoEghZccZBR8tZKwbe+p3pMUJB5LDygN8wmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736761940; c=relaxed/simple;
	bh=Qp+f3wRCgQSbuILWFkzkrkwvy5aTaGshw5JpMvPzjBI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jktO1bYamWIkwRz6K7Twt0atYzu26yDkuI1tITDodY/vT85qLNXzlt8jo9jY1MGQzQWb9gThHTA1HIgQTPylwUurjBJpI/wwUUfp6McB92HZ5FAgOlJe92qef3SobJAtiT+YbHIS4NmQM3EjekhlbciGXR5XiVS0r9wo44N65Ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPMAMGEQ; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736761939; x=1768297939;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Qp+f3wRCgQSbuILWFkzkrkwvy5aTaGshw5JpMvPzjBI=;
  b=VPMAMGEQUr4OSngXNtAoJw+6ItosWMq0Ho1T12LF23ija0jAA9ELQPLP
   iF3HQ62WZrmtrnYzkOpXJUnNy6BsYVPu+aHPTJ3ONQizNQiPUyKidLzY3
   2MOdI40ZIiy/0wf6a3IphSVo3YO1XOAhmuz8fcAji9rQNUFyP+yxMP8Rf
   8noqhm1MykPR1S2frZE2w24NemTUewb9EI0i+2lJcdoPx7DNcB2dX/a3W
   B6PAjjLN6sjo4rda5mswD7xGw9yee0afu6mpIwIhMjptvnPdI3O9IRpWJ
   bUjJojXk/mOismW9PurSeeQ1i/9w3K3o5iLLP9QMCvwo4ygkqtNm3WNK7
   w==;
X-CSE-ConnectionGUID: CiO6DiV8RvyulQ8B699JmA==
X-CSE-MsgGUID: ypC9P4tTRvGTSHfandp0OA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="24612390"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="24612390"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 01:52:17 -0800
X-CSE-ConnectionGUID: L1OipkN9TNqOy1kdGhW5wA==
X-CSE-MsgGUID: kEBR/crPTOiOe/SqRNVmBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104379176"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 01:52:17 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 01:52:16 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 01:52:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 01:52:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GAD3+ADQ1OUQf+P3sofnohfv4MfSuEhuKM8QPU9oRopZ6m9T/tXT24n7osh6XlkC0TIAweHX7yb49p+N7m/IEjiNnh002I/ctjHSuhUmXx/aiuTAp0crOBRNfecSls+sbuCo4Y+bx5yb8u4Vgg9amyJN4NvZlDFTzzG+77/JyKbbdyBdxjS9fmlc7c+K1CgIvvm6jzMDHRb8px65CwjNMpVBFprBfMk/bJZundw2HE0KYbTgvzbT7TWpyS7btvkH3Nm70Y7SBXrLOwZeRVQk/6Xk/AQ5zsgbNPaXhsFqWRZ3aThYCahPOGO3Wu6aUlHJynIRhiZKGck0iYq4MeaziQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qp+f3wRCgQSbuILWFkzkrkwvy5aTaGshw5JpMvPzjBI=;
 b=Uo5IXonvuElc33xpNS29s+9fv4tjgblKfZHc5ZE/Sruwkyqt2eG2MP6BbOY9t6cO0qmnlXskX0NEzzHp20SMO81Jf4PNkO36VGXpZUT9laN9LvEXV7z/cYt04FoaYwvSW//V5cGB60RboRA87fmVsJCFlVkMytLYWnhjDEC1Bu0g+BapD3tdzlpc9z7/N1XMUyWgflGkIRuHNiJCmj+3pSdQLpnk6bzEusEWJY4S2TBQcUaDPHaX7Fy74P9AVNKEnEWWGlPhxYDVxFBhuUT9OZ8ko0g1Uz2syD+VCYW0i4XMqdtpgl+vMQboZnV3CTBmYSjcqMYnNCmuaC7pMp03Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8234.namprd11.prod.outlook.com (2603:10b6:610:190::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 09:52:14 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 09:52:14 +0000
Date: Mon, 13 Jan 2025 17:51:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 0/5] KVM: Dirty ring fixes and cleanups
Message-ID: <Z4TiGLp/91vJjZh9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250111010409.1252942-1-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: dbbddc94-6273-499f-4773-08dd33b7f4e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CgHqyoz2cIXFDH32PkZ0h4cq7lTL3ayuwSfNC5CYavh1hrycTi33s+/Y3dYL?=
 =?us-ascii?Q?xHcu9bZOCJSNav8Cd2YQc8NbHe9aG+3KF2+mEvFKj7BXLeY23UWDsRqusKek?=
 =?us-ascii?Q?3bPEQgykBhlxyhf8JSu/sT9USy6aAmbqpfXIegOqXyyjHzTmRGlbLtE7olSi?=
 =?us-ascii?Q?CFugBVsoDPP9Afk6p+T5cfnOPLZNYyS4CSKQqaOTc9RQL351RqfElWHRkyhy?=
 =?us-ascii?Q?Z7EQuYsIRX3wbZSBZLsuSu/vgRVVV2COPaykIlwPw4R3ZdumndJ5dWoYbEj8?=
 =?us-ascii?Q?759my7dqTYC2bIMaaVg7X6xu6t4Vz+NE6yYI5/n2qSbhO+QOVGFmoYqg8p8k?=
 =?us-ascii?Q?Utpr1AHW8vbGhPMqhSvEwB+sWNAE7P319A5ZNUD16BbXSrPnxhfXN3niWZaJ?=
 =?us-ascii?Q?VGtNN+sHlcV4moCzwVvXxW8Je9ZKkwiAlxFwhkMYCG0gJ49v+9VV6u9JuRE/?=
 =?us-ascii?Q?uCdfzEnCGTvH7UdAc/na+LLdWWXBnvx5TqMUb91OXRGkSxvZbndnEXl0Bv5N?=
 =?us-ascii?Q?ML08u1N6PzItZiyIXNET2h5L8fEaFaXV8M++GhSPU1jnN4EEKauJANhp5kCP?=
 =?us-ascii?Q?QDpV5PVF3DU8uzvvHcn41lS8ox0eghAtiho409Q5B9iUNYdBoC+zLg9RNn4Z?=
 =?us-ascii?Q?CFCHMJG8wXy3hBy3I5V3P8rgr1zS18Q2lbB0hJV65VPTJMUGg3Mw4Toq2DE/?=
 =?us-ascii?Q?U8e9drphfsh6mFIwGiSHFUrpKvmMQuq03cYzk5Jag+ABUEWOYNEzc+7wQYCV?=
 =?us-ascii?Q?aoGghB4+UAXadKAwx5TT9oQ4AjKS8cW1L1aQQqCxvPX80RehrLKyTs3pkHII?=
 =?us-ascii?Q?8+LDLkyTSFmfdy1MmEDChowAGnSPzS2uAR1nmBGKUHNGDBhAMMS9lcBV7V1j?=
 =?us-ascii?Q?3YdFe+xmCEG6CW57v+ErSoq93a6Db5g5nn+jwXuArU8P0oNtQeFs585Kv1U4?=
 =?us-ascii?Q?zS1vaL9uzT+8KbFp0PIrSF1l2FUovgAU3IN5GB6f3j5ssDobU+HtN1VflNiW?=
 =?us-ascii?Q?v4rcQNsBKa2P2eINGUagY88dven5LdT6hTZ957zRCfDlGNDJM6eKliO9W9qe?=
 =?us-ascii?Q?91dJQVAheDeOhPTVlkKKHmX39B6i28BFEakHiErt+v4gIt7V/4ZYMbCn0GOh?=
 =?us-ascii?Q?Z/CSED8W21Bq81nR3mKVBG7JgqnWQiXgNS/DhbchPBTkf+qtSDy2Wkp8gyK8?=
 =?us-ascii?Q?Hqf9uebBbaaPQAxR/F4Vz1oCqgm9DcEsf6GtBcqzbtzFWLwyzY/by1NdedrH?=
 =?us-ascii?Q?qGFQkZh7T6gLxAK1x8LU+hRFkQkIUEgXDnC0R0BlB+pqX6SUkZp4Y5rAKsX6?=
 =?us-ascii?Q?xQ+o4ShPDhf7k++nXQdYHa4ac9qdLKjzHKMMqpLObfi8silGRnXYn9pFOI6p?=
 =?us-ascii?Q?XBILB41pqZBOhDGGICczJB2nvdEI91VqNw+pJDQYl4engYIkoQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CQGhMuYrRvvGXKflw2B0rtsTm8FBUdtaqDLjD4Rz541n4JVu6eDVA2+GKoML?=
 =?us-ascii?Q?uRIhsXAhGK99+qGbyTQ+3UYlZltaqET4JthiIfz0VHpDn56vf9Mt0R4AKr2C?=
 =?us-ascii?Q?Qp+aJ3srDkVEjjqPb5Jumu0exVLE3LOHF5LgNuKzzuzO4/CtROQLXFNsonP1?=
 =?us-ascii?Q?AYq4G80XtER6LAMyEOUPr89ieFl45BmzxP790ja4Ka6oQgswMyO2QY4/WGq7?=
 =?us-ascii?Q?7Q0iC7DFNaGDbM5M8qv2FtVnqfKFzk3NAWZj4ZsSznZK1ZgM2l7e0kNy71uo?=
 =?us-ascii?Q?IMchx9IqgFHZ3pD1wxNuYntWgDdzri6x4F7R5WP6KqDUFom6GvA/Xp5MZNai?=
 =?us-ascii?Q?JEQnALb+GHgyvh319dMiz9XQtrjoJzBoJqQZ1Kdw/93CIZ03680p3gUZcwfK?=
 =?us-ascii?Q?ORUXIuJjmsw7wm0Sr1Emd2VxRaso/1VdKJJ2WJ3hT0wv/uJ/CTV3mQFBUFRe?=
 =?us-ascii?Q?uuP6DflVkmnr8jrnbCHsEOuFPIEmeMgt3crnDRnrohgSs01i7kiF1hOQPtuY?=
 =?us-ascii?Q?+pKH4MbOi24tZtK7Pz85H/flONDMPVWXZ1qu9azZOmyHMfi+w25hSKehYFRz?=
 =?us-ascii?Q?SwB5MRjLHQnX6T7oSAziujLIWllA0NC5hxLYojOwt+ZyaHzVRNLMXFPr4uPg?=
 =?us-ascii?Q?vE5TpBTHyyHQAJy20GaGskYNnCzSHBn1Ib4C/qPHf7LeoHEF1E9tUwn75HQl?=
 =?us-ascii?Q?4FaAsJ37BQHWSrzEVNjWhhSZ0vtbhueQaBE78FmIyLkmpimY+5A7PBVa4ldq?=
 =?us-ascii?Q?+8lD3L9/UOJcjjdl0hrlsyu1gI64l/vVI9riXBoEwXm4kdmDTa6eUbQ5JPMx?=
 =?us-ascii?Q?B66c6aRMTOEjb8sWNmzb+zGf29SIrqPD6DrsOjjdXwQ6E+LOPFr5gzthy7P7?=
 =?us-ascii?Q?K+kpobvE3/6vWJMYNPlxSb2vHV4GlPD+1V8h98gTMSkKG/x3aotcbyAyb7Xw?=
 =?us-ascii?Q?Fj5Ptv1bQNribznkb90kqyMQJ5BIxxNtSBZjiO4tbedJ0lDdXhl4Ntn1Q8rT?=
 =?us-ascii?Q?RxBl3LYBDJe4Io8hddFhv+CrcZHLm1XopSRA2PRnWxMAAwjef8bfxpkK1Zy8?=
 =?us-ascii?Q?P1plqJiOcT0se09dH9QE9GsO1D3n1135MrYWpvYUz6DjHEEODGLNsnRBRUqc?=
 =?us-ascii?Q?OnLP02u3IP/Qfr8kF1AJ/mIAk4CEW0zhnOaO4LQZQgFjpQ/SAwQ0+5xBnd1n?=
 =?us-ascii?Q?4/M2yaTyXLHOxJSC2wHWK9UPsUXlj+7HYgVbHOOeHgB2GY6nq3weuate3mc+?=
 =?us-ascii?Q?tPFdUCliuhwp832GKo+LOVk0Nn8St5rOKZFxkNw/WNFOPewWA3YkeXGUBZOJ?=
 =?us-ascii?Q?FdXccwJBQQcMxnahYgP4PGojGSQ10ToZlvahAdAlVcofq5RxLWCkxnm3qVQO?=
 =?us-ascii?Q?SKtvaEzEymND+IRnHHhEGeKa5fLAXXfBjJuX7h9bNYDjxZ1oAvnXV3/1LXYy?=
 =?us-ascii?Q?d5U7AtOEP4TwLpCbS+XHrx9oPufECsDVBx0tHwuu7SKlLaoPwAngu0d1fIa4?=
 =?us-ascii?Q?A6eXlqHY+NJZo5Q4crLWCitOPQGRL2sSGFp916bKXS0Eu+rVRvIYSiv1XIoa?=
 =?us-ascii?Q?XTyiAEhm3dUlC2QlbmVZpbtEk+zaTH10N5TIIDKQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbbddc94-6273-499f-4773-08dd33b7f4e6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 09:52:14.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBGf4inqJJJ4TCM9z+mrvTPEvZEMgE1HBBUdy6Qg/QBPtTI5NomCXCBvcBLZVrw8QJitAUuGYIO+wfWF+332fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8234
X-OriginatorOrg: intel.com

On Fri, Jan 10, 2025 at 05:04:04PM -0800, Sean Christopherson wrote:
> Yan's series to fix a flaw where a buggy/malicious userspace could coerce
> KVM into corrupting TDX SPTEs
> [*] https://lore.kernel.org/all/20241220082027.15851-1-yan.y.zhao@intel.com

Hi Sean,
Here's the v2
https://lore.kernel.org/kvm/20241223070427.29583-1-yan.y.zhao@intel.com.
FYI, in case you didn't catch it as it was sent close to Christmas :)

Thanks
Yan

