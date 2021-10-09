Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D714275E0
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbhJICPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244345AbhJICPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:15:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AB9C06176D
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y16-20020a2586d0000000b005b752db8f97so14924883ybm.18
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=crdXztg9++vBF99WovoTawrTDZAMlepONlGnGeI4yW0=;
        b=poNGQMstvhEww3j/q+Ew2K+kNGbRr43AknFTBRh6WmHfINYVTEZ8xwMCg3y/Oe0NTr
         JtR7XEPh6F0hNfpa7j0f0RwTpV2urRBu3LMP+OKFGJcSZrESErjqFnLHWoSw1ikwE0o1
         UkxXXzg8yn/8yoLlIGTWwkwNWIU3bDlweiuiVGKXvNbXpeSJbXUFTmJ78JXoB8GBPJw2
         Mxj9q9UdsBWYyWx2wIwXfPBkBDNwtFvcrIvOy5n8ZO7r3niACNa+V6HpFHN56wIysh/P
         Cwz5E66bxfbW3Pz3Ruv8j5UfmgJXe5yN635GAZ7qZZ8Qx3Cc9Yvo9ZcfDICQydkTtIEI
         6A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=crdXztg9++vBF99WovoTawrTDZAMlepONlGnGeI4yW0=;
        b=3PDxuZaIom7NalvI0I/K8Y7gqFQPrkLyfCYL91icTNvZuSUK3itgQYRP/Buy3yjqmr
         GkekFkP4iBTzMxgqV8KuVP1xumI7EmaBLggTaaDXiqj3xUiEHIao4F+qdB6W0vZtn54V
         /lL8YB+mwryvNJkYa9wQwt01u58wm6t769+dAzD2Bxqrqq3RrIZpL2tNEHx1f9PTfcNN
         syaeR4ApprPAZ2aSdCf3hN/wwl9tTlDQ4ygpue4T/T7iGR4FUn2pwux9QNZ47f+kvn5s
         UrHMmIRi7zAmaIZ3/PmzhGj9FYSdfPkK/m8fwZJw5pgMwvsBeC0MefOnz0Fwb1a+Pp1Q
         x0NA==
X-Gm-Message-State: AOAM533WdygBBVLmK33khZ7NlqjzyXBc6yZaEmYKbDk/3IEvx2QrBi0C
        TyeK4WPGMw+p37UfkM6v9/J82GxJRCs=
X-Google-Smtp-Source: ABdhPJzcfIZ1Zv0b5dqnBIvzfvXq4ARXDnmY1mzl0GCln9fUNJg9VNZGpZvCwHJXJWz2rm5XencR2U5y0mk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:: with SMTP id
 w15mr7392080ybt.259.1633745589050; Fri, 08 Oct 2021 19:13:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:04 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-12-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is successful
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invoke the arch hooks for block+unblock if and only if KVM actually
attempts to block the vCPU.  The only non-nop implementation is on x86,
specifically SVM's AVIC, and there is no need to put the AVIC prior to
halt-polling as KVM x86's kvm_vcpu_has_events() will scour the full vIRR
to find pending IRQs regardless of whether the AVIC is loaded/"running".

The primary motivation is to allow future cleanup to split out "block"
from "halt", but this is also likely a small performance boost on x86 SVM
when halt-polling is successful.

Adjust the post-block path to update "cur" after unblocking, i.e. include
AVIC load time in halt_wait_ns and halt_wait_hist, so that the behavior
is consistent.  Moving just the pre-block arch hook would result in only
the AVIC put latency being included in the halt_wait stats.  There is no
obvious evidence that one way or the other is correct, so just ensure KVM
is consistent.

Note, x86 has two separate paths for handling APICv with respect to vCPU
blocking.  VMX uses hooks in x86's vcpu_block(), while SVM uses the arch
hooks in kvm_vcpu_block().  Prior to this path, the two paths were more
or less functionally identical.  That is very much not the case after
this patch, as the hooks used by VMX _must_ fire before halt-polling.
x86's entire mess will be cleaned up in future patches.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f90b3ed05628..227f6bbe0716 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3235,8 +3235,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -3253,6 +3251,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
 
+	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(wait);
 	for (;;) {
@@ -3265,6 +3264,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		schedule();
 	}
 	finish_rcuwait(wait);
+
+	kvm_arch_vcpu_unblocking(vcpu);
+
 	cur = ktime_get();
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
@@ -3273,7 +3275,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
-	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	/*
-- 
2.33.0.882.g93a45727a2-goog

