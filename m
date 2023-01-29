Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241A5680100
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 19:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjA2SyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 13:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2SyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 13:54:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985341E292;
        Sun, 29 Jan 2023 10:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39288B80D78;
        Sun, 29 Jan 2023 18:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA032C433EF;
        Sun, 29 Jan 2023 18:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675018456;
        bh=I7OWZpIexMPfCriDmT6tX4hVWNcJ0a14P9vHmErgqiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzVIl+okQLi+gn0pb5zM1bLR8OlapQIWh8SR+njowGQ+fQohh2pHsHuQNXKBzotO4
         YOi/IUvzN9dTu1fuqm1H6lXw+rHMCoAA0sVjl+TvQJyR90PrZN3inhi46GjZltPgiB
         /Ojvn3udXkK2WYgcfsCfHWEzxpLYXOCA/GMTB6+B+5uqTdmq+tGUI99DhztjxVWt/v
         BU4u3ToWPj4Yz6n2S3cWZzL0mENVWyvP7vtyOcDK7Njck4ixQAK2kiOM1jBxSJwTrJ
         PM6kzA4GnZfPshdCC9MnSp65sYQTmEAqD3AtXZX51YU6tL33mg9wUfV3oz0SFsjTV6
         AeLQaTdWufqZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMCog-005eZQ-4U;
        Sun, 29 Jan 2023 18:54:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc:     linux-kernel@vger.kernel.org, will@kernel.org, reijiw@google.com,
        kvm@vger.kernel.org, isaku.yamahata@intel.com, pbonzini@redhat.com,
        suzuki.poulose@arm.com, eric.auger@redhat.com, yuzhe@nfschina.com,
        yuzenghui@huawei.com, linux-doc@vger.kernel.org,
        james.morse@arm.com, renzhengeek@gmail.com, corbet@lwn.net,
        oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu,
        shan.gavin@gmail.com, seanjc@google.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, ricarkol@google.com
Subject: Re: [PATCH v3 0/4] Improve dirty ring warning report
Date:   Sun, 29 Jan 2023 18:54:10 +0000
Message-Id: <167501840046.2480538.4084679017095353524.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126235451.469087-1-gshan@redhat.com>
References: <20230126235451.469087-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, will@kernel.org, reijiw@google.com, kvm@vger.kernel.org, isaku.yamahata@intel.com, pbonzini@redhat.com, suzuki.poulose@arm.com, eric.auger@redhat.com, yuzhe@nfschina.com, yuzenghui@huawei.com, linux-doc@vger.kernel.org, james.morse@arm.com, renzhengeek@gmail.com, corbet@lwn.net, oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com, seanjc@google.com, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 07:54:47 +0800, Gavin Shan wrote:
> It has been known case where no running VCPU context exists when the
> vgic/its tables are saved. There are other two unknown cases where we
> don't have the running VCPU context: (a) restore vgic3 LPI pending
> status. (b) restoring vgic3 pending tables.
> 
> PATCH[1]     includes 'kvm_mmu.h' to 'vgic.h'
> PATCH[2]     adds unified helper vgic_write_guest_lock()
> PATCH[3 - 4] allows no-running-vcpu context for (a) and (b)
> 
> [...]

Applied to fixes, thanks!

[2/4] KVM: arm64: Add helper vgic_write_guest_lock()
      commit: a23eaf9368aafa4defcc8904b20391b6ea07bb1e
[3/4] KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending status
      commit: 2f8b1ad2228a7f1f1e2458864f4bfc1cbdf511ed
[4/4] KVM: arm64: Allow no running vcpu on saving vgic3 pending table
      commit: 6028acbe3a5f2119a2a6ddd3e06453c87c09cae0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


