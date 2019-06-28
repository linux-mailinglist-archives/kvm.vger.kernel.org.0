Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63E5976C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfF1J0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:26:43 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:28000 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfF1J0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561714000; x=1593250000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=BSa/2bhUhVpoXPd1h3Z1Mf3cTbNmLvLzCJ1cgVchQhg=;
  b=MWPNNTxtHkPlPD+3ZlEtEAhEl3BXHd0iqB2w6tWV2L+cv9YVrkQGiwi/
   3up8o4FCamSB6D7x5t6Q2Hyr3YGU2U8Hmw3yELyWAVdSo1eZPkNLojz32
   XywEv4umpmjzO2d27DHta1m/TtB+L0FV1k2qCLljnFvzLWDoCNQc6akck
   8=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="813262324"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Jun 2019 09:26:35 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id A8614A1D54;
        Fri, 28 Jun 2019 09:26:34 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:33 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 09:26:29 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v4 1/5] Build target for emulate.o as a userspace binary
Date:   Fri, 28 Jun 2019 11:26:17 +0200
Message-ID: <20190628092621.17823-2-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628092621.17823-1-samcacc@amazon.de>
References: <20190628092621.17823-1-samcacc@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit contains the minimal set of functionality to build
afl-harness around arch/x86/emulate.c which allows exercising code
in that source file, like x86_emulate_insn.

---

v1 -> v2:
 - Moved -O0 to ifdef DEBUG
 - Building with ASAN by default

v2 -> v3:
 - Removed a workaround for printf smashing the stack when compiled
   with -mcmodel=kernel, and stopped compiling with -mcmodel=kernel
 - Added a null check for malloc's return value
 - Moved multiple macros from emulator_ops.c into emulator_ops.h as
   static inline functions.

v3 -> v4:
 - Added unimplemented_op macro to stub out emulator ops
 - envvar FAIL_ON_UNIMPLEMENTED_OP decides whether AFL treats this as
   a crash
 - Updated README to include core dump setup

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/Makefile                  |   9 ++
 tools/fuzz/x86ie/.gitignore     |   2 +
 tools/fuzz/x86ie/Makefile       |  51 +++++++++++
 tools/fuzz/x86ie/README.md      |  21 +++++
 tools/fuzz/x86ie/afl-harness.c  | 151 ++++++++++++++++++++++++++++++++
 tools/fuzz/x86ie/common.h       |  87 ++++++++++++++++++
 tools/fuzz/x86ie/emulator_ops.c |  58 ++++++++++++
 tools/fuzz/x86ie/emulator_ops.h | 134 ++++++++++++++++++++++++++++
 tools/fuzz/x86ie/stubs.c        |  59 +++++++++++++
 tools/fuzz/x86ie/stubs.h        |  52 +++++++++++
 10 files changed, 624 insertions(+)
 create mode 100644 tools/fuzz/x86ie/.gitignore
 create mode 100644 tools/fuzz/x86ie/Makefile
 create mode 100644 tools/fuzz/x86ie/README.md
 create mode 100644 tools/fuzz/x86ie/afl-harness.c
 create mode 100644 tools/fuzz/x86ie/common.h
 create mode 100644 tools/fuzz/x86ie/emulator_ops.c
 create mode 100644 tools/fuzz/x86ie/emulator_ops.h
 create mode 100644 tools/fuzz/x86ie/stubs.c
 create mode 100644 tools/fuzz/x86ie/stubs.h

diff --git a/tools/Makefile b/tools/Makefile
index 3dfd72ae6c1a..b55990c19afd 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -94,6 +94,12 @@ freefall: FORCE
 kvm_stat: FORCE
 	$(call descend,kvm/$@)
 
+fuzz: FORCE
+	$(call descend,fuzz/x86ie)
+
+fuzz_deps: FORCE
+	$(call descend,fuzz/x86ie,fuzz_deps)
+
 all: acpi cgroup cpupower gpio hv firewire liblockdep \
 		perf selftests spi turbostat usb \
 		virtio vm bpf x86_energy_perf_policy \
@@ -171,6 +177,9 @@ tmon_clean:
 freefall_clean:
 	$(call descend,laptop/freefall,clean)
 
+fuzz_clean:
+	$(call descend,fuzz/x86ie,clean)
+
 build_clean:
 	$(call descend,build,clean)
 
