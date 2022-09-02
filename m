Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF0E5AB618
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbiIBP7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiIBP7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:59:03 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF26AC6944
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 08:52:53 -0700 (PDT)
Date:   Fri, 2 Sep 2022 15:52:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662133972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=35qjFLrYT3buGXhS8Vj22dIHKr4JB5N0KAUbbHI8coY=;
        b=hk/3SguCOBwdLg4PaMV96tHvBax7zVDo2wR7UXE3ZRYJeJTiu1NlMCJWn19Bk9lzFxgdbn
        28vyKfDFuCrsa0CBJfHtZiTOoOVGkVmKnxBOwGU1yiEPYsSH3WonrlhMx2g7Okx/kA9neo
        uuOob/7GeI76+AzjUE1RrGZjyOd3iqU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 0/7] KVM: arm64: Use visibility hook to treat ID regs
 as RAZ
Message-ID: <YxIm0GE7LA6cvB12@google.com>
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902154804.1939819-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lol, mess up my own copypasta:

On Fri, Sep 02, 2022 at 03:47:56PM +0000, Oliver Upton wrote:
> For reasons unknown, the Arm architecture defines the 64-bit views of
> the 32-bit ID registers as UNKNOWN [1]. This combines poorly with the
					^ on AArch64-only systems.

> fact that KVM unconditionally exposes these registers to userspace,
> which could throw a wrench in migration between 64-bit only systems.
> 
> This series reworks KVM's definition of these registers to RAZ/WI with
> the goal of providing consistent register values across 64-bit machines.
> 
> Patches 1-3 clean up the ID register accessors, taking advantage of the
> fact that the generic accessors know how to handle RAZ.
> 
> Patches 4-6 start switch the handling of potentially nonzero AArch32 ID
> registers to RAZ/WI. RAZ covers up the architecturally UNKNOWN values,
> and WI allows for migration off of kernels that may provide garbage.
> Note that hidden AArch32 ID registers continue to have RAZ behavior with
> the additional expectation of invariance.
> 
> Lastly, patch 7 includes a small test for the issue.
> 
> Applies to 6.0-rc3. Tested with KVM selftests under the fast model w/
> asymmetric 32 bit support and no 32 bit support whatsoever.

[1]: DDI0487H.a Table D12-2 'Instruction encodings for non-Debug System Register accesses'

v1: https://lore.kernel.org/kvmarm/20220817214818.3243383-1-oliver.upton@linux.dev/

--
Thanks,
Oliver

> v1 -> v2:
>  - Collect Reiji's r-b tags (thanks!)
>  - Call sysreg_visible_as_raz() from read_id_reg() (Reiji)
>  - Hoist sysreg_user_write_ignore() into kvm_sys_reg_set_user() (Reiji)
> 
> Oliver Upton (7):
>   KVM: arm64: Use visibility hook to treat ID regs as RAZ
>   KVM: arm64: Remove internal accessor helpers for id regs
>   KVM: arm64: Drop raz parameter from read_id_reg()
>   KVM: arm64: Spin off helper for calling visibility hook
>   KVM: arm64: Add a visibility bit to ignore user writes
>   KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
>   KVM: selftests: Add test for RAZ/WI AArch32 ID registers
> 
>  arch/arm64/kvm/sys_regs.c                     | 150 +++++++++---------
>  arch/arm64/kvm/sys_regs.h                     |  24 ++-
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/aarch64_only_id_regs.c        | 135 ++++++++++++++++
>  5 files changed, 225 insertions(+), 86 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/aarch64_only_id_regs.c
> 
> 
> base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
> -- 
> 2.37.2.789.g6183377224-goog
> 
