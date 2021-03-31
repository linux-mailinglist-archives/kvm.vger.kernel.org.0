Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4AE34F5EB
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 03:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhCaBLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 21:11:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:64188 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233291AbhCaBKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 21:10:40 -0400
IronPort-SDR: Lqp5T6GQbF2PSUzxALBf45gb6V2bX4WkgDYHS3a6AbbPjJNTxVo7QPz7DlZfIhk8TIgAzChDUx
 GGi/0KX9zdsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="188629376"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="188629376"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 18:10:39 -0700
IronPort-SDR: FOQAzg6DPIMvG9IhpJ+6slfBE/vnf0omu5LI+4YvHEt7AGxhDI7n8aABrT12l5lB2q/c2CVZfw
 jdZLQLNKNvZA==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="411890393"
Received: from mwamucix-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.24.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 18:10:35 -0700
Date:   Wed, 31 Mar 2021 14:10:32 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
In-Reply-To: <20210326150320.GF25229@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210326150320.GF25229@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 16:03:55 +0100 Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:22:21PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a misc device /dev/sgx_vepc to allow userspace to allocate "raw" EPC
> > without an associated enclave.  The intended and only known use case for
> > raw EPC allocation is to expose EPC to a KVM guest, hence the 'vepc'
> > moniker, virt.{c,h} files and X86_SGX_KVM Kconfig.
> > 
> > SGX driver uses misc device /dev/sgx_enclave to support userspace to
> > create enclave.  Each file descriptor from opening /dev/sgx_enclave
> > represents an enclave.  Unlike SGX driver, KVM doesn't control how guest
> > uses EPC, therefore EPC allocated to KVM guest is not associated to an
> > enclave, and /dev/sgx_enclave is not suitable for allocating EPC for KVM
> > guest.
> > 
> > Having separate device nodes for SGX driver and KVM virtual EPC also
> > allows separate permission control for running host SGX enclaves and
> > KVM SGX guests.
> 
> Hmm, just a question on the big picture here - that might've popped up
> already:
> 
> So baremetal uses /dev/sgx_enclave and KVM uses /dev/sgx_vepc. Who's
> deciding which of the two has priority?

Hi Boris,

Sorry the late response (I saw Dave was replying. Thanks Dave :)).

Ultimately the admin, or the user decides, or the two don't have priority, from
EPC page allocation's perspective. SGX driver's EPC page reclaiming won't be
able to reclaim pages that have been allocated to KVM guests, and virtual EPC
fault handler won't try to reclaim page that has been allocated to host enclaves
either, when it tries to allocate EPC page.

For instance, in case of cloud, where KVM SGX is the main usage, SGX driver in
host either won't be used, or very minimal, specific and well-defined workloads
will be deployed in host (for instance, Quoting enclave and architecture
enclaves that are used for attestation). The admin will be aware of such EPC
allocation disjoint situation, and deploy host enclaves/KVM SGX guests
accordingly.

> 
> Let's say all guests start using enclaves and baremetal cannot start any
> new ones anymore due to no more memory. Are we ok with that?
> 
> What if baremetal creates a big fat enclave and starves guests all of a
> sudden. Are we ok with that either?

Yes to both above questions.

> 
> In general, having two disjoint things give out SGX resources separately
> sounds like trouble to me.
> 
> IOW, why don't all virt allocations go through /dev/sgx_enclave too, so
> that you can have a single place to control all resource allocations?

Overall, there are two reasons (also mentioned in the commit msg of this patch):

1) /dev/sgx_enclave, by its name, implies EPC pages allocated to it are
associated to an host enclave, so it is not suitable for virtual EPC, since EPC
allocated to KVM guest won't have an enclave associated. It's possible to
modify SGX driver (such as deferring 'struct sgx_encl' allocation from open to
CREATE_ENCLAVE ioctl, modifying majority code flows to cover both cases, etc),
but even with that, we'd still better to change /dev/sgx_enclave
to, for instance, /dev/sgx_epc, so it doesn't imply the fd opened from it is
an host enclave, but some raw EPC. However this is userspace ABI change. 
2) Having separate /dev/sgx_enclave, and /dev/sgx_vepc, allows admin to have
different permission control, if required.

So based on above reasons, we agreed it's better to have two device nodes.

Please see previous discussion for RFC v4:
https://lore.kernel.org/linux-sgx/c50ffb557166132cf73d0e838d3a5c1f653b28b7.camel@intel.com/

> 
> > To use /dev/sgx_vepc to allocate a virtual EPC instance with particular
> > size, the userspace hypervisor opens /dev/sgx_vepc, and uses mmap()
> > with the intended size to get an address range of virtual EPC.  Then
> > it may use the address range to create one KVM memory slot as virtual
> > EPC for guest.
> > 
> > Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> > /dev/sgx_vepc rather than in KVM. Doing so has two major advantages:
> > 
> >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> >     just another memory backend for guests.
> > 
> >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> >     does not have to export any symbols, changes to reclaim flows don't
> >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> >     get aired out for the world to see,
> 
> Good one. :-)
> 
> > and so on and so forth.
> 
> > The virtual EPC pages allocated to guests are currently not reclaimable.
> > Reclaiming EPC page used by enclave requires a special reclaim mechanism
> > separate from normal page reclaim, and that mechanism is not supported
> > for virutal EPC pages.  Due to the complications of handling reclaim
> > conflicts between guest and host, reclaiming virtual EPC pages is
> > significantly more complex than basic support for SGX virtualization.
> 
> What happens if someone in the future wants to change that? Someone
> needs to write patches or there's a more fundamental stopper issue
> involved?

Sorry I am not following. Do you mean if someone wants to support "reclaiming
EPC page from KVM guests"? If so yes someone needs to write patches (we
internally have some, actually), but could you elaborate why there will be a
more fundamental stopper issue involved?


