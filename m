Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C021A1820CF
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 19:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgCKSaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 14:30:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730468AbgCKSaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 14:30:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583951401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ViQv4eLb1PCvu14XNidzpKiJDyoifYD32koQb9f3gVo=;
        b=TwxVZJ5LOWLYzZoFKpLiKYeXXAXLraQ9fHANCEEEJOUY6kBXnqOonmQ8qCbllTJDn4b6JT
        fKBAnBfb7GdL9Hsoq8GoC4y/RKXT1xY2D2kftvVvZr3Gq4VVoIfHh2b30f/1PxJIvsL3i/
        Hk4HVAp8mnQzdxdfM7omhJP+9dAOZBs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-mepIckC9MTiAEyyQCbvDUg-1; Wed, 11 Mar 2020 14:30:00 -0400
X-MC-Unique: mepIckC9MTiAEyyQCbvDUg-1
Received: by mail-wr1-f71.google.com with SMTP id i7so1345227wru.3
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 11:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ViQv4eLb1PCvu14XNidzpKiJDyoifYD32koQb9f3gVo=;
        b=mhLrkOwt8XU57vL43DPE51znSBSyqfVAQYlLMrNMx5fG+vDEgG3w3fd6hFsFxDs2nL
         Gc6zFKJ0IXpM/yO4gVSDj7I9rgYEOnWCnzXNJq4fp7D5lS46jMko+bHApnFCZwH4RjtP
         Yw04vnQsJYY+L2ckiM2SqFqwpNVTXq8hla3bowFSMyKcClt8EpnkBnYgeXArPriWI6kk
         NKQopjurZsaLmAiEJ4ILNycmLSxQGQkM6zdoUPf3EswQAKMJ2zpfb6ogbFxblVxNV8Cq
         zl0n0s7MaDk7rv/70rsP07SerSxyOEo/Js7Nzgw/FPOuc2Zkb1xRNXY/2OCZPkySOExw
         gaDA==
X-Gm-Message-State: ANhLgQ1k/4GExt8D6Fga5sxbOSyRRdPxoPaIMmf/wnYat73hL9+z/LiR
        CiD+/OMipiCB+UvqPGWvnWV4VBXjCwmkW7roha3dtlzBwvw4EY6loHmGtxdNsqURl+DXG/fXeg/
        I1f6Q3y1HOA9Y
X-Received: by 2002:a5d:4486:: with SMTP id j6mr1336568wrq.427.1583951398676;
        Wed, 11 Mar 2020 11:29:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vufrNSLCrIa4lavgQZpEdoPcB2lTlX6rUROjTyDKdG4jrc37ZCY5Ivpfd144PkEWePUE7VShA==
X-Received: by 2002:a5d:4486:: with SMTP id j6mr1336557wrq.427.1583951398460;
        Wed, 11 Mar 2020 11:29:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4887:2313:c0bc:e3a8? ([2001:b07:6468:f312:4887:2313:c0bc:e3a8])
        by smtp.gmail.com with ESMTPSA id c13sm11689035wro.96.2020.03.11.11.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 11:29:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: access regs array in vmenter.S in its natural
 order
To:     Uros Bizjak <ubizjak@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200310171024.15528-1-ubizjak@gmail.com>
 <20200310182422.GG9305@linux.intel.com>
 <CAFULd4Z6+LNORYOShsjixy9_7ntgzYjFGx0X0vGyM1-+7Zdw+g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <305d1735-2dde-672f-28e8-560c7318cd8f@redhat.com>
Date:   Wed, 11 Mar 2020 19:29:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4Z6+LNORYOShsjixy9_7ntgzYjFGx0X0vGyM1-+7Zdw+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After all I probably prefer Uros's order, since he took the time to send
a patch I'll apply it.

And now, a short history lecture on 8-bit processors for the younger,
and a walk down memory lane for everyone else...

On 10/03/20 20:16, Uros Bizjak wrote:
> FYI, the original x86 registers were not named in alphabetical order.
> Their names are explained in e.g. [1].

I think the reason why BX comes last is that it maps to the HL register
on the 8080, where "location pointed by HL" was the only available
addressing mode.

Likewise, CX maps to the BC register of the 8080.  That is only really
apparent if you take into account Z80 extensions such as the DJNZ or
LDIR instructions, but the Z80 predates the 8086 anyway.

So A -> AX, BC -> CX, DE -> DX, HL -> BX.

Thanks,

Roy Batty^A^KPaolo

