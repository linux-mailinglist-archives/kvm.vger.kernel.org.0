Return-Path: <kvm+bounces-47248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFE0ABEF62
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E77473A9702
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9CB23C4F1;
	Wed, 21 May 2025 09:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a69OvURI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B841723C8C5;
	Wed, 21 May 2025 09:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747819102; cv=fail; b=glRbDCd0z4/wwvfC98No7AEpht/U2ImFKTFAymRw41OAqgvvb0E3TxwHKOFrfSv3Kl5X3o1E5N/ko1BvW2hcJ6HAkROwNMs8LLw9Ubq9VhHH8JA7J+zQG486LAoBmOqBrvEExpaQCeJpDTHoFh2t+qglGaeNeg4U0sYum2X+p8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747819102; c=relaxed/simple;
	bh=zobj9wTEVUOpjicc3wLuowYrQwAMDf9plnENXpNUKPs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OwMdgc0OpNSPNvHfJbMssy04+9eM0eQHYbG6cuDVdWViUtqhN9DtBwmZdbtvoSr6f05jY5kTg+HpJ1exD/3/uJEAySum2Zm2ZrQ3Ez8zYnjXkrU4RC3arWDZpQGEuXpYwyPzV+VIoBeoP50rPbccjokLcNnxUed7pv/fyOkh7fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a69OvURI; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747819100; x=1779355100;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zobj9wTEVUOpjicc3wLuowYrQwAMDf9plnENXpNUKPs=;
  b=a69OvURImREiGr2mUFDQ7Ki8XMcXbMzlvg3zZy6XSi4ySd0ixEc57oAP
   ehb2bILTMdISIx8z2jl5Gr9gnZrFD5baRHN7+oXKu6Abb8mDyGwl78Qdp
   9dhkT1K+Pfjen89Ls4Mi6w/iaomVkLh/oY15xTViDG9/SUD2y1bAs7JEx
   wvv19HtEbJ7S5Nb/TDGPGirMlz8GoyMjegFnPu+3jN3eA5SXsVtQZAe1O
   VGcJObJVxG/pwXuo+FtGBBwFlq4O99CPgfIYYbexauLH2kQNrV3bklZVA
   B5IxikWxpSZnd6zQ1nzGCGux09d1qTXfesN6jJY/QiZTAtV1cVviFbbY4
   g==;
X-CSE-ConnectionGUID: OvPqN1FgSL2cnTahV1//og==
X-CSE-MsgGUID: wl103qBfQsiYgxHKFL+ipg==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60445983"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="60445983"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 02:18:20 -0700
X-CSE-ConnectionGUID: fjEhMOCPQ3mBwracg79wDQ==
X-CSE-MsgGUID: r+ibPCvURj63oDQwsUcu1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="170983882"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 02:18:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 02:18:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 02:18:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 02:18:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTCd+hOc61prNiMMy1n7KD2BZNteIWTITvhdxFObcWg8kCOa7dRfCS2ABF6qMCoiZOWA/1MiWAz8BkcmSxIk/8Vsuaihg0yjCIVVSOwpXfY3pEhf2+5xPjWM9NcfLPouD7vMqUTgI0t1cnsxngRoGsgT1LqpUiGSeLPadUbBhV1aL4JOg4pnP4kaJev4bpLihzAcHfRQTSzy7W3FdN4ccEvlDh4+LylX7bd6X1OWP0V8yjbchy7nbkUAIJ6TI54NndBV32LAJ3wPTfyGPWyNX1fZjNeQV5jUTI5D6+zXPNbjsw4mgQ1ex8oTEdFgYhp27choUK+MoESed9cfMLxwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQ0fBu5MApLA07PcJ9wYtbkWvrQqKWFPYHwxPutkv98=;
 b=CxWztmIy554/3QsVZOoaHwToUkB0z8McQcOMOyyriBThtDJyUb5o9nnHJg6SLPxMHNh1wHZkGkJ4aM1jMIqy4tQhK4rkzDKbgkuP7MZFYr9n2TswsWyVWYFnzqX7T5Zws07p9L/pzWHoNzrX0o9G8DJkfmVYCX/C9Vzoeu/CYfabYf4TqXP1hPdyv1VLTfJYRRCL1bjoozq40XUdLmENhEQrGlV+x1EPHHnoBEhM9EEiYcSpEnKRzDs2QM6pzg54NGDFpx3mSBCI9gEXd5ltp59xdVqRkMnmt6AYiu2rZm22i/99CCmrKPreXUW48tLw4NWPxkAG8eGyH5Atlhb4pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 21 May
 2025 09:18:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 09:18:15 +0000
