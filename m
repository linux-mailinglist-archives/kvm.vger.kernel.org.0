Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949E11BC01A
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgD1NsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 09:48:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbgD1NsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 09:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588081694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ARODMKZjaY+Q6fhklEvL0MAdkHHjbuc8bfJZSb3vKE=;
        b=fNB8t4f7sjKDcDBXVdk6OtMsBgzfa5aeYaRAEqCaHB0ivgRNbgU0WMNSwTrVOSRfTQoOB2
        HvxYiT/AxRnXCGTjHvjRuwQZzPC5MnLr9OM/sFzrZZiOyXhmjnNljxcq27bVP0YXac21k1
        XCsMvgyoxOhBWLaMWjvssk/i8suyDKY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-Z1ge_6jBPAOgoFTI2vlksg-1; Tue, 28 Apr 2020 09:48:13 -0400
X-MC-Unique: Z1ge_6jBPAOgoFTI2vlksg-1
Received: by mail-wm1-f70.google.com with SMTP id h6so1077066wmi.7
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 06:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ARODMKZjaY+Q6fhklEvL0MAdkHHjbuc8bfJZSb3vKE=;
        b=r4EaX7fYdBuZ1cepYqmtyP5S+t5+tjef0u8OziyTBz4yiFUbSNmrZ34gVTaSoOnkRu
         Bb2PZEZzT3o4W1NTV8+lrPICzFlC4rSQvv/xpxp+oWvN7AM1Pr/JQo2d6q5AxI5Lx6IP
         DPV9pmMLyJE2C+353x02Vxb7PZJtnXUCCGIJiApTRZDz1ZBRAouZmsL018L10OkELPRI
         uqQWmdrRlYq0BQYuUBO61ltGAzEK9kJSWQ/H0laSb9xMOsfJTTxFtn6A14tbgez32pcg
         Jeeu48AmgvcCPhw4D+X8AVFH0gLq8ZohDbugNnCJ7Gh5KGdEdbftIAUzyOFBEWLLCitZ
         5v0g==
X-Gm-Message-State: AGi0PuZaqc1vC9XypHJA/jFPqPeM4a7/dM+5fzRjRdNBnHKjNXcpbhQd
        SyFe74p4zX9tSsTTQJ0wewMmxPiBaq2U/lrbgWEy8mt7rHC8kYZ8jtolZqzSKsTRp3PKDnnllH0
        00Bvc7hT8ll2Z
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr4944292wmj.95.1588081691537;
        Tue, 28 Apr 2020 06:48:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypLRtM6URDiujOjPMMKCxSnn+0TShXHp2LDgWWs7ZUPBwrRzJQ9YifX0JPszDCaTmLwlSgqKNg==
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr4944279wmj.95.1588081691323;
        Tue, 28 Apr 2020 06:48:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2c8e:3b22:4882:7794? ([2001:b07:6468:f312:2c8e:3b22:4882:7794])
        by smtp.gmail.com with ESMTPSA id z18sm25046925wrw.41.2020.04.28.06.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 06:48:10 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200426115255.305060-1-ubizjak@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fcf019d2-0481-5d10-76fa-4d86e8b8c4e6@redhat.com>
Date:   Tue, 28 Apr 2020 15:48:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200426115255.305060-1-ubizjak@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/20 13:52, Uros Bizjak wrote:
> Improve handle_external_interrupt_irqoff inline assembly in several ways:
> - use "n" operand constraint instead of "i" and remove
>   unneeded %c operand modifiers and "$" prefixes
> - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> - use $-16 immediate to align %rsp
> - remove unneeded use of __ASM_SIZE macro
> - define "ss" named operand only for X86_64
> 
> The patch introduces no functional changes.

I think I agree with all of these, so the patch is okay!  Thanks,

Paolo

