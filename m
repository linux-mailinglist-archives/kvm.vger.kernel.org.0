Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A104406BD
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 03:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJ3BhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 21:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJ3BhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 21:37:12 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BBAC061714;
        Fri, 29 Oct 2021 18:34:43 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h81so5908486iof.6;
        Fri, 29 Oct 2021 18:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aM2UIDKlHlRVDNMmLAAR2KZpDgdEIfkzvAwIfORb7XU=;
        b=MPVLBnNyPG7Q/KThwcQMZpg6zOdy9NX6BGc+y5juZfuTiL76Js8z2ZAWfkHEVtFyge
         fU0wzrqiqzQ24n1Z04yXrKxyycH6E+67m1ePl4LIU/WQCrCFDhqR+I3bbIsfw+dEg/ZC
         tmRFAKk7I4rcHZi/TRaoGoApvrJ3Ka+CmeICLJ/6gxQokwq2xMy3zsr2VwluZO/tSGze
         UGEYnPt2U9zA8jQcolyVcfanknDjldZvpklou6PNia5HAc8IhU7OxvW7ESiSgYhlnW//
         pcfSSAkSMsAVxVE9Pe9ItQi4kodCoeWCStz4pFbLxBhwbi/Z+Y3Zr2+AS0tWcRQj4Fnb
         1Q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aM2UIDKlHlRVDNMmLAAR2KZpDgdEIfkzvAwIfORb7XU=;
        b=IFNzVNKaniiOU8fCPOvcPi2bNWmMp7HhjIx8tDzeX95TIwiUeO1GG/CQ1FoJuC3tq4
         bNcnbaatKF2/A7CymQCu8W1/paKkxoxTT1BEf9ppbOs7riB1rzjJk67s72+kPwAb/gUf
         44L3GIEq8RO8j1mGOXZ0HK06Vfyu13goakA7q06+ecHS2Knf9fHrdVHXWtt8O0kcm+vy
         bms3Sjee3h4h4dabeJnN8GLJqtlraw5FhIA2Hubxll9E9Figi5Y/Y7mBxeJT4ORsmxrv
         KSw/mvy8cz4pxSTuMvFeHiMYDp/aA+AAFRTETqaGXABsNxkEGEZ00AmvV4FQApufWbCU
         bQgw==
X-Gm-Message-State: AOAM5306cder/eblpToqiFYTZrXeRHZaP9FrSrFGh5X32YCrdXlDLM0K
        BnDEPvAP0Kv4+Ce3tMUnHMz0wFOlJNrW/UB0Gj0=
X-Google-Smtp-Source: ABdhPJygNNPndHZOPvUvjR+W4LGfsfL++Y/Bsge3qeff8gNMYOQ/wY/+CYxIy80nYNBtjd9zopHt4uY6TX5jpqEN62c=
X-Received: by 2002:a05:6602:1594:: with SMTP id e20mr10725393iow.14.1635557682679;
 Fri, 29 Oct 2021 18:34:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-24-sean.j.christopherson@intel.com> <CAJhGHyD=S6pVB+OxM7zF0_6LnMUCLqyTfMK4x9GZsdRHZmgN7Q@mail.gmail.com>
 <YXrAM9MNqgLTU6+m@google.com> <CAJhGHyBKVUsuKdvfaART6NWF7Axk5=eFQLidhGrM=mUO2cv2vw@mail.gmail.com>
 <YXwq+Q3+I81jwv7G@google.com>
In-Reply-To: <YXwq+Q3+I81jwv7G@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Sat, 30 Oct 2021 09:34:31 +0800
Message-ID: <CAJhGHyBNazRUiwPT5nGC=JNYX96J1dP9Y+KWFz7TeYuT3teYZg@mail.gmail.com>
Subject: Re: [PATCH v3 23/37] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/

