Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573547225FC
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbjFEMf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbjFEMfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:35:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D23131
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 05:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE2A6237D
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 12:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A54C4339B;
        Mon,  5 Jun 2023 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685968519;
        bh=vyf9dpzIpcTT5CD+N7Yb/DEe7mgX+DjWnHFGmmhpb9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYlS4rymrjpbxOsjEdcN7Iqp4fArKHCKVaDqOE4F/KWJbvEwMp8j1pRUOPUo9cd/t
         Gkt9MUtgb82N91YlmI/OqAR0U0rrAC+Arowg4GSfHMZM0icrdnq3gVdVIzHTfF7DrD
         6/ggZJZb7fTpQuOd4GEdc2/64zc74SEublgjA8LScmiRNZr1qB5IenXxM1ecWi2jJq
         XnFuE9fjMCVNQ36QmWfkv4DUm1mpNJYFOuyofFuh2nPW9pR9QH8s35WPq206LQcx8u
         Y54E1Z9vVJhyL1covieFLCQzjClsUrR/rA0b+M7KTsqOx73eDdSEh2vNfCkzzYIB46
         1n9aKCF/TYu8Q==
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        Sami Mujawar <sami.mujawar@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH kvmtool v3 0/2] Fix virtio/rng handling in low entropy situations
Date:   Mon,  5 Jun 2023 13:35:12 +0100
Message-Id: <168596748381.3019987.14273263311363710129.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230524112207.586101-1-andre.przywara@arm.com>
References: <20230524112207.586101-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 May 2023 12:22:05 +0100, Andre Przywara wrote:
> At the moment kvmtool uses the /dev/random device to back the randomness
> provided by our virtio/rng implementation. We run it in non-blocking
> mode, so are not affected by the nasty "can block indefinitely"
> behaviour of that file. However:
> - If /dev/random WOULD block, it returns EAGAIN, and we reflect that by
>   adding 0 bytes of entropy to the virtio queue. However the virtio 1.x
>   spec clearly says this is not allowed, and that we should always provide
>   at least one random byte.
> - If the guest is waiting for the random numbers, we still run into an
>   effective blocking situation, because the buffer will only be filled
>   very slowly, effectively stalling or blocking the guest. EDK II shows
>   that behaviour, when servicing the EFI_RNG_PROTOCOL runtime service
>   call, called by the kernel very early on boot.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] virtio/rng: switch to using /dev/urandom
      https://git.kernel.org/will/kvmtool/c/62ba372b0e67
[2/2] virtio/rng: return at least one byte of entropy
      https://git.kernel.org/will/kvmtool/c/bc23b9d9b152

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
