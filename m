Return-Path: <kvm+bounces-12210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB98880A8F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 06:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B67F91C21664
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 05:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5EC14F75;
	Wed, 20 Mar 2024 05:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+HudN/n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032D512E40;
	Wed, 20 Mar 2024 05:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710911543; cv=fail; b=ik15mRp0WQMCO//s0G1c9YGIDnddc1TlScb/BTt2ddVQFxdR5RWMhiWEe3k2h5uPjFklfryho3ltsHWLhXmfV3VJUIZzXLjNOWGazHlIq3CzwowDybOkS9yfwOjg9LlDZ9dLfdBO9tIupy0LchU/6jhbsZtsqTF+eGZ6S4oMfOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710911543; c=relaxed/simple;
	bh=Osrk/+WnpZa02Eb7Xy14qM7uxnhTiTETqIdPwt/m9gg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RqQFQ/FYCzBTQOBFoU1+jMJSm1CPFH+eDCx+6Z73PkndvAclsbDXUanFGmf0oSce8OvPl5RUIOC89GdbbXbaYePAA9SgKf4kLij/9b1kBkZ5LuNpKqicllm1y+2CprdmwHVPGu4UtuyzQmXjtlARiilFm2+W101yLRL2YkY4gKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+HudN/n; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710911541; x=1742447541;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Osrk/+WnpZa02Eb7Xy14qM7uxnhTiTETqIdPwt/m9gg=;
  b=J+HudN/nnOBoBSw5yK1ovVu+0r0tRu01EyrEKt0e8JNxVDkBoJwdBKoc
   Lkggtc+TrT6O/AVeeCfpttWC2EEI5JMtqBIR1F/0rz6Tq7HXF/EEFsKd8
   QqJoDMeD7xWX+klBSTxpspnv3ozr8cSaT7LGdZ/eQQo/MDqcxrFOwgEVT
   dWGfuZY4K+90/Lpq0jNWC87ObtShOxv1KlM+4AknWRZjJQ9szOv/sE5xQ
   jTBgJWns95OaQQMTKYVBkXWvT0W7lgVbi0EHgDtLLUAuEfR7vVj0lTwob
   SETqSrY0/dd1cnWSW8SSqFjNiUwXA+862w/XChnWhuK8qZhHiTIeeazpr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="28292350"
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="28292350"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 22:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="13945446"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 22:12:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 22:12:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 22:12:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 22:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jj5utcjeC8wqqJTgwWjcXED7oFqY+OIpDRu8dRPAoWhYQKnaHon0uIH8GT+fmnOTgL4YRnX61tF6xzFx0kTrnBkKX3QcZJDnxHB9+tpSBQfN+L2akUOcasrYaWhE5/F2TjMHIq+x+xuCq8Ueif4Ws7cHNHK5JbYvDoWAnQv3g4cLHwxEPj8Hujfyn+K5qEASDtkxEsiOJ7tF8Nq4klE1kOYH5ceV4Cz4mYVqpijIwgHuQ4Bt/oY+SQRH/u8rk6yTexO1K3Ajch4d5lfyeZt5M1joyUX3xZF3OBTokqUHsrj3gNPk02SwbwLEu6Dlq6SdgOZhJlb6FMYARr5NmcRkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPuHS/fJmN7PTVLEBOeWnD6cfiojBjgZFeCqIJ6xt98=;
 b=DenIO7Jdnj9HBrMwMP9tA5eJ7//kfW6XYyt9hzwOUxwR81deiRbcIdOUbhYesEJGUIIZGebPTyxuxkzYS/GXGPNXve0nFEf910A8sQ2uNlqy5vIerEsDv2usap8Z+CHQTTrCLcTjZAfA9I9eyntZY7Iknd6VPVtWhF95bYfMYALQKfc2x1jjUXXLqCjdX1NycdGXhX+dtSlAQdJgylpz5XUZHGm/7WLmYyHx4KXmVU5cUTJkQcKPdkKdsIc7SYsRAytY2Q1mISz3D3Dc+Pkfi5bLBk2LN43EaFQiGWOBFwKFxq2SDxFyjO63cIIBjJMISuR/bJBCRlofTyZuTZkQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6172.namprd11.prod.outlook.com (2603:10b6:208:3e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 05:12:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 05:12:12 +0000
