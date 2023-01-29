Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162CF680106
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 19:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjA2Syr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 13:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbjA2Syp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 13:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48C21F4BA
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 10:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87F3FB80D77
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 18:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9BFC433D2;
        Sun, 29 Jan 2023 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675018473;
        bh=ebOSirCFEDGOZLFrWoVgpUQkTKHhvgyDudrNEvfsQ5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAkZCyq/Po7VFmbYI5vI4zmmIekOjNo1UAU++xhDe21FSDrfDXHLf/ID6RkoClR4U
         gyD9zuCwMIMKB7w71yAGNtK5H02tMKZGAEUKpEU1i1ADFHHebj8TNlvcJX0rj3Z5yH
         2sU2TZ/73FS2Oh6Oxip8weT4brR2XGsejwgkRy4Grcym87fmTK1oU+wx6YyjuowsjG
         gt4BnTfaMg3awMMVX5NnElqeafHX8q5GHn0QHv6AbIM1xUdOjbsphe+cSj6TButVry
         UQAmeYB73a4+h4gDkajLYfvW8b0A38GQGbyVg5Ypaye35Zt9svFwQg6M5svBAXrS/c
         aFhlVvly6zNpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMCox-005eaG-7H;
        Sun, 29 Jan 2023 18:54:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Ricardo Koller <ricarkol@google.com>, andrew.jones@linux.dev
Cc:     oupton@google.com, pbonzini@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/4] KVM: selftests: aarch64: page_fault_test S1PTW related fixes
Date:   Sun, 29 Jan 2023 18:54:28 +0000
Message-Id: <167501840046.2480538.131170578621947209.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127214353.245671-1-ricarkol@google.com>
References: <20230127214353.245671-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, ricarkol@google.com, andrew.jones@linux.dev, oupton@google.com, pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com, yuzenghui@huawei.com
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

On Fri, 27 Jan 2023 21:43:49 +0000, Ricardo Koller wrote:
> Commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
> changed the way S1PTW faults were handled by KVM.  Before this fix,
> KVM treated any fault due to any S1PTW as a write, even S1PTW that
> didn't update the PTE.  Some tests in page_fault_test mistakenly check
> for this KVM behavior and are currently failing.  For example, there's
> a dirty log test that asserts that a S1PTW without AF or DA results in
> the PTE page getting dirty.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
      commit: 0dd8d22a887a473f6f11abf556c4f7944ab5ef1d
[2/4] KVM: selftests: aarch64: Do not default to dirty PTE pages on all S1PTWs
      commit: 42561751ea918d8f3f54412622735e1f887cb360
[3/4] KVM: selftests: aarch64: Fix check of dirty log PT write
      commit: 8b03c97fa6fd442b949b71aeb7545b970b968fe3
[4/4] KVM: selftests: aarch64: Test read-only PT memory regions
      commit: 08ddbbdf0b55839ca93a12677a30a1ef24634969

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


