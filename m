Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0B1494ACD
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbiATJdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:33:33 -0500
Received: from out0-153.mail.aliyun.com ([140.205.0.153]:39501 "EHLO
        out0-153.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbiATJdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:33:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047208;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.MfrexES_1642671210;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MfrexES_1642671210)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 17:33:30 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86/emulator: Fix wrong checks when loading code segment in emulator
Date:   Thu, 20 Jan 2022 17:33:28 +0800
Message-Id: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per Intel's SDM on "Instruction Set Reference", code segment
can be loaded by far jmp/call/ret, iret and int. For all those
instructions, not-present segment check should be after type and
privilege checks. But the emulator checks it first, so #NP is
triggered instead of #GP if privilege check fails and the segment
is not present.

When loading code segment above realmode, RPL/CPL/DPL should be
checked, but the privilege checks are different between those
instructions. Since iret and int are only implemented for realmode
in emulator, no checks ared needed.

The current implement only checks if DPL > CPL for conforming
code or (RPL > CPL or DPL != CPL) for non-conforming code. Since
far call/jump to call gate, task gate and task state segment are
not implemented for in emulator, the current checks are enough.

As for far return, outer level return is not implemented above
virtual-8086 mode in emulator, so RPL <= CPL. Per Intel's SDM,
if RPL < CPL, it should trigger #GP, but it is missing in
emulator. Other checks are satisfied in current implementation.

When vmexit for task switch, code segment would also be loaded
from tss. Since segment selector is loaded before segment descriptor
when load state from tss, it implies that RPL = CPL, the checks
are satisfied too.

I add some tests in kvm-unit-tests[*] for the wrong checks in
emulator. Enable kvm.force_enable_emulation to test them on emulator.

[*] https://lore.kernel.org/kvm/cover.1642669912.git.houwenlong.hwl@antgroup.com

Hou Wenlong (2):
  KVM: x86/emulator: Defer not-present segment check in
    __load_segment_descriptor()
  KVM: x86: Fix wrong privilege check for code segment in
    __load_segment_descriptor()

 arch/x86/kvm/emulate.c | 44 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

--
2.31.1

