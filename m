Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F2F40AC04
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhINKyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 06:54:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhINKyT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 06:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631616782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWruQ/3HB3f8fPlOpFW89YUJGQb6La6iD1WrFwB+mXA=;
        b=hI5O382XYItr3iyAkUblrsK7WWYD0bl/D6lvyHKFT/yI6TzwWo2mpqn7ANHliHo1mbI3G/
        bybtLL8EZ5GNnPFO4wDD4a1+PGpyY7ot9nM3qIlhJAGcBSfeneLtuUr+oah53SJ5zwhriz
        2deGs780jsSK1sR1pSPDke5ZIYy36so=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-q2ucT6XFP5K-7M_gO6C8cA-1; Tue, 14 Sep 2021 06:53:01 -0400
X-MC-Unique: q2ucT6XFP5K-7M_gO6C8cA-1
Received: by mail-ed1-f72.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so6605315edb.3
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 03:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xWruQ/3HB3f8fPlOpFW89YUJGQb6La6iD1WrFwB+mXA=;
        b=ce0K9JHbODc7kmWKuyzmDiSm5ktXrL0DRz1/c7qS47WVWRVPSpQIdH0AI1tGwY325k
         4vGOZ1bmE48ZklLgTg+WuufuSVn+uFsKktU/3BiAOiuqsZDH3EnDBQRAVXYFsxE+nqWF
         nwhlOr9pm2YnnO4D/tsQKkQuuckJZWfTYMM2j5aVpfRimjlad/6zfb/1+VT3ulz/7zfg
         XsVy6B0d8FC7EPPY5ihkW38kmawuxrGZgDohQNBUbDNjLX2hkIZnW6kG3MPJDuZhAfnx
         yl4aX8XkOJuz5WrXEET8HnheGZhT4VF8QnObrngfMFpUkpGQUxh3VyfZXabH3PrpB+gj
         2yww==
X-Gm-Message-State: AOAM531ufy1ErXlWotu4XChrsmLImJSpKDxs2jXRjvCv4S0P8LM/oKUP
        Dh52cvvl8aP798jy2MlEKTIS+KyVoeO4XWO16B4jroqikuvyBcSMlcdt3FvpMT9BrWsV5ZELLvO
        DezBOFIbb78TD
X-Received: by 2002:a17:907:75d9:: with SMTP id jl25mr18158883ejc.4.1631616779908;
        Tue, 14 Sep 2021 03:52:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+hi4n9xRSOVKeKx3t6GwkR3/2NedhuNekmOLb1VB4opjRzgR4tPgifcWpMRBTNG4c2w21Ag==
X-Received: by 2002:a17:907:75d9:: with SMTP id jl25mr18158872ejc.4.1631616779777;
        Tue, 14 Sep 2021 03:52:59 -0700 (PDT)
Received: from localhost.localdomain ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id v1sm4928263ejd.31.2021.09.14.03.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 03:52:55 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210903102039.55422-1-eesposit@redhat.com>
 <20210903102039.55422-4-eesposit@redhat.com>
 <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
 <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
 <9585f1387b2581d30b74cd163a9aac2adbd37a93.camel@redhat.com>
 <2b1e17416cef1e37f42e9bc8b2283b03d2651cb2.camel@redhat.com>
 <ee207b0c-eab3-13ba-44be-999f849008d2@redhat.com>
 <fb828c752fac255c6a1d997ff27dfc5264a5c658.camel@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <a1ab92dd-6e76-fb30-d570-582cd3ebecd3@redhat.com>
Date:   Tue, 14 Sep 2021 12:52:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fb828c752fac255c6a1d997ff27dfc5264a5c658.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> I would do it this way:
> 
> struct svm_nested_state {
>          ...
> 	/* cached fields from the vmcb12 */
> 	struct  vmcb_control_area_cached ctl;
> 	struct  vmcb_save_area_cached save;
>          ...
> };
> 
> 

The only thing that requires a little bit of additional work when 
applying this is svm_get_nested_state() (and theoretically 
svm_set_nested_state(), in option 2). In this function, nested.ctl is 
copied in user_vmcb->control. But now nested.ctl is not anymore a 
vmcb_control_area, so the sizes differ.

There are 2 options here:
1) copy nested.ctl into a full vmcb_control_area, and copy it to user 
space without modifying the API. The advantage is that the API is left 
intact, but an additional copy is required.

2) modify KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE to handle 
vmcb_control_area_cached. Advantage is that there is a lightweight copy 
+ the benefits explained by you in the previous email (no unset field).

I am not sure which one is the preferred way here.

Thank you,
Emanuele

