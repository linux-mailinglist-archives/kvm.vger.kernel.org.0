Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4582155B36
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBGPzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:55:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47616 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbgBGPzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 10:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581090904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QFBH+I3pZxSE3/nW8uXkPGgglj6CkLzBvtfEOuG6ltU=;
        b=KA1DBU6RgRUjv/ZPdlxEZMBEBldFg56KQHL16GMgq38CK6zzDn1RGbEQgjBwcgeyZLaSog
        i0fD4l4HH+o9oq7j/C459Bv4ellI4whJhCqUDa6tvRwfMAMcqV+0lBemq6AOHn+Q6KIETb
        bMfW6zc7BlRRGtxTiLCnmD0f5E4mLIU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-9zl3kE9_PYy_NO0Gi6q0CA-1; Fri, 07 Feb 2020 10:55:03 -0500
X-MC-Unique: 9zl3kE9_PYy_NO0Gi6q0CA-1
Received: by mail-wm1-f70.google.com with SMTP id n17so893079wmk.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 07:55:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QFBH+I3pZxSE3/nW8uXkPGgglj6CkLzBvtfEOuG6ltU=;
        b=fAwhyW0yXAoTOB4idNZOhNFBjPltsusL+KUJnu7r0faz01kJr8IA1gnKq2ozKrsTz8
         KFw6IIzRS/4LGhDgEopUOfj+c1EDUJ/DhYQwHM1CUEogcFYjvoxuCr9AFTjmlbB9ejzw
         S9HlRzdJLlKxqh+ik2suGnpVwz71oBYlxMj+UKh0NZT81q6aJDrSXdoOoIcBPTbB1OdY
         fe6q1XLWBKGzSfVxKAp99DMNFC7Jv7HOg1X19sBSd/rxlasX5ZRDec8uOZ7mi18VmlGZ
         IGgPFlQVDxLuL0JYtcW2BUpIVU93LYhYU1XJlghnysGgBf9gnMpihV+m6R+FiR7bYqFM
         nAWQ==
X-Gm-Message-State: APjAAAW6pFHp83lMjY/WXHW0JF88hKZp/Adwk+QRaVN3FvmgL9Pgjw5y
        WHkis/Hc1WWCDLGZthWeTdjr8KnVbDtFNzfvx9/zp3GWVopWs0TMeVztTrrfJW09vgrGz5AHLrO
        ovHigLfwcauqK
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr4823101wme.125.1581090900633;
        Fri, 07 Feb 2020 07:55:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGMhefTt0xxkYnoAPTdX7xUJ/aP2VoWNuoM5XnuppuedTlNtTGQxscI7Jhe88U/WITfvKq0A==
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr4823080wme.125.1581090900418;
        Fri, 07 Feb 2020 07:55:00 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a8sm3949803wmc.20.2020.02.07.07.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:54:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 08/61] KVM: x86: Warn on zero-size save state for valid CPUID 0xD.N sub-leaf
In-Reply-To: <20200201185218.24473-9-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-9-sean.j.christopherson@intel.com>
Date:   Fri, 07 Feb 2020 16:54:59 +0100
Message-ID: <87blqaqtnw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> WARN if the save state size for a valid XCR0-managed sub-leaf is zero,
> which would indicate a KVM or CPU bug.  Add a comment to explain why KVM
> WARNs so the reader doesn't have to tease out the relevant bits from
> Intel's SDM and KVM's XCR0/XSS code.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fd9b29aa7abc..424dde41cb5d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -677,10 +677,17 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  				goto out;
>  
>  			do_host_cpuid(&entry[i], function, idx);
> -			if (entry[i].eax == 0)
> -				continue;
> -			if (WARN_ON_ONCE(entry[i].ecx & 1))
> +
> +			/*
> +			 * The @supported check above should have filtered out
> +			 * invalid sub-leafs as well as sub-leafs managed by

Is it 'sub-leafs' or 'sub-leaves' actually? :-)

> +			 * IA32_XSS MSR.  Only XCR0-managed sub-leafs should
> +			 * reach this point, and they should have a non-zero
> +			 * save state size.
> +			 */
> +			if (WARN_ON_ONCE(!entry[i].eax || (entry[i].ecx & 1)))
>  				continue;
> +
>  			entry[i].ecx = 0;
>  			entry[i].edx = 0;
>  			++*nent;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

