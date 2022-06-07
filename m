Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31D554004F
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243741AbiFGNn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243723AbiFGNnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:43:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03388A8894
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9413361446
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 13:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2785C385A5;
        Tue,  7 Jun 2022 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654609430;
        bh=zJAgHSfeuULjeQ226gU3vnExepgqfXsDdzVQZfb1jyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddjfLvsDSgKgyGnPJwpKyJcvwj3H/euPSrL9jFyylGy6RuWF8wwQWc95bsGgGOkfa
         emF5DAnLBScWWHLaiMK6IOzj3O3TVoQixDbrZiI8nu6qZ58OQYGvUw0lqqoy4Jl0RN
         1iuQDj7HqWtBDFY6ZO4ByOnoLI10YYsE9ebHvle4aoO9qPIVBm+4PuMUO0z962mRgi
         5SxFZD0WOtU7a35SUNRGwqXFAKNrxfOE5K7qc9pi1Dda/baJpywzoj/O9ctC5AlVGG
         q3ed03OiJuGr7X5X3GiRfA+QanLMbM1EnK7r7R+3UVmbYV+p4cCVWVz0HkxaPVPvVC
         8fd//Fmj0bOeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nyZUp-00GC0V-Ck; Tue, 07 Jun 2022 14:43:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>, Mark Brown <broonie@kernel.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 00/18] KVM/arm64: Refactoring the vcpu flags
Date:   Tue,  7 Jun 2022 14:43:44 +0100
Message-Id: <165460926051.126720.11200694374756872451.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, broonie@kernel.org, kernel-team@android.com, will@kernel.org, suzuki.poulose@arm.com, qperret@google.com, alexandru.elisei@arm.com, tabba@google.com, oupton@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 28 May 2022 12:38:10 +0100, Marc Zyngier wrote:
> While working on pKVM, it slowly became apparent that dealing with the
> flags was a pain, as they serve multiple purposes:
> 
> - some flags are purely a configuration artefact,
> 
> - some are an input from the host kernel to the world switch,
> 
> [...]

Applied to fixes, thanks!

[01/18] KVM: arm64: Always start with clearing SVE flag on load
        commit: d52d165d67c5aa26c8c89909003c94a66492d23d
[02/18] KVM: arm64: Always start with clearing SME flag on load
        commit: 039f49c4cafb785504c678f28664d088e0108d35

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

