Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308984001EB
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349600AbhICPVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349603AbhICPVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:21:30 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D28C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 08:20:29 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w7so5816439pgk.13
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 08:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4CSkZVwfR8F5r/YD5qn9dxPgh6dJZoCpG89KU+T6HLQ=;
        b=ZukqF/2Eu4qstUi5OQuaN3Op8LbOP7aJASN8QpubjqGjsq3tlGkfCWdELg6bIjHhuY
         /r7wj/mQdIaX5MX7DYG9i2q7Rb/BnEsUUG4g1nGDsowqoTLYlfzeoVD9OshAvBG+gUUq
         LQy2ryuaeFKFf9jE9ZuY/VtJPMEjQAzAwtcTpXaxvLCK8V/YzWffqFZmmkeHBYv8OI2P
         Kf/xqCW6KFfgj7Z3Uad9pe/TYAKouyMkbcKKxHsKE59sw3TBQHf8oIRriWOuBzPUknIK
         BqUS/7eEHHxZDu3+wswLo6Xr/B4rUWxA0vmt1LXsS9E8nuRJQ7n9jiAa0huA5ZJq8DXo
         8ieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4CSkZVwfR8F5r/YD5qn9dxPgh6dJZoCpG89KU+T6HLQ=;
        b=e1cUh9Y7WfPQgBs0M8rmxItBBWkApzcgNK24oMQUvHmae7MzUZ7SOxjNnxFu3pALH4
         CkAWDVVouD+KtBgiq5Wcgks4p3HhD3LVJYGd/u8uyJW7IL0ObgKfIIAprkRdG4Cr1usP
         AREgTY5grtRxQaACLbGmJ8aqHRNwht58pjWohBkCOWvRnTJqq5u9N1Rb911UUM0n4lvP
         YACbQCMiChsKdymDcxBHMcykT4IYq4Dzru9HdBEDQ+Sx8y/NiTiY3oqBRu5qERHNbotm
         Wuny84OfZQTW4T5zUwPJgDllnt1wLAIdrCWhtWFLeNmKzoAtvhg5G2kJlKFpz9V9iliH
         3PzQ==
X-Gm-Message-State: AOAM530982hvyyVqdoe6esOVPvB8iI08aaqhmE92H2Euxd3SM/i92j6q
        77Th9BETt1lelIyRgKNNczlENg==
X-Google-Smtp-Source: ABdhPJxymG8cfCUFrFhuqdX1WRR1BbgxyBDR6IlE8cbopkBGiA6E3xFdMJ9GJsU8TC/8n68R/yFT0A==
X-Received: by 2002:a63:78c5:: with SMTP id t188mr4027705pgc.386.1630682428457;
        Fri, 03 Sep 2021 08:20:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c15sm5881007pjr.22.2021.09.03.08.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:20:28 -0700 (PDT)
Date:   Fri, 3 Sep 2021 15:20:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jiang Jiasheng <jiasheng@iscas.ac.cn>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: SVM: Potentially kvfree the ptr points to error
 page
Message-ID: <YTI9OPEStjZqp8Xa@google.com>
References: <1630661986-816436-1-git-send-email-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630661986-816436-1-git-send-email-jiasheng@iscas.ac.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021, Jiang Jiasheng wrote:
> Directly use the sev_unpin_memory() may cause kvfree()
> free the error page, for region->pages may point to the error page.
> 
> Signed-off-by: Jiang Jiasheng <jiasheng@iscas.ac.cn>
> ---
>  arch/x86/kvm/svm/sev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8d36f0c..ee7d691 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1664,6 +1664,8 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>  static void __unregister_enc_region_locked(struct kvm *kvm,
>  					   struct enc_region *region)
>  {
> +	if (IS_ERR(region->pages))
> +		return;

This is completely bogus, __unregister_enc_region_locked() is only called with
@region coming directly from sev->regions_list, i.e. it would require KVM to put
an error pointer on the list.  Aside from the fact that (a) KVM has the proper
error checking and (b) regions are allocated via kzalloc(), which uses NULL and
not ERR_PTR() to signal failure, it's impossible to add an error pointer to a
list because error pointers are not mapped.
