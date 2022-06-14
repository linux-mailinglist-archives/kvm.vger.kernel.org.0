Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1922254BB56
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357817AbiFNUJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357829AbiFNUIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89744EF78
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:10 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w36-20020a17090a6ba700b001e876698a01so2800pjj.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xo1qDgQfLuXoeUJsd2fB/DhbQ6NUNvOIxbn7J+1FRkI=;
        b=YAFZFhP4ujJ+4Z4z2Wzs5pJblK6AlYCVkpLyv4/Ji/q6/TLZKupD0qmSlBWboQLswM
         xQMp4YENRSgn7lLS90Q0x7/2FmGOgk96VUCA+KEEp6GMAk6ag6chPKsaDncgt4j3bva+
         KTyvAQmMI3fbEpZNolhUH2iTNhxvz4UGBLcOkNCpIdVihOPeWF6XkoA27rSKadSa8aJ2
         XYvKNAxIi2uanQyfP3jTNIWIzTfW+fJlm7mPAOITbk9DelYy0K8sZUeMKvEX5ghVByF5
         OnStN04CJjgjqX7mGbvQ+k5HX5dO5f5eMF9qrbd2ppu5n5UqEqYdxjGrk9bF3MFaiIFc
         TI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xo1qDgQfLuXoeUJsd2fB/DhbQ6NUNvOIxbn7J+1FRkI=;
        b=62sU6PledtHMI89wwGp0jgbn6xNHvfd0dLP5vElmjEtPC8KDUVbid2jZ6HJRRC0pMg
         Fk+QdKButP7yEny1gu3hglJI+0ldmB87Bi0+xps7OMD0aNgn7oSpfq09Tr40s9XFCulh
         9LhJl6KMFhL8hJX0uWaTDLMOj6mWqgmn8qY549l0kXbDsL4UeSYqYgy8rxtM6Mq62jul
         /2RJzYhXNFpadpHVpnbW0CV3FaFir9BcC2OqAT8M0NVqP83ku36s2JmzJoIaxBNmjlIk
         EJqq7wLYkMFnELuhd3Yxq/+p/TNM9ONR9EzleiXWedK+slvQulZrzrvLWLjT7DOtXapB
         tMwQ==
X-Gm-Message-State: AJIora/nMZPH39D1MC4jmbSfEFVUqZbAXv1/TijkiCqwRGX5c2vyvuXA
        N3OxJLytbmc8YFSigl88yxjLvx9wRPk=
X-Google-Smtp-Source: AGRyM1tO2CBJtsKmDlSqCBIPkUlrozcg78gkzMsXmJdD2PKSXmOVgsKKc0huRWug6941nM+zyJ+YTU3SdIk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:32c4:b0:163:e765:5071 with SMTP id
 i4-20020a17090332c400b00163e7655071mr5876009plr.153.1655237280764; Tue, 14
 Jun 2022 13:08:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:52 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-28-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 27/42] KVM: selftests: Use vcpu_get_cpuid_entry() in CPUID test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use vcpu_get_cpuid_entry() instead of an open coded equivalent in the
CPUID test.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 8723d73dcdbd..694583803468 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -147,7 +147,6 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 
 static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid2 *cpuid = vcpu->cpuid;
 	struct kvm_cpuid_entry2 *ent;
 	int rc;
 	u32 eax, ebx, x;
@@ -157,7 +156,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
-	ent = get_cpuid_entry(cpuid, 0x7, 0);
+	ent = vcpu_get_cpuid_entry(vcpu, 0x7);
 	ebx = ent->ebx;
 	ent->ebx--;
 	rc = __vcpu_set_cpuid(vcpu);
@@ -165,7 +164,7 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 	ent->ebx = ebx;
 
 	/* Changing MAXPHYADDR is forbidden */
-	ent = get_cpuid_entry(cpuid, 0x80000008, 0);
+	ent = vcpu_get_cpuid_entry(vcpu, 0x80000008);
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-- 
2.36.1.476.g0c4daa206d-goog

