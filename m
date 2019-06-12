Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B842642FFA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbfFLT10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 15:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbfFLT1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 15:27:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2A263087958;
        Wed, 12 Jun 2019 19:27:25 +0000 (UTC)
Received: from flask (unknown [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id 428E260CCD;
        Wed, 12 Jun 2019 19:27:20 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Wed, 12 Jun 2019 21:27:20 +0200
Date:   Wed, 12 Jun 2019 21:27:20 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
Message-ID: <20190612192720.GB23583@flask>
References: <1560332419-17195-1-git-send-email-wanpengli@tencent.com>
 <20190612151447.GD20308@linux.intel.com>
 <20190612192243.GA23583@flask>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190612192243.GA23583@flask>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 12 Jun 2019 19:27:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-12 21:22+0200, Radim Krčmář:
> 2019-06-12 08:14-0700, Sean Christopherson:
> > On Wed, Jun 12, 2019 at 05:40:18PM +0800, Wanpeng Li wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > @@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
> > >  static int __read_mostly lapic_timer_advance_ns = -1;
> > >  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
> > >  
> > > +/*
> > > + * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.
> > > + */
> > > +u32 __read_mostly vmentry_advance_ns = 300;
> > 
> > Enabling this by default makes me nervous, e.g. nothing guarantees that
> > future versions of KVM and/or CPUs will continue to have 300ns of overhead
> > between wait_lapic_expire() and VM-Enter.
> > 
> > If we want it enabled by default so that it gets tested, the default
> > value should be extremely conservative, e.g. set the default to a small
> > percentage (25%?) of the latency of VM-Enter itself on modern CPUs,
> > VM-Enter latency being the min between VMLAUNCH and VMLOAD+VMRUN+VMSAVE.
> 
> I share the sentiment.  We definitely must not enter the guest before
> the deadline has expired and CPUs are approaching 5 GHz (in turbo), so
> 300 ns would be too much even today.
> 
> I wrote a simple testcase for rough timing and there are 267 cycles
> (111 ns @ 2.4 GHz) between doing rdtsc() right after
> kvm_wait_lapic_expire() [1] and doing rdtsc() in the guest as soon as
> possible (see the attached kvm-unit-test).

I forgot to attach it, pasting here as a patch for kvm-unit-tests.

---
diff --git a/x86/Makefile.common b/x86/Makefile.common
index e612dbe..ceed648 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -58,7 +58,7 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/vmentry_latency.flat
 
 ifdef API
 tests-api = api/api-sample api/dirty-log api/dirty-log-perf
diff --git a/x86/vmentry_latency.c b/x86/vmentry_latency.c
new file mode 100644
index 0000000..3859f09
--- /dev/null
+++ b/x86/vmentry_latency.c
@@ -0,0 +1,45 @@
+#include "x86/vm.h"
+
+static u64 get_last_hypervisor_tsc_delta(void)
+{
+	u64 a = 0, b, c, d;
+	u64 tsc;
+
+	/*
+	 * The first vmcall is there to force a vm exit just before measuring.
+	 */
+	asm volatile ("vmcall" : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
+
+	tsc = rdtsc();
+
+	/*
+	 * The second hypercall recovers the value that was stored when vm
+	 * entering to execute the rdtsc()
+	 */
+	a = 11;
+	asm volatile ("vmcall" : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
+
+	return tsc - a;
+}
+
+static void vmentry_latency(void)
+{
+	unsigned i = 1000000;
+	u64 min = -1;
+
+	while (i--) {
+		u64 latency = get_last_hypervisor_tsc_delta();
+		if (latency < min)
+			min = latency;
+	}
+
+	printf("vm entry latency is %"PRIu64" TSC cycles\n", min);
+}
+
+int main(void)
+{
+	setup_vm();
+	vmentry_latency();
+
+	return 0;
+}
