Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E476B3FCA
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 13:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCJM5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 07:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJM5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 07:57:33 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27C37D57E
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 04:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678453052; x=1709989052;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t3/No4RIfWmVnyZwhOzYmHIK4RfnszW72qZTFnNvC1w=;
  b=Lml6z+fr66J2QIAlYqJT75VXxzEfznO/XoYdwCzaZyWhrzrktkjGAylC
   huacxnf9GTgWfsv4EHwchktQrXV9D1I8rHHgLgyaslEtRFPfGQjbg29iW
   hJ+pBdT4bZzAC9bvHh6L4t4pAxl9SnU45jxv8bYroMTP3uvuGBJjyfbb+
   7bZ64R2XvPzsEdUIiQevzSEAwTBX20VH9d4Hc1NU7bH98kVSV+j0EP+Di
   t4mOgJBU3U++YLx1/uYghCIr53VKadll5QPiVDPG2OkOQHCOVOr1RHnMB
   woZVggkLYTDbUUZVK3kgrNoV/FUCXOgmrI1G5qVH+90HpsKeoA27U5z1G
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336739887"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="336739887"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="801573454"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="801573454"
Received: from sqa-gate.sh.intel.com (HELO zhihaihu-desk.tsp.org) ([10.239.48.212])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:30 -0800
From:   Robert Hoo <robert.hu@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     robert.hoo.linux@gmail.com
Subject: [PATCH 0/3] Some code refactor surround CR4.UMIP virtualization
Date:   Fri, 10 Mar 2023 20:57:15 +0800
Message-Id: <20230310125718.1442088-1-robert.hu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is some small code refactor/cleanup surround CR4.UMIP virtualization.

vmx_umip_emulated() is misleading, it is actually cpu_has_vmx_desc(). E.g.,
if host has both UMIP cap and VMX_FEATURE_DESC_EXITING feature,
vmx_umip_emulated() returns true, but UMIP in fact isn't emulated. Rename
it.

Also, vCPU can have UMIP feature (i.e. CR4.UMIP is valid) if and only if
host has UMIP and/or VMX_FEATURE_DESC_EXITING cap, (see vmx_set_cpu_caps());
then checking cpu_has_vmx_desc() for emulating UMIP is redundant, because
boot_cpu_has(X86_FEATURE_UMIP) and cpu_has_vmx_desc() must at least one be
true. 

===Test===
kvm-unit-test umip cases, enabled and disabled (unittests.cfg patch below),
pass. But currently I have no machine with UMIP feature, so actually only
emulation path is covered.
In January, test was carried out on Simics platform with UMIP. Passed.

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 08a9b20..32a3b79 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -323,6 +323,10 @@ arch = x86_64
 file = umip.flat
 extra_params = -cpu qemu64,+umip
 
+[umip-disabled]
+file = umip.flat
+extra_params = -cpu qemu64,-umip
+


Robert Hoo (3):
  KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
  KVM: VMX: Remove a unnecessary cpu_has_vmx_desc() check in
    vmx_set_cr4()
  KVM: VMX: Use the canonical interface to read CR4.UMIP bit

 arch/x86/kvm/vmx/capabilities.h |  2 +-
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/vmx/vmx.c          | 12 +++++++++---
 3 files changed, 12 insertions(+), 6 deletions(-)


base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.31.1

