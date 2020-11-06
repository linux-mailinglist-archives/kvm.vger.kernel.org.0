Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A26E2A9658
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 13:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgKFMnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 07:43:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbgKFMnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 07:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604666599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YLHskCrfS0z3OoLalCf29HaFi8TidtghE6FdSxhOhCQ=;
        b=QlEJWDLVPsN0mqDsuGq45j44In3nRyYFizAWOJHZYJcVlZnluBrUeoqsfZvrvY1ouCbot9
        94Msg2sDE6N+t69tGKueVAnwguSGlhfI7lwexPEz4b4t8fLAtd4qHDPaU3TvB09Xi/CyFW
        22p3icNHGSprbxRp4Q4thRlgqx0I3vs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-eAsTwx3_MfaUC69xu4bmpg-1; Fri, 06 Nov 2020 07:43:17 -0500
X-MC-Unique: eAsTwx3_MfaUC69xu4bmpg-1
Received: by mail-ej1-f72.google.com with SMTP id o27so402166eji.12
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 04:43:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YLHskCrfS0z3OoLalCf29HaFi8TidtghE6FdSxhOhCQ=;
        b=joZivruMvxa6v7FKXU26eONBnvwaqGQtIZM3LdnZoxwaHw4M4kv/Njj7ROnBpS9bi9
         mHj5GzSTxClWWxxepGwvlDc0NtvZuxHc59+eZZ9WgUdD4KGOF8gf/FBoQdKX9wfd0+Pc
         P/xxh9Dk6texCyHfUFwOH4oWT7NBbm81EXHcKUP7HbQInTc+MxjCcg2pqxABE3C5lMnL
         TC8drcC7q+gSCjiUDm7lmnqb/vvm1beGIQGZJm7sSuskBrnIRg2DPrFVmzqxfaTDTWIA
         ZRpnKRocOOD26yQzoKm2Bl+WiGrzjHkjgZLrgctGZ4qbQfKlHncKp4kaEwp4t0WgqBV/
         aKaQ==
X-Gm-Message-State: AOAM531ZlvKUwU9fAhKuI2evso5LA2HDyTSbIib3oS8/ZEwUcztAC2w+
        jVMJf0IGmyJEyf9H7lU+ICMFNpVkcNbrnARt1VN/6uhufNC5m6vYts0YoFWqNcdh+gdcvKcwG1Q
        a3OqS047tw2HB
X-Received: by 2002:a17:906:892:: with SMTP id n18mr1821774eje.1.1604666596244;
        Fri, 06 Nov 2020 04:43:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+UF37EskuRfWO2kvbgzfsHQvokOCjkjT6Tkl2qNKnUtcpNvo64OzSYZmD3r9MkR9+fKmD3Q==
X-Received: by 2002:a17:906:892:: with SMTP id n18mr1821762eje.1.1604666596077;
        Fri, 06 Nov 2020 04:43:16 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id q22sm885336ejm.13.2020.11.06.04.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 04:43:14 -0800 (PST)
Subject: Re: [PATCH 5/6] kvm: x86: request masterclock update any time guest
 uses different msr
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>
References: <20201027231044.655110-1-oupton@google.com>
 <20201027231044.655110-6-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8575d45-846c-40aa-e436-51122eba6e02@redhat.com>
Date:   Fri, 6 Nov 2020 13:43:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201027231044.655110-6-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/20 00:10, Oliver Upton wrote:
> commit 66570e966dd9 ("kvm: x86: only provide PV features if enabled in
> guest's CPUID") subtly changed the behavior of guest writes to
> MSR_KVM_SYSTEM_TIME(_NEW). Restore the previous behavior; update the
> masterclock any time the guest uses a different msr than before.
> 
> Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
> Signed-off-by: Oliver Upton<oupton@google.com>
> Reviewed-by: Peter Shier<pshier@google.com>
> ---

Actually commit 5b9bb0ebbcdc ("kvm: x86: encapsulate 
wrmsr(MSR_KVM_SYSTEM_TIME) emulation in helper fn", 2020-10-21).

Paolo

