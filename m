Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38DE611F9A2
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2019 18:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfLORVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 12:21:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726207AbfLORVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Dec 2019 12:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576430492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ADBtJPMiOqroMyMBBwifechFlOzJVQXPXEIkpj00sng=;
        b=YyKoRvNGo8J1bvtyFPZypSv2m8bvPmFo+2zTo/gTPRgN2FxUt0i2phAa+RSgG+VbbZhrZJ
        DUM+rn1moKsmTAfwdw7I7FERD6oPtoUKBP5e5Ap5a5xw423zcNVQ+tidMNSXLs13hsCWND
        skEMFqHINYvfNDLIVCqghr2XIUK7Z14=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-jAM30qLWN7asCamFYLObQQ-1; Sun, 15 Dec 2019 12:21:28 -0500
X-MC-Unique: jAM30qLWN7asCamFYLObQQ-1
Received: by mail-qk1-f200.google.com with SMTP id m13so3062180qka.9
        for <kvm@vger.kernel.org>; Sun, 15 Dec 2019 09:21:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ADBtJPMiOqroMyMBBwifechFlOzJVQXPXEIkpj00sng=;
        b=FC2arbS3kMPWjSliAHwF5DEbyS7XX7yxYLqeyP40uiOT0f3dFg15ev0/yrFmO0nQzL
         Vxiw06MkOTe9imcbx3fDBYf69D9TyT/RvUfSJMzv29K1dXz1DplqJSvTXTyXeixsyGxW
         4yNDsUPQtuYSSJNVbMn4NRgSjAzzMuDhxi38K3xzETjSVd8EssxMR/R6lk7vvrRUTzWx
         SezAtaKonSeCUbJ5O1sY/wgs2p9laRVsg5emY7KKZ1HgaEbC2F1DgxVsZR6gt+jinC3W
         o9FVoEZXbDvJxem+7IBfzm61YwBOmvmCU6nGQarOj0uGk6x0krLyQMYMqEGcEAvfP1Zi
         dhxg==
X-Gm-Message-State: APjAAAUeUXNnM0gxTpFwE9MYjvoMVttaYEnqcUvKW2yjFI+kdf+LzI/Z
        dLRv7VMWZ9xp48qCiyDZv9jxx0rIq+neanlWt3oLRGpvvpAnUdFGw2pCWiCWUiHjwCbXgOhfDPX
        0YAqbIX4yF3iS
X-Received: by 2002:a37:9807:: with SMTP id a7mr23404938qke.213.1576430488296;
        Sun, 15 Dec 2019 09:21:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAoCdS8FnRIEzT0hJRh8zcgHR/NRA7BSO3cylgFHiFStVv1aVyM+Hl7l32HAXtz86pLxtWuQ==
X-Received: by 2002:a37:9807:: with SMTP id a7mr23404919qke.213.1576430487861;
        Sun, 15 Dec 2019 09:21:27 -0800 (PST)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e19sm4902428qtc.75.2019.12.15.09.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 09:21:26 -0800 (PST)
Date:   Sun, 15 Dec 2019 12:21:24 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191215172124.GA83861@xz-x1>
References: <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1>
 <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 06:09:02PM +0100, Paolo Bonzini wrote:
> On 10/12/19 16:52, Peter Xu wrote:
> > On Tue, Dec 10, 2019 at 11:07:31AM +0100, Paolo Bonzini wrote:
> >>> I'm thinking whether I can start
> >>> to use this information in the next post on solving an issue I
> >>> encountered with the waitqueue.
> >>>
> >>> Current waitqueue is still problematic in that it could wait even with
> >>> the mmu lock held when with vcpu context.
> >>
> >> I think the idea of the soft limit is that the waiting just cannot
> >> happen.  That is, the number of dirtied pages _outside_ the guest (guest
> >> accesses are taken care of by PML, and are subtracted from the soft
> >> limit) cannot exceed hard_limit - (soft_limit + pml_size).
> > 
> > So the question go backs to, whether this is guaranteed somehow?  Or
> > do you prefer us to keep the warn_on_once until it triggers then we
> > can analyze (which I doubt..)?
> 
> Yes, I would like to keep the WARN_ON_ONCE just because you never know.
> 
> Of course it would be much better to audit the calls to kvm_write_guest
> and figure out how many could trigger (e.g. two from the operands of an
> emulated instruction, 5 from a nested EPT walk, 1 from a page walk, etc.).

I would say we'd better either figure out all the caller's sites to
prove it will never overflow, or, I think we'll need the waitqueue at
least.  The problem is if we release a kvm with WARN_ON_ONCE and at
last we found that it can be triggered and ring full can't be avoided,
then it means the interface and design is broken, and it could even be
too late to fix it after the interface is published.

(Actually I was not certain on previous clear_dirty interface where we
 introduced a new capability for it.  I'm not sure whether that can be
 avoided because after all the initial version is not working at all,
 and we fixed it up without changing the interface.  However for this
 one if at last we prove the design wrong, then we must introduce
 another capability for it IMHO, and the interface is prone to change
 too)