Date: Wed, 20 Mar 2024 13:12:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <ZfpwIespKy8qxWWE@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9ee92e-63d8-44e6-8516-08dc489c4c6b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtJj8XOVtdwPDldYDHwGyHo19CACIsqUgwot6uP2sazavwhOMPR31UPflpgrlC8yZdhAz2ph8Biq/UI1sCnPTF9cnRzyABkJhbj+0hBv0qcbpRwhuU2bWu57HS3V6SFwz4RA1LyMvKCFZs+iyNtXKACXQC00CLJdKtvAe9eIwiCM0txZ0+7Tq0hYgswUybw55dl1JqWAoT71wkDluLcrBSLL3R6lj1YWRyVNUIkd3VQQkBJeEoqBt836s9kI9hSYXvx1IQ40wHDlmScZcPQv4D6zKZLiYrGmBBN/mevFZQ5tPYzRugfIdrALf4C9XtAIZ72Zs26AVBYCbxZMHsTdd85UeukGilGX6mi11PDQLbufv9xUNhrdnGQIZkeu1CgPZTqUQlImomIMZGpTM0/kyjwjxC4zqcGTdnPzi/6jIh82IpOTFTB7pGQLEO4Xnx1CN+8IfXC6ST2TwF5kZszhAU3s8Dx16pqSPUFY6kiHQxXBiJ5c899zHZ7eS4/6przLl5dW3KIXiFfHSPW3i84QAOIpN8s/Y89IEEJIGbsUoZ3ufuSusNr6CE4F3/Cog+ekXtS+CLp5e20sDteC43X1Ic+yK2b6sBLnTLnmX+0FkbipyYxv5KX7M+B+drScgHFASOUSydEG4FHv+xZumsmASgQFR9op0tNUTg0ct8FViUU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eWU+k/1MN1OVqSeGmzfhs5ucIRvnG9vqay1X21Dp57y0/m78AD/Koj7oOkbi?=
 =?us-ascii?Q?aRAJYNYFewOFpL47BCS0j/31huT4ziU1/OrJjLKUUs+me/YzURpxoYt1gubd?=
 =?us-ascii?Q?gGoCerHFmLnH1tFEA3pVnxkTEkzfr5GsfrOajeZSwTxbmGyPzpemwwEU2cG3?=
 =?us-ascii?Q?hvKF+b1DcaIt3htZWgvGfGQTlhy+geThaaJRxP6AqcP4aRltpwHnEz3zDEn7?=
 =?us-ascii?Q?rdF5fV9zMlhTSE93s47KNdOKWB2bZP6tSfQOz02HmAMc6bfgnmSWPkyV3IEF?=
 =?us-ascii?Q?z05pMaop7YLPdu5QR/FsvkZ+w4nArNdP63CTEZCbUiRuN0uwFf6BnF/aggv5?=
 =?us-ascii?Q?sPCARN9ihkJdFnEjyFaQ9QtWkDlfdjcmNurOTYbirg35Ywp3clc4grrSI23G?=
 =?us-ascii?Q?cmZmCXGu2lQj2DjHyJP7VryxFRSTYYwNZsshUMJtzxQ6/iVzkCFxr1EYOil0?=
 =?us-ascii?Q?wDI63CkZdLxOvgqtexhVay8UhMmARBOOMDuqMwhTl5ONtbyfqzm7H+Mvb6E4?=
 =?us-ascii?Q?66d8kJce+N/T2GEK9y86Sds0CivBwFmOy9likY3SaMzoCSO/hO5ug2YgAshd?=
 =?us-ascii?Q?qFKSxgaHi+tSO+WuiDfByO+PpYcWG6cMHXCEtoPP1EVSPj/+L3OviRtx/lzL?=
 =?us-ascii?Q?Gkusj8BYBEKYvgjuT4BJxEiQGNmGXimPtJr4om2bfbG19BCPBQITjnazpbdx?=
 =?us-ascii?Q?jT8/qfC0ahy1xa0vh/pB8ZaJRQsr6ZlNXu5LRWaH9bg3hdilar/+W2pS1zhK?=
 =?us-ascii?Q?i6CUyU/xVtR9pZ3k4ynaFmsvIfaywe49jic/QtfxCh4sFGLWEgJ2qlfjAAjW?=
 =?us-ascii?Q?S7Zu3XNPEoNKVzZ6samha+VDqFUs6eqVWS7PGqlxDacLmOl87NkT49qK9/WR?=
 =?us-ascii?Q?HFlfxxeww2fsFUkge5QU1lWYt+yeFVlaSyJhmoieLAutl2/WDAToi9xxmkdy?=
 =?us-ascii?Q?k2UmLKVGvu4dfB7sm5hmVRCljRJ4ILx05vMUduZga1tpQiLHPU6QzW04+8Wc?=
 =?us-ascii?Q?82XvQCCxxM/jnpRiuRLmMB2ANvmpODCt6nTFUyUFEKqsUdypuajg5bRDkggt?=
 =?us-ascii?Q?Hv3yZlsipETtOC/xD7alrQD5T5CaFL2R2vgHGYRZMO1+BRFZ7rpTEtjQaPBi?=
 =?us-ascii?Q?otY8+/yaeuQ5xZ1gqTnwofNj+bxEr9IdSrzwriMvL1bbpnWCZTLZvnhh/bsj?=
 =?us-ascii?Q?se+cZniw2D7+5BQwS0Hgr7pxtt7CYIGLBL3SPotRPsH+9+4bcgZx4UaBKSFY?=
 =?us-ascii?Q?6rOK8nnwdDxOMSpEaDCHv4fntnr/mytH8qpZh/VuTpSjXuSygxrJ81vcjJJ8?=
 =?us-ascii?Q?o1x2eNvqdl3ILsX+Fq0rwmr7nb8EIfzowm6OWUexfkFDfPx/69hI4nN6sAVc?=
 =?us-ascii?Q?d7C2GiecZPrPril1pSiPRGQKIyqaqkzZLAijgrwPE4XCPC+KFlVp8TSEWelP?=
 =?us-ascii?Q?3w3JfAk1eKqtLff1okYWJrq+ctesMESROanWTcDya3XxMFj9LqrgDIwnbL0k?=
 =?us-ascii?Q?BRZsvdL1OJKQ2knLqqiAEHuFaygUUnGBsDjQzQVdEEt/WyiNFWONr3tWMjZx?=
 =?us-ascii?Q?/693QRl9COp4l+UOOlMOAIbQQ4Mmwau29o7KDlcN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9ee92e-63d8-44e6-8516-08dc489c4c6b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 05:12:11.8663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLmR255f87aCu5+AXrwDnq5TpUJzZTWKiziJreyTe01hZeRLxd1WRNhHQ7/5mR3x4uwrXvVAb69aj3KFVQiDTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6172
