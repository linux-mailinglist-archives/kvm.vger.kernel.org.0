Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD05401A60
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 13:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbhIFLIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 07:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240302AbhIFLIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 07:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630926467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZI1k/K6ivHiraxD4vMcL+vxFoqbnTrx2bG7F3rS0xHI=;
        b=Zt0hKJxDXmCPVV3PM0qovH9JNUMR0K7ePpbcEz2WBS2nvKqZNto7NbzXkGn/w6cqmMK96b
        sO6gchnPG56MFH6w0vEhjXDtVMs30IVZnvdowIDCR2RzmLQwAHSODZu7jItjWy2JPcsXDx
        1UnENrQHGSZqNz+faY6e9A7q5wa7LSs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-gOpcUhdgO6SnilAC0XFz0A-1; Mon, 06 Sep 2021 07:07:46 -0400
X-MC-Unique: gOpcUhdgO6SnilAC0XFz0A-1
Received: by mail-wm1-f69.google.com with SMTP id h1-20020a05600c350100b002e751bf6733so3076274wmq.8
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 04:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZI1k/K6ivHiraxD4vMcL+vxFoqbnTrx2bG7F3rS0xHI=;
        b=TdfvglGSYfHIe10pjz8ZITF3CLItsav+Z4XbtfLwEGTL6wx9+Ac/fAsYWMtBJ5qAqf
         bGhPvyPMgSLvnR65XPY7tlB4yJ5lr3gikFiQQG6dc5FEJyresWr0U9xg9B6HbUBtaOQS
         MKXoG98K2oFYnvHBgjKn/okZmQ7OIJtxtbDvw/12pWX3KpXlD6ewCB2nVFEVsthcFxvN
         QZTGbQAqwcxVS34RS9xR5IUdHKtGlhjpFW+99kuWqBE3XZEnSNzo8SDwUapjRp/FEJGq
         NHEh4hw3VanFjU9Y/Eww81Mx6KioE1UCmSg8y0nCiSQxkXoN0w4ozFHcZ7VhK6NVYPuU
         3WdQ==
X-Gm-Message-State: AOAM531HPiQsavXd1dMt/zMZwWmLg/fSK+wliIHfKve5I6aYlZdXRNVQ
        9CtcKGR6+JNsTkXEixhsJfhdWNN6Uyqn8EWYo/HzRp3c6tn8PL9E48FGgs28QBrMe1QuGRbmz3G
        u9kcHjkydFpIc
X-Received: by 2002:a1c:f613:: with SMTP id w19mr10649246wmc.9.1630926465421;
        Mon, 06 Sep 2021 04:07:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSCaYJQUbwtbI35XMt6DrgI6FomYKM94zk2bKZi3g5Ujko33G2NGowArfIHSdln8gB0Uj/1g==
X-Received: by 2002:a1c:f613:: with SMTP id w19mr10649218wmc.9.1630926465210;
        Mon, 06 Sep 2021 04:07:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p3sm7429784wrx.82.2021.09.06.04.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:07:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jiang Jiasheng <jiasheng@iscas.ac.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
In-Reply-To: <YTI5SYVTJHiMdm+W@google.com>
References: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
 <87czppnasv.fsf@vitty.brq.redhat.com> <YTI5SYVTJHiMdm+W@google.com>
Date:   Mon, 06 Sep 2021 13:07:43 +0200
Message-ID: <87tuiy3qtc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Sep 03, 2021, Vitaly Kuznetsov wrote:
>> Jiang Jiasheng <jiasheng@iscas.ac.cn> writes:
>> 
>> > The kvm_get_vcpu() will call for the array_index_nospec()
>> > with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
>> > and the value of constant '0' as index.
>> > If the size is also '0', it will be unreasonabe
>> > that the index is no less than the size.
>> >
>> 
>> Can this really happen?
>> 
>> 'online_vcpus' is never decreased, it is increased with every
>> kvm_vm_ioctl_create_vcpu() call when a new vCPU is created and is set to
>> 0 when all vCPUs are destroyed (kvm_free_vcpus()).
>> 
>> kvm_guest_time_update() takes a vcpu as a parameter, this means that at
>> least 1 vCPU is currently present so 'online_vcpus' just can't be zero.
>
> Agreed, but doing kvm_get_vcpu() is ugly and overkill.
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..cc1cb9a401cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>                                        offsetof(struct compat_vcpu_info, time));
>         if (vcpu->xen.vcpu_time_info_set)
>                 kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -       if (v == kvm_get_vcpu(v->kvm, 0))
> +       if (!kvm_vcpu_get_idx(v))

Do we really need to keep kvm_vcpu_get_idx() around though? It has only
3 users, all in arch/x86/kvm/hyperv.[ch], and the inline simpy returns
'vcpu->vcpu_idx'.

>                 kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>         return 0;
>  }
>

-- 
Vitaly

