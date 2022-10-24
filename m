Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBECF60A1FA
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiJXLh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiJXLhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECFC2338C;
        Mon, 24 Oct 2022 04:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611441; x=1698147441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ZWYt19HkbGichJe8gxDpcMzSf3niaLPKuq8RXWtguo=;
  b=fgPSGzF7FkxLRh2FmhKuElG9S69oXengpHvWxF3vD7nzDVRsqeWrapN7
   U3eVAIBIZtQyR7gyLm0Ca03brLBNE7GapEjHB/+QS7fOG+FgZJxc6uII1
   MwTaVrDBAFcfCRRAOMS69VDXVWx27B8uRkLyhs+9NxfdhkKAbRZb4gK6G
   tvs66PPRO9idiR0qAHvtNvjdaNJt8sEAEy3lJulF/Xi/WPcX/DEig9tR7
   OMHHrHZtU77/0cAx+FIGv2QzSypC1hKHQUCbGYZAwRh/xCNl0P5LI2wWi
   fQ1Wcv7WNr7PdmPU8lpkRgMLz0WRF1pgyPViMlgWLjpsfoSYkI5ZjM7Fc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="371612770"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="371612770"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:34:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784625"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784625"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:34:53 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 02/18] KVM: selftests/kvm_util: use vm->vcpus[] when create vm with vcpus
Date:   Mon, 24 Oct 2022 19:34:29 +0800
Message-Id: <20221024113445.1022147-3-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_vm struct has been changed to maintain vcpus via an array of
vcpu pointers, there is no need to require users to allocate and pass
in another vcpu array when create the vm.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 941f6c3ea9dc..1f69f5ca8356 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -371,12 +371,10 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	struct kvm_vm *vm;
 	int i;
 
-	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
-
 	vm = __vm_create(mode, nr_vcpus, extra_mem_pages);
 
 	for (i = 0; i < nr_vcpus; ++i)
-		vcpus[i] = vm_vcpu_add(vm, i, guest_code);
+		vm->vcpus[i] = vm_vcpu_add(vm, i, guest_code);
 
 	return vm;
 }
@@ -385,13 +383,12 @@ struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 					 uint64_t extra_mem_pages,
 					 void *guest_code)
 {
-	struct kvm_vcpu *vcpus[1];
 	struct kvm_vm *vm;
 
 	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages,
-				    guest_code, vcpus);
+				    guest_code, NULL);
 
-	*vcpu = vcpus[0];
+	*vcpu = vm->vcpus[0];
 	return vm;
 }
 
-- 
2.27.0

