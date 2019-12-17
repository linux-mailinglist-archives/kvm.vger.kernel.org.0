Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB641231F2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfLQQSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:18:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28410 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729069AbfLQQSt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 11:18:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576599526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vK5NDcBxim7yNbmFnJiOrQ1gwFPi/J/vE1JJF/ionzc=;
        b=HZbZ22750qr61IBA33Ps03ASUNsRAUZc72HiDowOpMNCfK9XmPYFDc4hcUgXys9Gra1aAX
        cdGzFs9WoJ/Cl6od1px0Z4H/6jgiew2KjNegR+VzxcQLJi5QyqEBKZKujbVYUZJPdENoj1
        REHyGUDYAG3VUvO91ib66JbBusBiHqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-AFz6fOSUM3alHFfb2t83Tg-1; Tue, 17 Dec 2019 11:18:42 -0500
X-MC-Unique: AFz6fOSUM3alHFfb2t83Tg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E8DF800D24;
        Tue, 17 Dec 2019 16:18:41 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83C2F68872;
        Tue, 17 Dec 2019 16:18:38 +0000 (UTC)
Date:   Tue, 17 Dec 2019 09:18:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory
 tracking
Message-ID: <20191217091837.744982d3@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D645E55@SHSMSX104.ccr.corp.intel.com>
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
        <20191215172124.GA83861@xz-x1>
        <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D645E55@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Dec 2019 02:28:33 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Paolo Bonzini
> > Sent: Monday, December 16, 2019 6:08 PM
> > 
> > [Alex and Kevin: there are doubts below regarding dirty page tracking
> > from VFIO and mdev devices, which perhaps you can help with]
> > 
> > On 15/12/19 18:21, Peter Xu wrote:  
> > >                 init_rmode_tss
> > >                     vmx_set_tss_addr
> > >                         kvm_vm_ioctl_set_tss_addr [*]
> > >                 init_rmode_identity_map
> > >                     vmx_create_vcpu [*]  
> > 
> > These don't matter because their content is not visible to userspace
> > (the backing storage is mmap-ed by __x86_set_memory_region).  In fact, d
> >   
> > >                 vmx_write_pml_buffer
> > >                     kvm_arch_write_log_dirty [&]
> > >                 kvm_write_guest
> > >                     kvm_hv_setup_tsc_page
> > >                         kvm_guest_time_update [&]
> > >                     nested_flush_cached_shadow_vmcs12 [&]
> > >                     kvm_write_wall_clock [&]
> > >                     kvm_pv_clock_pairing [&]
> > >                     kvmgt_rw_gpa [?]  
> > 
> > This then expands (partially) to
> > 
> > intel_gvt_hypervisor_write_gpa
> >     emulate_csb_update
> >         emulate_execlist_ctx_schedule_out
> >             complete_execlist_workload
> >                 complete_current_workload
> >                      workload_thread
> >         emulate_execlist_ctx_schedule_in
> >             prepare_execlist_workload
> >                 prepare_workload
> >                     dispatch_workload
> >                         workload_thread
> > 
> > So KVMGT is always writing to GPAs instead of IOVAs and basically
> > bypassing a guest IOMMU.  So here it would be better if kvmgt was
> > changed not use kvm_write_guest (also because I'd probably have nacked
> > that if I had known :)).  
> 
> I agree. 
> 
> > 
> > As far as I know, there is some work on live migration with both VFIO
> > and mdev, and that probably includes some dirty page tracking API.
> > kvmgt could switch to that API, or there could be VFIO APIs similar to
> > kvm_write_guest but taking IOVAs instead of GPAs.  Advantage: this would
> > fix the GPA/IOVA confusion.  Disadvantage: userspace would lose the
> > tracking of writes from mdev devices.  Kevin, are these writes used in
> > any way?  Do the calls to intel_gvt_hypervisor_write_gpa covers all
> > writes from kvmgt vGPUs, or can the hardware write to memory as well
> > (which would be my guess if I didn't know anything about kvmgt, which I
> > pretty much don't)?  
> 
> intel_gvt_hypervisor_write_gpa covers all writes due to software mediation.
> 
> for hardware updates, it needs be mapped in IOMMU through vfio_pin_pages 
> before any DMA happens. The ongoing dirty tracking effort in VFIO will take
> every pinned page through that API as dirtied.
> 
> However, currently VFIO doesn't implement any vfio_read/write_guest
> interface yet. and it doesn't make sense to use vfio_pin_pages for software
> dirtied pages, as pin is unnecessary and heavy involving iommu invalidation.
> 
> Alex, if you are OK we'll work on such interface and move kvmgt to use it.
> After it's accepted, we can also mark pages dirty through this new interface
> in Kirti's dirty page tracking series.

I'm not sure what you're asking for, is it an interface for the host
CPU to read/write the memory backing of a mapped IOVA range without
pinning pages?  That seems like something like that would make sense for
an emulation model where a page does not need to be pinned for physical
DMA.  If you're asking more for an interface that understands the
userspace driver is a VM (ie. implied using a _guest postfix on the
function name) and knows about GPA mappings beyond the windows directly
mapped for device access, I'd not look fondly on such a request.
Thanks,

Alex

