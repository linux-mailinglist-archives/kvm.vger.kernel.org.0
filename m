Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14191EE6FE
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgFDOxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:53:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36216 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729089AbgFDOxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 10:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591282419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bkjkczUAegkCYVD3I4mCfLncEzS/Hv9PCrfpe6zg2Qc=;
        b=euwto6D0u9JHGEseNQiyp9G02CnNzRLHmrPR8bJ9X6pia7i7M1IlHOWmgzCKPrPaAbPkCv
        mtHARKKEgqSC8aU7mSI8kkSvDgGM/fGC3ItBY+EmhLETE/cPSsHk0QZRoG/+gPhJ0VF8EE
        iAMiGWqCFl2TaLjIYDIZv31MaYwVQac=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-4XDp9e4mMsak_2XbKux-HA-1; Thu, 04 Jun 2020 10:53:38 -0400
X-MC-Unique: 4XDp9e4mMsak_2XbKux-HA-1
Received: by mail-ej1-f72.google.com with SMTP id op14so2254852ejb.15
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 07:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bkjkczUAegkCYVD3I4mCfLncEzS/Hv9PCrfpe6zg2Qc=;
        b=CTbx7LusK6RkGN9RD2pyo4KB6j3UWQq7uNDNgXhQvs5daRditCQrsXg3MPx2X4RgsN
         NguBvjVX/xxsMCRdzXhm18OOXSWr47n5DO1PvfTGSkSYz/LztsI6knXD7qgCsfDOJ/EG
         Ds4RwOiKSM1T8F2SO0oV8ym9X3KV83vh/Oly2CH3DDkYnM+opYfkKlrlk31AM9FSW81V
         80+BjtxQmroZkrJJiqA0j3tnNVHvXVcy71ZAgZUJ23wjI6C/ATevtMHSDUHaT6ojiay9
         +9x3+l843iDca2iAsWLpZ1mpxl/eH3lusP2vOlQ8f7Ehj4CeBu/tKcjLlcdzob/vZfie
         kKDQ==
X-Gm-Message-State: AOAM533ICE5snZCP7+WHwP9Pdo7+BL2NRI8TIDiiquliwbtm9MgKXrkD
        33aELQbIaBuOT+mX0XOOrJO6bm0FiR90v4AIEaeWivXuN5OSh9zgIwmmXw0daMV23eZHqJdRl1T
        8/gkxFFxWgwHx
X-Received: by 2002:a05:6402:1d96:: with SMTP id dk22mr4850218edb.258.1591282416848;
        Thu, 04 Jun 2020 07:53:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdUWD/soPlYgGL8mgklo+O0gr8pBKIXLBPJA28P88u/VAkfY5QZj9Zn762qCiARN2fkqYzVQ==
X-Received: by 2002:a05:6402:1d96:: with SMTP id dk22mr4850191edb.258.1591282416533;
        Thu, 04 Jun 2020 07:53:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ce16sm2313704ejb.76.2020.06.04.07.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 07:53:36 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails to read guest memory
In-Reply-To: <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
References: <20200604143158.484651-1-vkuznets@redhat.com> <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
Date:   Thu, 04 Jun 2020 16:53:35 +0200
Message-ID: <87mu5ievbk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 04/06/20 16:31, Vitaly Kuznetsov wrote:
>> Syzbot reports the following issue:
>> 
>> WARNING: CPU: 0 PID: 6819 at arch/x86/kvm/x86.c:618 kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
>> ...
>> Call Trace:
>> ...
>> RIP: 0010:kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
>> ...
>>  nested_vmx_get_vmptr+0x1f9/0x2a0 arch/x86/kvm/vmx/nested.c:4638
>>  handle_vmon arch/x86/kvm/vmx/nested.c:4767 [inline]
>>  handle_vmon+0x168/0x3a0 arch/x86/kvm/vmx/nested.c:4728
>>  vmx_handle_exit+0x29c/0x1260 arch/x86/kvm/vmx/vmx.c:6067
>> 
>> 'exception' we're trying to inject with kvm_inject_emulated_page_fault() comes from
>>   nested_vmx_get_vmptr()
>>    kvm_read_guest_virt()
>>      kvm_read_guest_virt_helper()
>>        vcpu->arch.walk_mmu->gva_to_gpa()
>> 
>> but it is only set when GVA to GPA conversion fails. In case it doesn't but
>> we still fail kvm_vcpu_read_guest_page(), X86EMUL_IO_NEEDED is returned and
>> nested_vmx_get_vmptr() calls kvm_inject_emulated_page_fault() with zeroed
>> 'exception'. This happen when e.g. VMXON/VMPTRLD/VMCLEAR argument is MMIO.
>> 
>> KVM could've handled the request correctly by going to userspace and
>> performing I/O but there doesn't seem to be a good need for such requests
>> in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
>> anything but normal memory. Just inject #GP to find insane ones.
>> 
>> Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 9c74a732b08d..05d57c3cb1ce 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4628,14 +4628,29 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
>>  {
>>  	gva_t gva;
>>  	struct x86_exception e;
>> +	int r;
>>  
>>  	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
>>  				vmcs_read32(VMX_INSTRUCTION_INFO), false,
>>  				sizeof(*vmpointer), &gva))
>>  		return 1;
>>  
>> -	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
>> -		kvm_inject_emulated_page_fault(vcpu, &e);
>> +	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
>> +	if (r != X86EMUL_CONTINUE) {
>> +		if (r == X86EMUL_PROPAGATE_FAULT) {
>> +			kvm_inject_emulated_page_fault(vcpu, &e);
>> +		} else {
>> +			/*
>> +			 * X86EMUL_IO_NEEDED is returned when kvm_vcpu_read_guest_page()
>> +			 * fails to read guest's memory (e.g. when 'gva' points to MMIO
>> +			 * space). While KVM could've handled the request correctly by
>> +			 * exiting to userspace and performing I/O, there doesn't seem
>> +			 * to be a real use-case behind such requests, just inject #GP
>> +			 * for now.
>> +			 */
>> +			kvm_inject_gp(vcpu, 0);
>> +		}
>> +
>>  		return 1;
>>  	}
>>  
>> 
>
> Hi Vitaly,
>
> looks good but we need to do the same in handle_vmread, handle_vmwrite,
> handle_invept and handle_invvpid.  Which probably means adding something
> like nested_inject_emulation_fault to commonize the inner "if".
>

Oh true, I've only looked at nested_vmx_get_vmptr() users to fix the
immediate issue. Will do v2.

-- 
Vitaly

