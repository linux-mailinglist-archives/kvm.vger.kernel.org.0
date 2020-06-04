Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826D81EE6CB
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgFDOk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 10:40:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728987AbgFDOk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 10:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591281657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1KzIQ4ZIm1Bb01N7lRD8u70UzbaIWnRS/sElZztpMM=;
        b=KHjk9bULU4G5CfFKm2h6okjaV3V7On4H57erK/itXwwD3OchNGUdZclunTRFNPoywdAwKk
        2JTvCdBZzoozbTJ+vAWpVmIg27/Lb7B89KmZFsC109pb4+Fe98huVHxdRUdZQsnnYNiOqG
        jFOU34+vnE0NSJDmww76IuWo7KxQ0mU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-QgVxDvy2MKK-DTd9I6ZS6g-1; Thu, 04 Jun 2020 10:40:55 -0400
X-MC-Unique: QgVxDvy2MKK-DTd9I6ZS6g-1
Received: by mail-wr1-f72.google.com with SMTP id c14so2497828wrw.11
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 07:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T1KzIQ4ZIm1Bb01N7lRD8u70UzbaIWnRS/sElZztpMM=;
        b=lxSGW/ADBxwJ0L76rWlJoV+2PCncl1k0kyIkNtO3HPiXEiqGVqhc5M77leCpqT6hWm
         wu7vQh+zYvPo09SbrxgUPJOjboYOPc6ZCpZp1hBMnc+H8FW+bYK635SzadwlgxW7xXH2
         g2Cjndzgi/KmGIT7+uzN6gn2DMwzHcFn/ia6SbwpZW+QKRiEi6xl9dJZborsoNfIvtwN
         jmlpvz1FgTjtVmmbWpp78EZpuoMNHsofxsHSpA6kH5n9FGX2JlX9Ty1R3felkK8xVPff
         pyw0FtmvASIGyhAkl1SFXNVm7TPsPIvATRjuVFHSKa3xwrsNBwGZGU6CAh6OuhekAQKP
         OWww==
X-Gm-Message-State: AOAM531HazYCmHWzJ9DfLNdLrGemfOYtbBX9fLCggvwbbpaMEM//bCN+
        3xKKEYmS/v4E/eFRJ8j+hUo1Qg26kVU3ozE0MHJjpXyCpq2BDSsBC0bCV3tPP4q+mjVtNocdTUk
        Y6VLmhnfwuHWz
X-Received: by 2002:a5d:4f09:: with SMTP id c9mr4622974wru.3.1591281654236;
        Thu, 04 Jun 2020 07:40:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0T3+36Rp24qdkIttu0E+JI6/N5toSssvU3HegZCFxjFGCHGF+T9y5wmhzxGSCEXHDXbg8JA==
X-Received: by 2002:a5d:4f09:: with SMTP id c9mr4622958wru.3.1591281653985;
        Thu, 04 Jun 2020 07:40:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id 23sm7275756wmg.10.2020.06.04.07.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 07:40:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails
 to read guest memory
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200604143158.484651-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
Date:   Thu, 4 Jun 2020 16:40:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200604143158.484651-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 16:31, Vitaly Kuznetsov wrote:
> Syzbot reports the following issue:
> 
> WARNING: CPU: 0 PID: 6819 at arch/x86/kvm/x86.c:618 kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
> ...
> Call Trace:
> ...
> RIP: 0010:kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
> ...
>  nested_vmx_get_vmptr+0x1f9/0x2a0 arch/x86/kvm/vmx/nested.c:4638
>  handle_vmon arch/x86/kvm/vmx/nested.c:4767 [inline]
>  handle_vmon+0x168/0x3a0 arch/x86/kvm/vmx/nested.c:4728
>  vmx_handle_exit+0x29c/0x1260 arch/x86/kvm/vmx/vmx.c:6067
> 
> 'exception' we're trying to inject with kvm_inject_emulated_page_fault() comes from
>   nested_vmx_get_vmptr()
>    kvm_read_guest_virt()
>      kvm_read_guest_virt_helper()
>        vcpu->arch.walk_mmu->gva_to_gpa()
> 
> but it is only set when GVA to GPA conversion fails. In case it doesn't but
> we still fail kvm_vcpu_read_guest_page(), X86EMUL_IO_NEEDED is returned and
> nested_vmx_get_vmptr() calls kvm_inject_emulated_page_fault() with zeroed
> 'exception'. This happen when e.g. VMXON/VMPTRLD/VMCLEAR argument is MMIO.
> 
> KVM could've handled the request correctly by going to userspace and
> performing I/O but there doesn't seem to be a good need for such requests
> in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
> anything but normal memory. Just inject #GP to find insane ones.
> 
> Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9c74a732b08d..05d57c3cb1ce 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4628,14 +4628,29 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
>  {
>  	gva_t gva;
>  	struct x86_exception e;
> +	int r;
>  
>  	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
>  				vmcs_read32(VMX_INSTRUCTION_INFO), false,
>  				sizeof(*vmpointer), &gva))
>  		return 1;
>  
> -	if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
> -		kvm_inject_emulated_page_fault(vcpu, &e);
> +	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
> +	if (r != X86EMUL_CONTINUE) {
> +		if (r == X86EMUL_PROPAGATE_FAULT) {
> +			kvm_inject_emulated_page_fault(vcpu, &e);
> +		} else {
> +			/*
> +			 * X86EMUL_IO_NEEDED is returned when kvm_vcpu_read_guest_page()
> +			 * fails to read guest's memory (e.g. when 'gva' points to MMIO
> +			 * space). While KVM could've handled the request correctly by
> +			 * exiting to userspace and performing I/O, there doesn't seem
> +			 * to be a real use-case behind such requests, just inject #GP
> +			 * for now.
> +			 */
> +			kvm_inject_gp(vcpu, 0);
> +		}
> +
>  		return 1;
>  	}
>  
> 

Hi Vitaly,

looks good but we need to do the same in handle_vmread, handle_vmwrite,
handle_invept and handle_invvpid.  Which probably means adding something
like nested_inject_emulation_fault to commonize the inner "if".

Thanks,

Paolo

