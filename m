Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44B43E8F87
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbhHKLgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 07:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237154AbhHKLgi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 07:36:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628681774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+S2exkjtlBxygOtOf45G5PJ8smTzamomsBrJITv8Zac=;
        b=BbSp06VvP/+ZBm8X9M1RPKgY0wGTHpvtWlmxO28n+kFXjfICXc2p14IgqetQhmydFLinza
        o+XAIX3pKOsJGP6UqoFFlWA3PnY3yxQDyXBbdxr3N9xBLO/gs7EV7mdku8YBHh3Cz2Kmqd
        15ydBmkWqxDQFAklulrq7fRW0KlAXF8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558--vVR8fMVPPqZQjiyM5RGGg-1; Wed, 11 Aug 2021 07:36:13 -0400
X-MC-Unique: -vVR8fMVPPqZQjiyM5RGGg-1
Received: by mail-ej1-f71.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so574523ejc.8
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 04:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+S2exkjtlBxygOtOf45G5PJ8smTzamomsBrJITv8Zac=;
        b=rOFRjP7Ct5FaukgoEBnD2BV044BEzrAlFVKgdEi/xlnCh5skR/ffLq8TNJgVEAsW7h
         sJwpaM/mk1PKEmb89crY5xVOO83eKFOfbxULNQH2FTumxjCDtPa1eCtwVtUWwipCHSUp
         hM/nZU2KOCcFWqNRjF9bn4ptWnXjswqTz2XYLWtFLECawUzA+nix7hlYKqZHAwOLAHwd
         +rC9mLq2gkl3ntEFrgepzWsW2Wqdk5RzNBWkem3mqxTDd1MZmJzWy2j6/CWJKea/Vzcy
         u1wJnoWBGNt4NwTx6Y0hMDeObPFeWmhaTv5nxBj+TSXdHDr1bqs+jKsXQyyG/c+zX+HQ
         NzCQ==
X-Gm-Message-State: AOAM530VUlcsTjq29WUeltOC3atQfKMXiBDXPHUz3tlKrPn9FxQdp7Qx
        mLl321dZGFdr5K0Y0BRPoSB6YLIaeDXVqx9MmPKT5adYC87E8/zr6v+0Kpl7cZsfPtDWzFb6vNL
        YZSybld33pGW9
X-Received: by 2002:a05:6402:94b:: with SMTP id h11mr10671269edz.76.1628681771939;
        Wed, 11 Aug 2021 04:36:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUzWqNXPpLEiXwfgxkzBIN1W6Pp9trzh8bVCD3xoae7TLtfwWpOMpwPsaWV3Cw8DEovIjkXQ==
X-Received: by 2002:a05:6402:94b:: with SMTP id h11mr10671247edz.76.1628681771743;
        Wed, 11 Aug 2021 04:36:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id h19sm1463315ejt.46.2021.08.11.04.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 04:36:10 -0700 (PDT)
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20210803044607.599629-1-mizhang@google.com>
 <20210803044607.599629-4-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f047f6ea-6d66-b7a7-cb39-7f5427876913@redhat.com>
Date:   Wed, 11 Aug 2021 13:36:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803044607.599629-4-mizhang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/21 06:46, Mingwei Zhang wrote:
> +	union {
> +		struct {
> +			atomic64_t pages_4k;
> +			atomic64_t pages_2m;
> +			atomic64_t pages_1g;
> +			atomic64_t pages_512g;
> +		};
> +		atomic64_t pages[4];
> +	};
>   	u64 nx_lpage_splits;

This array can use KVM_NR_PAGE_SIZES as the size.

Queued, thanks!

Paolo

