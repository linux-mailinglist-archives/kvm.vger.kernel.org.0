Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3836699D9F
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBPUZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBPUZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:25:09 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750163A0B6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:25:06 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k9-20020a25bec9000000b00944353b6a81so3089456ybm.7
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDQ7KvyDpfsj/imayjFP0wV3OxBaUwM6CN96YqXWrfA=;
        b=K7tyLOQmQMP0VWdW3BxwR7/AgHt9jemeev2qPmbu7xudMQRuYKBtn4kVOR09ok9po5
         HJWJ66R+7RAIWNKZZYkoUjukM/x0slRaAuWJBU8iO+Oqb+npJTYJcvEOCB+8bC15VFIF
         N2LxQNDOM4Tdn9j7fRnMMP+shn07ilz+6brgEo58cO6fgC+W4+TiH2XYtCjUht0jlU1D
         yRKujt4BVG6TtX/c1HkZy7jI9Jskn6n3260d76d7AoXh5H75WqRAYiyHW8Ou5vZ7sYop
         08BosPaqW1ltpHjbBKYMvdDYgsClCM0NoNF7Tvd/aRwkEWa9y0qBmQfO0D6vCeQP4bdL
         o30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDQ7KvyDpfsj/imayjFP0wV3OxBaUwM6CN96YqXWrfA=;
        b=U+kyxZXd0CSsDbShameQWPszJdE4M3065cN4yjtxhUf6abuilVjdjlTXM8yB8qaa4D
         vt7elpilmGtftydv0aGFXBFUEECEaU2xhoHl49lM8hEV309BSzxP1onoNG8+06e/SPQn
         MT4EceVUD4pGVWgRrhTsfV3ha7YAXNugyiXMzCb4R1WqiSdjcKUaeGEMlWRTwGAM8vPH
         Q9QIZH2Ug6itWuUliF2gsR1iHqwsXnlG5qnC5ZeR2c1EU/5Gd5lJGcOY844cbsyT8DdD
         E18fW/4xsqdaQlznqWwhJORbQsYJex1C4AP9eqZBLuegVRtcKqsQF17ClfS2noOkNgCq
         syCg==
X-Gm-Message-State: AO0yUKWawDiA+IKsDnzXiER9ewyKPm7Rd09u+x/lmC2C8zMN+xj5Jswm
        ZkoAfqe7BAVYeOSKr4C3hgfU21sk4aYuRw==
X-Google-Smtp-Source: AK7set8BAYAk3KQPj312kh6tmMJ4U85BUd+UAf7CDI4ZRUeohfxDIVJZdVF+ZsCFzZunCkFUnPy2X5DZkeFZIw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:a547:0:b0:50e:e691:94b6 with SMTP id
 v7-20020a81a547000000b0050ee69194b6mr840357ywg.315.1676579105752; Thu, 16 Feb
 2023 12:25:05 -0800 (PST)
Date:   Thu, 16 Feb 2023 20:24:32 +0000
In-Reply-To: <Y+6PWxGL5w+pwbhe@google.com>
Mime-Version: 1.0
References: <Y+6PWxGL5w+pwbhe@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216202432.1033366-1-amoorthy@google.com>
Subject: [PATCH] selftests/kvm: Fix nsec to sec conversion in demand_paging_test.
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     jthoughton@google.com, seanjc@google.com, oliver.upton@linux.dev,
        Anish Moorthy <amoorthy@google.com>
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

demand_paging_test uses 1E8 as the denominator to convert nanoseconds to
seconds, which is wrong. Use NSEC_PER_SEC instead to fix the issue and
make the conversion obvious.

Reported-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b0e1fc4de9e29..2439c4043fed6 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
 		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
 
 	memstress_destroy_vm(vm);
 
-- 
2.39.2.637.g21b0678d19-goog

