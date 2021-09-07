Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00640239C
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 08:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhIGGvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 02:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231429AbhIGGvq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 02:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630997439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTDhhUvvDbJ7NpxaaVzsPO+lW+QLm0QYSBqXZYb5YbI=;
        b=T+sY94rvJQ+Oli6FX5d/jDYYHOIa5wmQ7h2+1gNrE47O0O4ej1uuiRFybsVEypdkRePERO
        1NmZYhnzAIEYKSwyPqncSCi5yUM0343UIf03gsmMG9Yn6wlkWapW9dgN5eXqdzb//R525s
        SbMGFgIUqZwcJBclEN1rSIQlibg7NZo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-G0R7cbyCNZOUTYCAopdUDg-1; Tue, 07 Sep 2021 02:50:36 -0400
X-MC-Unique: G0R7cbyCNZOUTYCAopdUDg-1
Received: by mail-wm1-f70.google.com with SMTP id p5-20020a7bcc85000000b002e7563efc4cso728865wma.4
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 23:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cTDhhUvvDbJ7NpxaaVzsPO+lW+QLm0QYSBqXZYb5YbI=;
        b=ZpcKGB0zcxMGfH+OvWYr/9eD2/wvP61Q2cz8cfgx3IcyBdSiGFrprG4b/qmT7ft/an
         ZYy/24H9NIRK74MPvaqkiKZSd/5XdhKm1kdVUTZi4WU6i2YbmN3jFwgbvrRmeGa6mIH5
         kmZY/Uq6XgDDtUSSgiFC3hxf8TNDZrXriBUla3YT/RZ49Oc86cM3i63N+FCj8vI98AkQ
         D3Agh+BJzypqQbhrsfA3bM2QqktFHeFt9pFD4knzRdRzjoL/S9wXtU/aXylqdz1MWjIA
         6LwlyULHE5Rjy8wK3eVq82R6ID3eOgNG+dM8O9kFMJNx4LSnLqw4D9BVQFL/3rgTEErp
         9+8Q==
X-Gm-Message-State: AOAM533gONGh59h4628x+h0zYO/km+6SBw+dnMtl5KFDIH0aC8P/FBd1
        nNV1AlTSnjoQfNz7RP2ziJnwBrv9J7n6Qe1snFxUFgKGKtc4C7feNCwg9Z6LzciBPGl1c7B8t5Q
        tpgmAlO/yvcvB
X-Received: by 2002:a5d:58e9:: with SMTP id f9mr16550029wrd.154.1630997434636;
        Mon, 06 Sep 2021 23:50:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCETlFGE/fGAH7ycrp8pZpq7ggabDZaenWfDkmVgVwD7eIIKSMb+i7CdtVIc62tH5jU7/A9Q==
X-Received: by 2002:a5d:58e9:: with SMTP id f9mr16550007wrd.154.1630997434458;
        Mon, 06 Sep 2021 23:50:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j4sm9760221wrt.23.2021.09.06.23.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 23:50:33 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: VMX: avoid running vmx_handle_exit_irqoff in
 case of emulation
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
 <20210826095750.1650467-2-mlevitsk@redhat.com> <YSe6wphK9b8KSkXW@google.com>
 <a642cc28-272b-9a1f-51bb-657416e588d0@redhat.com>
 <e3e84acd383d4f5716745c2e513d442782b6b786.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2d1d944-d865-5cd4-104b-35977f7d97eb@redhat.com>
Date:   Tue, 7 Sep 2021 08:50:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e3e84acd383d4f5716745c2e513d442782b6b786.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/21 23:07, Maxim Levitsky wrote:
> Note that I posted V2 of this patch series ([PATCH v2 0/6] KVM: few more SMM fixes)
> 
> There I addressed the review feedback from this patch series,
> and for this particular case, I synthesized invalid VM exit as was suggested.

Yes, that's intended.  I will revert this version in 5.16.

Paolo

