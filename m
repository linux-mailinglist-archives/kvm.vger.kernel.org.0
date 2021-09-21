Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463E0412AE0
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbhIUCCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbhIUB5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:03 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325E3C06B66B
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:09 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bl32-20020a05620a1aa000b004330d29d5bfso79994084qkb.23
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hB1u/1U7FVrwJRpX8vQCTsPiyuWdnEtzgh8L/+VT5Qw=;
        b=WoAhVbZLjlFRzVrS8pcCW/UkTgcCHABwERWL7df6mCwj0v5eNci4Ld509z01PeU+ea
         qTmt/SHj803jnMZh/GTzCWBxC6x1NJJ2sq6VuiNMwpVoZ7x0CqHO3aVCdKr8FYc7ib4s
         ehYBewljs2ivKAaOq5CvuwCz72uINos7zC6MuOR7c9S5eLhJGZeteCbr5OnK536uaMry
         hzl3nZKK+LYJJR8gVXewgn3K6nAQbIknVAaJS3aZd+IUTnkgkIq2MrOQOaRzQ+UZxtIr
         eUdZP+L2f5EMSlrNHs8f/x7LOXw/orw9kB1C6NPSdvAOa5ey0VOWM336trEGvPHKL3u2
         s0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hB1u/1U7FVrwJRpX8vQCTsPiyuWdnEtzgh8L/+VT5Qw=;
        b=mn7qBq6t9Fg9uyz2MQxPbZRhegR+vGirtOW5qeZ0LL9K9g3HX+c41aiCom3WrIxXdw
         WyqLQoTXm7AMzUPUcqdfPXOHjr1eRIms45xXPrr0b1gTv5vJwRB7wjFShYSHLeNNiDqG
         uqS+pYGo1WITM1A6PINenLK68rT2uCk7RFENjoZmAJp2cZDoQmYCjzSRm4I1T4Ix/wu0
         le/tzgpMvxZsWCIH4neY0uWKC6NYagE9jauaOkB80LO8pNNcbvzO5MgA7mNoq9eaeL2O
         lEdzCqQ5vM/vytPXmzsPTzZseVAtZs03IuihhK3bfkqNViFDppnhizNwu3QgUhL90dHh
         WFoQ==
X-Gm-Message-State: AOAM532dVKCMeM1t7vKOai8ZVehbyo9GaUuCfSt6NG7SdW2OC6PoEyTr
        /HCWDsrXFW5HhwAi0wH3U1B5QO3ofow=
X-Google-Smtp-Source: ABdhPJzvtZ/5YByftSpZCQBoBJ6K6ul8seXX6G2+C5UF1vnC35TqXWTP69EI6GrqME15ApX7ks3YQ++mU2Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a05:6214:3ca:: with SMTP id
 ce10mr27837999qvb.12.1632182588340; Mon, 20 Sep 2021 17:03:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:02:54 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 01/10] KVM: x86: Mark all registers as avail/dirty at vCPU creation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark all registers as available and dirty at vCPU creation, as the vCPU has
obviously not been loaded into hardware, let alone been given the chance to
be modified in hardware.  On SVM, reading from "uninitialized" hardware is
a non-issue as VMCBs are zero allocated (thus not truly uninitialized) and
hardware does not allow for arbitrary field encoding schemes.

On VMX, backing memory for VMCSes is also zero allocated, but true
initialization of the VMCS _technically_ requires VMWRITEs, as the VMX
architectural specification technically allows CPU implementations to
encode fields with arbitrary schemes.  E.g. a CPU could theoretically store
the inverted value of every field, which would result in VMREAD to a
zero-allocated field returns all ones.

In practice, only the AR_BYTES fields are known to be manipulated by
hardware during VMREAD/VMREAD; no known hardware or VMM (for nested VMX)
does fancy encoding of cacheable field values (CR0, CR3, CR4, etc...).  In
other words, this is technically a bug fix, but practically speakings it's
a glorified nop.

Failure to mark registers as available has been a lurking bug for quite
some time.  The original register caching supported only GPRs (+RIP, which
is kinda sorta a GPR), with the masks initialized at ->vcpu_reset().  That
worked because the two cacheable registers, RIP and RSP, are generally
speaking not read as side effects in other flows.

Arguably, commit aff48baa34c0 ("KVM: Fetch guest cr3 from hardware on
demand") was the first instance of failure to mark regs available.  While
_just_ marking CR3 available during vCPU creation wouldn't have fixed the
VMREAD from an uninitialized VMCS bug because ept_update_paging_mode_cr0()
unconditionally read vmcs.GUEST_CR3, marking CR3 _and_ intentionally not
reading GUEST_CR3 when it's available would have avoided VMREAD to a
technically-uninitialized VMCS.

Fixes: aff48baa34c0 ("KVM: Fetch guest cr3 from hardware on demand")
Fixes: 6de4f3ada40b ("KVM: Cache pdptrs")
Fixes: 6de12732c42c ("KVM: VMX: Optimize vmx_get_rflags()")
Fixes: 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
Fixes: bd31fe495d0d ("KVM: VMX: Add proper cache tracking for CR0")
Fixes: f98c1e77127d ("KVM: VMX: Add proper cache tracking for CR4")
Fixes: 5addc235199f ("KVM: VMX: Cache vmcs.EXIT_QUALIFICATION using arch avail_reg flags")
Fixes: 8791585837f6 ("KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..e77a5bf2d940 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10656,6 +10656,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	int r;
 
 	vcpu->arch.last_vmentry_cpu = -1;
+	vcpu->arch.regs_avail = ~0;
+	vcpu->arch.regs_dirty = ~0;
 
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-- 
2.33.0.464.g1972c5931b-goog

