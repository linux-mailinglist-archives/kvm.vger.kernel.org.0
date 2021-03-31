Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53F350AA6
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 01:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhCaXX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 19:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCaXXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 19:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE02761057;
        Wed, 31 Mar 2021 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617232989;
        bh=7qKTBZ33hsy0BLYk+KPdaZQgCrEQ9vlK7Wd8SViwxuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdb3yZHk2W0dyxqN/4+bvUqhSr7elqo/zWtwqvOr4AVxTosVDl6gIFQDnf1rO1O4x
         emqTSt032zJmSMr24mtgtvF3dGqqdF/5VTLijI8ouoHy/RVNtob72pNvXsZ5sgFCtv
         tApUeQ4AoB+61iIQSMNwJNc44T0suz2jC4J6HUg/CFIW41jFAhR11f6ciYoGMKcdJ0
         4YEHWHiKP6LrorJJv43/m6mPY6lVRq31lzhb8zP3dk4X71WiCh0U58ZT5Li6XoZnYw
         W0ZBY7xOiBVXwMC/mOB2HLr/dAqX53y8XZa8FPelA7K6YNOYcKEhSZp3nONbkFYICx
         qafoo+Wf2+/uQ==
Date:   Thu, 1 Apr 2021 02:23:06 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: [PATCH v3 00/25] KVM SGX virtualization support
Message-ID: <YGUEWiY3ymVbkk0y@kernel.org>
References: <cover.1616136307.git.kai.huang@intel.com>
 <YF5kNPP2VyzcTuTY@kernel.org>
 <490103d033674dbeb812def2def69543@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490103d033674dbeb812def2def69543@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 28, 2021 at 09:01:38PM +0000, Huang, Kai wrote:
> > On Fri, Mar 19, 2021 at 08:29:27PM +1300, Kai Huang wrote:
> > > This series adds KVM SGX virtualization support. The first 14 patches
> > > starting with x86/sgx or x86/cpu.. are necessary changes to x86 and
> > > SGX core/driver to support KVM SGX virtualization, while the rest are patches
> > to KVM subsystem.
> > >
> > > This series is based against latest tip/x86/sgx, which has Jarkko's
> > > NUMA allocation support.
> > >
> > > You can also get the code from upstream branch of kvm-sgx repo on github:
> > >
> > >         https://github.com/intel/kvm-sgx.git upstream
> > >
> > > It also requires Qemu changes to create VM with SGX support. You can
> > > find Qemu repo here:
> > >
> > > 	https://github.com/intel/qemu-sgx.git upstream
> > >
> > > Please refer to README.md of above qemu-sgx repo for detail on how to
> > > create guest with SGX support. At meantime, for your quick reference
> > > you can use below command to create SGX guest:
> > >
> > > 	#qemu-system-x86_64 -smp 4 -m 2G -drive
> > file=<your_vm_image>,if=virtio \
> > > 		-cpu host,+sgx_provisionkey \
> > > 		-sgx-epc id=epc1,memdev=mem1 \
> > > 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> > >
> > > Please note that the SGX relevant part is:
> > >
> > > 		-cpu host,+sgx_provisionkey \
> > > 		-sgx-epc id=epc1,memdev=mem1 \
> > > 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> > >
> > > And you can change other parameters of your qemu command based on your
> > needs.
> > 
> > Please also put tested-by from me to all patches (including pure KVM
> > patches):
> > 
> > Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > I did the basic test, i.e. run selftest in a VM. I think that is sufficient at this point.
> > 
> 
> Thanks Jarkko for doing the test!

Sure, have had it in my queue for some time :-)

/Jarkko
