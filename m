Return-Path: <kvm+bounces-12947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 262DC88F5C2
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8AFC293AF1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D82417BB9;
	Thu, 28 Mar 2024 03:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jCLmpcyU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0595F28DD5;
	Thu, 28 Mar 2024 03:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595592; cv=fail; b=IeE4+9NLz0iXGu1l0+zvhYdu8u80kVgfvPXqEOF/PJWgXjLZ91l/pBO3NZ3trZNZbn1kRPdftrPe1/+nCF55ipmmwCpbD5QrtWeTvMgVX8vRa3GUXdh1U6OypiHhlX1TsPfDFxPesYQhEXq6ZKL5dDlR4tk52BFjDjZKHM78K0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595592; c=relaxed/simple;
	bh=aW1xeoEBB9Bxn5XXKk+POxbVB6W0InhqMVX3FrYRw88=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rdmmXk14pSFupeRb5xgUgf1/IGG19a5X1HnunmBxBouDhNxbmbpdt1ub8c7unun/AzDZTS/OIEX5Brye8XfBcmlOglgFwkb0VnZ6Gh10lOX5ENJgvskOfesj32SpXyeMnqJTaT6ra4/90s7HBbeVAcxNcQSUvQ5cY6CRQrXaocQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jCLmpcyU; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711595591; x=1743131591;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aW1xeoEBB9Bxn5XXKk+POxbVB6W0InhqMVX3FrYRw88=;
  b=jCLmpcyU8rClHelEMC8rS+6bDoh/tD8/XAn2UE6HBDS/9O+BXZcCZ0WM
   91cPq+xEhxH9rvEdCxnWAFFQPCWTsgLX1PMxXbqBhxBVGZCVaankb7cll
   QaFPgjz5azZyrPpVVF5egK6KoLdAtSYKiWX5qZQSRvk8tYKmmaUJp9AIT
   Iw5ASMNRYo7P8fMacgVRjoLpNSGF11kz5Jn0bIrEkHif6LYcUgMTlfioP
   8HBkayQAAHOld3sQACcrd//8bZSh27dES8MmmWs4obor2frFdO0cVzx9B
   05aoBmo27CMMiWUPNMxTv/0qJZcGz6HaJ5KgGPXNbaVkQ9/swpiC0bJL7
   w==;
X-CSE-ConnectionGUID: dRFwOtr/QFWxngu/I6yAnA==
X-CSE-MsgGUID: zbfRSzqeSmabdqdta+Mp0g==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10522542"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="10522542"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:13:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21151980"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:13:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:13:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:13:09 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:13:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccY7YenTChIkZbWcHc2KvRmdAUJlQqTLgr/TEYEHRto1dzmZDo/MAdxjQGd1egZS6KFm1I4+bZdLTrdOrV5q8oANCmF6bDR2CCjUdHcyCDzMjq27ER8u9reikxeCghOu2bj+35bu469mi6Idyb8PIeZdGXOvMv/fXGoNFQoLAGwO4GyEzSd2719fV6F8HwxjV67gHC8s4/kJHGHoghBNnw8Xc/QJafsUhlSrC6kgx6CV3YRYQO9bjw78vp58kk7vT593vRd49D6PCrsVPgR3IR3RAh65rG52LfuQF0HiQbSQtht4ovIJntrmtKs7TXooewCCgT3csOKzzf8StSylNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Anm0/6VtooLnWyNYZluXJAXEflQ1QJlvwKUedXlKAWE=;
 b=myPSZ9Bm8hn7aigsF6ZNJ4gNxzhJG6qcFwE90Mc1aeDU4LqAu4vzafl5zFE1W/tnxYVpLYAbYI3F8hnZrc9hiHb/yJrJ6w0G3lupFCks1zq2zNyj29aFFWB0KC3Y/zCurRZqCXMcYQ1jHhkzdqhO1Li1TWO/uLmwwcY01QnFRrB6HWZZ1carnHcnHqaKXmXXW7TKdDhNvIjWjevvu9EIkZrSkhtvHtsCYZRIhi/KKhtNibk708DsnYZPwSEOa1cB0TNFZNIpvjMltzUDLHqq/UQUxwh8yx++1GhkQPusFDWvyItmxlebjnEOX0AmpFae4pFlxiB6a3oTcVe7fmNQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 03:13:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 03:13:07 +0000
