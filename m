Return-Path: <kvm+bounces-66670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EB9CDBA13
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 08:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80CCC303868B
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 07:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFBD2F6903;
	Wed, 24 Dec 2025 07:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OMNrZA21"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4359E2C859;
	Wed, 24 Dec 2025 07:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766562839; cv=fail; b=hS4op94jUOcF9X79+um7hopiB0KrrILK+iE+qYZBppxknxxTz+QS15Hn2T4OfxbkM8ZaOREn2bHIwcK/ekJ9VuYt7K2sCWYwiSqB3XGdeaqw9RZl1AAVCYt+Ngw7I561L4pLteFEE7oDSvFT65OcXhco6lw+oHUPcel98WorkE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766562839; c=relaxed/simple;
	bh=92NrTkcztTGJkDOX9cEfiamBeeeYwz/60OMYJy/3Hac=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CGPWyWcVbHrc3gDnk2ayZdLT1Dnr74PwUXYc9BlNgVlHs5Zts0KD9glsqvmCGLtHBYq8TJ1NdPhOPB1cbSFxjSO/OAa9WhkDWL0r5FSc6CDgUsqkxlFcqPZhZlFXCMW2JEMQen0F9N4+h2mkwxja0cUm39Qd1G7ADZUXSoKZLfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OMNrZA21; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766562837; x=1798098837;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=92NrTkcztTGJkDOX9cEfiamBeeeYwz/60OMYJy/3Hac=;
  b=OMNrZA214MnEM2ed9SIqIc56za5ncJq7pKyAqPtOWmbQQ4Fasbs3JgNF
   xCMczQdNfBL4GwpYJJ5QuYhZNaSSRptSRoeGZjb0uARt1LA/cVvY6Anev
   6798xaK6T9XgsacvvSWKfcR/CXfYbafL6Tl4PebBfn1UyfiIym4rFDRbl
   VqctUiOB23pdASGH0ZmqmgjlAwXqAqPPz/S/FtUMgU3xa7C4fDYQ15GHN
   6zT4l/N5MOA3+sFQDMhFioUg2Csc7CzetPjsjC8utStvSvbXTbU4JWDlR
   DbqffRZyYTZ6LezYCB2wntSReXyUFER42fb/3z1CTD+osiAPKz1TK8YUk
   g==;
X-CSE-ConnectionGUID: tX3HBKvsR76XShGRV8eZNQ==
X-CSE-MsgGUID: AUNM9lrySmymKzqEBCatXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11651"; a="85824392"
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="85824392"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 23:53:56 -0800
X-CSE-ConnectionGUID: mr3iNyvaSNqrz687y26CbA==
X-CSE-MsgGUID: efmVOHJNQ9O/m/CP1HTIGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="199627583"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 23:53:56 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 23 Dec 2025 23:53:56 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 23 Dec 2025 23:53:56 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 23 Dec 2025 23:53:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzaoKQB2YTXiqoS+F7nCIKNWXX1lknZCZwdO9jrPkpVJKtTL39GoEbclT6PZOtkGcL7BwG3f64/vffGM/pe6J6yMU0doyeLIOVxp+zES38XLN7Mn8nOzswhP2OoQh8iAqbjQcvSRs49vopKu46vILQ8RKE5Lz3UyW//gbYzs2AtNQuEiqpD+NEBMl6Vbl9U9BZ32eA1dc6F8baUf8ejmF7QrU6F268lfqqoHA9qW/qkTReISDsMJsIgfMq4kNwBGY4FTGcEDpOBA/b+GelFF7jhvtbySyUZiA12TxCQNbsc9xt6RNZX+/G3NP00ofSNl+cPUC8eYsFTDANGQqaNkLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvtqRp3wupTtS+Wlo8fetJ1U9AlTCHFGCEGwKU/6av8=;
 b=s134CIG1pOKubBoVH7clcRfCaXpku/QPi60t+vF+hmE+z03RIUuEiS5l6cLe30N6ZJUwncyzO4b/qgFgigf/4sQGW611fH7de2OKwqIS6jL3i66gLVf+ojaEk9dMFKRQVlQGGRRkbCrwAjiMs97znSMtxW2COEzdbzmc7AWeJqj8z0DHJ/OMFWEvK+EhQZ78WlfW4fgmGqtXfc8p9KTlIqTyneywLZ3wq6eRNwYy2gyemLtCHO4aAnOYSh8Inbi1wb826zIdH4+adWx38Xsc0vi2jQnqYoi3+O3tEY+JHya6KJLRXRRNUu0tqJyCT/BepVDZY7p3rC/JKD7l1TZRYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB5873.namprd11.prod.outlook.com (2603:10b6:806:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Wed, 24 Dec
 2025 07:53:46 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Wed, 24 Dec 2025
 07:53:46 +0000
Date: Wed, 24 Dec 2025 15:53:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 04/10] KVM: nVMX: Switch to vmcs01 to update PML
 controls on-demand if L2 is active
