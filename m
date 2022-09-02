Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099B35AA606
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbiIBCrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiIBCrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:47:35 -0400
Received: from out0-152.mail.aliyun.com (out0-152.mail.aliyun.com [140.205.0.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBBC90C54
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 19:47:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047209;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.P5mm2Hp_1662086822;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P5mm2Hp_1662086822)
          by smtp.aliyun-inc.com;
          Fri, 02 Sep 2022 10:47:02 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Subject: [PATCH v2 0/2] Add missing trace points in emulator path
Date:   Fri, 02 Sep 2022 10:46:59 +0800
Message-Id: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
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

Some existed trace points are missing in emulator path, e.g.,
RDMSR/WRMSR emulation and CR read/write emulation. However,
if add those trace points in emulator common interfaces in
arch/x86/kvm/x86.c, other instruction emulation may use those
interfaces too and cause too much trace records. But add those
trace points in em_* functions in arch/x86/kvm/emulate.c seems
to be ugly. Luckily, RDMSR/WRMSR emulation uses a sepreate
interface, so add trace points for RDMSR/WRMSR in emulator
path is acceptable like normal path.

Changed from v1:
- As Sean suggested, use X86EMUL_PROPAGATE_FAULT instead of
  X86EMUL_UNHANDLEABLE for error path.
- As Sean suggested, move "r < 0" handling into the set helper,
  and add "r < 0" check in the get helper.

v1: https://lore.kernel.org/kvm/cover.1658913543.git.houwenlong.hwl@antgroup.com

Hou Wenlong (2):
  KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
  KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path

 arch/x86/kvm/emulate.c | 20 ++++++++------------
 arch/x86/kvm/x86.c     | 32 ++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 22 deletions(-)

--
2.31.1

