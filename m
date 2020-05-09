Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CB11CC17B
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEIMys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 08:54:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgEIMyr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 08:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589028886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nx7i4+sm5IylK0DJFpKkbPDe53y6Qh0HUjzPyqbwKfk=;
        b=CJxCBHMSySR8tsNDozFztiD4XfrkeT3lTzM6800XS3CKAQQ8GEERlJdviJTc7pAFdLS65c
        /4Z7MZoxwNz7q+pdm6o0F9ak9HpS1MzVS/mycc2OLGJZ1tr4iNRu5t4GpT8bWXw/b0Gh0F
        5fHngSzmxsUbfOjO9AwFZumPX/Cz3N0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-JZ9hX8c9MmWILr9M3qLC7w-1; Sat, 09 May 2020 08:54:44 -0400
X-MC-Unique: JZ9hX8c9MmWILr9M3qLC7w-1
Received: by mail-wr1-f70.google.com with SMTP id r11so2338514wrx.21
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 05:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nx7i4+sm5IylK0DJFpKkbPDe53y6Qh0HUjzPyqbwKfk=;
        b=uYMA+8PuBPf3WtM152Bw/iS02xpE50AE5ASOoW1kwRxtCaqFDNQpEYJbFQ0xrsj9bt
         GTyiQ5hO9UQrBi9Gb127wYCGFJokQ4Tw4ve2rxYFdUHqz+wivlM3GRbq/ZVn6zgmts00
         HIpmap75W72RPgG6zeVw8g4jDbyEBBzSGkFxLFLMACRHq9ZsrRC6xcJJnWooNrpbF3Zo
         OgFVJxw8arKcl10XiH2hOlOwiGeAMIvn9fFOMSh/tcElc6odhuyrmwC/EdNHmi9m66cJ
         9qqvvfZPPT2OPD2P0TikmZzw8BXmqh6ZI5VSyl+5vk5g8Q5ajWYKC3ZiVTiuYFu7TY/E
         j1MA==
X-Gm-Message-State: AGi0PuZLtUvLNXFg56jntC9vg/xCADGXE5xEXxR8YRSfq5+Ktmv51Jbc
        xTblaSDLCp3XjVVyx9aFnZ3t3mQhL897Qs3dIw5wlN8b/gQwK5e9UO7dK9jkoclQNOYTPyMD0IN
        4yrkX65jjwAtF
X-Received: by 2002:adf:f00e:: with SMTP id j14mr1684158wro.252.1589028883788;
        Sat, 09 May 2020 05:54:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypLCMfgaKo+9i2/6L1tsiD3080IT0rU+1LLK7ZOFUIy/ZAt/k7wVzyOi7AwLmhlYZuCqzXuyCw==
X-Received: by 2002:adf:f00e:: with SMTP id j14mr1684141wro.252.1589028883550;
        Sat, 09 May 2020 05:54:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id g15sm110949wro.71.2020.05.09.05.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 05:54:43 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: VMX: Invoke kvm_exit tracepoint on VM-Exit due
 to failed VM-Enter
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508235348.19427-1-sean.j.christopherson@intel.com>
 <20200508235348.19427-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <551ed3f8-8e6c-adbd-67ff-babd39b7597f@redhat.com>
Date:   Sat, 9 May 2020 14:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508235348.19427-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/20 01:53, Sean Christopherson wrote:
> Restore the pre-fastpath behavior of tracing all VM-Exits, including
> those due to failed VM-Enter.
> 
> Fixes: 032e5dcbcb443 ("KVM: VMX: Introduce generic fastpath handler")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Squashed, thanks.  Though is it really the right "Fixes"?

Paolo

