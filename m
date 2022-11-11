Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1F66261BD
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 20:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiKKTG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 14:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKKTG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 14:06:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A6391FF
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 11:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95FF8620B3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 19:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3515C433D6;
        Fri, 11 Nov 2022 19:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668193579;
        bh=glUZLqZQVoxiOyzIfHGRfq6bY6J3iXv73EeOSZbGuyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCBMVH408hR6/dNC2gHgo8eXBO9ISeYqcfw0MnUnTjUhENnIn4IGEBkQh/18pmJyD
         mRpvEOxI8tstgnQERg/ZjUfO7dk42BJPM5FlYpRM8N3YYOySErzlVPGgtdwxl1ZiGr
         pQRUVAhma5N1O7OoJF4bflUWIPnUiGmSJo4UIMjdRY0ljuG6fcob0OuM0G2c+6AF84
         shi4o3fgBvtQJWNkT7puMyy7Q7n9uQ68gxrDjBbDYjw4+sy3l++psfdYBd7I03agnx
         ft/td6Kl43SCJBZ10nmHAq4onJbtRSGso7AXnaJiwh8P2Q6Z38gnDkaHa/HIYI1poS
         c1dJvDVXqZ0SA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1otZM1-005Ux5-IC;
        Fri, 11 Nov 2022 19:06:17 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc:     Vincent Donnefort <vdonnefort@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH v6 00/26] KVM: arm64: Introduce pKVM hyp VM and vCPU state at EL2
Date:   Fri, 11 Nov 2022 19:06:14 +0000
Message-Id: <166819337067.3836113.13147674500457473286.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.linux.dev, vdonnefort@google.com, james.morse@arm.com, mark.rutland@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, qperret@google.com, philmd@linaro.org, suzuki.poulose@arm.com, tabba@google.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, seanjc@google.com, catalin.marinas@arm.com, chao.p.peng@linux.intel.com
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

On Thu, 10 Nov 2022 19:02:33 +0000, Will Deacon wrote:
> This is version six of the pKVM EL2 state series, extending the pKVM
> hypervisor code so that it can dynamically instantiate and manage VM
> data structures without the host being able to access them directly.
> These structures consist of a hyp VM, a set of hyp vCPUs and the stage-2
> page-table for the MMU. The pages used to hold the hypervisor structures
> are returned to the host when the VM is destroyed.
> 
> [...]

As for Oliver's series, I've tentatively applied this to -next.
I've dropped Oliver's patch for now, but kept the RFC one. Maybe I'll
change my mind.

Anyway, there was an interesting number of conflicts between the two
series, which I tried to resolve as well as I could, but it is likely
I broke something (although it compiles, so it must be perfect).

Please have a look and shout if/when you spot something.

[01/26] KVM: arm64: Move hyp refcount manipulation helpers to common header file
        commit: 0f4f7ae10ee4e6403659b2d9ddf05424eecde45b
[02/26] KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
        commit: 72a5bc0f153ce8ca80e9abbd1d9adec7d586915a
[03/26] KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory
        commit: 8e6bcc3a4502a0d8d065466efd888b6b59b85789
[04/26] KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
        commit: 0d16d12eb26ef85602ef8a678d94825a66772774
[05/26] KVM: arm64: Unify identifiers used to distinguish host and hypervisor
        commit: 33bc332d4061e95db55594893c4f80105b1dd813
[06/26] KVM: arm64: Implement do_donate() helper for donating memory
        commit: 1ed5c24c26f48ff61dc5d97c655769821f36a622
[07/26] KVM: arm64: Prevent the donation of no-map pages
        commit: 43c1ff8b75011bc3e3e923adf31ba815864a2494
[08/26] KVM: arm64: Add helpers to pin memory shared with the hypervisor at EL2
        commit: 9926cfce8dcb880255f30ab9ac930add787e1ead
[09/26] KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
        commit: 4d968b12e6bbe4440f4f220c41d779e02df8af1a
[10/26] KVM: arm64: Add hyp_spinlock_t static initializer
        commit: 1c80002e3264552d8b9c0e162e09aa4087403716
[11/26] KVM: arm64: Rename 'host_kvm' to 'host_mmu'
        commit: 5304002dc3754a5663d75c977bfa2d9e3c08906d
[12/26] KVM: arm64: Add infrastructure to create and track pKVM instances at EL2
        commit: a1ec5c70d3f63d8a143fb83cd7f53bd8ff2f72c8
[13/26] KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1
        commit: 9d0c063a4d1d10ef8e6288899b8524413e40cfa0
[14/26] KVM: arm64: Add per-cpu fixmap infrastructure at EL2
        commit: aa6948f82f0b7060fbbac21911dc7996b144ba3c
[15/26] KVM: arm64: Initialise hypervisor copies of host symbols unconditionally
        commit: 6c165223e9a6384aa1e934b90f2650e71adb972a
[16/26] KVM: arm64: Provide I-cache invalidation by virtual address at EL2
        commit: 13e248aab73d2f1c27b458ef09d38b44f3e5bf2e
[17/26] KVM: arm64: Add generic hyp_memcache helpers
        commit: 717a7eebac106a5cc5d5493f8eef9cf4ae6edf19
[18/26] KVM: arm64: Consolidate stage-2 initialisation into a single function
        commit: 315775ff7c6de497dd07c3f6eff499fb538783eb
[19/26] KVM: arm64: Instantiate guest stage-2 page-tables at EL2
        commit: 60dfe093ec13b056856c672e1daa35134be38283
[20/26] KVM: arm64: Return guest memory from EL2 via dedicated teardown memcache
        commit: f41dff4efb918db68923a826e966ca62c7c8e929
[21/26] KVM: arm64: Unmap 'kvm_arm_hyp_percpu_base' from the host
        commit: fe41a7f8c0ee3ee2f682f8c28c7e1c5ff2be8a79
[22/26] KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
        commit: 73f38ef2ae531b180685173e0923225551434fcb
[23/26] KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
        commit: 27eb26bfff5d358d42911d04bbecc62e659ec32b
[24/26] KVM: arm64: Don't unnecessarily map host kernel sections at EL2
        commit: 169cd0f8238f2598b85d2db2e15828e8f8da18e5
[25/26] KVM: arm64: Clean out the odd handling of completer_addr
        (no commit info)
[26/26] KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()
        commit: be66e67f175096f283c9d5614c4991fc9e7ed975

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


