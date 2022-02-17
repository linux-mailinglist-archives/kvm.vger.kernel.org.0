Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05DD4BA5F6
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbiBQQa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:30:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBQQa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:30:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB9816BF84
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B56B819D8
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 16:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE907C340E8;
        Thu, 17 Feb 2022 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645115410;
        bh=sKibz8OzQha4IEtN1WKsG3GJ7XK5Q1A3GcQLBBLeAak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpllzW2EpQnF667KIDoAmwzLnNggIf1+lxYcPcJvDmqc0aaxdzSS5zUzZvTnn/rxu
         m5CLZN/uotGOPyce3KKZE5Aw5RuNYh6R69LFtddIVuh/0fOuKPu6Shv2+LCuMHBF5e
         YA9pMhVSBqA/BvoFXHRgJzoBgwsSyl72kfjyDqVpRN8arvnXFQGwGVUKL76DKYjIF3
         hrp75T9mtuznx97/FxHhp9boWtJu87PnqxDClLjVcfPZk2783kU7FCoNNOcSEaUDh9
         75E/E6sJuSklSpRuuAw0JAfBkKsslQUHMluQ3L8yybJS/lhS4jG80vLRiNO2Xwzp7c
         6R4Y4rdPhbELQ==
Received: from static-176-185-135-154.ftth.abo.bbox.fr ([176.185.135.154] helo=localhost.localdomain)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKjfU-008dH9-9v; Thu, 17 Feb 2022 16:30:08 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't miss pending interrupts for suspended vCPU
Date:   Thu, 17 Feb 2022 16:30:01 +0000
Message-Id: <164511451219.2024117.15534854729772713949.b4-ty@kernel.org>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220217101242.3013716-1-oupton@google.com>
References: <20220217101242.3013716-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 176.185.135.154
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, maz@kernel.org, ricarkol@google.com, alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, reijiw@google.com, pshier@google.com, pbonzini@redhat.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Feb 2022 10:12:42 +0000, Oliver Upton wrote:
> In order to properly emulate the WFI instruction, KVM reads back
> ICH_VMCR_EL2 and enables doorbells for GICv4. These preparations are
> necessary in order to recognize pending interrupts in
> kvm_arch_vcpu_runnable() and return to the guest. Until recently, this
> work was done by kvm_arch_vcpu_{blocking,unblocking}(). Since commit
> 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch
> callback hook"), these callbacks were gutted and superseded by
> kvm_vcpu_wfi().
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't miss pending interrupts for suspended vCPU
      commit: a867e9d0cc15039a6ef72e17e2603303dcd1783f
