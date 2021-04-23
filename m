Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06E369010
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 12:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242026AbhDWKG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 06:06:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:16479 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhDWKG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 06:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1619172382; x=1650708382;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=NqNh1cmvx7Jya0AhkcVQWTNhWdJSU5+SRsoIOobowto=;
  b=wATh9o1YIlh5EWBN4mhjjJNtuDhWb6YW1f3+t9ztJtDfpJvGRsdiFTn7
   EwE3L1dT5oC+e0deG23kXUPb7O5WhwiJTPaZH+CsyL3rCFZzH+kp+xLu0
   QxyuUK3Kbau4iQLdYg4LXIP+x4FSXwPLHlrlpiYPSJSnin6LkEyfyj5Fc
   E=;
X-IronPort-AV: E=Sophos;i="5.82,245,1613433600"; 
   d="scan'208";a="121023440"
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 23 Apr 2021 10:06:14 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id B1C7A14002F;
        Fri, 23 Apr 2021 10:06:08 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.81) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 23 Apr 2021 10:06:02 +0000
Date:   Fri, 23 Apr 2021 12:05:58 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <20210423100557.GB30824@uc8bbc9586ea454.ant.amazon.com>
References: <20210423090333.21910-1-sidcha@amazon.de>
 <87y2d9filg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87y2d9filg.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.81]
X-ClientProxiedBy: EX13D16UWB003.ant.amazon.com (10.43.161.194) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 11:36:27AM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > Hypercall code page is specified in the Hyper-V TLFS to be an overlay
> > page, ie., guest chooses a GPA and the host _places_ a page at that
> > location, making it visible to the guest and the existing page becomes
> > inaccessible. Similarly when disabled, the host should _remove_ the
> > overlay and the old page should become visible to the guest.
> >
> > Currently KVM directly patches the hypercall code into the guest chosen
> > GPA. Since the guest seldom moves the hypercall code page around, it
> > doesn't see any problems even though we are corrupting the exiting data
> > in that GPA.
> >
> > VSM API introduces more complex overlay workflows during VTL switches
> > where the guest starts to expect that the existing page is intact. This
> > means we need a more generic approach to handling overlay pages: add a
> > new exit reason KVM_EXIT_HYPERV_OVERLAY that exits to userspace with the
> > expectation that a page gets overlaid there.
> >
> > In the interest of maintaing userspace exposed behaviour, add a new KVM
> > capability to allow the VMMs to enable this if they can handle the
> > hypercall page in userspace.
> >
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> >
> > CR: https://code.amazon.com/reviews/CR-49011379
> 
> This line wasn't supposed to go to the upstream patch, was it? :-)

Yes. Will be removed in future :)

> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++++
> >  arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++++++---
> >  arch/x86/kvm/x86.c              |  5 +++++
> >  include/uapi/linux/kvm.h        | 10 ++++++++++
> >  4 files changed, 41 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3768819693e5..2b560e77f8bc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -925,6 +925,10 @@ struct kvm_hv {
> >
> >       struct hv_partition_assist_pg *hv_pa_pg;
> >       struct kvm_hv_syndbg hv_syndbg;
> > +
> > +     struct {
> > +             u64 overlay_hcall_page:1;
> > +     } flags;
> 
> Do you plan to add more flags here? If not, I'd suggest we use a simple
> boolean instead of the whole 'flags' structure.

No nothing in particular, was just being futuristic. I'll change it too bool.

> >  };
> >
> >  struct msr_bitmap_range {
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index f98370a39936..e7d9d3bb39dc 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -191,6 +191,21 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
> >       srcu_read_unlock(&kvm->irq_srcu, idx);
> >  }
> >
> > +static void overlay_exit(struct kvm_vcpu *vcpu, u32 msr, u64 gpa,
> > +                      u32 data_len, const u8 *data)
> > +{
> > +     struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> > +
> > +     hv_vcpu->exit.type = KVM_EXIT_HYPERV_OVERLAY;
> > +     hv_vcpu->exit.u.overlay.msr = msr;
> > +     hv_vcpu->exit.u.overlay.gpa = gpa;
> > +     hv_vcpu->exit.u.overlay.data_len = data_len;
> > +     if (data_len)
> > +             memcpy(hv_vcpu->exit.u.overlay.data, data, data_len);
> 
> It seems this exit to userspace has double meaning:
> 1) Please put an overlay page at GPA ... (are we sure we will never need
> more than one page?)
> 2) Do something else depending on the MSR which triggered the write (are
> we sure all such exits are going to be triggered by an MSR write?)

