Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609245EDB87
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 13:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiI1LP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 07:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiI1LOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 07:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97E2625C
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 04:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664363675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9VP1b5FjBz3eQjrTuWyZDYVNGrDjksZQALujn01OoWs=;
        b=cL9u0DXFQcW53HtvW0kiYpEMxv+1iL7io9V5FLqFKKaKb5XxcBbczp6gFqYgcvwfDTuNuu
        A8sivaiQBxmxJs2YEF7eD1s/lirlYCJA6P6rHl1ZscbV7mNDnbNfqlVwMa+YA5e2lShfK3
        4HsUNjVdQKJeJ4Mn1sV0NCvXosCZ/Vw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-VUs_GW96OIqOobltKd0Vaw-1; Wed, 28 Sep 2022 07:14:31 -0400
X-MC-Unique: VUs_GW96OIqOobltKd0Vaw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 215FE29DD996;
        Wed, 28 Sep 2022 11:14:31 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12B004A927A;
        Wed, 28 Sep 2022 11:14:25 +0000 (UTC)
Message-ID: <e3a7ab12e3941e17c033e172eb063cc645d70eb4.camel@redhat.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Date:   Wed, 28 Sep 2022 14:14:24 +0300
In-Reply-To: <b3dc9505-9a5c-a631-065a-85bf86b1d071@redhat.com>
References: <YxtOEgJhe4EcAJsE@google.com>
         <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
         <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
         <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
         <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
         <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
         <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
         <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
         <YzIZhn47brWBfQah@google.com>
         <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
         <YzMdjSkKaJ8HyWXh@google.com>
         <b3dc9505-9a5c-a631-065a-85bf86b1d071@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-09-28 at 11:11 +0200, Emanuele Giuseppe Esposito wrote:
