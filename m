Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C10472A47
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbhLMKgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239355AbhLMKfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 05:35:52 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E064C08EC6A;
        Mon, 13 Dec 2021 02:10:49 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639390247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kpmld58++CovZyjv4g8dxh7x+hTY0n1CC8dC2gdGec8=;
        b=nKdhjF+OYXv76RPc+NX7no2l0uOZ6IX0lXrZ47bVIsLGck4ZNCAd7lYUwCfZ5MRUEm58Zy
        HC91b2To67hudXyZ2r3f43eA+RX+/kJ39DcTyQqWDj8PTFAA8E7NmGTZ3oEj0Rk4OLNT7x
        SpOAt18ReGsaJ1w/iA3h5X+yRGwaMMWabfCp3qpbhm08a4YGnYKneAdipwDuPsthr9o+O0
        s4osAdEA7PNe+1bw93Q1NcGLOHYipnvtPscHX8IWVjIv7WS3WiqFfsGHn4fM/uFhbE6d/4
        cDRSiZU5xJ8vuYa63U1YwNrTk8w/q9q7gZQOn44oFbXK1TXIs3oT05H8HCvQuw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639390247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kpmld58++CovZyjv4g8dxh7x+hTY0n1CC8dC2gdGec8=;
        b=WTHY2yQoctGef0bq/3/ngKGi83NirnkaJgoKZzuATSFEIMfa6pEjcu0tbTJQCB7KAowcY/
        EoVFbHhWHiZzPACA==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
In-Reply-To: <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
Date:   Mon, 13 Dec 2021 11:10:47 +0100
Message-ID: <87bl1kvmqg.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10 2021 at 17:30, Paolo Bonzini wrote:
> On 12/8/21 01:03, Yang Zhong wrote:
>> +static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 *state)
>> +{
>> +	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>> +		return 0;
>> +
>> +	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state,
>> +					      supported_xcr0, &vcpu->arch.pkru);
>> +}
>> +
>
> I think fpu_copy_uabi_to_guest_fpstate (and therefore 
> copy_uabi_from_kernel_to_xstate) needs to check that the size is 
> compatible with the components in the input.

fpu_copy_uabi_to_guest_fpstate() expects that the input buffer is
correctly sized. We surely can add a size check there.

> Also, IIUC the size of the AMX state will vary in different processors. 
>   Is this correct?  If so, this should be handled already by 
> KVM_GET/SET_XSAVE2 and therefore should be part of the 
> arch/x86/kernel/fpu APIs.  In the future we want to support migrating a 
> "small AMX" host to a "large AMX" host; and also migrating from a "large 
> AMX" host to a "small AMX" host if the guest CPUID is compatible with 
> the destination of the migration.

How is that supposed to work? If the AMX state size differs then the
hosts are not compatible.

Thanks,

        tglx
