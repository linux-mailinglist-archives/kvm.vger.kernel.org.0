Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2917063E531
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiK3XQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiK3XPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:15:54 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C2CA1A3E
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:25 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f22-20020a635556000000b0046fd05d55cdso109133pgm.1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X0tmq9TjsMbdzf016NYPEZWLDrtJgEerkZwlPByjvHs=;
        b=ffiAil8tYfi3nQXQblraVPD6jbdbOOCVG7uQkkKJrYkDL25R/TkQAeFRDogqa/QMMv
         6wZOWt9R/eeSPWTlpWV3IYmrtl04WJOPJAhS7DhGuKTgLTJnehBcyBsLWlgRsCVFi/Ix
         ksxZjkBOqqqo9hOr9qKhrYgS8WLlfTE4UM6Vkkhhf880kZVvVEdvLhl4X0FaFYBb/6vC
         1lACz1AHExA2AbJQILx7vCyuTDoL44EAFEV/X6CifJwvfMkGg0ai47n8Yg94c4IO+cHQ
         jlRTeSXfVKpq0j3GPFNIBJZpOCvznvIZyM5DfqXmXJnRlhyCma48IFWCHmjS0A3NCAbs
         hdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X0tmq9TjsMbdzf016NYPEZWLDrtJgEerkZwlPByjvHs=;
        b=uEuH8+TLLVwFqz0dyCXD8xH+zMyhZ1ZbFh4ee+Vm4uxanY5lOrVsPnwpLcx3TyM6CF
         xr90J84zfn2Q+yxGnaTc3hy2HejpgntpGp8ouAMrV1Roza/jdHOpiCJfxVBaYuA3Q9Bq
         mreTvQ7VgigYWmbOS7ZKPHFc4S3EOHICq8q3g+rEUdsxMD/btG/kPYEZnfPh0muuBZe/
         8SzsOK1LNockvBhZVH9uh7cpXgCSvMiVM8nKcFlk2LpchsdvLbfe1Bs3u/EisQhD7haa
         jZC4jjj26YDZtowVmfuN54MEyroJqU4vL60lhggmcmh6wGUIFnYKt5WZj2FM0R5VbbkO
         vxlg==
X-Gm-Message-State: ANoB5pkRAKwwc+JwW68KGNt6ppKd3Vw3ESqusRD/tLvIn2Gzf9mUANLD
        Z+io6cn/TB9GK48UEuDb4IxBDp4Vk8A=
X-Google-Smtp-Source: AA0mqf4tYdOmumtBwzOsj2b757evhXiqjnmJBxVweHABwP7YhX6XXp+28OecLtWsiEbLYyMEiAceUWRYidE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8487:0:b0:56c:3bb4:28a8 with SMTP id
 u7-20020aa78487000000b0056c3bb428a8mr44633084pfn.83.1669849852226; Wed, 30
 Nov 2022 15:10:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:27 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-44-seanjc@google.com>
Subject: [PATCH v2 43/50] KVM: Ensure CPU is stable during low level hardware enable/disable
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

Use the non-raw smp_processor_id() in the low hardware enable/disable
helpers as KVM absolutely relies on the CPU being stable, e.g. KVM would
end up with incorrect state if the task were migrated between accessing
cpus_hardware_enabled and actually enabling/disabling hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d985b24c423b..a46d61e9c053 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5028,7 +5028,7 @@ static struct miscdevice kvm_dev = {
 
 static void hardware_enable_nolock(void *junk)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 	int r;
 
 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
@@ -5070,7 +5070,7 @@ static int kvm_online_cpu(unsigned int cpu)
 
 static void hardware_disable_nolock(void *junk)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
-- 
2.38.1.584.g0f3c55d4c2-goog

