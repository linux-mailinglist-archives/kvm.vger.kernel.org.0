Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE4C3D2B89
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhGVRNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:13:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230214AbhGVRNj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NBK5ZbfLr2xOMEjTMg8AY+rGI1FLEY7KEe1dQPGLHug=;
        b=i51OtlkwtHqidUK3fA9f1yOVaLZVEWyzLHf0AnsR/GsjYeH85GIeZYXkbuLyql6ctz8Pz8
        vKdgMHq0RwZVQUUrx4Q59gIOsM5zDYISfw5VFo2Qw6WscFS1Pbhyvcy17sLKYdWp8B/6pg
        kygu7R2BXBzBiCiEpmq9ZCC/h886NP0=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-PoJ-F_EwMwOvnxtS-Rs9jg-1; Thu, 22 Jul 2021 13:54:12 -0400
X-MC-Unique: PoJ-F_EwMwOvnxtS-Rs9jg-1
Received: by mail-oi1-f197.google.com with SMTP id f205-20020acacfd60000b02901f424a672b7so4449175oig.18
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NBK5ZbfLr2xOMEjTMg8AY+rGI1FLEY7KEe1dQPGLHug=;
        b=hDBsjmdOcA7r9dY9+Y8tKE+lbWdQEAlD/aN53S7Wf/+1FIpfb27RL8KJ+bW6VlXZvr
         LzUCJMdgWQIKAy3ctQGSG/tAevxfXU3B7W6ZTLWl4pmIWjFHfHb3mjs8pQWWmzUkzdZB
         4exeAVR6aOkPxxO1VBx3GV6pyvcaFIJOK9IO7W8XyXZC3j52Np4HztzCJYkzWCkGBpj6
         1TzjUNKA9aCYo1OLiFlAUx5ErQ5bvTosCg1x+Xm2fQFYn92WqDMWgT66DBMShem1RMsX
         834XUvMNC3uvZG0RN1F7kc9wY6dsLXIqVMpR3XU4xyhYt3tiHEwk7paYujYJk7NjWmBg
         6DYw==
X-Gm-Message-State: AOAM5301gW86VPzJfQArzLyhMZlAKqA4X81aPXC7lA5Cm2+uFJ3NgPhR
        h9uddj/xebAw+B9ZazIc1kwJ8yyYgE4duGqBEs8r1An6ggN+h0s1AmmiDWyvvK5ovHWcIna6zu1
        xPqb3Q9wRUz1xC8zT5I7k6pF0EXNN4BVn1cftQOYvjQrRxeCNDrRKc2LfSn/lAQ==
X-Received: by 2002:aca:7589:: with SMTP id q131mr6290252oic.76.1626976451811;
        Thu, 22 Jul 2021 10:54:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWs4lbf5DnGa7JMnK2l64tfYQl0ksZqISWX93BlHjCEaqgHFm5i1Srl4kN8yR6jo7Dk0/VNg==
X-Received: by 2002:aca:7589:: with SMTP id q131mr6290236oic.76.1626976451658;
        Thu, 22 Jul 2021 10:54:11 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id g1sm5270450otk.21.2021.07.22.10.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:54:11 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 34/44] target/i386/tdx: set reboot action to
 shutdown when tdx
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <d1afced8a92c01367d0aed7c6f82659c9bf79956.1625704981.git.isaku.yamahata@intel.com>
Message-ID: <0ccf5a5c-2322-eae3-bd4b-9e72e2f4bbd1@redhat.com>
Date:   Thu, 22 Jul 2021 12:54:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d1afced8a92c01367d0aed7c6f82659c9bf79956.1625704981.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:55 PM, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> In TDX CPU state is also protected, thus vcpu state can't be reset by VMM.
> It assumes -action reboot=shutdown instead of silently ignoring vcpu reset.
> 
> TDX module spec version 344425-002US doesn't support vcpu reset by VMM.  VM
> needs to be destroyed and created again to emulate REBOOT_ACTION_RESET.
> For simplicity, put its responsibility to management system like libvirt
> because it's difficult for the current qemu implementation to destroy and
> re-create KVM VM resources with keeping other resources.
> 
> If management system wants reboot behavior for its users, it needs to
>   - set reboot_action to REBOOT_ACTION_SHUTDOWN,
>   - set shutdown_action to SHUTDOWN_ACTION_PAUSE optionally and,
>   - subscribe VM state change and on reboot, (destroy qemu if
>     SHUTDOWN_ACTION_PAUSE and) start new qemu.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   target/i386/kvm/tdx.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 1316d95209..0621317b0a 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -25,6 +25,7 @@
>   #include "qapi/qapi-types-misc-target.h"
>   #include "standard-headers/asm-x86/kvm_para.h"
>   #include "sysemu/sysemu.h"
> +#include "sysemu/runstate-action.h"
>   #include "sysemu/kvm.h"
>   #include "sysemu/kvm_int.h"
>   #include "sysemu/tdx.h"
> @@ -363,6 +364,19 @@ static void tdx_guest_init(Object *obj)
>   
>       qemu_mutex_init(&tdx->lock);
>   
> +    /*
> +     * TDX module spec version 344425-002US doesn't support reset of vcpu by
> +     * VMM.  VM needs to be destroyed and created again to emulate
> +     * REBOOT_ACTION_RESET.  For simplicity, put its responsibility to
> +     * management system like libvirt.
> +     *
> +     * Management system should
> +     *  - set reboot_action to REBOOT_ACTION_SHUTDOWN
> +     *  - set shutdown_action to SHUTDOWN_ACTION_PAUSE
> +     *  - subscribe VM state and on reboot, destroy qemu and start new qemu
> +     */
> +    reboot_action = REBOOT_ACTION_SHUTDOWN;
> +
>       tdx->debug = false;
>       object_property_add_bool(obj, "debug", tdx_guest_get_debug,
>                                tdx_guest_set_debug);
> 

I think the same effect could be accomplished with modifying
kvm_arch_cpu_check_are_resettable.

