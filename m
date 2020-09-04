Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6A225DECD
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIDQAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 12:00:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:29411 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgIDQAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 12:00:14 -0400
IronPort-SDR: p8h0t8mTpBiLdWIa0lCT2hDK/9FmG8zdObq84BgZqMShFEzbEdvKJB6rV0qY74DXuFdaq8iLDI
 jGaF/agi6LbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="175822319"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="175822319"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:00:12 -0700
IronPort-SDR: B0zfEkIxhDFm2q4frTASRz7FOgl7CEHz9Q72W6CC3ioa5Lv3Tv2kK5vDrwxBrX/5AQR4oq9jq0
 7vT+c1KM7zlg==
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="478552197"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:00:12 -0700
Date:   Fri, 4 Sep 2020 09:00:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200904160008.GA2206@sjchrist-ice>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
 <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 09:29:05AM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > Unless I'm mistaken, microvm doesn't even support PCI, does it?
> 
> Correct, no pci support right now.
> 
> We could probably wire up ecam (arm/virt style) for pcie support, once
> the acpi support for mictovm finally landed (we need acpi for that
> because otherwise the kernel wouldn't find the pcie bus).
> 
> Question is whenever there is a good reason to do so.  Why would someone
> prefer microvm with pcie support over q35?
> 
> > If all of the above is true, this can be handled by adding "pci=lastbus=0"
> > as a guest kernel param to override its scanning of buses.  And couldn't
> > that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
> > to the end user?
> 
> microvm_fix_kernel_cmdline() is a hack, not a solution.
> 
> Beside that I doubt this has much of an effect on microvm because
> it doesn't support pcie in the first place.

I am so confused.  Vitaly, can you clarify exactly what QEMU VM type this
series is intended to help?  If this is for microvm, then why is the guest
doing PCI scanning in the first place?  If it's for q35, why is the
justification for microvm-like workloads?

Either way, I think it makes sense explore other options before throwing
something into KVM, e.g. modifying guest command line, adding a KVM hint,
"fixing" QEMU, etc... 
