Return-Path: <kvm+bounces-18843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAFA8FC1C4
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 04:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 849422833CB
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 02:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6A660B96;
	Wed,  5 Jun 2024 02:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ezJdoewQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6958A17C79
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 02:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554227; cv=fail; b=VPc+C9oDEbafK0HVfWIHg4EqhzoguAUbZHxsTjM51C89lot6CkWPzbTrUjxAwWmCPJCVlAs7m9wwUaN92UTQRXv23fqA7EQ3n0oF53UorNx4nl17uqyGnNubaOc6gZhG9Ei7LHLpMT6EdZXGSomYkq9xrhwz/P+vobWag/brKnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554227; c=relaxed/simple;
	bh=4OE9DElxjp8P27J1kwBnDZyjdPnYDjem4xHeg1xx4M0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hxfoXSbzPvlBQPiUSmn+nUq02ulxi5/swAEs1T9ZvOX+mv/Dyo+yUk/eWoGUUdkRCTWp3JqKdM0h7yEjrUenoBACO0hanZKLnEbKRTlexYt6BTrQtzd4L18BITKfF96ZlfuHsT7Rce3XAY9oIeiMs7Hw6YYHBUIozJHnt11BlZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ezJdoewQ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717554225; x=1749090225;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4OE9DElxjp8P27J1kwBnDZyjdPnYDjem4xHeg1xx4M0=;
  b=ezJdoewQbRXJG9vynOkMlEbo9mx6WMV1XugpOebY0ywyfyrtHgSZ0E3H
   b7GefN9gu+mo34PKxcDDKtr+avnGzDM00KMNmqKYm5u4KueIBjw+x2Qlv
   NMdCAauXHIlvam7F7voCShKVbs5aw+RFU9Ckwangu+4eaDNXrxpWkM9Io
   Z6YSAbz7yIAp/tEDmFXPk6MKzoB0vPj+vDqHBfiHeIVxVTG+QI2Cugj/n
   pLQs/VFyp2b80Yt962pmGPIyIQSy4ptY1JJ9qMnM0+a/RKV1SMYfddQ56
   8vXUP3KybzYu+29caxrztWfhrAdAUgkOYiTJYmxSkyRzw/xSeZGP6hUr9
   Q==;
X-CSE-ConnectionGUID: coGsGksRSpK7U0CBBH4VNw==
X-CSE-MsgGUID: vysE/NBjSP6ZosL18BZVng==
X-IronPort-AV: E=McAfee;i="6600,9927,11093"; a="14321687"
X-IronPort-AV: E=Sophos;i="6.08,215,1712646000"; 
   d="scan'208";a="14321687"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 19:23:41 -0700
