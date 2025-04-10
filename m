Return-Path: <kvm+bounces-43052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7459BA837F5
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 06:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29A657B0433
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 04:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E151F153E;
	Thu, 10 Apr 2025 04:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IXzLyow7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9431E9B02
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 04:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744260278; cv=none; b=H9j2Y9UUPgo681lBfvFnqI2XDtuKO7Y0xF7lDCcoyuxvc7fy9YMw0LPg4HQVqeF+NmTSPyMJ1eywJeKyV4EXdRM/dUH42WZwuV8rDFK1vUgq1c1BoVocF/DMmtBNT5Am5TplKt6O9I50WNGs6ZrhSnb+rR/2Xcj0wpIkxkzqwfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744260278; c=relaxed/simple;
	bh=aTdHpc5rDqraycZTf4nOde0tkf7843YMHFrARQ0hu2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OaB1lq6boOeAQLufHmxxZHuLifAcnxlcD7j5np5b5ynWHXDym2wtFyYGQWsy68478IxuKsVvUg5kdSGpkw8y0A7lJf1kBQuUxZjkdDcfO9smbsadTCn0K6BqNKkKMHCGmq+B5kDPuHDues2JvRWi2jUo+4DBRN/glpNmPoh5Z48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IXzLyow7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744260277; x=1775796277;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aTdHpc5rDqraycZTf4nOde0tkf7843YMHFrARQ0hu2s=;
  b=IXzLyow7/9IM5XAOaTpxTzO17nHfHRVYsVO+3pfRIEShIaZ76ixSAppC
   9VwA0F7uctMR8JVSa/lqkfFu6wLJn4j+HgwCkVW3tLgcNny2EwwBce38X
   yYrRYiOv2UyGtIBRBFW0myhXxp5E3hVVexGwadiwY9iMC06jT/SPcolHo
   L7c6QKLS7Gp/yUnuqN2sl4sOTU+zakrRHNWksqLUq1/OX3cTex+RLDQFH
   ERUhOSl0qoAK+NDKzHpASDKFqknsZnjrv3KtsufcjGqUt7dHY/lqH2ekS
   ANU3vW5O6igjaH6wwve2cc3D8mitcGpF9zeTvbF999+AxVBFb50C4Q3nj
   g==;
X-CSE-ConnectionGUID: Y0TxMSNGShSsV9gk/Q88Qg==
X-CSE-MsgGUID: Vw3BLeWMSYmHeZL0tOybDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="68245480"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="68245480"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 21:44:36 -0700
X-CSE-ConnectionGUID: qcSZQYFES12pOlD3NIbIBQ==
X-CSE-MsgGUID: RIwOMItmTjud9lN6+3ArRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="129620583"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 09 Apr 2025 21:44:26 -0700
Date: Thu, 10 Apr 2025 13:05:15 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com
Subject: Re: [PATCH v3 07/10] target/i386/kvm: query kvm.enable_pmu parameter
Message-ID: <Z/dRiyGTxb8JBE8v@intel.com>
References: <20250331013307.11937-1-dongli.zhang@oracle.com>
 <20250331013307.11937-8-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331013307.11937-8-dongli.zhang@oracle.com>

Hi Dongli,

The logic is fine for me :-) And thank you to take my previous
suggestion. When I revisit here after these few weeks, I have some
thoughts:

> +        if (pmu_cap) {
> +            if ((pmu_cap & KVM_PMU_CAP_DISABLE) &&
> +                !X86_CPU(cpu)->enable_pmu) {
> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                        KVM_PMU_CAP_DISABLE);
> +                if (ret < 0) {
> +                    error_setg_errno(errp, -ret,
> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
> +                    return ret;
> +                }
> +            }

This case enhances vPMU disablement.

> +        } else {
> +            /*
> +             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old
> +             * linux, we have to check enable_pmu parameter for vPMU support.
> +             */
> +            g_autofree char *kvm_enable_pmu;
> +
> +            /*
> +             * The kvm.enable_pmu's permission is 0444. It does not change until
> +             * a reload of the KVM module.
> +             */
> +            if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
> +                                    &kvm_enable_pmu, NULL, NULL)) {
> +                if (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu) {
> +                    error_setg(errp, "Failed to enable PMU since "
> +                               "KVM's enable_pmu parameter is disabled");
> +                    return -EPERM;
> +                }

And this case checks if vPMU could enable.

>              }
>          }
>      }

So I feel it's not good enough to check based on pmu_cap, we can
re-split it into these two cases: enable_pmu and !enable_pmu. Then we
can make the code path more clear!

Just like:

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f68d5a057882..d728fb5eaec6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2041,44 +2041,42 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     if (first) {
         first = false;

-        /*
-         * Since Linux v5.18, KVM provides a VM-level capability to easily
-         * disable PMUs; however, QEMU has been providing PMU property per
-         * CPU since v1.6. In order to accommodate both, have to configure
-         * the VM-level capability here.
-         *
-         * KVM_PMU_CAP_DISABLE doesn't change the PMU
-         * behavior on Intel platform because current "pmu" property works
-         * as expected.
-         */
-        if (pmu_cap) {
-            if ((pmu_cap & KVM_PMU_CAP_DISABLE) &&
-                !X86_CPU(cpu)->enable_pmu) {
-                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
-                                        KVM_PMU_CAP_DISABLE);
-                if (ret < 0) {
-                    error_setg_errno(errp, -ret,
-                                     "Failed to set KVM_PMU_CAP_DISABLE");
-                    return ret;
-                }
-            }
-        } else {
-            /*
-             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old
-             * linux, we have to check enable_pmu parameter for vPMU support.
-             */
+        if (X86_CPU(cpu)->enable_pmu) {
             g_autofree char *kvm_enable_pmu;

             /*
-             * The kvm.enable_pmu's permission is 0444. It does not change until
-             * a reload of the KVM module.
+             * The enable_pmu parameter is introduced since Linux v5.17,
+             * give a chance to provide more information about vPMU
+             * enablement.
+             *
+             * The kvm.enable_pmu's permission is 0444. It does not change
+             * until a reload of the KVM module.
              */
             if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
                                     &kvm_enable_pmu, NULL, NULL)) {
-                if (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu) {
-                    error_setg(errp, "Failed to enable PMU since "
+                if (*kvm_enable_pmu == 'N') {
+                    warn_report("Failed to enable PMU since "
                                "KVM's enable_pmu parameter is disabled");
-                    return -EPERM;
+                }
+            }
+        } else {
+            /*
+             * Since Linux v5.18, KVM provides a VM-level capability to easily
+             * disable PMUs; however, QEMU has been providing PMU property per
+             * CPU since v1.6. In order to accommodate both, have to configure
+             * the VM-level capability here.
+             *
+             * KVM_PMU_CAP_DISABLE doesn't change the PMU
+             * behavior on Intel platform because current "pmu" property works
+             * as expected.
+             */
+            if ((pmu_cap & KVM_PMU_CAP_DISABLE)) {
+                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                        KVM_PMU_CAP_DISABLE);
+                if (ret < 0) {
+                    error_setg_errno(errp, -ret,
+                                     "Failed to set KVM_PMU_CAP_DISABLE");
+                    return ret;
                 }
             }
         }




