Return-Path: <kvm+bounces-29255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5EE9A5D64
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01A9D1F217CF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946A71E102E;
	Mon, 21 Oct 2024 07:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YPNRyhth"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD261E0DD1
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 07:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729496656; cv=fail; b=nGKxvVSw0AdDRC81P9DaBpZpczsb+YQ/8H44BdUY7wdwiffRo5N8V6l/didF2iQIKFK15zH4OqnbEKFN9cqZ74lQwtC3tNS6oLFJyPiQPMix9K+3OdpulcNTxOZkhsSRIXIGTkl4sRFlTO3lYYWBtoWLXz0gn1vHuy/oMrCwZ4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729496656; c=relaxed/simple;
	bh=bHJdqS4s+mlLQM9mAcB88lFjGcXOFSiRRGowYlL66I4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fVTKZOgSRQ5qksknBAcryzsKcaO1iCTAsu1Z/b9DiNLMWa/j2CDLau475F15Ja5EWqmlxB8JC4ygLpp1Z32m7FtnOA1J6wmL512O4tod9WtJ58hEFCTern5yJEpcHmnDjuLYH2FXEDUNEn0l3i9FwH9as7YBPeKyQCEUU/FwXCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YPNRyhth; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729496655; x=1761032655;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bHJdqS4s+mlLQM9mAcB88lFjGcXOFSiRRGowYlL66I4=;
  b=YPNRyhthBb++Bw8pTvioGK6rJ+an/IOs9XkXoEV7cWOwXh7VvsngxNBH
   RqDUHRGuzR389ZUsCMR0ccegf3gtKDdIc30JeKITG6Qkd0eD0gHKwfc2o
   Xf9MnUgQWadskcD0ppwxLEeqVLvF7+RphFnu/CLG0nQBDhM29DMRmyL7d
   6s5VgXLNgmjyBo/dCkFU5dltdfEDCklyRSexqfzzK2+eMNpP4raMX7q2+
   yorLw7d4h8rPIQruQAUFq73A6UlVQbUJpsow4FDlWjm3o1sZNMlsBzzKE
   eKW/glTCExVPukaDmSdjqisPUp+WximP7zv2WAd9RZNqQup5Ghcv917G/
   g==;
