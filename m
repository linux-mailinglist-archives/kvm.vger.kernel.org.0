Return-Path: <kvm+bounces-66109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 815A9CC69BA
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 09:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D13F0305FE4A
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 08:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55FC15B971;
	Wed, 17 Dec 2025 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCM6Pcij"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1077A26ED3D;
	Wed, 17 Dec 2025 08:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765960368; cv=fail; b=tWr8J4VdgXCLODoP4/sm3GsL7LSKNP5jVDDnqWl9xKA0tp8wDbEEWqb3cf3JG2AnQEvyHK7wmbz+XeqKZnkBoRLlWXF0thmtinDHORo2C2THBSQUfaU61CvOgNA7skJBACpvf9+Isd761aOuWBv7sWsbGOMHu7+hxkuOQtzMte0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765960368; c=relaxed/simple;
	bh=J24ovQYasyPKWJSEdRjLaiq4QGEHw8RB2b/lpO27mkA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y33bKTNyjp+2MzKGWI+3u6JJdq2pxOwMpyNWmopMDRMRIU320SAK/dhYi0nbpXTKESpQhLGuivKDbRMx3LyW/1yYZ9UtqWcOEllZiF0gP6/OC6PWsrYAiMp/hPS5cLNvHnm3vtWjSlcg0+K8/kXu/0DbQW//rdkBpc0/6fREun4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCM6Pcij; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765960367; x=1797496367;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J24ovQYasyPKWJSEdRjLaiq4QGEHw8RB2b/lpO27mkA=;
  b=LCM6PcijQKbLCrywc9siN9MGkP78pDMtNz3br799wBz03V5bnVt2d5ua
   DAME2DYhge/2rQOAZyKOMGWeEADRfXh4PatKDpsfduZW4VXwi70BCmMJk
   r97LB6tmMhiVFAsu3t9czYZZc+3lV5bVORA5R/Cj2j+cpqh8i0O5EurtL
   tT5VzcnJ+uWCwcU4ITeX4rhLMKjMVb9Cam1g3ZJk5c9MVu5TdwXx8zidz
   0mXxi9O/+IqNr+41MrA1K9LaEIHhF8Kp2qPOAPn848e3pw+nJp/oAR0iG
   iUQVFI87eBLouxJDqDPaQXUC7z5HQBOIF8HEd58xtM3D3y52jUnpHSIKV
   A==;
