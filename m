Return-Path: <kvm+bounces-17887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1738CB6A8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0295CB21D55
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1789A5476B;
	Wed, 22 May 2024 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="trZBdNVk"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54592290F;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337118; cv=none; b=F/HMkc7qQYPtlGgY+EoE2OgO/+kNMtfWCgMwPMTPc6FDeqyQs0fFR1HV1d3zN6F9a5CVqtjzFpW9NkwZI0PWsQksg7jIWzD+9l7/eK4FOmtivIftX0DSSfrs4Sh4xuLnC/uaWMLNF1Fh7vwGd7baAWst9TZwvOGMvbN6zhwXC0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337118; c=relaxed/simple;
	bh=i70bK26YTpbLHrHjp4PIPhrdFTO9m5AUpbQPwhNvTAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m9KRC4AEajc8NXwf2yJGwhU8ntY2meMeiWevPQ7mozECGxMOb5NjI2WUqkaOcoK8mBI1f2ttqB/UHvCepMnfprzxTFSLrAasIXdsKyVlduInY2ZhzKwBFonhzkCd4l+LGqUlUR3weGXzf6KIZYcuPTU6iIj+zcPzoB1vQgV6g7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=trZBdNVk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4/r8tox2hKRCSET1svgANSR8IiriUmTqewsrNclFBAQ=; b=trZBdNVkJzuEAc+k73lQqe7nTn
	Utk9V0wAKd1XnkXDF1lnwmiax9LFeCOQkARPY0JVTvjM6e1HqlfmfLhti1gFCrdhSKv9I9PxjxhX0
	an1j9yWtfTkRjo5x8X0ADc41y2pdjyLHgUf+zEiljIz/ljIXq6z0o91Ay8EZjcMVBLfbFw3VAPWwo
	2+O0FodNsD2m2hnqz3aMrLMy33DsVOlPk1ikdiKCbp//Gpkd71EiAG9XR5e7kAvzGaVkgUeQ02SC1
	VbBJf5sXsIG8ZU79MF83cEbq2SPkWKILJNHNzpCIsIp/CgXF7iExwC+4ZQRYC+et/p8LgIZYNe2Vf
	bV4xxMmA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgR-00000000815-3bjR;
	Wed, 22 May 2024 00:18:19 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgR-00000002b4B-1ZE4;
	Wed, 22 May 2024 01:18:19 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paul Durrant <paul@xen.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jalliste@amazon.co.uk,
	sveith@amazon.de,
	zide.chen@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [RFC PATCH v3 00/21] Cleaning up the KVM clock mess
Date: Wed, 22 May 2024 01:16:55 +0100
Message-ID: <20240522001817.619072-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Clean up the KVM clock mess somewhat so that it is either based on the guest
TSC ("master clock" mode), or on the host CLOCK_MONOTONIC_RAW in cases where
the TSC isn't usable.

Eliminate the third variant where it was based directly on the *host* TSC,
due to bugs in e.g. __get_kvmclock().

Kill off the last vestiges of the KVM clock being based on CLOCK_MONOTONIC
instead of CLOCK_MONOTONIC_RAW and thus being subject to NTP skew.

Fix up migration support to allow the KVM clock to be saved/restored as an
arithmetic function of the guest TSC, since that's what it actually is in
the *common* case so it can be migrated precisely. Or at least to within
±1 ns which is good enough, as discussed in
https://lore.kernel.org/kvm/c8dca08bf848e663f192de6705bf04aa3966e856.camel@infradead.org

In v2 of this series, TSC synchronization is improved and simplified a bit
too, and we allow masterclock mode to be used even when the guest TSCs are
out of sync, as long as they're running at the same *rate*. The different
*offset* shouldn't matter.

And the kvm_get_time_scale() function annoyed me by being entirely opaque,
so I studied it until my brain hurt and then added some comments.

In v2 I also dropped the commits which were removing the periodic clock
syncs. In v3 I put them back again but *only* for the non-masterclock
mode, along with cleaning up some other gratuitous clock jumps while in
masterclock mode. And Jack's patch to move the pvclock structure to uapi.

I also fixed the bug pointed out by Chenyi Qiang, that I was failing to
set vcpu->arch.this_tsc_{nsec,write} after removing the cur_tsc_* fields.

I also included patches to fix advertised steal time going backwards, and
to make the guest more resilient to it. Those may end up being split out
and submitted under separate cover (with selftests).

Still needs more comprehensive selftests.

David Woodhouse (18):
      KVM: x86/xen: Do not corrupt KVM clock in kvm_xen_shared_info_init()
      KVM: x86: Improve accuracy of KVM clock when TSC scaling is in force
      KVM: x86: Explicitly disable TSC scaling without CONSTANT_TSC
      KVM: x86: Add KVM_VCPU_TSC_SCALE and fix the documentation on TSC migration
      KVM: x86: Avoid NTP frequency skew for KVM clock on 32-bit host
      KVM: x86: Fix KVM clock precision in __get_kvmclock()
      KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
      KVM: x86: Simplify and comment kvm_get_time_scale()
      KVM: x86: Remove implicit rdtsc() from kvm_compute_l1_tsc_offset()
      KVM: x86: Improve synchronization in kvm_synchronize_tsc()
      KVM: x86: Kill cur_tsc_{nsec,offset,write} fields
      KVM: x86: Allow KVM master clock mode when TSCs are offset from each other
      KVM: x86: Factor out kvm_use_master_clock()
      KVM: x86: Avoid global clock update on setting KVM clock MSR
      KVM: x86: Avoid gratuitous global clock reload in kvm_arch_vcpu_load()
      KVM: x86: Avoid periodic KVM clock updates in master clock mode
      KVM: x86/xen: Prevent runstate times from becoming negative
      sched/cputime: Cope with steal time going backwards or negative

Jack Allister (3):
      KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for accurate KVM clock migration
      UAPI: x86: Move pvclock-abi to UAPI for x86 platforms
      KVM: selftests: Add KVM/PV clock selftest to prove timer correction

 Documentation/virt/kvm/api.rst                    |  37 ++
 Documentation/virt/kvm/devices/vcpu.rst           | 115 +++-
 arch/x86/include/asm/kvm_host.h                   |  15 +-
 arch/x86/include/uapi/asm/kvm.h                   |   6 +
 arch/x86/include/{ => uapi}/asm/pvclock-abi.h     |  24 +-
 arch/x86/kvm/svm/svm.c                            |   3 +-
 arch/x86/kvm/vmx/vmx.c                            |   2 +-
 arch/x86/kvm/x86.c                                | 716 +++++++++++++++-------
 arch/x86/kvm/xen.c                                |  22 +-
 include/uapi/linux/kvm.h                          |   3 +
 kernel/sched/cputime.c                            |  20 +-
 tools/testing/selftests/kvm/Makefile              |   1 +
 tools/testing/selftests/kvm/x86_64/pvclock_test.c | 192 ++++++
 13 files changed, 884 insertions(+), 272 deletions(-)


