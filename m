Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D634F37531C
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 13:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhEFLgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 07:36:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234842AbhEFLgH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 07:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620300908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IcruxJx/IBHZiLRdPQHrzdMkqW/EMFC2L1rirQLSBsk=;
        b=Ut4uEZAEqcbTThhpyPGGcPrfnOq86r8qEjH9C1A6+OD/M5lGzhsrD2IZh2qF4OZBZuQfyG
        A6JzBHTglGjdeTnk1A9Zvqbc80LNbQLAg1MY5KoKcP5/ojMsufmD9lMCyTk6hnHG8jwUDg
        dlBSVAQxgmCEs96aMQuZbLEFma1o0/A=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-lOt6Y5dNPfiyMiz26Y4Hvw-1; Thu, 06 May 2021 07:35:04 -0400
X-MC-Unique: lOt6Y5dNPfiyMiz26Y4Hvw-1
Received: by mail-ej1-f72.google.com with SMTP id f8-20020a1709068248b02903a8adf1f5c2so498351ejx.19
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 04:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IcruxJx/IBHZiLRdPQHrzdMkqW/EMFC2L1rirQLSBsk=;
        b=RCG/rXxQSeA/11wyMLR8xmaSrCFC82WNaBB14VBKuElbX4KpbfkcaQ7rlKVJXA2X2/
         nGkz18vmjxmhvxSwmuv/AUl7koGO9sUwwIobQqWeORxlj6WdOgF+CCUT/IM34yPIXMis
         72mMwB9cK6OvD4jMRMaY9HCctn3/XrmGS25w0hbYA4uVa567+7x9OGVrJtBYavsxiPxE
         WfyInyJhN3H5S/iXY/t5MJkLYPlOVj6l+qrP+V6BArIKEkfjBXAVXswbFJIucJE/I9Gu
         rnkzaqZX1jObVz3HHOzPqYejJ74SlKXbwjUCZVldt2/jjZ3siam8SDBqhPyYmZY72iNz
         rR+g==
X-Gm-Message-State: AOAM531kzOJOWTF5zS0Uxih1mK7tNRspcOc4X2Lm5QqeKPODEh31ss0N
        4y+2JieCRp3qjDxS2feMQy4akoGl3MosEILf8JIKU9n+YsYi3eqIVGGrULaKprpaHDU3rxqWMQ4
        0SFzAxARkbLjW
X-Received: by 2002:a17:906:dffb:: with SMTP id lc27mr2495218ejc.469.1620300903653;
        Thu, 06 May 2021 04:35:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7T6NEYxSs2IVjtnQnWAs8zbhJN+Tmbs/3knWOOHRukp3KsTdby0Kkpz24YEjFioxJPIqIBg==
X-Received: by 2002:a17:906:dffb:: with SMTP id lc27mr2495192ejc.469.1620300903297;
        Thu, 06 May 2021 04:35:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i6sm1447225eds.83.2021.05.06.04.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 04:35:02 -0700 (PDT)
Subject: Re: KVM: x86: Cancel pvclock_gtod_work on module removal
To:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <87czu4onry.ffs@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2a18634f-b100-334e-f7b5-01c84302e27e@redhat.com>
Date:   Thu, 6 May 2021 13:35:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87czu4onry.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 23:48, Thomas Gleixner wrote:
> Nothing prevents the following:
> 
>    pvclock_gtod_notify()
>      queue_work(system_long_wq, &pvclock_gtod_work);
>    ...
>    remove_module(kvm);
>    ...
>    work_queue_run()
>      pvclock_gtod_work()	<- UAF
> 
> Ditto for any other operation on that workqueue list head which touches
> pvclock_gtod_work after module removal.
> 
> Cancel the work in kvm_arch_exit() to prevent that.
> 
> Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> Found by inspection because of:
>    https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
> See also:
>    https://lkml.kernel.org/r/20210505105940.190490250@infradead.org
> 
> TL;DR: Scheduling work with tk_core.seq write held is a bad idea.
> ---
>   arch/x86/kvm/x86.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8168,6 +8168,7 @@ void kvm_arch_exit(void)
>   	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
>   #ifdef CONFIG_X86_64
>   	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
> +	cancel_work_sync(&pvclock_gtod_work);
>   #endif
>   	kvm_x86_ops.hardware_enable = NULL;
>   	kvm_mmu_module_exit();
> 

Queued, thanks (with added Cc to stable).

Paolo

