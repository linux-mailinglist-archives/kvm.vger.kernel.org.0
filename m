Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0BB45F4CB
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 19:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbhKZSpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 13:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbhKZSnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 13:43:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2637C061A31
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:15:31 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l25so41904478eda.11
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWT8MdNNggjQhE1QwTfOzg3dLrU8rxwDOUm5noHLVXI=;
        b=Y2ljIOBiwjRZ6RerrqUZ9SoEf6JdS6PxByejsXkA2D5FYUc8IVum83FdECmlgMsqZv
         lm6Mee+ilAcAA+6t2aqaKWTuu4rxWabmaLUS+iBZj+eeeicdCuYu88s2+CuJOyb2rtOn
         8lAOaLOPF+je8kkbGTLncujg+e/rzuWvrgPNgtVaHqxeZnDJTknm9nuu95GacfbK4gJW
         JONQ0sa5eFVb3M0YTsWLFp7LEeplN+Xy2ldkiTCI7m6AHX4jaPTO674czAbh0uBGSqe9
         ySR+jiCiajh+/weRHey62rTk1hjYc9WKphrIpkA/a0BtSG1uYdGeHl36TKqLTYDwwnaB
         YSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWT8MdNNggjQhE1QwTfOzg3dLrU8rxwDOUm5noHLVXI=;
        b=8D99xkkn9V2EWF120t1oJ0rIvK7bB7BDO/fyc8Ws406vu0BJMFvmtwzDSPzPmuxbZu
         TjRf2FinMzNQNFB/aIttG2tZrTBvzFVaU2cPv1KUgrAGIr9HVHFjBEfXx/NYg5XoWP73
         7bv6x0mZ9KLVciPdyB59rNjnJQ6hrPHiDWMIVUQ0zuvCSZQWy7PgCnCjC92fcQ3QHSOB
         kdlV03aAJcIc6Awjzf7YrA7hA/ewHWDxm+UWtlkcABL9eU3PyDCQCbKF9Jp4vDY8lePF
         YDs7VLtu2MBrB9qqQIGBOPiytrbKRRpmiCRrTDKNcXAd486u//azgnBCUu2FOEbvrwUE
         nUKg==
X-Gm-Message-State: AOAM5322UqK0qtphPhY2w0oWV1w5kXjrne0Lkiee1Zk3fDVourVCerjb
        xBaySZPKS4e1AKFZ1D6VpoF+hMY9NC0=
X-Google-Smtp-Source: ABdhPJwFypDIYxyy1MtiW2H+i8v0zNTD9dgrHLbxrkusk6Xs9OU1WU4nSf6BkkMKDrPFbQICTlQ0Mg==
X-Received: by 2002:a17:906:f0d4:: with SMTP id dk20mr41107426ejb.257.1637950530434;
        Fri, 26 Nov 2021 10:15:30 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id v13sm3273586ejo.36.2021.11.26.10.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 10:15:29 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f2bcaee1-6dab-0858-4004-edc13cbb6d90@redhat.com>
Date:   Fri, 26 Nov 2021 19:15:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 13/39] x86/access: Pre-allocate all page
 tables at (sub)test init
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20211125012857.508243-1-seanjc@google.com>
 <20211125012857.508243-14-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125012857.508243-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 02:28, Sean Christopherson wrote:
> -static _Bool ac_test_enough_room(ac_pt_env_t *pt_env)
> +static void __ac_test_init(ac_test_t *at, unsigned long virt,
> +			   ac_pt_env_t *pt_env, ac_test_t *buddy)
>   {
> -	/* '120' is completely arbitrary. */
> -	return (pt_env->pt_pool_current + 5) < 120;
> -}

Ok, so the early change to the "pool" logic was mostly cosmetic as it 
goes away.

Paolo

