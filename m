Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1842F640D21
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiLBS2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiLBS2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:28:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB47DA7FE
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670005624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33ZyAUYenMjlLRX8QFd49i1YF8RHArF5TDtZ248qOZs=;
        b=N6yuYUt5M62uVAnw/Kk/lyUwepWXBERcwszO+xV4blk0gW1t+bIOSCC0QLMHlNBXIVTVad
        cz8wWD5oZUKr1fmNEZRC0ZwQ1OONTSNz16BuxvyuEWeiL4QgZc9eWhSaSoo72EAvgx+fHh
        dWm9WIyOTfjRachTUsEAYeodouEqdjI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-SPbCg1fdPmeozXScQsUyqA-1; Fri, 02 Dec 2022 13:27:03 -0500
X-MC-Unique: SPbCg1fdPmeozXScQsUyqA-1
Received: by mail-wm1-f71.google.com with SMTP id f1-20020a1cc901000000b003cf703a4f08so2240225wmb.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:27:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=33ZyAUYenMjlLRX8QFd49i1YF8RHArF5TDtZ248qOZs=;
        b=fWpAvAaDlOEvQC+xiSS3Yo4GiC2WLgkIUJ1RSfWsxWgRTDUS+RsMmrFCorKk8syIj9
         zLsNAwwVcwcExwNpzO8NZZdutyCXlk0c+XWiuDwGiolmCmGBz4mC2EFaqbhSHg0hDzg1
         r91X4NXcv5+kNRA5mPXgUsIxUZqUmIbfa051EjDLN4ry61smKxVGd1yLbl+0H+6ScLcD
         0M/hHK15oB7XslJypNoqBxYmY2rRZn9yC/ov1n4jPcYQL+h9J4s2Ucif/ay0hhIA9Bmh
         Vw/jMpb4mTG7Syu8XgOXEgT1BWNQjypYxKam7yMTPm23ou0epY/8cs+3eBOPNAzcklqd
         igEQ==
X-Gm-Message-State: ANoB5pnFmIOjZdqPguHLbvX5YBZLJNKOc8PiCxezfu8+m0Qa14kmtyYy
        S33FN1gFte8z46Ge4Gtx9HMtJWiJ3Z3i3i2e+253T6Z7PEfshNnHqZLa84jmeiLfEsGQ+dJxARI
        /+xYgb6rzZSXY
X-Received: by 2002:a05:600c:4e4b:b0:3cf:7624:5fcd with SMTP id e11-20020a05600c4e4b00b003cf76245fcdmr52102164wmq.195.1670005621429;
        Fri, 02 Dec 2022 10:27:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7yV3q4cofRV+TOuSntrtid+pPem3DasxYocHnzyyHvYi0JJq2f7eoPijhRXyKG/bNkn/lg7g==
X-Received: by 2002:a05:600c:4e4b:b0:3cf:7624:5fcd with SMTP id e11-20020a05600c4e4b00b003cf76245fcdmr52102158wmq.195.1670005621205;
        Fri, 02 Dec 2022 10:27:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n10-20020adffe0a000000b00241bd7a7165sm7382927wrr.82.2022.12.02.10.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:27:00 -0800 (PST)
Message-ID: <8e8217f6-4eec-4793-637d-436a429c9aad@redhat.com>
Date:   Fri, 2 Dec 2022 19:26:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: Deal with nested sleeps in kvm_vcpu_block()
Content-Language: en-US
To:     Space Meyer <spm@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kpsingh@kernel.org
References: <20221130161946.3254953-1-spm@google.com>
 <CABgObfby+9JNwrJnjPRp6pty05CqRUfKBA3AB=TNwq4q0KjBTg@mail.gmail.com>
 <CAOLenvZm4aPJAv5O+iybMxJoD-ZeytbJ=9o1nLVSh+84uj2U8g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAOLenvZm4aPJAv5O+iybMxJoD-ZeytbJ=9o1nLVSh+84uj2U8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 16:52, Space Meyer wrote:
> The bug doesn't seem to be easily reproducible, but looking at the
> code this should also be applicable for the upstream 6.0, 5.15, 5.10,
> 5.4, 4.19 and 4.14 branches, which have not received a backport of
> 26844fe.
> 
> Do you think this is all we should do? My conclusion from the LWN
> article was, that we should avoid the set_current_state ->
> conditional -> schedule pattern when possible as well.

Yes, the bug is there but unfortunately the backport is not easy.  I 
don't really feel confident backporting the fix to older kernels; even 
if it is apparently just a couple lines of code, event handling is very 
delicate and has had a lot of changes recently.

Paolo

