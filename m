Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF52D724D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 11:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfJOJ2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 05:28:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbfJOJ2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 05:28:40 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDCE746288
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 09:28:39 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id s16so1700722wme.6
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 02:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aub9eUM1bMC5A+9eKTkOj7byBw91bMGGa1ow0bZuIKI=;
        b=LBHDoQdAXUykxA9+QtCmbL7uW1kuvuUo+DIdYBKC27aKZ5+jw7OxdpQrvQLjXRW8mG
         8UrKGWnO19IPKSQwrxqsaAecyFomHMf4MSgDBUdd/eF6wkVBQChNaoCovvkM0I6pX+wB
         I0LV7zbm75FDXV+VHkkHuKwLHff2Rz6pvKxh49EARzQT/V21kRhZuULs7EBgS0arpFAt
         G3cK0QPNBqtSErVyxg4SlKPzdSa1pFStyv0HZ63Q4enMVTZ3+HFlZLIDTH+mdzvgwTC8
         42cM0Adk96Q+K5rm41dtoLALrDkFd67aeu3Gxk2Zk55OqbflGHIBBCmrx06UYHHi46wP
         z0QA==
X-Gm-Message-State: APjAAAXm0/1qgFlg4DVEhwDfn8gGj9kiixOMqqtOY6IbHJEtMZhtLgJ6
        EuCHcquMlXgF0flUd7ARQ0tKxNuhkeBiX6dd9TmFoYxXUrsOAJCLXkTewPmfC8AW1h/J0ERMOmv
        dgYIzz1kEIUoF
X-Received: by 2002:a1c:a784:: with SMTP id q126mr17779308wme.59.1571131718515;
        Tue, 15 Oct 2019 02:28:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwL9u0C2kzpM2yvdS1YogOoNAbTP1QenamcQe0oKSrvWrdfOYgMAVNPba0m3+5BPL183ARKVw==
X-Received: by 2002:a1c:a784:: with SMTP id q126mr17779289wme.59.1571131718217;
        Tue, 15 Oct 2019 02:28:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id n7sm22921225wrt.59.2019.10.15.02.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 02:28:37 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
Date:   Tue, 15 Oct 2019 11:28:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87y2xn462e.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/19 18:58, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
>> and SVM. Make them common functions.
>>
>> No functional change intended.
> Would it rather make sense to move this code to
> kvm_arch_vcpu_create()/kvm_arch_vcpu_destroy() instead?
> 

user_fpu could be made percpu too...  That would save a bit of memory
for each vCPU.  I'm holding on Xiaoyao's patch because a lot of the code
he's touching would go away then.

Paolo
