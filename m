Return-Path: <kvm+bounces-47382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC5AAC0F87
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A77FA1BA3C76
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04CE028FFCE;
	Thu, 22 May 2025 15:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ob8QSjF8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B5A28C2DE;
	Thu, 22 May 2025 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926639; cv=none; b=fE5J5w67ArisH7k0DcjsCleaUZEY0KKhPGZ761XCiLswG/T8q1uQADGPFKkKjKsaGfHYYpHXqn2/HTFsCMT9atRBwIqcdct/uMOC7bOdBcv8DZRGdIrAutO4R863FEVXuXHhytw+6CPGuDn7uQ5XUiKtm+6x3j/bbQmCL156GSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926639; c=relaxed/simple;
	bh=wf41/MbbIQ+TsogV3cK9E6jg8W1a4fQE5ZpT5ZBBEXM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VkE1rXkkwTk3JBdhbBCPddihQvzp2vSuwAcma4rypyYIZriNBDUvS0E8MFdsBESjbS9bQMqNFs9Wnalz1BH9KWziupu31G1WBzs6HbVxfP5sdCGpLHn7T9ZzPEUanECVhhDaq0YtP+pWRKjDYaJxaWAHk/i1mQOnWPw+VYQSEAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ob8QSjF8; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747926638; x=1779462638;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wf41/MbbIQ+TsogV3cK9E6jg8W1a4fQE5ZpT5ZBBEXM=;
  b=Ob8QSjF88+IKSmwtAfaIodle5EYMlzMAfLwxcNnuoVe62SXh3MgBLdJ3
   vWmhPTE9qz6gSaTMS+nGjlC4Wpc4aNWLOYdYHMP4NqaDDtqdjp8QaoHv0
   kEobs8wcloqADJ6vB1Hrk85zSPkA0qUbZbcDXGP4vvre8AtjpFo0SmzKc
   ngrFg1jbXKzQVu3pWbU1Zt8xKqglpSO00Cj3xfXgDT3JNETP/PS2rtlR2
   a0Be5FnJqdBLAEgceHVJ8LEPuhTIkclwMVcaajA620Y0G4D5w4lMMdBUN
   QdL3GSbSXKPeTLaFJ6QqOSY46Od9MJB3/QAXqG4NJt/pMeTma6nW8e1Ms
   Q==;
X-CSE-ConnectionGUID: qZPdbKqhTKm9Fomv3UXTPQ==
X-CSE-MsgGUID: Fi//fnM9Qtej3+lt5M7BVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61006648"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61006648"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:37 -0700
X-CSE-ConnectionGUID: AgKCE3YUSWOORf9HYI7wUg==
X-CSE-MsgGUID: NQ7rJRQlTom4ecAFFz9m5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171627588"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:36 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: [PATCH v8 0/6] Introduce CET supervisor state support
Date: Thu, 22 May 2025 08:10:03 -0700
Message-ID: <20250522151031.426788-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Dear maintainers and reviewers,

I kindly request your consideration for merging this series. Most of
patches have received Reviewed-by/Acked-by tags.

Thanks Chang, Rick, Xin, Sean and Dave for their help with this series.

== Changelog ==
v7->v8:
 - refine the comment in __fpstate_reset() (Sean)
 - provide helpers to provide default feature masks for host and
   guest FPUs (Sean)
 - v7: https://lore.kernel.org/kvm/20250512085735.564475-1-chao.gao@intel.com/

== Background ==

CET defines two register states: CET user, which includes user-mode control
registers, and CET supervisor, which consists of shadow-stack pointers for
privilege levels 0-2.

Current kernel disables shadow stacks in kernel mode, making the CET
supervisor state unused and eliminating the need for context switching.

== Problem ==

To virtualize CET for guests, KVM must accurately emulate hardware
behavior. A key challenge arises because there is no CPUID flag to indicate
that shadow stack is supported only in user mode. Therefore, KVM cannot
assume guests will not enable shadow stacks in kernel mode and must
preserve the CET supervisor state of vCPUs.

== Solution ==

An initial proposal to manually save and restore CET supervisor states
using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
its impact on KVM's ABI. Instead, leveraging the kernel's FPU
infrastructure for context switching was favored [1].

The main question then became whether to enable the CET supervisor state
globally for all processes or restrict it to vCPU processes. This decision
involves a trade-off between a 24-byte XSTATE buffer waste for all non-vCPU
processes and approximately 100 lines of code complexity in the kernel [2].
The agreed approach is to first try this optimal solution [3], i.e.,
restricting the CET supervisor state to guest FPUs only and eliminating
unnecessary space waste.

Key changes in this series are:

1) Fix existing issue regarding enabling guest supervisor states support.
2) Add default features and size for guest FPUs.
3) Add infrastructure to support guest-only features.
4) Add CET supervisor state as the first guest-only feature.

With the series in place, guest FPUs have xstate_bv[12] == xcomp_bv[12] == 1
and CET supervisor state is saved/reloaded when xsaves/xrstors executes on
guest FPUs. non-guest FPUs have xstate_bv[12] == xcomp_bv[12] == 0, then
CET supervisor state is not saved/restored.

== Performance ==

We measured context-switching performance with the benchmark [4] in following
three cases.

case 1: the baseline. i.e., this series isn't applied
case 2: baseline + this series. CET-S space is allocated for guest fpu only.
case 3: baseline + allocate CET-S space for all tasks. Hardware init
        optimization avoids writing out CET-S space on each XSAVES.

The performance differences in the three cases are very small and fall within the
run-to-run variation.

[1]: https://lore.kernel.org/kvm/ZM1jV3UPL0AMpVDI@google.com/
[2]: https://lore.kernel.org/kvm/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/
[3]: https://lore.kernel.org/kvm/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/
[4]: https://github.com/antonblanchard/will-it-scale/blob/master/tests/context_switch1.c



Chao Gao (4):
  x86/fpu/xstate: Differentiate default features for host and guest FPUs
  x86/fpu: Initialize guest FPU permissions from guest defaults
  x86/fpu: Initialize guest fpstate and FPU pseudo container from guest
    defaults
  x86/fpu: Remove xfd argument from __fpstate_reset()

Yang Weijiang (2):
  x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
  x86/fpu/xstate: Add CET supervisor xfeature support as a guest-only
    feature

 arch/x86/include/asm/fpu/types.h  | 49 ++++++++++++++++++++++++----
 arch/x86/include/asm/fpu/xstate.h |  9 ++++--
 arch/x86/kernel/fpu/core.c        | 53 +++++++++++++++++++++++--------
 arch/x86/kernel/fpu/init.c        |  1 +
 arch/x86/kernel/fpu/xstate.c      | 40 +++++++++++++++++++----
 5 files changed, 122 insertions(+), 30 deletions(-)


base-commit: 5d7e238ec229cadaeda63b5f96b4ee90bac489e4
-- 
2.47.1


