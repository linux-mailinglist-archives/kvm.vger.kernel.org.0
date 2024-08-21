Return-Path: <kvm+bounces-24690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAA29594A8
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 08:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F9661F2446C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 06:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCB3170A26;
	Wed, 21 Aug 2024 06:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUMXJjZw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D355916D9BE;
	Wed, 21 Aug 2024 06:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724221891; cv=fail; b=GWt7Q42p9d1uxw2UtsCftDqfi5VMKRWsrwtxbrou5G1GHwy9ZDJOV5tVt1UzKAfkFl1L2XvVpXjBppkYzMtCDYKh+W6IY1xgoBIou/qmPe/bVqopW1qwbKr5udyf7BeZUrjlFxZ14yS5FVgsmtzUcZLmui0OIik9f+rCJnMt+Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724221891; c=relaxed/simple;
	bh=JoqM9LDn00GB7r/R09fnPaArK0kQN9TqQTeitS6W7v8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ncOPuwNTEHehy6gntDFLqQxzwLgS1f+u2XxmL3abd40MmLZPFgFzjh6pH5v00fNF0ZQUtVg907tGEdkPxsQrACs80EU1zCBFcKwAJlMCa6J/TqExnMJEwTrvrsaeF6g9I9yp7zpA/lYdbi+ZrU36bfOTgoHMXs51cTrpPDDQZRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUMXJjZw; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724221890; x=1755757890;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JoqM9LDn00GB7r/R09fnPaArK0kQN9TqQTeitS6W7v8=;
  b=aUMXJjZwWhXqKys2YuWBV9FcMYPO6yRRKz5d7IQpAYIeMsWRGZz6x65K
   s9//kNrm8G3W72LjlBq2xdvLdV7y9qTqKbl57NBK7AYCZCDvZ3PfPBqdD
   QQA1L+2v+locbP5tPe/PggMzAx01cpqJMUPzfSPfkxhh6RVV+AzHN7At+
   ogb/21YfvHmbdW4NFn6vnOO/PF0D/hTjN82eJ5xy32mN15CvnsnGj8T9i
   lPvsTmGzzX4P1yoJLKiN6oklzbZvB129XQ/3Jz/4ZvcpOZW9hxCueAmc5
   4FZtwjhNi3hEvC1nvbjK8VhkzBpwX1XOCNePEnG3wYsqVX7xmeWbzw+fl
   Q==;
X-CSE-ConnectionGUID: 4Ux/4ChGSGC/SHJbj7jNDg==
X-CSE-MsgGUID: SLvBFreeSaWX3FnbFgKLpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="47954806"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="47954806"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 23:31:26 -0700
X-CSE-ConnectionGUID: oJv8AwsaR/ODbQimcELhJw==
X-CSE-MsgGUID: jjxtYk7bQJyfh7wWZSY0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="61521350"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 23:31:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 23:31:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 23:31:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 23:31:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 23:31:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BgS0ydeMzSYx5BepVBo1q+eJRv95nkXMw5E7iVNaYNFSJ9XMCeASoDSe+l+MDSHXC6gunhZ/XfJXZlPoyYb9s2kW5duj1iV116GJZ8jz3fGyItkAYB0ZLeZjK8Mjpq7wm78R2TmQSrFpoJNME9Uh0teX3NbH/nMAtVnotj95nl9ND8ylFZF0P34JoCrAOQ0iSaMwwFlvCmkNCToMTzLBN4xySBDa3/W41rY7vdgpxlx1lw1wDehydMs/6bhaRXur6EF9966OXP9eX4bZyz65o4lVY0T/aPJG98Xp1VdGeEvFaAD1wiSAN4ZGWb4ILg5Cj95p/y3Hugvgo2ABGFgIDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BewN9xiJTgu7Rlaw1pX47QDPd9DfUejJeL5WAWMR0w=;
 b=Pbl2EMpjuwIY4dJaK1vGdvpoavaPSScJ/iHV3V9QTZKUNJ1AxIQmcecQ9la4bKOnMmF9ndVE38CwkGiF1l1j7poRV522wakO1ox0mDCiROlr5f2pDB7BE3WnTwTRZGGstqXcUitolIiQWITJKDB+8g3Z4o+32RwgfQ/u6YprGljgJxbKHl5x1VkWPePi97lPPMmlLVlG3RzRdDTW9jLoAxIqfyR3Jizjk2S6+73XtQaBd4pI5gWtVxSnp8gQVVTdZQX8b5WGMjH3X26EuCayYHoO/N63l6xWLud7vjr+C44gqDfAEyDABRRunZ3s6ib3YjC4usmx8ckWGJS0ZDwunw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 06:31:23 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 06:31:23 +0000
