Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD8817A76C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCEO3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:29:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21471 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgCEO3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583418580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psVOG7od+ajhl0Qo6ZW+Pj0HLvKsvb4nNAk9KL1G8Tw=;
        b=ZubQEyMDyA9FlydIMlpaSyd566eN21FEwYGoZLqOrtrx/pCGlOSbsUFryfLsW+BVc0BhUr
        E1jkHCU5G4VL5uZqrZvihuJJPGyA2w6U4KLzIaMSiEyKLJlP7hS1ks+As3PiU30lN2cyD9
        Aeqjgq24GzYP5GS+4K39Cu7k/8VJfsA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-GYF1jzDrMH-yKBnV5mUwcQ-1; Thu, 05 Mar 2020 09:29:39 -0500
X-MC-Unique: GYF1jzDrMH-yKBnV5mUwcQ-1
Received: by mail-wr1-f72.google.com with SMTP id m13so2384812wrw.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 06:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=psVOG7od+ajhl0Qo6ZW+Pj0HLvKsvb4nNAk9KL1G8Tw=;
        b=Q3Upu633GxlN+Pd+JStgSDuiA4lHXxbOsNdNaE5dLVzDztvfQBFBGOOmCuwax05G0m
         ZnoAtyuLZz86+7ihK5Em5nVPuBdKCJkoF271e0tuOtAghjM5xugSKJivkxvS+6NnXnv7
         /qLcjDvZ6Hl/RjbfIZX2ZswxQPmE9BtEBJ01/0jxYh2+kcD6EEZ/v8uqoZr1SpQ7Ns7X
         Qi5KBGivbJSp5nLuNKC+1EeM/v11TqSdAeqzTzjeKLXC8g6KwsbwckcK20cvJewwd3qt
         uwmaLVldj50J5U4ZrCGLfzVLKeJA9oLa2jGVohu12CLmZEvbbvhfpYgwlGDEdNrvdGrY
         FctA==
X-Gm-Message-State: ANhLgQ2vHqk8jQPaJUgkcU22UDvI5ZKfepQ4sXi7+OpBpnZzcGOovkAn
        FYUUjUhiwRY81GAee0mkhfoW8KBpD+sCwPERtwr0x7Sz44Qq09nVbkFaljGsR5/i5j/FJbSs5gh
        3z/sPH+0rVDUL
X-Received: by 2002:a5d:658c:: with SMTP id q12mr11208883wru.57.1583418577986;
        Thu, 05 Mar 2020 06:29:37 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvFzgRa5nufgb2hQk6wE9mEnuNRyLTpmqOX3HouacHZWQr0BD1TKZDAs8cSZNdBDl9Pu4WGhg==
X-Received: by 2002:a5d:658c:: with SMTP id q12mr11208863wru.57.1583418577757;
        Thu, 05 Mar 2020 06:29:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id y7sm9627254wmd.1.2020.03.05.06.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 06:29:37 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Fix warning due to implicit truncation on
 32-bit KVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305002422.20968-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09a6a16a-34db-38df-4632-ddf861afece6@redhat.com>
Date:   Thu, 5 Mar 2020 15:29:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305002422.20968-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 01:24, Sean Christopherson wrote:
> Explicitly cast the integer literal to an unsigned long when stuffing a
> non-canonical value into the host virtual address during private memslot
> deletion.  The explicit cast fixes a warning that gets promoted to an
> error when running with KVM's newfangled -Werror setting.
> 
>   arch/x86/kvm/x86.c:9739:9: error: large integer implicitly truncated
>   to unsigned type [-Werror=overflow]
> 
> Fixes: a3e967c0b87d3 ("KVM: Terminate memslot walks via used_slots"
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ba4d476b79ad..fa03f31ab33c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9735,8 +9735,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		if (!slot || !slot->npages)
>  			return 0;
>  
> -		/* Stuff a non-canonical value to catch use-after-delete. */
> -		hva = 0xdeadull << 48;
> +		/*
> +		 * Stuff a non-canonical value to catch use-after-delete.  This
> +		 * ends up being 0 on 32-bit KVM, but there's no better
> +		 * alternative.
> +		 */
> +		hva = (unsigned long)(0xdeadull << 48);
>  		old_npages = slot->npages;
>  	}
>  
> 

Queued, thanks.

Paolo

