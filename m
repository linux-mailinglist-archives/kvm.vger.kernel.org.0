Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AA41EE5E4
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgFDNv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 09:51:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58021 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728673AbgFDNv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 09:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591278714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uoBbK+k/e+AuoAPCRkXj1uUT4I78qfeUjU2XWnILoIk=;
        b=HgYOgTg6PhdWyrgCQPShrtR7aMOU00besmWhzi/LYi5SkiqAFVhYSzl+AhHiOJdnIgu6bs
        yUPZTP5qYQdVNu3bpksl7WvPqReg+afU74pnnA5ZIts08vPK3bt7ocH8x07+x/k9MnVKN1
        K0/wVVjIDxbhMq6VKuzo4AKWUVafHTc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-UOQ0XAYJPHq3076fmMcAxQ-1; Thu, 04 Jun 2020 09:51:53 -0400
X-MC-Unique: UOQ0XAYJPHq3076fmMcAxQ-1
Received: by mail-ej1-f69.google.com with SMTP id b24so439337ejb.8
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 06:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uoBbK+k/e+AuoAPCRkXj1uUT4I78qfeUjU2XWnILoIk=;
        b=XPvr+mjQ+Lb3TeL9G39vxdMHaverAH1w34YNfmUVJnHh5ZZ5GYy2QeTH+bFv0XzmZq
         cXQVeTm8ChkebGs5LOplfpNXfhrDxHjEA85FE02qQPNIHzKLyd1g4b3Fd7+QVNQOtk6A
         2UA/q4xMuro1sxbdJGCcwpNZ5wmg/JL9IWAa49Sc0u3vD6CgdBv5i9Oc2p38/SMBa0R5
         3RtSA67Wot2nIkTc9Fk/q6Kl64dcJbtR46aL/7it/03rHG3pocTK7gLnWkRtb7EwE4uL
         dlCuDCdwIPBDGoZJqSUC/ThZY/I+SvJvk6B7KZLLYVXnHyT2DmV27HonTl98mRumh3/d
         X9iA==
X-Gm-Message-State: AOAM532hB+q//5Rt8kNfnxlmLUVpkZ79NrMXTjeGw1VfqCGDkLLl96A8
        JG7/VYEWoqVgFdRBT3KPnDvVM8Lypl+wBxVbDNjldbVLRifedesAQ0G5mkwkTUJrlxf5G0SbM+5
        iFDqzs/K74XUK
X-Received: by 2002:a17:906:600a:: with SMTP id o10mr4167143ejj.544.1591278711819;
        Thu, 04 Jun 2020 06:51:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkhvrr1Z3DJSvE7lNzp5tFHZLM8W0ufwGZImUkNGsEK/WAYS3w5CFLIRBWKO129vYIZniR9g==
X-Received: by 2002:a17:906:600a:: with SMTP id o10mr4167129ejj.544.1591278711610;
        Thu, 04 Jun 2020 06:51:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c9sm2278785ejx.98.2020.06.04.06.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 06:51:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com
Cc:     syzbot <syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        wanpengli@tencent.com, x86@kernel.org
Subject: Re: WARNING in kvm_inject_emulated_page_fault
In-Reply-To: <c15b3ad0-0062-f106-0746-d018cf33adbb@redhat.com>
References: <000000000000c8a76e05a73e3be3@google.com> <874krrf6ga.fsf@vitty.brq.redhat.com> <c15b3ad0-0062-f106-0746-d018cf33adbb@redhat.com>
Date:   Thu, 04 Jun 2020 15:51:49 +0200
Message-ID: <87pnafdjm2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 04/06/20 12:53, Vitaly Kuznetsov wrote:
>> Exception we're trying to inject comes from
>> 
>>  nested_vmx_get_vmptr()
>>   kvm_read_guest_virt()
>>    kvm_read_guest_virt_helper()
>>      vcpu->arch.walk_mmu->gva_to_gpa()
>> 
>> but it seems it is only set if GVA to GPA convertion fails. In case it
>> doesn't, we can still fail kvm_vcpu_read_guest_page() and return
>> X86EMUL_IO_NEEDED but nested_vmx_get_vmptr() doesn't case what we return
>> and does kvm_inject_emulated_page_fault(). This can happen when VMXON
>> parameter is MMIO, for example.
>> 
>> How do fix this? We can either properly exit to userspace for handling
>> or, if we decide that handling such requests makes little sense, just
>> inject #GP if exception is not set, e.g. 
>> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 9c74a732b08d..a21e2f32f59b 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -4635,7 +4635,11 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
>>                 return 1;
>>  
>>         if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
>> -               kvm_inject_emulated_page_fault(vcpu, &e);
>> +               if (e.vector == PF_VECTOR)
>> +                       kvm_inject_emulated_page_fault(vcpu, &e);
>> +               else
>> +                       kvm_inject_gp(vcpu, 0);
>> +
>>                 return 1;
>>         }
>> 
>
> Yes, this is a plausible fix (with a comment explaining that we are 
> taking a shortcut).  Perhaps a better check would be 
>
> 	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
> 	if (r != X86EMUL_CONTINUE) {
> 		if (r == X86EMUL_PROPAGATE_FAULT) {
> 			kvm_inject_emulated_page_fault(vcpu, &e);
> 		} else {
> 			/* ... */
> 			kvm_inject_gp(vcpu, 0);
> 		}
> 		return 1;
> 	}
>
> Are you going to send a patch?
>

Sure, will do.

-- 
Vitaly

