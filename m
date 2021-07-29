Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627B73DA04E
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhG2JfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:35:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235622AbhG2JfM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 05:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627551309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GL8yo4T1lYqtt20r6KuqjoBVUtGlVQrRHRnGsjw+oeA=;
        b=V2lHpTwMlM1h4BKsT85gFDV9RwNj7zIwiiCU5ftovZAQHH36q7mBwmYdYq5rR70SlSA0Mu
        rFSTlSugYna14iFPaewty6QGwZI+xavOiB2Nd6/4eeek6VJqjJyo+an6/geFOV3/jikM5d
        J4vJ4XMyWtRYSXNDp07yXErxsggjAEk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-ect2ZPRCNlK3Nt9rBCnUZQ-1; Thu, 29 Jul 2021 05:35:07 -0400
X-MC-Unique: ect2ZPRCNlK3Nt9rBCnUZQ-1
Received: by mail-ej1-f69.google.com with SMTP id a19-20020a1709063e93b0290551ea218ea2so1788444ejj.5
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 02:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GL8yo4T1lYqtt20r6KuqjoBVUtGlVQrRHRnGsjw+oeA=;
        b=oOqfadoQ5Bv/i+uckFgeRiQB/hFnDkl7c77phbvh8lrgkz9g5MkN9jqSSKVLK4jAKt
         0/o2TiMcpUIAfQHOmUEK5YEBILEMYxVcDfrPfAiXAkLDJDo8vB60gjyETsc2V/M+1x/L
         wdfUe/oLUXuBibqSCiT0al58eGjtg1REhEpcE+466r53w6JI/Q0imcpB5Djr4aNx/axx
         p1Fk/jrvtaVsxMXVgw79RmGzowPLSw7MniKPZXuIl2yfo4y8DwC1pzwKka4EeMaqJRsN
         jayUtKkIIILx5cjEPK6zg6vSuzDQd4uh8x8n4+62Gy2LlmdPk0qf6i9ZxR/Mn/OtjvNV
         SZ2A==
X-Gm-Message-State: AOAM533UX1h8SfApNX5PxZVSAymdhHutzXtpBRXq+pr6jU9ioFOJsDFy
        dj+TDW+V0ZQaLJTStywYQAVVupTgadn0OqwAAAhams9c+sKa/gknDMqFfrpGuGmXGFLuHAdqI57
        0XIuufG6kIy/k
X-Received: by 2002:a17:907:2bd0:: with SMTP id gv16mr3889705ejc.49.1627551306420;
        Thu, 29 Jul 2021 02:35:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyDBQjZYIdLYt3llFOHVemIJWYi3AdcSIncArF9cUKmxLCuKQxPAnyKhTmwPhu61dMMjraXw==
X-Received: by 2002:a17:907:2bd0:: with SMTP id gv16mr3889691ejc.49.1627551306230;
        Thu, 29 Jul 2021 02:35:06 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id s24sm786053ejd.19.2021.07.29.02.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 02:35:05 -0700 (PDT)
Subject: Re: [PATCH v2 9/9] KVM: X86: Optimize zapping rmap
To:     Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153419.43671-1-peterx@redhat.com> <YQHOdhMoFW821HAu@google.com>
 <YQHTocEdMzsJQuzL@t490s> <YQHa1xuNKhqRr4Fq@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c2c83189-6bc4-1f3b-36da-be19b940dcf9@redhat.com>
Date:   Thu, 29 Jul 2021 11:35:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQHa1xuNKhqRr4Fq@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/21 00:31, Sean Christopherson wrote:
>> If that'll be a performance concern, no objection to hard code it.
> It's more about unnecessary complexity than it is about performance, e.g. gcc-10
> generates identical code for both version (which did surprise the heck out of me).

If you think of what's needed to produce decent (as fast as C) code out 
of STL code, that's not surprising. :)  Pretty cool that it lets people 
write nicer C code too, though.

> If we really want to isolate pte_list_destroy(), I would vote for something like
> this (squashed in).   pte_list_remove() already calls mmu_spte_clear_track_bits(),
> so that particular separation of concerns has already gone out the window.

Yes, that's fair enough.  Thanks for the review!

Paolo

