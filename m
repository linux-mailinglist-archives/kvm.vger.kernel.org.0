Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAC938FB71
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 09:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhEYHMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 03:12:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230366AbhEYHMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 03:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621926675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7mLmIW6ehg0LCjXEELVdzJZToVTG1vKZ+tSeDNW/S8w=;
        b=EJp/O0WkRxe4EAvCjKvg5lDSVDETEbVAa20UBVb+eIH4ZGjyo803sFJWOI6GNFO95Gft4M
        3KIM1Voa86BHg7Tv4HHHwhhY8945nPI9yWiD6ukxs1XeF8eDP8nIrL3r3r9/UoQABWr22s
        V50MgiYT4S+P4sTopewX+o68T8mIczM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-ft6zJySdOMed5J8zbHY8iw-1; Tue, 25 May 2021 03:11:14 -0400
X-MC-Unique: ft6zJySdOMed5J8zbHY8iw-1
Received: by mail-ed1-f70.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so16822262edd.2
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 00:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7mLmIW6ehg0LCjXEELVdzJZToVTG1vKZ+tSeDNW/S8w=;
        b=j0544Ytxsw56O4wDpHu5p0LGVCl8lSSk2BLS8WzH3lKfv7ECvODZFslDgJWaOPns7j
         7GwJURBg2A4bFBn8GG8RjvxXwll0W6JrvGjxmdwNd+MsKPr4x3itG6EYpS8HZAYwERox
         Ufo3HLjnICiT/rdkgjP0PJrcAsl582vZDyirkUfTndmWPd0PiZUJlsVmddWCYrHgb9kc
         gIgXHIwrEV4BquA78vW4jNAr4RWiJ9ecEfGckQJqw0DJxNxtoT/Smr05EfbybdExm6L5
         rtfsOcOBhCJxRxj/8wLroTANzZ5pujEH4kgsQYaTGyL7kbt+Oxjr8Y7QMieyjMd1Cczi
         AfBQ==
X-Gm-Message-State: AOAM530Awp2DHs+ND8uV+6cdLAfsw/PyABJnkvVJH8mxUCYQcXPDl5/N
        qeorb6PNM9C51xSRXurLN1ET+jInxZseG5BpBJYGAFgbawg0D/VWAxffYctKgYc+YvkSYtuY9d4
        aZTOOVr0AMB1H
X-Received: by 2002:a05:6402:c8:: with SMTP id i8mr11472862edu.380.1621926673166;
        Tue, 25 May 2021 00:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiPJkqMYvGP9jvqBWS9kpUE2n3iiJUQJOaGaZuwoHN+m9v6QC3OymSTLFWevkXIv8urAMHkQ==
X-Received: by 2002:a05:6402:c8:: with SMTP id i8mr11472845edu.380.1621926673036;
        Tue, 25 May 2021 00:11:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n24sm10390224edv.51.2021.05.25.00.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 00:11:12 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-6-vkuznets@redhat.com>
 <82e2a6a0-337a-4b92-2271-493344a38960@redhat.com>
 <87fsyb8h7s.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b8d0e27-a893-b090-7ecd-df17eefdf6f1@redhat.com>
Date:   Tue, 25 May 2021 09:11:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87fsyb8h7s.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 08:23, Vitaly Kuznetsov wrote:
>> Should it also disable APICv unconditionally if
>> HV_DEPRECATING_AEOI_RECOMMENDED is not in the guest CPUID?  That should
>> avoid ping-pong between enabled and disabled APICv even in pathological
>> cases that we cannot think about.
> When you run Hyper-V on KVM it doesn't use SynIC (let alone AutoEOI) but
> we still inhibit APICv unconditionally. The patch as-is improves this
> without any userspace changes required and I see it as a benefit. Going
> forward, we will definitely add something like 'hv-synic-noaeoi' to QEMU
> to make non-nesting setups benefit too but it'll take a while for this
> option to propagate to real world configurations (sigh).

Ok, if enable<->disable APICv becomes an issue we can also consider 
disabling APICv forever if AutoEOI is ever used.

Paolo

