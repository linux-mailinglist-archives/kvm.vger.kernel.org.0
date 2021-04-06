Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8297355CC4
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245147AbhDFUPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 16:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242818AbhDFUPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 16:15:17 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6977DC061756
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 13:15:09 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id z9so14257141ilb.4
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 13:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C0HiCwP3UtTQfY1kRref7C3+6EwFGVKz2vZ22xzsYYo=;
        b=CXI/eoTaqm18/Hv401/K1FvwdUTC++/foA8eRvWERh6/klwZebWXbs3FAQy7XfI/Nl
         yxgTa6mWry30BPtEyRbQg9/LFRFeUeXoYvAMJLv4OlaHTX+CylCQndSEgwCvRXaBs+/I
         45Yn43YeigHy0RGWMuVRCl4Txn7nhvwicyM6kmAimftpd0Jsr7/0lKnSUGb7QhBYwZ/a
         ed4PAxDuse1zp9OHuwHabGWoKelGBC0wS940kOmt9VLVHhJOIALc9cXpwodhd2w4F2df
         A/Nns69vuiyKMofhWpSHTy9f2pK6VgIdnrJtLbR7/b2cHU4gPw7seGRVEpaUixYUhaEM
         mFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C0HiCwP3UtTQfY1kRref7C3+6EwFGVKz2vZ22xzsYYo=;
        b=hOjrOs5PNE+GBmYBpjT7WiJuE6R59Nd/4XgP+6k7cDrVUzTxl+8eteYROEnu7LUi3a
         NAISPJs28wSxx9u96in5U/qozZjaZ9jPkDl8uzpjg+V9/fFnoqRIckd6l2XqfBHcQxYm
         JTC5dsurLicYhK3Mtra9am9peH7LRM935bHHBu9HNSTcaDmvWqxLcnNa8XjnOgJxF8Pg
         tp3xetrg08hJS6Kr4FAN8kWUhby7tJDSFtnZl1AFBq/mqNbgUMTUgMnBpsU863Bsoz/e
         6RiS6ccnovoaZaitQWTkw1Y3iMs1akZuJMNnkjZie+okQD/pyuVyl/h3i4VBzI1XQfLt
         FC8g==
X-Gm-Message-State: AOAM532kl5gKBhuqu1IiVwSfsfhCulhNy/MmdReWXhq1TnhPH2aZ1PiD
        iRHGt2CMTYJcwHufHFfqyhQe873oKI3wUsWsmrD2zbHHYQtHEg==
X-Google-Smtp-Source: ABdhPJx22wuO13D1Z6c1UBwf8Y+QUzNm1cXhGvcqp3fX0fx/lk5u9QvxUMu7ZyfZzmTvpqm+MGCGa17/MQfEiEqLKLQ=
X-Received: by 2002:a05:6e02:eb4:: with SMTP id u20mr64919ilj.182.1617740108386;
 Tue, 06 Apr 2021 13:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617302792.git.ashish.kalra@amd.com> <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <YGyCxGsC2+GAtJxy@google.com> <20210406160758.GA24313@ashkalra_ubuntu_server>
In-Reply-To: <20210406160758.GA24313@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 6 Apr 2021 13:14:32 -0700
Message-ID: <CABayD+f9o1CZTdak-ktKXpJnxcOAP4KPnYCDBzry91QcK6WVcw@mail.gmail.com>
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 6, 2021 at 9:08 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Tue, Apr 06, 2021 at 03:48:20PM +0000, Sean Christopherson wrote:
> > On Mon, Apr 05, 2021, Ashish Kalra wrote:
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > ...
> >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 3768819693e5..78284ebbbee7 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
> > >     int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> > >
> > >     void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > > +   int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
> > > +                             unsigned long sz, unsigned long mode);
> > >  };
> > >
> > >  struct kvm_x86_nested_ops {
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index c9795a22e502..fb3a315e5827 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >     return ret;
> > >  }
> > >
> > > +static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
> > > +{
> > > +   vcpu->run->exit_reason = 0;
> > > +   kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
> > > +   ++vcpu->stat.hypercalls;
> > > +   return kvm_skip_emulated_instruction(vcpu);
> > > +}
> > > +
> > > +int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
> > > +                      unsigned long npages, unsigned long enc)
> > > +{
> > > +   kvm_pfn_t pfn_start, pfn_end;
> > > +   struct kvm *kvm = vcpu->kvm;
> > > +   gfn_t gfn_start, gfn_end;
> > > +
> > > +   if (!sev_guest(kvm))
> > > +           return -EINVAL;
> > > +
> > > +   if (!npages)
> > > +           return 0;
> >
> > Parth of me thinks passing a zero size should be an error not a nop.  Either way
> > works, just feels a bit weird to allow this to be a nop.
> >
> > > +
> > > +   gfn_start = gpa_to_gfn(gpa);
> >
> > This should check that @gpa is aligned.
> >
> > > +   gfn_end = gfn_start + npages;
> > > +
> > > +   /* out of bound access error check */
> > > +   if (gfn_end <= gfn_start)
> > > +           return -EINVAL;
> > > +
> > > +   /* lets make sure that gpa exist in our memslot */
> > > +   pfn_start = gfn_to_pfn(kvm, gfn_start);
> > > +   pfn_end = gfn_to_pfn(kvm, gfn_end);
> > > +
> > > +   if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > > +           /*
> > > +            * Allow guest MMIO range(s) to be added
> > > +            * to the shared pages list.
> > > +            */
> > > +           return -EINVAL;
> > > +   }
> > > +
> > > +   if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > > +           /*
> > > +            * Allow guest MMIO range(s) to be added
> > > +            * to the shared pages list.
> > > +            */
> > > +           return -EINVAL;
> > > +   }
> >
> > I don't think KVM should do any checks beyond gfn_end <= gfn_start.  Just punt
> > to userspace and give userspace full say over what is/isn't legal.
> >
> > > +
> > > +   if (enc)
> > > +           vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
> > > +   else
> > > +           vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
> >
> > Use a single exit and pass "enc" via kvm_run.  I also strongly dislike "DMA",
> > there's no guarantee the guest is sharing memory for DMA.
> >
> > I think we can usurp KVM_EXIT_HYPERCALL for this?  E.g.
> >
>
> I see the following in Documentation/virt/kvm/api.rst :
> ..
> ..
> /* KVM_EXIT_HYPERCALL */
>                 struct {
>                         __u64 nr;
>                         __u64 args[6];
>                         __u64 ret;
>                         __u32 longmode;
>                         __u32 pad;
>                 } hypercall;
>
> Unused.  This was once used for 'hypercall to userspace'.  To implement
> such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
>
> This mentions this exitcode to be unused and implementing this
> functionality using KVM_EXIT_IO for x86?

