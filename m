Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CDC72075B
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbjFBQU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbjFBQUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:20:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB40A134
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:20:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb24045f986so458746276.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722803; x=1688314803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AKZ+QcH2t4NJe/ed/jTt48MOUVZ5yGgakBcy9/LKgLc=;
        b=gOJmzaVwpb5cL/ofhb40JPjrejLFOmGwxvBLREtZtKYEtBqlBWWmNvx4yz+dZNfNTt
         Yj2MvcBoIwXDTyCUQvN/5R0xzJPSzICMynP0RUnKbpIhxnH0Pu3vM7dS9KI3UWNVqLA/
         eHrc7eUjQtP9/xGPoR9alIVRAmwHpVVIyz9ucU/6VNW45j3M8iIN7z0HG01xPFg71RvR
         zGC4BxeHuhCM7o7ME+X3yWqsd+fMQyRwburJVoLMDdMXbN6KDcw2ZHS3q/L68ErJEpX4
         jwzvPt08ql+iMdABRu+67FZ3y+quTMFJL3Ap6xvKQM1vLhTWJ0q4Gq4uplDRhDxeR86P
         x9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722803; x=1688314803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKZ+QcH2t4NJe/ed/jTt48MOUVZ5yGgakBcy9/LKgLc=;
        b=CrFFYeq1A7X1s6l2e1VN3s58LjTO1HecbHSMS3VK1T4L581CMlOXD9HRpSx7sYUNsv
         wN2vJNYjfxxRmozGYTCFuyyLbDInvRidHPtq8PHejDkFTLkJIzTbTJGjfqUNO8wxb0wa
         qYR3vmye3eChFfqpSCPUCct3u4sm6CndwWN7oE8MkbMxF1l7HTR2nqsdX5+e8O9gs3yA
         WVwksPNTSqy/ATVA0UbqI30E7kjONw3ejevCkyZtiME/WxO5f6nOWOFIkDH9lZTLNSE4
         gDurJvVlQPWmUEEt5yICIHElwLD0BIOF1syIoM7Z8MxQQV+wZhDJhd0kCTuSpxKQSr+b
         p3eA==
X-Gm-Message-State: AC+VfDxhP6F6KdFRTJNC0JyKYsw26ZiB/zbmQbSHLYSOpSpDBv1UYSX2
        pBhGDN9RxWW3zjvK6BysDd2wGUtkqlTkvQ==
X-Google-Smtp-Source: ACHHUZ46dOJ4+aQ0H4ACFU/vf9rAuOjzZ2Z0+enGpkWWIIyAbS8Ekb99+ErWUPHF+isePP2KFPk3NpE4HGQiFw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1007:b0:ba8:4ff5:3217 with SMTP
 id w7-20020a056902100700b00ba84ff53217mr1260701ybt.3.1685722803102; Fri, 02
 Jun 2023 09:20:03 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:17 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-13-amoorthy@google.com>
Subject: [PATCH v4 12/16] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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

Using the overall demand paging rate to measure performance can be
slightly misleading when vCPU accesses are not overlapped. Adding more
vCPUs will (usually) increase the overall demand paging rate even
if performance remains constant or even degrades on a per-vcpu basis. As
such, it makes sense to report both the total and per-vcpu paging rates.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 9c18686b4f63..5e8bda388814 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -135,6 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
 	int i;
+	double vcpu_paging_rate;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -191,11 +192,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
-	pr_info("Total guest execution time: %ld.%.9lds\n",
+	pr_info("Total guest execution time:\t%ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
-	pr_info("Overall demand paging rate: %f pgs/sec\n",
-		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
+
+	vcpu_paging_rate =
+		memstress_args.vcpu_args[0].pages
+		/ ((double)ts_diff.tv_sec
+			+ (double)ts_diff.tv_nsec / NSEC_PER_SEC);
+	pr_info("Per-vcpu demand paging rate:\t%f pgs/sec/vcpu\n",
+		vcpu_paging_rate);
+	pr_info("Overall demand paging rate:\t%f pgs/sec\n",
+		vcpu_paging_rate * nr_vcpus);
 
 	memstress_destroy_vm(vm);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

