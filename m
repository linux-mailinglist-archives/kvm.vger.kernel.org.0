Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAA014404A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 16:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAUPMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 10:12:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59686 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbgAUPMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 10:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579619574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bu/iMoYfYBgd5jXQviUDjY/CFaD1fKEaBQDIzi7DS7k=;
        b=Og8Apxb2WrYqabgBOUx1J5eX/OPRhL2ogKA7V9JpKLznNZkeZHaCSZkDukQfUeRXtbJHBA
        RkagdeKMvSC8AYXhK+V6XqKx8yczT+BVHWUBxzA0tbVzbDf5CbbLbiSpG0g+OPhhbggWK1
        vYcC8DHk3v1sIkutFsdtobcFfqZnQdU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-sNM9p47oO8m3nDqnR4do8A-1; Tue, 21 Jan 2020 10:12:51 -0500
X-MC-Unique: sNM9p47oO8m3nDqnR4do8A-1
Received: by mail-wr1-f72.google.com with SMTP id z10so1426133wrt.21
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 07:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bu/iMoYfYBgd5jXQviUDjY/CFaD1fKEaBQDIzi7DS7k=;
        b=jP2RTKZQxzz1KmaQsmuUA9o8x9FrgsGUSGp8ou/WPlcIRdxJ6jGE5WK2pAKlCyBriP
         YS4tbLAxZD40TLFctoM/OYTLqeMNJ7Cl3To7e53VBxIbALJnHiVqxXS9RvVNh/Eumlqe
         N9LD4agyzRyo3oY7tuindL91ATWHZh+V4voSr+s6btM0Gu7JZRuqEOgRXA2Ex7oCZJ1U
         iz33SfH92VTBWr+Sz2O60f8Z9zpsb0P8YT8S++LntsyVvFYWK2VEHb0wCFMA0OZxwLdE
         /MfhqVpOX5+PS65pfsbZ7fwbqaVGBrbh0uwIESp4+qE1jsYSjyavzMdSOpTyEgj0Gz2V
         CG7w==
X-Gm-Message-State: APjAAAWNHoKRTf6mhx0AzWy0f8bzvwE1Uru22vDq2GzrS+4rZ9auRmHh
        LnRQh7N6utTgx9mFRZ4N86bTjhH5ZLM4MvYjyzRm1h06fkp1bm4xnjfkqEjKqbHkVZxqq8jIpnJ
        B2ifrwZi+vehi
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr5000203wmd.5.1579619569960;
        Tue, 21 Jan 2020 07:12:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3W9/IFqNtFmh53Y8FuFyZdMe+4NHjz+xYUeI++YvzTVDVuRT0IkPp6ekS3qHgnEBSwWauFA==
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr5000170wmd.5.1579619569664;
        Tue, 21 Jan 2020 07:12:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id b16sm54711240wrj.23.2020.01.21.07.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 07:12:49 -0800 (PST)
Subject: Re: [PATCH 12/14] KVM: x86/mmu: Fold max_mapping_level() into
 kvm_mmu_hugepage_adjust()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-13-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <52cf5d90-5e65-4878-b214-7e1809224688@redhat.com>
Date:   Tue, 21 Jan 2020 16:12:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-13-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 21:24, Sean Christopherson wrote:
> -	level = host_pfn_mapping_level(vcpu, gfn, pfn);
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!memslot_valid_for_gpte(slot, true))
> +		return PT_PAGE_TABLE_LEVEL;

Following up on my remark to patch 7, this can also use
gfn_to_memslot_dirty_bitmap.

Paolo

> +
> +	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
> +	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
> +		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
> +			break;
> +	}
> +
> +	if (max_level == PT_PAGE_TABLE_LEVEL)
> +		return PT_PAGE_TABLE_LEVEL;
> +
> +	level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
>  	if (level == PT_PAGE_TABLE_LEVEL)
>  		return level;
>  
> @@ -4182,8 +4172,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	if (lpage_disallowed)
>  		max_level = PT_PAGE_TABLE_LEVEL;
>  
> -	max_level = max_mapping_level(vcpu, gfn, max_level);
> -
>  	if (fast_page_fault(vcpu, gpa, error_code))
>  		return RET_PF_RETRY;
>  
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0560982eda8b..ea174d85700a 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -817,8 +817,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	else
>  		max_level = walker.level;
>  
> -	max_level = max_mapping_level(vcpu, walker.gfn, max_level);
> -
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> 

