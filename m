Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7DE5EFEDB
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 22:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiI2Ur2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 16:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiI2UrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 16:47:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065FD15313C
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349423f04dbso24598657b3.13
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 13:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=m9o9aC44IY/im9QAS+qaues+I53Dzb9AHDDpW5u1v5c=;
        b=HgRgZwUsL+vm/dX90nmv82OSQcUtARJ36y37S8UdTMx2HdsiLkwxuWRWxmfiOqrHE+
         nLQuF5MhBOwOHQ9f7VlMQ0v4C+Y/JKmmMmOjnwFLsie2dRS/q855wl8JxN4stoNl238b
         tZjmBVvqY4hc25JrI6jOJ6eiK6keccGoq8DWgnMDQvc3Th3SFi8nJbeXVCRF7CVREYCj
         eptalcWmah9dev+gC8CPcS3i51rCxI+2SOTmRnVe1holvaCB0AQb1cRgrvfsTRB33Ivx
         m0/D9w2kKULKM7XGqIiZOWQWjHA7yB35D+nr1uE3w/zsWUDGXDaqaw+aczasb5pbxv0F
         y5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=m9o9aC44IY/im9QAS+qaues+I53Dzb9AHDDpW5u1v5c=;
        b=rc81kP3Y1j5LiS3/8UNl6tqtPoWlf/ntoxxqCDaprxwizadAKKddNO9YRmurroK8rj
         BVbB6X1E87cFiYwA9ymfkTh8I/NZm+t+MRNTbP9SZ9hOGDXbvq3eF1Fb7hma3D/kMz8+
         eO0Kdw8XNRUx9PtNLGA0/uuh587H7MzXs1MjABVmjZuFjP4KHhx/wE4kerJ1ELB6BCe5
         o6X4PNRdbioaywVFMGvSmYoHxPsJM5yUCsyOxw9ZnwlEquW+X+jblhdxFyGr5p+/tiJC
         XFeTaGZ5HibSaQpSt1TvOZ5I4HWo5FXubT+StMS+9VD80x+WjTsxwl5wx1rU2kGNA9nG
         ASpA==
X-Gm-Message-State: ACrzQf11r0q2jwar2RKPAExKru9wh9o7pYUmpGPfWhfUfm3U9ECAV0Oi
        VDTl7IsVF/ePQbhc2M2KDkvV0hAyo1DYqw==
X-Google-Smtp-Source: AMsMyM7okvM2d9TGUnzuQXESO/VvZPGMOsOoqNODiZF7b6EaR7I7m6WBi/liP0Oia/8cL9wxIMPnv/u5JwRZZA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:97c5:0:b0:6b0:7306:8a76 with SMTP id
 j5-20020a2597c5000000b006b073068a76mr5079490ybo.400.1664484440252; Thu, 29
 Sep 2022 13:47:20 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:47:07 -0700
In-Reply-To: <20220929204708.2548375-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929204708.2548375-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929204708.2548375-4-dmatlack@google.com>
Subject: [PATCH 3/4] KVM: selftests: Skip emulator_error_test if
 KVM_CAP_EXIT_ON_EMULATION_FAILURE not available
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Skip emulator_error_test if KVM_CAP_EXIT_ON_EMULATION_FAILURE is not
available rather than failing. This makes emulator_error_test skip on
older kernels and also deletes a net 2 lines of code from the test.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/x86_64/emulator_error_test.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 52ff1eb772e9..4b06c9eefe7d 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -103,15 +103,13 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	int rc;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE));
 
-	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
-	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vm_enable_cap(vm, KVM_CAP_EXIT_ON_EMULATION_FAILURE, 1);
 
 	/*
-- 
2.38.0.rc1.362.ged0d419d3c-goog

