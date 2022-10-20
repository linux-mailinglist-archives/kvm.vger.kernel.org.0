Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99176056EF
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJTFni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiJTFnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:43:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432431B94EB
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o4-20020a258d84000000b006bcfc1aafbdso18222988ybl.14
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VB1jPPUEjrX48I4GSjyuQn7W+BcJBZ1KSoLIzPYJb4c=;
        b=ZBvzHWXEg5+0LfNox4fGQHvZCGExRABrADPgKQ0uJAT3GS2bcwXVcPUHDokKK0oD8e
         rBfcnafeNZELKVFMbhHowJDe7++TZWn9+acFfzRzNTYOvkyUYvbGXQueYUS7+V7xHqjc
         pASv4I9AmarKpMizQUqSSMGE+PrD1DktzRC0sEF4OWpoRrGdgBAo3uvOROA8AlwjqjE0
         bxaJb3Vla6LFM5hsDsBAYwGA5biTNljRB4SUgd2nJUMnSSiio4kL7inDOrpqnyBxmh5O
         0tPO6YMpMe3QmY5eX0aMQCl+cXZNO+TWL4qwf6QJ270u6kIT3RQormWGvj9KrJgD9jYd
         Rfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VB1jPPUEjrX48I4GSjyuQn7W+BcJBZ1KSoLIzPYJb4c=;
        b=nLLXNxHOF90ZQdQz8NHaacMmIJ7g81DZ4FZZ5wW9DifFEkY0ele76mRCVCCikQOXna
         UDkpu639pJXBhS+4MFrsd2rkw7XIQIfQpVem+io0sMAx4GYODE1yL9Zcotr3LaPnG61D
         cooLWV068cG/a6DszVEcL67ulxKzNJoP5vcgn5+aZiZ3s5UaHTxeA04UqGJrde1KfjwL
         flT0lFh7C/DKLv3Sr7zoPNiZyh9n6JNc8FZlXFHCqaJzY7jXR70YX04q+heObhru8M5d
         rNSK5R/TXWaXjS9RZ5O5ftshPjaOALBLTnAniVkxmcskFb0f5WQbrwwcGdoN3r1/Wk07
         4xig==
X-Gm-Message-State: ACrzQf1MkiDYX5fB+i96l+PIcJTXF0szqF19KRBzoiiYCqMTGvE+uVn2
        2t91M1G1obkv9DhYb/OWa5H1nuxDskg=
X-Google-Smtp-Source: AMsMyM4QU19wSO5ZMBNGHX43y4ZfNhPpdLhf7KWE0/041MMlzko8xOXHq23D3L2kQwLsCPfLQLR/LWK3xuY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:a4ea:0:b0:6c0:2f38:431d with SMTP id
 g97-20020a25a4ea000000b006c02f38431dmr10273171ybi.276.1666244610630; Wed, 19
 Oct 2022 22:43:30 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:59 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-7-reijiw@google.com>
Subject: [PATCH v2 6/9] KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Change debug_version() to take the ID_AA64DFR0_EL1 value instead of
vcpu as an argument, and change its callsite to read ID_AA64DFR0_EL1
(and pass it to debug_version()).
Subsequent patches will reuse the register value in the callsite.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 040e4d7f8755..72ec9bb16682 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -337,11 +337,8 @@ static void guest_code_ss(int test_cnt)
 	GUEST_DONE();
 }
 
-static int debug_version(struct kvm_vcpu *vcpu)
+static int debug_version(uint64_t id_aa64dfr0)
 {
-	uint64_t id_aa64dfr0;
-
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
@@ -466,9 +463,11 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	int opt;
 	int ss_iteration = 10000;
+	uint64_t aa64dfr0;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
 		       "Armv8 debug architecture not supported.");
 	kvm_vm_free(vm);
 
-- 
2.38.0.413.g74048e4d9e-goog

