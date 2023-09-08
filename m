Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD46579923E
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343924AbjIHWaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343820AbjIHWaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9D71FE7
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:30:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b6083fa00so9604757b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212201; x=1694817001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KBbXT1HpOrFkX6fT3ri9dT8smyClqE/Pk/MSUbxJK0g=;
        b=alC1oCufNh9x2TWBtheD6ycZ18f7z6RBgYZQmjwANN2xgcwW5t/uPS0WD5vRy4LT8U
         fAXLwtrTUpzhgP/CBxiJ//MlSrWYALeix7W6qqYRWqYHL/DIJgW8PKIu9qj0EYPQ5VtX
         sfZIekn6HcQARJBOEdxMXCSBerI6kCHk7KxTfAEXdbxoXB1P3Rzyp9S2653hR9Gkfh/C
         BnxR1WWIc/t3YHEZlphsvHAcdzJaaJXArPBL7lyNVZYXKEMKEA0y06+7NSyM/BDP8E/i
         QcnIQ5ax+LdkPg8gvEYPKX72IFK1FpJg7aqeooeeYFLwaRFC27MlHiX5V4xAkQSdo7Hi
         DzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212201; x=1694817001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBbXT1HpOrFkX6fT3ri9dT8smyClqE/Pk/MSUbxJK0g=;
        b=POFyFiHK4aST7cdfuCby0n/IwWbP4EMt+twwyTkOy52yicdBSgPcZsSvbYte8sZ+zi
         W94SUplQFscAoeU+xyGpz0+Rkcfm93WOo+4M9n4LEfV6+pwjW272ykK22dpTR6ZpLIo2
         eG2aTQUr0ppO43hOh1dBt6P1/nn7cVfmwyTXp9kVTcsNkDzrJhKqRDmAy5pOGi9ZhzKN
         +K82dYvbxyMfpZKmvGdrFz9jWv7OWvDG4h23rsuo4XzkulYTFH1hkF3CzN8zgCF6OAk1
         LnqdB+F+tfWRdKgGMiCwINMOJIGIOzCNkJQ6vgL6A+PHCDBzt+EGbYpDcSm123LbhPEN
         nj6w==
X-Gm-Message-State: AOJu0Yxn8H8Yr/m4+Git3aq84uJ6fYP9Z72oEgNndFrRurQW0DqpNvAW
        L+uXn3fMDkbbqYkSmkVpxvQvlYWzlTKMbg==
X-Google-Smtp-Source: AGHT+IG0u7Fmfgwad2kTm5siZgMBlIJxpuK6meAbCgZIKiyvEqI1hsyuH16I5IXFPHVsdwlRNhxPIlipqpV5bw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ae96:0:b0:c78:c530:6345 with SMTP id
 b22-20020a25ae96000000b00c78c5306345mr67692ybj.7.1694212201104; Fri, 08 Sep
 2023 15:30:01 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:29:00 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-14-amoorthy@google.com>
Subject: [PATCH v5 13/17] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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
index 09c116a82a84..6dc823fa933a 100644
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
2.42.0.283.g2d96d420d3-goog

