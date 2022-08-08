Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5740058BE82
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 02:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiHHAgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 20:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiHHAgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 20:36:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC9563A9
        for <kvm@vger.kernel.org>; Sun,  7 Aug 2022 17:36:12 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b9-20020a170902d50900b0016f0342a417so5323393plg.21
        for <kvm@vger.kernel.org>; Sun, 07 Aug 2022 17:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=3S4dHkc0MTdRqLv4SAcUqz1B/UVYMX8Vb8XOweGx+Xk=;
        b=k8SwtQYdUwGzi6BjV82WmRUu3DSH9ZVvRp5BHjYQ0ttSH3NMLZ5yodStvp++/TX/eP
         8THi5ka3yqv2QLjH4JIMbu+Jlxr7q4m7O0yPCIzgw7eqGrsDfGIAl929jiy6S6z87DRf
         rEYijg4j862bIxPlK9ZCpQJkrm2vijrNY/WpxPhGT1DYTdytdXs/HNfp1cv88KfSrFda
         UustYvpcO99RK9VnQpW3+NuYd0hxBi8dZDFL8N73VfXFK2ufmWRbViBg83vaL7iffpeu
         jMtTgY14NnGD0l2kooD92aLuvNjdMLYa2OlrqzcVSaaZTVZJk4ys6s3oW5ImfgKLSvcP
         PiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=3S4dHkc0MTdRqLv4SAcUqz1B/UVYMX8Vb8XOweGx+Xk=;
        b=tljXEYzMRDMObcgdsWvEFcjHr8z00antD/eADb0e7gwTuYs4TFcVkloCEJsQjHV+kc
         izqZPHLQ32+NqKJ6BgKKZoDz25p25Cd2g9aHKFhX+isIogJ3RpvcAyQ6brzFDFcNZ8ZH
         snnvor4qckRb1gf09xDJx/DCddVg05kEPK+WL5RGIy59C/d5n+L0yb4jySGxZyMmV7jh
         rkERye7glkDRRz9a2LoiZCHAEBqtbufuZX1aK98W19fCoDIUQTY/yoAMOWWHfEaZ+Dob
         eXgND1o+oWHyC/QsQYLw5UAPrtaBUroB4Z7ZuTCr3Izw1CUIG/orN6gE8wtOjoyyorkq
         SO2w==
X-Gm-Message-State: ACgBeo1Aw9KoxrDfpGtFPnN9UH1ogNjL68fzLoPpaEOK8gbxwxT3EqUA
        3rnsmHKWooG2ZECDwrpVc3J4w3GYDod2
X-Google-Smtp-Source: AA6agR4fgv7b0+tDrH4/mToceWv+CaztaivGulIYYwVgW7bZ2kFq/RW0sNCa09fwKUBGlzNHdRKC/tglv46P
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:a93:b0:528:77d6:f660 with SMTP id
 b19-20020a056a000a9300b0052877d6f660mr16354359pfl.50.1659918972247; Sun, 07
 Aug 2022 17:36:12 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  8 Aug 2022 00:36:05 +0000
In-Reply-To: <20220808003606.424212-1-mizhang@google.com>
Message-Id: <20220808003606.424212-3-mizhang@google.com>
Mime-Version: 1.0
References: <20220808003606.424212-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 2/3] KVM: nVMX: Add tracepoint for nested vmenter
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index f5cb18e00e78..a65477295ec0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3367,6 +3367,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
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
2.37.1.559.g78731f0fdb-goog

