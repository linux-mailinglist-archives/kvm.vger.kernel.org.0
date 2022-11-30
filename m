Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4511E63E4EF
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiK3XOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiK3XNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:13:16 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDD89D836
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:44 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 84-20020a630257000000b00477f88d334eso82481pgc.11
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZ/AA3AN9yZfFS+Yz2Hj0GA1Db97x+XE1LjIfmdmS/w=;
        b=luHLl3WdRQNdBhH/vZv/hfYOmt9Q6vwep+qjtUAST73H1MF3LqvzoF2Ukv7UaDUlgb
         fXELwkqnEzgBN1h88nvzTImTYOnZGPEMito85bT2cMG/Dw2lvuyXP8zeBz8U2jGVs5tj
         pSDhoig8xe+6jwKUzsQZ0HNL6W7uKODl2j0YOlmoXogdfyORLlX0GkBhzBuT5EaiKGr7
         PCHzZt497tY3kEsEdxjbaw0LnCs8v3tH39skbarsReDUyuZOdzK6YVSLerydaPGb/0Z5
         eHv7VqvGcSRs3JMgPsz9Bq5kCqCHy9eUbAeqCz5po17CqSrTsXQffsEYVsh38nZQAmal
         lJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oZ/AA3AN9yZfFS+Yz2Hj0GA1Db97x+XE1LjIfmdmS/w=;
        b=i0qW2eJaXjbbHa/cN/JbUjeVJdbBFKtjb8IGI9RVZ3g7IRIJhFum8cnsNqxzS5Xcw1
         hdNSBpXeB/F1lYOpHZZMhfOFpbi7VIReAvEKvfHBnl/VNwY2JiCpuFOAvtIytGxqofjE
         x2w/h60hpzrfpZ5k/BpucsDFEX4y0iBpaIVVIM7e0r563r5n4jHN8UzRgiM/ooxfb/iX
         uRR1IIcIp2gp6225WQgSBNxZhKz1LiuI/eyKzwHlWtO+ixcIlvzcKAkvcuLKxChc9G6U
         0B4KT9TE1FLMEaxvC1MiDaoMj9+9O9BizAkS4hcB2RAWrRvrYybd0pRSU+ut2TFGemIo
         QTkg==
X-Gm-Message-State: ANoB5pnD7zihy28xFI5MaL0eneaLrnQipAU5WUjbkBz9uIWvtkpdXRVo
        GXBbdJUKpznO0fmpHawn8JhK2/bdaOo=
X-Google-Smtp-Source: AA0mqf70Xm5b73dwbCTmumj9PiXG1e+aKYb1a7npTh2VM+OaIt1Kg/9NwT12H0mJEQDQr8PRUFC8axppjXM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f1c5:b0:189:39e4:c0ed with SMTP id
 e5-20020a170902f1c500b0018939e4c0edmr41790703plc.108.1669849824265; Wed, 30
 Nov 2022 15:10:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:11 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-28-seanjc@google.com>
Subject: [PATCH v2 27/50] KVM: s390: Do s390 specific init without bouncing
 through kvm_init()
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the guts of kvm_arch_init() into a new helper, __kvm_s390_init(),
and invoke the new helper directly from kvm_s390_init() instead of
bouncing through kvm_init().  Invoking kvm_arch_init() is the very
first action performed by kvm_init(), i.e. this is a glorified nop.

Moving setup to __kvm_s390_init() will allow tagging more functions as
__init, and emptying kvm_arch_init() will allow dropping the hook
entirely once all architecture implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
---
 arch/s390/kvm/kvm-s390.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 829e6e046003..8c4fcaf2bd36 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -469,7 +469,7 @@ static void kvm_s390_cpu_feat_init(void)
 	 */
 }
=20
-int kvm_arch_init(void *opaque)
+static int __kvm_s390_init(void)
 {
 	int rc =3D -ENOMEM;
=20
@@ -527,7 +527,7 @@ int kvm_arch_init(void *opaque)
 	return rc;
 }
=20
-void kvm_arch_exit(void)
+static void __kvm_s390_exit(void)
 {
 	gmap_unregister_pte_notifier(&gmap_notifier);
 	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
@@ -541,6 +541,16 @@ void kvm_arch_exit(void)
 	debug_unregister(kvm_s390_dbf_uv);
 }
=20
+int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+
+}
+
 /* Section: device related */
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
@@ -5696,7 +5706,7 @@ static inline unsigned long nonhyp_mask(int i)
=20
 static int __init kvm_s390_init(void)
 {
-	int i;
+	int i, r;
=20
 	if (!sclp.has_sief2) {
 		pr_info("SIE is not available\n");
@@ -5712,12 +5722,23 @@ static int __init kvm_s390_init(void)
 		kvm_s390_fac_base[i] |=3D
 			stfle_fac_list[i] & nonhyp_mask(i);
=20
-	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	r =3D __kvm_s390_init();
+	if (r)
+		return r;
+
+	r =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (r) {
+		__kvm_s390_exit();
+		return r;
+	}
+	return 0;
 }
=20
 static void __exit kvm_s390_exit(void)
 {
 	kvm_exit();
+
+	__kvm_s390_exit();
 }
=20
 module_init(kvm_s390_init);
--=20
2.38.1.584.g0f3c55d4c2-goog

