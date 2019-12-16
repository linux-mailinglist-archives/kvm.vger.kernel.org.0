Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4571201FE
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 11:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLPKIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 05:08:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45165 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727114AbfLPKIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 05:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576490900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09JiSv25cdJaJ4KBuEFbebJuRN+Qs0ExALLgw9H0+YM=;
        b=gLSGVXNVTlE/f9aq9j2GLoTYVkhS5oucCTPDOaQKvFhnhxyrj57teLqE4uC6VTZkc+snRS
        Fots+TQnKdrfMwkvaHSxFRb0HWmS/msZvKsXwnqpP4m1dZ/ImnKGj84IlJWK/9YL31jwPf
        Ielzg2/JIcZi5LBkeADAr3tr0LUGi20=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-FVT0FLX6PoifWLwzBa_7hw-1; Mon, 16 Dec 2019 05:08:19 -0500
X-MC-Unique: FVT0FLX6PoifWLwzBa_7hw-1
Received: by mail-wm1-f70.google.com with SMTP id l13so859788wmj.8
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 02:08:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09JiSv25cdJaJ4KBuEFbebJuRN+Qs0ExALLgw9H0+YM=;
        b=PcoxO1CijFsHCAXB5GGv/6Vx0OlkkyoHBu/lj9qHDlaFJNadyEyvYiL1SvzrzZOmtG
         K3Qjj2yByxXxAeVTyFhJDdlDzss8TiJHNx9FU082Nq7G1ZlcQj7RgUmBV5bv98up5kAu
         be7CdNcJTPx/0MetENoQqdpuuw+NL53WXnr/Sw8fb2NJpxO4RaOnQGytPHcIoL53gR2e
         5k0RzduWx6+XZucnU9rrw303oLHlX1uveqwQWa6Fucw79/xbM7F7d8j4tZEnwuXVk+yr
         OJ2AMtU0Xl8pnuyfEGrS+zimCPt3hl199SDL2Klfil2GW2nukH6slUAjHXNGqZCmus4j
         h6mg==
X-Gm-Message-State: APjAAAXmcFpgOcnHVy8USS6dygURsFBXne0oLpIeBxgd+3L2kJ9iihLZ
        09aDLVs2ZD+mdlatsLge1i55pQWqnRJnqb5rI+rUynSXrjjHvsXZShDOJiIOt0FiLPikez4igKI
        +pKugzGff44+z
X-Received: by 2002:a7b:c216:: with SMTP id x22mr28107090wmi.51.1576490898312;
        Mon, 16 Dec 2019 02:08:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSe+0hde9uu9y/6Xw0eqWx6m1WenCodQYxucyi2EicOiyc0vMVkWi/pULhbKmEDqNwkYYwsw==
X-Received: by 2002:a7b:c216:: with SMTP id x22mr28107055wmi.51.1576490897952;
        Mon, 16 Dec 2019 02:08:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id q6sm22169932wrx.72.2019.12.16.02.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 02:08:17 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1> <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
Date:   Mon, 16 Dec 2019 11:08:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191215172124.GA83861@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Alex and Kevin: there are doubts below regarding dirty page tracking
from VFIO and mdev devices, which perhaps you can help with]

On 15/12/19 18:21, Peter Xu wrote:
>                 init_rmode_tss
>                     vmx_set_tss_addr
>                         kvm_vm_ioctl_set_tss_addr [*]
>                 init_rmode_identity_map
>                     vmx_create_vcpu [*]

These don't matter because their content is not visible to userspace
(the backing storage is mmap-ed by __x86_set_memory_region).  In fact, d

>                 vmx_write_pml_buffer
>                     kvm_arch_write_log_dirty [&]
>                 kvm_write_guest
>                     kvm_hv_setup_tsc_page
>                         kvm_guest_time_update [&]
>                     nested_flush_cached_shadow_vmcs12 [&]
>                     kvm_write_wall_clock [&]
>                     kvm_pv_clock_pairing [&]
>                     kvmgt_rw_gpa [?]

This then expands (partially) to

