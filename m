Return-Path: <kvm+bounces-13078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1C5891680
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:06:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE8A01C20CBD
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1AB54BFD;
	Fri, 29 Mar 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ka4xH/kX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD6C52F72
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711706786; cv=none; b=nlZP/wg8bVMVE81KOhaXRfuKtuNuewBUuZ9qsoU5ArD/spM/rRk4HGAZ2eu/UvY3kFG25WZjKtbyUlhhfgvChP+Yxg/Bcgl9EGxk/ovVUGWoRzpzpjXzMyC5Pd0oROk6c3B+AOXn+RH3ZdcVB9mnRLgXDSHvFkfeiPVfR/7aEIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711706786; c=relaxed/simple;
	bh=5YnpqPAXnQgSLnwyieSH2PQh+ZNUxgYyQ1OBV3sT/yg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RaLG+KkAJqwKN0JH1I22fp3JcOPC08Hlpj2jbCdYlu2MVGUs5fklj94TXC1QSwSiPqgIIEAmS3crdt3Y4LlfufuA950yCwJsfqnBFxCjM8BJxHHHQtstFDRUM1rlWK896YtToscPJr//MovkKEyrtfNmbVeRx2GzGmjFbSkzKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ka4xH/kX; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711706785; x=1743242785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5YnpqPAXnQgSLnwyieSH2PQh+ZNUxgYyQ1OBV3sT/yg=;
  b=Ka4xH/kX4X2LeMFlVTPn+SbJM/A4y8rjnNtiknOGmvk69t+r7JBpVF4u
   PLAlxl3wM47rlQwsA+FA7ClsNTMCIe1vVGxr4Akv8+cqBSLPM2oGwfZNQ
   BKElJtTg0HH4DsqiscZdlBM82f//7/gcnilfomIsPDUtpGM9YbwXDMU3j
   xMC+NJF0REL+dq9Gqk/EhZXdIgAdEgoToejqXjvVkvIlvBy8O6/x1fKxx
   WSwnnl0RfRZDBiMWzj3fSj3hHwn57smk8umTcpwq45QwlEnROf+aETYYB
   tm6HAfew4s7ap0cQvSCdQKdQO1mGgtK5Tznlla55rL9B0iK6+gmHfDm6a
   Q==;
X-CSE-ConnectionGUID: r5+O+p23Qgmlsk+p4mmUJQ==
X-CSE-MsgGUID: hphfjLlhScWGmeGFw4oR5w==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17519237"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17519237"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 03:06:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="21441985"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 29 Mar 2024 03:06:21 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH for-9.1 6/7] target/i386: Fix duplicated kvmclock name in FEAT_KVM
Date: Fri, 29 Mar 2024 18:19:53 +0800
Message-Id: <20240329101954.3954987-7-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tim Wiederhake <twiederh@redhat.com>

The commit 642258c6c7 ("kvm: add kvmclock to its second bit") gave the
old and new kvmclocks with the same name "kvmclock", to facilitate user
to set/unset the feature bits for both 2 kvmclock features together.

This could work because:
* QEMU side:
  - x86_cpu_register_bit_prop() supports "the same property name can be
    registered multiple times to make it affect multiple bits in the
    same FeatureWord".
* KVM side:
  - The only difference between 2 version kvmclocks is their MSRs have
    different addresses.
  - When 2 kvmclocks are both enabled, KVM will prioritize the use of
    new kvmclock's MSRs.

However, there're reasons we need give the second kvmclock a new name:
* Based on the KVM mechanism, it doesn't make sense to bind two
  kvmclocks together. Since kvmclock is enabled by default in most cases
  as a KVM PV feature, the benefit of the same naming is reflected in
  the fact that -kvmclock can disable both. But, following the KVM
  interface style (i.e., separating the two kvmclocks) is clearly
  clearer to the user.
* For developers, identical names have been creating confusion along
  with persistent doubts about the naming.
* FeatureWordInfo should define names based on hardware/Host CPUID bit,
  and the name is used to distinguish the bit.
* User actions based on +/- feature names should only work on
  independent feature bits. The common effect of multiple features
  should be controlled by an additional CPU property or additional code
  logic to show the association between different feature bits.
* The old kvmclock will eventually be removed. Different naming can ease
  the burden of future cleanups.

Therefore, rename the new kvmclock feature as "kvmclock2".

Additionally, add "kvmclock2" entry in kvm_default_props[] since the
oldest kernel supported by QEMU (v4.5) has supported the new kvm clock.

Signed-off-by: Tim Wiederhake <twiederh@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Based on Tim's original patch, rewrote the commit message and added the
tiny fix for compatibility.
---
 target/i386/cpu.c         | 2 +-
 target/i386/kvm/kvm-cpu.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1b6caf071a6d..0a1dac60f5de 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -855,7 +855,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_KVM] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
+            "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock2",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", "kvm-asyncpf-vmexit", "kvm-pv-ipi",
             "kvm-poll-control", "kvm-pv-sched-yield", "kvm-asyncpf-int", "kvm-msi-ext-dest-id",
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index ae3cb27c8aa8..753f90c18bd6 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -77,7 +77,7 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
 
     if (cpu->legacy_kvmclock) {
         /*
-         * The old and new kvmclock are both set by default from the
+         * The kvmclock and kvmclock2 are both set by default from the
          * oldest KVM supported (v4.5, see "OS requirements" section at
          * docs/system/target-i386.rst). So when one of them is missing,
          * it is only possible that the user is actively masking it.
@@ -179,6 +179,7 @@ static void kvm_cpu_xsave_init(void)
  */
 static PropValue kvm_default_props[] = {
     { "kvmclock", "on" },
+    { "kvmclock2", "on" },
     { "kvm-nopiodelay", "on" },
     { "kvm-asyncpf", "on" },
     { "kvm-steal-time", "on" },
-- 
2.34.1


