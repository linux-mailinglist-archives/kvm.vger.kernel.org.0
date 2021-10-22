Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23612437051
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 05:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhJVDCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 23:02:16 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55518 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232627AbhJVDCP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 23:02:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---0UtCTiCu_1634871597;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UtCTiCu_1634871597)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 10:59:57 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: some fixes about RDMSR/WRMSR instruction emulation
Date:   Fri, 22 Oct 2021 10:59:55 +0800
Message-Id: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_CAP_X86_USER_SPACE_MSR cap is enabled, userspace can control
MSR accesses. In normal scenario, RDMSR/WRMSR can be interceped, but
when kvm.force_emulation_prefix is enabled, RDMSR/WRMSR with kvm prefix
would trigger an UD and cause instruction emulation. If MSR accesses is
filtered, em_rdmsr()/em_wrmsr() returns X86EMUL_IO_NEEDED, but it is
ignored by x86_emulate_instruction(). Then guest continues execution,
but RIP has been updated to point to RDMSR/WRMSR in handle_ud(), so
RDMSR/WRMSR can be interceped and guest exits to userspace finnaly by
mistake. Such behaviour leads to two vm exits and wastes one instruction
emulation.

After let x86_emulate_instruction() returns 0 for RDMSR/WRMSR emulation,
if it needs to exit to userspace, its complete_userspace_io callback
would call kvm_skip_instruction() to skip instruction. But for vmx,
VMX_EXIT_INSTRUCTION_LEN in vmcs is invalid for UD, it can't be used to
update RIP, kvm_emulate_instruction() should be used instead. As for
svm, nRIP in vmcb is 0 for UD, so kvm_emulate_instruction() is used.
But for nested svm, I'm not sure, since svm_check_intercept() would
change nRIP.

Hou Wenlong (2):
  KVM: VMX: fix instruction skipping when handling UD exception
  KVM: X86: Exit to userspace if RDMSR/WRMSR emulation returns
    X86EMUL_IO_NEEDED

 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/vmx/vmx.h | 9 +++++++++
 arch/x86/kvm/x86.c     | 4 +++-
 3 files changed, 14 insertions(+), 3 deletions(-)

--
2.31.1

