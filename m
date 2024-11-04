Return-Path: <kvm+bounces-30435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 717C19BAB05
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 03:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 087681F21288
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 02:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F46716DEB3;
	Mon,  4 Nov 2024 02:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nc+rK/xR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703E3F9FB;
	Mon,  4 Nov 2024 02:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730688453; cv=fail; b=A6P7SJUZLW/ghqBpTYBGbzT1dI2zNg+9S1fcYDB4ptG+8QpWeHQQh7TYINEuEW4Pc+jYPEMVrnQS3EM63jTpV9ktKA36eOF6+/+O70Nxj2W+npMzZE3CRCyxco1VQ4ldKvXQywyBkrkiRYgVBWNAze31Aj7rYdDZWVNJep4AUB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730688453; c=relaxed/simple;
	bh=HiJp1NcP40TrHi/As89RWTpIr8f30N79hVE600QFYQs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bHE/cMmf6aLq+/TJ2GJkqJMIjz5jmbPKYQVktMP0QIJf5R0uiS3o4siQTS4caSN63ZHgmaYk5u0unX9A/V9n+6ru3x7rsGdc5R9naCeUHzl2jk7j8GbQyXjT3/Wy2Dxi7sBABAs5Xc/CTkmaoLINNPoxxsJsRfOCtT/ET7WqmS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nc+rK/xR; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730688451; x=1762224451;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HiJp1NcP40TrHi/As89RWTpIr8f30N79hVE600QFYQs=;
  b=nc+rK/xRVUxxp20kkTHfYIfqT76kKpviqZ84psm1KzJQQq0M7XizeuD5
   6jf2ScJRSuxXnKQ1mPXaKUU/ifUDfs2DIUIyAZ1Ct1Buc/veOPjQ6F9ts
   9yq1bo75ZfVkcGHnzziCMH+xzb96ohJq7RMGasaiCF9gmLTgqYMpMiV9s
   x9VYxYI5MXm6q4uS3mzbMrYX2e0IB571ln9PpWaeywN9qOnDa4wUuDIih
   iYMa6/sWXWzTIVNXxO5his0qXqJoL32Ob6ewobF30LV90Cvj/uWYdh5LD
   KGpv4L1nWEtGD2bjnn0+vo0uM3svox62HgBkuZJmib3xB0vQWwfQr9Zr/
   A==;