X-OriginatorOrg: intel.com

> config KVM_SW_PROTECTED_VM
> 	bool "Enable support for KVM software-protected VMs"
>-	depends on EXPERT
> 	depends on KVM && X86_64
> 	select KVM_GENERIC_PRIVATE_MEM
> 	help
>@@ -89,6 +88,8 @@ config KVM_SW_PROTECTED_VM
> config KVM_INTEL
> 	tristate "KVM for Intel (and compatible) processors support"
> 	depends on KVM && IA32_FEAT_CTL
>+	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST

why does INTEL_TDX_HOST select KVM_SW_PROTECTED_VM?

>+	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
> 	help
> 	.vcpu_precreate = vmx_vcpu_precreate,
> 	.vcpu_create = vmx_vcpu_create,

>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -5,10 +5,11 @@
> 
> #include "capabilities.h"
> #include "x86_ops.h"
>-#include "x86.h"
> #include "mmu.h"
> #include "tdx_arch.h"
> #include "tdx.h"
>+#include "tdx_ops.h"
>+#include "x86.h"

any reason to reorder x86.h?

>+static void tdx_do_tdh_phymem_cache_wb(void *unused)
>+{
>+	u64 err = 0;
>+
>+	do {
>+		err = tdh_phymem_cache_wb(!!err);
>+	} while (err == TDX_INTERRUPTED_RESUMABLE);
>+
>+	/* Other thread may have done for us. */
>+	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
>+		err = TDX_SUCCESS;
>+	if (WARN_ON_ONCE(err))
>+		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
>+}
>+
>+void tdx_mmu_release_hkid(struct kvm *kvm)
>+{
>+	bool packages_allocated, targets_allocated;
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>+	cpumask_var_t packages, targets;
>+	u64 err;
>+	int i;
>+
>+	if (!is_hkid_assigned(kvm_tdx))
>+		return;
>+
>+	if (!is_td_created(kvm_tdx)) {
>+		tdx_hkid_free(kvm_tdx);
>+		return;
>+	}
>+
>+	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
>+	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
>+	cpus_read_lock();
>+
>+	/*
>+	 * We can destroy multiple guest TDs simultaneously.  Prevent
>+	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
>+	 */
>+	mutex_lock(&tdx_lock);
>+
>+	/*
>+	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
>+	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable.  Make the transition atomic
>+	 * to other functions to operate private pages and Secure-EPT pages.
>+	 *
>+	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
>+	 * This function is called via mmu notifier, mmu_release().
>+	 * kvm_gmem_release() is called via fput() on process exit.
>+	 */
>+	write_lock(&kvm->mmu_lock);
>+
>+	for_each_online_cpu(i) {
>+		if (packages_allocated &&
>+		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
>+					     packages))
>+			continue;
>+		if (targets_allocated)
>+			cpumask_set_cpu(i, targets);
>+	}
>+	if (targets_allocated)
>+		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, true);
>+	else
>+		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, true);

