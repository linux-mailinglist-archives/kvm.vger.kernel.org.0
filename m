Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC096E8C3C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 10:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbjDTIIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 04:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjDTIIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 04:08:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340AC1700
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C394C645CA
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 08:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9F4C4339B;
        Thu, 20 Apr 2023 08:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681978126;
        bh=sNcC/4YLuv3NV1p2vjUhFdV9MKTBqvreodvPR0jwTFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNuxodsMu1W9T5KWvV+jGZLBFBPdMjp5HMnn2QlWIZmthC73SclTsmIPjVbXmP3Ro
         cOEooQv3vMEepGHqVZmYX2ALVJJaJY7IXUPCOSF0TpeSTaMEnFPRRWjjGs15KsBlST
         IrGaG2Ybj9T3duGlrZpKUJwJeMVAyaVGDxiaOJDSE16tAbxW6E0VmS4r2+uZTwNwWo
         tEIUR7WM/CBd+Ue9dQeSrXKSnfirFGwvV71+EKIHRkxFLSWUiw6UtD/EStZacH69F/
         9zELN8dM3T2dh8nMDPqnjb1gncoZmVlvU5B123dmpkeKhjmos+Iuvwch5IyGdBNG9i
         xIMuNgrO17Yug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ppPLQ-009n1B-0Q;
        Thu, 20 Apr 2023 09:08:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] KVM: arm64: Fix bugs related to mp_state updates
Date:   Thu, 20 Apr 2023 09:08:40 +0100
Message-Id: <168197811285.2978116.18354347158121769762.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230419021852.2981107-1-reijiw@google.com>
References: <20230419021852.2981107-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, reijiw@google.com, oliver.upton@linux.dev, suzuki.poulose@arm.com, rananta@google.com, james.morse@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com, alexandru.elisei@arm.com, jingzhangos@google.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 19:18:50 -0700, Reiji Watanabe wrote:
> This series adds fixes that were missing in the patch [1].
> 
> The patch [1] added the mp_state_lock to serialize writes to
> kvm_vcpu_arch::{mp_state, reset_state}, and promoted all
> accessors of mp_state to {READ,WRITE}_ONCE() as readers do not
> acquire the mp_state_lock.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
      commit: 4ff910be01c0ca28c2ea8b354dd47a3a17524489
[2/2] KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update mp_state
      commit: a189884bdc9238aeba941c50f02e25eb584fafed

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