X-CSE-ConnectionGUID: kjWOXi3UQ16VnSva5Zglyw==
X-CSE-MsgGUID: Z1TXHE/hSyOLu+WRKdgrig==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="17990005"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="17990005"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 18:47:31 -0800
X-CSE-ConnectionGUID: 9/R7FUNLRnWFipxtWz8Ciw==
X-CSE-MsgGUID: LF+iPDnWSVSgKI0Q4yOAgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83651320"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2024 18:47:30 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 3 Nov 2024 18:47:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 3 Nov 2024 18:47:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 3 Nov 2024 18:47:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T8f7EAPYd/Jt3e/M36tfiU+hZWxyAlft2W4JUkdtpv2wncwVSqHiQv5r1acjp6QAATYMdsJNj8WZa6QF611j3VIvrpOOOrFnOzCrE1x+oYMOMnTqMyTOZ0s6gThHg/eV7VZGH7eUAy1nENk92to+Hm6o+CGalWgWoMz4/8FGNDlaXQkxChsFtc46JQQQpjk9CrAi++5nxBd/hJaUFKDroDnFMPahso2I7GHWyxiuwsUTeaTAoAMM8yrlhLLFuNydQcL9u+6p4Frq0gQpOgigtb+0UFTmlTuVMy3ubdM88Hm2jtv4nSP5WfwbZuD5fLg/PyVKs0gs1oq1KBBh+7fx8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3H3zbJivLqXcrIyjnZt+2GDuJwfSDHZ/od5YofW7lw=;
 b=Q41bXB5AJK9h9GMcBJiiUuxzpMpMOIUDT8O6xCQRBYYPbznoqKyhYFSYIrd04N/g++1hHMEYhY5tc4U4y9072mlIqfI9899y10/l0054tsCveDgIMrEMIVrcKHdSnZs0nfMgtOGEOaI0i7L4ZIldtwU99BHmKrpTSTfnLngCPQSddhfTDpZp+dUjsFvWOf3YSeFaRD8W7E+b9zufQyLtpWY35es8mlH0AFoIwOk47F8JHrbJ2o43t0/FVt00txcwjx2abk97kbk0FKS+y3ZDC3PQXIMMJYeJOKlYtUwoOmFlMPg/ZWOK8Nqr/UBhR+u9rVMUwfC92sjI/d4MzqFFQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4941.namprd11.prod.outlook.com (2603:10b6:a03:2d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 02:47:27 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 02:47:27 +0000
Date: Mon, 4 Nov 2024 10:47:18 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Treat vpid01 as current if L2 is active, but
 with VPID disabled
Message-ID: <Zyg1tkDxNR6N16Ga@intel.com>
References: <20241031202011.1580522-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241031202011.1580522-1-seanjc@google.com>
X-ClientProxiedBy: SG3P274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::35)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4941:EE_
X-MS-Office365-Filtering-Correlation-Id: fd909a03-9ef3-435b-56ad-08dcfc7b04a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QQFkWHkiNXAcrNvhD5EPk+gP/Q4kYU5/bneOZYNWgkTin1jca0ADQjoATgTb?=
 =?us-ascii?Q?qErrZTUxPAaJM0TGfyZmmHQPaxJDsqt+ZfiaLJnGQ2EVwgpTigR61UFoNpnZ?=
 =?us-ascii?Q?3TKYc0XobaWVS5ZbA3s6o90ivtWWidQMtcBBDej+9x4LDQqesnGd4FMRCPQR?=
 =?us-ascii?Q?wrsm0f+mlytLtz7o4PRSNvNoP262yQaaU6LJPDd79uUMSYQdnD6Kj7X82WUm?=
 =?us-ascii?Q?VppA4Twn3S+nvFi3U8fCOXpo2NqL4vV9Wm4nUgsJAmpPpQYPR+vA29C5wmla?=
 =?us-ascii?Q?AXy3R+WVlYg+70ECH1JLBaTqXQQU+nGb0fbZi8uG8fVKeMtTfN8NEm8gkPdL?=
 =?us-ascii?Q?b6udQNAIzxyTuvto5tW4/xoUL1XkbfQUvamF10IvfmUtYmn+lZEkbKYH32+5?=
 =?us-ascii?Q?k/1xbnJH1gEmgf1QwwAr1VhlV/6u72fACLfQueijrfCM0R9mW/rppSpujY4d?=
 =?us-ascii?Q?BOvHPAwiQvetKgVruypZhbnrVSTS5y8lCrrorSQpkI3fWehQRcpxF+tHPoZb?=
 =?us-ascii?Q?KB1vVbQCFjuN8HjVh4uz6g239Hnu99bkFwyh/f1KOVwSlyJlfSVOHGzfZZpT?=
 =?us-ascii?Q?aaHxiglblJGQ1FTNoSUWVUTtELEGr5qzsfnpJOq9UExB5LapmktxBi8cThSO?=
 =?us-ascii?Q?PYPETyplnD6n5m1h7/yLpXdEQ0Dh9iSKmwb/K0IOp7wupPHmfG7jSVOYkWL8?=
 =?us-ascii?Q?c2AUO8I1t+nXU8ZR9z6PjW6C5idwDOa3317NqCDi87BABURBVP7f6pgjeuYv?=
 =?us-ascii?Q?UqPmRT92oZt7ll9vcOujYSfji0h4eduTcajuziJ+aoJ5xJyOKmAm5p0Y3pPM?=
 =?us-ascii?Q?n247/B/IY4ys0/mKc2TTqHQtgYKnWRnl7/kyyeC/52t0FRB7ELzwU0jMYnPe?=
 =?us-ascii?Q?GLzIi8o6FunAtj6/9W5cv4HfGssgq9I72FcOP7OGeYGtudUT0GuO0B3peMi+?=
 =?us-ascii?Q?Cnn56egaFOb7Ez6SKUxDFhve+vhPpI+zW4FKTkn8MCPfDkyJ3NyhT8OW+zgh?=
 =?us-ascii?Q?P/u7igbQpBCS9BzEztXjiWmDDa995KzBQ9l/hqNxgwYqrn5K9/Ne+5StFa1s?=
 =?us-ascii?Q?5TGk0g77puS8lBx81x67udtaC2xFG8eqyrmk+7T/03Nl5PQHsC3ungWYv/5Z?=
 =?us-ascii?Q?caEVkmVuaWM/xLSfFdSNbZ35zrzxwHztkLUDZNj5IrLtLwfhw1p1BKr+C5dk?=
 =?us-ascii?Q?zovoNjV/juW1Z8v0w7W2EspglW+5/gk/fMiSJlZtbOdYTN6k1eh62Gsy/1mr?=
 =?us-ascii?Q?J+V5TPlP87DzncbWhMHVV7BrnwjJcEIy1vPtqjcPVTM+ttyoVboC2sJC9O0j?=
 =?us-ascii?Q?zpTXHLzv3MH47q5e7gKjqWai?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZaiNA58e4MaeVt6NWd+lL/z2b4/paGK/8I6JJ6QEb8aRPQzJsQ/fkVpLhfje?=
 =?us-ascii?Q?+VyXRnZcf8FMBJzoQExl9v0yvYpQcOR2mDImYVI7LSEOS7N5eqwz8eiKL9+U?=
 =?us-ascii?Q?wDQc1EMwYeJmadkLR7DR5pxZpR4YkxMtmVGbyHC7mnaopN+C1QXT9RGqTUgk?=
 =?us-ascii?Q?yTVWSf/YESlVZDCuF3tpVEjJxV9iqjm+dbyx4HWZGCIEeBWScXl+XpvkDo+v?=
 =?us-ascii?Q?jlZbIyWoiJZFD5jdR5qTNySp/Ink4yWkmVzNLaEr2xaCavxUFrKMQFtktbGu?=
 =?us-ascii?Q?8JJviUkGNT/MkkP6eQW5XStras3e8aeFBj6h50mHbLrqKbBE7vlY3fmMh5Nf?=
 =?us-ascii?Q?AJA/+dM4SmOfdcTigq9KZyKCf7n/+q+JkjTIE44PM6h/LqT8LvYcFIfjLDX2?=
 =?us-ascii?Q?Z+iJSIKHjRGB12NCkglWvf7nN0iob9j/mQXQn/aGIclSs3Z+AQjLWO/R4zwE?=
 =?us-ascii?Q?PSfnemrYDXSgBAOLQpfya0ABmj8+k6deti8cpSyShKfb9XejRCvxnWCtoZWw?=
 =?us-ascii?Q?gRxpIeoiNPz0Q4HTMMuHjo69TNCdnXXHrWn4FjUgEWjPXszx2oVY89s+oKjd?=
 =?us-ascii?Q?eVGZWQCWPSptKZOq89fN+wLI2yaBQpUOelclZteFdaWu8tOk4nxtDEaF6WWB?=
 =?us-ascii?Q?gEO8jDai5DLfd9qBxN9Kq7hTyX46b9VdV4+ayDlmHs3gBpAM25LtgiGHk9BV?=
 =?us-ascii?Q?JmL9A+7Tf8eAiCm5hgs074W6zToqhFZ3pV8qjWqBgG9yssgc5Gg1bTcyfoxK?=
 =?us-ascii?Q?7erkAHTKu1Q3RYG7guqHWsZNEiLXEKguPv8s+CcoVVVV67JpHyVAmaKc4raD?=
 =?us-ascii?Q?aGzt7ZbWVLidDpSjMHzmDlABtHeEMcaY70kC1QvdMq72uhwhCKvttzBM5hfv?=
 =?us-ascii?Q?2zdYebos5qLWnJuq686F0imvV1BkwoDrb1giGkRkM6Qb1dsE/zfxuCNetuxk?=
 =?us-ascii?Q?CDLbVkiZxeC4jotgLICffI2m4K5k388y4oIszg19HF1ms8hqt7H/QhaCtPfn?=
 =?us-ascii?Q?++8ajeJwD6pyeobvTgek+VaYBtBIcPdQ7vg32J3AB4pabqp72lkF4neGBpFG?=
 =?us-ascii?Q?R5lWb6bDzfI6ZG/IikKdA6UzkPQHdhNL38Bl2nOXg27NUylzKoZFI0SULxan?=
 =?us-ascii?Q?zzvkSkfSb3n+I7L+1VOqxXcvDzaxmXmxp2fu0BPQaR3x0LVfjL4jMxYdinmm?=
 =?us-ascii?Q?s/pHQRNOwINsjqFIv9UOfahH9pfM8T46+dUZDB/PYVxvvI3VdnOktqcH94LN?=
 =?us-ascii?Q?GDbVcv83fF/D840+ZbNy9TKQWeChz7xhZ6bWDgr+/jj8/EgknP+u1oWEKEWZ?=
 =?us-ascii?Q?RBXfu9La2+64uPcvZurvx1+NAGcECOlL4qVxSyAOpBmFzio/aUdkdVaWnJfE?=
 =?us-ascii?Q?iGJa5NROp+AlKW/Y7Zon4uMmRPxKmRuA+0Alp5b4Lh0Oq6H3lgQIDCyZdXTB?=
 =?us-ascii?Q?92kdxGvk2ReWzGEQQct/NqqgIXrQApdw0OYDxosRq5pRFeAEw/W/RZW62K3F?=
 =?us-ascii?Q?BZWRxtQxVsjfDTfJmfz8nbsQ+xJ/wZ7eU1rFLkuX5C9VSnzBf7COQnMTJk9M?=
 =?us-ascii?Q?T+nU5y2/P1ZJ353VrhKNkdx6iogieE6oUijdh4B1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd909a03-9ef3-435b-56ad-08dcfc7b04a1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 02:47:27.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJYpeJLgiMWy0C8+YdNtVVdpxUUErtBcOu4EPvGiuA/58Wk8lGEvbonhj51Lr7gwexEJne97Bwro9hyGTfnQpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4941
