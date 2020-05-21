Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1979E1DD1E7
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 17:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgEUPbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 11:31:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35780 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729598AbgEUPbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 11:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590075063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NiBbFfqpWGfaX7br4oQd1Sf0u6bMIADYOp/o0kJpbao=;
        b=b3Ea99Pt802PKQzW4nUWd0+XptQsmfqsAUAKfMvp6C9xuU0RKtwACeLnQadcChcmjv62hj
        JkZdJy/zcUYRo5eFV/NE4nOaEJVdbhu2WbTpHfQra8LuWUgfeJd4iE5tmj7i/CVVbXy8u5
        +OOcvpn7Bmrn6Bz6DgU0QX9+5iKcwcM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-8yJcSXQiPYaOHqB9vxPyzA-1; Thu, 21 May 2020 11:31:01 -0400
X-MC-Unique: 8yJcSXQiPYaOHqB9vxPyzA-1
Received: by mail-wr1-f69.google.com with SMTP id p8so3069364wrj.5
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 08:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NiBbFfqpWGfaX7br4oQd1Sf0u6bMIADYOp/o0kJpbao=;
        b=KQQt2vH3sfGd5yuH1GrAsVVUs6MMlW3AyKOGmLicU7/umYVsbsapG5wQbrAj2iFEeI
         8WOYZ8OWxtKbGUwzZCTPRO4tDUd4f5qXCUj9VvFkVV87REhUoFiVhdffGLg+CK4um+7F
         heratThW3heI/w5dSWkoGsxxw27UtpEt2Gn9NZE3wpeTK9WvfEmuN9IquaLwaklNSdEh
         rq/hAuiwzOx2ora8NhS9qGKDID7SQfOpAjFLIr7ITvE+2yPCFXSGgag14W8K1MrpZ9l+
         GbMO5UVFHYkRBCqps4h4HDn0PBJbeq04aG7usuydXqzQRN4MRWwhaEhV1UWhxAZbRIGo
         cFiw==
X-Gm-Message-State: AOAM531Br8SfmtXgAW4QbUKTwQEVN0yStikmtu3jp9ys/QvHpJfsnyUY
        0bimpKwHzVQExyn3a/McwLstfRpRkvFIf1Tzc+r6qYZP20LYYWsIF7VgnzzAERxhc3r9CB9LS+k
        cAUGSi5hLa0io
X-Received: by 2002:adf:e951:: with SMTP id m17mr9117306wrn.352.1590075059863;
        Thu, 21 May 2020 08:30:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9XzQHYSb3oj7OXmZwI4SsOv4c8F+v4kCsqF4Ze+XpP0U9yag65LbK5doHRKdxJY5/WD7+mw==
X-Received: by 2002:adf:e951:: with SMTP id m17mr9117283wrn.352.1590075059632;
        Thu, 21 May 2020 08:30:59 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.160.154])
        by smtp.gmail.com with ESMTPSA id m7sm6922422wmc.40.2020.05.21.08.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 08:30:59 -0700 (PDT)
Subject: Re: [PATCH v2] i386/kvm: fix a use-after-free when vcpu plug/unplug
To:     Pan Nengyuan <pannengyuan@huawei.com>, rth@twiddle.net,
        ehabkost@redhat.com, mtosatti@redhat.com
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        zhang.zhanghailiang@huawei.com, euler.robot@huawei.com
References: <20200513132630.13412-1-pannengyuan@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2bbaf097-69ab-3afb-d081-56eb76f633d5@redhat.com>
Date:   Thu, 21 May 2020 17:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513132630.13412-1-pannengyuan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/20 15:26, Pan Nengyuan wrote:
> When we hotplug vcpus, cpu_update_state is added to vm_change_state_head
> in kvm_arch_init_vcpu(). But it forgot to delete in kvm_arch_destroy_vcpu() after
> unplug. Then it will cause a use-after-free access. This patch delete it in
> kvm_arch_destroy_vcpu() to fix that.
> 
> Reproducer:
>     virsh setvcpus vm1 4 --live
>     virsh setvcpus vm1 2 --live
>     virsh suspend vm1
>     virsh resume vm1
> 
> The UAF stack:
> ==qemu-system-x86_64==28233==ERROR: AddressSanitizer: heap-use-after-free on address 0x62e00002e798 at pc 0x5573c6917d9e bp 0x7fff07139e50 sp 0x7fff07139e40
> WRITE of size 1 at 0x62e00002e798 thread T0
>     #0 0x5573c6917d9d in cpu_update_state /mnt/sdb/qemu/target/i386/kvm.c:742
>     #1 0x5573c699121a in vm_state_notify /mnt/sdb/qemu/vl.c:1290
>     #2 0x5573c636287e in vm_prepare_start /mnt/sdb/qemu/cpus.c:2144
>     #3 0x5573c6362927 in vm_start /mnt/sdb/qemu/cpus.c:2150
>     #4 0x5573c71e8304 in qmp_cont /mnt/sdb/qemu/monitor/qmp-cmds.c:173
>     #5 0x5573c727cb1e in qmp_marshal_cont qapi/qapi-commands-misc.c:835
>     #6 0x5573c7694c7a in do_qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:132
>     #7 0x5573c7694c7a in qmp_dispatch /mnt/sdb/qemu/qapi/qmp-dispatch.c:175
>     #8 0x5573c71d9110 in monitor_qmp_dispatch /mnt/sdb/qemu/monitor/qmp.c:145
>     #9 0x5573c71dad4f in monitor_qmp_bh_dispatcher /mnt/sdb/qemu/monitor/qmp.c:234
> 
> Reported-by: Euler Robot <euler.robot@huawei.com>
> Signed-off-by: Pan Nengyuan <pannengyuan@huawei.com>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
> - v2: remove unnecessary set vmsentry to null(there is no non-null check).
> ---
>  target/i386/cpu.h | 1 +
>  target/i386/kvm.c | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index e818fc712a..afbd11b7a3 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1631,6 +1631,7 @@ struct X86CPU {
>  
>      CPUNegativeOffsetState neg;
>      CPUX86State env;
> +    VMChangeStateEntry *vmsentry;
>  
>      uint64_t ucode_rev;
>  
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 4901c6dd74..0a4eca5a85 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1770,7 +1770,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>  
> -    qemu_add_vm_change_state_handler(cpu_update_state, env);
> +    cpu->vmsentry = qemu_add_vm_change_state_handler(cpu_update_state, env);
>  
>      c = cpuid_find_entry(&cpuid_data.cpuid, 1, 0);
>      if (c) {
> @@ -1883,6 +1883,8 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
>          env->nested_state = NULL;
>      }
>  
> +    qemu_del_vm_change_state_handler(cpu->vmsentry);
> +
>      return 0;
>  }
>  
> 

Queued, thanks.

Paolo

