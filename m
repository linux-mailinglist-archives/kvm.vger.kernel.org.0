Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523942F3D65
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436965AbhALVgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:36:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406962AbhALUBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 15:01:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610481619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YFXb4Pk6zkZotZ7QFJdBiZxTuzhscJ3Ufo92Lo64mQQ=;
        b=Efla9mP0Dq4GneFaqh7i0lPuweO8fY6Orb/RAosyM/zQzI8+p5j0Jb2D4PMKyZlDJdBfxi
        XiJVDUpSPRPjyGkmmVZ3UmMKO2JQvqxce7vBpj5ZvyQK1ZCCUJRCPx1Ie33dZV6zseJ3jm
        fPRx28PctedONprJSSfZRr4ioDEO0/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-FbFMmpNeNgW9eXHRb0esVQ-1; Tue, 12 Jan 2021 15:00:18 -0500
X-MC-Unique: FbFMmpNeNgW9eXHRb0esVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 632211DE0E;
        Tue, 12 Jan 2021 20:00:11 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5BB378206;
        Tue, 12 Jan 2021 20:00:09 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com,
        mlevitsk@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by VM instructions
References: <20210112063703.539893-1-wei.huang2@amd.com>
        <X/37QBMHxH8otaMa@google.com>
Date:   Tue, 12 Jan 2021 15:00:09 -0500
In-Reply-To: <X/37QBMHxH8otaMa@google.com> (Sean Christopherson's message of
        "Tue, 12 Jan 2021 11:40:48 -0800")
Message-ID: <jpgsg76kjsm.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:
...
>> -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
>> -	    !is_vmware_backdoor_opcode(ctxt)) {
>> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>> -		return 1;
>> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
>> +		vminstr = is_vm_instr_opcode(ctxt);
>> +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
>> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>> +			return 1;
>> +		}
>> +		if (vminstr)
>> +			return vminstr;
>
> I'm pretty sure this doesn't correctly handle a VM-instr in L2 that hits a bad
> L0 GPA and that L1 wants to intercept.  The intercept bitmap isn't checked until
> x86_emulate_insn(), and the vm*_interception() helpers expect nested VM-Exits to
> be handled further up the stack.
>
So, the condition is that L2 executes a vmload and #GPs on a reserved address, jumps to L0 - L0 doesn't
check if L1 has asked for the instruction to be intercepted and goes on with emulating
vmload and returning back to L2 ?

>>  	}
>>  
>>  	/*
>> -- 
>> 2.27.0
>> 

