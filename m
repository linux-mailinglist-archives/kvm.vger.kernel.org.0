Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0068A77D6FD
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 02:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbjHPASW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 20:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240777AbjHPASD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 20:18:03 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A9CC6
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:18:02 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2b9c0391749so96348151fa.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692145080; x=1692749880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxsVtxBsz7ZNtnDwLhhwnSt+LGT+C0m0E563LOEZPKk=;
        b=WtzBhpDqdhUBNm5VH13yzUSiSHI0N9XrI5mWChHlQ9n/DkgpIAyeAYSEowCeuvXfx7
         8qiQfz9LYegTG08yqNKqho0DqARpZsxeWCxAPNmrlo5m/AYXVE0T967xlS716jqZWkWw
         u5xSych/CU/3n7wkdlQhmzVy+1ID9r29uuc9LDRW0m1LuN/HbAbP0Wl/sNWTFPftvReC
         asRBYFYjYQJI27G0lXXyq98Y/1r8iNWE6CzvvVuUjhwnEgSuNJjWs9GQI8mcqOdQPzz+
         +GumoDw5VkYNIXijh8aMhHLN6iT85P8vmGO52lfaa7eX8rxBEKRMeI/tja1CiijHuxjV
         U9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692145080; x=1692749880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxsVtxBsz7ZNtnDwLhhwnSt+LGT+C0m0E563LOEZPKk=;
        b=At4FAb9XQCluVmI8Ozx2Ngj1ldOb0kY1REMjSUKY24faA0d/lcpJUzIzZWQkQNnGJr
         Mpgp3uAV8uohbIIZnHRoGww/vYTEV58GliFqk9CkRV2s5OHFnQDM0/eks0bpeF1BS08a
         aN40IvXD/ZwZtP8DKzwkmA7i9LpqiQ5ESQjS7BKhpopuH/vj5exYfk56Pt11F6pe1UOm
         SZslSZVFuZzmbBuF9lP+q8P5HRHu1gn+IatLcwXLtS8f73b2dy9kEKF6tW6IZbzF3wpA
         w3YhiU9QXAmoz2Wc2pZo6o9wvV6R2PZi1fHjWGb0GQ11curGPe1Bvs+RH7d4mq5Silhl
         939w==
X-Gm-Message-State: AOJu0YzNj/OYC+N4Wp29/7K1dGx93lTCt+ADIU4tTT/HZyGT4MjQuWXC
        6w9VDX5pX8jC7Dr8VPWVyk+u4T0zNVJE02BiodtTLQ==
X-Google-Smtp-Source: AGHT+IF12jnPwdWfNDlBt25Ulla0zbJGJNh6+KSwv6ddCheINsAa1uFX3+jNn5WBCCn41kPZZ5e/4Qs4Ymb7s1FhcQ8=
X-Received: by 2002:a2e:9c99:0:b0:2b6:e618:b593 with SMTP id
 x25-20020a2e9c99000000b002b6e618b593mr242669lji.31.1692145080284; Tue, 15 Aug
 2023 17:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-28-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-28-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 17:17:47 -0700
Message-ID: <CAAdAUth98bjh_tyB0BT+dJnrxF7o7WVNddUZRDrkPmEZGOL=UA@mail.gmail.com>
Subject: Re: [PATCH v4 27/28] KVM: arm64: Move HCRX_EL2 switch to load/put on
 VHE systems
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
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
> Although the nVHE behaviour requires HCRX_EL2 to be switched
> on each switch between host and guest, there is nothing in
> this register that would affect a VHE host.
>
> It is thus possible to save/restore this register on load/put
> on VHE systems, avoiding unnecessary sysreg access on the hot
> path. Additionally, it avoids unnecessary traps when running
> with NV.
>
> To achieve this, simply move the read/writes to the *_common()
> helpers, which are called on load/put on VHE, and more eagerly
> on nVHE.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index a4750070563f..060c5a0409e5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,6 +197,9 @@ static inline void __activate_traps_common(struct kvm=
_vcpu *vcpu)
>         vcpu->arch.mdcr_el2_host =3D read_sysreg(mdcr_el2);
>         write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>
> +       if (cpus_have_final_cap(ARM64_HAS_HCX))
> +               write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
> +
>         __activate_traps_hfgxtr(vcpu);
>  }
>
> @@ -213,6 +216,9 @@ static inline void __deactivate_traps_common(struct k=
vm_vcpu *vcpu)
>                 vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>         }
>
> +       if (cpus_have_final_cap(ARM64_HAS_HCX))
> +               write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
> +
>         __deactivate_traps_hfgxtr(vcpu);
>  }
>
> @@ -227,9 +233,6 @@ static inline void ___activate_traps(struct kvm_vcpu =
*vcpu)
>
>         if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
>                 write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> -
> -       if (cpus_have_final_cap(ARM64_HAS_HCX))
> -               write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
>  }
>
>  static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
> @@ -244,9 +247,6 @@ static inline void ___deactivate_traps(struct kvm_vcp=
u *vcpu)
>                 vcpu->arch.hcr_el2 &=3D ~HCR_VSE;
>                 vcpu->arch.hcr_el2 |=3D read_sysreg(hcr_el2) & HCR_VSE;
>         }
> -
> -       if (cpus_have_final_cap(ARM64_HAS_HCX))
> -               write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
>  }
>
>  static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
