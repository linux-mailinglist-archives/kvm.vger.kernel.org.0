Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40BDD73F3
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 12:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfJOKxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 06:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfJOKxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 06:53:24 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 950CD82DA
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 10:53:23 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id f3so9912704wrr.23
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 03:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p/1yabDz8qKhRFkalHkrj4947RSYeZJkszdmHrfnxwc=;
        b=eqMPbWcFOlWMA4iWqK/zS4gNlX6NKPiWQJ5R5gbhJN6pv1r4GFdR2v3NFjCH5rRtjQ
         4nkoiLIMLbibCgrJ3qHZ/ggzCiz2IXILVyfRKTXL+I37oJfcZZN0NXhS7A430OfVl7Ar
         AfAgdT/c8PZSznWvqFtE4hzyWLbmPXrqzyaQaGFt9BcEl2L0D88aJwC2ADZk6VMBUv/b
         MnE8PD7OnE7bDfFSid520aJTRm/FNaqfzw0WmwYgtiGYmNnTYUX4Iz/B6l2lG4qRKzhC
         Ug7RnLmIYEjJmydvs8K9MkRmiQaBJRpucrXa2fy4JrqjO/+iK6FwVLwR4LdkkrFtu9hf
         8aDw==
X-Gm-Message-State: APjAAAXMdSdtxeN6zAOcWmY1wbLu0RtOxPdPo7ZwVOfEdpWeRYaUooJK
        xTuPCCAmhZxQWef+UI4W4NE6m/hXJLC2MNXP1iEnXyKYlCrEMlXXzeIUf5lZsmbzoIE3IyPHct1
        RHJB48dDPmOXR
X-Received: by 2002:adf:eb0f:: with SMTP id s15mr28329220wrn.97.1571136802294;
        Tue, 15 Oct 2019 03:53:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwu0QYUpkH9lGGmecEb8XIlX9PlulVL8sYPAzG3x9q/fyyIX2pqIq4BlP6J6f9jD1VdvCLLWQ==
X-Received: by 2002:adf:eb0f:: with SMTP id s15mr28329205wrn.97.1571136802066;
        Tue, 15 Oct 2019 03:53:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g17sm16952765wrq.58.2019.10.15.03.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 03:53:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
In-Reply-To: <20191014183723.GE22962@linux.intel.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com> <87y2xn462e.fsf@vitty.brq.redhat.com> <20191014183723.GE22962@linux.intel.com>
Date:   Tue, 15 Oct 2019 12:53:20 +0200
Message-ID: <87v9sq46vz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Oct 14, 2019 at 06:58:49PM +0200, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> 
>> > They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
>> > and SVM. Make them common functions.
>> >
>> > No functional change intended.
>> 
>> Would it rather make sense to move this code to
>> kvm_arch_vcpu_create()/kvm_arch_vcpu_destroy() instead?
>
> Does it make sense?  Yes.  Would it actually work?  No.  Well, not without
> other shenanigans.
>
> FPU allocation can't be placed after the call to .create_vcpu() becuase
> it's consumed in kvm_arch_vcpu_init().   FPU allocation can't come before
> .create_vcpu() because the vCPU struct itself hasn't been allocated.

A very theoretical question: why do we have 'struct vcpu' embedded in
vcpu_vmx/vcpu_svm and not the other way around (e.g. in a union)? That
would've allowed us to allocate memory in common code and then fill in
vendor-specific details in .create_vcpu().

-- 
Vitaly
