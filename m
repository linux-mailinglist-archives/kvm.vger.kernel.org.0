Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4882F25D9
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 02:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbhALBvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 20:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbhALBvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 20:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE1622E01;
        Tue, 12 Jan 2021 01:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610416228;
        bh=dRGyHAjqsy64r9JX6waKT5z0ulEmmuBT29XOewWYj6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nh1RqDphK9lOWC8DSDStTcsbEzYLHcmYR3k0SQt3vjXNaJkm4uXc8kui9Hvk55Nxd
         QQRjWGorq+ImtCquM+S2CEMl8jRrV2tq7368s3mwWHBitHL3EH+t/zvzN6iw/ykCq0
         ABPSdkvh2i1SPW2wGDDcOrDOSfi0ZAtCvT+a3Q8Oo8Gnbv6KsKiAZcgwfNVbXBrbmE
         IfaWscLhNvRQY/JAGcgaGgNy20+YRBRO9YPt9ymCdGJ1QtGBui/NmaYzQsIF82Y5xm
         QHAQpsJ1q/sDvHN/dWq9uPvnA4MiS+TZecwm0ynYWyLZmjBcHbgfe3U13kv7uYz5n+
         Ki39yB6jL60zg==
Date:   Tue, 12 Jan 2021 03:50:23 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <X/0AX7B5mU2DMVaO@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
 <X/zhbyoWBnV1ESQx@kernel.org>
 <20210112135654.8fbefebd82fa6c57dc2d3bef@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112135654.8fbefebd82fa6c57dc2d3bef@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 01:56:54PM +1300, Kai Huang wrote:
> On Tue, 12 Jan 2021 01:38:23 +0200 Jarkko Sakkinen wrote:
> > On Wed, Jan 06, 2021 at 02:55:20PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> > > EPC without an associated enclave.  The intended and only known use case
> > > for raw EPC allocation is to expose EPC to a KVM guest, hence the
> > > virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> > > 
> > > Modify sgx_init() to always try to initialize virtual EPC driver, even
> > > when SGX driver is disabled due to SGX Launch Control is in locked mode,
> > > or not present at all, since SGX virtualization allows to expose SGX to
> > > guests that support non-LC configurations.
> > > 
> > > Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> > > /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:
> > > 
> > >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> > >     just another memory backend for guests.
> > > 
> > >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> > >     does not have to export any symbols, changes to reclaim flows don't
> > >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> > >     get aired out for the world to see, and so on and so forth.
> > > 
> > > The virtual EPC allocated to guests is currently not reclaimable, due to
> > > oversubscription of EPC for KVM guests is not currently supported. Due
> > > to the complications of handling reclaim conflicts between guest and
> > > host, KVM EPC oversubscription is significantly more complex than basic
> > > support for SGX virtualization.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > 
> > The commit message does not describe the code changes. It should
> > have an understandable explanation of fops. There is nothing about
> > the implementation right now.
> 
> Thanks for feedback. Does "understabdable explanation of fops" mean I
> should add one sentence to say, for instance: "userspace hypervisor should open
> the /dev/sgx_virt_epc, use mmap() to get a valid address range, and then use
> that address range to create KVM memory region"?
> 
> Or should I include an example of how to use /dev/sgx_virt_epc in userspace, for
> instance, below?
> 
> 	fd = open("/dev/sgx_virt_epc", O_RDWR);
> 	void *addr = mmap(NULL, size, ..., fd);
> 	/* userspace hypervisor uses addr, size to create KVM memory slot */
> 	...

I would suggest just to describe them in few sentences. Just write
how you understand them in one paragraph.

/Jarkko
