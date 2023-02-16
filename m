Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4D2699CAE
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjBPSyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjBPSyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:54:03 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38B34AFCF
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:54:00 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id p14so3002222vsn.0
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JyRRKEGZ8zSR9Nqcb3MNGJNAmA81Hl5SP7GHLNm+Cm0=;
        b=bNCnbI+VXeIdOVQVm0sp1rmobHHtRTc9+2ERfzZi+u+Y/2FGqLRckgeiuLg8Ex3nLm
         0cUpC0qdwJjBHVo2Vi5ljBKsPHbc0Jn2ODIe1C1s8JYQvuF8kCa8m9CIolH5KGRZZYKP
         mOsC6CqHniQu+2TX0Bc5ZM+88NEakTpoG52aE3DbF0o8TWeNAeKOEXEFawDmNF+UDbsD
         Zv7+kC30Ig39liFHBwG9JNTIrekrPThxd0HrTxB6mzZE8VFVCpt/bbR/UZcgXRo2ZZOH
         a9j/pYumOiZMehj5gcnSH87ePomE82U/r+swRnENXuA5ixacoPmMm6fgHWUrsiZcbxop
         50XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JyRRKEGZ8zSR9Nqcb3MNGJNAmA81Hl5SP7GHLNm+Cm0=;
        b=vf7ChHVLPhbW1Ame39SCeSSOyKXlmZwAadzImU3acV6slyJ22+tfNIqZ8QyEklOThL
         HZaZxSv8j76wYyHKBC7KkP7a+LEwL0yM9Baf3PYhHRz1SG4YJT0+01OIzuZW+w/T/Qd2
         WDTdXy+7Lljn6hIiUsRXYLs26C9bpuingNLfskmewpnSdowBKYa3XMJCenrHONqrwyhE
         H9BEpcz/jj44sPwPa/NBOAJKKACuoRj0NEkdfCTr44K7i1uqI5WpPuB8f5HjlvDD/OK/
         EC7hxSriTI4jdU5bAGqoKOx/HxCw4zV1fkOyV8eIFBa9bDmVHLjGbsATB1q8D0WSUE6f
         FdhQ==
X-Gm-Message-State: AO0yUKUdMvi/cKkbA5t6SveM2Bn+Q+XxiqJVMbGESHoPB2Z6PS6QqrkI
        iay+hHFVTts7dxIGFJcIRjv6dxsvR3M/W4I4i+Gd5w==
X-Google-Smtp-Source: AK7set9dE37K0pvg3/0VA9YLcO6pH4noIv9bFNiaq7QbeTkkjSQXEmjErAL00CLE7/xnjYN1EglE9y72davbrfU8Qj8=
X-Received: by 2002:a05:6102:3b01:b0:412:6a3:2267 with SMTP id
 x1-20020a0561023b0100b0041206a32267mr1548682vsu.5.1676573639812; Thu, 16 Feb
 2023 10:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org>
In-Reply-To: <87mt5fz5g6.wl-maz@kernel.org>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 16 Feb 2023 10:53:47 -0800
Message-ID: <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 12:59 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Why not use KVM_ENABLE_CAP instead for this? Its a preexisting UAPI for
> toggling KVM behaviors.

Oh I wrote it this way because, even with the "args" field in "struct
kvm_enable_cap" to express the enable/disable intent, it felt weird to allow
disabling the feature through KVM_ENABLE_CAP. But it seems like that's the
convention, so I'll make the change.

> >  5. The kvm_run structure
> >  ========================
> >
> > @@ -6544,6 +6556,21 @@ array field represents return values. The userspace should update the return
> >  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
> >  spec refer, https://github.com/riscv/riscv-sbi-doc.
> > +
> > +             /* KVM_EXIT_MEMORY_FAULT */
> > +             struct {
> > +                     __u64 gpa;
> > +                     __u64 size;
> > +             } memory_fault;
> > +
>
> How is userspace expected to differentiate the gup_fast() failed exit
> from the guest-private memory exit? I don't think flags are a good idea
> for this, as it comes with the illusion that both events can happen on a
> single exit. In reality, these are mutually exclusive.
>
> A fault type/code would be better here, with the option to add flags at
> a later date that could be used to further describe the exit (if
> needed).

Agreed. Something like this, then?

+    struct {
+        __u32 fault_code;
+        __u64 reserved;
+        __u64 gpa;
+        __u64 size;
+    } memory_fault;

The "reserved" field is meant to be the placeholder for a future "flags" field.
Let me know if there's a better/more conventional way to achieve this.

