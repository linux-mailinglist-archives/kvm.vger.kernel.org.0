Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924863BE98A
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGGOSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:18:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231724AbhGGOSe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625667354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7TkRYJsDfarqXSn4EBmx0Hd12Melpzh3GqncamrRv0=;
        b=eL78irsKPKOtKpi7eK3/ww4MDKFXjWxdCvd61LfSaS6Bp05l497zI+5SMUVGG5/wkGaThi
        J6CyvTXtdehEfcFb3j9rwkS7TDV2V7h2v2E/bZDSGyDUu2IOojS2kGhaONjp2sI/G729nb
        lTjSPjMJUPjwl4hmMQNpCeNLxDpNvsA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-QRyvefsbNiibhcwW76dddw-1; Wed, 07 Jul 2021 10:15:52 -0400
X-MC-Unique: QRyvefsbNiibhcwW76dddw-1
Received: by mail-ej1-f72.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso604533ejt.20
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 07:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v7TkRYJsDfarqXSn4EBmx0Hd12Melpzh3GqncamrRv0=;
        b=P1yfeVSgUsUhhikoZqmVksW8o6DJ64eCfs6jQHf87f6wc/P3WdpfOSFtJFcH+OYFTa
         yCNXsBL1B2L37qWR619RuAOgwYUDU7s+lL/unLpAfrJK71ggxLqZK5ba5CcfdxBKpB3q
         OvgVI3k2u1JMJ41DWBJnrWBH/BOT2Iso+iEdO8p9xGBtQh2lurGIEVUFBbtbKWG+Q+vw
         MZJv/2RnFm7I1D0vmWBxDzGa5JMhvRYkNLx2D3RsR/rzIKqjSMZ1s36LCO3NAJd+oRdY
         UZzJX0ayTxVBEbvAroML9fXm48S1reiYCE21oL2iex7Od/dtd6O8EdA3ScFr32nuemTJ
         5H5w==
X-Gm-Message-State: AOAM533S1URhuiYGiy4ZCMxvZSfF53LH+C7sBQUjYcq0xVLVDfPSOzWO
        5Z+LXVeJZvbLxFDYw5QxEtBekSWIVL4TkzeIT/zuYUZq1fjuQ1kq9MbSXWV/VsoBKtUWN2nzmOL
        A+RwD0LMkVeGP
X-Received: by 2002:a17:906:842:: with SMTP id f2mr24646137ejd.460.1625667351671;
        Wed, 07 Jul 2021 07:15:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxogJG5EZkoMMu8maydXHcDJhSX3aRBwefzb6CXUOxZgETiNeOxmsHGUhIROgdGHhgQ760dLw==
X-Received: by 2002:a17:906:842:: with SMTP id f2mr24646105ejd.460.1625667351434;
        Wed, 07 Jul 2021 07:15:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id zp1sm6983114ejb.92.2021.07.07.07.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:15:50 -0700 (PDT)
Subject: Re: [PATCH 3/4] KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, regressions@lists.linux.dev
References: <20210615164535.2146172-1-seanjc@google.com>
 <20210615164535.2146172-4-seanjc@google.com> <YNUITW5fsaQe4JSo@google.com>
 <ad85c5db-c780-bd13-c6ce-e3478838acbe@redhat.com>
 <CA+G9fYsrQo3FvtW1VhXocY2xkaPLNADA4S5f=fBM5uqa=C5LYg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40623553-310a-68f7-2981-f8ea9c7bd5b0@redhat.com>
Date:   Wed, 7 Jul 2021 16:15:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsrQo3FvtW1VhXocY2xkaPLNADA4S5f=fBM5uqa=C5LYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/21 14:09, Naresh Kamboju wrote:
> On Fri, 25 Jun 2021 at 14:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 25/06/21 00:33, Sean Christopherson wrote:
>>> On Tue, Jun 15, 2021, Sean Christopherson wrote:
>>>> WARN if NX is reported as supported but not enabled in EFER.  All flavors
>>>> of the kernel, including non-PAE 32-bit kernels, set EFER.NX=1 if NX is
>>>> supported, even if NX usage is disable via kernel command line.
>>>
>>> Ugh, I misread .Ldefault_entry in head_32.S, it skips over the entire EFER code
>>> if PAE=0.  Apparently I didn't test this with non-PAE paging and EPT?
>>>
>>> Paolo, I'll send a revert since it's in kvm/next, but even better would be if
>>> you can drop the patch :-)  Lucky for me you didn't pick up patch 4/4 that
>>> depends on this...
>>>
>>> I'll revisit this mess in a few weeks.
>>
>> Rather, let's keep this, see if anyone complains and possibly add a
>> "depends on X86_PAE || X86_64" to KVM.
> 
> [ please ignore if this is already reported ]
> 
> The following kernel warning noticed while booting linus master branch and
> Linux next 20210707 tag on i386 kernel booting on x86_64 machine.

Ok, so the "depends on" is needed.  Let's add it, I'm getting back to 
KVM work and will send the patch today or tomorrow.

Paolo

