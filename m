Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2371203D71
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgFVRFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:05:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729992AbgFVRE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 13:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592845497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zw8XrOHkVRgeeR7QiiSEcbjjjltG1ehdscLw0b/C9c0=;
        b=HK1pnyvkqHnxsLGrfsqJVCnJUQGfR2HNg+QQNbW7LlAZDNwUPJriS4zqdks9x7klIWMnGc
        5iig13zlfIOSl28b4c5YR78WBwAA1QTyDg1ItpuiM6QZsGXZgWv7dpa3cHdt1+gRcXTTCU
        wPCeMmVmlLFFh0tIf0YSjDhyLCDfkUo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-piw0CY-fMoagmNSVUwjYYw-1; Mon, 22 Jun 2020 13:04:56 -0400
X-MC-Unique: piw0CY-fMoagmNSVUwjYYw-1
Received: by mail-wm1-f71.google.com with SMTP id g124so74630wmg.6
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 10:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zw8XrOHkVRgeeR7QiiSEcbjjjltG1ehdscLw0b/C9c0=;
        b=DudErEH19CtFJ7hRUxKeZivHZIeYx1Zc5gIWf7uAaNBDQgaaii/+j9mrtcNXmuCv2o
         EGBQTQ9QqrgwocIFCkUlcQjTJm+pWXIJ/Qbn/6buci1jnHKfCZ4Hk4H9HuMa2G3flUHw
         Xuj7AVvnix1fQ1N0KNvmvWdwribf135PF7hjVRsv5o4e5i+uUJjrVgm9geVIhVK/ANe3
         CaoIjvRiYVgeuKksYKzJ5/Qna9pWgtUht8AlznpVdVM4adQoVI2N6VH8+cJpyCSWq0d2
         M4RMIkyVLEoYGwbQQo7FLNiPgbUNIqps/pJvVNGd6NDNz4X7URaqe+pay55VbLDw/kgb
         tPkA==
X-Gm-Message-State: AOAM5301s/1Acc5/B+pnvoZN60+BykoE2U84wxQIa+VoDzlMAG71AGN8
        aIC+iFiQJ+w8yCzNJL8ZnMLAomGXiTsByiCI2anNOFs/QHSGTVjhnK8XGeXaTSdj640YE1J6s6/
        tMCQf1y0nj4ox
X-Received: by 2002:a5d:4d4d:: with SMTP id a13mr20552791wru.252.1592845494817;
        Mon, 22 Jun 2020 10:04:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJshRM/Q+cYn+pOyoQNIMqnZX6SUkflro/KbDFFzDy9a/O4IODCxlScxMd2GSbKua7MHQkLQ==
X-Received: by 2002:a5d:4d4d:: with SMTP id a13mr20552775wru.252.1592845494559;
        Mon, 22 Jun 2020 10:04:54 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id p16sm20655190wru.27.2020.06.22.10.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:04:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Avoid mixing gpa_t with gfn_t in
 walk_addr_generic()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200622151435.752560-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe5b461e-795f-332f-48fe-58fc39fd1ae0@redhat.com>
Date:   Mon, 22 Jun 2020 19:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622151435.752560-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 17:14, Vitaly Kuznetsov wrote:
> translate_gpa() returns a GPA, assigning it to 'real_gfn' seems obviously
> wrong. There is no real issue because both 'gpa_t' and 'gfn_t' are u64 and
> we don't use the value in 'real_gfn' as a GFN, we do
> 
>  real_gfn = gpa_to_gfn(real_gfn);
> 
> instead. 'If you see a "buffalo" sign on an elephant's cage, do not trust
> your eyes', but let's fix it for good.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index a6d484ea110b..58234bfaca07 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -360,7 +360,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	++walker->level;
>  
>  	do {
> -		gfn_t real_gfn;
>  		unsigned long host_addr;
>  
>  		pt_access = pte_access;
> @@ -375,7 +374,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  		walker->table_gfn[walker->level - 1] = table_gfn;
>  		walker->pte_gpa[walker->level - 1] = pte_gpa;
>  
> -		real_gfn = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
> +		real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
>  					      nested_access,
>  					      &walker->fault);
>  
> @@ -389,12 +388,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  		 * information to fix the exit_qualification or exit_info_1
>  		 * fields.
>  		 */
> -		if (unlikely(real_gfn == UNMAPPED_GVA))
> +		if (unlikely(real_gpa == UNMAPPED_GVA))
>  			return 0;
>  
> -		real_gfn = gpa_to_gfn(real_gfn);
> -
> -		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, real_gfn,
> +		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
>  					    &walker->pte_writable[walker->level - 1]);
>  		if (unlikely(kvm_is_error_hva(host_addr)))
>  			goto error;
> 

Queued, thanks.

Paolo

