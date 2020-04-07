Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001AA1A0DC0
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 14:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgDGMfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 08:35:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728146AbgDGMfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 08:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586262922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qj/NCHNTy8cKBQLrOFei5N4fXMJmrkSwVdyGWxnI98o=;
        b=LEf9e6hfi1zjsPHLHkGlKHbOEbEptKzB+Y+j1LxCQfEusajd4+BsO9hUnIor1P+w+t2bBW
        j1umIPvA327LESOhnN/gJoGYgAQZ+hjw1I2OEWdxsrVzv8rpKjZRvZyT31DxOpbmcakRqr
        2e1eDp4r8qnrfEQFhN4wlt7nQDbH9t4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-CAlixJRKP6CjF-ItrEMQKg-1; Tue, 07 Apr 2020 08:35:21 -0400
X-MC-Unique: CAlixJRKP6CjF-ItrEMQKg-1
Received: by mail-wm1-f69.google.com with SMTP id s9so554239wmh.2
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 05:35:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qj/NCHNTy8cKBQLrOFei5N4fXMJmrkSwVdyGWxnI98o=;
        b=BOQ7EiW8y0fBSo8abOU3jhSLwDuZJi8+thg8HUJJaIUQm1i/OjSr55QWj11WN4NJUb
         WVGJT+JfqSaBVT5iHi2sd+ImuYpdquPhXeZslmW00N9SGeVOUa6a82eZpGfRgfJ93OBd
         ZXC2psFC2OBVVIFpexHSXLoKd5RlTlJoxz66LZ2gp3YavLeIMVzoWy77+iFTGkmcSWh9
         2bxaj/rhiMcEd5k0WorPwp2mVOUpOJ+BBV6+PmTBQIBB1+Rjyy4dAB/vzVm5hklyWQ1Q
         X6rKWPK4SGGG/qLqRya5lypRm5y0HyXmb4N57yxIRrUDJzvwPjBReTnKp+zzQmGANQvi
         7Duw==
X-Gm-Message-State: AGi0PubhJfO8sdFCy4VPiV8ztg7/3M7HXm2fDB1n3+9pG5npI94vGw6c
        jVg0kwGwBzfXMSTv0+kazfvgPSXvzA9LYc+QXIvlOxBl5EzamSAqFzv3Knndb8DW4RvrFAVLesA
        5KSsmIJGlUq8I
X-Received: by 2002:a7b:cf02:: with SMTP id l2mr2224568wmg.4.1586262920072;
        Tue, 07 Apr 2020 05:35:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypKpOChN8tGzByvwHEKGAyg4BmSbrzIK1wsR3YYnAfmm17DVuuJcLPkB5PdpW+tBGHaK6JYitA==
X-Received: by 2002:a7b:cf02:: with SMTP id l2mr2224546wmg.4.1586262919855;
        Tue, 07 Apr 2020 05:35:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id f1sm32628821wrv.37.2020.04.07.05.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 05:35:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200401081348.1345307-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0c2504c0-8dac-4bbf-bd50-a503be755d3f@redhat.com>
Date:   Tue, 7 Apr 2020 14:35:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200401081348.1345307-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/20 10:13, Vitaly Kuznetsov wrote:
> If KVM wasn't used at all before we crash the cleanup procedure fails with
>  BUG: unable to handle page fault for address: ffffffffffffffc8
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 23215067 P4D 23215067 PUD 23217067 PMD 0
>  Oops: 0000 [#8] SMP PTI
>  CPU: 0 PID: 3542 Comm: bash Kdump: loaded Tainted: G      D           5.6.0-rc2+ #823
>  RIP: 0010:crash_vmclear_local_loaded_vmcss.cold+0x19/0x51 [kvm_intel]
> 
> The root cause is that loaded_vmcss_on_cpu list is not yet initialized,
> we initialize it in hardware_enable() but this only happens when we start
> a VM.
> 
> Previously, we used to have a bitmap with enabled CPUs and that was
> preventing [masking] the issue.
> 
> Initialized loaded_vmcss_on_cpu list earlier, right before we assign
> crash_vmclear_loaded_vmcss pointer. blocked_vcpu_on_cpu list and
> blocked_vcpu_on_cpu_lock are moved altogether for consistency.
> 
> Fixes: 31603d4fc2bb ("KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3aba51d782e2..39a5dde12b79 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2257,10 +2257,6 @@ static int hardware_enable(void)
>  	    !hv_get_vp_assist_page(cpu))
>  		return -EFAULT;
>  
> -	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> -	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> -
>  	r = kvm_cpu_vmxon(phys_addr);
>  	if (r)
>  		return r;
> @@ -8006,7 +8002,7 @@ module_exit(vmx_exit);
>  
>  static int __init vmx_init(void)
>  {
> -	int r;
> +	int r, cpu;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	/*
> @@ -8060,6 +8056,12 @@ static int __init vmx_init(void)
>  		return r;
>  	}
>  
> +	for_each_possible_cpu(cpu) {
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +		INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> +		spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> +	}
> +
>  #ifdef CONFIG_KEXEC_CORE
>  	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
>  			   crash_vmclear_local_loaded_vmcss);
> 

Queued, thanks.

Paolo

