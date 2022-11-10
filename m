Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370F0624A56
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKJTJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiKJTJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9545F874
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BA0061E13
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25B6C433C1;
        Thu, 10 Nov 2022 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668107234;
        bh=n5RqcH+r3Pr3N5MvLY5kNdjJD72G1QSkvwLCwqb/nxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBykAl5QAR54gfFIPccn7LHfRTgCamAGEYwjYWRe99h9pr9hJBMuKXAQTbm4qr8nA
         GhmRzgSM5NA2kPRZp1WGGJVsF7uyH4UMKn1z3KSvTxVzBkf7TisBdL14TOevSTs5fy
         z1k3NirXzDdk5+6Qo1smXykdSxv9IuG1aue2RHTi1oJ1f4LWtMB9hvL8kvrOy9CBfj
         BLmAvzxQQS2aaRN6r6Kuokvc1pacDImbWb8mZpRAif/runUTi30aE/+dCbAgQ0K7S8
         wNF6E0DFjpnVo07UPaQ0T3AWEmoECANJNGM/mZAsEenu4cKRcQDRL3b7c7rAFerBBg
         hNXA81mwOjjSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1otCtM-005Ecq-E2;
        Thu, 10 Nov 2022 19:07:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Reiji Watanabe <reijiw@google.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v2 0/9] KVM: arm64: selftests: Test linked {break,watch}points
Date:   Thu, 10 Nov 2022 19:07:05 +0000
Message-Id: <166810721166.3361564.3176052818843423972.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
References: <20221020054202.2119018-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, reijiw@google.com, andrew.jones@linux.dev, pbonzini@redhat.com, kvm@vger.kernel.org, alexandru.elisei@arm.com, suzuki.poulose@arm.com, jingzhangos@google.com, ricarkol@google.com, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, oliver.upton@linux.dev, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Oct 2022 22:41:53 -0700, Reiji Watanabe wrote:
> This series adds test cases for linked {break,watch}points to the
> debug-exceptions test, and expands {break,watch}point tests to
> use non-zero {break,watch}points (the current test always uses
> {break,watch}point#0).
> 
> Patches 1-6 add some helpers or do minor refactoring for
> preparation of adding test cases in subsequent patches.
> Patches 7-8 add test cases for a linked {break,watch}point.
> Patch 9 expands {break,watch}point test cases to use non-zero
> {break,watch}points.
> 
> [...]

Applied to next, thanks!

[1/9] KVM: arm64: selftests: Use FIELD_GET() to extract ID register fields
      commit: 1a6182033f2d5c481aec1f8c1c26ebc649693d57
[2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in debug-exceptions
      commit: f6d02aa28ae21161d64300bac62b2dde85584004
[3/9] KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from debug-exceptions
      commit: 700b8860e02cbaa7dd1181a914ff38e0fae18bf0
[4/9] KVM: arm64: selftests: Add helpers to enable debug exceptions
      commit: 152880d8edf5ad6df5b4b4915a4d9f9085ab8fef
[5/9] KVM: arm64: selftests: Stop unnecessary test stage tracking of debug-exceptions
      commit: 948f439c9d0080972ec937f4aefbe51229546510
[6/9] KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
      commit: 5dd544e882d96d43b363c5ef64683281f2a386d9
[7/9] KVM: arm64: selftests: Add a test case for a linked breakpoint
      commit: 142365932f5f296df593dd653d79194ff5457722
[8/9] KVM: arm64: selftests: Add a test case for a linked watchpoint
      commit: 5ced4e533b676b1a582d89aba5328e4b316957e0
[9/9] KVM: arm64: selftests: Test with every breakpoint/watchpoint
      commit: ebb8cc10316de3040efc4cfb40030f374cbbaa3b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


