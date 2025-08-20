Return-Path: <kvm+bounces-55104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD808B2D65E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7DBD1646F7
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 08:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432B02DA76A;
	Wed, 20 Aug 2025 08:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m7WoWQpS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729A32D9ED0;
	Wed, 20 Aug 2025 08:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755678550; cv=fail; b=TsS59iVwscNYZqx6R42ME5TkqEhhbRezjh/DAcu1mQzaugIAWwnYVvD5PVJzrlrkM8Xxu8uZC62oP/FBv4IyqKa6kOljiWiQlkNUZfuftYph5n+P7o88qlFcUuODts/sUXgdr6Np23OiVeq9sqEp3LSzeorSxu3t6JlTT74A4KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755678550; c=relaxed/simple;
	bh=eBh4aQAbaIPp80NevQUrYC8q1gAtUeSfJggQ/EAs4ZY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SvDp9O+gyR8Hva0QXWy285eJdkaxXxBXbhSggnvTXvoKrfMPFjbEqWYvlDMN6RdVNBV0KSVK64m49UaigOtFkODMu++RWx+npX+9Sk3kIj+TsF4JaVIqV5rgV4lIIwclPe7JLiCVhYTZ5Ip/xHuwdxsQx1bsGC9/c40nbOs7voM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m7WoWQpS; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755678548; x=1787214548;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eBh4aQAbaIPp80NevQUrYC8q1gAtUeSfJggQ/EAs4ZY=;
  b=m7WoWQpSfw6/X0heIns4CwTJDbBj53q3F/kbTBDOZoqLyQxVtZcW9ytt
   Cpu2CNVVIWxaDvwc91O6mN8MkngUNtF3yupPoLz1s+4abdagZoeg1oMZp
   Xr9bcsX8x/vWNNODzhqGTX6pxZ2eJ9YGDcWhzYf2piAM97D2rnF9kLRjD
   ROUMqxgobO3n8eWK+9EVPJfIElKkqYJwm1jbpyAm7EXB4hO7sgIHWP6eJ
   KK+xBf6gOvm9WOemiy7XSU4jpO0bfhIW6V6M9zpNHb66jTe9tvqW4I+e7
   ZhHwWgJcz0IWZocat33zetqg6WsYHHBUwsKXJXn/tdPMG6+pcDyxzzykq
   Q==;
X-CSE-ConnectionGUID: Wke/TyxBTk+/gUFda9xw1w==
X-CSE-MsgGUID: lNikQ/vlTimKtMYbJXqbfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="68538497"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="68538497"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 01:29:07 -0700
X-CSE-ConnectionGUID: miLurkrqS+qRP29O1aZy/g==
X-CSE-MsgGUID: TWrbb+FnTw6K7RohTjrurQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="173427864"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 01:29:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 01:29:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 01:29:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.87)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 01:29:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CibgwdQ8Vq/b5LvaT6G0yVrRWWvVmBIBPBPPG8qZVqrBTf/AZ7h5JWctfKAKF71oINjY0UMqlifm3GE+gZ01xFJAuRn/d32xMJFxlRvMgUTmqgrrKBswL7tJ6ekwHx9azj5mjpSJm5qq5voAyKyCXMjIuZ8Bs3U4IiVgKT4Fhf8oYrrXvuvAc/RhzahQaGo3pZEMvM2ojhT6lGWei8hKfmx9v5EJvVtjaHc3idFfrfU9OrkP9HNeQqQ6TqN4GKl/kFGVptp4QcgTYHFMy+IPmT/ZbEQNu9fGjnzNflo0dCx1+b2rCcv8tTfHtvOswedU1OEuKziu4JsGKz3xrki0wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnP350xUgIm4sWZOSDbKcGNqOqU2UdAXPAqaqNrQZSY=;
 b=QwiFXxR6nYpO9P8I0t6YzdbaZ1MxdTBorDxKQvZBPnEaUmpUpFvP2id/po2RyXhVhK0+gr/J5FxDqb4BHqT+Pbep4zucE4nX8Hrie8LUYSV7/LZ9NXjFSFjxNer7MXFVuS2WU1nNWzwqNawiC/ghA7CeRBLPWggQG2VlNxLTx3wRorX7ntB+3NM6iQnuqk9AnBiy2ysvcnVdX4D2XfC4fIZaqL9lCKwrTcaZ9mBquKe3CI3S8tiiAmCaBzsh5cmBXLubqiU2xBphlmkvHfRtA7BJ8F/T6GLto10WzuRaQ2eHaTufe+oQ1Beb0HfkWQ6kHAmtBIG0lCQDjOfLwT+RFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6016.namprd11.prod.outlook.com (2603:10b6:8:75::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 08:29:04 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 08:29:04 +0000
Date: Wed, 20 Aug 2025 16:28:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mlevitsk@redhat.com>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v12 06/24] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
Message-ID: <aKWHRe4qli+GkqHh@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-7-chao.gao@intel.com>
 <aKS2WKBbZn6U1uqx@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKS2WKBbZn6U1uqx@google.com>
