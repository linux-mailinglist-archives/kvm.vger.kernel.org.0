Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7577F345
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 11:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349605AbjHQJ3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 05:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349641AbjHQJ3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 05:29:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4312712
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 02:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDF5A6624A
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 09:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2448EC433C7;
        Thu, 17 Aug 2023 09:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692264571;
        bh=0PTCv8BrIVMJUjmKixV2bEKBL/aXU/1ljGkJ3AG/cak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iToFXREVJKpzs9nQmAO2jwbhewqe1y6AWRdEWU0c9GBZkJslbzOIxpqDhAkSavSqk
         7eS5WP0EpB+AjzOzZnnsFudmBt71co3oPwBPsqWJBnwvJE5aYvbA1X42p8O9IYByBZ
         7QU2egwPPN1ueWdCu03OvJsQCgcz6kfvfWkpXDYpbbZWsTcJCYh89eg7ndvpsXDKUO
         RcW3WdhyNbZNDl+McdH59E27Ec25WLYAlOUgPpN5fiiSS9KJ7WQx75aFscmIYJ3EQ3
         aoYUStCmkS7VYfs49j9yqaqDukIrE9BLc1XDxcHbOSrgUASXMded1L+E77yyn7yK7D
         f28E3lad38iLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qWZJo-005dbi-VY;
        Thu, 17 Aug 2023 10:29:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Chase Conklin <chase.conklin@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andre Przywara <andre.przywara@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Miguel Luis <miguel.luis@oracle.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 00/28] KVM: arm64: NV trap forwarding infrastructure
Date:   Thu, 17 Aug 2023 10:29:26 +0100
Message-Id: <169226452281.2753740.4810898175548882849.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, maz@kernel.org, broonie@kernel.org, chase.conklin@arm.com, jingzhangos@google.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, andre.przywara@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, darren@os.amperecomputing.com, eric.auger@redhat.com, yuzenghui@huawei.com, will@kernel.org, miguel.luis@oracle.com, gankulkarni@os.amperecomputing.com, james.morse@arm.com, mark.rutland@arm.com
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

On Tue, 15 Aug 2023 19:38:34 +0100, Marc Zyngier wrote:
> Another week, another version. Change log below.
> 
> I'll drop this into -next now, and see what happens.
> 
> * From v3 [3]:
> 
>   - Renamed trap_group to cgt_group_id (Eric)
> 
> [...]

Applied to next, thanks!

[01/28] arm64: Add missing VA CMO encodings
        commit: 21f74a51373791732baa0d672a604afa76d5718d
[02/28] arm64: Add missing ERX*_EL1 encodings
        commit: 464f2164da7e4cb50faec9d56226b22c9b36cdda
[03/28] arm64: Add missing DC ZVA/GVA/GZVA encodings
        commit: 6ddea24dfd59f0fc78a87df54d428e3a6cf3e11f
[04/28] arm64: Add TLBI operation encodings
        commit: fb1926cccd70a5032448968dfd639187cd894cb7
[05/28] arm64: Add AT operation encodings
        commit: 2b97411fef8ff9dafc862971f08382f780dc5357
[06/28] arm64: Add debug registers affected by HDFGxTR_EL2
        commit: 57596c8f991c9aace47d75b31249b8ec36b3b899
[07/28] arm64: Add missing BRB/CFP/DVP/CPP instructions
        commit: 2b062ed483ebd625b6c6054b9d29d600bd755a86
[08/28] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
        commit: cc24f656f7cf834f384a43fc6fe68ec62730743d
[09/28] arm64: Add feature detection for fine grained traps
        commit: b206a708cbfb352f2191089678ab595d24563011
[10/28] KVM: arm64: Correctly handle ACCDATA_EL1 traps
        commit: 484f86824a3d94c6d9412618dd70b1d5923fff6f
[11/28] KVM: arm64: Add missing HCR_EL2 trap bits
        commit: 3ea84b4fe446319625be64945793b8540ca15f84
[12/28] KVM: arm64: nv: Add FGT registers
        commit: 50d2fe4648c50e7d33fa576f6b078f22ad973670
[13/28] KVM: arm64: Restructure FGT register switching
        commit: e930694e6145eb210c9931914a7801cc61016a82
[14/28] KVM: arm64: nv: Add trap forwarding infrastructure
        commit: e58ec47bf68d2bcaaa97d80cc13aca4bc4abe07b
[15/28] KVM: arm64: nv: Add trap forwarding for HCR_EL2
        commit: d0fc0a2519a6dd906aac448e742958d30b5787ac
[16/28] KVM: arm64: nv: Expose FEAT_EVT to nested guests
        commit: a0b70fb00db83e678f92b8aed0a9a9e4ffcffb82
[17/28] KVM: arm64: nv: Add trap forwarding for MDCR_EL2
        commit: cb31632c44529048c052a2961b3adf62a2c89b17
[18/28] KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
        commit: e880bd3363237ed8abbe623d1b49d59d5f6fe0d1
[19/28] KVM: arm64: nv: Add fine grained trap forwarding infrastructure
        commit: 15b4d82d69d7b0e5833b7a023dff3d7bbae5ccfc
[20/28] KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
        commit: 5a24ea7869857251a83da1512209f76003bc09db
[21/28] KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
        commit: 039f9f12de5fc761d2b32fa072071533aa8cbb3b
[22/28] KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
        commit: d0be0b2ede13247c53745d50e2a5993f2b27c802
[23/28] KVM: arm64: nv: Add SVC trap forwarding
        commit: a77b31dce4375be15014b10e8f94a149592ea6b6
[24/28] KVM: arm64: nv: Expand ERET trap forwarding to handle FGT
        commit: ea3b27d8dea081f1693b310322ae71fa75d1875b
[25/28] KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
        commit: d4d2dacc7cddc37aaa7c6eed8665d533d1037e1e
[26/28] KVM: arm64: nv: Expose FGT to nested guests
        commit: 0a5d28433ad94cc38ecb3dbb5138b8ae30ffb98a
[27/28] KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
        commit: a63cf31139b7f41d468dc8ef63dbf6bae213d960
[28/28] KVM: arm64: nv: Add support for HCRX_EL2
        commit: 03fb54d0aa73cc14e51f6611eb3289e4fec15184

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


