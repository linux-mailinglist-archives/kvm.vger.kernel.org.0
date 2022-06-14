Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F338F54BD25
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 23:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352180AbiFNV6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 17:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358024AbiFNV6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 17:58:42 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281D1E3DB
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:41 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-313aa142909so36679127b3.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hM7xMbhXzzpQsznI3mGO8g+Dd+xj8PMNtipqtZvGG6k=;
        b=GuwmpLX88ftCnnpvqBc0WWzPL0wSNukaXGYAF8kRU3fV4GL4+B9Elr4s4+wWKQ3/Rz
         xg+LLlOREPuRcRxHZKOFIBVH6tpVgBcu+qg1SyPbYUuTj2LeHp4CzOFvYXE9NL+dQt1o
         +Vw0KhKxEtxeoXYu9Sj5Zl0XeKb8VflPBYqi0tGcGGuDmaOIEC/hxaGQZMlFoiLPgt48
         m0Gk4uwi/E2c2iCDlKMiCd0GOlJfPgP6eKlWtS1GaMP4EVNyXrivSMOwwTyNIvKB+PBU
         uf651/XmhZiMVcMv1l9rlJ/4l5c6D+8s/y89roi6/XOnE9ZysvYaodORfCg8EVWtW3J0
         zs1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hM7xMbhXzzpQsznI3mGO8g+Dd+xj8PMNtipqtZvGG6k=;
        b=55Gxm3rRmknwTcjM8QO79I8jVS13Lw0uMq6elf7iSpdqI6louCoLzsuHlNevZg6Lef
         ehz66Lnp1IdEnuTXhwpzwIAhObRxU3MGc/FmMzva93VzI1SNy8OJ3bZy0HPo6fwOEj9X
         2XiWbETsYvAMliWhlTBfGBiITnV0pXKXJJSJ/Lxlt+XnMuZQV7mnP9H2hZ3A7CptaSZ5
         I0jwArNwCIPKw3COD2n8aUG/17fdsAJ0xA9re2fBPL/IOpx9Nn/xYIW/5W/+KtGG/9za
         rlVQ8OMGkBq5t/cn0WoOXMgvPk9qvCsda6rltjrqvnv6+14ygWinc5qIx9vL5lZ//4Sz
         gtuw==
X-Gm-Message-State: AJIora8foU9tQKTscRFP54C4oQkSBTW28h94DXmWxr5srZwn9q314V+R
        m7gd7bL+dmVVC9oVWO72OYTXFVpu50s=
X-Google-Smtp-Source: AGRyM1tLv+/JKHGTDIKQSxOo/noztvW59rm5koNkZaEIoKlUtzDtwmNubj8LmcaWwHqarnkYTx9vUqSqWNs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:c544:0:b0:663:896f:2236 with SMTP id
 v65-20020a25c544000000b00663896f2236mr6636975ybe.234.1655243921135; Tue, 14
 Jun 2022 14:58:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 21:58:30 +0000
In-Reply-To: <20220614215831.3762138-1-seanjc@google.com>
Message-Id: <20220614215831.3762138-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220614215831.3762138-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 4/5] KVM: nVMX: Save BNDCFGS to vmcs12 iff relevant controls
 are exposed to L1
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

Save BNDCFGS to vmcs12 (from vmcs02) if and only if at least of one of
the load-on-entry or clear-on-exit fields for BNDCFGS is enumerated as an
allowed-1 bit in vmcs12.  Skipping the field avoids an unnecessary VMREAD
when MPX is supported but not exposed to L1.

Per Intel's SDM:

  If the processor supports either the 1-setting of the "load IA32_BNDCFGS"
  VM-entry control or that of the "clear IA32_BNDCFGS" VM-exit control, the
  contents of the IA32_BNDCFGS MSR are saved into the corresponding field.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 38015f4ecc54..496981b86f94 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4104,7 +4104,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
 	vmcs12->guest_pending_dbg_exceptions =
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
-	if (kvm_mpx_supported())
+	if ((vmx->nested.msrs.entry_ctls_high & VM_ENTRY_LOAD_BNDCFGS) ||
+	    (vmx->nested.msrs.exit_ctls_high & VM_EXIT_CLEAR_BNDCFGS))
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
-- 
2.36.1.476.g0c4daa206d-goog

