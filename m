Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECFE175F6D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCBQUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:20:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727307AbgCBQUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:20:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583166018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dy2VYWwVWhSvzuqB6gToR7pJSPiAWRfT7pUZn4SEGOw=;
        b=d8tjR1BqFfdPiwtqFkescCL3KPqDlrOTV81uLA63qcSU/lB+AkmyaPNRJvXIJjMr4vOdZl
        6Gno1c3VcOIaTxgp04uhGqvBIY6OmlIxss9j2jaVey3HyL54kJcvbU/plqMnE45wnK5gD6
        WffpSiFBt4ihnVZynyPijNiVA6hxo5M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-_oQsp5JBMTuoadLR-1I1rA-1; Mon, 02 Mar 2020 11:20:16 -0500
X-MC-Unique: _oQsp5JBMTuoadLR-1I1rA-1
Received: by mail-wm1-f70.google.com with SMTP id g78so2338wme.9
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dy2VYWwVWhSvzuqB6gToR7pJSPiAWRfT7pUZn4SEGOw=;
        b=t54NQZV5qpikSzZbA36cUqia6BhupQMjsx11n9rcj0obCSSW3ppfZ4569ZU6N9eI3R
         z6OyoscY7dPvjIDya2554O0UhjAMhq9grj/MSuatSW0FH7vPTUOl6KunCRWHf+nTOr83
         93yVCsCxtSyPGiMjQ9CK1BPOIU2DTPQpldD+G1lUQh9QVl6IjWrz5wgtmdRXMR0HYxu9
         sIagOEzCClkAqZZoatLR56EtUjdLOV+jM9r6HIJgawqxeX7B4cSGllvWWvO/6GfLLi/H
         pYwuCTaIevriarsxd16pzUdJhfs8M3cO46ChYwf8XLEfR6b8EeuZK/xXMKbTfEtj4V4U
         twVw==
X-Gm-Message-State: ANhLgQ2rpV6iWqvzMN1YSaZvkIqSBnrH7HggTRQMKx40C7OPpanALwDu
        om5V1+MqfGr88XBy+9RhdHYTtb4b1t9ewTsjpGiPokjlojPUX59cZbtiL86QRr+fzhmzTOQfOZ1
        yt5uv5ZKjumjs
X-Received: by 2002:adf:e74a:: with SMTP id c10mr341813wrn.113.1583166014974;
        Mon, 02 Mar 2020 08:20:14 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsFba2ap/3M2C8V1ZLS9AbnIszACse8Qml7+E+3tl18MRaCrS1ooNkZd4X3DTQzJig9UjS+Jw==
X-Received: by 2002:adf:e74a:: with SMTP id c10mr341803wrn.113.1583166014808;
        Mon, 02 Mar 2020 08:20:14 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id z14sm29021610wru.31.2020.03.02.08.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:20:14 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Fast CR3 switch improvements
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200228225240.8646-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d930b38e-4306-4b1c-3bf9-20d1384b6788@redhat.com>
Date:   Mon, 2 Mar 2020 17:20:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200228225240.8646-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 23:52, Sean Christopherson wrote:
> Two improvements for fast CR3 switch, implemented with nested VMX in mind,
> but they should be helpful in general.
> 
> Sean Christopherson (2):
>   KVM: x86/mmu: Ignore guest CR3 on fast root switch for direct MMU
>   KVM: x86/mmu: Reuse the current root if possible for fast switch
> 
>  arch/x86/kvm/mmu/mmu.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo

