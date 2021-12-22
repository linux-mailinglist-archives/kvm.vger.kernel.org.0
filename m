Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE8A47CEFD
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 10:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243827AbhLVJRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 04:17:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:16305 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243837AbhLVJR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 04:17:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640164649; x=1671700649;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rXCtJUBxqPox6jugTX1tFPWuCUUtyI4++IV9Eigc/+o=;
  b=bvYBrYFs7IDzw8ORmGyze07KoN7qBBQYGQyv2iY7peHL+tihwjP2/z+S
   8qAYG8BXiAGgFypQfC2jWgOs9dz0BO+BK0w1mbp9OldoS0dePDPnmgiao
   kSx73TbU0Z5ZMJVfXIKVZ9T2+0/ge8IFBUp950dyfr7aPCsZCaE4IcDD5
   abMIcGyVlfLvT4559FMpmzrR05IdQRc2PTEo03xd6LqxvZNUL+QLg+nHl
   SCoR1F1Q7S7QAqRtKEw6xU0f3XMwMc6A5o5gPghp6fOWFflXNxxbbHiTM
   IsxBcSodPlhmo2MFcXu7yHAxLSozd8X6dcRmxVzK/wvZR9ZVbHNGjGrMq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="303954183"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="303954183"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 01:17:29 -0800
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="521608108"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 22 Dec 2021 01:17:26 -0800
Date:   Wed, 22 Dec 2021 17:02:25 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, jun.nakajima@intel.com,
        kevin.tian@intel.com, jing2.liu@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 3/3] selftest: Support amx selftest
Message-ID: <20211222090225.GA8515@yangzhon-Virtual>
References: <20211221231507.2910889-1-yang.zhong@intel.com>
 <20211221231507.2910889-4-yang.zhong@intel.com>
 <65dd75c0-e0fd-28d2-f5b5-920772b6e791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65dd75c0-e0fd-28d2-f5b5-920772b6e791@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 21, 2021 at 06:36:17PM +0100, Paolo Bonzini wrote:
> On 12/22/21 00:15, Yang Zhong wrote:
> >This selftest do two test cases, one is to trigger #NM
> >exception and check MSR XFD_ERR value. Another case is
> >guest load tile data into tmm0 registers and trap to host
> >side to check memory data after save/restore.
> >
> >Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> 
> This is a great start, mainly I'd add a lot more GUEST_SYNCs.
> 
> Basically any instruction after the initial GUEST_ASSERTs are a
> potential point for GUEST_SYNC, except right after the call to
> set_tilecfg:
> 
> GUEST_SYNC(1)
> 
> >+	/* xfd=0, enable amx */
> >+	wrmsr(MSR_IA32_XFD, 0);
> 
> GUEST_SYNC(2)
> 
> >+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == 0);
> >+	set_tilecfg(amx_cfg);
> >+	__ldtilecfg(amx_cfg);
> 
> GUEST_SYNC(3)
 
   Paolo, with this GUEST_SYNC(3) between __ldtilecfg and __tileloadd
   instructions, the guest code generate (vector:0x6, Invalid Opcode) 
   exception, which is a strange issue. thanks!

   Yang   


> 
> >+	/* Check save/restore when trap to userspace */
> >+	__tileloadd(tiledata);
> >+	GUEST_SYNC(1);
> 
> This would become 4; here add tilerelease+GUEST_SYNC(5)+XSAVEC, and
> check that state 18 is not included in XCOMP_BV.
>
     
   Thanks Paolo, the new code like below:

    GUEST_SYNC(5);
    /* bit 18 not in the XCOMP_BV after xsavec() */
    set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
     __xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
    GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA) == 0)


    Yang

 
> >+	/* xfd=0x40000, disable amx tiledata */
> >+	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
> 
> GUEST_SYNC(6)
> 
> >+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
> >+	set_tilecfg(amx_cfg);
> >+	__ldtilecfg(amx_cfg);
> >+	/* Trigger #NM exception */
> >+	__tileloadd(tiledata);
> 
> GUEST_SYNC(10); this final GUEST_SYNC should also check TMM0 in the host.
> 
> >+	GUEST_DONE();
> >+}
> >+
> >+void guest_nm_handler(struct ex_regs *regs)
> >+{
> >+	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
> 
> GUEST_SYNC(7)
> 
> >+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> >+	/* Clear xfd_err */
> 
> Same here, I'd do a GUEST_SYNC(8) and re-read MSR_IA32_XFD_ERR.
> 
> >+	wrmsr(MSR_IA32_XFD_ERR, 0);
> >+	GUEST_SYNC(2);
> 
   
    This need add regs->rip +=3 to skip __tileloadd() instruction(generate #NM) 
    when VM resume from GUEST_SYNC(9).

    Thanks!

    Yang


> This becomes GUEST_SYNC(9).
> 
> >+}
> 
> 
> >+		case UCALL_SYNC:
> >+			switch (uc.args[1]) {
> >+			case 1:
> >+				fprintf(stderr,
> >+					"Exit VM by GUEST_SYNC(1), check save/restore.\n");
> >+
> >+				/* Compacted mode, get amx offset by xsave area
> >+				 * size subtract 8K amx size.
> >+				 */
> >+				amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
> >+				state = vcpu_save_state(vm, VCPU_ID);
> >+				void *amx_start = (void *)state->xsave + amx_offset;
> >+				void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
> >+				/* Only check TMM0 register, 1 tile */
> >+				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
> >+				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d\n", ret);
> >+				kvm_x86_state_cleanup(state);
> >+				break;
> 
> All GUEST_SYNCs should do save_state/load_state like state_test.c.
> Then of course you can *also* check TMM0 after __tileloadd, which
> would be cases 4 and 10.
> 

  Yes, the new code will add save_state/load_state as in the state_test.c file.

  Thanks!

  Yang



> Thanks,
> 
> Paolo
> 
> >+			case 2:
> >+				fprintf(stderr,
> >+					"Exit VM by GUEST_SYNC(2), generate #NM exception.\n");
> >+				goto done;
> >+			}
> >+			break;
> >+		case UCALL_DONE:
> >+			goto done;
> >+		default:
> >+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> >+		}
> >+	}
> >+done:
> >+	kvm_vm_free(vm);
> >+}
> >
