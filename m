Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECE3725108
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbjFGAMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239991AbjFGAMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:12:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC07D1985
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:12:29 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f6e19f814so2017687a12.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686096749; x=1688688749;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOKQucxjReBAl4ueIGJC15nKLzQWh4BqOUmVZxC990Y=;
        b=jpOg8A7Whukym3P9JMD50SgFY2Q6AnR51vkyYqvhxQYMCaB+QLPDYzMk9YMN0BXJIx
         Be10BMVUxPzOq5yf0BqSSYDB4yN5YqXMX7q8Iyzl/LuNsCLcWKGMxvot9ofgLGUsElav
         ZFisDfXzuzu0cpr5cti+WbJCsF+yzrY1GSdF5R7+nTJyEclLxAR4bqW/KkXtJJ7zJ3Fi
         l645yU4Kk1d1PW0NuxDBqQObLdg8ChcNlVk+MdAYcELVAu2+fke73EI0z+A7aJX6jjdn
         pkD72BZ8m33UFFfC3kd9fVNSaDPLYUeD6d2FnaZG/oWzr36NmWucpEOIrvtBOkgNgIP6
         JoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686096749; x=1688688749;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOKQucxjReBAl4ueIGJC15nKLzQWh4BqOUmVZxC990Y=;
        b=Cyv4PGV7b5NluRkXps83afrn7wr3uIBvevThm0NhP+msXdIi9fYX+6Ik18OjBiteMg
         j6m+JWd/jlZ44aEUtdFzfMd9znr/kQX174KdtvjaRxO/WBifk2gR+shi3jpuEXZAccgm
         7+2nToWwcOO2EssZB9aQDuK9WdTQX44WcNkjZzH52SWFNcjRCrwiztrECldGpxQkf/PW
         moKiv3UyneNcHIvfoxBfIgJ4vuHzsHZrSSlpm/rwW/DPkX0fiCToVroa+lgHdqd+rveO
         MXvOzRYtV+s3EVt3dNUaAde1Gw+e9mvEJfu+F7EU6uxNO77H8nlpDDkHN5HyId7wCowJ
         izkA==
X-Gm-Message-State: AC+VfDyxBLky5fiddjZMfUsiqJBBX77yA9TIeiv6i1elHoiUEtHFfeu/
        bgilNbsM4Zx55rLYV6g7tCwwIOMmt4A=
X-Google-Smtp-Source: ACHHUZ6FJB7VFga7cyM68faKHMXRbtEdVfT4fxNTReyLLljKUOqZB9CEgcerYJJq4DdKDJvy4aF853AKImU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d611:0:b0:520:7943:3de4 with SMTP id
 q17-20020a63d611000000b0052079433de4mr785177pgg.4.1686096749257; Tue, 06 Jun
 2023 17:12:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 17:12:26 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607001226.1398889-1-seanjc@google.com>
Subject: [PATCH v3] KVM: selftests: Allow specify physical cpu list in demand
 paging test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

From: Peter Xu <peterx@redhat.com>

Mimic the dirty log test and allow the user to pin demand paging test
tasks to physical CPUs.

Put the help message into a general helper as suggested by Sean.

Signed-off-by: Peter Xu <peterx@redhat.com>
Link: https://lore.kernel.org/r/20230601184256.180413-1-peterx@redhat.com
[sean: rebase, tweak arg ordering, add "print" to helper, print program name]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/demand_paging_test.c  | 15 +++++++++++++--
 .../testing/selftests/kvm/dirty_log_perf_test.c | 12 +-----------
 .../selftests/kvm/include/kvm_util_base.h       |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c      | 17 +++++++++++++++++
 4 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 9c18686b4f63..09c116a82a84 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -208,10 +208,11 @@ static void help(char *name)
 {
 	puts("");
 	printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-d uffd_delay_usec]\n"
-	       "          [-b memory] [-s type] [-v vcpus] [-o]\n", name);
+	       "          [-b memory] [-s type] [-v vcpus] [-c cpu_list] [-o]\n", name);
 	guest_modes_help();
 	printf(" -u: use userfaultfd to handle vCPU page faults. Mode is a\n"
 	       "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
+	kvm_print_vcpu_pinning_help();
 	printf(" -d: add a delay in usec to the User Fault\n"
 	       "     FD handler to simulate demand paging\n"
 	       "     overheads. Ignored without -u.\n");
@@ -229,6 +230,7 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	const char *cpulist = NULL;
 	struct test_params p = {
 		.src_type = DEFAULT_VM_MEM_SRC,
 		.partition_vcpu_memory_access = true,
@@ -237,7 +239,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:o")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:u:d:b:s:v:c:o")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -264,6 +266,9 @@ int main(int argc, char *argv[])
 			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
+		case 'c':
+			cpulist = optarg;
+			break;
 		case 'o':
 			p.partition_vcpu_memory_access = false;
 			break;
@@ -279,6 +284,12 @@ int main(int argc, char *argv[])
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
index 416719e20518..d374dbcf9a53 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -332,17 +332,7 @@ static void help(char *name)
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
+	kvm_print_vcpu_pinning_help();
 	puts("");
 	exit(0);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a089c356f354..07732a157ccd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -733,6 +733,7 @@ static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
 void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
+void kvm_print_vcpu_pinning_help(void);
 void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 			    int nr_vcpus);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 298c4372fb1a..9741a7ff6380 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -494,6 +494,23 @@ static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
 	return pcpu;
 }
 
+void kvm_print_vcpu_pinning_help(void)
+{
+	const char *name = program_invocation_name;
+
+	printf(" -c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
+	       "     values (target pCPU), one for each vCPU, plus an optional\n"
+	       "     entry for the main application task (specified via entry\n"
+	       "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
+	       "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
+	       "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
+	       "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
+	       "         %s -v 3 -c 22,23,24,50\n\n"
+	       "     To leave the application task unpinned, drop the final entry:\n\n"
+	       "         %s -v 3 -c 22,23,24\n\n"
+	       "     (default: no pinning)\n", name, name);
+}
+
 void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
 			    int nr_vcpus)
 {

base-commit: dfa78a20cc879205b2c6239300dac09907ad3da1
-- 
2.41.0.162.gfafddb0af9-goog