Date: Thu, 28 Mar 2024 11:12:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Message-ID: <ZgTgOVNmyVVgfvFM@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dfeccf4-9731-4d0b-51f6-08dc4ed4fd6d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9O4IrDZrhqQCCVYOCc3hgHy0ZtHq56I8fz+PSgWZ5bnZXA8hN/sBbTqs8H9i13Q6mH8kDdasGpD+KD4uSUbGAtzYINYwJuQ4J5RJN5vHs4LJrk8MLSTtYXvpRRd84Z8sZrx0LgfxVIXVqXjxNSEoGzzm7thj3Mc3FjQNL/+96g9LaIZMywmqHWcHJh7LYw70R9xKy4TJ5eZlQWkbI9hULP/KPU2G+Iyk1CfTyUR1K43NX4xiX46Rrd69/I12j5ufGcZtu0T0ib0PRZ33hZenjIyRrdtbo19ulljvghomYoWZtjmv+AQe+1xQre902uyFcOu+lErWHyL6JIuXpvQM2B/EKVo8ZWYSjAapL7zh15hAvAFFUKsWiwDZZ3eyuzNUie7xK5SHxAw2r9jqjM2RCGHuVubSiuVEsSPiWHM7NeN4+cSlRNfY4UCV78NhxDKt7snhGlIYhZS6AQ9OnBPAvfTMqBvwWeUrc6nC2U36buCXO+/b9srriw61jCTdFVLCzvr9+NT3qFwOpwqtlUgdcK4TsoJ1ajJhdrS6c/ZTarRjCHPZ4CpoX+6+NUzicCxozCkmv61FrpOBKFfZcjwX83IBJydhAmHn7soA4NCPzQXmyReRpsQ3b2+gFsvwOlJgds6qs99XRYqbOt8RVEOqQoIiKbKO1a+ez31iBIhYSA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6MyZCXjZZiGN+ccYeReW3+pEyN8AbnsTdlnYT8cUIrTgcE9Us02uzkskt/TN?=
 =?us-ascii?Q?NVVyFQvJMrwn5KNF1G4PoDu5FO5bitRDMl9qLQHx1vqXH+siPoHjBZ15cgWL?=
 =?us-ascii?Q?uZFidC2imP4mDpEF64LL7CPW0aKc2YeUBFIfxAlHcVHR00UIyJ3QCwJtUz0j?=
 =?us-ascii?Q?hnkHR+IjOkopeh4iF5mSKes2SUSQdEu12wsMsLWDZtpyLDQ9c0cPGrO+DaD/?=
 =?us-ascii?Q?N6u9UpPlo1z/82a/WPsk8+v8Mrod8hYXdP0nPIAqCFI7122LpfTdUcsj8HyO?=
 =?us-ascii?Q?dD0DrNKAL1oIz2FMJHR5/H2PZFsDUBn+dnWhfO/Sseemr5PQzYpC/NRsyOJ7?=
 =?us-ascii?Q?qZHRQUYvEi9ox6qYheQvS0Zsn8AlQ61jeJtNZ4+TVIgh8ic2n3mW7lb5Tsio?=
 =?us-ascii?Q?9rpLC/YoqilpxgRABwaLhTBId4G9IOoFMn5fQXjooenXVDcdk9sicbJkes87?=
 =?us-ascii?Q?TETpHjpZ17qmFygQLNKu7q9W5gy6p6HLIMNGPMCy4oQho+H5mo3fSDp6yvcZ?=
 =?us-ascii?Q?p+dU/YegrFKQ9hBJgC5i3ZOZMpUQASrrRb2ROaSFVHvjlmrAQWwkSL11g2O7?=
 =?us-ascii?Q?DJmdmvY9ft202av/sp3ftnaEONA+I+EfY1+/4xEaBz/Sxn4nzXy0Oez+lWtI?=
 =?us-ascii?Q?bFpVy29hcBSykl4p9BoPqIZrzdxWp0LT4MbWf3oDTmARpLevP690l9iuFTu9?=
 =?us-ascii?Q?j7f0NTR3IGyhOwuUAWPGaJVqJ0mWGQvVaecxVSrGZfIYUVNOR5nTVGAvY/uW?=
 =?us-ascii?Q?MN+FJw7gQUOQStG2TnU2KIyUbBBvNU+HotqN1cTbCmUBZ+kpgu/4RLKijeFc?=
 =?us-ascii?Q?eTx2diBVtiZBd9Mr6Lb6Opmv5mD7rUYp25LxJXtmqWKknA/gAnuFbYK0dhvm?=
 =?us-ascii?Q?00hfQZzRt+DJLNupEf8mBYzjmuG6OLFfyUrg+jHdVF1lfAmnhMUA3OxhhYwS?=
 =?us-ascii?Q?B0sU1LUUJ0iSXVM1rRM82Hbza0dX/geFkhIMaRs4PHWLUdmZyF2Xdeg0+pxw?=
 =?us-ascii?Q?FFTMUdQT6ohVox/+uvDEIRExpe4l4KoxSy694VE+CjZwXJG6VDauVipGC7cg?=
 =?us-ascii?Q?ssO7a3R+EiQfhWIF/erFkOR2JDbrkKF7G1fqUzP/sMIhgGuIynxZurOz128T?=
 =?us-ascii?Q?5oR/JPFA6mb4W/MCsEkDsBywbBZULVRVVFJgsag37r73m9MgVbR4fHOaQvPc?=
 =?us-ascii?Q?rJXSMg9KJ8NrzFCFVuEAKBbHWJbI0sAv9OAplUoYjTtsYCkCDTcBPrHSTIDF?=
 =?us-ascii?Q?a9HVs4pQsgB2CeJrwOeeoXqef3u1cUuPVl0RD7tXbtCjzz4/w0yqzC9kEomI?=
 =?us-ascii?Q?WpRVHICnpnqlVIvVtV3ELS7FM0AkTtEfYIwI1DoyH7r0eNS4hT/0WRwpXSar?=
 =?us-ascii?Q?y7KDu3k9vVdOuOfIgXUWIHw40fywqeyJa56drvRSzIwY7n+7WFbmrnAdxoHX?=
 =?us-ascii?Q?VcirMepHP37UqXPb2LVVTi0ToPsVqhOwb/+KPOePgUUSlDk0El9iD3Iaju2i?=
 =?us-ascii?Q?KMFQMmIdhtU++7dTCtTTXiEfI8zC+HO5wHSzAYAPVwBQy539JULOeM49TGT1?=
 =?us-ascii?Q?6PCKpjY5aKySDmYLDh9NR7sorxnkn/o3mJH9W5pW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfeccf4-9731-4d0b-51f6-08dc4ed4fd6d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 03:13:07.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgBQGtNxWkM+PujbBHTkXSr50hbxkpNo3xhQYZPQJuMX4QjFk0wlO1Diq7vAO656DzaiRl3bC9tWwH7xjPJwLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6392
