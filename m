Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7794345CBD
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 12:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCWLY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 07:24:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhCWLYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 07:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616498661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/jZjkAwRus4AIYciljvnfqSX7rPemkJkEMaBRK1wLNg=;
        b=e2/3xkpg8JUu+jRqv9gBpLwVMBaZc7fA0tstkLiZjY8g/dI0EcImFRhuJeOEMjMfQ17qt/
        G89mi5wq3qGq5IvrmsxK27qfwV149wFsBDzkoA6ctWFSwR0SCsXPgk8vGNPGDUpgyKpPd/
        Y3xCiB2uqDTqBtgjXwl3T9VVZUF5U4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-wI5iCr5dPni74WkZnJwayg-1; Tue, 23 Mar 2021 07:24:17 -0400
X-MC-Unique: wI5iCr5dPni74WkZnJwayg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B162800D53;
        Tue, 23 Mar 2021 11:24:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A17D2179B3;
        Tue, 23 Mar 2021 11:24:14 +0000 (UTC)
Date:   Tue, 23 Mar 2021 12:24:11 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 0/4] RFC: Minor arm/arm64 MMU fixes and
 checks
Message-ID: <20210323112411.6uwqex6x2py4va6d@kamzik.brq.redhat.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319122414.129364-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 12:24:10PM +0000, Nikos Nikoleris wrote:
> Prior to this set of fixes, the code in setup() which we call to
> initialize the system has a circular dependency. cpu_init()
> (eventually) calls spin_lock() and __mmu_enabled(). However, at this
> point, __mmu_enabled() may have undefined behavior as we haven't
> initialized the current thread_info (cpu field). Moving
> thread_info_init() above cpu_init() is not possible as it relies on
> mpidr_to_cpu() which won't return the right results before cpu_init().
> In addition, mem_init() also calls __mmu_enabled() and therefore
> suffers from the same problem. Right now, everything works as
> thread_info maps to memory which is implicitly initialized to 0 (cpu =
> 0) and makes the assumption that the cpu that runs setup() will be the
> first cpu in the DT.
> 
> This set of patches changes the code slightly and avoids this
> assumptions. In addition, it adds assertions to catch problems like
> the above. The current solution relies on the thread_info() of the cpu
> that setup() run to be initialized to zero (should we make it
> explicit?).
> 
> There are a couple of options I considered in addressing this issue
> which didn't seem satisfactory:
> 
> - Change the mmu_disabled_count global variable to mmu_enabled_count
>   to count the number of active mmu's and bypass __mmu_enabled() when
>   it's 0. This is a global variable and at the momement all write to
>   it are protected by a lock but it's rather fragile and could easily
>   cause issues in the future.
> - Explicitly initialize current_thread_info()->cpu = 0 in setup()
>   before anything else or make the first call of thread_info_init() a
>   special case and avoid looking up mpidr_to_cpu(). This way we can
>   move thread_info_init() to the top of setup(). If the CPU setup is
>   running on is not the first that appears in the DT then this
>   solution won't work.
> 
> Thanks,
> 
> Nikos
> 
> Nikos Nikoleris (4):
>   arm/arm64: Avoid calling cpumask_test_cpu for CPUs above nr_cpu
>   arm/arm64: Read system registers to get the state of the MMU
>   arm/arm64: Track whether thread_info has been initialized
>   arm/arm64: Add sanity checks to the cpumask API
> 
>  lib/arm/asm/cpumask.h     |  7 ++++++-
>  lib/arm/asm/mmu-api.h     |  7 +------
>  lib/arm/asm/processor.h   |  7 +++++++
>  lib/arm/asm/thread_info.h |  1 +
>  lib/arm64/asm/processor.h |  1 +
>  lib/arm/mmu.c             | 16 ++++++++--------
>  lib/arm/processor.c       | 10 ++++++++--
>  lib/arm64/processor.c     | 10 ++++++++--
>  8 files changed, 40 insertions(+), 19 deletions(-)
> 
> -- 
> 2.25.1
>

Hi Nikos,

So, I like patches 1, 2, and 4. I think 3 can be dropped with the
addition of "arm/arm64: Zero BSS and stack at startup". Would you
agree? I've applied all the updated commit messages and all of
Alexandru's suggestions to 2. Patch 2 now looks like the diff below.

Alexandru, are you satisfied with 1, 2, and 4? If so, please let me
know and I'll add r-b's for you before queuing.

Thanks,
drew


diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 3d04d0312622..05fc12b5afb8 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -5,12 +5,7 @@
 #include <stdbool.h>
 
 extern pgd_t *mmu_idmap;
-extern unsigned int mmu_disabled_cpu_count;
-extern bool __mmu_enabled(void);
-static inline bool mmu_enabled(void)
-{
-	return mmu_disabled_cpu_count == 0 || __mmu_enabled();
-}
+extern bool mmu_enabled(void);
 extern void mmu_mark_enabled(int cpu);
 extern void mmu_mark_disabled(int cpu);
 extern void mmu_enable(pgd_t *pgtable);
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index 273366d1fe1c..6b762ad060eb 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -67,11 +67,13 @@ extern int mpidr_to_cpu(uint64_t mpidr);
 	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & 0xff)
 
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
+extern bool __mmu_enabled(void);
 extern bool is_user(void);
 
 #define CNTVCT		__ACCESS_CP15_64(1, c14)
 #define CNTFRQ		__ACCESS_CP15(c14, 0, c0, 0)
 #define CTR		__ACCESS_CP15(c0, 0, c0, 1)
+#define SCTRL		__ACCESS_CP15(c1, 0, c0, 0)
 
 static inline u64 get_cntvct(void)
 {
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index a1862a55db8b..15eef007f256 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -24,13 +24,10 @@ extern unsigned long etext;
 pgd_t *mmu_idmap;
 
 /* CPU 0 starts with disabled MMU */
-static cpumask_t mmu_disabled_cpumask = { {1} };
-unsigned int mmu_disabled_cpu_count = 1;
+static cpumask_t mmu_enabled_cpumask;
 
-bool __mmu_enabled(void)
+bool mmu_enabled(void)
 {
-	int cpu = current_thread_info()->cpu;
-
 	/*
 	 * mmu_enabled is called from places that are guarding the
 	 * use of exclusive ops (which require the mmu to be enabled).
@@ -38,19 +35,22 @@ bool __mmu_enabled(void)
 	 * spinlock, atomic bitop, etc., otherwise we'll recurse.
 	 * [cpumask_]test_bit is safe though.
 	 */
-	return !cpumask_test_cpu(cpu, &mmu_disabled_cpumask);
+	if (is_user()) {
+		int cpu = current_thread_info()->cpu;
+		return cpumask_test_cpu(cpu, &mmu_enabled_cpumask);
+	}
+
+	return __mmu_enabled();
 }
 
 void mmu_mark_enabled(int cpu)
 {
-	if (cpumask_test_and_clear_cpu(cpu, &mmu_disabled_cpumask))
-		--mmu_disabled_cpu_count;
+	cpumask_set_cpu(cpu, &mmu_enabled_cpumask);
 }
 
 void mmu_mark_disabled(int cpu)
 {
-	if (!cpumask_test_and_set_cpu(cpu, &mmu_disabled_cpumask))
-		++mmu_disabled_cpu_count;
+	cpumask_clear_cpu(cpu, &mmu_enabled_cpumask);
 }
 
 extern void asm_mmu_enable(phys_addr_t pgtable);
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 773337e6d3b7..9d5759686b73 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -145,3 +145,8 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+bool __mmu_enabled(void)
+{
+	return read_sysreg(SCTRL) & CR_M;
+}
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 771b2d1e0c94..8e2037e1a43e 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -98,6 +98,7 @@ extern int mpidr_to_cpu(uint64_t mpidr);
 
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
 extern bool is_user(void);
+extern bool __mmu_enabled(void);
 
 static inline u64 get_cntvct(void)
 {
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 2a024e3f4e9d..ef558625e284 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -257,3 +257,8 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+bool __mmu_enabled(void)
+{
+	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
+}