Date: Wed, 21 May 2025 17:16:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, James Houghton
	<jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 5/6] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
Message-ID: <aC2Z1X0tcJiAMWSV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250516213540.2546077-6-seanjc@google.com>
X-ClientProxiedBy: KU0P306CA0055.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 611dd4aa-5e7c-49c0-4ed5-08dd98486a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OzrQmEIcHrHdBJvAde0Mh+C5E08r+njseTp7vCZwRvL5110QHdmIwJQt6A26?=
 =?us-ascii?Q?BvykbuG3SEIHkbIPA6CHDPLGCoOMWEzloCEUlEKKMmfsJtjJ2BLLj62PaDzH?=
 =?us-ascii?Q?wWd/0ieus3OTeWjXxh8JFdXd24bCcI2zKuC2RHIz2LdWiIX0xGIfp9/WGKO2?=
 =?us-ascii?Q?y5Ps/dI5E9LSjtTgDKWmvqhS387oUBSXrSCV4btW7vGG+ArHFshsrQXBv5Qh?=
 =?us-ascii?Q?yKrc2pKXGdhkbnvWQYJAeDZI/ghg30msfyN0hJV2lKanpQMcQ0WIuT3OJspV?=
 =?us-ascii?Q?bOxeClam418BnwdwkynVAW8e6J0jIViNn17h/CAjh++IErw1zDz/3/ZMINDJ?=
 =?us-ascii?Q?oIubVGpq21ES6SQ/vzCSFFzKJWk9kY8oMHSdOCWOZT5I+PnpoXTYF1hRhey0?=
 =?us-ascii?Q?ZRd0zEr37fcjT3w1usJyiNPfxNy1bSg72VivFMh2w44/mqXxloXIBhSTfgI8?=
 =?us-ascii?Q?82K1M/3nznOoHTkwEtMnTvbgSYlr/LHGn4QuPG/dAePpK9KK0k49BJ0lbq5z?=
 =?us-ascii?Q?PBBlZ9eveVRwEu8QvLio1kgQZA1bWjs7uyCZbsh5FgRLAjHyxYobnx7uDcWP?=
 =?us-ascii?Q?FTPivh8V6xYLEq/Qibd98fooEs9EpwJz4l/HbPP/YLuu8j27mXWuy+PAt79a?=
 =?us-ascii?Q?0HLo80LdNZQljcs/nqGkeCn3/y2WWkZtMULi7RUxEEhbg5okt/er/sz5h5Kg?=
 =?us-ascii?Q?1+d3aoIyEjx/x2kD1ZfXkWUqzhPoREVhiEJST/IZ8B9hAn6oNLW2Wr7VolG5?=
 =?us-ascii?Q?bMaHKIz9EGPj6JTCnyeSoJgaocFmqkVyY3X+1FGtCOHrXnF40cJr39BTrLXd?=
 =?us-ascii?Q?bBa7jX2lm4yMQgmWzi1tGy9WmRDRWYKczdmuAAxFp996/z5sAy43TMHBSzMx?=
 =?us-ascii?Q?yRXNkSMnqhlUuhAUsWLOKHyO4NC03pkuq9sknsZCdFYOkz6gwDQQty256m+o?=
 =?us-ascii?Q?YD1JejUqzN12gLk+jVrcD9RsGo3NkgT2xIQWERYMDvSnpVtyg6UeAJtDghLA?=
 =?us-ascii?Q?ZvS2DkgZ5p6da0Fdai5nfX62MvNuE9J+LkhIkd6FA01bw3G7zchTIIUrKSZH?=
 =?us-ascii?Q?sBtsW/lQhgPYtwaflUR7EwQRoBJmkUDnaHmrVXafQKZFvQQ0Bw0CVpWu24lU?=
 =?us-ascii?Q?Sb2E1NhEDEpcKSVwUX1G66DU1ZfzZbsJPX5I1/BcutmubMYVGyCL0f1CjU3N?=
 =?us-ascii?Q?H/52NHRuiIIlP9cqqR/4piULOqvU2gx7fXVMc+1NxlvbaGKA/e29tC6gCsv3?=
 =?us-ascii?Q?1TTCglUnDOeHR4IBoU/t6/Ql0J6shEwR9HOE08LmN9OdptjrZWj0Grwqsws6?=
 =?us-ascii?Q?EDHHTPh0zfppvinuz1kn968uwPUrE9Ezw4CUq1HaxuWtK3q88Ct9CC7S5omc?=
 =?us-ascii?Q?K1uh+Es55sr2F5nhvPBh69FiHaoM3vT+aG3kk57IvUsCaQL+o3JGGhXF44/m?=
 =?us-ascii?Q?xx8WnDZ2Crg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IhPAcKKIbaI7asSHj21rFvmb7hA97cKKW5J8hfkyTCfVJC3qvfnokLLYxsa8?=
 =?us-ascii?Q?YHbGv9YkJOXBGn9VfcOMa6N9L4iSc27rkkY5iwNcK6nghClKyQLSyzVPMJDI?=
 =?us-ascii?Q?7snqBcsRKYpOUcpL/qlE/gHXH+wSGY3NRfIMW5p3kHWQQ+2dpmJ4P0qW1b5U?=
 =?us-ascii?Q?WeIeKqmvE2PL3FViFOX9di9D9FLic1sncyS/HitmRVtrkW+bUiY/zg48vKQ9?=
 =?us-ascii?Q?nBDKzGuA92WusEoWvxSLWmfv7XDIGdfF7hsgRIG4o/maXjwnX1VOljg7AKis?=
 =?us-ascii?Q?l43kCzELK8u6qOnecm4tICZR9zhVMiBWEKhxBmYB6DL0vh4QmaOxG0p+jfbw?=
 =?us-ascii?Q?HOHxg447tsDX1d+7QCft7oTEX7xxqgeZiIXzyLaxQWSBN4iNpmzHphHRpbhN?=
 =?us-ascii?Q?yuv/nVteKc4MlhEFUvjWDO2k4idA7n1RyhAesARgEVlpDDRZhLX08VKuFBIK?=
 =?us-ascii?Q?tcTUbwZaZBu3hIgCTuDCT0XWa7KtNLWLlUvOZuwI8BXW285zaVgM9pPNWprx?=
 =?us-ascii?Q?AyVDrvL2uPngxYdjlzCIhlAy/JsDlRq4j+GVc715Ym8uFQaa2hQRlx9+zcoS?=
 =?us-ascii?Q?ZfWn9ckjb//T26XxoJcsch2EAGf/2uKy33FUWSW8PeGMxv1jHud1sWpAZcRU?=
 =?us-ascii?Q?VSELsTZcmvbWfTv940tHw2CmYZqXG357FlpjPoObVhcFFT5tWJQCrna7q8pn?=
 =?us-ascii?Q?HalfVNmtHAi9L2lDmMzu2YHZYkgM5HYmfySAFDc1F+Ptzv9CJrEjZfX66Ma3?=
 =?us-ascii?Q?5HSpxmUX1ksxs/f9xTbRNw+HXRnZIFi5zoR5cC0pdY3sLHCmE2ulvmw4yYmW?=
 =?us-ascii?Q?1B/knpAMs6LHhL8yn02WonVg0HIMbiBc7cozIkEfMZnW6cOmut1orOHQbxkm?=
 =?us-ascii?Q?PD6kn7t2fWgkrbjEEuZhTmnJnZgbedD+4Wsu89Q4zsIa6msoeHSeJexB+bYY?=
 =?us-ascii?Q?4XEhsQfwy/rugZO8JAjwwhmJq8Ovy8TqALFeobpNlQ3AKotHsc9nQ5VrnTar?=
 =?us-ascii?Q?Dg91iUBH5uMsNtZuE4pR/GkSXDm+NQpL6UipKsVBh3gzhWtKWyktv3lBAHuQ?=
 =?us-ascii?Q?De21jsmQVaQCHv2U7Zrlno+4NmtipW8e/tKxukvTLHG/fssCf6/SC2MiXW8f?=
 =?us-ascii?Q?PlPbJUeg3SHFpGLMz6bd8JOKGwUdzhKFsR4ubE0162R0X37zHMFNqzdeTqek?=
 =?us-ascii?Q?dh610jDi6Nw8suh/9QFwpryfiwBKKopT6A+wuhUT9+WOU9W50wL+oL6H+5mV?=
 =?us-ascii?Q?J0Qn4pC2oLi+HyN7BifKTinW3CVW6ZLO1MQkmvknIEyrzsG7rGwVqFPxmzhk?=
 =?us-ascii?Q?U2degqhqdAPLrM8/1+L2n6tlnap7O+GUGCDhXVKTg/IUJM9zjKp/0Ulym3DQ?=
 =?us-ascii?Q?cXIxd+sfU58q5v/RNXeOVPdRrb+0DO/fi7F57DqIcVe1X3QD8yd/hjNolpDV?=
 =?us-ascii?Q?waPEtrNGx22emI8arxvKNgGRU4ccY1XbD9NAYCJS9InlgwENcI4zX7IHuT4b?=
 =?us-ascii?Q?JjTmyMuV3eetZS2z705S7WCVeU3Xb8zmyCqwlMlfdDKd249ORbTinxQtFlpH?=
 =?us-ascii?Q?L/ejceTiMm8wZWNMuZpcKBtrlIckIA4zTAZ11b6I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 611dd4aa-5e7c-49c0-4ed5-08dd98486a77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 09:18:14.9460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whJKdxMWKrE38e42qdsLOrwuYrGQhkGiZpM72QLK13Omnm8o3SK9qQg7TvA6H9mxpr0uP4Bbu8ZbeoN/EDIMMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 02:35:39PM -0700, Sean Christopherson wrote:
