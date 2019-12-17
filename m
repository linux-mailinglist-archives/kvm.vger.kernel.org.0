Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA886123251
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfLQQYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:24:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728118AbfLQQYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576599849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBtizMbTglHAVgP9sAvfiVMx/37lk14Twc9yWt9Vr3U=;
        b=PmlKf/v6JnQNZPsNjYfev3O/7jbqRJIvgBeoZUNrQC2aa1zP27NKs1Zc/m0g25gACxLqlB
        b+TVB6ssC59qrH1TUbz3oB3iwR5QfTVvBvl1EXjC+mzTP3ycHDMCvzGln5o19NFvsOEmAL
        YLP9GKshxgcbml3a74SDdJynVpTvbGc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-MhrQv1luNFClXkYijGbwmQ-1; Tue, 17 Dec 2019 11:24:08 -0500
X-MC-Unique: MhrQv1luNFClXkYijGbwmQ-1
Received: by mail-qv1-f72.google.com with SMTP id n11so100131qvp.15
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 08:24:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sBtizMbTglHAVgP9sAvfiVMx/37lk14Twc9yWt9Vr3U=;
        b=BhCUlImg8Czjl0asSeLZU9Px6mE3IBvv2jwzm1NyJuFTjnzIysowOVp8BSeCA5G6aa
         3ZpRaZ1ucMs4LvhLlIW/J/olaxRVqhviUNmsZwdBK/dln80RD+CvJwtI8zQOmgKGipXh
         arPT79GpvyMTpucAc5WBEbi5lrweQiyRblmlCZtv7UEgRhCX11DI0Pd3CQlFmtB2YIeL
         dTiuo62F/rc7R9nvNmI9hRtLa+R9L8Okj4ezj/QobQxYtH+b4xBLHrOOoBr7CAIDVsZf
         BklyNSih4rfcF3EbtL4eo/hHBGb83CCSaFAQD16njN2Fv2gyqDVtXr96qFTybIIfNlnW
         GYxA==
X-Gm-Message-State: APjAAAU7d8oYzqOYf1wB0Dy5vE6MfVPxrmHx5tUe9PuFu7swIBQALBIF
        5+7q/Tn0WZ7Zmu3Pf3QYibg6R5Df48YGam7xYPLIvd14CP2o7tLJsj3+i/aUO/r5NjEvtRzR1Yg
        2Wf2Uujtdsqks
X-Received: by 2002:a37:a18b:: with SMTP id k133mr5955205qke.83.1576599847691;
        Tue, 17 Dec 2019 08:24:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAz74+chwPsWG0gYw0+NJ9gVdBbukEfTyvbr5tdg+B2YknGFiVYEg3aGaatgue+hYqx5FOKw==
X-Received: by 2002:a37:a18b:: with SMTP id k133mr5955164qke.83.1576599847290;
        Tue, 17 Dec 2019 08:24:07 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l184sm6933473qkc.107.2019.12.17.08.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 08:24:06 -0800 (PST)
Date:   Tue, 17 Dec 2019 11:24:05 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191217162405.GD7258@xz-x1>
References: <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <20191216185454.GG83861@xz-x1>
 <815923d9-2d48-2915-4acb-97eb90996403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <815923d9-2d48-2915-4acb-97eb90996403@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 10:01:40AM +0100, Paolo Bonzini wrote:
> On 16/12/19 19:54, Peter Xu wrote:
> > On Mon, Dec 16, 2019 at 11:08:15AM +0100, Paolo Bonzini wrote:
> >>> Although now because we have kvm_get_running_vcpu() all cases for [&]
> >>> should be fine without changing anything, but I tend to add another
> >>> patch in the next post to convert all the [&] cases explicitly to pass
> >>> vcpu pointer instead of kvm pointer to be clear if no one disagrees,
> >>> then we verify that against kvm_get_running_vcpu().
> >>
> >> This is a good idea but remember not to convert those to
> >> kvm_vcpu_write_guest, because you _don't_ want these writes to touch
> >> SMRAM (most of the addresses are OS-controlled rather than
> >> firmware-controlled).
> > 
> > OK.  I think I only need to pass in vcpu* instead of kvm* in
> > kvm_write_guest_page() just like kvm_vcpu_write_guest(), however we
> > still keep to only write to address space id==0 for that.
> 
> No, please pass it all the way down to the [&] functions but not to
> kvm_write_guest_page.  Those should keep using vcpu->kvm.

