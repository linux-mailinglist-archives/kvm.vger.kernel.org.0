Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF3C60E4F8
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiJZPoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 11:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiJZPob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 11:44:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719BBFBCCF
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 08:44:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q71so15198429pgq.8
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 08:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U9wY9lvgInKo/WrSw8ypKy3xK6f/RkOvyVDAnAK0+i4=;
        b=ptsF/Q9yl4ERSWU6r8zn0gB8Y7cVyejUKQ3JViZR90yB4kv1HAXb4I0p7K11IHAqyL
         qOKhPaPs8LwnB/+qGzrUyUb52tlBjV1dI69ymUbARlTZWlU2NcNP1GP6jaOD9grmZumg
         ea/kDG2Kj4vCKm8T1/F5dB+koVarOKnvWPMLPd/kZYLUzMZfGJWIHrmSLnWHDABA0g90
         w+hDWyYPRh6ifVD3FKvRwcc+j6aNKT71RxOTpWmGUwJA/IuWbf7T/8xbawZ7mYFAEqKu
         cmMUFbP4PXuHWqAZk7RC+dqa9IEkhrUNi7fyJxCNgA2wakrkj9tk4SQ3YZNmLBG/+8Lr
         RGTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9wY9lvgInKo/WrSw8ypKy3xK6f/RkOvyVDAnAK0+i4=;
        b=jEcpbnQwmgJsgya7XuRnTjaBGEksTKdAb6VjiVJ7RZRqtFb/qWynJf74vDcZwwUXHk
         HQITKSlXQQ7oD9dPvH7BlTlq98vhgmM0Ztkd9W8ByqPgnnVIKsDiLBTgNlqB+qtHfWlc
         d4EOVV9dbvr+miaGIpoibdhtJkZ88tzERFOLSXRbnptshVh46zLO9nsY00TuAowak54x
         M6ibFJ1AU2lvDT3O8qGWHvCgh3LlR7OUkwzRccMXWfzulatcTYU1k8PxD0lQKyPy3ftA
         Z0HxkB0AgnqMNEtBHPxue+f0M0nl1G/Qp429Ce2wpibq0kxUSD+CJiDvYItXP4NMV/uD
         99qw==
X-Gm-Message-State: ACrzQf1ER9mtrE+i48aJuWd8juqOKBz4Sn94wwDc9ZAC70zdQjcPgEhQ
        lvjqM7+pJ7pFn3nnoARvQyQ3EXLD7cOYKw==
X-Google-Smtp-Source: AMsMyM40hJjFGssxSMIkSkmzpRSBO6vjvUKmzM25hBUKnK393pVTsuNOXatA5iYRaBZK4IsDue2pzw==
X-Received: by 2002:a65:5b0b:0:b0:462:da7a:1ded with SMTP id y11-20020a655b0b000000b00462da7a1dedmr21055408pgq.605.1666799063604;
        Wed, 26 Oct 2022 08:44:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b00178a9b193cfsm3071240plg.140.2022.10.26.08.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 08:44:23 -0700 (PDT)
Date:   Wed, 26 Oct 2022 15:44:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Message-ID: <Y1lV0l4uDjXdKpkL@google.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-6-vipinsh@google.com>
 <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26, 2022, Wang, Wei W wrote:
> On Saturday, October 22, 2022 5:18 AM, Vipin Sharma wrote:
> > +static void pin_this_task_to_pcpu(uint32_t pcpu) {
> > +	cpu_set_t mask;
> > +	int r;
> > +
> > +	CPU_ZERO(&mask);
> > +	CPU_SET(pcpu, &mask);
> > +	r = sched_setaffinity(0, sizeof(mask), &mask);
> > +	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu);
> > +}
> > +
> >  static void *vcpu_thread_main(void *data)  {
> > +	struct perf_test_vcpu_args *vcpu_args;
> >  	struct vcpu_thread *vcpu = data;
> > 
> > +	vcpu_args = &perf_test_args.vcpu_args[vcpu->vcpu_idx];
> > +
> > +	if (perf_test_args.pin_vcpus)
> > +		pin_this_task_to_pcpu(vcpu_args->pcpu);
> > +
> 
> I think it would be better to do the thread pinning at the time when the
> thread is created by providing a pthread_attr_t attr, e.g. :
> 
> pthread_attr_t attr;
> 
> CPU_SET(vcpu->pcpu, &cpu_set);
> pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpu_set);
> pthread_create(thread, attr,...);
> 
> Also, pinning a vCPU thread to a pCPU is a general operation
> which other users would need. I think we could make it more general and
> put it to kvm_util.

