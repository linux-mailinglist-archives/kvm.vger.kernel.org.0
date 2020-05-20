Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510F1DC099
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgETUxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 16:53:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgETUxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 16:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590007997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VPigoHBTo8Av268DW2XPyNgTHTZZR4sFXreDaayXHHw=;
        b=YNpB6FEAijUKH7JZn9x3LItp3XhQGttAgHqn6ctaGltKK2ajlv4Ik9M8yFVvcpyTF6pdV8
        3geiNBCeAke8EJz72lgfsGhFB9unPg/FhHbH4qmJtuKW60HVZaGEILl+P5YwdJkclyhRmL
        fFVweIFhR+/Bt29lgCEQwKkD1U8xVNY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-VJFtkE59PkGD3cy80Ux9QQ-1; Wed, 20 May 2020 16:53:15 -0400
X-MC-Unique: VJFtkE59PkGD3cy80Ux9QQ-1
Received: by mail-ed1-f71.google.com with SMTP id e1so1791801edn.14
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 13:53:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VPigoHBTo8Av268DW2XPyNgTHTZZR4sFXreDaayXHHw=;
        b=iTy0pDHByy9fASYTBwiYo0AS7w+oZtShkKYy/BI7/oC5vCYKxfUHZCHawAgRYH44dX
         DUgs0sOWT9UMN/NAuENqfSS8aQQxhoRukHZ3QeSgYmhwJZc3nwsw+17XwUQUzxNMUIG3
         gJ4eAXqrKAcMLjGrRtc8pApCxwIRAjTHvTWfApNZ7+0zYLPU+TTBsXMf455/QyVQNgd9
         sLGhkogPDeYHh6qFDjAUy+nEn+KQPsbjskSrsVAnK/+fQ1dMnG4VRiUpLmpuX5du2iXh
         niDKpNw1kb1hmK6fwiZXa/eAUZvQIL7VEo+cmUKqaOe59k+NU1qE4qZtN5kF4XAPLYZZ
         K2wg==
X-Gm-Message-State: AOAM533PEZQvKVBSaUYG7pPkyYYvi2PbRti1dUBTDgr1Qvoezgcx/6ma
        GJlBWKWU+PO3RAuUGQm/gkMbmV9GElQ1hNebybx/EsI4e/RO6o0+W7ili8xfNi8qkB9Sj0JuzN7
        22T1xr+D/P79C
X-Received: by 2002:a50:f017:: with SMTP id r23mr4991724edl.290.1590007994100;
        Wed, 20 May 2020 13:53:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7ztMsWaIhJcyidKuhFBK27vLzUX6354lqSQ5emT6HXlyIFILWrCqT9pbRFbyD8TIX28Fc5g==
X-Received: by 2002:a50:f017:: with SMTP id r23mr4991714edl.290.1590007993897;
        Wed, 20 May 2020 13:53:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.gmail.com with ESMTPSA id gw23sm2773789ejb.84.2020.05.20.13.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 13:53:13 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Fix VMX preemption timer migration
To:     Makarand Sonare <makarandsonare@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
References: <20200519222238.213574-1-makarandsonare@google.com>
 <20200519222238.213574-2-makarandsonare@google.com>
 <87v9kqsfdh.fsf@vitty.brq.redhat.com>
 <CA+qz5sppOJe5meVqdgW-H=_2ptmmP+s3H9iVicA0SRBpy4g5tQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d21f47c0-dd48-53f8-ffbb-8d6f8637b50b@redhat.com>
Date:   Wed, 20 May 2020 22:53:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+qz5sppOJe5meVqdgW-H=_2ptmmP+s3H9iVicA0SRBpy4g5tQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 20:53, Makarand Sonare wrote:
>>
>>> +
>>> +		if (get_user(vmx->nested.preemption_timer_deadline,
>>> +			     &user_vmx_nested_state->preemption_timer_deadline)) {
>> ... tt also seems that we expect user_vmx_nested_state to always have
>> all fields, e.g. here the offset of 'preemption_timer_deadline' is
>> static, we always expect it to be after shadow vmcs. I think we need a
>> way to calculate the offset dynamically and not require everything to be
>> present.
>>
> Would it suffice if I move preemption_timer_deadline field to
> kvm_vmx_nested_state_hdr?
> 

Yes, please do so.  The header is exactly for cases like this where we
have small fields that hold non-architectural pieces of state.

Also, I think you should have a boolean field, like
vmx->nested.has_preemption_timer_deadline.
nested_vmx_enter_non_root_mode would use it (negated) instead of
from_vmentry.  You can then set the field to true in
vmx_set_nested_state (if the incoming state has
KVM_STATE_NESTED_PREEMPTION_TIMER set) and in
nested_vmx_enter_non_root_mode; conversely, vmexit will set it to false
and vmx_get_nested_state can also use the field to decide whether to set
KVM_STATE_NESTED_PREEMPTION_TIMER.

This way, if you have an incoming migration where the field is not set,
nested_vmx_enter_non_root_mode will fall back as gracefully as possible.

Thanks,

Paolo

