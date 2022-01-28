Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7BC49F002
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344878AbiA1Axm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbiA1Ax1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:27 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82A2C061755
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:22 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id bj8-20020a056a02018800b0035ec8c16f0bso2379225pgb.11
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MoHy27U3pXaXkL0u2KKkeb8SzX8P4k1qrRDTcgsWetA=;
        b=EqdpBATfjlVVuZojDLCyulKP1ekFA1dhoWS7qfqhKAGctc9u66Eg5171vUXlLUm4HE
         Var11+u7SKElmw93R/hlCwCDqc5vzefmNzGbr+80RNF2yoQHlPK5XtH1/SdviM1XTGGN
         YM0jpR5nfIzr0XDBbxEeEZmo4uR2eJamLqLu0bvSk1XDwjjUe3I6Oe0C+KfKNOpQ2PxN
         K+iDLhjNYwFuoPqbE3jgVAkupGcCSDIXpiWhxfSBEpu3auyEkAYi1VpGBRIZkNcrRnuY
         FsM/Y8jP1wTIx+DFNYDCKCR2eV4ZDwpk34awoNG/cMJ+J0HBWhwzfYThc7GezvbpOqSq
         zbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MoHy27U3pXaXkL0u2KKkeb8SzX8P4k1qrRDTcgsWetA=;
        b=ELmlg9ptyd/nOyQCbzxxXn1LX3PAMmf48oavP/pp8P7Mlp8nQxqfTCU3FemVrB/2mg
         tSkzILifSZC1pK03WOTlnViZ3gMIDMC/8QnVM0aEvq5CyRf8H4z47xmcBDzEn387INqT
         d8TlWJpCrowTrhM/Vs9J9+mSr1wKjsAuC7K07l+4UA4gLy2TQpMjK8Kx2ZbPpiXUKKfT
         ic6T2FTdh9Kr00W+0nldF5FVwkJoWHMOGalxvUZ2J/mVeSQojV6ZjUP87kdssCbIHqf5
         +EfLV8PnULv4yK/yUEQPDrO6tY9xS/L2sV5hWmdk1tL2UfZW0UbfEcQpf4np5lr5qBIz
         B0Ow==
X-Gm-Message-State: AOAM531GMiedtMhaDvqpaa5WaOjPzbNavLprqXqLbsghy49KsXArzfaI
        ZGbpz6L1tFefdnJK5V29fF5BZmV27jQ=
X-Google-Smtp-Source: ABdhPJz5GveShZKKXurJYvOum+YlxCN026eERDfD3Ui6hAISaoh3rOcsEo7zG5HDWxojIvpU/MEppShInwI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:17c4:: with SMTP id
 q62mr16834393pja.145.1643331202367; Thu, 27 Jan 2022 16:53:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:51 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 05/22] KVM: x86: Use static_call() for .vcpu_deliver_sipi_vector()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define and use a static_call() for kvm_x86_ops.vcpu_deliver_sipi_vector(),
mostly so that the op is defined in kvm-x86-ops.h.  This will allow using
KVM_X86_OP in vendor code to wire up the implementation.  Any performance
gains eeked out by using static_call() is a happy bonus and not the
primary motiviation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/kvm/lapic.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a87632641a13..eb93aa439d61 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -117,5 +117,6 @@ KVM_X86_OP(enable_direct_tlbflush)
 KVM_X86_OP(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
+KVM_X86_OP(vcpu_deliver_sipi_vector)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7e6fde82d25..dc4bc9eea81c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2928,7 +2928,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 			/* evaluate pending_events before reading the vector */
 			smp_rmb();
 			sipi_vector = apic->sipi_vector;
-			kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
+			static_call(kvm_x86_vcpu_deliver_sipi_vector)(vcpu, sipi_vector);
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		}
 	}
-- 
2.35.0.rc0.227.g00780c9af4-goog

