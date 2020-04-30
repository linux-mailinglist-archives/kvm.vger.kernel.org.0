Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76801BF85D
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgD3Mpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 08:45:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54080 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726500AbgD3Mpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 08:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588250732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Cb5HHKbQwivw+27kErpeaVpuk6fg8e7FOLW1l12fCc=;
        b=f4rI8OkNNiDlNsItKrSvFpbMRcEclZo9KsiHRfYLpbInOK9hTi+V2AJhj5hmfG/G2lLLSz
        CRTXLC4P6SwxpvCdfYdN2LIwYfnEgTLQ1TBRHuMqSeSi2c0AFUD6DAsRi3KD8Zi5yJx6oq
        cHsGLcvT2YS6ohdpVJyHhJX6EVHwk9I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-TAs2fIv3PfmJmMBSIU0tCw-1; Thu, 30 Apr 2020 08:45:31 -0400
X-MC-Unique: TAs2fIv3PfmJmMBSIU0tCw-1
Received: by mail-wm1-f70.google.com with SMTP id v185so531407wmg.0
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 05:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Cb5HHKbQwivw+27kErpeaVpuk6fg8e7FOLW1l12fCc=;
        b=JiVjhJhpZ0f20JJzLnSOMtBr0+fV5s9HfMJ478l02OWwtD1Y7RbZQzZLKojsXUUdFJ
         APx1CgOD3HVzlU8MX1qZoN4NO2r40KgmGP4h/3PLpLv00Lgq/0az3SWCVNQGVsqlf3Tl
         qp1+XNU/yOmabca8MfV6oZREGhyJtRBhNLgf9FbLWnorLNDw5BWcA1rPjD8YKJ28zoYB
         CHuC5LjPGNY5F7WPNc0LOUE3f8gEWwYJsVio/VJrOmN0b8shuzDTPLeoQb1Dge79hBew
         9ROAP+YVgqgWGlXY7uwlMJ7G3o+EsmIhpkdTzOkOUez5Pac+e3szf61lRo9M4uLC1OSf
         8+RA==
X-Gm-Message-State: AGi0PuapTmVhvtVM6NJaqAdlJbmZ9mea8Gu25OUWetAFsF3i2ZcNuXsj
        qlvD3EE+eFaXpv+9tF9O/3+PJ2LbfP93JU8GrNx9/Pc29ehHwueU+ZWJK6/NypihrtaxPiAPuFr
        ElGA1UGCTBpgw
X-Received: by 2002:a1c:6787:: with SMTP id b129mr2890875wmc.165.1588250729963;
        Thu, 30 Apr 2020 05:45:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypJHyik7w72yZvX6PX+sEPiltOuJ0kE1Z2Mjczffq8o7emZek2HBnjq6JmtiOcFDW1lscPKysw==
X-Received: by 2002:a1c:6787:: with SMTP id b129mr2890837wmc.165.1588250729563;
        Thu, 30 Apr 2020 05:45:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id t20sm11667993wmi.2.2020.04.30.05.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 05:45:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: handle wrap around 32-bit address space
To:     David Laight <David.Laight@ACULAB.COM>,
        'Jim Mattson' <jmattson@google.com>
Cc:     'LKML' <linux-kernel@vger.kernel.org>,
        'kvm list' <kvm@vger.kernel.org>,
        'Sean Christopherson' <sean.j.christopherson@intel.com>,
        'Joerg Roedel' <joro@8bytes.org>,
        "'everdox@gmail.com'" <everdox@gmail.com>
References: <20200427165917.31799-1-pbonzini@redhat.com>
 <CALMp9eTBs=deSYu1=CMLwZcO8HTpGM2JsgDxvFR1Y220tdUQ3w@mail.gmail.com>
 <c3ac5f4c9e3a412cb57ea02df19dd2d2@AcuMS.aculab.com>
 <91c76eb0edcd4f1a9d5bc541d35f8ade@AcuMS.aculab.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2f471fbc-99fb-1a85-8f9f-c276c897f518@redhat.com>
Date:   Thu, 30 Apr 2020 14:45:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <91c76eb0edcd4f1a9d5bc541d35f8ade@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 10:56, David Laight wrote:
>>>> +               if (unlikely(((rip ^ orig_rip) >> 31) == 3) && !is_64_bit_mode(vcpu))
>> Isn't the more obvious:
>> 	if (((rip ^ orig_rip) & 1ull << 32) ...
>> equivalent?

This one would not (it would also detect carry on high memory addresses,
not just 0x7fffffff to 0x80000000)...

> Actually not even being clever, how about:
> 	if (orig_rip < (1ull << 32) && unlikely(rip >= (1ull << 32)) && ...

... but yes this one would be equivalent.

Paolo

