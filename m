Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522AF1C40A4
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgEDQ7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:59:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729540AbgEDQ7g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7aCTRstfMP2fnbSH6DWPhx3+pxRKGKgLGIyHZLhrquM=;
        b=FCjv6j3UGRvZ5LEsC51Cp0T6Q5O/LEUBqC3ZqWKjPwN6RVol5bS4mAH6DUCyVAIofRVuAJ
        JPEyL9csayjAjLL+RRfX7JB8A/5/Prj/5dJ42DNoYduNz278ojwqzCVRueQiSnpLjxeQju
        +MK427qfzkN9yMplRgjyE5Csnor1HT0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-TOG2pkILMh6aBrU2i6t9Wg-1; Mon, 04 May 2020 12:59:32 -0400
X-MC-Unique: TOG2pkILMh6aBrU2i6t9Wg-1
Received: by mail-wm1-f70.google.com with SMTP id o26so130277wmh.1
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7aCTRstfMP2fnbSH6DWPhx3+pxRKGKgLGIyHZLhrquM=;
        b=B3xBaRpgdiJnUVYgw5tuOaPOTBhATubNPTuDKJEbcL2QX98UR1TlHPWzl8MlkiewLB
         TzonpXnozeG/KfiU54OTLVcjfBPClDJlqgnWi+56d3miQWxO/dWsc3XSV1CF9+KcBwXG
         AV1kpOcYH7jZGnQT1Vt+yhbxUT8U3ADFqluJtesL5XSF7JJnAK8gwk23YdXMR0bu8nDk
         oiaXReovdEew8vbDsO8TPjRZWP3a1W3AFAAwe2VhvFhw5+bHJBTjEr5RUO87ElW2Cxr4
         kVVJ3bbAkWw+lLZDEHWmgCmK7MSERHT8UT0O7yJ4l5aLYfb0WTLX7gKt6/ifTyxfhKCl
         lk1A==
X-Gm-Message-State: AGi0PuZgXfglniWeTv0OLcW7bc7oWWn2uT6k017UUklf+tMv7Z3HZ2Ay
        3C1Sk0pEmp09VDspSb/IQ3atu+2U3dW32Uy7bQOZSNUiWV9ne5ymnbgVEkGRZpwvs176Ri7KFxB
        IjDSsq/jB2BPG
X-Received: by 2002:a1c:7415:: with SMTP id p21mr15349083wmc.93.1588611571734;
        Mon, 04 May 2020 09:59:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypLQQu1fA5WU3WcZdTQUZ5JMatoV1CzXKcSaJVgR1xNoz1rhM6z0ZBtu8DWTmlj6wMhE9B3uhg==
X-Received: by 2002:a1c:7415:: with SMTP id p21mr15349068wmc.93.1588611571521;
        Mon, 04 May 2020 09:59:31 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id q4sm13441818wrx.9.2020.05.04.09.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:59:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: No need to retry for hva_to_pfn_remapped()
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155906.267462-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dba4f310-5838-cd78-73c9-3db84f93766a@redhat.com>
Date:   Mon, 4 May 2020 18:59:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416155906.267462-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 17:59, Peter Xu wrote:
> hva_to_pfn_remapped() calls fixup_user_fault(), which has already
> handled the retry gracefully.  Even if "unlocked" is set to true, it
> means that we've got a VM_FAULT_RETRY inside fixup_user_fault(),
> however the page fault has already retried and we should have the pfn
> set correctly.  No need to do that again.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2f1f2f56e93d..6aaed69641a5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1824,8 +1824,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  		r = fixup_user_fault(current, current->mm, addr,
>  				     (write_fault ? FAULT_FLAG_WRITE : 0),
>  				     &unlocked);
> -		if (unlocked)
> -			return -EAGAIN;
>  		if (r)
>  			return r;
>  
> @@ -1896,15 +1894,12 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>  		goto exit;
>  	}
>  
> -retry:
>  	vma = find_vma_intersection(current->mm, addr, addr + 1);
>  
>  	if (vma == NULL)
>  		pfn = KVM_PFN_ERR_FAULT;
>  	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
>  		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
> -		if (r == -EAGAIN)
> -			goto retry;
>  		if (r < 0)
>  			pfn = KVM_PFN_ERR_FAULT;
>  	} else {
> 

Queued, thanks.

Paolo

