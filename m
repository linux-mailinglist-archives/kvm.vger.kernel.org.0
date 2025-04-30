Return-Path: <kvm+bounces-44843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D48AA4166
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 05:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 101711BC3533
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 03:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706BF1E2312;
	Wed, 30 Apr 2025 03:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cf9y1+AC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCDD156677;
	Wed, 30 Apr 2025 03:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745983676; cv=fail; b=DhHYI8G3RcqUczU05h7Eo/PGPL3Jd3UbXRvpS+ONYOHZS4x71COw0rFgp1hhTrIIwqMgz0CWAqeUa5o24n1HFDmVqM1QSx1liBb81RQmWJxYv199PEC5uPXeEg61dIM/tGvNhPY+fEtM5PEagkmR0iBj1RXhEFZeAaOvyh8ecYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745983676; c=relaxed/simple;
	bh=I2EmIJweN72eDIeYdY7K8YasyEkNFAjhw4n9ceL6JBM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Bjf45uTXKUgEq7wrJRWtKUQq9IGyo3WWTfy0rSq1tu4rvguTSKHhkGpSCqlx09L2naaP2z6zQUvMKvgxk6tyVVmRpTxpsp8vXuytSwgywA+eahEQDgE6GStRCGTsWe1oz2VC7zZh5q6+NryPpbQmLy7mS80j3MIUKhn88DRcxGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cf9y1+AC; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745983675; x=1777519675;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I2EmIJweN72eDIeYdY7K8YasyEkNFAjhw4n9ceL6JBM=;
  b=Cf9y1+AC4jcuSy9ZqOgpReiyqNPLt/tLreL98P0DSW3aoi0C7K+aPF3R
   bHYReAf+981L5ZaxolRa9owFzzFx6rW1xcLjid7fYVG5Q4kqTPTbuIqfE
   VilY4EdTn4CVinFMmCm/q2GoEr1WlmXPPgqiYBkPziqBrsNszHEqv2W09
   bg0HfnTcfFQBKruSiIywEnOCEc5PkxpektOQVg1nQ6De+NcuhiyMWu+Pc
   U1sc1v3tzTPhaH9awP0JyMEQaFuyVXtDsOujvipJLZoy8YmQDVWKSz1Qv
   43/IBP5gsSQVoDRARKPsjLSxq2gd7Re+PXllGZ6K9/Sam+Ca9D8vTxPJv
   g==;
X-CSE-ConnectionGUID: Bp8OustCQMa/1hFb5SZLLA==
X-CSE-MsgGUID: d3AhIdI2R3uWjm+5AY/UiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="70135287"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="70135287"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 20:27:54 -0700
X-CSE-ConnectionGUID: BSD0cZ0eQ6iWYawv4YZVqA==
X-CSE-MsgGUID: BXmmcmhxTaeYPFB0TAhoYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133897583"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 20:27:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 29 Apr 2025 20:27:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 29 Apr 2025 20:27:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 29 Apr 2025 20:27:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AaF7I9IH2qLCnopiFq8udLo7pRRATwmcB8eWhxdYbqHdsGANbmy6sxoHIMPS1JAWrJCp7MbQknYX0Al535N0ffdN3lNPevYg/kxaSB8cvEdQC+ckCK0K8zK1h+0j3vWnjKYzGPeyIy4/8dBvMTALDWqaYvaLqzQoeJ+ojEIGEw2vjBxH1eJicNmPVZ3iTd1xEbZcRv51KmeseC5tpZN6dkcSieInIooclQpCeefX5DTubQ6God9a47m230VSbwVSRGCz/lWJy8o+Bf0zRZ+pi2wCoK+IzA4JWoNSlbGZBiU4gj0n60jljTh0XKIaWWpobsgkQ4dM7F12RPFL4nhObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WVvjxDxQbispYZ5khT0WP739YQqfIZfzSBBBTzva8E=;
 b=wSYayIAHxictK0CHMMcVLr0ovUbTOJJtSr7R1iOPeZ28SL0OPCnF59T4ppComMCNpkl8c4fLcw7Ss9m2i5R3AM/3VUJLe2rr/IsDRKedM5KOH7OYapu7yqvCDhnwWk+xKYfSHwSh1Ven/2jY6mf1dlP1kKTNSxmS8vWajdwH9ARYaugNKTmFo3Gsn834NYyL1AM8gW/0zZbKm+qROBjP3jyPofeIFKiSyM1uivRfXXzJa2LC5uiPC0S1TTa2YSMg5Jl8EZI295XhWyQzGEsQPPmV0gfo2YzYy1Kd8FVgtd2XxLK2rnq+dvHjDGimVU0gHIFjbz4oyBG82FxJDXYP7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPF2FCF00E1F.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 03:27:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 03:27:33 +0000
