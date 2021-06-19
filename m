Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F673AD85B
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 09:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhFSHFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Jun 2021 03:05:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234150AbhFSHF1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Jun 2021 03:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624086196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ML4REiy5OkcaqfJ6brk7+RfQQvQg3ZqoRzOqMYC4CQ=;
        b=J0F5GsHhMdf4BjcqmRPbvxjekUgLvI8ieIlqkO+70qHtKV/eoSgGnb4CRKOZTdUAGtzPKe
        Dt/NNKKWK5OPBPGQ9nNJ2RT0HATEAatgN9CHg5AFwI9RXhmIlqNCyz27mmtrcEyTCyKunB
        YTAmIpKU/GxGZeXwEmh7hPdQAP+/QGI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-7APu7AgjNbuNhsnJaRseYQ-1; Sat, 19 Jun 2021 03:03:15 -0400
X-MC-Unique: 7APu7AgjNbuNhsnJaRseYQ-1
Received: by mail-ed1-f72.google.com with SMTP id z5-20020a05640235c5b0290393974bcf7eso4540968edc.2
        for <kvm@vger.kernel.org>; Sat, 19 Jun 2021 00:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ML4REiy5OkcaqfJ6brk7+RfQQvQg3ZqoRzOqMYC4CQ=;
        b=tRlJt4PZI5jRHZHec+GJ+2E5PkXz2bjHmg2HRWasxknHS3czOOiG7rvyEhIITwqiHz
         GmjcJEnUoSn8qAfocBVR/N4YszJnRhoAzHog5dfW5tgdVsiHJ/XnoAhV7RdyMQfXWUiA
         1vliqk0OpJEK8l+VXmBjz5QIGOsU9nV9/sDrTeplvY0SCc4FJLB6Xf4vpPE+SN5Im/75
         f8p6yBjHuY6yzBvQDydKxE3SPLCfvmokojgIBCV8uo6LeEgeoCJp0e9qkXKlZlO990om
         cp4/ZoQl3oAUhqdoEAKQ3oX2uMpM6MUYyL+9+/f7lIhOGKAr62K4efBsyKQGVtMQquYr
         twRw==
X-Gm-Message-State: AOAM530vZ9dwv7DjT8X6hZasjtYysUlNT4DXf3VRD9bZv+dfUYo9/CWe
        tI5Dxq9priU/GJ21cml6Brncs59nfZlRML8UpqiiSwLBNF4eTN64MRT0Gl+hsEmDaSaVXV/5SGs
        a9BLQsHWJRsG8
X-Received: by 2002:a05:6402:2317:: with SMTP id l23mr9400533eda.265.1624086194034;
        Sat, 19 Jun 2021 00:03:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhkU4ORZu2NUVqekm38wER3uTsadAxLzHjeKIBOfzZkIl9xiP0Gksb8acUUBxOaPCJVpfJRA==
X-Received: by 2002:a05:6402:2317:: with SMTP id l23mr9400523eda.265.1624086193880;
        Sat, 19 Jun 2021 00:03:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hx18sm448140ejc.82.2021.06.19.00.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jun 2021 00:03:13 -0700 (PDT)
Subject: Re: [PATCH v3 8/8] KVM: x86: avoid loading PDPTRs after migration
 when possible
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
 <20210607090203.133058-9-mlevitsk@redhat.com> <YM0H3Hvs8/3+twnc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <289ac328-703f-6eb0-292e-99b1eda08784@redhat.com>
Date:   Sat, 19 Jun 2021 09:03:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YM0H3Hvs8/3+twnc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 22:53, Sean Christopherson wrote:
> The bool is essentially an extension of
> KVM_REQ_GET_NESTED_STATE_PAGES, I think it makes sense to clear the flag whenever
> KVM_REQ_GET_NESTED_STATE_PAGES is cleared.

So in vcpu_enter_guest?

> Another thing that's not obvious is the required ordering between KVM_SET_SREGS2
> and KVM_SET_NESTED_STATE.  AFAICT it's not documented, but that may be PEBKAC on
> my end.  E.g. what happens if walk_mmu == &root_mmu (L1 active in targte KVM)
> when SET_SREGS2 is called, and_then_  KVM_SET_NESTED_STATE is called?

Either ordering should work.

Paolo

