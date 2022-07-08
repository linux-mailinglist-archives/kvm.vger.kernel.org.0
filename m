Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13456C547
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 02:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239424AbiGHXXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 19:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiGHXXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 19:23:12 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D26419AE
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 16:23:11 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i5-20020a170902c94500b0016a644a6008so39636pla.1
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 16:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YCs/Ozya1DEi/lgLzfirR8Zlh6X4WyJYUDH8smOVNLc=;
        b=fM2FZMwhOjn0XFbozuKXIQ0p7ngjA3tLHPA2/jJN2AHxscipUW7ePQzlBV2U0kvScb
         iqESxrCm7SSafg3O8a2jO1SjtJTLTEOSV1JmCyytwFlnLV6zhlumK6L2vQeYtZXL+VyO
         eR8e7rTCxPhOrjQt1+WgOiy2zspv0q/eEOkultnrK0vaS61gW85M74cIM89MNqPYlsEC
         fwjutTQwOaMHXPbw6RuYIvcO3hgTyMLH8AfTyiHWySbq0FC2sj5JOSJyylNSri5SLan8
         9qDsa360ZbB8p/7Jr0xcHtJ0TvCME3qU3TaE3EUG5POX7xWdTfOBsgGawl3UujCG+wlX
         m3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YCs/Ozya1DEi/lgLzfirR8Zlh6X4WyJYUDH8smOVNLc=;
        b=WNpGBN2xjwPtXDdq3edPUCg0PNkCGGCc7Jq/q5RuYHI8a6fIdibBKsiP4AA5eobEBY
         lwcHUJ0KwnYq9cNX53/dIi94Pi4waavEXokOh9QUwQYkoKvzPYKcn7UVkcXvFcOpN1j/
         UlIlbMfgXfbg1+pfrUF/zgBOH3/sAhrXpprqiE1zremjMr69Ao/YI+cdMkswH7DCKJrE
         f0CQBFM5Esyyz3ayj8lWxJ2SpnwJgKGIubpvJoE/t0iE0H40x6nsiBumnrXjzWhJ6znC
         d2yv/f7bv2q3cWCmx9/nkPggbKJbPsBdCfUuvt1SY69T5W3o+o1G673qIjIQLKlE/N+/
         IsZg==
X-Gm-Message-State: AJIora9RXuOKEfpei8SnGUTRzOiNfiYVngWX1m0LOtGO7+5P/gEGsb99
        z3UwCwrynjqqx+8aORAsHavYI30btbWS
X-Google-Smtp-Source: AGRyM1vZxxcWg4+gD+2pS+oyj5Bm5xDUty77kz3mw24tt8ks5Tmjt8Oo9+IVWAjz/X5uQnH5fqqez+UZtR4Y
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:2384:b0:52a:b75b:1123 with SMTP
 id f4-20020a056a00238400b0052ab75b1123mr2170901pfc.8.1657322591304; Fri, 08
 Jul 2022 16:23:11 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  8 Jul 2022 23:23:04 +0000
In-Reply-To: <20220708232304.1001099-1-mizhang@google.com>
Message-Id: <20220708232304.1001099-3-mizhang@google.com>
Mime-Version: 1.0
References: <20220708232304.1001099-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 2/2] kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun
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
 arch/x86/kvm/vmx/nested.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..7289187b020a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3367,6 +3367,16 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	};
 	u32 failed_index;
 
+	trace_kvm_nested_vmrun(
+		kvm_rip_read(vcpu),
+		vmx->nested.current_vmptr,
+		vmcs12->guest_rip,
+		vmcs12->guest_intr_status,
+		vmcs12->vm_entry_intr_info_field,
+		vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT,
+		vmcs12->ept_pointer,
+		KVM_ISA_VMX);
+
 	kvm_service_local_tlb_flush_requests(vcpu);
 
 	evaluate_pending_interrupts = exec_controls_get(vmx) &
-- 
2.37.0.144.g8ac04bfd2-goog

