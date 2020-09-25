Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3D27924B
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgIYUiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727286AbgIYUiH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:38:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601066287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWeiJx3sxuFTq2/3Kl2souS6jLFXPZ/6WseamNe8sdQ=;
        b=CupCVPOZxiUhLnJ87xIU7N4KgOffybyI5gOTQ5EFrnZoBoFIQcuIQY/GgeA/uk/Bk0KIP9
        haM4eo+eXBXVOw8dI+tPEjitymU9RkAeIepWebjBfaWCHcZyMblolioWE6xX+9i9B+1OOg
        NUqZ4X5FnwrbUu8/KAd8y6OxQsdRATU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-rInnFwnIP12zNXqwjdjNWQ-1; Fri, 25 Sep 2020 16:38:05 -0400
X-MC-Unique: rInnFwnIP12zNXqwjdjNWQ-1
Received: by mail-wm1-f70.google.com with SMTP id m25so84929wmi.0
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uWeiJx3sxuFTq2/3Kl2souS6jLFXPZ/6WseamNe8sdQ=;
        b=H0cfDNL+Dz78Go9x3bHQvr0ymtdG6DdQ/FzMbdYMMsG+aiw87SPlVMNhgpe94h48sD
         gJXmWZtmV3POBAk/KRqx0+CHzQvGBdy064YQtkGs/l8TacdqVmcO1O80WFXzKUpg1S6l
         YxYl/SZA1JRfWptfB8Fo2UogBpUct/8fNRjhTFaPMYuMLkVUiAPSS+jylk9OmgL6/Jsx
         nt+yJxDxFFWBx4Nog8UyLrpnOjNTKqNUxZ+1LCuSQbLaYvwkmJ+JZbG2MUQxbm002CpR
         CZIwaUwvCmdRRCQz6fbpMWYT1bG1oHaAmKNohVxYIT/AS5HSi3xGGCjZgDVPaA50OJvD
         M4ZQ==
X-Gm-Message-State: AOAM533cr8KdWKBx38RLMljdAAlM3sEb9G1wh+uEwXQibBU/fr7d8RUP
        n+dO4P3y2ODAuxDJg85yadQhTkQ/U9hzlxIPFixj4miOXQMaBN4IteBkJdSExXzV61od5dUGrz0
        gX9Ywch4xENlf
X-Received: by 2002:adf:ec47:: with SMTP id w7mr6747273wrn.175.1601066284105;
        Fri, 25 Sep 2020 13:38:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbpCJ+RQiq27xPB84gL69eoIjGEkAsGv4FYrVYBjyXXAGHSnL/vEF1J5oPR/Zh36nAZMfXnw==
X-Received: by 2002:adf:ec47:: with SMTP id w7mr6747260wrn.175.1601066283908;
        Fri, 25 Sep 2020 13:38:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id l8sm4083404wrx.22.2020.09.25.13.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:38:03 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Page fault handling cleanups
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
References: <20200923220425.18402-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ca36404c-9b2a-dbce-d5e4-a3fc3cc620bc@redhat.com>
Date:   Fri, 25 Sep 2020 22:38:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923220425.18402-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 00:04, Sean Christopherson wrote:
> Cleanups for page fault handling that were encountered during early TDX
> enabling, but are worthwhile on their own.  Specifically, patch 4 fixes an
> issue where KVM doesn't detect a spurious page fault (due to the fault
> being fixed by a different pCPU+vCPU) and does the full gamut of writing
> the SPTE, updating stats, and prefetching SPTEs.
> 
> Sean Christopherson (4):
>   KVM: x86/mmu: Return -EIO if page fault returns RET_PF_INVALID
>   KVM: x86/mmu: Invert RET_PF_* check when falling through to emulation
>   KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed
>   KVM: x86/mmu: Bail early from final #PF handling on spurious faults
> 
>  arch/x86/kvm/mmu/mmu.c         | 70 +++++++++++++++++++++-------------
>  arch/x86/kvm/mmu/mmutrace.h    | 13 +++----
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 ++
>  3 files changed, 52 insertions(+), 34 deletions(-)
> 

Queued, thanks.  Looking at the KVM_BUG_ON now since patch 1 is somewhat
related.

Paolo

