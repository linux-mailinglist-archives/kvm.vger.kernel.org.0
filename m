Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B9E4ADFBF
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 18:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345881AbiBHRhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 12:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240791AbiBHRhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 12:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C43C061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 09:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3A86617CC
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 17:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A982C004E1;
        Tue,  8 Feb 2022 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644341842;
        bh=z7x9k7zpuA8L2GckoI+lo9EUEQELGlJ8Sq9J/gtwCrg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Iqe5nSU6qBLRf38mjjQ4wbUvCVUTZbIMmZZu989D+IuNG12ulYHAjPsVmYUtQOU/i
         1VidmTepRY5DJCT0rUlhDDGQm2JWDWmKDK4/iriqFqoGwQqMdZ34WTkoTO309iG7JU
         Mmy8vqSIkrdugsbU1shsN7oN8SiUJ9Wwhs9AaVaoH8qJ6n5TQm657RxYsNT0/N/908
         P0InK5D9ulklxviR0helIE2q7ELed1rakGzY/nsiSrfu1mUePK4FDiaJbdwFmxu1EC
         Qg26b04uW/QQklTy2eYI/Bs+Aiz9sY9nJcJxbcIUHZnNImyhpviicKWXV3zHAm7sb2
         TntaW8IuP979g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nHUQa-006Ks8-5n; Tue, 08 Feb 2022 17:37:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH v2 0/3] ARM64: Guest performance improvement during dirty
Date:   Tue,  8 Feb 2022 17:37:18 +0000
Message-Id: <164434147327.3931943.5197467293148231951.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118015703.3630552-1-jingzhangos@google.com>
References: <20220118015703.3630552-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: reijiw@google.com, rananta@google.com, ricarkol@google.com, oupton@google.com, pbonzini@redhat.com, will@kernel.org, dmatlack@google.com, jingzhangos@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, 18 Jan 2022 01:57:00 +0000, Jing Zhang wrote:
> This patch is to reduce the performance degradation of guest workload during
> dirty logging on ARM64. A fast path is added to handle permission relaxation
> during dirty logging. The MMU lock is replaced with rwlock, by which all
> permision relaxations on leaf pte can be performed under the read lock. This
> greatly reduces the MMU lock contention during dirty logging. With this
> solution, the source guest workload performance degradation can be improved
> by more than 60%.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Use read/write spin lock for MMU protection
      commit: fcc5bf89635a05e627cdd2e9ec52c989c8dfe2ab
[2/3] KVM: arm64: Add fast path to handle permission relaxation during dirty logging
      commit: f783ef1c0e82e4fc311a972472ff61f6d1d0e22d
[3/3] KVM: selftests: Add vgic initialization for dirty log perf test for ARM
      commit: c340f7899af6f83bd937f8838949bb32da54c8a4

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


