Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E291D4F6EE1
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiDFX6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiDFX6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:58:23 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2C6C90DA
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:56:26 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id y19-20020a056e02119300b002c2d3ef05bfso2727756ili.18
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
        b=SzJkCsZV7iMptbeHI6SunPJiVnXUQJsGsvB3EBMHTQhojiWMdyE3B/pfzOPMhedu0u
         OmjdVa4Lek6+jecHKQATT9mNii32Oo1kFhrG4QCstEBMVPNiL24y7OBfjRPA9wUhdRbA
         TAeB+mX1bc+TzRM6ne/WhlZq4XBLaHRKGejrM8I2ujdW/m8+EoB42jAXHLzGSV6cQQ+s
         riOWVn4yLnlNd/SyoucnJAS05H14Mk9xZheCP9DQVf8ivm5s8/I2K3POTNfZgmfxpJb9
         IbOTnSOlGW76Kk118l5vziFY9iX3OH4rZkouN2yrL80iW8lU17cmw4IdwL/McIe4gmIi
         UcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
        b=geCi/t0R4KUFCdn1wxlJeCZv4V6NbbC2vpGsqIKBdDrzqzGlRSPqjBlI4Ekq/IxkSN
         wTTvlN2lEjWI1GRfTSabu6shfHkqoDJ3f6KjLQ1w/6R9Cwa5mSxTjusEmi9OXWkVUgb/
         G2JtjMba/4O/yG6jVAyYqvbvZRWFVZHf5RFaYr5rIB5MD26iX/6Chy7SV0PkFC6uX8Kr
         ueKugVdguhgm2Z88fFpJnqtTKSLhpvaxXs3VBBN34osxkobARn/l2VocfG2KI0wruZyJ
         WMsM3k4WAfk3sgXNmIdpDuw97RybyBq7/uWsBI/QYqWBRz5rPWdjC1Y/Xv5fB2jjJ/Up
         vP+g==
X-Gm-Message-State: AOAM533T8KIeCXONx+fEZuXXCEe/PGFJVweA1UHe3xN2s61R6lbWVqNi
        /qW2Gg45BbQMWqVh3KtAM++p2iQwh9o=
X-Google-Smtp-Source: ABdhPJzGNrYJp2IFGjhmrFmxuYB89kWWkYo6WwdyQZ1lPeVi+kRKHzYARL8aZVq18I7pX0Q/UZ3gqbn08tg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:5af:b0:2ca:396f:9d with SMTP id
 k15-20020a056e0205af00b002ca396f009dmr5221608ils.216.1649289385863; Wed, 06
 Apr 2022 16:56:25 -0700 (PDT)
Date:   Wed,  6 Apr 2022 23:56:15 +0000
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
Message-Id: <20220406235615.1447180-4-oupton@google.com>
Mime-Version: 1.0
References: <20220406235615.1447180-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 3/3] selftests: KVM: Free the GIC FD when cleaning up in arch_timer
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

