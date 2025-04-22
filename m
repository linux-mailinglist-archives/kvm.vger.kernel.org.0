Return-Path: <kvm+bounces-43750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86610A95EFB
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C6C318998DE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9475B23BF8F;
	Tue, 22 Apr 2025 07:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cevMaMAF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594DA22AE49;
	Tue, 22 Apr 2025 07:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745305643; cv=fail; b=uzwFDTw7du7nmz51/WYLvXMTOHOjK/Y8HSM10MRvN66yopMSOZKylP6XDK4f7QX0/XX3xFBHLQ5xrlf1QIP7si75Lb5Owgdm6HHCyisMpTS27HzlvkSsb4Rx3HLFP1vcM1pTGTHcdeirMcvKQKG6+MrXom9sA6jaFHbxDO5dI+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745305643; c=relaxed/simple;
	bh=x+H+mqMX5COvRLcDlGxj1XaZhA20h/A7cJHgQMzLI1I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ttRvhoa6IPqVoJ65ljr9dnOHRCvwxWnS588KoHE1nMkaWC0f4oNsQPPUJiq9c6xSRHlHagZ2LXjSiDREsU+YhpHSi7DNVoNg6AAblFnRtnO7KqfJalkDSWtcYjW660pIacSIMDR5daXRCF3b+PE5H9KPd1YDr1q3Cvkp8QIDTNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cevMaMAF; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745305642; x=1776841642;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=x+H+mqMX5COvRLcDlGxj1XaZhA20h/A7cJHgQMzLI1I=;
  b=cevMaMAFvbQqC5sgJ5jruGPm4MjijJw9CmGu3O1Lsj8MKc+Cm5ifZrfW
   yNyo0FIJo2rRXGaMePHIjSwL8W2lriBnDez87gsjAxnViLrKsEel0XfJk
   APGTgHQGHm0lcrIXnitstD57mhpVC8A7PSxjBPNU/j56KQUhlrjyHHEOk
   ehLKzTiZTbJmjb9dT9PI3eMMU4cKNYruQro6zyGXW3dP4nZAPcwk6RIi8
   1ajY6l23FZV7nFZhjNBg3nKYd7/D9efUUObVtO0uXS003pTpqIyN3rkDg
   GOJ5UagFVFTQJ0J5IPOG9rpv/2J154vs9v589IVHztG+NxpWvHEUhT/Hv
   Q==;
