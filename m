Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA67CF1C5D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732395AbfKFRWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:22:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbfKFRWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:22:32 -0500
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 378AF811A9
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 17:22:32 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id e25so14618763wra.9
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 09:22:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7lJxgAWCW8T3bcUZhMKJItz5qgGgFx2fg3nRIeSIa28=;
        b=rpY2jPNON0sRo1qiP1+1Z0DDHIfQRQB7CsnGucyrpTff8Q+Wi1i/t44pUhPHI/yStO
         EYvSVaZbNR7yM9AuiAbw0sKHJ4/6htLhU+umAcEPoSKneaTrhKkqKwxgPxWogIAJ42cJ
         5chV3MvFArpRds51mn8ItEHdHqMtf6Gyr3zmd5dyiqPsQK3TK89fOwC8v4FvoliCjw2M
         kkRcTDtttACGOjs64GNV5JeIOsGiK/zy0GeTnIT9BmgBHpxPbNy7JK1pwUqdP1Z/wUCa
         nqTAVoKjp/ROmVF4MA7UyVeRdAmaWyjMa31eboFVjofunM6fkXOIoGFSs8VYnGt72qcI
         Xm/A==
X-Gm-Message-State: APjAAAVXbZopjooALwBrINthghWiHY6dXPUIK66hYj3/XxI91fn4oJM7
        e1OYxejx8WGrFosVYdV9xWOPDLas24BfhdYOuwQBpC2cBuEeQYafwFNeYy/rnTk74arNu1pSMnr
        QkQZW3Es2Rv+o
X-Received: by 2002:a7b:c853:: with SMTP id c19mr3370877wml.48.1573060950897;
        Wed, 06 Nov 2019 09:22:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6pdOPx+AAeZZqH4fmE+ZC+rck52bJZ9rsot7WpLYCv6sn/6q9wKCL5cJG5B5TqooJZUp+3g==
X-Received: by 2002:a7b:c853:: with SMTP id c19mr3370846wml.48.1573060950602;
        Wed, 06 Nov 2019 09:22:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id n22sm2988799wmk.19.2019.11.06.09.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 09:22:30 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Add helper to consolidate huge page
 promotion
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9b3e3cc3-9cd0-1f55-ee19-f33c4cfb7f8a@redhat.com>
Date:   Wed, 6 Nov 2019 18:22:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106170727.14457-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 18:07, Sean Christopherson wrote:
>  	 */
> -	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> -	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
> -	    PageTransCompoundMap(pfn_to_page(pfn)) &&
> +	if (level == PT_PAGE_TABLE_LEVEL && kvm_is_hugepage_allowed(pfn) &&
>  	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
>  		unsigned long mask;
>  		/*
> @@ -5914,9 +5919,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 * the guest, and the guest page table is using 4K page size
>  		 * mapping if the indirect sp has level = 1.
>  		 */
> -		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> -		    !kvm_is_zone_device_pfn(pfn) &&
> -		    PageTransCompoundMap(pfn_to_page(pfn))) {
> +		if (sp->role.direct && kvm_is_hugepage_allowed(pfn)) {
>  			pte_list_remove(rmap_head, sptep);

I don't think is_error_noslot_pfn(pfn) makes sense in
kvm_mmu_zap_collapsible_spte, so I'd rather keep it in
transparent_hugepage_adjust.  Actually, it must be is_noslot_pfn only at
this point---error pfns have been sieved earlier in handle_abnormal_pfn,
so perhaps

	if (WARN_ON_ONCE(is_error_pfn(pfn)) || is_noslot_pfn(pfn))
		return;

	if (level == PT_PAGE_TABLE_LEVEL &&
	    kvm_is_hugepage_allowed(pfn) &&
	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL))

would be the best option.

Paolo
