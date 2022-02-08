Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8404AD509
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 10:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355208AbiBHJeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 04:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355203AbiBHJeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:34:09 -0500
Received: from out0-152.mail.aliyun.com (out0-152.mail.aliyun.com [140.205.0.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E1C03FEC5
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 01:34:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047213;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.Mn.uQJG_1644312846;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mn.uQJG_1644312846)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 17:34:06 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: x86/emulator: Fix wrong checks when loading code segment in emulator
Date:   Tue, 08 Feb 2022 17:34:02 +0800
Message-Id: <cover.1644292363.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
References: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

[*] https://lore.kernel.org/kvm/cover.1644311445.git.houwenlong.hwl@antgroup.com

Changed from v1:
- Add a comment about RPL < CPL check for far return in patch 2.
- Fix a mistake when judge transfer type in patch 2.
- As Sean suggested, add a new patch to move the unhandled outer
  privilege level logic of far return into __load_segment_descriptor().

Hou Wenlong (3):
  KVM: x86/emulator: Defer not-present segment check in
    __load_segment_descriptor()
  KVM: x86/emulator: Fix wrong privilege check for code segment in
    __load_segment_descriptor()
  KVM: x86/emulator: Move the unhandled outer privilege level logic of
    far return into __load_segment_descriptor()

 arch/x86/kvm/emulate.c | 51 +++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 15 deletions(-)

--
2.31.1

