Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B0574FBAB
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjGKXCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjGKXCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:02:01 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DFD1BCE
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:49 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8a7735231so64507225ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116509; x=1691708509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NZYUXnjHPmQ/WMoe3NgtL+hMKetCK3WyAi/ewwv+qe0=;
        b=l44qBzgB6Q7SSsjQQ711GNRtQ8qlOMLsmMgf6zreaVte1Im4NUmW6FKj+LT1tEJ8RO
         hR+9DexXG3PZhGuIm5YgC4YyxlYUsdSIakurMN/gb2LCu+2WXYx03xTMfim8bjxZ0MYJ
         m05at+g01AIaxdj8VVc8YP/xE43ba1hHeUTyXRsLXEg1grEM7ikivejicwH32E5WoOaK
         xbHxFXfDCDUskgotNbrIwV9pvIwQPxYbD6bFoYSJVzsadr7oUWIhKGvNKaFOa9dSEjXT
         lHfnSzEhc0UQqSEf7zRwCljA/cQwTMMzZz+1ywwFNxq2HQZtxYqFqzU8XPhuHaCYEruo
         KE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116509; x=1691708509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZYUXnjHPmQ/WMoe3NgtL+hMKetCK3WyAi/ewwv+qe0=;
        b=E9EiDpJ1IvmR/W037hxsocnsAjcvfDOPoegmp8bpBylADPCYZJCgYyZu5iXXMM1D8U
         KgYi7AlmkQLnXtv2DtwTO2lLOPg0DKBqX5PAZqn04NovZWiy5okpcS6jILkLms6Cwscd
         5q5r37CtJwxWUmtmzJ33ehTkyfiSduBzv6AWQX6lsteK4TO6swWk0y0fN8PWLbGnuflk
         Ow+ZpRSVn5BWJJAhOWqDNrVzaXdymWBxiVW4j2iHCIxlAiKebqjrEIpNAb8wIN2OyXPR
         HJeyaXw8SAuT3VeqzcZGCgQwz5uORtV2wF3Su2RWhtBk1Z5afu00zK0J1996CClhJGmq
         eKpA==
X-Gm-Message-State: ABy/qLYPoWTZ9hbSrtmapz6k60zHnzEdcr96DCrtFNUNeLw4/IE6Qta7
        NSoEMiz5QdonR9QyD6xn+V1351KpSZ4=
X-Google-Smtp-Source: APBJJlHpwQnUAsfgftTMh1px84YuyX4vmpkN3OpQhjOCUnpxZyihOxV+4Zc6ADNt1Gp/Iop1b2qhlEf0Vs8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a417:b0:1b8:8cd9:5355 with SMTP id
 p23-20020a170902a41700b001b88cd95355mr12083294plq.6.1689116508764; Tue, 11
 Jul 2023 16:01:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:31 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-8-seanjc@google.com>
Subject: [PATCH 7/7] KVM: selftests: Verify stats fd is usable after VM fd has
 been closed
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
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that VM and vCPU binary stats files are usable even after userspace
has put its last direct reference to the VM.  This is a regression test
for a UAF bug where KVM didn't gift the stats files a reference to the VM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 5317e27b77d0..698c1cfa3111 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -252,6 +252,14 @@ int main(int argc, char *argv[])
 			stats_test(vcpu_get_stats_fd(vcpus[i * max_vcpu + j]));
 		}
 
+		/*
+		 * Close the VM fd and redo the stats tests.  KVM should gift a
+		 * reference (to the VM) to each stats fd, i.e. stats should
+		 * still be accessible even after userspace has put its last
+		 * _direct_ reference to the VM.
+		 */
+		kvm_vm_free(vms[i]);
+
 		stats_test(vm_stats_fds);
 		for (j = 0; j < max_vcpu; ++j)
 			stats_test(vcpu_stats_fds[j]);
@@ -259,8 +267,6 @@ int main(int argc, char *argv[])
 		ksft_test_result_pass("vm%i\n", i);
 	}
 
-	for (i = 0; i < max_vm; ++i)
-		kvm_vm_free(vms[i]);
 	free(vms);
 	free(vcpus);
 	free(vcpu_stats_fds);
-- 
2.41.0.255.g8b1d071c50-goog