diff --git a/tools/fuzz/x86ie/.gitignore b/tools/fuzz/x86ie/.gitignore
new file mode 100644
index 000000000000..7d44f7ce266e
--- /dev/null
+++ b/tools/fuzz/x86ie/.gitignore
@@ -0,0 +1,2 @@
+*.o
+*-harness
diff --git a/tools/fuzz/x86ie/Makefile b/tools/fuzz/x86ie/Makefile
new file mode 100644
index 000000000000..07a784519100
--- /dev/null
+++ b/tools/fuzz/x86ie/Makefile
@@ -0,0 +1,51 @@
+ROOT_DIR=../../..
+include ../../scripts/Makefile.include
+
+.DEFAULT_GOAL := all
+
+INCLUDES := $(patsubst -I./%,-I./$(ROOT_DIR)/%, $(LINUXINCLUDE))
+INCLUDES := $(patsubst ./include/%,./$(ROOT_DIR)/include/%, $(INCLUDES))
+INCLUDES += -include ./$(ROOT_DIR)/include/linux/compiler_types.h
+
+$(ROOT_DIR)/.config:
+	make -C $(ROOT_DIR) menuconfig
+	sed -i -r 's/^#? *CONFIG_KVM(.*)=.*/CONFIG_KVM\1=y/' $(ROOT_DIR)/.config
+
+
+KBUILD_CFLAGS += -fsanitize=address
+BAD_FLAGS := -mcmodel=kernel # Causes all kinds of errors in a userspace bin
+BAD_FLAGS += -mpreferred-stack-boundary=3 # Similar to ^, breaks ubuntu 16 too
+BAD_FLAGS += -mno-sse # stdlibs use sse, would like to have it
+
+ifdef DEBUG
+KBUILD_CFLAGS += -DDEBUG
+KBUILD_CFLAGS += -O0
+BAD_FLAGS += -O3
+BAD_FLAGS += -O2
+BAD_FLAGS += -O1
+endif
+
+KBUILD_CFLAGS := $(filter-out $(BAD_FLAGS),$(KBUILD_CFLAGS))
+
+ifdef FAIL_ON_UNIMPLEMENTED_OP
+KBUILD_CFLAGS += -DFAIL_ON_UNIMPLEMENTED_OP
+endif
+
+KERNEL_OBJS := arch/x86/kvm/emulate.o \
+		arch/x86/lib/retpoline.o \
+		lib/find_bit.o
+KERNEL_OBJS := $(patsubst %,$(ROOT_DIR)/%, $(KERNEL_OBJS))
+
+DEPS := emulator_ops.h stubs.h common.h
+%.o: %.c $(DEPS)
+	$(CC) $(KBUILD_CFLAGS) $(INCLUDES) -g -c -o $@ $<
+
+LOCAL_OBJS := emulator_ops.o stubs.o
+afl-harness: afl-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
+	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
+
+all: afl-harness
+
+.PHONY: clean
+clean:
+	$(RM) -r *.o afl-harness
diff --git a/tools/fuzz/x86ie/README.md b/tools/fuzz/x86ie/README.md
new file mode 100644
index 000000000000..d5971f184b18
--- /dev/null
+++ b/tools/fuzz/x86ie/README.md
@@ -0,0 +1,21 @@
+# Building
+
+Dependencies on Ubuntu are:
+make gcc wget screen build-essential libssh-dev flex bison libelf-dev bc
+
+From the root of linux, run:
+
+0. If intending to use AFL:
+   - Install, build, and export AFLPATH for AFL via:
+     `source ./tools/fuzz/x86ie/scripts/install_afl.sh`
+   - Set linux to create core dumps:
+     `sudo bash -c "echo core >/proc/sys/kernel/core_pattern"`
+1. Build the harness via `./tools/fuzz/x86ie/scripts/build.sh`
+   - Set the envvar CC with your desired compiler (afl-gcc if fuzzing with AFL) a la:
+     `CC=$AFLPATH/afl-gcc ./tools/fuzz/x86ie/scripts/build.sh`
+2. Run afl via `./tools/fuzz/x86ie/scripts/run.sh` which requires $AFLPATH set.
+   You must have built the harness with `afl-gcc` to fuzz with afl.
+   - Optionally, set `FUZZDIR` to specify a location other than the default
+    `./fuzz` to store fuzzer status.  Placing this in memory like `/dev/shm`
+    is advised as AFL can be IO bound.
+
diff --git a/tools/fuzz/x86ie/afl-harness.c b/tools/fuzz/x86ie/afl-harness.c
new file mode 100644
index 000000000000..a3eeab0cfc90
--- /dev/null
+++ b/tools/fuzz/x86ie/afl-harness.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * x86 Instruction Emulation Fuzzing Wrapper
+ *
+ * Authors:
+ *   Sam Caccavale   <samcacc@amazon.de>
+ *
+ * Supporting code from xen:
+ *  xen/tools/fuzz/x86_instruction_emulation/afl-harness.c
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * From: xen/master f68f35fd2016e36ee30f8b3e7dfd46c554407ac1
+ */
+
+#include <assert.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include "emulator_ops.h"
+
+/* Arbitrary, but limiting fuzz input size is important. */
+#define MAX_INPUT_SIZE 4096
+#define INSTRUCTION_BYTES (MAX_INPUT_SIZE - MIN_INPUT_SIZE)
+
+int main(int argc, char **argv)
+{
+	size_t size;
+	FILE *fp = NULL;
+	int max, count;
+	struct state *state;
+
+	setbuf(stdin, NULL);
+	setbuf(stdout, NULL);
+
+	while (1) {
+		enum { OPT_INPUT_SIZE,
+		};
+		static const struct option lopts[] = {
+			{ "input-size", no_argument, NULL, OPT_INPUT_SIZE },
+			{ 0, 0, 0, 0 }
+		};
+		int c = getopt_long_only(argc, argv, "", lopts, NULL);
+
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case OPT_INPUT_SIZE:
+			printf("Min: %lu\n", MIN_INPUT_SIZE);
+			printf("Max: %u\n", MAX_INPUT_SIZE);
+			exit(0);
+			break;
+
+		case '?':
+			printf("Usage: %s $FILE [$FILE...] | [--input-size]\n",
+			       argv[0]);
+			exit(-1);
+			break;
+
+		default:
+			printf("Bad getopt return %d (%c)\n", c, c);
+			exit(-1);
+			break;
+		}
+	}
+
+	max = argc - optind;
+
+	if (!max) { /* No positional parameters.  Use stdin. */
+		max = 1;
+		fp = stdin;
+	}
+
+	state = create_emulator();
+	state->data = malloc(INSTRUCTION_BYTES);
+	if (!state->data) {
+		printf("Malloc failed.\n");
+		return -1;
+	}
+
+#ifdef __AFL_HAVE_MANUAL_CONTROL
+	__AFL_INIT();
+
+	/*
+	 * This is the number of times AFL's forkserver should reuse a
+	 * process to fuzz the target.  1000 is the recommended starting
+	 * point.  Future tweaking may or may not yeild better results.
+	 */
+	for (count = 0; __AFL_LOOP(1000);)
+#else
+	for (count = 0; count < max; count++)
+#endif
+	{
+		if (fp != stdin) { /* If not stdin, open the provided file. */
+			printf("Opening file %s\n", argv[optind + count]);
+			fp = fopen(argv[optind + count], "rb");
+			if (fp == NULL) {
+				perror("fopen");
+				exit(-1);
+			}
+		}
+#ifdef __AFL_HAVE_MANUAL_CONTROL
+		else {
+			/*
+			 * This will ensure we're dealing with a clean stream
+			 * state after the afl-fuzz process messes with the
+			 * open file handle.
+			 */
+			fseek(fp, 0, SEEK_SET);
+		}
+#endif
+		size = fread(state, 1, MIN_INPUT_SIZE, fp);
+		if (size != MIN_INPUT_SIZE) {
+			printf("Input does not populate state\n");
+			if (max == 1)
+				exit(-1);
+		}
+
+		size = fread(state->data, 1, INSTRUCTION_BYTES, fp);
+		state->data_available = size;
+
+		if (ferror(fp)) {
+			perror("fread");
+			exit(-1);
+		}
+
+		/* Only run the test if the input file was < than INPUT_SIZE */
+		if (feof(fp)) {
+			initialize_emulator(state);
+			emulate_until_complete(state);
+		} else {
+			printf("Input too large\n");
+			/* Don't exit if we're doing batch processing */
+			if (max == 1)
+				exit(-1);
+		}
+
+		if (fp != stdin) {
+			fclose(fp);
+			fp = NULL;
+		}
+	}
+
+	free(state->data);
+	free_emulator(state);
+	return 0;
+}
diff --git a/tools/fuzz/x86ie/common.h b/tools/fuzz/x86ie/common.h
new file mode 100644
index 000000000000..9aec2bea3d50
--- /dev/null
+++ b/tools/fuzz/x86ie/common.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <stdint.h>
+
+#define PRIx64 "llx"
+#define MSR_INDEX_MAX 16
+
+#ifdef DEBUG
+#define DEBUG_PRINT 1
+#else
+#define DEBUG_PRINT 0
+#endif
+
+#define debug(...)							\
+	do {								\
+		if (DEBUG_PRINT)					\
+			fprintf(stderr, __VA_ARGS__);			\
+	} while (0)
+
+enum x86_segment {
+	/* General purpose. */
+	x86_seg_es,
+	x86_seg_cs,
+	x86_seg_ss,
+	x86_seg_ds,
+	x86_seg_fs,
+	x86_seg_gs,
+	/* System: Valid to use for implicit table references. */
+	x86_seg_tr,
+	x86_seg_ldtr,
+	x86_seg_gdtr,
+	x86_seg_idtr,
+	/* No Segment: For accesses which are already linear. */
+	x86_seg_none
+};
+
+#define NR_SEG x86_seg_none
+
+struct segment_register {
+	uint16_t sel;
+	union {
+		uint16_t attr;
+		struct {
+			uint16_t type : 4;
+			uint16_t s : 1;
+			uint16_t dpl : 2;
+			uint16_t p : 1;
+			uint16_t avl : 1;
+			uint16_t l : 1;
+			uint16_t db : 1;
+			uint16_t g : 1;
+			uint16_t pad : 4;
+		};
+	};
+	uint32_t limit;
+	uint64_t base;
+};
+
+enum user_regs {
+	REGS_RAX,
+	REGS_RCX,
+	REGS_RDX,
+	REGS_RBX,
+	REGS_RSP,
+	REGS_RBP,
+	REGS_RSI,
+	REGS_RDI,
+	REGS_R8,
+	REGS_R9,
+	REGS_R10,
+	REGS_R11,
+	REGS_R12,
+	REGS_R13,
+	REGS_R14,
+	REGS_R15,
+	NR_REGS
+};
+#define NR_VCPU_REGS NR_REGS
+
+static inline void print_n_bytes(unsigned char *bytes, size_t n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		fprintf(stderr, " %02x", bytes[i]);
+	fprintf(stderr, "\n");
+}
diff --git a/tools/fuzz/x86ie/emulator_ops.c b/tools/fuzz/x86ie/emulator_ops.c
new file mode 100644
index 000000000000..55ae4e8fbd96
--- /dev/null
+++ b/tools/fuzz/x86ie/emulator_ops.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * x86 Instruction Emulation Fuzzing Wrapper
+ *
+ * Authors:
+ *   Sam Caccavale   <samcacc@amazon.de>
+ *
+ * Supporting code from xen:
+ *  xen/tools/fuzz/x86_instruction_emulation/fuzz_emul.c
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * From: xen/master f68f35fd2016e36ee30f8b3e7dfd46c554407ac1
+ */
+
+#include <string.h>
+#include <stdio.h>
+#include <assert.h>
+#include <stdlib.h>
+
+#include "stubs.h"
+#include "emulator_ops.h"
+
+#include <linux/compiler_attributes.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/processor-flags.h>
+#include <asm/user_64.h>
+#include <asm/kvm.h>
+
+void initialize_emulator(struct state *state)
+{
+}
+
+int step_emulator(struct state *state)
+{
+	return 0;
+}
+
+int emulate_until_complete(struct state *state)
+{
+	return 0;
+}
+
+struct state *create_emulator(void)
+{
+	struct state *state = malloc(sizeof(struct state));
+	return state;
+}
+
+void reset_emulator(struct state *state)
+{
+}
+
+void free_emulator(struct state *state)
+{
+}
diff --git a/tools/fuzz/x86ie/emulator_ops.h b/tools/fuzz/x86ie/emulator_ops.h
new file mode 100644
index 000000000000..3105374a09e2
--- /dev/null
+++ b/tools/fuzz/x86ie/emulator_ops.h
@@ -0,0 +1,134 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef EMULATOR_OPS_H
+#define EMULATOR_OPS_H
+
+#include "common.h"
+#include "stubs.h"
+#include <asm/kvm_emulate.h>
+
+
+#ifdef FAIL_ON_UNIMPLEMENTED_OP
+#define FAIL_ON_UNIMPLEMENTED_OP 1
+#else
+#define FAIL_ON_UNIMPLEMENTED_OP 0
+#endif
+
+#define unimplemented_op()						\
+	do {								\
+		if (FAIL_ON_UNIMPLEMENTED_OP | DEBUG_PRINT)		\
+			fprintf(stderr, "Unimplemented op: %s\n", __func__);\
+		exit(FAIL_ON_UNIMPLEMENTED_OP);				\
+	} while (0)
+
+struct vcpu {
+	unsigned long cr[5];
+	uint64_t msr[MSR_INDEX_MAX];
+	uint64_t regs[NR_REGS];
+	uint64_t rflags;
+	struct segment_register segments[NR_SEG];
+};
+
+/*
+ * Internal state of the emulate harness.  Calculated initially from the input
+ * corpus, and later mutated by the emulation callbacks.
+ */
+struct state {
+	/* Bitmask which enables/disables hooks. */
+	unsigned long options;
+
+	/* Internal representation of emulated CPU. */
+	struct vcpu vcpu;
+
+	/*
+	 * Input bytes are consumed at s.data[eip + s.other_bytes_consumed]
+	 * while eip + size_requested + other_bytes_consumed < data_available
+	 *
+	 * emul_fetch consumes bytes for use as x86 instructions as eip grows
+	 *
+	 * get_bytes_and_increment consumes bytes and increments
+	 * other_bytes_consumed.  These bytes can be used as return values for
+	 * memory reads, random chances to fail, or other purposes.
+	 *
+	 *  Only these two functions should be used to access this data.
+	 *
+	 * This causes .data to be an interspliced source of instructions and
+	 * other data.  Xen's instruction emulation does this to provide
+	 * deterministic randomness on fuzz runs at the cost of complexity to
+	 * crash output.
+	 *
+	 * Other alternatives (two separate streams, getting ins bytes from
+	 * low, and random bytes from high, etc) yield byte streams which may
+	 * not bear an as close correlation with AFL's input.  This was chosen
+	 * since the only drawback to this approach is remedied by simple
+	 * bookkeeping of instruction bytes when debugging crashes.  This is
+	 * enabled by the TODO flag.
+	 */
+	unsigned char *data;
+
+	/* Real amount of data backing state->data[]. */
+	size_t data_available;
+
+	/*
+	 * Amount of bytes consumed for purposes other than instructions.
+	 * E.G. whether a memory access should fault.
+	 */
+	size_t bytes_consumed;
+
+	/* Emulation context */
+	struct x86_emulate_ctxt ctxt;
+};
+
+#define MIN_INPUT_SIZE (offsetof(struct state, data))
+
+#define container_of(ptr, type, member)					\
+	({								\
+		const typeof(((type *)0)->member) * __mptr = (ptr);	\
+		(type *)((char *)__mptr - offsetof(type, member));	\
+	})
+
+#define get_state(h) container_of(h, struct state, ctxt)
+
+static inline int number_of_gprs(struct x86_emulate_ctxt *c)
+{
+	return (c->mode == X86EMUL_MODE_PROT64 ? 16 : 8);
+}
+
+/*
+ * Allocates space for, and creates a `struct state`.  The user should set
+ * state->data to their instruction stream and do any modification of the
+ * state-vpcu if desired.
+ */
+extern struct state *create_emulator(void);
+
+/*
+ * memset's all fields of state except data and data_available.
+ */
+extern void reset_emulator(struct state *state);
+
+/*
+ * free_emulator does not free the state->data member, the user should free
+ * it before freeing the emulator.  The alternative implementation either
+ * restrains data to a fixed size or has the user pass in a (pointer, size)
+ * pair which would have to be copied.  Copying this would be slow to fuzz.
+ */
+extern void free_emulator(struct state *state);
+
+/*
+ * Uses the state->option field to disable certain functionality and
+ * initializes the state->ctxt to a valid state.  This is optional if
+ * intentionally testing the emulator in an invalid state.
+ */
+extern void initialize_emulator(struct state *state);
+
+/*
+ * Advances the emulator one instruction and handles any exceptions.
+ */
+extern int step_emulator(struct state *state);
+
+/*
+ * Steps the emulator until no instructions remain or something fails.
+ */
+extern int emulate_until_complete(struct state *state);
+
+#endif /* ifdef EMULATOR_OPS_H */
diff --git a/tools/fuzz/x86ie/stubs.c b/tools/fuzz/x86ie/stubs.c
new file mode 100644
index 000000000000..3255b436561b
--- /dev/null
+++ b/tools/fuzz/x86ie/stubs.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * These functions/symbols are required to build emulate.o but belong in
+ * linux tree files with include many other headers/unnecessary symbols
+ * and cause building emulate.o to become far more complicated than just
+ * stubbing them out here.  In order to stub them without modifying the
+ * included source, we're declaring many of them here.
+ */
+#include <linux/types.h>
+#include <stdio.h>
+
+#include "stubs.h"
+
+#define VMWARE_BACKDOOR_PMC_HOST_TSC 0x10000
+#define VMWARE_BACKDOOR_PMC_REAL_TIME 0x10001
+#define VMWARE_BACKDOOR_PMC_APPARENT_TIME 0x10002
+
+/*
+ * This is easy enough to stub out its full functionality.
+ */
+bool is_vmware_backdoor_pmc(u32 pmc_idx)
+{
+	switch (pmc_idx) {
+	case VMWARE_BACKDOOR_PMC_HOST_TSC:
+	case VMWARE_BACKDOOR_PMC_REAL_TIME:
+	case VMWARE_BACKDOOR_PMC_APPARENT_TIME:
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Printk has no side effects so we don't need to worry about it.
+ */
+int printk(const char *s, ...)
+{
+	return 0;
+}
+
+/*
+ * This is required by source included from emulate.c and would be linked in.
+ */
+bool enable_vmware_backdoor;
+
+struct exception_table_entry;
+struct pt_regs;
+
+bool ex_handler_default(const struct exception_table_entry *fixup,
+			struct pt_regs *regs, int trapnr,
+			unsigned long error_code, unsigned long fault_addr)
+{
+	return true;
+}
+
+void fortify_panic(const char *name)
+{
+	perror("detected buffer overflow");
+}
diff --git a/tools/fuzz/x86ie/stubs.h b/tools/fuzz/x86ie/stubs.h
new file mode 100644
index 000000000000..02c2f6f9bc26
--- /dev/null
+++ b/tools/fuzz/x86ie/stubs.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef STUBS_H
+#define STUBS_H
+
+
+/*
+ * Several typedefs in linux/types.h collide with ones in standard libs.
+ *
+ * kvm_emulate.h uses many other types in linux/types.h heavily, so we must
+ * include it but having access to the standard libs is also important for the
+ * harnesses.
+ *
+ * A solution would be to not include any kernel files in the harness but then
+ * useful introspection into state->ctxt is impossible as x86_emulate_ctxt is
+ * defined in kvm_emulate.h and uses a ton of linux/types.h types.
+ *
+ * Instead, we use dummy defines to avoid the collision and linux seems
+ * content to use the equivalent types from the standard libs.
+ */
+#define fd_set fake_fd_set
+#define dev_t fake_dev_t
+#define nlink_t fake_nlink_t
+#define timer_t fake_timer_t
+#define loff_t fake_loff_t
+#define u_int64_t fake_u_int64_t
+#define int64_t fake_int64_t
+#define blkcnt_t fake_blkcnt_t
+#define uint64_t fake_uint64_t
+#include <linux/types.h>
+#undef fd_set
+#undef dev_t
+#undef nlint_t
+#undef timer_t
+#undef loff_t
+#undef u_int64_t
+#undef int64_t
+#undef blkcnt_t
+#undef uint64_t
+
+/*
+ * These are identically defined in string.h and included kernel headers.
+ */
+#ifdef __always_inline
+#undef __always_inline
+#endif
+
+#ifdef __attribute_const__
+#undef __attribute_const__
+#endif
+
+#endif /* STUBS_H */
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