X-ClientProxiedBy: SG2P153CA0054.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::23)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6016:EE_
X-MS-Office365-Filtering-Correlation-Id: e6b8631e-7d71-49f1-7638-08dddfc39f2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fYbnxY6l4wCF68RwP/8Lm3WnulD3t48GUiSeRtIUfR6D9tbdDfk+SZ48Z1v0?=
 =?us-ascii?Q?vrgl4lkwQGr7ATgWMCQkqh2lcVXi1U9l6q4Wjglb4j1NImUJUr4BrkE4BiHT?=
 =?us-ascii?Q?Jji8NEzHbMFX7ELbDScomB5ab4dT56/JAFDrP+wrYku0srf6RD4F5ypdhuz0?=
 =?us-ascii?Q?YSIfk3Sdal5PZ9aOGVdJ6m2qp7avNR+4eNYeQUR/MEUTZ2/KvlZrZuOUPIHV?=
 =?us-ascii?Q?zHfU/dl0bpF7gIzPyGC1oCS8Z1hY6Isn37awd0UzjA/104sm13uxbkN6MtnG?=
 =?us-ascii?Q?R1l0OY0scUWNoVXJKgNnzFiMV+Fi8jvv78Hyx4j0D5v8Em6D4EbaMKVqZ45w?=
 =?us-ascii?Q?8bqen92SOesu2AuA3NKYjx0gqqRAwk3ojwc3+3qgKnLcbDDqECTSLhSlxIky?=
 =?us-ascii?Q?dEwNRPKNspm6FzdePHykgOfHGlu2C3TrDNQQJPMro9SMmdXQRpOwA23LlVpZ?=
 =?us-ascii?Q?ykEX2+/wjZXr7U4PwqzHYCMKXa572vG77IUzMUz1+Z3NwfOy21AI92xf2b51?=
 =?us-ascii?Q?UI87Qlf7wiFrFXaJzudPsVLUvnc6RWmAbK+lp8ayx5LDWx5SSBAJkQf+p6Yf?=
 =?us-ascii?Q?3/MpSfKhg+ErG0cWlVkSfIBi9h6QSK3T+DKaf51DybHEgws5KqoHEpNjLYNq?=
 =?us-ascii?Q?1kYtc4j3YdqzVlH3liSjS11HZmKbHptUm2/g3j1YQFdZ8wWi5G15REJKSFaE?=
 =?us-ascii?Q?60N6sNagJxHoR9KKWe9N3MEjlL//lrBRySnr/gf7L4tT3RYerknYCBlionvD?=
 =?us-ascii?Q?fXZVBpv6gaeo+xaFbtAgrY/1VCGme/pM4WsZcDyWgaMnU6GI3eghbymCtwod?=
 =?us-ascii?Q?ZrAssRWEScX3GVgZZDh6x/hIaFrjfujkxvp+Eq/K8mc1mcRwcD/HYtN3i0EH?=
 =?us-ascii?Q?HxMZ6wFO2xTtKoKY3x1iY1TQE2sVkuWtvBThKDpJDPvcnrxocI596pKsxJm6?=
 =?us-ascii?Q?Oi6d29dC5/vg67wmofrDIGXqqnpHTJbAKZL20ynFXzGWNXrU10zdRWUiJsdP?=
 =?us-ascii?Q?mol8qL6jK3kcg8hYn6I5WcYJGTWxT7mzgDO0HDspRSWMnZwDy4mHPDVJi+23?=
 =?us-ascii?Q?rheH2Uj7T9EhaQkIHw/zi/2jlA5o9VnCJ3F0AAiddAUZkCCnBz+U81dK1X8P?=
 =?us-ascii?Q?y/6STI45W8d7ObtdvjNHPC/1//Ae+vMSkHlD7YGnIZgejic2shCUXBPrD5L6?=
 =?us-ascii?Q?ysGOoqi9lPuT7UvPMDazhLuNw18mCdBQ4+XeJKCwf3or7T+7bz3ujZzWDpOn?=
 =?us-ascii?Q?1aH/nwPsFcJhmI+j5ciiMmCukSkMityMF1sgas/dtytGb6yKUaOFAonKEro0?=
 =?us-ascii?Q?30apRW79LXyFB5j9FU9IdsTwitoQVN8aS4H/Wi814T9iRpGIPPyFDI2mgYBK?=
 =?us-ascii?Q?/xSCFK2dj9EbZaz+a76JOJNuWFJmhZm7eToDIo4Qw2oHSj7RxqkNU5MwtrCM?=
 =?us-ascii?Q?4O4tmLwvuew=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8fEXbFgYgTQm9KbIxEr49z4zyzue2kvjx5QEYw051AEi3KHOEOps5iKXBtz?=
 =?us-ascii?Q?JD3wM1zXEsOv0jVqFV2BKaAEfUL2MEHFzmqwdgwGxPMYm6vR6toDa/WtiFVL?=
 =?us-ascii?Q?LYXwtjkNUCNxZrufwRqJ1GI9RvhHWIaOdvgIDQ59bX8HtC2Hk9LeKtgW6WdQ?=
 =?us-ascii?Q?6TzWZ6NdXU8M51Ss5eV/j7Pn6+JPRHRxmaZl+32/D3cmlEmDfoaMOZHB0Tu2?=
 =?us-ascii?Q?YwPY3DXToSSESfPkjBCrYnWPXPByCvuFReMF6cKPtsRDhk8+C3Kcp12QJKgX?=
 =?us-ascii?Q?gZFPpm9WQ3g/RJeMSLLjKQrK6G/SenNqdG7X6r1dKfmmaDwrPrCc4Ipzoflp?=
 =?us-ascii?Q?NNQnnlsT/Gs2GZRXQuO0TPxWBZkX9jTOEYFUwkBwfunnY+VqElJ/U3Nh8PL9?=
 =?us-ascii?Q?t323IShM3hmGRmreo0QZbcu132Y5iAyafQu6NoQR+DEDMN0Rsj6Oxwfyxvk1?=
 =?us-ascii?Q?ecarDIbXi9terAT2NDXwLkNsX4EGGh3wS2eSNAoDRcdAgAUjf5VPDLmwZWD3?=
 =?us-ascii?Q?NMe7ZZX+ibFonvtW6WK3caVQgQTIjLvW57+bobimmO4jEmSX+8SjacchwZup?=
 =?us-ascii?Q?A3zLP/Ll1nW+Qcphc9SxABPgDYXd9geptbG3Cr0x+RcRL0vc29DU8/3Y9KXh?=
 =?us-ascii?Q?b9dwCZncRSIzMPrf4GyfdEJbugASn7FVQGQx7L7D2tA5qEaQRiUSO6XBNM2z?=
 =?us-ascii?Q?zejiNq7WzjoX1X8+H2bVkpmTmGpBw2yF7r8mRcAFeHE7Kc4/eiFKsW/my988?=
 =?us-ascii?Q?Z8qgnA4xRU1qiYW0FfgjLVQo8bV6/8Fhmw5WklGUugDY+MOfyFJjNFuwlfpt?=
 =?us-ascii?Q?yx/SLTqzTKmXkBoZbd2R2wmsk0UVqvgQQkQwMwDcFpmvqC0dtknqL+wZIcyN?=
 =?us-ascii?Q?gWoQlE9f4Sp0tWCOK6smahcnN0s9NsAU1vkYyJ9I/WurbPi5UBqjGHG3FW2P?=
 =?us-ascii?Q?fkgVU8gDLJU9V+6ZHxk2nA1QAJKBqTMXg9wjh0QibEhDgUo26mCNqSShI4J3?=
 =?us-ascii?Q?+GyfONHeBFqBYtI+iaXVGbs1PMsbyspavBMWPQr9RxA+xrdZj0bi1TfA0HVw?=
 =?us-ascii?Q?IPxu7WluYnEv32dm+ZvwTVlxC2Ps7gdYo7JcSXKo8+hjVl3ep3GZs8RCN4Ix?=
 =?us-ascii?Q?R7PIO+C20RgCNRA3jcr3g45GVjcg2LTa28M73ubo8VlqOG5k9xwSyf9pS/E3?=
 =?us-ascii?Q?0cRi0yBeY7FM7w4LFYInKbyBLeBOnlylYLEX+dKLi7j4Sd4t4rdLXPfcXkTH?=
 =?us-ascii?Q?b2Cr7q1f4HCcHlTukdfFQ70TohGXkk60sAUj3163igOTFrgQ2TlqzPD7pRs7?=
 =?us-ascii?Q?WpknfumPrtXwloY/oEE8TBbWO4BBospjeK8GRsJdKcCrlmNl02lfS2b6lYXB?=
 =?us-ascii?Q?5ggvkcG+wROSf86i9TJ5iidXcYF1JJ3V6nfrVLYH3HPXZ20244Wfs0CJlrHB?=
 =?us-ascii?Q?h1e8jBbvULcCJwjGy0y8jLrkQMnG/domgRSpSn8NL/ZOZg9Z9+JBG3VxaWXW?=
 =?us-ascii?Q?iP5rVg7+vvn1C3bsxBAyz81gHg1NrjuoyC77JufAqjtnmT/JSJO5SJTRdClS?=
 =?us-ascii?Q?WUtZOOtLNXhP3WQOkd99GevSyCbqR42KgSQROhyF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b8631e-7d71-49f1-7638-08dddfc39f2f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 08:29:04.0759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/20jukYDrDI/L1SwazP9++H6HDWMKkRbviwc2UEbcCbS72jOnYjA/8do0Xv+IwMdHu0/d1RM/lND594MqsGSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6016