Date: Wed, 30 Apr 2025 11:27:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Bae, Chang Seok" <chang.seok.bae@intel.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Spassov, Stanislav" <stanspas@amazon.de>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, "Li, Xin3"
	<xin3.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"vigbalas@amd.com" <vigbalas@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"john.allen@amd.com" <john.allen@amd.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "bp@alien8.de" <bp@alien8.de>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <aBGYjlPHv+dq9z+f@intel.com>
References: <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com>
 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
 <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
 <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com>
 <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0091.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::31) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPF2FCF00E1F:EE_
X-MS-Office365-Filtering-Correlation-Id: d91a7bba-c748-411f-866e-08dd8796f1e6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?G/i6y2mhlghqoPsb/Rd+qQUmGfPPhi/Br9aNDuhI7GBw/rJfxnPUw6xPuVJx?=
 =?us-ascii?Q?2pO9gxemk+LIclaBW8PcgXB43IW4ikUN8zHT+m82WbKMqXWZ38ILXc2Qa36Q?=
 =?us-ascii?Q?TIR/vhNwZb1Bq1elyMyyAKVeGzlUCG1fMyHdypZXZnQVPd10YgbiLUVwwGTp?=
 =?us-ascii?Q?59roaKHdQRzxVvRT+qK4nbHKxdcyWwHd+pA1GXYxh5vzcwH1U5DmQnVjpsNJ?=
 =?us-ascii?Q?IAsWtojXD10VZk9gdI1asxwK4RtngazluPiXwRjxpdNqS+WQrdr3veSyJIZ5?=
 =?us-ascii?Q?sLi72EQ34Ja1Q519hWZzDU7eiDM3WN8LUq7dvdvjIb9MdeEiaTtrNLx81iyq?=
 =?us-ascii?Q?vcDBfuunCaEMLnZD7lJv0eaoLZw/hS4qv1fNBM4gBKL7hcE7eyF5LdhrCicV?=
 =?us-ascii?Q?yFJLUImzwDbwrBUkCiuNY7n+yIMShsP3xo3YjJuEvQoLwwHb5kgAIX7CO1QB?=
 =?us-ascii?Q?TxLgJUyPVqTdxyqObBsXppFxcY6CPQ3VqrvxTMzm4SSMcw9RRBO8fEEDc8iY?=
 =?us-ascii?Q?CobklmaRMPUsX1PKVCvsHDzfhAGLAZHqmy6mg1kA0fW4aQZE89WPc9kWLTpl?=
 =?us-ascii?Q?JZOSHMFBwmhUmnZdQygNz71Gu7zwqNAB31nxBeoZ/x4adur7uIq7uzVuZ0Fo?=
 =?us-ascii?Q?vb+iP++lujrIgHHNMuYMYYqfzrvim1zReU8NyD+TQfMJUqm5oeyf+oRu3EzH?=
 =?us-ascii?Q?HCDu5tJmRDhZjb1CnraJ66iIQbHV8sEVcckxKNF3CKpH/B4ug+sWLrzXIpkF?=
 =?us-ascii?Q?BwVXemeOvfvzxa6u0CuhaKeuWq/Q13Hnrv6rFb2rGNCYP1ojONqnro9TQxWK?=
 =?us-ascii?Q?G6VZBpdfWmHwotOEkNMxSNljdnC5qyvlmy9IZPNlKsOa0cyMufkY1ZjIO68c?=
 =?us-ascii?Q?mCruojSgCwJGlJgDePQaaQRZBgv5MgCaqYSALuXAH51SbtCcTIMv2Ezt1Aaf?=
 =?us-ascii?Q?d5LZVRY/tAJZp29tb0I3Y0PS1Sk98O4L+07cB8OeoCTHOGZLBP0xNyT0OEHO?=
 =?us-ascii?Q?1EEmMAVA8SKiE9czkrofgp9g19d3li8VhlDJR+YH4FEs37274OBXXMgT9Q2j?=
 =?us-ascii?Q?9oK7bg1NbFNiucPiLGAqNUHHmQrwNYynxepnSZlwFv8OzlK0wcerZ34xphYl?=
 =?us-ascii?Q?WV7zb2RqLyTx+XFEUHI27iDsO+yCGKvga6fns6OL56pT5fMna2XgxEY2e/wQ?=
 =?us-ascii?Q?6XWW9WjGLw1jniIwBItEYYgCMUNsJCoBVZq1dYDTr2J2W/eKQUgSqyFnrcR8?=
 =?us-ascii?Q?H94sEnSsuCVzQso+FPJmui1idur1Ke7wXYRyjaOb7v3BTs2iV4sFC7Ia5GRi?=
 =?us-ascii?Q?RqtkLuH0Bt9bXDcn1Aj6PPPICfZxOZ9zI5dPsfFk/dhSaRQlC7RxCyjFiGQj?=
 =?us-ascii?Q?NPbuOs8nIpZgNwzCwTJGSdswO72wU36CcV9E3D1L7lNgM7Zp+QTk+AkKfuL5?=
 =?us-ascii?Q?5mFuqceD1U0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yDYghl1UJngYQPcDjyQaxa6fzsF0L0IK2+w7ONtqElamYTuOni/GVT4dJB9E?=
 =?us-ascii?Q?BPdMn76eT+D+nmmNI8mSVqHnCxP8ovLDxy3ZOk6Wb2mH9DmuczpcNVJ+tN06?=
 =?us-ascii?Q?rbS7K5eJ39AGYDVHdSVdl7Ov75eeJqTZWXCWFzg7mNhRrm6pSHqEhHGWohtH?=
 =?us-ascii?Q?TvRZhWap0BrG6oSw+us0y9Cvre18LEmtngl0Sgv3zVk/ogph07oAnyXy9f+5?=
 =?us-ascii?Q?wn5TuX9+y9yGYh+HFg+NryIymRv3TA2neSa9DT0Bf3m6ddi1p0dv7wVCjemj?=
 =?us-ascii?Q?Yunv6oUtb5lD3EqnmzG/FhbC4gj3/o6Y6Bvw0IdyVwBVGhf8D19BKmIu318h?=
 =?us-ascii?Q?mQbAstwO9gQlL6TUDMWD3D4xP62LvpAbBlUqTFJnh/AsWhpJc4GwQIe5Alzs?=
 =?us-ascii?Q?jCEFFQxTAy/x9GKnFnj/ux6kJ1vEUmv3bGbkKXznrKylECNatpxxZBNXBCqB?=
 =?us-ascii?Q?ux9aUX2k6mn6MakfPSBkIh3COIMCBrovEKVvPnWv0QSATMaWSEt1f5+hsGDe?=
 =?us-ascii?Q?Ri5DrTVqtbI/70ifq2YfSNfNZEjvV//pREfrpjefllm7+k0LV/y6y6tCc56b?=
 =?us-ascii?Q?RG6b5Vt3cDC67Ct7+/SO71n2C1dQgwWCWZpV4ijJDDSZogCOapTdGL2bzPPt?=
 =?us-ascii?Q?oXmoStE7MzwpZI6ew3/LuieGA0h8YXa+FWXfHrwIP5InqZ7NZlOIbigqhii1?=
 =?us-ascii?Q?Cq8FTglirLhqONftAieeE844nel+yZY7PaDWEqyJqkrskHlPNZQ03iZzQjg+?=
 =?us-ascii?Q?DQERvNh47rFm7s5o5ip0iKZc4j4XZLYbSOh6X7ppiFnjJSu2HbWRigy/ObRP?=
 =?us-ascii?Q?MmMu9euB44fGPsqtChJ79kWLY+RoVhgIzifllbmw9YPU8GtceXA6UCuSeSPA?=
 =?us-ascii?Q?kfrwXwoQubUiUb/EmcWi6qjwy18cfJ0yh1Ba1lV6urgw6PXwIgNhi9kjXR99?=
 =?us-ascii?Q?hUWO8l3NvUmjA06uJiSoMS0brxGVFRtRpHVAl40fAN+/TfBJiaFUkWSs7KY7?=
 =?us-ascii?Q?pLjHPQjLbWMlkXp8IaR4qaTrZc3p321pEhyWnEDwUMDl1AXpIwb3clzO/X/W?=
 =?us-ascii?Q?0RVnFBYpZ8zFd6IvG7IFMzM4lC4zW+3xEXdpx7geFNsJcyDKk/h+91DaZb7g?=
 =?us-ascii?Q?7QNVN+A+e8U+qLao6eHkHTuy3x8xsQ+XzcLg/jj7iXZrsuNuRL37BXaO/08D?=
 =?us-ascii?Q?CI6f5/KYYeZeg7aJH9U6rqG05IA18HqVS2kW3boShkA+T6FVkaBlQetHHyjO?=
 =?us-ascii?Q?cXDLs/tg6ejrminuFS0mT303d9qI74pLimDypOSBmCzyAkhurObDdFUVBrWQ?=
 =?us-ascii?Q?SFoPHuE+oTXcWqU6Z9r4ySwNBPNy9rlnnxw669NCSXYwi9G0b9251STEagKL?=
 =?us-ascii?Q?oYn4cync6hioFXkrsOO2/yTveL7mtJNMaYWmTIHJ/LwmtF+PGlNqchYTOXtW?=
 =?us-ascii?Q?Q4v3EsKaM/AJZOe3KR9vTqk7XRqLV3k67GerDxozzEFFpARA63nJ1JUcCHEe?=
 =?us-ascii?Q?tM2A0Uszmt+1USEFu3IOwlFRMOaXu7jYei/EzBwW5W9QHnrxHURr5FOHe80/?=
 =?us-ascii?Q?KzwvzQgOiRUQlkCI6c0NUptmyRmGHEnaO7esGj6/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d91a7bba-c748-411f-866e-08dd8796f1e6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 03:27:33.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eq7YR0GDGSJXgbjV2/pPlgk1k+RpLUun7OAykC9t/fh+LtmoG4f/+GnskQB/OQ8yX0nhioAIlu6zYvsAhMscZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2FCF00E1F
