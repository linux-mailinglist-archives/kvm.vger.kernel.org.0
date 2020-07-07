Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E5C2167FC
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 10:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgGGIEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 04:04:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbgGGIEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 04:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594109083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0mh35xkHSMPfz/goX6QsqA4ztMFVQSPiIBdm0V+Pjk=;
        b=avVadxlMk+/s21ltuk7iySbbwbsfgj2WsREp//SEzDPdnntlAr//E8CU8CnNAN5ithFaJi
        aV0wmpcvA9grwLCg3N4y+lPhZNdy5M9Zq8eeUVANd0tQczodIu1SGiJ2/Y/Jvd8srcJo+O
        QJ8l47Bpp6Xl0J0k19on2wogPt63D3k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-M1bsMUcyMBOQQxhRwS8DOg-1; Tue, 07 Jul 2020 04:04:41 -0400
X-MC-Unique: M1bsMUcyMBOQQxhRwS8DOg-1
Received: by mail-wr1-f72.google.com with SMTP id d11so30388938wrw.12
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 01:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0mh35xkHSMPfz/goX6QsqA4ztMFVQSPiIBdm0V+Pjk=;
        b=YcGpShKpsJOygtaxr+4j4+3K0HS3etWSg4xJ5+yiscFXMwL+K8YNWa+glBghoPn6k2
         Nz6MIgHc/yn9kKtr0vPq99Lz6kMqQ95UITaxFaeeShJ7O3dP2RRpD9dtxdEgFz6KmTT5
         b3Uy4FRCJlHXftKrEk7Iu/MxOkmgyEDMf1HCp/StMpiO6g+S9uW93EqThk7u0v+ejxnT
         Y5tP/TLzMu1PbXaPFJ8KZ27D0uX4nJd5xlRoFDAqjUjD1jXjKt24mFcWx2UpiMgGe+37
         zSdL0g95LCMyrdx62R8lC6BaXAbu5jeJc3z4YL/xYXGNuTTWB5pfSP7mvw74T437l2HD
         b1ow==
X-Gm-Message-State: AOAM533Hlq4ntRda/FGPU01DWyrcDsQnuDWuFUkA068VkSmvmXeh5oVJ
        GawpqsQeSGZa50nqTn0e95NE80lhTP6+zkQVDA/XD7FLaE98K1tZygTFpjhsJc3g0wz9J0bd/la
        KCXYi2WLr/9lV
X-Received: by 2002:a1c:2157:: with SMTP id h84mr2804181wmh.35.1594109080791;
        Tue, 07 Jul 2020 01:04:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEXYEc8WO2QrC4l1AhnZ0dwyI2sMS9xYnpCs4+uKJSHDlLUn+io3PXSQkdxcCMVou80aHRHA==
X-Received: by 2002:a1c:2157:: with SMTP id h84mr2802969wmh.35.1594109064788;
        Tue, 07 Jul 2020 01:04:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e95f:9718:ec18:4c46? ([2001:b07:6468:f312:e95f:9718:ec18:4c46])
        by smtp.gmail.com with ESMTPSA id b62sm2419356wmh.38.2020.07.07.01.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 01:04:24 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
Date:   Tue, 7 Jul 2020 10:04:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707061105.GH5208@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 08:11, Sean Christopherson wrote:
> One oddity with this whole thing is that by passing through the MSR, KVM is
> allowing the guest to write bits it doesn't know about, which is definitely
> not normal.  It also means the guest could write bits that the host VMM
> can't.

That's true.  However, the main purpose of the kvm_spec_ctrl_valid_bits
check is to ensure that host-initiated writes are valid; this way, you
don't get a #GP on the next vmentry's WRMSR to MSR_IA32_SPEC_CTRL.
Checking the guest CPUID bit is not even necessary.

Paolo

> Somehwat crazy idea inbound... rather than calculating the valid bits in
> software, what if we throw the value at the CPU and see if it fails?  At
> least that way the host and guest are subject to the same rules.  E.g.
> 
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2062,11 +2062,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                     !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>                         return 1;
> 
> -               if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
> -                       return 1;
> -
> +               ret = 0;
>                 vmx->spec_ctrl = data;
> -               if (!data)
> +
> +               local_irq_disable();
> +               if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &data))
> +                       ret = 1;
> +               else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, vmx->spec_ctrl))
> +                       ret = 1;
> +               else
> +                       wrmsrl(MSR_IA32_SPEC_CTRL, data))
> +               local_irq_enable();
> +
> +               if (ret || !vmx->spec_ctrl)
>                         break;
> 
>                 /*
> 

