Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E60261721E
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiKBXWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiKBXUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:20:34 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4545C6549
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:19:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m2-20020a17090a730200b0021020cce6adso2494738pjk.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yE/4Y9j/oYhrNnppN3pBbrFR3yZQeQID1rXlzF1UIrs=;
        b=ay8cPyDCIqaMfo0DK1yGgX9Wb9Bl9/1fVHbdhv2aAy1cj0+xuZ97OrHcZUeV1cFb37
         6xEzJJ8+vktqwJnTtuH1USFvq8dlhSmN+zODY90fpIycgDYl660YnoWyBjRJ4shxmyzm
         eiIMz6ZQ5l1bjRGivO4fA9kceUx/9ETkzTfr9tWJ9HyO6sppdHxDi6fl6UdHy8ptqT6P
         DK4l+CKIMpqMLCpZJAWwhuO/obSacLjdsxWR0MNI7G5lNuNRlHspSUm1vSdSmF25/DFv
         q5eNxeOVs/atfRGxPMYHZj9KnffzNZveBs/Mh+BUBe8auRPPWp99Q7jjD7exn9MfTR0m
         9eDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yE/4Y9j/oYhrNnppN3pBbrFR3yZQeQID1rXlzF1UIrs=;
        b=xRCCLjiSEd6WGs/fG92B3fj6ezShKBZUBbcLUSEj9sI0eJ5KvFXMF2g6nhZPpG3SIR
         n7BG+yqf3rhQymZSeyD4izwoqNCKAJrHqx+uZPPbPkwvCM4Dgbc2pHdmgY/yOj5UinOW
         qlfaKgMff5+bSsioTl/gfpZMytSKAIF+zyb3J6K4Lh+yDaQekofxKk6yfF16IEuLJ9M6
         ORpyIZB4wR/VyRz+sE5sJG88aTCOMfNzh2p5I0umBCbAxsbi+Xcq3AP32XeEQRynsf2K
         woW0MUiOxat3ItZ32L8bUVBtF/wpKUTHFSnXb2hM/fO5ewP/nO1pgxvhOcUnrvb1DjuM
         nbLw==
X-Gm-Message-State: ACrzQf3EWCbh8oDlK8cRCXndCeDeFXhF/2UF3yZmUImeWDKGuYYmGACy
        veHFVu1VqAIGxnXLnPgV51LtBi2wLck=
X-Google-Smtp-Source: AMsMyM5/m9Qv5qe0i9jmB6ZTvP1qiSAaI3rCUeMWt3X4Tz8UOP4pahzgtmW58pUMKKKCCfw0sH3ElrsKh+M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:d412:0:b0:56c:6f25:8b12 with SMTP id
 a18-20020a62d412000000b0056c6f258b12mr27322827pfh.60.1667431181026; Wed, 02
 Nov 2022 16:19:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:43 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-17-seanjc@google.com>
Subject: [PATCH 16/44] KVM: arm64: Unregister perf callbacks if hypervisor
 finalization fails
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
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Undo everything done by init_subsystems() if a later initialization step
fails, i.e. unregister perf callbacks in addition to unregistering the
power management notifier.

Fixes: bfa79a805454 ("KVM: arm64: Elevate hypervisor mappings creation at EL2")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 73644def7780..f400a8c029dd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1839,12 +1839,21 @@ static int init_subsystems(void)
 	kvm_register_perf_callbacks(NULL);
 
 out:
+	if (err)
+		hyp_cpu_pm_exit();
+
 	if (err || !is_protected_kvm_enabled())
 		on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
 
 	return err;
 }
 
+static void teardown_subsystems(void)
+{
+	kvm_unregister_perf_callbacks();
+	hyp_cpu_pm_exit();
+}
+
 static void teardown_hyp_mode(void)
 {
 	int cpu;
@@ -2237,7 +2246,7 @@ int kvm_arch_init(void *opaque)
 
 	err = init_subsystems();
 	if (err)
-		goto out_subs;
+		goto out_hyp;
 
 	if (!in_hyp_mode) {
 		err = finalize_hyp_mode();
@@ -2258,7 +2267,7 @@ int kvm_arch_init(void *opaque)
 	return 0;
 
 out_subs:
-	hyp_cpu_pm_exit();
+	teardown_subsystems();
 out_hyp:
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
-- 
2.38.1.431.g37b22c650d-goog

