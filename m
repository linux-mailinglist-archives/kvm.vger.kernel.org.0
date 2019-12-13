Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E16121A64
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 21:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfLPUBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 15:01:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50458 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbfLPUBF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 15:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576526464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xa61T8y0JraKLOEIfs1XX0hxvV12aD4G8wd1zxbgSRI=;
        b=SGBbgqLQwWn7AeZ+XaNNkXMmMl3oPW4Q3yerK6Rb+6r9I+8a2fBy/7gDQtH3h/ZkFuOba0
        nBrnxGQjMTBtGsy+tq2kcVnb+S7NqtgNPMNYGNZZuJ4c4vzRWKBt9zI1yqMBfe5NU9PCGc
        RqJvLML3s7xW5ENUgT+Opx27g3uc0mo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-MBiXdzYWMd63jkwrNbXKiA-1; Mon, 16 Dec 2019 15:01:00 -0500
X-MC-Unique: MBiXdzYWMd63jkwrNbXKiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04CBA91230;
        Mon, 16 Dec 2019 20:00:59 +0000 (UTC)
Received: from localhost (ovpn-116-90.gru2.redhat.com [10.97.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E64260933;
        Mon, 16 Dec 2019 20:00:56 +0000 (UTC)
Date:   Fri, 13 Dec 2019 19:27:02 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, konrad.wilk@oracle.com
Subject: Re: [PATCH 1/3] KVM: x86: fix reporting of AMD speculation bug CPUID
 leaf
Message-ID: <20191213222702.GH498046@habkost.net>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
 <1566376002-17121-2-git-send-email-pbonzini@redhat.com>
 <20191130232731.GA9495@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191130232731.GA9495@sol.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 30, 2019 at 03:27:31PM -0800, Eric Biggers wrote:
> Hi Paolo,
> 
> On Wed, Aug 21, 2019 at 10:26:40AM +0200, Paolo Bonzini wrote:
> > The AMD_* bits have to be set from the vendor-independent
> > feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
> > about the vendor and they should be set on Intel processors as well.
> > On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
> > VIRT_SSBD does not have to be added manually because it is a
> > cpufeature that comes directly from the host's CPUID bit.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 22c2720cd948..43caeb6059b9 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -729,18 +729,23 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >  			g_phys_as = phys_as;
> >  		entry->eax = g_phys_as | (virt_as << 8);
> >  		entry->edx = 0;
> > +		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
> > +		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
> >  		/*
> > -		 * IBRS, IBPB and VIRT_SSBD aren't necessarily present in
> > -		 * hardware cpuid
> > +		 * AMD has separate bits for each SPEC_CTRL bit.
> > +		 * arch/x86/kernel/cpu/bugs.c is kind enough to
> > +		 * record that in cpufeatures so use them.
> >  		 */
> > -		if (boot_cpu_has(X86_FEATURE_AMD_IBPB))
> > +		if (boot_cpu_has(X86_FEATURE_IBPB))
> >  			entry->ebx |= F(AMD_IBPB);
> > -		if (boot_cpu_has(X86_FEATURE_AMD_IBRS))
> > +		if (boot_cpu_has(X86_FEATURE_IBRS))
> >  			entry->ebx |= F(AMD_IBRS);
> > -		if (boot_cpu_has(X86_FEATURE_VIRT_SSBD))
> > -			entry->ebx |= F(VIRT_SSBD);
> > -		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
> > -		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
> > +		if (boot_cpu_has(X86_FEATURE_STIBP))
> > +			entry->ebx |= F(AMD_STIBP);
> > +		if (boot_cpu_has(X86_FEATURE_SSBD))
> > +			entry->ebx |= F(AMD_SSBD);
> > +		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
> > +			entry->ebx |= F(AMD_SSB_NO);
> >  		/*
> >  		 * The preference is to use SPEC CTRL MSR instead of the
> >  		 * VIRT_SPEC MSR.
> 
> This patch started causing a warning about an unchecked MSR access, when
> starting a VM.
> 
> Processor is: "AMD Ryzen Threadripper 1950X 16-Core Processor"
> 
> The warning appears both in the host and guest kernel logs.
> 
> On the host:
> 
> 	[   12.121802] unchecked MSR access error: RDMSR from 0x48 at rIP: 0xffffffff8b049765 (svm_vcpu_run+0x6a5/0x720)
> 	[   12.121806] Call Trace:
> 	[   12.121812]  ? kvm_arch_vcpu_ioctl_run+0x902/0x1b70
> 	[   12.121814]  ? kvm_vm_ioctl_irq_line+0x1e/0x30
> 	[   12.121817]  ? kvm_vcpu_ioctl+0x21e/0x560
> 	[   12.121821]  ? vfs_writev+0xc0/0xf0
> 	[   12.121824]  ? do_vfs_ioctl+0x41d/0x690
> 	[   12.121826]  ? ksys_ioctl+0x59/0x90
> 	[   12.121827]  ? __x64_sys_ioctl+0x11/0x20
> 	[   12.121828]  ? do_syscall_64+0x43/0x130
> 	[   12.121832]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

For reference, this is:

	/*
	 * We do not use IBRS in the kernel. If this vCPU has used the
	 * SPEC_CTRL MSR it may have left it on; save the value and
	 * turn it off. This is much more efficient than blindly adding
	 * it to the atomic save/restore list. Especially as the former
	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
	 *
	 * For non-nested case:
	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
	 * save it.
	 *
	 * For nested case:
	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
	 * save it.
	 */
	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);

This code looks suspicious.  I don't see anything that would
prevent the kernel from trying to read the MSR on CPUs that don't
have X86_FEATURE_AMD_SSBD (CPUID[0x80000008].EBX[24]) set.

Maybe it's a preexisting bug being triggered by the failing WRMSR
below:

> 
> On the guest:
> 
> 	[    0.799090] unchecked MSR access error: WRMSR to 0x48 (tried to write 0x0000000000000004) at rIP: 0xffffffff81028272 (speculation_ctrl_update+0x132/0x2c0)

It looks like WRMSR is being rejected because of:

		if (!msr->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
			return 1;

My guess is that the actual bug is at do_cpuid_7_mask(), which
enables SPEC_CTRL and SPEC_CTRL_SSBD even on AMD hosts, while the
SVM MSR emulation code won't let guests write to
MSR_IA32_SPEC_CTRL.  I don't understand why it was not causing
any problems before commit 4c6903a0f9d76, though

Can you show output of 'x86info -r' and /proc/cpuinfo in both the
host and the guest?


> 	[    0.801823] Call Trace:
> 	[    0.801831]  ? seccomp_set_mode_filter+0x18d/0x800
> 	[    0.801833]  speculation_ctrl_update_current+0x21/0x30
> 	[    0.801837]  task_update_spec_tif+0x1d/0x20
> 	[    0.801839]  ssb_prctl_set+0xb5/0xd0
> 	[    0.801841]  arch_seccomp_spec_mitigate+0x2a/0x50
> 	[    0.801843]  seccomp_set_mode_filter+0x788/0x800
> 	[    0.801845]  do_seccomp+0x34/0x200
> 	[    0.801849]  __x64_sys_seccomp+0x15/0x20
> 	[    0.801852]  do_syscall_64+0x4a/0x1f0
> 	[    0.809349]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 	[    0.810548] RIP: 0033:0x7f431db92e9d
> 	[    0.811528] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b3 5f 0c 00 f7 d8 64 89 01 48
> 	[    0.814754] RSP: 002b:00007ffca5506788 EFLAGS: 00000246 ORIG_RAX: 000000000000013d
> 	[    0.816075] RAX: ffffffffffffffda RBX: 0000556956c07580 RCX: 00007f431db92e9d
> 	[    0.817367] RDX: 0000556956c023e0 RSI: 0000000000000000 RDI: 0000000000000001
> 	[    0.818698] RBP: 0000556956c023e0 R08: 0000000000000007 R09: 0000556956b73730
> 	[    0.819948] R10: 0000556956b7101a R11: 0000000000000246 R12: 000000000000002d
> 	[    0.821184] R13: 0040000000002001 R14: 00007f431d9b4898 R15: 0000000000000000
> 
> The VM still boots though.
> 
> I've actually been seeing this for a while but haven't had a chance to bisect it
> until now.
> 
> Reverting the commit (4c6903a0f9d76) on mainline makes the warnings go away.
> 
> Any ideas?  Presumably something isn't working as intended.
> 
> - Eric
> 

-- 
Eduardo

