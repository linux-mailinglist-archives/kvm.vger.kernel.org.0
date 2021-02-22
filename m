Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E438B321B6B
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 16:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhBVP2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 10:28:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhBVP07 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 10:26:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614007532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tflmRNKq1Lj+d2pXfKiLiMojvzDHMb3JaLn1wBwNDos=;
        b=ILljJOHB66N/p6tMlZ8ZQR9l3paIo54X9CqshwStGzMevT6D+tAQhd00CnpXcwNDNQltUU
        h29syOLaQDh8JKnVu/qSnnCjhFCO4rJcvKJD515NIW1qeABaHkWXcjhGun6VgFWgf2Rtda
        c2jT3tluOMgl2XPsXHFUyai6fr80q+s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-FXwer6i9PEenPSJXmOStHQ-1; Mon, 22 Feb 2021 10:25:29 -0500
X-MC-Unique: FXwer6i9PEenPSJXmOStHQ-1
Received: by mail-ej1-f71.google.com with SMTP id hx26so4129915ejc.3
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 07:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tflmRNKq1Lj+d2pXfKiLiMojvzDHMb3JaLn1wBwNDos=;
        b=Ii1W+0SzUBGA+va+idB+Yiu3PpnJ1JmK5mhKa7vyn/TL39JEbpNZCCs9bg5NV7IUTA
         CRFyr0OY2AsIdQMu79NpFYOOHm7tvv+MzEVJD+xvYP27e4DmCbedwUpzTSZT823kUDQe
         HDuA6SW1U+J58kdpF0SPm4x2I2ekWpINnAKynaDHYUmwdB8lzu/xjTGGo5bPm8ZXY7ST
         4MRB0o8IeUmS8C2cyWLvDK+lIHL5BZWyz7/ZAtXjGSg5JYs91mTbr87ylj+HJaGh06YL
         ymjl475iYfjJ4Lsf06nMzupC/wdE1rV0JKrGK/EKcpIWRjwBbXHJe0rodn+Kgorm/LNG
         b8Ow==
X-Gm-Message-State: AOAM531C61vNoyj7WxjxzaDEVlqJ6LE9BRtkV19AB92Zx6ximrgO58Zs
        ovcfB/sGLphfDm2eTX7sp8Izgn3XXt/3xffj59UmXGSXn2FzB83/xdBWMNT+rudHouqLCI2OhpY
        ahmyntbw5IrUQfXlT/ewEM5cGEbpD+vZZYWHMOk4rOSyUT2NiU14wzuyA1D4wtX+J
X-Received: by 2002:a50:fc0e:: with SMTP id i14mr9752606edr.91.1614007528029;
        Mon, 22 Feb 2021 07:25:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrxy658Ivld/kxrkrpRzq0DflFQFYuLCNqh41ax1E2OjWXwabEqAAgWGgOq20SW9jpZ9JqYA==
X-Received: by 2002:a50:fc0e:: with SMTP id i14mr9752586edr.91.1614007527815;
        Mon, 22 Feb 2021 07:25:27 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n5sm12355408edw.7.2021.02.22.07.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 07:25:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     jroedel@suse.de, seanjc@google.com, mlevitsk@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: prepare guest save area while is_guest_mode
 is true
In-Reply-To: <20210218162831.1407616-1-pbonzini@redhat.com>
References: <20210218162831.1407616-1-pbonzini@redhat.com>
Date:   Mon, 22 Feb 2021 16:25:26 +0100
Message-ID: <87blcc3z15.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Right now, enter_svm_guest_mode is calling nested_prepare_vmcb_save and
> nested_prepare_vmcb_control.  This results in is_guest_mode being false
> until the end of nested_prepare_vmcb_control.
>
> This is a problem because nested_prepare_vmcb_save can in turn cause
> changes to the intercepts and these have to be applied to the "host VMCB"
> (stored in svm->nested.hsave) and then merged with the VMCB12 intercepts
> into svm->vmcb.
>
> In particular, without this change we forget to set the CR0 read and CR0
> write intercepts when running a real mode L2 guest with NPT disabled.
> The guest is therefore able to see the CR0.PG bit that KVM sets to
> enable "paged real mode".  This patch fixes the svm.flat mode_switch
> test case with npt=0.  There are no other problematic calls in
> nested_prepare_vmcb_save.
>
> The bug is present since commit 06fc7772690d ("KVM: SVM: Activate nested
> state only when guest state is complete", 2010-04-25).  Unfortunately,
> it is not clear from the commit message what issue exactly led to the
> change back then.  It was probably related to svm_set_cr0 however because
> the patch series cover letter[1] mentioned lazy FPU switching.
>
> [1] https://lore.kernel.org/kvm/1266493115-28386-1-git-send-email-joerg.roedel@amd.com/
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 92d3aaaac612..35891d9a1099 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -469,8 +469,8 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb12_gpa,
>  
>  	svm->nested.vmcb12_gpa = vmcb12_gpa;
>  	load_nested_vmcb_control(svm, &vmcb12->control);
> -	nested_prepare_vmcb_save(svm, vmcb12);
>  	nested_prepare_vmcb_control(svm);
> +	nested_prepare_vmcb_save(svm, vmcb12);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
>  				  nested_npt_enabled(svm));

For the record,

this seems to fix the bug when Gen2 guests were not booting on Hyper-V
on KVM (SVM). They boot now, thanks!

Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

