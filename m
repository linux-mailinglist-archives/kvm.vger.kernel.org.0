Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE2B1725D4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 19:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgB0SAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 13:00:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbgB0SAj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 13:00:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582826438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1a+jNTb4Orz5c9qxW8szumduw/KGeqpv62VeNode+w=;
        b=Unb+r7E+Mm9gZnfZxfuwRFHtoqGhCHCRhsue5jjjJ8CsimX03HATy3Tq6sSiljiJTj4hY9
        3DtNDB8pmkhvzSs0BZov53v9sc6AaONy73PIQNxQ4Ryg8JzJs7CwMRJw+mUKyDos95YmgL
        flCpjFBkTJc6yQ3sk+3NeeXgSrfYUAQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-e--Q7faJO6CvaKg9p_5J8A-1; Thu, 27 Feb 2020 13:00:36 -0500
X-MC-Unique: e--Q7faJO6CvaKg9p_5J8A-1
Received: by mail-wm1-f71.google.com with SMTP id p2so76013wma.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 10:00:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B1a+jNTb4Orz5c9qxW8szumduw/KGeqpv62VeNode+w=;
        b=mjkhY65goSlK0aXbE86BB7nG8U3Z19VZ8Fi1uKmT3hDPxA+BHxyBDHRgovCYYRK+vB
         BnwiJrV/JU2Ovr3+3mPn/irDbCYkuTCXg2+NWloL5CsL3GGB5RxZw18rZXnyOWNsa1cr
         bWkIpUKSh6rDQPJ0AQUPj7CT0qXkgUVsTSmR8iaWAt83LfnnithVZaPANJm45bIv1REZ
         9Z7VyJJ76l6HN9DWWybpvf6OLKndylgfkFaAN6Algl9JV9rm9A8QNRZ9me+jnjQOQnGH
         qBEe6dkAC1Pe4MozZeQlm89QeyA4WHPRtCZ4NgLYXV3520LLfvr+1jNprOd8R07tThqo
         58iA==
X-Gm-Message-State: APjAAAWTtnzCda+RPsU94I4+a/B690qxKfi/fr3QZXLnqR3i/1li6RiC
        1LFI9612mfDYrTfCXEca4Ec7n5gbNO08niqLQTFLdJ6a/7ksbZtfi0DZVW8CXZd/yLduTMlJDI9
        15Rupd+/Fol6q
X-Received: by 2002:adf:e506:: with SMTP id j6mr34516wrm.309.1582826435242;
        Thu, 27 Feb 2020 10:00:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxEXgel+e/Cr10Eg2mSUgtpkv3oomTVYQQ91dnsRyuh9Zrri6FyoSRaQfd8YKoTsQFnJzluA==
X-Received: by 2002:adf:e506:: with SMTP id j6mr34495wrm.309.1582826435009;
        Thu, 27 Feb 2020 10:00:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:30cb:d037:e500:2b47? ([2001:b07:6468:f312:30cb:d037:e500:2b47])
        by smtp.gmail.com with ESMTPSA id p26sm8207428wmc.24.2020.02.27.10.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 10:00:34 -0800 (PST)
Subject: Re: [PATCH 5/5] KVM: x86: mmu: Add guest physical address check in
 translate_gpa()
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org
References: <20200227172306.21426-1-mgamal@redhat.com>
 <20200227172306.21426-6-mgamal@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f81e0503-bc35-d682-4440-68b81c10784f@redhat.com>
Date:   Thu, 27 Feb 2020 19:00:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227172306.21426-6-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 18:23, Mohammed Gamal wrote:
> In case of running a guest with 4-level page tables on a 5-level page
> table host, it might happen that a guest might have a physical address
> with reserved bits set, but the host won't see that and trap it.
> 
> Hence, we need to check page faults' physical addresses against the guest's
> maximum physical memory and if it's exceeded, we need to add
> the PFERR_RSVD_MASK bits to the PF's error code.

You can just set it to PFERR_RSVD_MASK | PFERR_PRESENT_MASK (no need to
use an "|") and return UNMAPPED_GBA.  But I would have thought that this
is not needed and the

                if (unlikely(FNAME(is_rsvd_bits_set)(mmu, pte, walker->level))) {
                        errcode = PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
                        goto error;
                }

code would have catch the reserved bits.

> Also make sure the error code isn't overwritten by the page table walker.

Returning UNMAPPED_GVA would remove that as well.

I'm not sure this patch is enough however.  For a usermode access with
"!pte.u pte.40" for example you should be getting:

- a #PF with PRESENT|USER error code on a machine with physical address
width >=41; in this case you don't get an EPT violation or misconfig.

- a #PF with RSVD error code on a machine with physical address with <41.

You can enable verbose mode in access.c to see if this case is being generated,
and if so debug it.

The solution for this would be to trap page faults and do a page table
walk (with vcpu->arch.walk_mmu->gva_to_gpa) to find the correct error
code.

Paolo

