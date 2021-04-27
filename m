Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B8836BFBD
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 09:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhD0HHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 03:07:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234843AbhD0HGh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 03:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619507155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hU0X065Jts3zXqonmt3u6RVQ5smooOA0uzd+qO/RgE8=;
        b=P8QSjF0q6m50cIAybdy2A4o8mfyp1KsskxX3363cAZllMxsaytEr0PP5x9GuDdVdXXmy83
        C1U0N3iwkYnIe7RAHi2UPvo/xVHCgmqf5l6wAkCjpKZxRKGkTfTgjkj35YuPeedKbAJTOV
        hHMPTb0L9y13JCD8UVhWLvgVwAiiTcI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-21UlObUENe-ICImkjL4j2Q-1; Tue, 27 Apr 2021 03:05:52 -0400
X-MC-Unique: 21UlObUENe-ICImkjL4j2Q-1
Received: by mail-ej1-f69.google.com with SMTP id gb17-20020a1709079611b029038c058a504cso1805256ejc.7
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 00:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hU0X065Jts3zXqonmt3u6RVQ5smooOA0uzd+qO/RgE8=;
        b=LaLjcZa9812HEpRGW9vwoVHgmNJmPRU3RPr/2YUdxLiKJni5dddHFGUEwt3+c3/mKA
         OwZ7TG0xCdNvRPucbb1FpwkcNJP3fYorFWjBgR0SQRGBu0eV0cQllIfJlvTuJRFS17MQ
         3pcQv6Hj9MqJhU2RMQStXSgHnYIqqK9sv2KnyDYf7XPXb21yQ+xngwBKc1a8uh0IyZGi
         Oval24yd/HnMYNXgSvNRzVq9OgZynlQLfjQlAY934y3jfJKdEsnC+w2ykWuVKVNry4am
         CPYMjy88FczOYOLjcDMp+wTa3rsdxrkZmoMUU5NVtwxGG+IMn/J2xW0hw4I6dQ0ABjXi
         bgCQ==
X-Gm-Message-State: AOAM533mRSwke7vPSWNqJuHMbUkmAFfhjs8+SvDdklEq6J/YayVqtCus
        d8/wLDr5aubpXLACXUK7R/Yx4BllFPGSRtU9IG74oln+D/7dvbTtn18cwOTiasM6oSgBpcKyo2u
        T0uZe4qVmewVO
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr22253861ejc.326.1619507151321;
        Tue, 27 Apr 2021 00:05:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ7hxv9V3N9QTnZlvdRwBjGOXQZdA7OUgnCOqig0VsESbZiuwiXd/zr94sDLdsUQMotZjtOA==
X-Received: by 2002:a17:907:628a:: with SMTP id nd10mr22253845ejc.326.1619507151124;
        Tue, 27 Apr 2021 00:05:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id 16sm12846449ejw.0.2021.04.27.00.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 00:05:50 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
 <20200915191505.10355-3-sean.j.christopherson@intel.com>
 <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
 <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
 <CAJhGHyDrAwKO1iht=d0j+OKD1U7e1fzLminudxo2sPHbF53TKQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2fd450a9-0f59-8d88-d4bc-431245f3b565@redhat.com>
Date:   Tue, 27 Apr 2021 09:05:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAJhGHyDrAwKO1iht=d0j+OKD1U7e1fzLminudxo2sPHbF53TKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/21 02:54, Lai Jiangshan wrote:
> The C NMI handler can handle the case of nested NMIs, which is useful
> here.  I think we should change it to call the C NMI handler directly
> here as Andy Lutomirski suggested:

Great, can you send a patch?

Paolo

> On Mon, Apr 26, 2021 at 11:09 PM Andy Lutomirski <luto@amacapital.net> wrote:
>> The C NMI code has its own reentrancy protection and has for years.
>> It should work fine for this use case.
> 
> I think this is the right way.
> 