X-CSE-ConnectionGUID: D5lhu95mTxi+yul9OHLerw==
X-CSE-MsgGUID: Z5NK+lIwQViEoH50CSwZfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,215,1712646000"; 
   d="scan'208";a="60622148"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jun 2024 19:23:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 19:23:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 19:23:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 19:23:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnaanatmeaxk0xmsEGyWsr0Yg9mxRj7c3XNea+hd0l/wfMzOaCUYDpGYAMNfExjNb4s9sHrHl1+73coe414Xxn2QG5ZfsRDfLvqBLyTS662X49LWYIx+uu1ZD6lmeFWgslEevhc6yxyOvkNRYUcT4cGk2ljNPIcMDIx79zfDeWdQk9BQ2vl97QkufguRA2hOLDoBeqfRFJMlaPWr5sPtY/4UYwOowb3/XJNRn8FjdmBeoN0RkTT4P4+WdX1vNmBpEFdgyfJZndDp2ptU9eI/HH/uo2oP7oNZwZ/HcwNgLD+BNVCKdKNlH1dsQ3UGh74JS5dg1C2XMemS3cWF6UkRRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+d/Q7i5O/5/ecUtUMbaqZY603S66o+dvjwaBO5zqxE=;
 b=O7VjnhQQYVVbFElT+10eKP8gdySiGNzgqKh2uB1F9Lw/Jv9QMW7mfEadYOfU7QOekU5C60krf2BMwJsZFM6Y7cD+0jUPZqDXdcNbhPYksPrJAi3jL0jOLx6tuGpHI8tHvYBJSY/l7fT+pqEFo+fjYhjkfOsycGWb1LhniKczQkR/cwxyO/VGWtNSXynvxS9xAOyw/yPlIVIoYnq1PeULayVkJiu1SFeBeJq/K/cKR9HyT9c85wTZYDBliFRchhjI+L23KWpKXr3WvM1lcqIwwlpdrnCUJI6Ttr9mn7oELSofFo6dn0askhrKubSAImX9i4fyM9qQVbKferRw6AGaeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CYYPR11MB8407.namprd11.prod.outlook.com (2603:10b6:930:c1::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.31; Wed, 5 Jun 2024 02:23:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 02:23:33 +0000
Date: Wed, 5 Jun 2024 10:22:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <Zl/L7F5ltKJBBZG/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
 <20240530045236.1005864-3-alex.williamson@redhat.com>
 <ZlpgJ6aO+4xCF1+b@yzhao56-desk.sh.intel.com>
 <20240531231815.60f243fd.alex.williamson@redhat.com>
 <Zl6XdUkt/zMMGOLF@yzhao56-desk.sh.intel.com>
 <20240604080728.3a25941e.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240604080728.3a25941e.alex.williamson@redhat.com>
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CYYPR11MB8407:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef17b67-388b-468b-454f-08dc85067f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OejonK3yRFxXyuE7anxMa+ZsO3pQWGO9uyto1nH628cge4/Hol/9KqsgGPBS?=
 =?us-ascii?Q?HNldOKZAPRAjKXqgYJ4LWSel7NGFayq+U1XCLhKf3JykBDI02+gYQmwr9Qql?=
 =?us-ascii?Q?n8gEsfxyUvAGTdTrNzlLoQhtiAaxLGzaO7IN3uTK7LqaqPpqSHan00oFVZMT?=
 =?us-ascii?Q?bDm+MgFYyPbOLnW/ICJ7/M+ET6i3oByrbFJlhSxSm5ALk3Z27RDG0De9wdmL?=
 =?us-ascii?Q?1WRWrtj45g3URbZSveymjqoi5rlcZNKNvVT7otoT1aJm/A9ywCZ4JwuYw9qL?=
 =?us-ascii?Q?5rzG8SUMtqWbnRsQuxFxG4vXG4QCvmLGkeOpQHX7D0HA59wUTEYNp4uX5qfN?=
 =?us-ascii?Q?fMjzBdtiOu8Gcdwm3ZB2sfRExPtGnwGsNr/aNCnIJtLFDxFY6AhGVSqNP37F?=
 =?us-ascii?Q?WH7vScnCCCeLDSsJGToTebgOoREL+2cC08RAjHmyMCea82O5vn2vxqeUyKip?=
 =?us-ascii?Q?EQ70WyWBG0CJi3QiehZQampVXLXcSz41nrFVQfwjFB4/vBPuNRlZbu6j0yGZ?=
 =?us-ascii?Q?wcDuSLbFD+hTYVeh3GhHVHxdpF1rf0y0rj4rLGM6U0MRcLrwtlyoZ8Ja/Jai?=
 =?us-ascii?Q?+Z0qkIWmQhWlQE9pveW1q2iPgJWTiPDZuDTIQOyVgPnfcJKFiWzpaGzC5cC1?=
 =?us-ascii?Q?hO8QI495KvI2drXS0TuHQZHx6wYeOnhJOk0dkZ5mzQo3uPB/p8y8JbJfoWsM?=
 =?us-ascii?Q?ulQVhuzu2vuCk1wR8vsf3sloDWivAT3eLZSj0Evf5Qqm41X0YvtyRzwCQXDG?=
 =?us-ascii?Q?UdibZJiDACR6NdLgRs5C9vyn1chJ1USQ48ebLBvCRO3/MT0JzjoNIjgUmMU6?=
 =?us-ascii?Q?Pd90Gws6RIoo7VksotRZ87uQh30lzVuICeaMghRoL/ZhhDlfQ8Rry/p4F4+C?=
 =?us-ascii?Q?NeoJpcAbYMZJA/m+/B0KMei1V5M++U39QnDljO4oEJEBklqgOu22cFTqtG4E?=
 =?us-ascii?Q?JZ3quHh/kFAfP/wJFpwbws5rKPi9IgXeypfboOmU1BbyI0WOELb1bBAjOW8s?=
 =?us-ascii?Q?QZsqRlqxWeZ/EP4usUcLLznTX0zbt1oQL7CviqfO+MGgGyeOySymO9xgu4AA?=
 =?us-ascii?Q?1nKihN3HUMViTNxGvQskLn2C+RIXKkgb2CFOGwDDmjxlhfYl9So39ffI6MLh?=
 =?us-ascii?Q?ekRpGTgTt2mHEXh+n6THKKxISDX2QvoO92AHARn31EUzY72ZytW8/5PYOHCO?=
 =?us-ascii?Q?XPLMRQh9dv6lBPmHalvtdFP4+7Qkqnr+roMZsILxBEnq9P8OOz6SJMUTgjdK?=
 =?us-ascii?Q?dAbes9JDmhd4+AVa725pkD5ijKtfbtjL83bnAb6nPA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+aF9Lbqb//9K3SCF0NblohHqXRKEOi+rAKPlddIsMYUARr23+cuAT5KI2Vtx?=
 =?us-ascii?Q?q/DVcKN/euLI0E7JehcRQK1NStGES6yVI7ul15C5zB9ONLFGmJ5tpnzaRIUl?=
 =?us-ascii?Q?RTMzuJ+9Dsh2RW4dqFxqyv+q/L0NK2C8Sh9bzVNIy8mZwJpIFY1k4VTvmWaa?=
 =?us-ascii?Q?9vGs5lpimjm8rHey2ltHdKz8xicitfx/3ABC+UuRlhQLxkOPzNe3MC6/7DVa?=
 =?us-ascii?Q?AsLJdhYh2LzXAScYbV8TIk7zGmrjLHMtsVP9FrNW/KGDYLZuTTYciEJQ2OPG?=
 =?us-ascii?Q?hBka/DBDATHvZ6ANzPB5lpGLOF3OvCGHh9ZlPtc1MAI1UIH1Z3YuKc9qa23d?=
 =?us-ascii?Q?BNNN7r7djyqVR+sH/MEUMYyFtccio3UXVc3Z/xhuTdNCRtxlBIFDE9Rx/m67?=
 =?us-ascii?Q?PAVe1+ixrzHsRyO7PpDrnyEl/DqzughppqQ62wSILA1m75j65hoCONT8KhMH?=
 =?us-ascii?Q?rkUzxGu8PkOT+w7oakQKk5FOpIsNiGgZqQ8F4QfxvR9+/jDM0tiZD4ByqUww?=
 =?us-ascii?Q?aAvkwQrc7mpz6w/q46tmKmXQTjJpmciO1JVkdd2zxiA98/LiHmmLua7nLuP7?=
 =?us-ascii?Q?T8ORNmQ/5gc60/hYYumiVZPuoN/ssQAx1qpycxHfZN6inRM1GjgZEqMCcR9l?=
 =?us-ascii?Q?F6yyxsDsb5x0Y210yOaLkTD8exjboNu5Z0t3/Cb//Sy4uFu8l2AFZsG9oCYC?=
 =?us-ascii?Q?DlMYVNokbl2AoflESV1dd7WtfXgYSlavjsbJB5X+hxDGJreP735mdIWqUxCu?=
 =?us-ascii?Q?tUlIHfgm++/Fr4BWnUjRMQ0WcvhmI2OGPQQjxCaiLadH0rlZ1pnXb+PQWC4v?=
 =?us-ascii?Q?wqXSyZ9usoC/rK4skuazdlZRk0LrgVDxbqH0NMt1VbcNXZx8eZmBCqD6HCvY?=
 =?us-ascii?Q?OCjdbIZzKNDqB2orWYrnXsDtDHxeyCnuUuY6E0kQ1xUzcHkICgpUEGRq10D9?=
 =?us-ascii?Q?QTiYPSvxfdfs3BZnrj7gTsM2w2Xe8iaSuBx/sl1op2FJRzOrLSYQH5wiF20m?=
 =?us-ascii?Q?zaCYyGFtReKOCFzYsf7OjWfEYkWauMhT/Z6kX3TMAozlPn8HPXtx6lKzn0Bh?=
 =?us-ascii?Q?aWybPUmuzM1ZHAmW+Uxg1qpWHPmewSWMhgfoktBKgtv9a1ASslumK1ck40l+?=
 =?us-ascii?Q?G2CTFAOWkjz8DBNZPr9E48YwZaWfwmig+olOIQfnLc7sxr8HKOunEY+3HKHp?=
 =?us-ascii?Q?mepNprOvOqqUI4u1F4NLAXOYn3By3P5kU4Xhg/Xrxp00eroVTx3KkCtMa6Z1?=
 =?us-ascii?Q?wAKCQFqt9OluTpoo/RWNh3dOHrZdRT1tExzVeeMBF43HMqLHlH3QHLfoerKo?=
 =?us-ascii?Q?trPD3To0I6dTVcZG5BCSmWGmoRMkuG+XyyYzNlhIMoneMDXo30exGc/h7mqp?=
 =?us-ascii?Q?n30jcJsG3cG25cEKnmZo5ZiH91BHxO4NYWJQsO0rXVZAJVTLL9oWpCP2IsyW?=
 =?us-ascii?Q?YxNSevH+IqWJkuX1qN0jddHMj2ZgLfNFpuaB2tuXs8hx8SkFe3Yq7hRoszIc?=
 =?us-ascii?Q?S8L2m6MV3xF9w9I2YmpK8am0VkPJO0jvMy6yxkkCp9yVmcgkvR+XcfvwL0Cc?=
 =?us-ascii?Q?BJtoLy/kzA7z5i0KR09OrnEYQ1d0McDja57SdGwb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef17b67-388b-468b-454f-08dc85067f04
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 02:23:33.0186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bRtUGusS+UW/pR0LtL83rxbAynm9ChMZcCjj7PSHsXUGIxAHMdpRH16Alwlh/U3jU7U6l9blpMLiSmzEQ1eqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8407
X-OriginatorOrg: intel.com

On Tue, Jun 04, 2024 at 08:07:28AM -0600, Alex Williamson wrote:
> On Tue, 4 Jun 2024 12:26:29 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Fri, May 31, 2024 at 11:18:15PM -0600, Alex Williamson wrote:
> > > On Sat, 1 Jun 2024 07:41:27 +0800
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Wed, May 29, 2024 at 10:52:31PM -0600, Alex Williamson wrote:  
> > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > ordering necessary to manually zap each related vma.
> > > > > 
> > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > corresponding to BAR mappings.
> > > > > 
> > > > > This also converts our mmap fault handler to use vmf_insert_pfn()
> > > > > because we no longer have a vma_list to avoid the concurrency problem
> > > > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > > > huge_fault handler to avoid the additional faulting overhead, but
> > > > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > > > >    
> > > > Do we also consider looped vmf_insert_pfn() in mmap fault handler? e.g.
> > > > for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE) {
> > > > 	offset = (i - vma->vm_start) >> PAGE_SHIFT;
> > > > 	ret = vmf_insert_pfn(vma, i, base_pfn + offset);
> > > > 	if (ret != VM_FAULT_NOPAGE) {
> > > > 		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
> > > > 		goto up_out;
> > > > 	}
> > > > }  
> > >  
> > What about the prefault version? e.g.
> > 
> >         ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
> > +       if (ret & VM_FAULT_ERROR)
> > +               goto out_disabled;
> > +
> > +       /* prefault */
> > +       for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE, pfn++) {
> > +               if (i == vmf->address)
> > +                       continue;
> > +
> > +               /* Don't return error on prefault */
> > +               if (vmf_insert_pfn(vma, i, pfn) & VM_FAULT_ERROR)
> > +                       break;
> > +       }
> > +
> >  out_disabled:
> >         up_read(&vdev->memory_lock);
> > 
> > 
> > > We can have concurrent faults, so doing this means that we need to
> > > continue to maintain a locked list of vmas that have faulted to avoid  
> > But looks vfio_pci_zap_bars() always zap full PCI BAR ranges for vmas in
> > core_vdev->inode->i_mapping.
> > So, it doesn't matter whether a vma is fully mapped or partly mapped?
> 
> Yes, but without locking concurrent faults would all be re-inserting
> the pfns concurrently from the fault handler.
insert_pfn() holds a ptl lock with get_locked_pte() and it will return
VM_FAULT_NOPAGE directly without re-inserting if !pte_none() is found,
right?

> 
> > > duplicate insertions and all the nasty lock gymnastics that go along
> > > with it.  I'd rather we just support huge_fault.  Thanks,  
> > huge_fault is better. But before that, is this prefault one good?
> > 
> 
> It seems like this would still be subject to the race that Jason noted
> here[1], ie. call_mmap() occurs before vma_link_file(), therefore we
> need to exclusively rely on fault to populate the vma or we risk a race
> with unmap_mapping_range().  Thanks,
> 
Thanks. But the proposed prefault way is also in the fault handler,
which is after the vma_link_file().
Similar implementations can be found at 
drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c.

> 
> 
> [1]https://lore.kernel.org/all/20240522183046.GG20229@nvidia.com/
> 

