Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD363E4E0
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiK3XN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiK3XMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:12:42 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E629C60D
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:37 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id lx3-20020a17090b4b0300b002137705324eso2536531pjb.1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2E/ZNfNVjTWUDx7EclAA9RDMNJ28SDYbq0FBSTNkEW0=;
        b=YOeUjr5k1nRXALq3v0KKdNU/RoNOZHvdJ287PzEh8mewFol14vSXSy8/3fYRK98ogf
         DM6/FhXti4G1BKHQNvzjRV1tWyFhTyxYu+zxNSNi9IlHcolXKLZsPssVX0dsnM50iavV
         x2ODcftM6fP7S5M9f/kxN+kBZaYtyIW+z4R08Rc0Nfjpphi6e+XsI1tHwJnKWXkQaHpN
         Fvd9/AR9wQma2szpaVgVzc80G2d6HwNcimfP60MChrBcVuLXdfKe+wSSxLqRYu4pvEyL
         hD29cSFZ9nNlD/40iFEC/0Ct0+nb0Drk9Ewou2J1g8F1lSQpSFp12LOPbSOpy+zVepWe
         HB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2E/ZNfNVjTWUDx7EclAA9RDMNJ28SDYbq0FBSTNkEW0=;
        b=vrYkLcBnyziHzUCqI3rfMHfys9Sa/WHJblQ6DDleyqXoM5DNr1wSw0mJtbaLXy3vke
         u3vQ/kR/bHUMhm5R3eos49s3+gYRkYOp1IHVdeutmFy7Fv5xUehrfsO6+FGJQIcNMuTZ
         FDnZYu3uAOTkbnClybRPMGdm6tjmYeBe5O/iYdXr8A/sa2EMJk527x+/Hmg7Kc6+lOKc
         MK7FLA58toRKUna8/MohYW9B1XQVZbScxcq514evSdlPygnX5U67dGiqrxCQpWH1wB4q
         MoK2L7n9OnM/NvqetOokKP7/2Z63OVP/Ayzc1z0eT7LfBvm9IpPPEODojpLSilZX0Mrt
         avKA==
X-Gm-Message-State: ANoB5pk18ulqfTfaXwwpJRYsGTfcvqxXDliL2tQcnDYeeQ62tfQuEaFU
        tpLakONzSftrshDRfujUIpqSUMdnHqs=
X-Google-Smtp-Source: AA0mqf6fouTIX68sTKIWP0zUhpW+UmWGK5D4PKuHk4dF0PG0spJwJY42lnPZuN8WAPveTbTZZSc8FEJYBlE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:6045:0:b0:575:f66b:75a9 with SMTP id
 u66-20020a626045000000b00575f66b75a9mr3406091pfb.2.1669849816681; Wed, 30 Nov
 2022 15:10:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:07 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-24-seanjc@google.com>
Subject: [PATCH v2 23/50] KVM: MIPS: Register die notifier prior to kvm_init()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call kvm_init() only after _all_ setup is complete, as kvm_init() exposes
/dev/kvm to userspace and thus allows userspace to create VMs (and call
other ioctls).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
---
 arch/mips/kvm/mips.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 75681281e2df..ae7a24342fdf 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1640,16 +1640,17 @@ static int __init kvm_mips_init(void)
 	if (ret)
 		return ret;
=20
-	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-
-	if (ret)
-		return ret;
=20
 	if (boot_cpu_type() =3D=3D CPU_LOONGSON64)
 		kvm_priority_to_irq =3D kvm_loongson3_priority_to_irq;
=20
 	register_die_notifier(&kvm_mips_csr_die_notifier);
=20
+	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (ret) {
+		unregister_die_notifier(&kvm_mips_csr_die_notifier);
+		return ret;
+	}
 	return 0;
 }
=20
--=20
2.38.1.584.g0f3c55d4c2-goog

