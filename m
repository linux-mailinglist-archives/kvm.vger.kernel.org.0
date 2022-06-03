Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D531D53C24B
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbiFCA5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240939AbiFCAuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC2E289A4
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:24 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j23-20020aa78017000000b005180c6e4ef2so3489678pfi.12
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l/OZjUL38jsfY4/DpTlZPtW8u7Bpzi8r+BXI9KSVCQ8=;
        b=nIEvPCDXk+dhtPWG/5txV/z74Hw6CBk6fS9BiJZ6DSvcXtK8IX/B77ecEXalkF1ok8
         euOlklsQ4pUc/BZDMwSBgm+ao4x6geiLUzOPRiec7ym15s7l5bBZQ0WATTB6IsXTPRCS
         kXbjfkBuTKGH3yNFvVZtatT9EXdvZX5kI6fhC5xyUz4Xlcj26iFvgdOUKoWNnuCBgYBu
         /X7IgPTI4ub5kDCcmx3658ZkrDMOuegZ8mUnklM2ywOJRF+KoFhhOn1NWIute1vBTKxF
         nGywyqh9zbyUBiuCm1gXqlVOZTOLD4N2k0RoizUz0RSCpZUS0Df6TyggGXHMc93JqDfL
         bXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l/OZjUL38jsfY4/DpTlZPtW8u7Bpzi8r+BXI9KSVCQ8=;
        b=NxlqkMkOk/lV4aRCzi4iZS2CF5QOgWmzPywLE+mySw1KAgYBG+YNZZvcH89B4VwhZA
         FjG9cm4pzZxbkfuo8yb93OGs7V2QMC++ZIZXE2TX7t+sKmwvydkhIjvYL7PNrXcbMOFS
         O23cQkzFuHrv1QOyR7SdAlv42JqEBC/mn5Byl6i+wqaKGHH7rSuZRqcBkhMzbe9ym5lf
         AhSZCJcWcW/nt6OSBRPnemROzbGZeuZeeyrEDCy42TLyhjFnBVA5RfvfxqQ82W/sH+t+
         xH/huLQF2nxB+9Qx2XujCzqRSRCgB0dvDPMtYliclkpDfbv4XRS2qVSKJchzhuhJuUjZ
         mxOg==
X-Gm-Message-State: AOAM5327uALOtYkzZGPKXrqLiB2PHRoB/efjSvVicsqiT33VRMGSv5ai
        sjw1Lp2OXIFmn4jrrbc5R3vNFU1YNIk=
X-Google-Smtp-Source: ABdhPJwOrd21xozUkPSPipBTDUPDfGjWpV3moLecJ+b9YdF1JJEpxNgEGqyPUCWLXp4CF0pd9v+SdzWWRxE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:888a:0:b0:518:a0b8:f5c1 with SMTP id
 z10-20020aa7888a000000b00518a0b8f5c1mr56039909pfe.46.1654217243828; Thu, 02
 Jun 2022 17:47:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:13 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-127-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 126/144] KVM: selftests: Convert kvm_binary_stats_test away
 from vCPU IDs
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track vCPUs by their 'struct kvm_vcpu' object in kvm_binary_stats_test,
not by their ID.  The per-vCPU helpers will soon take a vCPU instead of a
VM+vcpu_id pair.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 407e9ea8e6f3..dfc3cf531ced 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -172,9 +172,9 @@ static void vm_stats_test(struct kvm_vm *vm)
 	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
 }
 
-static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
+static void vcpu_stats_test(struct kvm_vcpu *vcpu)
 {
-	int stats_fd = vcpu_get_stats_fd(vm, vcpu_id);
+	int stats_fd = vcpu_get_stats_fd(vcpu->vm, vcpu->id);
 
 	stats_test(stats_fd);
 	close(stats_fd);
@@ -195,6 +195,7 @@ static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
 int main(int argc, char *argv[])
 {
 	int i, j;
+	struct kvm_vcpu **vcpus;
 	struct kvm_vm **vms;
 	int max_vm = DEFAULT_NUM_VM;
 	int max_vcpu = DEFAULT_NUM_VCPU;
@@ -220,17 +221,21 @@ int main(int argc, char *argv[])
 	/* Create VMs and VCPUs */
 	vms = malloc(sizeof(vms[0]) * max_vm);
 	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
+
+	vcpus = malloc(sizeof(struct kvm_vcpu *) * max_vm * max_vcpu);
+	TEST_ASSERT(vcpus, "Allocate memory for storing vCPU pointers");
+
 	for (i = 0; i < max_vm; ++i) {
 		vms[i] = vm_create_barebones();
 		for (j = 0; j < max_vcpu; ++j)
-			__vm_vcpu_add(vms[i], j);
+			vcpus[j * max_vcpu + i] = __vm_vcpu_add(vms[i], j);
 	}
 
 	/* Check stats read for every VM and VCPU */
 	for (i = 0; i < max_vm; ++i) {
 		vm_stats_test(vms[i]);
 		for (j = 0; j < max_vcpu; ++j)
-			vcpu_stats_test(vms[i], j);
+			vcpu_stats_test(vcpus[j * max_vcpu + i]);
 	}
 
 	for (i = 0; i < max_vm; ++i)
-- 
2.36.1.255.ge46751e96f-goog

