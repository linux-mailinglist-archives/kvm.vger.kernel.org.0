Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01263D6855
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 23:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhGZUTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 16:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232992AbhGZUTr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 16:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627333214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/2NV58+R3TTXhlXYbDsz/es4LHmfDCv8omJdsxV3Uw=;
        b=Oj/HcR6UEGuLx0sfx/qTGHifY3DfLwzyVlHX1rHCYkf1Tt7FSJh01S+WXQO1mKRQ35s6is
        hudHxPOmpbnxfTv7wcyH1DD0ft3fzo/mBEpsBdt4sumDIxPKa1yFUdVvLSNqoADoIohiQJ
        48YSfzEwRlCNf6bzXYQZl/tUA0yJBCE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-gPkLE_ncO2aClAdS0otHew-1; Mon, 26 Jul 2021 17:00:11 -0400
X-MC-Unique: gPkLE_ncO2aClAdS0otHew-1
Received: by mail-ej1-f72.google.com with SMTP id g21-20020a1709061e15b029052292d7c3b4so2468526ejj.9
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 14:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n/2NV58+R3TTXhlXYbDsz/es4LHmfDCv8omJdsxV3Uw=;
        b=hxt56eYA22vjGhighdvm0U8dGOHu8fDGmHxn/5rZuuTvKqGT/RJ8N8iGGkY53m8zW/
         3MLKewCzifhgTgaGtKH5nAmOQVRWE1KBE4EyXtz16Dmypjf29o51Rmw31q2cghQWICtO
         8xnSL+tFU7bE/XQmzf0pT9IzF+5S4ESSFKYZ8B14+Dqjlzc4fA43I8wFexUk2X6by703
         hXuZoMtU18cB7l92gXKRmAxn9mj14xNxzvvAosIFxaUSyQ7NCXOOBzQNB6OwGKIxdVlk
         ahJzdL1kVMmQz27+x8VPIDeJf1G44H+/pO3iI+vHEN4UAU/inhrCCuhFM0W8jfd5Mgd/
         VcvQ==
X-Gm-Message-State: AOAM531TEnFrF8reNqWxwizY69qc2pZU1EfVN43NVB4UG3yGdYW++ybI
        BYs3E6IbKPnC8hFFj6gYUGPf0L6g9DjHfSMuFMfIIHRbK0+Fv+2HzeJKjFgX2Z+8XNqxhXOb72c
        ik8+ZtWieoT/b
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr23484117edt.321.1627333209954;
        Mon, 26 Jul 2021 14:00:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztDsC08Z/aUiP1V66rA7QrjiGQa4Xn5UaHN+Ib73DVd8YXdXu3VfivStRUUmdTsaAqeK5HiA==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr23484084edt.321.1627333209765;
        Mon, 26 Jul 2021 14:00:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n14sm377090edo.23.2021.07.26.14.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:00:09 -0700 (PDT)
Subject: Re: [PATCH v2 41/46] KVM: VMX: Smush x2APIC MSR bitmap adjustments
 into single function
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-42-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7ddb5bfb-f274-9867-3efb-0b6ba5224aa2@redhat.com>
Date:   Mon, 26 Jul 2021 23:00:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713163324.627647-42-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 18:33, Sean Christopherson wrote:
> +	if (!(mode ^ vmx->x2apic_msr_bitmap_mode))
> +		return;

Just !=, I guess?

Paolo

> +	vmx->x2apic_msr_bitmap_mode = mode;

