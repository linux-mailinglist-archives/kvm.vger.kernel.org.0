Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9C513CB68
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgAORxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:53:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58897 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729074AbgAORxo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 12:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579110823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a21Qt8oFCTbhrNX1697lVeADy2POBjMF/euhssereqA=;
        b=KjtV7fTdS0Yr0u7U6ZJ85tgCZyd8O4RAJZErDSnacpZQDS28X4ZrWbiajR3vMjjaHECXI5
        W2WDTR7gZNq17qKa8OP15JJtI/eqxXuAYR3NX0KlNB5tGPoimErE34jdU2dSYpyyIPfqPN
        8tVBroLpX5NJ2M/aj43nwbpBZ4USdVM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-7n7uNCUCN7yIxs5luJ9bOQ-1; Wed, 15 Jan 2020 12:53:40 -0500
X-MC-Unique: 7n7uNCUCN7yIxs5luJ9bOQ-1
Received: by mail-wm1-f72.google.com with SMTP id t16so229324wmt.4
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 09:53:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a21Qt8oFCTbhrNX1697lVeADy2POBjMF/euhssereqA=;
        b=FrDv2v9dNpV2i2ldxHZLx1TeD+m8jGEo2O+Yvhwk+BQSD5PQDl4AXPeM+kMKQXZiSI
         MKUs2EbG+i6dgYv+/B2HEL1TkO4NpHmWrgXbljpJKrqFR6UGcuQBjkcdN4cQlVr5jYTn
         lBGsHLIWpGHZmQxNYcgM5SgVPDv7plOupqA00DpRrFTRFVwE/HiJDNPcNgI9ZyLx9Kue
         LHL3dKG/GP1O3R6GyTqvRCddI38rJ+/7topzzJPBGomZO/fE+CXADxj52vF+ML7K4KeI
         hWRyePf2Lgi2Y3dQ+m90IOZE4pjONW9s4tSLRs8tKdYpcz6gQ+TNcckGh62hmXYy9sAx
         DUjw==
X-Gm-Message-State: APjAAAXZdrpk8zPwvFQbZx4LRfj6KAp6TgjVYmV9DFzJWx5V5lf0cD1+
        ZDI9i4dQl5L0BsAMP7tgTXyGaOa4joTPN9IvknPKnREsA3YY7AO1vNFnSFJGu7NGPCm9fl075OR
        s6ze95KXafZ9z
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr1075072wmg.83.1579110819591;
        Wed, 15 Jan 2020 09:53:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVUW0GWD/BbLlkB6QCotVb7uRTNn5MEbaGIbppm9s4IVai07E++87QyL+uOr4TgKm96kAD2Q==
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr1075044wmg.83.1579110819370;
        Wed, 15 Jan 2020 09:53:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id q3sm26493043wrn.33.2020.01.15.09.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 09:53:38 -0800 (PST)
Subject: Re: [PATCH 5/6] KVM: x86: check kvm_pit outside
 kvm_vm_ioctl_reinject()
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1575710723-32094-1-git-send-email-linmiaohe@huawei.com>
 <1575710723-32094-6-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5968f94f-ecd9-c284-b762-683ea761ec68@redhat.com>
Date:   Wed, 15 Jan 2020 18:53:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575710723-32094-6-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/19 10:25, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> check kvm_pit outside kvm_vm_ioctl_reinject() to keep codestyle consistent
> with other kvm_pit func and prepare for futher cleanups.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2d4e3a2dfec6..00b5d4ace383 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4662,9 +4662,6 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
>  {
>  	struct kvm_pit *pit = kvm->arch.vpit;
>  
> -	if (!pit)
> -		return -ENXIO;
> -
>  	/* pit->pit_state.lock was overloaded to prevent userspace from getting
>  	 * an inconsistent state after running multiple KVM_REINJECT_CONTROL
>  	 * ioctls in parallel.  Use a separate lock if that ioctl isn't rare.
> @@ -5029,6 +5026,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r =  -EFAULT;
>  		if (copy_from_user(&control, argp, sizeof(control)))
>  			goto out;
> +		r = -ENXIO;
> +		if (!kvm->arch.vpit)
> +			goto out;
>  		r = kvm_vm_ioctl_reinject(kvm, &control);
>  		break;
>  	}
> 

Applied this one, I don't think the others are a useful improvement.

Paolo

