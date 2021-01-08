Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B45B2EEB34
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 03:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbhAHCRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 21:17:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:57504 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbhAHCRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 21:17:34 -0500
IronPort-SDR: QJ2XLaQrQAT961+MQQHQWJDLB79hnxXVEu8QreA1hbRz87CRQE6l3x6cEzOmB4R91QF3riKRVn
 DDybi9ZYXnLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="262297479"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="262297479"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 18:16:53 -0800
IronPort-SDR: ukq5hlBitu+SmXtFhvEK2oUtSmQFVc3omu+a810T1BH4juqQfktiFw6qgz5mtmjFoEUTpzWRUX
 9rrqqKZgSAWA==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="362180462"
Received: from culloa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.116.170])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 18:16:47 -0800
Date:   Fri, 8 Jan 2021 15:16:45 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-Id: <20210108151645.6c1d624f6bf383c7de0d526a@intel.com>
In-Reply-To: <X/czdL6TmbuBdZ/b@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <1772bbf4-54bd-e43f-a71f-d72f9a6a9bad@intel.com>
        <20210107133441.0983ca20f7909186b8ff8fa1@intel.com>
        <d586730e-d02f-8059-0a81-cbfd762deacf@intel.com>
        <20210107145026.a8f593323ab9ae34874250ed@intel.com>
        <X/czdL6TmbuBdZ/b@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 08:14:44 -0800 Sean Christopherson wrote:
> On Thu, Jan 07, 2021, Kai Huang wrote:
> > On Wed, 6 Jan 2021 16:48:58 -0800 Dave Hansen wrote:
> > > Your series adds some new interfaces, including /dev/sgx_virt_epc.  If
> > > the kernel wants to add oversubscription in the future, will old binary
> > > application users of /dev/sgx_virt_epc be able to support
> > > oversubscription?  Or, would users of /dev/sgx_virt_epc need to change
> > > to support oversubscription?
> > 
> > Oversubscription will be completely done in kernel/kvm, and will be
> > transparent to userspace, so it will not impact ABI.
> 
> It's not transparent to userpsace, odds are very good that userspace would want
> to opt in/out of EPC reclaim for its VMs.  E.g. for cases where it would be
> preferable to fail to launch a VM than degrade performance.

It seems reasonable use case, but I don't have immediate picture how it
requires new ABI related to virtualization. For instance, SGX driver should
expose sysfs saying how frequent the EPC swapping is (with KVM
oversubscription, host SGX code should provide such info in whole I think),
and cloud admin can determine whether to launch new VM.

Another argument is, theoretically, cloud admin may not know how EPC will be
used in guest, so potentially guest will only use very little EPC, thus
creating new VM won't hurt a lot, so I am not sure that, if we want to
upstream KVM oversubscription one day, do we need to consider such case.
 
> 
> That being said, there are no anticipated /dev/sgx_virt_epc ABI changes to
> support reclaim, as the ABI changes will be in KVM.  In the KVM oversubscription
> POC, I added a KVM ioctl to allow enabling EPC reclaim/oversubscription.  That
> ioctl took a fd for a /dev/sgx_virt_epc instance.

Adding IOCTL to enable/disable oversubscription for particular VM seems
user-case dependent, and I am not sure whether we need to support that if we
want to upstream oversubscription one day. To me, it makes sense to upstream
*basic* oversubscription (which just supports reclaiming EPC from VM) first,
and then we can extend if needed according to use cases.

Anyway, oversubscription won't break existing ABI as you mentioned. 

> 
> The reason for routing through KVM was to solve two dependencies issues:
> 
>   - KVM needs a reference to the virt_epc instance to handle SGX_CONFLICT VM-Exits
> 
>   - The SGX subsystem needs to be able to translate GPAs to HVAs to retrieve the
>     SECS for a page it is reclaiming.  That requires a KVM instance and helper
>     function.
> 
> Routing the ioctl through KVM allows KVM to hand over a pointer of itself along
> with a GPA->HVA helper, and the SGX subsystem in turn can hand back the virt_epc
> instance resolved from the fd.
> 
> It would be possible to invert the flow, e.g. pass in a KVM fd to a new
> /dev/sgx_virt_epc ioctl, but I suspect that would be kludgier, and in any case
> it would be a new ioctl and so would not break existing users.
