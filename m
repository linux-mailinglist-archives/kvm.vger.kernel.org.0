Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3616929F03
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfEXTXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:23:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43127 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfEXTXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:23:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id l17so2649478wrm.10
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 12:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FfvEgBvczzVOaIiksPBe9Zhmh3gTawDZ+icOnSoWPrk=;
        b=Yn9u2ObJh4kEi5FGPC+kPhAwz3HRNzd9Nq2517WmCCBVGL533XPdC+xvm5KMZ5pzxa
         gmYHAkFWacSeEfJBg0KNGmrqr8Qz9mcPvWPGzmSRUFUk4o0t3b1cT3dTYbE+hmFSaa+m
         FpgCaK9MXucydq7VfXpQl1bj+o20P/+zgsJgzv5jtStMqYNgEPHTsZ6vksgUQu08MGK/
         Mvronwtu6g32hFGLz2D8IQlRq/ohFpu6Y8PvXrtbfcCTbQ7GHZzscqtY1m0eRvdhhWTt
         BCGXF/Q/uMxbAS4iaf/8MfqAtXjLl1jkNivsI99PtQ5hNTRQJbZhJXSKmveeQxI50fBT
         LD+A==
X-Gm-Message-State: APjAAAX9L0wUixx6RqRMe3/oOtp96BjZVJGxxQt98A4B8RJtxc3jQRXV
        kmS5OLr/K4Ad8ircvuzRf08D5rhDPbU=
X-Google-Smtp-Source: APXvYqywO0g1W1KwtVIjuNOlZNm2fExin2mR+fWENFvcjbnHeS5nXwPxAQ5Sa1QElrzOp/ymzRcoFg==
X-Received: by 2002:a5d:638a:: with SMTP id p10mr8854819wru.273.1558725817173;
        Fri, 24 May 2019 12:23:37 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n3sm2002105wrt.44.2019.05.24.12.23.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:23:35 -0700 (PDT)
Subject: Re: [PATCH] kvm: selftests: aarch64: dirty_log_test: fix unaligned
 memslot size
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, peterx@redhat.com
References: <20190523093405.17887-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <683c924b-f67b-6a61-888e-f5c71d29d6cf@redhat.com>
Date:   Fri, 24 May 2019 21:23:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523093405.17887-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/19 11:34, Andrew Jones wrote:
> The memory slot size must be aligned to the host's page size. When
> testing a guest with a 4k page size on a host with a 64k page size,
> then 3 guest pages are not host page size aligned. Since we just need
> a nearly arbitrary number of extra pages to ensure the memslot is not
> aligned to a 64 host-page boundary for this test, then we can use
> 16, as that's 64k aligned, but not 64 * 64k aligned.
> 
> Fixes: 76d58e0f07ec ("KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size", 2019-04-17)
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Queued, thanks.

Paolo

> ---
> Note, the commit "KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of
> unaligned size" was somehow committed twice. 76d58e0f07ec is the
> first instance.
> 
>  tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index f50a15c38f9b..bf85afbf1b5f 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -292,7 +292,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	 * A little more than 1G of guest page sized pages.  Cover the
>  	 * case where the size is not aligned to 64 pages.
>  	 */
> -	guest_num_pages = (1ul << (30 - guest_page_shift)) + 3;
> +	guest_num_pages = (1ul << (30 - guest_page_shift)) + 16;
>  	host_page_size = getpagesize();
>  	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
>  			 !!((guest_num_pages * guest_page_size) % host_page_size);
> 

