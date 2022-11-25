Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D2638275
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 03:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKYCip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 21:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKYCip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 21:38:45 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4126134
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 18:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669343923; x=1700879923;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NlV1BvaTnDBRoGdcFyQLbQV5Ebr+mk+mN0Iowh9DOoA=;
  b=Kw17L8KKbYSSB3WyGKwfHiQCNDXtVQTTfDpWGiK4BXIsMxDafHouI0q1
   wcOnYNl1NIVyQCgezpMsryowqAVmypRb65q6ECzH5IRARfIbNfNbiOAOx
   hHWU61a8puK+PRZT7PIjANQJl1qdsbU/pXO41LOoPXd1Zjk+P5bWg5zhn
   q4JLtc6vFswVQqkCJjlznzYRPWhkS7eWw0M7tuNgut1yUDm14MUsJIhUZ
   iIfle5Ayf+KQu09V6NoqUD5CnZq0qjzN+cK+NM2PdH7lUTry1I2esWikg
   tr4bUFGAvt6PSkDy+xfjVqO4EwzlZTadoW35CjzerewlzJh3BKMdQHbu1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="378654797"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="378654797"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 18:38:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="642561687"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="642561687"
Received: from b49691d8dae0.jf.intel.com ([10.112.228.155])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 18:38:42 -0800
From:   "Wang, Lei" <lei4.wang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@linux.intel.com
Subject: [PATCH] KVM: selftest: Move XFD CPUID checking out of __vm_xsave_require_permission()
Date:   Thu, 24 Nov 2022 18:38:39 -0800
Message-Id: <20221125023839.315207-1-lei4.wang@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_cpu_has(X86_FEATURE_XFD) will call kvm_get_supported_cpuid() which will
cache the cpuid information when it is firstly called. Move this line out
of __vm_xsave_require_permission() and check it afterwards so that the
CPUID change will not be veiled by the cached CPUID information.

Signed-off-by: Wang, Lei <lei4.wang@intel.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 --
 tools/testing/selftests/kvm/x86_64/amx_test.c      | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a..5686eacd4700 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -616,8 +616,6 @@ void __vm_xsave_require_permission(int bit, const char *name)
 		.addr = (unsigned long) &bitmask
 	};
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
-
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index dadcbad10a1d..1e3457ff304b 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -312,6 +312,7 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_AMX_TILE));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILECFG));
-- 
2.34.1

