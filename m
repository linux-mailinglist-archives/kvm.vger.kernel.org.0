Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AA93BDFD1
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 01:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGFXn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 19:43:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhGFXn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 19:43:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625614878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rHF/8qiocy61ktpvRNLwGWg1uBU/1PeZj1OwtHAN95A=;
        b=UR/Qjzgvhw9Yq3r/AXw7SLvnRv0i3xxgzUd1YZoI9P7qIY6znPv6w16jrHDDpytCYaUVEX
        Lh0cGYUAdIaDWV7UizL6g6K7/SGIGI3AFgzhMJljI7gzjHDTEdy/XFVJqFqeQf0biU9/W2
        +Ks8OkkIzwFaH1ZfP9LoafwDs3ru0YY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-t2zKz37rNKOMSpAa5jkjPw-1; Tue, 06 Jul 2021 19:41:17 -0400
X-MC-Unique: t2zKz37rNKOMSpAa5jkjPw-1
Received: by mail-ed1-f72.google.com with SMTP id n13-20020a05640206cdb029039589a2a771so369823edy.5
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 16:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rHF/8qiocy61ktpvRNLwGWg1uBU/1PeZj1OwtHAN95A=;
        b=GqsBr+XrpUnQVZ2QxY3k4RhA7ZUi0jH79NvFcIQ67GrfavopCktTrJb4qHQfF90EJd
         xsfD7ngSlkl7cJQDR6XZJJ+eiMD9FHPnYB9duOZr4J3i//gQzvEPsVvUWwg4Y8wI96N+
         jzKNYszv2fEtwFRq+n/+QIUsX4sKQejwFYnIu8JKYF5Hsux7vAKuS1cl862ptB1RGnJO
         J1Rsp4STDhJtINRFnMpS5wyH1M21maNS5p8bcXYjx1sQN2pqR+T4o21MiM/oPUHWC187
         U0cJPB55Cuez1uFDs/Y/bs5T/hzO3rhY09ryK7ROUo6QD9HXvHX/kxdzPWa/7Rkl0jvy
         ac3A==
X-Gm-Message-State: AOAM530tPrnRJBlAyoWy/scVrhITsQGJBR+HS0sCn0AxwaRtqwWY+VsJ
        k57jvS0KQ1roPC5deNgeW29jhwjK/HNUg9MKPpaU8m9ms1fh0TiYlJ635j8USLnPG06Fcuq313I
        Q15WPHic1CXTG
X-Received: by 2002:a05:6402:1042:: with SMTP id e2mr18970595edu.144.1625614875934;
        Tue, 06 Jul 2021 16:41:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymzPOVB5X3mg+T37fQY4b7gZh3he2S5tKbpe21pQmPJm3f8kPQcwb7k622gWNAWxv1CaP5iA==
X-Received: by 2002:a05:6402:1042:: with SMTP id e2mr18970579edu.144.1625614875729;
        Tue, 06 Jul 2021 16:41:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id v7sm8380791edd.4.2021.07.06.16.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 16:41:14 -0700 (PDT)
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
To:     stsp <stsp2@yandex.ru>, Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        "ntsironis@arrikto.com" <ntsironis@arrikto.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
 <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
 <b15c78e6-4ae3-5825-50c2-396c4e600d02@yandex.ru>
 <CALMp9eT9XSuk2=WuunKsLpUw8zbE1xtzRzHesN3MOJPYuh0KkQ@mail.gmail.com>
 <1501d6d3-4dab-3eca-1d82-1e1954e293e1@redhat.com>
 <eadbc511-3270-8a8e-a2d8-a8eb1fccb8c0@yandex.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <54270fb7-91ac-f10d-5879-956f42372536@redhat.com>
Date:   Wed, 7 Jul 2021 01:41:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <eadbc511-3270-8a8e-a2d8-a8eb1fccb8c0@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/21 00:22, stsp wrote:
> I confirm that this works, thanks.
> Sadly the problematic patch was
> CCed to -stable, and is now present
> in all kernels, like ubuntu's 5.8.0-55-generic.
> Since AFAICT it didn't contain the
> important/security fix, I think it
> shouldn't have been CCed to -stable.
> 
> Can we revert it from -stable?
> That will mean a relatively quick
> fix for most of current users.

It was a bugfix, see the commit message:

     when userspace requests an IRQ window vmexit, an interrupt in the
     local APIC can cause kvm_cpu_has_interrupt() to be true and thus
     kvm_vcpu_ready_for_interrupt_injection() to return false.  When this
     happens, vcpu_run does not exit to userspace but the interrupt window
     vmexits keep occurring.  The VM loops without any hope of making progress.

Thanks for the testing!

Paolo

