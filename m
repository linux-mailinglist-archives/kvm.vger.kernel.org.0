Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3271D08E3
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 08:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgEMGrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 02:47:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728101AbgEMGrP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 02:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589352433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AdFMrhhIoANCzu/7dse+27HGCF0LIUSWgnhbm4IqTpY=;
        b=hC+54WZsyA82zWdaUkFkCKkbXa3zVp30n8Gt7xrmok9md28Vf/hZHmoS5hiJ+8IdgoZ72X
        /1ICiCJJq+Ishv/ynNL8fpvDVRJlME7v4829FQ4jOSd5n7jqIxm4jDXtka5tAJHn5dZU6H
        RKHeV8u72u1JOBM/t/Ldo7vfl59d2cc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-yktXWEV0NGaIngJ-Ov-fJw-1; Wed, 13 May 2020 02:47:11 -0400
X-MC-Unique: yktXWEV0NGaIngJ-Ov-fJw-1
Received: by mail-wr1-f69.google.com with SMTP id z8so8127739wrp.7
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 23:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AdFMrhhIoANCzu/7dse+27HGCF0LIUSWgnhbm4IqTpY=;
        b=Uoj+GoSEfnU8qCAams1uRS+ygbb9CFhX8JalGkfj0IB0B+M0w9hOxUHxeX+iXdmGjK
         X1XY8Bgbecd1b9iIfVpld4emI+kEOj5BkiN4d7v8j48GOVqyN6y0I8Z6G/5GM63igMfM
         YNSmK/CfNiS8vV0D7hYwRrUHR3DUORX0fUBZlEMawD4WAkzY2eyV38kaEgrLFaWWYdGU
         2CPKvDKFpw28ZpMmYvZ/6qwdoXQEhC7Puy/j1xLx5+rdQFF6iRqJg9su8HQT/WwRjJsR
         41nFTxrzf0fES2v8Ej5CIJ8Nhrnj0Ba05qi1PTaXGvXFkIGC+18CmyMtpq+hRf6wXU5H
         crRw==
X-Gm-Message-State: AGi0PuaBv37VacP9S4FWf4/LGiJFc3eBeoAt4zcWhLaZBJTeYeYWgIwq
        nsy/Ud58jv5pm41eAHA9h/HWeAZoJ93AkmGLO5oomTfON/AWXhhufSNjXk/1XDFQ1FgVscCKpV2
        HM0YXSIt1sXNB
X-Received: by 2002:a1c:a3c5:: with SMTP id m188mr20233382wme.160.1589352430275;
        Tue, 12 May 2020 23:47:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypJKd5qCQY6u5EUoGGL4m4WiqTUjq2cnRZ3DkU0F5sqPvQ/ZGnXVq3J14vWgf3ZM9BN5qZGbXA==
X-Received: by 2002:a1c:a3c5:: with SMTP id m188mr20233342wme.160.1589352430066;
        Tue, 12 May 2020 23:47:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6ced:5227:72a1:6b78? ([2001:b07:6468:f312:6ced:5227:72a1:6b78])
        by smtp.gmail.com with ESMTPSA id s11sm25480042wrp.79.2020.05.12.23.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 23:47:09 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] KVM: x86: Move pkru save/restore to x86.c
To:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com,
        Anthony Steinhauser <asteinhauser@google.com>,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>,
        Arjun Roy <arjunroy@google.com>, logang@deltatee.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923998430.20128.2992701977443921714.stgit@naples-babu.amd.com>
 <CALMp9eSAnkrUaBgtDAu7CDM=-vh3Cb9fVikrfOt30K1EXCqmBw@mail.gmail.com>
 <e84b15c2-ec9d-8063-4cf4-42106116fdd9@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6982aaa9-d1ee-db8a-2eeb-6063c9bc342c@redhat.com>
Date:   Wed, 13 May 2020 08:47:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e84b15c2-ec9d-8063-4cf4-42106116fdd9@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/20 19:17, Babu Moger wrote:
> 
> On 5/12/20 11:39 AM, Jim Mattson wrote:
>> On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
>>> MPK feature is supported by both VMX and SVM. So we can
>>> safely move pkru state save/restore to common code. Also
>>> move all the pkru data structure to kvm_vcpu_arch.
>>>
>>> Also fixes the problem Jim Mattson pointed and suggested below.
>>>
>>> "Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
>>> resource isn't. It can be read with XSAVE and written with XRSTOR.
>>> So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
>>> the guest can read the host value.
>>>
>>> In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
>>> potentially use XRSTOR to change the host PKRU value"
>>>
>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> I would do the bugfix as a separate commit, to ease backporting it to
>> the stable branches.
> Ok. Sure.

I will take care of this for v4 (pick this patch up and put it in
5.7-rc, package everything as a topic branch, merge it to kvm/next).

Paolo

