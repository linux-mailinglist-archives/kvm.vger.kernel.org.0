Return-Path: <kvm+bounces-2203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 697487F3495
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E090B215DC
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DE658122;
	Tue, 21 Nov 2023 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF9F12C;
	Tue, 21 Nov 2023 09:11:32 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a00f67f120aso194050866b.2;
        Tue, 21 Nov 2023 09:11:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700586690; x=1701191490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCBszeb6BLVjodCjuc9eHADxH0ZAWabB6KnbF0fS0Zs=;
        b=sJplJ0JojYKw3VqKn/pV9dbjvtLjWIKBm+6C8lYXpo4jUX2vzDwDQ52I4WbMXxi3gP
         NdxqUPQUgiX0H1LlCX+in2UJLz8LDfTEPXWQihQaY8z+Iyj+sWGjIaVWeTNCXeCfXsn9
         jzKFdafKBqwoX5IiacDQn/Lr9zNxvYigG7XHDGXB8Rwt8I0wFbv12yGTmC0o9a1JNIER
         z1173Q2bZmdyyMd7L1N2KRZ8Jy/96KxDcZsRbguO5LkACgSOT4we/VB4WO2Zc/gqRIoV
         ZC6uTC4fRFFeeql6Nd9aXokDrKXJS9waSFNx/NSupeDu8ti10QxsHQpLA0+MaPoEUEh5
         zCgw==
X-Gm-Message-State: AOJu0Ywkl+bgqwdll7Xf+Wo3lM2esPWqatnYHtf3/qgoJcT13+6BGzA4
	F/mKBx/DDDHMtjZak+6xsF8=
X-Google-Smtp-Source: AGHT+IHX7Y0XB2x7hVRtJz0NSvftW4BJdfFw950qFhk/Nfom111GzjhxAHfj/D1vjt+wa4rhGBnyNA==
X-Received: by 2002:a17:906:2252:b0:a02:3f1e:59e6 with SMTP id 18-20020a170906225200b00a023f1e59e6mr2022045ejr.71.1700586690349;
        Tue, 21 Nov 2023 09:11:30 -0800 (PST)
