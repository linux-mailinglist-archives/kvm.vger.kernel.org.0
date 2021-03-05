Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F02632DEF0
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhCEBLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhCEBLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:45 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893EAC0613D7
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 194so689832ybl.5
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=a0iu5Jr62fO/y6sZLX97v683VVAURhp+4UWYw55JC8A=;
        b=a2TdeP2jIifcVwzqSBDM0de5+MwbT43APmxx1Fo6PChIdw0LzDMC9HH6i09sQbEvEQ
         nsyBB+1a0yRtBfvP2QLcuusKIDVaJIyt2qi927seF24rIwjt/udvGo4h0hYKjPzZ9/Tc
         CLr+SlevtE/inchuXygmJbsrDG+ALFWdiRVcBqXQqJi9rzfiOZ5EJODShYqljY3lHYE1
         IA8Cl4sh4rzvzaT3TLvsFFuRKvuMcRvstyQ5HgLNxFyCelqK37iuhOXXXbcoHzAy7eng
         JF2iI6cZShez1bzrx2ti3DJgXO+TKcMXM373c3PeViizQuDK12tO0dqa2W2PAL5N2mNH
         /VsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=a0iu5Jr62fO/y6sZLX97v683VVAURhp+4UWYw55JC8A=;
        b=AS08qtzvC/m4XogWG0PaUCUeAhafTEq+HoIn5iBjZsX1vWF34MyvPOyKjCVHrH79Yf
         pwvQzhnh8eRWBS1I1thfnBPNpG4DnI/i79uHc5m+zqhYYEt+tcZ5ZRq/76GFG1SRaBtj
         aJQlrUnOCCiubJyKIRUrwq7V6VYuDk3OiqZZ62cOgavo+ku5dfLCtqs+F8Y0iq4o5cAD
         wk2cCD6RN/Yc/eLQUlji7OLuGoY5yZuaGQjERja24ZGc/bTI+N+jE/fDL2+aemgVhp1K
         lN7EvahdNMtGp0SKZmqMmoMaU8ZOBdx2N6MgcEv4T8JT+qo0vYMu+y/XquODvEB9/x4D
         y3nQ==
X-Gm-Message-State: AOAM532zqyHwL98ebpqlHJvAWDYP+pT77U/mPUTtmxy1S5lOHmE1zsgl
        pny3MnsHxqoqwSF1mN4DV8oO0xftZ5I=
X-Google-Smtp-Source: ABdhPJzgFxnA5s0adQuP9jc1yY23XBQGOxKNuuDdMTj9ETO8QkE751E1BJ0BbCGDJhnhGUcLZF+QyU861W8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:655:: with SMTP id 82mr9307990ybg.168.1614906703841;
 Thu, 04 Mar 2021 17:11:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:11:00 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 16/17] KVM: x86/mmu: Sync roots after MMU load iff load as successful
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For clarity, explicitly skip syncing roots if the MMU load failed
instead of relying on the !VALID_PAGE check in kvm_mmu_sync_roots().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4f66ca0f5f68..bceff7d815c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4850,10 +4850,11 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
 	write_unlock(&vcpu->kvm->mmu_lock);
+	if (r)
+		goto out;
 
 	kvm_mmu_sync_roots(vcpu);
-	if (r)
-		goto out;
+
 	kvm_mmu_load_pgd(vcpu);
 	static_call(kvm_x86_tlb_flush_current)(vcpu);
 out:
-- 
2.30.1.766.gb4fecdf3b7-goog