Date: Wed, 21 Aug 2024 14:31:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Suleiman Souhlal <suleiman@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ssouhlal@freebsd.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: Include host suspended time in steal
 time.
Message-ID: <ZsWJsPkrhDReU4ez@intel.com>
References: <20240820043543.837914-1-suleiman@google.com>
 <20240820043543.837914-3-suleiman@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240820043543.837914-3-suleiman@google.com>
X-ClientProxiedBy: SGXP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::30)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: ff0e492e-0efe-4862-960b-08dcc1aae008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZRv/EOwgyclDvgh5ZGbOBSJ8kdo8b3lZ8Eds22aUOVlJtqjPlp7EYmqJAAlu?=
 =?us-ascii?Q?wVeUA6lkzeZ7u4GAldDcKH80fCFFOohF3/1oKLw1yyvg/Y7gRrSajljyLNzG?=
 =?us-ascii?Q?EBJYj1LWwd7nscj82cL6grdXclN8xvJShuz3vZuO5IiQGACRqewEVyIbm9Gx?=
 =?us-ascii?Q?AJgZPc4/4BpNN9s7q4gchtXSE4x0JYflHw9z2psuAmfMkK4WeSilvQ9IvyW6?=
 =?us-ascii?Q?xfkRUTzreKjEXPGZ4IIAXzOL957bOPLJ91ptxgzSH1CR9eJz+SYkZEUUAMVU?=
 =?us-ascii?Q?NAHuply8VYny3NB6OJdhQaLy6ft/0u2m3DX2Z6yiEUB9JXGNNWtfWt1ufwjP?=
 =?us-ascii?Q?mwtUYpXyQ7AMIQZd497pDBDhaiH6E1cCXXXaFGPrcegXEDyMI/yOgYKep1ph?=
 =?us-ascii?Q?n5gTWBZ66d36fqRBTDeQnRB51RR4fvsCaw23fLvSPPPC4gn1Ps+dav8A5l+V?=
 =?us-ascii?Q?BWCqBxFFduuCmj6J/lVymK7kMRApQXdBC47wUMlmgZawe5FhgUJaAGRoKHQK?=
 =?us-ascii?Q?joGKQa1+hzzoiNZFrC/bNOu4l4pD64gjm7ksVZT3KAnZbWpE5q9g/cJffTjB?=
 =?us-ascii?Q?zFjlAPJ7X/fn2/PhpAIRTyFVCZLIy4Y6VM+PIepiFcNax4aacIOrWit1gQLh?=
 =?us-ascii?Q?PR7BR2humgEPEDB6vzunsZ0Ts1UOCiRmZu0X1IKm1WeXOGOvAfuND1c6MV12?=
 =?us-ascii?Q?t2JX1YYAM4GYxqntHxTQ/AwUYYcKvZbNOHjfMnlpSItEQpk5aLu8OlDoyzpe?=
 =?us-ascii?Q?8cA5f87NVxagtJaDl3/hBmaXZSOuvW/EYFW14SMWnLmB6qBXHQt95VpbBzCg?=
 =?us-ascii?Q?3tQy4WH//3xtj+7ldmAZHvde6ilZeTEIP0LawuP0uiGPnGU2Hm8makKFvYQM?=
 =?us-ascii?Q?R4RIvt17oVRmm40/8Gf3zVOu07O7lwwgTce8EU8DiERuBVhkeYTyCeEkFz7y?=
 =?us-ascii?Q?fHNdid0qe7PY65Fk8aATuUOGmDwX8B8iqfg7Dalou/aAxqmawDqEgAgD5IAb?=
 =?us-ascii?Q?29gyiUi4a8sfesSJ/XFOhhJ/WbZAxrZsYp2bPulhvi9ebalFW6svX6o14qyF?=
 =?us-ascii?Q?3s7okNNz8e+P4RSl94BIrT6QEHPEjtLSiZqCne7kkgoclBSS90GjUX1mKCvv?=
 =?us-ascii?Q?j1cQ3M4JG8LgeV/s/Tzj2dwkqZd6yAbWmGPq2pGaAzf/1+sNF6rDbW5tZJmA?=
 =?us-ascii?Q?jTnqmlhUftT2lk112tJoP58TJWSFZvmMPkMS56umcDs7AAejmr4gfa0LPDRZ?=
 =?us-ascii?Q?MObxSK2lxbEbf/1f94iSnHRUTopCrUzhGJx94P5No+hEhMQgGCwtfEjeAArX?=
 =?us-ascii?Q?Hpo3tNwLE2T5x9Bx0E1mQAdEOaSdXMfo0jzta9Wd2teX5g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HZ+tMiX7BuHl3fpQhUW/CxWgYLBQLQwx+ZsMsqRRoUJMrstR/YeqSDjqsuiN?=
 =?us-ascii?Q?icCZTIAyrK9q8hUiBO5m9o22EFqQ4SMF4wBW0TV/PwUzsc95YcHlUzSaMcuG?=
 =?us-ascii?Q?eFDbAMeePI7w/lSEOxEHowrFMkcgYh7Vj3q+Rx0ZI0RwVoRmonfa36GbUHFr?=
 =?us-ascii?Q?xgj0a2zidQEwYwpnYloRO6hPM6usRGfzJuV4JW54Wr6i0iYu3WWo0S30536+?=
 =?us-ascii?Q?JGP++fgj+ZBQyLietEEo7d5w+PVcESkltLEeBzKcalc2401JXHWxZHb4nWLK?=
 =?us-ascii?Q?ftjj+mxFpK47iZ1W/YIJN5dZ/1YdtWxLE3ukI9Jgy31fNYF01eatKMdZ9z6a?=
 =?us-ascii?Q?qEpt+YyaOgCW/54jU70Qciht5Zbtd3u0Mwh7GncBLo7+SRGEHFjR4oGlkIby?=
 =?us-ascii?Q?kdseNUAkRQH8PIp/Xu3gy4ccgV6vrM+ECj4KLrNicOo2Ysv++utvPmBU3C9z?=
 =?us-ascii?Q?znAYchJIbHkiIHiz34RZV6RnkCesnUKwe3QTTjEa8sMf3pJxkjtkNnzCeMc+?=
 =?us-ascii?Q?FbzNn/0hg0lEax7OZiTYT0kcXwBDjk3yYl5kPfWZ7FieN9XS8isrkqhwfXe6?=
 =?us-ascii?Q?dZk6+K5ItlPcuUa+ieBJbJaPaOpy5mSwgifwN8bd+Tcc0RFFP80pVOD4M1Xm?=
 =?us-ascii?Q?okCRmq1pqIhhpo5Wu5ZDiQ0Sul25N0pafrzMRYSgZeuJCsWu3uB85ojM3O3n?=
 =?us-ascii?Q?0MNvvuy9zSCkB23RIBweM96DpEh74QE2Dzo/Av/Qs7Ag+2yu/POxA9ZlQGo0?=
 =?us-ascii?Q?PzVQ0x1Dr2oKTGHD6D+yAZYIzAfDNTHYZsmQwmi2uZJWU+/wvRMNtfJpj26q?=
 =?us-ascii?Q?txk3kAru/zWKLIyIz91IGJVNsxRMBYQI1bwxW/4sPyjJ8VtHMod8OohCyVlh?=
 =?us-ascii?Q?zZbv0dDUiU0H2dQ+OitlZwYXe8fOhv1ydalaR3geANZuNtLi8fiPjstRhobU?=
 =?us-ascii?Q?Xhu1BgkORqB3yZD5f3zk3pDMyHHuvWOhCHvBegw9uSpjTB4+vgxyU5ewidii?=
 =?us-ascii?Q?0h4ENQT+GrjbJYNHSg1i44VZrlrifYXvp62eP0zyxdrrNyk6o/lMVbQI3dHi?=
 =?us-ascii?Q?M1DNuoZFWtg3uTOiQatFylOjAi9UU6jmyIoS0BxkKRg2wWvtuYi+zqXVb0EO?=
 =?us-ascii?Q?76DkMwzOigmc82TbP+9l49EVWr3foZIVr5RmbGjs+cNcFdCjHvGCHkAwDOyD?=
 =?us-ascii?Q?HjyVFrft8GkpYWZWI0V+UfnlZoL8trzt+36wHMRG3NEPJP1v8jvJ88h7nJtD?=
 =?us-ascii?Q?8XttaJCiFX4RxB+5+eMywiWwZVRX9v1Pay5xAbWBp5wDy67bwbvPmxw9zr+/?=
 =?us-ascii?Q?34F879lTVqhBhuxt0mc3NunPLooNDfAj8UuaX31+SWmaFl2fd5Hnu3uORVj+?=
 =?us-ascii?Q?zlhTK0gWW/fKRmHPv6d6kvWoI6/M3k3vk/KLt3mzQjcvfi5wL6ndbLHV+BDW?=
 =?us-ascii?Q?hINwcPcxjZtSXiyLwSwGuaKPJ/tGY5xKhbdRkjkul2zR6im/MIxGLze+/dpK?=
 =?us-ascii?Q?YaIRUrlV1A2mVrfue4XGO8AKeEa8BXgQL15MP6k5O7hx/gXb20TBmDTtBSBG?=
 =?us-ascii?Q?p58Rc7lGqBtGjCAwMDA35l507jSrxOwTp+e9fUxI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff0e492e-0efe-4862-960b-08dcc1aae008
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 06:31:23.0080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vj9xfEruEEUGb8FWFbN4hMeUQtJXJxfecxUCUWzHeIh9q0fMXEBPMC52vUXvILsu2bEYpERIAfbke4kJPWKuOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6392
X-OriginatorOrg: intel.com

