Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D597211D9
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 21:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjFCTRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 15:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFCTRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 15:17:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C3F1AD
        for <kvm@vger.kernel.org>; Sat,  3 Jun 2023 12:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685819811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M4o0k3datcaUU/TmUVbwYLxyr5WzpSezN+J1D4IJgBE=;
        b=Oz7AOpkFSDjCuvg0qlIrmbftH2YdXmJ+3rYI0Lc8KYGPTHwlx56rjavKjZN0vI1hE9vqgH
        e7Gte4dHjtZiqF3WQoCDqReB9ZkPPXE5GTPFXnL8K9V6QNGvl6fTSd1pBgdWwaJ07ip9Y7
        gL734lTkgHmMNox7L7PP8WaNCdSusNI=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-_E2v8ATQOYi7tzsg_XFjwA-1; Sat, 03 Jun 2023 15:16:49 -0400
X-MC-Unique: _E2v8ATQOYi7tzsg_XFjwA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-789c45e1e51so900741241.0
        for <kvm@vger.kernel.org>; Sat, 03 Jun 2023 12:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685819809; x=1688411809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4o0k3datcaUU/TmUVbwYLxyr5WzpSezN+J1D4IJgBE=;
        b=Z89ScCFr5VTdQvSm8yeEo318yK792i13mj8ux/t2e9O6kxbtlTl/hxI2g5vHYrQhg9
         /aPD445/CckgDSub7xAnyGJl/yS+aOWgA3svy/D6CDj6mJiPQ6Cfn/L83T5YcGgMsebT
         Jrda9e2GokRCgQ+5YfXrwH6Zk5kLUOhEO8neP5LA2J+X7fViCcRrIq2yXLH43WQ/Uta4
         pFnyyrMsIELqgszFKmUFXapj2cGqmeXnujtmJdJ0x6tHiASltYnONudr8eXi/fAe8v16
         yKTsiTaFOpkpPqqCWPfK3J6Y3DZkHwxlfWkR2uvcwsrKBF4YzYZtGsnGgbqLdj6cwnKo
         Klyg==
X-Gm-Message-State: AC+VfDxxh6WUfU6WVtrmr2d9XO8msojsRYwL3oFK4sJYP1SP06xoRD2N
        9LqOG739J7h19ET3wUH4dGehu/VUKKIFARn5W3amtigZMDUw74y+PtcByOMFTQsfKeEjWZzzsfm
        lJl60fKJmLt5eBjLbVQPW+VsQJJXk
X-Received: by 2002:a67:ead2:0:b0:43b:298f:ed6e with SMTP id s18-20020a67ead2000000b0043b298fed6emr1954650vso.30.1685819808758;
        Sat, 03 Jun 2023 12:16:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7FcmiNdTHlNrtp/QP2ZTTg/GDP+onBpgDJrEavKZ/00QU2LrieG2uUGPDLsTfnTfpRUl42Q9tH6v0HzgnRY2I=
X-Received: by 2002:a67:ead2:0:b0:43b:298f:ed6e with SMTP id
 s18-20020a67ead2000000b0043b298fed6emr1954638vso.30.1685819808536; Sat, 03
 Jun 2023 12:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230531100305.430120-1-maz@kernel.org>
In-Reply-To: <20230531100305.430120-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 3 Jun 2023 21:16:37 +0200
Message-ID: <CABgObfbb0oPO1jv4OR-4xuXNfz-cKbPs9KgFRuuER9CHnaYAxg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #3
To:     Marc Zyngier <maz@kernel.org>
Cc:     Akihiko Odaki <akihiko.odaki@daynix.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Yu Zhao <yuzhao@google.com>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 12:03=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the third batch of fixes for 6.4: yet another MMU-related fix,
> an external debug bug fix and the obligatory PMU fix.
>
> Note that since you don't seem to have pulled kvmarm-fixes-6.4-2[1]
> just yet, pulling this will drag both tags.
>
> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/r/20230524125757.3631091-1-maz@kernel.org
>
> The following changes since commit a9f0e3d5a089d0844abb679a5e99f15010d53e=
25:
>
>   KVM: arm64: Reload PTE after invoking walker callback on preorder trave=
rsal (2023-05-24 13:47:12 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.4-3

Pulled, thanks (a bit more speedily than #2, fortunately).

Paolo

> for you to fetch changes up to 40e54cad454076172cc3e2bca60aa924650a3e4b:
>
>   KVM: arm64: Document default vPMU behavior on heterogeneous systems (20=
23-05-31 10:29:56 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.4, take #3
>
> - Fix the reported address of a watchpoint forwarded to userspace
>
> - Fix the freeing of the root of stage-2 page tables
>
> - Stop creating spurious PMU events to perform detection of the
>   default PMU and use the existing PMU list instead.
>
> ----------------------------------------------------------------
> Akihiko Odaki (1):
>       KVM: arm64: Populate fault info for watchpoint
>
> Oliver Upton (3):
>       KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
>       KVM: arm64: Iterate arm_pmus list to probe for default PMU
>       KVM: arm64: Document default vPMU behavior on heterogeneous systems
>
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  8 +++--
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 ++
>  arch/arm64/kvm/hyp/pgtable.c            |  3 ++
>  arch/arm64/kvm/hyp/vhe/switch.c         |  1 +
>  arch/arm64/kvm/pmu-emul.c               | 58 +++++++++++++--------------=
------
>  5 files changed, 35 insertions(+), 37 deletions(-)
>

