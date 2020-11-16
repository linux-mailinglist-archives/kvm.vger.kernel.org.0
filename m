Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D1B2B5106
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 20:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgKPTYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 14:24:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729060AbgKPTYx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 14:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605554691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQSvuYRvFqxv79hOPPNIGHgoFAvmVSa2KGCGh14XvX0=;
        b=E+8g53PS7vBYB7cQU4nQkAgSm+Fg8AX1P2fSKH+MNGTIDz20p9snLrXzOzILJGewNQCLYo
        jceLfkxxzQeDCc6y/KIDIthVfAm77WFe7IXa/rVQZYHTrACsZGLgTVyIbHzrAMBCq6DdQk
        nBkOH+dC9pQ52OsUjWiDY7OR++iyWwQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-WrT8LSsCOvKkBFtaOZumDA-1; Mon, 16 Nov 2020 14:24:47 -0500
X-MC-Unique: WrT8LSsCOvKkBFtaOZumDA-1
Received: by mail-wr1-f69.google.com with SMTP id y2so11622023wrl.3
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 11:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQSvuYRvFqxv79hOPPNIGHgoFAvmVSa2KGCGh14XvX0=;
        b=a93n1zL3BDHELh+xZJxzizsWU8ZI8GuReDz9TpM9h7xdIE33yVaNFOHgLPFW0X9mIA
         ifB0Lcm2xOdQ64qItjFOr40R4qfV5sLH4UiNx7LxKOc19KZZOnOoqWiSBCCWb8JSTAvs
         JvgvREpuQ65wKBIw3p/Tvp5L8o+jcGTQUh3IcurTHMOigZUVOniaCykVkn8qz+cLtdDQ
         L9LYtNDVgWnQtAyX+Mywzjqm8ytBY3KNB2DAazf7ip4q5l+ar3i7HmkxsX77U0Rez8Fu
         EeXmL1rKX5OKGjXR/JWvMllkNN2plMLCTlfILVB/aQqr6Yjx4RCutXfCdh54fdUDmlYX
         GqBA==
X-Gm-Message-State: AOAM530xy9632ezk1zwTwO9nLEoqLYFI9YRhbCrI1Fm3GXvUXLxBhSWc
        gScKo5pzAXky++eyYlIh3Tnp/gFxLCVH2hYQT6js5ujQMqSbG5YHFJpE0YoFyEnHLEp+KfMp9w5
        L03f4pzj7gcYn
X-Received: by 2002:a5d:6550:: with SMTP id z16mr21224443wrv.266.1605554686173;
        Mon, 16 Nov 2020 11:24:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnSUOlYF2Jq5az6RhTrY9TqlYaubHiAMiJS9+yWuJqSgfh9MnDb2jScNGTXjzVqknfEqQ9xA==
X-Received: by 2002:a5d:6550:: with SMTP id z16mr21224424wrv.266.1605554685953;
        Mon, 16 Nov 2020 11:24:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n11sm23295666wru.38.2020.11.16.11.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 11:24:45 -0800 (PST)
Subject: Re: [PATCH] kvm/i386: Set proper nested state format for SVM
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <fe53d00fe0d884e812960781284cd48ae9206acc.1605546140.git.thomas.lendacky@amd.com>
 <a29c92be-d32b-f7c3-ed00-4c3823f8c9a5@redhat.com>
 <f58c08c7-0c80-efe8-b976-ffb85b488723@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b978bd3-ffa4-f06e-3654-e851b7e1c1e2@redhat.com>
Date:   Mon, 16 Nov 2020 20:24:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f58c08c7-0c80-efe8-b976-ffb85b488723@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 19:25, Tom Lendacky wrote:
> On 11/16/20 12:09 PM, Paolo Bonzini wrote:
>> On 16/11/20 18:02, Tom Lendacky wrote:
>>> From: Tom Lendacky<thomas.lendacky@amd.com>
>>>
>>> Currently, the nested state format is hardcoded to VMX. This will result
>>> in kvm_put_nested_state() returning an error because the KVM SVM support
>>> checks for the nested state to be KVM_STATE_NESTED_FORMAT_SVM. As a
>>> result, kvm_arch_put_registers() errors out early.
>>>
>>> Update the setting of the format based on the virtualization feature:
>>>     VMX - KVM_STATE_NESTED_FORMAT_VMX
>>>     SVM - KVM_STATE_NESTED_FORMAT_SVM
>>
>> Looks good, but what are the symptoms of this in practice?
> 
> I discovered this while testing my SEV-ES patches. When I specified the
> '+svm' feature, the new SEV-ES reset address for the APs wasn't getting
> set because kvm_arch_put_registers() erred out before it could call
> kvm_getput_regs(). This resulted in the guest crashing when OVMF tried to
> start the APs.
> 
> For a non-SEV-ES guest, I'm not sure if other updates could be missed,
> potentially.

Ok, thanks.  It's certainly a potential source of bugs, I've queued the 
patch.

Paolo

