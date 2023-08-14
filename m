Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6016A77C218
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 23:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbjHNVJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 17:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjHNVIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 17:08:44 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C073E5E
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 14:08:43 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b9cdba1228so75879091fa.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 14:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692047321; x=1692652121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSp/PBgFuqjU5FU2wSVwIwvbq+BUoL+z7yaXrbjmk7E=;
        b=OS9OcTyyhb0MI7YCPjUC8NTPZAqUrVrUllRWSw1QWEtcLSMWO1aXtrg0HUBCj9yqDf
         qkMl0AjE4N+YwB1uBuRRlsVs1zgxiNdzIROOb0TNV25Fuz5HkyI8Hyv6muEiV9T8Ggzr
         7NTuZsmwSHxBicLIgMgzvrMnVtcrn1f56FqfQSKaOIplzWK4g6pP48WIbHB5PpMCngzk
         Yje2kX4dEXTa1+/0oE3kJ6dlBEBApyN4t5zuZ9vJ3tnWeN7PM86YPbgLH01k2wlzYwj0
         UPL27kWoVw+NW6v7aOqySigoX1koIA0C5FV8OgFovFsK9tzGThAR94nPxD1lEYvi+pCY
         0Fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692047321; x=1692652121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSp/PBgFuqjU5FU2wSVwIwvbq+BUoL+z7yaXrbjmk7E=;
        b=AFY6t8Qde7JgGAnMIODNT+85wv/YQF5JFYLT4gbQ4byxlf3lvIkx5q6wgW105jNRHz
         q9i3nqp0LrRzXJiqLQuVqet0XRaB15H8g0vXh6cZ3a5I8rdCMIj9JJ6+k0HU3Vz5wgbE
         VuBFte+X+fHM3T+67ahpvBFA8DyPt+PhlJiJyUtH9wMeiA883QRUWJLL0jF65Snr2bHV
         LCfhNxXeplX/7EaBgHUiMP0lYJzsOQslETA5Iv0Mrhe9cffVER5lqUmXG1id52n5TdC3
         HupsRYLZSogW5O8UfZrsTMDJONEIWTk3unrhhXhJP+AuMe9GHTH1H3cU7nxbHZO86EwN
         RyiQ==
X-Gm-Message-State: AOJu0YxHh0EXtC18UZpQGhejkGOudXPAGMTuJ0C6efvVdt3VcQ7pXtJL
        rxfzlAunrbAmGLmd5mFtFDzoI4y1ioykk7M8rYWSDw==
X-Google-Smtp-Source: AGHT+IEmydD7Vg63lIM0FBUIs9+BBEzh+aAHaZt+2h9ySTyHScdO/ox2c3DfLJT1FXQenxJY8qkzoCaqPavs81FI74Y=
X-Received: by 2002:a2e:8752:0:b0:2b6:c61c:745b with SMTP id
 q18-20020a2e8752000000b002b6c61c745bmr7782564ljj.3.1692047321419; Mon, 14 Aug
 2023 14:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-17-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-17-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 14 Aug 2023 14:08:29 -0700
Message-ID: <CAAdAUtjvnbdr==SyKz+8UC-ZDPOc9W-Rp-3JjtMjfbVeB=zuPA@mail.gmail.com>
Subject: Re: [PATCH v3 16/27] KVM: arm64: nv: Expose FEAT_EVT to nested guests
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

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we properly implement FEAT_EVT (as we correctly forward
> traps), expose it to guests.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 315354d27978..7f80f385d9e8 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -124,8 +124,7 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct =
sys_reg_params *p,
>                 break;
>
>         case SYS_ID_AA64MMFR2_EL1:
> -               val &=3D ~(NV_FTR(MMFR2, EVT)     |
> -                        NV_FTR(MMFR2, BBM)     |
> +               val &=3D ~(NV_FTR(MMFR2, BBM)     |
>                          NV_FTR(MMFR2, TTL)     |
>                          GENMASK_ULL(47, 44)    |
>                          NV_FTR(MMFR2, ST)      |
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
