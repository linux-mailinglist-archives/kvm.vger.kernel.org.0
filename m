Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8395943B6F4
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhJZQVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:21:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236157AbhJZQUa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635265086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtrZ02+a7Y6c2uG+Rvt1nh9ebvVZMP9HOLLjO1Lvlk4=;
        b=Q79sFFXPNNYJI0QtLSqUL/qN67tJpNWB5kEWKK3zJ1X8JIz8PIInRN850mXqG8y+hEzOI4
        zjclXq1BDGYTsYJgoXiMtxSDfd6G6smHfPkFuHh3ZNxVvQ+Fh/dgHpnOCUXeeeQxPXaGjR
        VZfriYzn/f2mWQDFJ8wAT12uZw91zhw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-zMhI7GJ0Mxi-6hWwaj-RxQ-1; Tue, 26 Oct 2021 12:18:04 -0400
X-MC-Unique: zMhI7GJ0Mxi-6hWwaj-RxQ-1
Received: by mail-ed1-f70.google.com with SMTP id q6-20020a056402518600b003dd81fc405eso2679815edd.1
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rtrZ02+a7Y6c2uG+Rvt1nh9ebvVZMP9HOLLjO1Lvlk4=;
        b=iF5zgW28zqW9Bhi3QqN1ZBeiE1UsWFoUhwPbJTNpr0CMtoSbZtLGUchLO9RTeD6uap
         4yDtvPv0p1CO3HJK4F7wpm9IbHYGA5SZ2h6g20myato5+JvCRYjrxCHP19nwdQ0NN7Pu
         PimqWdaXn4lSVSUGy19MYFbC67yEEuFpAqsBXOLhpjXIR5xLs3eOCMTYrTArZM5eb8nV
         eR9YKgvN9Vlk7R7M7vgvJSjIyBzon/NGiLMogsx2vuyUOwCr5GSWA/HBauqdCxSWvv1E
         IChGGd38DzsS1lSHpfheOx4MffxJcu9zlnbhmS24CT8GfJdbmPhjB4LVSyHj3F0d/uqC
         mTkg==
X-Gm-Message-State: AOAM532KChc9ooyy6NWpgFk/juNMtSKvFj+d5WGAcpMJfhLI5f+UgqeC
        Jr7Thh/MP3e6+u8ZOYl8f/K3uaj2vGiTi++Q7IDqAvUg4xv29PABEHl3utbo131s0WVYu0jqRYV
        d7GwtMcL5EzsJ
X-Received: by 2002:a17:907:2071:: with SMTP id qp17mr1252072ejb.284.1635265083448;
        Tue, 26 Oct 2021 09:18:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUxAVnxfpnlov0+lOdcRwDqyC6BZ9EUFd/Acu3BIsW9KtyvlZtiHR+/eTmsV9k5nuSJEYMUg==
X-Received: by 2002:a17:907:2071:: with SMTP id qp17mr1252035ejb.284.1635265083192;
        Tue, 26 Oct 2021 09:18:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j11sm4679905edt.49.2021.10.26.09.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 09:18:02 -0700 (PDT)
Message-ID: <7e3fb7c6-265c-d245-dd97-24ab401a8ea3@redhat.com>
Date:   Tue, 26 Oct 2021 18:18:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] kvm: Avoid shadowing a local in search_memslots()
Content-Language: en-US
To:     Qian Cai <quic_qiancai@quicinc.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211026151310.42728-1-quic_qiancai@quicinc.com>
 <YXgib3l+sSwy8Sje@google.com>
 <60d32a0d-9c91-8cc5-99bd-7c7a9449f7c1@quicinc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <60d32a0d-9c91-8cc5-99bd-7c7a9449f7c1@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/21 18:14, Qian Cai wrote:
>> Maybe "pivot"?  Or just "tmp"?  I also vote to hoist the declaration out of the
>> loop precisely to avoid potential shadows, and to also associate the variable
>> with the "start" and "end" variables, e.g.
> Actually, I am a bit more prefer to keep the declaration inside the loop
> as it makes the declaration and assignment closer to make it easier to
> understand the code. It should be relatively trivial to avoid potential
> shadows in the future. It would be interesting to see what Paolo would say.

You both have good arguments, so whoever writes the patch wins. :)

Paolo

