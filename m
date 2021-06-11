Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6D3A4614
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhFKQE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:04:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231924AbhFKQD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 12:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623427320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KodckdEdFkiVnhQ3kWeVQWRJntz+7Wxk85hCibed+y8=;
        b=BeRar4kXqSFTiG4Zhzn1wJuUeiNnydo8/aDInHIs35OvEd/YLhxi9pwirkiyHz4W/xcNkA
        RSOzUjrzFwLrmbHZjWc1OSBBAFQrtydCkxoRdKi3lgefdoO548uvpHgRCsS7RFvYaD4k/s
        FSVYPb4+Ii68hWkHMehm6ptpgGZwoCQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-m64_-J-2Mn6p6xYRPBUQag-1; Fri, 11 Jun 2021 12:01:59 -0400
X-MC-Unique: m64_-J-2Mn6p6xYRPBUQag-1
Received: by mail-wm1-f71.google.com with SMTP id u17-20020a05600c19d1b02901af4c4deac5so4561552wmq.7
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 09:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KodckdEdFkiVnhQ3kWeVQWRJntz+7Wxk85hCibed+y8=;
        b=kc89nldcK2Qfu0gpTIHMSNsGS9GfrpA86/8SwUgSHSoZdvyWEqdNrUfchlUD2cOGTC
         UtpZcujR9yhy16nNyzMqYDaJXlwzo+lw8rlmbhY7DqGT0hVAoFtrIMFDW+U5W/uyw4qy
         /c8SGa0vP6puAT35A2yqN8WVQOmA70VZ4vanUrq8rJxPE0SroRjtMDsoN4UODa6sRWzW
         B9CffUIlqvzdc88jlXlw9eVc3aPpTUXxTJPD2vafS7F24w5Kp7TBEL4/kbPb09tx/v0B
         2f8pzYJiP1Rmj2SRg8oI9oyWIC3JSrcpX4QMwxQMbKo3U+T1nsfvt4iqmmnEfDeP7/wa
         7OiQ==
X-Gm-Message-State: AOAM532/+EKvp//ymU/eToNsc3t0HRgyCvjALtJqALoXaWU3qjv5jL4Y
        qlhZRUSHtwN5aujNbVpZzvb6z3LjZF6LgltOQzmgUXxYpxrQOKDDZBdIHqHHEUZqxERQhSEsHPW
        hlNhO9Dr76+/+
X-Received: by 2002:a05:6000:22c:: with SMTP id l12mr4838441wrz.329.1623427317860;
        Fri, 11 Jun 2021 09:01:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkO/4rFB+Bz9cLk6zIBi8aAYZqwvx6oQXfxBfVew8J+fQdIHhS0NRnmI0ob3DFrOtSokAkyg==
X-Received: by 2002:a05:6000:22c:: with SMTP id l12mr4838420wrz.329.1623427317678;
        Fri, 11 Jun 2021 09:01:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m132sm6508982wmf.10.2021.06.11.09.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:01:56 -0700 (PDT)
Subject: Re: [RFC PATCH 0/7] Support protection keys in an AMD EPYC-Milan VM
To:     David Edmondson <david.edmondson@oracle.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <330417d8-9e23-4c90-b825-24329d3e4c66@redhat.com>
Date:   Fri, 11 Jun 2021 18:01:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First of all, sorry for the delayed review.

On 20/05/21 16:56, David Edmondson wrote:
> AMD EPYC-Milan CPUs introduced support for protection keys, previously
> available only with Intel CPUs.
> 
> AMD chose to place the XSAVE state component for the protection keys
> at a different offset in the XSAVE state area than that chosen by
> Intel.
> 
> To accommodate this, modify QEMU to behave appropriately on AMD
> systems, allowing a VM to properly take advantage of the new feature.

Uff, that sucks. :(

If I understand correctly, the problem is that the layout of 
KVM_GET_XSAVE/KVM_SET_XSAVE depends on the host CPUID, which in 
retrospect would be obvious.  Is that correct?  If so, it would make 
sense and might even be easier to drop all usage of X86XSaveArea:

* update ext_save_areas based on CPUID information in kvm_cpu_instance_init

* make x86_cpu_xsave_all_areas and x86_cpu_xrstor_all_areas use the 
ext_save_areas offsets to build pointers to XSaveAVX, XSaveBNDREG, etc.

What do you think?

Paolo

> Further, avoid manipulating XSAVE state components that are not
> present on AMD systems.
> 
> The code in patch 6 that changes the CPUID 0x0d leaf is mostly dumped
> somewhere that seemed to work - I'm not sure where it really belongs.
> 
> David Edmondson (7):
>    target/i386: Declare constants for XSAVE offsets
>    target/i386: Use constants for XSAVE offsets
>    target/i386: Clarify the padding requirements of X86XSaveArea
>    target/i386: Prepare for per-vendor X86XSaveArea layout
>    target/i386: Introduce AMD X86XSaveArea sub-union
>    target/i386: Adjust AMD XSAVE PKRU area offset in CPUID leaf 0xd
>    target/i386: Manipulate only AMD XSAVE state on AMD
> 
>   target/i386/cpu.c            | 19 +++++----
>   target/i386/cpu.h            | 80 ++++++++++++++++++++++++++++--------
>   target/i386/kvm/kvm.c        | 57 +++++++++----------------
>   target/i386/tcg/fpu_helper.c | 20 ++++++---
>   target/i386/xsave_helper.c   | 70 +++++++++++++++++++------------
>   5 files changed, 152 insertions(+), 94 deletions(-)
> 