Actually I even wanted to refactor these helpers.  I mean, we have two
sets of helpers now, kvm_[vcpu]_{read|write}*(), so one set is per-vm,
the other set is per-vcpu.  IIUC the only difference of these two are
whether we should consider ((vcpu)->arch.hflags & HF_SMM_MASK) or we
just write to address space zero always.  Could we unify them into a
single set of helper (I'll just drop the *_vcpu_* helpers because it's
longer when write) but we always pass in vcpu* as the first parameter?
Then we add another parameter "vcpu_smm" to show whether we want to
consider the HF_SMM_MASK flag.

Kvmgt is of course special here because it does not have vcpu context,
but as we're going to rework that, I'd like to know whether you agree
with above refactoring if without the kvmgt caller.

> 
> >>> init_rmode_tss or init_rmode_identity_map.  But I've marked them as
> >>> unimportant because they should only happen once at boot.
> >>
> >> We need to check if userspace can add an arbitrary number of entries by
> >> calling KVM_SET_TSS_ADDR repeatedly.  I think it can; we'd have to
> >> forbid multiple calls to KVM_SET_TSS_ADDR which is not a problem in general.
> > 
> > Will do that altogether with the series.  I can further change both of
> > these calls to not track dirty at all, which shouldn't be hard, after
> > all userspace didn't even know them, as you mentioned below.
> > 
> > Is there anything to explain what KVM_SET_TSS_ADDR is used for?  This
> > is the thing I found that is closest to useful (from api.txt):
> 
> The best description is probably at https://lwn.net/Articles/658883/:
> 
> They are needed for unrestricted_guest=0. Remember that, in that case,
> the VM always runs in protected mode and with paging enabled. In order
> to emulate real mode you put the guest in a vm86 task, so you need some
> place for a TSS and for a page table, and they must be in guest RAM
> because the guest's TR and CR3 points to it. They are invisible to the
> guest, because the STR and MOV-from-CR instructions are invalid in vm86
> mode, but it must be there.
> 
> If you don't call KVM_SET_TSS_ADDR you actually get a complaint in
> dmesg, and the TR stays at 0. I am not really sure what kind of bad
> things can happen with unrestricted_guest=0, probably you just get a VM
> Entry failure. The TSS takes 3 pages of memory. An interesting point is
> that you actually don't need to set the TR selector to a valid value (as
> you would do when running in "normal" vm86 mode), you can simply set the
> base and limit registers that are hidden in the processor, and generally
> inaccessible except through VMREAD/VMWRITE or system management mode. So
> KVM needs to set up a TSS but not a GDT.
> 
> For paging, instead, 1 page is enough because we have only 4GB of memory
> to address. KVM disables CR4.PAE (page address extensions, aka 8-byte
> entries in each page directory or page table) and enables CR4.PSE (page
> size extensions, aka 4MB huge pages support with 4-byte page directory
> entries). One page then fits 1024 4-byte page directory entries, each
> for a 4MB huge pages, totaling exactly 4GB. Here if you don't set it the
> page table is at address 0xFFFBC000. QEMU changes it to 0xFEFFC000 so
> that the BIOS can be up to 16MB in size (the default only allows 256k
> between 0xFFFC0000 and 0xFFFFFFFF).
> 
> The different handling, where only the page table has a default, is
> unfortunate, but so goes life...
> 
> > So... has it really popped into existance somewhere?  It would be good
> > at least to know why it does not need to be migrated.
> 
> It does not need to be migrated just because the contents are constant.

OK, thanks!  IIUC they should likely be all zeros then.

Do you think it's time to add most of these to kvm/api.txt? :)  I can
do that too if you like.

-- 
Peter Xu

