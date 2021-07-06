Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1B73BD865
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhGFOka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231754AbhGFOk2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CQBCB+bMahID1ZaCZKHNYR0DExf7wMJRe389TSgL0HE=;
        b=YXf9IgeCgP8PLmGtTyboO6+Wj6kgvOmRN4TDsoQbT2X5ECcWu1TKoDtvOpduJJuyvsSsAx
        fE/BH9XWiBpKuVLaHw61S/Heu2wD3qseAZeBimHEMSf5+LPTLif5OrhIE2/4bmhbRjhMiv
        xBisZbqL+/tlrqqglhwGuQ3tX6Sc7Rg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-FcP84AUEOAeufncOCM7eQQ-1; Tue, 06 Jul 2021 09:47:35 -0400
X-MC-Unique: FcP84AUEOAeufncOCM7eQQ-1
Received: by mail-ej1-f70.google.com with SMTP id d2-20020a1709072722b02904c99c7e6ddfso5822217ejl.15
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CQBCB+bMahID1ZaCZKHNYR0DExf7wMJRe389TSgL0HE=;
        b=jo0n9jfT5W96A1OOpTN6r9bDAjYURLmuMFLcJ8tM7IO2haqImF5Gu402H+bJDhSHXo
         Kqu/GzEp5Pi80xOM3Bj3l41b+w9Yh/6NKOmrK2li3eO/SfajsLANSoW7QwLC28hCgDXC
         J/JPPFkWLgddYN5WEcBmMHPpAYRn3SAb3AWUrCRgtHuva/EX+F0B3sqDOAjQbwE/cZtd
         3aDSxXVJSYnVtm0cIDladY8mkT5HtIZuqxK8l7tYZ97GZU1tXP3YIUD7/1fhwf3gNcvY
         xiK92sfuu3pMdZfAVitkEwCy9Hh/8ijFWj48fpzXUFZIiEKESPzPCwTaETmqNOXYAx0w
         InYA==
X-Gm-Message-State: AOAM5337RDKyw1FAg/zV9wiPgXphLVT5rQEfARruloXm3Sct7JYQ7HT0
        J/q+AZKs6UJwBjGTR+dsrAVvAhPE+RmYMcpBKa7bBMEGMXYTIEW3vD2iM9cw4MhQbMw1MHDvJvL
        zyhfdtJK2Jo8p
X-Received: by 2002:a05:6402:100e:: with SMTP id c14mr22590659edu.51.1625579254003;
        Tue, 06 Jul 2021 06:47:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXX0V6NyZLkesT4JsBq/0laHKl+IOkz9sbNFzot2uERrrxaV2JlFVgf9Huw20vMU9mmk7FAQ==
X-Received: by 2002:a05:6402:100e:: with SMTP id c14mr22590627edu.51.1625579253872;
        Tue, 06 Jul 2021 06:47:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cz9sm3256609edb.76.2021.07.06.06.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:47:33 -0700 (PDT)
Subject: Re: [RFC PATCH v2 18/69] KVM: Export kvm_make_all_cpus_request() for
 use in marking VMs as bugged
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <1d8cbbc8065d831343e70b5dcaea92268145eef1.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f70c6603-a6af-9090-68e7-d9238a9b1054@redhat.com>
Date:   Tue, 6 Jul 2021 15:47:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1d8cbbc8065d831343e70b5dcaea92268145eef1.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Export kvm_make_all_cpus_request() and hoist the request helper
> declarations of request up to the KVM_REQ_* definitions in preparation
> for adding a "VM bugged" framework.  The framework will add KVM_BUG()
> and KVM_BUG_ON() as alternatives to full BUG()/BUG_ON() for cases where
> KVM has definitely hit a bug (in itself or in silicon) and the VM is all
> but guaranteed to be hosed.  Marking a VM bugged will trigger a request
> to all vCPUs to allow arch code to forcefully evict each vCPU from its
> run loop.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

This should be _before_ patch 17, not after.

Paolo

