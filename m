Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7681F5345
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgFJLeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:34:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48186 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728412AbgFJLeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 07:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztFqhUudHoU3NNYqFL5POta8Qmquf650y/nl/9Uo0mc=;
        b=L31SJ0WmX/2p6ulGSebAb22Ofufm5BGModPLE4jXIbqaMxEEjKP0HNXckWpM1isege8QTe
        gqdMldM6Lp0AMLQKAYluWGSNltWpU+YfFFWeIsieNrj55YWYY3ZMfZ9Ph2nadWpQPxuJZ5
        c3nqnujtgdgqa+USYAGdy7RLQIkfLBM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-y6HChBgoMn-n8O0z_b7wBQ-1; Wed, 10 Jun 2020 07:34:05 -0400
X-MC-Unique: y6HChBgoMn-n8O0z_b7wBQ-1
Received: by mail-ed1-f70.google.com with SMTP id f13so546046edv.11
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 04:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ztFqhUudHoU3NNYqFL5POta8Qmquf650y/nl/9Uo0mc=;
        b=lpfFLCuF65h5MrouAWO1M+fFB9Brq4rhWtOi5Sp5Y07xKmc/U2X4uJBgc0V+AhKf+9
         jNKPg9rGBlvJDHT/xgohgqDpEhgg8/8ebOul5wWqckRTA5mXZ6EWGH3WIFb6XSlsjHxu
         a2IJbP6natGtWKvUBvqsaSbOaCzmzLb3+6snfybzmTcD29ZRafKDZUBc38uHukcOgL44
         i6C/NO3HuPx1D6wsNkpdh9hyjqPz3Achb1jw0gu5Z36GlmZme0CZjOoH7jt0J635VhcS
         Xka6emwF0Fz0QFpZzaXGvMFsZIjmSwQky2ozWU2NH5Akm3cGeqh7vfulgDxv2V6K38N7
         eKuA==
X-Gm-Message-State: AOAM5303yauJusyw43LPwNoN425ZBLeMM3R2DeM+zRD/gHXEGSga30ab
        t9LJygAgZISJYwFWeywV2h+Phipuakc8ubVj3w8fCmzIl6EkKw7lUlkKIHPpVSBzwSwBaFJj4hW
        z1NsBzrHtNaIp
X-Received: by 2002:a17:907:441c:: with SMTP id om20mr2772954ejb.62.1591788844386;
        Wed, 10 Jun 2020 04:34:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYfnxO7q4EnVccZRzA4Vkj9BRco2fOIoVOAQFKJPWEKvKv7I1oFGHoz1Ks7Pdc073loFhqzQ==
X-Received: by 2002:a17:907:441c:: with SMTP id om20mr2772924ejb.62.1591788844144;
        Wed, 10 Jun 2020 04:34:04 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.134.4])
        by smtp.gmail.com with ESMTPSA id e4sm16864342edy.17.2020.06.10.04.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 04:34:03 -0700 (PDT)
Subject: Re: [PATCH v2 05/10] KVM: x86: interrupt based APF 'page ready' event
 delivery
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-6-vkuznets@redhat.com>
 <20200609191035.GA223235@redhat.com>
 <dcdda87c-cf2f-da6f-3166-e2d0bfefce06@redhat.com>
 <873673b8gc.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce34f17a-d444-fdf4-1a1c-e052234c1516@redhat.com>
Date:   Wed, 10 Jun 2020 13:34:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <873673b8gc.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/20 11:01, Vitaly Kuznetsov wrote:
> The issue isn't related to the interrupt based APF mechanism, right?
> 'Page ready' events are always injected (sooner or later). I'll take a
> look.

No, it isn't.

>>> While setting up async pf, should we keep track whether associated
>>> page_not_present was delivered to guest or not and deliver page_ready
>>> accordingly.
>>
>> Yes, I think so.
> 
> Something like this? (not even compile tested yet):

Pretty much, though I would avoid the reindentation if possible.

Paolo

