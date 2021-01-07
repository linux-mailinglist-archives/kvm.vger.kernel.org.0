Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81B02EC75A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 01:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbhAGAfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 19:35:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:15258 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAGAf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 19:35:29 -0500
IronPort-SDR: HmyYLGnPQ87+K/KvCSeqxXTSUF2EGxsdVK2beDsnBgryEQF+G1Xx+Yk6PGXkES9MXP/xeDx69t
 ldy+uPynSSPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="173844969"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="173844969"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 16:34:49 -0800
IronPort-SDR: t42AKbWZJ8JJvkcgVGvC/DSfT9trU1Vs4XgYhGsbjrNQY7s/uilTGUndLt1et/u/EoPLN0tKuf
 FgiteuOrHsPw==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="398425941"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 16:34:44 -0800
Date:   Thu, 7 Jan 2021 13:34:41 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <jethro@fortanix.com>, <b.thiel@posteo.de>,
        <jmattson@google.com>, <joro@8bytes.org>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <corbet@lwn.net>
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-Id: <20210107133441.0983ca20f7909186b8ff8fa1@intel.com>
In-Reply-To: <1772bbf4-54bd-e43f-a71f-d72f9a6a9bad@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <1772bbf4-54bd-e43f-a71f-d72f9a6a9bad@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 09:07:13 -0800 Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > - Virtual EPC
> > 
> > "Virtual EPC" is the EPC section exposed by KVM to guest so SGX software in
> > guest can discover it and use it to create SGX enclaves. KVM exposes SGX to 
> > guest via CPUID, and exposes one or more "virtual EPC" sections for guest.
> > The size of "virtual EPC" is passed as Qemu parameter when creating the
> > guest, and the base address is calcualted internally according to guest's
> 
> 				^ calculated
> 
> > configuration.
> 
> This is not a great first paragraph to introduce me to this feature.
> 
> Please remind us what EPC *is*, then you can go and talk about why we
> have to virtualize it, and how "virtual EPC" is different from normal
> EPC.  For instance:
> 
> SGX enclave memory is special and is reserved specifically for enclave
> use.  In bare-metal SGX enclaves, the kernel allocates enclave pages,
> copies data into the pages with privileged instructions, then allows the
> enclave to start.  In this scenario, only initialized pages already
> assigned to an enclave are mapped to userspace.
> 
> In virtualized environments, the hypervisor still needs to do the
> physical enclave page allocation.  The guest kernel is responsible for
> the data copying (among other things).  This means that the job of
> starting an enclave is now split between hypervisor and guest.
> 
> This series introduces a new misc device: /dev/sgx_virt_epc.  This
> device allows the host to map *uninitialized* enclave memory into
> userspace, which can then be passed into a guest.
> 
> While it might be *possible* to start a host-side enclave with
> /dev/sgx_enclave and pass its memory into a guest, it would be wasteful
> and convoluted.

Thanks. I'll add this.

> 
> > core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> > "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX driver,
> > virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave associated,
> > and how virtual EPC is used by guest is compeletely controlled by guest's SGX
> 
> 					   ^ completely
> 
> Please run a spell checker on this thing.

Yeah will do. Thanks for good suggestion.

> 
> > software.
> > 
> > Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> > /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:
> > 
> >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> >     just another memory backend for guests.
> > 
> >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> >     does not have to export any symbols, changes to reclaim flows don't
> >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> >     get aired out for the world to see, and so on and so forth.
> > 
> > The virtual EPC allocated to guests is currently not reclaimable, due to
> > reclaiming EPC from KVM guests is not currently supported. Due to the
> > complications of handling reclaim conflicts between guest and host, KVM
> > EPC oversubscription, which allows total virtual EPC size greater than
> > physical EPC by being able to reclaiming guests' EPC, is significantly more
> > complex than basic support for SGX virtualization.
> 
> It would also help here to remind the reader that enclave pages have a
> special reclaim mechanism separtae from normal page reclaim, and that
> mechanism is disabled for these pages.

OK.

> 
> Does the *ABI* here preclude doing oversubscription in the future?

I am Sorry what *ABI* do you mean?

> 
> > - Support SGX virtualization without SGX Launch Control unlocked mode
> > 
> > Although SGX driver requires SGX Launch Control unlocked mode to work, SGX
> 
> Although the bare-metal SGX driver requires...

OK.

> 
> Also, didn't we call this "Flexible Launch Control"?

I am actually a little bit confused about all those terms here. I don't think
from spec's perspective, there's such thing "Flexible Launch Control", but I
think everyone knows what does it mean. But I am not sure whether it is
commonly used by community. 

I think using FLC is fine if we only want to mention unlocked mode. But if you
want to mention both, IMHO it would be better to specifically use LC locked
mode and unlocked mode, since technically there's third case that LC is not
present at all.

> 
> > virtualization doesn't, since how enclave is created is completely controlled
> > by guest SGX software, which is not necessarily linux. Therefore, this series
> > allows KVM to expose SGX to guest even SGX Launch Control is in locked mode,
> 
> ... "expose SGX to guests even if" ...

Thanks.

> 
> > or is not present at all. The reason is the goal of SGX virtualization, or
> > virtualization in general, is to expose hardware feature to guest, but not to
> > make assumption how guest will use it. Therefore, KVM should support SGX guest
> > as long as hardware is able to, to have chance to support more potential use
> > cases in cloud environment.
> 
> This is kinda long-winded and misses a lot of important context.  How about:
> 
> SGX hardware supports two "launch control" modes to limit which enclaves
> can run.  In the "locked" mode, the hardware prevents enclaves from
> running unless they are blessed by a third party. 

or "by Intel".

 In the unlocked mode,
> the kernel is in full control of which enclaves can run.  The bare-metal
> SGX code refuses to launch enclaves unless it is in the unlocked mode.
> 
> This sgx_virt_epc driver does not have such a restriction.  This allows
> guests which are OK with the locked mode to use SGX, even if the host
> kernel refuses to.

Indeed better. Thanks a lot.

> 
> > - Support exposing SGX2
> > 
> > Due to the same reason above, SGX2 feature detection is added to core SGX code
> > to allow KVM to expose SGX2 to guest, even currently SGX driver doesn't support
> > SGX2, because SGX2 can work just fine in guest w/o any interaction to host SGX
> > driver.
> > 
> > - Restricit SGX guest access to provisioning key
> > 
> > To grant guest being able to fully use SGX, guest needs to be able to create
> > provisioning enclave.
> 
> "enclave" or "enclaves"?

I think should be "enclave", inside one VM, there should only be one
provisioning enclave.

> 
> > However provisioning key is sensitive and is restricted by
> 
> 	^ the

Thanks.

> 
> > /dev/sgx_provision in host SGX driver, therefore KVM SGX virtualization follows
> > the same role: a new KVM_CAP_SGX_ATTRIBUTE is added to KVM uAPI, and only file
> > descriptor of /dev/sgx_provision is passed to that CAP by usersppace hypervisor
> > (Qemu) when creating the guest, it can access provisioning bit. This is done by
> > making KVM trape ECREATE instruction from guest, and check the provisioning bit
> 
> 		^ trap
> 
> > in ECREATE's attribute.
> 
> The grammar in that paragraph is really off to me.  Can you give it
> another go?

I'll refine it. Thanks a lot for input.

