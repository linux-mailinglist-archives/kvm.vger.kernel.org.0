Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499FD6CEF4C
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 18:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjC2Q0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 12:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjC2Q0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 12:26:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C993FB
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 09:26:31 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y19so9624156pgk.5
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 09:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680107191;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xVyDMyZSpGCQ7MxCl/Op2Md4aBGMLAhdohsoe3DXYiw=;
        b=UwJSnq+CIN6vt1rJP+cxGSL8i84zh2WehYJsz5WddGu7tY0iZ9MWigqVu/UoA4Vg5C
         iHksoMOtr3avNPXC2tkZWY+uaKmYR2u7zk7pRDdUn+dr8yEQsGAw/O5g/OXrj5BQcodi
         P29XKfzbTlOzcp5sOURe0GBCEtm32s/mFD+cLkFf+K0X5Ak+aZqXTq+tuB26YgT5to+Z
         7+J8zOmODTQnmf0Y1TUUYr4bGm3SgGJ6yJzeHAfVWVuEHpBcUXYBIVceJsV4dQL9tznI
         jgY4ZlqyVOqhSKJpZ7B/CZ5fTnRv5TOLwSA1L2oNeHvBuKjvPa5Y7cDZ1nvBDh2NnyFu
         vpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680107191;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xVyDMyZSpGCQ7MxCl/Op2Md4aBGMLAhdohsoe3DXYiw=;
        b=KthRsZ0W1azNg0MH1iL0LyktFCMCiEJTnJQ7RMIgxikzlrwjR8UxgaAskipWdl53ZP
         z7pYyVlzRlrqO0tnpMZ6fa/pns9Hx0lLt0UzQmL76qP3cKRFW3wSUsAzecZiYzVlnuAp
         qKyHM9881dGbcxHhd698LyVmETG5w2vGjV0PMFo1fUNfXDleE2gtibqs/2EEdsciIl1z
         jMm8pCimAUk8ewr+r5BieQ1jPV2Q7HlvPVp5LRBOAisB8iEmMeqmx2C/JOId2Gp0W0TP
         F6MZH9EOarredNHFSd99WUEu3QIPK1YL+xQtpTjI8+vqhyRUtlRIZnMQCPazZ39otRNs
         foQg==
X-Gm-Message-State: AAQBX9eNcqbx53CBl08URcyp8AMb8bBJBJGBrfR9fB7Qs+7S8XeoIMNT
        o7DSWaBHIGUODjM5XAKOtvUlEwgoM6fpfsQNd+/nug==
X-Google-Smtp-Source: AKy350YvipsUiNBJuE6YBTyMPuwRu2a0VFb8e6m8DUE6BW/xhC9hc8gC85jEyUX2V5MoAyWcDuJKSLxWs+vAwycyHb0=
X-Received: by 2002:a05:6a00:99d:b0:5e6:f9a1:e224 with SMTP id
 u29-20020a056a00099d00b005e6f9a1e224mr10564721pfg.6.1680107190606; Wed, 29
 Mar 2023 09:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-3-jingzhangos@google.com> <861qlaxzyw.wl-maz@kernel.org>
 <CAAdAUtjp1tdyadjtU0RrdsRq-D3518G8eqP_coYNJ1vFEvrz2Q@mail.gmail.com>
In-Reply-To: <CAAdAUtjp1tdyadjtU0RrdsRq-D3518G8eqP_coYNJ1vFEvrz2Q@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 29 Mar 2023 09:26:13 -0700
Message-ID: <CAAeT=FyJyip9NOhTjdh169+9jE_eP3uEHMTszEQa7VfUY9MS1Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Save ID registers' sanitized value per guest
To:     Jing Zhang <jingzhangos@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +/*
> > > + * Set the guest's ID registers that are defined in id_reg_descs[]
> > > + * with ID_SANITISED() to the host's sanitized value.
> > > + */
> > > +void kvm_arm_set_default_id_regs(struct kvm *kvm)
> > > +{
> > > +     int i;
> > > +     u32 id;
> > > +     u64 val;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > > +             id = reg_to_encoding(&id_reg_descs[i]);
> > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > +                     /* Shouldn't happen */
> > > +                     continue;
> > > +
> > > +             if (id_reg_descs[i].visibility == raz_visibility)
> > > +                     /* Hidden or reserved ID register */
> > > +                     continue;
> >
> > Relying on function pointer comparison is really fragile. If I wrap
> > raz_visibility() in another function, this won't catch it. It also
> > doesn't bode well with your 'inline' definition of this function.
> >
> > More importantly, why do we care about checking for visibility at all?
> > We can happily populate the array and rely on the runtime visibility.
> Right. I'll remove this checking.

Without the check, calling read_sanitised_ftr_reg() for some hidden
ID registers will show a warning as some of them are not in
arm64_ftr_regs[] (e.g. reserved ones). This checking is needed
temporarily to avoid the warning (the check is removed in the following
patches of this series).  It would be much less fragile to call the
visibility function instead, but I don't think this is a also good way
to check the availability of the sanitized values for ID registers
either. I didn't found a good (proper) way to check that without
making changes in cpufeature.c, and I'm not sure if it is worth it
for this temporary purpose.

Thank you,
Reiji




> >
> > > +
> > > +             val = read_sanitised_ftr_reg(id);
> > > +             kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > > +     }
> > > +}
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
>
> Thanks,
> Jing
