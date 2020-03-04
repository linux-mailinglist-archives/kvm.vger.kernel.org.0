Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AC21791D4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgCDN6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 08:58:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728244AbgCDN6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 08:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583330318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3kAy1mxF/iEPG19osRMx+mDCDQEPCAf6CYbZmlawD5s=;
        b=CwsCtZsHXYnZQko0+RvwJWgb8RPC2tU31xwlVHDHyZCitk9rwl7II8sVK8NsJNORdbO1pZ
        DnYvlFmXv9InliLNV3rTEzNXTqZjnJBuhb/d9OvDVql7fYGJTubZvp9XOL1oGuh8qMkYUy
        z/5HQ6UZ+foy2yNnbMfTu/sVLXlDUbI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-u_AWJSjtOkWr0ERFWplIRQ-1; Wed, 04 Mar 2020 08:58:36 -0500
X-MC-Unique: u_AWJSjtOkWr0ERFWplIRQ-1
Received: by mail-wr1-f72.google.com with SMTP id w11so874651wrp.20
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 05:58:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3kAy1mxF/iEPG19osRMx+mDCDQEPCAf6CYbZmlawD5s=;
        b=N8AUbjssprUSprbVZPed6SN62qQ9xtaE4juTin4M5fVQ1URs2R+njKQQSRTAQgYug4
         q+ZQIeYpn+iyYfLXRuQz85CaFR5VSsmLvYKXsLILLx3Gw4JlKkepn8xacWyrZ9LxCGZq
         N48BvLHuXw/zC/UkAoeRWQuKep/Zlds4EMjVvvn4DLX+LttDzx3iUqOvolylasN4wd9P
         eGm80cryFaH5aHC20tGvaQy6nLe3sHNMVH+W1SwevbPU2FNB7vTBG4a95m2g5H/Fy6SB
         zS7u5Fb6ZWgjP1uRpa0phtXYg8PsWYBabUKQLprWeZCJE5NcekhJiXk8W7ALcMPizVxL
         h37g==
X-Gm-Message-State: ANhLgQ21rzoRebNAuC28MU2VQ1vlpdmBvCyNah3eZ3JDjEV7K8wY0kRo
        gofjAnQkOV9yYdSKX57fBKAwM8p3eY5mUG0oo0akftzYfYKXnLcLJRIprbih+u1VTpyj7hwGgmH
        EbCGpL9ucFHWb
X-Received: by 2002:a1c:81d3:: with SMTP id c202mr3940566wmd.79.1583330299932;
        Wed, 04 Mar 2020 05:58:19 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuPNTWTD9RI+ams7yAcbxDxktjcz32mFc5odev+35OalYkzB+bvFzZUTHmXpFcCSIo1WOJbOg==
X-Received: by 2002:a1c:81d3:: with SMTP id c202mr3940540wmd.79.1583330299654;
        Wed, 04 Mar 2020 05:58:19 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k66sm1744965wmf.0.2020.03.04.05.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:58:19 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v1 2/3] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
In-Reply-To: <20200303130356.50405-3-arilou@gmail.com>
References: <20200303130356.50405-1-arilou@gmail.com> <20200303130356.50405-3-arilou@gmail.com>
Date:   Wed, 04 Mar 2020 14:58:18 +0100
Message-ID: <87pndsdxxh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
> page and simply identifies the CPU being used (AMD/Intel) and according
> to it simply makes hypercalls with the relevant instruction
> (vmmcall/vmcall respectively).
>
> The relevant function in kdvm is KdHvConnectHypervisor which first checks
> if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
> and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
> 0x1000101010001 which means:
> build_number = 0x0001
> service_version = 0x01
> minor_version = 0x01
> major_version = 0x01
> os_id = 0x00 (Undefined)
> vendor_id = 1 (Microsoft)
> os_type = 0 (A value of 0 indicates a proprietary, closed source OS)
>
> and starts issuing the hypercall without setting the hypercall page.
>
> To resolve this issue simply enable hypercalls if the guest_os_id is
> not 0.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 13176ec23496..7ec962d433af 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1615,7 +1615,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>  
>  bool kvm_hv_hypercall_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
> +	return READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0;
>  }
>  
>  static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)

I would've enabled it in both cases,

return (READ_ONCE(kvm->arch.hyperv.hv_hypercall) &
 HV_X64_MSR_HYPERCALL_ENABLE) || (READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0);

to be safe. We can also check what genuine Hyper-V does but I bet it has
hypercalls always enabled. Also, the function can be made inline,
there's a single caller.

-- 
Vitaly

