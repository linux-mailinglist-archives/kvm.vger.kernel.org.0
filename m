Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BA2EC7D9
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 02:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbhAGBvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 20:51:13 -0500
Received: from mga17.intel.com ([192.55.52.151]:48914 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbhAGBvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 20:51:13 -0500
IronPort-SDR: PmM11X16uycmR+rD04T6cg0ms0KLxhWU1YyW0Fy5Igog04FMztRqB211jpAVze9dwt0XOSFEhw
 Byfpm8GfRTuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="157143525"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="157143525"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:50:32 -0800
IronPort-SDR: s+xvzgxKq8A+UwImhebNIeCO6udJLilmVh9a6Qd3k5zqAQuMKSp1PXAvcEZi7m8yIrN+MOmw5E
 0Qt8Yth2FA4g==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="379511568"
Received: from naljabex-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.117.182])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:50:28 -0800
Date:   Thu, 7 Jan 2021 14:50:26 +1300
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
Message-Id: <20210107145026.a8f593323ab9ae34874250ed@intel.com>
In-Reply-To: <d586730e-d02f-8059-0a81-cbfd762deacf@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <1772bbf4-54bd-e43f-a71f-d72f9a6a9bad@intel.com>
        <20210107133441.0983ca20f7909186b8ff8fa1@intel.com>
        <d586730e-d02f-8059-0a81-cbfd762deacf@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 16:48:58 -0800 Dave Hansen wrote:
> On 1/6/21 4:34 PM, Kai Huang wrote:
> > On Wed, 6 Jan 2021 09:07:13 -0800 Dave Hansen wrote:
> >> Does the *ABI* here preclude doing oversubscription in the future?
> > 
> > I am Sorry what *ABI* do you mean?
> 
> Oh boy.
> 
> https://en.wikipedia.org/wiki/Application_binary_interface
> 
> In your patch set that you are posting, /dev/sgx_virt_epc is a new
> interface: a new ABI.  If we accept your contribution, programs will be
> build around and expect Linux to support this ABI.  An ABI is a contract
> between software written to use it and the kernel.  The kernel tries
> *really* hard to never break its contracts with applications.

Thanks.

> 
> OK, now that we have that out of the way, I'll ask my question in
> another way:
> 
> Your series adds some new interfaces, including /dev/sgx_virt_epc.  If
> the kernel wants to add oversubscription in the future, will old binary
> application users of /dev/sgx_virt_epc be able to support
> oversubscription?  Or, would users of /dev/sgx_virt_epc need to change
> to support oversubscription?

Oversubscription will be completely done in kernel/kvm, and will be
transparent to userspace, so it will not impact ABI.

> 
> >> Also, didn't we call this "Flexible Launch Control"?
> > 
> > I am actually a little bit confused about all those terms here. I don't think
> > from spec's perspective, there's such thing "Flexible Launch Control", but I
> > think everyone knows what does it mean. But I am not sure whether it is
> > commonly used by community. 
> > 
> > I think using FLC is fine if we only want to mention unlocked mode. But if you
> > want to mention both, IMHO it would be better to specifically use LC locked
> > mode and unlocked mode, since technically there's third case that LC is not
> > present at all.
> 
> Could you go over the changelogs from Jarkko's patches and at least make
> these consistent with those?

I'll dig into them.

[...]

> >>> - Restricit SGX guest access to provisioning key
> >>>
> >>> To grant guest being able to fully use SGX, guest needs to be able to create
> >>> provisioning enclave.
> >>
> >> "enclave" or "enclaves"?
> > 
> > I think should be "enclave", inside one VM, there should only be one
> > provisioning enclave.
> 
> This is where the language becomes important.  Is the provisioning
> enclave a one-shot deal?  You create one per guest and can never create
> another?  Or, can you restart it?  Can you architecturally have more
> than one active at once?  Or, can you only create one once the first one
> dies?
> 
> You'll write that sentence differently based on the answers.
> 

I think I can just change to "guest needs to be able to access provisioning
key". :)


