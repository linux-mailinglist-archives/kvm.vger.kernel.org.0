Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39333BD8A0
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhGFOpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:45:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232411AbhGFOpW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:45:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=McsgxVcRwZrz3jkI4WiryERrD7OS3yQzBONl/84ETUg=;
        b=cePA5evLPHKlPPRJ9V+chefLgPkKw1NnuF/QEqy35Z3IkDX8VCwpQ967Zylh4mE8XsqXZn
        ip5DQsAA3KkW/2xQyq+njpd/8w9o693ayuR3zLte80cVw+Jg5cVt5r7rOQnqC/VYejgr6d
        Lj3ansqMBYyqr2HIMQHHAzH08quGbP8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-NHO9jiPaO_G_nYjptYXdAA-1; Tue, 06 Jul 2021 10:42:42 -0400
X-MC-Unique: NHO9jiPaO_G_nYjptYXdAA-1
Received: by mail-ed1-f69.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so10922449edt.13
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=McsgxVcRwZrz3jkI4WiryERrD7OS3yQzBONl/84ETUg=;
        b=VzIBC3mlmdV8XqqSF+MA2+XF9GABAkR9jNEEKktf/uLPs+2kLKYyP56S8ExfMEMLAo
         uvTG1LqUF1h8/IqXoTZqiAT0dRKQeHhtYDK2WHym/cplFylX9FtGS9q7DX15NGKCdrXQ
         vFWp/XoCHUpt4YrO6Phk/btW1D6bTSCXUPoVLK6FaOSaUTVrMc8CI4fLkyWezsNOMWfL
         1cR/0r5dSIWaLny3sktzmF8Fw/epAlviCzXOxvgxifkGKpFXKQnDPL3ypulLpfIEKLD2
         42oN8VV+kAgUgR6bsg64N7wRrq1aFx2m2nHUrwP6BVAzEPeMK8YWonNe+TSzEqGBRk/C
         v1xQ==
X-Gm-Message-State: AOAM530XQwpsx0IztlIhHHhjgbOFoRP6IqkncUMdvihaOsalDXGzm+hf
        ZxkZsNypX7BDn+EBX9pAYFk2UJFXcL9pCNCA3ThlyNnxKq+szenamBoWhjytq7w4KNJOlSyppru
        zHJDdX/tYGivH
X-Received: by 2002:a17:906:3693:: with SMTP id a19mr9903336ejc.237.1625582561747;
        Tue, 06 Jul 2021 07:42:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwbxWvwp60kqcqhky9/mwQk1xdW/Xhxe5g5Ux3YtstsLMjGM27875BD0OAV+jSW3dCDxig/w==
X-Received: by 2002:a17:906:3693:: with SMTP id a19mr9903309ejc.237.1625582561583;
        Tue, 06 Jul 2021 07:42:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c15sm7354300edu.19.2021.07.06.07.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:42:40 -0700 (PDT)
Subject: Re: [RFC PATCH v2 54/69] KVM: VMX: Define VMCS encodings for shared
 EPT pointer
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <9d24d2d63de110962f85f66ce84250967436f96b.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <56866301-e218-fee4-1b79-2249db5a3bed@redhat.com>
Date:   Tue, 6 Jul 2021 16:42:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9d24d2d63de110962f85f66ce84250967436f96b.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add the VMCS field encoding for the shared EPTP, which will be used by
> TDX to have separate EPT walks for private GPAs (existing EPTP) versus
> shared GPAs (new shared EPTP).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/vmx.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 132981276a2f..56b3d32941fd 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -235,6 +235,8 @@ enum vmcs_field {
>   	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
>   	TSC_MULTIPLIER                  = 0x00002032,
>   	TSC_MULTIPLIER_HIGH             = 0x00002033,
> +	SHARED_EPT_POINTER		= 0x0000203C,
> +	SHARED_EPT_POINTER_HIGH		= 0x0000203D,
>   	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>   	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>   	VMCS_LINK_POINTER               = 0x00002800,
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

