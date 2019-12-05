Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED2113F37
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfLEKSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:18:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38662 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729017AbfLEKSN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 05:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575541091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rrJ2QpeOD1T6UGSZxBKj4bnGbZCCWof+wP8aUHJYy/8=;
        b=P+G35NpyG5qoHXartKYpb/x3tfZyBae6ST8aDPau7ac+sfzMr86Am6kkSmjUFOrxhlpVyD
        GMo6rOXL1aPe3UHYGyOBhQCaWwZ2NIG5dyJdx+PGNWXGCp3qj+XTqpoLLrLew5McTKjJn8
        kFEBaZY+CXbsSQs+1xDKFE8kNhHouDY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-oumjyAIeNEqkks8zM5RRfw-1; Thu, 05 Dec 2019 05:18:10 -0500
Received: by mail-wr1-f72.google.com with SMTP id 92so1326730wro.14
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 02:18:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rrJ2QpeOD1T6UGSZxBKj4bnGbZCCWof+wP8aUHJYy/8=;
        b=pd93WJxCaZL5Z0TwIsQQa2eS+QSpS5LXG6c2kCknoiA0govHi1H/ALdHHAXWCpmlMg
         9K753CoYof3AZV/5gGxCgH5Ft6A4G2eDsTtzu25DdSz+aCJb1rgC8t7t6IbXJSFVadFR
         GFBY//bm7GlcAbiuXVrF5nvHvjGd1InyIHJbFIF+Ssb8NNjMuJ1RKPiouT/2sKFIUt40
         pbHexpJVPnujIgqg37y3M9QzPE0/YBTZcN8eJL9R32ojWzMwAMxHAqyLwK1W42vSimT2
         kYpC8b+eVA0h0sWLZaytT24j2Wrhz6KHNoDFvW7PMzpqiXwU07sNSIn49rcTLcitOzpw
         LS0Q==
X-Gm-Message-State: APjAAAX04SMzCsfdTrPXt5W++4IPCDyuoZBUDzbQdjGRZsF+X/62xOBl
        b1ATiVcjkhTb918OEH1aRsNoW3+N7ZzSpsqAVQhNaq4AbMqXcrlH+h1tiM7Ag1jcCOyK2rhQoZx
        DNRF15FNUXnh1
X-Received: by 2002:adf:c74f:: with SMTP id b15mr9102703wrh.272.1575541089032;
        Thu, 05 Dec 2019 02:18:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9KpijdtwrciYuh/BwTYlT6yukw04yKTCUYkRGS6I9sNL+NECO7fX2tcX67XlyzUJLfJUBFw==
X-Received: by 2002:adf:c74f:: with SMTP id b15mr9102686wrh.272.1575541088803;
        Thu, 05 Dec 2019 02:18:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:541f:a977:4b60:6802? ([2001:b07:6468:f312:541f:a977:4b60:6802])
        by smtp.gmail.com with ESMTPSA id f12sm9612263wmf.28.2019.12.05.02.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 02:18:08 -0800 (PST)
Subject: Re: [PATCH] KVM: get rid of var page in kvm_set_pfn_dirty()
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1575515105-19426-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dbb89c0e-73f1-84a7-7f47-05ee886ba8f1@redhat.com>
Date:   Thu, 5 Dec 2019 11:18:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575515105-19426-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: oumjyAIeNEqkks8zM5RRfw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/19 04:05, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> We can get rid of unnecessary var page in
> kvm_set_pfn_dirty() , thus make code style
> similar with kvm_set_pfn_accessed().
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/kvm_main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 00268290dcbd..3aa21bec028d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1931,11 +1931,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
>  
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
> -		struct page *page = pfn_to_page(pfn);
> -
> -		SetPageDirty(page);
> -	}
> +	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
> +		SetPageDirty(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
>  
> 

Queued, thanks.

Paolo

