Return-Path: <kvm+bounces-42949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E38B9A812FF
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 18:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0229B4A0B5B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 16:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B40232363;
	Tue,  8 Apr 2025 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQr6zeER"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B51DF754;
	Tue,  8 Apr 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131253; cv=none; b=XG0pkoeewm4h5OLtHFhbIuu8HfF8uFPlQ1xgTSUnpyzCqTtHfIsnmHCRYcbtjLYwfwFEu2cHzWY31BoNuCSPpR+KGsVxdNWDRjqppb3KxmJy8ycp5hbxBm0cdCB6XHpkXpWEVqQXGY4FyuWI9884URKDpz6lJnTOa/3qIwIkTbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131253; c=relaxed/simple;
	bh=k11y85anIUxaVdUyWTskfFr8geLdEXxtcqSuOAf3X5A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LXL3TFGQMA8FN//6px2Hnl2QlWA8dF1AvmoAZbnOe0QKfRmExvOhNa56cNOkXsy6+yCd0EmF/YN+ccr/bfCs6cVcyT9xNHubQKYjjrQIJPtvXDveTz+7zj5H6U02VAUKmdv5WuhbO/bsDKo036/V5AChuPWr95YkxIKtBLcdpBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQr6zeER; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA875C4CEE5;
	Tue,  8 Apr 2025 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744131253;
	bh=k11y85anIUxaVdUyWTskfFr8geLdEXxtcqSuOAf3X5A=;
	h=Date:From:To:Cc:Subject:From;
	b=aQr6zeERt0iLP/IziVLHwH7jdSi7gtEWEqb8xdV2CTa2Z5MdeeA154PHGVSXXq/cB
	 z45rVeii2Ex1hV0LQyPE4wmL3TFtWtpJ69blKEdsgGBXXua/sXJ9Aq7nhNX6whzavE
	 j1VfzXTXbL88YYiFPSeBRVhkTAWFwE3vNysf4pCL588TrtrlQLQiFvVRr3MJmasnyZ
	 hYWJoDuAuXfrC+qyOsOlvdZ3FlCurcL+K2ykKdrsihJupDtevHo2F9C2m9l9E9nDOb
	 DxdXss5Sm4mFRPuyAUhTSEYvVy/kopQ7wULSpxyy1GxXuAqMpIewoy9n8u54KqNYIj
	 nkLqSmLapGptA==
Date: Tue, 8 Apr 2025 11:54:11 -0500
From: Seth Forshee <sforshee@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: kvm guests crash when running "perf kvm top"
Message-ID: <Z_VUswFkWiTYI0eD@do-x1carbon>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

A colleague of mine reported kvm guest hangs when running "perf kvm top"
with a 6.1 kernel. Initially it looked like the problem might be fixed
in newer kernels, but it turned out to be perf changes which must avoid
triggering the issue. I was able to reproduce the guest crashes with
6.15-rc1 in both the host and the guest when using an older version of
perf. A bisect of perf landed on 7b100989b4f6 "perf evlist: Remove
__evlist__add_default", but this doesn't look to be fixing any kind of
issue like this.

This box has an Ice Lake CPU, and we can reproduce on other Ice Lakes
but could not reproduce on another box with Broadwell. On Broadwell
guests would crash with older kernels in the host, but this was fixed by
971079464001 "KVM: x86/pmu: fix masking logic for
MSR_CORE_PERF_GLOBAL_CTRL". That does not fix the issues we see on Ice
Lake.

When the guests crash we aren't getting any output on the serial
console, but I got this from a memory dump:

