Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA1A30793D
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhA1PMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:12:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232564AbhA1PL5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 10:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611846630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+wQuziv7z+Yh3SvyIM831IdGc6/wY1UoY9rflWt+jk=;
        b=QoUhuoG6if0xbFmgw8R1ycsEZGT15oLq+1AcV/ZY0233Tjz5HH2bVl5pE/VLZKu4NnHhfn
        P0CXqj5K5pB6Ej3yYcrBEWcmhf773BRX9UKW7UzaOFTjc3MyAqU2+DzS8FXbdbhepdj1eC
        mExOgS03J3v2Vl9keM6KlZKbk/3k1bI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-2QVuR9vBNWiZcGpKSBnZjw-1; Thu, 28 Jan 2021 10:10:28 -0500
X-MC-Unique: 2QVuR9vBNWiZcGpKSBnZjw-1
Received: by mail-ej1-f69.google.com with SMTP id j14so2306368eja.15
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:10:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b+wQuziv7z+Yh3SvyIM831IdGc6/wY1UoY9rflWt+jk=;
        b=Wi3kMxYRDh7t3k7/b6wNOnAv+9bVfvNeoD4tpvuPbbSpjB7fuoJ+V1sfnpZQ5Tb20U
         hO1EOh9QDwfqQe7TULIM42k0dl3mThJTGhDzLI/bDnNASWl/zbTs2XjsNUsqQAw5Peq4
         ompQdg7ySOprfCc4Es0lxYnVM9uKBFp81xFo6I9TsYmefxxPf6/XSfe1dIeufut2SGq7
         XxCTYmwFw2BiXf9hB3J8ONhXRb5bm4O0Wdi1FR+e4YUuQO2eFv9DpzThQwkiF1W2GUk/
         p+K3bXv/o49HhDIKMTxrflfSQmI7BIWvruQCZAdk/DM0XCFswpA74b39WWKuFUNCYGCv
         J7Bg==
X-Gm-Message-State: AOAM531M/2Pn8UzuIrJzWM8RU+QDsIFfGZGM8gfKL/WEGcetQ0+kzB9P
        0l05/cd0D24y5UXKrfguzKFoeTNjZCdqYqwLvCAVKVSIRWr9PaVXO76UueJGeWrV1KvMJgxnFuf
        /zq+0nxqrxpkd
X-Received: by 2002:aa7:c60a:: with SMTP id h10mr14463150edq.263.1611846627226;
        Thu, 28 Jan 2021 07:10:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvrLkS9YX15WjbJzHD3ylCnm409ccs+e5aYflwjJrItwYKGebUACH43o772Xm79wLkpepznQ==
X-Received: by 2002:aa7:c60a:: with SMTP id h10mr14463129edq.263.1611846627073;
        Thu, 28 Jan 2021 07:10:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r11sm3119537edt.58.2021.01.28.07.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 07:10:26 -0800 (PST)
Subject: Re: [PATCH v2 14/14] KVM: SVM: Skip SEV cache flush if no ASIDs have
 been used
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-15-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <55a63dfb-94a4-6ba2-31d1-c9b6830ff791@redhat.com>
Date:   Thu, 28 Jan 2021 16:10:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114003708.3798992-15-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/21 01:37, Sean Christopherson wrote:
> Skip SEV's expensive WBINVD and DF_FLUSH if there are no SEV ASIDs
> waiting to be reclaimed, e.g. if SEV was never used.  This "fixes" an
> issue where the DF_FLUSH fails during hardware teardown if the original
> SEV_INIT failed.  Ideally, SEV wouldn't be marked as enabled in KVM if
> SEV_INIT fails, but that's a problem for another day.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 23a4bead4a82..e71bc742d8da 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -56,9 +56,14 @@ struct enc_region {
>   	unsigned long size;
>   };
>   
> -static int sev_flush_asids(void)
> +static int sev_flush_asids(int min_asid, int max_asid)
>   {
> -	int ret, error = 0;
> +	int ret, pos, error = 0;
> +
> +	/* Check if there are any ASIDs to reclaim before performing a flush */
> +	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> +	if (pos >= max_asid)
> +		return -EBUSY;
>   
>   	/*
>   	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
> @@ -80,14 +85,7 @@ static int sev_flush_asids(void)
>   /* Must be called with the sev_bitmap_lock held */
>   static bool __sev_recycle_asids(int min_asid, int max_asid)
>   {
> -	int pos;
> -
> -	/* Check if there are any ASIDs to reclaim before performing a flush */
> -	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> -	if (pos >= max_asid)
> -		return false;
> -
> -	if (sev_flush_asids())
> +	if (sev_flush_asids(min_asid, max_asid))
>   		return false;
>   
>   	/* The flush process will flush all reclaimable SEV and SEV-ES ASIDs */
> @@ -1323,10 +1321,10 @@ void sev_hardware_teardown(void)
>   	if (!sev_enabled)
>   		return;
>   
> +	sev_flush_asids(0, max_sev_asid);
> +
>   	bitmap_free(sev_asid_bitmap);
>   	bitmap_free(sev_reclaim_asid_bitmap);
> -
> -	sev_flush_asids();
>   }
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)
> 

I can't find 00/14 in my inbox, so: queued 1-3 and 6-14, thanks.

Paolo