X-CSE-ConnectionGUID: pq1UW+UXQ2eU3EUiLMaxQg==
X-CSE-MsgGUID: O8qyGKCtSZuQUA7ckEA4Dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="40335234"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="40335234"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 00:44:14 -0700
X-CSE-ConnectionGUID: mycUbHk1S8yBzKQtwb5mwA==
X-CSE-MsgGUID: W3qMhmChSiWYZ+sLupvBdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79090833"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 00:44:14 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 00:44:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 00:44:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 00:44:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EuljRNWsO6MytvbT4CfViScMayKCw+znf5UH077bQNtffDi+DVugGsNIo4/4n1e/iKP75qs7Yu5tLb0k2hxJnkSfdhZCjHzxBELjJTZY0YIItVqhossULuEs1ehdUZqAZkAeUVfSzoBdl1kOhRHuUHk/b0LcqVoYY2aONsOAbkJRl2Aw6pxIFTwLD2GS/NR4uRXJIMOqqu4BsambS43JlKYPCXZ9SDdNHmnhF3nzY6SYv6oGTsQyot4iDcRRzB3TV5S8AejMhW5UM4uIEJ0y+uDgAznvhoEEl3xZFSPjS4uPAZohI3J8Fh6JJSIhJsOFByv/zheJB94+ZSDN4hYWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSjryYV5d81cuZgAdv9F6NTSbMK9ZcHaQQU4KLowruk=;
 b=xzx2p/LlqzB1LqXaCTnX3RNUJjtqm4idUMmTtYQLhCXbeY5F+YyrMc2wezDxp5sRMRai+X5hVTOBsIr7xoIZYzQXK5I0b5RslmogKnYBuJOF/WrlpSHwiXBUlQVNHXONpGxLrMw7CEKuu4gQX1xCAfzs0z3iojIjn9iubMoq4slCGQrYiYtbdwxiDOIrN7eUVmnISHxVdIGaGpn3UEmKHvEdWeR0RS2D41SctRnpvCPwUPpNqP0aOBxny0fLG6WjTtPs844AVoT1DOe+hbcVG7NExdRWLnWNEF5yoZsPELXCIS7ItkBSn8PEYKR/Qbgak+ciEfKJLO4QtkKWRNukww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8593.namprd11.prod.outlook.com (2603:10b6:806:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 07:44:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 07:44:02 +0000
Date: Mon, 21 Oct 2024 15:43:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Bernhard Kauer <bk@alpico.io>
CC: <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
Message-ID: <ZxYGOTHnysoz5Q1w@intel.com>
References: <20241018100919.33814-1-bk@alpico.io>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241018100919.33814-1-bk@alpico.io>
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8593:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b36b8d0-7bb6-4b6b-63fd-08dcf1a421de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?j5+FB1g8uauTSrXovJ0z1dy9UbDKXFG9LFsDKvy6+bg1R0JSYohJFpCmDEEt?=
 =?us-ascii?Q?UvwrxynZn5p7nTtce/C1shiLfzMQqcmgr19TJ2csUTU2ChPY6FDTBKD4foLB?=
 =?us-ascii?Q?hTPoiu9UwaML+ZbSgBS192J7Y7ceowq2HklaUV5skgMIVKQ+8RWu1iZnxQAJ?=
 =?us-ascii?Q?/qXRm0bvXLZ4KG8CgauUUcRR9Kt4iXHaUo+mVoQJWovw8FaY4l4PymRi/3Jb?=
 =?us-ascii?Q?IZtetSBMLq4fdpKWA2Yu1jnkliUL0eDKYFRckzHXoSLYaMfFKx6HmeAFezYR?=
 =?us-ascii?Q?MJxvnCxDD2lYyObsWd4q2i5vecURHXGXG8OrbPW8BfnCa5JbCB+LHp+2uIQe?=
 =?us-ascii?Q?Krr5o3+NsYWvb+ifwidmIsEIIUDic/FwnFidlGIxQ0Xxyi586KhaACyooBvG?=
 =?us-ascii?Q?ztMsn1+BU+pLdqPeEXI63dqdzav2HH2VOXXLYY9a+4NNR/Wx26nsqDc3Y1Ri?=
 =?us-ascii?Q?fR1WmS3Ibh3qm5DvU1Hw4Z52j2bwUDrnaZTXnWVXDSg6nPc/Da0wHMWKNI/x?=
 =?us-ascii?Q?Q9XaI7TzN9unZFcnI9++y+zX57BpHsf+Wf8k0bM8yaBPUkPxwdyGZr+AANvL?=
 =?us-ascii?Q?5v7sGJa2J+ulTMWEXrZysLYRDGUXNdZSCkTeOgjvy62jfnlmd0baFqT/7K+6?=
 =?us-ascii?Q?xhSdX6y75g6JIUUfyjIat0rFoRx6cWHIyytQso+Gc0MSFMLuxtk7VZJQyvDP?=
 =?us-ascii?Q?k07UTNwjYrM30ug7RxT0OVzGJj6tz3RvGNyDcYjmCvY2nlN9W0lRwWCQ14Sy?=
 =?us-ascii?Q?w5nriygNFyzyfRpMJ6skoIy/969YA7y+lMPV6sGGecw3b2M4U1Ag3L5I6xrg?=
 =?us-ascii?Q?kP/12mPXGwX+qiPBngWEOFG/Ibl2eq0wFyJrMwK9RRtWvbjdA9maw5dG9T6E?=
 =?us-ascii?Q?Tzct1ixXmpyb13i3WdlmBa/riIdwhFu5PDJvm07yqqQlJENpM1sXyIwDmBRl?=
 =?us-ascii?Q?+1l0/SqkvIUDGoPXM6GYaaMDqW6NOit+/1n/xDY//LvdXQFllyhSnZNJTPxi?=
 =?us-ascii?Q?v6R+sf3lIAA3RGGfh44ucrhEzkI38/xY33lYgBHEaFMxupWhAp2BDxuhCaT2?=
 =?us-ascii?Q?jcT32J1cXu9q2pFLzIpSibNKVNpIOR4M+s5sgRknICC3HnlvhL5YTOg8FY/m?=
 =?us-ascii?Q?9JgklldRXnc7ntQkzXfGgraufABnDnN1fUBWcoFDnjozGHmW8NcWkuqDb8Z6?=
 =?us-ascii?Q?XiSUwKErRiNFBkauXxkFYiW5lpIUDXcsg8Ywtw7SDhWFzVmrxAJ3smOYQBxx?=
 =?us-ascii?Q?OgBzaFvzcfoSSi8s7jlratlj0CaQBBWqyMksCAUX/+XVzn+bIOyUpOf6xqub?=
 =?us-ascii?Q?LRwQGDG0jYw78Y/FdwQ+Kirv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?baZJBAo5otckfiwrGM0+0fxRTut8ugY8+wXldqS8jI56nGR0gaTNEKJrRATs?=
 =?us-ascii?Q?PxwQWiOH3147qURjQdO+/rMzF885F2NfKuaR2WMZH3Ws7DM3E8dE22grZfbK?=
 =?us-ascii?Q?BjIWxrgnHLDgQf/FwVvinCe2NkvOsgRh+wT2WfetJc5E0AJDwpGX7fdlA8pf?=
 =?us-ascii?Q?dFf7T1KQ0lIIFT35pSNJ8liI1ZG1P8OE2Uc0P7wvnkiDJTIm+bH9BzrG8zUn?=
 =?us-ascii?Q?aQNwZuCh2ZB/mBeO2hxIqg5ROkYJ/LGYgOh2tups25a9RgTKwl/jG5kWOm18?=
 =?us-ascii?Q?4gMY8Zd1Brc3e8qFMx9dcv0/6pXw+vGxMsUUS8GGxWSPYmfwaZ3yWudTuqn3?=
 =?us-ascii?Q?ZmBqA0LhtlUe/4216NEXIiRDrLTNSo6idwZ6P3PGcTZQtHVhjIHXQnjnj+Rc?=
 =?us-ascii?Q?Ua3WzHX8WpI8Y1rpslobBPgJYb8SrPr3NNtTcC/OtTrq2ozkQkM31uoP/CYy?=
 =?us-ascii?Q?IBMCD7J/E1ntmCear4akGv0vikbUQrr3PmrxBaN4OCj9jbA5RfCyn/wyLCob?=
 =?us-ascii?Q?D5+jki8U/10EB4Q5Ve/k7wakqVfO5cT1my4ai7DyBCaofydf5GWcLSMrSB1S?=
 =?us-ascii?Q?l/GAdqhFjXwKkQlYIVVr7EyLAv3hKFcE9MZZOJn9HyuL2JbHzhDcLqeRgF9G?=
 =?us-ascii?Q?9lMna+jJloXW4QOOfRnJejAX4CYFgMc/2IWN5YY71bqqcYnSm5NSXKjeJnQB?=
 =?us-ascii?Q?HceZmFf0x4c792xQdgyvRwYnzOZRYN6SQWEC6ofzo99lJNbLSPNXJ4HublIW?=
 =?us-ascii?Q?Vr2edDplsQspqfZW8K+SZRJmS81d8sOWFtgR+aqaeAoA7ygcGK9a2MtWGHAh?=
 =?us-ascii?Q?zBAW0yct8OzXviUKd6/GdiLTAZQQvpBmhQ5xZWYRgNkdnH47Jp1/QmhXov+G?=
 =?us-ascii?Q?yUziNYCL5ynti5PZ5x1SCI4rgG64y/feZHr1hwwEtktyjBfj95bZx2j7g7IA?=
 =?us-ascii?Q?sboo/hbVlwBfrdKZB803Db/WzEyGREMN8YxyOvxuGU0ds7rs4h+AP4HZs8Pa?=
 =?us-ascii?Q?6V4XCpZ2TJ6sYgFzX1Fi3cIL119Q0KQ3JOYjTgaC8wV5BRf74tTc6dg8iAtD?=
 =?us-ascii?Q?lQB3F163G/vRfDG9thFHFEtsxys91YWmCho6L0DqD2mx98PMKRdeGD3Dfo0P?=
 =?us-ascii?Q?ApU/Sxh/+UNVMFx96mi0fQ+eX1t+R6CyOFjb6aBYNNGk732WYwC762R0higC?=
 =?us-ascii?Q?GujnNtW6dCSs0+YUm7zexNUOHG/C5vaChfO8q4QDgMHXujrSpwzVg9ollnWB?=
 =?us-ascii?Q?qpRnCdexuCXyLKGt0maQd1xMOeZICrQOs+D6D1g48XlOzORps14NJNYAbrpM?=
 =?us-ascii?Q?Sf2rs/tW2hctRBliV1ALYRuBRNFS6k5I0HplA2fKe68iGRwk8zGW4Do5MWUi?=
 =?us-ascii?Q?AaFDFxpUbLxrVJvQgKAji4mg1dG0kffvvRc1HQDZTfRbnSBpGIoI1t/RLjw8?=
 =?us-ascii?Q?Uomw2O8RUWqRjSqT5mO58N8y5xzYxhicAQGSApyOnTO0/+qQAXYnMQ9f43pR?=
 =?us-ascii?Q?/enQgb33zpX+UCSE44ufBUlehvy+LayXbao7jrxo7jvI63/yTEPyMUGdVfiF?=
 =?us-ascii?Q?LNc7hk/v1MlG9VOlpY/T93+HEHh99fmnvdJBrVgr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b36b8d0-7bb6-4b6b-63fd-08dcf1a421de
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 07:44:02.6100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6EWoEmpIjoY5QxkwuL1ddgRs+L86oZu7xw9TtbH4Bvf5jpfdOfOR/2JhrTx+7kej9H2JYdzuD3LpBTWnPA2ZKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8593
X-OriginatorOrg: intel.com

The shortlog should be:

KVM: x86: Drop the kvm_has_noapic_vcpu optimization

see https://docs.kernel.org/process/maintainer-kvm-x86.html#shortlog

On Fri, Oct 18, 2024 at 12:08:45PM +0200, Bernhard Kauer wrote:
>It used a static key to avoid loading the lapic pointer from
>the vcpu->arch structure.  However, in the common case the load
>is from a hot cacheline and the CPU should be able to perfectly
>predict it. Thus there is no upside of this premature optimization.
>
>The downside is that code patching including an IPI to all CPUs
>is required whenever the first VM without an lapic is created or
>the last is destroyed.
>
>Signed-off-by: Bernhard Kauer <bk@alpico.io>
>---
> arch/x86/kvm/lapic.c | 4 ----
> arch/x86/kvm/lapic.h | 6 +-----
> arch/x86/kvm/x86.c   | 8 --------
> 3 files changed, 1 insertion(+), 17 deletions(-)
>
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index 2098dc689088..0c75b3cc01f2 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -135,8 +135,6 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
> 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> }
> 
>-__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
>-EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> 
> __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
> __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
>@@ -2518,7 +2516,6 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
> 	struct kvm_lapic *apic = vcpu->arch.apic;
> 
> 	if (!vcpu->arch.apic) {
>-		static_branch_dec(&kvm_has_noapic_vcpu);
> 		return;
> 	}