Currently there are 4 types of overlay pages defined in the Hyper-V TLFS:
 - Hypercall code page
 - Synic message page
 - Synic event page
 - VP Assist page

All of them are single pages and are MSR triggered. The userspace is
responsible for overlaying the page and copying the initial data if-any
to that page.

> and I'm wondering if it would be possible to actually limit
> KVM_EXIT_HYPERV_OVERLAY to 'put an overlay page' and do the rest somehow
> differently.
> 
> In particularly, I think we can still do hypercall page patching
> directly from KVM after overlay page setup.

After we have given up control to the userspace, we don't have a way to
write to the page that got overlaid before the guest execution resumes
(as it expects the page to be ready after the MSR write).

The other alternative is to expose a new ioctl to write this data but
that seems excessive considering what we are trying to achieve here.

> With VTL, when the logic is
> more complex, do you expect it to be implemented primarily in userspace?

During VTL switches, we plan to exit to user space to re-overlay the
right per-VTL page.

> > +
> > +     kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
> > +}
> > +
> >  static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
> >  {
> >       struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
> > @@ -1246,9 +1261,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
> >               /* ret */
> >               ((unsigned char *)instructions)[i++] = 0xc3;
> >
> > -             addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
> > -             if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
> > -                     return 1;
> > +             if (kvm->arch.hyperv.flags.overlay_hcall_page) {
> > +                     overlay_exit(vcpu, msr, data, (u32)i, instructions);
> > +             } else {
> > +                     addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
> > +                     if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
> > +                             return 1;
> > +             }
> >               hv->hv_hypercall = data;
> >               break;
> >       }
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index eca63625aee4..b3e497343e5c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3745,6 +3745,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >       case KVM_CAP_HYPERV_TLBFLUSH:
> >       case KVM_CAP_HYPERV_SEND_IPI:
> >       case KVM_CAP_HYPERV_CPUID:
> > +     case KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE:
> >       case KVM_CAP_SYS_HYPERV_CPUID:
> >       case KVM_CAP_PCI_SEGMENT:
> >       case KVM_CAP_DEBUGREGS:
> > @@ -5357,6 +5358,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                       kvm->arch.bus_lock_detection_enabled = true;
> >               r = 0;
> >               break;
> > +     case KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE:
> > +             kvm->arch.hyperv.flags.overlay_hcall_page = true;
> > +             r = 0;
> > +             break;
> >       default:
> >               r = -EINVAL;
> >               break;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index f6afee209620..37b0715da4fd 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -185,10 +185,13 @@ struct kvm_s390_cmma_log {
> >       __u64 values;
> >  };
> >
> > +#define KVM_EXIT_HV_OVERLAY_DATA_SIZE  64
> 
> Could you please elaborate on why you think 64 bytes is going to be
> enough? (like what structures we'll be passing here for VTL)

With VSM, we need 36 bytes. That number was rounded up to next power of
2 for future needs.

> > +
> >  struct kvm_hyperv_exit {
> >  #define KVM_EXIT_HYPERV_SYNIC          1
> >  #define KVM_EXIT_HYPERV_HCALL          2
> >  #define KVM_EXIT_HYPERV_SYNDBG         3
> > +#define KVM_EXIT_HYPERV_OVERLAY        4
> 
> Please document this in Documentation/virt/kvm/api.rst
> 
> >       __u32 type;
> >       __u32 pad1;
> >       union {
> > @@ -213,6 +216,12 @@ struct kvm_hyperv_exit {
> >                       __u64 recv_page;
> >                       __u64 pending_page;
> >               } syndbg;
> > +             struct {
> > +                     __u32 msr;
> > +                     __u32 data_len;
> > +                     __u64 gpa;
> > +                     __u8 data[KVM_EXIT_HV_OVERLAY_DATA_SIZE];
> 
> ... in partucular, please document the meaning of 'data' (in case it
> needs to be here).

Ack.

> > +             } overlay;
> >       } u;
> >  };
> >
> > @@ -1078,6 +1087,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_DIRTY_LOG_RING 192
> >  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> >  #define KVM_CAP_PPC_DAWR1 194
> > +#define KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE 195
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> 
> --

Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



