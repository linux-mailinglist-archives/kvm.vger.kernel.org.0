Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E763E4CE
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiK3XMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiK3XMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:12:00 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2821975F9
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:27 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y11-20020a056a00190b00b005749340b8a8so179362pfi.11
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ELQ4r/TqKHaBJHvAWCVxPtXKZjhdmN2xYeWWLtdN78s=;
        b=rV6sXkwW0NobTm3rjPA4K5oJXg7Chbj9zLHGkDIEdGJ4GDvAf1gR/xdVUzmRVjaVxZ
         Lpv4mXcdPvHfacU07BhEHSV/clf7T6Wt4K9p7HTpl3MuGOSlPJopPlIOdMhwNJq55wJQ
         C2XphKPH8RVseXHYjMsaGq/j2Utscd+e1YQpyMJwrt0VKjAxdKimwtuQPugYzzhiHh00
         1sder2j0DzOfxhA6vqd3HzFSqamEahbTJmdvrPEKWeFh0CbO4l9ispHgKo3f6y1MgB15
         Il0zG/AUJb/AsRXvsLsQjRJk0smNChBO607PrkbuzuuP3tG+dumldlOL4wJ4R/wyXPyf
         wKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELQ4r/TqKHaBJHvAWCVxPtXKZjhdmN2xYeWWLtdN78s=;
        b=w3jfGJzgj3SNX3n3CFpIsXZp4Y0m7PlXyWc2AdY44waFwmUDcM83NGE3b6fX90CRFV
         Bnnw8yfXaWeTA8XoffgTReFrbW7uWLB5ALDQPdd+Rq9lKs5bUAC+x78ou9XRTxsp92+D
         izPzKpb4aIsi+Wh0HuN9AxIR9kCDuHFVcxVQkSq/WoApD9pOz/h9KsCiqN7iu8qTBGY/
         8agjR8zPKcIKBlgTLD85i8KEgqATddESyyb2zFyqBSgW+5b1hyz1YGPeJnrYSII81tHs
         9yKbTO5ZecO5wZv5YBmOG3ISjTqu8AGucN1Z/ZBIeYPGtR9mABbSisiN8H5KtwqJh+eD
         LsaQ==
X-Gm-Message-State: ANoB5pmVZMhhrev9KWSaocTaG/kIiHHpT2dGwgijPNa3+3DL3YRR/YKl
        TQbnoo1ITgQirConvrvQI9fQxI2m1/0=
X-Google-Smtp-Source: AA0mqf6ABFslzbC+5qGGF8++aLIGKcv8VtrwUOxMpqn3yz+UIKnkh0KvASvkaqQSOu9f+r1p0oHxko8zbBk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:f89:b0:219:5b3b:2b9f with SMTP id
 ft9-20020a17090b0f8900b002195b3b2b9fmr848420pjb.2.1669849807964; Wed, 30 Nov
 2022 15:10:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:02 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-19-seanjc@google.com>
Subject: [PATCH v2 18/50] KVM: arm64: Unregister perf callbacks if hypervisor
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
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
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
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
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

Undo everything done by init_subsystems() if a later initialization step
fails, i.e. unregister perf callbacks in addition to unregistering the
power management notifier.

Fixes: bfa79a805454 ("KVM: arm64: Elevate hypervisor mappings creation at EL2")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fa986ebb4793..e6f6fcfe6bcc 100644
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
@@ -2242,7 +2251,7 @@ int kvm_arch_init(void *opaque)
 
 	err = init_subsystems();
 	if (err)
-		goto out_subs;
+		goto out_hyp;
 
 	if (!in_hyp_mode) {
 		err = finalize_hyp_mode();
@@ -2263,7 +2272,7 @@ int kvm_arch_init(void *opaque)
 	return 0;
 
 out_subs:
-	hyp_cpu_pm_exit();
+	teardown_subsystems();
 out_hyp:
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
-- 
2.38.1.584.g0f3c55d4c2-goog

