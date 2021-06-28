Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E84C3B5CDE
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhF1LDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 07:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232617AbhF1LDC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 07:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624878037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e6/55UgAVTl1MciCP8eOgIX5G5ud34sV09g0xg5DQZw=;
        b=Sl/cpMKTsphzBE+eh1ezj/zGmuDnOyX0CptD923D0EtI1f6+awN3rpAzYNVZII7C4xQJwX
        uSiGeMON5uAVue1ZTaS65G6A3jGBXUcysh1Y2dyLoP/LY8AdbkHwWBC5f8H8eS5XfCsTrT
        eq12BufZYHMJubVDvCtf1on8vw23Y2U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-jeg5B4WXPLesPecK4X1WqQ-1; Mon, 28 Jun 2021 07:00:35 -0400
X-MC-Unique: jeg5B4WXPLesPecK4X1WqQ-1
Received: by mail-ej1-f70.google.com with SMTP id ho42-20020a1709070eaab02904a77ea3380eso4189408ejc.4
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 04:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e6/55UgAVTl1MciCP8eOgIX5G5ud34sV09g0xg5DQZw=;
        b=Xmjl+CYBFXJsz8wI+QYUrih/u0a0q1war2j7Ymn6nyH5OQ3fO6fIp3CJ6ALE9aHBoi
         Ppca6TGtnHSjhYyBdb/ZMN2JRSj1+aqB0UmaeljDIB36rLcOG5QdF39YesvrwmzR1yg7
         S2ubGX+lcOnzyphOM5B45kNu3ZWAfQVJvtY6GlX6agiTxP8R/ApGhMPVqPtckpsFeMD+
         3WUscofzazGWsGsbeBdQp00WpAPqIA/l1tn1x9c8yWJXAaJMgT+gBKphASykAQoIscst
         jV80cTwlapeaQI+ck2/4uaO6ttXrYFhW6WkAq9K5x+G5Azf7AeQ4IwItTNJ6BqbHS3dw
         Dn8A==
X-Gm-Message-State: AOAM530jnmnSY5rWepZJsffUm5qzARWmcaXWp4ZaJx3Z7E8m1afudVHs
        ux3/JCHMuxA6/VNxFHeD7FNxKgSUZ4nSIvcB4wLULjIX1A4Jk69faPP9OmCveZp4h6ZkVacbRYx
        Etmw/KGayg5cSXDeRCZ/dXelJ+5trvBZmYNQHKVqW9GSxVgu9l2H2z1wckaq4P7yK
X-Received: by 2002:a17:906:38c6:: with SMTP id r6mr11275117ejd.411.1624878034525;
        Mon, 28 Jun 2021 04:00:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIs5s6/cQga2cxuMpGxSjDc1C9V28BYNpJ7NzHVkUpg1t8VtbJ/TknkgxaJt7sYcDEnKAzag==
X-Received: by 2002:a17:906:38c6:: with SMTP id r6mr11275085ejd.411.1624878034342;
        Mon, 28 Jun 2021 04:00:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p24sm4567784ejn.83.2021.06.28.04.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 04:00:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
In-Reply-To: <87lf6u2r6v.fsf@vitty.brq.redhat.com>
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <87zgva3162.fsf@vitty.brq.redhat.com>
 <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
 <87o8bq2tfm.fsf@vitty.brq.redhat.com>
 <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru>
 <87lf6u2r6v.fsf@vitty.brq.redhat.com>
Date:   Mon, 28 Jun 2021 13:00:32 +0200
Message-ID: <87im1y2qzz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> stsp <stsp2@yandex.ru> writes:
>
...

> I wrote a
>> test-case for it, but it involves the entire
>> buildroot setup and you need to wait
>> a bit while it is trying to trigger the race.
>
> Maybe there's an easier way to trigger imminent exit to userspace which
> doesn't involve 

[my test editor swallowed the ending of the phrase, sorry about that]

Maybe there's an easier way to trigger imminent exit to userspace which
doesn't involve signals.

-- 
Vitaly

