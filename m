Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A853EECF0
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhHQNAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 09:00:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhHQNAw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 09:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629205219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=24VNOmz3ABWZ8T8FOYCfWGXdG4dpgLm2OSCtpNdnMWE=;
        b=eCr/dyUX9fwIeoccexoWD5WMrAksQ0Rj41I9SCGjvynjNJWuGF7mfZ7yEPdcHCnFRkVWU0
        bhADD+m4bfRqULMVLND1JjDgYrLMLdBesGQ3VEt4iDORFzgrgESTpNLef3hoz9o1kIao6N
        yi3vi+iRJOgCQc3LMT/qhFuf1qfRvJY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-yU0Qtw6eOoitCIih0yQ_kg-1; Tue, 17 Aug 2021 09:00:15 -0400
X-MC-Unique: yU0Qtw6eOoitCIih0yQ_kg-1
Received: by mail-wr1-f72.google.com with SMTP id t15-20020a5d42cf000000b001565f9c9ee8so4392801wrr.2
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 06:00:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24VNOmz3ABWZ8T8FOYCfWGXdG4dpgLm2OSCtpNdnMWE=;
        b=Wv0E7RS9jw4qLwKdqygM9Yz1xH5RT3XkmqLK5Ab3pvqaCHGLgB43x9zWmYUctavot0
         BCKwA6ywil5XrFPKX74uto8axGM+QF0FSFRzFl/SiWtvHUOdJPMKJjOpgPFnimkvR6Mq
         hcVcDJyFgOJXShhmuSQgmdVDtDjnTDxQdBBT3fmzClG4JPnOLmQT31tf0CK0DjaXpEGi
         1FeQN7Hdzpo5IADXL0Ro9N+16UwFkQuIhvtMT2gH/S+sQIzjJn+sdoEXUAyJ74c2J51S
         Guuf3JaVXcm+RVNOKXrrVwiu6DgkuK4jixqtVuHc7k9zeTpeqRJ9bDe8MKV/8UG2Dyph
         5jiA==
X-Gm-Message-State: AOAM531V3skbBl9DHJl+C3+g60WptIJJdLCpCYB6TYKqZuZRkfOxN5ga
        1T28ZE4iPZuAZiRgEXdhgmsw9iBgBS8o7FCj/2QEyawZly45HS42cpKFsweoJlZDfH5x6tEXZg/
        9bT6YZ6/dSGfC
X-Received: by 2002:adf:ee0d:: with SMTP id y13mr3830214wrn.317.1629205214720;
        Tue, 17 Aug 2021 06:00:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyd17wV7H6XAYf16GItYIs4ZocBeJWlyLEaZpXY3BlSXznfe20ehIyweYotkmzEBPmLpFCJ4A==
X-Received: by 2002:adf:ee0d:: with SMTP id y13mr3830182wrn.317.1629205214516;
        Tue, 17 Aug 2021 06:00:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z126sm2138129wmc.11.2021.08.17.06.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 06:00:13 -0700 (PDT)
Subject: Re: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct
 kvm_page_fault
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-4-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <613778fe-475d-fcd6-7046-55f05ee1be6c@redhat.com>
Date:   Tue, 17 Aug 2021 15:00:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813203504.2742757-4-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 22:35, David Matlack wrote:
> -	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> -		/*
> -		 * The gfn of direct spte is stable since it is
> -		 * calculated by sp->gfn.
> -		 */
> -		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> -		kvm_vcpu_mark_page_dirty(vcpu, gfn);
> -	}
> +	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> +		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);

Oops, this actually needs kvm_vcpu_mark_page_dirty to receive the slot.

Paolo

