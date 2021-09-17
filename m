Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5334D40FDB1
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240920AbhIQQRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 12:17:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhIQQRN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 12:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631895350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wAFQPGPyFN6MzK3bzK8jBC17iHiKc9AgbxXN8TxrV2g=;
        b=Y+kLmyqvevPO0M1lv4CBuDscbgZU1euGtIdTb5vLax83dj2R8Q/0ehw1u1pVQqp7rePoon
        f+f7oTgXjbUMnSysreJPbisTEutw/O49Way1m8mOtp9dVoF4VJ0/eK11EmRnYiWfrBmHhy
        iTr0j9ClQiw4d9UbZB0/X1nrW9kPQTQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-rAigjA9TNKu2rj7Ai9DWcQ-1; Fri, 17 Sep 2021 12:15:47 -0400
X-MC-Unique: rAigjA9TNKu2rj7Ai9DWcQ-1
Received: by mail-pj1-f71.google.com with SMTP id v10-20020a17090ac90a00b0019936bc24c7so7647076pjt.7
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 09:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wAFQPGPyFN6MzK3bzK8jBC17iHiKc9AgbxXN8TxrV2g=;
        b=UuTL+SGJTrsLKBVWFt3xqflZqTr0BoKYx8/Jw5JMtEQlaTQqWQ5giT2GGJoVaFKsUb
         tJLrkRAFM/s10FJ5j8yFO5lGnjdbvKnnVG+gxHnEIgbFx9w/kKjimnOZurxTRwiICOQv
         6xeJnV5+gvrL2gu8mpPuL71s+vROAwYezk8wUjCvmerIGvwZvqSdMtrf1wsTPYFcIhoe
         ibIpIlnZgRX93ZTpFwZMd/6WaLOz6+/veTSHXZJGBoi0aPH9aP/CFr35TM3iDdO9Oqm9
         nb6xAdjgzAI6HVU6dq9485zML+A+M+7/sW8fi/w0aTaLEbJifdZBW3R7riwy7zuuA/tc
         DF2w==
X-Gm-Message-State: AOAM532vasBZaYyLSKFDchItZvAQac7nLitax5/4NPNXWOSr4GVd+6Pj
        AC1nJyh7Bb4E+gkTiYSqdnCi/N9FycH0PAumlSnKJA6ejVcuSc9zmLKD2Cad3VMyIrPa+iwiKxU
        YaOyTWj5CHdk7qE4UmnNtPaqZgeIi
X-Received: by 2002:a17:902:d717:b0:133:a5f6:6be6 with SMTP id w23-20020a170902d71700b00133a5f66be6mr10309167ply.14.1631895346053;
        Fri, 17 Sep 2021 09:15:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOhNz2zbDcVfa/AWoVfQ6vVBkU8H3tVtK9RFm4Mi0iUZKgxzNDBV2Mk++eD7V1IurjLU3QnjPe+x14oLufnf4=
X-Received: by 2002:a17:902:d717:b0:133:a5f6:6be6 with SMTP id
 w23-20020a170902d71700b00133a5f66be6mr10309138ply.14.1631895345720; Fri, 17
 Sep 2021 09:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210914230840.3030620-1-seanjc@google.com>
In-Reply-To: <20210914230840.3030620-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 17 Sep 2021 18:15:34 +0200
Message-ID: <CABgObfYz1b3YO4a9tR02TourLmsnS48RWrOprrsEh=NpbQfjRA@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: x86: Clean up RESET "emulation"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 1:08 AM Sean Christopherson <seanjc@google.com> wrote:
> Add dedicated helpers to emulate RESET instead of having the relevant code
> scattered through vcpu_create() and vcpu_reset().  Paolo, I think this is
> what you meant by "have init_vmcb/svm_vcpu_reset look more like the VMX
> code"[*].
>
> [*] https://lore.kernel.org/all/c3563870-62c3-897d-3148-e48bb755310c@redhat.com/

That assumes that I remember what I meant :) but I do like it so yes,
that was it. Especially the fact that init_vmcb now has a single
caller. I would further consider moving save area initialization to
*_vcpu_reset, and keeping the control fields in init_vmcb/vmcs. That
would make it easier to relate the two functions to separate parts of
the manuals.

I should go back to KVM next week. Context switching with KVM Forum
and Kangrejos this week made everything so much slower than I'd liked.

Paolo

