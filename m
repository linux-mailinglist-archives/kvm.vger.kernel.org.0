Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C85C29EF9
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfEXTV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:21:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55522 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfEXTV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:21:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id x64so10422923wmb.5
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 12:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hhpEA5bjl58Li319ZLPi9C0clAwaLvwax4NH0f/4Z7g=;
        b=mArFQ0PycCVG9zgixDde2Bd5GEcNiDUdKurpvWFCJrp5goCL/eoCTqfRiN+iwdLRTF
         xAJIrkHPXWGiqZBC3BdoMN1sSWefhlLBlAvcNQAMjUJ02UXp1DqdOQl/IhOAXcqWQKbg
         2Z2LmEBlJw6aBvMBwke73nIe6mgjUSpq0EdHdaoxux7CjSWmSTFlIK9ZuxMi3502yC+D
         sH3U/qdw4mUlEtdco5tzqaDUu/5SC5l83GxcgLJxgGpUCJEvKrio12X5WR/dB3qUYbci
         1VQs1GYd4XkS7wX3C/pCzOqbsYhIbf2tlY7ChYNJ3Z2yzSsV/LBSX1fAJzuVrbVT4xaE
         4raQ==
X-Gm-Message-State: APjAAAWttQpwLfQqCVCjJ1s73gFGm7n3dbZvWK+EUKgeSW2kuXw4NZ1F
        Gh8VyfPfK55/Qtx6LTpVL+5g7A==
X-Google-Smtp-Source: APXvYqzVW8+lSidchypL8va23vulSlBcABe601SqasKD35Z2ztw7HupPhfH149YMzdfE/fat/9pzVg==
X-Received: by 2002:a05:600c:551:: with SMTP id k17mr16995780wmc.35.1558725717133;
        Fri, 24 May 2019 12:21:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 67sm4994440wmd.38.2019.05.24.12.21.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:21:56 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: fix memory slot handling for
 KVM_SET_USER_MEMORY_REGION
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        linux-kselftest@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20190524140623.104033-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89ad11b6-b044-5669-a9a3-398da002182f@redhat.com>
Date:   Fri, 24 May 2019 21:21:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524140623.104033-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 16:06, Christian Borntraeger wrote:
> kselftests exposed a problem in the s390 handling for memory slots.
> Right now we only do proper memory slot handling for creation of new
> memory slots. Neither MOVE, nor DELETION are handled properly. Let us
> implement those.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 871d2e99b156..6ec0685ab2c7 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4525,21 +4525,28 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				const struct kvm_memory_slot *new,
>  				enum kvm_mr_change change)
>  {
> -	int rc;
> +	int rc = 0;
>  
> -	/* If the basics of the memslot do not change, we do not want
> -	 * to update the gmap. Every update causes several unnecessary
> -	 * segment translation exceptions. This is usually handled just
> -	 * fine by the normal fault handler + gmap, but it will also
> -	 * cause faults on the prefix page of running guest CPUs.
> -	 */
> -	if (old->userspace_addr == mem->userspace_addr &&
> -	    old->base_gfn * PAGE_SIZE == mem->guest_phys_addr &&
> -	    old->npages * PAGE_SIZE == mem->memory_size)
> -		return;
> -
> -	rc = gmap_map_segment(kvm->arch.gmap, mem->userspace_addr,
> -		mem->guest_phys_addr, mem->memory_size);
> +	switch (change) {
> +	case KVM_MR_DELETE:
> +		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
> +					old->npages * PAGE_SIZE);
> +		break;
> +	case KVM_MR_MOVE:
> +		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
> +					old->npages * PAGE_SIZE);
> +		if (rc)
> +			break;
> +		/* FALLTHROUGH */
> +	case KVM_MR_CREATE:
> +		rc = gmap_map_segment(kvm->arch.gmap, mem->userspace_addr,
> +				      mem->guest_phys_addr, mem->memory_size);
> +		break;
> +	case KVM_MR_FLAGS_ONLY:
> +		break;
> +	default:
> +		WARN(1, "Unknown KVM MR CHANGE: %d\n", change);
> +	}
>  	if (rc)
>  		pr_warn("failed to commit memory region\n");
>  	return;
> 

Queued for 5.2-rc2, thanks.

Paolo
