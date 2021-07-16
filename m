Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274CF3CB578
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 11:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhGPJzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 05:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230360AbhGPJzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 05:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626429136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb4R+JVoagpsb7WH3nwCiNnKAH31HT4aNCBqTWasD8c=;
        b=QFPxxgzuUDD72Q5SSvalruNCTh6biu9CK3lvCCRhb+UrcfqW1Da3hqwW2woU/kuxZd1zGF
        x7UswQHXHPwbYGjobXXynZ03E+OG7p8PUJeoGzAXrZMXVHjC5DTOUoudhCk5pAUBj8prP1
        b8nFFk2kFcRtMPOP36HeFndl917I/C8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-cRQoqPi-MwuPJSKH7S31xw-1; Fri, 16 Jul 2021 05:52:14 -0400
X-MC-Unique: cRQoqPi-MwuPJSKH7S31xw-1
Received: by mail-wr1-f69.google.com with SMTP id h11-20020adffa8b0000b029013a357d7bdcso4602339wrr.18
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 02:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fb4R+JVoagpsb7WH3nwCiNnKAH31HT4aNCBqTWasD8c=;
        b=Fi8g8b4HibHOWTLD4Oq0Se7YLxfPnMXLUvL+bDWmmAHxNTiz/GSQ++UfeGPrQtff4H
         lCKdIxtRjlqNYaUAnnqUPjgtrCfPARoq3JZ1DnxOBVithKW35IaqpKhpuCDGdMWJtUhr
         0gEGETOikDyw+xhCzDkj/TQD+8qI58QcfGpTVpWkxn/z7b4Qia7ulLVGeDyrHCcQmtFZ
         nBad94JLeI/QoiqY4UB2x9uZe+wH7jlKFiCvKy/u8WzaZaFzqnUYULSPYmqunmL0Ap6Z
         +OqySDQ8jsnXdTILTA3KWLHJscL3gqO5K2h2+A5lE39jlGCztzpDMSt6mgaQ8CrLZxPZ
         nIRA==
X-Gm-Message-State: AOAM532LvD1nNil8y67A0z6BPtURsrsFk7iElFl12eqwH1r+/9biQnod
        2HOG+II1HFo95Hzj0ZBY9WQFw6qjDLu0dyMuMuS67VCg/x8/1dsrCJVBHGLVW60vVMn18zC6LMK
        7tGFz3owY/Ra6
X-Received: by 2002:a05:600c:4f96:: with SMTP id n22mr9486993wmq.137.1626429133664;
        Fri, 16 Jul 2021 02:52:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4PzoAhnSdzpCYK7ODLnh30V49UUpOf9H5Ht+rIvB4Eqa05Jn7dZdV6hgU0Y5jzzVByP7LiQ==
X-Received: by 2002:a05:600c:4f96:: with SMTP id n22mr9486968wmq.137.1626429133409;
        Fri, 16 Jul 2021 02:52:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id c125sm12505903wme.36.2021.07.16.02.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 02:52:12 -0700 (PDT)
To:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-7-guang.zeng@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/6] KVM: VMX: enable IPI virtualization
Message-ID: <8aed2541-082d-d115-09ac-e7fcc05f96dc@redhat.com>
Date:   Fri, 16 Jul 2021 11:52:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716064808.14757-7-guang.zeng@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/21 08:48, Zeng Guang wrote:
>  
> +	if (!(_cpu_based_3rd_exec_control & TERTIARY_EXEC_IPI_VIRT))
> +		enable_ipiv = 0;
> +
>   	}

Please move this to hardware_setup(), using a new function 
cpu_has_vmx_ipiv() in vmx/capabilities.h.

>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
> -		u64 opt3 = 0;
> +		u64 opt3 = enable_ipiv ? TERTIARY_EXEC_IPI_VIRT : 0;
>  		u64 min3 = 0;

I like the idea of changing opt3, but it's different from how 
setup_vmcs_config works for the other execution controls.  Let me think 
if it makes sense to clean this up, and move the handling of other 
module parameters from hardware_setup() to setup_vmcs_config().

> +
> +	if (vmx->ipiv_active)
> +		install_pid(vmx);

This should be if (enable_ipiv) instead, I think.

In fact, in all other places that are using vmx->ipiv_active, you can 
actually replace it with enable_ipiv; they are all reached only with 
kvm_vcpu_apicv_active(vcpu) == true.

> +	if (!enable_apicv) {
> +		enable_ipiv = 0;
> +		vmcs_config.cpu_based_3rd_exec_ctrl &= ~TERTIARY_EXEC_IPI_VIRT;
> +	}

The assignment to vmcs_config.cpu_based_3rd_exec_ctrl should not be 
necessary; kvm_vcpu_apicv_active will always be false in that case and 
IPI virtualization would never be enabled.

Paolo

