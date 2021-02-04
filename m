Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36C731005A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 23:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBDWxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 17:53:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhBDWxS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 17:53:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612479111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lq9nuNPtZLBS+cbRJ5imk1NIAv935j3u3Kxk6L5bw/E=;
        b=JmSI2SdrQHdLvKIJrGuCl/VuLnXPaLkul3ppk5aXMnTDU1dQzxfkcmH794u9J/OOavNfz7
        0VzSqRb+isQ4LYAZfe/Q2olHi1BgUk+HfRvQO72X9HgTjUzXVBBjeowjGMsDoZVKEn1f2g
        KLO9F2e8ZgpB3KDGdyWG9fG5A2yDTKI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-x4lPRE1kPOG8J2LnFwRiJQ-1; Thu, 04 Feb 2021 17:51:47 -0500
X-MC-Unique: x4lPRE1kPOG8J2LnFwRiJQ-1
Received: by mail-qk1-f198.google.com with SMTP id e5so4079495qkn.2
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 14:51:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lq9nuNPtZLBS+cbRJ5imk1NIAv935j3u3Kxk6L5bw/E=;
        b=dB7f2aFFFTqbk0it050vU44NbAsJzT7zInPTqcKcfD1z6x7Foz1U8qwF6/KPHXEBZq
         A6IkEyhbnnBscOULJnYdwOfR0DMaNH01qK3j+16rPG5vr2G5UtQ+LZ6ZTXVgjnLHSEiX
         qJNKuNrzYYQXcw0XeRReTGq7JUsdquVLTENA82TQjDwPoEzZr9rOsEtsqGTqZ/s5u52T
         MaEphT8uGkKUC5+9muQQEZ4lIiYshEJ1Z0lClNJh7ucJE+11BSrZKegneg/n/AziLxHc
         ox8WpgU42CDCZzZvDspF32auZf3LcQFKSH/VyIsQlnAvyHhbj+lPqzAoL5RUd8baArPA
         5oJQ==
X-Gm-Message-State: AOAM532j+bmq3l5sAeUR43YX6E+rKjDL74wAySI09uDnVwbRObahikBc
        ct9RHBPfJKyBlWWD81OF/BQlkj8FyFuyGkEjzBb1qrsPD3M0+05CmNd3czRJS2hvVeTKeUVQF4h
        3H8qU3Quy2Rn3
X-Received: by 2002:a05:6214:9d3:: with SMTP id dp19mr1610766qvb.40.1612479107469;
        Thu, 04 Feb 2021 14:51:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxV17SHLrE+uX2s2MUEyXHm7kffYBSerSRCUe9yZR1kBi+IVmixUgCm6vr7S1S8Sgvus5iIw==
X-Received: by 2002:a05:6214:9d3:: with SMTP id dp19mr1610750qvb.40.1612479107239;
        Thu, 04 Feb 2021 14:51:47 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-182.dsl.bell.ca. [174.93.89.182])
        by smtp.gmail.com with ESMTPSA id u7sm5407925qta.75.2021.02.04.14.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 14:51:46 -0800 (PST)
Date:   Thu, 4 Feb 2021 17:51:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH] KVM: VMX: Optimize flushing the PML buffer
Message-ID: <20210204225144.GU6468@xz-x1>
References: <20210204221959.232582-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210204221959.232582-1-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Ben,

On Thu, Feb 04, 2021 at 02:19:59PM -0800, Ben Gardon wrote:
> The average time for each run demonstrated a strange bimodal distribution,
> with clusters around 2 seconds and 2.5 seconds. This may have been a
> result of vCPU migration between NUMA nodes.

Have you thought about using numactl or similar technique to verify your idea
(force both vcpu threads binding, and memory allocations)?

From the numbers it already shows improvements indeed, but just curious since
you raised this up. :)

> @@ -5707,13 +5708,18 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
>  	else
>  		pml_idx++;
>  
> +	memslots = kvm_vcpu_memslots(vcpu);
> +
>  	pml_buf = page_address(vmx->pml_pg);
>  	for (; pml_idx < PML_ENTITY_NUM; pml_idx++) {
> +		struct kvm_memory_slot *memslot;
>  		u64 gpa;
>  
>  		gpa = pml_buf[pml_idx];
>  		WARN_ON(gpa & (PAGE_SIZE - 1));
> -		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> +
> +		memslot = __gfn_to_memslot(memslots, gpa >> PAGE_SHIFT);
> +		mark_page_dirty_in_slot(vcpu->kvm, memslot, gpa >> PAGE_SHIFT);

Since at it: make "gpa >> PAGE_SHIFT" a temp var too?

Thanks,

-- 
Peter Xu

