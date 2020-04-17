Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E591ADD58
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgDQMcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:32:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727877AbgDQMcJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 08:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587126728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9L7aHUs75OeWjYI0y3MvgX22V5CmXyF5KO7JSCxpwk0=;
        b=AW8HxNPMTe9/HnbMGSuoA0tO4Or4Dp/OSo5KoEX3gkS2lTUZ8Qsm2/fFFHaKImey4rwru0
        wynUwGtlDFD+VkA1aY0FKO4L7lbHx8+7yu54fsbGJUe2IaSIAqnWfOiK21dCq9nDonAl0Y
        EVUM9AmeXqAP9fVd8MXaLfOUBWW6sUs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-wTLuuLVRNxKj6CMvrmnuaw-1; Fri, 17 Apr 2020 08:32:05 -0400
X-MC-Unique: wTLuuLVRNxKj6CMvrmnuaw-1
Received: by mail-wm1-f71.google.com with SMTP id h184so884064wmf.5
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 05:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9L7aHUs75OeWjYI0y3MvgX22V5CmXyF5KO7JSCxpwk0=;
        b=EUXznLznmmzf0GZIWJljFn9XuBCkf6qY5hGZrH5j/dt6NF1brS1EmQfRtgJOqctRX/
         UDrB5mrHPK9Y3FGCp8mi8CZlD7BaWy0SEFF3qZ7PPE+DRl0c+Rt5NrTqT3ORphORc32S
         HSIzmd7Jd9RAP5MwGJuuDuAedTsQubw193WAYmWpkZY9cvJ5MIEfRCUvU87DCEYr48mh
         tr9gr2ljjQqwBvtpPGkYTJqInW8SuP6mkBJiIK6G4y/AfLkcuGQCffckupM64v6w/gZ3
         HD6l7C034vnPUYMS3xlDYIe6jG5Q39NpMaSanWx/o/ywbw04VqCdsshXG7lyGlTGY9D3
         2iIw==
X-Gm-Message-State: AGi0PuYNsU3jkeiRKX7zNBWziQfspm8O1LH4jzTIUKNTrqgOciH3/RQ9
        FjDfmCDzQBCDGd9vwfOEr/i8lJviHT27q9yPRFQiocGC8QO97dn8LepY4SeSvKA3pJNd2eTAvNi
        Y3AZXqXOaAJMJ
X-Received: by 2002:adf:aa92:: with SMTP id h18mr1869978wrc.20.1587126723973;
        Fri, 17 Apr 2020 05:32:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypLvl7d4kuCFhWqwrLgDEaksxVfNMwZp3k3+y9WAtwG6kHfkrIuRtia2MBHXl2fIKgCvL+zP1Q==
X-Received: by 2002:adf:aa92:: with SMTP id h18mr1869952wrc.20.1587126723719;
        Fri, 17 Apr 2020 05:32:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id e15sm31312897wrt.16.2020.04.17.05.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 05:32:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Improve handle_external_interrupt_irqoff inline
 assembly
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200417113524.1280130-1-ubizjak@gmail.com>
 <140c189d-4e82-1af5-6a59-6ea42fb818b9@redhat.com>
 <CAFULd4YWpxUH6WJbqT5wvPu1d_HzZ+hXvnOu=CScaXQk=H4=UA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b3fc3b32-7a2f-6379-956b-bac0f06c5f27@redhat.com>
Date:   Fri, 17 Apr 2020 14:32:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4YWpxUH6WJbqT5wvPu1d_HzZ+hXvnOu=CScaXQk=H4=UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/04/20 14:25, Uros Bizjak wrote:
> I was going to say that it is documented in [1] under x86 family
> section, but indeed, there is no description of "l" constraint. It is
> internal to the compiler. :(

Yes, I looked there.  It's worth documenting it in GCC, I think.

Paolo

> (define_register_constraint "l" "INDEX_REGS"
>  "@internal Any register that can be used as the index in a base+index
>   memory access: that is, any general register except the stack pointer.")

