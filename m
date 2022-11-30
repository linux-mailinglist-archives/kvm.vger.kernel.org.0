Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E5F63E51E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiK3XQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiK3XPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:15:00 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037E0A1A34
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:15 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id a3-20020a17090a8c0300b00218bfce4c03so3812626pjo.1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9siMTxNa3uAP5fZIzNGfC6XHHMwgiKNlJBnmhPRbPro=;
        b=ChW1Nps965Qp18Q6+pUQJ9HaZg+bsuoNAPERVx5vtZW0btHu7mssz1zq2swGpNBnOO
         xeSdi4iwUV2bHGTbxVVeaFbSd7hDQi+GikXoUOMA+ds3pfZUeA7jrH6W4f5P6c5pwr9B
         U3XVYRZQ7E6Yrhd7CzlvGARnYPdmscwvfkiQmHkzv9OBvomDdeXYt/xK1+qhaSsZxp4N
         N9NxXX+4yvTNEHy1B6JV5V2Zu6j+0V3rnH/CXLtu/bfRs93WfDHZOPYCsGgSMQHV2o0D
         eDMkxgUR8PhMKsVPRy8wQRrlE6YEWvcusAVfquXtz1XnSeeHga0XG3gUzph6fBCETn2R
         dxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9siMTxNa3uAP5fZIzNGfC6XHHMwgiKNlJBnmhPRbPro=;
        b=ilReApn9sAREouEIQyoq248sfza8lBFyjfI7w8RHXT1kaf80vdfud5Bi8/esujPast
         bE6xjtZBeJii8X1iwtPk2ahKfip+XK1TUoVsr7/pZ7v0mR01404IWw63DTe50bBocU3B
         wio47Knp/iXf/Y/9ndQIWJbGht/TNzAOdZpQb6GhcUVy+DyLUEHw7O4ahAmm6kJWdzZs
         +K4xHLmbzB85lvixBIMepMUnrdmDMuAfKLpkMwubkPveJ5Lle6LwWh7wJtHHnrrgt0eE
         0dKscFg7X+3aCL+uJ5BV/b97ex0r45WxxTBx0bYO43Hl8uY8yQKtDeS1wlJraYJhRAbs
         ss5A==
X-Gm-Message-State: ANoB5pkv6SzTkt14VIls/GBDrURS2YWtmel2Uabr8WtKLBEo6shL13g3
        3mhGUJmhKrIBEzfpNgFtPtRAHFtocMw=
X-Google-Smtp-Source: AA0mqf6VC0HWkGfsmW3gbMncl1EgCwyuCiATzAwaZawtYWdw9a793FC2Aun76Ue7cKpeYcZGTN4fYSLmS4k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:43a4:b0:219:1d0a:34a6 with SMTP id
 r33-20020a17090a43a400b002191d0a34a6mr2520763pjg.1.1669849843212; Wed, 30 Nov
 2022 15:10:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:22 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-39-seanjc@google.com>
Subject: [PATCH v2 38/50] KVM: SVM: Check for SVM support in CPU compatibility checks
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

Check that SVM is supported and enabled in the processor compatibility
checks.  SVM already checks for support during hardware enabling,
i.e. this doesn't really add new functionality.  The net effect is that
KVM will refuse to load if a CPU doesn't have SVM fully enabled, as
opposed to failing KVM_CREATE_VM.

Opportunistically move svm_check_processor_compat() up in svm.c so that
it can be invoked during hardware enabling in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 49ccef9fae81..9f94efcb9aa6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -543,6 +543,14 @@ static bool kvm_is_svm_supported(void)
 	return true;
 }
 
+static int __init svm_check_processor_compat(void)
+{
+	if (!kvm_is_svm_supported())
+		return -EIO;
+
+	return 0;
+}
+
 void __svm_write_tsc_multiplier(u64 multiplier)
 {
 	preempt_disable();
@@ -4087,11 +4095,6 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
-{
-	return 0;
-}
-
 /*
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
-- 
2.38.1.584.g0f3c55d4c2-goog