X-OriginatorOrg: intel.com

>+#if IS_ENABLED(CONFIG_HYPERV)
>+static int vt_flush_remote_tlbs(struct kvm *kvm);
>+#endif
>+
> static __init int vt_hardware_setup(void)
> {
> 	int ret;
>@@ -49,11 +53,29 @@ static __init int vt_hardware_setup(void)
> 		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> 	}
> 
>+#if IS_ENABLED(CONFIG_HYPERV)
>+	/*
>+	 * TDX KVM overrides flush_remote_tlbs method and assumes
>+	 * flush_remote_tlbs_range = NULL that falls back to
>+	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
>+	 */
>+	if (vt_x86_ops.flush_remote_tlbs ||
>+	    vt_x86_ops.flush_remote_tlbs_range) {
>+		enable_tdx = false;
>+		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
>+	}
>+#endif
>+
> 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> 	if (enable_tdx)
> 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> 					   sizeof(struct kvm_tdx));
> 
>+#if IS_ENABLED(CONFIG_HYPERV)
>+	if (enable_tdx)
>+		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;

Is this hook necessary/beneficial to TDX?

if no, we can leave .flush_remote_tlbs as NULL. if yes, we should do:

struct kvm_x86_ops {
...
#if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(TDX...)
	int  (*flush_remote_tlbs)(struct kvm *kvm);
	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
					gfn_t nr_pages);
#endif

