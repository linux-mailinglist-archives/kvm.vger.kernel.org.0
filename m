Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B006D5372
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjDCVYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 17:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbjDCVXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 17:23:52 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD584C1A
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 14:23:31 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-177b78067ffso32345462fac.7
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680557009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9EPMXOr7/BpSW0fz3V3pwNkNbHFJwN9oEHw10txBko=;
        b=JSrJHjc8ZlkN946jtgq7pXnminH4yEpKyDgM/gCOAmSADuPaZeN8qyXKh6Lz/tzW1k
         vTRrhW3M0FG6eVQiT1zs3JO0WEUFCRAZXEmnyUVmCQfh325zdk6HjRCKfWEO5vHZ2RSV
         GeyPLeOR4EuNwTOZEGuko3LAMXLdC7iuV1Zwrm4P2sKWvXR9ibfS69kHCma4Gu3Go0Bl
         N0hS3WBTKQ4Fgr4To1R7dFmoSj2mJpzvYRJ4QLoHHQcRjM7UoUVVOXbRWEgE/Yix3v4F
         qNsnERfOgf0ulmyZMGLFUpMyd/z89HcxRIWryz4ryLmHOlJnDzJUmy8/eUVgYwgz32x+
         5bJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9EPMXOr7/BpSW0fz3V3pwNkNbHFJwN9oEHw10txBko=;
        b=fMn+ECDu2nYSbp1DxkZotve3X1l3cFPF6Of4UdTnlMjSs8NdJH3nzgF3eIjgRkCCk2
         wliGCjEuH1BtTq9Fa4M49dny71lrzB+ouwQViXlsyHSBjxr75lhTuBShTMJl8y7XWbuk
         57f9IGEBVPMiKD94JJRlcxYlyySwI1i4j/rxBWdWH4wcPonbkt+t43cghZRGsCK5qmaq
         NFCSyei0vETjXTGMOaVnTpEmWCa//3/o98gNC3TFzxNXSiUjOJoWVr/HU8Wjt4pD06FS
         bwlDu3SKLRFegiuZZyhgdSN/odkuVIu5e+EpBvqSSvJG4ECUa8xSaOal/bWjChQRxSPU
         UbUw==
X-Gm-Message-State: AAQBX9cyN7HQuSeGSNhIoBMOMOEt5+khlRRI9MNpzgjMdWQNp27awIck
        EucNuG0Lk4MA9aAA47AGyUKoyY4nUG3qu2e98Y4bDg==
X-Google-Smtp-Source: AKy350ZxhWGAvzQvHaIIWFH212tmU5Na2D4k/xzxENz1UReTgZm1yspXtLicu2nfaNdqwOwe55eUrkgJerG4aimb47Y=
X-Received: by 2002:a05:6870:339e:b0:17e:7674:8df0 with SMTP id
 w30-20020a056870339e00b0017e76748df0mr281290oae.9.1680557008648; Mon, 03 Apr
 2023 14:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-5-rananta@google.com>
 <ZCTdcJLxWBRXItSM@linux.dev>
In-Reply-To: <ZCTdcJLxWBRXItSM@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 3 Apr 2023 14:23:17 -0700
Message-ID: <CAJHc60xbhyiVieqzeMcB1S7UWw_J3Jyh8PqjA9GLOhudja5nmA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Mar 29, 2023 at 5:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrote:
> > Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> > such that it can utilize the TLBI range based instructions
> > if supported.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
> >  2 files changed, 18 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index dee530d75b957..211fab0c1de74 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages);
> > +
> >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> >  {
> >       return false;
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index e98910a8d0af6..409cb187f4911 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> >       return 0;
> >  }
> >
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages)
> > +{
> > +     phys_addr_t start, end;
> > +
> > +     if (!system_supports_tlb_range())
> > +             return -EOPNOTSUPP;
>
> There's multiple layers of fallback throughout this series, as it would
> appear that deep in __kvm_tlb_flush_range() you're blasting the whole
> VMID if either the range is too large or the feature isn't supported.
>
> Is it possible to just normalize on a single spot to gate the use of
> range-based invalidations? I have a slight preference for doing it deep
> in the handler, as it keeps the upper layers of code a bit more
> readable.
>
I was a little skeptical on this part, since the
kvm_arch_flush_remote_tlbs_range() expects to return -EOPNOTSUPP if
indeed there's no support.
But I see your point. The if-else in kvm_pgtable_stage2_flush_range()
seems redundant and I can simply manage this conditions inside
__kvm_tlb_flush_range_vmid_ipa() itself, but I'll leave the
kvm_arch_flush_remote_tlbs_range()'s implementation as is. Thoughts?

Thank you.
Raghavendra


> > +     start =3D start_gfn << PAGE_SHIFT;
> > +     end =3D (start_gfn + pages) << PAGE_SHIFT;
> > +
> > +     kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, &kvm->arch.mmu,
> > +                     start, end, KVM_PGTABLE_MAX_LEVELS - 1, 0);
> > +     return 0;
> > +}
> > +
> >  static bool kvm_is_device_pfn(unsigned long pfn)
> >  {
> >       return !pfn_is_map_memory(pfn);
> > --
> > 2.39.1.519.gcb327c4b5f-goog
> >
> >
>
> --
> Thanks,
> Oliver
