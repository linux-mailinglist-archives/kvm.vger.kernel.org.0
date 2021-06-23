Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5253B21C0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFWUZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229955AbhFWUZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 16:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624479779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9inRY89TsT5DJ1D2z368LNI6P3yOUL9KZ0T/FVXFIE=;
        b=BQzMbnOr8K87nff6XtGU7tGxM7CFfiDdLUpvE0HtpWxVDNAsZ5a2vvaVrIUexO9N5eeyAK
        f6CwU3uPVxZK+AD0A4tjLA/obCFKwZKYDkR9SbQMDft6cUFaILrC+w+BvL88ihFpDE4Gl2
        Zze8lYxEZzfiaooOfqDxjedRcFdJQOc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-zG7t-FN5OD6kqvKCYPqnnQ-1; Wed, 23 Jun 2021 16:22:57 -0400
X-MC-Unique: zG7t-FN5OD6kqvKCYPqnnQ-1
Received: by mail-ed1-f71.google.com with SMTP id v8-20020a0564023488b0290393873961f6so1955177edc.17
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A9inRY89TsT5DJ1D2z368LNI6P3yOUL9KZ0T/FVXFIE=;
        b=rxF8zjdhxUXqGwkhQWwD6iAk0UJLNoU/I+YGV2SRNoUUu/qNkaDXNm+6cpZIaUmlAq
         2G9rVnlqf3RcrnPkMbh0nFF2IbMMuDwiIxPdWjeZxW+5+l/bVphJ44ABGa/Ub1izls88
         jdDTmf7wMdLOCeGWdqvucIDjoQevihaIVfPYK8d1BJJELHoUnHe5ZTJvlgHcxR11qC/w
         LzBFUJ23mE3daxRazqpe6lHRVhbohUIw/x1UFFlJd1ZdJLJjFoNypu0wAKslShJZ+uZ8
         8+dT2zEEC0td7eUIbmVQpxbXtHORR+qUBLtq0npCBMQp5RVJ+F5bdZlY0PfTXn9XVvB1
         YaTg==
X-Gm-Message-State: AOAM532Z8QUz+zgwDw99WOjt1ZtcwLlk3D/GhoKkAW1T7oa9AP1wg+mV
        XUiaeSz25zl3NWSDJKmYDbuTQae6DniWDmHWfSD1b128K/145FuRLKZhGDmGWqUNqLd995sVm4E
        IX4wNZasJo+ae
X-Received: by 2002:a17:906:b858:: with SMTP id ga24mr1775182ejb.355.1624479776573;
        Wed, 23 Jun 2021 13:22:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhmVrINxJjx/nb0p2vxzI/BThN7B2LoyvmZnp19v1XWSmDNQv7hN6+V/AP6Jrq0ETmlO010w==
X-Received: by 2002:a17:906:b858:: with SMTP id ga24mr1775174ejb.355.1624479776391;
        Wed, 23 Jun 2021 13:22:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c6sm577571ede.17.2021.06.23.13.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:22:55 -0700 (PDT)
Subject: Re: [PATCH 50/54] KVM: x86/mmu: Optimize and clean up so called "last
 nonleaf level" logic
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-51-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e7a290c6-aeca-bd7b-d0be-d1af44713138@redhat.com>
Date:   Wed, 23 Jun 2021 22:22:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-51-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> For 32-bit paging (non-PAE), the adjustments are needed purely because
> bit 7 is ignored if PSE=0.  Retain that logic as is, but make
> is_last_gpte() unique per PTTYPE

... which makes total sense given where it's used, too.

> +#if PTTYPE == 32
> +	/*
> +	 * 32-bit paging requires special handling because bit 7 is ignored if
> +	 * CR4.PSE=0, not reserved.  Clear bit 7 in the gpte if the level is
> +	 * greater than the last level for which bit 7 is the PAGE_SIZE bit.
> +	 *
> +	 * The RHS has bit 7 set iff level < (2 + PSE).  If it is clear, bit 7
> +	 * is not reserved and does not indicate a large page at this level,
> +	 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
> +	 */
> +	gpte &= level - (PT32_ROOT_LEVEL + !!mmu->mmu_role.ext.cr4_pse);

!! is not needed and possibly slightly confusing?  (We know it's a 
single bit).

Paolo

