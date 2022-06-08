Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CAC542902
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 10:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiFHIMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 04:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiFHIMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 04:12:06 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2B62132AE
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 00:40:51 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-fe023ab520so2995445fac.10
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 00:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4C+HR3kdGNMQU0VniOy6D2TLr5OZWg8RJ6oE98/dwoc=;
        b=lniF6SLwf2sUXG4L0oxq7Wvjkomm8JSVVcdy9UzJDPuqG9mEJpDr1yJXXD8UEn8ubM
         DP7YyQB0975e/YbQSSGUijeh7xrN31/yqUtCCrcEaxk6ysdAfEnEG42VefCFXo/ua0BH
         CjN+8JiKVCb0pxnVxMjrz4HvhAu28Lujp3EqMXIp+bS6ugnqNVvRhLBpwUrL4M4P4od0
         mow1rtEcXV2IdS5nu9EyuXgjt7u/n2/BqItaCrd9FbYugktvOlRupZv7BJw7MHAv02aS
         dfsm6fuod9FPKaaXXLOjjoPcHvKi1Pft/nRpXH2+T0MqaqVEoMMoHdcT9vSNZn3+FX4D
         SvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4C+HR3kdGNMQU0VniOy6D2TLr5OZWg8RJ6oE98/dwoc=;
        b=XP6IUXvija13hXo64OAg7+yuhMLZZycOmcC2M5/NoJ9Atec5jTrpVAHnseJiXxZ2Fe
         jgYHNOOxGosPjmFpDmRnYDqLD8oYSEwHEd3o/Az285XuXbwr0F9n3jxNlLO+HsprVSGo
         9ar8RAurKxHpIt6BqXX+xHjpzzua92i+5p687PkmkIyUtV4yItCRynnSw97o3T0xlgVJ
         mneemb6QnJiX2dBFa3froQvAI9Jni4+naiELZ5XSkjebqajtFTy5y+mORUeC5sLvYbJk
         reV7VMA4L/eo1bnYmfMoSEHGD64718x+zvleFRpAYfxnk5vmrB6YtffOfRlirAP1cpIA
         tQEQ==
X-Gm-Message-State: AOAM530HCqL2CWpaESDmgdrmi6J5h/v9mdGeyFlYgf01zla2O0lkF7Lj
        sLuEM5ltSFNCoqgTp+Tq46bqXEOm6a2PT9SoRmy1Ww==
X-Google-Smtp-Source: ABdhPJxJU2tr9O9BGDzNE7cjJh/nBawaDlGq2ZFiX9T3Jx1K4j1sILs6YF386g05D+iAgS/6fcxJ3SXP4KDchr+cHKE=
X-Received: by 2002:a05:6870:961b:b0:e2:ffb9:f526 with SMTP id
 d27-20020a056870961b00b000e2ffb9f526mr1662882oaq.146.1654674050672; Wed, 08
 Jun 2022 00:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
In-Reply-To: <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 8 Jun 2022 08:40:14 +0100
Message-ID: <CA+EHjTxa8mhiEykjTTgB0J6aFpRqDiRzLKOWOd3hFsSrL+d=5g@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To:     Peter Collingbourne <pcc@google.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org,
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

Hi Peter,

On Tue, Jun 7, 2022 at 1:42 AM Peter Collingbourne <pcc@google.com> wrote:
>
> On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> >
> > From: Fuad Tabba <tabba@google.com>
> >
> > Return an error (-EINVAL) if trying to enable MTE on a protected
> > vm.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 10e036bf06e3..8a1b4ba1dfa7 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                 break;
> >         case KVM_CAP_ARM_MTE:
> >                 mutex_lock(&kvm->lock);
> > -               if (!system_supports_mte() || kvm->created_vcpus) {
> > +               if (!system_supports_mte() ||
> > +                   kvm_vm_is_protected(kvm) ||
>
> Should this check be added to kvm_vm_ioctl_check_extension() as well?

No need. kvm_vm_ioctl_check_extension() calls pkvm_check_extension()
for protected vms, which functions as an allow list rather than a
block list.

Cheers,
/fuad


> Peter
