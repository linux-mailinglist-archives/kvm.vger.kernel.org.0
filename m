Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD8B706F93
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 19:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjEQRgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 13:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjEQRgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 13:36:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1044913E
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 10:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684344964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=puQWJvhyxYukjytjCrrZQqa3KW6zW1mGsvpp553sZtw=;
        b=KSzjU7VcBFGGKIBx7wc1oRVqpv6IdFHn+6kIsndKdjm1MNgS9gcuPhTTPIysoajbeDj623
        zwPujYPGuHAOFx8qDxFuhEsBc6x+33o8N/iek7PDKK6cPTpZPVqa2Q6o8I1HelhOYtsDxi
        DCDtIO1bLoIhDCI6loIsXWbXfx9uAWo=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-EkHeXzUpNX2bLsMbLLYPjg-1; Wed, 17 May 2023 13:36:03 -0400
X-MC-Unique: EkHeXzUpNX2bLsMbLLYPjg-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-783bc0aeda5so357715241.1
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 10:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684344961; x=1686936961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puQWJvhyxYukjytjCrrZQqa3KW6zW1mGsvpp553sZtw=;
        b=j7vtUafYkN+I7JlYQ40nHotORCOCiFR4NjkuzACFh2fWXffEe26FcJrcSPWF4qzDAv
         amKbBarh+6+3NaflLa/FA9FEZXLjspolNQF8jbty6TeaLteqGA0ltpOYhshtYc0VvqCT
         l9QekvSWyLM2bU7TSB7NSiNjtq5pq7zGPUSAfg2rapJwM4VbW/Q9/5EpzxMd4brScVWl
         PjF8xbVHKaNohAflrMzDm16FRTFYnGFQsWSCke1CLfStMb66zWIKva5zgm9FFsHwT/Z9
         jswjoMhPMaWqaJkz8DVVs6hIjlzdJnff7NwWsUsHpqWqsq4S0DODvTaiepEXUS29wzFm
         z3VQ==
X-Gm-Message-State: AC+VfDxpmpi6/TNi3vq3DwBDa/9091HzIswdm26IVEd4NVQXeCDqmrNi
        QBcyEDN/TIol4oF9kPfogLxT6zCT6v8GmPImHdAZw9dKTct0+kOdg4ntNPea8+XvCRIJy7SpauE
        7pPn7nrmu0VE0+qsdrCdJ7Pd0SLHz
X-Received: by 2002:a67:e988:0:b0:436:1e1:685e with SMTP id b8-20020a67e988000000b0043601e1685emr13994173vso.28.1684344961432;
        Wed, 17 May 2023 10:36:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5CBOO9lrZpm38AXv4U8EwjpqzO9e3cjzo4meH70K3KkFLoiIuh6P2clRvBZTGyw+vABcuwrE5EAB3pyttPA9c=
X-Received: by 2002:a67:e988:0:b0:436:1e1:685e with SMTP id
 b8-20020a67e988000000b0043601e1685emr13994153vso.28.1684344961140; Wed, 17
 May 2023 10:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230511143638.350228-1-maz@kernel.org>
In-Reply-To: <20230511143638.350228-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 17 May 2023 19:35:50 +0200
Message-ID: <CABgObfYAHbrPJuSHFum4kkeHSb1Msh0u3-6BoOUZVGX6wVd7OQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jingyu Wang <jingyuwang_vip@163.com>,
        Mark Brown <broonie@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 4:37=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's a first set of fixes, most of which has been simmering in -next
> for some time now. The most important one is a series from Oliver,
> plugging a (hard to trigger) race that would result in the wrong
> mapping being established at S2.
>
> The rest is a bunch of cleanups and HW workarounds (the usual Apple
> vgic issue that keeps cropping up on new SoCs).
>
> Please pull,

Done, thanks.

Paolo

> The following changes since commit ac9a78681b921877518763ba0e89202254349d=
1b:
>
>   Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.4-1
>
> for you to fetch changes up to c3a62df457ff9ac8c77efe6d1eca2855d399355d:
>
>   Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes (2023=
-05-11 15:26:01 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.4, take #1
>
> - Plug a race in the stage-2 mapping code where the IPA and the PA
>   would end up being out of sync
>
> - Make better use of the bitmap API (bitmap_zero, bitmap_zalloc...)
>
> - FP/SVE/SME documentation update, in the hope that this field
>   becomes clearer...
>
> - Add workaround for the usual Apple SEIS brokenness
>
> - Random comment fixes
>
> ----------------------------------------------------------------
> Christophe JAILLET (2):
>       KVM: arm64: Slightly optimize flush_context()
>       KVM: arm64: Use the bitmap API to allocate bitmaps
>
> Jingyu Wang (1):
>       KVM: arm64: Fix repeated words in comments
>
> Marc Zyngier (4):
>       KVM: arm64: Constify start/end/phys fields of the pgtable walker da=
ta
>       KVM: arm64: vgic: Add Apple M2 PRO/MAX cpus to the list of broken S=
EIS implementations
>       Merge branch kvm-arm64/misc-6.4 into kvmarm-master/fixes
>       Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes
>
> Mark Brown (3):
>       KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
>       KVM: arm64: Restructure check for SVE support in FP trap handler
>       KVM: arm64: Clarify host SME state management
>
> Oliver Upton (2):
>       KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
>       KVM: arm64: Infer PA offset from VA in hyp map walker
>
>  arch/arm64/include/asm/cputype.h        |  8 +++++++
>  arch/arm64/include/asm/kvm_pgtable.h    |  1 +
>  arch/arm64/kvm/fpsimd.c                 | 26 +++++++++++++--------
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++--
>  arch/arm64/kvm/hyp/pgtable.c            | 41 +++++++++++++++++++++++++--=
------
>  arch/arm64/kvm/inject_fault.c           |  2 +-
>  arch/arm64/kvm/vgic/vgic-v3.c           |  4 ++++
>  arch/arm64/kvm/vmid.c                   |  7 +++---
>  8 files changed, 76 insertions(+), 25 deletions(-)
>

