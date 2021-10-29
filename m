Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CEE43F414
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 02:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhJ2Aqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 20:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhJ2Aqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 20:46:53 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3794C061570;
        Thu, 28 Oct 2021 17:44:25 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z144so9366948iof.0;
        Thu, 28 Oct 2021 17:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQP4kRzm3ZSndyVhtvxvd/t2NKU3Z81W6oJKDHuooD0=;
        b=Mqu8zRtKOuus4eaIvw+S3uKGxoOqY0VjK92sWkJ5SYeeKEdEGXqdK2U/WeoOLAeI+w
         1ekw3doiTOXxiQmqIcRoUgux9R/AamtSEEyp/oc7DVmOzxynHNasxpYqHlBbZKLCusos
         zeZM3fpFS2N0G1w26R5F/6vvTCcbUYWLQ3yxXeIZdmCoCXuh49sUAVh9UimQpOTMeS+C
         n8nHEGPmyChZqJO6uHoOhruMoTCxDpNlebk/+XbdtxJjQMOWYx+txuz14rbYA8bPu33G
         c0hl//lhdQOeGGyU8a/nBPyKYaxfAsq27F9ORBEfvmCorVvluWB3wN7yZx02mIARfuuw
         kZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQP4kRzm3ZSndyVhtvxvd/t2NKU3Z81W6oJKDHuooD0=;
        b=6XNlWPoM+2uPO5i4Fv35ea3feUu2tLu3gj5I8A6maIdseYX7CddPeMxm8EpyeykpA1
         A1L7ru7kzsgxGiro9ctHQ5qWGPEQx8pciQeK8SYqrL/RqZtaGBxfOJj5ANsg9LjhG9Lw
         ZesvRSZ8ai5mhPZILZ8B6QhdWnHAbWlMMvTjMmA6uilKh8E8NlEjWtr7e1+ylm8CwpIN
         O9VplGva/4TT28Pe7jP3yUdoLzMZlKxFw5mxZVdJcC4kUW9/4IDK6kwPUFkw3qmxFkPz
         l+qMqTDTGv4o8I3UF5PTUrY++ZNbIeT3NVKL0JTdMbYoLSUmDA2m8P63Vpb5Y2N4sZMF
         RQqg==
X-Gm-Message-State: AOAM532+HYV8LM6VskFjhj+1GIuymemDc+EMZWbh9Zyc01F60vCmWgMk
        TDVPMwkRr6JMHb2RidSB/8LKtWuuZtDFXHLJRaOhNRrOdRs=
X-Google-Smtp-Source: ABdhPJzJKilq3tDV5Olh9mImUtsSsiwF8o6rvu8pTkX4MbWwe2o0arz6VTezLeOsEfqHk6p3OWm4ylILeLP4hUTLPMU=
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr5663782ior.152.1635468265191;
 Thu, 28 Oct 2021 17:44:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-24-sean.j.christopherson@intel.com> <CAJhGHyD=S6pVB+OxM7zF0_6LnMUCLqyTfMK4x9GZsdRHZmgN7Q@mail.gmail.com>
 <YXrAM9MNqgLTU6+m@google.com>
In-Reply-To: <YXrAM9MNqgLTU6+m@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 29 Oct 2021 08:44:13 +0800
Message-ID: <CAJhGHyBKVUsuKdvfaART6NWF7Axk5=eFQLidhGrM=mUO2cv2vw@mail.gmail.com>
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

On Thu, Oct 28, 2021 at 11:22 PM Sean Christopherson <seanjc@google.com> wrote:
>
> -me :-)
>
> On Thu, Oct 28, 2021, Lai Jiangshan wrote:
> > On Sat, Mar 21, 2020 at 5:29 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > +       if (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu)) {
> > > +               kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> > > +       } else if (is_vmenter &&
> > > +                  vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> > > +               vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> > > +               vpid_sync_context(nested_get_vpid02(vcpu));
> > > +       }
> > > +}
> >
> > (I'm sorry to pick this old email to reply to, but the problem has
> > nothing to do with this patch nor 5c614b3583e7 and it exists since
> > nested vmx is introduced.)
> >
> > I think kvm_mmu_free_guest_mode_roots() should be called
> > if (!enable_ept && vmcs12->virtual_processor_id != vmx->nested.last_vpid)
> > just because prev_roots doesn't cache the vpid12.
> > (prev_roots caches PCID, which is distinctive)
> >
> > The problem hardly exists if L1's hypervisor is also kvm, but if L1's
> > hypervisor is different or is also kvm with some changes in the way how it
> > manages VPID.
>
> Indeed.  A more straightforward error case would be if L1 and L2 share CR3, and
> vmcs02.VPID is toggled (or used for the first time) on the L1 => L2 VM-Enter.
>
> The fix should simply be:
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index eedcebf58004..574823370e7a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1202,17 +1202,15 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>          *
>          * If a TLB flush isn't required due to any of the above, and vpid12 is
>          * changing then the new "virtual" VPID (vpid12) will reuse the same
> -        * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
> -        * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
> -        * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
> -        * guest-physical mappings, so there is no need to sync the nEPT MMU.
> +        * "real" VPID (vpid02), and so needs to be flushed.  Like the !vpid02
> +        * case above, this is a full TLB flush from the guest's perspective.
>          */
>         if (!nested_has_guest_tlb_tag(vcpu)) {
>                 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>         } else if (is_vmenter &&
>                    vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
>                 vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> -               vpid_sync_context(nested_get_vpid02(vcpu));
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);

This change is neat.

But current KVM_REQ_TLB_FLUSH_GUEST flushes vpid01 only, and it doesn't flush
vpid02.  vmx_flush_tlb_guest() might need to be changed to flush vpid02 too.

And if so, this nested_vmx_transition_tlb_flush() can be simplified further
since KVM_REQ_TLB_FLUSH_CURRENT(!enable_ept) can be replaced with
KVM_REQ_TLB_FLUSH_GUEST.

>         }
>  }
