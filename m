Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB025431
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfEUPj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 11:39:58 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19222 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfEUPj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 11:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558453191; x=1589989191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=AMfjMIyVVLp3f0BRoXOD3C8gCuDAnUH9nAaKFrrh6kw=;
  b=KL50Y/mMH7IUAE3rFD7uUBU5ClNj4OCDTGTogz/hFifiytGnuUaALSDT
   lbLNpW7Nm8BRkBFOUoZ2pXY2TIF7ovLhX/K24RZZ2YO5vkz7UMNbz4pYO
   IkSgRKdcUVJR5Gqo32UuqvHTPMxY0rqGLZTGzer2647DP7FcoGCvyc0IZ
   M=;
X-IronPort-AV: E=Sophos;i="5.60,495,1549929600"; 
   d="scan'208";a="675574214"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 May 2019 15:39:48 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4LFdhwK026958
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 21 May 2019 15:39:47 GMT
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:46 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:45 +0000
Received: from uc2253769c0055c.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 21 May 2019 15:39:41 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcacc@amazon.de>, <samcaccavale@gmail.com>,
        <nmanthey@amazon.de>, <wipawel@amazon.de>, <dwmw@amazon.co.uk>,
        <mpohlack@amazon.de>, <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Build target for emulate.o as a userspace binary
Date:   Tue, 21 May 2019 17:39:22 +0200
Message-ID: <20190521153924.15110-2-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190521153924.15110-1-samcacc@amazon.de>
References: <20190521153924.15110-1-samcacc@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit contains the minimal set of functionality to build
afl-harness around arch/x86/emulate.c which allows exercising code
in that source file, like x86_emulate_insn.  Resolving the
dependencies was done via GCC's -H flag by get_headers.py.

---
 tools/Makefile                                |   9 ++
 .../fuzz/x86_instruction_emulation/.gitignore |   2 +
 tools/fuzz/x86_instruction_emulation/Makefile |  57 +++++++
 .../fuzz/x86_instruction_emulation/README.md  |  12 ++
 .../x86_instruction_emulation/afl-harness.c   | 149 ++++++++++++++++++
 tools/fuzz/x86_instruction_emulation/common.h |  87 ++++++++++
 .../x86_instruction_emulation/emulator_ops.c  |  58 +++++++
 .../x86_instruction_emulation/emulator_ops.h  | 117 ++++++++++++++
 .../scripts/get_headers.py                    |  95 +++++++++++
 .../scripts/make_deps                         |   4 +
 tools/fuzz/x86_instruction_emulation/stubs.c  |  56 +++++++
 tools/fuzz/x86_instruction_emulation/stubs.h  |  52 ++++++
 12 files changed, 698 insertions(+)
 create mode 100644 tools/fuzz/x86_instruction_emulation/.gitignore
 create mode 100644 tools/fuzz/x86_instruction_emulation/Makefile
 create mode 100644 tools/fuzz/x86_instruction_emulation/README.md
 create mode 100644 tools/fuzz/x86_instruction_emulation/afl-harness.c
 create mode 100644 tools/fuzz/x86_instruction_emulation/common.h
 create mode 100644 tools/fuzz/x86_instruction_emulation/emulator_ops.c
 create mode 100644 tools/fuzz/x86_instruction_emulation/emulator_ops.h
 create mode 100644 tools/fuzz/x86_instruction_emulation/scripts/get_headers.py
 create mode 100755 tools/fuzz/x86_instruction_emulation/scripts/make_deps
 create mode 100644 tools/fuzz/x86_instruction_emulation/stubs.c
 create mode 100644 tools/fuzz/x86_instruction_emulation/stubs.h

diff --git a/tools/Makefile b/tools/Makefile
index 3dfd72ae6c1a..4d68817b7e49 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -94,6 +94,12 @@ freefall: FORCE
 kvm_stat: FORCE
 	$(call descend,kvm/$@)
 
+fuzz: FORCE
+	$(call descend,fuzz/x86_instruction_emulation)
+
+fuzz_deps: FORCE
+	$(call descend,fuzz/x86_instruction_emulation,fuzz_deps)
+
 all: acpi cgroup cpupower gpio hv firewire liblockdep \
 		perf selftests spi turbostat usb \
 		virtio vm bpf x86_energy_perf_policy \
@@ -171,6 +177,9 @@ tmon_clean:
 freefall_clean:
 	$(call descend,laptop/freefall,clean)
 
+fuzz_clean:
+	$(call descend,fuzz/x86_instruction_emulation,clean)
+
 build_clean:
 	$(call descend,build,clean)
 