> Use "mask" instead of a dedicated boolean to track whether or not there
> is at least one to-be-reset entry for the current slot+offset.  In the
> body of the loop, mask is zero only on the first iteration, i.e. !mask is
> equivalent to first_round.
> 
> Opportunistically combine the adjacent "if (mask)" statements into a single
> if-statement.
> 
> No functional change intended.
> 
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/dirty_ring.c | 60 +++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 84c75483a089..54734025658a 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -121,7 +121,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  	u64 cur_offset, next_offset;
>  	unsigned long mask = 0;
>  	struct kvm_dirty_gfn *entry;
> -	bool first_round = true;
>  
>  	while (likely((*nr_entries_reset) < INT_MAX)) {
>  		if (signal_pending(current))
> @@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  		ring->reset_index++;
>  		(*nr_entries_reset)++;
>  
> -		/*
> -		 * While the size of each ring is fixed, it's possible for the
> -		 * ring to be constantly re-dirtied/harvested while the reset
> -		 * is in-progress (the hard limit exists only to guard against
> -		 * wrapping the count into negative space).
> -		 */
> -		if (!first_round)
> +		if (mask) {
> +			/*
> +			 * While the size of each ring is fixed, it's possible
> +			 * for the ring to be constantly re-dirtied/harvested
> +			 * while the reset is in-progress (the hard limit exists
> +			 * only to guard against the count becoming negative).
> +			 */
>  			cond_resched();
>  
> -		/*
> -		 * Try to coalesce the reset operations when the guest is
> -		 * scanning pages in the same slot.
> -		 */
> -		if (!first_round && next_slot == cur_slot) {
> -			s64 delta = next_offset - cur_offset;
> +			/*
> +			 * Try to coalesce the reset operations when the guest
> +			 * is scanning pages in the same slot.
> +			 */
> +			if (next_slot == cur_slot) {
> +				s64 delta = next_offset - cur_offset;
>  
> -			if (delta >= 0 && delta < BITS_PER_LONG) {
> -				mask |= 1ull << delta;
> -				continue;
> -			}
> +				if (delta >= 0 && delta < BITS_PER_LONG) {
> +					mask |= 1ull << delta;
> +					continue;
> +				}
>  
> -			/* Backwards visit, careful about overflows!  */
> -			if (delta > -BITS_PER_LONG && delta < 0 &&
> -			    (mask << -delta >> -delta) == mask) {
> -				cur_offset = next_offset;
> -				mask = (mask << -delta) | 1;
> -				continue;
> +				/* Backwards visit, careful about overflows! */
> +				if (delta > -BITS_PER_LONG && delta < 0 &&
> +				(mask << -delta >> -delta) == mask) {
> +					cur_offset = next_offset;
> +					mask = (mask << -delta) | 1;
> +					continue;
> +				}
>  			}
> -		}
>  
> -		/*
> -		 * Reset the slot for all the harvested entries that have been
> -		 * gathered, but not yet fully processed.
> -		 */
> -		if (mask)
> +			/*
> +			 * Reset the slot for all the harvested entries that
> +			 * have been gathered, but not yet fully processed.
> +			 */
>  			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
Nit and feel free to ignore it :)

Would it be better to move the "cond_resched()" to here, i.e., executing it for
at most every 64 entries?

> +		}
>  
>  		/*
>  		 * The current slot was reset or this is the first harvested
> @@ -185,7 +184,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  		cur_slot = next_slot;
>  		cur_offset = next_offset;
>  		mask = 1;
> -		first_round = false;
>  	}
>  
>  	/*
> -- 
> 2.49.0.1112.g889b7c5bd8-goog
> 

