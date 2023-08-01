Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E5E76AC59
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjHAJIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 05:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjHAJIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 05:08:20 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34564EFE;
        Tue,  1 Aug 2023 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690880772; x=1722416772;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BTa7pFRtc5hN79memTk6tlfkpBhDUr274mj/lMgq9SQ=;
  b=k8ymMUnwrlWuKHlLJTJiqP0MmNuNrfoeCxaXahRbWW18/fNDazT5k2q0
   oP5JOcovBW2DyakYS0ZH4tUelN27zE9yZNOJcxNNhA3otIo05Hak+zLw5
   IcvkNl+mNdSu+QVm6SUDC69S8ihSK0B3S9b4SKNb5i1E6fulZv7K0taHD
   HirwX11kw7g2ka1LmhT/ELBNC0/ZJf251t2v9h/eqg+WdDGDYZjEDEYny
   SDMCsQc6U19D7lg2XX3WPqKNwdelGCWgUbjx2zb31Mnu1eQETBh44Mr+E
   s2v7oIkk01731xLCwjGVLyWjWWhJM2cWYZcDY1c9o29E9er3+gNVHlHQ7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="366713454"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="366713454"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 02:04:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722420705"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722420705"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2023 02:04:25 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Xin Li <xin3.li@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@Oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Subject: [PATCH RESEND v9 27/36] x86/traps: Add external_interrupt() to dispatch external interrupts
Date:   Tue,  1 Aug 2023 01:35:44 -0700
Message-Id: <20230801083553.8468-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

external_interrupt() dispatches all external interrupts: it checks if an
external interrupt is a system interrupt, if yes it dipatches it through
the system_interrupt_handlers table, otherwise to
dispatch_common_interrupt().

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v8:
* Reword the patch description, which was confusing (Thomas Gleixner).

Changes since v5:
* Initialize system_interrupt_handlers with dispatch_table_spurious_interrupt()
  instead of NULL to get rid of a branch (Peter Zijlstra).
---
 arch/x86/include/asm/traps.h |  2 ++
 arch/x86/kernel/traps.c      | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index cba3e4dfc329..48daa78ee88c 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -66,4 +66,6 @@ static inline void sysvec_setup_fred(unsigned int vector, system_interrupt_handl
 	alloc_intr_gate(vector, asm_##func);				\
 }
 
+int external_interrupt(struct pt_regs *regs);
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9040c7f01c93..90fdfcccee7a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1542,6 +1542,24 @@ void set_sysvec_handler(unsigned int i, system_interrupt_handler func)
 	system_interrupt_handlers[i] = func;
 }
 
+int external_interrupt(struct pt_regs *regs)
+{
+	unsigned int vector = regs->vector;
+	unsigned int sysvec = vector - FIRST_SYSTEM_VECTOR;
+
+	if (unlikely(vector < FIRST_EXTERNAL_VECTOR)) {
+		pr_err("invalid external interrupt vector %d\n", vector);
+		return -EINVAL;
+	}
+
+	if (sysvec < NR_SYSTEM_VECTORS)
+		system_interrupt_handlers[sysvec](regs);
+	else
+		dispatch_common_interrupt(regs, vector);
+
+	return 0;
+}
+
 #endif /* CONFIG_X86_64 */
 
 void __init trap_init(void)
-- 
2.34.1

