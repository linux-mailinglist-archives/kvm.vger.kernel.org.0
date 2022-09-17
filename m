Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FAB5BB536
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiIQBGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIQBGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:06:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2ADA99FE
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v5-20020a2583c5000000b006964324be8cso20155381ybm.14
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=P62ArTPc7+3A2J+iBFhu2NmzpTO392tFyQSa9B00I7o=;
        b=gQs+pUloXH7vOfPonPzkbtOTB0jf3YMXQ5CPD6RCnsFqnwdAK0hZcwcz8NJSzxtoZS
         5JVD0qCmjbGE7+CyAGZ9v8Ff55/Sw+zC+IJFh5lewEXB2sICf2UY/EfgeBSfz24rEOSm
         3MC07gAnmDTxVNZUCfnPvjzK9B5J9r5vXVm5zFzp7gzIe5qWTqWFrl7XvlZiZMyDTd4q
         uUGKlEycSRb+rJl819tg6lf2P3gKsYED9B1ycNpzItfGRbUW7q+0xEKANLXW7Ak+gzo9
         NMYMTrvb8Dm3TRe+3D1y+Xfc8ychf4aUlPWoh+35PnOKy5T0EyUrA9mP3yaA1VCTFh88
         mkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=P62ArTPc7+3A2J+iBFhu2NmzpTO392tFyQSa9B00I7o=;
        b=ISG71W/IEk2j70DhhvNVOoNmTe0X9Zv+vVnKUd/weaV7fsd0ESPcQ217XTrfBYwMGz
         NYwWTUJU0ZnUsZe/vZd9kCOqa1L2tOFn4Lgo8UO3uKYaji/X1Zn2zt0N7G1/irfUHusQ
         ZmKTjtFeiKxWTweZdLnTTY1ZEgh9RR9HuuiGYE4CkyY8oc82DBodDeCK4mZm0FqqGzLx
         +nyW/CIBn3yi/Iltx28VlCmOUl8hR3+sfXWahs6ifqyQDTq23EGEsC/eY2C31hvOetxP
         VzIUnNvCOKmvoqP0e3zzuc5LFCNnqLZ4lZSzVh/ccnxggSbeGYicvgz8t6nTcd3kMOZ5
         /dPg==
X-Gm-Message-State: ACrzQf2+AKLuOcw1IyV2ZZoelQyPAY1yAxg8ZUnnPHrD783uhl7ar9jE
        6DX4xGlQJgZnbS3w/IogA13tLA4vysM=
X-Google-Smtp-Source: AMsMyM5VgruCN2bvpzdWSE6f5BHhOI/uXg4nOMM6u0Ll+ZOiBxNJUH3SUKeI4ewiHSJGbviPr/4BGR3kHWY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:bc7:0:b0:6af:d9a3:d721 with SMTP id
 190-20020a250bc7000000b006afd9a3d721mr6478800ybl.47.1663376776016; Fri, 16
 Sep 2022 18:06:16 -0700 (PDT)
Date:   Fri, 16 Sep 2022 18:05:59 -0700
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-4-reijiw@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: selftests: Refactor debug-exceptions to
 make it amenable to new test cases
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

Split up the current test into a helper, but leave the debug version
checking in main(), to make it convenient to add a new debug exception
test case in a subsequent patch.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..e6e83b895fd5 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -246,7 +246,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	return id_aa64dfr0 & 0xf;
 }
 
-int main(int argc, char *argv[])
+static void test_guest_debug_exceptions(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -259,9 +259,6 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
-		       "Armv8 debug architecture not supported.");
-
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
@@ -294,5 +291,18 @@ int main(int argc, char *argv[])
 
 done:
 	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+		       "Armv8 debug architecture not supported.");
+	kvm_vm_free(vm);
+	test_guest_debug_exceptions();
+
 	return 0;
 }
-- 
2.37.3.968.ga6b4b080e4-goog

