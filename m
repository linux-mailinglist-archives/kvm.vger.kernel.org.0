Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8E3726E8
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhEDIHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:07:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhEDIH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 04:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620115594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLKysQTV4YSvTWozBBPWCa8Guy98Cew7Li+JKEFqCjc=;
        b=ZcUvyr/Q67AePxoCtsajLJ7pWX7AnT5H24MBBECKlztxcDGThwxFVikVxUn1/BGR/We4Vg
        +weg7DEati84DApH4FU/xni0q05hFnV1QOtlHCYbYzoAOryPh7ZwuiXes4UmLl63/ckoMs
        7GAeAs6WDOHhnQ6hkbRS9ZlCWIITz6w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-r1QlHTGQM2aXV4jH_MXsPA-1; Tue, 04 May 2021 04:06:30 -0400
X-MC-Unique: r1QlHTGQM2aXV4jH_MXsPA-1
Received: by mail-ed1-f70.google.com with SMTP id c15-20020a056402100fb029038518e5afc5so6054643edu.18
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 01:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qLKysQTV4YSvTWozBBPWCa8Guy98Cew7Li+JKEFqCjc=;
        b=Bcv9hW91rgKjR5t0Ef93GdgnV5STuHO0zsD9eMU+K1b2uBZn2MQIpWkPXZ9q74hdu7
         1TX73H8UIi18F2PmT6teD2Lv5N72FuJt7dI8cUN3EmGW7VdcbCM/H1+m2glQCtyb3wWg
         fXrDxfyIsKGZOTVOJhdLkOjCQcf/GOvzTR3+xHad8vzhUkgI/UQJkA0ehFLBPZcg/Y36
         x0/NmAgIDmw4WxCkSghlXQ3HjWOCv7pgKzYdGyGpAXJyFIh516b+3XhLPZSwJ1ZpdFpb
         0txyRFadLTdHI/JLaiqFQy14LTYJTIWiIA2/q8960A9mW5kXqSRLCwbxNuqPtvDG4k+0
         pL+Q==
X-Gm-Message-State: AOAM530dFs4QVzQvHmqNX88z02GCQPrNY+pXpNotWtv4wfrhGtolcgnR
        E4jM3jY1v8n2RP4feBXQQIs0kwQbEzRvgebD6YIGwZmuWS88Hu8rbk1WsRrDsx9wquwsL/CSYzq
        +AyWeoUDRQ//C
X-Received: by 2002:a17:906:5285:: with SMTP id c5mr9840080ejm.282.1620115589355;
        Tue, 04 May 2021 01:06:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybH1LFqY7rks+Hn7YEbWIOw03EQChstO5Gf6zE7RPJZokiRExRemQ/1tQ5EmeZinwbeVW0Fw==
X-Received: by 2002:a17:906:5285:: with SMTP id c5mr9840060ejm.282.1620115589186;
        Tue, 04 May 2021 01:06:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f24sm13707548edt.44.2021.05.04.01.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 01:06:28 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: nVMX: Map enlightened VMCS upon restore when
 possible
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <20210503150854.1144255-5-vkuznets@redhat.com>
 <87de6570-750c-5ce1-17a2-36abe99813ac@redhat.com>
 <87h7jjx6yh.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83f9d6af-a3b1-a115-6f19-cbdf8693af11@redhat.com>
Date:   Tue, 4 May 2021 10:06:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87h7jjx6yh.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 10:02, Vitaly Kuznetsov wrote:
> I still dislike the divergence and the fact
> that 'if (vmx->nested.hv_evmcs)' checks scattered across the code are
> not fully valid. E.g. how do we fix immediate KVM_GET_NESTED_STATE after
> KVM_SET_NESTED_STATE without executing the vCPU problem?

You obviously have thought about this more than I did, but if you can 
write a testcase for that as well, I can take a look.

Thanks,

Paolo

