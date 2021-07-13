Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25DF3C749C
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhGMQg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhGMQg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:27 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58004C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:37 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bm22-20020a05620a1996b02903b87dad5a1dso4009873qkb.23
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc:content-transfer-encoding;
        bh=yeyM8miFXVfhYCiRacpfh4x5/Y1VXoOxcgLbMzodMTs=;
        b=gmkIzyulalQgm0iUkw5EyMI4acmPrftCi/JxE0avsh261tlyjOsTc8y3eCFLK4U2xj
         4kMtA7UeZ8G5aJwgY7KEbGInJGWrQqEEns3qJzuxuW1KoLj+KPqVhRXa0Mt3TrLYfPOw
         bPgGWsWO3VwZM0GLigsA92jIZERVIPFwD20MS1hpLdwc/3nHnwpHDXzLMwM+fIw8XtM4
         vSwAXaSy0sE8JwcIfU4EsYGfBiRWfzfaM/qXn3KuCFDZIuneUXZkhevPebN5elEwjjry
         xtDF80ue9AK2pfDYCLUCGxX5PzK2swNv30wmbASC+CHfCAkc+LG0Cngbqzk6ruE/8OgZ
         IZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc
         :content-transfer-encoding;
        bh=yeyM8miFXVfhYCiRacpfh4x5/Y1VXoOxcgLbMzodMTs=;
        b=WrBWDQVUDodjH0f6XIm7XcoeOsQYQ8AKU/chiBCUw3+QCafS4z+4zzA31MS6ci/StX
         pqjakSYEhBDYzzb5Q3XZ+7HBaGmI9Rfu0k5PGmsQiAWWFQoi/babX6l7RV0VfJ7sZJsE
         uDQ4hAoywBxZ3eQHVx4ISklbyXfd3waEF7mAk5Qx2f2F+Y0n1D/RwDi7/ZICnZkGl9Cp
         Ml0fGebXdWqFBMu2CWf6aHc4LygcvrKWv1tZAuAaDXiN8KIaVEgn9qI+AGqNZFlj/xnc
         3ReajlFIO0K3JEdVEBMLB++js8636bFq5aMufGj8/qL5iOrXv3ski5EA9pufBuSGtDy6
         PdiQ==
X-Gm-Message-State: AOAM530PAjZIyZpWeHvxZm7qrwY4eEvLJZIy974JR1FWVNH9DuXNL4vo
        PIHXrcGb0zRSy4loet+f+WIVsA3TO3U=
X-Google-Smtp-Source: ABdhPJzNv3IrIvUUMO8p+vTbbzvg8/gZPxZ+5gcJjFCq3w/wqMdzu0+2wJRWpZC/wQLsNMZ8ef8ajgs/xvE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a0c:b44b:: with SMTP id e11mr5841955qvf.38.1626194016387;
 Tue, 13 Jul 2021 09:33:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:39 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 01/46] KVM: x86: Flush the guest's TLB on INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flush the guest's TLB on INIT, as required by Intel's SDM.  Although
AMD's APM states that the TLBs are unchanged by INIT, it's not clear that
that's correct as the APM also states that the TLB is flush on "External
initialization of the processor."  Regardless, relying on the guest to be
paranoid is unnecessarily risky, while an unnecessary flush is benign
from a functional perspective and likely has no measurable impact on
guest performance.

Note, as of the April 2021 version of Intels' SDM, it also contradicts
itself with respect to TLB flushing.  The overview of INIT explicitly
calls out the TLBs as being invalidated, while a table later in the same
section says they are unchanged.

  9.1 INITIALIZATION OVERVIEW:
    The major difference is that during an INIT, the internal caches, MSRs,
    MTRRs, and x87 FPU state are left unchanged (although, the TLBs and BTB
    are invalidated as with a hardware reset)

  Table 9-1:

  Register                    Power up    Reset      INIT
  Data and Code Cache, TLBs:  Invalid[6]  Invalid[6] Unchanged

Given Core2's erratum[*] about global TLB entries not being flush on INIT,
it's safe to assume that the table is simply wrong.

  AZ28. INIT Does Not Clear Global Entries in the TLB
  Problem: INIT may not flush a TLB entry when:
    =E2=80=A2 The processor is in protected mode with paging enabled and th=
e page global enable
      flag is set (PGE bit of CR4 register)
    =E2=80=A2 G bit for the page table entry is set
    =E2=80=A2 TLB entry is present in TLB when INIT occurs
    =E2=80=A2 Software may encounter unexpected page fault or incorrect add=
ress translation due
      to a TLB entry erroneously left in TLB after INIT.

  Workaround: Write to CR3, CR4 (setting bits PSE, PGE or PAE) or CR0 (sett=
ing
              bits PG or PE) registers before writing to memory early in BI=
OS
              code to clear all the global entries from TLB.

  Status: For the steppings affected, see the Summary Tables of Changes.

[*] https://www.intel.com/content/dam/support/us/en/documents/processors/mo=
bile/celeron/sb/320121.pdf

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8166ad113fb2..4ffc4ca7d7b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10867,6 +10867,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool in=
it_event)
 	 */
 	if (old_cr0 & X86_CR0_PG)
 		kvm_mmu_reset_context(vcpu);
+
+	/*
+	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
+	 * APM states the TLBs are untouched by INIT, but it also states that
+	 * the TLBs are flushed on "External initialization of the processor."
+	 * Flush the guest TLB regardless of vendor, there is no meaningful
+	 * benefit in relying on the guest to flush the TLB immediately after
+	 * INIT.  A spurious TLB flush is benign and likely negligible from a
+	 * performance perspective.
+	 */
+	if (init_event)
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
=20
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
--=20
2.32.0.93.g670b81a890-goog

