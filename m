Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B210B25B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 16:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfK0PYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 10:24:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:60744 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0PYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 10:24:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 07:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,249,1571727600"; 
   d="scan'208";a="206803778"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 27 Nov 2019 07:24:09 -0800
Date:   Wed, 27 Nov 2019 07:24:09 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191127152409.GC18530@linux.intel.com>
References: <20191120181913.GA11521@linux.intel.com>
 <7F99D4CD-272D-43FD-9CEE-E45C0F7C7910@djy.llc>
 <20191120192843.GA2341@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191120192843.GA2341@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 11:28:43AM -0800, Sean Christopherson wrote:
> On Wed, Nov 20, 2019 at 02:04:38PM -0500, Derek Yerger wrote:
> > 
> > > Debug patch attached.  Hopefully it finds something, it took me an
> > > embarassing number of attempts to get correct, I kept screwing up checking
> > > a bit number versus checking a bit mask...
> > > <0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch>
> > 
> > Should this still be tested despite Wanpeng Li’s comments that the issue may
> > have been fixed in a 5.3 release candidate?
> 
> Yes.
> 
> The actual bug fix, commit e751732486eb3 (KVM: X86: Fix fpu state crash in
> kvm guest), is present in v5.2.7.
> 
> Unless there's a subtlety I'm missing, commit d9a710e5fc4941 (KVM: X86:
> Dynamically allocate user_fpu) is purely an optimization and should not
> have a functional impact.

---

Any chance the below change fixes your issue?  It's a bug fix for AVX
corruption during signal delivery[*].  It doesn't seem like the same thing
you are seeing, but it's worth trying.

[*] https://lkml.kernel.org/r/20191127124243.u74osvlkhcmsskng@linutronix.de/

 arch/x86/include/asm/fpu/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 4c95c365058aa..44c48e34d7994 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -509,7 +509,7 @@ static inline void __fpu_invalidate_fpregs_state(struct fpu *fpu)
 
 static inline int fpregs_state_valid(struct fpu *fpu, unsigned int cpu)
 {
-	return fpu == this_cpu_read_stable(fpu_fpregs_owner_ctx) && cpu == fpu->last_cpu;
+	return fpu == this_cpu_read(fpu_fpregs_owner_ctx) && cpu == fpu->last_cpu;
 }
