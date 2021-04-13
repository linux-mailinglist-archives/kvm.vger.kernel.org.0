Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B535DE6F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhDMMPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:15:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236758AbhDMMPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqf0RiZSoAYfI4s0e2+ZgKSiJco7N8Kba8wSDbcvYCc=;
        b=TMWLLvIIl04hagtpe6OblGypZQSvWNHooOkG3g/GA6Af1MWHl1a5j+0kzosu/DQFbwuJ1p
        GYrh8FYbdjdZpXsN+l+NKpN1gq3keBaiyM/UfHXcYmADLJZDkC1h5iqPxQ2KtqgrIlS2Yi
        9kCUuK73WUyKFOLqz2WLinu9g5OGGGE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Y3xg7aWOPnGI98klKizf2Q-1; Tue, 13 Apr 2021 08:15:15 -0400
X-MC-Unique: Y3xg7aWOPnGI98klKizf2Q-1
Received: by mail-ed1-f69.google.com with SMTP id r4-20020a0564022344b0290382ce72b7f9so1154823eda.19
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 05:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqf0RiZSoAYfI4s0e2+ZgKSiJco7N8Kba8wSDbcvYCc=;
        b=rztOwhZii6ZcVlIRijZrrnIwNvnOiIYWohzZ+msmZVjN1MB7I3tdHakvc0Y9mNTfUi
         Xx9gslAxpDr840Pg8o60NR12ZFHCRymwjFx2Bbvo7taDwy7yw0k7+NDsEMrsfo0pD2ge
         6s+Uj9IW0wwn3fbtWYWHeeE/224QG2WEDg2yS8/JWuGJpGvMzeDP1cyQrzJKE5aVgCYm
         8xiK+IFKp7+g44QFBfHIYptf5+5azkJTPqy4w62LX650XA9dRLliC96Ej9QL3eOEtYzJ
         dmeJeyp0yueYn4s1W+L0lSZxLBVxxPfNitlbZx5PEArnBJTFFf2RtEqkQlt1kArwJmG3
         CqBQ==
X-Gm-Message-State: AOAM531R83JpxGHhDFAbKlqcN8HydAybftdzBzDXrDSHmb2idMyldVI0
        m8Lsss4ksgi+7GTGu9VZ6ebjUBVCP/IXabG5bPQ+7248ORpB4V9j3drXYvL8VKgx83ChfvFftcE
        QuQlqU2Sr+ift
X-Received: by 2002:a17:906:3549:: with SMTP id s9mr9309563eja.327.1618316114728;
        Tue, 13 Apr 2021 05:15:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye3ZXpM2j4/xA1ZsYOu2bEOUbV5nlWPoAJCBVywHcjFdlmDPmkeyBoZhrkjlFGbk70xZ8uSA==
X-Received: by 2002:a17:906:3549:: with SMTP id s9mr9309548eja.327.1618316114534;
        Tue, 13 Apr 2021 05:15:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j6sm9057849edw.73.2021.04.13.05.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 05:15:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20201127112114.3219360-1-pbonzini@redhat.com>
 <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
 <YHS/BxMiO6I1VOEY@google.com>
 <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80b013dc-0078-76f4-1299-3cff261ef7d8@redhat.com>
Date:   Tue, 13 Apr 2021 14:15:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/21 13:03, Lai Jiangshan wrote:
> This patch claims that it has a place to
> stash the IRQ when EFLAGS.IF=0, but inject_pending_event() seams to ignore
> EFLAGS.IF and queues the IRQ to the guest directly in the first branch
> of using "kvm_x86_ops.set_irq(vcpu)".

This is only true for pure-userspace irqchip.  For split-irqchip, in 
which case the "place to stash" the interrupt is 
vcpu->arch.pending_external_vector.

For pure-userspace irqchip, KVM_INTERRUPT only cares about being able to 
stash the interrupt in vcpu->arch.interrupt.injected.  It is indeed 
wrong for userspace to call KVM_INTERRUPT if the vCPU is not ready for 
interrupt injection, but KVM_INTERRUPT does not return an error.

Ignoring the fact that this would be incorrect use of the API, are you 
saying that the incorrect injection was not possible before this patch?

Paolo

