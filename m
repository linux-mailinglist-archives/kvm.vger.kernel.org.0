Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7CC79F929
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjINDxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjINDxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:53:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425FE1BE3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663579; x=1726199579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h2VTCw5i0cKuV38BdOMgzq2DUKXjm2pDKAxaCdcmMTA=;
  b=BkzRdtSc1d4xJf1zVUE1hVo8wGBOBTwNTcDDqkK2Vo5IwCyy2iLBNCEh
   S/dzwiySGa26ORtnb0NW9H99Bw08wVFgFwEQMTryh1yb0ngZ2WVYH/gGR
   DQdoFWNuYoZ3ZpyAtbWiHNeD31xbjxA7DWzJAe82I8vWCbf7PVNQq766g
   6MJ+rtcDMmK3Djd0MtGuHpwg1J1wMOOcmqiufaOM+JXdRJJzXf59RDS7D
   aenip+TJaj3QsuE6n+oPFwxUauy463nG2Kgph8H7SsS7nuzgRX1z6pinx
   ttsoFvZvjpTrGdwKyMqfneXkeii6M2ex41zLUqY3Y28shJkF0kFlNVww1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528606"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528606"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500731"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500731"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:54 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 21/21] i386: Disable SMM mode for X86_SW_PROTECTED_VM
Date:   Wed, 13 Sep 2023 23:51:17 -0400
Message-Id: <20230914035117.3285885-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/sw-protected-vm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/sw-protected-vm.c b/target/i386/kvm/sw-protected-vm.c
index f47ac383e1dd..65347067aa03 100644
--- a/target/i386/kvm/sw-protected-vm.c
+++ b/target/i386/kvm/sw-protected-vm.c
@@ -34,10 +34,18 @@ static MemoryListener kvm_x86_sw_protected_vm_memory_listener = {
 int sw_protected_vm_kvm_init(MachineState *ms, Error **errp)
 {
     SwProtectedVm *spvm = SW_PROTECTED_VM(OBJECT(ms->cgs));
+    X86MachineState *x86ms = X86_MACHINE(ms);
 
     memory_listener_register(&kvm_x86_sw_protected_vm_memory_listener,
                              &address_space_memory);
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "X86_SW_PROTECTED_VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     spvm->parent_obj.ready = true;
     return 0;
 }
-- 
2.34.1

