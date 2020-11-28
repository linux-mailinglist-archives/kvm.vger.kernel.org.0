Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74002C6E5B
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 03:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbgK1CFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 21:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731924AbgK1CEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 21:04:13 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB31DC0613D2;
        Fri, 27 Nov 2020 18:04:12 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k8so6127551ilr.4;
        Fri, 27 Nov 2020 18:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wflFfmV0h+VkTUXw4dnigENEr6YKI+GTw63N8b+QamM=;
        b=mNfLDr8I9YeJdrdKv9F6I2Zuhv9FHtA6r2AZHsGp+2pPMuEfy9Ob0fu32gixgrtCcT
         dqvxAqzOprHP7/6v3STPI+0mn/kDPaHQiDMUO20yTQHT5vf8s8Nd0rL2wuWbkDHvkNkx
         fs05uG0otO2eFZoS0qwsRoxQG/QUKSRUGIj//Y/D5XTyIphSgpXw6ftfGRxqlFmYypBy
         4dcE1xOU9rdOKIKezK7u57EDjXR3WaI2NbrbCi7M4y6RAXXscBur+g/lpwHtmGwxe8xg
         QnOLBrqbZz480OcvPFlY0OGFglqdJvKgm01RHslBzVKcOXBCZ3hKL/1Tljla7+VPLQRd
         DBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wflFfmV0h+VkTUXw4dnigENEr6YKI+GTw63N8b+QamM=;
        b=J+Gb+XqxZYhm3vwYbFFPrfJlpIFwt1aqnEAMHs8qJZW+sdmxFQGZxH4QbD+GZ6j9h4
         rjLsK19qVFIRWdIh7YjHWfZMaJ1pOA3yrkTHJ3VT6Z04pv1T/7seaHvCJ3INc1i1Mphm
         G+m6V6F9pvs+VF5cDQfxan5mKFwY4bm5P4BudNgzQJINW05Rl0ZLUwAylPx8WBdsFwLb
         RB+L+JZt1OuaDpNWYp63vM6inK7rQ4WjlxFLgahD9cJaoC9yXF0SLRUnDTcnl3eXRPjK
         p897wVtSmh5/2ltHsP0GYKS6nZfp28SSPwDLzskJg8/wg5+yqi+Zqk2G9VeX9+nYfLVs
         Z2Cg==
X-Gm-Message-State: AOAM5335h2/p0m0yBfHVHZMY8hysIdrsNVCjOnbI3Ll2QIHSXloLtogB
        VdwWoSslPh7Jp9/0adhcxzZK5eqTxHnH+Jbc74Y=
X-Google-Smtp-Source: ABdhPJysEVNq2gbUDgAqedaN0LFcXc+rap6lS2RKie2goF+k5/FfA5oVVSUVK9/bh741Gi8IvF6RpD3kTV799ulv5Qk=
X-Received: by 2002:a92:ae0e:: with SMTP id s14mr9068421ilh.94.1606529052081;
 Fri, 27 Nov 2020 18:04:12 -0800 (PST)
MIME-Version: 1.0
References: <20201120095517.19211-1-jiangshanlai@gmail.com>
 <20201126000549.GC450871@google.com> <0724aeb9-3466-5505-8f12-a5899144e68f@redhat.com>
In-Reply-To: <0724aeb9-3466-5505-8f12-a5899144e68f@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sat, 28 Nov 2020 10:04:01 +0800
Message-ID: <CAJhGHyApvmQk4bxxK2rJKzyAShFSXyEb2W0qyFcVoUEcsMKs_w@mail.gmail.com>
Subject: Re: [PATCH] kvm/x86/mmu: use the correct inherited permissions to get
 shadow page
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@qumranet.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 28, 2020 at 12:48 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/11/20 01:05, Sean Christopherson wrote:
> > On Fri, Nov 20, 2020, Lai Jiangshan wrote:
> >> From: Lai Jiangshan <laijs@linux.alibaba.com>
> >>
> >> Commit 41074d07c78b ("KVM: MMU: Fix inherited permissions for emulated
> >> guest pte updates") said role.access is common access permissions for
> >> all ptes in this shadow page, which is the inherited permissions from
> >> the parent ptes.
> >>
> >> But the commit did not enforce this definition when kvm_mmu_get_page()
> >> is called in FNAME(fetch). Rather, it uses a random (last level pte's
> >> combined) access permissions.
> >
> > I wouldn't say it's random, the issue is specifically that all shadow pages end
> > up using the combined set of permissions of the entire walk, as opposed to the
> > only combined permissions of its parents.
> >
> >> And the permissions won't be checked again in next FNAME(fetch) since the
> >> spte is present. It might fail to meet guest's expectation when guest sets up
> >> spaghetti pagetables.
> >
> > Can you provide details on the exact failure scenario?  It would be very helpful
> > for documentation and understanding.  I can see how using the full combined
> > permissions will cause weirdness for upper level SPs in kvm_mmu_get_page(), but
> > I'm struggling to connect the dots to understand how that will cause incorrect
> > behavior for the guest.  AFAICT, outside of the SP cache, KVM only consumes
> > role.access for the final/last SP.
> >
>
> Agreed, a unit test would be even better, but just a description in the
> commit message would be enough.
>
> Paolo
>

Something in my mind, but I haven't test it:

pgd[]pud[]  pmd[]        pte[]            virtual address pointers
 (same hpa as pmd2\)  /->pte1(u--)->page1 <- ptr1 (u--)
         /->pmd1(uw-)--->pte2(uw-)->page2 <- ptr2 (uw-)
pgd->pud-|           (shared pte[] as above)
         \->pmd2(u--)--->pte1(u--)->page1 <- ptr3 (u--)
 (same hpa as pmd1/)  \->pte2(uw-)->page2 <- ptr4 (u--)


pmd1 and pmd2 point to the same pte table, so:
ptr1 and ptr3 points to the same page.
ptr2 and ptr4 points to the same page.

  The guess read-accesses to ptr1 first. So the hypervisor gets the
shadow pte page table with role.access=u-- among other things.
   (Note the shadowed pmd1's access is uwx)

  And then the guest write-accesses to ptr2, and the hypervisor
set up shadow page for ptr2.
   (Note the hypervisor silencely accepts the role.access=u--
    shadow pte page table in FNAME(fetch))

  After that, the guess read-accesses to ptr3, the hypervisor
reused the same shadow pte page table as above.

  At last, the guest writes to ptr4 without vmexit nor pagefault,
Which should cause vmexit as the guest expects.

In theory, guest userspace can trick the guest kernel if the guest
kernel sets up page table like this.

Such spaghetti pagetables are unlikely to be seen in the guest.

But when the guest is using KPTI and not using SMEP. KPTI means
all pgd entries are marked NX on the lower/userspace part of
the kernel pagetable. Which means SMEP is not needed.
(see arch/x86/mm/pti.c)

Assume the guest does disable SMEP and the guest has the flaw
that the guest user can trick guest kernel to execute on lower
part of the address space.

Normally, NX bit marked on the kernel pagetable's lower pgd
entries can help in this case. But when in guest with shadowpage
in hypervisor, the guest user can make those NX bit useless.

Again, I haven't tested it neither. I will try it later and
update the patch including adding some more checks in the mmu.c.

Thanks,
Lai
