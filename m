Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792FC31025D
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhBEBpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhBEBpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 20:45:44 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CBC06178B
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 17:45:04 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id d6so4497368ilo.6
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 17:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BgkMx2UvYXfudgmh2Ybo3NWYwm+nsYCqdg2+vVo3BEM=;
        b=oH9Pnh3uGpbIIWINvoI3NTRGqv5bN3tgdFqnL5WqMpemQwZ/3z2tLHMPD1QP2wBlHt
         jPbWcx88dXuIl7IHBG8DwqQYNU1JO4xKOYj5HLmumY2WSdfJETAkFwODUTGPEiqGJHZ1
         oeQ0vjZghQqx46i2Tmrjuist+LScBZVmFo3JpI2pS/MYV6cIozYCalEZWChx5C7oPnhg
         f1vcINXUCaZQ5DnBZJ6lFhgO3fFB4DMEN9K0QYxg+fuR5izegDovtEyXvHxkyCar8J/f
         vgF7Mq8m3OJ9CQLRi8oVyB7wiwbnAwSXq61P27XTYqEOtRwJRCMu/bfP75BCzFksQ8WQ
         Wu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BgkMx2UvYXfudgmh2Ybo3NWYwm+nsYCqdg2+vVo3BEM=;
        b=F4r0AfL2GGV5AUTxUyevIEWIWohCzzdJEl7PQHZl4Q3kIHwr90wE7Z+AH6HOgiM+Jf
         RZ9ys4M/gvrAnrcXQL27oYSeOC+tyGwJ7Rcf+VZID5a7uMd1m3z5/AZaLWgEmqefWpf8
         3qaFlLUn8BlUXhm/c4Ttm8cv6x2zwD5io2lKQL8n7Q8UUvmwfIWdQ1bTspQSA8KmOmZM
         VHc7lznfOQDd/bXyFTFpHloZPDMVJA3PtHtTQYYjOGZb/ySe1oQone39FH8llk/+GcBx
         vDVnNYEZqqjuxYx4/nW1xpShNXcd3kUMVPgUtl4B1i5GYYzH0G3e1D8mSUPeloJDo96G
         Myow==
X-Gm-Message-State: AOAM531B3uK77ac7KzEiSCGwbv3THTpFdndVi3pmqH0DKsADDsa0VP9e
        Lg39IDx8+3HkvCu/5wGVCW6ILHBz9MKW1IoeuJcylQ==
X-Google-Smtp-Source: ABdhPJx5cZ45733UIwduqccvYHtyh+iGoi6wDenK4i7Lr/XUWh8fsoyG1SXgr19v3xbjOKHfFCXKhvtYEqgOfWxgmVc=
X-Received: by 2002:a92:2e0f:: with SMTP id v15mr1851165ile.110.1612489503314;
 Thu, 04 Feb 2021 17:45:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612398155.git.ashish.kalra@amd.com> <245f84cca80417b490e47da17e711432716e2e06.1612398155.git.ashish.kalra@amd.com>
