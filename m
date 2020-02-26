Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0E16FDD5
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 12:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgBZLfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 06:35:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21728 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728133AbgBZLfO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 06:35:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582716913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvIUhrFKwmk9Ea/GdoOf5uCGGPADVd/Wpcg66GGR0yk=;
        b=Hzl3SZANuy6T9WLoCp2U1UFPL1zz5GIBI5lfvXQeGzKMZc/QFKuUu9z4dc5ad8jEP0gP7F
        /YeRRvimVLIzt5mVpslWuKH9qbA3TA1SDKGXId5TqVKYx1KmSM/7pSe2ixMElaULw/ANHx
        E+4+f5fLWLAdM1wvEOb2RT3KWDOjUEo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-vRUKRBDVPGScAmehEkdc8A-1; Wed, 26 Feb 2020 06:35:11 -0500
X-MC-Unique: vRUKRBDVPGScAmehEkdc8A-1
Received: by mail-wm1-f69.google.com with SMTP id p26so578000wmg.5
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 03:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lvIUhrFKwmk9Ea/GdoOf5uCGGPADVd/Wpcg66GGR0yk=;
        b=EQhUvJfYYkq3nnZ0QDta6xwLrQRtjXDN3HoC+wOg/zVOXN7xUTigGDKd/lSrkxfxni
         KnDsb5DxFBdVJRIHv8GTYirtPK7jae80olV8EGxUnRPe3RRiphrODBeoac2qZpdYQWw3
         v+/05SudppBegzQBnWP3STRTrShrhXIP/Qibbt37iVqLMRBGRMJVMP75nSVMUg0k+qyk
         XyAgKCqixofzq+kyjbEJkmKKp5VZSayNC4RyZgPh9tdJTMvCN5AsGUDEbIr0FIHozQsL
         walaDNOwT1TI8Zi+eZ9WoBg2C9krXD1LxoX4VKT5daCgakUBP14liWtcGPQJ3Z2qlAHW
         /aGg==
X-Gm-Message-State: APjAAAUwggedItyyAiphmoUR+1LGOV59Bu/SFo2TvJTh5NG2S6IefQA8
        6RRpFSGRb5XzeH39Mq3HyCjqy20OOKCLa3hWBNr/rS6Es703AGFbvFyeGkKA5mICkCB5Fr1MkvG
        oc5P7M7tSFeNX
X-Received: by 2002:a5d:5647:: with SMTP id j7mr5081290wrw.265.1582716910231;
        Wed, 26 Feb 2020 03:35:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDd3f4Vi0FeLResGKxmUpHUh3OYBUuZ7e/luVEzmQiuyXycrrIMCW1Rytkgx2yxmucC695Fw==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr5081262wrw.265.1582716909980;
        Wed, 26 Feb 2020 03:35:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id w7sm2444135wmi.9.2020.02.26.03.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 03:35:09 -0800 (PST)
Subject: Re: [PATCH 02/61] KVM: x86: Refactor loop around do_cpuid_func() to
 separate helper
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-3-sean.j.christopherson@intel.com>
 <87sgjng3ru.fsf@vitty.brq.redhat.com> <20200207195301.GM2401@linux.intel.com>
 <04fb4fe9-017a-dcbb-6f18-0f6fd970bc99@redhat.com>
 <87zhd6k8jn.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c4cb8b15-acab-38a7-a2c2-74b58f7df873@redhat.com>
Date:   Wed, 26 Feb 2020 12:35:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87zhd6k8jn.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 16:09, Vitaly Kuznetsov wrote:
>> Apart from the stupidity of the above case, why would it be EINVAL?
>>
> I suggested -EINVAL because issuing KVM_GET_SUPPORTED_CPUID with nent=0
> looks more like a completely invalid input and not 'too many
> entries'(-E2BIG) to me (but -E2BIG is already there, let's keep it, it's
> not a big deal).

Yes, and in fact he already does that change a few patches later.

Paolo

