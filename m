Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0D052A2CB
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347342AbiEQNKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347232AbiEQNKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:10:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032003585F;
        Tue, 17 May 2022 06:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793036; x=1684329036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HfzEJ9vltPpB7NqHUUbPqOHhmBSeJ/AMSXfEoxvz9AU=;
  b=UHFXn3DhIbrEIBZhPTgswpg1ohkolHYG8z958ubTVL3txTHYQVPxOPDC
   cz3lpSX49vWXPXn3kQswsr35GD/eQLoBhfqN0q1S1idNWhYoUMcHYKbdW
   ri3nuMHvysazdWSuajzyCUj97iKvtvWSX+ARGLxnqUW0LKCBHTnuAtK7G
   L+VZrgiNoN5OFUDAOxdutpJXq80OkWp9BuN9HSqonbPJDTqkTHYSMNb3w
   xfYBUK+BDWqoF00EL9ChTyZnuTM5PK/C5r4fobkSVBHviZcrfT4MJ8sN3
   VP2Z3ynnwH+CffC99BPo9FoRIltGEuKclU06iCUMFihadnhoY2QziEXAJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="271300116"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="271300116"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844304"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:33 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 3/6] perf tools: Add guest_code support
Date:   Tue, 17 May 2022 16:10:08 +0300
Message-Id: <20220517131011.6117-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517131011.6117-1-adrian.hunter@intel.com>
References: <20220517131011.6117-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A common case for KVM test programs is that the test program acts as the
hypervisor, creating, running and destroying the virtual machine, and
providing the guest object code from its own object code. In this case,
the VM is not running an OS, but only the functions loaded into it by the
hypervisor test program, and conveniently, loaded at the same virtual
addresses.

Normally to resolve addresses, MMAP events are needed to map addresses
back to the object code and debug symbols for that object code.

Currently, there is no way to get such mapping information from guests
but, in the scenario described above, the guest has the same mappings
as the hypervisor, so support for that scenario can be achieved.

To support that, copy the host thread's maps to the guest thread's maps.
Note, we do not discover the guest until we encounter a guest event,
which works well because it is not until then that we know that the host
thread's maps have been set up.

Typically the main function for the guest object code is called
"guest_code", hence the name chosen for this feature. Note, that is just a
convention, the function could be named anything, and the tools do not
care.

This is primarily aimed at supporting Intel PT, or similar, where trace
data can be recorded for a guest. Refer to the final patch in this series
"perf intel-pt: Add guest_code support" for an example.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.c       |  7 ++-
 tools/perf/util/machine.c     | 87 +++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h     |  2 +
 tools/perf/util/session.c     |  7 +++
 tools/perf/util/symbol_conf.h |  3 +-
 5 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6439c888ae38..0476bb3a4188 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -683,9 +683,12 @@ static bool check_address_range(struct intlist *addr_list, int addr_range,
 int machine__resolve(struct machine *machine, struct addr_location *al,
 		     struct perf_sample *sample)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->pid,
-							sample->tid);
+	struct thread *thread;
 
+	if (symbol_conf.guest_code && !machine__is_host(machine))
+		thread = machine__findnew_guest_code(machine, sample->pid);
+	else
+		thread = machine__findnew_thread(machine, sample->pid, sample->tid);
 	if (thread == NULL)
 		return -1;
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e67b5a7670f3..009061852808 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -392,6 +392,93 @@ struct machine *machines__find_guest(struct machines *machines, pid_t pid)
 	return machine;
 }
 
