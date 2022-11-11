Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20AA625EA0
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiKKPrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiKKPrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:47:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA4F532ED
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:47:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57736B82650
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 15:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6017C433C1;
        Fri, 11 Nov 2022 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668181659;
        bh=ieiibTmDrFYVTnTf2P9P+mwebXpKPMN4HIQwkxrTT54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDJqlCSoXKUc2tIHGpdf46XyjiJUb0FugqmunaImzUbYD+eF7V80k+OHqrcLpwITP
         y3d6rGZJdZDq0ike5/4kPHFA2iw6BiUdAiH7QkUxMJuVU1D7FWIPqlArkNn5SwKUOl
         6ad6sW/OPY5SIePylKYuf+AS1QJnYhSnCKERBbmYmdVqu3gsIHVbMDB5Hl5H9J+HCI
         zb6+GQFdTSI2CWyIfh5M7lMh6MbYiWk5KSvFgydPEIkKe0lrP6j/wlZ12uMMVGm+4F
         HUtuRX8P6dTMgCuyqiJC7ngDqNT/Y1Axp4tWFazvj2Vvu8mHpyUKYqiA+HOtZpi2fC
         uo/bAX3FlljSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1otWFl-005Shi-Fz;
        Fri, 11 Nov 2022 15:47:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Quentin Perret <qperret@google.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Christopherson <seanjc@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Gavin Shan <gshan@redhat.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v5 00/14] KVM: arm64: Parallel stage-2 fault handling
Date:   Fri, 11 Nov 2022 15:47:34 +0000
Message-Id: <166818113574.3365943.966631047504377265.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, oliver.upton@linux.dev, alexandru.elisei@arm.com, qperret@google.com, peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org, kvmarm@lists.linux.dev, bgardon@google.com, ricarkol@google.com, linux-arm-kernel@lists.infradead.org, seanjc@google.com, reijiw@google.com, gshan@redhat.com, dmatlack@google.com
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

On Mon, 7 Nov 2022 21:56:30 +0000, Oliver Upton wrote:
> Presently KVM only takes a read lock for stage 2 faults if it believes
> the fault can be fixed by relaxing permissions on a PTE (write unprotect
> for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> predictably can pile up all the vCPUs in a sufficiently large VM.
> 
> Like the TDP MMU for x86, this series loosens the locking around
> manipulations of the stage 2 page tables to allow parallel faults. RCU
> and atomics are exploited to safely build/destroy the stage 2 page
> tables in light of multiple software observers.
> 
> [...]

I've gone over this for quite a while, and while I'm still sh*t
scared about it, I've decided to let it simmer in -next for a bit.

If anything goes wrong or that someone spots something ugly,
it will be easy to simply drop the branch. For simple fixes, they
can go on top.

[01/14] KVM: arm64: Combine visitor arguments into a context structure
        commit: dfc7a7769ab7f2a2f629c673717ef1fa7b63aa42
[02/14] KVM: arm64: Stash observed pte value in visitor context
        commit: 83844a2317ecad935f6735abd854e4bf3f757040
[03/14] KVM: arm64: Pass mm_ops through the visitor context
        commit: 2a611c7f87f26cca405da63a57f06d0e4dc14240
[04/14] KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
        commit: fa002e8e79b3f980455ba585c1f47b26680de5b9
[05/14] KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
        commit: 8e94e1252cc054bb31fd3e9a15235cd831970ec1
[06/14] KVM: arm64: Use an opaque type for pteps
        commit: 6b91b8f95cadd3441c056182daf9024475ac4a91
[07/14] KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
        commit: 5c359cca1faf6d7671537fe1c240e8668467864d
[08/14] KVM: arm64: Protect stage-2 traversal with RCU
        commit: c3119ae45dfb6038ca458ab5ba7a9fba2810845b
[09/14] KVM: arm64: Atomically update stage 2 leaf attributes in parallel walks
        commit: ca5de2448c3b4c018fe3d6223df8b59068be1cd7
[10/14] KVM: arm64: Split init and set for table PTE
        commit: 331aa3a0547d1c794587e0df374d13b16645e832
[11/14] KVM: arm64: Make block->table PTE changes parallel-aware
        commit: 0ab12f3574db6cb432917a667f9392a88e8f0dfc
[12/14] KVM: arm64: Make leaf->leaf PTE changes parallel-aware
        commit: 946fbfdf336b811479e024136c7cabc00157b6b9
[13/14] KVM: arm64: Make table->block changes parallel-aware
        commit: af87fc03cfdf6893011df419588d27acdfb9c197
[14/14] KVM: arm64: Handle stage-2 faults in parallel
        commit: 1577cb5823cefdff4416f272a88143ee933d97f5

Fingers crossed,

	M.
-- 
Without deviation from the norm, progress is not possible.