In-Reply-To: <245f84cca80417b490e47da17e711432716e2e06.1612398155.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 4 Feb 2021 17:44:27 -0800
Message-ID: <CABayD+ecgZ-fn3kjf+W3dXsAEi6zDO-Pzv1Yvg0SB29C5EHdcw@mail.gmail.com>
Subject: Re: [PATCH v10 08/16] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 3, 2021 at 4:38 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.
>
> The patch introduces a new shared pages list implemented as a
> sorted linked list to track the shared/unencrypted regions marked by the
> guest hypercall.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  Documentation/virt/kvm/hypercalls.rst |  15 +++
>  arch/x86/include/asm/kvm_host.h       |   2 +
>  arch/x86/kvm/svm/sev.c                | 150 ++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c                |   2 +
>  arch/x86/kvm/svm/svm.h                |   5 +
>  arch/x86/kvm/vmx/vmx.c                |   1 +
>  arch/x86/kvm/x86.c                    |   6 ++
>  include/uapi/linux/kvm_para.h         |   1 +
>  8 files changed, 182 insertions(+)
>
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/k=
vm/hypercalls.rst
> index ed4fddd364ea..7aff0cebab7c 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -169,3 +169,18 @@ a0: destination APIC ID
>
>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>                 any of the IPI target vCPUs was preempted.
> +
> +
> +8. KVM_HC_PAGE_ENC_STATUS
> +-------------------------
> +:Architecture: x86
> +:Status: active
> +:Purpose: Notify the encryption status changes in guest page table (SEV =
guest)
> +
> +a0: the guest physical address of the start page
> +a1: the number of pages
> +a2: encryption attribute
> +
> +   Where:
> +       * 1: Encryption attribute is set
> +       * 0: Encryption attribute is cleared
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 3d6616f6f6ef..2da5f5e2a10e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1301,6 +1301,8 @@ struct kvm_x86_ops {
>         int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>
>         void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector=
);
> +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> +                                 unsigned long sz, unsigned long mode);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 25eaf35ba51d..55c628df5155 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -45,6 +45,11 @@ struct enc_region {
>         unsigned long size;
>  };
>
> +struct shared_region {
> +       struct list_head list;
> +       unsigned long gfn_start, gfn_end;
> +};
> +
>  static int sev_flush_asids(void)
>  {
>         int ret, error =3D 0;
> @@ -196,6 +201,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm=
_sev_cmd *argp)
>         sev->active =3D true;
>         sev->asid =3D asid;
>         INIT_LIST_HEAD(&sev->regions_list);
> +       INIT_LIST_HEAD(&sev->shared_pages_list);
> +       sev->shared_pages_list_count =3D 0;
>
>         return 0;
>
> @@ -1473,6 +1480,148 @@ static int sev_receive_finish(struct kvm *kvm, st=
ruct kvm_sev_cmd *argp)
>         return ret;
>  }
>
> +static int remove_shared_region(unsigned long start, unsigned long end,
> +                               struct list_head *head)
> +{
> +       struct shared_region *pos;
> +
> +       list_for_each_entry(pos, head, list) {
> +               if (pos->gfn_start =3D=3D start &&
> +                   pos->gfn_end =3D=3D end) {
> +                       list_del(&pos->list);
> +                       kfree(pos);
> +                       return -1;
> +               } else if (start >=3D pos->gfn_start && end <=3D pos->gfn=
_end) {
> +                       if (start =3D=3D pos->gfn_start)
> +                               pos->gfn_start =3D end + 1;
> +                       else if (end =3D=3D pos->gfn_end)
> +                               pos->gfn_end =3D start - 1;
> +                       else {
> +                               /* Do a de-merge -- split linked list nod=
es */
> +                               unsigned long tmp;
> +                               struct shared_region *shrd_region;
> +
> +                               tmp =3D pos->gfn_end;
> +                               pos->gfn_end =3D start-1;
> +                               shrd_region =3D kzalloc(sizeof(*shrd_regi=
on), GFP_KERNEL_ACCOUNT);
> +                               if (!shrd_region)
> +                                       return -ENOMEM;
> +                               shrd_region->gfn_start =3D end + 1;
> +                               shrd_region->gfn_end =3D tmp;
> +                               list_add(&shrd_region->list, &pos->list);
> +                               return 1;
> +                       }
> +                       return 0;
> +               }
> +       }

This doesn't handle the case where the region being marked as
encrypted is larger than than the unencrypted region under
consideration, which (I believe) can happen with the current kexec
handling (since it is oblivious to the prior state).
I would probably break this down into the "five cases": no
intersection (skip), entry is completely contained (drop), entry
completely contains the removed region (split), intersect start
(chop), and intersect end (chop).

>
> +       return 0;
> +}
> +
> +static int add_shared_region(unsigned long start, unsigned long end,
> +                            struct list_head *shared_pages_list)
> +{
> +       struct list_head *head =3D shared_pages_list;
> +       struct shared_region *shrd_region;
> +       struct shared_region *pos;
> +
> +       if (list_empty(head)) {
> +               shrd_region =3D kzalloc(sizeof(*shrd_region), GFP_KERNEL_=
ACCOUNT);
> +               if (!shrd_region)
> +                       return -ENOMEM;
> +               shrd_region->gfn_start =3D start;
> +               shrd_region->gfn_end =3D end;
> +               list_add_tail(&shrd_region->list, head);
> +               return 1;
> +       }
> +
> +       /*
> +        * Shared pages list is a sorted list in ascending order of
> +        * guest PA's and also merges consecutive range of guest PA's
> +        */
> +       list_for_each_entry(pos, head, list) {
> +               if (pos->gfn_end < start)
> +                       continue;
> +               /* merge consecutive guest PA(s) */
> +               if (pos->gfn_start <=3D start && pos->gfn_end >=3D start)=
 {
> +                       pos->gfn_end =3D end;

I'm not sure this correctly avoids having duplicate overlapping
elements in the list. It also doesn't merge consecutive contiguous
regions. Current guest implementation should never call the hypercall
with C=3D0 for the same region twice, without calling with c=3D1 in
between, but this API should be compatible with that model.

The easiest pattern would probably be to:
1) find (or insert) the node that will contain the added region.
2) remove the contents of the added region from the tail (will
typically do nothing).
3) merge the head of the tail into the current node, if the end of the
current node matches the start of that head.
>
> +                       return 0;
> +               }
> +               break;
> +       }
>
> +       /*
> +        * Add a new node, allocate nodes using GFP_KERNEL_ACCOUNT so tha=
t
> +        * kernel memory can be tracked/throttled in case a
> +        * malicious guest makes infinite number of hypercalls to
> +        * exhaust host kernel memory and cause a DOS attack.
> +        */
> +       shrd_region =3D kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT)=
;
> +       if (!shrd_region)
> +               return -ENOMEM;
> +       shrd_region->gfn_start =3D start;
> +       shrd_region->gfn_end =3D end;
> +       list_add_tail(&shrd_region->list, &pos->list);
> +       return 1;
>
> +}
> +

Thanks!
Steve