This tries flush cache on all CPUs when we run out of memory. I am not sure if
it is the best solution. A simple solution is just use two global bitmaps.

And current logic isn't optimal. e.g., if packages_allocated is true while
targets_allocated is false, then we will fill in the packages bitmap but don't
use it at all.

That said, I prefer to optimize the rare case in a separate patch. We can just use
two global bitmaps or let the flush fail here just as you are doing below on
seamcall failure.

>+	/*
>+	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
>+	 * tdh_mng_key_freeid() will fail.
>+	 */
>+	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
>+	if (WARN_ON_ONCE(err)) {
>+		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
>+		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
>+		       kvm_tdx->hkid);
>+	} else
>+		tdx_hkid_free(kvm_tdx);

curly brackets are missing.

>+
>+	write_unlock(&kvm->mmu_lock);
>+	mutex_unlock(&tdx_lock);
>+	cpus_read_unlock();
>+	free_cpumask_var(targets);
>+	free_cpumask_var(packages);
>+}
>+

>+static int __tdx_td_init(struct kvm *kvm)
>+{
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>+	cpumask_var_t packages;
>+	unsigned long *tdcs_pa = NULL;
>+	unsigned long tdr_pa = 0;
>+	unsigned long va;
>+	int ret, i;
>+	u64 err;
>+
>+	ret = tdx_guest_keyid_alloc();
>+	if (ret < 0)
>+		return ret;
>+	kvm_tdx->hkid = ret;
>+
>+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
>+	if (!va)
>+		goto free_hkid;
>+	tdr_pa = __pa(va);
>+
>+	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
>+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>+	if (!tdcs_pa)
>+		goto free_tdr;
>+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
>+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
>+		if (!va)
>+			goto free_tdcs;
>+		tdcs_pa[i] = __pa(va);
>+	}
>+
>+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
>+		ret = -ENOMEM;
>+		goto free_tdcs;
>+	}
>+	cpus_read_lock();
>+	/*
>+	 * Need at least one CPU of the package to be online in order to
>+	 * program all packages for host key id.  Check it.
>+	 */
>+	for_each_present_cpu(i)
>+		cpumask_set_cpu(topology_physical_package_id(i), packages);
>+	for_each_online_cpu(i)
>+		cpumask_clear_cpu(topology_physical_package_id(i), packages);
>+	if (!cpumask_empty(packages)) {
>+		ret = -EIO;
>+		/*
>+		 * Because it's hard for human operator to figure out the
>+		 * reason, warn it.
>+		 */
>+#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
>+		pr_warn_ratelimited(MSG_ALLPKG);
>+		goto free_packages;
>+	}
>+
>+	/*
>+	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
>+	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
>+	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
>+	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
>+	 * caller to handle the contention.  This is because of time limitation
>+	 * usable inside the TDX module and OS/VMM knows better about process
>+	 * scheduling.
>+	 *
>+	 * APIs to acquire the lock of KOT:
>+	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
>+	 * TDH.PHYMEM.CACHE.WB.
>+	 */
>+	mutex_lock(&tdx_lock);
>+	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
>+	mutex_unlock(&tdx_lock);
>+	if (err == TDX_RND_NO_ENTROPY) {
>+		ret = -EAGAIN;
>+		goto free_packages;
>+	}
>+	if (WARN_ON_ONCE(err)) {
>+		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
>+		ret = -EIO;
>+		goto free_packages;
>+	}
>+	kvm_tdx->tdr_pa = tdr_pa;
>+
>+	for_each_online_cpu(i) {
>+		int pkg = topology_physical_package_id(i);
>+
>+		if (cpumask_test_and_set_cpu(pkg, packages))
>+			continue;
>+
>+		/*
>+		 * Program the memory controller in the package with an
>+		 * encryption key associated to a TDX private host key id
>+		 * assigned to this TDR.  Concurrent operations on same memory
>+		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
>+		 * mutex.
>+		 */
>+		mutex_lock(&tdx_mng_key_config_lock[pkg]);

the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
create TDs, the same set of CPUs (the first online CPU of each package) will be
selected to configure the key because of the cpumask_test_and_set_cpu() above.
it means, we never have two CPUs in the same socket trying to program the key,
i.e., no concurrent calls.

>+		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
>+				      &kvm_tdx->tdr_pa, true);
>+		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
>+		if (ret)
>+			break;
>+	}
>+	cpus_read_unlock();
>+	free_cpumask_var(packages);
>+	if (ret) {
>+		i = 0;
>+		goto teardown;
>+	}
>+
>+	kvm_tdx->tdcs_pa = tdcs_pa;
>+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
>+		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
>+		if (err == TDX_RND_NO_ENTROPY) {
>+			/* Here it's hard to allow userspace to retry. */
>+			ret = -EBUSY;
>+			goto teardown;
>+		}
>+		if (WARN_ON_ONCE(err)) {
>+			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
>+			ret = -EIO;
>+			goto teardown;
>+		}
>+	}
>+
>+	/*
>+	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
>+	 * ioctl() to define the configure CPUID values for the TD.
>+	 */
>+	return 0;
>+
>+	/*
>+	 * The sequence for freeing resources from a partially initialized TD
>+	 * varies based on where in the initialization flow failure occurred.
>+	 * Simply use the full teardown and destroy, which naturally play nice
>+	 * with partial initialization.
>+	 */
>+teardown:
>+	for (; i < tdx_info->nr_tdcs_pages; i++) {
>+		if (tdcs_pa[i]) {
>+			free_page((unsigned long)__va(tdcs_pa[i]));
>+			tdcs_pa[i] = 0;
>+		}
>+	}
>+	if (!kvm_tdx->tdcs_pa)
>+		kfree(tdcs_pa);
>+	tdx_mmu_release_hkid(kvm);
>+	tdx_vm_free(kvm);
>+	return ret;
>+
>+free_packages:
>+	cpus_read_unlock();
>+	free_cpumask_var(packages);
>+free_tdcs:
>+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
>+		if (tdcs_pa[i])
>+			free_page((unsigned long)__va(tdcs_pa[i]));
>+	}
>+	kfree(tdcs_pa);
>+	kvm_tdx->tdcs_pa = NULL;
>+
>+free_tdr:
>+	if (tdr_pa)
>+		free_page((unsigned long)__va(tdr_pa));
>+	kvm_tdx->tdr_pa = 0;
>+free_hkid:
>+	if (is_hkid_assigned(kvm_tdx))

IIUC, this is always true because you just return if keyid
allocation fails.

	>+	ret = tdx_guest_keyid_alloc();
	>+	if (ret < 0)
	>+		return ret;
	>+	kvm_tdx->hkid = ret;
	>+
	>+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
	>+	if (!va)
	>+		goto free_hkid;

>+		tdx_hkid_free(kvm_tdx);
>+	return ret;
>+}

