Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC174F1B98
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380388AbiDDVVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379929AbiDDSX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:23:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D6922B37
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:21:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2eb645be8dbso30869757b3.11
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 11:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
        b=pD4+208dXd+MuHbyfJYWyePRJiEoaz4qSgQF8/hxMsKV0Z77tFRwC9sUU2JZ74zbJN
         Nlx5Axiw++PDyBNl2HV3VZvug6drX2xzxJfLCeMbpi2IVdhGJTyKXQYDIlOUkOJDaG/U
         iepheGb2k8zTo54D5xJ4g1d40r92qSQZajd6inFsq2CyMqBwM0sBRQghFW0OCXgcjDEC
         SR3U2crly/QNYAVdd/EEvyop1nywh9D3m92nz/i8+U1+woMZ9ZvSk5oMGmsLxa/V1Udx
         TxlfQuZhwK3T9hIAV4TsTqwqva87iJ2lYmlpt23OOpbQJY2u9rHr3uEOleyMUM1aY8I5
         5Fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
        b=vuC0/ybMG8cBZeCp1FYNtrQfdeSzjnYfgiUSsf/V3gJNN/aO05TmOmuU+OOA3dIPQd
         iy+yySY81opPWzf2e2L8ibm2fCkVnEfE8uPkynB1a7P3hEFRE5bGqsHtxCr0badAhuhC
         /YUkZp9SfKukxz5BYGT9gyTdq7aC5qWFpyCGILnMMGnDiUjXH2wNUUZxIndmGTNkGoO2
         +cnI8YtJHo/hRblu2krD7PHyGMrvUumpGwNLYcCl/aRvAQFLwgFTnlaktsJ9ljGiOdef
         H5/PBfny2Z5ACV4Vpog5SPjValaPVIRYri/0AlQeexYTBKh4mDHZ/Mf65l6uwmeIhdbI
         Fg4w==
X-Gm-Message-State: AOAM532zvzhpB9UZcSFOuTQuwoS+Qa1Wia8rqZSsG29gPiwi1eh/Z1Xm
        g//JaDrOol0KDhDDA6g3i+rS0+iAQYw=
X-Google-Smtp-Source: ABdhPJyae0iAnZ5vVEgpMLzFzDK8g3K2mXaBfdK4hiobTFKYWjRk2EN5sWj512nGNHMjsWgcvI/z556o6Kc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:1082:b0:63e:145c:dc55 with SMTP id
 v2-20020a056902108200b0063e145cdc55mr805811ybu.283.1649096491105; Mon, 04 Apr
 2022 11:21:31 -0700 (PDT)
Date:   Mon,  4 Apr 2022 18:21:19 +0000
In-Reply-To: <20220404182119.3561025-1-oupton@google.com>
Message-Id: <20220404182119.3561025-4-oupton@google.com>
Mime-Version: 1.0
References: <20220404182119.3561025-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 3/3] selftests: KVM: Free the GIC FD when cleaning up in arch_timer
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to correctly destroy a VM, all references to the VM must be
freed. The arch_timer selftest creates a VGIC for the guest, which
itself holds a reference to the VM.

Close the GIC FD when cleaning up a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index b08d30bf71c5..3b940a101bc0 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -362,11 +362,12 @@ static void test_init_timer_irq(struct kvm_vm *vm)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
+static int gic_fd;
+
 static struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
 	unsigned int i;
-	int ret;
 	int nr_vcpus = test_args.nr_vcpus;
 
 	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
@@ -383,8 +384,8 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-	if (ret < 0) {
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	if (gic_fd < 0) {
 		print_skip("Failed to create vgic-v3");
 		exit(KSFT_SKIP);
 	}
@@ -395,6 +396,12 @@ static struct kvm_vm *test_vm_create(void)
 	return vm;
 }
 
+static void test_vm_cleanup(struct kvm_vm *vm)
+{
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
 static void test_print_help(char *name)
 {
 	pr_info("Usage: %s [-h] [-n nr_vcpus] [-i iterations] [-p timer_period_ms]\n",
@@ -478,7 +485,7 @@ int main(int argc, char *argv[])
 
 	vm = test_vm_create();
 	test_run(vm);
-	kvm_vm_free(vm);
+	test_vm_cleanup(vm);
 
 	return 0;
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

