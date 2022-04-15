Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF38501FB8
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 02:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245477AbiDOAqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 20:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348103AbiDOAqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 20:46:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41EB96832
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:43:48 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l14-20020a63f30e000000b0039cc65bdc47so3475304pgh.17
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WHJorEYqdPsyoiS8LBeb1G8S4S7kzQkyLWZGD9aUrjs=;
        b=bZwTwRaSjFo3UIyEnG1Se3GCFh+RY6IvOG3VlupdDpfNfI6GX6hkJeLI81eGmOGX6G
         1cHm7fTg8TqH04RjFv10Of5DvAYAHAM8tiEPrQRiuCNBDJRSzCUDQUG0BMRWHtD+LdNa
         OXpZzAre9wRSs/2YHv0GHmqXz+Pqefc9fuZxtMcl8GYafBb9wbzvPCjbT/nzQhtpz2Wn
         fyyyAL63cPcu44vOIB0qfBetcyUX/9l8dZ2b05Q4AfOcPl4SLNf/Fbj41CZv9b/yvg1F
         Aer1piomJTMTT3b0SNhbaUMWvPS5/iUeOlL+Pvad6lLyGugPdHlz8JZmH21Rl+8vgLjA
         mBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WHJorEYqdPsyoiS8LBeb1G8S4S7kzQkyLWZGD9aUrjs=;
        b=0A6MiCLlyWJwivrkeApGWD9lKLNtJEY/vir9DKD5i2O7XnU5K2VUB3eC73u9+ZA+7Q
         sdGxSJJpBmsWk6jIZYRE0DgjJ0V4Y2EivV6uVm7U8JMDzhzy/GvdPVJ8Vn4fJnguEPMv
         5g86sUVcCDe594Oaiqi6/6CZmbKvxp3FOAcK7YTtiqDAudUJe9PVO+kqqzNhJNtCD+v0
         pi5q8+y0ucJigR7Qzwbp4p1eSdGo9sXvHdF5nLn7ujqGgUZU70g0CSwdigkiN93Ecy22
         NABL6TM9dNNx3T1AMCZtArZbckwSeGF3iZFqfI6KUAB+Y78Htjju0hq5BIxwJtmxxTID
         KK5Q==
X-Gm-Message-State: AOAM532AkxALOKMDeZvRulS8VL7zZpk8aYLsR5kNCB/WxS7wPjQHNwrq
        0Xtk8mWVZHWDkiKeJO/a3XMfX4ZtGNM=
X-Google-Smtp-Source: ABdhPJzt0tscL0kcshOCrjwd8G3ruQcGXCkqq7xMYex2fkXBeIa/R8tC7xq7T2RAxBd1S9ySsMfZwzJ54UU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b84:b0:1cb:6cf5:d2ff with SMTP id
 lr4-20020a17090b4b8400b001cb6cf5d2ffmr1311935pjb.41.1649983428416; Thu, 14
 Apr 2022 17:43:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Apr 2022 00:43:41 +0000
In-Reply-To: <20220415004343.2203171-1-seanjc@google.com>
Message-Id: <20220415004343.2203171-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220415004343.2203171-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 1/3] KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()
From:   Sean Christopherson <seanjc@google.com>
To:     Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't re-acquire SRCU in complete_emulated_io() now that KVM acquires the
lock in kvm_arch_vcpu_ioctl_run().  More importantly, don't overwrite
vcpu->srcu_idx.  If the index acquired by complete_emulated_io() differs
from the one acquired by kvm_arch_vcpu_ioctl_run(), KVM will effectively
leak a lock and hang if/when synchronize_srcu() is invoked for the
relevant grace period.

Fixes: 8d25b7beca7e ("KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..f35fe09de59d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10450,12 +10450,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
-	int r;
-
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	return r;
+	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
 }
 
 static int complete_emulated_pio(struct kvm_vcpu *vcpu)
-- 
2.36.0.rc0.470.gd361397f0d-goog

