Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A5C5376F4
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 10:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiE3I2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 04:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiE3I2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 04:28:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3259674DE8
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 01:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9351B80B09
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 08:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECF6C385B8;
        Mon, 30 May 2022 08:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653899290;
        bh=y17OzcpGc1HlzyJqlHd0DQWHrq/L+rJUWQeAvCz7OHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJGu3IxfKiPlT8olJ8xkAAJuP8UrK/fjPv6JcqwiR0C1oINxhqDjhSocktkccQNaL
         KcJJZedhd13HQMKgv/VobBGKYJDqd6nnUCTrQltTvp1AkL3exevofOGKqpeXNJoXau
         lWiKVCT4y0alnAQy2BgFTUJi0awQMWIQJwgJql1E7bAqUcxMVRm9CthFapHgP66YQ0
         DBXWdSrSEcQ8Zd+0FI69r78FFWm6a0M1eQvcY6Iz4h2rkJqRWqHdkRLaVQH6X1hTp4
         MRPSrTh/va2ghWlRUDo5xc6KCMY6hny84ZNS2Ju/x34uVDbKDDhdCrKeGyTSeKWLCW
         zJIel+MeGNUeQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nvaky-00ESs1-16; Mon, 30 May 2022 09:28:08 +0100
MIME-Version: 1.0
Date:   Mon, 30 May 2022 09:28:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: Re: [PATCH 00/18] KVM/arm64: Refactoring the vcpu flags
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e29e8f7a2bfa3cd099c58c9a9ab8a518@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-05-28 12:38, Marc Zyngier wrote:

[...]

> This has been lightly tested on both VHE and nVHE systems, but not
> with pKVM itself (there is a bit of work to rebase it on top of this
> infrastructure). Patches on top of kvmarm-4.19 (there is a minor
> conflict with Linus' current tree).

As Will just pointed out to me in private, this should really read
kvmarm-5.19, as that's what the patches are actually based on.

I guess I'm still suffering from a form of Stockholm syndrome...

         M.
-- 
Jazz is not dead. It just smells funny...