So, with the hope that we could avoid the waitqueue, I checked all the
callers of mark_page_dirty_in_slot().  Since this initial work is only
for x86, I didn't look more into other archs, assuming that can be
done later when it is implemented for other archs (and this will for
sure also cover the common code):

    mark_page_dirty_in_slot calls, per-vm (x86 only)
        __kvm_write_guest_page
            kvm_write_guest_page
                init_rmode_tss
                    vmx_set_tss_addr
                        kvm_vm_ioctl_set_tss_addr [*]
                init_rmode_identity_map
                    vmx_create_vcpu [*]
                vmx_write_pml_buffer
                    kvm_arch_write_log_dirty [&]
                kvm_write_guest
                    kvm_hv_setup_tsc_page
                        kvm_guest_time_update [&]
                    nested_flush_cached_shadow_vmcs12 [&]
                    kvm_write_wall_clock [&]
                    kvm_pv_clock_pairing [&]
                    kvmgt_rw_gpa [?]
                    kvm_write_guest_offset_cached
                        kvm_steal_time_set_preempted [&]
                        kvm_write_guest_cached
                            pv_eoi_put_user [&]
                            kvm_lapic_sync_to_vapic [&]
                            kvm_setup_pvclock_page [&]
                            record_steal_time [&]
                            apf_put_user [&]
                kvm_clear_guest_page
                    init_rmode_tss [*] (see above)
                    init_rmode_identity_map [*] (see above)
                    kvm_clear_guest
                        synic_set_msr
                            kvm_hv_set_msr [&]
        kvm_write_guest_offset_cached [&] (see above)
        mark_page_dirty
            kvm_hv_set_msr_pw [&]

We should only need to look at the leaves of the traces because
they're where the dirty request starts.  I'm marking all the leaves
with below criteria then it'll be easier to focus:

Cases with [*]: should not matter much
           [&]: actually with a per-vcpu context in the upper layer
           [?]: uncertain...

I'm a bit amazed after I took these notes, since I found that besides
those that could probbaly be ignored (marked as [*]), most of the rest
per-vm dirty requests are actually with a vcpu context.

Although now because we have kvm_get_running_vcpu() all cases for [&]
should be fine without changing anything, but I tend to add another
patch in the next post to convert all the [&] cases explicitly to pass
vcpu pointer instead of kvm pointer to be clear if no one disagrees,
then we verify that against kvm_get_running_vcpu().

So the only uncertainty now is kvmgt_rw_gpa() which is marked as [?].
Could this happen frequently?  I would guess the answer is we don't
know (which means it can).

> 
> > One thing to mention is that for with-vcpu cases, we probably can even
> > stop KVM_RUN immediately as long as either the per-vm or per-vcpu ring
> > reaches the softlimit, then for vcpu case it should be easier to
> > guarantee that.  What I want to know is the rest of cases like ioctls
> > or even something not from the userspace (which I think I should read
> > more later..).
> 
> Which ioctls?  Most ioctls shouldn't dirty memory at all.

init_rmode_tss or init_rmode_identity_map.  But I've marked them as
unimportant because they should only happen once at boot.

> 
> >>> And if we see if the mark_page_dirty_in_slot() is not with a vcpu
> >>> context (e.g. kvm_mmu_page_fault) but with an ioctl context (those
> >>> cases we'll use per-vm dirty ring) then it's probably fine.
> >>>
> >>> My planned solution:
> >>>
> >>> - When kvm_get_running_vcpu() != NULL, we postpone the waitqueue waits
> >>>   until we finished handling this page fault, probably in somewhere
> >>>   around vcpu_enter_guest, so that we can do wait_event() after the
> >>>   mmu lock released
> >>
> >> I think this can cause a race:
> >>
> >> 	vCPU 1			vCPU 2		host
> >> 	---------------------------------------------------------------
> >> 	mark page dirty
> >> 				write to page
> >> 						treat page as not dirty
> >> 	add page to ring
> >>
> >> where vCPU 2 skips the clean-page slow path entirely.
> > 
> > If we're still with the rule in userspace that we first do RESET then
> > collect and send the pages (just like what we've discussed before),
> > then IMHO it's fine to have vcpu2 to skip the slow path?  Because
> > RESET happens at "treat page as not dirty", then if we are sure that
> > we only collect and send pages after that point, then the latest
> > "write to page" data from vcpu2 won't be lost even if vcpu2 is not
> > blocked by vcpu1's ring full?
> 
> Good point, the race would become
> 
>  	vCPU 1			vCPU 2		host
>  	---------------------------------------------------------------
>  	mark page dirty
>  				write to page
> 						reset rings
> 						  wait for mmu lock
>  	add page to ring
> 	release mmu lock
> 						  ...do reset...
> 						  release mmu lock
> 						page is now dirty

Hmm, the page will be dirty after the reset, but is that an issue?

Or, could you help me to identify what I've missed?

> 
> > Maybe we can also consider to let mark_page_dirty_in_slot() return a
> > value, then the upper layer could have a chance to skip the spte
> > update if mark_page_dirty_in_slot() fails to mark the dirty bit, so it
> > can return directly with RET_PF_RETRY.
> 
> I don't think that's possible, most writes won't come from a page fault
> path and cannot retry.

Yep, maybe I should say it in the other way round: we only wait if
kvm_get_running_vcpu() == NULL.  Then in somewhere near
vcpu_enter_guest(), we add a check to wait if per-vcpu ring is full.
Would that work?

Thanks,

-- 
Peter Xu

