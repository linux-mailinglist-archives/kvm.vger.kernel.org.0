Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A5D3C74C6
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhGMQhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbhGMQhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:10 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D55C0613A0
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:12 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c3-20020a37b3030000b02903ad0001a2e8so17413866qkf.3
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VLNuKyQvTwa0Rm4aLkj5S4FZy5CA1rkSDtpmTBtHVoc=;
        b=oyR1MaMm7QYmjSg9mz0Rnv0KDk7T4VF7Pt6iLuMNec+Tfcf0IzGyVlEyBqbSQEeMSG
         2MGXJFQ8F2EUCdTEqyaLc+rw0gcDJLIOCwp7z9/ZrM/Gbg3V+GRrXOV76VpTnGOsgMJA
         2JTX5Qnv/hDtrnydyoMMrjvdxDgJQjzV4pesC2rNnm7dXyVj6xId94m9ZTCHKUeF5Rp/
         lhkxyPPRy3e4NhlSyG35GE5cR5oiT4gKg+E8pCxVUNWHR/9Ua4jjD4HRqRgnlY+wRxgU
         2gsJb0pCB9IMDhynM+wJjeOdGklqzO69wysuwhhAB+g7BeyzLicvq54M3YR+fp+l/I9P
         f/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VLNuKyQvTwa0Rm4aLkj5S4FZy5CA1rkSDtpmTBtHVoc=;
        b=YhaMvsC3eV4ANum8MhhW4X9SU86YR8uumww2O0zDdSY2JYnqDAFelVdfXzq1AxY/z3
         pgPNXp93ap7Av9JalAgnLdq4dfLejb4vo3i1f4INZhRnfi3x1TinRWgQDItqx5hM/WP6
         32X00Es3TDrnRRfESailjZIUwzxmoxXvrrUKqW7QtDQxGD2OEJo+gXfOk8un8pF17h1z
         jkioGImfPoeoSrvZRASn2cseh1TTU9PLp4OmBuCzp90N8lvX7wF6/l7cU5UyA1viuir9
         gB/Kx3apL6XjkmR1POz/8yACuGFqueC3S1ArnxI+kmDtRHVRXvnKFPZFhqzs9OZy2lup
         jL2w==
X-Gm-Message-State: AOAM531UUakQwlwYeDK1rvI3g9kA5J6XweYtWVekV1rEfLhO9iGNZ362
        meUZ8w/hs0LpZ2QwiTWTyIaJTCWEQug=
X-Google-Smtp-Source: ABdhPJw73ip1ApUCgVsMmAoAoiyMSd7pyjPaFYmLRPs47MCJPzGXMnA+hVNCaPFYY9W2qPMwzI2uzs3Z/9U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:ad4:57ac:: with SMTP id g12mr5843456qvx.32.1626194051878;
 Tue, 13 Jul 2021 09:34:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:58 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-21-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 20/46] KVM: SVM: Don't bother writing vmcb->save.rip at
 vCPU RESET/INIT
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

Drop unnecessary initialization of vmcb->save.rip during vCPU RESET/INIT,
as svm_vcpu_run() unconditionally propagates VCPU_REGS_RIP to save.rip.

No true functional change intended.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 268580713938..0101646e42e0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1266,8 +1266,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm_set_efer(vcpu, 0);
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
-	save->rip = 0x0000fff0;
-	vcpu->arch.regs[VCPU_REGS_RIP] = save->rip;
+	vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
 
 	/*
 	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
-- 
2.32.0.93.g670b81a890-goog

