Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64B2DACC1
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 13:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgLOMMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 07:12:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728117AbgLOMMJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 07:12:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608034243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xKG78tVWwkxniUz6StJ7P3PHjuo4F/t6OHAj2JgECiE=;
        b=OAZprLnGURT2bAjz+gFwL9cxQZqrZ+YuSPBaWpnRka5pPQlEc+1i+zd+s/p3bymOeGzPoq
        gFT+bramqpY5pLmgVIPu763D5Ejfrf5yGVA6gf1kkagsWYqXIMl9majOSE/WTZK3126+u/
        3IPtY8LKGn7JIpOVe8c3QGWO8M9s+/s=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241--CMFk_jSNUaFYlC3q0ow5g-1; Tue, 15 Dec 2020 07:10:41 -0500
X-MC-Unique: -CMFk_jSNUaFYlC3q0ow5g-1
Received: by mail-ed1-f71.google.com with SMTP id f19so9856005edq.20
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 04:10:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xKG78tVWwkxniUz6StJ7P3PHjuo4F/t6OHAj2JgECiE=;
        b=pSJOTOrshOli/xiZznfR0aZ7IeI1o/va72jot2j3DUz8rnY+HSQa0dYxhsoLr8fr34
         7h3driaNjhtzlcPzVopE1jiFZdwujYlSZZciq2quv6/HJrTA9Ktp2qgu8JdwOq+3Vu7K
         rDt7lOLMQjHvkC0pvkbS0SuDW0Zv3aFcXiq324MJoEAKg/CdS79bxulgq85pOW6/B9JF
         cesfj2IGkqCcgPcpYLLeAyO9/B51zbR+j4rCTmuAMXkMaFdgT+yz7eUSbA/plILaZXdg
         tKeuyLdQAGQqTtatQ4gUQ42n4VVC8RybRU58nvu0ehd8QhOs2oV9whc+qH9zvg3j6Op5
         iIpA==
X-Gm-Message-State: AOAM531I5eKjhhVQxE0/MGPikzFf7IEh6Js1E3BmPmUp+2hJQIqnAMf9
        LC/eEWKvFXPZEqBkhtxr8yObkkcnupLg4jui7oJFVFNt0YZ0kaGz04IJ6oih4OnqjToVWiE2CBw
        FTRirAwaK9RAt
X-Received: by 2002:a17:907:961b:: with SMTP id gb27mr26118404ejc.313.1608034240447;
        Tue, 15 Dec 2020 04:10:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyovv1Qtf8rssruUi3Tau82kr/pOo5m+XRwhMAzO84zftSaBR7YCZXUCGm72GoMn3w90QiKSw==
X-Received: by 2002:a17:907:961b:: with SMTP id gb27mr26118387ejc.313.1608034240200;
        Tue, 15 Dec 2020 04:10:40 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id lr24sm1204010ejb.41.2020.12.15.04.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 04:10:38 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr handling
In-Reply-To: <7fa66c23d2758860d6b8012014faf977d03b140b.camel@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-3-dwmw2@infradead.org>
 <87czzcw020.fsf@vitty.brq.redhat.com>
 <58AC82A4-ADE4-4A8F-9522-16B8A4B9CBDD@infradead.org>
 <877dpkvz8w.fsf@vitty.brq.redhat.com>
 <432C977E-0E29-4FFC-86FF-9958601DAB40@infradead.org>
 <873608vxhf.fsf@vitty.brq.redhat.com>
 <7fa66c23d2758860d6b8012014faf977d03b140b.camel@infradead.org>
Date:   Tue, 15 Dec 2020 13:10:38 +0100
Message-ID: <87r1nruv5t.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> On Mon, 2020-12-14 at 23:22 +0100, Vitaly Kuznetsov wrote:
>> > Can you define kvm_hv_msr_enabled()?
>> > 
>> > Note kvm_hv_hypercall_enabled() is based on a value that gets written
>> > through the MSR, so it can't be that.
>> 
>> When Hyper-V emulation appeared in KVM we (unfortunately) didn't add a
>> capability to globaly enable and disable it so to be backwards
>> compatible we'll have to define kvm_emulating_hyperv() as 'true' for
>> now as that's how KVM behaves. This, however, doesn't mean we can't add
>> e.g. a module parameter to disable Hyper-V emulation. Also, we can
>> probably check guest CPUIDs and if Hyper-V's signature wasn't set we can
>> return 'false'.
>> 
>> <rant>
>> Having Hyper-V emulation in KVM 'always enabled' may not be a big deal
>> from functional point of view but may not be ideal from security
>> standpoint as bugs in arch/x86/kvm/hyperv.c become exploitable even from
>> Linux guests.
>> </rant>
>
> Indeed. And yet it can coexist with Xen support too, so it isn't even
> as simple as turning it off when Xen is enabled.
>
> Which is why I ended up just using Joao's patch unchanged. Short of
> going back in time to make Hyper-V support conditional when it was
> first introduced, I couldn't see a better answer.
>
> And regardless of the Hyper-V mess, what this patch does for Xen is
> precisely what you suggest: handle it first, before the switch(), *if*
> the Xen MSR is enabled.

Functionally I have no complaints, even with the suggested
'generalization' we'll be handling MSRs in the exact same sequence. You
are, however, right calling Hyper-V mess 'mess' and if we want to make
things cleaner we should probably start there (goes to my to-do
list...).

-- 
Vitaly

