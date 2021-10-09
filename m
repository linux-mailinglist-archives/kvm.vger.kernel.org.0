Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8182F427603
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244323AbhJICQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244473AbhJICPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:15:37 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8B2C061766
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:26 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id j6-20020a05620a288600b0045e5d85ca17so9767705qkp.16
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qbaTmooIqpw2scwWIPvYnbgTG8gkipCw/gcnfpltSGY=;
        b=FuJT0BM9dDnYucltpEKN/3PIbfdvyXmexJqecK3YzG4d74UzCBAUJzNpfna5d3hhf9
         CThoB+q3zbECmvBpsVwSPC65vqE3PC/pyRXG3MptW0vOaTjGmTNfFzi4I7G//ciy+nJL
         p2SrF4m156i96jaV+xzdhT+w6QkXcy0HHxtm4YS01i3rZ/GAWxIlxZ4cG090KNqUoG+F
         MZ7IfesCmYwBPSKodHNoD1ZFOQvtV8bnYcdLR84ii1K0oqwvG/i2DqC+H4C9C8AdNE7S
         NtI/ovPQV920bh3qJxqxqTJF2XHwSs9PcFYmvUBVFETjJlGAhfkCawm/pDGPWqba98m2
         bBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qbaTmooIqpw2scwWIPvYnbgTG8gkipCw/gcnfpltSGY=;
        b=vYGERlSDhI3YhHkpCOAhFUsTKjxZNfLH2qzDOYEJVMGoGx1/WuV6nwaHkDBB4SZRyu
         pLq4xpp6PnYSxvnT/sFn3vHhPK+hlaWLPtYrTmXnmI5q5YgiOaI9A0tuPUfeaXSwff9p
         VApuHCkS92m1gePTR38tw+vGjYREDs6iIVlEXBwQrsKBCilgcVlDd/7t3c3E6hXUgzJr
         EMezlhJdrTVaUjx6a3yYpySN9WBrs+oW5eM+he2qnVLPHubECLongp38uJpOdjSBj0/s
         2lBcR/6OTz7DuKGIU2dZnFNH/5z0XqSBHaGIB4tKmSvf7ZnZq6gGLq8F8JuKYuaxMS++
         o8yQ==
X-Gm-Message-State: AOAM530/YIwiEVGx/P2CE84YOSCvJ75De4n0NeSgFAaYjoEyLhp2Hb3l
        HWiae1AqoVz2IS41sRaCqRTEVLN3q/o=
X-Google-Smtp-Source: ABdhPJzmsEVzPU7/MqwbML2H7/jnReeletG9BCOCcGkMjuKkxZyo31ypELMFzY3g7cKF9pg0VOLbDRLLOow=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:ac8:4e11:: with SMTP id c17mr1903866qtw.400.1633745605808;
 Fri, 08 Oct 2021 19:13:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:11 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-19-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 18/43] KVM: x86: Invoke kvm_vcpu_block() directly for
 non-HALTED wait states
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

Call kvm_vcpu_block() directly for all wait states except HALTED so that
kvm_vcpu_halt() is no longer a misnomer on x86.

Functionally, this means KVM will never attempt halt-polling or adjust
vcpu->halt_poll_ns for INIT_RECEIVED (a.k.a. Wait-For-SIPI (WFS)) or
AP_RESET_HOLD; UNINITIALIZED is handled in kvm_arch_vcpu_ioctl_run(),
and x86 doesn't use any other "wait" states.

As mentioned above, the motivation of this is purely so that "halt" isn't
overloaded on x86, e.g. in KVM's stats.  Skipping halt-polling for WFS
(and RESET_HOLD) has no meaningful effect on guest performance as there
are typically single-digit numbers of INIT-SIPI sequences per AP vCPU,
per boot, versus thousands of HLTs just to boot to console.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd51f100e906..e0219acfd9cf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9899,7 +9899,10 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	if (!kvm_arch_vcpu_runnable(vcpu) &&
 	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
 		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
-		kvm_vcpu_halt(vcpu);
+		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
+			kvm_vcpu_halt(vcpu);
+		else
+			kvm_vcpu_block(vcpu);
 		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 
 		if (kvm_x86_ops.post_block)
-- 
2.33.0.882.g93a45727a2-goog

