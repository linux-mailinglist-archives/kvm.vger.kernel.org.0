Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5343EF08E
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 19:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhHQRDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 13:03:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhHQRDF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 13:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629219751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ltq+fwytIpin2Fxi6msuoYUCCRLZEzmr3HuFsNhqJo0=;
        b=LlJnGRl2ipDeOnSAlyob5q0tTwdweDX/TLcbdRNSzw7jym4TATdbyCQksxXVOUaeZNVEW/
        OieVnK4WuXdtvrALUCz237/cbUBc1S7UfzVtIw8rjPih+CiYRG9ZwhPH0F+YY5lOy+oucz
        eowGtalCnBWOZH8G8DpUOfOm2Rvj0ko=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-JWuLgsUGPs6_Tb6wnGqCmw-1; Tue, 17 Aug 2021 13:02:30 -0400
X-MC-Unique: JWuLgsUGPs6_Tb6wnGqCmw-1
Received: by mail-wm1-f72.google.com with SMTP id n20-20020a05600c4f9400b002e6dc6a99b9so974430wmq.1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 10:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ltq+fwytIpin2Fxi6msuoYUCCRLZEzmr3HuFsNhqJo0=;
        b=tb8F0pUgRg9X0dIlH4dEdhYZxauugVp3DZuMbaCIVg5iDB/Ln0fRbF2aYiEwxRojQ2
         vjLhm9PEmpDUswNME2E8CZo7IDgCq/lQpvokNyTDx9S50hjyE6WuEBygWI9jDNdOiPYu
         bIZUC7XJ84sk7PZ+gL917uXVmpIrDmfWsPjtRwQbdYQ29uidYmWyuWGRFFd/o9SmVE56
         dJJRm0cO+NJS8b2ijML17YIhayWS3+lq9fB+jpBIWpgfty7rt82n6OitKRKj5fH4f0yE
         2SutW/Dml5CBeIw8idOsAIFXbH7UsGtnuFx5XdfvOi70cGqvaBtQWD384NUFO/E7a99Z
         LpIg==
X-Gm-Message-State: AOAM532xYojMDCqgIEdj110BgQdlPKgUtz9LJZHq/giFYatIklA5+lkz
        sAeeAK9W28NmTpwwEKaS7f4qCnxtCR6AT1KpiX2VOI/FNIU6FJ738B1mOSCt2KliAMpMIJExmZx
        g91wjYHJBUMpB
X-Received: by 2002:a1c:7e85:: with SMTP id z127mr4338607wmc.35.1629219749106;
        Tue, 17 Aug 2021 10:02:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCExxGC5g0eRb4d2q9XcvdaTG9qYHgh8Gn1aetqGJ+xswDO6vDle/2BBA0vdCLI4gsCYLs+w==
X-Received: by 2002:a1c:7e85:: with SMTP id z127mr4338593wmc.35.1629219748938;
        Tue, 17 Aug 2021 10:02:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id a11sm3123431wrw.67.2021.08.17.10.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 10:02:28 -0700 (PDT)
Subject: Re: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct
 kvm_page_fault
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
 <20210813203504.2742757-4-dmatlack@google.com>
 <613778fe-475d-fcd6-7046-55f05ee1be6c@redhat.com>
 <CALzav=cXzvWnSP3d_Krcwa3wUteoFe+ufd=37W+9ug+BGMhcGg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b1d0587-2d8e-1129-9ae7-960595c03b13@redhat.com>
Date:   Tue, 17 Aug 2021 19:02:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALzav=cXzvWnSP3d_Krcwa3wUteoFe+ufd=37W+9ug+BGMhcGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/21 18:13, David Matlack wrote:
> On Tue, Aug 17, 2021 at 6:00 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 13/08/21 22:35, David Matlack wrote:
>>> -     if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
>>> -             /*
>>> -              * The gfn of direct spte is stable since it is
>>> -              * calculated by sp->gfn.
>>> -              */
>>> -             gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
>>> -             kvm_vcpu_mark_page_dirty(vcpu, gfn);
>>> -     }
>>> +     if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
>>> +             mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
>>
>> Oops, this actually needs kvm_vcpu_mark_page_dirty to receive the slot.
> 
> What do you mean? kvm_vcpu_mark_page_dirty ultimately just calls
> mark_page_dirty_in_slot.

Yeah, I was thinking of some very old version of the dirty page ring 
buffer patches.  What I wrote makes no sense. :)

Paolo