On Wed, Feb 15, 2023 at 9:07 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 15, 2023, Marc Zyngier wrote:
> > On Wed, 15 Feb 2023 01:16:11 +0000, Anish Moorthy <amoorthy@google.com> wrote:
> > >  8. Other capabilities.
> > >  ======================
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 109b18e2789c4..9352e7f8480fb 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -801,6 +801,9 @@ struct kvm {
> > >     bool vm_bugged;
> > >     bool vm_dead;
> > >
> > > +   rwlock_t mem_fault_nowait_lock;
> > > +   bool mem_fault_nowait;
> >
> > A full-fat rwlock to protect a single bool? What benefits do you
> > expect from a rwlock? Why is it preferable to an atomic access, or a
> > simple bitop?
>
> There's no need to have any kind off dedicated atomicity.  The only readers are
> in vCPU context, just disallow KVM_CAP_MEM_FAULT_NOWAIT after vCPUs are created.

I think we do need atomicity here. When KVM_CAP_MEM_FAULT_NOWAIT is enabled
async page faults are essentially disabled: so userspace will likely want to
disable the cap at some point (such as the end of live migration post-copy).
Since we want to support this without having to pause vCPUs, there's an
atomicity requirement.

Marc, I used an rwlock simply because it seemed like the easiest correct thing
to do. I had a hunch that I'd be asked to change this to an atomic, so I can go
ahead and do that barring any other suggestions.

On Wed, Feb 15, 2023 at 12:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> > +:Returns: 0 on success, or -1 if KVM_CAP_MEM_FAULT_NOWAIT is not present.
>
> Please pick a meaningful error code instead of -1. And if you intended
> this as -EPERM, please explain the rationale (-EINVAL would seem more
> appropriate).

As I mention earlier, I'll be switching to toggling the capability via
KVM_ENABLE_CAP so this KVM_SET_MEM_FAULT_NOWAIT ioctl is going to go away. I
will make sure to set an appropriate error code if the user passes nonsensical
"args" to KVM_ENABLE_CAP though, whatever that ends up meaning.

> > +
> > +Enables (state=true) or disables (state=false) waitless memory faults. For more
> > +information, see the documentation of KVM_CAP_MEM_FAULT_NOWAIT.
> > +
> >  5. The kvm_run structure
> >  ========================
> >
> > @@ -6544,6 +6556,21 @@ array field represents return values. The userspace should update the return
> >  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
> >  spec refer, https://github.com/riscv/riscv-sbi-doc.
> >
> > +::
> > +
> > +             /* KVM_EXIT_MEMORY_FAULT */
> > +             struct {
> > +                     __u64 gpa;
> > +                     __u64 size;
> > +             } memory_fault;
> > +
> > +If exit reason is KVM_EXIT_MEMORY_FAULT then it indicates that the VCPU has
> > +encountered a memory error which is not handled by KVM kernel module and
> > +which userspace may choose to handle.
>
> No, the vcpu hasn't "encountered a memory error". The hypervisor has
> taken a page fault, which is very different. And it isn't that KVM
> couldn't handle it (or we wouldn't have a hypervisor at all). From
> what I understand of this series (possibly very little), userspace has
> to *ask* for these, and they are delivered in specific circumstances.
> Which are?

Thanks for the correction: "encountered a memory error" was incorrect phrasing.
What is your opinion on the following, hopefully more accurate, documentation?

"An exit reason of KVM_EXIT_MEMORY_FAULT indicates that the vCPU encountered a
memory fault for which the userspace page tables did not contain a present
mapping. This exit is only generated when KVM_CAP_MEM_FAULT_NOWAIT is enabled:
otherwise KVM will attempt to resolve the fault without exiting to userspace,
returning -1 with errno=EFAULT when it cannot."

It might also help to note that the vCPUs exit in exactly the same cases where
userspace would get a page fault when trying to access the memory through the
VMA/mapping provided to the memslot. Please let me know if you feel that this
information should be included in the documentation, or if you see anything else
I've gotten wrong.

As for handling these faults: userspace should consider its own knowledge of the
guest and determine how best to resolve each fault. For instance if userspace
hasn't UFFDIO_COPY/CONTINUEd a faulting page yet, then it must do so to
establish the mapping. If it already did, then the next step would be to fault
in the page via MADV_POPULATE_READ|WRITE.

A naive userspace could just always MADV_POPULATE_READ|WRITE in response to
these faults: that would basically yield KVM's behavior *without* the capability
enabled, just with extra steps, worse performance, and no chance for async page
faults.

A final note: this is just how the fault applies in the context of
userfaultfd-based post-copy live migration. Other uses might come up in the
future, in which case userspace would want to take some other sort of action.

