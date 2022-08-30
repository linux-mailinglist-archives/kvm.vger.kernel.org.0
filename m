Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401AA5A5B61
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 08:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiH3GBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 02:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiH3GBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 02:01:21 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A33F77EA2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 23:01:20 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 134so4756718vkz.11
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 23:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=II0ZRvpyCmZsr92YqXuZZ/vXhZG9dSd/cKIK3SFpfT8=;
        b=nwIphf3SN8SPDI9lF45xXNGKxzXuBy7/MpijMVPbJJEnFUjmXUk/NJBLl4HtecAxI7
         HB0Q1UcHnMwPQ0GJq25AOgkwYNaKF+m2suVblmUrWysR6BgQ88RHvf16YDxn0l5zVKIR
         O37N9tSePzxVSeiUVPUEySP8/SH46wYQVSXhUWzoVYdsccS1bA3i79LJg/GUqtSatfgS
         kcv8IdzpjaqBrJxmb22srS5pcyHjqyVOJf9jbW+zc5EoYi27RP4Q6D9tOMnAW4e2hW3P
         m0jJ+anCP7RLsrVNhcjf4p+gfNXeGz9FYEMPCTbg1DaO20KI5SYQD5n5vFae95EyjI1p
         SH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=II0ZRvpyCmZsr92YqXuZZ/vXhZG9dSd/cKIK3SFpfT8=;
        b=Z81J2RrHfyXX+czi42cX5krc8zS+EgSRXjWppAtaMcGRF41dXCooBi3wXt8slk3T7l
         xXNDGd5sKeprLsAB8KRUBYKQKxsUzO8TxfEauGUEtjZF3FOfsYiz21hdQ0Yif+JLOsNT
         EAs5XZmlHwfqeZE9SGggqOcTIf4Ac7tWe5lENSyvonHOHKFZLdc6zafkwJPrL9wfvfIB
         5KqEhR5YOQ+kpc/vmmoxaRyKc2NnHRRrr8tt+mdnGa2vbLiWJHWmJGTB8CIUrjSfAo8C
         MdEjLtdbNyTKASlVl6GkXu7Jal2nOVg3rzFPLQyk7ps9yE2vbDoaRWt1hqI1DPLHHXI1
         xqOQ==
X-Gm-Message-State: ACgBeo1eT6scHb6+0isw031xkaeVSgSe9yKim/DHZ/CwlGILxxFfjQ69
        oGNi9X8folDH5vJerPyh/LVWKR5v0DHihOrnCOzYXA==
X-Google-Smtp-Source: AA6agR6/43t9mn8vyQUyis7KwGHYx16rxCk7VtEspKIvDh0GiZ5lOGt5Ps7J26fqhMvj2fNUfNLWdXs7y/LmQokPsdM=
X-Received: by 2002:a1f:a30e:0:b0:380:81d3:2562 with SMTP id
 m14-20020a1fa30e000000b0038081d32562mr4148222vke.7.1661839279500; Mon, 29 Aug
 2022 23:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev> <20220817214818.3243383-4-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-4-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Aug 2022 23:01:03 -0700
Message-ID: <CAAeT=FyNDjNvqeDWMVRtGiFrPo7D9p8Z4PAVAJPkpSRbRRcP5w@mail.gmail.com>
Subject: Re: [PATCH 3/6] KVM: arm64: Spin off helper for calling visibility hook
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.h | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index a8c4cc32eb9a..e78b51059622 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -136,22 +136,25 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
>         __vcpu_sys_reg(vcpu, r->reg) = r->val;
>  }
>
> -static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
> -                                const struct sys_reg_desc *r)
> +static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
> +                                            const struct sys_reg_desc *r)
>  {
>         if (likely(!r->visibility))
> -               return false;
> +               return 0;
>
> -       return r->visibility(vcpu, r) & REG_HIDDEN;
> +       return r->visibility(vcpu, r);
> +}
> +
> +static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
> +                                const struct sys_reg_desc *r)
> +{
> +       return sysreg_visibility(vcpu, r) & REG_HIDDEN;
>  }
>
>  static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
>                                          const struct sys_reg_desc *r)
>  {
> -       if (likely(!r->visibility))
> -               return false;
> -
> -       return r->visibility(vcpu, r) & REG_RAZ;
> +       return sysreg_visibility(vcpu, r) & REG_RAZ;
>  }
>
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
