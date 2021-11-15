Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6824245053C
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhKONWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:22:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231537AbhKONWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 08:22:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636982341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wL8FL6L5F6hP13kAfLAHnZ2vlwmdadJMBOWtZ6gOEW4=;
        b=jBIrG/Y6cxFH2HF2WZjCrqLI9DFzSOZOYZubBjXJ1aps8YDAFsQb8gEK3UmU7UMIUwWGBa
        jmhvTn1dTJzm5Ti33EzAfckE91CTSDkvbIhmd01dzOPYIaqArNkwpiQQb1gBNKbww6j1Gq
        qD7DlOpltkLrkPvjj3zrD91WlvsXxlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-nS0e7JEPMd2tmFYpoF4B9Q-1; Mon, 15 Nov 2021 08:18:58 -0500
X-MC-Unique: nS0e7JEPMd2tmFYpoF4B9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8489B9F93B;
        Mon, 15 Nov 2021 13:18:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDC0E10016F5;
        Mon, 15 Nov 2021 13:18:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/2] KVM: x86/mmu: include efer.lma in extended mmu role
Date:   Mon, 15 Nov 2021 15:18:37 +0200
Message-Id: <20211115131837.195527-3-mlevitsk@redhat.com>
In-Reply-To: <20211115131837.195527-1-mlevitsk@redhat.com>
References: <20211115131837.195527-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the host is running with normal TDP mmu (EPT/NPT),
and it is running a nested 32 bit guest, then after a migration,
the host mmu (aka root_mmu) is first initialized with
nested guest's IA32_EFER, due to the way userspace restores
the nested state.

When later, this is corrected on first nested VM exit to the host,
when host EFER is loaded from vmcs12,
the root_mmu is not reset, because the role.base.level
in this case, reflects the level of the TDP mmu which is
always 4 (or 5) on EPT, and usually 4 or even 5 on AMD
(when we have 64 bit host).

Since most of the paging state is already captured in
the extended mmu role, just add the EFER.LMA there to
force that reset.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd7..a44b9eb7d4d6d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -364,6 +364,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
 		unsigned int cr4_la57:1;
+		unsigned int efer_lma:1;
 	};
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4d..5c4a41697a717 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4682,6 +4682,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 		/* PKEY and LA57 are active iff long mode is active. */
 		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
 		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+		ext.efer_lma = ____is_efer_lma(regs);
 	}
 
 	ext.valid = 1;
-- 
2.26.3

