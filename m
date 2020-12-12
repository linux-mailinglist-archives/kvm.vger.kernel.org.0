Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4FD2D834D
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 01:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394547AbgLLANP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 19:13:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389275AbgLLANO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 19:13:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607731907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lzlGKMbnrfGvCdrIWPnbPiuADFoVhbI0Kl9RIcmeVLQ=;
        b=O0Fm9PGC2ftaIhfdPsQFUxKr/F+c4nsgWrBckrF1KA43XJlj2caoTRU0Uhuq8TwT0qghrY
        Vm1ijymaL24IrKzV191e8Ug1V4i2ZmVMZi6a6/ONvutdEFzqvTAo609HoTZSeGuSxYq3f8
        HUwfCX23PFcSHZDaLFbwicYJuIpGp3I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-sIy_XNPeMtW9LDDG6RUCTQ-1; Fri, 11 Dec 2020 19:11:46 -0500
X-MC-Unique: sIy_XNPeMtW9LDDG6RUCTQ-1
Received: by mail-wm1-f71.google.com with SMTP id s11so1269469wmh.0
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 16:11:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lzlGKMbnrfGvCdrIWPnbPiuADFoVhbI0Kl9RIcmeVLQ=;
        b=hYR1ProcpW7+3thios60ViwYnOqAA1/gTzBhwPk8QrGaW4QQzez22sw8vJQUf54KAB
         zMYJnAJ+vVfdL6PZMaW1hQTIzDhsUOwvOoX5Q/zUXsWYD0HM3maM7/O9c/tUrtkpV08q
         e9OD7j5AkEcM1187iZufgBvfbnSrj7NDvPqzVAtbmcnlwXA9eRnkkv9xKDPc8IUbrhej
         47+Rt9a/aZovXOmPUYq5psPFUVUnOBws3WmQKopl9Wj6vgmuM51aAyTR6ca2byWGSZqX
         Qn+vFlpeO6zSzM5zW8reX+FB1BEPAU8rnM0SZNR5qOyespTSS+UAtPQUMsUzWSX9EzAN
         3otw==
X-Gm-Message-State: AOAM5306jyKkSgDZWAY4AA3Ciyk5uryDa4ZZb2DckzavyNTaj+V+siza
        wfRaRS1Tvf6QXW1DtBQ/lceAaECyzFamJuvXNtrsD/5EEXJvQVOo5S+WYtUmCjBeWLtClfVohM5
        2wVIhr6IPf9jF
X-Received: by 2002:a1c:7318:: with SMTP id d24mr16260162wmb.39.1607731904570;
        Fri, 11 Dec 2020 16:11:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUoIjTFz7kibleaF0KiCrf+JT2FvsBWrot4QvrzU18ItBt56b0YivFM2BmKg/8RZdvoxiT6g==
X-Received: by 2002:a1c:7318:: with SMTP id d24mr16260153wmb.39.1607731904343;
        Fri, 11 Dec 2020 16:11:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b83sm16258211wmd.48.2020.12.11.16.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 16:11:43 -0800 (PST)
Subject: Re: [PATCH v3] KVM: mmu: Fix SPTE encoding of MMIO generation upper
 half
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        stable@nongnu.org
References: <20201211234532.686593-1-pbonzini@redhat.com>
 <X9QGw9vJfzCrFNzd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ae56d2b-23bd-c31e-94b3-34e0d5e8076e@redhat.com>
Date:   Sat, 12 Dec 2020 01:11:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X9QGw9vJfzCrFNzd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/20 00:54, Sean Christopherson wrote:
> On Fri, Dec 11, 2020, Paolo Bonzini wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
>> cleaned up the computation of MMIO generation SPTE masks, however it
>> introduced a bug how the upper part was encoded:
>> SPTE bits 52-61 were supposed to contain bits 10-19 of the current
>> generation number, however a missing shift encoded bits 1-10 there instead
>> (mostly duplicating the lower part of the encoded generation number that
>> then consisted of bits 1-9).
>>
>> In the meantime, the upper part was shrunk by one bit and moved by
>> subsequent commits to become an upper half of the encoded generation number
>> (bits 9-17 of bits 0-17 encoded in a SPTE).
>>
>> In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
>> has changed the SPTE bit range assigned to encode the generation number and
>> the total number of bits encoded but did not update them in the comment
>> attached to their defines, nor in the KVM MMU doc.
>> Let's do it here, too, since it is too trivial thing to warrant a separate
>> commit.
>>
>> Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> Message-Id: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
>> Cc: stable@nongnu.org
> 
> I assume you want stable@vger.kernel.org?

I do.

>> [Reorganize macros so that everything is computed from the bit ranges. - Paolo]
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> 	Compared to v2 by Maciej, I chose to keep GEN_MASK's argument calculated,
> 
> Booooo.  :-D

But I explained why. :)

Paolo

> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> 
>> 	but assert on the number of bits in the low and high parts.  This is
>> 	because any change on those numbers will have to be reflected in the
>> 	comment, and essentially we're asserting that the comment is up-to-date.
> 

