Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2366D18598D
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCODDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:03:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727174AbgCODDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584241387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqN7yC9dr/9wjtV7DO9ie1xoABQY+WCqIxj6pMJdRtw=;
        b=Upxqg79/O1faznznI/hU6TVmb7Ysif7PNAOSCSu4jWQAF63kwPdEH4HAWv9suunmHRPAH6
        QH3YnL+QBnor2SlMVGdJ3nUzp30xB8R/lDz3/fmOZDL88e4DdB3ySIxS+9Jm3dFC0XSv2u
        xi8ubutU98pyoKIzIcNFE94kxnkuyI4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-_3sS8LwjMqu4EU-rGeRhLQ-1; Sat, 14 Mar 2020 07:00:24 -0400
X-MC-Unique: _3sS8LwjMqu4EU-rGeRhLQ-1
Received: by mail-wr1-f70.google.com with SMTP id o9so5800129wrw.14
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IqN7yC9dr/9wjtV7DO9ie1xoABQY+WCqIxj6pMJdRtw=;
        b=LpJOvLZCWB4dDCBqtqlNIO6NkHFiyVyTjVK25I6go12CssBbSexoxtT1P+uP0c8cBI
         xv9tSkrkepcenPX/iNzQdfrGOZZ60KL8wPWwtz+BoMwfjfjZElrM48jVfLMGfNR48MY4
         GF7HFP0nfxC3JVXc9IqHcdJ3AG9lrT2R6vGvDK/PeCn5thTDOziAwdFoIqH2HaLdyqdE
         hc16/rBasY7yx7Xvg7nhcUmDyOxngh3euhrJu8BSgwSe8NMWcgFHCC88Ujgstnpn/VEH
         DSaIkNL/7o18lONwJwKp3qD7q7zD+5hc9NiX+6ZieKX26E85rrCk7H+2C012CgeArofu
         +ycg==
X-Gm-Message-State: ANhLgQ3US171SFxUtk5FRIZr0L4z/r6yIagrP5meNcfCiM5fsBr3Br/a
        wDUUnyEmsVSKKrkCUCY+VmLk/3EunPs3MjkMt90A+79gI3pA4TK29pXal+xD3fKDv/N6Z+xM6Tn
        LQvKoiL4cE4o+
X-Received: by 2002:a5d:54ce:: with SMTP id x14mr23165847wrv.353.1584183622987;
        Sat, 14 Mar 2020 04:00:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsb7twEeEjI6N9PLMfvne45vD4UyBWcTtwFAPlo+XiIRsjTK0BGMqrnb5HspCUKm4EPDOwGSw==
X-Received: by 2002:a5d:54ce:: with SMTP id x14mr23165830wrv.353.1584183622716;
        Sat, 14 Mar 2020 04:00:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id r9sm13830690wma.47.2020.03.14.04.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:00:22 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: VMX: Micro-optimize vmexit time when not exposing
 PMU
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1584071718-17163-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0776e1d0-f0e0-68ef-a07c-9a4884ea1498@redhat.com>
Date:   Sat, 14 Mar 2020 12:00:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584071718-17163-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/20 04:55, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> PMU is not exposed to guest by most of products from cloud providers since the 
> bad performance of PMU emulation and security concern. However, it calls 
> perf_guest_switch_get_msrs() and clear_atomic_switch_msr() unconditionally 
> even if PMU is not exposed to the guest before each vmentry. 
> 
> ~2% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my 
> SKX server.
> 
> Before patch:
> vmcall 1559
> 
> After patch:
> vmcall 1529
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * move the check before atomic_switch_perf_msrs
> 
>  arch/x86/kvm/vmx/vmx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40b1e61..b20423c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6567,7 +6567,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	pt_guest_enter(vmx);
>  
> -	atomic_switch_perf_msrs(vmx);
> +	if (vcpu_to_pmu(vcpu)->version)
> +		atomic_switch_perf_msrs(vmx);
>  	atomic_switch_umwait_control_msr(vmx);
>  
>  	if (enable_preemption_timer)
> 

Queued, thanks.

Paolo

