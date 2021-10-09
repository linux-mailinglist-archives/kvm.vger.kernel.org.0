Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E03427622
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244399AbhJICQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244507AbhJICQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:16:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23DFC06177E
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p8-20020a056902114800b005bad2571fbeso3624566ybu.23
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SdOYPzkyfZrBWx1GJeur2Vwb7zEvl7JYNbVbQ0SB2Gg=;
        b=aUvGN/4AFgJcKIBF9LBWgDwhCHQZYEJ03JrconxIXHeAq0mSobvx5eFsN2IhEk7hMF
         07jWDFM9e+ezgnVy0PqTHsU8wjkF0Sq/uHjyc0w84aIFVqAcJRuuc8LQH3WxNpDQiA8J
         1gOwXo6k1Mjhlm2dzNYz4rr2omGOTIv9FMsD0TA3lqfU/1iEz7W8Tub84Aqukc87X1xM
         piXJImDfP3oyBzKVi6TuZiCoM21cARPSFti7XJOcRw2PuPbisGedjpLV+YL9vQi2purC
         N3om2H5mKJxeus7ZcbgIF+EPMNOHqwS7dYW8kbDAw9PWlIpsbYSk0g7cYENwS5oOjCiw
         mX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SdOYPzkyfZrBWx1GJeur2Vwb7zEvl7JYNbVbQ0SB2Gg=;
        b=xqvO/NmRZVLzQmzuDy71YW8DcRUeY7WyiK6dFUFKaiYUPWr+dSWSGwkjfZPoz46kSK
         tb8gh9QGeEIAM7l//cfLQ820rYK1J3TfEY8DpdAUe8qzbBIapCrKHvRcSZkrSGuaitad
         eyaX75ynnccIl7WDJ42SwvtRHTLL2HF/dEX0HGcZsuHE9enoP4ggZG1CqYG6QKsxGqp6
         zDsUEMwKlSdBAlQX+I7zWQEPhf14LVi13uxOq3znYdqUQkks7wLeL5Gdp6SrBAm/zwfG
         c6VKBp1iicJkeKCyZ4Z1gokFydKfjs6D5bt3M4t5gx4llNFclpF9FJgw3Lfsx6uP0+UG
         +s8Q==
X-Gm-Message-State: AOAM533p+m78B7Nyu3vB+O6LoXQ/uIujgSkHJYYGS0Z8474YA3mfw0u4
        YQe/OdXNAbe5HHJtmzdnk7GLGJVzfJM=
X-Google-Smtp-Source: ABdhPJxYoBKdyJNsrFu59iAPxlEnyIVO9cffUZpeFin68SfrlNt2dK+2hwMzncpFoR3FTBopTnOtfheDhwY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:6e06:: with SMTP id j6mr7636609ybc.311.1633745615988;
 Fri, 08 Oct 2021 19:13:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:15 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 22/43] KVM: VMX: Drop unnecessary PI logic to handle
 impossible conditions
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

Drop sanity checks on the validity of the previous pCPU when handling
vCPU block/unlock for posted interrupts.  Barring a code bug or memory
corruption, the sanity checks will never fire, and any code bug that does
trip the WARN is all but guaranteed to completely break posted interrupts,
i.e. should never get anywhere near production.

This is the first of several steps toward eliminating kvm_vcpu.pre_cpu.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 67cbe6ab8f66..6c2110d91b06 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -118,12 +118,10 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
 
-	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-		list_del(&vcpu->blocked_vcpu_list);
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-		vcpu->pre_pcpu = -1;
-	}
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	list_del(&vcpu->blocked_vcpu_list);
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	vcpu->pre_pcpu = -1;
 }
 
 /*
@@ -153,14 +151,12 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 
 	WARN_ON(irqs_disabled());
 	local_irq_disable();
-	if (!WARN_ON_ONCE(vcpu->pre_pcpu != -1)) {
-		vcpu->pre_pcpu = vcpu->cpu;
-		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-		list_add_tail(&vcpu->blocked_vcpu_list,
-			      &per_cpu(blocked_vcpu_on_cpu,
-				       vcpu->pre_pcpu));
-		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
-	}
+
+	vcpu->pre_pcpu = vcpu->cpu;
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+	list_add_tail(&vcpu->blocked_vcpu_list,
+		      &per_cpu(blocked_vcpu_on_cpu, vcpu->pre_pcpu));
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 
 	WARN(pi_desc->sn == 1,
 	     "Posted Interrupt Suppress Notification set before blocking");
-- 
2.33.0.882.g93a45727a2-goog