Message-ID: <aUucAR7QBjVTC2jT@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-5-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a915f07-a825-4ab3-b42e-08de42c19116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2z5v5Mp7FomckCJZ5EVrcU1O8FVUAuoWdyLQZVJFAVAgJXKNuCX1I8i6auFW?=
 =?us-ascii?Q?hxvvjkbnUOsNXfmOyk8WyIPh7h3Y/XSfDXEtBk/6p5Z2bJlJgXH5B2jj6l+/?=
 =?us-ascii?Q?o8ndMv7pgEufErefmS+2+d9YdIYURAxtov1B6QfPqDYphSx8McFIqnCyjbq3?=
 =?us-ascii?Q?zc+9bTY0i0yR2ecBbwk9kaaRVeUE9NiAnhJhHFkAVSJCFsjCqEnk90R6BK2m?=
 =?us-ascii?Q?JJuERT8Eo5JbK2MTA1FIOGS6hGcjy5fd7KlYNsAy5EXd9R0kaEOVbUY2KeFL?=
 =?us-ascii?Q?6Ix8o/7RTNyA/NfF56P7Ob7cJzcjD1PheTbz/+cFavv1f0UqKZ9WuY0HJHj8?=
 =?us-ascii?Q?XcwVXC7Owq4wGuWhuqs0fLdv5LLgTzjI9CYcbpFUlX33Cs2WX1SM2cR46eOb?=
 =?us-ascii?Q?XmNZ7ShCZQk7NDBQEO164u/sVzfB9xWyfvnpp9gg6aWc/lWMDcts3N3UvFpb?=
 =?us-ascii?Q?bjSd+0YQhNVbpMw6atfUwFxCKIxYa63YaqQ8PsQfhrhubnPNOrSh8Pk1uggp?=
 =?us-ascii?Q?uqzW96lTPyWQmQTMpodtaXgu2ejU9Y+y7tPcfNe6nYCW49VjQAVj7IhVlMbm?=
 =?us-ascii?Q?WzYd+toljBh0YnjD66YjbeG+0NFRu2REYcIgjl5fEWRYw0xdb3FNr/S4YTZ4?=
 =?us-ascii?Q?ZuymnjXY1qyYQO1bbng5KdB41J0JfycFyjc9BuE0ukGaiVt8hAHlanlAEdOy?=
 =?us-ascii?Q?uPAjbnaVKCAFoF0c2dScDkcWVLd35j9xGLjqJcFaahm22nD3FNp3cIpcPl9P?=
 =?us-ascii?Q?osHV/pvDzVdvTCGgos7Ipfx8hKUgRl+Dew7diDA9LPjZab1IFGt8mQk7XNG7?=
 =?us-ascii?Q?OwyNg+e1sV3nF2v/E1pcrYC+B+6kGXGgD9yYufU1/nPqiPy2sIRdGid1oGAx?=
 =?us-ascii?Q?IMKWzzJi+1lPEBg4MgxODw1aRV+cwSm2ObvtxTAHHQQ+kthqNvPEtCWIjCwy?=
 =?us-ascii?Q?KAT/+Zdl1ZWqOHZHtkP9LHOiUiezfgs1gUG92fchcxIjEC/4tin/WyAemNOm?=
 =?us-ascii?Q?w2ykYEFu6L+PmsUi21t1nFCDmGu4WkZH73892tv5ArRyUlJ0HT6j/IyTdfCZ?=
 =?us-ascii?Q?jBCvm0NEZ3IeZBJQMLJSyGU4Yl88w1s+4MVnHK/4evDD13qNBNbYUK8XOTez?=
 =?us-ascii?Q?BOTwp+TTaR44qHm0hSwudufhBeP8suJ7maxLE3Ve8JiIdROAzaqENwt43fB4?=
 =?us-ascii?Q?epWkhMZOC6x4tqQT6c+3DNEKgxei6TozsiQ4ndinOsCL+HfIoYxvZE5scYVm?=
 =?us-ascii?Q?XHjsz6xVvO4+HRzbwHICnouacpO84aIH1fUCyVi9IQGt5/ad33IZngjqmo6N?=
 =?us-ascii?Q?6OMDBk9jrD3Qof5BXCewMDwpzJrS1sG9aZ7KJEAD27vICyN/P1hej/fmrdxt?=
 =?us-ascii?Q?n1EjNHoQAb2zOu6tDIdfbMWDRNZ57VDcWdITEbTmqwuz0VUlEkVpzMI38ZVO?=
 =?us-ascii?Q?VRN/v5pspjTwH/xywSy+Vjzl8m6NN0Ck?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bQB2kG+58qjtksizx3gcBmW1EdiZtnyE7BYN5fk4YC/Az4j0BguofGt+nHsf?=
 =?us-ascii?Q?acDUaZf5I/yJBBkS5ks6oOzr1TscjF23ekKm2v4/Gh70fDt9/8V4lo7jg55G?=
 =?us-ascii?Q?S+7lG07IGRMmCBFxlXcnLF5BFVPG0WoDT/P+0Ga5JPCzSS6Kc59eEBu8XCZI?=
 =?us-ascii?Q?/XdarSCzhk5soQ0EuRFEvGWevvPC+CQOXT9O6nCsx1G/KVvlA0vRAt89t/wM?=
 =?us-ascii?Q?EX/ylfAMRZMsyp6whJmXECVfL5LJjCGM2Q31IUfD75FwvOwKiGcQ/+USZZ4Y?=
 =?us-ascii?Q?m0QUtRIZ4b8JKpMO0TY46x+x1X/LafguXjpZpK5iB7e04rmI44w/VyAUy6AW?=
 =?us-ascii?Q?W/YA3cofgEn+uIYNF9XNgW77MY6d3DvPRPSF96Hix0bKXPBbsOcbdOan0ycg?=
 =?us-ascii?Q?OfngkcMySgHVocufY98wKMnFdPM332L7y83IrUrKqnYHkeWJGwf1kOOsbQ4D?=
 =?us-ascii?Q?Y+DutLk+d5cWY41KgRZ7cUOk+/dMVsdY10RmAEVmY7fwCRMZxdhJ7feoTIHk?=
 =?us-ascii?Q?JBXWHn1nHkHKkLI5eGJf2DZzbBI2WwNt2kQreP+nXAAFE6Jl+F48Z+2QgNzk?=
 =?us-ascii?Q?vQeyA9NjwtDSJQWmWLkdxbWI8bs+N0rq05UeQFsopExRsH7/NlfNEXMR5Irs?=
 =?us-ascii?Q?zrZqB+C2tkpVd9aHWjnvxlLNyiJzyUQ3zUAr9/Zh785YY1uXcZd9ZeU49AQl?=
 =?us-ascii?Q?faekL+bw/FD/ITvvDc0B8gME0jPMfsH8ZL61Yn4l6fspxqr/C5BFi+KTCqWq?=
 =?us-ascii?Q?e3T8Sc4GjZoWDPiwBuw3zu9lUhZP4R5I78q1FS+7KXdwyZ+cJga+XmwFB95G?=
 =?us-ascii?Q?uNU1XCgwveV384kk3uEe8PsUv5rnu847BDiX5j4N0gsKzL/z6qVyaXnNmJ5m?=
 =?us-ascii?Q?k4+shcM9ABTSbJOXraiTRCkVL/DtnQcPw5igUXLVVGAun67sgJxZ7kl6I+UA?=
 =?us-ascii?Q?55+s5xajXn2123/kDI+g+fg6uvCD6Rq9KsYKRJEguizLldK+ivez06G9GPsB?=
 =?us-ascii?Q?dN1TFJw5HwXqQlzByQHDy7//MAOJR+PDrpTuIh1D0nkcAIAm9/zNeteU58Pb?=
 =?us-ascii?Q?a1dFcc5KMw0UH6LMMAgEXAlCWt6HWOryo8pfqbB7C9K3hEfvLuF2E4PugS1U?=
 =?us-ascii?Q?xzO+Gl+LRh2Euj2KrDTtoy65LuC+IN2TJfjJfCfiGRb8SS7U+BwAvVNEe5g6?=
 =?us-ascii?Q?35FyzIuPIJs6ffus2PzBHnUJ5s/LVgi/sdtBGyBn9j2H4xgDbecoFSEgzqFp?=
 =?us-ascii?Q?fKuCqulZ5VXLQXS7PqlRrmk14dvnhn67XknkQOB51/Vo6/xj/JixjF52xk/2?=
 =?us-ascii?Q?GHowEpbfFerjgqRlYc2T08JFMubq/4qjSQPgiIjro7k2TvoOAcrvR1+c8plD?=
 =?us-ascii?Q?stgE7yF5CN8omrnNZF/YZu7L4GBSJXjskoBjyiHZ4Yar5Yh1CMDw1CELKiTR?=
 =?us-ascii?Q?ogVgmWwWHxP94E8XTOinV4WqId1sPJGJuDqc0QY33EtNbv2s4Ho2176F8UjD?=
 =?us-ascii?Q?82BN5EP3oWsY95iM/s7jmNTHSLt7FCE4ZUBPgT9saGcMMoOyqjbt5tCIj8mf?=
 =?us-ascii?Q?5SZ2bOX7nEJlOtdc1v219UxBTMqEy4w7KWjh/3UzIA24QBgnU7wUEe0kmVUT?=
 =?us-ascii?Q?h1HZWzvNuFgSA5L0eiCyifH0GDiSqtUFPGQawNBLpn5AYQ3kQgmkHBoko4g0?=
 =?us-ascii?Q?Z0MMlD7+SQue7z8PjI8yztTRCAKSfLGIi+hWt1x/xWtxKaalXixMqLP9wAHK?=
 =?us-ascii?Q?Cp0asGLPdQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a915f07-a825-4ab3-b42e-08de42c19116
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 07:53:46.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuK+5pzMFlDYwAabTDfjWnRfZP2UlazQZWkRDvXE2t/4DhGRXG28/sopKN/ElAchKkIuUNfgBS7ssrGiUOJT4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5873
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:07PM -0800, Sean Christopherson wrote:
>If KVM toggles "CPU dirty logging", a.k.a. Page-Modification Logging (PML),
>while L2 is active, temporarily load vmcs01 and immediately update the
>relevant controls instead of deferring the update until the next nested
>VM-Exit.  For PML, deferring the update is relatively straightforward, but
>for several APICv related updates, deferring updates creates ordering and
>state consistency problems, e.g. KVM at-large thinks APICv is enabled, but
>vmcs01 is still running with stale (and effectively unknown) state.
>
>Convert PML first precisely because it's the simplest case to handle: if
>something is broken with the vmcs01 <=> vmcs02 dance, then hopefully bugs
>will bisect here.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

