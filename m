Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5BE367B19
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhDVHbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:31:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhDVHbO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 03:31:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619076640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XgTehN3/NyaVKZ7FW4MkOjMjlpGG8PCtMVmQI1FgYuU=;
        b=acBMMVnV2shJSXHc5SWU0EPBTeKc9WbCeqmEKOZcgYYVywkWMh1USO5pHZR+RARVCIrksT
        BkzeUHL0AJGoHGuumsGdhj3PFi/Feoe7z1m/yWHgIGspZooWQjmgxgPF0QI1sFghvkh0Aa
        SeuJkdYGW+0/0iB97HkrnFcP2zBS9Ns=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-P_snl3j0P2ahk4YfqFtMFQ-1; Thu, 22 Apr 2021 03:30:05 -0400
X-MC-Unique: P_snl3j0P2ahk4YfqFtMFQ-1
Received: by mail-ed1-f70.google.com with SMTP id c15-20020a056402100fb029038518e5afc5so8731780edu.18
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XgTehN3/NyaVKZ7FW4MkOjMjlpGG8PCtMVmQI1FgYuU=;
        b=LxmBBZIeqOFigmzaaEBPaBola/nvMPZy/eVsMfufMPgpkl0Fixoh5AF3o9zi+la2U8
         O15ioa3eEleeA0k42sKEPY1QLUl/JYB7eqXr245adtvY9ilFyyQx161Oa77VQt0rjfEs
         HGL6qhK2s4VHZMn5nxoTGTOGuwKvwRm10tunUaKDWgdcE74i9mXS6L7Kn8M2S1E3a8Ur
         F01J3XquD3HpJolphmGIoMsrHgM6671a1l65JuO0FMg+mQpLtEKwHHNZ2LbjhR9B82Kv
         s0iv5nWJOKI0WVfwefbN4SzpxjLHT7tPyzoCP8FQ9W+PUhrN5KAs9n1D+fG9yXvDX+H0
         9COw==
X-Gm-Message-State: AOAM5317INBNdVZvLBa/Al7dic4ntLvBgURQ5yHoTqImXO+5DUisXWr3
        l6ukiDBS/Gr5MJbzmN9wZEL2HjVdcjqFqRTMY8rhdx4m+Xr6dSgusRkSXMm+nxtStY1dfEJuLL2
        PyK2zEMoM5V1B
X-Received: by 2002:a05:6402:451:: with SMTP id p17mr2050247edw.223.1619076604148;
        Thu, 22 Apr 2021 00:30:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiNMCMSKUrm1BcR/2l+x4SSrt+dlYKfzqOC2tNMELsxcx0vTAuCEjJNb0Lu5qru537VaKKnw==
X-Received: by 2002:a05:6402:451:: with SMTP id p17mr2050227edw.223.1619076603937;
        Thu, 22 Apr 2021 00:30:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z17sm1297427edx.36.2021.04.22.00.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 00:30:03 -0700 (PDT)
Subject: Re: [PATCH v5 15/15] KVM: SVM: Skip SEV cache flush if no ASIDs have
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
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-16-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a7e15de5-5b04-7a33-1d7d-81edf07193ba@redhat.com>
Date:   Thu, 22 Apr 2021 09:30:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422021125.3417167-16-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:11, Sean Christopherson wrote:
> +	int ret, pos, error = 0;
> +
> +	/* Check if there are any ASIDs to reclaim before performing a flush */
> +	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
> +	if (pos >= max_asid)
> +		return -EBUSY;

There's a tiny bug here which would cause sev_flush_asids to return 0
if there are reclaimed SEV ASIDs and the caller is looking for an SEV-ES
ASID, or vice versa.  The bug used to be in __sev_recycle_asids, you're
just moving the code.

It's not a big deal because sev_asid_new only retries once, but we might
as well fix it:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 02b3426a9e39..403c6991e67c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -74,12 +74,13 @@ struct enc_region {
  	unsigned long size;
  };
  
+/* Called with the sev_bitmap_lock held, or on shutdown  */
  static int sev_flush_asids(int min_asid, int max_asid)
  {
  	int ret, pos, error = 0;
  
  	/* Check if there are any ASIDs to reclaim before performing a flush */
-	pos = find_next_bit(sev_reclaim_asid_bitmap, max_sev_asid, min_asid);
+	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid);
  	if (pos >= max_asid)
  		return -EBUSY;
  

Paolo

>   	/*
>   	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
> @@ -87,14 +92,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
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
> @@ -1846,10 +1844,11 @@ void sev_hardware_teardown(void)
>   	if (!sev_enabled)
>   		return;
>   
> +	/* No need to take sev_bitmap_lock, all VMs have been destroyed. */
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

