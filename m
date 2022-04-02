Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47A44F0542
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244498AbiDBRmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 13:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244141AbiDBRmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 13:42:45 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34115E0B6
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 10:40:53 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id f11-20020a056602070b00b00645d08010fcso3612188iox.15
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
        b=pRdr/FNL4DJ4+FDZfYXkJBtQDCsAq7uj4Emtow3IUaukx62QJi2YKu7pn/kogEODph
         Y+Ut0ZuenWviBdtaf3uK2ywut5KwfSCOLvuj4E4oRTQycEzaxb0DzPh8RMPK+LNVr1U9
         BeWnTU5Vzf7eMYH9M9yl+lnM/35IO89F+KiuVVUfxbFmL7DCH09Jixfk7rVjhOmUP+j6
         a/towLy19ro+gsEvXWFYQ/JDk+Ch7sQoSUNbTLyRyCqqiA9WSF46VI49YlqOoWC3xzcx
         XazJkCyLa9KKCF8rswY5B8VWHE3+GnUCNK6RnnP18kj5JH5MFdP1r61Sm0hEYI+A6ayv
         064w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
        b=m8EZnZUYIv2E4OcNdiLpBu1U2VPMpBa9gyX1WRpNNUc1dE9d6ZLy/JRKo/JZowrhKX
         j6y8QJFzCYX/jsqPTQ+iRAgmHZ16NEvDwDylTuOO3x1NCLaPPJo5MzBwMThzw/0PneeT
         WVKzHzSI4rjZIkeY6NYcTFl5HOzwmRPCWWRAo3KUkprziwI5vxWhwbzVLWJhurfFz0yX
         KOfhniAvLmSUV9/phs5CvI5L6IF3Ub1BnMHg4dF1e9d8JvfRUGuDLcmedeBr4Bkq6s0E
         l4oySWOCH8VWed8YDpsnIOSS8WEgALsfnMhPxreH2miD28E94A2g4L/EvOmKvDXg+VBY
         prAA==
X-Gm-Message-State: AOAM530rh+gV8Ogz7NOLAUJL5yIYlx6HRZe9TSc3DlEDmy0kyJaX5PY5
        owqy1x7j8hG25uZAIQGqFieecqDCwCc=
X-Google-Smtp-Source: ABdhPJxfhOuV+H0OWvhKyqVH+yGUG1Gyfq61aVtKlvvdZjUHlwISHe0FlEzqyL1csiERacH6j/kPsSDcnBY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:8d8b:0:b0:645:eb9e:6765 with SMTP id
 p133-20020a6b8d8b000000b00645eb9e6765mr2056322iod.215.1648921252570; Sat, 02
 Apr 2022 10:40:52 -0700 (PDT)
Date:   Sat,  2 Apr 2022 17:40:44 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-5-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 4/4] selftests: KVM: Free the GIC FD when cleaning up in arch_timer
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

