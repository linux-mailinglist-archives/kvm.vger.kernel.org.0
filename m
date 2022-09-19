Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463BA5BC5F8
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 12:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiISKEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 06:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiISKEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 06:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CC522BED
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 03:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80D186126C
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17A1C433C1;
        Mon, 19 Sep 2022 10:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663581846;
        bh=vv5edDA3DSeWqg/CbFNAolrHqtgw8wIZzdfQbXSqnyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDWaFwrGS+TF3aqhtbdma4NfFSruPnIYtIGi6LC3Jh4o3Inw0+q+cte/Jvw0VplZq
         6P2+7Hap/2gqsDXoyrxqSGG6MuJglxt7cZQ3bn5dRIvq/0EDX4QiHmxKzJQ/mzaH7B
         64uRNaa5jNE5rMiCpUjxdzqldF/NdYaE1UTkSYnz7tuFZXP1EOJxYo/ddJiI6/E9+j
         i6Gph6PYhzlIgGewjJzUM1IY7mIA7ppfK2H0b7P7V46MDGrN9f3boFqo/ePRaPOxq6
         thn6MwFN/qmD+o/7bRsRk+ayqVIJWKFp2s7UJPz+j4fWsyprllFMuW4OyAZLdt7Tr2
         OsyvzwjuI3E8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oaDdE-00B4JL-VQ;
        Mon, 19 Sep 2022 11:04:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Reiji Watanabe <reijiw@google.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix bugs of single-step execution enabled by userspace
Date:   Mon, 19 Sep 2022 11:04:01 +0100
Message-Id: <166358182480.2829822.10216167209295970084.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220917010600.532642-1-reijiw@google.com>
References: <20220917010600.532642-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, reijiw@google.com, linux-arm-kernel@lists.infradead.org, ricarkol@google.com, jingzhangos@google.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, suzuki.poulose@arm.com, pbonzini@redhat.com, james.morse@arm.com, rananta@google.com, kvm@vger.kernel.org
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

On Fri, 16 Sep 2022 18:05:56 -0700, Reiji Watanabe wrote:
> This series fixes two bugs of single-step execution enabled by
> userspace, and add a test case for KVM_GUESTDBG_SINGLESTEP to
> the debug-exception test to verify the single-step behavior.
> 
> Patch 1 fixes a bug that KVM might unintentionally change PSTATE.SS
> for the guest when single-step execution is enabled for the vCPU by
> userspace.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Preserve PSTATE.SS for the guest while single-step is enabled
      commit: 34fbdee086cfcc20fe889d2b83afddfbe2ac3096
[2/4] KVM: arm64: Clear PSTATE.SS when the Software Step state was Active-pending
      commit: 370531d1e95be57c62fdf065fb04fd8db7ade8f9
[3/4] KVM: arm64: selftests: Refactor debug-exceptions to make it amenable to new test cases
      commit: ff00e737090e0f015059e59829aaa58565b16321
[4/4] KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP
      commit: b18e4d4aebdddd05810ceb2f73d7f72afcd11b41

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

