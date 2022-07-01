Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDB2563849
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiGAQu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGAQu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:50:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D2E3EF02
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 09:50:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2eb7d137101so22764587b3.12
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 09:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6WBuqBxN71rHL177gapA5k+g6PwRD2S0jU9i7UbBI/0=;
        b=aUFHTHfr6d/Kekk4YLScyBzica1U3L9RnB2HAFV54RFdXst5ikdvgRa2M6YPHR+wyo
         vkrI8Bbxx2L8PVRU+Vc2iVUT5lhxDENc5phF/38iSrRelpOKR/WFtmA5o6bX9r1IND/c
         x9w7x/45h9/n0tl1Dq9yDShswSHKCnj7eR/R2rthEAAZw7lT8LjPldhDb3BKWwJqwHzv
         6qS2S1nmDl31eUSuQY07vbOMUuwmE4/yJ0vyOs0VPIPxpOPuZ0ZJUM7C0mMubFhL8IB7
         2ZgLu9lJNg0UUOaANFzi9z1G9eEGxKfuzZER5t3+Z3WtKstjDrrKQNx60Or8yevfg3Yf
         gRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6WBuqBxN71rHL177gapA5k+g6PwRD2S0jU9i7UbBI/0=;
        b=5dJqGN2UM+4VRgP7WgINpGx/kselC4NTRNgMiPCI5lHU6o6uVbN+oJjet+Ko1tW7+s
         VM1nzYF33evzKR9UpdvtlXdahGY/G+NgNXGTcmupg4eXKj1D594K/0NaSZ2JapHDblRQ
         gdZb5K0EYgmV07Cn1e4khIo4bV1/cQPMwiStjesUgJqM4JjH6olMmS1AZhaZ86OHWVO7
         YiyS4/pxngynvpJYnHHJ12BDGJJPODD6W1Ni3jJhzQs3RhGL3bQrbA1vCiMuBuFuLhXH
         6mUafOQm9lUVtpBRYG/2VjxZBbSnb23J4CopI4tpSm8h9zPXtNIT0UGzMWtoXDU/8nIP
         gTnw==
X-Gm-Message-State: AJIora/th9sfih2ZdUoFq5BfOZHE+QNcf6WGO9FVoTvoelxtmuO1ie1w
        x3oFgLwIY9XOZJbgdTwWqC7DUY67
X-Google-Smtp-Source: AGRyM1uZj0EVVwwCYYe/nQsYZ0kegws8/U9l9DfRwuf89myMXkQixOy821tLyoy8cph34F+P2+ugqMCe
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:7200:c2cb:2999:20c])
 (user=juew job=sendgmr) by 2002:a05:6902:708:b0:66d:2871:c574 with SMTP id
 k8-20020a056902070800b0066d2871c574mr17721648ybt.439.1656694255078; Fri, 01
 Jul 2022 09:50:55 -0700 (PDT)
Date:   Fri,  1 Jul 2022 09:50:45 -0700
In-Reply-To: <20220701165045.4074471-1-juew@google.com>
Message-Id: <20220701165045.4074471-2-juew@google.com>
Mime-Version: 1.0
References: <20220701165045.4074471-1-juew@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 2/2] KVM: x86: Fix access to vcpu->arch.apic when the irqchip
 is not in kernel
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix an access to vcpu->arch.apic when KVM_X86_SETUP_MCE is called
without KVM_CREATE_IRQCHIP called or KVM_CAP_SPLIT_IRQCHIP is
enabled.

Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4322a1365f74..d81020dd0fea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4820,8 +4820,9 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		if (mcg_cap & MCG_CMCI_P)
 			vcpu->arch.mci_ctl2_banks[bank] = 0;
 	}
-	vcpu->arch.apic->nr_lvt_entries =
-		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
+	if (vcpu->arch.apic)
+		vcpu->arch.apic->nr_lvt_entries =
+			KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
 
 	static_call(kvm_x86_setup_mce)(vcpu);
 out:
-- 
2.37.0.rc0.161.g10f37bed90-goog

