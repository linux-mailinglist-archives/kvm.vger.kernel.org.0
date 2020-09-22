Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84667274576
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 17:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgIVPi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 11:38:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgIVPiV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 11:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600789100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WuaYKSij4WH1NXByncA5AVSp9syAJ776Fggbd8itbrg=;
        b=X56zTAExOcHUwI7YeaU2WkBkRpAXXakwLoZ7ulzx8cVQ2BRvbQKMSVR2K5sH9nJynncsd9
        hkJJJIOYsjRy9E4dYSfhsDC8QT2xa0hkxQNk1b4KbQdOABsiN2/arIfJNzrS+wVswwJ0IG
        kQvlfoetK4Fl/tpBnfsCUMdpk7rZA7s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-vLzXb8hkMpGBUZ1jGmJGxA-1; Tue, 22 Sep 2020 11:38:15 -0400
X-MC-Unique: vLzXb8hkMpGBUZ1jGmJGxA-1
Received: by mail-wm1-f72.google.com with SMTP id 23so694398wmk.8
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 08:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WuaYKSij4WH1NXByncA5AVSp9syAJ776Fggbd8itbrg=;
        b=n00I8pkLnZXcezrcnbk9+tocApA8SfgzIsPXOxh8pRSKbQfl31UF2sfQ4QUcGw3ePE
         NHZ1+zbCtLXgmp+LQuArxwGOOWfW59RNJ5WgoJnJKwWPlKi7XIXXa8yz2qkEa3kXSqpO
         br0EoaQbQUZxmEJGwezRMEVcsG5NL9595CBF9fzGjKsG59Zfwp3HEVPav7wR1EP7WYeR
         tLSVt6bCuPGfP2aIEVG2ZJOdrPl1jEu8zQeo/N4OPGGcSl+btMWkU3Vd47tBGgg5jwsQ
         HLJN8mQSs9RM5zxpWYCATaG4PNTowv+1Iaf1Zteo7qYbU9TB2Cdial9HSqHgEpDslnUj
         Yqkw==
X-Gm-Message-State: AOAM531+kTCVdC/907ri/QMAjiH0tQkJUAHlvQ/4jNKN1IjetYkYez6y
        vyDMF40IN+K1OpqODwnjrffEOGLJ04mC5EN6SQsc4blwkis9E0O+WSEv/levhI/jS51vaQiQIUQ
        lMSFHQ3Gdouez
X-Received: by 2002:a1c:e484:: with SMTP id b126mr1623673wmh.44.1600789094321;
        Tue, 22 Sep 2020 08:38:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynXdfXyBnd242un5XVis7GmOEU7D12gowjspwcx7XthRwbz+t15wEohJR5o+CX20vzIO9+HQ==
X-Received: by 2002:a1c:e484:: with SMTP id b126mr1623655wmh.44.1600789094116;
        Tue, 22 Sep 2020 08:38:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z15sm27228395wrv.94.2020.09.22.08.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 08:38:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        1896263@bugs.launchpad.net, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] i386: Don't try to set MSR_KVM_ASYNC_PF_EN if kernel-irqchip=off
In-Reply-To: <20200922151455.1763896-1-ehabkost@redhat.com>
References: <20200922151455.1763896-1-ehabkost@redhat.com>
Date:   Tue, 22 Sep 2020 17:38:12 +0200
Message-ID: <87v9g5es9n.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> This addresses the following crash when running Linux v5.8
> with kernel-irqchip=off:
>
>   qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0
>   qemu-system-x86_64: ../target/i386/kvm.c:2714: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
>
> There is a kernel-side fix for the issue too (kernel commit
> d831de177217 "KVM: x86: always allow writing '0' to
> MSR_KVM_ASYNC_PF_EN"), but it's nice to simply not trigger
> the bug if running an older kernel.
>
> Fixes: https://bugs.launchpad.net/bugs/1896263
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  target/i386/kvm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 9efb07e7c83..1492f41349f 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -2818,7 +2818,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>          kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
>          kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
>          kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
> -        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
> +        /*
> +         * Some kernel versions (v5.8) won't let MSR_KVM_ASYNC_PF_EN to be set
> +         * at all if kernel-irqchip=off, so don't try to set it in that case.
> +         */
> +        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF) &&
> +            kvm_irqchip_in_kernel()) {
>              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
>          }
>          if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {

I'm not sure kvm_irqchip_in_kernel() was required before we switched to
interrupt-based APF (as we were always injecting #PF) but with
kernel-5.8+ this should work. We'll need to merge this with

https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg02963.html
(queued by Paolo) and
https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg06196.html
which fixes a bug in it.

as kvm_irqchip_in_kernel() should go around both KVM_FEATURE_ASYNC_PF
and KVM_FEATURE_ASYNC_PF_INT I believe.

-- 
Vitaly