I suspect this description is historical. It was originally from 2009.
KVM_EXIT_IO is used for IO port reads/writes.

Personally, I would prefer to stay the course and use a name similar
to KVM_EXIT_DMA_SHARE, say KVM_EXIT_MEM_SHARE and
KVM_EXIT_MEM_UNSHARE. These just seem very clear, which I appreciate.
Reusing hypercall would work, but shoehorning this into
KVM_EXIT_HYPERCALL when we don't have generic hypercall exits feels a
bit off in my mind. Note: that preference isn't particularly strong.

Steve
>
> Thanks,
> Ashish
>
> >       vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> >       vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> >       vcpu->run->hypercall.args[0]  = gfn_start << PAGE_SHIFT;
> >       vcpu->run->hypercall.args[1]  = npages * PAGE_SIZE;
> >       vcpu->run->hypercall.args[2]  = enc;
> >       vcpu->run->hypercall.longmode = is_64_bit_mode(vcpu);
> >
> > > +
> > > +   vcpu->run->dma_sharing.addr = gfn_start;
> >
> > Addresses and pfns are not the same thing.  If you're passing the size in bytes,
> > then it's probably best to pass the gpa, not the gfn.  Same for the params from
> > the guest, they should be in the same "domain".
> >
> > > +   vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
> > > +   vcpu->arch.complete_userspace_io =
> > > +           sev_complete_userspace_page_enc_status_hc;
> >
> > I vote to drop the "userspace" part, it's already quite verbose.
> >
> >       vcpu->arch.complete_userspace_io = sev_complete_page_enc_status_hc;
> >
> > > +
> > > +   return 0;
> > > +}
> > > +
> >
> > ..
> >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index f7d12fca397b..ef5c77d59651 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >             kvm_sched_yield(vcpu->kvm, a0);
> > >             ret = 0;
> > >             break;
> > > +   case KVM_HC_PAGE_ENC_STATUS: {
> > > +           int r;
> > > +
> > > +           ret = -KVM_ENOSYS;
> > > +           if (kvm_x86_ops.page_enc_status_hc) {
> > > +                   r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> >
> > Use static_call().
> >
> > > +                   if (r >= 0)
> > > +                           return r;
> > > +                   ret = r;
> > > +           }
> >
> > Hmm, an alternative to adding a kvm_x86_ops hook would be to tag the VM as
> > supporting/allowing the hypercall.  That would clean up this code, ensure VMX
> > and SVM don't end up creating a different userspace ABI, and make it easier to
> > reuse the hypercall in the future (I'm still hopeful :-) ).  E.g.
> >
> >       case KVM_HC_PAGE_ENC_STATUS: {
> >               u64 gpa = a0, nr_bytes = a1;
> >
> >               if (!vcpu->kvm->arch.page_enc_hc_enable)
> >                       break;
> >
> >               if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(nr_bytes) ||
> >                   !nr_bytes || gpa + nr_bytes <= gpa)) {
> >                       ret = -EINVAL;
> >                       break;
> >               }
> >
> >               vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> >               vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> >               vcpu->run->hypercall.args[0]  = gpa;
> >               vcpu->run->hypercall.args[1]  = nr_bytes;
> >               vcpu->run->hypercall.args[2]  = enc;
> >               vcpu->run->hypercall.longmode = op_64_bit;
> >               vcpu->arch.complete_userspace_io = complete_page_enc_hc;
> >               return 0;
> >       }
> >
> >
> > > +           break;
> > > +   }
> > >     default:
> > >             ret = -KVM_ENOSYS;
> > >             break;
