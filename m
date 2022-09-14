Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362065B8686
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 12:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiINKmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 06:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiINKl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 06:41:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B704A78BD2
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 03:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65016B81A06
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 10:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15444C433D6;
        Wed, 14 Sep 2022 10:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663152115;
        bh=qZF9xZYgF5fgg3ULL55FWObrA8P8t6PL2FkrqN2TU5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSBKh/oyI9Bwsfx7CwpRUk7rkmI5v3KMUiAH56t6QWKoP5GfnqeRfi110Z8w2Ouhc
         VskBVB7/xoK5YsGlC4HVtrfSBup3fMSly+dtd6JajXX5Kbn7p+ajK8OJMe2C8ja+iJ
         jDGrYyH2U8cvF53jW8eGlZIRKLymbRHB29X64+8Zafn10qGYWq9w9e7RpZLq0R3sNh
         xUZivgtybovgcOauwhuBC4gZP26MQS7epNoD//YxChloR07RfpmKNK8ig35QNPax8K
         8VJoSdwvYVSAJhZG7sCk/TUNeVcM078669cNweLMSxeAlHaGqzCY9ozE4/Y/dpwuPw
         +jRfiN/V81hkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oYPq4-00AB2X-Oj;
        Wed, 14 Sep 2022 11:41:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>
Cc:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH v3 0/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
Date:   Wed, 14 Sep 2022 11:41:50 +0100
Message-Id: <166315210221.2105633.12201786772874832958.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, oliver.upton@linux.dev, james.morse@arm.com, reijiw@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, andrew.jones@linux.dev
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

On Tue, 13 Sep 2022 09:44:33 +0000, Oliver Upton wrote:
> For reasons unknown, the Arm architecture defines the 64-bit views of
> the 32-bit ID registers as UNKNOWN [1]. This combines poorly with the
> fact that KVM unconditionally exposes these registers to userspace,
> which could throw a wrench in migration between 64-bit only systems.
> 
> This series reworks KVM's definition of these registers to RAZ/WI with
> the goal of providing consistent register values across 64-bit machines.
> 
> [...]

Applied to kvm-arm64/next, thanks!

[1/7] KVM: arm64: Use visibility hook to treat ID regs as RAZ
      commit: 34b4d20399e6fad2e3379b11e68dff1d1549274e
[2/7] KVM: arm64: Remove internal accessor helpers for id regs
      commit: 4782ccc8ef50fabb70bab9fa73186285dba6d91d
[3/7] KVM: arm64: Drop raz parameter from read_id_reg()
      commit: cdd5036d048ca96ef5212fb37f4f56db40cb1bc2
[4/7] KVM: arm64: Spin off helper for calling visibility hook
      commit: 5d9a718b64e428a40939806873ecf16f072008b3
[5/7] KVM: arm64: Add a visibility bit to ignore user writes
      commit: 4de06e4c1dc949c35c16e4423b4ccd735264b0a9
[6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
      commit: d5efec7ed826b3b29c6847bf59383d8d07347a4e
[7/7] KVM: selftests: Add test for AArch32 ID registers
      commit: 797b84517c190053597e3f7e03ead15da872e04d

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