X-CSE-ConnectionGUID: +MTGX2D+QCeaIprb0YYxPA==
X-CSE-MsgGUID: SikEqGn0R2CL3SqhSWtNfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="49513579"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="49513579"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 00:07:20 -0700
X-CSE-ConnectionGUID: OfGKSsG3Rrqe6Hr0z9Thyg==
X-CSE-MsgGUID: cbKCCWYzQpW6KOkdeQ2qSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="137088436"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 00:07:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 00:07:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 00:07:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 00:07:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kRJ+GafMl+OQ1l329egu0pjTTQbHGNHFivE1Bo963bErRqS+dcnzuSFjQq9FvxIgTr45CdjD1EqoBiluYqN/XHX03+vKJZeR2FZfmvzJ6mWn8NhZNVuxcjptgUt5rk+aFWWBjcaa9wV6OE4E2AYbksepV5cc7JHAgUl8jaFIANWJfEzbcHtxHgv689LcgnOvGIybSnXDSUBsEeMVxMljq7pW7gygNTw6SaXJy+wK0TqTF9ACLUnokqJS6E9QKV7jjRaO/M9DZawnMvgeS5YPMXRHciPMcdE3f1U2bki0K0ROHYuIeh6+576bia4ofFRi+Z1jX5GghE4+FZAwEgxT/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFtThbmje2VpyKFouOIUEGI9xRydutTN+XTCOyuDaXU=;
 b=RjQWx25vif2hB6p87P6mUIRJcl7YIfCWhfyYE/sZHVDtni9z/CDdLtH6D/BnY0Jy92owiXldLuUxhYipFdm+0+xDiJdO2NSud1zUbYsK5RYAwAj5axCqIhRhmJDyqvzg7doSEiDYY+fScICfJfvPlLKpDDOFKjjxCZI0d8vKP8QXZT8pNUCb/9a33QA9u/W5ZZ4tlRMAl1Dv/4bJPD5vUwW3oIG/lt2xKVF6Z45nXLZ5n61OtcuAWVoOGVcvif8e7UzhUwo8Vd/G+n9wc5P3fxpBtv31KRwbzdYq1o1k8taKiT4gcAWRYzmMPg9EMTWfTYExI3bkEm2fskJDPMCHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5124.namprd11.prod.outlook.com (2603:10b6:303:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 07:06:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 07:06:16 +0000
Date: Tue, 22 Apr 2025 15:06:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Message-ID: <aAc/3p2GyZNmYFUc@intel.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-7-jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313203702.575156-7-jon@nutanix.com>
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ac0c438-5e1f-413c-33e4-08dd816c2c77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uNhftRw4pPm/sELTN/2+g4aG+DnB6iOhu21FPXNsWfSlAvDNpeE3uQ2wc1Tx?=
 =?us-ascii?Q?pCiJ8yoL/rpTo2Oq9aL/c30458gJER+HJMUw+xAVX4+Aa4txbMk6UnCT/CTA?=
 =?us-ascii?Q?+v1usZi0MrBm8nrwIrXFu3ShMztPKUF4YKkOtpQF64DdTsNQCAWg0Ml+skov?=
 =?us-ascii?Q?o7lxIgvOzdCl0RnVivQfaITZFSW265NaZOIvmzMhe4jW8/p5B2d2ZlEjyGkb?=
 =?us-ascii?Q?qkZ0Mi4X6SLNo+o4pM6/hRvGdwjsB++N79gDkOnwS1urKvuRMCcHnPml4s6U?=
 =?us-ascii?Q?7Nz48O6T4Mrq6H9xKQzWJjZIORhmolU8ydQImtkZ6XYsw3rvBmlAyhguTuCW?=
 =?us-ascii?Q?SsS4BoKexPRUy4S050v8xrg5fAofuSpBAvqJhdAHv69VYO5xSVzk9IYhU67n?=
 =?us-ascii?Q?zx4riU43hbrfYptdgaXZwmGaGJqjX3cVRB+81iuBzHT5r3YPa/8PwL//msyy?=
 =?us-ascii?Q?mlqb4IDw2e1Fp3FSdKBSfdvjN5IRAsEA+ScMKLHok6OMkfIE3RUIUv88IBEW?=
 =?us-ascii?Q?N1kjWwRfNfUonr6XB3Hx8l1TdCKsUwpjhetUnH38VcbhGeg2Q3Vk0InfGZpG?=
 =?us-ascii?Q?q0sQl+w0/cE7F3JeoQAeUmuwnD5M8oSymNPb+2c5XqrShVapHH+9TaZmTMXn?=
 =?us-ascii?Q?VXG4ZjiW6TiRJ/j8nXYFMxmTRer8D3CMjnk/JTdO6I8tQX5p9+6Hsplfatkc?=
 =?us-ascii?Q?WKe4Uvr8EItkU/cnviBkOcIqgLQMocs3EK8yjKwlLBb83WRtZpPCfyNEcZHg?=
 =?us-ascii?Q?nxQrA6UnW1QC6R8h7pKTco0AoevYEv6oNBnbxc2WtPmtpp9ZT5f3XYazSGNT?=
 =?us-ascii?Q?54avA1jOWOBB/vXeXeoTNBlzQzcqwEwZ+V/ORV0o7C/3lk/6N6XQVOE1khVk?=
 =?us-ascii?Q?2NknkcQdVnsmtbUmegIPmCgvTvUtOjlZbllgCqtCX6oBY65KkEmfxLYIxHVl?=
 =?us-ascii?Q?mSBmUq38eS87DpGAcxZZbQu9Svxj1rViTw0TXdva51YNFyKKy96Bfeu8WxMv?=
 =?us-ascii?Q?emXP4UftfJrYopqYukwCO5N5PumVKKY4JfGw7B+EaHoKW7vnXYYQvnsNTBQf?=
 =?us-ascii?Q?o7xFiYLODV6KQ/7W3wUYPGzMzQboCQ1TArSwHhJYUg4/u8I6kAvMg9x9547z?=
 =?us-ascii?Q?W2X5H1zS9OQJTv94oPLc9SnCtxIm0IRgu55K1Xm78B2uh9jIRIVH7Iu7mSU8?=
 =?us-ascii?Q?Jmd83o3xE4dNP7CQWQo4dMzOtjFpdyhSkssTUPBbR0oaJFeNUQiaWL9QMg8p?=
 =?us-ascii?Q?PVyJinIi6PhkgMvQiKVAgPjqs30WmlYTRLI0qhDI+8A0YwChIjj5n/2JiAaj?=
 =?us-ascii?Q?ZrYNatwUfDW2nq7DnzenHf61yUVvN/hRKVlZrjek1laqXfLktWoAJTjl46GE?=
 =?us-ascii?Q?vDcMF0Vhs8RU8xDDHr60/wcQje9OuKtGmWBy1NzbuHLtz9Al0RuQVHdN4uQY?=
 =?us-ascii?Q?dl4OzS7/pgk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J4thpisg3nNs0lAuBgN+FU3jNKY7ka7lALCiwkI3T0ok8BWS20GQSYkgYQwc?=
 =?us-ascii?Q?JV5k1VgM9r8q/mWsYDT/vwHvvkjoKt1O5PZg7abhxHUeChjJ5FXAbZE0rW1T?=
 =?us-ascii?Q?9RRx2gmB91/Levgw+ytbGIWgj8ERmlttLCmFWWi9zjpbyDzp9nBkMQg873GJ?=
 =?us-ascii?Q?GfscZNB5ZqZG55oX9aB9Aw0xDHSM93ZV8ZWPeiiXROnVBgwUuaYGg+3NAImI?=
 =?us-ascii?Q?iVyh33Nq637haXJ5qBE6FKUAGCXL8xom5kvfshAgx9htjDiv9/cyf10Jnlg2?=
 =?us-ascii?Q?S1v8XnbEWRyt42X1vq6ybBzxgDd9p1Pjq1zo6PBKlwlxYzk/g2y9tzbpA1x8?=
 =?us-ascii?Q?3CaikV7NkH8vqvZi8K0WLh4qWwj5OBNkbrin2hFwN2LXB1oUCEvQqLh/sPVv?=
 =?us-ascii?Q?a01lYQ8YaZMzLs/UptFZhsfQN71cM/VrWM4B1NgTujZOgVpPuWTSMaYPBUyB?=
 =?us-ascii?Q?/24BJhpe6I+C7Nmf8F0nN0rMNBnD/SgMK2N/E/DsiZl3GK8tlq3QRPSqcljx?=
 =?us-ascii?Q?8hF0qbNJ/+msuKWL9qyUM9OzRKxdikc+6SqmfP1Q/j99ojitXjY+DAiPl1Rw?=
 =?us-ascii?Q?l0mLNUXstQ4ejJHay4qj0V8YI2JxkTDFX77U7RHW1DQCC9gNnXa6te0f5ZMa?=
 =?us-ascii?Q?xU21AoTq58K5hJCmU4KC8ez5hXuhWMWFJQuav0QXD2nj9Hqo6a6ktCUFifQD?=
 =?us-ascii?Q?5t9vrtopP5oZG2VQ2ezj2RJ3f0csxaJLsvUrutuxMr7qtvpV9brJRdqdlhiK?=
 =?us-ascii?Q?ToYsID5nVSsVRT8YwUS5gYV8tQbtb7Cv3UqpTSUeU2JqHuqHUS6sQPi+Tn+n?=
 =?us-ascii?Q?M9h7FPs9sI4GGVoZOF/dIbMjyOY74vEfXs30QsYs+7oZkc7NBmf7X4/osIDm?=
 =?us-ascii?Q?gj8JqLG2by0aWB45xOQXJFyP+qoEMCaKt1kdCql/NTDFvIP8c9xvB3vP6feP?=
 =?us-ascii?Q?aH+KUZCMo9sUvLzGofWCXOhwiT13Y5XEkxZVYk0N4ldoFOftJzksfm4GgWIK?=
 =?us-ascii?Q?NdWxduxlbK8JqxJ41CpstMwFeDt915i+4CBY0yUvFn1HuSRM6kXy/Kte2Cw8?=
 =?us-ascii?Q?gHp67N+2xoRMvZu5F1dN1M2zvuHGVvbUcx1NBRJVRKVIomC9LhwXn1i599ae?=
 =?us-ascii?Q?fBsFueKgi6bRrm3cR75u96ghQFSWrVFpqSxtRK7/Q9wc+/9dWCkIeWaW9jL8?=
 =?us-ascii?Q?SIFHLfs86HhjvojK2EFjz9msIZSZq1jI3wePpMrLZKny0NL1P7sSHqSzlHsE?=
 =?us-ascii?Q?AJj3QJ3Grem0GQ5Hy2erRDT9NJ+vLBtdlrTlJBiphedGrgNO4q4T4EUzqNoC?=
 =?us-ascii?Q?Yzm9P5u9qDwFVGQxNc9X2QcZpIi98E3mzkYAU0L4AmeWIibj9VhyQwRyWMZp?=
 =?us-ascii?Q?8Ig8cH8V1wpE1ftavjqoAqe6+GH1Dia3oKglvHgbunw6rgDxN5a/SjOXW4jm?=
 =?us-ascii?Q?AaQ+d/C0SM1847m3wqcEKsvBy4nP4YCzKGR/fDzLaTq42JGvWD/yCID5YYkP?=
 =?us-ascii?Q?WSnFIKM5Z2lUVNLLS3rLDZCgp91V5/2zQ6zrWtfJ8WVSCoQq5czcMx0QRsCO?=
 =?us-ascii?Q?Ls+vn7nC/e3bGij2HIJj7lKOdUnseiuhM7eAbVWe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac0c438-5e1f-413c-33e4-08dd816c2c77
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 07:06:16.0705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkHwCjbZ5BsTj57WbAPseYngIG4IZV95TusUTPVrRPo88BGOGmwAxNRlOsAwB7ZAkkDYY+c944ao9wcbBa14aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5124
X-OriginatorOrg: intel.com

On Thu, Mar 13, 2025 at 01:36:45PM -0700, Jon Kohler wrote:
>Add logic to enable / disable Intel Mode Based Execution Control (MBEC)
>based on specific conditions.
>
>MBEC depends on:
>- User space exposing secondary execution control bit 22

The code below doesn't check this.

>- Extended Page Tables (EPT)
>- The KVM module parameter `enable_pt_guest_exec_control`
>
>If any of these conditions are not met, MBEC will be disabled
>accordingly.
>
>Store runtime enablement within `kvm_vcpu_arch.pt_guest_exec_control`.
>
>Signed-off-by: Jon Kohler <jon@nutanix.com>
>
>---
> arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
> arch/x86/kvm/vmx/vmx.h |  7 +++++++
> 2 files changed, 18 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 7a98f03ef146..116910159a3f 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2694,6 +2694,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> 			return -EIO;
> 
> 		vmx_cap->ept = 0;
>+		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
> 		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
> 	}
> 	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_VPID) &&
>@@ -4641,11 +4642,15 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
> 		exec_control &= ~SECONDARY_EXEC_ENABLE_VPID;
> 	if (!enable_ept) {
> 		exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
>+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
> 		exec_control &= ~SECONDARY_EXEC_EPT_VIOLATION_VE;
> 		enable_unrestricted_guest = 0;
> 	}
> 	if (!enable_unrestricted_guest)
> 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
>+	if (!enable_pt_guest_exec_control)
>+		exec_control &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
>+
> 	if (kvm_pause_in_guest(vmx->vcpu.kvm))
> 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
> 	if (!kvm_vcpu_apicv_active(vcpu))
>@@ -4770,6 +4775,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
> 		if (vmx->ve_info)
> 			vmcs_write64(VE_INFORMATION_ADDRESS,
> 				     __pa(vmx->ve_info));
>+
>+		vmx->vcpu.arch.pt_guest_exec_control =
>+			enable_pt_guest_exec_control && vmx_has_mbec(vmx);

