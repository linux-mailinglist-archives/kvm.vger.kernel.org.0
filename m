Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08AC617241
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiKBXYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiKBXW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:22:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CC9B7F4
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349423f04dbso765417b3.13
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/lqn4M/Too7/hLjEdNjj07wzHVUwU9le6KZacsTk8SY=;
        b=jpZ4+tq6rgM4hZWXweQJqfxuirRlrRpN+o4JwlpzpCNTf2A1sJCTA6DFTlQxCFhgbt
         sLPS4JguQacCAQKGId9cUa8Po003/wEsvkFZ2dOMw9iNk7lA7jWRoh5OFZzRfWNs6e3X
         DneEijHQrn4rLICnTKWJFk513kvZJ3K123XsKZ8FoBZdWOMtOvWDKENXD0/AJPQsCKjG
         rrWvKtMA58cnJHMchHTeytkk5Oc3RF3YtWKf69zqcXqxFh7WlsD0FI+Jf5mEVKngU/vv
         wyh2CqSaqQR9rkwiquK7nfr1sE2Ot7UFYqlBaM19WPnwV+Bbr0Tz+aWWsDk+unGGDNDW
         oUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/lqn4M/Too7/hLjEdNjj07wzHVUwU9le6KZacsTk8SY=;
        b=ygJxloadYnJdFuZ7T4vFjfEv53Z7MXShCrJBCuDcjwGuWVVVdaHOBIj5wIlKYiAxRV
         3TZ+DxOGig1ItKNO8JUW7SB6aZX2i+LzTLy8hqpxs/1ZEy+GaDeFm9Qt97hpvAJO6Zrr
         n1Ry7TgNFyKrYMXLs72iybOHWLuOMG2wV8wAlZjfGi3LGGmGhvLJQAQQFpSakIkaFAZF
         FDeklfchfEqF60SQAtrEVCbQrR+8QnGp4hqKJ7Xt7UiKLliXclVlbvXQQYgjsAQchlMq
         /s3+4JiMHELUhl3m9SghnPWlAUDOxKQWxTJTgGWXoPWQXXUXzXduTi++NKlraCtcnU2J
         ky3A==
X-Gm-Message-State: ACrzQf0ayxRzUm+aYAAz16wi3VWKry5MCYfAtwkjFUggLRV9Uj9L8jrZ
        55Kdwa9/YNR0PvK2t+84AoQDoLR2bxg=
X-Google-Smtp-Source: AMsMyM7jpwGuIU1urFbOZ+g44WVeQ15lWGU4IrnR1FfXK34lSVgumwGfDAw7vRfyWzKVx0s/7WxU/xcerg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e694:0:b0:6ca:2610:76fd with SMTP id
 d142-20020a25e694000000b006ca261076fdmr171916ybh.607.1667431191239; Wed, 02
 Nov 2022 16:19:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:49 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-23-seanjc@google.com>
Subject: [PATCH 22/44] KVM: RISC-V: Do arch init directly in riscv_kvm_init()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold the guts of kvm_arch_init() into riscv_kvm_init() instead of
bouncing through kvm_init()=>kvm_arch_init().  Functionally, this is a
glorified nop as invoking kvm_arch_init() is the very first action
performed by kvm_init().

Moving setup to riscv_kvm_init(), which is tagged __init, will allow
tagging more functions and data with __init and __ro_after_init.  And
emptying kvm_arch_init() will allow dropping the hook entirely once all
architecture implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index a146fa0ce4d2..cb063b8a9a0f 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -66,6 +66,15 @@ void kvm_arch_hardware_disable(void)
 }
 
 int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
+
+static int __init riscv_kvm_init(void)
 {
 	const char *str;
 
@@ -110,15 +119,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
-	return 0;
-}
-
-void kvm_arch_exit(void)
-{
-}
-
-static int __init riscv_kvm_init(void)
-{
 	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 }
 module_init(riscv_kvm_init);
-- 
2.38.1.431.g37b22c650d-goog

