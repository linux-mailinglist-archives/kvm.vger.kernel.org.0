Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB78E1CEE92
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 09:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgELHyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 03:54:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40024 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725813AbgELHyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 03:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589270072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/MYEE3LL026i32opmckGgknS6r7+NiLTdtsOAf25vo=;
        b=elz05xO0cvXWiG0MJ1auB050RM5a2yT188uWFT+gQ0LAB5fl4exT2aa9cP7bJWSewARjZq
        ZZpxL/st04nJdRqyPzdreY5fiHpVPIjsqQ3wYosmqEBgvYY227NaG5SDCkx7KGLl23Vujb
        HuAknVAXI7qNdRvObR41fSvuBrmHRFw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-Y7zrCVaIOXmRM7b5I6fAhA-1; Tue, 12 May 2020 03:54:31 -0400
X-MC-Unique: Y7zrCVaIOXmRM7b5I6fAhA-1
Received: by mail-wm1-f69.google.com with SMTP id l26so1277969wmh.3
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 00:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u/MYEE3LL026i32opmckGgknS6r7+NiLTdtsOAf25vo=;
        b=fR+hp1fRHp8J7JRbXBCUsz6MjymupLuohP0rMk2TqAsWKvuI26ZJTdHOcimllfg82d
         7yJlhIBoSBYNFaSqrd3D26qXVlcux7mRFdH80Pu13Wke1OCoFT8V7+EuKPZILHLSiUSA
         riu5ziWrnuHdWGC/t7aBuPp/LztMzhzpCbvjlIwVEnqg3t/fcdJQwa83/hh4jv2NbzqN
         CK30eM5TbZh1A77gcj8WNPejvRtjs+/yIzFjHIwQMBq86OWgNUcFDTZcRWuPfcc0+l5d
         U+MuGZfzlNOHuM7vPNVVk6OY6nZk5bCV4l3U9lTEuNTU7/CuCscylec6NNbFZc+Bg1GT
         FNDQ==
X-Gm-Message-State: AGi0PubWriPaKL1WDPKGZy3QNMtirxOrPbt4yeSgPd9V7vw4fDxFuucZ
        PJLwQGimq8fIahlsjQ7qio3gKxtxgBnnNiNxC9Js07t+IadmWQaTJW5TAHxTHy1vZ1RTlRBFbfa
        dPtDlzO9oSROx
X-Received: by 2002:a5d:684a:: with SMTP id o10mr23024025wrw.311.1589270069790;
        Tue, 12 May 2020 00:54:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypJCzBgjMpK4yFwn071XfEIZdrnXGhYtv+pSlpt1rTWKIT49tzHYGX04nanxlWmWYnQp5xLxSg==
X-Received: by 2002:a5d:684a:: with SMTP id o10mr23023997wrw.311.1589270069463;
        Tue, 12 May 2020 00:54:29 -0700 (PDT)
Received: from [192.168.1.38] (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id p8sm21067366wre.11.2020.05.12.00.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 00:54:28 -0700 (PDT)
Subject: Re: [PATCH] i386/kvm: fix a use-after-free when vcpu plug/unplug
To:     Pan Nengyuan <pannengyuan@huawei.com>, pbonzini@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com
Cc:     euler.robot@huawei.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        zhang.zhanghailiang@huawei.com
References: <20200512133933.8696-1-pannengyuan@huawei.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <eab55b02-d51b-96c6-3c03-eb69964f162d@redhat.com>
Date:   Tue, 12 May 2020 09:54:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200512133933.8696-1-pannengyuan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/20 3:39 PM, Pan Nengyuan wrote:
> When we hotplug vcpus, cpu_update_state is added to vm_change_state_head
> in kvm_arch_init_vcpu(). But it forgot to delete in kvm_arch_destroy_vcpu() after
> unplug. Then it will cause a use-after-free access. This patch delete it in
> kvm_arch_destroy_vcpu() to fix that.
> 
> Reproducer:
>      virsh setvcpus vm1 4 --live
>      virsh setvcpus vm1 2 --live
>      virsh suspend vm1
>      virsh resume vm1
> 
> The UAF stack:
> ==qemu-system-x86_64==28233==ERROR: AddressSanitizer: heap-use-after-free on address 0x62e00002e798 at pc 0x5573c6917d9e bp 0x7fff07139e50 sp 0x7fff07139e40
> WRITE of size 1 at 0x62e00002e798 thread T0
>      #0 0x5573c6917d9d in cpu_update_state /mnt/sdb/qemu/target/i386/kvm.c:742
>      #1 0x5573c699121a in vm_state_notify /mnt/sdb/qemu/vl.c:1290
>      #2 0x5573c636287e in vm_prepare_start /mnt/sdb/qemu/cpus.c:2144
>      #3 0x5573c6362927 in vm_start /mnt/sdb/qemu/cpus.c:2150
>      #4 0x5573c71e8304 in qmp_cont /mnt/sdb/qemu/monitor/qmp-cmds.c:173
>      #5 0x5573c727cb1e in qmp_marshal_cont qapi/qapi-commands-misc.c:835
>      #6 0x5573c7694c7a in do_qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:132
>      #7 0x5573c7694c7a in qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:175
>      #8 0x5573c71d9110 in monitor_qmp_dispatch /mnt/sdb/qemu/monitor/qmp.c:145
>      #9 0x5573c71dad4f in monitor_qmp_bh_dispatcher /mnt/sdb/qemu/monitor/qmp.c:234
> 
> Reported-by: Euler Robot <euler.robot@huawei.com>
> Signed-off-by: Pan Nengyuan <pannengyuan@huawei.com>
> ---
>   target/i386/cpu.h | 1 +
>   target/i386/kvm.c | 5 ++++-
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index e818fc712a..afbd11b7a3 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1631,6 +1631,7 @@ struct X86CPU {
>   
>       CPUNegativeOffsetState neg;
>       CPUX86State env;
> +    VMChangeStateEntry *vmsentry;
>   
>       uint64_t ucode_rev;
>   
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 4901c6dd74..ff2848357e 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1770,7 +1770,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>           }
>       }
>   
> -    qemu_add_vm_change_state_handler(cpu_update_state, env);
> +    cpu->vmsentry = qemu_add_vm_change_state_handler(cpu_update_state, env);
>   
>       c = cpuid_find_entry(&cpuid_data.cpuid, 1, 0);
>       if (c) {
> @@ -1883,6 +1883,9 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
>           env->nested_state = NULL;
>       }
>   
> +    qemu_del_vm_change_state_handler(cpu->vmsentry);
> +    cpu->vmsentry = NULL;

Why set it to NULL? there is no non-NULL check.

Anyway if it matters to you, why not do it in 
qemu_del_vm_change_state_handler()?

Otherwise:
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> +
>       return 0;
>   }
>   
> 

