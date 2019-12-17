Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AA21223D6
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 06:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfLQFdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 00:33:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:46641 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfLQFdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 00:33:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 21:33:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,324,1571727600"; 
   d="scan'208";a="297938879"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga001.jf.intel.com with ESMTP; 16 Dec 2019 21:33:15 -0800
Date:   Tue, 17 Dec 2019 00:25:02 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     'Paolo Bonzini' <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191217052502.GF21868@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D646148@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 01:17:29PM +0800, Tian, Kevin wrote:
> > From: Tian, Kevin
> > Sent: Tuesday, December 17, 2019 10:29 AM
> > 
> > > From: Paolo Bonzini
> > > Sent: Monday, December 16, 2019 6:08 PM
> > >
> > > [Alex and Kevin: there are doubts below regarding dirty page tracking
> > > from VFIO and mdev devices, which perhaps you can help with]
> > >
> > > On 15/12/19 18:21, Peter Xu wrote:
> > > >                 init_rmode_tss
> > > >                     vmx_set_tss_addr
> > > >                         kvm_vm_ioctl_set_tss_addr [*]
> > > >                 init_rmode_identity_map
> > > >                     vmx_create_vcpu [*]
> > >
> > > These don't matter because their content is not visible to userspace
> > > (the backing storage is mmap-ed by __x86_set_memory_region).  In fact, d
> > >
> > > >                 vmx_write_pml_buffer
> > > >                     kvm_arch_write_log_dirty [&]
> > > >                 kvm_write_guest
> > > >                     kvm_hv_setup_tsc_page
> > > >                         kvm_guest_time_update [&]
> > > >                     nested_flush_cached_shadow_vmcs12 [&]
> > > >                     kvm_write_wall_clock [&]
> > > >                     kvm_pv_clock_pairing [&]
> > > >                     kvmgt_rw_gpa [?]
> > >
> > > This then expands (partially) to
> > >
> > > intel_gvt_hypervisor_write_gpa
> > >     emulate_csb_update
> > >         emulate_execlist_ctx_schedule_out
> > >             complete_execlist_workload
> > >                 complete_current_workload
> > >                      workload_thread
> > >         emulate_execlist_ctx_schedule_in
> > >             prepare_execlist_workload
> > >                 prepare_workload
> > >                     dispatch_workload
> > >                         workload_thread
> > >
> > > So KVMGT is always writing to GPAs instead of IOVAs and basically
> > > bypassing a guest IOMMU.  So here it would be better if kvmgt was
> > > changed not use kvm_write_guest (also because I'd probably have nacked
> > > that if I had known :)).
> > 
> > I agree.
> > 
> > >
> > > As far as I know, there is some work on live migration with both VFIO
> > > and mdev, and that probably includes some dirty page tracking API.
> > > kvmgt could switch to that API, or there could be VFIO APIs similar to
> > > kvm_write_guest but taking IOVAs instead of GPAs.  Advantage: this would
> > > fix the GPA/IOVA confusion.  Disadvantage: userspace would lose the
> > > tracking of writes from mdev devices.  Kevin, are these writes used in
> > > any way?  Do the calls to intel_gvt_hypervisor_write_gpa covers all
> > > writes from kvmgt vGPUs, or can the hardware write to memory as well
> > > (which would be my guess if I didn't know anything about kvmgt, which I
> > > pretty much don't)?
> > 
> > intel_gvt_hypervisor_write_gpa covers all writes due to software mediation.
> > 
> > for hardware updates, it needs be mapped in IOMMU through
> > vfio_pin_pages
> > before any DMA happens. The ongoing dirty tracking effort in VFIO will take
> > every pinned page through that API as dirtied.
> > 
> > However, currently VFIO doesn't implement any vfio_read/write_guest
> > interface yet. and it doesn't make sense to use vfio_pin_pages for software
> > dirtied pages, as pin is unnecessary and heavy involving iommu invalidation.
> 
> One correction. vfio_pin_pages doesn't involve iommu invalidation. I should
> just mean that pinning the page is not necessary. We just need a kvm-like
> interface based on hva to access.
>
And can we propose to differentiate read and write when calling vfio_pin_pages, e.g.
vfio_pin_pages_read, vfio_pin_pages_write? Otherwise, calling to
vfio_pin_pages will unnecessarily cause read pages to be dirty and
sometimes reading guest pages is a way for device model to track dirty
pages.

> > 
> > Alex, if you are OK we'll work on such interface and move kvmgt to use it.
> > After it's accepted, we can also mark pages dirty through this new interface
> > in Kirti's dirty page tracking series.
> > 
