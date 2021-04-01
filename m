Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1748D351176
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhDAJIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 05:08:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhDAJIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 05:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617268097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SH8q6v7mosb9ZWkhGf8eANcJIvuHX/dVnNgdkFE16jE=;
        b=JyuCQVPFwIp/3uxqt6W7vC6AlxMS+8uw2UNA7rWHqxguau+l+0eazFFlNzbYH4llmylV4k
        px3LV4973LiLlktBRLaZmI4uSansLUVeRB6Zt1DH2lxIVDRchJIqMpqjNk+pkoMd+fny94
        cKGqt2iTSR/KCXwKZVIyxv3+JwWPeTE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-YjwvknXoOcWuym9LEcrhtQ-1; Thu, 01 Apr 2021 05:08:16 -0400
X-MC-Unique: YjwvknXoOcWuym9LEcrhtQ-1
Received: by mail-ej1-f72.google.com with SMTP id e13so1934433ejd.21
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 02:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SH8q6v7mosb9ZWkhGf8eANcJIvuHX/dVnNgdkFE16jE=;
        b=YCMrmmO8u8tGP6Ll6wCyykHB5y7qnkqc/J77z+PEC2ywQE7jYpRVCKRQvBRKIBp34S
         0bgAHrEUJ5Pj9oYOaH1X193LaSGlKeXaDJXp519HqTfYjGzUZGA190sMCQjPWaw/4LTK
         Ly5ULhweWj28XFmW4NAWkT2TvQDKsWNY+WBvQR1SBfDY1x0qWNg8Op6tRaVYZb/MlJEf
         4/xTJLf69rbVjIWEEcHtv8SVG6R+OpWdaAbLUhaBFOIWgMJZo0ZS/G56oaV4NMlwyJ/I
         b1m7Maaz7nJgRw3r6ZAMK2CYeNdk1Diiy5+6V5OZzskNcAAIOBTP8wZ4UjsOuJUwJg0I
         MzQA==
X-Gm-Message-State: AOAM531stjjl9iAfsGC9GjCKOgldRYw5ZXryqGmdKiCzNMgE6ZnzVzVS
        XymKij2XVNYpUBnXtKgFD9cND7vpmOL8JC2lrn6G1ei/mz4i1v1q0uxiCUxqsSBerHhGzDnMO2f
        rYdK2zDvFciX/
X-Received: by 2002:aa7:d296:: with SMTP id w22mr9132646edq.150.1617268094915;
        Thu, 01 Apr 2021 02:08:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkaDtD/zV8/+g4vA8exSjAqnDTdsDQz0T3HuSz8w49b9Wf/JUk9n3MB5ubq9QTsnrpDORKRg==
X-Received: by 2002:aa7:d296:: with SMTP id w22mr9132630edq.150.1617268094789;
        Thu, 01 Apr 2021 02:08:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x4sm2967618edd.58.2021.04.01.02.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 02:08:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     pbonzini@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix potential memory access error
In-Reply-To: <YGS6XS87HYJdVPFQ@google.com>
References: <1617182122-112315-1-git-send-email-yang.lee@linux.alibaba.com>
 <YGS6XS87HYJdVPFQ@google.com>
Date:   Thu, 01 Apr 2021 11:08:13 +0200
Message-ID: <87mtuis77m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Mar 31, 2021, Yang Li wrote:
>> Using __set_bit() to set a bit in an integer is not a good idea, since
>> the function expects an unsigned long as argument, which can be 64bit wide.
>> Coverity reports this problem as
>> 
>> High:Out-of-bounds access(INCOMPATIBLE_CAST)
>> CWE119: Out-of-bounds access to a scalar
>> Pointer "&vcpu->arch.regs_avail" points to an object whose effective
>> type is "unsigned int" (32 bits, unsigned) but is dereferenced as a
>> wider "unsigned long" (64 bits, unsigned). This may lead to memory
>> corruption.
>> 
>> /home/heyuan.shy/git-repo/linux/arch/x86/kvm/kvm_cache_regs.h:
>> kvm_register_is_available
>> 
>> Just use BIT instead.
>
> Meh, we're hosed either way.  Using BIT() will either result in undefined
> behavior due to SHL shifting beyond the size of a u64, or setting random bits
> if the truncated shift ends up being less than 63.
>

A stupid question: why can't we just make 'regs_avail'/'regs_dirty'
'unsigned long' and drop a bunch of '(unsigned long *)' casts? 

-- 
Vitaly

