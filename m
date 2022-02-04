Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E294AA158
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiBDUrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiBDUrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:13 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E44C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:13 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id a185-20020a6bcac2000000b00604c268546dso4842100iog.10
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TTxMhtKc3iSNKzWjOY2I8dsoN059H4oxNJpf8eFE8Yg=;
        b=L30f8wuRgkYJRCntCSdRfunN35fl0sV+6QU4kfAwqcoO0KLwd3tc41E8CCyhEusqJ/
         Irsx6Qfdv2OaT0nwrmXupQPtw9AL4u2GoRQaYInkO73qbHcuVix5S5t/m4ZvHt055mNC
         U8mErcvl6Cml+iIBTUgSW2VYDnqsufNayPYxkZbqH/sTS7zfcM0D6uUvusY434ItL3OI
         dAFaCdVU0J4Zu8UTP8RDmnjzxy0SsCtthVE1/BaPaRNH6OfulcV312v5gTEbhBqoY15Z
         GnleGFOIMd/XZ9bwqLCqWb4leFp8UjLDnz8YZdgTkE0jvKTCzM2LDwbT2Auy/081S/RM
         aN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TTxMhtKc3iSNKzWjOY2I8dsoN059H4oxNJpf8eFE8Yg=;
        b=u2GddXL5FJ1SXprqZVjtPJ34QPJdDMooOe5bCjGAEC/7vmhl08I4JaoZ+yXEjDk5h3
         vfOSyP1gfRAKAEJ3MUI29Aa0/yzu9pb+11ZyUljZ2g44K2auhgJpW4cO0cGKXjJCMxDd
         ChJ3+GCs15w1k/zskNsJKfMRZ0Gnx4xzu9ATUo8rSLkNj665ppwRB73vHvkjX8DkVbAv
         /78pnVx22Wv5IPn9G02nzWipjbuoiYvsA3eiBqUwNJJ9TKwjH5Kxji0j3XptPY27s+5R
         b1Th0NNTV/ipFoOovrHmpePViCZ9/BtsrS11ErxAmXzaDzLDWRXuQES26FGxCjkHrMMq
         DgoA==
X-Gm-Message-State: AOAM531wQekLUdQ9LVMjVUtXIrwLDW6RtjO/5vTVWHxbHHXovm5VApE5
        u7AYuF0fUMAV0Dj/gNi5HKLING5Qeti3Y+PHfvGRG9+G2SX0rXUfGbORCa1dWqeDuit4hoH2wqS
        zHcGBEHrdzpFDIjsDZxk0+9mE5uZYTQOh3MNU1ZKEKc0L+vl6wyksik9Eew==
X-Google-Smtp-Source: ABdhPJzeXxQKi83eDIDSgeJRoHlM/tAPUyRt2nl5D+Q0Kbi2rN6mWlgm8DZr5aizCSC63LuSsjIW8Gt6IPc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:c03:: with SMTP id
 d3mr450236ile.206.1644007631700; Fri, 04 Feb 2022 12:47:11 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:47:00 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-3-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 2/7] KVM: nVMX: Keep KVM updates to PERF_GLOBAL_CTRL ctrl
 bits across MSR write
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d63d6dfbadbf..54ac382a0b73 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7242,6 +7242,8 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
 		}
 	}
+
+	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
-- 
2.35.0.263.gb82422642f-goog