Received: from localhost (fwdproxy-cln-001.fbsv.net. [2a03:2880:31ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id mr39-20020a17090782a700b00a01946a962csm1260879ejc.206.2023.11.21.09.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 09:11:29 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
To: jpoimboe@kernel.org,
	mingo@redhat.com,
	tglx@linutronix.de,
	bp@alien8.de,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Wang YanQing <udknight@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>
Cc: leit@meta.com,
	linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Kim Phillips <kim.phillips@amd.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Jinghao Jia <jinghao@linux.ibm.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Alyssa Ross <hi@alyssa.is>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-trace-kernel@vger.kernel.org (open list:FUNCTION HOOKS (FTRACE)),
	kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
	netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-modules@vger.kernel.org (open list:MODULE SUPPORT),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	rust-for-linux@vger.kernel.org (open list:RUST)
Subject: [PATCH v6 05/13] x86/bugs: Rename RETPOLINE to MITIGATION_RETPOLINE
Date: Tue, 21 Nov 2023 08:07:32 -0800
Message-Id: <20231121160740.1249350-6-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231121160740.1249350-1-leitao@debian.org>
References: <20231121160740.1249350-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CPU mitigations config entries are inconsistent, and names are hard to
related. There are concrete benefits for both users and developers of
having all the mitigation config options living in the same config
namespace.

The mitigation options should have consistency and start with
MITIGATION.

Rename the Kconfig entry from RETPOLINE to MITIGATION_RETPOLINE.

Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst   | 8 ++++----
 Documentation/admin-guide/kernel-parameters.txt | 4 ++--
 arch/x86/Kconfig                                | 6 +++---
 arch/x86/Makefile                               | 4 ++--
 arch/x86/entry/vdso/Makefile                    | 4 ++--
 arch/x86/include/asm/disabled-features.h        | 2 +-
 arch/x86/include/asm/linkage.h                  | 8 ++++----
 arch/x86/include/asm/nospec-branch.h            | 8 ++++----
 arch/x86/kernel/alternative.c                   | 6 +++---
 arch/x86/kernel/cpu/bugs.c                      | 6 +++---
 arch/x86/kernel/ftrace.c                        | 2 +-
 arch/x86/kernel/kprobes/opt.c                   | 2 +-
 arch/x86/kernel/vmlinux.lds.S                   | 4 ++--
 arch/x86/kvm/mmu/mmu.c                          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h                 | 2 +-
 arch/x86/kvm/svm/svm.c                          | 2 +-
 arch/x86/kvm/svm/vmenter.S                      | 4 ++--
 arch/x86/kvm/vmx/vmx.c                          | 2 +-
 arch/x86/lib/Makefile                           | 2 +-
 arch/x86/net/bpf_jit_comp.c                     | 2 +-
 arch/x86/net/bpf_jit_comp32.c                   | 2 +-
 arch/x86/purgatory/Makefile                     | 2 +-
 include/linux/compiler-gcc.h                    | 2 +-
 include/linux/indirect_call_wrapper.h           | 2 +-
 include/linux/module.h                          | 2 +-
 include/net/netfilter/nf_tables_core.h          | 2 +-
 include/net/tc_wrapper.h                        | 2 +-
 kernel/trace/ring_buffer.c                      | 2 +-
 net/netfilter/Makefile                          | 2 +-
 net/netfilter/nf_tables_core.c                  | 6 +++---
 net/netfilter/nft_ct.c                          | 4 ++--
 net/netfilter/nft_lookup.c                      | 2 +-
 net/sched/sch_api.c                             | 2 +-
 scripts/Makefile.lib                            | 2 +-
 scripts/generate_rust_target.rs                 | 2 +-
 scripts/mod/modpost.c                           | 2 +-
 tools/arch/x86/include/asm/disabled-features.h  | 2 +-
 37 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 32a8893e5617..cce768afec6b 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -473,8 +473,8 @@ Spectre variant 2
    -mindirect-branch=thunk-extern -mindirect-branch-register options.
    If the kernel is compiled with a Clang compiler, the compiler needs
    to support -mretpoline-external-thunk option.  The kernel config
-   CONFIG_RETPOLINE needs to be turned on, and the CPU needs to run with
-   the latest updated microcode.
+   CONFIG_MITIGATION_RETPOLINE needs to be turned on, and the CPU needs
+   to run with the latest updated microcode.
 
    On Intel Skylake-era systems the mitigation covers most, but not all,
    cases. See :ref:`[3] <spec_ref3>` for more details.
@@ -609,8 +609,8 @@ kernel command line.
 		Selecting 'on' will, and 'auto' may, choose a
 		mitigation method at run time according to the
 		CPU, the available microcode, the setting of the
-		CONFIG_RETPOLINE configuration option, and the
-		compiler with which the kernel was built.
+		CONFIG_MITIGATION_RETPOLINE configuration option,
+		and the compiler with which the kernel was built.
 
 		Selecting 'on' will also enable the mitigation
 		against user space to user space task attacks.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 65731b060e3f..7e071087c8c2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6000,8 +6000,8 @@
 			Selecting 'on' will, and 'auto' may, choose a
 			mitigation method at run time according to the
 			CPU, the available microcode, the setting of the
-			CONFIG_RETPOLINE configuration option, and the
-			compiler with which the kernel was built.
+			CONFIG_MITIGATION_RETPOLINE configuration option,
+			and the compiler with which the kernel was built.
 
 			Selecting 'on' will also enable the mitigation
 			against user space to user space task attacks.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4398e9ebef8c..862be9b3b216 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2460,7 +2460,7 @@ config CALL_PADDING
 
 config FINEIBT
 	def_bool y
-	depends on X86_KERNEL_IBT && CFI_CLANG && RETPOLINE
+	depends on X86_KERNEL_IBT && CFI_CLANG && MITIGATION_RETPOLINE
 	select CALL_PADDING
 
 config HAVE_CALL_THUNKS
@@ -2498,7 +2498,7 @@ config MITIGATION_PAGE_TABLE_ISOLATION
 
 	  See Documentation/arch/x86/pti.rst for more details.
 
-config RETPOLINE
+config MITIGATION_RETPOLINE
 	bool "Avoid speculative indirect branches in kernel"
 	select OBJTOOL if HAVE_OBJTOOL
 	default y
@@ -2510,7 +2510,7 @@ config RETPOLINE
 
 config RETHUNK
 	bool "Enable return-thunks"
-	depends on RETPOLINE && CC_HAS_RETURN_THUNK
+	depends on MITIGATION_RETPOLINE && CC_HAS_RETURN_THUNK
 	select OBJTOOL if HAVE_OBJTOOL
 	default y if X86_64
 	help
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1a068de12a56..b8d23ed059fb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -192,7 +192,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 
 # Avoid indirect branches in kernel to deal with Spectre
-ifdef CONFIG_RETPOLINE
+ifdef CONFIG_MITIGATION_RETPOLINE
   KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
   # Additionally, avoid generating expensive indirect jumps which
   # are subject to retpolines for small number of switch cases.
@@ -301,7 +301,7 @@ vdso-install-$(CONFIG_IA32_EMULATION)	+= arch/x86/entry/vdso/vdso32.so.dbg
 
 archprepare: checkbin
 checkbin:
-ifdef CONFIG_RETPOLINE
+ifdef CONFIG_MITIGATION_RETPOLINE
 ifeq ($(RETPOLINE_CFLAGS),)
 	@echo "You are building kernel with non-retpoline compiler." >&2
 	@echo "Please update your compiler." >&2
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index b1b8dd1608f7..c4df99aa1615 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -87,7 +87,7 @@ CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
        -fno-omit-frame-pointer -foptimize-sibling-calls \
        -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 
-ifdef CONFIG_RETPOLINE
+ifdef CONFIG_MITIGATION_RETPOLINE
 ifneq ($(RETPOLINE_VDSO_CFLAGS),)
   CFL += $(RETPOLINE_VDSO_CFLAGS)
 endif
@@ -164,7 +164,7 @@ KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
 KBUILD_CFLAGS_32 += -fno-omit-frame-pointer
 KBUILD_CFLAGS_32 += -DDISABLE_BRANCH_PROFILING
 
-ifdef CONFIG_RETPOLINE
+ifdef CONFIG_MITIGATION_RETPOLINE
 ifneq ($(RETPOLINE_VDSO_CFLAGS),)
   KBUILD_CFLAGS_32 += $(RETPOLINE_VDSO_CFLAGS)
 endif
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index fb604ec95a5f..24e4010c33b6 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -50,7 +50,7 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 # define DISABLE_RETPOLINE	0
 #else
 # define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 571fe4d2d232..c5165204c66f 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -42,25 +42,25 @@
 
 #if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define RET	jmp __x86_return_thunk
-#else /* CONFIG_RETPOLINE */
+#else /* CONFIG_MITIGATION_RETPOLINE */
 #ifdef CONFIG_SLS
 #define RET	ret; int3
 #else
 #define RET	ret
 #endif
-#endif /* CONFIG_RETPOLINE */
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 
 #else /* __ASSEMBLY__ */
 
 #if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define ASM_RET	"jmp __x86_return_thunk\n\t"
-#else /* CONFIG_RETPOLINE */
+#else /* CONFIG_MITIGATION_RETPOLINE */
 #ifdef CONFIG_SLS
 #define ASM_RET	"ret; int3\n\t"
 #else
 #define ASM_RET	"ret\n\t"
 #endif
-#endif /* CONFIG_RETPOLINE */
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 64d9f0e87419..cab7c937c71b 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -241,7 +241,7 @@
  * instruction irrespective of kCFI.
  */
 .macro JMP_NOSPEC reg:req
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	__CS_PREFIX \reg
 	jmp	__x86_indirect_thunk_\reg
 #else
@@ -251,7 +251,7 @@
 .endm
 
 .macro CALL_NOSPEC reg:req
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	__CS_PREFIX \reg
 	call	__x86_indirect_thunk_\reg
 #else
@@ -378,7 +378,7 @@ static inline void call_depth_return_thunk(void) {}
 
 #endif /* CONFIG_MITIGATION_CALL_DEPTH_TRACKING */
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 
 #define GEN(reg) \
 	extern retpoline_thunk_t __x86_indirect_thunk_ ## reg;
@@ -399,7 +399,7 @@ static inline void call_depth_return_thunk(void) {}
 
 /*
  * Inline asm uses the %V modifier which is only in newer GCC
- * which is ensured when CONFIG_RETPOLINE is defined.
+ * which is ensured when CONFIG_MITIGATION_RETPOLINE is defined.
  */
 # define CALL_NOSPEC						\
 	ALTERNATIVE_2(						\
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 73be3931e4f0..5ec887d065ce 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -473,7 +473,7 @@ static inline bool is_jcc32(struct insn *insn)
 	return insn->opcode.bytes[0] == 0x0f && (insn->opcode.bytes[1] & 0xf0) == 0x80;
 }
 
-#if defined(CONFIG_RETPOLINE) && defined(CONFIG_OBJTOOL)
+#if defined(CONFIG_MITIGATION_RETPOLINE) && defined(CONFIG_OBJTOOL)
 
 /*
  * CALL/JMP *%\reg
@@ -773,12 +773,12 @@ void __init_or_module noinline apply_returns(s32 *start, s32 *end)
 void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
 #endif /* CONFIG_RETHUNK */
 
-#else /* !CONFIG_RETPOLINE || !CONFIG_OBJTOOL */
+#else /* !CONFIG_MITIGATION_RETPOLINE || !CONFIG_OBJTOOL */
 
 void __init_or_module noinline apply_retpolines(s32 *start, s32 *end) { }
 void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
 
-#endif /* CONFIG_RETPOLINE && CONFIG_OBJTOOL */
+#endif /* CONFIG_MITIGATION_RETPOLINE && CONFIG_OBJTOOL */
 
 #ifdef CONFIG_X86_KERNEL_IBT
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index b906ed4f3091..fc46fd6447f9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1103,7 +1103,7 @@ static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
 static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 static bool spectre_v2_bad_module;
 
 bool retpoline_module_ok(bool has_retpoline)
@@ -1416,7 +1416,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 	     cmd == SPECTRE_V2_CMD_RETPOLINE_GENERIC ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
-	    !IS_ENABLED(CONFIG_RETPOLINE)) {
+	    !IS_ENABLED(CONFIG_MITIGATION_RETPOLINE)) {
 		pr_err("%s selected but not compiled in. Switching to AUTO select\n",
 		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
@@ -1470,7 +1470,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 
 static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 {
-	if (!IS_ENABLED(CONFIG_RETPOLINE)) {
+	if (!IS_ENABLED(CONFIG_MITIGATION_RETPOLINE)) {
 		pr_err("Kernel not compiled with retpoline; no mitigation available!");
 		return SPECTRE_V2_NONE;
 	}
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 12df54ff0e81..93bc52d4a472 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -307,7 +307,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
+#define RET_SIZE	(IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 517821b48391..36d6809c6c9e 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -324,7 +324,7 @@ static int can_optimize(unsigned long paddr)
 		 * However, the kernel built with retpolines or IBT has jump
 		 * tables disabled so the check can be skipped altogether.
 		 */
-		if (!IS_ENABLED(CONFIG_RETPOLINE) &&
+		if (!IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) &&
 		    !IS_ENABLED(CONFIG_X86_KERNEL_IBT) &&
 		    insn_is_indirect_jump(&insn))
 			return 0;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 54a5596adaa6..985984919d81 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -132,7 +132,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		SOFTIRQENTRY_TEXT
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 		*(.text..__x86.indirect_thunk)
 		*(.text..__x86.return_thunk)
 #endif
@@ -280,7 +280,7 @@ SECTIONS
 		__parainstructions_end = .;
 	}
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	/*
 	 * List of instructions that call/jmp/jcc to retpoline thunks
 	 * __x86_indirect_thunk_*(). These instructions can be patched along
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c57e181bba21..2485dbd4cf50 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -263,7 +263,7 @@ static unsigned long get_guest_cr3(struct kvm_vcpu *vcpu)
 static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
 						  struct kvm_mmu *mmu)
 {
-	if (IS_ENABLED(CONFIG_RETPOLINE) && mmu->get_guest_pgd == get_guest_cr3)
+	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && mmu->get_guest_pgd == get_guest_cr3)
 		return kvm_read_cr3(vcpu);
 
 	return mmu->get_guest_pgd(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index decc1f153669..bf73a121c5ef 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -312,7 +312,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!prefetch)
 		vcpu->stat.pf_taken++;
 
-	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
+	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
 		r = kvm_tdp_page_fault(vcpu, &fault);
 	else
 		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 712146312358..dc362ec24ba1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3452,7 +3452,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	if (!svm_check_exit_valid(exit_code))
 		return svm_handle_invalid_exit(vcpu, exit_code);
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_code == SVM_EXIT_MSR)
 		return msr_interception(vcpu);
 	else if (exit_code == SVM_EXIT_VINTR)
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index ef2ebabb059c..b9e08837ab96 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -207,7 +207,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 7:	vmload %_ASM_AX
 8:
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
@@ -344,7 +344,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	/* Pop @svm to RDI, guest registers have been saved already. */
 	pop %_ASM_DI
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..fbe516148ab6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6544,7 +6544,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	if (exit_reason.basic >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index ea3a28e7b613..72cc9c90e9f3 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -49,7 +49,7 @@ lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc.o copy_mc_64.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o insn-eval.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
-lib-$(CONFIG_RETPOLINE) += retpoline.o
+lib-$(CONFIG_MITIGATION_RETPOLINE) += retpoline.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
 obj-y += iomem.o
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 8c10d9abc239..ef732f323926 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -469,7 +469,7 @@ static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
 			emit_jump(&prog, &__x86_indirect_thunk_array[reg], ip);
 	} else {
 		EMIT2(0xFF, 0xE0 + reg);	/* jmp *%\reg */
-		if (IS_ENABLED(CONFIG_RETPOLINE) || IS_ENABLED(CONFIG_SLS))
+		if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) || IS_ENABLED(CONFIG_SLS))
 			EMIT1(0xCC);		/* int3 */
 	}
 
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 429a89c5468b..efca6bd818a3 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1273,7 +1273,7 @@ static int emit_jmp_edx(u8 **pprog, u8 *ip)
 	u8 *prog = *pprog;
 	int cnt = 0;
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	EMIT1_off32(0xE9, (u8 *)__x86_indirect_thunk_edx - (ip + 5));
 #else
 	EMIT2(0xFF, 0xE2);
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 08aa0f25f12a..bc31863c5ee6 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -61,7 +61,7 @@ ifdef CONFIG_STACKPROTECTOR_STRONG
 PURGATORY_CFLAGS_REMOVE		+= -fstack-protector-strong
 endif
 
-ifdef CONFIG_RETPOLINE
+ifdef CONFIG_MITIGATION_RETPOLINE
 PURGATORY_CFLAGS_REMOVE		+= $(RETPOLINE_CFLAGS)
 endif
 
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 2ceba3fe4ec1..d24f29091f4b 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -35,7 +35,7 @@
 	(typeof(ptr)) (__ptr + (off));					\
 })
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 #define __noretpoline __attribute__((__indirect_branch__("keep")))
 #endif
 
diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index c1c76a70a6ce..fe050dab55a3 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_INDIRECT_CALL_WRAPPER_H
 #define _LINUX_INDIRECT_CALL_WRAPPER_H
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 
 /*
  * INDIRECT_CALL_$NR - wrapper for indirect calls with $NR known builtin
diff --git a/include/linux/module.h b/include/linux/module.h
index a98e188cf37b..d45e17fa7f98 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -883,7 +883,7 @@ static inline void module_bug_finalize(const Elf_Ehdr *hdr,
 static inline void module_bug_cleanup(struct module *mod) {}
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 extern bool retpoline_module_ok(bool has_retpoline);
 #else
 static inline bool retpoline_module_ok(bool has_retpoline)
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 780a5f6ad4a6..ff27cb2e1662 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -93,7 +93,7 @@ extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
 extern const struct nft_set_type nft_set_pipapo_avx2_type;
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 bool nft_rhash_lookup(const struct net *net, const struct nft_set *set,
 		      const u32 *key, const struct nft_set_ext **ext);
 bool nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
index a6d481b5bcbc..a13ba0326d5e 100644
--- a/include/net/tc_wrapper.h
+++ b/include/net/tc_wrapper.h
@@ -4,7 +4,7 @@
 
 #include <net/pkt_cls.h>
 
-#if IS_ENABLED(CONFIG_RETPOLINE)
+#if IS_ENABLED(CONFIG_MITIGATION_RETPOLINE)
 
 #include <linux/cpufeature.h>
 #include <linux/static_key.h>
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 43cc47d7faaf..5c88afbfbdb9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1193,7 +1193,7 @@ static inline u64 rb_time_stamp(struct trace_buffer *buffer)
 	u64 ts;
 
 	/* Skip retpolines :-( */
