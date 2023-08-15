Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC7B77D6A7
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbjHOX3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbjHOX24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:28:56 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC9D98
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:28:54 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b9b5ee9c5aso93135631fa.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692142133; x=1692746933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdNRv3vafCuyDrqB+n8+gIjJewhkzMEcQknvKyMzHps=;
        b=Cv33u7OxmWIF91fZgxdk2/XjKLfXMlPd6pER6F5YS14+3WQBgXzDxNzWthVLuq37zo
         Tijtw4BisAnREscZqugPZSfUFN9DVLaQe/6xsjkG+nLFl6wT7eF+2QC3aczlhWTrsWRc
         0eYO3QPGA0/lB2GZRx3VBtTNCaJX2nb25nnyF4p1MRxkRoiQ/EGxI6n3DP1MYHVrHgap
         xJtA6+pEbyVoGWlIaP87FfUVGTb44dsFrcZyYW4vtLGVeJMgNPcxmbrQNXjjrBXZBD/v
         sRzcTNbiVB4a1uQVRR/Bw0Hys4ppEk748VM5xb95VRSLRY3MFVPsLk8dJakRg/wW2Bds
         fTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692142133; x=1692746933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tdNRv3vafCuyDrqB+n8+gIjJewhkzMEcQknvKyMzHps=;
        b=O+P9lzMu5m+RiC46NJze72OeMLXwu0QTcbAbvYN9xrtvP63zasTZf4LDQOOv7HVeFW
         r0WdDdmiOSYc1hwGGIJSSWaEnqnskgeoFPk1WgyMu4NwksDSb/LUGIM4OVO9u6ZvWStH
         snKE50zAuBMB776/q8Fw0rFFidg5HzZBbjG1eXV6WoeqqPzkaCsEzGjRsftZszRZlLMA
         oUi2Wg0QIzXZgdKKmGLC0+t9v2/d4GTtyMxeEAuNV1v1KGVvEM3GzC++anRrZak2ySmi
         gdz9fwgt5qpvMoAmpyX1Al3JnaZ5Op62/NFrywos2XRvNhJxSo2Hsfs8QWoMmFfBhP35
         Q/Rw==
X-Gm-Message-State: AOJu0YwhnEblpM/VO2slFPNiXeKZckBpcrDVk2h+v9cdxmGdiVoA5P5g
        UVwwIRkXIFKWHTx2NqvUVRIQyU9XamQcFS4nLiiXyQ==
X-Google-Smtp-Source: AGHT+IG8dMxkf/NsuhkaETZ1xc2m6q3/iV8JR4cGiRVhUhuHwBcqzPEkWxrcRQxEmIroRBttAL8DlU/uJCR1spu0Uz8=
X-Received: by 2002:a2e:241a:0:b0:2b9:df53:4c2a with SMTP id
 k26-20020a2e241a000000b002b9df534c2amr183575ljk.20.1692142132865; Tue, 15 Aug
 2023 16:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-25-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-25-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 16:28:40 -0700
Message-ID: <CAAdAUtjNVK8fPtCW0b6QV94fNeDYn1V+o+RR0dSN_eWibN7BnQ@mail.gmail.com>
Subject: Re: [PATCH v4 24/28] KVM: arm64: nv: Expand ERET trap forwarding to
 handle FGT
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> We already handle ERET being trapped from a L1 guest in hyp context.
> However, with FGT, we can also have ERET being trapped from L2, and
> this needs to be reinjected into L1.
>
> Add the required exception routing.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 3b86d534b995..617ae6dea5d5 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -222,7 +222,22 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>         if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
>                 return kvm_handle_ptrauth(vcpu);
>
> -       kvm_emulate_nested_eret(vcpu);
> +       /*
> +        * If we got here, two possibilities:
> +        *
> +        * - the guest is in EL2, and we need to fully emulate ERET
> +        *
> +        * - the guest is in EL1, and we need to reinject the
> +         *   exception into the L1 hypervisor.
> +        *
> +        * If KVM ever traps ERET for its own use, we'll have to
> +        * revisit this.
> +        */
> +       if (is_hyp_ctxt(vcpu))
> +               kvm_emulate_nested_eret(vcpu);
> +       else
> +               kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +
>         return 1;
>  }
>
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
