Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F7855B3FA
	for <lists+kvm@lfdr.de>; Sun, 26 Jun 2022 22:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiFZUFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 16:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiFZUFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 16:05:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EE15FAA
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 13:05:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d3-20020a170903230300b0016a4d9ded01so4199304plh.6
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 13:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=SHvTwEAagVJ3mN0Qty2biE6ESSKF4d2LGs55m3Aiei8=;
        b=VVxioJBPdc/m1LIyig1BROTV0DRf8OjryQD0bdHRYx5o6Jbm5lBSp6PTgl/VPQh8as
         OmtcsPcZX8wIpv5fKdGWrZu4XIWfsMpjR+pG78qY8QHLU5yVmWhEE/0OOttT85RD4dqn
         qGHQ5wjU+yOSTbZ/btlh0yn+PYmPNPHRK5eZ9L52kNZfbQ3SUw/3MGImeb/jKKA7kc2R
         PlI0qL+He4FiPTydANKCdpRcGbLtJuj0QDYMc91abiJ1N/p2khYLKRrJceIk6liEqbUK
         t+d3zHcQmQ/NrDLe2jX010CfUy3uprFYGV+WAmXNswcue0MyxSIN1JGut2EOnmfgTM5X
         MYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=SHvTwEAagVJ3mN0Qty2biE6ESSKF4d2LGs55m3Aiei8=;
        b=1lJQPSJv3sNPhXoNypPrB8byU59O12kDYWZqH4bX3gOqGr1OVvU+QRWXrAAhHXqTjD
         dPOFGEECieEnKn+LpuNS1L8Uoadgg7d3dZilM8TDGjbTlcim7uin8TaNXb6Im99+TWNW
         k1jd0S4+Jzp57Io9/VHdz0RkScxKo0LXTw640qDvFwOB3dGjsc61jRJOoKpcmuSwEUzY
         E5do+FBfEtcVKYWF1LLbDtgrKrwjhaAmW0ZL2f/bBM6k+Gm+7h41KUq+Iz5rbllq9v2R
         mmSq94PZOMSpMk//OXowHV+BvMhrndAi3e7GDjE6MlfrKljIi5Ecy0G0v8tOPl9MSxu1
         jckQ==
X-Gm-Message-State: AJIora98OOc76u6NwHBq2DPAlaCRxq4m9d0FPFidJtiMRmBNW9I07eMt
        mS4/XGeXoWsbLyG7+LJmQrr4EQUehtma
X-Google-Smtp-Source: AGRyM1vwun+MwnGbBaWTTQkqAwwk+stfTrLtMzekZGGLsJgE5sSyPtAqM2KhNOJ9qp0IkdYiIX9eILX3bXPT
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:889:b0:510:91e6:6463 with SMTP id
 q9-20020a056a00088900b0051091e66463mr11138566pfj.58.1656273941306; Sun, 26
 Jun 2022 13:05:41 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 26 Jun 2022 20:05:38 +0000
Message-Id: <20220626200538.3210528-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

This tracepoint is called by nested SVM during emulated VMRUN. Call
also during emulated VMLAUNCH and VMRESUME in nested VMX.

Attempt to use analagous VMCS fields to the VMCB fields that are
reported in the SVM case:

"int_ctl": 32-bit field of the VMCB that the CPU uses to deliver virtual
interrupts. The analagous VMCS field is the 16-bit "guest interrupt
status".

"event_inj": 32-bit field of VMCB that is used to inject events
(exceptions and interrupts) into the guest. The analagous VMCS field
is the "VM-entry interruption-information field".

"npt": 1 when the VCPU has enabled nested paging. The analagous VMCS
field is the enable-EPT execution control.

Signed-off-by: David Matlack <dmatlack@google.com>
[Move the code into the nested_vmx_enter_non_root_mode().]
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..29cc36cf2568 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3367,6 +3367,13 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	};
 	u32 failed_index;
 
+	trace_kvm_nested_vmrun(
+		kvm_rip_read(vcpu), vmx->nested.current_vmptr,
+		vmcs12->guest_rip,
+		vmcs12->guest_intr_status,
+		vmcs12->vm_entry_intr_info_field,
+		vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT);
+
 	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &

base-commit: 922d4578cfd017da67f545bfd07331bda86f795d
-- 
2.37.0.rc0.161.g10f37bed90-goog

