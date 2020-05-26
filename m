Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08E31E1B75
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgEZGkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:40:03 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14762 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgEZGkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:40:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eccb96a0002>; Mon, 25 May 2020 23:38:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 23:40:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 May 2020 23:40:02 -0700
Received: from [10.2.58.199] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 May
 2020 06:40:02 +0000
Subject: Re: [RFC 07/16] KVM: mm: Introduce VM_KVM_PROTECTED
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <29a1d089-ab37-321c-0a01-11801a16a742@nvidia.com>
Date:   Mon, 25 May 2020 23:40:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590475114; bh=g/4IAy2uMJlh4KcPaPM3wTx3s9c3edZLBVBevRBpy5g=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ieiogTJmT7OD2KrJ54E1e+hMqFWNUcQJHEuLSx9iORtOMEa5DJuAkKC82OoqDK/N9
         Z+kkYDd4JWywiQaUWZKhEuISDGME1ftbzsbIcaVdmEQIrS2TUgIRB5OxSPoR3R92Tt
         jnBzX8r8IBgby3fhpEva9vuLWhaTbFQSJqyrzyvvfA9Dn0EBcg1yefSpYw7SEIOcku
         rSizgc+dOr48WxFQZCagQj69j/oJRl6J/hi++W8wMvAG7ZQZ/kKsJpSl/PhfVjzOYD
         e3jpCHn7iaiyEF/xVkgMX+hYNUCBlu4gWmyTs4WtrXyBtUJxvJJs3wgxYomhlwoGvf
         KM/O8NJAlDMKA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-22 05:52, Kirill A. Shutemov wrote:
...
> @@ -2773,6 +2780,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
>   #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
>   #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
> +#define FOLL_KVM	0x80000 /* access to VM_KVM_PROTECTED VMAs */
>   

I grabbed 0x80000 already, for FOLL_FAST_ONLY. :)

thanks,
-- 
John Hubbard
NVIDIA
