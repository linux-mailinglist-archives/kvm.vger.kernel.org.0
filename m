Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F43404CE6
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 14:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344258AbhIIL6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 07:58:44 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:58567 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244877AbhIIL4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 07:56:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---0UnnI4Gp_1631188525;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UnnI4Gp_1631188525)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 19:55:25 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Subject: [PATCH v2 0/3] kvm: x86: some fixes of hypercall emulation
Date:   Thu,  9 Sep 2021 19:55:22 +0800
Message-Id: <cover.1631188011.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
References: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, use hypercall instruction in guest cpl3 would just skip
the instruction, however, that behaviour could trigger a exception
in Linux host. It is reasonable for hypervisor to inject a exception,
especially in nested guest, L1 guest could behaviour like host.

As for hypercall instruction emulation, hypervisor would replace
the wrong instruction with the right instruction instead of the real
instruction emulation. It's guest's responsibility to use the right
instruction, hypervisor could emulate it but shouldn't modify it
without guest's request. At present, Linux guest could use alternative
to choose right instruction, and hyperv guest could use hypercall to
modify instruction. So just do the real instruction emualtion job
for em_hypercall().

change from v1:
	v1 is wrong edition, sent by mistake

Hou Wenlong (3):
  kvm: x86: Introduce hypercall x86 ops for handling hypercall not in
    cpl0
  kvm: x86: Refactor kvm_emulate_hypercall() to no skip instruction
  kvm: x86: Emulate hypercall instead of fixing hypercall instruction

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/emulate.c             | 20 +++++------
 arch/x86/kvm/kvm_emulate.h         |  2 +-
 arch/x86/kvm/svm/svm.c             |  6 ++++
 arch/x86/kvm/vmx/vmx.c             |  9 +++++
 arch/x86/kvm/x86.c                 | 55 +++++++++++++++++-------------
 7 files changed, 59 insertions(+), 35 deletions(-)

--
2.31.1