intel_gvt_hypervisor_write_gpa
    emulate_csb_update
        emulate_execlist_ctx_schedule_out
            complete_execlist_workload
                complete_current_workload
                     workload_thread
        emulate_execlist_ctx_schedule_in
            prepare_execlist_workload
                prepare_workload
                    dispatch_workload
                        workload_thread

So KVMGT is always writing to GPAs instead of IOVAs and basically
bypassing a guest IOMMU.  So here it would be better if kvmgt was
changed not use kvm_write_guest (also because I'd probably have nacked
that if I had known :)).

As far as I know, there is some work on live migration with both VFIO
and mdev, and that probably includes some dirty page tracking API.
kvmgt could switch to that API, or there could be VFIO APIs similar to
kvm_write_guest but taking IOVAs instead of GPAs.  Advantage: this would
fix the GPA/IOVA confusion.  Disadvantage: userspace would lose the
tracking of writes from mdev devices.  Kevin, are these writes used in
any way?  Do the calls to intel_gvt_hypervisor_write_gpa covers all
writes from kvmgt vGPUs, or can the hardware write to memory as well
(which would be my guess if I didn't know anything about kvmgt, which I
pretty much don't)?

> We should only need to look at the leaves of the traces because
> they're where the dirty request starts.  I'm marking all the leaves
> with below criteria then it'll be easier to focus:
> 
> Cases with [*]: should not matter much
>            [&]: actually with a per-vcpu context in the upper layer
>            [?]: uncertain...
> 
> I'm a bit amazed after I took these notes, since I found that besides
> those that could probbaly be ignored (marked as [*]), most of the rest
> per-vm dirty requests are actually with a vcpu context.
> 
> Although now because we have kvm_get_running_vcpu() all cases for [&]
> should be fine without changing anything, but I tend to add another
> patch in the next post to convert all the [&] cases explicitly to pass
> vcpu pointer instead of kvm pointer to be clear if no one disagrees,
> then we verify that against kvm_get_running_vcpu().

This is a good idea but remember not to convert those to
kvm_vcpu_write_guest, because you _don't_ want these writes to touch
SMRAM (most of the addresses are OS-controlled rather than
firmware-controlled).

> init_rmode_tss or init_rmode_identity_map.  But I've marked them as
> unimportant because they should only happen once at boot.

We need to check if userspace can add an arbitrary number of entries by
calling KVM_SET_TSS_ADDR repeatedly.  I think it can; we'd have to
forbid multiple calls to KVM_SET_TSS_ADDR which is not a problem in general.

>>> If we're still with the rule in userspace that we first do RESET then
>>> collect and send the pages (just like what we've discussed before),
>>> then IMHO it's fine to have vcpu2 to skip the slow path?  Because
>>> RESET happens at "treat page as not dirty", then if we are sure that
>>> we only collect and send pages after that point, then the latest
>>> "write to page" data from vcpu2 won't be lost even if vcpu2 is not
>>> blocked by vcpu1's ring full?
>>
>> Good point, the race would become
>>
>>  	vCPU 1			vCPU 2		host
>>  	---------------------------------------------------------------
>>  	mark page dirty
>>  				write to page
>> 						reset rings
>> 						  wait for mmu lock
>>  	add page to ring
>> 	release mmu lock
>> 						  ...do reset...
>> 						  release mmu lock
>> 						page is now dirty
> 
> Hmm, the page will be dirty after the reset, but is that an issue?
> 
> Or, could you help me to identify what I've missed?

Nothing: the race is always solved in such a way that there's no issue.

>> I don't think that's possible, most writes won't come from a page fault
>> path and cannot retry.
> 
> Yep, maybe I should say it in the other way round: we only wait if
> kvm_get_running_vcpu() == NULL.  Then in somewhere near
> vcpu_enter_guest(), we add a check to wait if per-vcpu ring is full.
> Would that work?

Yes, that should work, especially if we know that kvmgt is the only case
that can wait.  And since:

1) kvmgt doesn't really need dirty page tracking (because VFIO devices
generally don't track dirty pages, and because kvmgt shouldn't be using
kvm_write_guest anyway)

2) the real mode TSS and identity map shouldn't even be tracked, as they
are invisible to userspace

it seems to me that kvm_get_running_vcpu() lets us get rid of the per-VM
ring altogether.

Paolo

