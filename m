Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158FF363007
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhDQMul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:50:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236092AbhDQMuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imq7uItrr0YxU0EZEqml8s/Gsv0G1i9Sjy/8OWB/B8c=;
        b=bjqHRMUXCN/+jLQ/3b3NStxGIqz5vfG8G0A9R0m0pS5kdxz8Rp7E9lv23MRXfib30zXCfq
        jJdBb26XsNC9NnHQqmRBKMEOzHcAx0tViufVIORt3Fb2X7210bM5UF+DUGkmTejD+5q8aw
        9wlhttnkhy7Dls2kpUBfe0rFOunjdg0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-9X6Lfmp_O5mctOh6HQg4XQ-1; Sat, 17 Apr 2021 08:50:11 -0400
X-MC-Unique: 9X6Lfmp_O5mctOh6HQg4XQ-1
Received: by mail-ed1-f70.google.com with SMTP id bm19-20020a0564020b13b02903789d6e74b5so8558599edb.21
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=imq7uItrr0YxU0EZEqml8s/Gsv0G1i9Sjy/8OWB/B8c=;
        b=KEhIPGRS0+eqR4X8WIeDIH0clT7qCxPMVsfbfsBdCivPwsdEy4qhnNUkurlBUvR8RC
         9UCj7PYYQCY39NgVOu8CEiawfx4yQfTghfe3PL9jZ/mcjxbQN2y4GTgG+URiAN09korX
         cQSb0CRWNxP4ayzsK6kWcGSwdxya4xGFNc7FNtUBhj71G5mZQijnhPsODrCcyCBxZeqS
         JZl7ZQwrTKFv1Fcmni2uFEjLH1X7cqywswlLxd25SK1EYYn7yTD678/M0goLW2IigA5z
         QxuFXyP+FrKDx0bjYKqu0rvoxZ/r/Ij2xuUSbLTwVaaNBJ4e2/D4MO0B8bE8Srgrwaoo
         9CxA==
X-Gm-Message-State: AOAM533NFV3Y9VWF5b28ca6o7iaoxemIkRX0YHxBfhueTgaTyh4Yq0Vh
        l7aXfV5IaeDFo3tJnv/GwZEkDNPqRHGk+K8RNB2Oll9e7NrI7E9H964TsdBdl4+hHUgWPBASNKa
        x16dQSKdxDwm8
X-Received: by 2002:aa7:d9ce:: with SMTP id v14mr4720240eds.110.1618663810614;
        Sat, 17 Apr 2021 05:50:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySzvWasWJZOfOzLQumKdE/3y1yRtBrfqEec5ONJbUnF72oqb9NqEXYW3z6X8nsclSvPgFefw==
X-Received: by 2002:aa7:d9ce:: with SMTP id v14mr4720227eds.110.1618663810468;
        Sat, 17 Apr 2021 05:50:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm6246042ejx.27.2021.04.17.05.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:50:09 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: SVM: A fix and cleanups for vmcb tracking
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210406171811.4043363-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0444df02-48de-6ff8-5e54-7dfb841ef153@redhat.com>
Date:   Sat, 17 Apr 2021 14:50:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406171811.4043363-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/21 19:18, Sean Christopherson wrote:
> Belated code review for the vmcb changes that are queued for 5.13.
> 
> Sean Christopherson (4):
>    KVM: SVM: Don't set current_vmcb->cpu when switching vmcb
>    KVM: SVM: Drop vcpu_svm.vmcb_pa
>    KVM: SVM: Add a comment to clarify what vcpu_svm.vmcb points at
>    KVM: SVM: Enhance and clean up the vmcb tracking comment in
>      pre_svm_run()
> 
>   arch/x86/kvm/svm/svm.c | 29 +++++++++++++----------------
>   arch/x86/kvm/svm/svm.h |  2 +-
>   2 files changed, 14 insertions(+), 17 deletions(-)
> 

Queued, thanks -- especially for the bug in patch 1, which avoided review.

Paolo

