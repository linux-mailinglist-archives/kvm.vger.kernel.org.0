Return-Path: <kvm+bounces-44457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD70A9DB44
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 15:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D68B1BA6995
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCA81FCFC0;
	Sat, 26 Apr 2025 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FL73MtPT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3714223C9;
	Sat, 26 Apr 2025 13:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745675146; cv=none; b=SCKtN3FU1DTzlZSmN0aTJKqG3/Usn6prS6t4s5oy5Xq76UmhKx52aTNzDzHm1Pd5hzmAFNInSCARSSS69dge7tYx7Mc/Vqy6daDXv7MULv91H5rUBol82nSd0Jw8/HLyVYtjbICvyWtPqh5TxJQazeGOFK6iWWbkfCwXxO2O10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745675146; c=relaxed/simple;
	bh=I4nsA4r/Iu57UddEcOKuVuHTuSSaO7yRpZoDOY/Qp2U=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=f6jE//5dGP+yujZDygBhxI12zfBvjAiiIrmsxv8F+/qVvJWSwkEDnJXcMj8isOy+aqgiKuXi7bsGIRTqJzOSGW+jKWbYdrDP8oBUy6IWpAoMJFHcvXaaL+IrJKMNeZxoixKhKLAFnoyhqFAUNNjURaGIpUGUw/+2LWdOinTXh80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FL73MtPT; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745675144; x=1777211144;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=I4nsA4r/Iu57UddEcOKuVuHTuSSaO7yRpZoDOY/Qp2U=;
  b=FL73MtPTIblP+GDB0e3HutmxvspsnScb1Q8MgkOg+0FgCJk83LlQX37D
   D6O2VEiAd3ZnGAPuMeiC1p+lOxC0BUoWn/yv9KlVf4JTDVYVqfnzXA+OR
   DutgC9PHVari3dsAVurAxj8alSC47O3w3xRUAYEaHX8vKl6xSDeiXOV5u
   8+fXOtcF1Mufp5d7nAAGzqNA6s/EWO5tUHxoKF/tApwjc8U0b5Odl1lhr
   5XkdHiDtLbON22C2c1d62RcP6zLnpMSStEIY8p39MDCuaMuh/sz5NYt7M
   stq1CpRZD+QdAxMzxnx04nXmArVvLbd97t0xzFj351KRhqDSXG/JM5O9T
   A==;
X-CSE-ConnectionGUID: rluqqy2OT+ujeyTWTOU9Mg==
X-CSE-MsgGUID: +oYvne6NRzqCTuyzNKfqzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47229772"
X-IronPort-AV: E=Sophos;i="6.15,241,1739865600"; 
   d="scan'208";a="47229772"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 06:45:43 -0700
X-CSE-ConnectionGUID: WMbNce1ORpCDbJZHWjGjpw==
X-CSE-MsgGUID: UaIR2HdjTjK095toUEDbGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,241,1739865600"; 
   d="scan'208";a="138223278"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 06:45:29 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Sat, 26 Apr 2025 16:45:26 +0300 (EEST)
To: Xin Li <xin@zytor.com>
cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
    linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
    virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
    linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
    linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
    Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com, 
    peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com, 
    alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
    adrian.hunter@intel.com, kan.liang@linux.intel.com, wei.liu@kernel.org, 
    ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com, 
    tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com, 
    seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com, 
    kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
    dapeng1.mi@linux.intel.com
Subject: Re: [PATCH v3 01/14] x86/msr: Move rdtsc{,_ordered}() to
 <asm/tsc.h>
In-Reply-To: <e62b81f3-1952-43e6-85fd-18c6f37d531d@zytor.com>
Message-ID: <f8a5b080-b2a8-06f0-3d2d-d232ef0887a4@linux.intel.com>
References: <20250425083442.2390017-1-xin@zytor.com> <20250425083442.2390017-2-xin@zytor.com> <42dc90e1-df2a-2324-d28c-d75fb525e4a2@linux.intel.com> <e62b81f3-1952-43e6-85fd-18c6f37d531d@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-589040720-1745675126=:944"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-589040720-1745675126=:944
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 26 Apr 2025, Xin Li wrote:

