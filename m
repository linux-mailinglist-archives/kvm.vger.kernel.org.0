Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861CB437855
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhJVNuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 09:50:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230342AbhJVNun (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 09:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634910504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AFmaoASDnexdE5qQmKYftfXRHv4WPfWCY1vwNo1gixg=;
        b=MMGu63Z5xXsPohHXcQpR+jRLMz/ryj59mH0aJYLmYRC6Vor+irzx0l/nbRcz8ajxN6EYuC
        5p8GjKmeIwJ08qlk6xCxrvNf/zWOG7R9PY/JPup0l6AJcBm7xn6ST4rrcXUUsz3UuBEgSG
        cHQGud/VjvF1fiqD+z0wwsWEQIC55ic=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-5jM8C3wHOO2gVSlaMYq_-Q-1; Fri, 22 Oct 2021 09:48:23 -0400
X-MC-Unique: 5jM8C3wHOO2gVSlaMYq_-Q-1
Received: by mail-wm1-f71.google.com with SMTP id l187-20020a1c25c4000000b0030da46b76daso1153470wml.9
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 06:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AFmaoASDnexdE5qQmKYftfXRHv4WPfWCY1vwNo1gixg=;
        b=pv2f+XSZfQfKw6y4t/OyE1QWHgJta2oF6PJrVUssJGOciEvhMkr6MR6P2MRx4jkkPW
         sgjKAQHsX/aZ8igBoY41KNCiImKylh9cR3QWPBF+lNFao7nBQf8eeJxq54mtU6xI45sC
         jmg4u+qLKXqlC1qC0Ln908Tc0KMOWLiineqpLh+NTs51W/+gKUDoR4GaC1h64x84/aMf
         QvkHmgA8NZQgxGo1Jgu1vczAUlE4G5hArD9FN5PadhOxFWR80CiXmBu0/DyuL4GrSrAU
         VbTk4VaU+R8/+wG1AiV97ZOd0jg0oZyTWw5KVVJYpkmVOvOy1qaP6XR8U3TZMSKB1aeD
         h5TA==
X-Gm-Message-State: AOAM532mUr4k60I1qP40IHiUvnME6JGEe4cgrIXLDhoASI8ne0o7uuQM
        2hh83+pGu9KlOVjXLyO8fznlX9bLYpb+1I/jFIjV1M4RFQ44l7z2wl/4+tbJPG4sd/ApYievIRJ
        AfEpR6vHiVMOU
X-Received: by 2002:a05:600c:3511:: with SMTP id h17mr28648710wmq.144.1634910502385;
        Fri, 22 Oct 2021 06:48:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcb9UsH4+XyNMhSajPj+HJcLfs6908IOjXwLy/YhyfZQEySIf0pwRdUhBu0EDwAJytLic7lA==
X-Received: by 2002:a05:600c:3511:: with SMTP id h17mr28648682wmq.144.1634910502194;
        Fri, 22 Oct 2021 06:48:22 -0700 (PDT)
Received: from localhost.localdomain ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id v18sm8270951wrm.63.2021.10.22.06.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 06:48:21 -0700 (PDT)
Subject: Re: [PATCH v3 4/8] nSVM: use vmcb_save_area_cached in
 nested_vmcb_valid_sregs()
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20211011143702.1786568-1-eesposit@redhat.com>
 <20211011143702.1786568-5-eesposit@redhat.com>
 <48953634-5b7c-72d6-5fcb-a1b25800f443@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <f374979b-e2e3-ca6c-9055-a5e9ac107a2d@redhat.com>
Date:   Fri, 22 Oct 2021 15:48:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <48953634-5b7c-72d6-5fcb-a1b25800f443@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22/10/2021 09:14, Paolo Bonzini wrote:
> On 11/10/21 16:36, Emanuele Giuseppe Esposito wrote:
>> +
>> +out_free_save:
>> +    memset(&svm->nested.save, 0, sizeof(struct vmcb_save_area_cached));
>> +
> 
> This memset is not strictly necessary, is it?  (Same for out_free_ctl 
> later on).
> 

It was just to keep the struct clean in case of error, but
you are right, it can be removed.

Thank you,
Emanuele