X-OriginatorOrg: intel.com

On Thu, Oct 31, 2024 at 01:20:11PM -0700, Sean Christopherson wrote:
>When getting the current VPID, e.g. to emulate a guest TLB flush, return
>vpid01 if L2 is running but with VPID disabled, i.e. if VPID is disabled
>in vmcs12.  Architecturally, if VPID is disabled, then the guest and host
>effectively share VPID=0.  KVM emulates this behavior by using vpid01 when
>running an L2 with VPID disabled (see prepare_vmcs02_early_rare()), and so
>KVM must also treat vpid01 as the current VPID while L2 is active.
>
>Unconditionally treating vpid02 as the current VPID when L2 is active
>causes KVM to flush TLB entries for vpid02 instead of vpid01, which
>results in TLB entries from L1 being incorrectly preserved across nested
>VM-Enter to L2 (L2=>L1 isn't problematic, because the TLB flush after
>nested VM-Exit flushes vpid01).
>
>The bug manifests as failures in the vmx_apicv_test KVM-Unit-Test, as KVM
>incorrectly retains TLB entries for the APIC-access page across a nested
>VM-Enter.
>
>Opportunisticaly add comments at various touchpoints to explain the
>architectural requirements, and also why KVM uses vpid01 instead of vpid02.
>
>All credit goes to Chao, who root caused the issue and identified the fix.
>
>Link: https://lore.kernel.org/all/ZwzczkIlYGX+QXJz@intel.com
>Fixes: 2b4a5a5d5688 ("KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST")
>Cc: stable@vger.kernel.org
>Cc: Like Xu <like.xu.linux@gmail.com>
>Debugged-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

I also ran the vmx_apicv_test KVM-Unit-Test. All failures are gone with this
patch applied. So,

Tested-by: Chao Gao <chao.gao@intel.com>

