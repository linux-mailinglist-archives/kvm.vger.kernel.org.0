Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651B06B6496
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjCLJ7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCLJ7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0393B20D1A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615095; x=1710151095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rqur+vevLMZCF7wA0NbcD0BAEZGwybzNrkGtGG8CPLM=;
  b=GrA83LKVH/fyvoRAyFzL16ywHxVutV9MH6egeterR0vWZF7W061E+Z09
   15oLnhXbP75vplCPMltKSSel2BQ0mq2SJhid5HPY+GKCpW7BND/eNNZFZ
   v1twdQoxVcrJK0eAAiJOhLHaCs4IKIFtXX7R+1gN2F9Tm9zgVnDzwnl+H
   +8NyJR37xG4sMEJ79SUSF/Ky4QY6QPmqiqgqejreDVMgOKCo0HxiVhA2t
   6hQTrMEMAGmyTJdy2gNZf3FPIokuYYC75m0TxjbTHxt5igTYhMFEPCTo1
   ez5WUvK2+P8ltj/9ME79OqmqxdPcE34U85FRtFzyYgj7ZIyXLpehePusk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998131"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998131"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677783"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677783"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:31 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 20/22] pkvm: x86: Add INVEPT/INVVPID emulation
Date:   Mon, 13 Mar 2023 02:03:01 +0800
Message-Id: <20230312180303.1778492-21-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The INVEPT & INVVPID cause vmexit unconditionally, pKVM must have
handler for them.

It's a tmp solution, just call global invept for invept/invvpid. After
pKVM supported shadow EPT, such emulation shall be done based on
shadow EPT.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 27b6518032b5..8e7392010887 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -251,6 +251,11 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			case EXIT_REASON_INTERRUPT_WINDOW:
 				handle_irq_window(vcpu);
 				break;
+			case EXIT_REASON_INVEPT:
+			case EXIT_REASON_INVVPID:
+				ept_sync_global();
+				skip_instruction = true;
+				break;
 			default:
 				pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
 				skip_instruction = true;
-- 
2.25.1

