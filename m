Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00853608578
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 09:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJVHd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 03:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJVHdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 03:33:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E9657E3C
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 00:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666424034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eQot4DamRtIVvtNXrDIRa8lRq5oa24j9DE2lulJ2uFI=;
        b=Y0xXSuF2UGuYsU/EKHmL8byVGrExId+yDbjTOenvwYSdsFxRGHqREi48e81bHnk46Dx4Cd
        cDqz0FiYEBO8pfvRrTAovlWHKEAVPrtkEPyPmilJuG6IRq0O3W8h0bO0ZPYLxga1Ut4hsJ
        I5lB96MDa8kbUIjTnCulTQM4gUQPo8Q=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-6hP_TylEMd6IROvy2w3SHQ-1; Sat, 22 Oct 2022 03:33:52 -0400
X-MC-Unique: 6hP_TylEMd6IROvy2w3SHQ-1
Received: by mail-ua1-f69.google.com with SMTP id b13-20020ab0140d000000b003e39e1390f9so2960406uae.18
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 00:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQot4DamRtIVvtNXrDIRa8lRq5oa24j9DE2lulJ2uFI=;
        b=4Eu4aP8uEGaONdTjbR5rOthU4lQjAQ+0BgR8c7Gr+nzDWnQB9hBSOK+nIJxdiWghzR
         +MtTPfQ4jQYYM3PcYQ7qAqccaom8zNOe46x4hEkCBWN8S5hmG5nX/nKWiEwUgw6TkP2f
         UcyYBXfl/MkmiRDQHOtXOL1oI3k5EBeABhRCxm9bfQWAg/Mf/80pyYkp0CuUDyrz27rs
         knYM724nr7qOnI36YCbZOxQH+J9ttWh1LwmD6sjLLIeudgPFm/gmi7uh3Vq0h6wP9PSX
         5Jyd44PF9HBb+bAkLZXj91ff3tT4du+CqqpdvVxNO5vuT5em/d1kDZhb27CTZqDal/Kb
         RFCA==
X-Gm-Message-State: ACrzQf3GugiKOl/ivrBS2M4rVdYmUiyKm1LZl/A4GlCdTaO2Y1wefjQs
        XTb3i8ReY8o3UxWCm8P1YcK+AU+j+NEXF/XKMbhz8gK3U5FiBHVdS7Qux32sZW7pJxfIMswdbFr
        08WN1W5rc5UJnQJlCtp/+jVaP2cjm
X-Received: by 2002:a05:6122:1809:b0:3ae:d68e:92b8 with SMTP id ay9-20020a056122180900b003aed68e92b8mr14353334vkb.10.1666424031898;
        Sat, 22 Oct 2022 00:33:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5XJ6Px8OxHtSAMMDOSIaZ7WomWjAkS8tov7b+lxHhzJeJhpDcwPk1Rbhq4f/pfEg9kswJ6CRijofNfOryUOu0=
X-Received: by 2002:a05:6122:1809:b0:3ae:d68e:92b8 with SMTP id
 ay9-20020a056122180900b003aed68e92b8mr14353325vkb.10.1666424031644; Sat, 22
 Oct 2022 00:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221020100125.3670769-1-maz@kernel.org>
In-Reply-To: <20221020100125.3670769-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 22 Oct 2022 09:33:40 +0200
Message-ID: <CABgObfYexXFT507Ufz3o2SLOAVDWO1AhJV5yKi9Ar1OeLNnPSQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.1, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Denis Nikitin <denik@chromium.org>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 12:02 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's a couple of additional fixes for 6.1. The ITS one is pretty
> annoying as it prevents a VM from being restored if it has a
> convoluted device topology. Definitely a stable candidate.
>
> Note that I can't see that you have pulled the first set of fixes
> which I sent last week[1]. In order to avoid any problem, the current
> pull-request is a suffix of the previous one. But you may want to pull
> them individually in order to preserve the tag descriptions.

Yes, that's why I did. Pulled now, thanks.

Paolo

>
> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/r/20221013132830.1304947-1-maz@kernel.org
>
> The following changes since commit 05c2224d4b049406b0545a10be05280ff4b8ba0a:
>
>   KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test (2022-10-13 11:46:51 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-2
>
> for you to fetch changes up to c000a2607145d28b06c697f968491372ea56c23a:
>
>   KVM: arm64: vgic: Fix exit condition in scan_its_table() (2022-10-15 12:10:54 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.1, take #2
>
> - Fix a bug preventing restoring an ITS containing mappings
>   for very large and very sparse device topology
>
> - Work around a relocation handling error when compiling
>   the nVHE object with profile optimisation
>
> ----------------------------------------------------------------
> Denis Nikitin (1):
>       KVM: arm64: nvhe: Fix build with profile optimization
>
> Eric Ren (1):
>       KVM: arm64: vgic: Fix exit condition in scan_its_table()
>
>  arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
>  arch/arm64/kvm/vgic/vgic-its.c   | 5 ++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>

