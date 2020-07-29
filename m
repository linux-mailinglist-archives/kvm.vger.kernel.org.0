Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591792327E6
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgG2XMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 19:12:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51823 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726718AbgG2XMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 19:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596064333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9pPtUWnI75PPVSEE75oF0U92QV8pFljuW9EYbvcOk4U=;
        b=IMhzxPLiQOYE6OTcGDVJMcQEFMWqJ44emOWCTzp6DXLznrJ207CFn+CTaf9yAA3REbBhw9
        zEibi+7B8+YFrUfpovAAsNANwdj1qzE5QDyzJqpltpBOrx+iOZWDCkd9duPlmQxOgPML0T
        hdzFQqdCTvm0yB3miRetraxkpBr8U5w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-YfUJ6XVLNBiK58vUA6qK7w-1; Wed, 29 Jul 2020 19:12:10 -0400
X-MC-Unique: YfUJ6XVLNBiK58vUA6qK7w-1
Received: by mail-wr1-f72.google.com with SMTP id 89so7151433wrr.15
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 16:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9pPtUWnI75PPVSEE75oF0U92QV8pFljuW9EYbvcOk4U=;
        b=U7cFSh3hl25UmHrfombCSOZTkX8kHviIL75ZBBNbOpz3yCjto5hws52CdhLVWGXbhM
         VYNzPuzZNZZtykfVMbQS5DfmdD9gRa1rjWxMB3Z+So060FOf8yJ1vh6quex41QZVuYWR
         SUqv8xNaPpZY62BUXYe0EFDfVC0QvIWX+QstY+Kb1QAiWn3LrFeiGlyM+0dYeWu3P8iq
         kE1e28x6INcUq8AAiEjvUo1UJhL3D1mSxJlk1bxw6PiPDCt94dueQYvT7gdwD9fRwZOa
         FmbQZN1D7Rs1Gz1IYiFqoIB0/Q9qTdfOM8mR7lJbZdZ1fmQkGc0l7wH2tbB5zM0ArguE
         B4Nw==
X-Gm-Message-State: AOAM530PWlSAajJAKDS2Dpe7UF9Ia/tr+2TTbdUFPGso7uD+jQHrcuM9
        Ct7Iab/XNKs5b8m35/iqejeGtwNNLfep//MGN/XG+ccRsYlBscxkbqap45BAhbr4qtRG3yXbHVO
        SagQY9pQEK00A
X-Received: by 2002:adf:bb14:: with SMTP id r20mr28450wrg.366.1596064329522;
        Wed, 29 Jul 2020 16:12:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfASuMmdkKxWdOoYTiFWwNM71pGY6l/xn3XDIGVfVKppRfSjaNZOg3ibDQsz3/sYBOz5MIVg==
X-Received: by 2002:adf:bb14:: with SMTP id r20mr28434wrg.366.1596064329223;
        Wed, 29 Jul 2020 16:12:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:101f:6e7:e073:454c? ([2001:b07:6468:f312:101f:6e7:e073:454c])
        by smtp.gmail.com with ESMTPSA id s20sm6330064wmh.21.2020.07.29.16.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 16:12:08 -0700 (PDT)
Subject: Re: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
 intercepts
To:     Jim Mattson <jmattson@google.com>, Babu Moger <babu.moger@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597948692.12744.7037992839778140055.stgit@bmoger-ubuntu>
 <CALMp9eRF-ScqaWG7vn2mxKmR4jWo7LYZiiicHksiZR9hh+G=-A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3841a638-eb9e-fae6-a6b6-04fec0e64b50@redhat.com>
Date:   Thu, 30 Jul 2020 01:12:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRF-ScqaWG7vn2mxKmR4jWo7LYZiiicHksiZR9hh+G=-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/20 01:59, Jim Mattson wrote:
>>         case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
>> -               u32 bit = 1U << (exit_code - SVM_EXIT_READ_DR0);
>> -               if (svm->nested.ctl.intercept_dr & bit)
>> +               if (__is_intercept(&svm->nested.ctl.intercepts, exit_code))
> Can I assume that all of these __<function> calls will become
> <function> calls when the grand unification is done? (Maybe I should
> just look ahead.)
> 

The <function> calls are reserved for the active VMCB while these take a
vector.  Probably it would be nicer to call them
vmcb_{set,clr,is}_intercept and make them take a struct
vmcb_control_area*, but apart from that the concept is fine

Once we do the vmcb01/vmcb02/vmcb12 work, there will not be anymore
&svm->nested.ctl (replaced by &svm->nested.vmcb12->ctl) and we will be
able to change them to take a struct vmcb*.  Then is_intercept would for
example be simply:

	return vmcb_is_intercept(svm->vmcb, nr);

as expected.

Paolo

