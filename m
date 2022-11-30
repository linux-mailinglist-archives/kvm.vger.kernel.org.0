Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0F63E4DB
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiK3XNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiK3XMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:12:33 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678C59B7AD
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:32 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so202508pfw.4
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uj+BMG24gpugAApyuMjfHhGTokqhj/HfOHcPzx/7Ixc=;
        b=rXveYksPcbHAdLQWx0Se3mgCcQvIusgWV2YBwsk350kO+gwstaEEoshUZTFpuvac++
         pLds7vX8HQyFV+EXcCsNs4Huph1CvEcQOXAAAxG85uCm3rCCbxscdft2ZxjRveL1foHX
         Lrax89MRhf3bE1bAwMOLphkpziYLo/XzKTjZtkj0KrWsaZWT2gVodfm1c5joltsrB5eF
         W0icMxnX0hgljPZjSz6UkymZcq3fcWnGh4feMzJb8fuOAJykHj0A+tcjteTkrK4SYiHc
         +b7l66OJ0teH4JUbB2xCLD5wxFKLZ8CELPJsM7W7cN4l69kYm6xFX8ZvCrFTJGzWVhEq
         HM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uj+BMG24gpugAApyuMjfHhGTokqhj/HfOHcPzx/7Ixc=;
        b=B+he8Ns+tJzGOk9/MnFKyVKtSz2lO2RtfTxe9dMdiPaE+7+FenvHIHe4pgRZqhJNuO
         gEx8NaLAAtCzL7csDuPLaCFaXudQ6GBQa76KdG6hgFPLXyVRT6CCvdHpfEUXok4sM2v/
         2tcuVoslpxYuMwSC//RRB9kJROvR5Wdr6OM/d5m0/emSFkCmK1bXm5RoF8Kt4XfMIJEg
         8CE2GGGK6NPENbXFYYNS4mI1qVLhM0nQeI+Dhu8rBSU64ic8KIQP9ciAmyFRoUW0W1D+
         aSJTHInKSFrr6m2zDi5IJShF5Q1zEFFgokkLVMvdeYvnSwiIA4Kn6uR3A/+iUNMnaws+
         9tTA==
X-Gm-Message-State: ANoB5pnUkA9Lugdi42oJD1q6SeYrX22yj/A3goh9EjGhuVm5Z6go71ug
        hfAUl6eKkVYToRvnTCmMEQjFa0DNMqU=
X-Google-Smtp-Source: AA0mqf4xYnJCkXbWk/N31ZRo5enbQfT7p8hAsoCQiyumsmQYs6alw3yUJytbRmVQwuUcUkB1fPIndjJ7nUc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1624:b0:573:993b:ea6d with SMTP id
 e4-20020a056a00162400b00573993bea6dmr46050829pfc.10.1669849814934; Wed, 30
 Nov 2022 15:10:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:06 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-23-seanjc@google.com>
Subject: [PATCH v2 22/50] KVM: MIPS: Setup VZ emulation? directly from kvm_mips_init()
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

Invoke kvm_mips_emulation_init() directly from kvm_mips_init() instead
of bouncing through kvm_init()=3D>kvm_arch_init().  Functionally, this is
a glorified nop as invoking kvm_arch_init() is the very first action
performed by kvm_init().

Emptying kvm_arch_init() will allow dropping the hook entirely once all
architecture implementations are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
---
 arch/mips/kvm/mips.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index f0a6c245d1ff..75681281e2df 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1012,7 +1012,7 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned in=
t ioctl, unsigned long arg)
=20
 int kvm_arch_init(void *opaque)
 {
-	return kvm_mips_emulation_init();
+	return 0;
 }
=20
 void kvm_arch_exit(void)
@@ -1636,6 +1636,10 @@ static int __init kvm_mips_init(void)
 	if (ret)
 		return ret;
=20
+	ret =3D kvm_mips_emulation_init();
+	if (ret)
+		return ret;
+
 	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
=20
 	if (ret)
--=20
2.38.1.584.g0f3c55d4c2-goog

