Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4457882A
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiGRRNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbiGRRNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:13:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5E52B26D
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:13:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n2-20020a170902e54200b0016c16832828so6964296plf.5
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=T789rHVyM0EXnBz1s4xRom+47Pt99vhuH1gFXMufNBM=;
        b=lUCY63XCcnTUmmbN+2RPcnFjRSJ8Sfm/6HX/0m66JTA1bkq5V2Cy7qXkNOVlD+O9p6
         t3eUdZWsFDMfRYvIBTI01Mh4VZcl+Uzy2MNRljKAt88WIBPSD0cLeewVVk+sZepqWKq8
         XRh5A9vzt69+AbrzXpvUfSsOhNuxMSxC1XAKR/qk9/MXTtlPfjCVklm08est7K/SRs8S
         TjbXiNSzYEfZYm2ko/HxHdPMrbprvT7xIb60h7WnbhqKXYs/GJzmTfnAXEJb7jQFgd32
         65TX2LBN6bcvOF3ciPmITGYrZpw/AVuTCKni18RUN5NwY1azbmFDMsdZXmiAfAiU+z+B
         Vx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=T789rHVyM0EXnBz1s4xRom+47Pt99vhuH1gFXMufNBM=;
        b=EvCDZ7wMIDSMP+IUERYLUyOCpyWRLAfo+C9y+s6ij0lBx1xu3pyHuOOOvmlBrIjoKW
         iJZ3AfQABihAweiyH5+7KNJ5mBhLl6qjpjdFG8M0i3rgpIke43f91ZDnI8hNDXqYVA/n
         OCFxav4ooaTf3mklGphWI32SRbnSD52UIozo+rAvwL2Hdbh3+h82oQDmQFO9TQbC4nP3
         KA2JjREb3jgV0EsTNRsD2Ps5QUAV9+Ck7EvT4tgMtwlh/S37HHifLGwlKHHgQNLrtdGX
         AAXmjiPKiLWEVUvKNlFw0Pg8anZz3wuBifLkQ9wHMThgq8SX0N87R68ArmCWuoPa62yW
         UUcg==
X-Gm-Message-State: AJIora/bXvB2erLDDoJ7WB/w1xvnpuC7at197Opc98jx5zVygsFnPiTK
        /XdMDpezp4t3Ew1w/scNtKKA7q72E5xw
X-Google-Smtp-Source: AGRyM1va7P2ztYevG3XekdBbVXxvteBJ+UuQ0nFr6oDlNIJ5SGcdXE8wK4eAZhIprsSbJdWw5p1sec3y4FFW
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:188e:b0:52a:b545:559f with SMTP
 id x14-20020a056a00188e00b0052ab545559fmr29158357pfh.18.1658164419189; Mon,
 18 Jul 2022 10:13:39 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 18 Jul 2022 17:13:32 +0000
In-Reply-To: <20220718171333.1321831-1-mizhang@google.com>
Message-Id: <20220718171333.1321831-3-mizhang@google.com>
Mime-Version: 1.0
References: <20220718171333.1321831-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 2/2] kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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

"npt_enabled": 1 when the VCPU has enabled nested paging. The analagous
VMCS field is the enable-EPT execution control.

"npt_addr": 64-bit field when the VCPU has enabled nested paging. The
analagous VMCS field is the ept_pointer.

Signed-off-by: David Matlack <dmatlack@google.com>
[Add several parameters and move the code into the
nested_vmx_enter_non_root_mode().]
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..825f7102daee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3367,6 +3367,15 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	};
 	u32 failed_index;
 
+	trace_kvm_nested_vmrun(kvm_rip_read(vcpu),
+			       vmx->nested.current_vmptr,
+			       vmcs12->guest_rip,
+			       vmcs12->guest_intr_status,
+			       vmcs12->vm_entry_intr_info_field,
+			       vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT,
+			       vmcs12->ept_pointer,
+			       KVM_ISA_VMX);
+
 	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
-- 
2.37.0.170.g444d1eabd0-goog

