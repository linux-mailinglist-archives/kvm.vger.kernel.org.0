Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B9587E17
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 16:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiHBO0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 10:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiHBO0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 10:26:44 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E9112D20;
        Tue,  2 Aug 2022 07:26:42 -0700 (PDT)
Date:   Tue, 2 Aug 2022 16:26:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659450400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EaLNjoWTWPcI7ofUyVBcC8g8dDyBo9LPkCcGpQyi7So=;
        b=I28bvGnLEdldd4C3LsEGRhzi0D8TAiTZgiUgqCaTGEu64Q5Y2kIG8vbB98SXunVoAPQDLw
        MIYArnNrDsy46ldhxM5V2P22Nx8o/rNeSdBqdrXRE7qiBIDdMMJgbbIGmfGSdz/eLO0yJc
        7nifMEtRvFr/M9RlKBN4dEl/E2NfYRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [V2 09/11] KVM: selftests: Make ucall work with encrypted guests
Message-ID: <20220802142638.vw6iw3dvyl4j5iyr@kamzik>
References: <20220801201109.825284-1-pgonda@google.com>
 <20220801201109.825284-10-pgonda@google.com>
 <20220802094915.lkmoz52gztzjjun4@kamzik>
 <CAMkAt6q9OSXCfj7y=g5H-82tRQfFvX84fjpcfYUrs+mKtGMHzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6q9OSXCfj7y=g5H-82tRQfFvX84fjpcfYUrs+mKtGMHzg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 07:51:40AM -0600, Peter Gonda wrote:
