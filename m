Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DABE427639
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbhJICRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244385AbhJICRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:17:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3292BC0613A6
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:49 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id j6-20020a05620a288600b0045e5d85ca17so9768255qkp.16
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wjQtX4Ec6wZvrLi6PMkrNqIQ2oyMcPdDf1m/MoA8d+0=;
        b=Lnm/cjPXbd272GpMZC0UeDF+UHTqiJU1haGCknMr5AmNFQOxgzVQrkCrFXx8cCosZZ
         vhad/H/bU6EtWHdiaGljqq6NEDe4jYwnagw1hmypkZVWw7KopTXWbIioXhrKeB9WZIoL
         ReDT+1R5eLOhM0x5my19UH6pmlRFdnAMJjCjW90ue2a+3KqjCQ5KVltKsfzvFJct3Or4
         f9Oft1KiecdRxszaICFl0MAY6x3TalLjCr4OG45jGmzTw8bdrlGkucMOEXd/i271jan6
         0hz+LH0reRdSJS/sNXpSqjCOVK3W+uTEL9F4YDHRKI7A05LpPRMlHE+Kaw+W+rV3UGa5
         UrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wjQtX4Ec6wZvrLi6PMkrNqIQ2oyMcPdDf1m/MoA8d+0=;
        b=Ie7ZqA0HcyQKF4SZigD16diqGTFM+CBNbXfcIkIv951Q+dNcqC3+ADcQmI5yR64kBr
         KJcuNRbKJN/MQPFVy3LXOfxm1MMaejThJm23XW14KfNuKQICLa+WUUjWARHzQcWFG7jd
         BS6YjchxQWWsSZGO/Q2DGDvBMthWs0FmDmysji5tbF/gnaJa94bQnzFD8flr4PFkt7sG
         a0aBeNYLpWmvyZbF3nAlwZq0XEUeNN+mki3qpzJzytaQEqB9Xg7bDIiXg5JbQXfS/P9f
         ujxC1ZRGmEKPjmBrNBzZQF13Ji0T4TeArCSHKvYok0FMChZEGaGusf49TtIuZKLIG8SX
         AHoA==
X-Gm-Message-State: AOAM533A07zE2Xwh4vtS4rFaB+cqlzkHt/bb/7w2C0YA5tA5xNVT2Y4y
        8tn7aKRdaMpQYeCz8zyXLhF8up9L7aY=
X-Google-Smtp-Source: ABdhPJzf4lH44KnogukwF+1XfgXVpbO4vnuwdh3pwX1cj7Z8+jmbGSLZhM6YPlZ7b6MhcrCUeQd2OdsxOQw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:6113:: with SMTP id a19mr1849269qtm.307.1633745628357;
 Fri, 08 Oct 2021 19:13:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:20 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-28-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst computation out
 of write loop
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

Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
out of the loop to write the descriptor, preemption is disabled so the
CPU won't change, and if the APIC ID changes KVM has bigger problems.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index fea343dcc011..2b2206339174 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -51,17 +51,15 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		goto after_clear_sn;
 	}
 
-	/* The full case.  */
+	/* The full case.  Set the new destination and clear SN. */
+	dest = cpu_physical_id(cpu);
+	if (!x2apic_mode)
+		dest = (dest << 8) & 0xFF00;
+
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
 
-		dest = cpu_physical_id(cpu);
-
-		if (x2apic_mode)
-			new.ndst = dest;
-		else
-			new.ndst = (dest << 8) & 0xFF00;
-
+		new.ndst = dest;
 		new.sn = 0;
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
@@ -103,15 +101,14 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
 	     "Wakeup handler not enabled while the vCPU was blocking");
 
+	dest = cpu_physical_id(vcpu->cpu);
+	if (!x2apic_mode)
+		dest = (dest << 8) & 0xFF00;
+
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
 
-		dest = cpu_physical_id(vcpu->cpu);
-
-		if (x2apic_mode)
-			new.ndst = dest;
-		else
-			new.ndst = (dest << 8) & 0xFF00;
+		new.ndst = dest;
 
 		/* set 'NV' to 'notification vector' */
 		new.nv = POSTED_INTR_VECTOR;
-- 
2.33.0.882.g93a45727a2-goog

