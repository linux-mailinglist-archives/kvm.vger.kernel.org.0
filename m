Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BB574FB9F
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjGKXBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjGKXBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:01:42 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309EB10D4
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b89e3715acso68764405ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116500; x=1691708500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8VQapMKBQBMTZxsjOULvb/Z6n7A3B0Prs/TRyhAaINo=;
        b=0meBJIEhxTgxt0w5IKnl8Z7teH02rv9JZxqyDtEuF1SoUNM0EhdKFpSC+T8V5Zcc4f
         ItM4ARCIWVT/rgEt8uYkBwBE/REmEktJEKeeLxdD+HYTwWEZGeMbWRig1L8QTKsIQ5T2
         hVkbXXKQSkWbxGGMsrcm56i8+aD/5dB7DOJP97opcnl2Ry4E6RHruR/qykibFq0/aUfW
         extko0Q/JcbDrL4/gyZcVcBTXaYze++0rQtwMUtlL1UnwshBD8Q5le30OExohxvBKRNa
         iLoDSD7fcIE/6uWCbzRK5jSM2JFe8rTxZeHBnCvka8ar7fO6J7NhQ6ilvUovBerrQ8U2
         Jhvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116500; x=1691708500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8VQapMKBQBMTZxsjOULvb/Z6n7A3B0Prs/TRyhAaINo=;
        b=Jdt9kGdwSetRLbo9R4rVbMeH94zZZCAWAxWYiFyU/Sj77AW9732irOdEvBBEeUpSSg
         nqEo0GCC0dSuv3oZ5v+Zc+Y2WuSBw/dXW7++fP+OvmUPHV2Rn2diFnrbc79NGPYYyQ0e
         VRkSJnkKGxM2YSqBet1pnMM0N03GCCEkEbCuMl5nOxqSxhJaV2KNaFqG8ExYgPL2UJ6V
         UsduxX5e4pSf97NFuHDBK37FDc0MQNUMCp9gLjkEYVFWcnm/UMQE9mt+UjAYjAT7VwdD
         1aG9cruZJGKHbVQVA2HV6UMzUKMQnP8lRGY87CkAnH7N6qM3R3Rk8xRHlluDAvDZ1ggY
         dCQQ==
X-Gm-Message-State: ABy/qLZQ/4SmP31ssDgGvNvsfNuLQYBl+/znkB/c9k9WpkgZbP76fVQH
        vwEFTwNfHNXMrvQvjU3ykPPVsu3iZZ0=
X-Google-Smtp-Source: APBJJlGManPSJIk0kdX94lHfSRSwM/QUvQS1ucWRoZhgJW/JZxlZW9IEoHaKwptTif9cwXe6p+xwpmckpJs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a417:b0:1b8:2055:fc1f with SMTP id
 p23-20020a170902a41700b001b82055fc1fmr13104726plq.2.1689116500737; Tue, 11
 Jul 2023 16:01:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:27 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-4-seanjc@google.com>
Subject: [PATCH 3/7] KVM: selftests: Clean up stats fd in common stats_test() helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the stats fd cleanup code into stats_test() and drop the
superfluous vm_stats_test() and vcpu_stats_test() helpers in order to
decouple creation of the stats file from consuming/testing the file
(deduping code is a bonus).  This will make it easier to test various
edge cases related to stats, e.g. that userspace can dup() a stats fd,
that userspace can have multiple stats files for a singleVM/vCPU, etc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c     | 22 ++++---------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index eae99d0e8377..f02663711c90 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -167,23 +167,7 @@ static void stats_test(int stats_fd)
 	free(stats_data);
 	free(stats_desc);
 	free(id);
-}
 
-
-static void vm_stats_test(struct kvm_vm *vm)
-{
-	int stats_fd = vm_get_stats_fd(vm);
-
-	stats_test(stats_fd);
-	close(stats_fd);
-	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
-}
-
-static void vcpu_stats_test(struct kvm_vcpu *vcpu)
-{
-	int stats_fd = vcpu_get_stats_fd(vcpu);
-
-	stats_test(stats_fd);
 	close(stats_fd);
 	TEST_ASSERT(fcntl(stats_fd, F_GETFD) == -1, "Stats fd not freed");
 }
@@ -241,9 +225,11 @@ int main(int argc, char *argv[])
 
 	/* Check stats read for every VM and VCPU */
 	for (i = 0; i < max_vm; ++i) {
-		vm_stats_test(vms[i]);
+		stats_test(vm_get_stats_fd(vms[i]));
+
 		for (j = 0; j < max_vcpu; ++j)
-			vcpu_stats_test(vcpus[i * max_vcpu + j]);
+			stats_test(vcpu_get_stats_fd(vcpus[i * max_vcpu + j]));
+
 		ksft_test_result_pass("vm%i\n", i);
 	}
 
-- 
2.41.0.255.g8b1d071c50-goog

