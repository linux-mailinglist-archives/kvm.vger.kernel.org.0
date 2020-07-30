Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481AF233B90
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 00:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgG3Wte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 18:49:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730457AbgG3Wtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 18:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596149371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AKyJrYWDX6x969FmRZ0QcDqOUbfYEkv8rsi7p3uCKKw=;
        b=golHnpBb5enmRk6dRkQrtO2dJnKuVZ4OVctIOduVPtKs0J9LeZCrPaHSqIczP2H5hOYTP7
        9NAUszQGOUJ9MD7FLiJgMAQZjMGKqjfhpVEURa6yZSM0TRzAiVL/4oIHKfCEofcLkRan8M
        bTt7w6cTgnlNc12YUAt+OluucjwxHr0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-RQtsE4BGMTaPpKaqmUlvyg-1; Thu, 30 Jul 2020 18:49:27 -0400
X-MC-Unique: RQtsE4BGMTaPpKaqmUlvyg-1
Received: by mail-wr1-f69.google.com with SMTP id f14so8355623wrm.22
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 15:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AKyJrYWDX6x969FmRZ0QcDqOUbfYEkv8rsi7p3uCKKw=;
        b=AVyJH4daOMnxZzOeERSDAuk0/wXGybazsCWUZ0JmNY6mchjwMPEv/4d6ZZflgIfXJ3
         XzUYdqq/SCosZawjFrW0n/9gMHwX8ThmkEFwsR6Nd5jn4WHBVSBo/SGx0R1YmaySDXP1
         swAKrHECnToHAR5fSKGITcWAXKYUattMrfQEQvoUo5OhTAzkFf/VlRh0bPzGY11f3pfk
         n9zGmLrqE5rGQqdnIwgxskhour3fuWenRyJDTlO1q8Vg7efT9+VWRsLt67bVFCNb/R0I
         Z7hottBIvN1AHTFZUymqrLe7Aqysz17VM+sWlH+l5KyQi0Zx4kbKvgcxfRnsabfSIJYI
         kY8Q==
X-Gm-Message-State: AOAM530NJQJAS+2jMf43PV5IUzXRhDihYZbt3aAKc2AY34wyN7fmxkqN
        lymmJODm2wysdbUZK/hj0JTGLf4f98xhJ8GfSFv/T8xxIDTvCESAriwW9Pyn4bpnLGKQIZxG0ik
        Qt2qgVKMr1Ega
X-Received: by 2002:a05:600c:2888:: with SMTP id g8mr1244792wmd.118.1596149366790;
        Thu, 30 Jul 2020 15:49:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiSvm3UnA27GuaplhnTlAkbTEsPEhFvd2AYU6wvlMVGQFr2KY+Xr1z3LwwSh73Mtd0o/Yd0w==
X-Received: by 2002:a05:600c:2888:: with SMTP id g8mr1244781wmd.118.1596149366596;
        Thu, 30 Jul 2020 15:49:26 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id k4sm12545213wrd.72.2020.07.30.15.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 15:49:26 -0700 (PDT)
Subject: Re: [PATCH v3 03/11] KVM: SVM: Change intercept_dr to generic
 intercepts
To:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597948692.12744.7037992839778140055.stgit@bmoger-ubuntu>
 <CALMp9eRF-ScqaWG7vn2mxKmR4jWo7LYZiiicHksiZR9hh+G=-A@mail.gmail.com>
 <3841a638-eb9e-fae6-a6b6-04fec0e64b50@redhat.com>
 <2987e401-f021-a3a7-b4fa-c24ff6d0381b@amd.com>
 <560456cc-0cda-13f6-d152-3dca4896e27f@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3737d3b5-0569-bba3-cda1-9967e9651365@redhat.com>
Date:   Fri, 31 Jul 2020 00:49:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <560456cc-0cda-13f6-d152-3dca4896e27f@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 00:41, Babu Moger wrote:
>> Let me try to understand.
>>
>> vmcb01 is &svm->vmcb->control;l
>> vmcb02 is &svm->nested.hsave->control
>> vmcb12 is  &svm->nested.ctl;

Right now we don't have a separate vmcb01/vmcb02, we have the current
and hsave VMCBs.  Cathy is working on it.

Just do the refactoring by passing the control area to
vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept.

>> The functions set_intercept and clr_intercept calls get_host_vmcb to get the
>> vmcb address.
>
> I will move the get_host_vmcb inside the caller and then call
> vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept directly.

Hmm no I think set_intercept and clr_intercept should remain as is.

Paolo

> I will re post the series. This will change the whole series a little bit.

