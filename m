Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321462F87B6
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 22:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAOVe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 16:34:26 -0500
Received: from mga04.intel.com ([192.55.52.120]:54870 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbhAOVeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 16:34:25 -0500
IronPort-SDR: HOCA39CoV4BiPjovxh1Sez5jMr5/t+9TGq5bKF5N9nuSIlu0N9B2j7xm2Uju24+P+DE6oSXIt3
 BiHjnQT+udLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9865"; a="176032069"
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="176032069"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 13:33:44 -0800
IronPort-SDR: dJtW2dWTT9lzuk9HegV3DKjG/PYzTiisz7M1bF3Id20+LquKwQQnko/vRzTqOfxCkutOeh5dQb
 Vk17wSsIDQhQ==
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="572731711"
Received: from stsmyth-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.231.187])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 13:33:41 -0800
Date:   Sat, 16 Jan 2021 10:33:39 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210116103339.0e36349cbde63ee8beba03e4@intel.com>
In-Reply-To: <af302572-96ae-66f5-4922-ef4a8879907f@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
        <20210107144203.589d4b2a7a2d2b53c4af7560@intel.com>
        <bd0ff2d8-3425-2f69-5fa7-8da701d55e42@intel.com>
        <20210116030713.276e48c023330172cded174c@intel.com>
        <af302572-96ae-66f5-4922-ef4a8879907f@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Jan 2021 07:39:44 -0800 Dave Hansen wrote:
> On 1/15/21 6:07 AM, Kai Huang wrote:
> >>From virtual EPC's perspective, if we don't force this in kernel, then
> > *theoretically*, userspace can use fork() to make multiple VMs map to the
> > same physical EPC, which will potentially cause enclaves in all VMs to behave
> > abnormally. So to me, from this perspective, it's better to enforce in kernel
> > so that only first VM can use this virtual EPC instance, because EPC by
> > architectural design cannot be shared.
> > 
> > But as Sean said, KVM doesn't support VM across multiple mm structs. And if I
> > read code correctly, KVM doesn't support userspace to use fork() to create new
> > VM. For instance, when creating VM, KVM grabs current->mm and keeps it in
> > 'struct kvm' for bookkeeping, and kvm_vcpu_ioctl() and kvm_device_ioctl() will
> > refuse to work if kvm->mm doesn't equal to current->mm. So in practice, I
> > believe w/o enforcing this in kernel, we should also have no problem here.
> > 
> > Sean, please correct me if I am wrong.
> > 
> > Dave, if above stands, do you think it is reasonable to keep current->mm in
> > epc->mm and enforce in sgx_virt_epc_mmap()?
> 
> Everything you wrote above tells me the kernel should not be enforcing
> the behavior.  You basically said that it's only a theoretical problem,
> and old if someone goes and does something with KVM that's nobody can do
> today.
> 
> You've 100% convinced me that having the kernel enforce this is
> *un*reasonable.

Sean, I'll remove epc->mm, unless I see your further objection.

Thanks to you both.
