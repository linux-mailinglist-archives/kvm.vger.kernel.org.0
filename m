Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E6044C413
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 16:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhKJPLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 10:11:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231743AbhKJPLN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 10:11:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636556906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AmR/7C75Un9rG7eImGgN4ajbaNdyQYmnUmjcof6AyG0=;
        b=gNhMIKZPHOd8Q3VEUdMpryy9AfBaLwmYUzzJ66Hgr2IlYHCbh+FIzHSr9d7jw/vsQhfdGP
        F5+2QICJEnQEQu6GjbLlc7YPLdrnZmSyDXXMlzJ48wBaIV0d97vS7wxUQDFF40mMDL1syt
        sT74qTGh4NZwqGkaxJXSN1h7ojC2YwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-6YRRtgCBM9GjHZJR58nU1Q-1; Wed, 10 Nov 2021 10:08:24 -0500
X-MC-Unique: 6YRRtgCBM9GjHZJR58nU1Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 192A7BAF83;
        Wed, 10 Nov 2021 15:08:23 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B01B60FFE;
        Wed, 10 Nov 2021 15:08:05 +0000 (UTC)
Message-ID: <7c326795af6ef2d876c14e645da1be67de50a928.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: nVMX: restore L1's EFER prior to setting the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>
Date:   Wed, 10 Nov 2021 17:08:04 +0200
In-Reply-To: <e6d4e268-da50-c55f-1485-f4a871afdff0@redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
         <20211110100018.367426-3-mlevitsk@redhat.com>
         <e6d4e268-da50-c55f-1485-f4a871afdff0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-10 at 16:01 +0100, Paolo Bonzini wrote:
> On 11/10/21 11:00, Maxim Levitsky wrote:
> > +	/*
> > +	 * The vcpu might currently contain L2's IA32_EFER, due to the way
> > +	 * some userspace kvm users (e.g qemu) restore nested state.
> > +	 *
> > +	 * To fix this, restore its IA32_EFER to the value it would have
> > +	 * after VM exit from the nested guest.
> > +	 *
> > +	 */
> > +
> > +	vcpu->arch.efer = nested_vmx_get_vmcs12_host_efer(vcpu, vmcs12);
> > +
> 
> In principle the value of LOAD_HOST_EFER on exit need not be the same as 
> on entry.  But you don't need all of EFER, only EFER.LME/EFER.LMA, and 
> those two bits must match ("the values of the LMA and LME bits in the 
> field must each be that of the “host address-space size” VM-exit 
> control" from the "Checks on Host Control Registers, MSRs, and SSP"; 
> plus the "Checks Related to Address-Space Size").
> 
> At least it's worth adjusting the comment to explain that.  But the root 
> cause of the issue is just nested_vmx_check_* accessing vcpu->arch.  So 
> you can instead:
> 
> - split out of nested_vmx_check_host_state a new function 
> nested_vmx_check_address_state_size that does
> 
> #ifdef CONFIG_X86_64
> 	if (CC(!!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) !=
> 	       !!(vcpu->arch.efer & EFER_LMA)))
> 		return -EINVAL;
> #endif
> 	return 0;
> 
> - call it from vmentry but not from migration
> 
> - in nested_vmx_check_host_state, assign ia32e from 
> vmcs12->vm_exit_controls instead of vcpu->arch.efer

I agree with you. I was thinking do something like that but wasn't sure at all.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


