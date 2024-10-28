Return-Path: <kvm+bounces-29817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B04659B25D4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:35:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D35361C211A4
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B211F18FDAB;
	Mon, 28 Oct 2024 06:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h0ftmd1P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4971218F2C5;
	Mon, 28 Oct 2024 06:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097251; cv=fail; b=g0HyW7NzirD+2y+bJwIovb4wOcVAXI7ozUP+Ou9dsK1yLfRx2cKkSCg9KqAdGUbJev5cfthk8wEj+l/tdSE5JDH8y0NWRCwpbQ1Ep4O1iMKgVe1JfLf5V2Xgr2D+v03E5lgoFbbfYqymtJmy3qr/u0Y/+vmFsTtjziXGo9lK1s8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097251; c=relaxed/simple;
	bh=vQwtg69sef9NTtTk5AiQKD/lkH8GLp8A2MyWfrttqm0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oRM/cSxedEOGo6OLLX1ilbvrdnSxl5KbMasDmrGKtP/j2SH7f23onHzqMM87RppEoMy8KA0oLjpuncYL/d5fcj18/o7nhXsXEvTZp5Ya1Tct0qeNi0iWbk5+d6zrIFumxheD3DFuIFxE5qJk71PHsrXHxyD+n7GcNj4U6Mw8edU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h0ftmd1P; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730097249; x=1761633249;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vQwtg69sef9NTtTk5AiQKD/lkH8GLp8A2MyWfrttqm0=;
  b=h0ftmd1PeEuDog015LY++CRNCOv9vrO5hbcv+GUjWKThf808bQ8gufRM
   eMMwiJdD6X6Raj03rpbyeEDTRv25NJebs9rlSVWQmgyTk7VzBwlkUQMNQ
   SWv+EvY0f6hIbH7fiveaK4Q5ZPXY9mF+1zOkUNr4mNsQQ4MK35GFSemZp
   jdzUGU6V1xNLn0AjWOl3hiFAJIBI4sL87b13wS1BjlrmVHpKzDzq678wt
   mmB1RZyNK8hJYP9WhIU+QqaMG2hLrwONEw0U023Vgsf5o8HsjdchNdQsY
   iRozzKDkk4xRHnv8ZZLkopd8GjhJ0Ok9eiJ/iCS4o/4KPOMlVWOiG2uOV
   Q==;
X-CSE-ConnectionGUID: 1+wPJil/Q5a1/b30y832Xg==
X-CSE-MsgGUID: fZYLl/hZSBm/SfWS1ZdJOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="55090544"
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="55090544"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 23:34:08 -0700
X-CSE-ConnectionGUID: 43eIzBNFSja5uG6REL/UgA==
X-CSE-MsgGUID: bSNOcADsSze3GvuMGHvKSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="86663166"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Oct 2024 23:34:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 27 Oct 2024 23:34:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 27 Oct 2024 23:34:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 27 Oct 2024 23:34:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMp/oK9ga5Fs+ZmQJHN3frC8UmQOYYJlR/Vl4R++P4dGS4sN51cEINMwiiiSzWNSuvplpFwuyXssalVk9vOKpOx/spom7PVXivC95ZKBmD7h69sAPKuesliOC+xC4Zu4jk0rKkeXxdOUL0PnoHZCLTJEl6UyffBtDoWPnzlobyhAKFAD5CViihc+//rnRAIlAPYiNkqKE1jJYaSR70ImOfaIFJGL9yWzbi4GRAhUZrn3icJx1kF3qjFeNiXRKVbMBK3j8oVTwJs4CA/ChFdGCk71LtyU/v78fTie00eSqbQHGiVDNRRUxAYdmUwJmmhB0yqNMMmdCX26R88uD2sa2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSOhUJ6RSOdIS9I8v4jrzb9uTEpJatRcZFSr4ARkugQ=;
 b=K2mqLRGb0etQc7cpaI8Am8e8eONpv8H6xey79tDnbZyLe8+zG++Bqc6d04bOjVg8dRf14bjNJr/Uv0OrJHhVIOTMMj5FTKX/vRsQm1wf0JrDexV5K3A5Vx7BkIb/t0Unv2KONEM1yhxVDQn+f/6jH9SAkv+amyx7EcJueFKaAYbuZFLyot+cOrfNHa5tHvagV0UCRD8MDA3MTW4eQ9+vnbwi2Z40bOqFUkFko7oNhcjGMARZv1zJvruzSVLubFyfmbIGuweyXhLZVnEasJJFGKfJPEHwwyhHr79gmnFZGAzx8sp21Z+/i9U6l+N5pfptrBfHxkpqweAjCzj+Dt21gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5956.namprd11.prod.outlook.com (2603:10b6:208:387::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Mon, 28 Oct
 2024 06:33:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.023; Mon, 28 Oct 2024
 06:33:59 +0000
Date: Mon, 28 Oct 2024 14:33:47 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 16/27] KVM: VMX: Virtualize FRED nested exception
 tracking
