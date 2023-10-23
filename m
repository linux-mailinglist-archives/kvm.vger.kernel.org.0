Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0557D7D2F16
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjJWJzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjJWJzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:55:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FE8170C
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:54:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30753C433C8;
        Mon, 23 Oct 2023 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698054893;
        bh=RGhMAQKKfN2krCGCzw9mQvKPycHDxrGCVceRB8YfGKo=;
        h=From:To:Cc:Subject:Date:From;
        b=Wtqxxl0nTlsUCc7PzdITXbEblfZij1vIQpJJNoKoX4sGke945Clc6kl9hHyv9YOn9
         d30ihSG2g3hdfeibXvBKZb39NJyoCk+VyxLVXOa4zapdF9qFn4My2jCwH2onDiJby9
         sMf98hWL3hDWD2y7NPzcE9g8bLAcnJhY9XpYYL/kSxjUfcAPm+YAih+2mjHJit793B
         zIdYDRe77etZYFITRbryElN9S6RTiJVX37XqEHzxCkUAUL0lzIfb68Ka6O9U4VAjuU
         f2WI+Oe7Cx1RdwECWulJCxvxeDOCxYee/gHP87GLKBx1mH1sKYmIkJOSiWe205ik1w
         CA7TfkJ0eFOmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qure6-006nPT-Pk;
        Mon, 23 Oct 2023 10:54:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/5] KVM: arm64: NV trap forwarding fixes
Date:   Mon, 23 Oct 2023 10:54:39 +0100
Message-Id: <20231023095444.1587322-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, eric.auger@redhat.com, miguel.luis@oracle.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As Miguel was reworking some of the NV trap list, it became clear that
the 32bit handling didn't get much love. So I've taken Miguel's
series, massaged it a bit, and added my own stuff.

Apart from the last patch, the all have been on the list and reviewed.
I was hoping to take it into 6.6, but some of the late rework and the
required testing have made it impossible.

Oliver, if you're happy with the shape of it, I'd appreciate it if you
could take it into 6.7.

Thanks,

	M.

Marc Zyngier (2):
  KVM: arm64: Do not let a L1 hypervisor access the *32_EL2 sysregs
  KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as RAZ/WI

Miguel Luis (3):
  arm64: Add missing _EL12 encodings
  arm64: Add missing _EL2 encodings
  KVM: arm64: Refine _EL2 system register list that require trap
    reinjection

 arch/arm64/include/asm/sysreg.h | 45 +++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c | 77 ++++++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c       | 24 +++++++---
 3 files changed, 133 insertions(+), 13 deletions(-)

-- 
2.39.2

