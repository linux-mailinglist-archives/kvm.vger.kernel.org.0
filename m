Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0755252197F
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 15:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243895AbiEJNtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 09:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244698AbiEJNq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 09:46:57 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC5517706D;
        Tue, 10 May 2022 06:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1652189516; x=1683725516;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZcFtI8jvSLQdq7u3zXtig0/LPNcCJ80T1zsBtiZt0Y0=;
  b=K+tUP34vPsG3N6BK0C+FFM6UBOrmmYm06dbTjSE4cb5ASqduYARNxGLZ
   SEtWg11aB1W+gPIxo15jWYcDVTxHz69rgUCpoOSviLnOpkY8dFGRXjBtz
   qiYbDUETZ4cGriXgyo6WkvfG8FHIuqA8djhnbCAjzXXwCsSTdpBLLqwR+
   A=;
X-IronPort-AV: E=Sophos;i="5.91,214,1647302400"; 
   d="scan'208";a="200152145"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 10 May 2022 13:31:31 +0000
Received: from EX13D08EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-90d70b14.us-east-1.amazon.com (Postfix) with ESMTPS id 14F59C08D3;
        Tue, 10 May 2022 13:31:23 +0000 (UTC)
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 10 May 2022 13:31:03 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Tue, 10 May 2022 13:31:02 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id 3590B41131; Tue, 10 May 2022 13:31:02 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
CC:     Maximilian Heyne <mheyne@amazon.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 0/4] x86: decode Xen/KVM emulate prefixes
Date:   Tue, 10 May 2022 13:30:29 +0000
Message-ID: <20220510133036.46767-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a backport of a patch series for 5.4.x.

The patch series allows the x86 decoder to decode the Xen and KVM emulate
prefixes.

In particular this solves the following issue that appeared when commit
db6c6a0df840 ("objtool: Fix noreturn detection for ignored functions") was
backported to 5.4.69:

  arch/x86/xen/enlighten_pv.o: warning: objtool: xen_cpuid()+0x25: can't find jump dest instruction at .text+0x9c

Also now that this decoding is possible, also backport the commit which prevents
kprobes on probing such prefixed instructions. This was also part of the
original series.

The series applied mostly cleanly on 5.4.192 except for a contextual problem in
the 3rd patch ("x86: xen: insn: Decode Xen and KVM emulate-prefix signature").

Masami Hiramatsu (4):
  x86/asm: Allow to pass macros to __ASM_FORM()
  x86: xen: kvm: Gather the definition of emulate prefixes
  x86: xen: insn: Decode Xen and KVM emulate-prefix signature
  x86: kprobes: Prohibit probing on instruction which has emulate prefix

 arch/x86/include/asm/asm.h                  |  8 +++--
 arch/x86/include/asm/emulate_prefix.h       | 14 +++++++++
 arch/x86/include/asm/insn.h                 |  6 ++++
 arch/x86/include/asm/xen/interface.h        | 11 +++----
 arch/x86/kernel/kprobes/core.c              |  4 +++
 arch/x86/kvm/x86.c                          |  4 ++-
 arch/x86/lib/insn.c                         | 34 +++++++++++++++++++++
 tools/arch/x86/include/asm/emulate_prefix.h | 14 +++++++++
 tools/arch/x86/include/asm/insn.h           |  6 ++++
 tools/arch/x86/lib/insn.c                   | 34 +++++++++++++++++++++
 tools/objtool/sync-check.sh                 |  3 +-
 tools/perf/check-headers.sh                 |  3 +-
 12 files changed, 128 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/include/asm/emulate_prefix.h
 create mode 100644 tools/arch/x86/include/asm/emulate_prefix.h


base-commit: 1d72b776f6dc973211f5d153453cf8955fb3d70a
-- 
2.32.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