> > +'gpa' and 'size' indicate the memory range the error occurs at. Userspace
> > +may handle the error and return to KVM to retry the previous memory access.
>
> What are these *exactly*? In what unit?

Sorry, I'll add some descriptive comments here. "gpa" is the guest physical
address of the faulting page (rounded down to be aligned with "size"), and
"size" is just the size in bytes of the faulting page.

> ... What guarantees that the
> process eventually converges? How is userspace supposed to handle the
> fault (which is *not* an error)? Don't you need to communicate other
> information, such as the type of fault (read, write, permission or
> translation fault...)?

Ok, two parts to the response here.

1. As Oliver touches on earlier, we'll probably want to use this same field for
   different classes of memory fault in the future (such as the ones which Chao
   is introducing in [1]): so it does make sense to add "code" and "flags"
   fields which can be used to communicate more information to the user (and
   which can just be set to MEM_FAULT_NOWAIT/0 in this series).

2. As to why a code/flags of MEM_FAULT_NOWAIT/0 should be enough information to
   convey to the user here: the assumption behind this series is that
   MADV_POPULATE_READ|WRITE will always be enough to ensure that the vCPU can
   run again. This goes back to the earlier claim about vCPUs exiting in the
   exact same cases as when userspace would get a page fault trying to access
   the same memory. MADV_POPULATE_READ|WRITE is intended to resolve exactly
   these cases, so userspace shouldn't need anything more.

Again, a VMM enabling the new exit to make post-copy faster must determine what
action to take depending on whether it has UFFDIO_COPY|CONTINUEd the faulting
page (at least for now, perhaps there will be more uses in the future): we can
keep discussing if this seems fragile. Just keeping things limited to
userfaultfd, having KVM communicate to userspace which action is required could
get difficult. For UFFDIO_CONTINUE we'd have to check if the VMA had
VM_UFFD_MINOR, and for UFFDIO_COPY we'd have to at least check the page cache.

> >
> > +7.34 KVM_CAP_MEM_FAULT_NOWAIT
> > +-----------------------------
> > +
> > +:Architectures: x86, arm64
> > +:Target: VM
> > +:Parameters: None
> > +:Returns: 0 on success, or -EINVAL if capability is not supported.
> > +
> > +The presence of this capability indicates that userspace can enable/disable
> > +waitless memory faults through the KVM_SET_MEM_FAULT_NOWAIT ioctl.
> > +
> > +When waitless memory faults are enabled, fast get_user_pages failures when
> > +handling EPT/Shadow Page Table violations will cause a vCPU exit
> > +(KVM_EXIT_MEMORY_FAULT) instead of a fallback to slow get_user_pages.
>
> Do you really expect a random VMM hacker to understand what GUP is?
> Also, the x86 verbiage makes zero sense to me. Please write this in a
> way that is useful for userspace people, because they are the ones
> consuming this documentation. I really can't imagine anyone being able
> to write something useful based on this.

My bad: obviously I shouldn't be exposing the kernel's implementation details
here. As for what the documentation should actually say, I'm thinking I can
adapt the revised description of the KVM exit from earlier ("An exit reason of
KVM_EXIT_MEMORY_FAULT indicates..."). Again, please let me know if you see
anything which should be changed there.

> > +             /* KVM_EXIT_MEMORY_FAULT */
> > +             struct {
> > +                     __u64 flags;
> > +                     __u64 gpa;
> > +                     __u64 size;
> > +             } memory_fault;
>
> Sigh... This doesn't even match the documentation.

Ack! Ack.

> > -/* Available with  KVM_CAP_S390_VCPU_RESETS */
> > +/* Available with KVM_CAP_S390_VCPU_RESETS */
>
> Unrelated change?

Yes, I'll drop it from the next revision.

> > +             r = -EFAULT;
> > +             if (copy_from_user(&state, argp, sizeof(state)))
>
> A copy_from_user for... a bool? Why don't you directly treat argp as
> the boolean itself? Of even better, make it a more interesting
> quantity so that the API can evolve in the future. As it stands, it is
> not extensible, which means it is already dead, if Linux APIs are
> anything to go by.

I'll keep that in mind for the future, but this is now moot since I'll be
removing KVM_SET_MEM_FAULT_NOWAIT.

> On a related subject: is there a set of patches for any of the main
> VMMs making any use of this?

No. For what it's worth, the demand_paging_selftest demonstrates the basics of
what userspace can do with the new exit. Would it be helpful to see how QEMU
could use it as well?

[1] https://lore.kernel.org/all/CA+EHjTyzZ2n8kQxH_Qx72aRq1k+dETJXTsoOM3tggPZAZkYbCA@mail.gmail.com/
