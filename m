Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1732A93EC
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgKFKSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:18:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgKFKSH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604657886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yzk7p3eTaQyL5wtsKR5oklwe+xjCN3EJ0U6A47oK3k0=;
        b=ay0gAqPfz58kmDtkHJKxDfPArR5S2iXYLOjL1opgd/CEv5becI8hVHGj2LJmbQVNVRyX86
        lynlBRfTqPE7lzybxs0VoFyBeypFcKEIP3nbUtK7pkDRTmBmXod0z6nSHdnHJ6tAwQGCnn
        Cq4y70OrnmqhjVR04DGf9Tzstx2KTY4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-eh4mIotxM8SC23KOSh1fDg-1; Fri, 06 Nov 2020 05:18:04 -0500
X-MC-Unique: eh4mIotxM8SC23KOSh1fDg-1
Received: by mail-wm1-f71.google.com with SMTP id c10so252066wmh.6
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 02:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yzk7p3eTaQyL5wtsKR5oklwe+xjCN3EJ0U6A47oK3k0=;
        b=IxgMo9vcoIHULhuFzInX/+yHuZ7PjuM+h3eoUAWR37o+/2n96pbawcuh0JblwhoQhY
         gPXQ8slAfqgtZwdfqwqZC5/K8OZR5pzVHE2z4i90PAlHilIf6TerqXo1OlFN7SomJGtj
         9Ji2EHl+/N6RDg5XOnt4AXFwo4QETH7zRNiw+nQ1muv29kavMKbykcVAPHRLKit3n5l0
         3ZcXlYvRKSywr0wxEDjASFUiaDtxPHQm1RCr25zkcJrWg4yDK98QAgiKQVPWE7XDc5/F
         vtaYQdhaV6AoQtzDjhhLIzh1HRRDYqe4aZGvaKi9gjLWchr8ocVHieLFsQFt/stFGahp
         u9lA==
X-Gm-Message-State: AOAM530P8ewlvxJU5/xqvs5l2+MPmkgNFMlKryd+j8/LJ7OvOpfz9Elc
        fxlx7fr9lpy6VKKOa5S3NDxcA0aIfrFXNrqdcU+xzMLGeTOgqhu+mzJ22Uck1omF3D5zcDSVXuC
        lsQVKiZwt6mXA
X-Received: by 2002:a5d:4104:: with SMTP id l4mr76526wrp.276.1604657883307;
        Fri, 06 Nov 2020 02:18:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB2u9mosiunWtpr+aCXh7Ej3eCO/BmFfUkhzOjK2rINBlvPD+3Osb4sZK4nnIZVF5p75slog==
X-Received: by 2002:a5d:4104:: with SMTP id l4mr76504wrp.276.1604657883127;
        Fri, 06 Nov 2020 02:18:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id e25sm1449631wra.71.2020.11.06.02.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 02:18:02 -0800 (PST)
Subject: Re: [PATCH] x86/kvm/hyper-v: Don't deactivate APICv unconditionally
 when Hyper-V SynIC enabled
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, junjiehua0xff@gmail.com
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrey Smetanin <asmetanin@virtuozzo.com>,
        Junjie Hua <junjiehua@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1604567537-909-1-git-send-email-junjiehua@tencent.com>
 <87sg9n3ilt.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <348f8763-3842-0dda-2c01-6c5d510fe630@redhat.com>
Date:   Fri, 6 Nov 2020 11:18:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <87sg9n3ilt.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/20 16:53, Vitaly Kuznetsov wrote:
>> The current implementation of Hyper-V SynIC[1] request to deactivate
>> APICv when SynIC is enabled, since the AutoEOI feature of SynIC is not
>> compatible with APICv[2].
>>
>> Actually, windows doesn't use AutoEOI if deprecating AutoEOI bit is set
>> (CPUID.40000004H:EAX[bit 9], HyperV-TLFS v6.0b section 2.4.5), we don't
>> need to disable APICv in this case.
>>
> Thank you for the patch, the fact that we disable APICv every time we
> enable SynIC is nothing to be proud of. I'm, however, not sure we can
> treat 'Recommend deprecating AutoEOI' as 'AutoEOI must not be
> used.'. Could you please clarify which Windows versions you've tested
> with with?
> 

Indeed---older versions of Windows that predate the deprecation will 
continue using AutoEOI.

Paolo

