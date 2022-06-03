Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9553C330
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbiFCA54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiFCAsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:48:35 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511251EC60
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v9-20020a17090a00c900b001df693b4588so3399192pjd.8
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xCwRt9ASaTV3+voHkN81FJmxrFYBbA6lWLKwN9Fy0tg=;
        b=mcDG2DdNxkNiwni8UMCxiRrS3SuSLpwAl3RZUPzSnOl/jPnCiOXKX53C00LFpApTRt
         olB3KMJEttycQKrJ7svDpoWepSn0DYNGUgXysDpE0BSDHkknnzO1ZfZCVeZkEPpKbY90
         mR3OX0dkYi65tjZn8SGljFHltOdWs+2DJ63HxLD6jaH/5WJrFfCBWj6/VqCbCZM/sc7h
         NIox+iS/c7jrQX8Uh1JXfmlXPTsOYazymcdIT/tj+rUIRWOPjtfsgFuv0arEtgI/LcP3
         jx9AQZOiUu/jefvZoahh6sa5qxV19taEe5TH1fIoPdulieOOpGJMkK9aClyf4EoHGs+P
         HYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xCwRt9ASaTV3+voHkN81FJmxrFYBbA6lWLKwN9Fy0tg=;
        b=jAItpvfHycqcZGBk/lRZGdDy3N+UkcCL5pk1q55Vg7NEJC9itClP05HN1hzJIl/5p7
         FkAaykLOditRybk/ZsOUZFWCQx0WDQgNnoFUSvt0+pqLueKBQqWtbwf/35RiECujlSjr
         qMYNkTj5Dw3Tg21Q2y5K5T68Hh1Tyi+S598LZ5u4YB/UeHiJLwWtMioE3qcOkg/lWALR
         8YGg7/hgX87c5qCis1fW7TIZKbxRdHGy03GW+xoLsJ7Iz/qb2qRSRRqJR4oOTb4Iwetb
         CE/s6tEFleP6aK058dFMvcKEDUdbzP1CTu38DjZ1eIIpwnuzIKApUcTFWEGWFHEtAIbW
         d6TQ==
X-Gm-Message-State: AOAM533oojBwlnqULxcUZMqpBYhQoajmYyCWuL36tXGRMqfYRMb0cWWF
        aijAhRJzzHr0iqOJJ+52n2i9RSAhpmk=
X-Google-Smtp-Source: ABdhPJxrnzpumre4tShZ2lmGxl76nQm2VNydMb0RO/lnougEU25QvIPALC+CNGHfpFaNC/9WBUc86kytf2w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:f60e:b0:158:5c4d:d9b0 with SMTP id
 n14-20020a170902f60e00b001585c4dd9b0mr7686895plg.63.1654217220262; Thu, 02
 Jun 2022 17:47:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:00 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-114-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 113/144] KVM: selftests: Sync stage before VM is freed in
 hypercalls test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Sync the next stage using the VM before said VM is potentially freed by
the TEST_STAGE_HVC_IFACE_FEAT_DISABLED stage.

Opportunistically take a double pointer in anticipation of also having to
set the new vCPU pointer once the test stops hardcoding '0' everywhere.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/hypercalls.c        | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index b1f99e786d05..44ca840e8219 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -246,32 +246,31 @@ static struct kvm_vm *test_vm_create(void)
 	return vm;
 }
 
-static struct kvm_vm *test_guest_stage(struct kvm_vm *vm)
+static void test_guest_stage(struct kvm_vm **vm)
 {
-	struct kvm_vm *ret_vm = vm;
+	int prev_stage = stage;
 
-	pr_debug("Stage: %d\n", stage);
+	pr_debug("Stage: %d\n", prev_stage);
 
-	switch (stage) {
+	/* Sync the stage early, the VM might be freed below. */
+	stage++;
+	sync_global_to_guest(*vm, stage);
+
+	switch (prev_stage) {
 	case TEST_STAGE_REG_IFACE:
-		test_fw_regs_after_vm_start(vm);
+		test_fw_regs_after_vm_start(*vm);
 		break;
 	case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		/* Start a new VM so that all the features are now enabled by default */
-		kvm_vm_free(vm);
-		ret_vm = test_vm_create();
+		kvm_vm_free(*vm);
+		*vm = test_vm_create();
 		break;
 	case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
 	case TEST_STAGE_HVC_IFACE_FALSE_INFO:
 		break;
 	default:
-		TEST_FAIL("Unknown test stage: %d\n", stage);
+		TEST_FAIL("Unknown test stage: %d\n", prev_stage);
 	}
-
-	stage++;
-	sync_global_to_guest(vm, stage);
-
-	return ret_vm;
 }
 
 static void test_run(void)
@@ -289,7 +288,7 @@ static void test_run(void)
 
 		switch (get_ucall(vm, 0, &uc)) {
 		case UCALL_SYNC:
-			vm = test_guest_stage(vm);
+			test_guest_stage(&vm);
 			break;
 		case UCALL_DONE:
 			guest_done = true;
-- 
2.36.1.255.ge46751e96f-goog

