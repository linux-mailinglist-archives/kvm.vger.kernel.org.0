Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE335775D6
	for <lists+kvm@lfdr.de>; Sun, 17 Jul 2022 13:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGQLB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jul 2022 07:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGQLB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jul 2022 07:01:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4238F167FF
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 04:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3EECBCE0EDB
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 11:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD2EC3411E;
        Sun, 17 Jul 2022 11:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658055682;
        bh=l3P6ZtN25yBtuV1jYZfD0R1nzULlwG+oRZaoxvGTG/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJxyl+GFqOWHymLcnJo55tCHr564CXZrH0BtbuAU9jdr++2goCPxP8NPodg0/eJsD
         Vd+xocw0mfKnMvHdsMImUaRA+0phkVGTeLn/yYiGFAaUiqYM2qim9dU6rUmNFk0bAK
         vVews900uAzFG62LntGfOwZEnqw7fjfGKOq1u+ZJEksgIKQhAJdx3IqK8bjmpMIdcs
         jI6hNPclH9XOuzG6F0iNZm/B7GSOfx8ni1CyOU4PAOFWzRa5q0ZcAGOY95EYwlKoAD
         G5bMr9Y9k/dqEJKiRYOTbFmHj4RLNRZtCo7dGxCpYAoXmkkBmgQ6v0JXjsoN4uroOi
         W+TUM/oudfN3g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oD21Y-007zvY-3q;
        Sun, 17 Jul 2022 12:01:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>, Schspa Shi <schspa@gmail.com>,
        kernel-team@android.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 00/20] KVM: arm64: vgic-v3 userspace access consolidation (and other goodies)
Date:   Sun, 17 Jul 2022 12:01:17 +0100
Message-Id: <165805554134.3537813.13905183767780787937.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, schspa@gmail.com, kernel-team@android.com, suzuki.poulose@arm.com, reijiw@google.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jul 2022 16:20:04 +0100, Marc Zyngier wrote:
> This is a follow-up to [1], which aims a performing a bunch of
> cleanups in the way we expose sysregs to userspace, with a particular
> focus on the GICv3 part of that code.
> 
> * From v1:
>   - A couple of extra cleanups thanks to Reiji's comments
>   - A fix for the breakage of the legacy GICv2 address setup
>   - Collected RBs from Reiji and Oliver, with thanks.
> 
> [...]

Provisionally applied to -next in order to get some exposure during
-rc7. No garantees I'll keep that in though.

[01/20] KVM: arm64: Add get_reg_by_id() as a sys_reg_desc retrieving helper
        commit: da8d120fbafe1d3217d25ac45493538b37cff87c
[02/20] KVM: arm64: Reorder handling of invariant sysregs from userspace
        commit: 1deeffb559663dc44e4b8a61fe7e271fe3b4b836
[03/20] KVM: arm64: Introduce generic get_user/set_user helpers for system registers
        commit: ba23aec9f4f27c00ac7a504aae60cae8a4087a19
[04/20] KVM: arm64: Rely on index_to_param() for size checks on userspace access
        commit: e48407ff9796529a1e5048b9e4d6ea8a0334468e
[05/20] KVM: arm64: Consolidate sysreg userspace accesses
        commit: 978ceeb3e40a59973ff1d1c3d23484f71f141819
[06/20] KVM: arm64: Get rid of reg_from/to_user()
        commit: 5a420ed9646a934e983358aeba1bf3cd993d1cc5
[07/20] KVM: arm64: vgic-v3: Simplify vgic_v3_has_cpu_sysregs_attr()
        commit: b61fc0857a3ad4cdee44128ad13685033e237367
[08/20] KVM: arm64: vgic-v3: Push user access into vgic_v3_cpu_sysregs_uaccess()
        commit: db25081e147c3cc496b8cd8c9d67f992546df6d5
[09/20] KVM: arm64: vgic-v3: Make the userspace accessors use sysreg API
        commit: cbcf14dd23bcf228eb6061991acf3721506b97ae
[10/20] KVM: arm64: vgic-v3: Convert userspace accessors over to FIELD_GET/FIELD_PREP
        commit: 71c3c7753c722b8b10566dcdf1ff0a2eaf33a9c1
[11/20] KVM: arm64: vgic-v3: Use u32 to manage the line level from userspace
        commit: 38cf0bb7625a58625efeef9ec944671464ff7430
[12/20] KVM: arm64: vgic-v3: Consolidate userspace access for MMIO registers
        commit: e1246f3f2df7aec025fd587ac3d7912007d1144d
[13/20] KVM: arm64: vgic-v2: Consolidate userspace access for MMIO registers
        commit: 7e9f723c2a90e41407d5889700169be4797a2009
[14/20] KVM: arm64: vgic: Use {get, put}_user() instead of copy_{from.to}_user
        commit: d7df6f282db67677c06456fd29d47eda0ba060b9
[15/20] KVM: arm64: vgic-v2: Add helper for legacy dist/cpuif base address setting
        commit: 9f968c9266aa30b0e81be0c6a560e45b93bed3dc
[16/20] KVM: arm64: vgic: Consolidate userspace access for base address setting
        commit: 4b85080f4e378f617f88964dec94fd282bcf2af4
[17/20] KVM: arm64: vgic: Tidy-up calls to vgic_{get,set}_common_attr()
        commit: 619064afa9b6f0088b86a1fed20c049cfe94cdf7
[18/20] KVM: arm64: Get rid of find_reg_by_id()
        commit: f6dddbb25572218d2e8ab93bfdad20cddeb99b5a
[19/20] KVM: arm64: Descope kvm_arm_sys_reg_{get,set}_reg()
        commit: c5332898dc35bbed7d3aa02b491e3388315ee481
[20/20] KVM: arm64: Get rid or outdated comments
        commit: 4274d42716d87d5301fdf67eb799e7db08fe73de

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