Is it possible for vmx->vcpu.arch.pt_guest_exec_control and
enable_pt_guest_exec_control to differ?

To me, the answer is no. So, why not use enable_pt_guest_exec_control
directly?

> 	}
> 
> 	if (cpu_has_tertiary_exec_ctrls())
>@@ -8472,6 +8480,9 @@ __init int vmx_hardware_setup(void)
> 	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
> 		enable_unrestricted_guest = 0;
> 
>+	if (!cpu_has_vmx_mbec() || !enable_ept)
>+		enable_pt_guest_exec_control = false;
>+
> 	if (!cpu_has_vmx_flexpriority())
> 		flexpriority_enabled = 0;
> 
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index d1e537bf50ea..9f4ae3139a90 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -580,6 +580,7 @@ static inline u8 vmx_get_rvi(void)
> 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
> 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
> 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
>+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
> 	 SECONDARY_EXEC_ENCLS_EXITING |					\
> 	 SECONDARY_EXEC_EPT_VIOLATION_VE)
> 
>@@ -721,6 +722,12 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
> 		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> }
> 
>+static inline bool vmx_has_mbec(struct vcpu_vmx *vmx)
>+{
>+	return secondary_exec_controls_get(vmx) &
>+		SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
>+}
>+
> static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
> {
> 	if (!enable_ept)
>-- 
>2.43.0
>

