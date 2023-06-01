Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4371F23C
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjFASnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFASno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81630184
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685644980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VWv8qJdIHUdzD1kuOVxtkf1lAHbXHShxABd30VkBVcA=;
        b=OGaB963Cy1RbybPpiBmMDXrjL29ovGlNidbtQMMYAe9EvDLSwUmp8SYFyB+Vw+7EKov5UU
        jBywXpYxqQ3obC+RpNVTlR+OHRm8d9BDnlyo4XKBXi1dTeQdy+cbgFNpCAAUx3vQwOKnk9
        6eovI6MjvxzuJKrzgyrrL7+AHid+WX4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-bfj5yRAKOUKK92yFx4RW5A-1; Thu, 01 Jun 2023 14:42:59 -0400
X-MC-Unique: bfj5yRAKOUKK92yFx4RW5A-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f8283a3a7aso2942101cf.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 11:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685644978; x=1688236978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWv8qJdIHUdzD1kuOVxtkf1lAHbXHShxABd30VkBVcA=;
        b=laJZqzWYsLWpcDv5pZ71ya5+UlDbn7OkfIoUijmnJ2Rvrw295KJnipL2V6ZcP8OYaQ
         5v1QxjCf23qeq6O1eKY5qVgau1EGT8W9FmyLhH+Kd1HYwIpdJ4rvkSzHpOgFr5oC9YYp
         wKi3EYf60Zwuo25r1wC194qQHEIjktsTeD1ErvCpJXiEZ72HUlnycIbFCnM47QA8b/BU
         wsNVntViLkDEKIufVBJDgieWmKwJUJBxXzS8DlIj3+rtut6DOuxSqSnmSmTYEydi67H2
         d1mSZG1/tBCYUMnfQPUkqXG+4wcqeAJnS2JFbEU4YseJWku+Ucr5qAeNjPljCBhwXXox
         Uwrg==
X-Gm-Message-State: AC+VfDxpFWs9EXPh/BFgkcQbYndlAJGPoRzoMKDIBamKQQvhYx0bU4P5
        RMdgDcuDgswZfAQbZPVr84353LH6Nv46TUw2Fsqw+SN6A1wOXXPcnAmzejTImg/tpxG67Jwz0EY
        s8s+7lkP4+G2N7rNIYU96
X-Received: by 2002:ad4:5966:0:b0:61b:76dd:b643 with SMTP id eq6-20020ad45966000000b0061b76ddb643mr6769790qvb.4.1685644978207;
        Thu, 01 Jun 2023 11:42:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4taCFW5c1Qbd4oWSXHSpnchEF/DTJbznrlO+oTXZHORe+U/7qVfz9xLPKydbKakE7U4fmjtA==
X-Received: by 2002:ad4:5966:0:b0:61b:76dd:b643 with SMTP id eq6-20020ad45966000000b0061b76ddb643mr6769776qvb.4.1685644977932;
        Thu, 01 Jun 2023 11:42:57 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id w1-20020ac84d01000000b003f6a0fa022bsm7947063qtv.51.2023.06.01.11.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 11:42:57 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     James Houghton <jthoughton@google.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2] selftests/kvm: Allow specify physical cpu list in demand paging test
Date:   Thu,  1 Jun 2023 14:42:56 -0400
Message-Id: <20230601184256.180413-1-peterx@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mimic dirty log test to allow specify physical cpu pinning for vcpu threads.
Put the help message into a general helper as suggested by Sean.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c  | 15 +++++++++++++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 12 +-----------
 .../testing/selftests/kvm/include/kvm_util_base.h |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c        | 15 +++++++++++++++
 4 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index bdb8e0748154..8581478ed4eb 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -220,7 +220,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
+	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a] [-c cpu_list]\n"
 		   "          [-d uffd_delay_usec] [-r readers_per_uffd] [-b memory]\n"
 		   "          [-s type] [-v vcpus] [-o]\n", name);
 	guest_modes_help();
@@ -229,6 +229,7 @@ static void help(char *name)
 	printf(" -a: Use a single userfaultfd for all of guest memory, instead of\n"
 		   "     creating one for each region paged by a unique vCPU\n"
 		   "     Set implicitly with -o, and no effect without -u.\n");
+	kvm_vcpu_pinning_help();
 	printf(" -d: add a delay in usec to the User Fault\n"
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
@@ -247,6 +248,7 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	const char *cpulist = NULL;
 	struct test_params p = {
 		.src_type = DEFAULT_VM_MEM_SRC,
 		.partition_vcpu_memory_access = true,
@@ -257,7 +259,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ahom:u:d:b:s:v:r:")) != -1) {
+	while ((opt = getopt(argc, argv, "ac:hom:u:d:b:s:v:r:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -272,6 +274,9 @@ int main(int argc, char *argv[])
 		case 'a':
 			p.single_uffd = true;
 			break;
+		case 'c':
+			cpulist = optarg;
+			break;
 		case 'd':
 			p.uffd_delay = strtoul(optarg, NULL, 0);
 			TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
@@ -309,6 +314,12 @@ int main(int argc, char *argv[])
 		TEST_FAIL("userfaultfd MINOR mode requires shared memory; pick a different -s");
 	}
 
+	if (cpulist) {
+		kvm_parse_vcpu_pinning(cpulist, memstress_args.vcpu_to_pcpu,
+				       nr_vcpus);
+		memstress_args.pin_vcpus = true;
+	}
+
 	for_each_guest_mode(run_test, &p);
 
 	return 0;
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e9d6d1aecf89..a17d4ebebe55 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -402,17 +402,7 @@ static void help(char *name)
 	       "     so -w X means each page has an X%% chance of writing\n"
 	       "     and a (100-X)%% chance of reading.\n"
 	       "     (default: 100 i.e. all pages are written to.)\n");
-	printf(" -c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
-	       "     values (target pCPU), one for each vCPU, plus an optional\n"
-	       "     entry for the main application task (specified via entry\n"
-	       "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
-	       "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
-	       "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
-	       "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
-	       "         ./dirty_log_perf_test -v 3 -c 22,23,24,50\n\n"
-	       "     To leave the application task unpinned, drop the final entry:\n\n"
-	       "         ./dirty_log_perf_test -v 3 -c 22,23,24\n\n"
-	       "     (default: no pinning)\n");
+	kvm_vcpu_pinning_help();
 	puts("");
 	exit(0);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc2a79369b8..dc8afe64cfb7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -734,6 +734,7 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
 void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 			    int nr_vcpus);
+void kvm_vcpu_pinning_help(void);
 
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8ec20ac33de0..5c9b9706f56a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -489,6 +489,21 @@ static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
 	return pcpu;
 }
 
+void kvm_vcpu_pinning_help(void)
+{
+	printf(" -c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
+	       "     values (target pCPU), one for each vCPU, plus an optional\n"
+	       "     entry for the main application task (specified via entry\n"
+	       "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
+	       "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
+	       "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
+	       "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
+	       "         ./dirty_log_perf_test -v 3 -c 22,23,24,50\n\n"
+	       "     To leave the application task unpinned, drop the final entry:\n\n"
+	       "         ./dirty_log_perf_test -v 3 -c 22,23,24\n\n"
+	       "     (default: no pinning)\n");
+}
+
 void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 			    int nr_vcpus)
 {
-- 
2.40.1

