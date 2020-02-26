Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458C817019C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBZO4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 09:56:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgBZO4C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 09:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582728961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fojZvLFP2Jo0NZ519XOD4dNh0bZ+gliF+8E6KslGYjA=;
        b=b3D8/1PvW1i3j/d8rGnp1dJzL5eOvTeFurNI9O5EoB+nWjUsgznYBQOVlNjJ5kp5Qu4/KO
        aXpsUAWemCU7KnQ+JEiwwid1kiPMVE27rV/kn7BXOG8jx/zg8nGD0H6/e4XrKv+AUy8hj8
        CmJrVPxsby66X3+3zwSU/OfqCLWtJIc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-AnSi5sOMPquRM7gZktqq2Q-1; Wed, 26 Feb 2020 09:55:58 -0500
X-MC-Unique: AnSi5sOMPquRM7gZktqq2Q-1
Received: by mail-wr1-f70.google.com with SMTP id n12so1575700wrp.19
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 06:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fojZvLFP2Jo0NZ519XOD4dNh0bZ+gliF+8E6KslGYjA=;
        b=HPjbHSO5ZXJWAhfrWgCA82IvIIroSmDsUaMJNwK1u1R4jeOVfkvmWCFwY6EjttJo9/
         T6jBSe5ALpi0fegKc2FL/ntkZqZEyym89eTwnTAQhWfwOumsmUgL8wspFYX3UDD1vo/h
         XpArl9rZQgB7hU5+GbGiXmU/bMAXx1qU2+jbUSbm3IqJn0jE4JfTO+X+x61PgNIbjSDr
         up48V2DgS6tQr3tr2scJQISvMiYvEKYIApeJuSkIiGLZLxIYF2jyxD4xEhxhMbHJ17go
         UZ5FNbb3+e4foGfxalu6T9rQMsmD/mjZ/+qB8aJn+FcHtaNbGFAD2z2tb2PsmQ7PvV2b
         NIXA==
X-Gm-Message-State: APjAAAXdg7ywMw13c5iMhlyPUiynALmFBr9pgC/xuc6W2doGjd/Zpn5H
        /Lm/MfUJ4x+/QPDMP9eTrKVkUDCbGDvPzXhdW921RViTX5Xh/DNlQ2/gcHYB3axcK4uXFtd6pfb
        QTw8q+2D3Tro7
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr6238745wmi.51.1582728956952;
        Wed, 26 Feb 2020 06:55:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJF+v50o12fLqZ9qUKolYQX8x00JcZR0zCo7Dv+ZRryekuLYXWmSUoEu+PcKGHBmDxzTkTcg==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr6238717wmi.51.1582728956677;
        Wed, 26 Feb 2020 06:55:56 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b10sm3342471wrt.90.2020.02.26.06.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 06:55:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/61] KVM: x86/mmu: Configure max page level during hardware setup
In-Reply-To: <20200225210149.GH9245@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-59-sean.j.christopherson@intel.com> <87blpmlobr.fsf@vitty.brq.redhat.com> <20200225210149.GH9245@linux.intel.com>
Date:   Wed, 26 Feb 2020 15:55:55 +0100
Message-ID: <87k149jt38.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Feb 25, 2020 at 03:43:36PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > Configure the max page level during hardware setup to avoid a retpoline
>> > in the page fault handler.  Drop ->get_lpage_level() as the page fault
>> > handler was the last user.
>> > @@ -6064,11 +6064,6 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>> >  	}
>> >  }
>> >  
>> > -static int svm_get_lpage_level(void)
>> > -{
>> > -	return PT_PDPE_LEVEL;
>> > -}
>> 
>> I've probably missed something but before the change, get_lpage_level()
>> on AMD was always returning PT_PDPE_LEVEL, but after the change and when
>> NPT is disabled, we set max_page_level to either PT_PDPE_LEVEL (when
>> boot_cpu_has(X86_FEATURE_GBPAGES)) or PT_DIRECTORY_LEVEL
>> (otherwise). This sounds like a change) unless we think that
>> boot_cpu_has(X86_FEATURE_GBPAGES) is always true on AMD.
>
> It looks like a functional change, but isn't.  kvm_mmu_hugepage_adjust()
> caps the page size used by KVM's MMU at the minimum of ->get_lpage_level()
> and the host's mapping level.  Barring an egregious bug in the kernel MMU,
> the host page tables will max out at PT_DIRECTORY_LEVEL (2mb) unless
> boot_cpu_has(X86_FEATURE_GBPAGES) is true.
>
> In other words, this is effectively a "documentation" change.  I'll figure
> out a way to explain this in the changelog...
>
>         max_level = min(max_level, kvm_x86_ops->get_lpage_level());
>         for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
>                 linfo = lpage_info_slot(gfn, slot, max_level);
>                 if (!linfo->disallow_lpage)
>                         break;
>         }
>
>         if (max_level == PT_PAGE_TABLE_LEVEL)
>                 return PT_PAGE_TABLE_LEVEL;
>
>         level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
>         if (level == PT_PAGE_TABLE_LEVEL)
>                 return level;
>
>         level = min(level, max_level); <---------

Ok, I see (I believe):

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

It would've helped me a bit if kvm_configure_mmu() was written the
following way:

void kvm_configure_mmu(bool enable_tdp, int tdp_page_level)
{
        tdp_enabled = enable_tdp;

	if (boot_cpu_has(X86_FEATURE_GBPAGES))
                max_page_level = PT_PDPE_LEVEL;
        else
                max_page_level = PT_DIRECTORY_LEVEL;

        if (tdp_enabled)
		max_page_level = min(tdp_page_level, max_page_level);
}

(we can't have cpu_has_vmx_ept_1g_page() and not
boot_cpu_has(X86_FEATURE_GBPAGES), right?)

But this is certainly just a personal preference, feel free to ignore)

-- 
Vitaly