X-OriginatorOrg: intel.com

On Tue, Apr 29, 2025 at 11:36:40AM +0800, Edgecombe, Rick P wrote:
>On Mon, 2025-04-28 at 20:22 -0700, Chang S. Bae wrote:
>> > 
>> > This patch adds struct vcpu_fpu_config, with new fields user_size,
>> > user_features. Then those fields are used to configure the guest FPU, where
>> > today it just uses fpu_user_cfg.default_features, etc.
>> > 
>> > KVM doesn't refer to any of those fields specifically, but since they are
>> > used
>> > to configure struct fpu_guest they become part of KVM's uABI.
>> 
>> Today, fpu_alloc_guest_fpstate() -> __fpstate_reset() sets
>> vcpu->arch.guest_fpu.fpstate->user_xfeatures using 
>> fpu_user_cfg.default_features.
>> 
>> Are you really saying that switching this to 
>> guest_default_cfg.user_features would constitute a uABI change?
>
>I'm not saying there is a uABI change... I don't see a change in uABI.

Yes. We all agree that this series has no uABI change.

>
>>  Do you 
>> consider fpu_user_cfg.default_features to be part of the uABI or 
>> anything else?
>
>KVM_GET_XSAVE is part of KVM's API. It uses fields configured in struct
>fpu_guest. If fpu_user_cfg.default_features changes value (in the current code)
>it would change KVM's uABI. But I'm starting to suspect we are talking past each
>other.
>
>It should be simple. Two new configuration fields are added in this patch that

Yes. it is a minor issue.

>match the existing concept and values of existing configurations fields. Per
>Sean, there are no plans to have them diverge. So why add them. If anyone feels
>strongly, I won't argue. But I think there is just miscommunication.

Ok. I will drop vcpu_fpu_config.user*.

