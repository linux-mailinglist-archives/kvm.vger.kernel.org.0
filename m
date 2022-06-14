Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7549D54BD2B
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354575AbiFNV66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 17:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357117AbiFNV6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 17:58:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDC41E3DB
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u71-20020a63854a000000b004019c5cac3aso5552059pgd.19
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dUrHYPjTeyeIaiftDlK8lvhq4xdyB6rSMhx+E9kZeQI=;
        b=RfCHJ3J1fNmHDZEev7mBJJN9myc3lMSXoLRzE2Em2X8P3DMPVasWAbim4o5g3WlEoQ
         3QHsJodpIlcfjTU0RQd721ClRWbaIejLI2WPMjqdowR/ig5uyjkMtX9QC0qUbJZnHSmM
         3HY5fKOeyqV7yolP5ij6JRIywi+RSZx37PtrtMfO0TE7WWkWPeS6fzuMQqvms+cJmARZ
         MPg20mobH3LwXo+Kn89TORBec+u/89bzPu5i8yycEVlDpO/vtC/DNzR2qvNjw+sEU1Vf
         tHs/PFPYLcOBi8afgwu+g006VVwkThlxkNsACsrUQAV2YEZseJ7JG2wGZr5Vrcp30x+f
         TKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dUrHYPjTeyeIaiftDlK8lvhq4xdyB6rSMhx+E9kZeQI=;
        b=iIO+SHZNdizgWf4Fc4OHJPGqiXF+ZO2AMiB838Fp5AOtbC4Gb4REd7BvA6Swt7CHKk
         EPbUOCQaqbBOKXyVzLjLC1ZnIH1mgdU966Reb+8irEXXspxMsHPuGxLVLwZLzI2DAS+D
         fujJMNj2hvBpJ1j44AzxFq49csUhQbyZh1en2XmSSsO/XEnBy0RxXjPAiXejcGSUwCyc
         oOZAYoDVgZSdYwDdXIwl7uQxqFcOsJQzmJYDomZEIB+CkgaNR243NxI5sO6Fpfe+A90o
         ybpJQY5fV3sPHP12c3XAFSyAgvOHzTkzQtMMpY6QTPzEUA778BKAZo9YCYnEikY/43mV
         zQ8A==
X-Gm-Message-State: AJIora/30LuLOJwBeI+hKiWwEg8wN8Pkeft46ZjAALMDeC4FlnqOsP0L
        1ncfhb+ydCg1XjDcUGvmRwktbqglIj4=
X-Google-Smtp-Source: AGRyM1uxtN4kfUs+KDPhUJOzCINTOwvP2Tf5ZCH5wEjU8SgnIy/HKAxWzaoLeqWCVfnitfkG/N6r2akI3FQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f353:b0:167:7bc1:b1b9 with SMTP id
 q19-20020a170902f35300b001677bc1b1b9mr6211259ple.117.1655243917791; Tue, 14
 Jun 2022 14:58:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 21:58:28 +0000
In-Reply-To: <20220614215831.3762138-1-seanjc@google.com>
Message-Id: <20220614215831.3762138-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220614215831.3762138-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 2/5] KVM: nVMX: Snapshot pre-VM-Enter DEBUGCTL for
 !nested_run_pending case
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Wang <lei4.wang@intel.com>
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

If a nested run isn't pending, snapshot vmcs01.GUEST_IA32_DEBUGCTL
irrespective of whether or not VM_ENTRY_LOAD_DEBUG_CONTROLS is set in
vmcs12.  When restoring nested state, e.g. after migration, without a
nested run pending, prepare_vmcs02() will propagate
nested.vmcs01_debugctl to vmcs02, i.e. will load garbage/zeros into
vmcs02.GUEST_IA32_DEBUGCTL.

If userspace restores nested state before MSRs, then loading garbage is a
non-issue as loading DEBUGCTL will also update vmcs02.  But if usersepace
restores MSRs first, then KVM is responsible for propagating L2's value,
which is actually thrown into vmcs01, into vmcs02.

Restoring L2 MSRs into vmcs01, i.e. loading all MSRs before nested state
is all kinds of bizarre and ideally would not be supported.  Sadly, some
VMMs do exactly that and rely on KVM to make things work.

Note, there's still a lurking SMM bug, as propagating vmcs01's DEBUGCTL
to vmcs02 across RSM may corrupt L2's DEBUGCTL.  But KVM's entire VMX+SMM
emulation is flawed as SMI+RSM should not toouch _any_ VMCS when use the
"default treatment of SMIs", i.e. when not using an SMI Transfer Monitor.

Link: https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 66c25bb56938..4a53e0c73445 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3379,7 +3379,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
 
-	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
+	if (!vmx->nested.nested_run_pending ||
+	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
 	    (!vmx->nested.nested_run_pending ||
-- 
2.36.1.476.g0c4daa206d-goog