> On 4/25/2025 8:45 AM, Ilpo J=C3=A4rvinen wrote:
> > To me this looks really a random set of source files, maybe it helped s=
ome
> > build success but it's hard for me to review this because there are sti=
ll
> > cases that depend on indirect include chains.
> >=20
> > Could you just look into solving all missing msr.h includes instead
> > as clearly some are still missing after 3 pre-existing ones and you add=
ing
> > it into 3 files:
> >=20
> > $ git grep -e rdmsr -e wrmsr -l drivers/platform/x86/
> > drivers/platform/x86/intel/ifs/core.c
> > drivers/platform/x86/intel/ifs/load.c
> > drivers/platform/x86/intel/ifs/runtest.c
> > drivers/platform/x86/intel/pmc/cnp.c
> > drivers/platform/x86/intel/pmc/core.c
> > drivers/platform/x86/intel/speed_select_if/isst_if_common.c
> > drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
> > drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
> > drivers/platform/x86/intel/tpmi_power_domains.c
> > drivers/platform/x86/intel/turbo_max_3.c
> > drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
> > drivers/platform/x86/intel_ips.c
> >=20
> > $ git grep -e 'msr.h' -l drivers/platform/x86/
> > drivers/platform/x86/intel/pmc/core.c
> > drivers/platform/x86/intel/tpmi_power_domains.c
> > drivers/platform/x86/intel_ips.c
>=20
> I think you want me to add all necessary direct inclusions, right?

For asm/msr.h yes, as it seems you're altering the inclusion paths and all=
=20
non-direct includes have a chance of breaking so it seems prudent to just=
=20
convert them into direct includes.

> This is the right thing to do, and I did try it but gave up later.
>=20
> I will do it in the next iteration as you asked.  But I want to make my
> points:
>=20
> 1) It's not just two patterns {rd,wr}msr, there are a lot of definitions
>    in <asm/msr.h> and we need to cover all of them:

I know and I don't expect you to get it 100% perfect, but taking a major=20
step into the right direction would be way better than build testing one=20
configuration and see what blows up and fix only those.

In this particular case, the amount of includes seemed really subpar with=
=20
many users lacking the include.

>       struct msr_info
>       struct msr_regs_info
>       struct saved_msr
>       struct saved_msrs

Could be shortened to -e 'struct msr' -e 'struct saved_msr'.

>       {read,write}_msr
>       rdpmc
>       .*msr.*_on_cpu

Well, my pattern already caught rdmsr.*on_cpu and wrmsr.*on_cpu.

For the other patterns, I don't see those at all under=20
drivers/platform/x86/ but I think when one typically implies the=20
others tend appear as well so this might not be as hard as it seems.

> 2) Once all necessary direct inclusions are in place, it's easy to
>    overlook adding a header inclusion in practice, especially if the
>    build passes.  Besides we often forget to remove a header when a
>    definition is removed.  In other words, direct inclusion is hard to
>    maintain.

This is true as well but we should still try to move towards the right=20
state affairs even if we will not get it near 100% until there's a real=20
tool that relentlessly keeps exposing such human oversight.

And do I try to check also includes whenever I remember while reviewing=20
patches (which requires some effort as they are not visible in the code=20
context and might not appear in a patch at all).

> 3) Some random kernel configuration combinations can cause the current
>    kernel build to fail.  I hit one in x86 UML.

Yes, which why direct including is much better than relying on fragile=20
indirects.

> We all know Ingo is the best person to discuss this with :).  While my
> understanding of the header inclusion issue may be inaccurate or
> outdated.
>=20
> So for me, using "make allyesconfig" is a practical method for a quick
> local build check, plus I always send my patches to Intel LKP.

Even with LKP, randconfig builds may still require many tests to find=20
issues.

> There probably wants a script that identifies all files that reference a
> definition in a header thus need to include it explicitly.  And indirect
> includes should be zapped.

Sadly, the clang based include-what-you-use tool is not yet there for=20
the kernel AFAIK.

--=20
 i.

--8323328-589040720-1745675126=:944--

