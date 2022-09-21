Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0A5BF21B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiIUAdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiIUAc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:32:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A587961E
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u6-20020a17090a1f0600b002039826d478so2057335pja.4
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=efA5iJVbRrRgyy7qejkmxwve22ULxnh+arH50++PU/o=;
        b=LKQ43lhsEV6qkmBZlofrSrdl8EJ6mizwyIEMQYN4yuGNXkQj4E20I0hn2n1os/W8rc
         FBABKu95Qjg91h2stXYOQw+qADMR7XZ6aWiaoE4AtE31UgVml4CNZ7U+iemEDcQM7Qu4
         t9Z+X0wLCYzA/PywBX4R2TbwY4IqErPsq7pWjccSbHgqlIcJodfmwDsORX1S0hnpHOqL
         beWZAka2S0YLzR5F93gSfrPtpqFy0vHNPuMIF2SvlDmkv6DmDFSXlrSQYeY1mlT0WWNb
         xuXG79A1mSLbxXjRXjfR/KkQ6hWyNCiYg0/oAhyTPT5fIKU53548mJXGWrhfghBolN1K
         JXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=efA5iJVbRrRgyy7qejkmxwve22ULxnh+arH50++PU/o=;
        b=S3AAURjyjVdGl6vI4PUiSruf3YaELpC1RabQeAJM4ncUtPAXwwTDA3VUhPSEhhh5wQ
         0+KZvTYWuUFuXxxSdPYIqllqlAeJzRu0YapUoneaNh4RaxggMtSjX+Rvy9TZDLA/a5aY
         qulaCM57Sk8Njig81hDZdyV0jeXbF5F0F6VrTDuhjvtHcgYmi5Xp/7KBwDkIeAgu4cVE
         xaprI4C039DEBswsYNkHEX8Asm6oWej4newtg+tUxZVj/3w6yBKJYjmSOPXF3Rl+iQ1P
         nHP8DC2Lc+ZuOjQMvVK7kBIVKvfBgnIQAG7OKbeA1cb7ysbSZIaCvS4Z9PRcw4/Jp5Yv
         L+nA==
X-Gm-Message-State: ACrzQf11cGnTBia9ANG9tn23ixy5bcjVnTaYBstDwDfRac2cz6YlDqOR
        z3iP5S4CRZpV64tnxxmS5oWlDWrtXZE=
X-Google-Smtp-Source: AMsMyM4y6HKockrgOW/pRtDhYoSBz/Hgk7Jbboq2yxWPlcCYVwqDxT8mse4oLg7p1D+UQZFuX9F/d/ndT2k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:be03:b0:178:6f5d:e979 with SMTP id
 r3-20020a170902be0300b001786f5de979mr2126922pls.163.1663720376093; Tue, 20
 Sep 2022 17:32:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:54 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-6-seanjc@google.com>
Subject: [PATCH v4 05/12] KVM: x86: lapic does not have to process INIT if it
 is blocked
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Do not return true from kvm_vcpu_has_events() if the vCPU isn' going to
immediately process a pending INIT/SIPI.  INIT/SIPI shouldn't be treated
as wake events if they are blocked.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: rebase onto refactored INIT/SIPI helpers, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16a24dd28f26..dcc675d4e44b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12765,7 +12765,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_pending_init_or_sipi(vcpu))
+	if (kvm_apic_has_pending_init_or_sipi(vcpu) &&
+	    kvm_apic_init_sipi_allowed(vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.37.3.968.ga6b4b080e4-goog

