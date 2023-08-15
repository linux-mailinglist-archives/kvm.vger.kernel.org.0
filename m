Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDBB77D6BB
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240677AbjHOXiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbjHOXiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:38:06 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAC82682
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:37:52 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b9e6cc93c6so90716591fa.2
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692142671; x=1692747471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8/Z8rt+EfsVmOxUyWP+mbbnL7pEZ6nBvIqSNe1Ie/I=;
        b=511hE7xFxwsqH1wGEtJpV29FnrC2vDOCbjMyX3pZdjhQ6jeV1uHayBjBwysM+3Gg5X
         p5YN7jd3O52nTAu2dmpIC1wI2f5CU9G2HE4xd6OOff3v8LfchezbDUnWMaNbXOF/nbQs
         hvnxM9NOFmr+NxqKlXg0rhPzMMDjb3UjhFNoEni1ZzVi2BAeQC7qCBHjpyUyMd04Yn6+
         MRep9SDRgW5IsZX1KUA1HfdQ/13Y3M+h6K6AtJCOyzvNYn+ZJHb9v1COzgVtmEdfszgg
         w9Sw+D4ZC7gqagP3yzwu2SM1lYih9o4HcDY2Tw86u5U9NG2G3RoB7MH9QTPteEidkoKd
         UhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692142671; x=1692747471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8/Z8rt+EfsVmOxUyWP+mbbnL7pEZ6nBvIqSNe1Ie/I=;
        b=JJTa9lMJEPPFcbQNkfrEIUSKFxzS8oSs34jSlFAamyIZ98AeWKw1psC4x07fj9iT63
         NVDpxAYCHRLeZ4PikoCq8b4CLcqKEVP1ZWtjlTP2I8NBf5P5qfNrHdK2VY0dsxM8ciXZ
         lC9Fy/Ezx+ZV9Boz/V9odN3gSL2Bbv6MZXitEd6LTswcw14+HSQ8SVISOL098UzVc1EX
         uqyeuZS4kz6pSHKgjIo6D2gLK3Bn7X8ql6SRvX69vanYV8a9Nwnx7o/jA5QclfiLimZ/
         u7yv+6N5KAsBX9rGZ3bQ1aqqA8u2ENl/8hxRVeFe3MCwqvGF9NCR+tglY9ZYfdCKc3/I
         MDTA==
X-Gm-Message-State: AOJu0Yzcs3i8a5siHgai7ixzt39XdDO5hhoddoukr37KxCc+H4+4panc
        W4FXDyj1xu+1DcecNmPgiKFDye2bXHb1mJ3HNMOs4Q==
X-Google-Smtp-Source: AGHT+IFxr0rejdPhxZuhZIxqY0a6IV1bqNq2o77jjGVN3czLaNIruw4D6qhQMspIFWCLgwdClPX0VZvwMC0XH8dUQQk=
X-Received: by 2002:a2e:300e:0:b0:2b9:6d6e:df5c with SMTP id
 w14-20020a2e300e000000b002b96d6edf5cmr159209ljw.5.1692142670864; Tue, 15 Aug
 2023 16:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-26-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-26-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 16:37:38 -0700
Message-ID: <CAAdAUth1M7Y9wpP9WEkS0==y3OJ1NM0=MDjSCQ2XfmOYwmLYsQ@mail.gmail.com>
Subject: Re: [PATCH v4 25/28] KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
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
> Now that we can evaluate the FGT registers, allow them to be merged
> with the hypervisor's own configuration (in the case of HFG{RW}TR_EL2)
> or simply set for HFGITR_EL2, HDGFRTR_EL2 and HDFGWTR_EL2.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 48 +++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index e096b16e85fd..a4750070563f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,6 +70,13 @@ static inline void __activate_traps_fpsimd32(struct kv=
m_vcpu *vcpu)
>         }
>  }
>
> +#define compute_clr_set(vcpu, reg, clr, set)                           \
> +       do {                                                            \
> +               u64 hfg;                                                \
> +               hfg =3D __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0; =
 \
> +               set |=3D hfg & __ ## reg ## _MASK;                       =
 \
> +               clr |=3D ~hfg & __ ## reg ## _nMASK;                     =
 \
> +       } while(0)
>
>
>  static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -97,6 +104,10 @@ static inline void __activate_traps_hfgxtr(struct kvm=
_vcpu *vcpu)
>         if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>                 w_set |=3D HFGxTR_EL2_TCR_EL1_MASK;
>
> +       if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +               compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
> +               compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
> +       }
>
>         /* The default is not to trap anything but ACCDATA_EL1 */
>         r_val =3D __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> @@ -109,6 +120,38 @@ static inline void __activate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
>
>         write_sysreg_s(r_val, SYS_HFGRTR_EL2);
>         write_sysreg_s(w_val, SYS_HFGWTR_EL2);
> +
> +       if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +               return;
> +
> +       ctxt_sys_reg(hctxt, HFGITR_EL2) =3D read_sysreg_s(SYS_HFGITR_EL2)=
;
> +
> +       r_set =3D r_clr =3D 0;
> +       compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
> +       r_val =3D __HFGITR_EL2_nMASK;
> +       r_val |=3D r_set;
> +       r_val &=3D ~r_clr;
> +
> +       write_sysreg_s(r_val, SYS_HFGITR_EL2);
> +
> +       ctxt_sys_reg(hctxt, HDFGRTR_EL2) =3D read_sysreg_s(SYS_HDFGRTR_EL=
2);
> +       ctxt_sys_reg(hctxt, HDFGWTR_EL2) =3D read_sysreg_s(SYS_HDFGWTR_EL=
2);
> +
> +       r_clr =3D r_set =3D w_clr =3D w_set =3D 0;
> +
> +       compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
> +       compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
> +
> +       r_val =3D __HDFGRTR_EL2_nMASK;
> +       r_val |=3D r_set;
> +       r_val &=3D ~r_clr;
> +
> +       w_val =3D __HDFGWTR_EL2_nMASK;
> +       w_val |=3D w_set;
> +       w_val &=3D ~w_clr;
> +
> +       write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
> +       write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
>  }
>
>  static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -121,7 +164,12 @@ static inline void __deactivate_traps_hfgxtr(struct =
kvm_vcpu *vcpu)
>         write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
>         write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>
> +       if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +               return;
>
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2)=
;
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2)=
;
>  }
>
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
