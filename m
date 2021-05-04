Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9C0372DE8
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 18:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhEDQUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 12:20:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231626AbhEDQUd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 12:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620145178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OvZzucVTJj9dxsTr6Jb9cUKmM3ASskNG3nrOKSzShTs=;
        b=dHDGsNEDmrYAgMG6tI34/w5h/I8GbNCwy6ipJfVZCi7v1dRVuiktVQN5EY+sMmNu9me+bI
        1XG+UZvfpV5lsV/MubdOHcxznAllJ1XpBc9pgdEqPOlBbs3phNWcylFAq1dV9tZ0L3u9Jg
        +E03M3POjkSiWRrdClpMwJf0PU+igxM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-qvB0ih6SMQ2bffu60jE6lg-1; Tue, 04 May 2021 12:19:35 -0400
X-MC-Unique: qvB0ih6SMQ2bffu60jE6lg-1
Received: by mail-ed1-f69.google.com with SMTP id z12-20020aa7d40c0000b0290388179cc8bfso6601210edq.21
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 09:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OvZzucVTJj9dxsTr6Jb9cUKmM3ASskNG3nrOKSzShTs=;
        b=ggNRXY5cGql4L6xIMd2yz1zQeEKrzU+SDwMZYMgovuzJZxaNoNZVMGKKH9+Y96K7Wc
         rOUivrRDpRjQWY+QxuHuxAu0pcRAaXLxUKWy/RP5TJhQxe2xRWw6bLwRm8np2UpDPGFy
         ml4BzRZSUpDfR1xxWZaKHB7qhTQBEfJAdKqypWJXRsJ6RC1ZnRldwpV4KPhT4235oYQG
         5XoHaTgmx4Lp4rWtUJPt1zLoGDNo/rRfbBmDuP5OMcGpQn0XsHTSvqQ3Bfp4tDYA8ybS
         W+6/X7jyGpydATZmIDEbmlksAUiSeN2TWNc63gzq090Wq8cJPa+CdC3pwj9VuUupl0Y9
         sG8g==
X-Gm-Message-State: AOAM533v0c6HwOryKDVE6mhf7O9BZYdE5C5h1tae+LMLvJpu+A/F9wCl
        ro86ico72Iw7qF7bZFTaFagN8EZIL7ritKf8R1mKc2ufzAITZnF+EAULaq+YeCC2E8I0EHO4X+p
        9JGHFRWM5cfo8
X-Received: by 2002:a17:906:74c6:: with SMTP id z6mr23116032ejl.13.1620145174167;
        Tue, 04 May 2021 09:19:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd+ig4AwTg19EHmSE9AuapvGBuOhDPNqevOhLBrOcuT38OfUfNCRLxPATXl7S44ePq1tKwMQ==
X-Received: by 2002:a17:906:74c6:: with SMTP id z6mr23115975ejl.13.1620145173653;
        Tue, 04 May 2021 09:19:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r16sm6213363edq.87.2021.05.04.09.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 09:19:33 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] KVM: nSVM: few fixes for the nested migration
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20210504143936.1644378-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08d7ea6e-8b90-e606-5dcf-18393bbae9fd@redhat.com>
Date:   Tue, 4 May 2021 18:19:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210504143936.1644378-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 16:39, Maxim Levitsky wrote:
> Those are few fixes for issues I uncovered by doing variants of a
> synthetic migration test I just created:
> 
> I modified the qemu, such that on each vm pause/resume cycle,
> just prior to resuming a vCPU, qemu reads its KVM state,
> then (optionaly) resets this state by uploading a
> dummy reset state to KVM, and then it uploads back to KVM,
> the state that this vCPU had before.
> 
> V2: those are only last 2 patches from V1,
> updated with review feedback from Paolo (Thanks!).

Queued, thanks.

Paolo

> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (2):
>    KVM: nSVM: always restore the L1's GIF on migration
>    KVM: nSVM: remove a warning about vmcb01 VM exit reason
> 
>   arch/x86/kvm/svm/nested.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 

