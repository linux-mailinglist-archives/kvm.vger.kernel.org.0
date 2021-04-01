Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD343513B7
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhDAKgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:36:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233917AbhDAKgU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 06:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617273380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=810J1/GaDcVsqpgpBl9h+wW/EjeyXRqZXrkMEl4sg0A=;
        b=GuGNfii/VBoQFn9nCFBqKzQFHQEtBflr5Y0jb99QedYTMyphlb4oHM0wSc3mV3Hlc97Xpx
        n+7hCtrpt1WH39Qi2ykynkZ9JQR1za9uTgHPd3ejUf4upR65twVUqSWAp6TN2S1oninsvd
        pmWqk3KgEConOSIAea8HHfJ6B611SIk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-Cn7_2Cq_PbW3xuhLI_f0KA-1; Thu, 01 Apr 2021 06:36:18 -0400
X-MC-Unique: Cn7_2Cq_PbW3xuhLI_f0KA-1
Received: by mail-ej1-f71.google.com with SMTP id bn26so2026265ejb.20
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 03:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=810J1/GaDcVsqpgpBl9h+wW/EjeyXRqZXrkMEl4sg0A=;
        b=dN2TEo6JYiZ7tVkz0cZqVqThWQm9adtbCbuNk1DrJriwHc4gHIWnFpqPwOq8VYJjEk
         xWBg6oiUeTDVhzt65WWmmLh62ExQ4WhvgFzsW4HyI33qlnUX2jOPfu7OWLwlyGLvBbZu
         MieC99+fAnZDhI5AUL8CgT7u8Gj3um0KppQrKBjoix/9Jhh6Jft8uoRjzwO+a+Jqnwe6
         REXnAdqtSOFV0Mmq6UQORlFXhyX3xSR2T9nvpx1Q/rMDGOqZRVtxM5gvpLVbCkTBTAmh
         MDgRelaZaHTBOY6aj/DmIfWJ5KJRaNgqF5A3RU4R+930Vs9M+yVRrUTvZyClFXV2FCbh
         2ebQ==
X-Gm-Message-State: AOAM532ufq0MKR38UYTmF53wfWL451tl66eppRZOKQrnuuyYQW8Nc586
        z5DQIEhhQblDeo4imeaBg/z2pJkAYg3zDsdYdKHn1aUgCHxxKCMBAenrgtXfsiatmpd5X4JUid6
        5+aS0tOifgym+
X-Received: by 2002:a17:907:1614:: with SMTP id hb20mr8375162ejc.77.1617273377239;
        Thu, 01 Apr 2021 03:36:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU+gqzTF3pii9ZoNjuKrbXXN9nHplHntt5RILHXU3PdnyQp/B39VwFMSuYP0ElcHRac1Zf/Q==
X-Received: by 2002:a17:907:1614:: with SMTP id hb20mr8375137ejc.77.1617273377031;
        Thu, 01 Apr 2021 03:36:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l18sm2523107ejk.86.2021.04.01.03.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:36:16 -0700 (PDT)
Subject: Re: [PATCH 12/13] KVM: x86/mmu: Fast invalidation for TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210331210841.3996155-1-bgardon@google.com>
 <20210331210841.3996155-13-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <79548215-b86f-99de-9322-c76ba5a1802d@redhat.com>
Date:   Thu, 1 Apr 2021 12:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331210841.3996155-13-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 23:08, Ben Gardon wrote:
>   
> +	if (is_tdp_mmu_enabled(kvm))
> +		kvm_tdp_mmu_invalidate_roots(kvm);
> +
>   	/*
>   	 * Toggle mmu_valid_gen between '0' and '1'.  Because slots_lock is
>   	 * held for the entire duration of zapping obsolete pages, it's
> @@ -5451,9 +5454,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>   
>   	kvm_zap_obsolete_pages(kvm);
>   
> -	if (is_tdp_mmu_enabled(kvm))
> -		kvm_tdp_mmu_zap_all(kvm);
> -

This is just cosmetic, but I'd prefer to keep the call to 
kvm_tdp_mmu_invalidate_roots at the original place, so that it's clear 
in the next patch that it's two separate parts because of the different 
locking requirements.

Paolo

