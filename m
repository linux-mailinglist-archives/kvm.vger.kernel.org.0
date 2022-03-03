Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6E4CB7CB
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiCCH27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiCCH2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B0E14A054
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292484; x=1677828484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LJEmkoDqllpFH5Iid50VThIb6goNurX+rp3Rv8fKx9k=;
  b=dRa8RYVQCQcIS+ApoleFYwTh1gt+umAN4hl78zOTFu26N75xdtbI0j6O
   SUcWQlg1LyAG6iGiZPBj0wcfDPmgGc+ndHGoDhKmYqSBWcEzgxRgwt8zK
   Ol9zlwALdmy7U8FHbV9Mlc12CZEnYHOAQPxDK/30OJcp1I6fflzoa42bl
   /lBmlyma9He4S9IWlPJMjKExhT70NhB4H+c+1FjuYwtULFLg4SYsqhq/q
   xmrrtjrniY3ruP8Or3Uti1owjDRnUp8l1t4SaXwvyemJIxYhvdaR9ACNV
   QZCgQmQMmziES+vYMZAq6nvMy0lhvv0yK1ZMPCrTjdi1+YY9lvOu6qI31
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177053"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177053"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:28:04 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631871"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:28:01 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 17/17] x86 TDX: Make run_tests.sh work with TDX
Date:   Thu,  3 Mar 2022 15:19:07 +0800
Message-Id: <20220303071907.650203-18-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a special group 'tdx' for those test cases supported
by TDX. So that when group 'tdx' specified, these test cases
run in TDX protected environment if EFI_TDX=y.

For example:
    EFI_TDX=y ./run_tests.sh -g tdx

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 README.md         |  6 ++++++
 x86/unittests.cfg | 18 +++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 6e82dc22570e..a84460e9f96b 100644
--- a/README.md
+++ b/README.md
@@ -137,6 +137,12 @@ when the user does not provide an environ, then an environ generated
 from the ./errata.txt file and the host's kernel version is provided to
 all unit tests.
 
+# Unit test in TDX environment
+
+    All the test cases supported by TDX belong to 'tdx' group, by this
+    command: "EFI_TDX=y ./run_tests.sh -g tdx", all these test cases run
+    in a TDX protected environment.
+
 # Contributing
 
 ## Directory structure
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 840e2054d54d..8cb32e6e7bee 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -56,10 +56,12 @@ arch = i386
 [smptest]
 file = smptest.flat
 smp = 2
+groups = tdx
 
 [smptest3]
 file = smptest.flat
 smp = 3
+groups = tdx
 
 [vmexit_cpuid]
 file = vmexit.flat
@@ -155,6 +157,7 @@ file = hypercall.flat
 [idt_test]
 file = idt_test.flat
 arch = x86_64
+groups = tdx
 
 #[init]
 #file = init.flat
@@ -163,6 +166,7 @@ arch = x86_64
 file = memory.flat
 extra_params = -cpu max
 arch = x86_64
+groups = tdx
 
 [msr]
 # Use GenuineIntel to ensure SYSENTER MSRs are fully preserved, and to test
@@ -171,6 +175,7 @@ arch = x86_64
 # will fail due to shortcomings in KVM.
 file = msr.flat
 extra_params = -cpu max,vendor=GenuineIntel
+groups = tdx
 
 [pmu]
 file = pmu.flat
@@ -207,6 +212,7 @@ file = s3.flat
 
 [setjmp]
 file = setjmp.flat
+groups = tdx
 
 [sieve]
 file = sieve.flat
@@ -216,23 +222,28 @@ timeout = 180
 file = syscall.flat
 arch = x86_64
 extra_params = -cpu Opteron_G1,vendor=AuthenticAMD
+groups = tdx
 
 [tsc]
 file = tsc.flat
 extra_params = -cpu kvm64,+rdtscp
+groups = tdx
 
 [tsc_adjust]
 file = tsc_adjust.flat
 extra_params = -cpu max
+groups = tdx
 
 [xsave]
 file = xsave.flat
 arch = x86_64
 extra_params = -cpu max
+groups = tdx
 
 [rmap_chain]
 file = rmap_chain.flat
 arch = x86_64
+groups = tdx
 
 [svm]
 file = svm.flat
@@ -259,7 +270,7 @@ extra_params = --append "10000000 `date +%s`"
 file = pcid.flat
 extra_params = -cpu qemu64,+pcid,+invpcid
 arch = x86_64
-groups = pcid
+groups = pcid tdx
 
 [pcid-disabled]
 file = pcid.flat
@@ -277,10 +288,12 @@ groups = pcid
 file = rdpru.flat
 extra_params = -cpu max
 arch = x86_64
+groups = tdx
 
 [umip]
 file = umip.flat
 extra_params = -cpu qemu64,+umip
+groups = tdx
 
 [la57]
 file = la57.flat
@@ -393,6 +406,7 @@ check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 [debug]
 file = debug.flat
 arch = x86_64
+groups = tdx
 
 [hyperv_synic]
 file = hyperv_synic.flat
@@ -431,6 +445,7 @@ extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=o
 file = tsx-ctrl.flat
 extra_params = -cpu max
 groups = tsx-ctrl
+groups = tdx
 
 [intel_cet]
 file = cet.flat
@@ -441,3 +456,4 @@ extra_params = -enable-kvm -m 2048 -cpu host
 [intel_tdx]
 file = intel_tdx.flat
 arch = x86_64
+groups = tdx nodefault
-- 
2.25.1

