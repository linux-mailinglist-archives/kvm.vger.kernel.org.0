Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5472DA2AB
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgLNVnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:43:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392109AbgLNVmy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 16:42:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607982088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DV2mr6X5vesd9C3WlI0urcyPxkqlznyh99zPeXEjrvs=;
        b=UhOLXgKKfQWcDrKDh8qNpWs9uCh/bp/k7DTouR46yIEfxQhdN9RtjAuxgxKuR09bSQ4kEz
        U9o7sJ652fHDf9U3ylH3gLi8jo5rXe6h3XEvbVX9VvJjEDkJHQeam5oS/9xgJkUem6m3lz
        9yOs+i76yl3abxcXRMOb9u3RCLIw99Y=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-RhVs-OyiPECKm2RWGfvwgw-1; Mon, 14 Dec 2020 16:41:26 -0500
X-MC-Unique: RhVs-OyiPECKm2RWGfvwgw-1
Received: by mail-ed1-f70.google.com with SMTP id p17so8936005edx.22
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:41:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DV2mr6X5vesd9C3WlI0urcyPxkqlznyh99zPeXEjrvs=;
        b=mH6Gq7l+MI2D5mNjVtL4fsmWkGiifrh9bixRyH2QUchbd+hwNTnPb0IlVgpAz/vtuj
         fpCFuneE5X8lD+Q5Zbtd2gjjdInUuZ/O3QI8HadQD2F0J1lqH5iiZ7XoR2ZYX/iT0/of
         uszIqntHPLRH5fUBBBVcLT18x9WaETVSVBd+4j1qCKpyMRQaPVz0CRvyvSpmQ0zHlnax
         vKcDXbfHHbTIY53my5GUYrDqtanT1i/sVLj3/gt+4GQ18AkW9dwd0p0mvabSg+brXN7k
         irjV7tvxdRh75KDxYucAqaLXaoTwsePJ9N9hY1q3iZleNL7BSgApHceKpB+1yR2K2rDz
         j1pA==
X-Gm-Message-State: AOAM533jwQw9QsFOzTOemQLCtaLuHrIk9ZQgwxyjxXExjUHHVVfbLjME
        yKZ4X7MU3knaaQCAKSRZYQfBndBlzyAj8W/K+EuF5RVHQr0rimJkEBX3tWwEzDJfD6dj3wC7TQ7
        j+1QgwFT6PdRe
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr26513114edv.181.1607982085286;
        Mon, 14 Dec 2020 13:41:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUk89K2+30f3elqKuu9WOlVFi4pIAsQjKigrfZO2J0L1BTXheuLbdVa4VsgJnHo4+hMmlenw==
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr26513093edv.181.1607982085142;
        Mon, 14 Dec 2020 13:41:25 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f8sm16605165eds.19.2020.12.14.13.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 13:41:24 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 01/17] KVM: Fix arguments to kvm_{un,}map_gfn()
In-Reply-To: <6E8FD19B-7ABD-4BF1-84C5-26EDD327F01D@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-2-dwmw2@infradead.org>
 <87ft48w0or.fsf@vitty.brq.redhat.com>
 <6E8FD19B-7ABD-4BF1-84C5-26EDD327F01D@infradead.org>
Date:   Mon, 14 Dec 2020 22:41:23 +0100
Message-ID: <87a6ugvzek.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> On 14 December 2020 21:13:40 GMT, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>What about different address space ids? 
>>
>>gfn_to_memslot() now calls kvm_memslots() which gives memslots for
>>address space id = 0 but what if we want something different? Note,
>>different vCPUs can (in theory) be in different address spaces so we
>>actually need 'vcpu' and not 'kvm' then.
>
> Sure, but then you want a different function; this one is called
> 'kvm_map_gfn()' and it operates on kvm_memslots(). It *doesn't*
> operate on the vcpu at all.
>

Actually, we already have kvm_vcpu_map() which uses kvm_vcpu_memslots()
inside so no new function is needed.

> Which is why it's so bizarre that its argument is a 'vcpu' which it
> only ever uses to get vcpu->kvm from it. It should just take the kvm
> pointer.

Your change is correct but I'm not sure that it's entirely clear that
kvm_map_gfn() implicitly uses 'as_id=0' and I don't even see a comment
about the fact :-(

-- 
Vitaly

