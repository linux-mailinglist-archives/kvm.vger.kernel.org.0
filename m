Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C65AAED70
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392988AbfIJOmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392981AbfIJOmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:42:02 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF56E2A09CE
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:42:01 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id b9so9057989wrt.5
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bT12KRgZOTisqUXhqBmZuyXHkuoI5E2VzJwdrt5Ywu0=;
        b=UvdaX9eNM7kBYfTiDM8kkhVuABRDnUL89C4utQ6Btd/I+5eM3uEY4WCgnxsjsOb/Pn
         oidqY2M9YdDM6/TIymauD0VKQ6F0k2pYUNUCADJ5rrybL7bUaAoCnFBQ7jNazlJQO480
         eEGr23BTNxO+DsUnS2kQe1BigdujXrCdG3bJVBkiuS9GYXG2L9odFtYGvmj9DInuW6gi
         CfaYBFF8jtsW47wxHozI9pj4NFhZItaPyPlyU4KtMl1HexDVuVzcahVTwBexUYsCfDUV
         m/p4QT0B/XNVOmoMbutd+xfSMXMQqx+6Zne7CrMhoiiknh2/azLC2grhg/E68NGVz1p3
         MKGw==
X-Gm-Message-State: APjAAAXhp5sFIOhR5waRbO5UjEFcyzY3xgtrD8tecHCVK6lEUStrw4VV
        BzzNbBA3W7cDV7q6+14aax93LXDv5ZMISgtMPL8PhDzGoEQ46N12kOV8sOsVXssgqLKXakPvvA1
        nOdpr/HpOjDPg
X-Received: by 2002:adf:ef12:: with SMTP id e18mr26533945wro.65.1568126520273;
        Tue, 10 Sep 2019 07:42:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxYCnJJYgIX4oew9IGSu9sfnNhgnO8lhKUywmdsYpWsRh5l50jOQx3zkdI6kX5X1a2V2STQFw==
X-Received: by 2002:adf:ef12:: with SMTP id e18mr26533909wro.65.1568126520007;
        Tue, 10 Sep 2019 07:42:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 189sm5004427wma.6.2019.09.10.07.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:41:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Manually calculate reserved bits when loading
 PDPTRS
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>
References: <20190903233645.21125-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7a83d8a7-b751-1232-a35f-38f8d9b660f3@redhat.com>
Date:   Tue, 10 Sep 2019 16:41:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903233645.21125-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/19 01:36, Sean Christopherson wrote:
> Manually generate the PDPTR reserved bit mask when explicitly loading
> PDPTRs.  The reserved bits that are being tracked by the MMU reflect the
> current paging mode, which is unlikely to be PAE paging in the vast
> majority of flows that use load_pdptrs(), e.g. CR0 and CR4 emulation,
> __set_sregs(), etc...  This can cause KVM to incorrectly signal a bad
> PDPTR, or more likely, miss a reserved bit check and subsequently fail
> a VM-Enter due to a bad VMCS.GUEST_PDPTR.
> 
> Add a one off helper to generate the reserved bits instead of sharing
> code across the MMU's calculations and the PDPTR emulation.  The PDPTR
> reserved bits are basically set in stone, and pushing a helper into
> the MMU's calculation adds unnecessary complexity without improving
> readability.
> 
> Oppurtunistically fix/update the comment for load_pdptrs().
> 
> Note, the buggy commit also introduced a deliberate functional change,
> "Also remove bit 5-6 from rsvd_bits_mask per latest SDM.", which was
> effectively (and correctly) reverted by commit cd9ae5fe47df ("KVM: x86:
> Fix page-tables reserved bits").  A bit of SDM archaeology shows that
> the SDM from late 2008 had a bug (likely a copy+paste error) where it
> listed bits 6:5 as AVL and A for PDPTEs used for 4k entries but reserved
> for 2mb entries.  I.e. the SDM contradicted itself, and bits 6:5 are and
> always have been reserved.
> 
> Fixes: 20c466b56168d ("KVM: Use rsvd_bits_mask in load_pdptrs()")
> Cc: stable@vger.kernel.org
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Reported-by: Doug Reiland <doug.reiland@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 290c3c3efb87..548cc6ef5408 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -674,8 +674,14 @@ static int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  				       data, offset, len, access);
>  }
>  
> +static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
> +{
> +	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63) | rsvd_bits(5, 8) |
> +	       rsvd_bits(1, 2);
> +}
> +
>  /*
> - * Load the pae pdptrs.  Return true is they are all valid.
> + * Load the pae pdptrs.  Return 1 if they are all valid, 0 otherwise.
>   */
>  int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  {
> @@ -694,8 +700,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>  	}
>  	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
>  		if ((pdpte[i] & PT_PRESENT_MASK) &&
> -		    (pdpte[i] &
> -		     vcpu->arch.mmu->guest_rsvd_check.rsvd_bits_mask[0][2])) {
> +		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
>  			ret = 0;
>  			goto out;
>  		}
> 

Queued, thanks.

Paolo