X-OriginatorOrg: intel.com

>> +#define KVM_X86_REG_MSR			(1 << 2)
>> +#define KVM_X86_REG_SYNTHETIC		(1 << 3)
>> +
>> +struct kvm_x86_reg_id {
>> +	__u32 index;
>> +	__u8 type;
>> +	__u8 rsvd;
>> +	__u16 rsvd16;
>> +};
>
>Some feedback from a while back never got addressed[*].  That feedback still
>looks sane/good, so this for the uAPI:

I missed that comment. Below is the diff I end up with. I moved struct
kvm_x86_reg_id to x86.c and added checks for ARCH (i.e., x86) and size.

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e72d9e6c1739..bb17b7a85159 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -411,15 +411,23 @@ struct kvm_xcrs {
	__u64 padding[16];
 };
 
-#define KVM_X86_REG_MSR			(1 << 2)
-#define KVM_X86_REG_SYNTHETIC		(1 << 3)
-
-struct kvm_x86_reg_id {
-	__u32 index;
-	__u8 type;
-	__u8 rsvd;
-	__u16 rsvd16;
-};
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
+
+#define KVM_x86_REG_TYPE_SIZE(type)						\
+{(										\
+	__u64 type_size = type;							\
+										\
+	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ENCODE(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
+
+#define KVM_X86_REG_MSR(index) KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
 
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf098a1183a..28e33269c1e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5940,6 +5940,15 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
	}
 }
 
+struct kvm_x86_reg_id {
+	__u32 index;
+	__u8  type;
+	__u8  rsvd;
+	__u8  rsvd4:4;
+	__u8  size:4;
+	__u8  x86;
+};
+
 static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
 {
	return -EINVAL;
@@ -6072,22 +6081,28 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
			break;
 
		r = -EINVAL;
+		if ((reg.id & KVM_REG_ARCH_MASK) != KVM_REG_X86)
+			break;
+
		id = (struct kvm_x86_reg_id *)&reg.id;
-		if (id->rsvd || id->rsvd16)
+		if (id->rsvd || id->rsvd4)
+			break;
+
+		if (id->type != KVM_X86_REG_TYPE_MSR &&
+		    id->type != KVM_X86_REG_TYPE_SYNTHETIC_MSR)
			break;
 
-		if (id->type != KVM_X86_REG_MSR &&
-		    id->type != KVM_X86_REG_SYNTHETIC)
+		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
			break;
 
-		if (id->type == KVM_X86_REG_SYNTHETIC) {
+		if (id->type == KVM_X86_REG_TYPE_SYNTHETIC_MSR) {
			r = kvm_translate_synthetic_msr(id);
			if (r)
				break;
		}
 
		r = -EINVAL;
-		if (id->type != KVM_X86_REG_MSR)
+		if (id->type != KVM_X86_REG_TYPE_MSR)
			break;
 
		value = u64_to_user_ptr(reg.addr);


>
>--
>#define KVM_X86_REG_TYPE_MSR	2ull
>
>#define KVM_x86_REG_TYPE_SIZE(type) 						\
>{(										\
>	__u64 type_size = type;							\
>										\
>	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
>		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
>		     0;								\
>	type_size;								\
>})
>
>#define KVM_X86_REG_ENCODE(type, index)				\
>	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
>
>#define KVM_X86_REG_MSR(index) KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
>--
>
>And then the kernel-only struct overlay becomes:
>
>--
>struct kvm_x86_reg_id {
>	__u32 index;
>	__u8  type;
>	__u8  rsvd;
>	__u8  rsvd4:4;
>	__u8  size:4;
>	__u8  x86;
>}
>--
>
>[*] https://lore.kernel.org/all/ZuGpJtEPv1NtdYwM@google.com

