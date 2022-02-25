Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDDA4C4F4A
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiBYUJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiBYUJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:08 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FBF1F03AD
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:36 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id d194-20020a6bcdcb000000b0063a4e3b9da6so4496604iog.6
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ai/+la0RYgtOBot3jbPAV3BwqgO07uDC5MnkveDrMNw=;
        b=G7ebjf3UAJPl9sr2mNokIOUbwM7QrxshwWQ2V5xpI9kIso0wwceO2dk3T/pinM7w7B
         gnL3qOQeGyEUt5xTUjq7zNLY0VTqZmA/VB3FkfX2rtiKL4vXAX1oYIu+OFzNuyDWxbum
         JciDgpvkwuyChRN+SaWrh0kOWYMsmh1XK/i5xuKiAK3fjVANarnczpUOre3G5aLrihL0
         JjHUX8+FaMgCve6QxeCiS7d/KGHE0l57wEopXweZR/NsJKX0kxWVGErSt6kz8BHd7y61
         XNo2f8Mm8DTbhRC0B7Z5oGFTx8X9zFATYWycpc0qYDaZxTWBeucHRG3IIXv5+RtqZaTr
         XGWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ai/+la0RYgtOBot3jbPAV3BwqgO07uDC5MnkveDrMNw=;
        b=QZQQuQ+Ke5r+FR1o4XnaFhQIu7lVSs9/FRgzWiwGy3CQBifu7R5mDF3CuC9E5dTaww
         j55DFjawHZbsFYRE1Ws1TihO/cprprH76XT2yLC1sjhP03WXwCteri9zyDqohvlEeX9n
         CXO8e6LSP1ySPXMkj3mMEWNuQMVAArfnLAvjYchWotsPz9ePi7XmsUbGZ9jDPs1bxbqB
         Ns+HlRq1Qtle6igEvbo8BTLC3Tu4JntWeNYE+znH6ZFFygWvDQJfcWL5Yge8BN/MnCKg
         6BCaFyDMHvOttB4ozPSCc5dkTjgx6quYh/us65rpYdg1DjJQNP5OQ8kT59HhTfBf0CzW
         9ppA==
X-Gm-Message-State: AOAM533sqXgAi0iJxlybYibdmpSTUaGRxu3Gh4q0mBHgRkHAQRJ5qgeF
        ev0rW0quP4+3ZzAPQWU5DUPGvRWX373oDx2SsD6qd7VSRrg9XzB1dwdczTtB4W/L3IIxoSTLZxN
        em9Syyg6fhzvBnCnDFRvMcyZpnIrDBCvmcvSOC72Sh6wcGBzn7rJXUU5eWQ==
X-Google-Smtp-Source: ABdhPJzZA/TXlWpmhaAI0COzAB6RXVLG3zTICUmR+ZnFV7OvwEKog+mLTE7g2t3QcforkAVfE8eVBDEHoc0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:9b06:0:b0:641:808b:4240 with SMTP id
 j6-20020a5e9b06000000b00641808b4240mr6555500iok.209.1645819715835; Fri, 25
 Feb 2022 12:08:35 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:19 +0000
In-Reply-To: <20220225200823.2522321-1-oupton@google.com>
Message-Id: <20220225200823.2522321-3-oupton@google.com>
Mime-Version: 1.0
References: <20220225200823.2522321-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 2/6] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl
 bits across MSR write
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
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

Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
VM-{Entry,Exit} control"), KVM has taken ownership of the "load
IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits. The ABI is that
these bits will be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if
the guest's CPUID exposes a vPMU that supports the IA32_PERF_GLOBAL_CTRL
MSR (CPUID.0AH:EAX[7:0] > 1), and clear otherwise.

However, KVM will only do so if userspace sets the CPUID before writing
to the corresponding MSRs. Of course, there are no ordering requirements
between these ioctls. Uphold the ABI regardless of ordering by
reapplying KVMs tweaks to the VMX control MSRs after userspace has
written to them.

Note that older kernels without commit c44d9b34701d ("KVM: x86: Invoke
vendor's vcpu_after_set_cpuid() after all common updates") still require
that the entry/exit controls be updated from kvm_pmu_refresh(). Leave
the benign call in place to allow for cleaner backporting and punt the
cleanup to a later change.

Uphold the old ABI by reapplying KVM's tweaks to the BNDCFGS bits after
an MSR write from userspace.

Fixes: c44d9b34701d ("KVM: x86: Invoke vendor's vcpu_after_set_cpuid() after all common updates")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9617479fd68a..77d74cbc2709 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7257,6 +7257,8 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
-- 
2.35.1.574.g5d30c73bfb-goog