On Sat, Oct 30, 2021 at 1:10 AM Sean Christopherson <seanjc@google.com> wrote:
>
> TL;DR: I'll work on a proper series next week, there are multiple things that need
> to be fixed.
>
> On Fri, Oct 29, 2021, Lai Jiangshan wrote:
> > On Thu, Oct 28, 2021 at 11:22 PM Sean Christopherson <seanjc@google.com> wrote:
> > > The fix should simply be:
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index eedcebf58004..574823370e7a 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -1202,17 +1202,15 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
> > >          *
> > >          * If a TLB flush isn't required due to any of the above, and vpid12 is
> > >          * changing then the new "virtual" VPID (vpid12) will reuse the same
> > > -        * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
> > > -        * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
> > > -        * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
> > > -        * guest-physical mappings, so there is no need to sync the nEPT MMU.
> > > +        * "real" VPID (vpid02), and so needs to be flushed.  Like the !vpid02
> > > +        * case above, this is a full TLB flush from the guest's perspective.
> > >          */
> > >         if (!nested_has_guest_tlb_tag(vcpu)) {
> > >                 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > >         } else if (is_vmenter &&
> > >                    vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> > >                 vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> > > -               vpid_sync_context(nested_get_vpid02(vcpu));
> > > +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> >
> > This change is neat.
>
> Heh, yeah, but too neat to be right :-)
>
> > But current KVM_REQ_TLB_FLUSH_GUEST flushes vpid01 only, and it doesn't flush
> > vpid02.  vmx_flush_tlb_guest() might need to be changed to flush vpid02 too.
>
> Hmm.  I think vmx_flush_tlb_guest() is straight up broken.  E.g. if EPT is enabled
> but L1 doesn't use EPT for L2 and doesn't intercept INVPCID, then KVM will handle
> INVPCID from L2.  That means the recent addition to kvm_invalidate_pcid() (see
> below) will flush the wrong VPID.  And it's incorrect (well, more than is required
> by the SDM) to flush both VPIDs because flushes from INVPCID (and flushes from the
> guest's perspective in general) are scoped to the current VPID, e.g. a "full" TLB
> flush in the "host" by toggling CR4.PGE flushes only the current VPID:

I think KVM_REQ_TLB_FLUSH_GUEST/kvm_vcpu_flush_tlb_guest/vmx_flush_tlb_guest
was deliberately designed for the L1 guest only.  It can be seen from the code,
from the history, and from the caller's side.  For example,
nested_vmx_transition_tlb_flush() knows KVM_REQ_TLB_FLUSH_GUEST flushes
L1 guest:

        /*
         * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
         * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
         * full TLB flush from the guest's perspective.  This is required even
         * if VPID is disabled in the host as KVM may need to synchronize the
         * MMU in response to the guest TLB flush.
         *
         * Note, using TLB_FLUSH_GUEST is correct even if nested EPT is in use.
         * EPT is a special snowflake, as guest-physical mappings aren't
         * flushed on VPID invalidations, including VM-Enter or VM-Exit with
         * VPID disabled.  As a result, KVM _never_ needs to sync nEPT
         * entries on VM-Enter because L1 can't rely on VM-Enter to flush
         * those mappings.
         */
        if (!nested_cpu_has_vpid(vmcs12)) {
                kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
                return;
        }

While handle_invvpid() doesn't use KVM_REQ_TLB_FLUSH_GUEST.

So, I don't think KVM_REQ_TLB_FLUSH_GUEST, kvm_vcpu_flush_tlb_guest
or vmx_flush_tlb_guest is broken since they are for L1 guests.
What we have to do is to consider is it worth extending them for
nested guests for the convenience of nested code.

I second that they are extended.

A small comment in your proposal: I found that KVM_REQ_TLB_FLUSH_CURRENT
and KVM_REQ_TLB_FLUSH_GUEST is to flush "current" vpid only, some special
work needs to be added when switching mmu from L1 to L2 and vice versa:
handle the requests before switching.
