Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E068271602
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgITQmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 12:42:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbgITQmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Sep 2020 12:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600620163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQOc5ISffTaehBEuI30FdkiWsdsuqhPzKjSDj5gslrU=;
        b=cnVAF+a7ERkRfDwimCNrUdJeFTbO3ZRbBWlXKGmiI9kvYeR525V9CGOvMY4/3a+jP5MW1L
        zu8QOeEi2CjyQDk+hi7rsD/PqfLVusTTFl5jzBcRgtgW3B7SOvNwEz1ptfX7TZR57LQKIs
        BTt0IJY6OJhhm908FCkNvu6HRb+bwG4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-ASTszgulMt2JHTUNfOp2Qw-1; Sun, 20 Sep 2020 12:42:41 -0400
X-MC-Unique: ASTszgulMt2JHTUNfOp2Qw-1
Received: by mail-wr1-f71.google.com with SMTP id h4so4779177wrb.4
        for <kvm@vger.kernel.org>; Sun, 20 Sep 2020 09:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQOc5ISffTaehBEuI30FdkiWsdsuqhPzKjSDj5gslrU=;
        b=PytZdU0u9Y8Ei6Eolp9qzY666aK7sv4oVkTvCPlYCBeWOfIdQqeu8gmg8fy4fm1sKH
         O29L1TdRqyZjmno9fJIBNE3sKO7v+kUnLSiF+rBdYwVCXCeP9tMjlc20llGQ/+1uXLcz
         gqKLcsNwNdbPGqrwNqjDO+c+yHU3B701Y3I/m0ZVUqFr75SI1F9+E2qk7pg4k8rAKSYM
         hV7UOB7n6DEG/CbPx0qbDHjFgupk6SbWXH0eY9ClJ5hoDV8bFlGt9PstiEcqR8OGB2BH
         1Snpj55v97VEbhC/PBPBaueoi8ZEuiAJ/RSDJGPh5u2ws7h4k7nt4fRdf4pGm3eTTVpF
         q9gA==
X-Gm-Message-State: AOAM530Lc3V5RzaVSDzxPP2BDaMSpXblDfe0/xl4sPyNMg4QJdQ2PwZX
        otPhQgSy7wsfTbKWvQyCJkaycsM3DIbZqc4xicPwwGcnruTmkwT4v/TLqV7GxlYGWOH2tVfc09d
        di4QghtEI2Bl1
X-Received: by 2002:a7b:c103:: with SMTP id w3mr24627955wmi.24.1600620160110;
        Sun, 20 Sep 2020 09:42:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcpPDRWHYVnQLTNMlhC8LLSjhM1SI6varUE6ZPjuPraMsccbvNnrlSEoYpg8wkw0TCEmrNbg==
X-Received: by 2002:a7b:c103:: with SMTP id w3mr24627934wmi.24.1600620159827;
        Sun, 20 Sep 2020 09:42:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d107:d3ba:83ae:307e? ([2001:b07:6468:f312:d107:d3ba:83ae:307e])
        by smtp.gmail.com with ESMTPSA id l10sm14977264wru.59.2020.09.20.09.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 09:42:39 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] KVM: nSVM: implement ondemand allocation of the
 nested state
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
 <20200917101048.739691-3-mlevitsk@redhat.com>
 <20200917162942.GE13522@sjchrist-ice>
 <d9c0d190-c6ea-2e21-92ca-2a53efb86a1d@redhat.com>
 <20200920161602.GA17325@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c35cbaca-2c34-cd93-b589-d4ab782fc754@redhat.com>
Date:   Sun, 20 Sep 2020 18:42:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200920161602.GA17325@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/20 18:16, Sean Christopherson wrote:
>> Maxim, your previous version was adding some error handling to
>> kvm_x86_ops.set_efer.  I don't remember what was the issue; did you have
>> any problems propagating all the errors up to KVM_SET_SREGS (easy),
>> kvm_set_msr (harder) etc.?
> I objected to letting .set_efer() return a fault.

So did I, and that's why we get KVM_REQ_OUT_OF_MEMORY.  But it was more
of an "it's ugly and it ought not to fail" thing than something I could
pinpoint.

It looks like we agree, but still we have to choose the lesser evil?

Paolo

> A relatively minor issue is
> the code in vmx_set_efer() that handles lack of EFER because technically KVM
> can emulate EFER.SCE+SYSCALL without supporting EFER in hardware.  Returning
> success/'0' would avoid that particular issue.  My primary concern is that I'd
> prefer not to add another case where KVM can potentially ignore a fault
> indicated by a helper, a la vmx_set_cr4().

