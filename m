Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42C52F2558
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 02:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbhALBPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 20:15:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:22280 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbhALBPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 20:15:16 -0500
IronPort-SDR: VeaCzDZySdGri6bDiBoYwyu+Gq63u3HsHp6jQtZTTkXSNl80PFuq+tlgDar3OjsOx+I4AW9VZ+
 m2lwHTtAoSBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="165643373"
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="165643373"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 17:14:35 -0800
IronPort-SDR: gcTdPTAenSfBS4t+vy9UlozmWALYIvh6z2EK9947afF2LKcge31cgqrAmwj1r/LOBOglMrWDaE
 ziTlz4rgGcAg==
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="397207362"
Received: from tpotnis-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.76.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 17:14:30 -0800
Date:   Tue, 12 Jan 2021 14:14:28 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, mattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-Id: <20210112141428.038533b6cd5f674c906a3c43@intel.com>
In-Reply-To: <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
        <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jan 2021 19:20:48 +0200 Jarkko Sakkinen wrote:
> On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > --- Disclaimer ---
> > 
> > These patches were originally written by Sean Christopherson while at Intel.
> > Now that Sean has left Intel, I (Kai) have taken over getting them upstream.
> > This series needs more review before it can be merged.  It is being posted
> > publicly and under RFC so Sean and others can review it. Maintainers are safe
> > ignoring it for now.
> > 
> > ------------------
> > 
> > Hi all,
> > 
> > This series adds KVM SGX virtualization support. The first 12 patches starting
> > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> > 
> > Please help to review this series. Also I'd like to hear what is the proper
> > way to merge this series, since it contains change to both x86/SGX and KVM
> > subsystem. Any feedback is highly appreciated. And please let me know if I
> > forgot to CC anyone, or anyone wants to be removed from CC. Thanks in advance!
> > 
> > This series is based against latest tip tree's x86/sgx branch. You can also get
> > the code from tip branch of kvm-sgx repo on github:
> > 
> >         https://github.com/intel/kvm-sgx.git tip
> > 
> > It also requires Qemu changes to create VM with SGX support. You can find Qemu
> > repo here:
> > 
> >         https://github.com/intel/qemu-sgx.git next
> > 
> > Please refer to README.md of above qemu-sgx repo for detail on how to create
> > guest with SGX support. At meantime, for your quick reference you can use below
> > command to create SGX guest:
> > 
> >         #qemu-system-x86_64 -smp 4 -m 2G -drive file=<your_vm_image>,if=virtio \
> >                 -cpu host,+sgx_provisionkey \
> >                 -sgx-epc id=epc1,memdev=mem1 \
> >                 -object memory-backend-epc,id=mem1,size=64M,prealloc
> > 
> > Please note that the SGX relevant part is:
> > 
> >                 -cpu host,+sgx_provisionkey \
> >                 -sgx-epc id=epc1,memdev=mem1 \
> >                 -object memory-backend-epc,id=mem1,size=64M,prealloc
> > 
> > And you can change other parameters of your qemu command based on your needs.
> 
> Thanks a lot documenting these snippets to the cover letter. I dig these
> up from lore once my environment is working.
> 
> I'm setting up Arch based test environment with the eye on this patch set
> and generic Linux keyring patches:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/arch.git/
> 
> Still have some minor bits to adjust before I can start deploying it for SGX
> testing. For this patch set I'll use two instances of it.

Thanks. Please let me know if you need anything more.

> 
> > =========
> > KVM SGX virtualization Overview
> > 
> > - Virtual EPC
> > 
> > "Virtual EPC" is the EPC section exposed by KVM to guest so SGX software in
> > guest can discover it and use it to create SGX enclaves. KVM exposes SGX to 
> 
> Virtual EPC is a representation of an EPC section. And there is no "the".
> 
> > guest via CPUID, and exposes one or more "virtual EPC" sections for guest.
> > The size of "virtual EPC" is passed as Qemu parameter when creating the
> > guest, and the base address is calcualted internally according to guest's
> > configuration.
> > 
> > To support virtual EPC, add a new misc device /dev/sgx_virt_epc to SGX
> > core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> > "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX driver,
> > virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave associated,
> > and how virtual EPC is used by guest is compeletely controlled by guest's SGX
> > software.
> 
> I think that /dev/sgx_vepc would be a clear enough name for the device. This
> text has now a bit confusing "terminology" related to this.

/dev/sgx_virt_epc may be clearer from userspace's perspective, for instance,
if people see /dev/sgx_vepc, they may have to think about what it is,
while /dev/sgx_virt_epc they may not.

But I don't have strong objection here. Does anyone has anything to say here?
