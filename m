Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025C53D696C
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 00:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhGZVma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 17:42:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231959AbhGZVm3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 17:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627338177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9dAuuhQeXJnHY9YOxmU0U5Agmhqw2dB6e5Zy44E0hE=;
        b=jICSysVYGOpqUKNL/UcgbjYUVCcYeuCSq7QPUzUG3QTboykUgU6+8/wE7EVot3sQ8K6IKV
        ylFu4lSHmLShEncwY6pcT9/Bnsor8dRne0qjtjatgrL+foQh3LWjP0e/96akcSbweN1P5o
        2aY+2pzqEG4oJqJW+omIC6VWcHLBqvM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-Kvy_pSutOMWT3LTmNNgumQ-1; Mon, 26 Jul 2021 18:22:56 -0400
X-MC-Unique: Kvy_pSutOMWT3LTmNNgumQ-1
Received: by mail-ed1-f71.google.com with SMTP id n24-20020aa7c7980000b02903bb4e1d45aaso3753907eds.15
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 15:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q9dAuuhQeXJnHY9YOxmU0U5Agmhqw2dB6e5Zy44E0hE=;
        b=Pl/9iLB3M7aK273vypndnU726crfIDXZayzLQLl+whMzln6SYgvHuP9R5XHcl7Sod/
         q2KXXUoRUXntdSR/hNl3UB1Y+/RckxW4crlUy8tHUzNi8tu/q+wcKXidRcGj0OMZSw3E
         NH+YEbm3zWa767AUd8hyr9DTWBDP8qJoMkWdAqvFj76dTPoVKSFhIbWHO2uXFylemQic
         OcxEc/yX6kE2Xn27RWk3g5l0DII6SeShen6sz++d8mUd4lxOCyzkSQVRdo6px7Q6Hidh
         eoKpHcsMlUasM/GZN6GJa28z4P/Gpc2dPs1Rx9poQm1xil0qNbDgZTNo6hLCk/KQ1I+b
         4oTA==
X-Gm-Message-State: AOAM530hqC0H6VKoi67bkYbuoRkC9xi4W/WF2E6/3mXSuHg3yZSDs8dL
        tWzHa2r4mM4GZreBFEb+jXivMT8BKL4NUNPdkitZSY6a7AfSHdCWuPWyzLYgVT5PN2MM/62pGAa
        ypdOzAeCyYg9N
X-Received: by 2002:a17:906:4f01:: with SMTP id t1mr10810092eju.388.1627338174804;
        Mon, 26 Jul 2021 15:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl1rSXlpY7vfcBbP4lSuX0aLNAwNQhSLeSGAi2brZYkcDm0gFPy32/jKoIa+cofv3hQjwuLA==
X-Received: by 2002:a17:906:4f01:: with SMTP id t1mr10810071eju.388.1627338174573;
        Mon, 26 Jul 2021 15:22:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id l7sm284712ejk.53.2021.07.26.15.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 15:22:53 -0700 (PDT)
Subject: Re: [PATCH v2 41/46] KVM: VMX: Smush x2APIC MSR bitmap adjustments
 into single function
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-42-seanjc@google.com>
 <7ddb5bfb-f274-9867-3efb-0b6ba5224aa2@redhat.com>
 <YP81dzqaD//iNr5L@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f50126e3-f28e-b8e5-d09d-27c2fe25e141@redhat.com>
Date:   Tue, 27 Jul 2021 00:22:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YP81dzqaD//iNr5L@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/21 00:21, Sean Christopherson wrote:
> On Mon, Jul 26, 2021, Paolo Bonzini wrote:
>> On 13/07/21 18:33, Sean Christopherson wrote:
>>> +	if (!(mode ^ vmx->x2apic_msr_bitmap_mode))
>>> +		return;
>> Just !=, I guess?
> Ha, yeah.  Forgot to do a bit of critical thinking after refactoring.
> 

Well, == even since I assume you don't want the ! in front. :)

Paolo

