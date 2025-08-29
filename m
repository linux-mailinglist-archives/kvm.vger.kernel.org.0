Return-Path: <kvm+bounces-56258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 13813B3B5E5
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3939C7BE1D9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E543286413;
	Fri, 29 Aug 2025 08:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KIZhdFTd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71606246787;
	Fri, 29 Aug 2025 08:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756455554; cv=fail; b=o8A4tqUaW0jRqcTputmAzWiT8Xwuh7beqCD29zFGFW3TEc/8ZhWRcjaap3H9BGSjghfp8KcSKlxX9BRt1j11Rv3blO/K/SVgDVmMS765UtThSFN5FLhvB6r3T/mv6vjtjCshUFU+XnIAt7jSUu+lYtbeS/pQOklEBuSZzYD6Neo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756455554; c=relaxed/simple;
	bh=O8W+MKHaAafk5i8D5WMeCDT5XogiMtYz4DmRpmW7kVg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IuwzOMwfG/MDNf3BjJhT2uaBHTMFK5fODDzq4CF/XwJfjj7m0nZc7xD5wNodt+3KAZUNoioIDetOMksXazsbyjV4XeIxO38aeNwK9Y/rHg2A5jCu764MpBVts2zan1tSXE/YEHVJEbEDmf3ikxHEcvUsZI1P3k9nP44a2JbK/iA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KIZhdFTd; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756455553; x=1787991553;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=O8W+MKHaAafk5i8D5WMeCDT5XogiMtYz4DmRpmW7kVg=;
  b=KIZhdFTdfEqywgKUcSjao2J8PL+6WMUTBBnCyikTiz4o3Ub8gAlMs6My
   RtG0TH+HLxWSM/mL0h3ejKJjwdsmBslAvvBTLhOouZL2ibGxApSqL7XKX
   AZgaLTcBPIvs4coPXEVaEXQQi6ZYbSSbE0X4p7nw7S9Luuakp6qr7L9pe
   scpxQl2iK3TWtMqfYDzvbUqGFA2e+VZab4OLqK4ESe4itDgf5r7p/FN0N
   a1GQe2vGPC7ut7M7aixYKSW8VHnlHYKQYYMAf2y82KAtn+3tyVU+lIj9x
   dhVmDrZ9wdWDXtK030wuavaKEGx3WDSNgwAyP1NKUfzpyWTpkXlH2m1cc
   A==;
