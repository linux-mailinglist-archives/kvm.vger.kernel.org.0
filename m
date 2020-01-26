Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D936D14988A
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2020 04:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAZDCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 22:02:30 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39789 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZDC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Jan 2020 22:02:29 -0500
Received: by mail-yw1-f66.google.com with SMTP id h126so3053739ywc.6;
        Sat, 25 Jan 2020 19:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tII4AVx3br1wrYA9rc56+ZdNuhnFX5KM9kteNOyiS3I=;
        b=lJIXcxbgCpGMRp6Zhvk2vdNUDh4nIe7voMjfHZxQXifoDNtapG1wg1VPXaJ/D5W50V
         q++Qs7815rrRcG1L7K91MxNz42/vCV917pKz+9tZLTxiAmjfYanj20HwdKQydpmE8KjY
         tDlpYmVMQWyr6MwKAd9+zqXhUsPdYj3bwOgycRD9kcbZ7EYqcByFtvK6zRrCsz/VBjJ4
         sLYwOcJ//TFJvb61wypLOyUvG/FePeJawpqNadA7y+xAnoGeTbtGKwBUIsWjy4E82OvC
         duMEH8TkUvPKoMimw74utO6UXNSMWYG5NgjQfg1fKhnGS4Nb7D9RTS+nENdf6YceeAf7
         20Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=tII4AVx3br1wrYA9rc56+ZdNuhnFX5KM9kteNOyiS3I=;
        b=nFs3ztBonP22UgjL/6bpK5IK+UQmQDL20BrN+rhxSZ0nD8nC8DY8XI5GEqzU7Ze7Jk
         RLie6Kr+HD1jK/BGr380jmR0/S1UJyFCkRqWeGm84gBZgRj2D8ANx2q68uK41bLHzdub
         uMzxD8BGWohht2h8YWc1Yeb6fd37N33ylyKVOgb4T1VDc55XmQzfBgRCr5XCNGvX41C7
         MbdFcy+VFLeKuCOkeWfRV255y5Wgd2vnEzp4G07reMiSV7nIPmsjC8Z1qvGj3sK0qHi0
         YMQf0nO0gXU28tRATaYdGn2hgNpLVD2eOWIop02+WK9nAdrbb7VJ7tZwCoROnp/wmso/
         q0Mg==
X-Gm-Message-State: APjAAAWuTudVSUJUL1ZSrFmY4oTFCyjDZ8EJ+l7VFKUMm7yfZU7xfjTG
        vpUHZ3aXLgTQY7Yq/WmDV2I=
X-Google-Smtp-Source: APXvYqxidmu1wxYikxWGAWqi1KWvgtfYYggyQy+ED7b5j1UZ0or2nxTKdnePwrdbB9N0a8F2AlDozg==
X-Received: by 2002:a0d:d8c2:: with SMTP id a185mr7623650ywe.337.1580007748730;
        Sat, 25 Jan 2020 19:02:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s3sm4845031ywf.22.2020.01.25.19.02.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Jan 2020 19:02:28 -0800 (PST)
Date:   Sat, 25 Jan 2020 19:02:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20200126030226.GA7167@roeck-us.net>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-31-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-31-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:55:15PM -0800, Sean Christopherson wrote:
> Now that all architectures tightly couple vcpu allocation/free with the
> mandatory calls to kvm_{un}init_vcpu(), move the sequences verbatim to
> common KVM code.
> 
> Move both allocation and initialization in a single patch to eliminate
> thrash in arch specific code.  The bisection benefits of moving the two
> pieces in separate patches is marginal at best, whereas the odds of
> introducing a transient arch specific bug are non-zero.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

[ ... ]

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8543d338a06a..2ed76584ebd9 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
>  

[ ... ]

> -struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> -				      unsigned int id)
                                      ^^^^^^^^^^^^^^^
> +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
>  	int rc;
>  
> -	rc = -ENOMEM;
> -
> -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> -	if (!vcpu)
> -		goto out;
> -
> -	rc = kvm_vcpu_init(vcpu, kvm, id);
> -	if (rc)
> -		goto out_free_cpu;
> -
> -	rc = -ENOMEM;
> -
>  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
>  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
>  	if (!sie_page)
> -		goto out_uninit_vcpu;
> +		return -ENOMEM;
>  
>  	vcpu->arch.sie_block = &sie_page->sie_block;
>  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  		 vcpu->arch.sie_block);
>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
                                   ^^^

For extensive changes like this, wouldn't it be desirable to at least
compile test it ?

Guenter
