Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D6B31DEBC
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 19:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhBQSCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 13:02:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234742AbhBQSC1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 13:02:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613584860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWiGWfzcYfTRYNwn5bn45x4oOrqQ38WANY07Gox027I=;
        b=XJ7gvUDaz5af9lVrJxx9TJCsC6U5awozspDAQWSxSOmQP9nI0qKLP/kChrfcGC7aqFq2Za
        /7iPRNpuEOlKV4tPEPZhMTnZ7eGV+O50LpcgNbhH/tEhVYEUZqEewIBDKMEo86+eBiOTht
        GQbyDPYVmt5B/f8z7UUOw93smMQOaqo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-At8CO9eYM4GaR3H_MzV6UA-1; Wed, 17 Feb 2021 13:00:57 -0500
X-MC-Unique: At8CO9eYM4GaR3H_MzV6UA-1
Received: by mail-wr1-f71.google.com with SMTP id x1so17326239wrg.22
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 10:00:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWiGWfzcYfTRYNwn5bn45x4oOrqQ38WANY07Gox027I=;
        b=fwKzYMIvkHBGhqK9VYVL8UyLitXemX60xrlDQJF6EtFxFESltaTB5eOOn7Ue4bA4DT
         vtistt7wZrZ59a6MsPBacGgQzX49hZ4JsJ1v31uwbJdegZnQYKNBhM2V4tZBLKvvYUfy
         ZBdeygRlJrizWxRW4EjQy34NgaNc+X7BdFuRus006wbhZvrImhJKE4g9snQea7VKzDXm
         srSgeIjAy/0hkyUmV4WJ7chPVh+PPeseAMzIw4QzpNs1kxUeZgYjL77pood876wmq4gM
         HwyudlklRym5BxymR6tCFkf2jr8lg/pklKTQoivUZIiqhISpR7/4StbOk74UbVABabLa
         zStA==
X-Gm-Message-State: AOAM533HRSnWE66xyFhkPUZ98/4/EebYmyGojuRqQJ8tMZy2nd2UzXfX
        trgAHaaR5g1aLzm+JhAysD9+C49cciQDoHSD9TrzcyVoB8DwH9wgw9iqvCpjcjsMoZTLtOOpBV5
        92+9q9tovDwW1
X-Received: by 2002:adf:f2c1:: with SMTP id d1mr333582wrp.345.1613584855009;
        Wed, 17 Feb 2021 10:00:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFbK08+UJ8QUvz0FNgBrsOTzClkMMR80nNg+ZQ4AVeH8xPFZd3/7fo8iwxuuNubrXMLO5KEA==
X-Received: by 2002:adf:f2c1:: with SMTP id d1mr333563wrp.345.1613584854817;
        Wed, 17 Feb 2021 10:00:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l1sm3917755wmi.48.2021.02.17.10.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 10:00:53 -0800 (PST)
Subject: Re: [PATCH 4/7] KVM: nVMX: move inject_page_fault tweak to
 .complete_mmu_init
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-5-mlevitsk@redhat.com> <YC1ShhSZ+6ST63nZ@google.com>
 <5a8bea9b-deb1-673a-3dc8-f08b679de4c5@redhat.com>
 <YC1ZI6DW49u0UP7m@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d4f00fbb-aeea-0aee-f22a-807aa32a3f39@redhat.com>
Date:   Wed, 17 Feb 2021 19:00:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC1ZI6DW49u0UP7m@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/21 18:57, Sean Christopherson wrote:
>> That said, I'm also rusty on_why_  this code is needed.  Why isn't it enough
>> to inject the exception normally, and let nested_vmx_check_exception decide
>> whether to inject a vmexit to L1 or an exception into L2?
>
> Hmm, I suspect it was required at one point due to deficiencies elsewhere.
> Handling this in the common fault handler logic does seem like the right
> approach.

I think I'm going to merge a variant of patch 5 just to unbreak things. 
But we should get rid of all this because after the exception payload 
changes we shouldn't need it.

Paolo

>> Also, bonus question which should have been in the 5/7 changelog: are there
>> kvm-unit-tests testcases that fail with npt=0, and if not could we write
>> one?  [Answer: the mode_switch testcase fails, but I haven't checked why].