diff --git a/tools/fuzz/x86_instruction_emulation/.gitignore b/tools/fuzz/x86_instruction_emulation/.gitignore
new file mode 100644
index 000000000000..7d44f7ce266e
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/.gitignore
@@ -0,0 +1,2 @@
+*.o
+*-harness
diff --git a/tools/fuzz/x86_instruction_emulation/Makefile b/tools/fuzz/x86_instruction_emulation/Makefile
new file mode 100644
index 000000000000..d2854a332605
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/Makefile
@@ -0,0 +1,57 @@
+ROOT_DIR=../../..
+THIS_DIR=tools/fuzz/x86_instruction_emulation
+
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
+ifdef DEBUG
+KBUILD_CFLAGS += -DDEBUG
+endif
+KBUILD_CFLAGS += -g -O0
+
+# This may still not a final solution-- but multiple build flags need to be
+# filtered out of KBUILD_FLAGS so a solution is needed.
+UNNEEDED_FLAGS:= -mno-sse
+KBUILD_CFLAGS := $(filter-out $(UNNEEDED_FLAGS),$(KBUILD_CFLAGS))
+
+DEPS := emulator_ops.h stubs.h common.h
+
+%.o: %.c $(DEPS)
+	$(CC) $(KBUILD_CFLAGS) $(INCLUDES) -g -c -o $@ $<
+
+KERNEL_OBJS := arch/x86/kvm/emulate.o \
+			arch/x86/lib/retpoline.o \
+			lib/find_bit.o
+KERNEL_OBJS := $(patsubst %,$(ROOT_DIR)/%, $(KERNEL_OBJS))
+# I don't know how to make KERNEL_OBJS a dependency of this.  I cannot call
+# make from here since it causes a cycle and I would rather not hardcode
+# these dependencies into _another_ makefile.
+$(KERNEL_OBJS): $(ROOT_DIR)/.config
+	$(error Run `./tools/fuzz/x86_instruction_emulation/scripts/make_deps' first (setting envvar CC if desired).)
+
+LOCAL_OBJS := emulator_ops.o stubs.o
+afl-harness: afl-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
+	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
+
+all: afl-harness
+
+.PHONY: fuzz_deps
+fuzz_deps:
+	cd $(ROOT_DIR) && \
+	python3 $(THIS_DIR)/scripts/get_headers.py \
+		$(THIS_DIR)/afl-harness.c \
+		arch/x86/kvm/emulate.c
+
+.PHONY: clean
+clean:
+	$(RM) -r *.o afl-harness
diff --git a/tools/fuzz/x86_instruction_emulation/README.md b/tools/fuzz/x86_instruction_emulation/README.md
new file mode 100644
index 000000000000..a78ac51b0152
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/README.md
@@ -0,0 +1,12 @@
+# Building
+
+From the root of linux, run:
+1. `./tools/fuzz/x86_instruction_emulation/scripts/make_deps`
+  - Optionally, set the envvar CC with your desired compiler.
+2. `make tools/fuzz`
+
+## TODO
+
+I'd like to add the object files built in `make_deps` as real
+dependencies of `make tools/fuzz` but it causes a cycle in Make to
+add them to `tools/fuzz/x86_instruction_emulation/Makefile`.
\ No newline at end of file
diff --git a/tools/fuzz/x86_instruction_emulation/afl-harness.c b/tools/fuzz/x86_instruction_emulation/afl-harness.c
new file mode 100644
index 000000000000..b3b09d7f15f2
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/afl-harness.c
@@ -0,0 +1,149 @@
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
+			printf("Min: %u\n", MIN_INPUT_SIZE);
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
+		reset_emulator(state);
+
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
diff --git a/tools/fuzz/x86_instruction_emulation/common.h b/tools/fuzz/x86_instruction_emulation/common.h
new file mode 100644
index 000000000000..9aec2bea3d50
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/common.h
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
diff --git a/tools/fuzz/x86_instruction_emulation/emulator_ops.c b/tools/fuzz/x86_instruction_emulation/emulator_ops.c
new file mode 100644
index 000000000000..55ae4e8fbd96
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/emulator_ops.c
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
diff --git a/tools/fuzz/x86_instruction_emulation/emulator_ops.h b/tools/fuzz/x86_instruction_emulation/emulator_ops.h
new file mode 100644
index 000000000000..5ae072d5f205
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/emulator_ops.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef EMULATOR_OPS_H
+#define EMULATOR_OPS_H
+
+#include "common.h"
+#include "stubs.h"
+#include <asm/kvm_emulate.h>
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
+	size_t other_bytes_consumed;
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
+void buffer_stderr(void) __attribute__((constructor));
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
diff --git a/tools/fuzz/x86_instruction_emulation/scripts/get_headers.py b/tools/fuzz/x86_instruction_emulation/scripts/get_headers.py
new file mode 100644
index 000000000000..94e63cab4e81
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/scripts/get_headers.py
@@ -0,0 +1,95 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0+
+
+"""
+This script compiles files given via arguments with GCC's -H flag.  This
+produces the list of headers used in compilation which we (primitively)
+check for coresponding source files to recur on.  In the end, we have the
+subset of source and header files needed to compile/link the source files
+that were given as arguments.
+
+There are a lot of hacks here including:
+Fickle regex to parse the -H output
+Attempting to use the `.FILE_NAME.o.cmd` that linux produces when building
+Being totally unrelocatable and requiring some linux build env vars
+Running `subproces.run` on input read from a file on disk
+
+If anything breaks it is likely related to one of the above hacks.
+"""
+
+import os
+import sys
+import subprocess
+from pathlib import Path
+
+if len(sys.argv) < 2:
+    print("Supply a starting file(s)")
+    exit(-1)
+
+KBUILD_FLAGS = os.environ.get("KBUILD_CFLAGS", "").split()
+LINUXINCLUDE = os.environ.get("LINUXINCLUDE", "").split()
+
+if [] in (KBUILD_FLAGS, LINUXINCLUDE):
+    print("Environment variable KBUILD_FLAGS or LINUXINCLUDE is not set.")
+    print("\tThese are emitted by the root Makefile-- are you running")
+    print("\tthis script from somewhere other than `make tools/fuzz_deps`?")
+    exit(-1)
+
+queue = [Path(source_file) for source_file in sys.argv[1:]]
+all_headers = set()
+source_files = set()
+
+# While there are source files in the queue left to process
+while queue:
+    current_file = queue.pop()  # Grab a file
+
+    source_files.add(current_file)  # Add it to the set of processed files
+    queue_size = len(queue)
+    print(f"\nFinding headers included in { current_file }:")
+
+    # If there is a `.FILE_NAME.o.cmd` file, then use that to build FILE_NAME.c
+    # if not, then `gcc -H FILE_NAME $KBUILD_FLAGS $LINUXINCLUDE` probably works
+    gcc_command = ["gcc", "-H", current_file] + KBUILD_FLAGS + LINUXINCLUDE
+    cmd_file = current_file.parent / ("." + current_file.name[:-1] + "o.cmd")
+    if cmd_file.exists():
+        with open(cmd_file, "r") as f:
+            gcc_command = f.readline().split(":= ")[1].split() + ["-H"]
+
+    # Build the file, pipe the output to sed to get just the list of headers
+    p1 = subprocess.run(gcc_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
+    p2 = subprocess.run(["sed", "/^\.[^/]/!d"], input=p1.stdout, stdout=subprocess.PIPE)
+
+    headers = p2.stdout.decode("utf-8").split("\n")
+    try:
+        # Output is of type r'\.+ filename' so split on whitespace and take the latter
+        headers = {Path(header.split()[1]) for header in headers if header}
+    except IndexError:  # Fickle regex sometimes produces lines without whitespace
+        print("Breaking output:")
+        print({header for header in headers if header and len(header.split()) < 2})
+        raise
+
+    # This loop is for adding new source files back to the queue
+    for header in headers:  # Ensure all the headers are actually files.
+        assert header.exists()
+
+        # If we have already seen the header file then we have already seen its source
+        # so there is no need to add it.  This is probably redudant with the next check.
+        if header in all_headers:
+            continue
+
+        # If we found a header file with a coresponding source file that we have not
+        # processed, then add it to the queue to process
+        source = header.parent / (header.name[:-1] + "c")
+        if source.exists() and source not in source_files:
+            queue.append(source)
+
+    print(
+        f"\t{ len(headers - all_headers) } new headers found,"
+        f"{ len(headers | all_headers) } total."
+    )
+    print(f"\tQueue size was { queue_size } and is now { len(queue) }.")
+    all_headers.update(headers)  # Add all the newly found headers to all_headers
+
+print("\n\nObjects included:")
+print("".join(sorted(f"\t{ str(path) }\n" for path in source_files)))
+exit(0)
diff --git a/tools/fuzz/x86_instruction_emulation/scripts/make_deps b/tools/fuzz/x86_instruction_emulation/scripts/make_deps
new file mode 100755
index 000000000000..4e2ab38c886f
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/scripts/make_deps
@@ -0,0 +1,4 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+make ${CC:+ "CC=$CC"} arch/x86/kvm/emulate.o arch/x86/lib/retpoline.o lib/find_bit.o
diff --git a/tools/fuzz/x86_instruction_emulation/stubs.c b/tools/fuzz/x86_instruction_emulation/stubs.c
new file mode 100644
index 000000000000..d2ffeb3ec599
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/stubs.c
@@ -0,0 +1,56 @@
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
+/*
+ * TODO: we likely need to implement this to handle emulated exceptions.
+ */
+bool ex_handler_default(const struct exception_table_entry *fixup,
+			struct pt_regs *regs, int trapnr,
+			unsigned long error_code, unsigned long fault_addr)
+{
+	return true;
+}
diff --git a/tools/fuzz/x86_instruction_emulation/stubs.h b/tools/fuzz/x86_instruction_emulation/stubs.h
new file mode 100644
index 000000000000..02c2f6f9bc26
--- /dev/null
+++ b/tools/fuzz/x86_instruction_emulation/stubs.h
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
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B


