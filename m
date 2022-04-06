Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23224F64A4
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiDFP5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236637AbiDFP4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85544F686F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 06:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2579260BA1
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 13:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891FBC385A3;
        Wed,  6 Apr 2022 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649251303;
        bh=9rQTc7L8tJ6xiJFNxneGRixTQCGHIv1jdjoD81C2PjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iz4AtakFBVCp2wk5WjxYcAYLOVYdFdadBlt82bPLsjO8d8fW1dPCigPmxTIgQQng9
         zsOlCy4db81JAJlprLuJVqZP6CjsxTekv9K3Js3jUGBf6cRX1DWFm5NXZ0SjidccOX
         0qdW35FVH9/JpfG8hsaKOnOpxaWO9RXI+2+OEOpu82L1rnCD478Ya3JvRVG8gA9z0x
         W8lKty2tqUDBc9VEcL9If31vrbJ3W2nYhM46/PFRDVLd9HgFkHybilRrIk0ntInAjx
         xqkQF5EC+cED7luy5reO2x/6N2SSEENlX5xBqHYhvNjzzEecLVtqbFV3Z8eMsbs30y
         ahMtGxF/iVJ1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nc5bQ-002Ae1-Gm; Wed, 06 Apr 2022 14:21:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>, kvmarm@lists.cs.columbia.edu
Cc:     Andrew Jones <drjones@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Oliver Upton <oupton@google.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 0/2] KVM: arm64: mixed-width check should be skipped for uninitialized vCPUs
Date:   Wed,  6 Apr 2022 14:21:33 +0100
Message-Id: <164925121901.3715988.2577538688364822137.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329031924.619453-1-reijiw@google.com>
References: <20220329031924.619453-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: reijiw@google.com, kvmarm@lists.cs.columbia.edu, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, alexandru.elisei@arm.com, ricarkol@google.com, pshier@google.com, rananta@google.com, jingzhangos@google.com, suzuki.poulose@arm.com, will@kernel.org, oupton@google.com, james.morse@arm.com, pbonzini@redhat.com
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

On Mon, 28 Mar 2022 20:19:22 -0700, Reiji Watanabe wrote:
> KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
> for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
> if the vcpu's register width is consistent with all other vCPUs'.
> Since the checking is done even against vCPUs that are not initialized
> (KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
> are erroneously treated as 64bit vCPU, which causes the function to
> incorrectly detect a mixed-width VM.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: mixed-width check should be skipped for uninitialized vCPUs
      commit: 26bf74bd9f6ff0f1545b4f0c92a37c232d076014
[2/2] KVM: arm64: selftests: Introduce vcpu_width_config
      commit: 2f5d27e6cf14efe652748bad89ee529ed5a5d577

Note that I have somewhat tweaked the first patch to my own liking.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


