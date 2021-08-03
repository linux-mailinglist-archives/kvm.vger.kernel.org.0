Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECA83DE8AA
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhHCIqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234487AbhHCIqD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627980352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iANhlztARO325R7WvNzYfBHyV3Zp037KAmbrWxgTFzY=;
        b=VbONNOApG4cxHioKOGtgNNneRxg6hkJaZwWI16N4MOVVYzuFC9CYo//jPJKf8z3tX20iRK
        55E7MUhGc3iTcQLLB8jRLuY/Aafg3Ep8d1W2rqBaje6eIzgjSjBQ4h4q3jHyiw7n17pKk7
        WJ7y3FzsHb/EgH9U8YcfE00NpYxA0Qw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-6GkR7ABBNYOwucAiA_qTGg-1; Tue, 03 Aug 2021 04:45:51 -0400
X-MC-Unique: 6GkR7ABBNYOwucAiA_qTGg-1
Received: by mail-ej1-f70.google.com with SMTP id zp23-20020a17090684f7b02905a13980d522so1714738ejb.2
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 01:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iANhlztARO325R7WvNzYfBHyV3Zp037KAmbrWxgTFzY=;
        b=TlM5/F79Dw5M6xip4ejdMo0OVlyzF/gkNCiYu21iMJoI9+HRur0hNUH1Dh4RXsTjWJ
         tDsvMXSeY81Ebec+yt1/ee09wHTDFgtpj1fcrg7Wejn0PDVGGsodXNUj1XXPDoQHVmcv
         njm0Y+m/B5E8AtrvQKNVWz0X5kuasLcU2gRNYLswxk971pED7DmRAKaMsS5RdYo/jPtu
         dyWcQErte8AWVAwpCqzIWbL2FG4Hpsct3LtLTCyJvS84guPSfm4xlrzUXkTYHyeK6N/5
         zQRZaQdpasHbDM6kOikBm6TNYKyfNgdaFN4JP0XydZmhGv21LyAK68EmApGd2CJOr3l6
         4pZw==
X-Gm-Message-State: AOAM530kxhDU/MXkNXddqND3dM3v61Ix4m0vftRJ+bLumu+JSrWgbPWA
        zmwnfs27itbacm3HZ95yp1pkbe5TsvvAtMvEBMT16wFrFuaR99uZFjDkXvRwKK/LW8wLsl+OUS8
        azgCN0yZK+fEh
X-Received: by 2002:a50:da0e:: with SMTP id z14mr24713994edj.73.1627980350570;
        Tue, 03 Aug 2021 01:45:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCkagRcMhtmbJrZjOBeLVemJvXcgugb6f910OjikZKE8IYSVHjybA/5Uwzx7kONUFePHtjvw==
X-Received: by 2002:a50:da0e:: with SMTP id z14mr24713980edj.73.1627980350441;
        Tue, 03 Aug 2021 01:45:50 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id dn18sm7776486edb.42.2021.08.03.01.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 01:45:49 -0700 (PDT)
Subject: Re: [PATCH v3 08/12] KVM: SVM: add warning for mistmatch between AVIC
 state and AVIC access page state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-9-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ded9040c-a841-319f-0147-92e6fd6264cc@redhat.com>
Date:   Tue, 3 Aug 2021 10:45:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-9-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
>   
> +	WARN_ON_ONCE(vcpu->kvm->arch.apic_access_memslot_enabled !=
> +		     kvm_vcpu_apicv_active(vcpu));

This should also check !vcpu->kvm->arch.apicv_inhibit_reasons instead of 
apic_access_memslot_enabled.

Paolo

