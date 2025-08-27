Return-Path: <kvm+bounces-55868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F35B5B37EB3
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D5D73647BB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46311343D62;
	Wed, 27 Aug 2025 09:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hbx33Ydq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7601D7E5B;
	Wed, 27 Aug 2025 09:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286582; cv=fail; b=pyLhmv1l9kEA7aw5Ii9POeR7+B8KVJT+aDOik1Ub3HrmR8AqGmG5ots4hPubzM4h60IojwPH7tlDZuG53tdTGDvaUdWqpYBLdTE3H5QZpnTLH0mvK2pVlaMgY/5mpbCAaCCOP5kmumRxM/3m0uXoyHM+wvDz5xwFN2PN5u4oChQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286582; c=relaxed/simple;
	bh=wTo/W5ZARoUrgyLiexMTUMO5KYQskAB8bVZY7oQL4EA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MfpS/jj+5X5UTeQpx7/JeuQcB0LQGoj4TWemI+FXQDE5EFmJV5FoT0NG3zOMlc1lqMzbZEdtjyN6ybheynOuVGi3X6KbzCI6sI1H4CMfsDUGJwH3P8Lec2C3gsx9lVRiN1vkiHP3YUcmrC+xRhSmFGA+66s4TgW9GJStCmhaXaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hbx33Ydq; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756286580; x=1787822580;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wTo/W5ZARoUrgyLiexMTUMO5KYQskAB8bVZY7oQL4EA=;
  b=hbx33Ydq3IjF/yFaRvun1f4Pw8zrNwVLPeerzI3bVIEf3UpLf/MqTyza
   jYPsY8PwTvey2L2YasLvFG3bnIR5CmubIxZ+Sm5ljrwc08lRM7Two6ITd
   gbbeLiKbYao/g0WUNGzkb/kuTwgKdKm8VQkY+bMTWRnwLvumcmz5agSAx
   N4sLalxgcERgXDCnXfWWV8IFJus53z55+n8+c+f61OYTw59JtY6E9Vqgw
   da3J3aN3sm9ZfSe6ripCnOXjcut2gXIkEsmLcBsPxIZWcwmy53e+gVUH+
   pGyWmon9Jj1EIYb1HGylcynJ0AROR0YBb/SmJ3PTtdP2P5GwCs4sL7yxB
   Q==;
X-CSE-ConnectionGUID: C+klvqAyQNOZY8WrvUDyug==
X-CSE-MsgGUID: g4xopcmgTKmgZRXyW+5ZZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="69973905"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69973905"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:23:00 -0700
X-CSE-ConnectionGUID: wwDarKQ+RH6kA58s2euKcw==
X-CSE-MsgGUID: DMtd9wPnQZ6gE4R1p6Avjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169091417"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:23:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:22:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 02:22:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.58)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:22:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GrLwoYVn7XyzhFBb7ZqNTykUW/qvMcExeI519hUbU83q9vtcY+j9/BiFtZQWHaFxpldA17tMOD/ecoIVq5wfWlEGJo75ymIeFB26YWPgQweTfVwA529AXVjsEGETfBMdIzLHFpLG9QbyYUBR0aSAQtRM6oVJn9pjhPRI/uM87287llId0iArcQB5ehSDD64w5boTkfcSFtNc7akIIcj69k1Ct869Mpjm0XHs0f3a2vicA1C4qRCyCma/PCl/9Klcp3yjcaPdATXlfh4zVrl2Rt8CfOtyep4ufykHMOY9izuDEyxnhSyGpAZ3I2CJhWw8wbpnx16jdLXgxQVdQJcvTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbyKTETzNmiigAU8/pchUcLxivmMebwn9kHq8+3SJnI=;
 b=ZML1A0SDY/YFuL+gVvWXnnEtIwB9svDO3TQNy8Ky2i9OUFlMwhIct4icLlJalw6GQuPi1O5rNOJ5ydqGl6wi18MPAkGeNCnBhTMu9D9qoBuomTMHT2pTnF6tJ112xF4ihIpipGZlj5QoeURo1Fij+DYCiN8Tf1s1163l610fhXT+JxtMHMqNhTRhzx1MB6uEKbVMHmOSoPmr+G+g1pjk6vJ+lWooLaiPZnsnjAfOlpcu90GN+pU8Ges4nzKlChrCAFP6VZ+AY1m+BT4NP9KCgKTOT/LDycM2XY+HDCFbBwcF2zMoDra+iul2+Ss8g1GN9pABQadT1EFlCSlffItp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB9277.namprd11.prod.outlook.com (2603:10b6:208:55d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Wed, 27 Aug
 2025 09:22:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 09:22:50 +0000
Date: Wed, 27 Aug 2025 17:22:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 12/12] KVM: TDX: Rename nr_premapped to
 nr_pending_tdh_mem_page_adds
