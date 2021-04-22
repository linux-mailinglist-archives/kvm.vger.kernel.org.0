Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EA2367A4E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhDVG5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 02:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230341AbhDVG5E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 02:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619074590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/pu0p1gTOS1PS7XsxBUkS37Pa/ylXdidImYYckq7UY=;
        b=MAUX7iWH0NawKuJgKrZr7BYTPug/ZUmZSUd197Ceh9PU/diz2588FkLAl9iuYYw0JQFFK4
        X702XOoTDGozvxnFqmRap82rNaGFma6cnCpaUUkWoNl4VQheDBTXJOnXaPndaJcVPj3Dkz
        A6u1amOk5k3hfkWYTflK29L084T6lCI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-Ul8mk4W-MOamJaYYrHfpAA-1; Thu, 22 Apr 2021 02:55:27 -0400
X-MC-Unique: Ul8mk4W-MOamJaYYrHfpAA-1
Received: by mail-ed1-f70.google.com with SMTP id cz7-20020a0564021ca7b02903853d41d8adso6920235edb.17
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 23:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m/pu0p1gTOS1PS7XsxBUkS37Pa/ylXdidImYYckq7UY=;
        b=g1/nwxuYtbwA/gOBP04rCqtPBx2M1z/eQ2VCplx8EjAuTb/MYVXGNXmgdciC0HY2nX
         hzsf2QLaVv7zNx6byoKWwB3Edl/rCzG+29NAqja40hFUdG9JeBLI2mGysvo1S0FUu8Hr
         aik8/Pfhk5iqsnayGcVLzEaYGe9zT2Y7LrNCJx1NXDYnq9cKQZY5T94okEeWphqy+moa
         nphfsTk/YzB5XJqvDPt4+YHq96SzXlseG97B/o4b33nDBQC6utwyr7TpWlL7i8hRFlFz
         7WfquxysufkDnXKpVG3tPlDOQZDxykg/kn0Ftjkhl98cWRHhjACwdIqXyh8E70CIZF44
         Xeeg==
X-Gm-Message-State: AOAM531RBEdIxy2ZCs2928yHFO3sMI5wIZ2JzBKh1bY8s9ykw6kQ30gB
        +dXuxiqvET+bWcJpNXOmSGrpScq9znMi3ENdqFZMyl6TBSphzeD/3PLKp40Vst00JExB0CKVa8y
        zoa0zu+vSSLM1
X-Received: by 2002:a17:906:c04:: with SMTP id s4mr1797003ejf.410.1619074526450;
        Wed, 21 Apr 2021 23:55:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzht7VAajXmdGxeQ1H5uS6egzt5iz8Mx+EaCVwvzRSrQ0cjkFg+yduXRXej/91oj8T45q0gqQ==
X-Received: by 2002:a17:906:c04:: with SMTP id s4mr1796986ejf.410.1619074526298;
        Wed, 21 Apr 2021 23:55:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id mj7sm1181802ejb.39.2021.04.21.23.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 23:55:25 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: x86: Fixes for (benign?) truncation bugs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20210422022128.3464144-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61e0dd04-a91a-1946-d694-2ed2fce4abb5@redhat.com>
Date:   Thu, 22 Apr 2021 08:55:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422022128.3464144-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:21, Sean Christopherson wrote:
> Patches 01 and 02 fix theoretical bugs related to loading CRs through
> the emulator.  The rest of the patches are a bunch of small fixes for
> cases where KVM reads/writes a 64-bit register outside of 64-bit mode.
> 
> I stumbled on this when puzzling over commit 0107973a80ad ("KVM: x86:
> Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch"), which stated that SEV
> guests failed to boot on PCID-enabled hosts.  Why only PCID hosts?
> 
> After much staring, I realized that the initial CR3 load in
> rsm_enter_protected_mode() would skip the MAXPHYADDR check due to the
> vCPU not being in long mode.  But due to the ordering problems with
> PCID, when PCID is enabled in the guest, the second load of CR3 would
> be done with long mode enabled and thus hit the SEV C-bit bug.
> 
> Changing kvm_set_cr3() made me look at the callers, and seeing that
> SVM didn't properly truncate the value made me look at everything else,
> and here we are.
> 
> Note, I strongly suspect the emulator still has bugs.  But, unless the
> guest is deliberately trying to hit these types of bugs, even the ones
> fixed here, they're likely benign.  I figured I was more likely to break
> something than I was to fix something by diving into the emulator, so I
> left it alone.  For now. :-)
> 
> v2: Rebase to kvm/queue, commit 89a22e37c8c2 ("KVM: avoid "deadlock"
>      between install_new_memslots and MMU notifier")
> 
> v1: https://lkml.kernel.org/r/20210213010518.1682691-1-seanjc@google.com
> 
> Sean Christopherson (9):
>    KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4 loads
>    KVM: x86: Check CR3 GPA for validity regardless of vCPU mode
>    KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode
>    KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit mode
>    KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in
>      !64-bit
>    KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit
>    KVM: x86/xen: Drop RAX[63:32] when processing hypercall
>    KVM: SVM: Use default rAX size for INVLPGA emulation
>    KVM: x86: Rename GPR accessors to make mode-aware variants the
>      defaults
> 
>   arch/x86/kvm/emulate.c        | 68 +----------------------------------
>   arch/x86/kvm/kvm_cache_regs.h | 19 ++++++----
>   arch/x86/kvm/svm/svm.c        | 12 +++++--
>   arch/x86/kvm/vmx/nested.c     | 14 ++++----
>   arch/x86/kvm/vmx/vmx.c        |  6 ++--
>   arch/x86/kvm/x86.c            | 19 ++++++----
>   arch/x86/kvm/x86.h            |  8 ++---
>   7 files changed, 48 insertions(+), 98 deletions(-)
> 

Queued, thanks.

Paolo

