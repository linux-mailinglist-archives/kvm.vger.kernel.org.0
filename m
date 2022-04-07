Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F864F7C21
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 11:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244013AbiDGJtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 05:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244014AbiDGJtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 05:49:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7231A7773
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 02:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A91D261B2F
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 09:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E15C385A4;
        Thu,  7 Apr 2022 09:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649324851;
        bh=ov8hUREiFkfx9WQR6MbrdhRmIn5JuS4ippBd4nbLP+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKaERjZOBt/VaP+NDZ5pTDV+osWGjYPbYCeqD37+VNkzZ8Yts8lLxRnVhR7O5UtVt
         LYoi8mv+Q9vqf9ucoqfI+WE2DdqCzvKMAsaZ0kR3gNSuOCWQtCn2Zi+59vhsbcXasi
         lt6hd+4aYEm+hv14GoWcGa2j+XrRRt0DpuzivVaP9t3fvo9G63Z+B5jzzotawM0MDS
         MkyiMkzwbhMMRj/vLdhDb1uE9+S7FevRVt9o8+oIsfHPEJTHhLGKHiKocDrKdrhMyg
         xrWu8UHTTRck6fRn/32e0jmljZoBnn/WdZNdhol82VS/EnFUCu7oWBuIwITFzywDUY
         sJKDt/Rx4Syfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ncOjg-002RDv-LA; Thu, 07 Apr 2022 10:47:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] KVM: Fix use-after-free in debugfs
Date:   Thu,  7 Apr 2022 10:47:25 +0100
Message-Id: <164932482949.4015708.14856763096234436640.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
References: <20220406235615.1447180-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, reijiw@google.com, seanjc@google.com, alexandru.elisei@arm.com, ricarkol@google.com, linux-arm-kernel@lists.infradead.org, pshier@google.com, suzuki.poulose@arm.com, pbonzini@redhat.com, james.morse@arm.com, kvm@vger.kernel.org
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

On Wed, 6 Apr 2022 23:56:12 +0000, Oliver Upton wrote:
> Funny enough, dirty_log_perf_test on arm64 highlights some issues around
> the use of debugfs in KVM. The test leaks a GIC FD across test
> iterations, and as such the associated VM is never destroyed.
> Nonetheless, the VM FD is reused for the next VM, which collides with
> the old debugfs directory.
> 
> Where things get off is when the vgic-state debugfs file is created. KVM
> does not check if the VM directory exists before creating the file,
> which results in the file being added to the root of debugfs when the
> aforementioned collision occurs.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: Don't create VM debugfs files outside of the VM directory
      commit: a44a4cc1c969afec97dbb2aedaf6f38eaa6253bb
[2/3] selftests: KVM: Don't leak GIC FD across dirty log test iterations
      commit: 386ba265a8197716076a88853244f4437b92b167
[3/3] selftests: KVM: Free the GIC FD when cleaning up in arch_timer
      commit: 21db83846683d3987666505a3ec38f367708199a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