We could, but it taking advantage of the pinning functionality would require
plumbing a command line option for every test, or alternatively adding partial
command line parsing with a "hidden" global struct to kvm_selftest_init(), though
handling error checking for a truly generic case would be a mess.  Either way,
extending pinning to other tests would require non-trivial effort, and can be
done on top of this series.

That said, it's also trival to extract the pinning helpers to common code, and I
can't think of any reason not to do that straightaway.

Vipin, any objection to squashing the below diff with patch 5?

>  e.g. adding it to the helper function that I'm trying to create

If we go this route in the future, we'd need to add a worker trampoline as the
pinning needs to happen in the worker task itself to guarantee that the pinning
takes effect before the worker does anything useful.  That should be very doable.

I do like the idea of extending __vcpu_thread_create(), but we can do that once
__vcpu_thread_create() lands to avoid further delaying this series.

---
 .../selftests/kvm/dirty_log_perf_test.c       |  7 ++-
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 .../selftests/kvm/include/perf_test_util.h    |  8 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 54 ++++++++++++++++++
 .../selftests/kvm/lib/perf_test_util.c        | 57 +------------------
 5 files changed, 68 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 35504b36b126..a82fc51d57ca 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -471,8 +471,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (pcpu_list)
-		perf_test_setup_pinning(pcpu_list, nr_vcpus);
+	if (pcpu_list) {
+		kvm_parse_vcpu_pinning(pcpu_list, perf_test_args.vcpu_to_pcpu,
+				       nr_vcpus);
+		perf_test_args.pin_vcpus = true;
+	}
 
 	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..3bf2333ef95d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -688,6 +688,10 @@ static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
+void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
+void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+			    int nr_vcpus);
+
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
 unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index ccfe3b9dc6bd..85320e0640fc 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -27,8 +27,6 @@ struct perf_test_vcpu_args {
 	/* Only used by the host userspace part of the vCPU thread */
 	struct kvm_vcpu *vcpu;
 	int vcpu_idx;
-	/* The pCPU to which this vCPU is pinned. Only valid if pin_vcpus is true. */
-	uint32_t pcpu;
 };
 
 struct perf_test_args {
@@ -43,8 +41,12 @@ struct perf_test_args {
 	bool nested;
 	/* True if all vCPUs are pinned to pCPUs */
 	bool pin_vcpus;
+	/* The vCPU=>pCPU pinning map. Only valid if pin_vcpus is true. */
+	uint32_t vcpu_to_pcpu[KVM_MAX_VCPUS];
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
+
+
 };
 
 extern struct perf_test_args perf_test_args;
@@ -64,6 +66,4 @@ void perf_test_guest_code(uint32_t vcpu_id);
 uint64_t perf_test_nested_pages(int nr_vcpus);
 void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
-void perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus);
-
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..8292af9d7660 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -11,6 +11,7 @@
 #include "processor.h"
 
 #include <assert.h>
+#include <sched.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -443,6 +444,59 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 	return vm_vcpu_recreate(vm, 0);
 }
 
