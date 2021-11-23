Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41FA45A41E
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 14:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhKWNz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 08:55:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235702AbhKWNzz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 08:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637675567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hg3rpdgYxxcOBJc5G9ynr2yksQKyjRICI2KgG4YRajw=;
        b=evr0QXRKqYUWh7KPzNQrkvBllgBAf7R8zFdvgoBKag709zrEiI5JAcyihkkWArqnpWUbOO
        Pp79vLc8V4beJagq1acSp5GDtpBCKhrg4/eHufeWInOTMSrCYvNflyvGYgdWLTbb83vsRC
        72V5L5359zP0UF1CvI93Dmnq2snft0s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-485-8E-DjwUIOKKJRdNYlFP7XA-1; Tue, 23 Nov 2021 08:52:44 -0500
X-MC-Unique: 8E-DjwUIOKKJRdNYlFP7XA-1
Received: by mail-wm1-f69.google.com with SMTP id 201-20020a1c04d2000000b003335bf8075fso8508214wme.0
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 05:52:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hg3rpdgYxxcOBJc5G9ynr2yksQKyjRICI2KgG4YRajw=;
        b=Fx70w8HPyYE30cANlgY5ebJlaP+gWswvLT1r0UHpbC+38pn9HJ0yg+QpgeZBZnMqoi
         cHDwXgGLRmIU32o+09MSYk7WRX7cqLP4WtY5qaIGH/uoPB5HZ0gEnlx4JENVW95s6rWu
         gI6S6+/me12VIRH9sydCI/i7P6eHl17OB+LiEuRex3J+AbPjIWDXUA5W/1YS+MOKVJWV
         ie/khoZ4hn0zK7vdDsNU7ZFLsdguGXHZWA6LSeJ7hCsy7fcmhJ8xxNPP5uYNxtmihb35
         eoC/lxvJimTeTXVDMmoQyzQ5NrDTDU8vDHDcd2azJ00PaMpALKNETi/rrKNiOfc60+eR
         NpfA==
X-Gm-Message-State: AOAM532qOg/ehDAKqSi3KkNQA2pKPujNVHhZdg2P6fYz57cNSGB1pLUm
        qGF+PrHZz+/imVQIRD4O4SARYUIpqkmz4Q7A63zgZDkMs0w0YxvI557Q2AWkiplXDBuQ+qb9YWq
        KdmTGW/Ii0YQM
X-Received: by 2002:a1c:7e04:: with SMTP id z4mr3279216wmc.134.1637675562910;
        Tue, 23 Nov 2021 05:52:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7iTjEl+nEyfMdplA1sJxP2OTCbcZNTVWZJYf4xKxVJgZBJzKPzNLaMH3ChCLer/E4VRC5uQ==
X-Received: by 2002:a1c:7e04:: with SMTP id z4mr3279190wmc.134.1637675562732;
        Tue, 23 Nov 2021 05:52:42 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o1sm12066278wrn.63.2021.11.23.05.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 05:52:42 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Make sure kvm_create_max_vcpus test
 won't hit RLIMIT_NOFILE
In-Reply-To: <87czmsm5iv.fsf@redhat.com>
References: <20211122171920.603760-1-vkuznets@redhat.com>
 <YZvVeW6qYNb/kkSc@google.com> <87czmsm5iv.fsf@redhat.com>
Date:   Tue, 23 Nov 2021 14:52:41 +0100
Message-ID: <877dczm11y.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

>>>  
>>> +	/*
>>> +	 * Creating KVM_CAP_MAX_VCPUS vCPUs require KVM_CAP_MAX_VCPUS open
>>> +	 * file decriptors.
>>> +	 */
>>> +	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl),
>>> +		    "getrlimit() failed (errno: %d)", errno);
>>
>> And strerror() output too?
>>
>
> Sure, will add in v2.
>

Actually, there are two issues with the code above. First, TEST_ASSERT()
already prints both errno and strerror() (setrlimit() counterpart which
is easier to make fail):

KVM_CAP_MAX_VCPU_ID: 4096
KVM_CAP_MAX_VCPUS: 1024
==== Test Assertion Failure ====
  kvm_create_max_vcpus.c:68: !setrlimit(RLIMIT_NOFILE, &rl)
  pid=344504 tid=344504 errno=1 - Operation not permitted
     1	0x0000000000402485: main at kvm_create_max_vcpus.c:68
     2	0x00007fcb2e8b4041: ?? ??:0
     3	0x000000000040254d: _start at ??:?
  setrlimit() failed, errno: 0

Second, note "errno: 0" above. There's no guarantee that getrlimit()
will be executed before evaluating 'errno' in C. I think I'll just drop
redundant errno printout then.

-- 
Vitaly