> On Tue, Aug 2, 2022 at 3:49 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> >
> > On Mon, Aug 01, 2022 at 01:11:07PM -0700, Peter Gonda wrote:
> > > Add support for encrypted, SEV, guests in the ucall framework. If
> > > encryption is enabled set up a pool of ucall structs in the guests'
> > > shared memory region. This was suggested in the thread on "[RFC PATCH
> > > 00/10] KVM: selftests: Add support for test-selectable ucall
> > > implementations". Using a listed as suggested there doesn't work well
> > > because the list is setup using HVAs not GVAs so use a bitmap + array
> > > solution instead to get the same pool result.
> > >
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > ---
> > >  .../selftests/kvm/include/kvm_util_base.h     |   3 +
> > >  .../selftests/kvm/include/ucall_common.h      |  14 +--
> > >  .../testing/selftests/kvm/lib/ucall_common.c  | 112 +++++++++++++++++-
> > >  3 files changed, 115 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > index 8ce9e5be70a3..ad4abc6be1ab 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > @@ -102,6 +102,9 @@ struct kvm_vm {
> > >       int stats_fd;
> > >       struct kvm_stats_header stats_header;
> > >       struct kvm_stats_desc *stats_desc;
> > > +
> > > +     bool use_ucall_list;
> >
> > use_ucall_pool
> >
> > > +     struct list_head ucall_list;
> > >  };
> 
> Will do. I also need to remove this |ucall_list| member.
> 
> > >
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> > > index c1bc8e33ef3f..a96220ac6024 100644
> > > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > > @@ -22,6 +22,10 @@ enum {
> > >  struct ucall {
> > >       uint64_t cmd;
> > >       uint64_t args[UCALL_MAX_ARGS];
> > > +
> > > +     /* For encrypted guests. */
> >
> > Please, no 'encrypted' words in ucall files. ucalls shouldn't care about
> > guest types. Indeed, the summary of this patch could even drop the word
> > 'encrypted'. This patch is adding support for ucall pools, which is
> > motivated by the need to support encrypted guests (the motivation should
> > go in the commit message, but otherwise the patch should be ucall specific
> > and guest type agnostic)
> >
> > > +     uint64_t idx;
> >
> > We don't need 'idx' because 'hva' will always be at the
> > idx * sizeof(struct ucall) offset of ucall_hdr->ucalls, which means
> > we can always calculate it,
> >
> >  static inline size_t uc_pool_idx(struct ucall *uc)
> >  {
> >         return uc->hva - ucall_hdr->ucalls;
> >  }
> 
> Good call, I didn't think of that.
> 
> >
> > > +     struct ucall *hva;
> > >  };
> > >
> > >  void ucall_arch_init(struct kvm_vm *vm, void *arg);
> > > @@ -32,15 +36,9 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
> > >  void ucall(uint64_t cmd, int nargs, ...);
> > >  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> > >
> > > -static inline void ucall_init(struct kvm_vm *vm, void *arg)
> > > -{
> > > -     ucall_arch_init(vm, arg);
> > > -}
> > > +void ucall_init(struct kvm_vm *vm, void *arg);
> > >
> > > -static inline void ucall_uninit(struct kvm_vm *vm)
> > > -{
> > > -     ucall_arch_uninit(vm);
> > > -}
> > > +void ucall_uninit(struct kvm_vm *vm);
> > >
> > >  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)       \
> > >                               ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> > > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> > > index a060252bab40..feb0173179ec 100644
> > > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > > @@ -1,22 +1,122 @@
> > >  // SPDX-License-Identifier: GPL-2.0-only
> > >  #include "kvm_util.h"
> > > +#include "linux/types.h"
> > > +#include "linux/bitmap.h"
> > > +#include "linux/atomic.h"
> > > +
> > > +struct ucall_header {
> > > +     DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
> > > +     struct ucall ucalls[KVM_MAX_VCPUS];
> > > +};
> > > +
> > > +static bool use_ucall_list;
> >
> > use_ucall_pool
> >
> > > +static struct ucall_header *ucall_hdr;
> >
> > ucall_pool
> 
> Will update naming here.
> 
> >
> > > +
> > > +void ucall_init(struct kvm_vm *vm, void *arg)
> > > +{
> > > +     struct ucall *uc;
> > > +     struct ucall_header *hdr;
> > > +     vm_vaddr_t vaddr;
> > > +     int i;
> > > +
> > > +     use_ucall_list = vm->use_ucall_list;
> > > +     sync_global_to_guest(vm, use_ucall_list);
> > > +     if (!use_ucall_list)
> > > +             goto out;
> > > +
> > > +     TEST_ASSERT(!ucall_hdr,
> > > +                 "Only a single encrypted guest at a time for ucalls.");
> >
> > single VM at a time
> >
> > And I'd leave that on a single line. checkpatch allows up to 100 chars and
> > I'm included to use all 110 chars of it.
> 
> Sounds good.
> 
> >
> > > +     vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
> > > +     hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
> > > +     memset(hdr, 0, sizeof(*hdr));
> > > +
> > > +     for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> > > +             uc = &hdr->ucalls[i];
> > > +             uc->hva = uc;
> > > +             uc->idx = i;
> > > +     }
> > > +
> > > +     ucall_hdr = (struct ucall_header *)vaddr;
> > > +     sync_global_to_guest(vm, ucall_hdr);
> > > +
> > > +out:
> > > +     ucall_arch_init(vm, arg);
> > > +}
> > > +
> > > +void ucall_uninit(struct kvm_vm *vm)
> > > +{
> > > +     use_ucall_list = false;
> > > +     ucall_hdr = NULL;
> >
> > It's unlikely we'd ever change the ucall setup on a running VM,
> > but we should sync these changes to the guest for good measure.
> 
> Hmm I'll need to have some notion of encrypted guests here then. Since
> the guests page tables also get encrypted we can no longer get the
> gva2gpa translations so sync_global_to_guest() cannot be done due to
> the addr_ga2hva(). So is it OK if this call references encryption like
> below?
> 
>     use_ucall_list = false;
>      ucall_hdr = NULL;
> if (!vm->memencrypt.encrypted) {
>    sync_global_to_guest(vm, use_ucall_list);
>   sync_global_to_guest(vm, ucall_hdr);
> }

Yes, I guess that's the best we can do.

If sync_global_to_guest() becomes useless once a guest is encrypted then
maybe it should assert !vm->memencrypt.encrypted.

> 
> >
> > > +
> > > +     ucall_arch_uninit(vm);
> > > +}
> > > +
> > > +static struct ucall *ucall_alloc(void)
> > > +{
> > > +     struct ucall *uc = NULL;
> > > +     int i;
> > > +
> > > +     if (!use_ucall_list)
> > > +             goto out;
> > > +
> > > +     for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> > > +             if (atomic_test_and_set_bit(i, ucall_hdr->in_use))
> > > +                     continue;
> > > +
> > > +             uc = &ucall_hdr->ucalls[i];
> > > +     }
> >
> > This is not what I suggested in the last revision and it's still wrong.
> > Here, you're still looping through all of the pool and returning the last
> > one.
> >
> > What I suggested was
> >
> >         for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> >                 if (!atomic_test_and_set_bit(i, ucall_hdr->in_use)) {
> >                         uc = &ucall_hdr->ucalls[i];
> >                         break;
> >                 }
> >         }
> >
> > Notice how we leave the loop early when we find a free uc.
> 
> Ah my mistake, I didn't get this fix into this series
> 
> >
> > We should also zero the contents of the uc buffer before returning.
> 
> Ack will do.
> 
> >
> > > +
> > > +out:
> > > +     return uc;
> > > +}
> > > +
> > > +static void ucall_free(struct ucall *uc)
> > > +{
> > > +     if (!use_ucall_list)
> > > +             return;
> > > +
> > > +     clear_bit(uc->idx, ucall_hdr->in_use);
> >
> > This seems to be the one and only use of idx which is another argument for
> > dropping the variable and just calculating it instead.
> 
> Will do.
> 
> >
> > > +}
> > > +
> > > +static vm_vaddr_t get_ucall_addr(struct ucall *uc)
> > > +{
> > > +     if (use_ucall_list)
> > > +             return (vm_vaddr_t)uc->hva;
> >
> > A comment explaining that this hva has already been synchronized
> > with the guest would be good. Or maybe a different name for the
> > pointer than hva, one which conveys that it's a pointer that works
> > as both an hva and gva would be better.
> 
> I don't think this pointer does work as a gva though since its created
> by just taking &uc during host execution. I can add a comment that
> mentions this is a hva is already translated for the host and not for
> guest use other than communicating with the host. I thought 'hva' was
> a good name here since it is literally the hva of this ucall struct,
> what name would you prefer?

My mistake, I forgot how we initialized uc->hva. 'hva' is a good name.

> 
> >
> >
> > > +
> > > +     return (vm_vaddr_t)uc;
> > > +}
> > >
> > >  void ucall(uint64_t cmd, int nargs, ...)
> > >  {
> > > -     struct ucall uc = {
> > > -             .cmd = cmd,
> > > -     };
> >
> > This zeros all members except cmd.
> >
> > > +     struct ucall *uc;
> > > +     struct ucall tmp;
> >
> > And this makes tmp full of stack garbage, so in the non uc-pool case we
> > no longer have an equivalent uc. Please initialize tmp the same way uc
> > was initialized.
> 
> Ack, I'll get this fixed.
> 
> >
> > >       va_list va;
> > >       int i;
> > >
> > > +     uc = ucall_alloc();
> > > +     if (!uc)
> > > +             uc = &tmp;
> > > +
> > > +     uc->cmd = cmd;
> > > +
> > >       nargs = min(nargs, UCALL_MAX_ARGS);
> > >
> > >       va_start(va, nargs);
> > >       for (i = 0; i < nargs; ++i)
> > > -             uc.args[i] = va_arg(va, uint64_t);
> > > +             uc->args[i] = va_arg(va, uint64_t);
> > >       va_end(va);
> > >
> > > -     ucall_arch_do_ucall((vm_vaddr_t)&uc);
> > > +     ucall_arch_do_ucall(get_ucall_addr(uc));
> >
> > We don't need get_ucall_addr(). Just do the if-else right here
> >
> >    if (use_ucall_list)
> >        ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
> >    else
> >       ucall_arch_do_ucall((vm_vaddr_t)uc);
> 
> Will do.
> 
> >
> > > +
> > > +     ucall_free(uc);
> > > +}
> > > +
> > > +static void *get_ucall_hva(struct kvm_vm *vm, uint64_t uc)
> > > +{
> > > +     if (vm->use_ucall_list)
> > > +             return (void *)uc;
> > > +
> > > +     return addr_gva2hva(vm, uc);
> > >  }
> > >
> > >  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > > @@ -27,7 +127,7 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> > >       if (!uc)
> > >               uc = &ucall;
> > >
> > > -     addr = addr_gva2hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
> > > +     addr = get_ucall_hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
> >
> > Wait, I thought we wanted ucall_arch_get_ucall() to return hvas?
> > It would make more sense if it did, since it's called from the
> > host.
> 
> As you noted in [V2 07/11] I updated ucall_arch_get_ucall() to return
> the gva. I figured this was just more boilerplate which could be
> consolidated given all archs right now just use the addr_gva2hva()
> helper to do this translation. This change also allowed for the
> "use_ucall_pool" to be completely contained in ucall_common.c instead
> of spilling into each arch specific file. If there is a preference to
> have the arch specific calls translate from gva to hva I can do that,
> I think I'll need to have them all check if "use_ucall_pool" is set
> though. Thoughts?

I just checked what I wrote for the last version of this patch,
"[RFC V1 08/10] KVM: selftests: Make ucall work with encrypted guests".
It was

> ...we're only updating x86's ucall_arch_get_ucall() to return gvas.
> What about the other architectures? Anyway, I'd rather we don't
> change ucall_arch_get_ucall() to return gvas. They should continue
> returning hvas and any trickery needed to translate a pool uc to
> an hva should be put inside ucall_arch_get_ucall().

(It's comforting to see I was consistent, at least wrt the last review.)

So, I would keep returning hvas and put the 'if use_ucall_pool' inside
the ucall_arch_get_ucall() functions.

Thanks,
drew

> 
> We can still update ucall_arch_get_ucall() to return a pointer type so
> that we can return NULL instead of 0.
> 
> >
> > >       if (addr) {
> > >               memcpy(uc, addr, sizeof(*uc));
> > >               vcpu_run_complete_io(vcpu);
> > > --
> > > 2.37.1.455.g008518b4e5-goog
> > >
> >
> > Thanks,
> > drew
