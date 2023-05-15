Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF9703EBD
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 22:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245290AbjEOUqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 16:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjEOUqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 16:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B67AD11
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 13:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 514DD6325D
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 20:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7249C433EF;
        Mon, 15 May 2023 20:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684183566;
        bh=IgotsoE+lKbu+zjyxa2eaxVvm4lP9qydqGNJoKmctcw=;
        h=From:To:Cc:Subject:Date:From;
        b=U/bRCxs3nu/a5nb/hVAm7N+rbLiZh5wXdH3kNCDzRepPrJdDZmhYG/VWSIYAcLLrJ
         z7wPtDIOPVGBjwkFt/24xjYVrbMIWPu0d32EwHdMTXhK0A0cvGZeXl8TJzLXXi+44c
         +J8HUHsirHv1fGWOO4MUiu8yhte8Bo3pm9HkPxwYe+KQlRJrFYjYZOPdhB27I/3cDW
         Rt49tveNT4IuDar0C/LMwUrDIeM3vOfNkchJQq7+U8iZmH3L5oH4HBqmlCQOXoiVLh
         hTLjP9tui1bR5riEccvdQyrNmbIpJbBtUmrH28bfjaJqb63qvLfNLS4AeJBpAt61lM
         IbqUoXns0us0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyf52-00FM0a-A5;
        Mon, 15 May 2023 21:46:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: arm64: Handle MTE Set/Way CMOs
Date:   Mon, 15 May 2023 21:45:59 +0100
Message-Id: <20230515204601.1270428-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, steven.price@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the MTE support was added, it seens the handling of MTE Set/Way
was ommited, meaning that the guest will get an UNDEF if it tries to
do something that is quite stupid, but still allowed by the
architecture...

Found by inspection while writting the trap support for NV.

Marc Zyngier (2):
  arm64: Add missing Set/Way CMO encodings
  KVM: arm64: Handle trap of tagged Set/Way CMOs

 arch/arm64/include/asm/sysreg.h |  6 ++++++
 arch/arm64/kvm/sys_regs.c       | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

-- 
2.34.1

