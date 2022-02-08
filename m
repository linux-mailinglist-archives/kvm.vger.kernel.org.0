Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F0D4ADFC8
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 18:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384343AbiBHRhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 12:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384317AbiBHRha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 12:37:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9102C061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 09:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73B38617BB
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 17:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C3EC340ED;
        Tue,  8 Feb 2022 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644341848;
        bh=DPma+LTOaMoHH6eY4ZXpFN0Oa9UnswEIPw8is5imAJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihoRU5F2a5DZAb4LPAzOI1XryX1XGVFbgeKREFgKQTtGgPMdc7qSNvzNjqiqoHH3n
         lUd7N6K1rzHpLnfdyo+fsChx11MV9Cpmfaj+NcAPzq+EgSt9qT7Trr3noIstxpV/aZ
         gXsvCHhRDeoCyosjWtPIhV4MN5jPRtOePXAYZkXkWsYj32pjxxPzKOFJ35SuC6bVl4
         FDafU4bu8dQNPZc1olVToKXusejnBZxm/PlSHHN1MSYczC/dkHoaNhyCGMj/w1WGDj
         m5YofxIqyxzetiBGyUZLBa0EiVn0YwOhLlEO5GFdZyTgMV/Y/kxFpyCZHF06Ok6QJz
         tjkiz3W1CzY7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nHUQh-006Kse-1y; Tue, 08 Feb 2022 17:37:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 0/5] kvm: selftests: aarch64: some fixes for vgic_irq
Date:   Tue,  8 Feb 2022 17:37:26 +0000
Message-Id: <164434147328.3931943.5336012810624636920.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
References: <20220127030858.3269036-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, drjones@redhat.com, kvm@vger.kernel.org, ricarkol@google.com, pbonzini@redhat.com, oupton@google.com, reijiw@google.com
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

On Wed, 26 Jan 2022 19:08:53 -0800, Ricardo Koller wrote:
> Reiji discovered multiple issues with the vgic_irq series [0]:
> 1. there's an assert that needs fixing.
> 2. some guest arguments are not set correctly.
> 3. the failure test in kvm_set_gsi_routing_irqchip_check is wrong.
> 4. there are lots of comments that use the wrong formatting.
> 5. vgic_poke_irq() could use a tighter assert check.
> 
> [...]

Applied to next, thanks!

[1/5] kvm: selftests: aarch64: fix assert in gicv3_access_reg
      commit: cc94d47ce16d4147d546e47c8248e8bd12ba5fe5
[2/5] kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
      commit: 11024a7a0ac26dd31ddfa0f6590e158bdf9ab858
[3/5] kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
      commit: 5b7898648f02083012900e48d063e51ccbdad165
[4/5] kvm: selftests: aarch64: fix some vgic related comments
      commit: a5cd38fd9c47b23abc6df08d6ee6a71b39038185
[5/5] kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()
      commit: b53de63a89244c196d8a2ea76b6754e3fdb4b626

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


