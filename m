Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5795B691A1E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 09:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjBJIkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 03:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBJIkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 03:40:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6126C5ACF3
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 00:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676018400; x=1707554400;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=arg/HVCNZUEjXwMJSn7IQ11Xm/90BebcmLgE664Uvfs=;
  b=AHv68iTZAH56DnlYblxwE0e67rSTTkKcbp4yQDzeec3hLeYm5TNGONVY
   YBheeXgcY7goJfu2Zcotv1SiuvRJjg7xIiA6yv4U5gvb3UN0zP+oqApfG
   KH1eSnQl98zQlhh9P+GKFGfyKfPaMZrZK5FsX9QubuqvWqrFqW53ruX6r
   bBhqkCQ23BLBRATlbp+gzK4Eu7+Sq6dDs24jFkexRcthE4QpoWNoBRt5E
   g8gFv7HiSPI/NqFN04V8UAA+WJt64i/Z9P8o1zKaJDvEQipACYfM4sVyi
   C6PaWMNJdsX8dP9rzJezQPyUnEobJxJVn9rmlXQAOpRRx4sYR9mWDQz3O
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="394974638"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="394974638"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 00:39:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="700388992"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="700388992"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 10 Feb 2023 00:39:50 -0800
Message-ID: <bfbd8fe3b01539d10ff71b6c9bad5694592880be.camel@linux.intel.com>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        yu.c.zhang@linux.intel.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Date:   Fri, 10 Feb 2023 16:39:49 +0800
In-Reply-To: <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <Y+SPjkY87zzFqHLj@gao-cwp>
         <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
         <Y+UtDxPqIEeZ0sYH@google.com>
         <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 10:07 +0800, Robert Hoo wrote:
> On Thu, 2023-02-09 at 17:27 +0000, Sean Christopherson wrote:
> > On Thu, Feb 09, 2023, Robert Hoo wrote:
> > > On Thu, 2023-02-09 at 14:15 +0800, Chao Gao wrote:
> > > > On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
> > > > Please add a kvm-unit-test or kselftest for LAM, particularly
> > > > for
> > > > operations (e.g., canonical check for supervisor pointers,
> > > > toggle
> > > > CR4.LAM_SUP) which aren't covered by the test in Kirill's
> > > > series.
> > > 
> > > OK, I can explore for kvm-unit-test in separate patch set.
> > 
> > Please make tests your top priority.  Without tests, I am not going
> > to spend any
> > time reviewing this series, or any other hardware enabling
> > series[*].  I don't
> > expect KVM specific tests for everything, i.e. it's ok to to rely
> > things like
> > running VMs that utilize LAM and/or running LAM selftests in the
> > guest, but I do
> > want a reasonably thorough explanation of how all the test pieces
> > fit
> > together to
> > validate KVM's implementation.
> 
> Sure, and ack on unit test is part of development work.
> 
> This patch set had always been unit tested before sent out, i.e.
> "running LAM selftests in guest" on both ept=Y/N.
> 
> CR4.LAM_SUP, as Chao pointed out, could not be covered by kselftest,
> I
> may explore it in kvm-unit-test.
> 
When I come to kvm-unit-test, just find that I had already developed
some test case on CR4.LAM_SUP toggle and carried out on this patch set.
Just forgot about it.

Is it all right? if so, I will include it in next version.

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 3d58ef7..c6b1db6 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -105,6 +105,8 @@
 #define X86_CR4_CET            BIT(X86_CR4_CET_BIT)
 #define X86_CR4_PKS_BIT                (24)
 #define X86_CR4_PKS            BIT(X86_CR4_PKS_BIT)
+#define X86_CR4_LAM_SUP_BIT    (28)
+#define X86_CR4_LAM_SUP        BIT(X86_CR4_LAM_SUP_BIT)
 
 #define X86_EFLAGS_CF_BIT      (0)
 #define X86_EFLAGS_CF          BIT(X86_EFLAGS_CF_BIT)
@@ -248,6 +250,7 @@ static inline bool is_intel(void)
 #define        X86_FEATURE_SPEC_CTRL           (CPUID(0x7, 0, EDX,
26))
 #define        X86_FEATURE_ARCH_CAPABILITIES   (CPUID(0x7, 0, EDX,
29))
 #define        X86_FEATURE_PKS                 (CPUID(0x7, 0, ECX,
31))
+#define        X86_FEATURE_LAM                 (CPUID(0x7, 1, EAX,
26))
 
 /*
  * Extended Leafs, a.k.a. AMD defined
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f483dea..af626cc 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -34,6 +34,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
+tests += $(TEST_DIR)/lam_sup.$(exe)
 
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/lam_sup.c b/x86/lam_sup.c
new file mode 100644
index 0000000..3e05129
--- /dev/null
+++ b/x86/lam_sup.c
@@ -0,0 +1,37 @@
+#include "libcflat.h"
+#include "processor.h"
+#include "desc.h"
+
+int main(int ac, char **av)
+{
+       unsigned long cr4;
+       struct cpuid c = {0, 0, 0, 0};
+
+       c = cpuid_indexed(7, 1);
+
+       if (!(c.a & (1 << 26))) {
+               report_skip("LAM is not supported. EAX = 0x%0x", c.a);
+               abort();
+       }
+
+       report_info("set CR4.LAM_SUP(bit 28)");
+
+       cr4 = read_cr4();
+       write_cr4(cr4 | X86_CR4_LAM_SUP);
+
+       report((cr4 | X86_CR4_LAM_SUP) == read_cr4(), "Set CR4.LAM_SUP
succeeded.");
+
+       report_info("clear CR4.LAM_SUP(bit 28)");
+
+       cr4 = read_cr4();
+       write_cr4(cr4 & ~X86_CR4_LAM_SUP);
+
+       report((cr4 & ~X86_CR4_LAM_SUP) == read_cr4(), "Clear
CR4.LAM_SUP succeeded.");
+
+       return report_summary();
+}
+
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32..0c90dfe 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -478,3 +478,8 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[intel-lam]
+file = lam_sup.flat
+arch = x86_64
+extra_params = -enable-kvm -cpu host

