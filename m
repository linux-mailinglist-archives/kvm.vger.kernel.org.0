Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19318426F89
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 19:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhJHR2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 13:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhJHR2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 13:28:39 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46FEC061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 10:26:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id m3so42365447lfu.2
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 10:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3qeR7tBKVxf2LGhI0YPmlW51b6P4/1lbrG+pCI+eQ4=;
        b=kdm78ZXnSxyTXIBZ2EJpULCfPYA/DtBVz2wySJ3jGAYfavL1IikRd8VrZrncaWHgN3
         c7bQGt8rlZhOFLh5ShBwbAtK5haMah27Cg3ChsPvEBRvtJJXrUsB0b172wB/zHl53WXC
         JEpofiXx6k8FnGlT8Xi7vyaw9Oy/ciEFPvEutPg9h0uv6l1iDMt7/6ACDXwOcIPGP+yM
         2wkjqL+VNZ6B2XOHeVIz72nqfAhbHxQw7jvU829pOpsry1+7eM4YMtSR5OMtztjWEPOA
         FqnCbMTXupfPmWCXEsIeBwA6saTIRUpuFZfhIZ4x1AGaE6vr9DSyKqKBpE6ENRYZmLsX
         Cyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3qeR7tBKVxf2LGhI0YPmlW51b6P4/1lbrG+pCI+eQ4=;
        b=CzDCnW5YWDV+CwyHAjU2DaK65Wo3+MgoC1iDKA4zJiWYzQt99Y9N3Rx7QxzpuX4AsR
         lU+ZdisPoGTjZ22JBhS7/yfbrDqfZ4sUDgK1cTyHG0YP9jIgmLayurwpPsEbLw5hehW2
         aMzetEEReMH0BR1NgBusS+eH5TC6j7G47ZakaM/8RlqwsLZQQ9q7KedfjCzIZfdZXy0j
         az6If1LpMZeKAzZ4nw1fLccrGCq3HJR7U2i9r1HZSwxchSuDsWw7MBwX6OEvz5kKmV4n
         VbuSPIKcVfbE9aSE5U4scHW5QQoaK4VwtmwsTNN47xkdYby18lXunrx+viKL2bxkumZz
         Ik6w==
X-Gm-Message-State: AOAM530doA6A7178PJwDM24NKOGYcQ+YORtcIYGSeUivTDUPlV79xPpe
        /CUFBOSVUoK3oo3YtA1H13iFxpVVVRHE74Fw9m3IDg==
X-Google-Smtp-Source: ABdhPJwlscVCQ4hK24IV6RgfA6KVeV48ZBgyD/EJCRnyKIr6FE62evaK5bG1B0gtY7iET1k0rNiGz1MpxV+bAbRFe8o=
X-Received: by 2002:a05:6512:c18:: with SMTP id z24mr10423419lfu.193.1633714001796;
 Fri, 08 Oct 2021 10:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211005141357.2393627-1-pgonda@google.com> <20211005141357.2393627-3-pgonda@google.com>
 <5f6e6f61-0d34-e640-caea-ff71ac1563d8@amd.com>
In-Reply-To: <5f6e6f61-0d34-e640-caea-ff71ac1563d8@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 8 Oct 2021 11:26:30 -0600
Message-ID: <CAMkAt6oF52BDB4UX7DhVxQygYANfietT=gqJMQOvKJifHpivTQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 V9] KVM: SEV: Add support for SEV-ES intra host migration
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 8, 2021 at 9:38 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/5/21 9:13 AM, Peter Gonda wrote:
> > For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
> > and other SEV-ES info needs to be preserved along with the guest's
> > memory.
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >   arch/x86/kvm/svm/sev.c | 53 +++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 52 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 6fc1935b52ea..321b55654f36 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1576,6 +1576,51 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
> >       list_replace_init(&src->regions_list, &dst->regions_list);
> >   }
> >
> > +static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
> > +{
> > +     int i;
> > +     struct kvm_vcpu *dst_vcpu, *src_vcpu;
> > +     struct vcpu_svm *dst_svm, *src_svm;
> > +
> > +     if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
> > +             return -EINVAL;
> > +
> > +     kvm_for_each_vcpu(i, src_vcpu, src) {
> > +             if (!src_vcpu->arch.guest_state_protected)
> > +                     return -EINVAL;
> > +     }
> > +
> > +     kvm_for_each_vcpu(i, src_vcpu, src) {
> > +             src_svm = to_svm(src_vcpu);
> > +             dst_vcpu = dst->vcpus[i];
> > +             dst_vcpu = kvm_get_vcpu(dst, i);
>
> One of these assignments of dst_vcpu can be deleted.

Good catch I'll remove the `dst_vcpu = dst->vcpus[i];` line.

>
> > +             dst_svm = to_svm(dst_vcpu);
> > +
> > +             /*
> > +              * Transfer VMSA and GHCB state to the destination.  Nullify and
> > +              * clear source fields as appropriate, the state now belongs to
> > +              * the destination.
> > +              */
> > +             dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
> > +             dst_svm->vmsa = src_svm->vmsa;
> > +             src_svm->vmsa = NULL;
> > +             dst_svm->ghcb = src_svm->ghcb;
> > +             src_svm->ghcb = NULL;
> > +             dst_svm->vmcb->control.ghcb_gpa = src_svm->vmcb->control.ghcb_gpa;
> > +             dst_svm->ghcb_sa = src_svm->ghcb_sa;
> > +             src_svm->ghcb_sa = NULL;
> > +             dst_svm->ghcb_sa_len = src_svm->ghcb_sa_len;
> > +             src_svm->ghcb_sa_len = 0;
> > +             dst_svm->ghcb_sa_sync = src_svm->ghcb_sa_sync;
> > +             src_svm->ghcb_sa_sync = false;
> > +             dst_svm->ghcb_sa_free = src_svm->ghcb_sa_free;
> > +             src_svm->ghcb_sa_free = false;
>
> Would it make sense to have a pre-patch that puts these fields into a
> struct? Then you can just copy the struct and zero it after. If anything
> is ever added for any reason, then it could/should be added to the struct
> and this code wouldn't have to change. It might be more churn than it's
> worth, just a thought.
>

That sounds like a good idea to me. I'll add a new patch to the start
of the series which adds in something like:

struct vcpu_sev_es_state {
  /* SEV-ES support */
  struct vmcb_save_area *vmsa;
  struct ghcb *ghcb;
  struct kvm_host_map ghcb_map;
  bool received_first_sipi;
  /* SEV-ES scratch area support */
  void *ghcb_sa;
  u64 ghcb_sa_len;
  bool ghcb_sa_sync;
  bool ghcb_sa_free;
};

struct vcpu_svm {
...
struct vcpu_sev_es_state sev_es_state;
...
};

I think that will make this less tedious / error prone code. Names
sound OK or better suggestion?
