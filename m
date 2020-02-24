Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38A616AA4D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgBXPjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:39:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26451 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727736AbgBXPjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 10:39:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582558754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ddo4zTy9kohv7vcxaNjRWh45qs6RB8g9+hhdp7Haxl4=;
        b=VEdYE2/CwowAL9CBqh+7/4k1u4qXejLTIGgD+K5NQOB8bZ43S3XU/quebnwFQp3k+Ga/7U
        wC5k9ag5Rl8TFG/VDBjME1NhCnf3lWEPkyVvrRvt0ayxmduuAJHc+muapys3Toa5YCPJAN
        IUgsnC+NW4n92FSel5GaHa5oTDAkGV4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-i9-O2vPjMv2OS_I4bdVtVA-1; Mon, 24 Feb 2020 10:39:10 -0500
X-MC-Unique: i9-O2vPjMv2OS_I4bdVtVA-1
Received: by mail-wr1-f70.google.com with SMTP id d15so5778967wru.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ddo4zTy9kohv7vcxaNjRWh45qs6RB8g9+hhdp7Haxl4=;
        b=eVXR4ydNe4rZEbHdh/Cy9YsLKxC5naVZzt3584FuecfMNRLy+dqr+Mv6nTGN3c3FVb
         DWAIoVvVbQiLGVjNfNVAubt1sccUeZsNk45w7AI4r3C1KQV1VM8GTDRd5blhG9Wy/OUL
         pDF4j9gucHoBi1O9zlxvYYfopTaP4BiSzpuEa/y0k/I0ehftBmEsjst+d5TCT6k39XTp
         1Hddr1z9w+1yDrbj+/n1OLGHd18TOkY7L7j2ArAh+siJxIH5s5darOkhyN+0EcDP3J/b
         jz1SneADmt5ZnGJL3k4ZYmOjSsWPgppjTJ3XknMVi+ZVBxkCQrmPyf8wlkyu5G+rUyhB
         xszw==
X-Gm-Message-State: APjAAAX9h2w7Wu6LkYMD1J1sRVnT4r7TJtFRjy7zCDcBG5X6IG3NH/Wx
        z5yKAP9y3w/2MsZJwsn+I6l/XCasMYXvFdULxgK6XLyMD3FtEbMLi6yWoXy1tD9/9VdiI6lIGbN
        8DvnqxirC1tOZ
X-Received: by 2002:adf:f586:: with SMTP id f6mr64690534wro.46.1582558748992;
        Mon, 24 Feb 2020 07:39:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/n0QwrYWVp/915whGBoyMjNRD9DraOLZjnMyIscER1XCgM5QXhvW6xCBl8B80g0y5p7Ffcg==
X-Received: by 2002:adf:f586:: with SMTP id f6mr64690519wro.46.1582558748783;
        Mon, 24 Feb 2020 07:39:08 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id m125sm19195001wmf.8.2020.02.24.07.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:39:08 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 37/61] KVM: x86: Refactor handling of XSAVES CPUID adjustment
In-Reply-To: <20200201185218.24473-38-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-38-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:39:07 +0100
Message-ID: <87k14cngf8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Invert the handling of XSAVES, i.e. set it based on boot_cpu_has() by
> default, in preparation for adding KVM cpu caps, which will generate the
> mask at load time before ->xsaves_supported() is ready.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c74253202af8..20a7af320291 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -422,7 +422,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	unsigned f_gbpages = 0;
>  	unsigned f_lm = 0;
>  #endif
> -	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
>  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  
>  	/* cpuid 1.edx */
> @@ -479,7 +478,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  
>  	/* cpuid 0xD.1.eax */
>  	const u32 kvm_cpuid_D_1_eax_x86_features =
> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES);
>  
>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
> @@ -610,6 +609,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  
>  		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
>  		cpuid_entry_mask(entry, CPUID_D_1_EAX);
> +
> +		if (!kvm_x86_ops->xsaves_supported())
> +			cpuid_entry_clear(entry, X86_FEATURE_XSAVES);
> +
>  		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
>  			entry->ebx = xstate_required_size(supported_xcr0, true);
>  		else

I was going to ask if this can be moved to set_supported_cpuid() for
both VMX and SVM but then I realized this is just a temporary change.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

