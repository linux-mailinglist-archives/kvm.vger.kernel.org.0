Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A64AF1CA
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiBIMe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiBIMeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:34:24 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A532C05CBBA;
        Wed,  9 Feb 2022 04:34:25 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id u20so2585501ejx.3;
        Wed, 09 Feb 2022 04:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oISxEhOVgdnKSet2UYGwe5pMid4GVc9Hvmnmg5R1/KI=;
        b=qQ+RDDDIHUw+vfOm5GQTBG35EX5r2QB7AP6hmDBKYQq72pTVVXL9WW/2fyL4eJH8Iy
         ayRliOssrwotSZkA/Q+shKBPfnU/LlKSKcVs8h4wTeYfjJQ3HjziQToGD+1k5J5RR+lt
         nnKttKD/J56IjUGZcAuk8Ha+pZKT98GIk9dbDJBZSZWbSgHlHGZ0sJaBJHr3LF0DGFsr
         SFGo7xf/MlcSN/F86VJUy/JAkOSIV01r9ucCfdgQETjyb50wf0qu2rZGN87P0/AEhAXT
         bOWeoNL1q1feg+afSolzEWHWXs58eMJ3OYeVSwLo1DYdG6ls7n6odH/OUMaR+wCr+LAW
         DGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oISxEhOVgdnKSet2UYGwe5pMid4GVc9Hvmnmg5R1/KI=;
        b=LssvIeox2P35aeq9J7iWJsDE1fC3MlBFjqbtZMVhLyxRWNv/L9cNN7myGQZct2ZmjN
         eK+MEqOi9YA8JsZd6u68MDeeSx3E7Li+8Mp9qyCeHlGxi+ZLWncDYJ0Tj48/yagwdsbf
         ti2PHUgnW4jK9BItq+YCt1ssAI3cYf2apfyO2dpSmFhzINA54FzS3HT1ctWm3YiKkfRy
         tjoj8+3nmVwp8YLaXks+CKUHyeJ+jtfDOldLmg3mLPmIubqrAvaOssJlKd8nHprmFrGC
         eslzW2GKxvZVHm2QzLI49bzyl6RV9YLIMAx7rrrGLYQ20SXhISlT2HGeMyCLlP3/W+Uy
         EDSg==
X-Gm-Message-State: AOAM530c4aa3i4S71zD1XT7QboD/9VfnFaFfTxTgyRyXrXFZ32y7I5a7
        Bmp2KI5H9EAJ/HSSuFBTi5TUkT3bFMM=
X-Google-Smtp-Source: ABdhPJxSq0xVoxQOLW4szVsnhbifY7wFqtfgaQ0laxPK5EHPDbaIEeeI+IlB1JR0bJ23U424XIyF0g==
X-Received: by 2002:a17:906:d62:: with SMTP id s2mr1807668ejh.176.1644410063741;
        Wed, 09 Feb 2022 04:34:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id gi15sm3353843ejc.139.2022.02.09.04.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 04:34:23 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d4c5d59f-5526-2c4f-236e-ca1536e762f6@redhat.com>
Date:   Wed, 9 Feb 2022 13:34:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 06/23] KVM: MMU: load new PGD once nested two-dimensional
 paging is initialized
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-7-pbonzini@redhat.com> <Yf178LYEY4pFJcLc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yf178LYEY4pFJcLc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 20:18, David Matlack wrote:
> On Fri, Feb 04, 2022 at 06:57:01AM -0500, Paolo Bonzini wrote:
>> __kvm_mmu_new_pgd looks at the MMU's root_level and shadow_root_level
>> via fast_pgd_switch.
> 
> Those checks are just for performance correct (to skip iterating through
> the list of roots)?
> 
> Either way, it's probably worth including a Fixes tag below.

It's actually a much bigger mess---though it's working as intended, 
except that in some cases the caching is suboptimal.

Basically, you have to call __kvm_mmu_new_pgd *before* kvm_init_mmu 
because of how fast_pgd_switch takes care of stashing the current root 
in the cache.   A PAE root is never placed in the cache exactly because 
mmu->root_level and mmu->shadow_root_level hold the value for the 
_current_ root.  In that case, fast_pgd_switch does not look for a 
cached PGD (even if according to the role it could be there).

__kvm_mmu_new_pgd then frees the current root using kvm_mmu_free_roots. 
  kvm_mmu_free_roots *also* uses mmu->root_level and 
mmu->shadow_root_level to distinguish whether the page table uses a 
single root or 4 PAE roots.  Because kvm_init_mmu can overwrite 
muu->root_level, kvm_mmu_free_roots must also be called before kvm_init_mmu.

I do wonder if the use of mmu->shadow_root_level was intentional (it 
certainly escaped me when first reviewing fast PGD switching), but 
fortunately none of this is necessary.  PAE roots can be identified from 
!to_shadow_page(root_hpa), so the better fix is to do that:

- in fast_pgd_switch/cached_root_available, you need to account for two 
possible transformations of the cache: either the old entry becomes the 
MRU of the prev_roots as in the current code, or the old entry cannot be 
cached.  This is 20-30 more lines of code.

- in kvm_mmu_free_roots, just use to_shadow_page instead of 
mmu->root_level and mmu->shadow_root_level.

Once this is in place, the original bug is fixed simply by calling 
kvm_mmu_new_pgd after kvm_init_mmu.  kvm_mmu_reset_context is not doing 
now to avoid having to figure out the new role, but it can do that 
easily after the above change.

I'll keep this cpu_role refactoring around, but strictly speaking it 
becomes a separate change than the optimization.

Paolo