Message-ID: <Zx8wS/wAI99yLmPh@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-17-xin@zytor.com>
 <ZxnoE6ltLawgPHdZ@intel.com>
 <5ded5ea5-6a31-47ef-ae12-f32615ada248@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5ded5ea5-6a31-47ef-ae12-f32615ada248@zytor.com>
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5956:EE_
X-MS-Office365-Filtering-Correlation-Id: d11f6a91-61b0-43dd-df8b-08dcf71a8191
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QJAscqDITNu6whrEBrxgFV6YFRQr7yJHpWbgofvVTz6TnR+mD5mvd5cX/xOV?=
 =?us-ascii?Q?KnmUAvQ6v8bvVipxS1P+DHiG6SZ6WuSi5n1ZuqhQOF6g0cKt8UEy1WrV7w8j?=
 =?us-ascii?Q?eoNhJ/emv9UiylSbP3kT4zr0FONcAIgXW6rcHk8zJcGJ0/F0wLpQfEHq59Kr?=
 =?us-ascii?Q?R0mc+6YqP516NpBR0MYtV3huvxbTKDdamEUonRUdu5jXUl+4GCzLHfCAJMu3?=
 =?us-ascii?Q?rzvMYbZ60+P2oP/pDGfxXJxo6EJRxqUg9ZYQ5n+BetX8F9xh0udtSb+H/uzV?=
 =?us-ascii?Q?QYgEe7wOHsnUKesuRihbw+eEuVY4SPLhyEpNaX97jVO+brptK9mPlZhf+oXb?=
 =?us-ascii?Q?Lnyy1Z3CcYwd4i2qVjvIFF/8NrIQAqa05g2Oo+7SuPv0iL8l9FZ1dHF60xnj?=
 =?us-ascii?Q?ELMZg8Ok3GFsxfNoxS/J+3jnPNBAKs8qbaBeiTmNAo5ITMqsoZ5oiZvJKFQJ?=
 =?us-ascii?Q?B5HmcBrCph9ySBYWWYMvyJTMKIzKkvZ6ChpyIAl9zXud8n4tYFHoT83F7VGy?=
 =?us-ascii?Q?9CwGdV7eMCgDXLbW6H0rdv6ZJ6xNTltxmkn7arI0Af7uOqXd+II2Qx9eMek9?=
 =?us-ascii?Q?/EYVQR6pYZz3oWKycochSFMDGAit6dTYfeqOkkTxGH4pHWsX4tJD8QKKfeTf?=
 =?us-ascii?Q?GeEeX7jlT0xRRYLaDTgDIiQGCUOIZgJKM2BVkAij5cnrLml5+Vk67BHZ6JLN?=
 =?us-ascii?Q?UZVAWRlTrzUslVXgprGY8MrxaOiLpxl/rMrT5UgukiOZW1xlg+MR+Dl3ckx+?=
 =?us-ascii?Q?mghUt2UbjHDqHGRgh5n22kpzfeCCq6do1mwbVsnFoyZ3XMvrursmZ45A/zpb?=
 =?us-ascii?Q?3qLEKn5bH9YPTWbBuef8HZhXjmyNL9hADY6TRXYdc9mi4d9kfyWAPcx0B4xi?=
 =?us-ascii?Q?JqKDNVqvkD1K2SrrEooRNDLxi4KWAGVBYqpjSDIwrdDJAzQfvB9Au0IrCLeH?=
 =?us-ascii?Q?0Txmyly4/EoNdxRg5qkwS9hQZ/qy4wWzRmy1Lj4Lk473VlBRP6cze4WRQitc?=
 =?us-ascii?Q?zE3uCe0hgP+4A5/IFmnYl+FRPJRJhqTu96kPX75AvKmAHJFaWKkkWpB+nu7+?=
 =?us-ascii?Q?p/TzwMk9elehDmp+zjZ5gWX0+3Jsp8EDl/SjP+uWUuR5JxvSPchXimTMUCUr?=
 =?us-ascii?Q?WdJlm7BaJ0/jc1Yi4Frgn8rBbSsac4HHmYYlEo3NFsQ/5TlxYWGM4S2bQE4R?=
 =?us-ascii?Q?LDastaCB16GxEDnHKvzv8LhIQ1bxIXHIRtOvjeY+J6feGY99g61PEf18tijc?=
 =?us-ascii?Q?g8VydzAY14mE5kiLMf+znhu6FkznOQeDnTI0Vpfcrc0T61NNfIpom7Zcf0l+?=
 =?us-ascii?Q?i+SQFuz33qzFGAV9FTpECQTP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p9LKMKAHICHFUh2mjJTzhrpyHSidfMjchSJfbZSsrhtOlkLzNV9XTthzgLWK?=
 =?us-ascii?Q?BFMW8kh0/khoKETxkRtV09yUaUSD83IPMYpemasv/4LbGpf/xsssXkn1Y0N+?=
 =?us-ascii?Q?SzHmzSFjGfbWzRMgXvD1qOWZLmNkXv4yjYyM0e3K5ClM/8Xxvd+9ofhqvGa9?=
 =?us-ascii?Q?uM/MuBk5zelrUQ3fMTXZQIpTpADWBHjHVrF0aV0u/IMIaO3Wtm8zNDZrRYXE?=
 =?us-ascii?Q?mK8hEbVuAFg8bMgrVkfx19j+9AbJY/EBoEcvIm1UUWRhE0kGRgikcyi5d3DW?=
 =?us-ascii?Q?O2XGGKH9kKWHFUkCjyuXXdSmUPLesGgbE2Vu5Dhr45POGsM3qeH+sav23ldn?=
 =?us-ascii?Q?Mijftu2rzIdB1naQkGjRZ/Z8wqNufQULEtHLmLTYMXF3Cpm7cBuiR8CX3o81?=
 =?us-ascii?Q?BbmX6Q7syFH+0DwlDeHj8gdvgXCU1qDt8VCb+EYgtCfH9mTQvHokzpOxn9mC?=
 =?us-ascii?Q?XYyHjlrE96rRc+4rIl1++J512Pq2QpG6p/THZ6LaT+XZ4EbtNIjVa7r560A1?=
 =?us-ascii?Q?rv3oS42A+t1Pr1D8ly7jF4oBoz9FVphzkklHr7qwbep2t+gtjoZmP90BARzV?=
 =?us-ascii?Q?HlzYE7GE4ncRCYXRSGIqUXOah8m5aUq2nHG0/+ASbCLB7XxDU5y2II67xvNs?=
 =?us-ascii?Q?AjHitZUz1+golrB3xAQJb/YmmHABuu40NrhcWI9mI/d6Kq+1MNQ9Llw7DUj3?=
 =?us-ascii?Q?vKfgYHKcouVufsIiFBBeMu1ykbWYuyPM/biE3W8X6J7K1ut8Dv86q1FZEliQ?=
 =?us-ascii?Q?HuKaUFN+b1+VlE4IcAM816VK8bzGdcV46ajKAr0z7rQ9rmnXV9ftwtJUXAt6?=
 =?us-ascii?Q?t9haJsVT5pSUgWw9cByF6dXBcOIkz3+YyzhIeBvnXwa6O8DOrVZAgPL/D+P9?=
 =?us-ascii?Q?R5zipJob9NOeDLwGvkIIFPNzhAZWYYhqilM2vzpapakA3jXw4gtaIhGTyxa4?=
 =?us-ascii?Q?XCTt0EoMZcb9k602T2zOL09H1gUDTstFeI95Q9X+ZEh1G3glJfb385EKRpGa?=
 =?us-ascii?Q?NZl6EM/H2LL5vsY2SLHE32L0N1ojL7vG4H+9Z+xx+/tnrZRXMSHQLv8rVEZ8?=
 =?us-ascii?Q?tCPFDGY9kNjHMRuhgHs4dpRpVnkOKi8QYuV0pmnhQRc76ZTxItfMrxhGEeYk?=
 =?us-ascii?Q?Cx5gFLmwhkSc4bH9yFbHNZsvBFmuJ+mW5NiwBVQe8rEA0EtX5cHvixtlvP3V?=
 =?us-ascii?Q?MAEJur7bX6AucmjIWxVgR64qK7zXE19n3zTFFg4HvqUfjbW6hxoX2E+jfGuN?=
 =?us-ascii?Q?5jDOmXW5sUI3gTqvgPXN8Er2VbfPBiJKQAXXg/EemPT3XUqC2EH77lhfmu8S?=
 =?us-ascii?Q?JPLOhGiUBk5jFoV1mzu7M9FsmADen06c7kSW3ddK5TnatR+0xP+Xu9pDU03K?=
 =?us-ascii?Q?xd95xI0JDuqE0fYlwReET92kQxCIUtj48QSzwS4bwC/lSNQOtJ+HULFCgALy?=
 =?us-ascii?Q?EmTs8sHNwmpTvp0fsZpaiyW6VYY7TNwMSQ2u4MJ8D0z2H1USAyFARbypCPKg?=
 =?us-ascii?Q?9sAd3c42N0T/tl0jFxsCFtWzzowpli2xpGrdnRoEpyak1/w6L7e81HIO0fKo?=
 =?us-ascii?Q?1NN/Fwo4nGFxwxcJUXdinMJasF73je67InCIFluL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d11f6a91-61b0-43dd-df8b-08dcf71a8191
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 06:33:59.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWA9Ood0maWNh6gHq8D+8uwhTPsDz5uKKGsDkalGbZXnuiXNDuSZy3XvX8oxhcoMpdKnMg+FwYeyGax+V0wHsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5956
X-OriginatorOrg: intel.com

