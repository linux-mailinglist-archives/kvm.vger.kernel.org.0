Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED603EF005
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 18:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhHQQOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 12:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhHQQOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 12:14:30 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71220C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 09:13:57 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r9so32957681lfn.3
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 09:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fz45eN0YQHrKq12xvU/L4mmZWr7+0QJnj2cWINTpG+U=;
        b=e/fBzXAGdi+9wuL+52RbMoiWcCtf/FmvvhByvW5Y7kXwBCi1sHxMUn1+Eu1S2LO7/n
         oR5ZbehPiEM6Yd4Q4SkKhTdLXeoFLJYVP3q9pd6dsHf0RdEtEq0SiSC2G1NXnmZL6zHD
         Z6gq4Z41ORn1MQvyHD1AdwIPvyuKI56I4RxrzHps6dk1fG8//Y+VTSuaoWYM4sgjs3SE
         fVCA3VYhvIH4j4LPiebbpPiExKzhziyiqKDq5XfPHKP1TU4GlQgtXCUa9n9U0UgyNUOe
         pjvGzSqaUy4oho/jVz5CB21dkiJ3phqhNMi30LGmJiFb3JguHUAD1OVA+0badBhDuNS6
         mdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fz45eN0YQHrKq12xvU/L4mmZWr7+0QJnj2cWINTpG+U=;
        b=U+m7HuJ7aDlqKblK46Er9qkfA0v47+6G1bXS5TgzPe5dQrcVAtY3hM9Up+Duy2faWM
         1ASeOXgJszkhHekRR2rqCC89CfOC1DXk+b9T34OXbhgMTPSG3lCQrps0zNANZxffVfY6
         4FKI/3J2suQ6F53c6yIu7CIXWjokNoGrG5pD2qrsNBLM99Gy+9tGouuIn/rTcB7HxYUO
         ZWAL9EgCvk+4Twx4A/wJK8wa1S2Sp6BX05Yu6Gd6TFjaPa/X+htocm/LwtGdoeAIrPuI
         C6lt2sIizI39kVnUUcKXJz/6jPaM2raqQo0nUXMx/OEnZfta2/bpQF2P/x8nU8N5WBE6
         6/Qw==
X-Gm-Message-State: AOAM530suG3xT5uE63gQ5M0GBVYYSKaIHEAEtmAi5OPUXNZ3ZyPaklS7
        eFb6OBpFkv2xEwZ0E4cuBCl7vzCI8kXMOTuwGg1jFQ==
X-Google-Smtp-Source: ABdhPJwAmYsV/GTAPBww3boiqGtk0HFPfKSKeHhWavXFO5X6kDFymmHw46nVdMIe/t/QYb0/fC1cJDA5Vv9R6puRLyE=
X-Received: by 2002:ac2:4e62:: with SMTP id y2mr3090399lfs.9.1629216835591;
 Tue, 17 Aug 2021 09:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com> <20210813203504.2742757-4-dmatlack@google.com>
 <613778fe-475d-fcd6-7046-55f05ee1be6c@redhat.com>
In-Reply-To: <613778fe-475d-fcd6-7046-55f05ee1be6c@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 17 Aug 2021 09:13:29 -0700
Message-ID: <CALzav=cXzvWnSP3d_Krcwa3wUteoFe+ufd=37W+9ug+BGMhcGg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 6:00 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/08/21 22:35, David Matlack wrote:
> > -     if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> > -             /*
> > -              * The gfn of direct spte is stable since it is
> > -              * calculated by sp->gfn.
> > -              */
> > -             gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> > -             kvm_vcpu_mark_page_dirty(vcpu, gfn);
> > -     }
> > +     if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> > +             mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
>
> Oops, this actually needs kvm_vcpu_mark_page_dirty to receive the slot.

What do you mean? kvm_vcpu_mark_page_dirty ultimately just calls
mark_page_dirty_in_slot.

>
> Paolo
>
