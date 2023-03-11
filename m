Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9896B570B
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjCKAtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCKAsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:48:09 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E58813F688
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:22 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p9-20020a17090a930900b00237a7f862dfso5075459pjo.2
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XQpHQnTblZcYiw70uXGfxV6izqCE3iLyNZEfMn1FeJc=;
        b=F73jJN26RfNAt0Q4PPpnKkx/ZnL8G2GZ0Wcbjb0JAbkHSSC6mLvfHoFU8cX9axXq6p
         2tOVrsjfrCSeOHC+FyDNMdVhFYFQ20L3L3ltPU9pnj9OZYvc8/UTDi7apGxan/ASgKDp
         BJNtysKgFKFHTkdFSktdJqPiPZp/UfE8TwoI5b0j8Exe3ilYq2/4LVHb30PgHfWQLBP8
         IYWon6Qhn9n1XNHl2f4jhzthYyl7xtbB7W+UUiA73jPnj4VuK+VPKqCxN2Xvbr18EH0O
         51NcqaKmDb5zj9Aw6HlbJ6ZDJJdiqpJsKs2dUBqL5iOSDpCvAEJL/eTYonN/DSEDF6Rd
         2HJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495615;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQpHQnTblZcYiw70uXGfxV6izqCE3iLyNZEfMn1FeJc=;
        b=ex5yBJiYy02Uv2TyDJE30zr07rIx9kV84CEIlTjp0aTIIcZUXvmMGO+2xTo/cMy9I5
         vQWMmPuHFWXACQ9VUsnX1abIuJC3/tNjPXIkSyzhy1n614THykWrfIhk1AD4SEwLmqPL
         00oK7i/1tQApbxQf+Axc8No3LMdpNNqRC8OJyrHW1X0jQa2NOUMMSei2UwD9C1W2kNCo
         ZZ1kNkEk+wj74PXhz2Q1VHAbkcrdR1IAxEc2qyxZLwCxNfkgSGGd0uH3c8HTr8kMvVaG
         c4tA0/3DRVc7SOt8n4Z7rEXjINDnxali8ibfyVQj2TqSX+52MWOI6chitWEt8StYyNfp
         FymQ==
X-Gm-Message-State: AO0yUKXtAkMZTop0RqgPASYOoTa+Tt6yis+WXq+AJ8kqodunK+eioyir
        +8zL26DR0v9TcchaaZDa/+cu9WsKYiE=
X-Google-Smtp-Source: AK7set97PJajfdHDsySczsXjilCUcygpoXZXoRuz+znVS6Sy8iBdOZWHu2JoCxrNpduPnoEz66UkQC+qO6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:744a:0:b0:503:919f:b942 with SMTP id
 e10-20020a63744a000000b00503919fb942mr9549279pgn.11.1678495615416; Fri, 10
 Mar 2023 16:46:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:15 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-19-seanjc@google.com>
Subject: [PATCH v3 18/21] KVM: selftests: Drop "all done!" printf() from
 PERF_CAPABILITIES test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the arbitrary "done" message from the VMX PMU caps test, it's pretty
obvious the test is done when the process exits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 6fc86f5eba0b..6733d879a00b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -213,6 +213,4 @@ int main(int argc, char *argv[])
 	test_fungible_perf_capabilities(host_cap);
 	test_immutable_perf_capabilities(host_cap);
 	test_guest_wrmsr_perf_capabilities(host_cap);
-
-	printf("Completed perf capability tests.\n");
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog

