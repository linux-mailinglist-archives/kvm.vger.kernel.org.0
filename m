Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278E5383A46
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbhEQQpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 12:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240562AbhEQQp3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 12:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621269842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pLOobSjCbQskFqMnll0HyKDl5KNjQO+RBewEeO7jSSc=;
        b=G1vgcO12YGKD0d0osMoY3g3sTP30iMUiNJbgGdS5JEbqJRjR7mhPHOhQElILTX4mfjGTbd
        vtmj6nNLN5QOS3zTFrWJMBuv0TRpz4cBqLhQNJ7cc1D6LM7sWwby7mkCtBnyKopsns1ERY
        Km8PQDNDUfD4eVhfxNxwGGDnTiQaLgs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-fiDcW9MlOVSdo-5D5yidxg-1; Mon, 17 May 2021 12:44:00 -0400
X-MC-Unique: fiDcW9MlOVSdo-5D5yidxg-1
Received: by mail-ej1-f70.google.com with SMTP id m18-20020a1709062352b02903d2d831f9baso1257426eja.20
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 09:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pLOobSjCbQskFqMnll0HyKDl5KNjQO+RBewEeO7jSSc=;
        b=CD15Sa8RLlTxXKNj9edXSne2I+KbidQ93w/mEJxGel04w5U8AsHTRr33uDKvDn0LHW
         1SghceJ765//LJfDVdqJ8+y+AbQmpH/eovN2CH+T4p4g/j6ar4pDF4cFpWV5h58IGIsb
         9wPBhYaQHQHhBlIjZA1iHXx1eKpb4FH9flhCVJmVYpWJ5+PKMUaz6zuv3S+g4buEVM+O
         AGmolCk8bdDw2CKnsl/g8HSkJMbv7v5wC4LianJ95h3gGczcb86/JM9nz3YIqmrzDIM8
         O25L0sWqIgdRIb3nB39ENhir5m6zpLHzR4f5gIYls0B/so3fJllGVHo4UgRhNHMVgPHQ
         wh9Q==
X-Gm-Message-State: AOAM532nvMTCkz3IkQZ0z8F8Wk7pV/Um0/fW5+qkNJLInfdWyNU8jl9O
        7Q0sXpJW0yfEmpoSZLy7o7N0/d5k0REgjHDfWERRTgqo32IiS3SMD7+VPyfAaVJ2OMY35XId+3y
        4owMNguipoDSBdlcYB/UvIYo9Per0Ody0dT00jrArJ+9mRoeM3KyRTXd5fYj5lMLY
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr1150021edj.178.1621269839239;
        Mon, 17 May 2021 09:43:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybcPfcPZg8fUCw2rYDP5qsCQxq7rGzcUbcnUmTWFmLAlzNQpmPlCsCiTwFNHTun2K89RcSNQ==
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr1149967edj.178.1621269838988;
        Mon, 17 May 2021 09:43:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i5sm4826603edt.11.2021.05.17.09.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 09:43:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>, Jon Kohler <jon@nutanix.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <ccdf00d8-7957-de95-68cd-7d61ece337c0@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8033c48-86aa-397b-57aa-71d65d834e9f@redhat.com>
Date:   Mon, 17 May 2021 18:43:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ccdf00d8-7957-de95-68cd-7d61ece337c0@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/21 15:54, Dave Hansen wrote:
> On 5/13/21 10:11 PM, Andy Lutomirski wrote:
>> I don't even want to think about what happens if a perf NMI hits and
>> accesses host user memory while the guest PKRU is live (on VMX -- I
>> think this can't happen on SVM).
> 
> What's the relevant difference between SVM and VMX here?  I'm missing
> something.

SVM has the global interrupt flag that blocks NMIs and SMIs, and PKRU is 
loaded while GIF=0.

Paolo

