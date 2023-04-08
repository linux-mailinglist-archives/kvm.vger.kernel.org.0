Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572D36DBBA0
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 16:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDHOhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 10:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjDHOhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 10:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DBEEFB9
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 07:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BAD160C77
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 14:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C108EC4339E;
        Sat,  8 Apr 2023 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680964666;
        bh=p1WFawqORrj4BNw0049zwWZ8jRy7T9i4XPAN6Z7h6YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIwkQR8qKocwx2KnUX6+/vWOxqDLb0ZLmscEj/eVgzKIKO9jal5dtP6e6OsHhoeW0
         Zow8TamEqS2SH37UAi8nbYPzXE8KVp6U+c5pinzJdOXTzXoBCNO7+Jc8azZ3kPSlPK
         2Cinawf4oDf4pdAJCtZ5/kK/4v1SVuC82TfV1sEYgsPi+53e4Kqe6/MxXLFT1Ua6B1
         0pRApd9Wr62ckhotU70Yj4Nvd9A5GleFc2J5arPTEHp599U6zA+VC10+nWj3l5kZxA
         r9z13ceyUez8MSVZO+qp2RbgGZuCuiIuFQwsOVam8dNfAd9CSDgDIokeS+kVKqOSfQ
         kkA9mgc3pjLdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pl9hI-006vs1-I4;
        Sat, 08 Apr 2023 15:37:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Reserve SMC64 arch range per SMCCC filter documentation
Date:   Sat,  8 Apr 2023 15:37:37 +0100
Message-Id: <168096461638.4153376.15496387144978644997.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408121732.3411329-1-oliver.upton@linux.dev>
References: <20230408121732.3411329-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, james.morse@arm.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 8 Apr 2023 12:17:30 +0000, Oliver Upton wrote:
> The intention of the SMCCC filter series was that the 'Arm architecture
> calls' range is reserved, meaning userspace cannot apply a filter to it.
> Though the documentation calls out both the SMC32 and presently unused
> SMC64 views, only the SMC32 view of this range was actually reserved.
> 
> Small series to align UAPI behavior with the documentation and adding a
> test case for the missed condition. Applies to kvmarm/next.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Prevent userspace from handling SMC64 arch range
      commit: 5a23ad6510c82049f5ab3795841c30e8f3ca324d
[2/2] KVM: arm64: Test that SMC64 arch calls are reserved
      commit: 00e0c947118f456b622c1f2ca316c116dfb4e12c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