remove the curly brackets, i.e., just

	if (!vcpu->arch.apic)
		return;

> 
>@@ -2864,7 +2861,6 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
> 	ASSERT(vcpu != NULL);
> 
> 	if (!irqchip_in_kernel(vcpu->kvm)) {
>-		static_branch_inc(&kvm_has_noapic_vcpu);
> 		return 0;
> 	}

ditto

> 
>diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>index 1b8ef9856422..157af18c9fc8 100644
>--- a/arch/x86/kvm/lapic.h
>+++ b/arch/x86/kvm/lapic.h
>@@ -179,13 +179,9 @@ static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
> 	return __kvm_lapic_get_reg(apic->regs, reg_off);
> }
> 
>-DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
>-
> static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
> {
>-	if (static_branch_unlikely(&kvm_has_noapic_vcpu))
>-		return vcpu->arch.apic;
>-	return true;
>+	return vcpu->arch.apic;
> }
> 
> extern struct static_key_false_deferred apic_hw_disabled;
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 83fe0a78146f..ca73cae31f53 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -9828,8 +9828,6 @@ void kvm_x86_vendor_exit(void)
> 	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
> 		clear_hv_tscchange_cb();
> #endif
>-	kvm_lapic_exit();
>-

why is this call removed?

> 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
> 					    CPUFREQ_TRANSITION_NOTIFIER);
>@@ -14015,9 +14013,3 @@ static int __init kvm_x86_init(void)
> 	return 0;
> }
> module_init(kvm_x86_init);
>-
>-static void __exit kvm_x86_exit(void)
>-{
>-	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
>-}
>-module_exit(kvm_x86_exit);
>-- 
>2.45.2
>
>