> 
> Am 27/09/2022 um 17:58 schrieb Sean Christopherson:
> > On Tue, Sep 27, 2022, Emanuele Giuseppe Esposito wrote:
> > > Am 26/09/2022 um 23:28 schrieb Sean Christopherson:
> > > > On Mon, Sep 26, 2022, David Hildenbrand wrote:
> > > > > As Sean said "This is an awful lot of a complexity to take on for something
> > > > > that appears to be solvable in userspace."
> > > > 
> > > > And if the userspace solution is unpalatable for whatever reason, I'd like to
> > > > understand exactly what KVM behavior is problematic for userspace.  E.g. the
> > > > above RHBZ bug should no longer be an issue as the buggy commit has since been
> > > > reverted.
> > > 
> > > It still is because I can reproduce the bug, as also pointed out in
> > > multiple comments below.
> > 
> > You can reproduce _a_ bug, but it's obviously not the original bug, because the
> > last comment says:
> > 
> >   Second, indeed the patch was reverted and somehow accepted without generating
> >   too much noise:
> > 
> >   ...
> > 
> >   The underlying issue of course as we both know is still there.
> > 
> >   You might have luck reproducing it with this bug
> > 
> >   https://bugzilla.redhat.com/show_bug.cgi?id=1855298
> > 
> >   But for me it looks like it is 'working' as well, so you might have
> >   to write a unit test to trigger the issue.
> > 
> > > > If the issue is KVM doing something nonsensical on a code fetch to MMIO, then I'd
> > > > much rather fix _that_ bug and improve KVM's user exit ABI to let userspace handle
> > > > the race _if_ userspace chooses not to pause vCPUs.
> > > > 
> > > 
> > > Also on the BZ they all seem (Paolo included) to agree that the issue is
> > > non-atomic memslots update.
> > 
> > Yes, non-atomic memslot likely results in the guest fetching from a GPA without a
> > memslot.  I'm asking for an explanation of exactly what happens when that occurs,
> > because it should be possible to adjust KVM and/or QEMU to play nice with the
> > fetch, e.g. to resume the guest until the new memslot is installed, in which case
> > an atomic update isn't needed.
> > 
> > I assume the issue is that KVM exits with KVM_EXIT_INTERNAL_ERROR because the
> > guest is running at CPL=0, and QEMU kills the guest in response.  If that's correct,
> > then that problem can be solved by exiting to userspace with KVM_EXIT_MMIO instead
> > of KVM_EXIT_INTERNAL_ERROR so that userspace can do something sane in response to
> > the MMIO code fetch.
> > 
> > I'm pretty sure this patch will Just Work for QEMU, because QEMU simply resumes
> > the vCPU if mmio.len==0.  It's a bit of a hack, but I don't think it violates KVM's
> > ABI in any way, and it can even become "official" behavior since KVM x86 doesn't
> > otherwise exit with mmio.len==0.
> > 
> > Compile tested only...
> 
> So basically you are just making KVM catch the failed
> kvm_vcpu_read_guest_page() by retuning mmio.len = 0 to QEMU which
> basically ends up in doing nothing and retry again executing the
> instruction?
> 
> I wonder if there are some performance implications in this, but it's
> definitely simpler than what I did.
> 
> Tested on the same failing machine used for the BZ, fixes the bug.
> 
> Do you want me to re-send the patch on your behalf (and add probably a
> small documentation on Documentation/virt/kvm/api.rst)?
> 
> Emanuele
> > ---
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Tue, 27 Sep 2022 08:16:03 -0700
> > Subject: [PATCH] KVM: x86: Exit to userspace with zero-length MMIO "read" on
> >  MMIO fetch
> > 
> > Exit to userspace with KVM_EXIT_MMIO if emulation fails due to not being
> > able to fetch instruction bytes, e.g. if the resolved GPA isn't backed by
> > a memslot.  If userspace is manipulating memslots without pausing vCPUs,
> > e.g. to emulate BIOS relocation, then a vCPU may fetch while there is no
> > valid memslot installed.  Depending on guest context, KVM will either
> > exit to userspace with KVM_EXIT_INTERNAL_ERROR (L1, CPL=0) or simply
> > resume the guest (L2 or CPL>0), neither of which is desirable as exiting
> > with "emulation error" effectively kills the VM, and resuming the guest
> > doesn't provide userspace an opportunity to react the to fetch.
> > 
> > Use "mmio.len == 0" to indicate "fetch".  This is a bit of a hack, but
> > there is no other way to communicate "fetch" to userspace without
> > defining an entirely new exit reason, e.g. "mmio.is_write" is a boolean
> > and not a flag, and there is no known use case for actually supporting
> > code fetches from MMIO, i.e. there's no need to allow userspace to fill
> > in the instruction bytes.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/emulate.c     | 2 ++
> >  arch/x86/kvm/kvm_emulate.h | 1 +
> >  arch/x86/kvm/x86.c         | 9 ++++++++-
> >  3 files changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index f092c54d1a2f..e141238d93b0 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -5353,6 +5353,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
> >  done:
> >  	if (rc == X86EMUL_PROPAGATE_FAULT)
> >  		ctxt->have_exception = true;
> > +	if (rc == X86EMUL_IO_NEEDED)
> > +		return EMULATION_IO_FETCH;
> >  	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
> >  }
> >  
> > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > index 89246446d6aa..3cb2e321fcd2 100644
> > --- a/arch/x86/kvm/kvm_emulate.h
> > +++ b/arch/x86/kvm/kvm_emulate.h
> > @@ -516,6 +516,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
> >  #define EMULATION_OK 0
> >  #define EMULATION_RESTART 1
> >  #define EMULATION_INTERCEPTED 2
> > +#define EMULATION_IO_FETCH 3
> >  void init_decode_cache(struct x86_emulate_ctxt *ctxt);
> >  int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
> >  int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index aa5ab0c620de..7eb72694c601 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7129,8 +7129,13 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
> >  		bytes = (unsigned)PAGE_SIZE - offset;
> >  	ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, val,
> >  				       offset, bytes);
> > -	if (unlikely(ret < 0))
> > +	if (unlikely(ret < 0)) {
> > +		vcpu->run->mmio.phys_addr = gpa;
> > +		vcpu->run->mmio.len = 0;
> > +		vcpu->run->mmio.is_write = 0;
> > +		vcpu->run->exit_reason = KVM_EXIT_MMIO;
> >  		return X86EMUL_IO_NEEDED;
> > +	}
> >  
> >  	return X86EMUL_CONTINUE;
> >  }
> > @@ -8665,6 +8670,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  		r = x86_decode_emulated_instruction(vcpu, emulation_type,
> >  						    insn, insn_len);
> >  		if (r != EMULATION_OK)  {
> > +			if (r == EMULATION_IO_FETCH)
> > +				return 0;
> >  			if ((emulation_type & EMULTYPE_TRAP_UD) ||
> >  			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
> >  				kvm_queue_exception(vcpu, UD_VECTOR);
> > 
> > base-commit: 39d9b48cc777bdf6d67d01ed24f1f89b13f5fbb2
> > 

Note that AFAIK, there is another case (and probably more), if TDP is disabled,
and MMU root is in mmio, we kill the guest.


mmu_alloc_shadow_roots -> mmu_check_root


I used to have few hacks in KVM to cope with this, but AFAIK,
I gave up on it, because the issue would show up again and again.

Best regards,
	Maxim Levitsky


