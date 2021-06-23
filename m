Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB573B1ECB
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFWQk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:40:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhFWQk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 12:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624466320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzECnKDBmIvo/ujBqWPH8Hf50HLw/m8oX6rv0gXcfxQ=;
        b=IL7I/xWhBYvZ8K4YZm4ZEgdW3jkTQCwDUNK7tqhsEhdaDxsD2uF14su78M9ucH6Ar8eISu
        DdbJHVfwm+5sl/pt3eWOqljtlgTl2DNfAakNEO9WbbFMH7Rs8WXY0Uj/gCh462bsmjOjrx
        xSr05b/NQQYPmPXr5u7YquWKr6uhjBE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-iiB-UikPOoe9ZBa5xVDDFA-1; Wed, 23 Jun 2021 12:38:36 -0400
X-MC-Unique: iiB-UikPOoe9ZBa5xVDDFA-1
Received: by mail-ej1-f72.google.com with SMTP id lu1-20020a170906fac1b02904aa7372ec41so1053705ejb.23
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZzECnKDBmIvo/ujBqWPH8Hf50HLw/m8oX6rv0gXcfxQ=;
        b=oQvsGTlHAr/IByPtdlLt5eTfI+M2oC39d/CDXiLnPFE4et/RcH9UlpeSMGoh5qXp3k
         HjcwZ64J72DQA7za5YOtQRRauuOtXl5gakoJcs8krckUFOkrUojdYluJtZIRwMyYdJuH
         naPx5eWUn8Imb7FreMdf36PQxpgDXrhpJ468V4ukXmasdH8VYV35JeRiSCh17uz1sUep
         qV2OYqzwUg1zG3h6Zdtn9XuC/3NrkAzS8FrOSowg+GX4nCjKMK40pMJPChTZmutiY+q6
         C63kna1nyKVuIHBwLNF8aeoeQxlsLRGncppc+2f4NZ7aI8GzahpN0plo1ROqoGSPQyIz
         Q04Q==
X-Gm-Message-State: AOAM532JaZut2O6gKpBr89CUfFgMe7fOBwQzzbfOxcUvj0OcaKYkycV5
        4BW3khJSpq2fwIFSv1Stzxh+oD4JLqY21eEkgmjV1Ma67gpgPCygc7MEAgcqxgr54KMtjRV2huB
        JHZo1f5ORh7Fo
X-Received: by 2002:a17:907:98c4:: with SMTP id kd4mr943066ejc.119.1624466315855;
        Wed, 23 Jun 2021 09:38:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdyc0GxzXAVwYD9leeHbZf3Ojn8RjxXdUDPOsa5C3q1WvM24iq/adb2MXELwzuVvE/n2m6Zw==
X-Received: by 2002:a17:907:98c4:: with SMTP id kd4mr943052ejc.119.1624466315643;
        Wed, 23 Jun 2021 09:38:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d6sm318843edq.37.2021.06.23.09.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 09:38:34 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-10-seanjc@google.com>
 <f2dcfe12-e562-754e-2756-1414e8e2775f@redhat.com>
 <YNNOeIWqNoZ3j8o+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
Message-ID: <f13fcf5b-f6bc-fb95-6f69-ea524ae446f5@redhat.com>
Date:   Wed, 23 Jun 2021 18:38:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNNOeIWqNoZ3j8o+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 17:08, Sean Christopherson wrote:
> Because the shadow page's level is incorporated into its role, if the level of
> the new page is >4k, the branch at (1) will be taken for all 4k shadow pages.
> 
> Maybe something like this for a comment?

Good, integrated.

Though I also wonder why breaking out of the loop early is okay.  Initially I thought
that zapping only matters if there's no existing page with the desired role,
because otherwise the unsync page would have been zapped already by an earlier
kvm_get_mmu_page, but what if the page was synced at the time of kvm_get_mmu_page
and then both were unsynced?

It may be easier to just split the loop to avoid that additional confusion,
something like:

         /*
          * If the guest is creating an upper-level page, zap unsync pages
          * for the same gfn, because the gfn will be write protected and
          * future syncs of those unsync pages could happen with an incompatible
          * context.  While it's possible the guest is using recursive page
          * tables, in all likelihood the guest has stopped using the unsync
          * page and is installing a completely unrelated page.
          */
         if (level > PG_LEVEL_4K) {
                 for_each_valid_sp(vcpu->kvm, sp, sp_list)
                         if (sp->gfn == gfn && sp->role.word != role.word && sp->unsync)
                                 kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
                                                          &invalid_list);
         }

Paolo