+/*
+ * A common case for KVM test programs is that the test program acts as the
+ * hypervisor, creating, running and destroying the virtual machine, and
+ * providing the guest object code from its own object code. In this case,
+ * the VM is not running an OS, but only the functions loaded into it by the
+ * hypervisor test program, and conveniently, loaded at the same virtual
+ * addresses.
+ *
+ * Normally to resolve addresses, MMAP events are needed to map addresses
+ * back to the object code and debug symbols for that object code.
+ *
+ * Currently, there is no way to get such mapping information from guests
+ * but, in the scenario described above, the guest has the same mappings
+ * as the hypervisor, so support for that scenario can be achieved.
+ *
+ * To support that, copy the host thread's maps to the guest thread's maps.
+ * Note, we do not discover the guest until we encounter a guest event,
+ * which works well because it is not until then that we know that the host
+ * thread's maps have been set up.
+ *
+ * This function returns the guest thread. Apart from keeping the data
+ * structures sane, using a thread belonging to the guest machine, instead
+ * of the host thread, allows it to have its own comm (refer
+ * thread__set_guest_comm()).
+ */
+static struct thread *findnew_guest_code(struct machine *machine,
+					 struct machine *host_machine,
+					 pid_t pid)
+{
+	struct thread *host_thread;
+	struct thread *thread;
+	int err;
+
+	if (!machine)
+		return NULL;
+
+	thread = machine__findnew_thread(machine, -1, pid);
+	if (!thread)
+		return NULL;
+
+	/* Assume maps are set up if there are any */
+	if (thread->maps->nr_maps)
+		return thread;
+
+	host_thread = machine__find_thread(host_machine, -1, pid);
+	if (!host_thread)
+		goto out_err;
+
+	thread__set_guest_comm(thread, pid);
+
+	/*
+	 * Guest code can be found in hypervisor process at the same address
+	 * so copy host maps.
+	 */
+	err = maps__clone(thread, host_thread->maps);
+	thread__put(host_thread);
+	if (err)
+		goto out_err;
+
+	return thread;
+
+out_err:
+	thread__zput(thread);
+	return NULL;
+}
+
+struct thread *machines__findnew_guest_code(struct machines *machines, pid_t pid)
+{
+	struct machine *host_machine = machines__find(machines, HOST_KERNEL_ID);
+	struct machine *machine = machines__findnew(machines, pid);
+
+	return findnew_guest_code(machine, host_machine, pid);
+}
+
+struct thread *machine__findnew_guest_code(struct machine *machine, pid_t pid)
+{
+	struct machines *machines = machine->machines;
+	struct machine *host_machine;
+
+	if (!machines)
+		return NULL;
+
+	host_machine = machines__find(machines, HOST_KERNEL_ID);
+
+	return findnew_guest_code(machine, host_machine, pid);
+}
+
 void machines__process_guests(struct machines *machines,
 			      machine__process_t process, void *data)
 {
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 0d113771e8c8..01a5fca643b7 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -168,6 +168,8 @@ struct machine *machines__find_host(struct machines *machines);
 struct machine *machines__find(struct machines *machines, pid_t pid);
 struct machine *machines__findnew(struct machines *machines, pid_t pid);
 struct machine *machines__find_guest(struct machines *machines, pid_t pid);
+struct thread *machines__findnew_guest_code(struct machines *machines, pid_t pid);
+struct thread *machine__findnew_guest_code(struct machine *machine, pid_t pid);
 
 void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size);
 void machines__set_comm_exec(struct machines *machines, bool comm_exec);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f9a320694b85..6577e1227bd5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1410,6 +1410,13 @@ static struct machine *machines__find_for_cpumode(struct machines *machines,
 		else
 			pid = sample->pid;
 
+		/*
+		 * Guest code machine is created as needed and does not use
+		 * DEFAULT_GUEST_KERNEL_ID.
+		 */
+		if (symbol_conf.guest_code)
+			return machines__findnew(machines, pid);
+
 		return machines__find_guest(machines, pid);
 	}
 
diff --git a/tools/perf/util/symbol_conf.h b/tools/perf/util/symbol_conf.h
index a70b3ec09dac..bc3d046fbb63 100644
--- a/tools/perf/util/symbol_conf.h
+++ b/tools/perf/util/symbol_conf.h
@@ -43,7 +43,8 @@ struct symbol_conf {
 			report_individual_block,
 			inline_name,
 			disable_add2line_warn,
-			buildid_mmap2;
+			buildid_mmap2,
+			guest_code;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
2.25.1

