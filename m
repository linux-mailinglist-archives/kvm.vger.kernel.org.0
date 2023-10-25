Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8227D7611
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 22:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjJYUxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 16:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjJYUxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 16:53:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A67DD50;
        Wed, 25 Oct 2023 13:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698267189; x=1729803189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fKL8O9LfX0J38E00Mtc5QFOreN8mewIuIipoFxbNi84=;
  b=P2Tp2FfUFAD2G856ryNsSeuasFVWSN9mlO29Mzm6TXU9ZG3jZddBNnL0
   iGGH07YiN/qXtZIEfQiXxXGdYDAI8afP5+0t2up+wxtTFuJms+JVY/BpK
   s8viFGeHdMczxgNHn+K5jMu5BMEQwdL5WFDh7GhQBhBh6f1JsQjlvByIH
   TBPaHalfMd7wxIg7aAhXUlFNBE2IdWGGsyzqEXEcWjHAjqyBSgyIRCtF/
   5pGWzEbw4XDbG7rfWNNPecsk247lBQWv2ZW4nIRxEJTqqee9q23ndY04H
   np7VvRRSMU0erv7RU3KoBxnsHSPRtFsMJwGeMbttwwU66DHVBwd/lQ0s4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="390255526"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="390255526"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 13:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="259651"
Received: from kkomeyli-mobl.amr.corp.intel.com (HELO desk) ([10.251.29.139])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 13:52:57 -0700
Date:   Wed, 25 Oct 2023 13:53:05 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH  v3 3/6] x86/entry_32: Add VERW just before userspace
 transition
Message-ID: <20231025-delay-verw-v3-3-52663677ee35@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_32.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 6e6af42e044a..74a4358c7f45 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -885,6 +885,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -954,6 +955,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1146,6 +1148,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:

-- 
2.34.1


