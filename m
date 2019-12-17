Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3220123253
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfLQQYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:24:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728299AbfLQQYZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 11:24:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576599863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UaYxxpQ+7yMxn9ORHCOWMBFO7RIyafsf5c6/e+ioEqg=;
        b=Kylvoz584eWl5Snvi1sZa5103QMnWg01475hZ2MX58rJvRx40HNm+f04EcSkxz7dJ8bjRl
        EZVk78X0kClq4OkMUu7cZU4H/2gRadDXCw/kMhD9iuuVROhL6Tu9y9DKr2P3P+gSzJIfia
        ttlTPgvyP6DMZvzlDlXBmBoSRuHE9yE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-Iv3ZR-nEMGWfuzbhq_B8Eg-1; Tue, 17 Dec 2019 11:24:22 -0500
X-MC-Unique: Iv3ZR-nEMGWfuzbhq_B8Eg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43E00800EBF;
        Tue, 17 Dec 2019 16:24:21 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B144620CC;
        Tue, 17 Dec 2019 16:24:18 +0000 (UTC)
Date:   Tue, 17 Dec 2019 09:24:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory
 tracking
Message-ID: <20191217092417.1c4f4586@x1.home>
In-Reply-To: <20191217052502.GF21868@joy-OptiPlex-7040>
References: <20191203184600.GB19877@linux.intel.com>
        <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
        <20191209215400.GA3352@xz-x1>
        <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
        <20191210155259.GD3352@xz-x1>
        <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
        <20191215172124.GA83861@xz-x1>
        <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D645E5F@SHSMSX104.ccr.corp.intel.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D646148@SHSMSX104.ccr.corp.intel.com>
        <20191217052502.GF21868@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Dec 2019 00:25:02 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Tue, Dec 17, 2019 at 01:17:29PM +0800, Tian, Kevin wrote:
> > > From: Tian, Kevin
> > > Sent: Tuesday, December 17, 2019 10:29 AM
> > >   
> > > > From: Paolo Bonzini
> > > > Sent: Monday, December 16, 2019 6:08 PM
> > > >
> > > > [Alex and Kevin: there are doubts below regarding dirty page tracking
> > > > from VFIO and mdev devices, which perhaps you can help with]
> > > >
> > > > On 15/12/19 18:21, Peter Xu wrote:  
> > > > >                 init_rmode_tss
> > > > >                     vmx_set_tss_addr
> > > > >                         kvm_vm_ioctl_set_tss_addr [*]
> > > > >                 init_rmode_identity_map
> > > > >                     vmx_create_vcpu [*]  
> > > >
> > > > These don't matter because their content is not visible to userspace
> > > > (the backing storage is mmap-ed by __x86_set_memory_region).  In fact, d
> > > >  
> > > > >                 vmx_write_pml_buffer
> > > > >                     kvm_arch_write_log_dirty [&]
> > > > >                 kvm_write_guest
> > > > >                     kvm_hv_setup_tsc_page
> > > > >                         kvm_guest_time_update [&]
> > > > >                     nested_flush_cached_shadow_vmcs12 [&]
> > > > >                     kvm_write_wall_clock [&]
> > > > >                     kvm_pv_clock_pairing [&]
> > > > >                     kvmgt_rw_gpa [?]  
> > > >
> > > > This then expands (partially) to
> > > >
> > > > intel_gvt_hypervisor_write_gpa
> > > >     emulate_csb_update
> > > >         emulate_execlist_ctx_schedule_out
> > > >             complete_execlist_workload
> > > >                 complete_current_workload
> > > >                      workload_thread
> > > >         emulate_execlist_ctx_schedule_in
> > > >             prepare_execlist_workload
> > > >                 prepare_workload
> > > >                     dispatch_workload
> > > >                         workload_thread
> > > >
> > > > So KVMGT is always writing to GPAs instead of IOVAs and basically
> > > > bypassing a guest IOMMU.  So here it would be better if kvmgt was
> > > > changed not use kvm_write_guest (also because I'd probably have nacked
> > > > that if I had known :)).  
> > > 
> > > I agree.
> > >   
> > > >
> > > > As far as I know, there is some work on live migration with both VFIO
> > > > and mdev, and that probably includes some dirty page tracking API.
> > > > kvmgt could switch to that API, or there could be VFIO APIs similar to
> > > > kvm_write_guest but taking IOVAs instead of GPAs.  Advantage: this would
> > > > fix the GPA/IOVA confusion.  Disadvantage: userspace would lose the
> > > > tracking of writes from mdev devices.  Kevin, are these writes used in
> > > > any way?  Do the calls to intel_gvt_hypervisor_write_gpa covers all
> > > > writes from kvmgt vGPUs, or can the hardware write to memory as well
> > > > (which would be my guess if I didn't know anything about kvmgt, which I
> > > > pretty much don't)?  
> > > 
> > > intel_gvt_hypervisor_write_gpa covers all writes due to software mediation.
> > > 
> > > for hardware updates, it needs be mapped in IOMMU through
> > > vfio_pin_pages
> > > before any DMA happens. The ongoing dirty tracking effort in VFIO will take
> > > every pinned page through that API as dirtied.
> > > 
> > > However, currently VFIO doesn't implement any vfio_read/write_guest
> > > interface yet. and it doesn't make sense to use vfio_pin_pages for software
> > > dirtied pages, as pin is unnecessary and heavy involving iommu invalidation.  
> > 
> > One correction. vfio_pin_pages doesn't involve iommu invalidation. I should
> > just mean that pinning the page is not necessary. We just need a kvm-like
> > interface based on hva to access.
> >  
> And can we propose to differentiate read and write when calling vfio_pin_pages, e.g.
> vfio_pin_pages_read, vfio_pin_pages_write? Otherwise, calling to
> vfio_pin_pages will unnecessarily cause read pages to be dirty and
> sometimes reading guest pages is a way for device model to track dirty
> pages.

Yes, I've discussed this with Kirti, when devices add more fine grained
dirty tracking we'll probably need to extend the mdev pinned pages
interface to allow vendor drivers to indicate a pinning is intended to
be used as read-only and perhaps also a way to unpin a page that was
pinned as read-write as clean, if the device did not write to it.  So
perhaps vfio_pin_pages_for_read() and vfio_unpin_pages_clean().  Thanks,

Alex