+void kvm_pin_this_task_to_pcpu(uint32_t pcpu)
+{
+	cpu_set_t mask;
+	int r;
+
+	CPU_ZERO(&mask);
+	CPU_SET(pcpu, &mask);
+	r = sched_setaffinity(0, sizeof(mask), &mask);
+	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu);
+}
+
+static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
+{
+	uint32_t pcpu = atoi_non_negative(cpu_str);
+
+	TEST_ASSERT(CPU_ISSET(pcpu, allowed_mask),
+		    "Not allowed to run on pCPU '%d', check cgroups?\n", pcpu);
+	return pcpu;
+}
+
+void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+			    int nr_vcpus)
+{
+	cpu_set_t allowed_mask;
+	char *cpu, *cpu_list;
+	char delim[2] = ",";
+	int i, r;
+
+	cpu_list = strdup(pcpus_string);
+	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
+
+	r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
+	TEST_ASSERT(!r, "sched_getaffinity() failed");
+
+	cpu = strtok(cpu_list, delim);
+
+	/* 1. Get all pcpus for vcpus. */
+	for (i = 0; i < nr_vcpus; i++) {
+		TEST_ASSERT(cpu, "pCPU not provided for vCPU '%d'\n", i);
+		vcpu_to_pcpu[i] = parse_pcpu(cpu, &allowed_mask);
+		cpu = strtok(NULL, delim);
+	}
+
+	/* 2. Check if the main worker needs to be pinned. */
+	if (cpu) {
+		kvm_pin_this_task_to_pcpu(parse_pcpu(cpu, &allowed_mask));
+		cpu = strtok(NULL, delim);
+	}
+
+	TEST_ASSERT(!cpu, "pCPU list contains trailing garbage characters '%s'", cpu);
+	free(cpu_list);
+}
+
 /*
  * Userspace Memory Region Find
  *
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 520d1f896d61..1d133007d7de 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -5,7 +5,6 @@
 #define _GNU_SOURCE
 
 #include <inttypes.h>
-#include <sched.h>
 
 #include "kvm_util.h"
 #include "perf_test_util.h"
@@ -243,17 +242,6 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 	exit(KSFT_SKIP);
 }
 
-static void pin_this_task_to_pcpu(uint32_t pcpu)
-{
-	cpu_set_t mask;
-	int r;
-
-	CPU_ZERO(&mask);
-	CPU_SET(pcpu, &mask);
-	r = sched_setaffinity(0, sizeof(mask), &mask);
-	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu);
-}
-
 static void *vcpu_thread_main(void *data)
 {
 	struct perf_test_vcpu_args *vcpu_args;
@@ -262,7 +250,7 @@ static void *vcpu_thread_main(void *data)
 	vcpu_args = &perf_test_args.vcpu_args[vcpu->vcpu_idx];
 
 	if (perf_test_args.pin_vcpus)
-		pin_this_task_to_pcpu(vcpu_args->pcpu);
+		kvm_pin_this_task_to_pcpu(perf_test_args.vcpu_to_pcpu[vcpu->vcpu_idx]);
 
 	WRITE_ONCE(vcpu->running, true);
 
@@ -312,46 +300,3 @@ void perf_test_join_vcpu_threads(int nr_vcpus)
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_join(vcpu_threads[i].thread, NULL);
 }
-
-static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
-{
-	uint32_t pcpu = atoi_non_negative(cpu_str);
-
-	TEST_ASSERT(CPU_ISSET(pcpu, allowed_mask),
-		    "Not allowed to run on pCPU '%d', check cgroups?\n", pcpu);
-	return pcpu;
-}
-
-void perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus)
-{
-	cpu_set_t allowed_mask;
-	char *cpu, *cpu_list;
-	char delim[2] = ",";
-	int i, r;
-
-	cpu_list = strdup(pcpus_string);
-	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
-
-	r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
-	TEST_ASSERT(!r, "sched_getaffinity() failed");
-
-	cpu = strtok(cpu_list, delim);
-
-	/* 1. Get all pcpus for vcpus. */
-	for (i = 0; i < nr_vcpus; i++) {
-		TEST_ASSERT(cpu, "pCPU not provided for vCPU '%d'\n", i);
-		perf_test_args.vcpu_args[i].pcpu = parse_pcpu(cpu, &allowed_mask);
-		cpu = strtok(NULL, delim);
-	}
-
-	perf_test_args.pin_vcpus = true;
-
-	/* 2. Check if the main worker needs to be pinned. */
-	if (cpu) {
-		pin_this_task_to_pcpu(parse_pcpu(cpu, &allowed_mask));
-		cpu = strtok(NULL, delim);
-	}
-
-	TEST_ASSERT(!cpu, "pCPU list contains trailing garbage characters '%s'", cpu);
-	free(cpu_list);
-}

base-commit: 076ac4ca97225d6b8698a9b066153b556e97be7c
-- 

