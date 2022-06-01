Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6A7539D1E
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 08:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349757AbiFAGQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 02:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349767AbiFAGQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 02:16:45 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73CDB51
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 23:16:41 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-e656032735so1494228fac.0
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 23:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQa+I47QKtVC2t95K19zDLcE2+R8SF0+XxRRkfkGlW0=;
        b=sc7cOnqpupy6XzI3Ysi9jsQVva3nLesW7cJqEc4n+FHGn9823/WQDEs7wJJNKvTfZq
         wjvGcdKxx72VxAsUCmDgA32niB+pWdq8Uu6w+G4laere2CrNZVwHrOEFSgiKmNyBV+rR
         sOd1WbpOSK0fQh8sIG5cOIclRR7ocACYt/7tOoshnrYHFX7imOQzK8QkcMYANnTsNnmI
         tIPQRkVtv2mWxgdEJVWmOcoHsAigPqiY9ynphJJt8eYVfVrgnAik1UYSrMJkoXztMX6y
         AjBSL0vGpocczhb9CRUtZOgMfHvKhTiHhZ7Af2dHeCuO/AACz9vzyJjfHaTkrfsm9KHY
         Qvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQa+I47QKtVC2t95K19zDLcE2+R8SF0+XxRRkfkGlW0=;
        b=wvu2J4ciFdO8Copguo2QacL2CL8JB6yIHjNZ3DqT+ht0XwxB220vvIM8ahoQ8D/L2U
         z13+v8jEqiopIASJdpby1k1umpVTUMtRyy8OfW0T/81eW+6Jk/QPO0Ajc+vWNsRS4VIi
         TVvxbMJ5yoXpTA4RxeH1uJpw+xxwGzlQx8vbai9MsWmQ5xAYJzMnRk/cuj0trkHLt5c7
         AUPQqnL06mX/UL8Ee8E4zpwMfKzrS0bweHpuLDXq1zelWpGQqmRvtHB8+n1XaTfgd0z7
         9OYW+QGRqxDSlDFPim0Yc0GlR6nbi/wjNQ1gbBk4sUuNrnJC8DTPC7BUWMx7QXU6+GG+
         72pw==
X-Gm-Message-State: AOAM532FgReX1K2VUOwt78Rz5bodDgloAV5cOkKG8TBytrMRbBEN9/Ta
        ZXXnAvBeO3/M+9Hj5iimwsXH3kFcMwT4tVfvaQFAmKcE6Ss=
X-Google-Smtp-Source: ABdhPJwDCSFT0xcho5IN+WsjKm40fHibRehTnYPPoMiBbBRL/6vg5o7no/GjVMEHaPx4YsTuPXgDqZiej8j9NaCwK6A=
X-Received: by 2002:a05:6870:304b:b0:f2:d164:5c85 with SMTP id
 u11-20020a056870304b00b000f2d1645c85mr15509285oau.107.1654064200350; Tue, 31
 May 2022 23:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com> <20220419065544.3616948-2-reijiw@google.com>
 <YnIesawWNhBwZydM@google.com>
In-Reply-To: <YnIesawWNhBwZydM@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 31 May 2022 23:16:24 -0700
Message-ID: <CAAeT=FwesxjpfxTo4J8nYf3o5zcO_PivV_fak5V0tLrZ5+pknw@mail.gmail.com>
Subject: Re: [PATCH v7 01/38] KVM: arm64: Introduce a validation function for
 an ID register
To:     Oliver Upton <oupton@google.com>
Cc:     h@google.com, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
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

Hi Oliver,

On Tue, May 3, 2022 at 11:35 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Apr 18, 2022 at 11:55:07PM -0700, Reiji Watanabe wrote:
> > Introduce arm64_check_features(), which does a basic validity checking
> > of an ID register value against the register's limit value, which is
> > generally the host's sanitized value.
> >
> > This function will be used by the following patches to check if an ID
> > register value that userspace tries to set for a guest can be supported
> > on the host.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |  1 +
> >  arch/arm64/kernel/cpufeature.c      | 52 +++++++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index c62e7e5e2f0c..7a009d4e18a6 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -634,6 +634,7 @@ void check_local_cpu_capabilities(void);
> >
> >  u64 read_sanitised_ftr_reg(u32 id);
> >  u64 __read_sysreg_by_encoding(u32 sys_id);
> > +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit);
> >
> >  static inline bool cpu_supports_mixed_endian_el0(void)
> >  {
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index d72c4b4d389c..dbbc69745f22 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -3239,3 +3239,55 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
> >               return sprintf(buf, "Vulnerable\n");
> >       }
> >  }
> > +
> > +/**
> > + * arm64_check_features() - Check if a feature register value constitutes
> > + * a subset of features indicated by @limit.
> > + *
> > + * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
> > + * an item whose width field is zero.
> > + * @val: The feature register value to check
> > + * @limit: The limit value of the feature register
> > + *
> > + * This function will check if each feature field of @val is the "safe" value
> > + * against @limit based on @ftrp[], each of which specifies the target field
> > + * (shift, width), whether or not the field is for a signed value (sign),
> > + * how the field is determined to be "safe" (type), and the safe value
> > + * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
> > + * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
> > + * won't be used by this function. If a field value in @val is the same
> > + * as the one in @limit, it is always considered the safe value regardless
> > + * of the type. For register fields that are not in @ftrp[], only the value
> > + * in @limit is considered the safe value.
> > + *
> > + * Return: 0 if all the fields are safe. Otherwise, return negative errno.
> > + */
> > +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
> > +{
> > +     u64 mask = 0;
> > +
> > +     for (; ftrp->width; ftrp++) {
> > +             s64 f_val, f_lim, safe_val;
> > +
> > +             f_val = arm64_ftr_value(ftrp, val);
> > +             f_lim = arm64_ftr_value(ftrp, limit);
> > +             mask |= arm64_ftr_mask(ftrp);
> > +
> > +             if (f_val == f_lim)
> > +                     safe_val = f_val;
> > +             else
> > +                     safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
> > +
> > +             if (safe_val != f_val)
> > +                     return -E2BIG;
> > +     }
> > +
> > +     /*
> > +      * For fields that are not indicated in ftrp, values in limit are the
> > +      * safe values.
> > +      */
> > +     if ((val & ~mask) != (limit & ~mask))
> > +             return -E2BIG;
>
> This bit is interesting. Apologies if I paged out relevant context. What
> features are we trying to limit that exist outside of an arm64_ftr_bits
> definition? I'll follow the series and see if I figure out later :-P
>
> Generally speaking, though, it seems to me that we'd prefer to have an
> arm64_ftr_bits struct plumbed up for whatever hits this case.

I'm sorry that I completely overlooked this until now...

This code is not currently used by this series since KVM will fill
any statically undefined fields as a lower safe unsigned field.

But, considering that arm64_ftr_bits that are defined in cpufeature.c
doesn't have all bits definitions, I wanted to have the function
handle such arm64_ftr_bits as well (the code is basically to make
sure that undefined fields are 0).

Thanks,
Reiji