>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index d81144bd648f..03f42b218554 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -1910,8 +1910,11 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
>> > 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
>> > 			     vmx->vcpu.arch.event_exit_inst_len);
>> > 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
>> > -	} else
>> > +	} else {
>> > 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
>> > +		if (ex->nested)
>> > +			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
>> 
>> how about moving the is_fred_enable() check from kvm_multiple_exception() to here? i.e.,
>> 
>> 		if (ex->nested && is_fred_enabled(vcpu))
>> 			intr_info |= INTR_INFO_NESTED_EXCEPTION_MASK;
>> 
>> It is slightly clearer because FRED details don't bleed into kvm_multiple_exception().
>
>But FRED is all about events, including exception/interrupt/trap/...
>
>logically VMX nested exception only works when FRED is enabled, see how it is
>set at 2 places in kvm_multiple_exception().

"VMX nested exception only works ..." is what I referred to as "FRED details"

I believe there are several reasons to decouple the "nested exception" concept
from FRED:

1. Readers new to FRED can understand kvm_multiple_exception() without needing
   to know FRED details. Readers just need to know nested exceptions are
   exceptions encountered during delivering another event (exception/NMI/interrupts).

2. Developing KVM's generic "nested exception" concept can support other vendors.
   "nested" becomes a property of an exception. only how nested exceptions are
   reported to guests is specific to vendors (i.e., VMX/SVM).

3. This series handles ex->event_data in a similar approach: set it regardless
   of FRED enablement and let VMX/SVM code decide to consume or ignore it.