BUG: unable to handle page fault for address: fffffe76ffbaf00000
BUG: unable to handle page fault for address: fffffe76ffbaf00000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
BUG: unable to handle page fault for address: fffffe76ffbaf00000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 2e044067 P4D 3ec42067 PUD 3ec41067 PMD 3ec40067 PTE ffffffffff120
Oops: Oops: 0002 [#1] SMP NOPTI
BUG: unable to handle page fault for address: fffffe76ffbaf00000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 2e044067 P4D 3ec42067 PUD 3ec41067 PMD 3ec40067 PTE ffffffffff120
Oops: Oops: 0002 [#2] SMP NOPTI
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.15.0-rc1 #3 VOLUNTARY
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/Incus, BIOS unknown 02/0=
2/2022
BUG: unable to handle page fault for address: fffffe76ffbaf00000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 2e044067 P4D 3ec42067 PUD 3ec41067 PMD 3ec40067 PTE ffffffffff120
Oops: Oops: 0002 [#3] SMP NOPTI
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.15.0-rc1 #3 VOLUNTARY
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/Incus, BIOS unknown 02/0=
2/2022

We got something different though from an ubuntu VM running their 6.8
kernel:

BUG: kernel NULL pointer dereference, address: 000000000000002828
BUG: kernel NULL pointer dereference, address: 000000000000002828
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10336a067 P4D 0=20
Oops: 0000 [#1] PREEMPT SMP NOPTI
BUG: kernel NULL pointer dereference, address: 000000000000002828
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10336a067 P4D 0=20
Oops: 0000 [#2] PREEMPT SMP NOPTI
BUG: kernel NULL pointer dereference, address: 000000000000002828
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10336a067 P4D 0=20
Oops: 0000 [#3] PREEMPT SMP NOPTI
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-56-generic #58-Ubuntu
BUG: kernel NULL pointer dereference, address: 000000000000002828
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10336a067 P4D 0=20
Oops: 0000 [#4] PREEMPT SMP NOPTI
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-56-generic #58-Ubuntu
BUG: kernel NULL pointer dereference, address: 000000000000002828
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10336a067 P4D 0=20
Oops: 0000 [#5] PREEMPT SMP NOPTI
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-56-generic #58-Ubuntu
RIP: 0010:__sprint_symbol.isra.0+0x6/0x120
Code: ff e8 0e 9d 00 01 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 =
90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 55 <48> 89 e5 41 57 4=
9 89 f7 41 56 4c 63 f2 4c 8d 45 b8 48 8d 55 c0 41
RSP: 0018:ff25e52d000e6ff8 EFLAGS: 00000046
BUG: #DF stack guard page was hit at 0000000040b441e1 (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)
BUG: #DF stack guard page was hit at 000000002fed44fb (stack is 00000000a17=
88787..000000008e7f4216)

CPU information from one of the boxes where we see this:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 106
model name	: Intel(R) Xeon(R) Gold 5318Y CPU @ 2.10GHz
stepping	: 6
microcode	: 0xd0003f5
cpu MHz		: 800.000
cache size	: 36864 KB
physical id	: 0
siblings	: 44
core id		: 0
cpu cores	: 22
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 27
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat =
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rd=
tscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nons=
top_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm=
2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt =
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpui=
d_fault epb cat_l3 intel_ppin ssbd mba ibrs ibpb stibp ibrs_enhanced tpr_sh=
adow flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 e=
rms invpcid cqm rdt_a avx512f avx512dq rdseed adx smap avx512ifma clflushop=
t clwb intel_pt avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 x=
saves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local split_lock_detect w=
bnoinvd dtherm ida arat pln pts hwp hwp_act_window hwp_epp hwp_pkg_req vnmi=
 avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni av=
x512_bitalg avx512_vpopcntdq la57 rdpid fsrm md_clear pconfig flush_l1d arc=
h_capabilities
vmx flags	: vnmi preemption_timer posted_intr invvpid ept_x_only ept_ad ept=
_1gb ept_5level flexpriority apicv tsc_offset vtpr mtf vapic ept vpid unres=
tricted_guest vapic_reg vid ple shadow_vmcs pml ept_violation_ve ept_mode_b=
ased_exec tsc_scaling
bugs		: spectre_v1 spectre_v2 spec_store_bypass swapgs mmio_stale_data eibr=
s_pbrsb gds bhi spectre_v2_user
bogomips	: 4000.00
clflush size	: 64
cache_alignment	: 64
address sizes	: 46 bits physical, 57 bits virtual
power management:

Let me know if I can provide any additional information or testing.

Thanks,
Seth

