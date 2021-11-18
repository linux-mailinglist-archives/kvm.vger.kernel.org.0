Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA441455B4F
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 13:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344605AbhKRMPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 07:15:21 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55727 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344576AbhKRMOI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 07:14:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---0UxC5c95_1637237466;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UxC5c95_1637237466)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 20:11:07 +0800
Date:   Thu, 18 Nov 2021 20:11:06 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: some fixes about msr access emulation
Message-ID: <20211118121106.GA10965@k08j02272.eu95sqa>
Reply-To: cover.1635842679.git.houwenlong93@linux.alibaba.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping

Thanks
Hou

On 2021/11/2 17:15, Hou Wenlong wrote:
> From: Hou Wenlong <houwenlong93@linux.alibaba.com>
> 
> When KVM_CAP_X86_USER_SPACE_MSR cap is enabled, userspace can control
> MSR accesses. In normal scenario, RDMSR/WRMSR can be interceped, but
> when kvm.force_emulation_prefix is enabled, RDMSR/WRMSR with kvm prefix
> would trigger an UD and cause instruction emulation. If MSR accesses is
> filtered, em_rdmsr()/em_wrmsr() returns X86EMUL_IO_NEEDED, but it is
> ignored by x86_emulate_instruction(). Then guest continues execution,
> but RIP has been updated to point to RDMSR/WRMSR in handle_ud(), so
> RDMSR/WRMSR can be interceped and guest exits to userspace finnaly by
> mistake. Such behaviour leads to two vm exits and wastes one instruction
> emulation.
> 
> After let x86_emulate_instruction() returns 0 for RDMSR/WRMSR emulation,
> if it needs to exit to userspace, its complete_userspace_io callback
> would call kvm_skip_instruction() to skip instruction. But for vmx,
> VMX_EXIT_INSTRUCTION_LEN in vmcs is invalid for UD, it can't be used to
> update RIP, kvm_emulate_instruction() should be used instead. As for
> svm, nRIP in vmcb is 0 for UD, so kvm_emulate_instruction() is used.
> But for nested svm, I'm not sure, since svm_check_intercept() would
> change nRIP.
> 
> Changed from v1:
> 	As Sean suggested, fix the problem within the emulator
> 	instead of routing to the vendor callback.
> 	Add a new emulation type to handle completion of user exits.
> 	Attach a different callback for msr access emulation in the
> 	emulator.
> 
> Hou Wenlong (3):
>   KVM: x86: Add an emulation type to handle completion of user exits
>   KVM: x86: Use different callback if msr access comes from the emulator
>   KVM: x86: Exit to userspace if RDMSR/WRMSR emulation returns
>     X86EMUL_IO_NEEDED
> 
> Sean Christopherson (1):
>   KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code
>     seg
> 
>  arch/x86/include/asm/kvm_host.h |   8 ++-
>  arch/x86/kvm/x86.c              | 108 ++++++++++++++++++++------------
>  2 files changed, 76 insertions(+), 40 deletions(-)
> 
