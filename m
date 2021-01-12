Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501542F2603
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 03:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbhALCD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 21:03:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:29698 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbhALCD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 21:03:59 -0500
IronPort-SDR: jLLNa5fJR9BFxRBBfmwat3C1mr6WLyNyzA+xY+GQa45f9Aj8s4t+8o1O5Y6Qd8neY7x9OSSowO
 Ct58YrX5Q+Ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="178061415"
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="178061415"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:03:16 -0800
IronPort-SDR: 17WE0Gdh1ZZuzrcaQ7uUpL6EWpWw0RElKYHszF/idIu0+G+aveqfa6KBx17HCTVWs5gJAUpV6b
 sMgOgnskp2Lg==
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="352828189"
Received: from tpotnis-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.76.146])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:03:13 -0800
Date:   Tue, 12 Jan 2021 15:03:09 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210112150309.4ca3f915f7dd4d1dbd251afa@intel.com>
In-Reply-To: <X/0AX7B5mU2DMVaO@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <X/zhbyoWBnV1ESQx@kernel.org>
        <20210112135654.8fbefebd82fa6c57dc2d3bef@intel.com>
        <X/0AX7B5mU2DMVaO@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 03:50:23 +0200 Jarkko Sakkinen wrote:
> On Tue, Jan 12, 2021 at 01:56:54PM +1300, Kai Huang wrote:
> > On Tue, 12 Jan 2021 01:38:23 +0200 Jarkko Sakkinen wrote:
> > > On Wed, Jan 06, 2021 at 02:55:20PM +1300, Kai Huang wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > Add a misc device /dev/sgx_virt_epc to allow userspace to allocate "raw"
> > > > EPC without an associated enclave.  The intended and only known use case
> > > > for raw EPC allocation is to expose EPC to a KVM guest, hence the
> > > > virt_epc moniker, virt.{c,h} files and X86_SGX_VIRTUALIZATION Kconfig.
> > > > 
> > > > Modify sgx_init() to always try to initialize virtual EPC driver, even
> > > > when SGX driver is disabled due to SGX Launch Control is in locked mode,
> > > > or not present at all, since SGX virtualization allows to expose SGX to
> > > > guests that support non-LC configurations.
> > > > 
> > > > Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> > > > /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:
> > > > 
> > > >   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
> > > >     just another memory backend for guests.
> > > > 
> > > >   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
> > > >     does not have to export any symbols, changes to reclaim flows don't
> > > >     need to be routed through KVM, SGX's dirty laundry doesn't have to
> > > >     get aired out for the world to see, and so on and so forth.
> > > > 
> > > > The virtual EPC allocated to guests is currently not reclaimable, due to
> > > > oversubscription of EPC for KVM guests is not currently supported. Due
> > > > to the complications of handling reclaim conflicts between guest and
> > > > host, KVM EPC oversubscription is significantly more complex than basic
> > > > support for SGX virtualization.
> > > > 
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > 
> > > The commit message does not describe the code changes. It should
> > > have an understandable explanation of fops. There is nothing about
> > > the implementation right now.
> > 
> > Thanks for feedback. Does "understabdable explanation of fops" mean I
> > should add one sentence to say, for instance: "userspace hypervisor should open
> > the /dev/sgx_virt_epc, use mmap() to get a valid address range, and then use
> > that address range to create KVM memory region"?
> > 
> > Or should I include an example of how to use /dev/sgx_virt_epc in userspace, for
> > instance, below?
> > 
> > 	fd = open("/dev/sgx_virt_epc", O_RDWR);
> > 	void *addr = mmap(NULL, size, ..., fd);
> > 	/* userspace hypervisor uses addr, size to create KVM memory slot */
> > 	...
> 
> I would suggest just to describe them in few sentences. Just write
> how you understand them in one paragraph.

Will do. Thanks.

