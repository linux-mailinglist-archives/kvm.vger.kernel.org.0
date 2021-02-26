Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9600326127
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 11:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBZKTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 05:19:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230107AbhBZKTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 05:19:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614334702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bkzcSPrA7vAUcT8SipaKPLFiHptMT01q/qqcIKIVYe8=;
        b=c77tfveistLgAjZs5TARhdpMKLEGIb1UcDGIli7bNOG3vqAFkPIQ4Yb4DzBya6aZd0c6oJ
        hDKRh98jV45Wydu0zTs0s7Kp6SQwoes8Xpcc1V2SMoh0/nJewz86wNDccmSIC0yRRLYyed
        C8XfMMk3uYp3mf7Fp/QL3hNgF3HibXQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-bUo6EF_2Op63M79lXq10-g-1; Fri, 26 Feb 2021 05:18:20 -0500
X-MC-Unique: bUo6EF_2Op63M79lXq10-g-1
Received: by mail-wr1-f72.google.com with SMTP id q5so4526349wrs.20
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 02:18:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bkzcSPrA7vAUcT8SipaKPLFiHptMT01q/qqcIKIVYe8=;
        b=Sm/gKJ/SThKUbtCexBbfRmdQKeJDsarS4FRFZStcXDjxopREjKtw+gG6fseB05zMYs
         dXmCpALYSviKPuz6A3pwNfzp85jVbRpsS1dU8D4IskCGzNgIyO97bfu1RnPAKC/EE0gM
         iZL2TBsDbT8HLBeL1CccW28QYM6qbIfR0SdnbwMcV/YHJ2+zn6CATCIQ/we5Mzl8O4Ch
         nRvQWf6U25nQGE7EqBp+Qdi8StFrqGnr2RXk5gyll2xLz8aK6c+w9OC6AGiN514x1UJD
         uIvVKkBM1Ys0igL1/aUzmrxgGfjy0wjQUXZDT5wN22vaAVg7cQohrbR2Ns6JDyNBqcnH
         l7hA==
X-Gm-Message-State: AOAM533dEn4i+jUmT8/zeuhrfg8VQ8qwmBvexmCEcsNduWOMUaEfUF2a
        JGjVTy2eDKo9Usx+XrEwmpHpKKykZe5R0zgPe9si2sHwHFn5DJl221YYT1bH8j89YWKnoNvFBar
        dWvNksH1Nih+g
X-Received: by 2002:a05:600c:21cb:: with SMTP id x11mr2121477wmj.189.1614334699782;
        Fri, 26 Feb 2021 02:18:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytuKpxASiF0sNN4YkBGhLIWmhXzJ4sGZrZuxXrHdncfBRU0w9kBKoWgaFTXJRZchMBaA4qng==
X-Received: by 2002:a05:600c:21cb:: with SMTP id x11mr2121466wmj.189.1614334699608;
        Fri, 26 Feb 2021 02:18:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u4sm12283135wrr.37.2021.02.26.02.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 02:18:19 -0800 (PST)
Subject: Re: [PATCH] selftests: kvm: Mmap the entire vcpu mmap area
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     Steve Rutherford <srutherford@google.com>
References: <20210210165035.3712489-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5e8bf9b1-5984-1b30-90bd-e761426caa8d@redhat.com>
Date:   Fri, 26 Feb 2021 11:18:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210165035.3712489-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/21 17:50, Aaron Lewis wrote:
> The vcpu mmap area may consist of more than just the kvm_run struct.
> Allocate enough space for the entire vcpu mmap area. Without this, on
> x86, the PIO page, for example, will be missing.  This is problematic
> when dealing with an unhandled exception from the guest as the exception
> vector will be incorrectly reported as 0x0.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fa5a90e6c6f0..859a0b57c683 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -21,6 +21,8 @@
>   #define KVM_UTIL_PGS_PER_HUGEPG 512
>   #define KVM_UTIL_MIN_PFN	2
>   
> +static int vcpu_mmap_sz(void);
> +
>   /* Aligns x up to the next multiple of size. Size must be a power of 2. */
>   static void *align(void *x, size_t size)
>   {
> @@ -509,7 +511,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>   		vcpu->dirty_gfns = NULL;
>   	}
>   
> -	ret = munmap(vcpu->state, sizeof(*vcpu->state));
> +	ret = munmap(vcpu->state, vcpu_mmap_sz());
>   	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
>   		"errno: %i", ret, errno);
>   	close(vcpu->fd);
> @@ -978,7 +980,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
>   	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
>   		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
>   		vcpu_mmap_sz(), sizeof(*vcpu->state));
> -	vcpu->state = (struct kvm_run *) mmap(NULL, sizeof(*vcpu->state),
> +	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
>   		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
>   	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
>   		"vcpu id: %u errno: %i", vcpuid, errno);
> 

Queued, with SoB chain fixed as suggested by Sean.

Paolo