-	if (IS_ENABLED(CONFIG_RETPOLINE) && likely(buffer->clock == trace_clock_local))
+	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && likely(buffer->clock == trace_clock_local))
 		ts = trace_clock_local();
 	else
 		ts = buffer->clock();
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index d4958e7e7631..614815a3ed73 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -101,7 +101,7 @@ endif
 endif
 
 ifdef CONFIG_NFT_CT
-ifdef CONFIG_RETPOLINE
+ifdef CONFIG_MITIGATION_RETPOLINE
 nf_tables-objs += nft_ct_fast.o
 endif
 endif
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 8b536d7ef6c2..63e9c8b9f144 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -21,7 +21,7 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nft_meta.h>
 
-#if defined(CONFIG_RETPOLINE) && defined(CONFIG_X86)
+#if defined(CONFIG_MITIGATION_RETPOLINE) && defined(CONFIG_X86)
 
 static struct static_key_false nf_tables_skip_direct_calls;
 
@@ -207,7 +207,7 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 			       struct nft_regs *regs,
 			       struct nft_pktinfo *pkt)
 {
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 	unsigned long e;
 
 	if (nf_skip_indirect_calls())
@@ -236,7 +236,7 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 	X(e, nft_objref_map_eval);
 #undef  X
 indirect_call:
-#endif /* CONFIG_RETPOLINE */
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 	expr->ops->eval(expr, regs, pkt);
 }
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 86bb9d7797d9..d3e66bcb2a91 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -751,7 +751,7 @@ static bool nft_ct_set_reduce(struct nft_regs_track *track,
 	return false;
 }
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 static const struct nft_expr_ops nft_ct_get_fast_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
@@ -796,7 +796,7 @@ nft_ct_select_ops(const struct nft_ctx *ctx,
 		return ERR_PTR(-EINVAL);
 
 	if (tb[NFTA_CT_DREG]) {
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 		u32 k = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
 
 		switch (k) {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 870e5b113d13..a0055f510e31 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -24,7 +24,7 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 bool nft_set_do_lookup(const struct net *net, const struct nft_set *set,
 		       const u32 *key, const struct nft_set_ext **ext)
 {
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index e9eaf637220e..d577c9e1cb42 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -2353,7 +2353,7 @@ static struct pernet_operations psched_net_ops = {
 	.exit = psched_net_exit,
 };
 
-#if IS_ENABLED(CONFIG_RETPOLINE)
+#if IS_ENABLED(CONFIG_MITIGATION_RETPOLINE)
 DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
 #endif
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cc44c95c49cc..d6e157938b5f 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -262,7 +262,7 @@ ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
 objtool-args-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
 endif
 objtool-args-$(CONFIG_UNWINDER_ORC)			+= --orc
-objtool-args-$(CONFIG_RETPOLINE)			+= --retpoline
+objtool-args-$(CONFIG_MITIGATION_RETPOLINE)		+= --retpoline
 objtool-args-$(CONFIG_RETHUNK)				+= --rethunk
 objtool-args-$(CONFIG_SLS)				+= --sls
 objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 3c6cbe2b278d..eaf524603796 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -155,7 +155,7 @@ fn main() {
             "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128",
         );
         let mut features = "-3dnow,-3dnowa,-mmx,+soft-float".to_string();
-        if cfg.has("RETPOLINE") {
+        if cfg.has("MITIGATION_RETPOLINE") {
             features += ",+retpoline-external-thunk";
         }
         ts.push("features", features);
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 973b5e5ae2dd..3070aa79aebd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1841,7 +1841,7 @@ static void add_header(struct buffer *b, struct module *mod)
 
 	buf_printf(b,
 		   "\n"
-		   "#ifdef CONFIG_RETPOLINE\n"
+		   "#ifdef CONFIG_MITIGATION_RETPOLINE\n"
 		   "MODULE_INFO(retpoline, \"Y\");\n"
 		   "#endif\n");
 
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index aeb3fbbbce46..d05158d8fe5f 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -50,7 +50,7 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_MITIGATION_RETPOLINE
 # define DISABLE_RETPOLINE	0
 #else
 # define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
-- 
2.34.1


