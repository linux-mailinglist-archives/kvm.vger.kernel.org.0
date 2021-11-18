Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6DB4561BD
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 18:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhKRRvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 12:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhKRRvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 12:51:23 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9246C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:48:22 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 136so6108778pgc.0
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CfdxEdXslR2oVzsVzclVq0hJrKFZ2Qpq+V3kJIPWZNk=;
        b=We7sJw/oumluwtRGa+yA2tX3O/Pghbk7M4/jhSvZqZ2JB1/Uw01sciZQrCuxTk+AfG
         Q4dXK/0t31NjwaXKopizYm1hdrH6CKsItzcAIj1v1HRqQouDIMnQZDEGz2lRS/rHqOG8
         lD6OfRSz4wFE6b1vzCEVsxfl+BOjT4GeZ6XhKvQxqz54U8jlNNDupNHC3gBaWoeJDWd6
         /rEOelTsuGwFSdjNZgVszFZjMBnpw8ZCZRxc0jWPBETdPoTlz8ic4bL44Lg4Bwb2GaW5
         K+46One8VeCDyzFfjVaUHvkSLrfJoIUOz3XjYp7zwjO86eqcd2SUhAh73/xfWeigRN0q
         PD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CfdxEdXslR2oVzsVzclVq0hJrKFZ2Qpq+V3kJIPWZNk=;
        b=H8b9C6CTpE2g7N9hUXIXqyuSWo1fuX2PGWIO+oNVOeikdu913O4kmgUuvvbooT1vyX
         NWoqpE2m3JqNu2NBzTGt1/2yOaX1BUZyf71pGDLXp1eEcFeEs6ZavEX4kdfSyNgYFxYA
         kRK8Ni/UuhtNNQEskPj/WJSuY1H8d4U1/16yUqfKsOwWAP7jY6NLLmDjL7qoSAYDKf+i
         ZCRoeSaAFZtTnDQFvW2r2aTOiOg64wESbGxllq3qflj/Jh6MnC+mfmYs67jauyvP9Hqg
         t1W2MMCd0QTl+c3G7MrF6oU7WRzy5tSG6on0KL5S385P2SXyjHJBJMyIzMpGi9dnBwi9
         iENw==
X-Gm-Message-State: AOAM533fMGhkKhRsijgOXm8Ur3vqGy3d/ENYApQBdmr06sYAY9qqZCK0
        MZwMFnDAsFah7ftxA6JpctYOLg==
X-Google-Smtp-Source: ABdhPJx/K5vTuknkNzdb4L245ma/MdAQJ17DKtltFnHyi2rN/3X39SStEpwxLfEG2XBbkUfpeB9Psw==
X-Received: by 2002:a63:d110:: with SMTP id k16mr12389762pgg.90.1637257702083;
        Thu, 18 Nov 2021 09:48:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u6sm241496pfg.157.2021.11.18.09.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 09:48:21 -0800 (PST)
Date:   Thu, 18 Nov 2021 17:48:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: Re: [PATCH 4/6] Increment dirty counter for vmexit due to page write
 fault.
Message-ID: <YZaR4U5r3j7zWBIF@google.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-5-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211114145721.209219-5-shivam.kumar1@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 14, 2021, Shivam Kumar wrote:
> For a page write fault or "page dirty", the dirty counter of the
> corresponding vCPU is incremented.
> 
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
> ---
>  virt/kvm/kvm_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1564d3a3f608..55bf92cf9f4f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3091,8 +3091,15 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  		if (kvm->dirty_ring_size)
>  			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
>  					    slot, rel_gfn);
> -		else
> +		else {
> +			struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +
> +			if (vcpu && vcpu->kvm->dirty_quota_migration_enabled &&
> +					vcpu->vCPUdqctx)
> +				vcpu->vCPUdqctx->dirty_counter++;

Checking dirty_quota_migration_enabled can race, and it'd be far faster to
unconditionally update a counter, e.g. a per-vCPU stat.

> +
>  			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +		}
>  	}
>  }
>  EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
> -- 
> 2.22.3
> 