X-CSE-ConnectionGUID: 7yqI+uueT72bPYNTIP9HwQ==
X-CSE-MsgGUID: SDFwawnLQ6anpSC9OTHlkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="70107176"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70107176"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:19:10 -0700
X-CSE-ConnectionGUID: ldVD6oqkSGCdDcj9/3JdZA==
X-CSE-MsgGUID: IaCF059bQAC0MndSQ/JAuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175613681"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:19:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 01:19:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 01:19:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.62)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 01:19:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1g8R9suz8rX/NmA+UoBzwDvNnp+5OL6Og2F3hB6LSpC8qVBFbBy5OcWwoMfa0XyS/fS5vr2aVlqyEKg1QdlRa4ctqkfAouUlicjHhVQFr075JXJbw9jDNVlTpyG62LHEnNxqmir47mbu6fZhLubP4UB0CYrJn6WptantP9mGWxR/wdkxWCcdukcT1GFrWF0uonKrdcnovAdRbMb2WH2Tb56jE3JVEDvJ2RVWArpt6i3CZgDiDqsmWkIf2OUOBbKtWo1I0T/PEDqEtdKcWr93Dll5SREHsqvFGyqXkGCgaF4OfjalUo3QN+wuefwMSPKmFWkFJ194bkwVb8mOBN6gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QdnNoCcf1wDO9OmUZiU06QC7LurERmnw445e8Sb020=;
 b=D3bQ8jGypStLri4CY9I+hSFd/Uxvy+MGfbRv760h8hacCvVzzw+21c0ElxQInCqZK7N0spGxMqgTH52qIvdoW5hZflpFJsR4cpszYLJMmgpT3itNz0mL+xeXAYoo8CkSpazvkOcIbPPfSh0u5ahiur5Vrrx5Z7BJtfVPOtErAmi7ua3UNj0SjG+49lQZ6PCcajQQjeWZEEQj1qoTtd5JuI8E0pvBhCHgB/lE3CimOXBSbrTQ9uPtO6SFbIQc79R6f4QpULBzJqlaYjeXFDfkZGwByU7ifiLM5L1RdAo93k96sUvLYMwVq1mrSUHpZmTLCjUu1oD/Cdf+ffhNUG0Reg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF4B1ECA5EA.namprd11.prod.outlook.com (2603:10b6:f:fc02::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 29 Aug
 2025 08:18:55 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 08:18:55 +0000
Date: Fri, 29 Aug 2025 16:18:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Message-ID: <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-13-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250829000618.351013-13-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF4B1ECA5EA:EE_
X-MS-Office365-Filtering-Correlation-Id: bdbb81f7-8ce8-432e-34ad-08dde6d4b208
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wCyqIFs764BfUQjwucQMpPXwRRzcQblE1OmIRvtYLV03rqW/ohDyYmOFPqQd?=
 =?us-ascii?Q?35OkMG34SoIHNWnLA9VJToJL3GAJuYmb2VR4uI5cOPkClKbzmrY5/BHqB9GH?=
 =?us-ascii?Q?yRpXcE9iWSzKDxJYpvCVlZKYBy06FCPoi6kiY6YfM/M6cvf0h2wb78upg49Z?=
 =?us-ascii?Q?asNQbjnaz+ykEsaQJ2qR9gYOmwozvEOGcCp/9H9TdHnmUPib40C9dlL4F8pg?=
 =?us-ascii?Q?EHFbpZQrH7I5uiiyg49O+SAd0Bg+dDvEVj3i69+T7bW3jqyWvOIUC52BKcH3?=
 =?us-ascii?Q?kQOCeoNER4dUhpfSyGAfcKcLKE8TmFuHqlULBxFHFEoMgsWN2vX7dJaknMOj?=
 =?us-ascii?Q?1vUVB+mOMkozN0QwTznMaXRwhDkXA5uOihIkpajfpZJgNIbBcQ0O2eCEiGR9?=
 =?us-ascii?Q?jFg3vsTtxYZwEfnbnGzeN4kSiVCd2Jw6ETDEQY2SQ/idFnuHNfXBrEwpjrhk?=
 =?us-ascii?Q?f9arM6JVnhKhNMJ8Ok/cM8qsxsyQMMNTuygxCkD8KrUTwCeB5HSQyrUkc+Qm?=
 =?us-ascii?Q?WOQgDv1g3vUto5dtgPy98uYHgNkfN3FCwmnwzK5K4nZC+oQrLFi2CcOt3a8o?=
 =?us-ascii?Q?fE+3sC1Sk2uPsKWB7yQXgq6cA9ZaJwDOJBG/xVADmrpdISbR7hk9BaBo+tgq?=
 =?us-ascii?Q?VGyr770tI+7EHkFJ2VXoDpq4JnYNbD5EqAuNgYieeWzwZ48Gh0Ltv69sUASz?=
 =?us-ascii?Q?1zYCP3bnctnyoFWFr30Heo3l4JT88ivqTF+240L/NOyZR2qvsJoCadWTuRme?=
 =?us-ascii?Q?ZSeIzn3EUwXZ0kuEuOKo7knRkReaPwnk/oZP53G/QzC15ngDI52uox5In9LT?=
 =?us-ascii?Q?bnZzIHSquE5CKND99I8kwXcQ26kJBpTDi1/4AiSdq+t8cjXq22NmOJPbD/nQ?=
 =?us-ascii?Q?oavN4cGSwfTH0mJhcqgNtZYOgZ697Ug/UXmESg5YQo9d3XInGKSXvCC/R+De?=
 =?us-ascii?Q?hZGNXaL5QOSkmhkfYTPMvXSw3WyKLwAAvCM0VIMYW+FNA2Ng+k1CAgRogIlC?=
 =?us-ascii?Q?AG6HvaTi4hnkRNqgcbDLaWkyDp795bcwxJo/kPeGnH54rSGddAE/sSpvKz/v?=
 =?us-ascii?Q?c931xCL/AgOqqS9d1vEYRrLvVAw3GhyCJqCZTo/kPFB0+1pjcZNWlQiHARyb?=
 =?us-ascii?Q?OpT98tf+sfu23yZXha+IMKk8hBghQvB6dQRFwicwRwBps54sSgV8/Jf3Ba+E?=
 =?us-ascii?Q?0cpwLk2RVt7W8FY9tWJZy/CFsSP74wk8rNeYerf3hqnx5mdYjmcs2CEN2Ks2?=
 =?us-ascii?Q?XAiGvpYnEAW/U1oI4DFjxpNbBBQwTpu+N7svp2U9UsWmsqS7hTtE2EKsIBaX?=
 =?us-ascii?Q?P4L3nJB5AmuCbJhAi9alYPagP7Y4T6CYiGMX7TurnX41PUYgWTy0jNjGVpHD?=
 =?us-ascii?Q?IM1zZjet+WLyUYNS9vU+frWGPGtN483sEBRAQAHjUGseXMNh4jZMSv3/7vLN?=
 =?us-ascii?Q?+1l9UrgG/so=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vMS9vLWfrPZQRQtH6UMdn8LPeC32Eq0T0QC+khGC0LtjcMLa5R9/rzzU9LTE?=
 =?us-ascii?Q?CG/rQpYslkR0cNpVHrwoJuMWyHQ82CbZo8kWPCacK/x9mcDa5EU9uGVHsjy3?=
 =?us-ascii?Q?U3pCPNa30Cwk4DWVK6qWi72BnIhETnSaeWriVbtGpKHfZVYd/1LMtiSh2ZPz?=
 =?us-ascii?Q?IWLCu0I4dFuYWw9Pj+VDb3UMCvWWcKZlHrd45AQoahzcfRdU1jlPTqq79vcp?=
 =?us-ascii?Q?pD8dtc/X2h7EiyVViTxXz3kp+YC7f4pYVD5sd9w1R9g96CbI8CQ71X0SCewS?=
 =?us-ascii?Q?YI6BvRZAP6vZ9Hp0UzZrNmd8V6UdhmAeZ15JWXhzu6mFgJarTW+Cqg8Oa9sO?=
 =?us-ascii?Q?9VBIZzA1zNHVFHg6fRFTwZmhllgnbcCG1KCOUu/JsYuAU+KwG8uYhQks4sOU?=
 =?us-ascii?Q?xZLwGysahtZEklRsZHTfG20CKV7zc2ZEiuJHvaFE/5DXIcQVADYxhJ7PBkWe?=
 =?us-ascii?Q?np1Gyetipp9gVbX4JP0IpXc8d5LF5CjZ5d2COiaFIqOzIiB67BaivTkams6/?=
 =?us-ascii?Q?fOSSoSgNnloulaNA++/eO7cSHd/tmF6MWeYcgPeg9jN0LG3GEch4vhaKL5Qc?=
 =?us-ascii?Q?4y0Rrpaa/52BdYutQC4mGG9nhkvPanG+FEt4FAGjsLitAPKg98GO2UsHkw0o?=
 =?us-ascii?Q?9+nTnW9cD8Aq9xgRIGXVesF5GMQ7punVX2JxF9mLS3BlF5zCXxzVSK9m0hMa?=
 =?us-ascii?Q?n240bik7V+v60DePpbfO1dtE71SqUlpXadAon5hmk2G7GGOWp4avgYgj2WWq?=
 =?us-ascii?Q?ws2FyM0nuHe6aDeIIlZcd7qK8ariI/Ot/4+0Z8QL2xhEJnw7NEhbzIK/sDrU?=
 =?us-ascii?Q?95/Fpr2gNXjoE0MUgiNPPTANt/4MnGhkKrX1x8aufBZte3GfN2c5Gylui/zC?=
 =?us-ascii?Q?kLOw7SU4QnfqvRnxOBeRwdyTpjK0x0/6zyxBcnYSGjpOWiwSA1rYoQrX6hjU?=
 =?us-ascii?Q?IyMDT5ZnzPAZ7qQsZT2UTpGkEOaDptLFCVb+fy/zaZiaS2TruopFLyhCCS8+?=
 =?us-ascii?Q?o1rQTIJbkqzij1cIvPHLmVaQv8oyl4mU/qlQn8IrZZuwKUlfgE4CzZ+4LHRr?=
 =?us-ascii?Q?QAJfsseWlSl9QiVBBntpurpFvHW8IlL8pYlMGciJY3flOW99llQceFRTxb4S?=
 =?us-ascii?Q?kMUctpEgtfN2ZK/blfwP/lYRIhOEk94nS7YRFrLbSEpC1ge7PwuSSnLnlrtG?=
 =?us-ascii?Q?aylxZF0gRhKB6CPf8ECIkeDo7nfycPkYEl8HyWLqKf2mUWC6rnPSk9vMZslH?=
 =?us-ascii?Q?YN+g9aBM+U1bWns9491AqqiWGpXSdZT0DMf5UYpNsDjs7BRepgky8phdlw3v?=
 =?us-ascii?Q?yiBSk5X3DcZA1iQ6+DaL3mkviiEhqi6W+eskWHEdwQmPr3vJEwx2MHq/agq2?=
 =?us-ascii?Q?+BPLMwlAN3er6Q2qzxPwQMGbntnxTNVXkNs/32HsDpcZEQx4mgOzN9HXcB0i?=
 =?us-ascii?Q?2SftDn+5tGvuu+hC9JMry+L3uWUGdXUz7AKjzC9OQ3e2rRtx6RlK2pDeNpq9?=
 =?us-ascii?Q?i0WB8nFSbwO0ah1tm/ENA6SKnebEIxwiS6tMLusyZpuBXPaR4qzJ4Sf2pWem?=
 =?us-ascii?Q?B8dkt1tfYRWP+Q8lHSZyecU/A8V65y5jcQQInj5e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbb81f7-8ce8-432e-34ad-08dde6d4b208
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 08:18:55.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vfXKrsUwIMNIrhQcymKbKdFD6AZpqfIJSM7l4wCsC6bU4xmNp2dmQ0OzQaZhbMBH4jICcxyZn+cFBFDQ7k3rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF4B1ECA5EA
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 05:06:12PM -0700, Sean Christopherson wrote:
> WARN and terminate the VM if TDH_MR_EXTEND fails, as extending the
> measurement should fail if and only if there is a KVM bug, or if the S-EPT
> mapping is invalid, and it should be impossibe for the S-EPT mappings to
> be removed between kvm_tdp_mmu_map_private_pfn() and tdh_mr_extend().
> 
> Holding slots_lock prevents zaps due to memslot updates,
> filemap_invalidate_lock() prevents zaps due to guest_memfd PUNCH_HOLE,
> and all usage of kvm_zap_gfn_range() is mutually exclusive with S-EPT
> entries that can be used for the initial image.  The call from sev.c is
> obviously mutually exclusive, TDX disallows KVM_X86_QUIRK_IGNORE_GUEST_PAT
> so same goes for kvm_noncoherent_dma_assignment_start_or_stop, and while
> __kvm_set_or_clear_apicv_inhibit() can likely be tripped while building the
> image, the APIC page has its own non-guest_memfd memslot and so can't be
> used for the initial image, which means that too is mutually exclusive.
> 
> Opportunistically switch to "goto" to jump around the measurement code,
> partly to make it clear that KVM needs to bail entirely if extending the
> measurement fails, partly in anticipation of reworking how and when
> TDH_MEM_PAGE_ADD is done.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 06dd2861eba7..bc92e87a1dbb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3145,14 +3145,22 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  
>  	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
>  
> -	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
> -		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> -			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> -					    &level_state);
> -			if (err) {
> -				ret = -EIO;
> -				break;
> -			}
> +	if (!(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> +		goto out;
> +
> +	/*
> +	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
> +	 * between mapping the pfn and now, but slots_lock prevents memslot
> +	 * updates, filemap_invalidate_lock() prevents guest_memfd updates,
> +	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
> +	 * zapping flows are mutually exclusive with S-EPT mappings.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> +		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
> +		if (KVM_BUG_ON(err, kvm)) {
I suspect tdh_mr_extend() running on one vCPU may contend with
tdh_vp_create()/tdh_vp_addcx()/tdh_vp_init*()/tdh_vp_rd()/tdh_vp_wr()/
tdh_mng_rd()/tdh_vp_flush() on other vCPUs, if userspace invokes ioctl
KVM_TDX_INIT_MEM_REGION on one vCPU while initializing other vCPUs.

It's similar to the analysis of contention of tdh_mem_page_add() [1], as
both tdh_mr_extend() and tdh_mem_page_add() acquire exclusive lock on
resource TDR.

I'll try to write a test to verify it and come back to you.

[1] https://lore.kernel.org/kvm/20250113021050.18828-1-yan.y.zhao@intel.com/ 
> +			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
> +			ret = -EIO;
> +			goto out;
>  		}
>  	}
>  
> -- 
> 2.51.0.318.gd7df087d1a-goog
> 

