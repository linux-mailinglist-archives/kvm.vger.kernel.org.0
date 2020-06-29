Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6DA20D38E
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 21:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgF2TAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:00:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48524 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726706AbgF2TAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rE8sePDsqa4643aK/Xq/VoL9+mfjUnQLSGGnMx89Flk=;
        b=R81lqaWljkA0usd3dQqIBex0UslT8mqg2kJXCFRt4RDMHKWTZjOvUBO8I2ghGiwF6BsF59
        rMiqzS4DLdfi5tuUMAMXzTtacPwBjUXm/FVJgSFEnn7wUiE/rgZWomCEuLTdRC0TP6ToGu
        mOx08MXaM0k4dWM55cX7uEexsWYm8g4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-7qKL-5p7NueR1jMbv7to2w-1; Mon, 29 Jun 2020 09:59:28 -0400
X-MC-Unique: 7qKL-5p7NueR1jMbv7to2w-1
Received: by mail-wm1-f69.google.com with SMTP id g138so9610626wme.7
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 06:59:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rE8sePDsqa4643aK/Xq/VoL9+mfjUnQLSGGnMx89Flk=;
        b=Fb3LgO/gyzh211v7WjY7rtKS8nKalVvUp9+ZdkuW30Kee45n+bc4dl2w6nU8dVI0p1
         0JXUgb6zuy8xJdAAWGx9h8oOOuRNO1OcCQFNenwzDGj3sLLbRkq5aC0cnn35kJJfM0S4
         vx8GSOPvBNSoBMog8Qx6UGTheWK8dqcn5IeqsorheqXqEz1wG0tiWla4lG2OrMPJVPFe
         NAx+IvFkXyTJDRH4RicBQKWj6qZNhwsJUmnuAszRQZMDBtoQIs1+a6EG7V9th7OWJe0A
         4RCEt1vWhuAK9FCxmm1oh9vMe+6LgOLJ+treGfaQH3GgeA9sYNqeR9Ye7OTeUnU26Jdf
         qqQA==
X-Gm-Message-State: AOAM533zz3MG96z5eEXXk1poAeYKSrTqrV8br02xJ5O6swo3GDgo3xPE
        DRvqZtCDCeN2nLC8B4NYL9jA57VQ1cgmmAjisIMq3xKuxbCIzxvJdcjDdaeeb6Vpw2TyhtDto5f
        YgFgQ6XmRg3Ot
X-Received: by 2002:a1c:ce:: with SMTP id 197mr16802249wma.177.1593439167025;
        Mon, 29 Jun 2020 06:59:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsxz9zZlXFnZ7BIFPMcVeMeUzlm7a/lsLSfHAU3MGsXPZfgWzKa7c4KMMzMv09dmjzWh/Gkg==
X-Received: by 2002:a1c:ce:: with SMTP id 197mr16802236wma.177.1593439166855;
        Mon, 29 Jun 2020 06:59:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b0e5:c632:a580:8b9a? ([2001:b07:6468:f312:b0e5:c632:a580:8b9a])
        by smtp.gmail.com with ESMTPSA id o1sm52465447wrw.20.2020.06.29.06.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 06:59:26 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Fix async pf caused null-ptr-deref
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
 <877dvqc7cs.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9b06428-51c3-09af-48cc-d378182916fd@redhat.com>
Date:   Mon, 29 Jun 2020 15:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <877dvqc7cs.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/20 15:46, Vitaly Kuznetsov wrote:
>> +	if (!lapic_in_kernel(vcpu))
>> +		return 1;
>> +
> I'm not sure how much we care about !lapic_in_kernel() case but this
> change should be accompanied with userspace changes to not expose
> KVM_FEATURE_ASYNC_PF_INT or how would the guest know that writing a
> legitimate value will result in #GP?

Almost any pv feature is broken with QEMU if kernel_irqchip=off.  I
wouldn't bother and I am seriously thinking of dropping all support for
that, including:

- just injecting #UD for MOV from/to CR8 unless lapic_in_kernel()

- make KVM_INTERRUPT fail unless irqchip_in_kernel(), so that
KVM_INTERRUPT is only used to inject EXTINT with kernel_irqchip=split

Paolo

> Alternatively, we may just return '0' here: guest will be able to check
> what's in the MSR to see if the feature was enabled. Normally, guests
> shouldn't care about this but maybe there are cases when they do?
> 