Message-ID: <aK7OOiZ8er7QpXJ5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-13-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-13-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0041.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB9277:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fb8380f-d2b4-455d-b07a-08dde54b4b77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?duz9et1xR8NL+RxveDpz37J7sVS5QO7ejnHq2muH3bnB9VTVbrkcQZhgvbZT?=
 =?us-ascii?Q?nicXQ5jwLFX+xJaifTXtTyYcNN388bmNEJpgXTOj3kwvq19jcw5g0QRw9n7K?=
 =?us-ascii?Q?fRQ2tbrOvOs29FFMJPfx8LFXNgCMASSNp2dN+/admBHGzoW8oTdcktV2bFCu?=
 =?us-ascii?Q?oddJ66jSsBHODvXeOCjAnTsvHJrtqa/XDWop6prmkg0D3rYCA2FjuMvl4oxb?=
 =?us-ascii?Q?UXBeek8PhtnwC8VnG5/qoHr49gNBVGdc7Cmfj784i+NJZyI8yL1a2UfTABav?=
 =?us-ascii?Q?ErRh6ttDd7JhDrGRmMMDtpZ3bHFnlHgrhnM9RNTwQ5tD/4/cKZIplv/SklLl?=
 =?us-ascii?Q?kXDT21hL6XlNE9vbtbIu5Gg9yMg8FOTWaZtKLhpk3t12BbJUsPqDIw/GN3vZ?=
 =?us-ascii?Q?mXXHNHvwZwlhsP27QleztFEgWN56yuGE7vOwHdcK3cbpB49LIM8wQgpBXLvn?=
 =?us-ascii?Q?Z21Pq28DBFZSkN5xJfpNzDsLq0oZRPMTfdsq5jVx5fsrgDIgcmJjKYnaLq2V?=
 =?us-ascii?Q?GwLYdVu/8IPvYgntUOH+3goL5PuhyudXgTKI3AXxEBxAQ2j5aO1pnHCTSWuZ?=
 =?us-ascii?Q?v+65KNTYUJndnA2YRz1pTetDt5/Q+Xl9GAeOXqAgB0/PlLQEWF5+R9bVqOP4?=
 =?us-ascii?Q?giPxNGje+UAvfzU5NxAFv4LVNwhm6bIPaupSGFKHFN5Qg2ho6KOVsRuBZJns?=
 =?us-ascii?Q?8+nAwtj2qctm6OKvnH35Qjx3a+r1uBrypM8cH73wcelBFE/NQYhQ/V1rQcpl?=
 =?us-ascii?Q?mR916CNzCAazLPV0n7iVzCmaIHtCEn/1+w+hJODvc3cAW6olT/d85ApXzUU+?=
 =?us-ascii?Q?IDZls7Sso42TL4R44qkS+yza6A6BlkxCQh572dwTZ1CWWhRMj8YntW1ZOqXo?=
 =?us-ascii?Q?nbF1Rb96vGjCTMXn9YCg31sCc25/Cqbd/RgO+l9fqRGjFIuUowssy4omuqDC?=
 =?us-ascii?Q?0RRLkFu2sqPA4oJYUcGjlCKISZZfjlu5abRnOmtLZXo+db9YSYK9XfN3xDTe?=
 =?us-ascii?Q?tdcIrirlEzksbFg96NTtiO7l8eoerrTmvCHuu4FNN5TlLWt5PyrUl+RGOfZm?=
 =?us-ascii?Q?oPmHTPaNcgOlMFxCR+6SsiNu/ON3L0tZ3mIiv7PCAkZ6YpgEz4jXNGW5GUgZ?=
 =?us-ascii?Q?7/X91IBDRSt62/PJawrXIEX/JAE1OWspNeljNEQmDXoiof5UdQd/lUP5FtyN?=
 =?us-ascii?Q?JehJLB8ggFX6jD93x9cuAnqvbhkWbqE61oMLPs5tzD0tVeuh+qlU8XMaq7vy?=
 =?us-ascii?Q?VDlnzAqRhpJsqaDINLDf27noYfyWUqT2pTKLmUL0/+Y59rT0WZHcn7k6Ao6T?=
 =?us-ascii?Q?fGrkcgZefjMW5orYysnPJEWC0La1573IXvCCfiOYmS6TjjegFenZ8VRJ1Dgk?=
 =?us-ascii?Q?PaE7wdWyUDo1z9ky1IZ2LngyA5lY+tQ5JKijkFxGP7ORcJ4lvfwr8nz2aD8e?=
 =?us-ascii?Q?56xvD3PAJIU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EQDIOd425exjJxpqpzYPpqeESvcs/Rcbhqt2XGgLSzTdHtcC1o86B9i3R4jc?=
 =?us-ascii?Q?kTxEqWJZTSG1+QkWWitOjfMQ/fBHX9aTyELdFKThb1IpkL/mfV4tPDw/Bocx?=
 =?us-ascii?Q?zgb9LC4y5rnaOK0z0nieZcb6r2ru8e5alGY36EpMZ7AuhIu8o5a6cqHbZrQB?=
 =?us-ascii?Q?CBqLmd/SLVqITngJZGEkQVTdqyHYtaFYdAeSuoQCgDzQUn+6vNXUUYVOzGsz?=
 =?us-ascii?Q?twM1oB2CJiubrFGWqBPcafRgsLUB6aduO3u12c2UklBOm84u8fHPguVu4Lze?=
 =?us-ascii?Q?dMh3iP4b1EyMxCH0+e7oFdU/2xX6XCOTzCN41Z9E6ojHkcfpCJ3tlfEKGfPp?=
 =?us-ascii?Q?K4mY8NfeVGxzDqUOQvu6tbZmGptkCpkRBHP1cDe1bqasKqj+Ih14IhZOvN6K?=
 =?us-ascii?Q?WmewMsVs8m74AMoqle91DgOJqxuJpZ9marwvB1KTX269sSkL+3PxO6aWQhCx?=
 =?us-ascii?Q?UTKbRw1McJFPwqMZzR3QkxWvVsXjYbRsmwSZeqMs9yEZ+9ezVhPgqS6EA7h5?=
 =?us-ascii?Q?BjYa/kMhE5H+b0EuMnmVquu6mvihmmMMVQ1X+hi5kqaW9G9eJnGsGuuH6J62?=
 =?us-ascii?Q?8JqWguAfPiIHNwaAb6dWbge3TDp/szzJu5LVI9N+KDmxLml6niEoVN+7VlE+?=
 =?us-ascii?Q?AUwRXz1HQfCQ35UvBE92iwhLySoxwXxL3kdf2HhSTegfcQY0jllYwf+B9ffs?=
 =?us-ascii?Q?U+uH5JeOrRV+ivFTrCpEzyb5HypNqKQ9ro9A7YVuFI1PfFf2YFeO22snUZAD?=
 =?us-ascii?Q?TmByuYS3hdLXy5YeIeJx+DLLnGqdlC8S80ew7W4ZDQVQWcIHPeY7MgTgj4aQ?=
 =?us-ascii?Q?7OZcQPsO8DRERywMdCpK88Kv/p+9Ap7KIGyX1MYBrSYV2MrfmnXOQiny8Nll?=
 =?us-ascii?Q?1CNgpBReq8/zvHM/4b9OQ1wToa7RuIdOsQusOBjyD4u1Iq+bSAM2T1CFCmN0?=
 =?us-ascii?Q?N/t8IzL+JBEVmp+Ewk4eiroXtsHkzJbFCjuu7X6bq6FKe1frbpgdQ6jGwpRN?=
 =?us-ascii?Q?yMlJTmvwgIZhoALuHmFBK4K85Yrq5bhEWLAF0gqB0bGut78x1LAntXAKCLH6?=
 =?us-ascii?Q?hK6vINnxfz5B/8APRDjpxxE47kwq6xLnUvSDzVS6TuNsrQpbFVx9Neec656o?=
 =?us-ascii?Q?IR6TXgICBuBCeETnM9tYltyA2lEqkckfTbJY+YEq9o7qmoAVqyyx68avSTwr?=
 =?us-ascii?Q?mwLbVl1Otazx1tN7GpmuSfP5BsEtiU3AyMakAfMeZCe+INA/nvOK+0yJYUMv?=
 =?us-ascii?Q?GliSlYB3AIW9KzNmnlJYN16NQZqzEEf0ea3X4codkrOuvYtwUyYje4EvxVyI?=
 =?us-ascii?Q?Kbw+OR9KLrjH0rq1qKj1R/NrY9xOfbrSWmX5yovUdCsYpqtEpuiST+CNmLbe?=
 =?us-ascii?Q?ufVK13EyiOVJWu2Tweb3SZxXeG4YbxoS1OFT2I0YwEaQMDwNAOIgm4ojJDAd?=
 =?us-ascii?Q?j/mBOuejsjjHScS/D9dP9rK0SIw5I5cR8mIwl0gNAUn8+W3hHk37NLDjCFCZ?=
 =?us-ascii?Q?qAr/Quu7HSEgDZY9Akreumt67BVKA72PdUg6NBv3bxi2yPaoqBiMKMvAysE5?=
 =?us-ascii?Q?xkK5nbRHeGNjNuV3m/pkDlERYa1hf+a+YcCz+wFu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb8380f-d2b4-455d-b07a-08dde54b4b77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 09:22:50.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IrceHS8j9If33+dzHa8/CBos3NRU86WbhwVFefOgGFJLK/EQs9WrM6wSk6uKzi64XnAeKZhI6dwULJ+Z5/DGVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9277
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:22PM -0700, Sean Christopherson wrote:
> Rename "nr_premapped" to an asurdly verbose "nr_pending_tdh_mem_page_adds"
> to make it explicitly clear what the counter tracks.  "pre-map" is far
> too similar to "pre-fault", especially since tdx_sept_set_private_spte()
> deals with both "pre_fault_allowed" and the counter.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 8 ++++----
>  arch/x86/kvm/vmx/tdx.h | 9 +++++++--
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5d2bb27f22da..f9ac590e8ff0 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1639,7 +1639,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
>  			return -EIO;
>  
> -		kvm_tdx->nr_premapped++;
> +		kvm_tdx->nr_pending_tdh_mem_page_adds++;
>  		return 0;
>  	}
>  
> @@ -1771,7 +1771,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
>  		lockdep_assert_held(&kvm->slots_lock);
>  
> -		if (KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm))
> +		if (KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm))
>  			return -EIO;
>  
>  		return 0;
> @@ -2846,7 +2846,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
>  	 * TDH.MEM.PAGE.ADD().
>  	 */
> -	if (kvm_tdx->nr_premapped)
> +	if (kvm_tdx->nr_pending_tdh_mem_page_adds)
>  		return -EINVAL;
>  
>  	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
> @@ -3160,7 +3160,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  		goto out;
>  	}
>  
> -	KVM_BUG_ON(--kvm_tdx->nr_premapped < 0, kvm);
> +	KVM_BUG_ON(--kvm_tdx->nr_pending_tdh_mem_page_adds < 0, kvm);
>  
>  	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
>  		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 04ba9ea3e0ba..45d86f9fa41c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -36,8 +36,13 @@ struct kvm_tdx {
>  
>  	struct tdx_td td;
>  
> -	/* For KVM_TDX_INIT_MEM_REGION. */
> -	unsigned long nr_premapped;
> +	/*
> +	 * The number of pages that KVM_TDX_INIT_MEM_REGION has mapped into the
> +	 * S-EPT, but not yet initialized via TDH.MEM.PAGE_ADD.  Used to sanity
> +	 * check adding pages to the image, and to ensure that all pages have
> +	 * been initialized before finalizing the TD.
> +	 */
To ensure the consistency between mirror EPT and S-EPT? (as in
https://lore.kernel.org/all/aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com).

tdx_td_finalize() holds slots_lock, so it can't run in-between a
KVM_TDX_INIT_MEM_REGION.

> +	unsigned long nr_pending_tdh_mem_page_adds;
>  
>  	/*
>  	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

