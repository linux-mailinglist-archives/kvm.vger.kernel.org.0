Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C582F7DBF
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbhAOOIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:08:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:46895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbhAOOH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 09:07:59 -0500
IronPort-SDR: aFALSTDMBRzXpTMYLPafW/B0qGYGH52jcnb4DoDXUBz9Lc6H/fD0u7G83LzopicoRIhtNR4L/8
 guXOsmS68MjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="177772750"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="177772750"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 06:07:19 -0800
IronPort-SDR: kAs2L9iORNiqfjpFscSideVFaBAexitrqRVwt5w2lMRs2zIxztsDBqZbHZ8wqfZ/ODiOPcT/s1
 ME+0EmvZMF3Q==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="354314866"
Received: from sanjanar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.19.188])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 06:07:16 -0800
Date:   Sat, 16 Jan 2021 03:07:13 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210116030713.276e48c023330172cded174c@intel.com>
In-Reply-To: <bd0ff2d8-3425-2f69-5fa7-8da701d55e42@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
        <20210107144203.589d4b2a7a2d2b53c4af7560@intel.com>
        <bd0ff2d8-3425-2f69-5fa7-8da701d55e42@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 21:02:54 -0800 Dave Hansen wrote:
> On 1/6/21 5:42 PM, Kai Huang wrote:
> >> I understand why this made sense for regular enclaves, but I'm having a
> >> harder time here.  If you mmap(fd, MAP_SHARED), fork(), and then pass
> >> that mapping through to two different guests, you get to hold the
> >> pieces, just like if you did the same with normal memory.
> >>
> >> Why does the kernel need to enforce this policy?
> > Does Sean's reply in another email satisfy you?
> 
> I'm not totally convinced.
> 
> Please give it a go in the changelog for the next one and try to
> convince me that this is a good idea.  Focus on what the downsides will
> be if the kernel does not enforce this policy.  What will break, and why
> will it be bad?  Why is the kernel in the best position to thwart the
> badness?

Hi Dave, Sean,

Sorry for late reply of this. I feel I should try again to get consensus here.

From virtual EPC's perspective, if we don't force this in kernel, then
*theoretically*, userspace can use fork() to make multiple VMs map to the
same physical EPC, which will potentially cause enclaves in all VMs to behave
abnormally. So to me, from this perspective, it's better to enforce in kernel
so that only first VM can use this virtual EPC instance, because EPC by
architectural design cannot be shared.

But as Sean said, KVM doesn't support VM across multiple mm structs. And if I
read code correctly, KVM doesn't support userspace to use fork() to create new
VM. For instance, when creating VM, KVM grabs current->mm and keeps it in
'struct kvm' for bookkeeping, and kvm_vcpu_ioctl() and kvm_device_ioctl() will
refuse to work if kvm->mm doesn't equal to current->mm. So in practice, I
believe w/o enforcing this in kernel, we should also have no problem here.

Sean, please correct me if I am wrong.

Dave, if above stands, do you think it is reasonable to keep current->mm in
epc->mm and enforce in sgx_virt_epc_mmap()?