X-CSE-ConnectionGUID: aNFjC80lQRCCWhLkjjYuJg==
X-CSE-MsgGUID: 7tDqfjw1QSWnY3qpkT798A==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="66884646"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="66884646"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 00:32:44 -0800
X-CSE-ConnectionGUID: A868pUbaRziakHOZxzRJKQ==
X-CSE-MsgGUID: O9TF3v14TaOC2x6zemqPpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="197863635"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 00:32:44 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 00:32:43 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 00:32:43 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 00:32:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YNXqUOi1YED022nh/gOkXK7/Q6S0XVwWDsrYiHeGzYfdsmq3lKEui+F3LwH2SvMjum6/kS62uADV3Pq737RpC1J5ocMMqWNlC9sYUwJ5xfxvRfFts8isK6yfk+hkEjS4XFNywPwyqlH10soKQg0+RKhhlqwfK0HVSoAgR7RRPgymt/bfoLZgJyBPHuSxL/MPKzwz/cvCk4p5YUhH0xZHDN2fOHwjJz56kMxXFZ5Vg59HYrppv8ZFTVeIzlGqeYSccDYBsWBZ9aXyTAghxj6vnmOTPInMeCYsByXVHl7lMIL9SoeW8ad/d8JLSdorLyg1jxwn5ufXm+7+l/ovEr4W1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJM161Grz/ZXp2fX5Bm6bRAxqWp7ZqCiITNcYb5/lAs=;
 b=rLLzTgOJeyVqt3JA2bYZOdGeEhZtFbRrJ9yAX2xWEunxYJV+AMI/7yGviceR9ASCOctBUU0rvHyUxzO3mi4Qz6nezE0ihNFuxlMN41RsPQGPKgj3jYJeyPaVdi5+ZiO7MrvD9og4SSs9i3rKGOYMcVwc0cJhd6nsgK9J8yU7f+smttRJr5zj+znfKXE9AkM/2LXjnHpCKqIkFSng9p+1XhgNpE8jSUsHvoPi5F498Gw2MyMIRh9rFpvDFF2ngQBICVPU6CDxOrxwp4wBcF/9Xi7+TzUq7fhmeENkUfj19jhn3OVChT6TwfuGvNVsi9Un9yEN7giKuGRV6/2xH5SvWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 MW5PR11MB5761.namprd11.prod.outlook.com (2603:10b6:303:195::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Wed, 17 Dec 2025 08:32:38 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 08:32:38 +0000
Date: Wed, 17 Dec 2025 16:32:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: nVMX: Disallow access to vmcs12 fields that aren't
 supported by "hardware"
Message-ID: <aUJqoJMVoGebFqv4@intel.com>
References: <20251216012918.1707681-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251216012918.1707681-1-seanjc@google.com>
X-ClientProxiedBy: CY5PR18CA0007.namprd18.prod.outlook.com
 (2603:10b6:930:5::31) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|MW5PR11MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 26dbb42a-7d09-4cdb-f92e-08de3d46d5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Vpx33bSFhntFQzx6SDaX/Bab3vvgOUUynbE8Hs+9Qq3Yx0HtD1mcryRA0PPo?=
 =?us-ascii?Q?izrXoA15mXd7kFhpwJrVlQmbOT2JH3ElDwYAFiAxsu4gpktLhdF8gKA/APZM?=
 =?us-ascii?Q?WFJmf+hn97j4TeQUxoN3P6ycWikPSLORwml0liDfTtqd0P7op4dF+8VagTF3?=
 =?us-ascii?Q?3n4M9QSpiKjiSKVFAj7GNJvnQ48XUj7iOXTlZhAzQrg3Nc/2DJstSFJQ0leA?=
 =?us-ascii?Q?3P0CGhc8SSre/NLWPrzLMN45votkM8++kkGJ0Vkl1glVPqrsuWaw1FcIkEIh?=
 =?us-ascii?Q?3LznJOVlYrXBICc9FxbYAZMDjFFdicEf5+dPNAD+qiHrdi2iAwGjqiVYg2cm?=
 =?us-ascii?Q?EclvCLe3P/DqzDUq6uvvyPoy/v6zQO84GFXcEVgiH1TUfOLnB/3b3cja9Mkg?=
 =?us-ascii?Q?rL/xN49UVX8lUm54G9b+G4twFtGF+j6VLfnWDeGCyP+R3pP7KMxyxYY8xuUi?=
 =?us-ascii?Q?zfhbOM8C4mO96xTt0YEaoTQVBqXurGKxgjl0nU9uZCR7AemHnJiQr5zVhx1I?=
 =?us-ascii?Q?XFFM+DK4RH4NT23dZq9FDeHo8NVpLkzTJWhBrnUjWkNBmmntORrVe3v6WSnA?=
 =?us-ascii?Q?L+Uyn7r2N0AJICvxdGCBH0H3U8oOWwoe/tdhufMWU9z+EtkpxeQuAbOf8a26?=
 =?us-ascii?Q?5UVYMmHzHoH2xW7pYqHXzcHe/NoQqAjIvR1unp27CNL0qfEH7MKnBRhiwf3M?=
 =?us-ascii?Q?rsYdUTpihHOEaDjZhpc/LiTzTRuVoXH2i66hVlo0G+A95qK9fBKuFyt9rLPh?=
 =?us-ascii?Q?rpoxDLd9GY1RknXj6u+cniFvP7HJGSTSk1sA1r+u7pzOuG6QFSJ7+t3ewkbS?=
 =?us-ascii?Q?iyUBNQyXT1fWKEkdqqws9BcbDF6zbccHvVq58HyuS73Kd8cu3dRcqqCjiHzF?=
 =?us-ascii?Q?0gWdDoAkBPGkY3ZeMEca/pQ44ZdgYOltuQGbysfi2Pq3BVUJv+3+2B9I/0Ou?=
 =?us-ascii?Q?zmooaEWW9JxMiju5mdMDVtmCH86YXcakMM4Utzzd5S8hu50VfxPxG1Ww+Iv7?=
 =?us-ascii?Q?ayRDBPG96wTHI4mfNIwogOrc3myaOpSEyqqAViNSwftxhiG2gvd0up0mx6wz?=
 =?us-ascii?Q?uwDSJ6+k+vDT/by5+3e9nQW68AdZuUmHcJ7RfoUzgIwTClxmn24gE8LSm5Qz?=
 =?us-ascii?Q?fCuqA0bf+M4KTsZlCwJP78NmAj+5JShbAF5/Bc/GtcQNaeh8RxzSByvVWBj6?=
 =?us-ascii?Q?+FmT3KaH5QDY3oOxafvsqV3Xfi6XuHLa6swo1YIrKZMIW7zhHyVSUKyX7irY?=
 =?us-ascii?Q?6sFfr1QU37FCFmlo/DxrbR9Or8+OndXbmvVbd2eZOKzHimTaE2VNNrL6Oda2?=
 =?us-ascii?Q?GuxEwxOzz/ymDfrxxXt5CPDX6mT7ODIQ4CqC8204MtpFKvXOWNKoruSmstfi?=
 =?us-ascii?Q?3M3INLcwZqXs4AZDJpvmLrBND5mv/6tcUEQxammAYvExIYLlc3QePWjiMAtE?=
 =?us-ascii?Q?3LCFVIByDmuojlz5Lb3JwDnPn31vs1Vv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eOQdO3y9UjTmyRYLkw+pMuqYAMb1NdPXIwufLlo6IZdY3kMMQ5fq0+rYmb4z?=
 =?us-ascii?Q?sT9FLwhDfjbTnYXqY6P9oLjfGB6M91PcVdl8ad11V/XBrLsZJyTALfjX2iH/?=
 =?us-ascii?Q?zSqYTosOefGKhOpQD8f3hhyR6CdaRs3s0Ft77dtw99mTXP9k2FHzEzUhDwSD?=
 =?us-ascii?Q?vkYPsfFnbVAn4lHIi8ctgq2iKvphMj9jdIGlbTwInbKsN9OkW3xGMpUhOdlm?=
 =?us-ascii?Q?Lk2f/lpHf+wVCdFUR80oNyzY1QQS3Wcr8w+O8K+cYZHn0CriQPw77kNZ3vMR?=
 =?us-ascii?Q?nStYOsvA5Gt+I4F2otemeuhzjeFNLrFTUgZc6qrhOtKoHM90tipDnPBm/xZ1?=
 =?us-ascii?Q?oCZMt+UxjEd46nqAFtlNLBKqq0VkuaTSucJkXrjFjxuj6n+r/mwyqm6OLuoH?=
 =?us-ascii?Q?HRNWPW+zl5H8ZsyHeiGhiIOPSTqd9L1k/6xwAyBd0QpA/Z21ngv0h8MldmNe?=
 =?us-ascii?Q?MMKhZ+0tBYX9C6n56Ity4gXWpXbpniQN5Z16WXk3tqXv/TzR6YR0NqcHFVMe?=
 =?us-ascii?Q?TUs2WOcJ6mLVDH5qVMBMIJbnIueqqgvAPRFTVQIOsYOwhy+SkL9gyijc1C97?=
 =?us-ascii?Q?iB5Hg0w+Pb4KF+taZs5ss/D34KdmYSE1W3Li4xPar2yVr3fwY38uHAFPB86z?=
 =?us-ascii?Q?TRBLSpnozVWhPYa6emaSZQLxMjFIHDrs3oKHnXR4WLngPhSoq5tSS8KU/7AF?=
 =?us-ascii?Q?EbxjPxgLhNdP0oMOzPnUGZMvRhEfUQ+MZq6wqeDDql8NAAbPxOfAL9K+Qb3v?=
 =?us-ascii?Q?Ud8Uz0xcU1bWalylMQiNj5+fVlDY3HaAF21jEWHCumVdafUwjJ8Rd3RuPZQD?=
 =?us-ascii?Q?fUgzJboWspWYNVx6MbXhp3YZqFArm+dKau5A2QvLvtQ/YAuqjb2VuRj69Z0h?=
 =?us-ascii?Q?/8a/+oVykl665a9J8NyojJjBRztE620y+w/V8gzArHLi3EKKVx1y6adYHJPi?=
 =?us-ascii?Q?5U2/qaXX9Xnar05fQ6vl28O///hkYsnW8DkPM87o29iYWtk4C2Bcsx1RwqhC?=
 =?us-ascii?Q?/Lm7NN6Qz+hEUjiCjWwJ2yytAE4shPK8Poj20A4b/IpbQkWJO759AdpOelWZ?=
 =?us-ascii?Q?/oYRILDe2VpYpvcorNkGE1G9Nt+KgyrYWdEqKyVoTdMVqgv5sles9g/RTrrX?=
 =?us-ascii?Q?btjNuRLmXpykcp68iQMmosuTR7Jz8xFJHgDm6ndo6NpSro8FZ2eyTsaQDU68?=
 =?us-ascii?Q?h+Qwc/VC4Nmdz6jiv7r0Xm2feKhcybS38mbXd2y28V5Xut/2oYH7xEtV35Ya?=
 =?us-ascii?Q?YiCKXEjCL39wLmlEQhmeXqe1FOeQhKJmMI+65lL33PKmXPiikXJm1sb5pZo9?=
 =?us-ascii?Q?gc4BlZe4jsRr2C0ZR4xo8D1k6P5CA+4RGfgyYUkOsLT59zNS2Dr3IO6PNzBW?=
 =?us-ascii?Q?5WYgitzbkrdzgiPC/643d7YjOq5zPbcY9pfVyCHMhyobq/lljmsIPe7kA4Ue?=
 =?us-ascii?Q?ad8dtCJ7yqod3sQd/AitpUxMICFPZcUFwuhyBEpYGi4tKXvnFAa2/1Z03vaV?=
 =?us-ascii?Q?pCWZ+XwGf+A7FKmxSo51AthfQvgAFuKF6WGj0LT/EdiA9f89PKZT4CYL+LHb?=
 =?us-ascii?Q?ETAwz9RXYALiCHMc5IBs0e3XCVcN6uTieEun7h2M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26dbb42a-7d09-4cdb-f92e-08de3d46d5f6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 08:32:38.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43x/OMg4sg7jnHIUSP8DWibO5Sr9SfBTkkopLm6aJAfGuSkTgpeRHg0aaRDteCI1nlVUgJG9cE8HZOzhDrUZUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5761
X-OriginatorOrg: intel.com

>+static __init bool cpu_has_vmcs12_field(unsigned int idx)
>+{
>+	switch (VMCS12_IDX_TO_ENC(idx)) {
>+	case VIRTUAL_PROCESSOR_ID: return cpu_has_vmx_vpid();
>+	case POSTED_INTR_NV: return cpu_has_vmx_posted_intr();
>+	VMCS12_CASE64(TSC_MULTIPLIER): return cpu_has_vmx_tsc_scaling();
>+	VMCS12_CASE64(VIRTUAL_APIC_PAGE_ADDR): return cpu_has_vmx_tpr_shadow();
>+	VMCS12_CASE64(APIC_ACCESS_ADDR): return cpu_has_vmx_virtualize_apic_accesses();
>+	VMCS12_CASE64(POSTED_INTR_DESC_ADDR): return cpu_has_vmx_posted_intr();
>+	VMCS12_CASE64(VM_FUNCTION_CONTROL): return cpu_has_vmx_vmfunc();
>+	VMCS12_CASE64(EPT_POINTER): return cpu_has_vmx_ept();
>+	VMCS12_CASE64(EPTP_LIST_ADDRESS): return cpu_has_vmx_vmfunc();
>+	VMCS12_CASE64(XSS_EXIT_BITMAP): return cpu_has_vmx_xsaves();
>+	VMCS12_CASE64(ENCLS_EXITING_BITMAP): return cpu_has_vmx_encls_vmexit();
>+	VMCS12_CASE64(GUEST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
>+	VMCS12_CASE64(HOST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
>+	case TPR_THRESHOLD: return cpu_has_vmx_tpr_shadow();
>+	case SECONDARY_VM_EXEC_CONTROL: return cpu_has_secondary_exec_ctrls();
>+	case GUEST_S_CET: return cpu_has_load_cet_ctrl();
>+	case GUEST_SSP: return cpu_has_load_cet_ctrl();
>+	case GUEST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
>+	case HOST_S_CET: return cpu_has_load_cet_ctrl();
>+	case HOST_SSP: return cpu_has_load_cet_ctrl();
>+	case HOST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();

Most fields here are not shadowed, e.g., CET-related fields. So, the plan is
that new fields should be added here regardless of whether they are shadowed or
not, right?

And GUEST_INTR_STATUS is missing here. It depends on APICv and is handled
explicitly in init_vmcs_shadow_fields().

>+
>+	/* KVM always emulates PML and the VMX preemption timer in software. */
>+	case GUEST_PML_INDEX:
>+	case VMX_PREEMPTION_TIMER_VALUE:
>+	default:
>+		return true;
>+	}
>+}
>+
>+void __init nested_vmx_setup_vmcs12_fields(void)
>+{
>+	unsigned int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(supported_vmcs12_field_offsets); i++) {
>+		if (!supported_vmcs12_field_offsets[i] ||
>+		    !cpu_has_vmcs12_field(i))
>+			continue;
>+
>+		vmcs12_field_offsets[i] = supported_vmcs12_field_offsets[i];
>+		nr_vmcs12_fields = i + 1;
>+	}
>+}
>diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
>index 4ad6b16525b9..e5905ba0bb42 100644
>--- a/arch/x86/kvm/vmx/vmcs12.h
>+++ b/arch/x86/kvm/vmx/vmcs12.h
>@@ -374,8 +374,12 @@ static inline void vmx_check_vmcs12_offsets(void)
> 	CHECK_OFFSET(guest_pml_index, 996);
> }
> 
>-extern const unsigned short vmcs12_field_offsets[];
>-extern const unsigned int nr_vmcs12_fields;
>+extern const __initconst u16 supported_vmcs12_field_offsets[];

No need to extern supported_vmcs12_field_offsets since it's only used in
vmcs12.c.

>+
>+extern u16 vmcs12_field_offsets[] __ro_after_init;
>+extern unsigned int nr_vmcs12_fields __ro_after_init;
>+
>+void __init nested_vmx_setup_vmcs12_fields(void);
> 
> static inline short get_vmcs12_field_offset(unsigned long field)
> {
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 6b96f7aea20b..e5ad3853f51d 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8670,6 +8670,8 @@ __init int vmx_hardware_setup(void)
> 	 * can hide/show features based on kvm_cpu_cap_has().
> 	 */
> 	if (nested) {
>+		nested_vmx_setup_vmcs12_fields();
>+
> 		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
> 
> 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
>
>base-commit: 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
>-- 
>2.52.0.239.gd5f0c6e74e-goog
>
>

