Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE955F0875
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiI3KUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiI3KTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C19D166F14;
        Fri, 30 Sep 2022 03:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533139; x=1696069139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vSZXqKi+VzUQ8Oss4q4ps8WZefdkIn/jIGxOEvEYF4=;
  b=gAeI49NO4KxURWbnIFS82Yjh305BEjOtRIJgcso/e83/zoH6uNiRUB6B
   21X8RxnY+qoO/y0lWSIUsxnYWsTbEIe9aH5fZQKkfl0kzU3tVIP3daAZF
   yZ4PQPUXu6Yh3jmD9oqAG1dCje/d5CGRHnlZruHFPAIRDHiOkch3+lTXp
   y4ihjdQNLVWPznGtqgn8pbjoERrxtjjA2GVnpcyvueWb/gtu1A+SNUR10
   GxjdMUm5TjG+nNhlBv3WEzonh8aeWwhqhw4QclbISXZ7G8lc83C/V6CiD
   0IrwEPORvZmQKwYdR40+MXVnWaVXF8NOg5HtVn0OzNxxsboMej4yuJcc7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870079"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870079"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807583"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807583"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH v9 025/105] KVM: TDX: Use private memory for TDX
Date:   Fri, 30 Sep 2022 03:17:19 -0700
Message-Id: <380563c808afef2260e601e3f761e050bd0ad964.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

Override kvm_arch_has_private_mem() to use fd-based private memory.
Return true when a VM has a type of KVM_X86_TDX_VM.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e1c35cbe0b77..5006ff5d9f5e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13588,6 +13588,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
-- 
2.25.1

