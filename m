Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8C4379A2
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhJVPMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:12:31 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:39218 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233281AbhJVPM1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:12:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UtHMhrZ_1634915407;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UtHMhrZ_1634915407)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 23:10:08 +0800
Date:   Fri, 22 Oct 2021 23:10:07 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: some fixes about RDMSR/WRMSR instruction
 emulation
Message-ID: <20211022151007.GB9730@k08j02272.eu95sqa>
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
 <bebc39f8-0ebc-c8cb-413e-bb4e30397057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bebc39f8-0ebc-c8cb-413e-bb4e30397057@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021 at 11:46:17AM +0200, Paolo Bonzini wrote:
> On 22/10/21 04:59, Hou Wenlong wrote:
> >When KVM_CAP_X86_USER_SPACE_MSR cap is enabled, userspace can control
> >MSR accesses. In normal scenario, RDMSR/WRMSR can be interceped, but
> >when kvm.force_emulation_prefix is enabled, RDMSR/WRMSR with kvm prefix
> >would trigger an UD and cause instruction emulation. If MSR accesses is
> >filtered, em_rdmsr()/em_wrmsr() returns X86EMUL_IO_NEEDED, but it is
> >ignored by x86_emulate_instruction(). Then guest continues execution,
> >but RIP has been updated to point to RDMSR/WRMSR in handle_ud(), so
> >RDMSR/WRMSR can be interceped and guest exits to userspace finnaly by
> >mistake. Such behaviour leads to two vm exits and wastes one instruction
> >emulation.
> >
> >After let x86_emulate_instruction() returns 0 for RDMSR/WRMSR emulation,
> >if it needs to exit to userspace, its complete_userspace_io callback
> >would call kvm_skip_instruction() to skip instruction. But for vmx,
> >VMX_EXIT_INSTRUCTION_LEN in vmcs is invalid for UD, it can't be used to
> >update RIP, kvm_emulate_instruction() should be used instead. As for
> >svm, nRIP in vmcb is 0 for UD, so kvm_emulate_instruction() is used.
> >But for nested svm, I'm not sure, since svm_check_intercept() would
> >change nRIP.
> 
> Hi, can you provide a testcase for this bug using the
> tools/testing/selftests/kvm framework?
> 
> Thanks,
> 
> Paolo
Hi, Paolo

There is already a testcase in kvm selftests
(test_msr_filter_allow() in tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c),
which is mentioned in Patch 2.

In that testcase, it tests MSR accesses emulation with
kvm.force_emulation_prefix enabled, and it is passed. But I think
the logic may be not right. As I explained in Patch 2,
x86_emulate_instruction() ignored X86EMUL_IO_NEEDED, so guest would
continue execution, but RIP had been updated to point to RDMSR/WRMSR
in handle_ud(). Then RDMSR/WRMSR would be intercepted and guest could
exit to userspace later. Although the final result seemed to be right,
it wasted the instruction emulation in the first vm exit.

