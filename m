Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A9F5A1CDB
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 00:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244514AbiHYW6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 18:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244482AbiHYW6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 18:58:10 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC18AC6FCA
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 15:58:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i1-20020a170902cf0100b001730caeec78so57434plg.7
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 15:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=wadlRfkfh/eCNxZlBFG/ZMtLROgMWIvNN1fkY84o1Bw=;
        b=tXzIQz4kyQAPXHYs8XCgoemSHhQnDjonD9baMgjHt7S4fTWbkmK+lYHCx3cT/vNZZL
         w5uQT0L1p2FXY4jJLxvg49CM8s4E/LroaEsOaLU9PK3Pas+zu3GfSivERw4ro0pC50eh
         oo0xu2qmXAre/GO8gA2tSMUgT/piBlHUZZFbN/HxHg7tKLOfoWeOG0aKPN4Ncmki0Pj9
         lUHaUtd/gGLZfIO2lRJFYLHTMlLfnfGZRyA3QNaB1eTXEbf0j7f8XBuerWExzYOGAoW8
         Bz2du9VQwY9yAaW2XW1IMFsYdzGoO00ymM3KIPkSyS31tqE80pNE+SmzsOXLauybsRiN
         iZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=wadlRfkfh/eCNxZlBFG/ZMtLROgMWIvNN1fkY84o1Bw=;
        b=vaOpys6d7MPb/1DdBFaTfwGeXrXnA41znQcU2WTR+zJIsprPvB7i+9P3SN69tkmtKC
         yefBI8if6EQftDpiWUaXQd8RVnBVy7LVw0a7gtz5nsABhIjuA+7vEmqIxHTBv9xrn0RD
         uvwmqVetIWDkVQ5+WJInQLTs7qqemmqeKyUMrWJM3U7uEq16lNhLG+BBOC9IxPUeCtb/
         OA3bXFy3vTvkcGZ9Fg0q7JbJJPtAFD8Svc0aBIi92gl8FJbjr/a48kfl9TEle9dDWrxX
         e0nhEAdH9zhLo/tUG/AOj2hTC0s08BWkmimAxG9/UnPL4thrrJYjfCxG9cJ9DY8H7t9P
         KSnQ==
X-Gm-Message-State: ACgBeo0zYUPqLudDcuKHeh9kbU6bQ5nYPUXoD/e1HTGjwPcWDZZOoB7o
        5uDaIfE1EVVMF3zezcA1spWbT33CCwUR
X-Google-Smtp-Source: AA6agR7A1fQHCwdLbya8oJ+6CW1VKfW6iKzzKprH1HJNVLv4rMRrwquEItfY6dBX9SsOVznkjavasyluYv5x
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:ad1:b0:530:2cb7:84de with SMTP id
 c17-20020a056a000ad100b005302cb784demr1257715pfl.3.1661468288259; Thu, 25 Aug
 2022 15:58:08 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Thu, 25 Aug 2022 22:57:54 +0000
In-Reply-To: <20220825225755.907001-1-mizhang@google.com>
Mime-Version: 1.0
References: <20220825225755.907001-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825225755.907001-3-mizhang@google.com>
Subject: [PATCH v4 2/3] KVM: nVMX: Add tracepoint for nested vmenter
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Call trace_kvm_nested_vmenter() during nested VMLAUNCH/VMRESUME to bring
parity with nSVM's usage of the tracepoint during nested VMRUN.

Attempt to use analagous VMCS fields to the VMCB fields that are
reported in the SVM case:

"int_ctl": 32-bit field of the VMCB that the CPU uses to deliver virtual
interrupts. The analagous VMCS field is the 16-bit "guest interrupt
status".

"event_inj": 32-bit field of VMCB that is used to inject events
(exceptions and interrupts) into the guest. The analagous VMCS field
is the "VM-entry interruption-information field".

"npt_enabled": 1 when the VCPU has enabled nested paging. The analagous
VMCS field is the enable-EPT execution control.

"npt_addr": 64-bit field when the VCPU has enabled nested paging. The
analagous VMCS field is the ept_pointer.

Signed-off-by: David Matlack <dmatlack@google.com>
[move the code into the nested_vmx_enter_non_root_mode().]
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..f72fe9452391 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3364,6 +3364,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	};
 	u32 failed_index;
 
+	trace_kvm_nested_vmenter(kvm_rip_read(vcpu),
+				 vmx->nested.current_vmptr,
+				 vmcs12->guest_rip,
+				 vmcs12->guest_intr_status,
+				 vmcs12->vm_entry_intr_info_field,
+				 vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT,
+				 KVM_ISA_VMX);
+
 	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
-- 
2.37.2.672.g94769d06f0-goog