On Tue, Aug 20, 2024 at 01:35:42PM +0900, Suleiman Souhlal wrote:
>When the host resumes from a suspend, the guest thinks any task
>that was running during the suspend ran for a long time, even though
>the effective run time was much shorter, which can end up having
>negative effects with scheduling. This can be particularly noticeable
>if the guest task was RT, as it can end up getting throttled for a
>long time.
>
>To mitigate this issue, we include the time that the host was
>suspended in steal time, which lets the guest subtract the duration from
>the tasks' runtime.
>
>Note that the case of a suspend happening during a VM migration
>might not be accounted.
>
>Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>---
> arch/x86/include/asm/kvm_host.h |  1 +
> arch/x86/kvm/x86.c              | 11 ++++++++++-
> 2 files changed, 11 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 4a68cb3eba78f8..728798decb6d12 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -898,6 +898,7 @@ struct kvm_vcpu_arch {
> 		u8 preempted;
> 		u64 msr_val;
> 		u64 last_steal;
>+		u64 last_suspend_ns;
> 		struct gfn_to_hva_cache cache;
> 	} st;
> 
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 70219e4069874a..104f3d318026fa 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -3654,7 +3654,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> 	struct kvm_steal_time __user *st;
> 	struct kvm_memslots *slots;
> 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
>-	u64 steal;
>+	u64 steal, suspend_ns;
> 	u32 version;
> 
> 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
>@@ -3735,6 +3735,14 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> 	steal += current->sched_info.run_delay -
> 		vcpu->arch.st.last_steal;
> 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
>+	/*
>+	 * Include the time that the host was suspended in steal time.
>+	 * Note that the case of a suspend happening during a VM migration
>+	 * might not be accounted.
>+	 */
>+	suspend_ns = kvm_total_suspend_ns();
>+	steal += suspend_ns - vcpu->arch.st.last_suspend_ns;
>+	vcpu->arch.st.last_suspend_ns = suspend_ns;

The document in patch 3 states:

  Time during which the vcpu is idle, will not be reported as steal time

I'm wondering if all host suspend time should be reported as steal time,
or if the suspend time during a vCPU halt should be excluded.

> 	unsafe_put_user(steal, &st->steal, out);
> 
> 	version += 1;
>@@ -12280,6 +12288,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> 
> 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
> 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>+	vcpu->arch.st.last_suspend_ns = kvm_total_suspend_ns();

is this necessary? I doubt this because KVM doesn't capture
current->sched_info.run_delay here.

> 	kvm_xen_init_vcpu(vcpu);
> 	vcpu_load(vcpu);
> 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
>-- 
>2.46.0.184.g6999bdac58-goog
>

