Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534C06D8634
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjDESp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjDESp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF644C31
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 11:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75D47627F1
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 18:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE859C433D2;
        Wed,  5 Apr 2023 18:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680720324;
        bh=J4UXmvYvYK4qcl8j2VAxL3b5OKdzwzoxr4JqIjRd1yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OC9h/SL18UE5n/uOg4q4G/GN7qko2Gk5oICyENCvzkROtev2tYyDsRHI/ynEzzZHA
         GK4xicRbSI9LnBJyeb1DTvtMZ5ehTYz8jDrdt6VFJrdtUSiyxIbtDzBWub79w7WGVX
         6M4KJajC1dPsiWx3/bPeCetPV8K301erbcvRkexa+R8Y/d3PVdG9cGGiBxhlfOmx0r
         E1w8/9irS30pz+LvRJTP5tpNkAutbN4hVfIoUYpFy9HQbdbqdyKspJyfDYbU5c7F1t
         DC8MeXE/hlMNyDKJNGn84J2ENapalf+LtYeLPTrrdR8XawY1HHR7mPD4gpSJ9HENTB
         6kU5WwjAEACUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk88I-0065Zq-Eb;
        Wed, 05 Apr 2023 19:45:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/13] KVM: arm64: Userspace SMCCC call filtering
Date:   Wed,  5 Apr 2023 19:45:18 +0100
Message-Id: <168072017406.3602423.3927825887664687371.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404154050.2270077-1-oliver.upton@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, pbonzini@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, salil.mehta@huawei.com, seanjc@google.com, yuzenghui@huawei.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Apr 2023 15:40:37 +0000, Oliver Upton wrote:
> The Arm SMCCC is rather prescriptive in regards to the allocation of
> SMCCC function ID ranges. Many of the hypercall ranges have an
> associated specification from Arm (FF-A, PSCI, SDEI, etc.) with some
> room for vendor-specific implementations.
> 
> The ever-expanding SMCCC surface leaves a lot of work within KVM for
> providing new features. Furthermore, KVM implements its own
> vendor-specific ABI, with little room for other implementations (like
> Hyper-V, for example). Rather than cramming it all into the kernel we
> should provide a way for userspace to handle hypercalls.
> 
> [...]

Applied to next, thanks!

[01/13] KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
        commit: e65733b5c59a1ea20324a03494364958bef3fc68
[02/13] KVM: arm64: Add a helper to check if a VM has ran once
        commit: de40bb8abb764f6866d82c4e2a43acdb22892cf4
[03/13] KVM: arm64: Add vm fd device attribute accessors
        commit: e0fc6b21616dd917899ee4a2d4126b4a963c0871
[04/13] KVM: arm64: Rename SMC/HVC call handler to reflect reality
        commit: aac94968126beb9846c12a940f1302ece7849b4f
[05/13] KVM: arm64: Start handling SMCs from EL1
        commit: c2d2e9b3d8ce9db825a5630d9d52d542f5138ae0
[06/13] KVM: arm64: Refactor hvc filtering to support different actions
        commit: a8308b3fc9494953c453480fb277e24f82f7d2b9
[07/13] KVM: arm64: Use a maple tree to represent the SMCCC filter
        commit: fb88707dd39bd1d5ec4a058776de9ee99bcc7b72
[08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
        commit: d824dff1919bbd523d4d5c860437d043c0ad121d
[09/13] KVM: arm64: Introduce support for userspace SMCCC filtering
        commit: 821d935c87bc95253f82deec3cbb457ccf3de003
[10/13] KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
        commit: 7e484d2785e2a2e526a6b2679d3e4c1402ffe0ec
[11/13] KVM: arm64: Let errors from SMCCC emulation to reach userspace
        commit: 37c8e494794786aa8e4acba1f0f5b45f37b11699
[12/13] KVM: selftests: Add a helper for SMCCC calls with SMC instruction
        commit: fab19915f498b0e76fabd4d78841c99b7b6d7851
[13/13] KVM: selftests: Add test for SMCCC filter
        commit: 60e7dade498eb881bcdf0d9a420c97625f73acc1

I've also added the extra patch to deal with with AArch32 T1
encodings of HVC/SMC. Please check the conflict resolution!

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


