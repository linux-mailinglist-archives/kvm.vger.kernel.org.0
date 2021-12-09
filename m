Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867DD46E23F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhLIGJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhLIGJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 01:09:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFB1C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 22:06:00 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e7-20020aa798c7000000b004a254db7946so2985161pfm.17
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 22:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=F7npRncW4+LVdPKAlFpehwCV1qj+xFDxIzbAJ1uOvTk=;
        b=WdzSiW/OqdqHQfuBzRXxl7bxnBT1nkV8M7OsO+le7hB5TxSQAicRndC5ShH50gOQSU
         geoxCwROmTrtqNVRCIxLIK565QwFMn23uv3wWx64xlrvMeEZs7HUBS4W77X+YU/2HVpc
         3ECaAz791DvPx/flJk6gBHuQc1Oaj7O0Vnd640zmpVKwK92A8duQjWconn1pte0cs5Zc
         wT/xwe+XihQDPxrkWzrdITj6NaQpyjQG4HVNtsC78accNJzMTEI2vc5cekAIeljS+dIP
         l4kMB9gbVwdpzsd2RgAgdU3nd3EFdqtxLc7qgDrZGacEvuDi/s3YlBp/QT5INvv6Nrn9
         XS+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=F7npRncW4+LVdPKAlFpehwCV1qj+xFDxIzbAJ1uOvTk=;
        b=pUkuei+jYFx3g5KBh19BxJciuXRKEnF7FNx/4dCMcdTll1kTxueKi7Zz/8+ypqjH5C
         qPDgOBmJrgG1u0gtFinOXyxMs472flMhHpuKhuJjhFnVCyhBd6eJdgm3djkirnzcsWyZ
         F/sFKyqA+EMbK/DRcB1C9CKLwbjlUHwhPrwOGqAPCUfadQ2JH0vEkP54smuyncsQAO+9
         isvmmlucUOQ4WvAShGOQqgR5gu7bET955Yaax33DQtZhQ/gg1c0Yu8s9Jk0hZbkf/dgP
         Q6Dr7DaY+eEyJPSjiSgrdm8kPUZtayTcf0nyuyDHVZYiRAbqIyRy2RWbspfKg6hzsiVl
         Pm8A==
X-Gm-Message-State: AOAM533jxZ7xdudxansl7/srKuZ3dcSvqbwrHdyEzgxYQ79DVy3RyB1s
        pgpIPPac5oJdCn8cKCK+kUn0x8y/Duk=
X-Google-Smtp-Source: ABdhPJytxpXAKw2TvuAPeJ9SFwMk1d5/jdVEtD/+MiWDuz0q2Pr8MexQZSYten3U0lNUgeqmZeLvfGcTDH4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6506:b0:143:84c4:6555 with SMTP id
 b6-20020a170902650600b0014384c46555mr64832906plk.8.1639029959878; Wed, 08 Dec
 2021 22:05:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Dec 2021 06:05:46 +0000
In-Reply-To: <20211209060552.2956723-1-seanjc@google.com>
Message-Id: <20211209060552.2956723-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211209060552.2956723-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending and
 root has no sp
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Play nice with a NULL shadow page when checking for an obsolete root in
the page fault handler by flagging the page fault as stale if there's no
shadow page associated with the root and KVM_REQ_MMU_RELOAD is pending.
Invalidating memslots, which is the only case where _all_ roots need to
be reloaded, requests all vCPUs to reload their MMUs while holding
mmu_lock for lock.

The "special" roots, e.g. pae_root when KVM uses PAE paging, are not
backed by a shadow page.  Running with TDP disabled or with nested NPT
explodes spectaculary due to dereferencing a NULL shadow page pointer.

Skip the KVM_REQ_MMU_RELOAD check if there is a valid shadow page for the
root.  Zapping shadow pages in response to guest activity, e.g. when the
guest frees a PGD, can trigger KVM_REQ_MMU_RELOAD even if the current
vCPU isn't using the affected root.  I.e. KVM_REQ_MMU_RELOAD can be seen
with a completely valid root shadow page.  This is a bit of a moot point
as KVM currently unloads all roots on KVM_REQ_MMU_RELOAD, but that will
be cleaned up in the future.

Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ccee4d17481..1d275e9d76b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3971,7 +3971,21 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault, int mmu_seq)
 {
-	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
+	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);
+
+	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
+	if (sp && is_obsolete_sp(vcpu->kvm, sp))
+		return true;
+
+	/*
+	 * Roots without an associated shadow page are considered invalid if
+	 * there is a pending request to free obsolete roots.  The request is
+	 * only a hint that the current root _may_ be obsolete and needs to be
+	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
+	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
+	 * to reload even if no vCPU is actively using the root.
+	 */
+	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
 		return true;
 
 	return fault->slot &&
-- 
2.34.1.400.ga245620fadb-goog

